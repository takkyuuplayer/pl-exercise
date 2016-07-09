use common::sense;

use Test::More skip_all => '';
use Test::Pretty;

use Mojo::Base -strict;
use Mojo::APNS;

$ENV{MOJO_APNS_DEBUG} = 1;
subtest 'notification' => sub {

    my $device_id = '5230e6dcdbb003b4125f6256aaae8bba80af790c30a08f9d3a7fda1e9c723c64';
    my $apns      = Mojo::APNS->new(
        cert    => '../../../Downloads/myapnsappcert.pem',
        key     => '../../../Downloads/myapnsappprivatekey.pem',
        sandbox => 1,
    );

    my $res = $apns->send($device_id, "Hey there!", sub { shift->ioloop->stop })->ioloop->start;

    ok 1;
};

done_testing;

__DATA__

