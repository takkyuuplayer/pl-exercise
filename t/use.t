use common::sense;
use Data::Dumper;
use Test::More;
use Test::Pretty;

our @ORDER = qw();

my $class = 'Use::First';
use_ok $class;

subtest 'pushed order' => sub {
    is_deeply \@ORDER, [qw(1 a b c d 2 3 4)];
};

done_testing;
