
use v5.40;
use experimental qw[ class ];

class Stream::Functional::Reducer :isa(Stream::Functional) {
    field $f :param;

    method apply ($arg, $acc) { $f->($arg, $acc) }
}
