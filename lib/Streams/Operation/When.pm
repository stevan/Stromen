
use v5.40;
use experimental qw[ class ];

class Streams::Operation::When :isa(Streams::Operation::Node) {
    field $source    :param;
    field $consumer  :param;
    field $predicate :param;

    method next {
        my $val = $source->next;
        $consumer->apply( $val ) if $predicate->apply( $val );
        return $val;
    }

    method has_next { $source->has_next }
}
