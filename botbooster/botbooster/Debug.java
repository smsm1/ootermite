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

import java.io.FileOutputStream;
import java.io.PrintStream;

/**
 *
 * @author sun
 */
public class Debug 
{
  public static final String LOGFILE = "bot.log";
  
  public static PrintStream out = System.out;
  
  static
  {
    try
    {
      out = new PrintStream(new FileOutputStream(LOGFILE));
    }
    catch(Exception ex)
    {
      ex.printStackTrace();
    }
  }
  
  public static void log(Object obj)
  {
    System.out.println(obj);
    out.println(obj);
  }
}
