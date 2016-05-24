use common::sense;

use List::MoreUtils qw(mesh firstidx);
use Test::More;
use Test::Pretty;

subtest 'Test mesh' => sub {
    my @columns = qw(col1 col2 col3);

    subtest 'when same length' => sub {
        my @values = qw(val1 val2 val3);
        my $hash = +{ mesh(@columns, @values) };
        is_deeply $hash,
            {
            col1 => 'val1',
            col2 => 'val2',
            col3 => 'val3',
            };
    };
    subtest 'when different length 1' => sub {
        my @values = qw(val1 val2);
        my $hash = +{ mesh(@columns, @values) };
        is_deeply $hash,
            {
            col1 => 'val1',
            col2 => 'val2',
            col3 => undef,
            };
    };
    subtest 'when different length 2' => sub {
        my @values = qw(val1);
        my $hash = +{ mesh(@columns, @values) };
        is_deeply $hash,
            {
            col1 => 'val1',
            col2 => undef,
            col3 => undef,
            };
    };
};

subtest firstidx => sub {
    subtest 'by integer' => sub {
        my $res = firstidx { $_ == 3 } (0, 1, 2, 3);
        is $res, 3;
    };
    subtest 'by string' => sub {
        my $res = firstidx { $_ == 3 } ("0", "1", "2", "3");
        is $res, 3;
    };
};

done_testing;

__DATA__

