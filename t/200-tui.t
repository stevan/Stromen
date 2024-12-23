#!perl

use v5.40;
use experimental qw[ class ];

use Test::More;
use Test::Differences;

use Stream;
use Stream::UI;

class Stream::UI::Functional::LineEditor :isa(Stream::Functional) {
    field $tty    :param :reader;
    field $prompt :param :reader = '> ';

    field @buffer;

    ADJUST {
        $tty->print($prompt);
    }

    method apply ($e) {
        if ($e isa Stream::UI::Event::KeyPress) {
            push @buffer => $e->value;
            $tty->print($e->value);
        }
        elsif ($e isa Stream::UI::Event::Backspace) {
            pop @buffer;
            $tty->print("\b \b");
        }
    }

    method result {
        return join '' => @buffer;
    }
}


my $tty = Stream::UI::TTY->new;

my $s = Stream::UI->new(
    source => Stream::UI::Source::EventsFromTTY->new(
        tty  => $tty,
        exit => Stream::Functional::Predicate->new( f => sub ($e) {
            $e isa Stream::UI::Event::Enter
        })
    )
);

$tty->setup;

my $result = $s->collect( Stream::UI::Functional::LineEditor->new( tty => $tty ) );
say "\nGOT: $result";

END { $tty->teardown }



done_testing;
