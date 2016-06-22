use common::sense;

use Data::Dumper;
use Test::Exception;
use Test::More;

use Params::Validate qw(:all);

subtest hash => sub {

    subtest 'hash' => sub {
        my $validator = { foo => 1, bar => 0 };

        my @valid    = (foo => 12345, bar => 12345,);
        my @invalid  = (bar => 12345);
        my @invalid2 = (foo => 12345, bar => 12345, hoge => 12345,);

        lives_ok {
            validate(@valid, $validator)
        };
        throws_ok { validate(@invalid,  $validator) } qr|foo|;
        throws_ok { validate(@invalid2, $validator) } qr|hoge|;
    };

    subtest 'hash' => sub {
        my $validator = { foo => 1, bar => 0 };

        my @valid    = ({ foo => 12345, bar => 12345, });
        my @invalid  = ({ bar => 12345 });
        my @invalid2 = ({ foo => 12345, bar => 12345, hoge => 12345, });

        lives_ok {
            validate(@valid, $validator)
        };
        throws_ok { validate(@invalid,  $validator) } qr|foo|;
        throws_ok { validate(@invalid2, $validator) } qr|hoge|;
    };
};

subtest 'SCALAR' => sub {
    subtest SCALAR => sub {
        my $validator = { foo => SCALAR };

        my @valid = (foo => 1);
        my @valid2 = ( foo => { hoge => 1 } );

        lives_ok { validate(@valid, $validator) };
        lives_ok { validate(@valid2, $validator) };
    };
    subtest SCALARREF => sub {
        my $validator = { foo => SCALARREF };

        my @invalid = (foo => 1);
        my @valid = ( foo => { hoge => 1 } );

        lives_ok { validate(@invalid, $validator) };
        lives_ok { validate(@valid, $validator) };
    };
};

done_testing;

