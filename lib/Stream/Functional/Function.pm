
use v5.40;
use experimental qw[ class ];

class Stream::Functional::Function :isa(Stream::Functional) {
    field $f :param;

    method apply ($arg) { return $f->($arg) }
}
