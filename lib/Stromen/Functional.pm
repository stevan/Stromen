
use v5.38;
use experimental 'class';

class Stromen::Functional {
    method apply;
}

class Stromen::Consumer :isa(Stromen::Functional) {
    field $f :param;

    method apply(@args) { $f->(@args); return; }
}

class Stromen::Predicate :isa(Stromen::Functional) {
    field $f :param;

    method apply(@args) { return !! $f->(@args) }
}

class Stromen::Mapper :isa(Stromen::Functional) {
    field $f :param;

    method apply(@args) { return $f->(@args) }
}

class Stromen::Accumulator :isa(Stromen::Functional) {
    field $finisher :param;
    field @acc;

    method apply(@args) { push @acc => @args; return; }

    method result { $finisher ? $finisher->( @acc ) : @acc }
}

__END__
