
use v5.40;
use experimental qw[ class ];

class Streams::Operation::Collect :isa(Streams::Operation::Terminal) {
    field $source      :param;
    field $accumulator :param;

    method apply {
        while ($source->has_next) {
            $accumulator->apply($source->next);
        }
        return $accumulator->result;
    }
}

