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
import java.util.Properties;

/**
 * Simple configuration class.
 * @author Christian Lins (christian.lins@sun.com)
 */
public class Config 
{
  private static Config instance = null;
  
  public static Config getInstance()
  {
    if(instance == null)
    {
      instance = new Config();
      Properties prop = new Properties();
      try
      {
        // Load ini file
        prop.load(new FileInputStream("config.ini"));
        
        instance.builders  = prop.getProperty("BUILDERS").split(",");
        instance.masterURL = prop.getProperty("MASTER_URL");
        instance.maxBuilds = Integer.parseInt(prop.getProperty("MAX_BUILDS_PER_RUN"));
      }
      catch(Exception ex1)
      {
        ex1.printStackTrace(Debug.out);
        
        // Create new ini file
        prop.setProperty("BUILDERS", Bot.DEFAULT_BUILDERS);
        prop.setProperty("MASTER_URL", Bot.MASTER_URL);
        prop.setProperty("MAX_BUILDS_PER_RUN", "1");
        
        try
        {
          prop.store(new FileOutputStream("config.ini"), "BotBooster");
        }
        catch(Exception ex2)
        {
          ex2.printStackTrace(Debug.out);
        }
      }
    }
    
    return instance;
  }
  
  private String[] builders  = new String[0];
  private String   masterURL = null;
  private int      maxBuilds = 1;
  
  private Config()
  {
  }
  
  public String[] builders()
  {
    return this.builders;
  }
  
  public int maxBuilds()
  {
    return this.maxBuilds;
  }
}
