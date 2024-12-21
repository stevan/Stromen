
use v5.40;
use experimental qw[ class ];

class Stream::Source::FromTime :isa(Stream::Source) {
    method     next { time() }
    method has_next { true   }
}

class Stream::Source::FromTime::Monotonic :isa(Stream::Source::FromTime) {
    my $MONOTONIC = Time::HiRes::CLOCK_MONOTONIC();
    method next { Time::HiRes::clock_gettime( $MONOTONIC ) }
}

class Stream::Source::FromTime::DeltaTime :isa(Stream::Source::FromTime) {

    field $prev;
    ADJUST { $prev = [ Time::HiRes::gettimeofday() ] }

    method next {
        my $now   = [ Time::HiRes::gettimeofday() ];
        my $since = Time::HiRes::tv_interval( $prev, $now );
        $prev     = $now;
        return $since;
    }
}
