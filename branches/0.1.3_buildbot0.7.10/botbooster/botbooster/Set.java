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

import java.util.ArrayList;

/**
 * A list that contains no duplicates. We could have used
 * a java.util.Set, but this seems easier.
 * @author Christian Lins (christian.lins@sun.com)
 */
public class Set extends ArrayList
{
  @Override
  public boolean add(Object obj)
  {
    if(super.contains(obj))
      return false;
    else
      return super.add(obj);
  }
}
