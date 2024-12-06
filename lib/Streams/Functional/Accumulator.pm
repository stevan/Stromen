
use v5.40;
use experimental qw[ class ];

class Streams::Functional::Accumulator :isa(Streams::Functional) {
    field $finisher :param = undef;
    field @acc;

    method apply ($arg) { push @acc => $arg; return; }

    method result { $finisher ? $finisher->( @acc ) : @acc }
}
