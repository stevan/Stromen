
use v5.40;
use experimental qw[ class ];

use Path::Tiny ();

use Stream::IO::Source::BytesFromHandle;
use Stream::IO::Source::LinesFromHandle;
use Stream::IO::Source::FilesFromDirectory;

class Stream::IO :isa(Stream) {

    sub bytes ($class, $fh, %opts) {
        $fh = Path::Tiny::path($fh)->openr
            unless blessed $fh
                || ref $fh eq 'GLOB';

        $class->new(
            source => Stream::IO::Source::BytesFromHandle->new( fh => $fh, %opts ),
        )
    }

    sub lines ($class, $fh, %opts) {
        $fh = Path::Tiny::path($fh)->openr
            unless blessed $fh
                || ref $fh eq 'GLOB';

        $class->new(
            source => Stream::IO::Source::LinesFromHandle->new( fh => $fh, %opts )
        )
    }

    sub files ($class, $dir, %opts) {
        $dir = Path::Tiny::path($dir)
            unless blessed $dir;

        $class->new(
            source => Stream::IO::Source::FilesFromDirectory->new( dir => $dir, %opts )
        )
    }

    method walk {
        $self->recurse(
            sub ($c) { $c->is_dir },
            sub ($c) {
                Stream::IO::Source::FilesFromDirectory->new( dir => $c )
            }
        );
    }

}
