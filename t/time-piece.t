use common::sense;
use Data::Dumper;
use Test::More;
use Test::Pretty;

my $class = 'Time::Piece';
use_ok $class, ();

subtest 'add_months' => sub {
    subtest 'end day of month' => sub {
        my $tp = Time::Piece->strptime('2016-08-31', '%Y-%m-%d');

        is $tp->strftime('%F'), '2016-08-31';
        is $tp->add_months(-1)->strftime('%Y%m'), '201607';
        is $tp->add_months(-2)->strftime('%Y%m'), '201607';
        is $tp->add_months(-3)->strftime('%Y%m'), '201605';
    };
    subtest '1st day of month' => sub {
        my $tp = Time::Piece->strptime('2016-12-01', '%Y-%m-%d');

        is $tp->add_months(-1 * $_)->strftime('%Y%m'), (201612 - $_) for 0 .. 11;
    };
};

done_testing;

__DATA__

