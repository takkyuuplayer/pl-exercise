use common::sense;

use Test::More skip_all => '';

subtest 'apns' => sub {
    use Net::APNS::Persistent;
    my $devicetoken_hex = '1d74882997491c40cbf1972886f1a0acd72e77b548aec1f58e21d4a3ba2c7aaa';
    my $apns            = Net::APNS::Persistent->new(
        {   sandbox => 1,
            cert    => '../../../Downloads/myapnsappcert.pem',
            key     => '../../../Downloads/myapnsappprivatekey.pem',
        }
    );
    do {
        $apns->queue_notification(
            $devicetoken_hex,
            {   aps => {
                    alert => 'sweet!',
                    sound => 'default',
                    badge => 1,
                },
            }
        );

        }
        for 1 .. 5;
    $apns->send_queue;
    $apns->disconnect;
};

done_testing;

__DATA__

