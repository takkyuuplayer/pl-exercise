use common::sense;

use Test::More;

subtest 'do-for' => sub {
    do {
        is $_, 1, 'only called once';
        last;
        }
        for 1 .. 3;
};

done_testing;

__DATA__

