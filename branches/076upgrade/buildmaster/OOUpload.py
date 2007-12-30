from buildbot.steps import transfer
from buildbot.process.buildstep import BuildStep
from buildbot.status.builder import SUCCESS, FAILURE, SKIPPED

class MyUpload(transfer.FileUpload):
#      def __init__(self, build, slavesrc, masterdest,
      def __init__(self, slavesrc, masterdest,
                   workdir="build", maxsize=None, blocksize=16*1024, mode=None,
                   **buildstep_kwargs):
            transfer.FileUpload.__init__(self, slavesrc, masterdest, workdir, maxsize, blocksize, mode, **buildstep_kwargs)
              
      def start(self):
            bname = self.getProperty("buildername")
            bnumber = self.getProperty("buildnumber")
            bbranch = self.getProperty("branch")            
            self.masterdest = "/home/buildmaster/buildmaster/install_sets/%s-%s-%s-install_set.zip" % (bname, bnumber, bbranch)
            url = "http://termite.go-oo.org/install_sets/%s-%s-%s-install_set.zip" % (bname, bnumber, bbranch)
            if self.getProperty("install_set"):
                  self.addURL("Install Set", url)
                  return transfer.FileUpload.start(self)
            else:
                  #self.timer = reactor.callLater(1, self.done)
                  self.step_status.setText(['Install Set:', 'Skipped'])
                  self.step_status.setColor("grey")
                  return BuildStep.finished(self, SKIPPED)

      def finish(self, result):
            BuildStep.finished(self, result)
#            transfer.finished(self, result)

