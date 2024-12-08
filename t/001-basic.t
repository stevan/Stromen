#!perl

use v5.40;
use experimental qw[ class ];

use Test::More;

use Stream;

my @expected_all        = (1 .. 16);
my @expected_after_grep = (2, 4, 6, 8, 10, 12, 14, 16);
my @expected_after_map  = (4, 16, 36, 64, 100, 144, 196, 256);
my @expected_result     = @expected_after_map;

subtest '... checking array source' => sub {
    my @all;
    my @after_grep;
    my @after_map;
    my @result = Stream->of( 1 .. 16 )
        ->peek(sub ($x) { push @all => $x })
        ->grep(sub ($x) { ($x % 2) == 0 })
        ->peek(sub ($x) { push @after_grep => $x })
        ->map(sub ($x) { $x * $x })
        ->peek(sub ($x) { push @after_map => $x })
        ->collect( Stream::Collectors->ToList )
    ;

    is_deeply(\@all,
        \@expected_all, '... got the full list we expected');
    is_deeply(\@after_grep,
        \@expected_after_grep, '... got the after grep we expected');
    is_deeply(\@after_map,
        \@expected_after_map, '... got the after map we expected');
    is_deeply(\@result,
        \@expected_result, '... got the result we expected');
};

subtest '... checking supplier source' => sub {
    my @all;
    my @after_grep;
    my @after_map;
    my @result = Stream
        ->generate(sub { state $x = 0; ++$x })
        ->take(16)
        ->peek(sub ($x) { push @all => $x })
        ->grep(sub ($x) { ($x % 2) == 0 })
        ->peek(sub ($x) { push @after_grep => $x })
        ->map(sub ($x) { $x * $x })
        ->peek(sub ($x) { push @after_map => $x })
        ->collect( Stream::Collectors->ToList )
    ;

    is_deeply(\@all,
        \@expected_all, '... got the full list we expected');
    is_deeply(\@after_grep,
        \@expected_after_grep, '... got the after grep we expected');
    is_deeply(\@after_map,
        \@expected_after_map, '... got the after map we expected');
    is_deeply(\@result,
        \@expected_result, '... got the result we expected');
};

subtest '... checking (infinite) iterator source' => sub {
    my @all;
    my @after_grep;
    my @after_map;
    my @result = Stream
        ->iterate(0, sub ($x) { $x + 1 })
        ->take(16)
        ->peek(sub ($x) { push @all => $x })
        ->grep(sub ($x) { ($x % 2) == 0 })
        ->peek(sub ($x) { push @after_grep => $x })
        ->map(sub ($x) { $x * $x })
        ->peek(sub ($x) { push @after_map => $x })
        ->collect( Stream::Collectors->ToList )
    ;

    is_deeply(\@all,
        \@expected_all, '... got the full list we expected');
    is_deeply(\@after_grep,
        \@expected_after_grep, '... got the after grep we expected');
    is_deeply(\@after_map,
        \@expected_after_map, '... got the after map we expected');
    is_deeply(\@result,
        \@expected_result, '... got the result we expected');
};

subtest '... checking (finite) iterator source' => sub {
    my @all;
    my @after_grep;
    my @after_map;
    my @result = Stream
        ->iterate(0, sub ($x) { $x < 16 }, sub ($x) { $x + 1 })
        ->peek(sub ($x) { push @all => $x })
        ->grep(sub ($x) { ($x % 2) == 0 })
        ->peek(sub ($x) { push @after_grep => $x })
        ->map(sub ($x) { $x * $x })
        ->peek(sub ($x) { push @after_map => $x })
        ->collect( Stream::Collectors->ToList )
    ;

    is_deeply(\@all,
        \@expected_all, '... got the full list we expected');
    is_deeply(\@after_grep,
        \@expected_after_grep, '... got the after grep we expected');
    is_deeply(\@after_map,
        \@expected_after_map, '... got the after map we expected');
    is_deeply(\@result,
        \@expected_result, '... got the result we expected');
};

done_testing;
