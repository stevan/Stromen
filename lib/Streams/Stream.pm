
use v5.40;
use experimental qw[ class builtin ];
use builtin      qw[ load_module ];

class Streams::Stream :isa(Streams::Source) {
    field $source :param :reader;

    ## -------------------------------------------------------------------------
    ## Source API
    ## -------------------------------------------------------------------------

    method     next { $source->next     }
    method has_next { $source->has_next }

    ## -------------------------------------------------------------------------
    ## Terminals
    ## -------------------------------------------------------------------------

    method reduce ($init, $f) {
        Streams::Operation::Reduce->new(
            source  => $self,
            initial => $init,
            reducer => blessed $f ? $f : Streams::Functional::Reducer->new(
                f => $f
            )
        )->apply
    }

    method foreach ($f) {
        Streams::Operation::ForEach->new(
            source   => $self,
            consumer => blessed $f ? $f : Streams::Functional::Consumer->new(
                f => $f
            )
        )->apply
    }

    method collect ($acc) {
        Streams::Operation::Collect->new(
            source      => $self,
            accumulator => $acc
        )->apply
    }

    method match ($matcher) {
        Streams::Operation::Match->new(
            matcher  => $matcher,
            source   => $self,
        )->apply
    }

    ## -------------------------------------------------------------------------
    ## Operations
    ## -------------------------------------------------------------------------

    method take_until ($f) {
        Streams::Stream->new( source => Streams::Operation::TakeUntil->new(
            source    => $self,
            predicate => blessed $f ? $f : Streams::Functional::Predicate->new(
                f => $f
            )
        ))
    }

    method when ($predicate, $f) {
        Streams::Stream->new( source => Streams::Operation::When->new(
            source    => $self,
            consumer  => blessed $f ? $f : Streams::Functional::Consumer->new(
                f => $f
            ),
            predicate => blessed $predicate
                ? $predicate
                : Streams::Functional::Predicate->new( f => $predicate )
        ))
    }

    method map ($f) {
        Streams::Stream->new( source => Streams::Operation::Map->new(
            source => $self,
            mapper => blessed $f ? $f : Streams::Functional::Mapper->new(
                f => $f
            )
        ))
    }

    method grep ($f) {
        Streams::Stream->new( source => Streams::Operation::Grep->new(
            source    => $self,
            predicate => blessed $f ? $f : Streams::Functional::Predicate->new(
                f => $f
            )
        ))
    }

    method peek ($f) {
        Streams::Stream->new( source => Streams::Operation::Peek->new(
            source   => $self,
            consumer => blessed $f ? $f : Streams::Functional::Consumer->new(
                f => $f
            )
        ))
    }

    method buffered {
        Streams::Stream->new( source => Streams::Operation::Buffered->new(
            source => $self
        ))
    }
}
