/*
 *  Copyright (C) 2008 Sun Microsystems, Inc.
 *
 *  This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program.  If not, see <http://www.gnu.org/licenses/>.
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
  public static final String DEFAULT_BUILDERS = "Win-XP2,Ubuntu,Solaris-Sparc,Solaris-Intel";
  public static final String MASTER_URL       = "http://ttermite.go-oo.org/buildbot/";
  
  public static boolean forceBuild(String builder, String build)
    throws MalformedURLException
  {
    HttpURLConnection conn = null;
    
    try
    {
      String urlStr = Config.getInstance().masterURL() + builder + "/force?username=botbooster&comments=AutoSubmitted&branch=" + build;

      URL url = new URL(urlStr);
      
      // Create a HttpURLConnection object. At this point no actual connection
      // is going to the remote server.
      conn  = (HttpURLConnection)url.openConnection();
      
      // Actually connect to the remote server
      conn.connect();

      if(conn.getResponseCode() != HttpURLConnection.HTTP_OK)
      {
        Debug.out.println("Server returned: " + conn.getResponseMessage());
        return false;
      }
      else
        return true;
    }
    catch(IOException ex)
    {
      ex.printStackTrace(Debug.out);
      return false;
    }
    finally
    {
      if(conn != null)
        conn.disconnect();
      try
      {
        // Sleep to give the system the time to "really" shutdown the
        // connection
        Thread.sleep(1000);
      }
      catch(InterruptedException ex2) 
      {}
    }
  }
}
