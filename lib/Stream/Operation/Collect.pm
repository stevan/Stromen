
use v5.40;
use experimental qw[ class ];

class Stream::Operation::Collect :isa(Stream::Operation::Terminal) {
    field $source      :param;
    field $accumulator :param;

    method apply {
        while ($source->has_next) {
            $accumulator->apply($source->next);
        }
        return $accumulator->result;
    }
}

