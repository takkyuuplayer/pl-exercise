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
        'f83e6b78 32806865 c5ea91b7 3bf7af63 090bd9cf 97e315e3 f0c0b4d6 eef96ba6',
        {   aps => {
                alert => "Hello, APNs!",
                badge => 1,
                sound => "default",
            },
            foo => [qw/bar baz/],
        }
    );

    # if you want to handle the error
    if (my $error = $apns->retrieve_error) {
        die Dumper $error;
    }

};
done_testing;

__DATA__

