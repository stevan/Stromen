#!perl

use v5.40;
use experimental qw[ class ];

use Test::More;
use Test::Differences;

use Stream;
use Stream::IO;

my @self = do {
    my $fh = IO::File->new(__FILE__, '<');
    map { chomp; $_ } <$fh>;
};

subtest '... testing IO->lines($fh)' => sub {
    open my $fh, '<', __FILE__;

    my @results = Stream::IO
        ->lines($fh)
        ->map(sub ($line) { chomp $line; $line })
        ->collect( Stream::Collectors->ToList )
    ;

    eq_or_diff(\@results, \@self, '... got the expected results');
};

subtest '... testing IO->lines(IO::File)' => sub {

    my @results = Stream::IO
        ->lines(IO::File->new(__FILE__, '<'))
        ->map(sub ($line) { chomp $line; $line })
        ->collect( Stream::Collectors->ToList )
    ;

    eq_or_diff(\@results, \@self, '... got the expected results');
};

subtest '... testing IO->lines(IO::File)' => sub {

    my @results = Stream::IO
        ->lines(__FILE__)
        ->map(sub ($line) { chomp $line; $line })
        ->collect( Stream::Collectors->ToList )
    ;

    eq_or_diff(\@results, \@self, '... got the expected results');
};

done_testing;
