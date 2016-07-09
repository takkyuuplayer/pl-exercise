use common::sense;

use File::Basename;
use Net::FTPSSL;
use Test::More skip_all => '';
use Test::Pretty;

my $ftps = Net::FTPSSL->new(
    'localhost',
    Croak        => 1
);

$ftps->login('vagrant', 'vagrant');

subtest upload => sub {
    my $path = '/tmp/' . basename($0);
    warn $path;
    unlink $path if -f $path;

    $ftps->put($0, $path);

    ok -f $path, 'Uploaded';
};

done_testing;

__DATA__
