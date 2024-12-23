#!perl

use v5.40;
use experimental qw[ class ];

use Test::More;
use Test::Differences;

use Stream;
use Stream::UI;

class Stream::UI::Functional::InputAccumulator :isa(Stream::Functional) {
    field @buffer;

    method apply ($e) {
        if ($e isa Stream::UI::Event::KeyPress) {
            push @buffer => $e->value;
        }
        elsif ($e isa Stream::UI::Event::Backspace) {
            pop @buffer;
        }
    }

    method result {
        return join '' => @buffer;
    }
}

class Stream::UI::Functional::InputEcho :isa(Stream::Functional) {
    field $tty :param :reader;

    method apply ($e) {
        $tty->print($e->value) if $e isa Stream::UI::Event::KeyPress;
        $tty->print("\b \b")   if $e isa Stream::UI::Event::Backspace;
    }
}

class Stream::UI::Functional::EOL :isa(Stream::Functional) {
    method apply ($e) { $e isa Stream::UI::Event::Enter }
}

my $tty = Stream::UI::TTY->new;

my $s = Stream::UI->new(
    source => Stream::UI::Source::EventsFromTTY->new(
        tty  => $tty,
        exit => Stream::UI::Functional::EOL->new
    )
);

$tty->setup->print("> ");

my $result = $s
->peek    ( Stream::UI::Functional::InputEcho->new( tty => $tty ) )
->collect ( Stream::UI::Functional::InputAccumulator->new )
;
say "\nGOT: $result";

END { $tty->teardown }



done_testing;
