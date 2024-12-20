#!perl

use v5.40;
use experimental qw[ class ];

use Test::More;
use Test::Differences;

use Stream;

subtest '.... flatten test' => sub {
    my @results = Stream
        ->of(map { [0 .. 5] } 0 .. 5)
        ->flatten(sub ($a) { @$a })
        ->collect( Stream::Collectors->ToList );

    eq_or_diff(
        \@results,
        [ map { 0 .. 5 } 0 .. 5 ],
        '... got the expected flattened results'
    )
};

done_testing;
