
use v5.40;
use experimental qw[ class ];

use Stream::Functional;
use Stream::Functional::Accumulator;
use Stream::Functional::Consumer;
use Stream::Functional::Function;
use Stream::Functional::Predicate;
use Stream::Functional::Reducer;
use Stream::Functional::Supplier;

use Stream::Operation;
use Stream::Operation::Buffered;
use Stream::Operation::Collect;
use Stream::Operation::ForEach;
use Stream::Operation::Grep;
use Stream::Operation::Map;
use Stream::Operation::Match;
use Stream::Operation::Peek;
use Stream::Operation::Reduce;
use Stream::Operation::Take;
use Stream::Operation::TakeUntil;
use Stream::Operation::When;

use Stream::Collectors;

use Stream::Match;
use Stream::Match::Builder;

use Stream::Source;
use Stream::Source::FromArray;
use Stream::Source::FromIterator;
use Stream::Source::FromRange;
use Stream::Source::FromSupplier;

class Stream {
    field $source :param :reader;

    field $prev :param = undef;
    field $next;

    ADJUST { $prev->set_next( $self ) if $prev }

    ## -------------------------------------------------------------------------
    ## Additional Constructors
    ## -------------------------------------------------------------------------

    # ->of( @list )
    # ->of( [ @list ] )
    sub of ($, @list) {
        @list = $list[0]->@*
            if scalar @list == 1 && ref $list[0] eq 'ARRAY';
        Stream->new(
            source => Stream::Source::FromArray->new( array => \@list )
        )
    }

    # Infinite Generator
    # ->generate(sub { ... })
    # ->generate(Supplier->new)
    sub generate ($, $f) {
        Stream->new(
            source => Stream::Source::FromSupplier->new(
                supplier => blessed $f ? $f : Stream::Functional::Supplier->new(
                    f => $f
                )
            )
        )
    }

    # Range iterator
    # ->range($start, $end)
    # ->range($start, $end, $step)
    sub range ($, $start, $end, $step=1) {
        Stream->new(
            source => Stream::Source::FromRange->new(
                start => $start,
                end   => $end,
                step  => $step,
            )
        )
    }

    # Infinite Iterator
    # ->iterate($seed, sub { ... })
    # ->iterate($seed, Function->new)
    # Finite Iterator
    # ->iterate($seed, sub { ... }, sub { ... })
    # ->iterate($seed, Predicate->new, Function->new)
    sub iterate ($, $seed, @args) {
        my ($next, $has_next);

        if (scalar @args == 1) {
            $next = blessed $args[0] ? $args[0]
                    : Stream::Functional::Function->new( f => $args[0] );
        }
        else {
            $has_next = blessed $args[0] ? $args[0]
                      : Stream::Functional::Predicate->new( f => $args[0] );
            $next     = blessed $args[1] ? $args[1]
                      : Stream::Functional::Function->new( f => $args[1] );
        }

        Stream->new(
            source => Stream::Source::FromIterator->new(
                seed     => $seed,
                next     => $next,
                has_next => $has_next,
            )
        )
    }

    ## -------------------------------------------------------------------------
    ## Navigation
    ## -------------------------------------------------------------------------

    method is_head { not defined $prev }
    method set_next ($n) { $next = $n }

    method next { $next }
    method prev { $prev }

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

    method take ($amount) {
        Stream->new(
            prev   => $self,
            source => Stream::Operation::Take->new(
                source => $source,
                amount => $amount,
            )
        )
    }

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
                mapper => blessed $f ? $f : Stream::Functional::Function->new(
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
