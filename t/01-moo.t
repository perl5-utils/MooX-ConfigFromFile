#!perl

use 5.008001;

use strict;
use warnings FATAL => 'all';

use Test::More;

our $OO = "Moo";

do "t/testerr.pm";
do "t/testlib.pm";
do "t/testmxcmd.pm";

done_testing;
