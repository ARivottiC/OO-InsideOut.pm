#!/usr/bin/perl -I../lib
package Test;

use strict;
use warnings;

use Data::Dumper;

sub new {
    my $class = shift;
    my %arg   = @_;

    my $self = bless \(my $o), ref $class || $class;

    return $self;
}

1;
