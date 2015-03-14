# Introduction #
The server setup is a little complicated, in that there are several components that one must set up to function properly.

# Buildbot #
In our setup, we run the buildbot process under the buildmaster user.  This user has a copy of the buildbot in their home directory.  The buildbot configuration is designed to be pulled from svn with an svn up and not meant to be edited on the buildmaster.

## Setup ##
The process for recreating the buildbot setup is more or less as follows:
  1. Patch and install buildbot (see buildbot docs and patch). The ootermite patch can be found in buildbot/buildmaster/OO-changes.diff
  1. Create the buildmaster
```
buildbot create-master buildmaster
```
  1. Checkout the buildmaster parts from svn. Please note that _trunk_ is work in progress! For a recent version use a branch (e.g. /branches/0.1\_buildbot0.7.5/) instead.
```
svn co http://ootermite.googlecode.com/svn/trunk/buildbot/buildmaster/ buildmaster
```
  1. you will need to find/create OOCredentials, which has the slave names and passwords (an OOCredentials.cfg.sample is provided)
  1. make start

## Developing ##
There are two "environments" defined in master.cfg that make development a little easier.  development.cfg and production.cfg have different slaves and builders to reflect the production environment, where you want to do such things as have lots of slaves and email tinderbox results.  The development environment is designed to be done on your workstation, and as such has only one slave defined.  One can have a buildslave and buildmaster running on the same workstation without much bother.

Notes:
  * Tinderbox email needs some adjustment
  * Factories are a mess.  f3 is the factory to use.  Others should be deprecated.

# Apache #
Apache can form the front-end (this is optional).  It uses mod\_proxy to either proxy requests to buildbot, reporter, or to serve the request itself.  This is currently not done and needs to be setup more or less as follows:
  * /buildbot gets routed to buildbot
  * /reporter gets routed to reporter
  * /installsets gets served up by apache