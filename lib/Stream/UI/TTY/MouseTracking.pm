
use v5.40;
use experimental qw[ class ];

class Stream::UI::TTY::MouseTracking {
    use constant ON_BUTTON_PRESS        => 1000;
    use constant EVENTS_ON_BUTTON_PRESS => 1002;
    use constant ALL_EVENTS             => 1003;
}
