############################################################
# $Id: Makefile.PL,v 1.8 2005/03/02 11:48:42 nicolaw Exp $
# psmon - Process Table Monitor Script
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

require 5.005;
use strict;
use ExtUtils::MakeMaker qw(WriteMakefile);

WriteMakefile(
	NAME			=> 'psmon',
	VERSION_FROM	=> 'bin/psmon',
	AUTHOR			=> 'Nicola Worthington <nicolaworthington@msn.com>',
	ABSTRACT_FROM	=> 'bin/psmon',
	EXE_FILES		=> [ ('bin/psmon','bin/psmon-config') ],

	dist			=> {
				'COMPRESS'	=> 'gzip -9f',
				'SUFFIX'	=> 'gz',
				'ZIP'		=> '/usr/bin/zip',
				'ZIPFLAGS'	=> '-rl',
			},

	PREREQ_PM		=> {
				'Getopt::Long'			=> 0,
				'Config::General'		=> 0,
				'POSIX'					=> 0,
				'Proc::ProcessTable'	=> 0,
				'Net::SMTP'				=> 0,
				'Unix::Syslog'			=> 0,
			},
);

#sub MY::postamble {
#	my $postamble = <<END;
#psmon-config:
#	\$(INST_SCRIPT)/psmon-config
#END
#	return $postamble;
#}


