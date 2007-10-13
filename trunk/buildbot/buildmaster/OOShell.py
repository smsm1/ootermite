from buildbot.steps.shell import ShellCommand
from buildbot.status.builder import SUCCESS, WARNINGS, FAILURE, SKIPPED
class OOShellCommand(ShellCommand):
  def __init__(self, **kwargs):
    ShellCommand.__init__(self, **kwargs)   # always upcall!

  def evaluateCommand(self, cmd):
    if cmd.rc == 65:        
      # the reason is given in the build status page and in the build status mails.
      # We only want to stop the build if it is skipped in 
      # the CWS, Prep, Configure, Bootstrap or Compile stages.
      # In the Smoketest, Bundle and Install set stages, we want the build to go on
      if self.describe(True) == "CWS":
        self.build.buildFinished(['slave rejected CWS', 'The bot has decided to skip the build at CWS fetching stage'], 'grey',
                               SKIPPED)
      elif self.describe(True) == "Prep":
        self.build.buildFinished(['slave rejected prep', 'The bot has decided to skip the build at prep'], 'grey', SKIPPED)
      elif self.describe(True) == "Configure":
        self.build.buildFinished(['slave rejected configure', 'The bot has decided to skip the build at configure'], 'grey', SKIPPED)
      elif self.describe(True) == "Bootstrap":
        self.build.buildFinished(['slave rejected bootstrap', 'The bot has decided to skip the build at bootstrap'], 'grey', SKIPPED)
      #anything else should just continue with the build
      else:
        BuildStep.finished(self, SKIPPED)
      
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

