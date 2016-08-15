use common::sense;

use Data::Dumper;
use IO::Select;
use IO::Socket::SSL;
use Test::Deep;
use Test::Exception;
use Test::Mock::Guard;
use Test::More skip_all => 'not send request';
use Test::Pretty;

my $class = 'Protocol::HTTP2::Client';
use_ok $class;

subtest 'curl --http2 https://http2bin.org/get' => sub {
    my $h2_client = $class->new;
    $h2_client->request(

        # HTTP/2 headers
        ':scheme'    => 'https',
        ':authority' => 'http2bin.org:443',
        ':path'      => '/get',
        ':method'    => 'GET',

        # HTTP/1.1 headers
        headers => [
            'accept'     => '*/*',
            'user-agent' => $class . '-Test',
        ],

        # Callback when receive server's response
        on_done => sub {
            my ($headers, $data) = @_;

            isa_ok $headers, 'ARRAY';
            ok $data;

            my %headers = @$headers;
            cmp_deeply \%headers,
                {
                'x-clacks-overhead'                => 'GNU Terry Pratchett',
                'access-control-allow-origin'      => '*',
                'server'                           => re('h2o'),
                'content-type'                     => 'application/json',
                'access-control-allow-credentials' => 'true',
                'content-length'                   => ignore,
                'date'                             => ignore,
                ':status'                          => '200'
                };
        },
    );

    my $client = IO::Socket::SSL->new(
        PeerHost => 'http2bin.org',
        PeerPort => 443,

        # openssl 1.0.1 support only NPN
        SSL_npn_protocols => ['h2'],

        # openssl 1.0.2 also have ALPN
        #SSL_alpn_protocols => ['h2'],
    ) or die $!;

    $client->blocking(0);

    my $sel = IO::Select->new($client);

    # send/recv frames until request is done
    while (!$h2_client->shutdown) {
        $sel->can_write;
        while (my $frame = $h2_client->next_frame) {
            syswrite $client, $frame;
        }

        $sel->can_read;
        while (sysread $client, my $data, 4096) {
            $h2_client->feed($data);
        }
    }
};

subtest 'APNS notification' => sub {
    my $host      = 'api.development.push.apple.com';
    my $port      = 443;
    my $device_id = 'ee9113521b262498fd0443d34cc34eb8f58eb55489640d9189cb81644794cd9c';
    my %request   = (
        ':scheme'    => 'https',
        ':authority' => $host . ':' . $port,
        ':path'      => '/3/device/' . $device_id,
        ':method'    => 'POST',
        headers      => [
            'user-agent' => $class . '-Test',
            'apns-topic' => 'com.amazonaws.appletest.takkyuuplayer',
        ],
        data    => '{"aps": {"alert":"hogefuga!" , "sound": "default", "badge": 1}}',
        on_done => sub {
            my ($headers, $body) = @_;

            isa_ok $headers, 'ARRAY';
            ok !$body, "$body";
        },
    );

    subtest 'w/o keepalive' => sub {
        my $h2_client = $class->new;
        $h2_client->request(%request);

        my $ssl_client = IO::Socket::SSL->new(
            PeerHost          => $host,
            PeerPort          => $port,
            SSL_npn_protocols => ['h2'],
            SSL_cert_file     => "$ENV{'APNS_PRIVATE_KEY_FILE'}",
        ) or die $!;
        $ssl_client->blocking(0);

        my $sel = IO::Select->new($ssl_client);

        while (!$h2_client->shutdown) {
            $sel->can_write;
            while (my $frame = $h2_client->next_frame) {
                syswrite $ssl_client, $frame;
            }

            $sel->can_read;
            while (sysread $ssl_client, my $data, 4096) {
                $h2_client->feed($data);
            }
        }
    };

    subtest 'w/ keepalive' => sub {
        my $h2_client = $class->new;
        $h2_client->request(%request);

        my $ssl_client = IO::Socket::SSL->new(
            PeerHost          => $host,
            PeerPort          => $port,
            SSL_npn_protocols => ['h2'],
            SSL_cert_file     => "$ENV{'APNS_PRIVATE_KEY_FILE'}",
        ) or die $!;

        $ssl_client->blocking(0);

        my $sel = IO::Select->new($ssl_client);

        while (!$h2_client->shutdown) {
            $sel->can_write;
            while (my $frame = $h2_client->next_frame) {
                syswrite $ssl_client, $frame;
            }

            $sel->can_read;
            while (sysread $ssl_client, my $data, 4096) {
                $h2_client->feed($data);
            }
            last;
        }

        sleep 5;

        $h2_client->request(%request);
        $h2_client->request(%request);

        while (!$h2_client->shutdown) {
            $sel->can_write;
            while (my $frame = $h2_client->next_frame) {
                syswrite $ssl_client, $frame;
            }

            $sel->can_read;
            while (sysread $ssl_client, my $data, 4096) {
                $h2_client->feed($data);
            }
            last;
        }
    };
};

done_testing;

__DATA__

