use common::sense;

use Test::More;
use Test::Pretty;
use Test::Deep qw(eq_deeply);

subtest eq_deeply => sub {
    ok eq_deeply [ "1", "2" ], [ 1 .. 2 ];
};

done_testing;

__DATA__

