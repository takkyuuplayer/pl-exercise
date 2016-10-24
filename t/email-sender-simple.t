use common::sense;
use Data::Dumper;
use Test::More;
use Test::Pretty;
use Test::Exception;
use Email::MIME;

my $class = 'Email::Sender::Simple';
use_ok $class;

subtest 'send' => sub {
    subtest 'To: RFC822 email address' => sub {
        SKIP: {
            skip 'actual sending', 1;
            lives_ok {
                $class->send(
                    Email::MIME->create(
                        header_str => [
                            From    => 'from@example.com',
                            To      => 'to@gmail.com',
                            Subject => __FILE__,
                        ],
                        attributes => {
                            content_type => 'text/plain',
                            charset      => 'UTF-8',
                            encoding     => 'base64',
                        },
                        body_str => 'How are you? Enjoy!',
                    )
                );
            };
        }
    };

    subtest 'To: Invalid RFC822 email address including . before @' => sub {
        dies_ok {
            $class->send(
                Email::MIME->create(
                    header_str => [
                        From    => 'from@example.com',
                        To      => 'to.@example.com',
                        Subject => __FILE__,
                    ],
                    attributes => {
                        content_type => 'text/plain',
                        charset      => 'UTF-8',
                        encoding     => 'base64',
                    },
                    body_str => 'How are you? Enjoy!',
                )
            );
        };
    };
};

done_testing;
