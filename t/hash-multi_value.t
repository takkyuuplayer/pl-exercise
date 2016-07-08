use common::sense;
use Data::Dumper;
use Test::More;
use Test::Deep;

my $class = 'Hash::MultiValue';
use_ok $class;

subtest hash => sub {
    my $hash = $class->new(
        foo => 'a',
        foo => 'b',
        bar => 'baz',
    );

    is $hash->{foo}, 'b';
    is $hash->get('foo'), 'b';
    is_deeply [ $hash->get_all('foo') ], [ 'a', 'b' ];

    cmp_bag [ keys %$hash ], [ 'foo', 'bar' ];
    cmp_bag [ $hash->keys ], [ 'foo', 'foo', 'bar' ];
};

done_testing;

__DATA__

