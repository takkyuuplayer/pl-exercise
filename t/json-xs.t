use common::sense;

use Test::More;
use Test::Pretty;

use JSON::XS;
use Types::Serialiser;
use Test::Deep;

subtest boolean => sub {
    subtest 'encode' => sub {
        is encode_json([0]),      '[0]';
        is encode_json(['true']), '["true"]';
        is encode_json([Types::Serialiser::true]), '[true]';
    };
    subtest 'decode' => sub {
        is_deeply decode_json('[0]'),      [0];
        is_deeply decode_json('["true"]'), ["true"];
        is_deeply decode_json('[true]'),   [Types::Serialiser::true];

        if(decode_json('[true]')->[0]) {
            pass 'Types::Serialiser::true is considered as true';
        } else {
            fail 'Types::Serialiser::true is considered as true';
        }
    };
};

done_testing;

__DATA__

