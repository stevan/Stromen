
use v5.40;
use experimental qw[ class ];

class Streams::Functional::Consumer :isa(Streams::Functional) {
    field $f :param;

    method apply ($arg) { $f->($arg); return; }
}
