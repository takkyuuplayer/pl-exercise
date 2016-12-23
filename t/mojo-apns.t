use common::sense;

use Test::More skip_all => '';

my $class = 'Mojo::APNS';
use_ok $class;

$ENV{MOJO_APNS_DEBUG} = $ENV{MOJO_EVENTEMITTER_DEBUG} = 1;
subtest 'notification' => sub {

    my $device_id = 'ee911352 1b262498 fd0443d3 4cc34eb8 f58eb554 89640d91 89cb8164 4794cd9c';
    my $apns      = $class->new(
        cert    => "$ENV{'HOME'}/Downloads/aps_development.cer",
        key     => "$ENV{'HOME'}/Downloads/privatekey.pem",
        sandbox => 1,
    );
    isa_ok $apns, 'Mojo::APNS';
    isa_ok $apns->ioloop, 'Mojo::IOLoop';

    my $gateway_stream_id;
    subtest 'enqueue message' => sub {
        ok !$apns->{gateway_stream_id};
        isa_ok $apns->send($device_id, "Hey there!"), 'Mojo::APNS';

        ok $gateway_stream_id = $apns->{gateway_stream_id};

        $apns->send($device_id, "counter: $_") for 1 .. 2;

        is $apns->{gateway_stream_id}, $gateway_stream_id, 'connection resused';
    };

    my $drain_called_count = 0;
    subtest 'on drain called after sending messages' => sub {
        $apns->on(
            drain => sub {
                $drain_called_count++;
                &_stop_ioloop;
            }
        );
        $apns->ioloop->start;
        is $drain_called_count, 1;

        is $apns->{gateway_stream_id}, $gateway_stream_id, 'connection resused';
    };

    subtest 'callback' => sub {
        subtest 'called on error' => sub {
            $apns->send(
                $device_id,
                1 x 256,
                sub {
                    isa_ok shift, 'Mojo::APNS';
                    like shift,   qr|^Too long message \(\d+\)$|;
                }
            );
            is $drain_called_count, 1;
        };
        subtest 'called on drain' => sub {
            my $i = 0;
            $apns->send(
                $device_id,
                "counter: $_",
                sub {
                    my ($apns, $msg) = @_;
                    isa_ok $apns, 'Mojo::APNS';
                    is $msg,      '';
                    $i++;
                    &_stop_ioloop;
                }
            ) for 3 .. 4;

            $apns->ioloop->start;
            is $apns->{gateway_stream_id}, $gateway_stream_id, 'connection resused';
            is $i, 2, 'ioloop start2';
            is $drain_called_count, 2;
        };
    };
};

sub _stop_ioloop {
    shift->ioloop->stop;
}

done_testing;

__DATA__

