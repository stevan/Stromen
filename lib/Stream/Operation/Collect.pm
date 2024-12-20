
use v5.40;
use experimental qw[ class ];

class Stream::Operation::Collect :isa(Stream::Operation::Terminal) {
    field $source      :param;
    field $accumulator :param;

    method apply {
        #say "applying Collect ...";
        while ($source->has_next) {
            my $next = $source->next;
            #say "Calling accumulator apply on $next";
            $accumulator->apply($next);
        }
        #say "Got all results ....";
        return $accumulator->result;
    }
}

