#!perl

use 5.008001;

use strict;
use warnings FATAL => 'all';

use Test::More;

do "t/testlib.pm";
do "t/testerr.pm";

done_testing;
