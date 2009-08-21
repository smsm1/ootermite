##
# ootermite - OpenOffice.org automated building/reporting system
# Copyright (C) ootermite project
# 
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
##

from email.Message import Message
from email.Utils import formatdate
from email.MIMEBase import MIMEBase
from email.MIMEMultipart import MIMEMultipart
from email.MIMEText import MIMEText
from email import Encoders
from twisted.internet import defer
from buildbot import interfaces
from buildbot.status import base, mail, tinderbox
from buildbot.status.builder import SUCCESS, WARNINGS, SKIPPED

# for tests
from buildbot.status import builder, base

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
            # map results to tinderbox stati
            if results == "building":
                  res = "building"
            elif results == SUCCESS:
                  res = "success"
            elif results == WARNINGS:
                  res = "test_failed"
            elif results == SKIPPED:
                  res = "fold"
            else:
                  if re.match(r'slave lost', "\n".join(build.getText())):
                        res = "fold"
                  else:
                        res = "build_failed"

            # tinderbox administrativa
            text  = "tinderbox: administrator: %s\n" % self.fromaddr # FIXME to use bot-admin
            text += "tinderbox: buildname:     %s\n" % name
            text += "tinderbox: tree:          %s\n" % build.getProperty("branch")
            text += "tinderbox: errorparser: unix\n" # only unix-errorparser is used by OOo-Tinderbox
            # getTimes() returns a fractioned time that tinderbox doesn't understand
            text += "tinderbox: starttime:     %s\n" % int(build.getTimes()[0])
            text += "tinderbox: timenow:       %s\n" % int(time.time())
            text += "tinderbox: status:        %s\n" % res
            text += "tinderbox: END\n\n"

            # backlink to termite
            text += "TinderboxPrint: <a href=\"http://termite.go-oo.org/buildbot/builders/%s/builds/%s\">termite</a>\n" % (build.getProperty("buildername"), build.getProperty("buildnumber"))

            # if build is building, then we send a plaintext message 
            # only containing the administrative part & backlink
            # however, if the build is finished, we send everything
            # as a gzipp'd MIME attachment
            if results == "building":
                  m = Message()
                  m.add_header('X-tinder', 'cookie')
                  m.set_payload(text)
            else:
                  # add link to installset if built
                  try:
                        if (build.getProperty("install_set")) and (results == SUCCESS):
                                text += "TinderboxPrint: <a href=\"http://termite.go-oo.org/install_sets/%s-%s-install_set.zip\">Install Set</a>\n" % (build.getProperty("buildername"), build.getProperty("buildnumber"))
                  # Do it slightly differently if we don't have an install_set
                  except KeyError:
                        if (results == SUCCESS):
                                text += "TinderboxPrint: No install set was produced\n"
                  
                  # logs will always be appended
                  for log in build.getLogs():
                        logName= log.getName()
                        # tinderbox does the error-parsing/extraction itself, don't duplicate it
                        if (logName != "summary log" and logName != "tail" and logName != "warnings" and logName != "errors"):
                              text += "*********************************************** %s ***********************************************\n" % logName
                              text += log.getText()

                  fakefile= StringIO.StringIO()
                  fakegzip= gzip.GzipFile("bogusfilename.gz", "wb", 9, fakefile)
                  fakegzip.write(text)
                  fakegzip.close()                                                 
                  compressedText= fakefile.getvalue()

                  # the message
                  m = MIMEMultipart()
                  m.add_header('X-Tinder', 'gzookie')
                  msg = MIMEBase('application', 'octet-stream')
                  msg.set_payload(compressedText)
                  Encoders.encode_base64(msg)
                  msg.add_header('Content-Disposition', 'attachment', filename="bogusfilename.gz")

                  # gzipped log is expected to be the second part of a multipart message, add dummy
                  dummy= MIMEText("dummytext")
                  dummy.add_header('Content-Disposition', 'inline')
                  m.attach(dummy)
                  m.attach(msg)
               

            m['Date'] = formatdate(localtime=True)
            m['Subject'] = self.subject % { 'result': res,
                                            'builder': name,
                                            'branch': build.getProperty("branch"),
                                            }
            m['From'] = self.fromaddr # need to use the property of the e-mail of the builder
            
            # m['To'] is added later

            d = defer.DeferredList([])
            d.addCallback(self._gotRecipients, self.extraRecipients, m)
            return d

# vim: set expandtab sw=6 ts=6: no clue why 6, other files indent by 4... FIXME probably :-)
