
use v5.40;
use experimental qw[ class ];

class Stream::UI::Event {
    use overload '""' => 'to_string';

    field $type :reader;
    ADJUST { $type = (split '::' => __CLASS__)[-1] }

    method to_string { sprintf 'Event[%s]' => $type }
}
