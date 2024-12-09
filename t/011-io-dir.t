#!perl

use v5.40;
use experimental qw[ class ];

use Test::More;
use Test::Differences;

use Stream;
use Stream::IO;

Stream::IO->files("./lib")->foreach(sub ($file) {
    say "GOT: $file";
});

done_testing;
