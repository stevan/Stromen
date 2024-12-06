
use v5.40;
use experimental qw[ class ];

class Streams::Source::FromArray :isa(Streams::Source) {
    field $array :param :reader;

    field $next :reader;

    method has_next {
        return false unless @$array;
        $next = shift @$array;
        return true;
    }
}
