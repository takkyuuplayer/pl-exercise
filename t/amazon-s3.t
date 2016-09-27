use common::sense;
use Data::Dumper;
use Test::Deep;
use Test::More skip_all => 'not send request';
use Test::Pretty;

my $class = 'Amazon::S3';
use_ok $class;

my $aws_access_key_id     = $ENV{AWS_S3_KEY};
my $aws_secret_access_key = $ENV{AWS_S3_SECRET};

subtest bucket => sub {
    my $s3 = Amazon::S3->new(
        {   aws_access_key_id     => $aws_access_key_id,
            aws_secret_access_key => $aws_secret_access_key,
            retry                 => 1
        }
    );
    my $bucket = $s3->bucket('rpa-devcf');
    isa_ok $bucket, 'Amazon::S3::Bucket';

    subtest 'add_key w/o content_type' => sub {
        is $bucket->add_key('test/text.txt', 'foobar'), 1;

        my $data = $bucket->get_key('test/text.txt');
        cmp_deeply $data,
            {
            etag           => ignore,
            content_length => length('foobar'),
            value          => 'foobar',
            content_type   => 'binary/octet-stream',
            };
    };

    subtest 'add_key w/ content_type' => sub {
        is $bucket->add_key('test/text.txt', 'foobar', { content_type => 'text/plain' }), 1;

        my $data = $bucket->get_key('test/text.txt');
        cmp_deeply $data,
            {
            etag           => ignore,
            content_length => length('foobar'),
            value          => 'foobar',
            content_type   => 'text/plain',
            };
    };
};

done_testing;
