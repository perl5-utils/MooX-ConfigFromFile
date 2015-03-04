#!perl

use 5.008001;

use strict;
use warnings FATAL => 'all';

use Test::More;

BEGIN {
    eval "use Moose;";
    $@ and plan skip_all => "Moose test requires Moose being installed";
}

our $OO = "Moose";
$ENV{WHICH_MOODEL} = "Moose";

do "t/testlib.pm";
do "t/testerr.pm";
do "t/testmxcmd.pm";

done_testing;
