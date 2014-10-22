use strict;
use warnings FATAL => 'all';

{
    package #
	Calc::Role::BinaryOperation;
    use Moo::Role;
    
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
    use Moo;
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


