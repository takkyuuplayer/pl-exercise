use strict;
use warnings;
use feature qw(say);

use Data::Dumper;
use Encode qw(:all);
use Test::More;
use Test::Pretty;

subtest 'use utf8' => sub {
    use utf8;

    my $strText = "ECナビ";
    my $binText = encode_utf8($strText);

    is length($strText), 4, 'Flagged UTF8';
    is length($binText), 8, 'UTF8 binary';

    is $strText,   'ECナビ';
    isnt $binText, 'ECナビ';

    say $strText;    # warning as it is Flagged UTF8
    say $binText;
};

subtest 'no utf8' => sub {
    no utf8;

    my $binText = "ECナビ";
    my $strText = decode_utf8($binText);

    is length($binText), 8, 'UTF8 binary';
    is length($strText), 4, 'Flagged UTF8';

    is $binText,   'ECナビ';
    isnt $strText, 'ECナビ';

    say $binText;
    say $strText;    # warning as it is Flagged UTF8

};

subtest 'encode' => sub {
    use utf8;

    my $strText = 'あいうえお';
    my $binText = encode('UTF16-BE', $strText);

    is length($strText), 5, 'Flagged UTF8';
    is length($binText), 10, 'UTF16-BE binary';

    is unpack('H*', $binText), '3042304430463048304a';
};

done_testing;

__DATA__

