use common::sense;

use Test::More;
use Test::Pretty;
use Data::Dumper;

use Net::APNs::Extended;

subtest apns => sub {
    my $apns = Net::APNs::Extended->new(
        is_sandbox => 1,
        cert_file  => '../../../Downloads/myapnsappcert.pem',
        key_file   => '../../../Downloads/myapnsappprivatekey.pem',
    );

    # send notification to APNs
    $apns->send(
        '1d74882997491c40cbf1972886f1a0acd72e77b548aec1f58e21d4a3ba2c7aaa',
        {   aps => {
                alert => "Hello, APNs!",
                badge => 1,
                sound => "default",
            },
        }
    );

    # if you want to handle the error
    if (my $error = $apns->retrieve_error) {
        die Dumper $error;
    }

};
done_testing;

__DATA__

