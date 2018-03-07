use common::sense;
use Data::Dumper;
use Test::More;

subtest and => sub {
    my $a, $b;

    $a = 0 and $b = 2;

    is $a, 0;
    is $b, undef;
};

done_testing;
