
use v5.40;
use experimental qw[ class ];

class Stream::UI::Event::Mouse :isa(Stream::UI::Event) {
    field $button  :param :reader;
    field $x       :param :reader;
    field $y       :param :reader;
    field $pressed :param :reader;

    method xy { $x, $y }

    method to_string {
        sprintf '%s:{ btn:(%s) x:(%d) y:(%d) %s }' => $self->SUPER::to_string,
            $button, $x, $y, ($pressed ? '●' : '○')
    }
}
