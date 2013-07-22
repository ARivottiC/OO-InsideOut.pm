#!/usr/bin/perl -I../lib
package FieldHash;

use strict;
use warnings;

use Hash::Util::FieldHash ();
use Data::Dumper;

Hash::Util::FieldHash::fieldhash my %Data;

sub new {
    my $class = shift;
    my %arg   = @_;

    my $self = bless \(my $o), ref $class || $class;

    $Data{ $self } = { %arg };

    return $self;
}

sub name { 
    my $self = shift;
    my $value = shift;

    $Data{ $self }{'name'} = $value
        if $value;

    return $Data{ $self }{'name'};
}

1;
