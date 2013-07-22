#!/usr/bin/perl -I../lib
package Test::B;

use strict;
use warnings;

use base qw(
    Test::C 
    Test::A 
    Test
);

use OO::InsideOut qw(id register);
use Data::Dumper;

our $Register = OO::InsideOut::register \my %Surname;

sub surname { 
    my $self = shift;
    my $id   = id $self;

    scalar @_
        and $Surname{ $id } = shift;

    return $Surname{ $id };
}

1;
