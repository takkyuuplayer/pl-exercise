use common::sense;
use Data::Dumper;
use Test::More;

my $class = 'Time::Piece';
use_ok $class, ();

subtest 'add_months' => sub {
    subtest 'end day of month' => sub {
        my $tp = Time::Piece->strptime('2016-12-31', '%Y-%m-%d');

        is $tp->strftime('%F %T'), '2016-12-31 00:00:00';
        is $tp->add_months(-1)->strftime('%F %T'),  '2016-12-01 00:00:00';
        is $tp->add_months(-2)->strftime('%F %T'),  '2016-10-31 00:00:00';
        is $tp->add_months(-3)->strftime('%F %T'),  '2016-10-01 00:00:00';
        is $tp->add_months(-4)->strftime('%F %T'),  '2016-08-31 00:00:00';
        is $tp->add_months(-5)->strftime('%F %T'),  '2016-07-31 00:00:00';
        is $tp->add_months(-6)->strftime('%F %T'),  '2016-07-01 00:00:00';
        is $tp->add_months(-7)->strftime('%F %T'),  '2016-05-31 00:00:00';
        is $tp->add_months(-8)->strftime('%F %T'),  '2016-05-01 00:00:00';
        is $tp->add_months(-9)->strftime('%F %T'),  '2016-03-31 00:00:00';
        is $tp->add_months(-10)->strftime('%F %T'), '2016-03-02 00:00:00';
        is $tp->add_months(-11)->strftime('%F %T'), '2016-01-31 00:00:00';
    };
    subtest '1st day of month' => sub {
        my $tp = Time::Piece->strptime('2016-12-01', '%Y-%m-%d');

        is $tp->strftime('%F %T'), '2016-12-01 00:00:00';
        is $tp->add_months(-1)->strftime('%F %T'),  '2016-11-01 00:00:00';
        is $tp->add_months(-2)->strftime('%F %T'),  '2016-10-01 00:00:00';
        is $tp->add_months(-3)->strftime('%F %T'),  '2016-09-01 00:00:00';
        is $tp->add_months(-4)->strftime('%F %T'),  '2016-08-01 00:00:00';
        is $tp->add_months(-5)->strftime('%F %T'),  '2016-07-01 00:00:00';
        is $tp->add_months(-6)->strftime('%F %T'),  '2016-06-01 00:00:00';
        is $tp->add_months(-7)->strftime('%F %T'),  '2016-05-01 00:00:00';
        is $tp->add_months(-8)->strftime('%F %T'),  '2016-04-01 00:00:00';
        is $tp->add_months(-9)->strftime('%F %T'),  '2016-03-01 00:00:00';
        is $tp->add_months(-10)->strftime('%F %T'), '2016-02-01 00:00:00';
        is $tp->add_months(-11)->strftime('%F %T'), '2016-01-01 00:00:00';
    };
};

done_testing;

__DATA__

