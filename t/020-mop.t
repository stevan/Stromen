#!perl

use v5.40;
use experimental qw[ class ];

use Test::More;
use Test::Differences;

use Stream;

use Stream::MOP;

my $src = Stream->new(
    source => Stream::MOP::Operation::ExpandSymbols->new(
        slots  => [qw[ CODE HASH ARRAY ]],
        source => Stream::MOP::Operation::WalkSymbolTable->new(
            source => Stream::MOP::Source::GlobsFromStash->new( stash => \%Stream:: )
        )
    )
);

$src->foreach(sub ($g) {
    isa_ok($g, 'Stream::MOP::Symbol');
    like($g->to_string, qr/^[&@%]Stream\:\:/, '... everything is from Stream::');
});

done_testing;
