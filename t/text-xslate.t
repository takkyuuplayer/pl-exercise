use common::sense;
use Data::Dumper;
use Data::Section::Simple qw(get_data_section);
use Test::More;

my $class = 'Text::Xslate';
use_ok $class;

my $tx = $class->new(module => ['Text::Xslate::Bridge::Star']);

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

subtest 'regex' => sub {
    subtest 'Android' => sub {
        is $tx->render_string(
            get_data_section('regex.tx'),
            {   user_agent =>
                    'Mozilla/5.0 (Linux; Android 4.1.1; Nexus 7 Build/JRO03D) AppleWebKit/535.19 (KHTML, like Gecko) Chrome/18.0.1025.166  Safari/535.19',
            }
            ),
            'Android
';
    };
    subtest "$_" => sub {
        is $tx->render_string(
            get_data_section('regex.tx'),
            {   user_agent =>
                    "Mozilla/5.0 ($_; CPU OS 8_1_3 like Mac OS X) AppleWebKit/600.1.4 (KHTML, like Gecko) Version/8.0 Mobile/12B466 Safari/600.1.4',"
            }
            ),
            'iOS
';
        }
        for qw(iPad iPhone iPod);
    subtest 'Others' => sub {
        is $tx->render_string(
            get_data_section('regex.tx'),
            {   user_agent =>
                    "Mozilla/5.0 (Windows NT 6.2; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/27.0.1453.94 Safari/537.36",
            }
            ),
            'Others
';
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

@@ regex.tx

: if $user_agent.lc().match(rx('android')) {
Android
: } else if $user_agent.lc().match(rx('(iphone|ipad|ipod)')) {
iOS
: } else {
Others
: }
