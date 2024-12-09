
use v5.40;
use experimental qw[ class ];

class Stream::IO::Source::FilesFromDirectory :isa(Stream::Source) {
    use constant DEBUG => 0;

    field $dir :param :reader;

    field $handle;
    field $next;

    ADJUST {
        opendir( $handle, $dir )
            || die "Unable to open $dir because $!";
    }

    method next { $next }

    method has_next {
        while (1) {
            say('... Entering loop ... ') if DEBUG;

            say('... About to read directory ...') if DEBUG;
            if ( my $name = readdir( $handle ) ) {

                say('... Read directory ...') if DEBUG;
                next unless defined $name;

                say('... Got ('.$name.') from directory read ...') if DEBUG;
                next if $name eq '.' || $name eq '..'; # skip these ...

                $next = $dir->child( $name );

                # directory is not readable or has been removed, so skip it
                if ( ! -r $next ) {
                    say('... Directory/File not readable ...') if DEBUG;
                    next;
                }
                else {
                    say('... Value is good, ready to return it') if DEBUG;
                    last;
                }
            }
            else {
                say('... Exiting loop ... DONE') if DEBUG;
                return false;
            }
            say('... ... looping') if DEBUG;
        }

        say('... Got next value('.$next.')') if DEBUG;
        return true;

    }
}
