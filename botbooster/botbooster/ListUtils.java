/*
 * Copyright (C) 2008 Sun Microsystems, Inc.
 * All rights reserved.
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
