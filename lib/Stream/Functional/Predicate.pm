
use v5.40;
use experimental qw[ class ];

class Stream::Functional::Predicate :isa(Stream::Functional) {
    field $f :param;

    method apply ($arg) { return !! $f->($arg) }
}
