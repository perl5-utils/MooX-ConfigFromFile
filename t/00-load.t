#!perl

use 5.008003;

use strict;
use warnings FATAL => 'all';

use Test::More;
use Moo;

BEGIN {
    use_ok( 'MooX::ConfigFromFile' ) || print "Bail out!\n";
}

diag( "Testing MooX::ConfigFromFile $MooX::ConfigFromFile::VERSION, Perl $], $^X" );

done_testing();
