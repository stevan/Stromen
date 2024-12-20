#!perl

use v5.40;
use experimental qw[ class ];

use Test::More;
use Test::Differences;

use Stream;

use Stream::MOP;


my $src = Stream->new(
    source => Stream::MOP::Source::GlobsFromStash->new( stash => \%Stream:: )
)->recurse(
    sub ($c) { $c->is_stash },
    sub ($c) { Stream::MOP::Source::GlobsFromStash->new( stash => $c->get_slot_value('HASH') ) }
);

$src
->flatten(sub ($g) { $g->get_all_symbols(qw[ CODE HASH ARRAY ]) })
->foreach(sub ($s) {
    isa_ok($s, 'Stream::MOP::Symbol');
    like($s->to_string, qr/^[&@%]Stream\:\:/, '... everything is from Stream::');
});

done_testing;

__DATA__
