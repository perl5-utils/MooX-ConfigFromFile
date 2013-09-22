package MooX::ConfigFromFile::Role;

use strict;
use warnings;

our $VERSION = '0.001';

use Moo::Role;

use FindBin qw/$Script/;

use Config::Any;
use File::Find::Rule;

with "MooX::File::ConfigDir";

sub new_with_config
{
    my ( $class, @params ) = @_;
    return $class->new( $class->load_config(@params) );
}

sub load_config
{
    my ( $class, %params ) = @_;
    return $class->new( %{ $class->loaded_config }, %params );
}

has 'config_files' => ( is => 'lazy' );

sub _build_config_files
{
    my ($self) = @_;

    my $can_config_prefix = $self->can("config_prefix");
    my $main_file = $can_config_prefix ? $can_config_prefix->($self) : $Script;

    my $cfg_dirs    = $self->config_dirs();
    #Test::More::diag(Test::More::explain(\$cfg_dirs));
    ref $cfg_dirs eq "ARRAY" or $cfg_dirs = ["."];
    my @cfg_pattern = map { $main_file . "." . $_ } Config::Any->extensions();
    my @cfg_files   = File::Find::Rule->file()->name(@cfg_pattern)->maxdepth(1)->in(@$cfg_dirs);

    return \@cfg_files;
}

has 'loaded_config' => (
                         is      => 'lazy',
                         clearer => 1
                       );

sub _build_loaded_config
{
    my ($self) = @_;

    my $files = $self->config_files;
    return {} if !@$files;

    my $config = Config::Any->load_files(
                                          {
                                            files   => $files,
                                            use_ext => 1
                                          }
                                        );
    my $config_merged = {};
    for my $c ( map { values %$_ } @$config )
    {
        %$config_merged = ( %$config_merged, %$c );
    }
    return $config_merged;

}

1;
