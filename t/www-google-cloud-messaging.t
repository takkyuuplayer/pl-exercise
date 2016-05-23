use common::sense;

use Test::More;
use Test::Pretty;

use WWW::Google::Cloud::Messaging;
my $api_key = $ENV{'GOOGLE_GCM_API_KEY'};
my $gcm = WWW::Google::Cloud::Messaging->new(api_key => $api_key);

subtest 'send' => sub {
    my $res = $gcm->send(
        {   registration_ids => [
                'eyQTwqKcZM4:APA91bFUCGLzxM7wQDqh5vQ9uJx8y1DlCAINrYimCGNQ4eZEDGAE2WcSzqNt4kLYt0xHVzbwXCmzWtGSDrX9NhrFOCLicIG0VwfTt8p2wsGB53A7i0NageO9zTUDM1z2zgC7N-j_MwVd',
            ],
            collapse_key => $0,
            data         => { message => "test-$_", },
        }
    );
    ok $res->is_success;

    my $results = $res->results;
    while (my $result = $results->next) {
        ok $result->is_success, "success on $_";
    }
};

done_testing;

__DATA__

