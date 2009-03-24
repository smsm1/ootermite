#*************************************************************************
# 
# Copyright (C) 2009 by Sun Microsystems, Inc.
#
# OpenOffice.org - a multi-platform office productivity suite
#
# This file is part of OpenOffice.org/ootermite.
#
# OpenOffice.org is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License version 3
# only, as published by the Free Software Foundation.
#
# OpenOffice.org is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License version 3 for more details
# (a copy is included in the LICENSE file that accompanied this code).
#
# You should have received a copy of the GNU Lesser General Public License
# version 3 along with OpenOffice.org.  If not, see
# <http://www.openoffice.org/license.html>
# for a copy of the LGPLv3 License.
#
#*************************************************************************

from buildbot.status import base
from buildbot.status.builder import SUCCESS, FAILURE, SKIPPED, WARNINGS
import SOAPpy
import sys

buildboturl = "http://termite.go-oo.org/buildbot/builders"

class EISStatusReceiver(base.StatusReceiverMultiService):

    def __init__(self):
        base.StatusReceiverMultiService.__init__(self)

        self.watched = []

    def builderAdded(self, name, builder):
        self.watched.append(builder)
        return self # subscribe to this builder

    def buildStarted(self, builderName, build):
        print("EISStatusReceiver::buildStarted: %s " % builderName)
        branch = build.getProperty("branch")
         
        page = "%s/%s/builds/%s" % (buildboturl, builderName, build.getProperty("buildnumber"))
        
        submitTestResult(branch, builderName, page, "running")
        return

    def buildFinished(self, builderName, build, results):
        print("EISStatusReceiver::buildFinished: %s" % builderName)
        branch = build.getProperty("branch")
        
        page = "%s/%s/builds/%s" % (buildboturl, builderName, build.getProperty("buildnumber"))
        if results == SUCCESS or results == WARNINGS:
            res = "success"
        elif results == FAILURE:
            res = "failed"
        elif results == SKIPPED:
            res = "incomplete"
        else:
            print("Unknown result!")
            res = "failed"
            
        self.submitTestResult(branch, builderName, page, res)
        return

    def getMasterForCWS(self, soap, cws_name):
        masters = soap.getMastersForCWS(cws_name)
        for master in masters:
            return master

    def submitTestResult(self, branch, builderName, resultPage, statusName):
        try:
            soap  = self.getSOAP();
            mws   = self.getMasterForCWS(soap, branch)
            cwsid = soap.getChildWorkspaceId(mws, branch);
            soap.submitTestResult(cwsid, "Buildbot", builderName, resultPage, statusName)
        except:
            print("Exception occurred in submitTestResult: %s" % sys.exc_info()[0])
        return

    def getSOAP():
        soap = SOAPpy.SOAPProxy("http://tools.services.openoffice.org/soap/servlet/rpcrouter")
        return soap._ns("urn:ChildWorkspaceDataService")
        
        
    def setServiceParent(self, parent):
        base.StatusReceiverMultiService.setServiceParent(self, parent)
        self.setup()
        
    def setup(self):
        self.status = self.parent.getStatus()
        self.status.subscribe(self)
