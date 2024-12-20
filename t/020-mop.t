#!perl

use v5.40;
use experimental qw[ class ];

use Test::More;
use Test::Differences;

use Stream;
use Stream::MOP;

class Foo {
    method foo { ... }
}

class Foo::Bar :isa(Foo) {
    method bar { ... }
}

class Foo::Bar::Baz  :isa(Foo::Bar) {
    method baz { ... }
}

class Foo::Bar::Gorch {
    method gorch { ... }
}

subtest '... testing MOP walker' => sub {
    my @results = Stream::MOP
        ->namespace( \%Foo:: )
        ->walk
        ->expand_symbols(qw[ CODE HASH ARRAY ])
        ->collect( Stream::Collectors->ToList );

    eq_or_diff(
        [ map $_->to_string, @results ],
        [qw[
            %Foo::Bar::
            %Foo::Bar::Baz::
            @Foo::Bar::Baz::ISA
            &Foo::Bar::Baz::baz
            &Foo::Bar::Baz::new
            %Foo::Bar::Gorch::
            &Foo::Bar::Gorch::gorch
            &Foo::Bar::Gorch::new
            @Foo::Bar::ISA
            &Foo::Bar::bar
            &Foo::Bar::new
            &Foo::foo
            &Foo::new
        ]],
        '... got the expected results'
    );
};

subtest '... testing MOP walker' => sub {
    my @results = Stream::MOP
        ->mro( 'Foo::Bar::Baz' )
        ->expand_symbols(qw[ CODE ])
        ->collect( Stream::Collectors->ToList );

    eq_or_diff(
        [ map $_->to_string, @results ],
        [qw[
            &Foo::Bar::Baz::baz
            &Foo::Bar::Baz::new
            &Foo::Bar::bar
            &Foo::Bar::new
            &Foo::foo
            &Foo::new
        ]],
        '... got the expected results'
    );
};

done_testing;

__DATA__
