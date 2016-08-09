use common::sense;

use Test::More skip_all => '';
use Test::Pretty;

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

    subtest 'enqueue message' => sub {
        isa_ok $apns->send($device_id, "Hey there!"), 'Mojo::APNS';
        $apns->send($device_id, "counter: $_") for 1 .. 2;
    };

    subtest 'error callback' => sub {
        $apns->send(
            $device_id,
            1 x 256,
            sub {
                isa_ok shift, 'Mojo::APNS';
                like shift,   qr|^Too long message \(\d+\)$|;
            }
        );
    };

    subtest 'on drain as global' => sub {
        my $i = 0;
        $apns->on(
            drain => sub {
                $i++;
                &_stop_ioloop;
            }
        );
        $apns->ioloop->start;
        is $i, 1;
    };

    subtest 'on drain as call back' => sub {
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
        is $i, 2, 'ioloop start2';
    };

    subtest 'on feedback' => sub {
        $apns->on(
            feedback => sub {
                my ($apns, $feedback) = @_;
                ok $feedback;
                use Data::Dumper;
                warn Dumper $feedback;
            },
        );
        $apns->send('12345678 23456789 34567890 4567890a 567890ab 67890abc 7890abcd', "feed back",);

        $apns->ioloop->start;
    };
};

sub _stop_ioloop {
    shift->ioloop->stop;
}

done_testing;

__DATA__

