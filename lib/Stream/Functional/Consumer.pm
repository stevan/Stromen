
use v5.40;
use experimental qw[ class ];

class Stream::Functional::Consumer :isa(Stream::Functional) {
    field $f :param;

    method apply ($arg) { $f->($arg); return; }
}
