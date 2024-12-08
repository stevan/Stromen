
use v5.40;
use experimental qw[ class ];

class Stream::Functional::Supplier :isa(Stream::Functional) {
    field $f :param;

    method apply () { $f->() }
}
