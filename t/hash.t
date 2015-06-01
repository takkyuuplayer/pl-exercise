use common::sense;

use Test::More;
use Test::Pretty;

subtest 'Operator for hash' => sub {
    my %hash = (
        key1 => 'val1',
        key2 => undef,
    );

    subtest 'key1' => sub {
        ok $hash{key1}, 'true';
        ok exists $hash{key1}, 'true';
        ok defined $hash{key1}, 'true';
    };
    subtest 'key2' => sub {
        ok !$hash{key2}, 'false';
        ok exists $hash{key2}, 'true';
        ok !defined $hash{key2}, 'false';
    };
    subtest 'key3' => sub {
        ok !$hash{key3}, 'false';
        ok !exists $hash{key3}, 'false';
        ok !defined $hash{key3}, 'false';
    };

};

done_testing;

__DATA__

