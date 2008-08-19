/*
 * Copyright (C) 2008 Sun Microsystems, Inc.
 * All rights reserved.
 */

package botbooster;

import java.io.IOException;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;

/**
 * Provides method for forcing builds at the Buildbot Master.
 * @author Christian Lins (christian.lins@sun.com)
 */
public class Bot 
{
  public static final String[] BUILDERS = {"Win-XP2", "Ubuntu", "Solaris-Sparc", "Solaris-Intel"};
  public static final String   MASTER_URL = "http://termite.go-oo.org/buildbot/";
  
  public static boolean forceBuild(String builder, String build)
    throws IOException, MalformedURLException
  {
    String urlStr = MASTER_URL + builder + "/force?username=botbooster&comments=AutoSubmitted&branch=" + build;
    
    URL               url   = new URL(urlStr);
    HttpURLConnection conn  = (HttpURLConnection)url.openConnection();
    conn.connect();
    
    if(conn.getResponseCode() != HttpURLConnection.HTTP_OK)
    {
      Debug.out.println("Server returned: " + conn.getResponseMessage());
      return false;
    }
    else
      return true;
  }
}
