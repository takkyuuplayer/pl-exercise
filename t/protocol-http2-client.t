use common::sense;
use Data::Dumper;
use IO::Select;
use IO::Socket::SSL;
use Test::More;
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
    SKIP: {
        skip 'Skip actual request', 2;

        my $h2_client = $class->new;

        my $host      = 'api.development.push.apple.com';
        my $port      = 443;
        my $device_id = 'ee9113521b262498fd0443d34cc34eb8f58eb55489640d9189cb81644794cd9c';

        $h2_client->request(

            # HTTP/2 headers
            ':scheme'    => 'https',
            ':authority' => $host . ':' . $port,
            ':path'      => '/3/device/' . $device_id,
            ':method'    => 'POST',

            # HTTP/1.1 headers
            headers => [
                'user-agent' => $class . '-Test',
                'apns-topic' => 'com.amazonaws.appletest.takkyuuplayer',
            ],

            data => '{"aps": {"alert":"hogefuga!" , "sound": "default", "badge": 1}}',

            # Callback when receive server's response
            on_done => sub {
                my ($headers, $body) = @_;

                isa_ok $headers, 'ARRAY';
                ok !$body, 'Empty on success';
            },
        );

        my $client = IO::Socket::SSL->new(
            PeerHost          => $host,
            PeerPort          => $port,
            SSL_npn_protocols => ['h2'],
            SSL_cert_file     => "$ENV{'APNS_PRIVATE_KEY_FILE'}",
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
    }
};

done_testing;

__DATA__

