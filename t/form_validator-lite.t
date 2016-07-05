use common::sense;
use Data::Dumper;
use Test::More;

my $class = 'FormValidator::Lite';
use_ok $class;

$class->load_constraints(qw(Number));

subtest NUMBER => sub {
    subtest 'OK' => sub {
        my $validator = $class->new({ month => 1 });
        $validator->check(month => [ [ BETWEEN => qw(1 12) ] ],);

        ok $validator->is_valid;
    };
    subtest 'NG' => sub {
        my $validator = $class->new({ month => 13 });
        $validator->check(month => [ [ BETWEEN => qw(1 12) ] ],);

        ok !$validator->is_valid;
        is_deeply $validator->errors, { month => { BETWEEN => 1, }, };
    };

    subtest 'OK: with 0 prefix' => sub {
        my $validator = $class->new({ month => 01 });
        $validator->check(month => [ [ BETWEEN => qw(1 12) ] ],);

        ok $validator->is_valid;
    };
};

done_testing;
