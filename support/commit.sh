#!/bin/sh
############################################################
# $Id: commit.sh,v 1.7 2005/03/02 11:48:23 nicolaw Exp $
# commit.sh - Update and commit changes to CVS
# Copyright: (c)2002,2003,2004 Nicola Worthington. All rights reserved.
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

if [ "`hostname`" = "lilacup.2x4b.com" ]
then
	if [ $# -ge 1 ]
	then
		#pod2html --css=perldoc.css ../psmon > psmon.html
		#pod2html ../psmon > psmon.html
		#pod2man ../psmon psmon.1
		#links -dump https://www.nicolaworthington.com/software/psmon/index.htm > README
		cvs commit $@
		cvs2cl.pl -r -t -T -P --fsf --file Changes
		rm -f *.bak pod2htm* 
	fi
fi

