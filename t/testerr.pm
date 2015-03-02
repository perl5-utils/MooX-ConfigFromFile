use strict;
use warnings FATAL => 'all';

{
    package #
      Must::Fail;

    use MooX::ConfigFromFile;

    sub new { bless {} shift }
}

{
    package #
      Already::There;

    use Moo;
    use MooX::ConfigFromFile;

    sub _initialize_from_config {}
}

my $mf = Must::Fail->new;
ok( !$mf->can("_initialize_from_config"), "Failed to apply MooX::ConfigFromFile::Role" );

my $ar = Already::There->new;
#ok( !$ar->can("is_role"), "" );
ok( !$ar->is_role("MooX::ConfigFromFile::Role"), "Skipped applying MooX::ConfigFromFile::Role" )
