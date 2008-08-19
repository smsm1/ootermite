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
