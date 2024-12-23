#!perl

use v5.40;
use experimental qw[ class ];

use Test::More;
use Test::Differences;

use Stream;
use Stream::UI;


my $tty = Stream::UI::TTY->new(
    use_mouse => Stream::UI::TTY::MouseTracking->ALL_EVENTS
);

my $s = Stream::UI->new(
    source => Stream::UI::Source::EventsFromTTY->new(
        tty => $tty
    )
);

$tty->setup;

$s->foreach(sub ($e) {
    say $e->to_string;
});

$tty->teardown;



done_testing;
