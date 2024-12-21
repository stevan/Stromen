#!perl

use v5.40;
use experimental qw[ class ];

use Test::More;
use Test::Differences;

use Stream;
use Stream::IO;
use Stream::MOP;

my $s1 = Stream::IO->files("./lib");
isa_ok($s1, 'Stream::IO');

my $s2 = $s1->walk;
isa_ok($s2, 'Stream::IO');

my $s3 = $s2->grep(sub ($file) { $file->basename =~ /\.pm$/ });
isa_ok($s3, 'Stream::IO');

my $s4 = $s3->map(sub ($file) {
    my $module = $file->stringify;
    $module =~ s/^lib\///;
    $module =~ s/\.pm$//;
    $module =~ s/\//\:\:/g;
    $module;
});
isa_ok($s4, 'Stream::IO');

my $s5 = $s4->flat_map_as('Stream::MOP' => sub ($class) {
    Stream::MOP->namespace( $class )
});
isa_ok($s5, 'Stream::MOP');

my $s6 = $s5->expand_symbols(qw[ CODE ]);
isa_ok($s6, 'Stream::MOP');

my @results = $s6->collect( Stream::Collectors->ToList );

ok(scalar @results, '... we got results');

done_testing;

__DATA__

