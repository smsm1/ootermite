/*
 * Copyright (C) 2008 Sun Microsystems, Inc.
 * All rights reserved.
 */

package botbooster;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.util.ArrayList;
import java.util.List;

/**
 * Main entrypoint class.
 * @author Christian Lins (christian.lins@sun.com)
 * @author Gregor Hartmann (gregor.hartmann@sun.com)
 */
public class Main
{
  public static final String DEFAULT_CWS_LIST_FILE = "CWS_List";
  public static final String VERSION               = "botbooster/0.3";
  
  static final String GET_CWS_METHOD = "getCWSWithState";
  static final String GET_MWS_METHOD = "getMasterWorkspaces";
  static final String SERVICE_URL = "http://tools.services.openoffice.org/soap/servlet/rpcrouter";
  static final String SERVICE_URN = "urn:ChildWorkspaceDataService";
  
  static int MAX_BUILDS = 1;
  
  /**
   * @param args the command line arguments
   */
  public static void main(String[] args)
  {
    try
    {
      if(args.length < 1)
      {
        System.out.println("botbooster <status of cws>");
        System.exit(1);
      }

      // Load the list of CWSs that was used last time
      List cwsLast;
      if(new File(DEFAULT_CWS_LIST_FILE).exists())
      {
        cwsLast = ListUtils.loadList(new FileInputStream(DEFAULT_CWS_LIST_FILE));
      }
      else
      {
        cwsLast = new ArrayList();
      }

      // Make a SOAP request to the public EIS and get the list of MWSs.
      SoapRequest mwsReq = new SoapRequest(SERVICE_URL, SERVICE_URN, GET_MWS_METHOD);
      Object      mwsObj = mwsReq.doRequest(new Object[0]);
      List        mwsLst = ListUtils.soapObjectToList(mwsObj);

      // This list will contain all CWSs that must be rebuilt
      List cwsNew = new ArrayList();

      // For every MWS make a SOAP request to retrieve the list of CWSs with
      // status args[0].
      for(int n = 0; n < mwsLst.size(); n++)
      {
        try
        {
          SoapRequest cwsRec = new SoapRequest(SERVICE_URL, SERVICE_URN, GET_CWS_METHOD);
          Object      cwsObj = cwsRec.doRequest(
            new Object[] {String.class, mwsLst.get(n), String.class, args[0]});
          List        cwsLst = ListUtils.soapObjectToList(cwsObj);

          // Add the retaining elements to the list of new CWSs
          cwsNew.addAll(cwsLst);
        }
        catch(Exception ex)
        {
          Debug.out.println("Exception catched: ");
          ex.printStackTrace(Debug.out);
        }
      }

      // Remove all elements from cwsLast that are NOT in cwsNew
      cwsLast.retainAll(cwsNew);

      // Remove all CWSs that we built last time; so all that are in cwsLast
      cwsNew.removeAll(cwsLast);

      // Force a build of the new CWSs on all Buildbot/ootermite builders
      for(int n = 0; n < cwsNew.size() && n < MAX_BUILDS; n++)
      {
        Debug.out.println("Forcing build of CWS named " + cwsNew.get(n));

        for(int m = 0; m < Bot.BUILDERS.length; m++)
        {
          Bot.forceBuild(Bot.BUILDERS[m], cwsNew.get(n).toString());
        }

        // Remember the cws we have submitted
        cwsLast.add(cwsNew.get(n));
      }

      // Save the list of successfully submitted builds
      ListUtils.saveList(cwsLast, new FileOutputStream(DEFAULT_CWS_LIST_FILE));

      Debug.out.println("Finished.");
      Debug.out.flush();
    }
    catch(Throwable ex)
    {
      ex.printStackTrace(Debug.out);
      Debug.out.flush();
    }
  }
}
