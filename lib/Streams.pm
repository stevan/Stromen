
use v5.40;
use experimental qw[ class ];

use Streams::Functional;
use Streams::Functional::Accumulator;
use Streams::Functional::Consumer;
use Streams::Functional::Mapper;
use Streams::Functional::Predicate;
use Streams::Functional::Reducer;

use Streams::Operation;
use Streams::Operation::Buffered;
use Streams::Operation::Collect;
use Streams::Operation::ForEach;
use Streams::Operation::Grep;
use Streams::Operation::Map;
use Streams::Operation::Match;
use Streams::Operation::Peek;
use Streams::Operation::Reduce;
use Streams::Operation::TakeUntil;
use Streams::Operation::When;

use Streams::Collectors;

use Streams::Match;
use Streams::Match::Builder;

use Streams::Source;
use Streams::Source::FromArray;

use Streams::Stream;

class Streams {

}
