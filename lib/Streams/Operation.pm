
use v5.40;
use experimental qw[ class ];

class Streams::Operation {}

class Streams::Operation::Node :isa(Streams::Operation) {
    method     next { ... }
    method has_next { ... }
}

class Streams::Operation::Terminal :isa(Streams::Operation) {
    method apply { ... }
}
