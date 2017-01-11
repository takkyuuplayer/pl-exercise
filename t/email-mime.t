use common::sense;
use Data::Dumper;
use Test::More;
use Test::Exception;

my $class = 'Email::MIME';
use_ok $class;

subtest create => sub {
    subtest 'To: RFC822 email address' => sub {
        lives_ok {
            $class->create(
                header_str => [
                    From    => 'from@example.com',
                    To      => 'to@example.com',
                    Subject => 'test',
                ],
                attributes => {
                    content_type => 'text/plain',
                    charset      => 'UTF-8',
                    encoding     => 'base64',
                },
                body_str => 'How are you? Enjoy!',
            );
        };
    };
    subtest 'To: Invalid RFC822 email address including . before @' => sub {
        lives_ok {
            $class->create(
                header_str => [
                    From    => 'from@example.com',
                    To      => 'to.@example.com',
                    Subject => 'test',
                ],
                attributes => {
                    content_type => 'text/plain',
                    charset      => 'UTF-8',
                    encoding     => 'base64',
                },
                body_str => 'How are you? Enjoy!',
            );
        };
    };
};

done_testing;
