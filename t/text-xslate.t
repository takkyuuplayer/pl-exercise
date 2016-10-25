use common::sense;
use Data::Dumper;
use Data::Section::Simple qw(get_data_section);
use Test::More;
use Test::Pretty;

my $class = 'Text::Xslate';
use_ok $class;

my $tx = $class->new;

subtest loops => sub {
    my $calendar = {
        1  => 'January',
        6  => 'June',
        11 => 'November',
    };
    subtest 'loop with default sort' => sub {
        is $tx->render_string(
            get_data_section('loop-with-default-sort.tx'),
            { calendar => $calendar, }
            ),
            '1 = January
11 = November
6 = June

'
    };
    subtest 'loop with number sort' => sub {
        is $tx->render_string(
            get_data_section('loop-with-number-sort.tx'),
            { calendar => $calendar, }
            ),
            '1 = January
6 = June
11 = November

'
    };
    subtest 'loop with string sort' => sub {
        is $tx->render_string(
            get_data_section('loop-with-string-sort.tx'),
            { calendar => $calendar, }
            ),
            '1 = January
11 = November
6 = June

'
    };


};

done_testing;

__DATA__

@@ loop-with-default-sort.tx

: for $calendar.keys().sort() -> $key {
<: $key :> = <: $calendar[$key] :>
: }

@@ loop-with-number-sort.tx

: for $calendar.keys().sort( -> $a, $b { $a <=> $b } ) -> $key {
<: $key :> = <: $calendar[$key] :>
: }

@@ loop-with-string-sort.tx

: for $calendar.keys().sort( -> $a, $b { $a cmp $b } ) -> $key {
<: $key :> = <: $calendar[$key] :>
: }

