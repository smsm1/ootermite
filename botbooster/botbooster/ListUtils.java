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

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.lang.reflect.Array;
import java.util.ArrayList;
import java.util.List;

/**
 * Utility methods for handling Lists.
 * @author Christian Lins (christian.lins@sun.com)
 */
public class ListUtils 
{
  public static List loadList(InputStream ins)
    throws IOException
  {
    List           list = new ArrayList();
    BufferedReader in   = new BufferedReader(new InputStreamReader(ins));
    
    String line;
    do
    {
      line = in.readLine();
      list.add(line);
    }
    while(line != null);
    
    return list;
  }
  
  public static void saveList(List list, OutputStream outs)
  {
    PrintWriter out = new PrintWriter(outs);
    
    for(int n = 0; n < list.size(); n++)
    {
      out.println(list.get(n));
    }
    
    out.flush();
    out.close();
  }
  
  /**
   * Converts an array of objects to a java.util.List
   * @param obj
   */
  public static List soapObjectToList(Object obj)
  {
    List list = new ArrayList();
    
    for(int n = 0; n < Array.getLength(obj); n++)
    {
      list.add(Array.get(obj, n));
    }
    
    return list;
  }
}
