
use v5.40;
use experimental qw[ class ];

class Streams::Functional::Reducer :isa(Streams::Functional) {
    field $f :param;

    method apply ($arg, $acc) { $f->($arg, $acc) }
}
