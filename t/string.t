use common::sense;

use Time::Piece ();
use Text::MicroTemplate::DataSection qw(render_mt);
use Test::More;
use Test::Pretty;

subtest 'variable in string' => sub {
    subtest scalar => sub {
        my $variable = 'test';
        is "This is $variable", 'This is test';
    };
    subtest array => sub {
        my @variable = qw(t e s t);
        is "This is @variable", 'This is t e s t';
        is "This is $variable[0]", 'This is t';
    };
    subtest hash => sub {
        my %variable = (
            t => 'e',
            s => 't',
        );
        is "This is %variable", 'This is %variable';
        is "This is $variable->{t}", 'This is e';
    };


};

done_testing;

__DATA__

