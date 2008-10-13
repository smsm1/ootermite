package buildbot;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Enumeration;
import java.util.Vector;


public class CWSList {
	private Vector<CWSAnnouncement> list;
	private File persistentFile;

	public CWSList() {
	   // Should really have this as a configuration option rather than a Fixed compiled string
		persistentFile = new File("sentcws.txt");
		list = new Vector<CWSAnnouncement>();
		loadList();
	}

	public void add(CWSAnnouncement a) {
		list.add(a);
	}

	public int size() {
		return list.size();
	}

	public CWSAnnouncement elementAt(int index) {
		return list.elementAt(index);
	}

	public boolean contains(CWSAnnouncement o) {
		Enumeration<CWSAnnouncement> e = list.elements();
		while(e.hasMoreElements()) {
			if(e.nextElement().equals(o)) {
				return true;
			}
		}
		return false;
	}

	public boolean isEmpty() {
		return list.isEmpty();
	}

	private void loadList() {
		if(persistentFile.exists()) {
			try {
				BufferedReader reader = new BufferedReader(new FileReader(persistentFile));
				String line = reader.readLine();
				int i = 0;
				do {
					System.out.println(i);
					i++;
					try {
						String[] lineItems = line.split("\t");
						if(lineItems.length==4) {
							// String cws, String master, String status, String date
							CWSAnnouncement c = new CWSAnnouncement(lineItems[0], lineItems[1], lineItems[2], lineItems[3]);
							list.add(c);
						}
					} catch (NullPointerException e) {

					}
					line = reader.readLine();
				} while (line != null);
				reader.close();
			} catch (FileNotFoundException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
	}

    /**
    * Save the list of CWS that have been sent to the build master already
    * to a file.
    * Should really junk older items that will no longer be in the feed to
    * prevent a file that will be too large and causing issues when it is
    * loaded in the future..
    */
	public boolean saveList() {
		try {
			PrintWriter writer = new PrintWriter(new BufferedWriter(new FileWriter(persistentFile)));
			Enumeration<CWSAnnouncement> e = list.elements();
			Date currentDate = Calendar.getDate();
			// Again the junk date should be configurable
			Date junkDate = currentDate.rollMonth(-3);
			while(e.hasMoreElements()) {
			     CWSAnnouncement an = e.nextElement();
			     if(an.getDate()>junkDate) {
				    writer.println(an);
			     }
			}
			writer.close();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return false;
		}
		return true;
	}
}
