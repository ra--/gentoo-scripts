#!/usr/bin/perl

# Name:		paludis2emerge.log_convert.pl
# Purpose:	converts paludis.log to emerge.log
# Version:	0.01-alpha
# Date:		24.Jan.2009
# License:	GPLv2
# Author:	ra <r_a@lavabit.com>
# Notes:	I tried to make the expressions strict, so it may have problems
# 		parsing lines with uncommon packages. You also loose some
# 		(probably unimportant) information like fetching and targets.


use strict;
use warnings;
use diagnostics;

my $pline;

while (<STDIN>) {
  chomp;
  $pline= "";

  if (/^([0-9]+): starting uninstall of package ([a-z0-9-]+\/[a-zA-Z.+0-9-_]+)(:[a-z0-9.-]+)?::installed(-unpackaged)? \([0-9]+ of [0-9]+\)$/) {
    $pline = "$1: === Unmerging... ($2)";
  } elsif (/^([0-9]+): starting clean of package ([a-z0-9-]+\/[a-zA-Z.+0-9-_]+)(:[a-z0-9.-]+)?::installed( \([0-9]+ of [0-9]+\))?$/) {
    $pline = "$1: === Unmerging... ($2)";
  } elsif (/^([0-9]+): finished (clean|uninstall) of package ([a-z0-9-]+\/[a-zA-Z.+0-9-_]+)(:[a-z0-9.-]+)?::installed(-unpackaged)? \([0-9]+ of [0-9]+\)$/) {
    $pline = "$1:  >>> unmerge success: $3";
  } elsif (/^([0-9]+): starting install of package ([a-z0-9-]+\/[a-zA-Z.+0-9-_]+)(:[a-z0-9.-]+)?::[a-zA-Z0-9-_]+ (.*)$/) {
    $pline = "$1:  >>> emerge $4 $2 to /";
  } elsif (/^([0-9]+): finished install of package ([a-z0-9-]+\/[a-zA-Z.+0-9-_]+)(:[a-z0-9.-]+)?::[a-zA-Z0-9-_]+ (.*)$/) {
    $pline = "$1:  ::: completed emerge $4 $2 to /";
  } elsif (/^([0-9]+): starting sync of repository ([a-zA-Z0-9-_]+) \([0-9]+ of [0-9]+( \(1 active\))?\)$/) {
    $pline = "$1: >>> Starting rsync with $2";
  } elsif (/^([0-9]+): finished sync of repository ([a-zA-Z0-9-_]+) \([0-9]+ of [0-9]+( \(1 active\))?\)$/) {
    $pline = "$1: === Sync completed with $2";
  } elsif (/^[0-9]+: ((starting|finished) (un)?install of targets|(starting|finished) clean of targets|(starting|finished) fetch of (targets|package)) .*$/) {
    $pline = '';
  } elsif (/^(.*)/) {
    print STDERR "ERROR parsing line: \"$1\"\n";
    exit 1;
  }
  print "$pline\n" unless $pline eq "";
}

