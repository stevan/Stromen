
use v5.40;
use experimental qw[ class ];

class Streams::Stream {
    field $source :param :reader;

    field $prev :reader :param = undef;
    field $next :reader;

    ADJUST { $prev->set_next( $self ) }

    method is_head { not defined $prev }

    method set_next ($n) { $next = $n }

    ## -------------------------------------------------------------------------
    ## Terminals
    ## -------------------------------------------------------------------------

    method reduce ($init, $f) {
        Streams::Operation::Reduce->new(
            source  => $source,
            initial => $init,
            reducer => blessed $f ? $f : Streams::Functional::Reducer->new(
                f => $f
            )
        )->apply
    }

    method foreach ($f) {
        Streams::Operation::ForEach->new(
            source   => $source,
            consumer => blessed $f ? $f : Streams::Functional::Consumer->new(
                f => $f
            )
        )->apply
    }

    method collect ($acc) {
        Streams::Operation::Collect->new(
            source      => $source,
            accumulator => $acc
        )->apply
    }

    method match ($matcher) {
        Streams::Operation::Match->new(
            matcher  => $source,
            source   => $self,
        )->apply
    }

    ## -------------------------------------------------------------------------
    ## Operations
    ## -------------------------------------------------------------------------

    method take_until ($f) {
        Streams::Stream->new(
            prev   => $self,
            source => Streams::Operation::TakeUntil->new(
                source    => $source,
                predicate => blessed $f ? $f : Streams::Functional::Predicate->new(
                    f => $f
                )
            )
        )
    }

    method when ($predicate, $f) {
        Streams::Stream->new(
            prev   => $self,
            source => Streams::Operation::When->new(
                source    => $source,
                consumer  => blessed $f ? $f : Streams::Functional::Consumer->new(
                    f => $f
                ),
                predicate => blessed $predicate
                    ? $predicate
                    : Streams::Functional::Predicate->new( f => $predicate )
            )
        )
    }

    method map ($f) {
        Streams::Stream->new(
            prev   => $self,
            source => Streams::Operation::Map->new(
                source => $source,
                mapper => blessed $f ? $f : Streams::Functional::Mapper->new(
                    f => $f
                )
            )
        )
    }

    method grep ($f) {
        Streams::Stream->new(
            prev   => $self,
            source => Streams::Operation::Grep->new(
                source    => $source,
                predicate => blessed $f ? $f : Streams::Functional::Predicate->new(
                    f => $f
                )
            )
        )
    }

    method peek ($f) {
        Streams::Stream->new(
            prev   => $self,
            source => Streams::Operation::Peek->new(
                source   => $source,
                consumer => blessed $f ? $f : Streams::Functional::Consumer->new(
                    f => $f
                )
            )
        )
    }

    method buffered {
        Streams::Stream->new(
            prev   => $self,
            source => Streams::Operation::Buffered->new(
                source => $source
            )
        )
    }
}
