use common::sense;
use Data::Dumper;
use Test::More;

my $class = 'Email::Send';
use_ok $class;

subtest 'send' => sub {
    subtest 'To: RFC822 email address' => sub {
        my $message = <<'__MESSAGE__';
To: to@example.com
From: test@example.com
Subject: RFC822 email address

How are you? Enjoy!
__MESSAGE__
        my $sender = Email::Send->new({ mailer => 'SMTP' });
        $sender->mailer_args([ Host => 'localhost' ]);
        SKIP: {
            skip 'actual sending', 1;
            ok $sender->send($message);
        }
    };
    subtest 'To: Invalid RFC822 email address including . before @' => sub {
        my $message = <<'__MESSAGE__';
To: to.@example.com
From: test@example.com
Subject Invalid RFC822 email address

How are you? Enjoy!
__MESSAGE__
        my $sender = Email::Send->new({ mailer => 'SMTP' });
        $sender->mailer_args([ Host => 'localhost' ]);
        ok !$sender->send($message);
    };
};

done_testing;
