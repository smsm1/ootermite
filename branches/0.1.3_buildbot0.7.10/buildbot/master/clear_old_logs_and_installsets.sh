#!/bin/sh
##
## clear_old_logs_and_installsets.sh
## Login : <buildmaster@termite.go-oo.org>
## Started on  Sat Nov  3 02:52:17 2007 BuildMaster
## $Id$
## 
## Copyright (C) 2007 BuildMaster
## This program is free software; you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation; either version 2 of the License, or
## (at your option) any later version.
## 
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
## 
## You should have received a copy of the GNU General Public License
## along with this program; if not, write to the Free Software
## Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
##

echo "Space before"
df -P /dev/sda1

find . -mindepth 2 -type f -not -path \*/.svn\*  -not -path \*/modules\* -not -path \*/builder -mtime +30 -print0 | xargs -0 -r rm
find twistd.log* -mtime +30 -print0 | xargs -0 -r rm

echo "Space after"
df -P /dev/sda1

