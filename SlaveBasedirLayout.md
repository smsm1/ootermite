The following files/scripts should reside within the ootermite slave basedir:

  * bootstrap: Runs bootstrap
  * buildprep: Insert whatever you need in here to prepare the tree for building. For example, copying Mozilla, that daft windows.dll or patching.
  * bundle: Zips up the install set.  The name is supplied in $1 by the buildmaster.
  * compile: Actually does the compile
  * configure: Runs configure, you supply configure line
  * cws\_get: For getting CWS's from CVS
  * cws\_get.config: cws\_get config file
  * steps.config: Several configuration values, e.g. for configure
  * sloccount
  * smoketestoo: Runs the smoketest

These files can be obtained through Subversion (trunk/buildbot/buildslave/scripts/).

The file _buildbot.tac_ is created through the buildbot create-slave command. If this file is missing the Buildbot will not recognize the slave's basedir! It is important because it contains basic (but important) information about the slave-master connection.

  * info/admin: Contains mail address of the slave's admin
  * info/host: Contains information about the host machine the slave is running on. Should be customized.

The buildprep step needs a build\_copy/ directory which is currently not automatically created.
Within build\_copy there can be one Common/ directory that contains files that are copyied into the source tree (e.g. unowinreg.dll). Additionally there are per workstamp dirs (e.g. DEV300\_m35) that contain milestone specific patches that will be applied onto the source tree before building (buildprep step).

While running there are two additional files:
  * twistd.log: Output of the slave.
  * twistd.pid: Contains PID of the currently running twistd process.