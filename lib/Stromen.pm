
use v5.38;
use experimental 'class';

use Stromen::Functional;
use Stromen::Source;
use Stromen::Operation;

class Stromen :isa(Stromen::Source) {
    field $source :param;

    method foreach($f) {
        Stromen::ForEachOperation->new(
            source   => $source,
            consumer => Stromen::Consumer->new( f => $f )
        )->apply;
    }

    method collect($acc) {
        Stromen::CollectOperation->new(
            source      => $source,
            accumulator => $acc
        )->apply;
    }

    method map($f) {
        Stromen->new(
            source => Stromen::MapOperation->new(
                source => $source,
                mapper => Stromen::Mapper->new( f => $f ),
            )
        );
    }

    method peek($f) {
        Stromen->new(
            source => Stromen::PeekOperation->new(
                source   => $source,
                consumer => Stromen::Consumer->new( f => $f ),
            )
        )
    }
}

package Stromen::Collectors {
    sub ToList() { Stromen::Accumulator->new }
    sub JoinWith($sep='') { Stromen::Accumulator->new( finisher => sub (@acc) { join $sep, @acc } ) }

}

__END__
