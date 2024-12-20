#!perl

use v5.40;
use experimental qw[ class ];

use Test::More;
use Test::Differences;

use Stream;

use Stream::MOP;


my $src = Stream->new(
    source => Stream::MOP::Operation::WalkSymbolTable->new(
        source => Stream::MOP::Source::GlobsFromStash->new( stash => \%Stream:: )
    )
);

$src
->flatten(sub ($g) { $g->get_all_symbols(qw[ CODE HASH ARRAY ]) })
#->peek(sub ($s) { diag $s })
->foreach(sub ($s) {
    isa_ok($s, 'Stream::MOP::Symbol');
    like($s->to_string, qr/^[&@%]Stream\:\:/, '... everything is from Stream::');
});

done_testing;
