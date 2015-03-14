This space is to be used for outline/collaboration.  What follows is the outline.

## Outline ##
  1. Speaker Introduction Fluff
  1. Introduction Fluff
  1. Historical Overview
    1. tinderbox (sucky)
    1. old buildbot (sucky)
  1. This New Thing (Termite)
    1. buildbot + tinderbox + "reporter"
    1. new capabilities
      1. EIS/tinderbox integration
      1. report generation
      1. "try"
    1. enhancements
      1. autobuild
      1. readyforqa
  1. Features In Depth
    1. EIS/tinderbox integration
      1. buildmaster sends results to tinderbox
      1. EIS knows tinderbox status
      1. Reports/Install sets are linked
    1. report generation
      1. arbitrary data can be gathered
      1. reports can be generated
        1. cws vs milestone
        1. milestones over time
    1. try
      1. one can "try" a patch before committing to a cws
    1. general enhancements
      1. builds triggered by changes
      1. ready for qa builds get special treatment
      1. client side config
      1. faster update mechanism sucks less
  1. How it All works
    1. Buildbot
      1. buildmaster/buildslave topology
      1. buildbot functional description
      1. caveats
      1. customization done for oo.o
    1. Report Generator
      1. functional description
      1. implementation description
  1. It's just that Easy
    1. how to set up a builder
    1. how to send data/create reports
    1. how to get started with development
  1. Next Steps
    1. what we didn't get done