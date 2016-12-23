use common::sense;
use Data::Dumper;
use Test::Deep;
use Test::More skip_all => 'not send request';

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

    subtest 'check content_type' => sub {
        local *Amazon::S3::Bucket::get_key = sub {
            my ($self, $key, $method, $filename) = @_;
            $method ||= "GET";
            $filename = $$filename if ref $filename;
            my $acct = $self->account;

            my $request = $acct->_make_request($method, $self->_uri($key), {});
            my $response = $acct->_do_http($request, $filename);

            if ($response->code == 404) {
                return undef;
            }

            $acct->_croak_if_response_error($response);

            my $etag = $response->header('ETag');
            if ($etag) {
                $etag =~ s/^"//;
                $etag =~ s/"$//;
            }

            my $return = {
                content_length => $response->content_length    || 0,
                content_type   => ($response->content_type)[0] || '',
                etag           => $etag,
                value          => $response->content,
            };

            is $response->content_type, 'binary/octet-stream';
            is $return->{content_type}, 'binary/octet-stream';

            foreach my $header ($response->headers->header_field_names) {
                next unless $header =~ /x-amz-meta-/i;
                $return->{ lc $header } = $response->header($header);
            }

            return $return;
        };

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
};

done_testing;
