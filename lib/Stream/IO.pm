
use v5.40;
use experimental qw[ class ];

use Path::Tiny ();

use Stream;
use Stream::IO::Source::LinesFromHandle;
use Stream::IO::Source::FilesFromDirectory;

class Stream::IO {

    sub lines ($, $fh) {
        $fh = Path::Tiny::path($fh)->openr
            unless blessed $fh
                || ref $fh eq 'GLOB';

        Stream->new(
            source => Stream::IO::Source::LinesFromHandle->new( fh => $fh )
        )
    }


    sub files ($f, $dir) {
        $dir = Path::Tiny::path($dir)
            unless blessed $dir;

        Stream->new(
            source => Stream::IO::Source::FilesFromDirectory->new(
                dir => $dir
            )
        )
    }

}
