use common::sense;
use Data::Dumper;
use Test::More;
use Test::Pretty;
use Digest::SHA qw(hmac_sha1_hex);
use Mojo::Util;

my $class = 'Mojolicious::Sessions';
use_ok $class;

subtest 'signed cookie' => sub {
    is hmac_sha1_hex('12345', 'secret'), '3beb4dcd4d5276a3107ef503d83c8ea978e4fe1b';
    is Mojo::Util::hmac_sha1_sum('12345', 'secret'), '3beb4dcd4d5276a3107ef503d83c8ea978e4fe1b';

};

done_testing;
