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

do "t/testlib.pm";
do "t/testerr.pm";

done_testing;
