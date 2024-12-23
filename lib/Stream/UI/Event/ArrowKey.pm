
use v5.40;
use experimental qw[ class ];

class Stream::UI::Event::ArrowKey :isa(Stream::UI::Event) {
    field $value :param :reader;

    method is_up    { $value eq "\e[A" }
    method is_down  { $value eq "\e[B" }
    method is_right { $value eq "\e[C" }
    method is_left  { $value eq "\e[D" }

    method to_string {
        sprintf '%s:(%s)' => $self->SUPER::to_string,
            ($self->is_up    ? '▲' :
             $self->is_down  ? '▼' :
             $self->is_right ? '▶' :
             $self->is_left  ? '◀' : die "WTF!")
    }
}
