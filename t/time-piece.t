use common::sense;
use Data::Dumper;
use Test::More;
use Test::Pretty;

my $class = 'Time::Piece';
use_ok $class, ();

subtest 'add_month' => sub {
    my $tp = Time::Piece->strptime('2016-08-31', '%Y-%m-%d');

    is $tp->strftime('%F'), '2016-08-31';
    is $tp->add_months(-1)->strftime('%Y%m'), '201607';
    is $tp->add_months(-2)->strftime('%Y%m'), '201607';
    is $tp->add_months(-3)->strftime('%Y%m'), '201605';
};

done_testing;

__DATA__

