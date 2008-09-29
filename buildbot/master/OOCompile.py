##
# ootermite - OpenOffice.org automated building/reporting system
# Copyright (C) ?
# Copyright (C) 2008 by Sun Microsystems, Inc.
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

import os
from buildbot.steps.shell import ShellCommand
from buildbot.slave.registry import registerSlaveCommand
from buildbot.process.buildstep import LoggedRemoteCommand
from buildbot.steps.transfer import FileUpload
from OOShell import OOShellCommand

class OOCompile(OOShellCommand):
    def createSummary(self, log):
        try:
            logFileName = self.step_status.logs[0].getFilename()

            command = "./create_logs.pl " + logFileName

            result = os.popen(command).read()

            summary_log_file_name = logFileName + "_brief.html"
            summary_log_file = open(summary_log_file_name)

            self.addHTMLLog('summary log', summary_log_file.read())

            command = "grep warning: "+ logFileName
            warnings = os.popen(command).read()

            command = "grep error: "+ logFileName
            errors = os.popen(command).read()

            command = "tail -50 "+logFileName
            tail = os.popen(command).read()

            if warnings != "" :
                self.addCompleteLog('warnings',warnings)

            if errors != "":
                self.addCompleteLog('errors',errors)

            if tail != "":
                self.addCompleteLog('tail',tail)

        except:
            print "cannot execute createSummary after OOCompile"
    
        def __init__(self, **kwargs):
            OOShellCommand.__init__(self, **kwargs)   # always upcall!

        def remote_updates(self, updates):
            OOShellCommand.remote_updates(self, updates)

            # Here is probably a good point to reload the platform specific
            # HTML-logfile that was created using build --html

            # Problem: how can we retrieve this log file from the slave?
            # Solution: There is a FileUpload step that can transmit a file from
            # the slave to the master. But that's real BuildStep. Is it possible to
            # misuse this class here?
            # Problem: how do we determine the name of the HTML log file on the slave?
            # Problem: how do we determine an available name for log file in the public_html dir?
            fileUpload = FileUpload(slavesrc="docs/reference.html", masterdest="~/public_html/ref.html")
            
            # Problem: how to we store this content on the Master?
            # Solution: we store the file in the master's public_html dir with an unique
            # file name and add a link to the waterfall page.

