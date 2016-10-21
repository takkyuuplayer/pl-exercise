use common::sense;
use Data::Dumper;
use Test::More;

my $class = 'FormValidator::Lite';
use_ok $class;

$class->load_constraints(qw(Number Email ));

subtest NUMBER => sub {
    subtest 'OK' => sub {
        my $validator = $class->new({ month => 1 });
        $validator->check(month => [ [ BETWEEN => qw(1 12) ] ],);

        ok $validator->is_valid;
    };
    subtest 'NG: out of range' => sub {
        my $validator = $class->new({ month => 13 });
        $validator->check(month => [ [ BETWEEN => qw(1 12) ] ],);

        ok !$validator->is_valid;
        is_deeply $validator->errors, { month => { BETWEEN => 1, }, };
    };
    subtest 'OK: missing but it does not care.' => sub {
        my $validator = $class->new({ month => '' });
        $validator->check(month => [ [ BETWEEN => qw(1 12) ] ],);

        ok $validator->is_valid;
    };

    subtest 'OK: with 0 prefix' => sub {
        my $validator = $class->new({ month => 01 });
        $validator->check(month => [ [ BETWEEN => qw(1 12) ] ],);

        ok $validator->is_valid;
    };
};

subtest EMAIL => sub {
    subtest 'OK' => sub {
        my $validator = $class->new({ email => 'test.@gmail.com' });
        $validator->check(email => [ [qw(EMAIL_LOOSE)] ],);

        ok $validator->is_valid;
    };
    subtest 'NG: loose email' => sub {
        my $validator = $class->new({ email => 'test.@gmail.com' });
        $validator->check(email => [ [qw(EMAIL )] ],);

        ok !$validator->is_valid;
    };
    subtest 'NG: invalid email' => sub {
        my $validator = $class->new({ email => 'test@com' });
        $validator->check(email => [ [qw(EMAIL_LOOSE)] ],);

        ok !$validator->is_valid;
    };
};

done_testing;
