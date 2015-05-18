use common::sense;

use Test::More;
use Test::Pretty;

subtest 'Test map with list conprehension' => sub {
    my $t = [map { $_ } ( 1 .. 3, 7 .. 9 ) ];
    is_deeply $t, [qw(1 2 3 7 8 9)];
};

done_testing;

