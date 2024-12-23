
use v5.40;
use experimental qw[ class ];

class Stream::UI::Source::EventsFromTTY :isa(Stream::Source) {
    field $tty  :param :reader;
    field $exit :param :reader;

    field $next :reader;

    method has_next {
        $next = $tty->get_next_event;
        return !$exit->apply( $next );
    }
}
