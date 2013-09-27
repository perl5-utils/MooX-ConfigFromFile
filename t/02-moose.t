#!perl

use 5.008003;

use strict;
use warnings FATAL => 'all';

use Test::More;

BEGIN {
    eval "use Moose;";
    $@ and plan skip_all => "Moose test requires Moose being installed";
}

my $dist_basedir =
  Cwd::abs_path( File::Spec->catdir( File::Basename::dirname($0), File::Spec->updir() ) );

{
    package #
	Calc::Role::BinaryOperation;
    use Moose::Role;
    
    has a => (
        is             => 'ro',
        required       => 1,
    );
    
    has b => (
        is             => 'ro',
        required       => 1,
    );
}


{
    package #
        Calc::add;
    use Moose;
    use MooX::ConfigFromFile;
    
    with 'Calc::Role::BinaryOperation';
    
    sub execute {
        my $self = shift;
        return $self->a + $self->b;
    }
}

my $adder = Calc::add->new( config_prefix => 'calc-operands' );
ok(defined($adder->a), "read 'a' from config");
ok(defined($adder->b), "read 'b' from config");
cmp_ok($adder->execute, "==", 5, "read right adder config");

done_testing;
