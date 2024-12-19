
use v5.40;
use experimental qw[ class ];

use Stream::MOP::Glob;

class Stream::MOP::Source::GlobsFromStash :isa(Stream::Source) {
    field $stash :param :reader;

    field @globs;
    ADJUST {
        @globs = map  { $stash->{$_} }
                 sort { $a cmp $b    }
                      keys $stash->%*;
    }

    method     next { Stream::MOP::Glob->new( glob => \(shift @globs) ) }
    method has_next { !! scalar @globs }
}
