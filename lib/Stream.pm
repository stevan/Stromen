
use v5.40;
use experimental qw[ class ];

use Stream::Functional;
use Stream::Functional::Accumulator;
use Stream::Functional::Consumer;
use Stream::Functional::Mapper;
use Stream::Functional::Predicate;
use Stream::Functional::Reducer;

use Stream::Operation;
use Stream::Operation::Buffered;
use Stream::Operation::Collect;
use Stream::Operation::ForEach;
use Stream::Operation::Grep;
use Stream::Operation::Map;
use Stream::Operation::Match;
use Stream::Operation::Peek;
use Stream::Operation::Reduce;
use Stream::Operation::TakeUntil;
use Stream::Operation::When;

use Stream::Collectors;

use Stream::Match;
use Stream::Match::Builder;

use Stream::Source;
use Stream::Source::FromArray;

class Stream {
    field $source :param :reader;

    field $prev :reader :param = undef;
    field $next :reader;

    ADJUST { $prev->set_next( $self ) if $prev }

    method is_head { not defined $prev }

    method set_next ($n) { $next = $n }

    ## -------------------------------------------------------------------------
    ## Terminals
    ## -------------------------------------------------------------------------

    method reduce ($init, $f) {
        Stream::Operation::Reduce->new(
            source  => $source,
            initial => $init,
            reducer => blessed $f ? $f : Stream::Functional::Reducer->new(
                f => $f
            )
        )->apply
    }

    method foreach ($f) {
        Stream::Operation::ForEach->new(
            source   => $source,
            consumer => blessed $f ? $f : Stream::Functional::Consumer->new(
                f => $f
            )
        )->apply
    }

    method collect ($acc) {
        Stream::Operation::Collect->new(
            source      => $source,
            accumulator => $acc
        )->apply
    }

    method match ($matcher) {
        Stream::Operation::Match->new(
            matcher  => $source,
            source   => $self,
        )->apply
    }

    ## -------------------------------------------------------------------------
    ## Operations
    ## -------------------------------------------------------------------------

    method take_until ($f) {
        Stream->new(
            prev   => $self,
            source => Stream::Operation::TakeUntil->new(
                source    => $source,
                predicate => blessed $f ? $f : Stream::Functional::Predicate->new(
                    f => $f
                )
            )
        )
    }

    method when ($predicate, $f) {
        Stream->new(
            prev   => $self,
            source => Stream::Operation::When->new(
                source    => $source,
                consumer  => blessed $f ? $f : Stream::Functional::Consumer->new(
                    f => $f
                ),
                predicate => blessed $predicate
                    ? $predicate
                    : Stream::Functional::Predicate->new( f => $predicate )
            )
        )
    }

    method map ($f) {
        Stream->new(
            prev   => $self,
            source => Stream::Operation::Map->new(
                source => $source,
                mapper => blessed $f ? $f : Stream::Functional::Mapper->new(
                    f => $f
                )
            )
        )
    }

    method grep ($f) {
        Stream->new(
            prev   => $self,
            source => Stream::Operation::Grep->new(
                source    => $source,
                predicate => blessed $f ? $f : Stream::Functional::Predicate->new(
                    f => $f
                )
            )
        )
    }

    method peek ($f) {
        Stream->new(
            prev   => $self,
            source => Stream::Operation::Peek->new(
                source   => $source,
                consumer => blessed $f ? $f : Stream::Functional::Consumer->new(
                    f => $f
                )
            )
        )
    }

    method buffered {
        Stream->new(
            prev   => $self,
            source => Stream::Operation::Buffered->new(
                source => $source
            )
        )
    }
}
