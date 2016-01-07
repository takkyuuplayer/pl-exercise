use common::sense;

use Test::Deep;
use Test::Exception;
use Test::More;
use Test::Pretty;
use Test::SharedFork;

use Parallel::ForkManager;
use MongoDB;

my $con = MongoDB->connect('mongodb://localhost')->get_database('test');

subtest insert => sub {

    my $coll = $con->get_collection('users');
    $coll->remove({});

    $coll->insert_many([ map { +{ user_id => $_, email => "$_\@test.com", } } 1 .. 100 ]);

    is $coll->count, 100;
};

subtest select => sub {
    my $coll = $con->get_collection('users');

    cmp_deeply $coll->find({ user_id => 1 })->next,
        {
        _id     => ignore,
        user_id => 1,
        email   => '1@test.com',
        };
};

subtest 'w/ Parallel::ForkManager' => sub {

    subtest 'Process = 1' => sub {
        my $pm = Parallel::ForkManager->new(1);
        for my $user_id (1 .. 10) {
            my $pid = $pm->start and next;

            my $coll = $con->get_collection('users');
            lives_ok { $coll->find({ user_id => $user_id })->next } "lives";

            $pm->finish;
        }
        $pm->wait_all_children;
    };

    subtest 'Process = 3' => sub {
        my $pm = Parallel::ForkManager->new(3);
        for my $user_id (1 .. 10) {
            my $pid = $pm->start and next;

            my $coll = $con->get_collection('users');

            lives_ok { $coll->find({ user_id => $user_id })->next } "fail in some processes";

            # localhost:27017 (type: Unknown, error: MongoDB::ProtocolError: unexpected number of documents: got 3, expected 1)
            # localhost:27017 (type: Unknown, error: MongoDB::ProtocolError: response ID (1719820241) did not match request ID (426057358))
            # localhost:27017 (type: Unknown, error: MongoDB::NetworkTimeout: Timed out while waiting for socket to become ready for reading )

            $pm->finish;
        }
        $pm->wait_all_children;
    };

    subtest 'Process = 3 w/ reconnection' => sub {
        my $pm = Parallel::ForkManager->new(3);
        for my $user_id (1 .. 10) {
            my $pid = $pm->start and next;

            my $con2 = MongoDB->connect('mongodb://localhost')->get_database('test');
            my $coll = $con2->get_collection('users');

            lives_ok { $coll->find({ user_id => $user_id })->next } "lives";

            $pm->finish;
        }
        $pm->wait_all_children;
    };
};

done_testing;

