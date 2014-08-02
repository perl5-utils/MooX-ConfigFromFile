## NAME

    MooX::ConfigFromFile - Moo eXtension for initializing objects from
    config file

## SYNOPSIS

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

## DESCRIPTION

    This module is intended to easy load initialization values for
    attributes on object construction from an appropriate config file. The
    building is done in MooX::ConfigFromFile::Role - using
    MooX::ConfigFromFile ensures the role is applied.

## AUTHOR

    Jens Rehsack, "<rehsack at cpan.org>"

## BUGS

    Please report any bugs or feature requests to "bug-moox-configfromfile
    at rt.cpan.org", or through the web interface at
    <http://rt.cpan.org/NoAuth/ReportBug.html?Queue=MooX-ConfigFromFile>. I
    will be notified, and then you'll automatically be notified of progress
    on your bug as I make changes.

## SUPPORT

    You can find documentation for this module with the perldoc command.

        perldoc MooX::ConfigFromFile

    You can also look for information at:

    *   RT: CPAN's request tracker (report bugs here)

        <http://rt.cpan.org/NoAuth/Bugs.html?Dist=MooX-ConfigFromFile>

    *   AnnoCPAN: Annotated CPAN documentation

        <http://annocpan.org/dist/MooX-ConfigFromFile>

    *   CPAN Ratings

        <http://cpanratings.perl.org/d/MooX-ConfigFromFile>

    *   Search CPAN

        <http://search.cpan.org/dist/MooX-ConfigFromFile/>

## LICENSE AND COPYRIGHT

    Copyright 2013-2014 Jens Rehsack.

    This program is free software; you can redistribute it and/or modify it
    under the terms of either: the GNU General Public License as published
    by the Free Software Foundation; or the Artistic License.

    See <http://dev.perl.org/licenses/> for more information.

