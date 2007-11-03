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

purge_old_logs() {
    cd $1
    echo Clearing logs from $1
    find *log* -mtime +10 -exec rm {} \;
    cd ..
}

purge_old_installsets() {
    cd install_sets
    find *.zip -mtime +10 -exec rm {} \;
    cd ..
}

echo "Space before"
df -P /dev/sda1

purge_old_logs edgy-jdk
purge_old_logs etch-gij
purge_old_logs MacPort1
purge_old_logs Mac-PPC
purge_old_logs Mac-x86
purge_old_logs O3-build
purge_old_logs Solaris-Intel
purge_old_logs Solaris-Sparc
purge_old_logs source
purge_old_logs SuSE-10
purge_old_logs Ubuntu-Sun
purge_old_logs Win-XP

purge_old_installsets

echo "Space after"
df -P /dev/sda1

