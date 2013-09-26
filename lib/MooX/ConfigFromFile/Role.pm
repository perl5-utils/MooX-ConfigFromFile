package MooX::ConfigFromFile::Role;

use strict;
use warnings;

our $VERSION = '0.001';

use Moo::Role;

use FindBin qw/$Script/;

use Config::Any;
use File::Find::Rule;

with "MooX::File::ConfigDir";

sub BUILDARGS { {} }

around BUILDARGS => sub {
    my $next   = shift;
    my $class  = shift;
    my $params = $class->$next(@_);
    $class->_initialize_from_config($params);
    return $params;
};

sub _initialize_from_config
{
    my ($class, $params) = @_;
    defined $params->{loaded_config} or $params->{loaded_config} = $class->_build_loaded_config($params);

    # This copies stuff from loaded_config into the object's parameters
    foreach my $cfg_key ( keys %{ $params->{loaded_config} } )
    {
        exists $params->{$cfg_key} and next;
        $params->{$cfg_key} = $params->{loaded_config}->{$cfg_key};
    }

    return $params;
}

has 'config_prefix' => ( is => 'lazy' );

sub _build_config_prefix { $Script; }

has 'config_files' => ( is => 'lazy' );

sub _build_config_files
{
    my ($class, $params) = @_;

    defined $params->{config_prefix} or $params->{config_prefix} = $class->_build_config_prefix($params);

    defined $params->{config_dirs} or $params->{config_dirs} = $class->_build_config_dirs($params);
    ref $params->{config_dirs} eq "ARRAY" or $params->{config_dirs} = ["."];
    my @cfg_pattern = map { $params->{config_prefix} . "." . $_ } Config::Any->extensions();
    my @cfg_files = File::Find::Rule->file()->name(@cfg_pattern)->maxdepth(1)->in(@{$params->{config_dirs}});

    return \@cfg_files;
}

has 'loaded_config' => (
                         is      => 'lazy',
                         clearer => 1
                       );

sub _build_loaded_config
{
    my ($class, $params) = @_;

    defined $params->{config_files} or $params->{config_files} = $class->_build_config_files($params);
    return {} if !@{$params->{config_files}};

    my $config = Config::Any->load_files(
                                          {
                                            files   => $params->{config_files},
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
