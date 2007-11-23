from buildbot.steps.shell import ShellCommand
from buildbot.process.buildstep import BuildStep
from buildbot.status.builder import SUCCESS, WARNINGS, FAILURE, SKIPPED
from buildbot.status.builder import BuildStepStatus
import sys
class OOShellCommand(ShellCommand):
  def __init__(self, **kwargs):
    ShellCommand.__init__(self, **kwargs)   # always upcall!

  def evaluateCommand(self, cmd):
    if cmd.rc == 65:        
      # the reason is given in the build status page and in the build status mails.
      # We only want to stop the build if it is skipped in 
      # the CWS, Prep, Configure, Bootstrap or Compile stages.
      # In the Smoketest, Bundle and Install set stages, we want the build to go on

      if self.describe(False) == ['CWS']:
        self.build.buildFinished(['slave rejected CWS', 'CWS problem'], 'grey', SKIPPED)
      elif self.describe(False) == ['Prep']:
        self.build.buildFinished(['slave rejected prep', 'prep problem'], 'grey', SKIPPED)
      elif self.describe(False) == ['Configure']:
        self.build.buildFinished(['slave rejected configure', 'configure problem'], 'grey', SKIPPED)
      elif self.describe(False) == ['Bootstrap']:
        self.build.buildFinished(['slave rejected bootstrap', 'bootstrap problem'], 'grey', SKIPPED)
      elif self.describe(False) == ['Everything']:
        self.build.buildFinished(['slave rejected source', 'Source problem'], 'grey', SKIPPED)
      else:
        BuildStep.finished(self, SKIPPED)
        self.step_status.setColor(self, "grey")
      return SKIPPED
    if cmd.rc != 0:
      return FAILURE
    # if cmd.log.getStderr(): return WARNINGS
    return SUCCESS

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

