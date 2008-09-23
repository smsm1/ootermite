##
# ootermite - OpenOffice.org automated building/reporting system
# Copyright (C) ?
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

from buildbot.steps import transfer
from buildbot.process.buildstep import BuildStep
from buildbot.status.builder import SUCCESS, FAILURE, SKIPPED

class MyUpload(transfer.FileUpload):
      def __init__(self, slavesrc, masterdest, # build param removed by chris
                   workdir="build", maxsize=None, blocksize=16*1024, mode=None,
                   **buildstep_kwargs):
            transfer.FileUpload.__init__(self, slavesrc, masterdest, workdir, maxsize, blocksize, mode, **buildstep_kwargs) # build param removed by chris
              
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
            transfer.finished(self, result)

