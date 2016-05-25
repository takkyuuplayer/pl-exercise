package Foo;
use common::sense;

use Test::More;
use Test::Pretty;

$Foo::foo = 23;

subtest alias => sub {
    our $foo;
    is $foo, 23;
};

subtest direct => sub {
    is $Foo::foo, 23;
};

package main;
use common::sense;

use Test::More;
use Test::Pretty;

subtest 'Foo::foo' => sub {
    is $Foo::foo, 23;
    is ${Foo::foo}, 23;
    is "${Foo::foo}", 23;
};

done_testing;
