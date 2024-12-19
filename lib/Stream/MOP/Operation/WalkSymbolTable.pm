
use v5.40;
use experimental qw[ class ];

class Stream::MOP::Operation::WalkSymbolTable :isa(Stream::Operation::Node) {
    field $source  :param :reader;
    field $exclude :param :reader = undef;

    field $next;
    field @stack;

    ADJUST {
        push @stack => $source;
    }

    method next { $next }

    method has_next {
        while (@stack) {
            if ($stack[-1]->has_next) {
                my $candidate = $stack[-1]->next;
                if ( $candidate->is_stash ) {
                    next if $exclude && $exclude->apply($candidate);

                    push @stack => Stream::MOP::Source::GlobsFromStash->new(
                        stash => $candidate->get_slot_value('HASH')
                    );
                }

                $next = $candidate;
                return true;
            }
            else {
                pop @stack;
                next;
            }
        }
        return false;
    }

}
