
use v5.40;
use experimental qw[ class ];

class Stream::Functional::Accumulator :isa(Stream::Functional) {
    field $finisher :param = undef;
    field @acc;

    method apply ($arg) { push @acc => $arg; return; }

    method result { $finisher ? $finisher->( @acc ) : @acc }
}
