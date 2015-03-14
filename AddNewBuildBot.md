# Introduction #

There is a number of things that you need to do to add a new build slave. Slightly fuller/alternative instructions are available from [AddNewBuildBotMacOSX](AddNewBuildBotMacOSX.md).

You will need the following prerequisites:

  * a working build environment for OpenOffice.org. Please make sure that you have already managed to build OpenOffice.org on the machine that you want to put the bot on. See http://wiki.services.openoffice.org/ for build instructions.
  * python 2.4 or later (Use **python -V** to get the python version number)
  * twisted 2.4 or later (most OSs provide this as package, e.g. python-twisted or SUNWpython-twisted)
  * perl (and the following modules: LWP::Simple, File::Copy::Recursive, Config::Auto which can be installed from CPAN)
```
sudo perl -MCPAN -e shell
install LWP::Simple
install File::Copy::Recursive
install Config::Auto
exit
```
  * bash
  * subversion/mercurial (for the buildbot scripts and DEV300 codeline)

# Details #

  1. Grab a copy of [Buildbot 0.7.9](https://sourceforge.net/project/showfiles.php?group_id=73177) or newer
  1. Unpack the source
  1. Build the buildbot [the buildbot manual](http://djmitche.github.com/buildbot/docs/0.7.9/#Installing-the-code)
  1. Create the build-slave
```
buildbot create-slave BASEDIR termite.services.openoffice.org:9999 SLAVENAME PASSWORD
```
> This will create a Build Slave Basedir and the important buildbot.tac file.
  1. make sure the buildbot.tac file also containes a line `umask = 022`
  1. Grab the scripts from svn directly in to the BASEDIR
```
svn checkout http://ootermite.googlecode.com/svn/trunk/buildbot/slave/ BASEDIR
```
  1. Edit the info/admin and info/host files to contain information about yourself/host
  1. Customise the scripts for your platform if needed.
  1. Contact the project to have your changes integrated into the codeline else automatic updates won't work
  1. Copy the steps.config.sample file to steps.config and customize it.
  1. Customize cws\_fetch.cfg
  1. Create a build\_copy dir (used by buildprep) with things you wish to be copied into the source tree after checkout and before configure (such as mozilla sourcetarballs patches)
  1. EMail Gregor Hartmann (Gregor.Hartmann@sun.com> (or mikeleib or shaunmcdonald) the botname and password and a screen name to add your bot to the master
  1. Start your bot
```
buildbot start BASEDIR (the dir containing the scripts ...)
```
  1. It should show up as online at http://termite.services.openoffice.org/ and you should be able to manually submit builds to it.