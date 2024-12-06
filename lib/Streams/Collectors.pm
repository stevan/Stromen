
use v5.40;

use Streams::Functional::Accumulator;

package Streams::Collectors {

    sub ToList { Streams::Functional::Accumulator->new }

    sub JoinWith($, $sep='') {
        Streams::Functional::Accumulator->new(
            finisher => sub (@acc) { join $sep, @acc }
        )
    }

}
