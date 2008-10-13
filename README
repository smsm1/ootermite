Buildbot Ready for QA Notifier

This Java app reads the RSS feed
http://eis.services.openoffice.org/EIS2/cws.rss.OOoCWSStatusChangeNewsFeed
for "Ready for QA" items. If one is in the feed a system command (which is 
currently hard coded) is run. This sends the master some information that a
new build should be started on all bots for a particular CWS due to it's 
change of status in EIS.

To build run:
ant
To run the app run:
ant RSSParser

Main class is: buildbot.RSSParser