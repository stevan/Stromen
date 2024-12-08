
use v5.40;

use Stream::Functional::Accumulator;

package Stream::Collectors {

    sub ToList { Stream::Functional::Accumulator->new }

    sub JoinWith($, $sep='') {
        Stream::Functional::Accumulator->new(
            finisher => sub (@acc) { join $sep, @acc }
        )
    }

}
