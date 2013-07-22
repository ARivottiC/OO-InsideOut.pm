#!/usr/bin/perl -I../lib
package Test::A;

use strict;
use warnings;

use OO::InsideOut qw(register id);
use Data::Dumper;

OO::InsideOut::register \my %Name;

sub name { 
    my $self = shift;
    my $id   = id $self;

    scalar @_
        and $Name{ $id } = shift;

    return $Name{ $id };
}

1;
