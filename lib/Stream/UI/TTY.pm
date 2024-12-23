
use v5.40;
use experimental qw[ class ];

use Term::ReadKey ();

use Stream::UI::Event;
use Stream::UI::Event::ArrowKey;
use Stream::UI::Event::EscapeKey;
use Stream::UI::Event::KeyPress;
use Stream::UI::Event::Mouse;

use Stream::UI::TTY::MouseTracking;

class Stream::UI::TTY {
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

    method setup {
        Term::ReadKey::ReadMode( 'cbreak', $stdin );
        $self->enable_mouse_tracking if $use_mouse;
    }

    method teardown {
        Term::ReadKey::ReadMode( 'restore', $stdin );
        $self->disable_mouse_tracking if $mouse_enabled;
    }

    method enable_mouse_tracking {
        return if $mouse_enabled;
        #warn "Enabling Mouse";
        binmode($stdin, ":encoding(UTF-8)");
        print $stdout "\e[?${use_mouse};1006h";
        $mouse_enabled = true;
        return;
    }

    method disable_mouse_tracking {
        return if !$mouse_enabled;
        #warn "Disabling Mouse";
        print $stdout "\e[?${use_mouse};1006l";
        $mouse_enabled = false;
        return
    }

    method get_next_event {
        my $key = Term::ReadKey::ReadKey( 0, $stdin );
        die "WTF $key" unless $key;

        if ($key eq "\e") {
            #warn "Found escape code";
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
                    #warn "Found mouse code";

                    my ($event_type, $x, $y, $pressed) = ('', '', '', false);
                    my $temp;
                    while (($temp = Term::ReadKey::ReadKey( 0, $stdin )) =~ m/^[0-9]$/) {
                        $event_type .= $temp;
                    }
                    #warn "Event type: $event_type";
                    die "WTF temp($temp)" unless $temp eq ';';
                    while (($temp = Term::ReadKey::ReadKey( 0, $stdin )) =~ m/^[0-9]$/) {
                        $x .= $temp;
                    }
                    #warn "x: $x";
                    die "WTF temp($temp)" unless $temp eq ';';
                    while (($temp = Term::ReadKey::ReadKey( 0, $stdin )) =~ m/^[0-9]$/) {
                        $y .= $temp;
                    }
                    #warn "y: $y";
                    die "WTF temp($temp)" unless $temp =~ /^[mM]$/;
                    $pressed = true if $temp eq 'm';
                    #warn "Pressed: ",$pressed ? 'YES' : 'NO';

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
                    #warn "button: $button";

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
            #warn "regular key: $key";
            return Stream::UI::Event::KeyPress->new( value => $key )
        }
    }
}

