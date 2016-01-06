use common::sense;

use Parallel::ForkManager;
use Test::More;
use Test::Pretty;

subtest forktest => sub {
    my @array = map { rand } 1 .. 100;
    my $pm    = new Parallel::ForkManager(30);

    my $counter = 0;
    foreach my $number (@array) {
        $pm->start and next;    # do the fork
        print "PID: $$\n";

        sleep $number;
        print "$counter: $number\n";
        $counter += 1;

        $pm->finish;            # do the exit in the child process
                                # 子プロセスをexitします
    }
    $pm->wait_all_children;

    is 1, 1;
};

done_testing;

__DATA__

