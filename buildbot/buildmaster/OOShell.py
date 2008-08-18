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

from buildbot.steps.shell import ShellCommand
from buildbot.process.buildstep import BuildStep
from buildbot.status.builder import SUCCESS, WARNINGS, FAILURE, SKIPPED
from buildbot.status.builder import BuildStepStatus
import sys

class OOShellCommand(ShellCommand):
  def __init__(self, **kwargs):
    ShellCommand.__init__(self, **kwargs)   # always upcall!

  def evaluateCommand(self, cmd):
    # Skip the failed but non vital steps
    if cmd.rc != 0:
      if self.describe(False) == ['Smoketest']:
        return SKIPPED
      if self.describe(False) == ['Bundle Installset']:
        return SKIPPED

    return ShellCommand.evaluateCommand(self, cmd)

  def getText(self, cmd, results):
    if results == SUCCESS:
      return self.describe(True)
    elif results == WARNINGS:
      return self.describe(True) + ["warnings"]
    elif results == SKIPPED:
      return self.describe(True) + ["skipped"]
    else:
      return self.describe(True) + ["failed"]

  def getColor(self, cmd, results):
    assert results in (SUCCESS, WARNINGS, FAILURE, SKIPPED)
    if results == SUCCESS:
      return "green"
    elif results == WARNINGS:
      return "orange"
    elif results == SKIPPED:
      return "grey"
    else:
      return "red"

