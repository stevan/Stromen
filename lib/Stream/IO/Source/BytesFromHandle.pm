
use v5.40;
use experimental qw[ class ];

class Stream::IO::Source::BytesFromHandle :isa(Stream::Source) {
    field $fh   :param :reader;
    field $size :param :reader = 1;

    field $next :reader;

    method has_next {
        my $result = sysread( $fh, $next, $size );
        return false if $result == 0;
        return true;
    }
}
