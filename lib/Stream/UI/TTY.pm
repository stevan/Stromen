
use v5.40;
use experimental qw[ class ];

use Term::ReadKey ();

use Stream::UI::Event;
use Stream::UI::Event::ArrowKey;
use Stream::UI::Event::Backspace;
use Stream::UI::Event::Enter;
use Stream::UI::Event::EscapeKey;
use Stream::UI::Event::KeyPress;
use Stream::UI::Event::Mouse;

use Stream::UI::TTY::MouseTracking;

class Stream::UI::TTY {
    use constant DEBUG => $ENV{DEBUG_TTY} // 0;
    sub LOG (@msg) { warn @msg, "\n" }

    field $stdin     :param :reader = *STDIN;
    field $stdout    :param :reader = *STDOUT;
    field $use_mouse :param :reader = undef;

    field $mouse_enabled = false;

    ADJUST {
        if ($use_mouse) {
            die "Unknown mouse tracking: $use_mouse"
                unless $use_mouse == Stream::UI::TTY::MouseTracking->ON_BUTTON_PRESS
                    || $use_mouse == Stream::UI::TTY::MouseTracking->EVENTS_ON_BUTTON_PRESS
                    || $use_mouse == Stream::UI::TTY::MouseTracking->ALL_EVENTS;
        }
    }

    method say   (@msg) { say   $stdout @msg }
    method print (@msg) { print $stdout @msg }

    method setup {
        Term::ReadKey::ReadMode( 'cbreak', $stdin );
        $self->enable_mouse_tracking if $use_mouse;
        $self;
    }

    method teardown {
        Term::ReadKey::ReadMode( 'restore', $stdin );
        $self->disable_mouse_tracking if $mouse_enabled;
        $self;
    }

    method enable_mouse_tracking {
        return if $mouse_enabled;
        DEBUG && LOG "Enabling Mouse";
        binmode($stdin, ":encoding(UTF-8)");
        print $stdout "\e[?${use_mouse};1006h";
        $mouse_enabled = true;
        return;
    }

    method disable_mouse_tracking {
        return if !$mouse_enabled;
        DEBUG && LOG "Disabling Mouse";
        print $stdout "\e[?${use_mouse};1006l";
        $mouse_enabled = false;
        return
    }

    method get_next_event {
        my $key = Term::ReadKey::ReadKey( 0, $stdin );
        die "WTF $key" unless $key;

        if ($key eq "\e") {
            DEBUG && LOG "Found escape code";
            my $bracket = Term::ReadKey::ReadKey( -1, $stdin );
            if (!$bracket || $bracket ne '[') {
                return Stream::UI::Event::EscapeKey->new;
            }
            else {
                my $next = Term::ReadKey::ReadKey( 0, $stdin );
                if ($next =~ /^([ABCD])$/) {
                    return Stream::UI::Event::ArrowKey->new( value => "\e[${1}" );
                }
                elsif ($next eq '<') {
                    DEBUG && LOG "Found mouse code";

                    my ($event_type, $x, $y, $pressed) = ('', '', '', false);
                    my $temp;
                    while (($temp = Term::ReadKey::ReadKey( 0, $stdin )) =~ m/^[0-9]$/) {
                        $event_type .= $temp;
                    }
                    DEBUG && LOG "Event type: $event_type";
                    die "WTF temp($temp)" unless $temp eq ';';
                    while (($temp = Term::ReadKey::ReadKey( 0, $stdin )) =~ m/^[0-9]$/) {
                        $x .= $temp;
                    }
                    DEBUG && LOG "x: $x";
                    die "WTF temp($temp)" unless $temp eq ';';
                    while (($temp = Term::ReadKey::ReadKey( 0, $stdin )) =~ m/^[0-9]$/) {
                        $y .= $temp;
                    }
                    DEBUG && LOG "y: $y";
                    die "WTF temp($temp)" unless $temp =~ /^[mM]$/;
                    $pressed = true if $temp eq 'm';
                    DEBUG && LOG "Pressed: ",$pressed ? 'YES' : 'NO';

                    my $button = $event_type & 0x03;
                    if ($button == 3) {
                        $button = 0;
                    } else {
                        if ($event_type & 0x04) {
                            $button += 4;
                        } else {
                            $button += 1;
                        }
                    }
                    DEBUG && LOG "button: $button";

                    return Stream::UI::Event::Mouse->new(
                        button  => $button,
                        x       => $x,
                        y       => $y,
                        pressed => $pressed,
                    );
                }
                else {
                    die "WTF $next";
                    return;
                }
            }
        }
        else {
            DEBUG && LOG "regular key: $key ord(key): ",ord($key);
            return Stream::UI::Event::Enter->new     if $key eq "\n";
            return Stream::UI::Event::Backspace->new if ord($key) == 127;
            return Stream::UI::Event::KeyPress->new( value => $key )
        }
    }

}

