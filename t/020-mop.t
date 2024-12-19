#!perl

use v5.40;
use experimental qw[ class ];

use Test::More;
use Test::Differences;

use Stream;

use Stream::MOP;

my $src = Stream->new(
    source => Stream::MOP::Operation::ExpandSymbols->new(
        source => Stream::MOP::Source::GlobsFromStash->new( stash => \%Stream:: )
    )
);

$src
->foreach(sub ($g) {
    say $g;
});

done_testing;
