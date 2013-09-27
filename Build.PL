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
	'Cwd' => 0,
	'File::Basename' => 0,
	'File::Spec' => 0,
	'JSON' => 0,
        'Test::More' => 0,
    },
    requires => {
	"Config::Any" => 0,
	"File::Find::Rule" => "0.30",
	"FindBin" => 0,
	"Moo" => "1.003",
	"MooX::File::ConfigDir" => "0.002",
    },
    auto_features => {
	author_testing => {
	    description => "Enable dependencies for author testing",
	    configure_requires => {
		'Test::CPAN::Changes' => 0,
		'Test::CheckManifest' => 0,
		'Test::Pod' => 0,
		'Test::Pod::Coverage' => 0,
		'Test::Pod::Spelling::CommonMistakes' => 0,
	    },
	},
    },
    add_to_cleanup     => [ 'MooX-ConfigFromFile-*' ],
    meta_merge =>
        { resources => { repository => "https://github.com/rehsack/MooX-ConfigFromFile", }, },
    test_files => join( ' ' => 't/*.t xt/*.t' ),

);

$builder->create_build_script();
