#!perl

use v5.38;
use experimental 'class';

use Stromen;

{

    my $stream = Stromen->new(
        source => Stromen::ArraySource->new( values => [ 1 .. 10 ] )
        #source => Stromen::CallbackSource->new( f => sub { state $i = 0; $i++ })
    );

    say $stream
        ->peek(sub ($i) { warn "Found $i before\n" })
        ->map(sub ($i) { $i * 10 })
        ->peek(sub ($i) { warn "Found $i after\n" })
        #->foreach(sub ($i) { say "-> $i" });
        ->collect(Stromen::Collectors::JoinWith(', '));


}



















