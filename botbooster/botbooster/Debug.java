/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
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
