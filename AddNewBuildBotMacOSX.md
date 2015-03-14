There is a number of things that you need to do to add a new build slave.

The following are the installation instructions that I used to get the bot working on Mac OS X:
  * a working build environment for OpenOffice.org. Please make sure that you have already managed to built OpenOffice.org on the machine that you want to put the bot on.
  * python 2.3.5 comes with Mac OS X 10.4 (Use **python -V** to get the python version number)
```
python -V
```
  * Download Zope 2.8.1-final.tgz (the last version to support Python 2.3.5)
```
./configure
make
sudo make install
```
  * Download twisted 2.5.0
```
python setup.py build
# You can ignore the errors that are shown.
```
  * Grab a copy of buildbot 0.7.9 [source](https://sourceforge.net/project/showfiles.php?group_id=73177)
  1. unpack the source
  1. build the buildbot [the buildbot manual](http://buildbot.net/repos/release/docs/buildbot.html#Installing-the-code)
```
python setup.py build
sudo python setup.py install
```
  1. perl (and the following modules: LWP::Simple, File::Copy::Recursive, Config::Auto
```
sudo perl -MCPAN -e shell
install LWP::Simple
install File::Copy::Recursive
install Config::Auto
exit
```
  * bash
  * subversion (for the buildbot scripts and OpenOffice.org source)

You should now have all the prerequisites installed, so you can now create the slave:

  1. create the build-slave
```
buildbot create-slave BASEDIR termite.go-oo.org:9999 SLAVENAME PASSWORD
```
  1. Grab the scripts from svn directly in to the BASEDIR
```
svn checkout http://ootermite.googlecode.com/svn/trunk/buildbot/buildslave/scripts/ BASEDIR
```
  1. Edit the info/admin and info/host files to contain information about yourself/host
  1. Customise the scripts for your platform
  1. Create a build\_copy dir (used by buildprep) with things you wish to be copied into the source tree after checkout and before configure (such as moz)
  1. Email Christian Lins <christian.lins@sun.com> (or mikeleib and shaunmcdonald131) the name and password to add your bot to the master
  1. Start your bot
```
buildbot start BASEDIR
```
  1. It should show up as online at http://termite.go-oo.org/ and you should be able to manually submit builds to it.