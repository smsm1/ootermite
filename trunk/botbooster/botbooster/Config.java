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

import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.util.ArrayList;
import java.util.List;
import jaxser.Jaxser;

/**
 *
 * @author Christian Lins (christian.lins@sun.com)
 */
public class Config 
{
  private static Config instance = null;
  
  public static Config getInstance()
  {
    if(instance == null)
    {
      Jaxser jaxser = new Jaxser();
      try
      {
        instance = (Config)jaxser.fromXML(new FileInputStream("config.xml"));
      }
      catch(Exception ex)
      {
        ex.printStackTrace(Debug.out);
        instance = new Config();
        try
        {
          jaxser.toXML(instance, new FileOutputStream("config.xml"));
        }
        catch(Exception e)
        {
          e.printStackTrace(Debug.out);
        }
      }
    }
    
    return instance;
  }
  
  private List<String> builders  = new ArrayList<String>();
  private int          maxBuilds = 1;
  
  private Config()
  {
  }
  
  public List<String> builders()
  {
    return this.builders;
  }
  
  public int maxBuilds()
  {
    return this.maxBuilds;
  }
}
