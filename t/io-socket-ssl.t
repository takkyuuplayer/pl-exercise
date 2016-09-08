use common::sense;
use Data::Dumper;
use Test::More ; skip_all => 'not send request';

my $class = 'IO::Socket::SSL';
use_ok $class;

my $cl = IO::Socket::SSL->new('www.google.com:443');
$cl->print("GET / HTTP/1.0\r\n\r\n");
print <$cl>;

done_testing;

__DATA__

