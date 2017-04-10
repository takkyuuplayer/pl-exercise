use Benchmark qw(:all);
use JSON::WebToken qw();
use Crypt::JWT qw();
use Mojo::JWT qw();

my $data = {
    user_id   => 1,
    issued_at => time,
};
my $secret = 'FooBar';

cmpthese(
    100000,
    {   'JSON::WebToken::encode_jwt' => sub {
            my $jwt = JSON::WebToken::encode_jwt($data, $secret);
        },
        'Crypt::JWT::encode_jwt' => sub {
            my $jwt = Crypt::JWT::encode_jwt(payload => $data, key => $secret, alg => 'HS256');
        },
        'Mojo::JWT->encode' => sub {
            my $jwt = Mojo::JWT->new(claims => $data, secret => $secret)->encode;
        },
    }
);
my $jwt
    = 'eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJpc3N1ZWRfYXQiOjE0OTE4MjQ4MTZ9.99zON6It6eDMEr6tptgvWX8SZY5k776_XTGS02FrqLI';

cmpthese(
    100000,
    {   'JSON::WebToken::decode_jwt' => sub {
            JSON::WebToken::decode_jwt($jwt, $secret);
        },
        'Crypt::JWT::decode_jwt' => sub {
            Crypt::JWT::decode_jwt(token => $jwt, key => $secret, alg => 'HS256');
        },
        'Mojo::JWT->decode' => sub {
            Mojo::JWT->new(secret => $secret)->decode($jwt);
        },
    }
);
