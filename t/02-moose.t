#!perl

use 5.008003;

use strict;
use warnings FATAL => 'all';

use Test::More;

BEGIN {
    eval "use Moose;";
    $@ and plan skip_all => "Moose test requires Moose being installed";
}

do "t/testlib.pm";

done_testing;
