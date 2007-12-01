from email.Message import Message
from email.Utils import formatdate
from email.MIMEBase import MIMEBase
from email.MIMEMultipart import MIMEMultipart
from email.MIMEText import MIMEText
from email import Encoders
from twisted.internet import defer
from buildbot import interfaces
from buildbot.twcompat import implements
from buildbot.status import base, mail, tinderbox
from buildbot.status.builder import SUCCESS, WARNINGS, SKIPPED
import zlib, bz2, base64, time, StringIO, gzip, re

class OOTinderboxMailNotifier(tinderbox.TinderboxMailNotifier):
      def __init__(self, fromaddr, extraRecipients,
                 categories=None, builders=None, relayhost="localhost",
                 subject="buildbot %(result)s in %(builder)s for the CWS %(branch)s", binaryURL="",
                 logCompression=""):
            tree= "garbage"
            tinderbox.TinderboxMailNotifier.__init__(self, fromaddr, tree, extraRecipients,
                                                     categories, builders, relayhost,
                                                     subject, binaryURL,
                                                     logCompression)

      def buildMessage(self, name, build, results):
            text = ""
            res = ""
            # shortform
            t = "tinderbox:"

            text += "%s tree: %s\n" % (t, build.getProperty("branch"))

            # builddate is deprecated
            # the start time
            # getTimes() returns a fractioned time that tinderbox doesn't understand
            # text += "%s builddate: %s\n" % (t, int(build.getTimes()[0]))
            text += "%s starttime: %s\n" % (t, int(build.getTimes()[0]))
            text += "%s timenow: %s\n" % (t, int(time.time()))
            text += "%s status: " % t

            if results == "building":
                  res = "building"
                  text += res
            elif results == SUCCESS:
                  res = "success"
                  text += res
            elif results == WARNINGS:
                  res = "test_failed"
                  text += res
            elif results == SKIPPED:
                  res = "fold"
                  text += res
            else:
                  if re.match(r'slave lost', "\n".join(build.getText())):
                        res = "fold"
                  else:
                        res = "build_failed"
                  text += res

            text += "\n";

            text += "%s administrator: %s\n" % (t, self.fromaddr)


            text += "%s buildname: %s\n" % (t, name)
            text += "%s errorparser: unix\n" % t # always use the unix errorparser

            # if the build just started...
            if results == "building":
                  text += "%s END\n" % t
            # if the build finished...
            else:
                  try:
                    if (build.getProperty("install_set")) and (results == SUCCESS):
                        text += "TinderboxPrint: <a href=\"http://termite.go-oo.org/install_sets/%s-%s-install_set.zip\">Install Set</a>\n" % (build.getProperty("buildername"), build.getProperty("buildnumber"))
                  # Do it slightly differently if we don't have an install_set
                  except KeyError:
                        if (results == SUCCESS):
                                text += "TinderboxPrint: No install set was produced\n"
                                
                  # logs will always be appended
                  tinderboxLogs = ""
                  for log in build.getLogs():
                        logName= log.getName()
#                   if logName and logName[-1] == '\n':
#                         logName = logName[:-1]
                        if (logName != "summary log" and logName != "tail" and logName != "warnings"):
                              tinderboxLogs += "*********************************************** %s ***********************************************\n" % logName
                              tinderboxLogs += log.getText()

                  text += "%s END\n\n" % t
                  text += tinderboxLogs
                  text += "\n"

                  fakefile= StringIO.StringIO()
                  fakegzip= gzip.GzipFile("bogusfilename.gz", "wb", 9, fakefile)
                  fakegzip.write(text)
                  fakegzip.close()                                                 
                  compressedText= fakefile.getvalue()

            # if build is building,
            # then we only send a regular message
            # however, if it built, we send everything
            # as a gzipp'd MIME attachment

            if results == "building":
                  m = Message()
                  m.add_header('X-tinder', 'cookie')
                  m.set_payload(text)
            else:
                  m = MIMEMultipart()
                  m.add_header('X-Tinder', 'gzookie')
                  msg = MIMEBase('application', 'octet-stream')
                  msg.set_payload(compressedText)
                  Encoders.encode_base64(msg)
                  msg.add_header('Content-Disposition', 'attachment', filename="bogusfilename.gz")

                  #keep tinderbox parser happy
                  msg2= MIMEText(text) #can use only 1 arg?
                  msg2.add_header('Content-Disposition', 'inline')
                  m.attach(msg2)
                  m.attach(msg)
               

            m['Date'] = formatdate(localtime=True)
            m['Subject'] = self.subject % { 'result': res,
                                            'builder': name,
                                            'branch': build.getProperty("branch"),
                                            }
            m['From'] = slave.getAdmin() #self.fromaddr # need to use the property of the e-mail of the builder
            
            # m['To'] is added later

            d = defer.DeferredList([])
            d.addCallback(self._gotRecipients, self.extraRecipients, m)
            return d

