## Major Components ##
![http://ootermite.googlecode.com/svn/wiki/simple_block_diagram.png](http://ootermite.googlecode.com/svn/wiki/simple_block_diagram.png)

The server runs two applications that are served out through apache.  The first is the buildbot application, which controls building.  The second is the reporter application which controls reporting.  Both are proxied through apache.

## Interface Overview ##
![http://ootermite.googlecode.com/svn/wiki/interfaces_block_diagram.png](http://ootermite.googlecode.com/svn/wiki/interfaces_block_diagram.png)

### Change Source Interfaces ###
Change source interfaces either poll or receive notification of changes to source code, such as commits or cws-state-changes.

The buildbot monitors a MailDir for changes that come from the all\_cvs mailing list.  The parser has been modified from the original buildbot version to ignore unrelated commits.

The buildbot also will receiv EIS status change notifications when cws's change state from new to ready-for-qa.  This is done through the pb-sendchange interface and some XML parsing that lives on the server.

#### Status Interfaces ####
Status interfaces are for both the display of build status as well as requesting specific builds be made.

The IRC interface is from buildbot.  This interface needs modifications to support forcing builds on specific cws's in a more graceful manner.  Also, it doesn't dance very well.

The HTML interface is multiplexed between reporter and buildbot.  This multiplexing is handled by apache.  The buildbot html interface is the waterfall, which should be familiar to the reader.  The reporter interface will allow for the browsing of reports as well as the creation of report templates.

The tinderbox email is a buildbot customization for the emailing of completed builds to tinderbox.  EIS has a tinderbox widget that allows the QA team to easily see build status directly from EIS.

### Slave Interface ###
This is interface is used by the slave for command/control as well as status reporting.

The twistd spread (an object broker) interface is used by buildbot to proxy build commands/status back and forth.

The reporter application receives XML "results" from the slave which it uses as data sources for reports.