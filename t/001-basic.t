#!perl

use v5.40;
use experimental qw[ class ];

use Stream;

my @x = Stream->new(
        source => Stream::Source::FromArray->new( array => [ 1 .. 16 ] )
    )
    ->peek(sub ($x) { say "!! Before Grep: $x " })
    ->grep(sub ($x) { ($x % 2) == 0 })
    ->peek(sub ($x) { say "!! After Grep: $x " })
    ->map(sub ($x) { $x * $x })
    ->peek(sub ($x) { say "!! After Map: $x " })
    ->collect( Stream::Collectors->ToList )
;


say "RESULTS: ", join ', ' => @x;
















