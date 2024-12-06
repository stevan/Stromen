#!perl

use v5.40;
use experimental qw[ class ];

use Streams;

my $source = Streams::Source::FromArray->new( array => [ 1 .. 16 ] );
my $stream = Streams::Stream->new( source => $source );

my @x = $stream
    ->peek(sub ($x) { say "!! Before Grep: $x " })
    ->grep(sub ($x) { ($x % 2) == 0 })
    ->peek(sub ($x) { say "!! After Grep: $x " })
    ->map(sub ($x) { $x * $x })
    ->peek(sub ($x) { say "!! After Map: $x " })
    ->collect( Streams::Collectors->ToList )
;


say "RESULTS: ", join ', ' => @x;
















