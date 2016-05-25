use common::sense;

use Test::More;
use Test::Pretty;
use Test::Deep qw(eq_deeply);

my $ok = eq_deeply [ "1", "2" ], [ 1 .. 2 ];
warn $ok;

done_testing;

__DATA__

