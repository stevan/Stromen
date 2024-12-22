#!perl

use v5.40;
use experimental qw[ class ];

use Test::More;
use Test::Differences;

use Stream;
use Stream::IO;

open my $fh, '<', __FILE__;

my $s = Stream::IO->bytes( $fh, size => 8 )->foreach(sub ($x) {
    ok(length($x) <= 8, '... nothing is longer than 8 characters')
});

done_testing;
