use strict;
use warnings FATAL => 'all';

{
    package    #
      Calc::Role::BinaryOperation;
    use Moo::Role;

    has a => (
        is       => 'ro',
        required => 1,
    );

    has b => (
        is       => 'ro',
        required => 1,
    );
}

{
    package    #
      Calc::add;
    use Moo;
    use MooX::ConfigFromFile;

    with 'Calc::Role::BinaryOperation';

    sub execute
    {
        my $self = shift;
        return $self->a + $self->b;
    }
}

{
    package    #
      Calc::sub;
    use Moo;
    use MooX::ConfigFromFile config_prefix => 'calc-operands';

    with 'Calc::Role::BinaryOperation';

    sub execute
    {
        my $self = shift;
        return $self->a - $self->b;
    }
}

{
    package    #
      Calc::mul;
    use Moo;
    use MooX::ConfigFromFile
      config_prefix    => 'calc-operands',
      config_singleton => 1;

    with 'Calc::Role::BinaryOperation';

    sub execute
    {
        my $self = shift;
        return $self->a * $self->b;
    }
}

my $adder = Calc::add->new( config_prefix => 'calc-operands' );
ok( defined( $adder->a ), "read 'a' from add config" );
ok( defined( $adder->b ), "read 'b' from add config" );
cmp_ok( $adder->execute, "==", 5, "read right adder config" );

my $subber = Calc::sub->new;
ok( defined( $subber->a ), "read 'a' from sub config" );
ok( defined( $subber->b ), "read 'b' from sub config" );
cmp_ok( $subber->execute, "==", -1, "read right subber config" );

my $mul1 = Calc::mul->new;
ok( defined( $mul1->a ), "read 'a' from mul1 config" );
ok( defined( $mul1->b ), "read 'b' from mul1 config" );
cmp_ok( $mul1->execute, "==", 6, "read right mul config" );

my $mul2 = Calc::mul->new( config_prefix => 'no-calc-operands' );
ok( defined( $mul2->a ), "copy 'a' from mul1 config" );
ok( defined( $mul2->b ), "copy 'b' from mul1 config" );
cmp_ok( $mul2->execute, "==", 6, "right mul1 config duplicated" );

