#!/bin/sh
############################################################
# $Id: install.sh,v 1.6 2004/08/01 10:43:05 nicolaw Exp $
# install.sh - Installation script for psmon
# Copyright: (c)2002,2003 Nic Lawrence. All rights reserved.
############################################################
# This file is part of psmon.
#
# psmon is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# psmon is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with psmon; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
############################################################

Target="/usr/bin"

if ! [ -f support/commit.sh ] && [ -f commit.sh ] && [ -f ../Makefile.PL ]
then
	cd ..
fi

for dm in wget lwp-download ncftpget
do
	if which $dm > /dev/null 2>&1
	then
		Download=$dm
	fi
done

# Check we have all the right perl modules installed. Try and
# install them from the tarballs provided if necessary.
echo "Config General 2.27,Proc ProcessTable 0.39,Unix Syslog 0.99,Getopt Long 2.34," | \
	while read -d',' Group Name Version
do
	m="$Group::$Name"
	mf="$Group-$Name-$Version.tar.gz"
	md="$Group-$Name"
	echo -n "Checking for $m ... "
	if perl -e '$m = shift; eval("use $m;"); exit 1 if $@;' $m
	then
		echo "found"
	else
		echo "missing"
		if [ "X$Download" != "X" ]
		then
			echo "Attempting to download $mf using $Download ..."
			$Download ftp://ftp.funet.fi/pub/languages/perl/CPAN/modules/by-module/$Group/$mf
			if [ -f $mf ]
			then
				echo "Attempting to install $m from $mf ..."
				tar -zxf $mf
				if cd $md-* > /dev/null 2>&1
				then
					perl Makefile.PL && make && make test && make install
					cd ..
				else
					echo "Failed to install $m from $mf; could not file extraction directory"
				fi
			else
				echo "Failed to download $mf"
			fi
		fi
	fi
done

# Install psmon
if [ -e bin/psmon ]
then
	# Remove any old version of psmon
	if which psmon > /dev/null 2>&1
	then
		oldpsmon=`which psmon`
		bakpsmon=`date +"$oldpsmon-%Y%m%d%H%M%S"`
		echo -n "Moving old psmon $oldpsmon to $bakpsmon ... "
		mv $oldpsmon $bakpsmon
		if [ -e $bakpsmon ]; then echo "done"; else echo "failed"; fi
	fi

	# Install the new psmon script
	echo -n "Installing psmon ... "
	cp bin/psmon $Target/
	if [ -e $Target/psmon ]; then echo "done"; else echo "failed"; fi

	# If we removed an old version, symlink it to the new version
	if [ "X$oldpsmon" != "X" ] && [ "$oldpsmon" != "$Target/psmon" ]
	then
		echo -n "Symlinking old psmon $oldpsmon to $Target/psmon ... "
		ln -s $Target/psmon $oldpsmon
		if [ -e $oldpsmon ]; then echo "done"; else echo "failed"; fi
	fi

	# Install psmon.conf
	if ! [ -e /etc/psmon.conf ]
	then
		if [ -e etc/psmon.conf ]
		then
			echo -n "Installing etc/psmon.conf ... "
			cp etc/psmon.conf /etc
			if [ -e /etc/psmon.conf ]; then echo "done"; else echo "failed"; fi
		else
			echo -n "Could not find etc/psmon.conf; skipped etc/psmon.conf installation"
		fi
	else
		echo "/etc/psmon.conf already exists; skipped etc/psmon.conf installation"
	fi

	# Generate HTML documentation
	if which pod2html > /dev/null 2>&1
	then
		echo -n "Generating HTML documentation support/psmon.html ... "
		pod2html --css=support/perldoc.css bin/psmon > support/psmon.html
		if [ -e support/psmon.html ]; then echo "done"; else echo "failed"; fi
	fi

	# Generate and install man pages
	if which pod2man > /dev/null 2>&1
	then
		mandir=/usr/man/man1
		if ! [ -d $mandir ] && [ -d /usr/share/man/man1 ];then
			mandir=/usr/share/man/man1
		fi
		#if which gzip > /dev/null 2>&1
		#then
		#	echo -n "Installing manual psmon.1.gz ... "
		#	pod2man psmon | gzip > $mandir/psmon.1.gz
		#	if [ -e $mandir/psmon.1.gz ]; then echo "done"; else echo "failed"; fi
		#else
			echo -n "Installing manual psmon.1 ... "
			pod2man bin/psmon > $mandir/psmon.1
			if [ -e $mandir/psmon.1 ]; then echo "done"; else echo "failed"; fi
		#fi
	else
		echo "Could not find pod2man; skipped manual installation"
	fi
else
	echo "Could not find psmon; skipped psmon installation"
fi



