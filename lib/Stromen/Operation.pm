
use v5.38;
use experimental 'class';

class Stromen::Operation {
    method next;
    method has_next;
}

class Stromen::Terminal {
    method apply;
}

class Stromen::ForEachOperation :isa(Stromen::Terminal) {
    field $source   :param;
    field $consumer :param;

    method apply {
        while ($source->has_next) {
            $consumer->apply($source->next);
        }
        return;
    }
}

class Stromen::CollectOperation :isa(Stromen::Terminal) {
    field $source      :param;
    field $accumulator :param;

    method apply {
        while ($source->has_next) {
            $accumulator->apply($source->next);
        }
        return $accumulator->result;
    }
}

class Stromen::MapOperation :isa(Stromen::Operation) {
    field $source :param;
    field $mapper :param;

    method next { $mapper->apply( $source->next ) }
    method has_next { $source->has_next }
}

class Stromen::PeekOperation :isa(Stromen::Operation) {
    field $source   :param;
    field $consumer :param;

    method next {
        my $val = $source->next;
        $consumer->apply( $val );
        return $val;
    }

    method has_next { $source->has_next }
}

__END__
