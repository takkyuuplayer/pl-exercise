sub {
    my $env = shift;

use Data::Dumper;

    return [ 200, [ 'Content-Type' => 'text/plain' ], [Dumper $env] ];
};
