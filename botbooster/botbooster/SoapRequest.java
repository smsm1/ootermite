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

import java.io.*;
import java.net.*;
import java.util.*;
import org.apache.soap.*;
import org.apache.soap.rpc.Call;
import org.apache.soap.rpc.Response;
import org.apache.soap.rpc.Parameter;

/**
 * A simple SOAP request class.
 * @author Frank Mau (frank.mau@sun.com)
 * @author Christian Lins (christian.lins@sun.com)
 */
public class SoapRequest
{
  private String serviceURL, serviceURN, methodName;
  
  public SoapRequest(String serviceURL, String serviceURN, String methodName)
  {
    this.serviceURL = serviceURL;
    this.serviceURN = serviceURN;
    this.methodName = methodName;
  }
  
  /**
   * @param arguments array of Class and value, e.g. java.lang.String.class and 
   * "My string". Improvement would be a generic Pair class.
   * @return
   */
  public Object doRequest(Object[] arguments)
  {
    //Debug.out.println("Sending SOAP-Request for");
    //Debug.out.println("\tURL: " + this.serviceURL);
    //Debug.out.println("\tURN: " + this.serviceURN);
    //Debug.out.println("\tMethod: " + this.methodName);

    Response resp;

    try
    {
      Call call = new Call();
      call.setTargetObjectURI(this.serviceURN);
      call.setMethodName(this.methodName);
      call.setEncodingStyleURI(Constants.NS_URI_SOAP_ENC);

      Vector params = new Vector();

      for (int n = 0; n < arguments.length; n++)
      {
        params.addElement(
          new Parameter("Argument" + n / 2,
          (Class)arguments[n],
          arguments[++n],
          null));
      }

      call.setParams(params);
      resp = call.invoke(new URL(this.serviceURL), this.serviceURN);
    }
    catch (Exception ex)
    {
      Debug.out.println("Error while calling '" + this.methodName + "':");
      Debug.out.println(ex.getMessage());
      throw new RuntimeException( ex.toString() );
    }

    if (resp.generatedFault())
    {
      Debug.out.println("Call to '" + this.methodName + "' returned a fault:");
      Debug.out.println(resp.getFault());
      throw new RuntimeException( "Call to '" + this.methodName + "' returned a fault:" + resp.getFault() );
    }
    else
    {
      if (null != resp.getReturnValue())
      {
        Object result = resp.getReturnValue().getValue();
        return result;
      }
    }
    throw new RuntimeException( "empty list" );
  }
}
