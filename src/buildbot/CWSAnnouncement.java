package buildbot;

public class CWSAnnouncement implements Comparable<CWSAnnouncement> {
	private String cws;
	private String master;
	private String status;
	private String date;
	
	public CWSAnnouncement() {
		cws = new String();
		master = new String();
		status = new String();
		date = new String();
	}
	
	public CWSAnnouncement(String cws, String master, String status, String date) {
		super();
		this.cws = cws;
		this.master = master;
		this.status = status;
		this.date = date;
	}
	
	public String getCws() {
		return cws;
	}
	
	public void setCws(String cws) {
		this.cws = cws;
	}
	
	public String getDate() {
		return date;
	}
	
	public void setDate(String date) {
		this.date = date;
	}
	
	public String getMaster() {
		return master;
	}
	
	public void setMaster(String master) {
		this.master = master;
	}
	
	public String getStatus() {
		return status;
	}
	
	public void setStatus(String status) {
		this.status = status;
	}

	public int compareTo(CWSAnnouncement o) {
		// First compare the CWS
		if(o.getCws().compareTo(this.getCws())==0) {
			// They are the same so lets compare the master
			if(o.getMaster().compareTo(this.getMaster())==0) {
				// The Masters are the same so lets compare the dates
				if(o.getDate().compareTo(this.getDate())==0) {
					// The Dates are the same so lets compare the statuses
					if(o.getStatus().compareTo(this.getStatus())==0) {
						// The status is the same, so return 0 since they are both the same object
						return 0;
					} else {
						// The status difference
						return o.getStatus().compareTo(this.getStatus());
					}
				} else {
					// The dates difference
					return o.getDate().compareTo(this.getDate());
				}
			} else {
				// Compare the masters
				return o.getMaster().compareTo(this.getMaster());
			}
		} else {
			// Compare the CWS
			return o.getCws().compareTo(this.getCws());
		}
	}
	
	public boolean equals(CWSAnnouncement o) {
		if(o.getCws().equals(this.getCws())) {
			if(o.getMaster().equals(this.getMaster())) {
				if(o.getDate().equals(this.getDate())) {
					if(o.getStatus().equals(this.getStatus())) {
						return true;
					}
				}
			}
		}
		return false;
	}
	
	public String toString() {
		///String cws, String master, String status, String date
		StringBuffer out = new StringBuffer();
		out.append(getCws());
		out.append("\t");
		out.append(getMaster());
		out.append("\t");
		out.append(getStatus());
		out.append("\t");
		out.append(getDate());
		return out.toString();
	}
}
