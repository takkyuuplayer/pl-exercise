use common::sense;

use Test::More skip_all => '';

use Net::APNS;

subtest notification => sub {
    my $apns = Net::APNS->new;
    isa_ok($apns, 'Net::APNS');
    can_ok($apns, qw/new notify/);
    my $notify = Net::APNS->notify(
        {   cert   => '../../../Downloads/myapnsappcert.pem',
            key    => '../../../Downloads/myapnsappprivatekey.pem',
            passwd => '',
            devicetoken =>
                '5230e6dc dbb003b4 125f6256 aaae8bba 80af790c 30a08f9d 3a7fda1e 9c723c64',
        }

    );
    isa_ok($notify, 'Net::APNS::Notification');

    $notify->sandbox(1);
    $notify->write({ message => 'test', });
};

1;

done_testing;

__DATA__

