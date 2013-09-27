package MooX::ConfigFromFile;

use 5.008003;
use strict;
use warnings FATAL => 'all';

our $VERSION = '0.002';

sub import
{
    my ( undef, @import ) = @_;
    my $target = caller;
    my @target_isa;
    { no strict 'refs'; @target_isa = @{"${target}::ISA"} };

    #don't add this to a role
    #ISA of a role is always empty !
    ## no critic qw/ProhibitStringyEval/
    @target_isa or return;

    my $apply_modifiers = sub {
        return if $target->can('_initialize_from_config');
	my $with   = $target->can('with');
        $with->('MooX::ConfigFromFile::Role');
    };
    $apply_modifiers->();

    return;
}

=head1 NAME

MooX::ConfigFromFile - Moo eXtension for initializing objects from config file

=head1 SYNOPSIS

   package Role::Action;

   use Moo::Role;

   has operator => ( ... );

   package Action;

   use Moo;
   use MooX::ConfigFromFile; # imports the MooX::ConfigFromFile::Role

   with "Role::Action";

   sub operate {
       my $self = shift;

       return say $self->operator;
   }

   package OtherAction;

   use Moo;

   with "Role::Action", "MooX::ConfigFromFile::Role";

   sub operate {
       my $self = shift;

       return warn $self->operator;
   }

   package QuiteOtherOne;

   use Moo;

   use MooX::ConfigFromFile; # imports the MooX::ConfigFromFile::Role

   with "Role::Action";

   sub _build_config_prefix { "die" }

   sub operate {
       my $self = shift;

       return die $self->operator;
   }

   package main;

   my $action = Action->new(); # tries to find a config file in config_dirs and loads it
   my $other = OtherAction->new( config_prefix => "warn" ); # use another config file
   my $quite_o = QuiteOtherOne->new(); # quite another way to have an individual config file

=head1 DESCRIPTION

This module is intended to easy load initialization values for attributes
on object construction from an appropriate config file. The building is
done in L<MooX::ConfigFromFile::Rule> - using MooX::ConfigFromFile ensures
the role is applied.

=head1 AUTHOR

Jens Rehsack, C<< <rehsack at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to
C<bug-moox-configfromfile at rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=MooX-ConfigFromFile>.
I will be notified, and then you'll automatically be notified of progress
on your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc MooX::ConfigFromFile

You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=MooX-ConfigFromFile>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/MooX-ConfigFromFile>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/MooX-ConfigFromFile>

=item * Search CPAN

L<http://search.cpan.org/dist/MooX-ConfigFromFile/>

=back


=head1 ACKNOWLEDGEMENTS


=head1 LICENSE AND COPYRIGHT

Copyright 2013 Jens Rehsack.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See L<http://dev.perl.org/licenses/> for more information.

=cut

1;    # End of MooX::ConfigFromFile
