
use v5.40;
use experimental qw[ class ];

use Path::Tiny ();

use Stream::IO::Source::LinesFromHandle;
use Stream::IO::Source::FilesFromDirectory;

use Stream::IO::Operation::WalkDirectoryTree;

class Stream::IO :isa(Stream) {

    sub lines ($class, $fh) {
        $fh = Path::Tiny::path($fh)->openr
            unless blessed $fh
                || ref $fh eq 'GLOB';

        $class->new(
            source => Stream::IO::Source::LinesFromHandle->new( fh => $fh )
        )
    }

    sub files ($class, $dir) {
        $dir = Path::Tiny::path($dir)
            unless blessed $dir;

        $class->new(
            source => Stream::IO::Source::FilesFromDirectory->new(
                dir => $dir
            )
        )
    }

    sub walk ($class, $dir) {
        $dir = Path::Tiny::path($dir)
            unless blessed $dir;

        $class->new(
            source => Stream::IO::Operation::WalkDirectoryTree->new(
                source => Stream::IO::Source::FilesFromDirectory->new(
                    dir => $dir
                )
            )
        )
    }

}
