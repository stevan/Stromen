
use v5.40;
use experimental qw[ class ];

class Stream::Source::FromArray :isa(Stream::Source) {
    field $array :param :reader;

    field $next :reader;

    method has_next {
        return false unless @$array;
        $next = shift @$array;
        return true;
    }
}
