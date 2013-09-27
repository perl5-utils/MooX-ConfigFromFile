package MooX::ConfigFromFile::Role;

use strict;
use warnings;

our $VERSION = '0.002';

use Moo::Role;

use FindBin qw/$Script/;

use Config::Any;
use File::Find::Rule;

with "MooX::File::ConfigDir";

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

=head1 NAME

MooX::ConfigFromFile::Role - Moo eXtension for initializing objects from config file

=head1 DESCRIPTION

This role adds a initializing sub around L<BUILDARGS|Moose::Manual::Construction/BUILDARGS>
and puts all what could read from config files into the hash which will be
used to construct the final object.

While it does that, it internally calls it's own _build_* methods (I<_build_config_prefix>,
I<_build_config_files> and I<_build_loaded_config>) unless the appropriate attributes are
already in C<$params>.

=head1 ATTRIBUTES

This role uses following attributes which might be suitable customized by
overloading the appropriate builder or pass defaults in construction arguments.

=head2 config_prefix

This attribute defaults to L<FindBin>'s C<$Script>. It's interpreted as the
basename of the config file name to use.

=head2 config_dirs

This attribute is included from L<MooX::ConfigDir|MooX::ConfigDir/config_dirs>.
It might be unclever to override - but possible. Use with caution.

=head2 config_files

This attribute contains the list of existing files in I<config_dirs> matching
I<config_prefix> . L<Config::Any-E<gt>extensions|Config::Any/extensions>.
Search is operated by L<File::Find::Rule>.

=head1 AUTHOR

Jens Rehsack, C<< <rehsack at cpan.org> >>

=head1 ACKNOWLEDGEMENTS

Toby Inkster suggested to rely on BUILDARGS instead of intercepting object
creation with nasty hacks. Also teached me a bit more how Moo(se) works.

=head1 LICENSE AND COPYRIGHT

Copyright 2013 Jens Rehsack.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See L<http://dev.perl.org/licenses/> for more information.

=cut

1;
