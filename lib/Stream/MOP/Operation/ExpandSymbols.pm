
use v5.40;
use experimental qw[ class ];

class Stream::MOP::Operation::ExpandSymbols :isa(Stream::Operation::Node) {
    field $source :param :reader;
    field $slots  :param :reader = [];

    field @stack;

    method next {
        my $x = shift @stack;
        #say "NEXT: $x";
        return $x;
    }

    method has_next {

        #say "!!!!!!! has_next called ....";

        return true if @stack;
        #say "!!!!!!! we don't have a stack ....";

        while ($source->has_next) {
            #say "!!!!!!! source -> has_next is true ....";
            my $next = $source->next;
            #say "!!!!!!! source -> next = [$next]";
            push @stack => $next->get_all_symbols( @$slots );
            #say "STACK: ", join ', ' => @stack;
            return true if @stack;
        }

        #say "No MORE!";
        return false;
    }

}
