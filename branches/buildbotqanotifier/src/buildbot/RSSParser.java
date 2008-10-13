package buildbot;

import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.Enumeration;
import java.util.Vector;

import nanoxml.XMLElement;

public class RSSParser implements Runnable {
	private CWSList list;

	public RSSParser() {
		list = new CWSList();
	}

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		RSSParser r = new RSSParser();
		r.run();
	}


	public void run() {
		doWork();
	}

	private void doWork() {
		URL rssFeed = null;
		try {
			rssFeed = new URL("http://eis.services.openoffice.org/EIS2/cws.rss.OOoCWSStatusChangeNewsFeed");
		} catch (MalformedURLException e) {
			System.out.println("Error setting the feed URL");
			e.printStackTrace();
			return;
		}
		XMLElement ele = new XMLElement();
		try {
			BufferedReader in = new BufferedReader(new InputStreamReader(rssFeed.openStream()));
			ele.parseFromReader(in);
			//System.out.println(ele.toString());
			Vector v = ele.getChildren();
			Enumeration en = v.elements();
			while(en.hasMoreElements()) {
				//System.out.println(en.nextElement());
				XMLElement enEle = (XMLElement) en.nextElement();
				//System.out.println(enEle.countChildren());
				//System.out.println(enEle.getName());
				Enumeration enE = enEle.enumerateChildren();
				while(enE.hasMoreElements()) {
					XMLElement enEl = (XMLElement) enE.nextElement();
					if(enEl.getName().equalsIgnoreCase("item")) {
						// We have an item, so show it
						Enumeration viEn = enEl.enumerateChildren();
						while(viEn.hasMoreElements()) {
							// Look for a title
							XMLElement viEle = (XMLElement) viEn.nextElement();
							//System.out.println(viEle.countChildren());
							if(viEle.getName().equals("title")) {
								// Lets print it
								String titleToParse = viEle.getContent();
								//System.out.println(titleToParse);
								// Now we just need to parse this
								// Child Workspace "vcl75" of master SRC680 set to status "ready for QA" on 28-MAR-07
								// Based on " ?
								/* Get the CWS */
								String cwsStr = titleToParse.substring(titleToParse.indexOf('"')+1, titleToParse.indexOf('"', titleToParse.indexOf('"')+2));
								//System.out.println("CWS: " +cwsStr);
								/* Get the Master */
								String masterStr = titleToParse.substring(titleToParse.indexOf("master ")+7, titleToParse.indexOf(" set to"));
								//System.out.println("Master: "+masterStr);
								/* Get the Status */
								String statusStr = titleToParse.substring(titleToParse.indexOf("status")+8, titleToParse.lastIndexOf('"'));
								//System.out.println(statusStr);
								/* Get the date */
								String dateStr = titleToParse.substring(titleToParse.length()-9);
								//System.out.println("Date: "+dateStr);
								if(statusStr.equalsIgnoreCase("ready for qa")) {
									// Create the announcement object
									CWSAnnouncement announce = new CWSAnnouncement(cwsStr, masterStr, statusStr, dateStr);
									// Check it hasn't been done already
									// list.contains doesn't work
									if(list.contains(announce)) {
										System.out.println("The master already knows about the CWS " + cwsStr);
									} else {
										System.out.println("Tell the build master to force a build for the CWS " + cwsStr + " of the master " + masterStr + " since it has been set ready for QA");
										String [] cmdarray = {"/Volumes/FREECOMHDD/ooo/buildbot/bin/buildbot",  "sendchange", "--master", "termite.go-oo.org:9999", "--username", "change", "--branch", cwsStr, "ready_for_qa"}; 
										File dir = new File("/Volumes/FREECOMHDD/ooo/buildbot/bin");
										Process buildSend = Runtime.getRuntime().exec(cmdarray, null, dir);
										int returnVal = -1;
										try {
											returnVal = buildSend.waitFor();
											System.out.println("Return val for sending the change: "+returnVal);
											// We have added the change to the master so store it
											//String cws, String master, String status, String date
											list.add(announce);
										} catch (InterruptedException e) {
											e.printStackTrace();
										}
									}
								}
							}

						}
					}
				}
				list.saveList();
			}
		} catch (IOException e) {
			System.out.println("Error getting the feed");
			e.printStackTrace();
		}
	}

}
