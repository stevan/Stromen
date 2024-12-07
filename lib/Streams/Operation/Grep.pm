
use v5.40;
use experimental qw[ class ];

class Streams::Operation::Grep :isa(Streams::Operation::Node) {
    field $source    :param;
    field $predicate :param;

    field $next :reader;

    method has_next {
        return false unless $source->has_next;
        $next = $source->next;
        until ($predicate->apply($next)) {
            return false unless $source->has_next;
            $next = $source->next;
        }
        return true;
    }
}