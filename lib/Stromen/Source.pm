
use v5.38;
use experimental 'class';

class Stromen::Source {
    method next;
    method has_next;
}

class Stromen::ArraySource :isa(Stromen::Source) {
    field $values :param;
    field $index = 0;

    method next() { $values->[$index++] }
    method has_next() { $index < scalar @$values }
}

class Stromen::CallbackSource :isa(Stromen::Source) {
    field $f :param;

    method next() { $f->() }
    method has_next() { 1 }
}

__END__
