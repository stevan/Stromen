
use v5.40;
use experimental qw[ class ];

class Stream::Source::FromSupplier :isa(Stream::Source) {
    field $supplier :param :reader;

    method next { $supplier->apply }
    method has_next { true }
}
