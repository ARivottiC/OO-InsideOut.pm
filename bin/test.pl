#!/usr/bin/perl -I../lib -I./

use Test::B;
use FieldHash;

use strict;
use warnings;

use threads;
use threads::shared;

use POSIX ":sys_wait_h";
use Scalar::Util qw(refaddr);
use Data::Dumper;

my $t1 = Test::B->new();
my $t2 = FieldHash->new();

$t1->name('André');
$t1->surname('Casimiro');
$t2->name('Carlos');
 
print OO::InsideOut::Dumper( $t1 );

threads->new( 
    sub { 
        print 'THREADS T1: ', $t1->name, "\n";
        print 'THREADS T2: ', $t2->name, "\n";
    },
)->join();

#my $s1 = shared_clone( $t1 );
#my $s2 = shared_clone( $t2 );

threads->new( 
    sub { 
        print 'SHARED T1: ', $t1->name, "\n";
        print 'SHARED T2: ', $t2->name, "\n";
    },
)->join();

my $child = fork();
if ( $child ) {
    $t1->name('zbr');
    print 'FORK T1: ', $t1->name, "\n";
    print 'FORK T2: ', $t2->name, "\n";

    exit 0;
}

my $kid;
do {
    $kid = waitpid(-1, WNOHANG);
} while $kid > 0;

print 'FINISH: T1', $t1->name, "\n";
print 'FINISH: T2', $t2->name, "\n";

print Dumper( $Test::B::Register );

1;
