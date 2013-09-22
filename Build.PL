use 5.008003;
use strict;
use warnings FATAL => 'all';
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'MooX::ConfigFromFile',
    license             => 'Perl_5',
    dist_author         => q{Jens Rehsack <rehsack@cpan.org>},
    dist_version_from   => 'lib/MooX/ConfigFromFile.pm',
    release_status      => 'stable',
    configure_requires => {
        'Module::Build' => 0,
    },
    build_requires => {
        'Test::More' => 0,
    },
    requires => {
        #'ABC'              => 1.6,
        #'Foo::Bar::Module' => 5.0401,
	"Moo" => "1.003",
	"Config::Any" => 0,
	"File::ConfigDir" => 0.005,
    },
    add_to_cleanup     => [ 'MooX-ConfigFromFile-*' ],
    meta_merge =>
        { resources => { repository => "https://github.com/rehsack/MooX-ConfigFromFile", }, },
    test_files => join( ' ' => 't/*.t xt/*.t' ),

);

$builder->create_build_script();
