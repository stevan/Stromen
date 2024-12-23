
use v5.40;
use experimental qw[ class ];

class Stream::UI::Event::KeyPress :isa(Stream::UI::Event) {
    field $value :param :reader;

    method is_newline { $value eq "\n" }

    method to_string {
        sprintf '%s:(%s)' => $self->SUPER::to_string, $value
    }
}
