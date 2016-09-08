use common::sense;
use Data::Dumper;
use Test::More;
use Test::Pretty;

my $class = 'Mojo::IOLoop';
use_ok $class;

subtest 'run document' => sub {
    my $server_id = $class->server(
        { port => 3000 } => sub {
            my ($loop, $stream) = @_;

            $stream->on(
                read => sub {
                    my ($stream, $bytes) = @_;

                    is $bytes, "GET / HTTP/1.1\n\n";

                    # Write response
                    $stream->write('HTTP/1.1 200 OK');
                }
            );
        }
    );

    # Connect to port 3000
    my $client_id = $class->client(
        { port => 3000 } => sub {
            my ($loop, $err, $stream) = @_;

            $stream->on(
                read => sub {
                    my ($stream, $bytes) = @_;

                    is $bytes, 'HTTP/1.1 200 OK';
                }
            );

            # Write request
            $stream->write("GET / HTTP/1.1\n\n");
        }
    );

    $class->timer(
        3 => sub {
            my $loop = shift;
            $loop->remove($server_id);
            $loop->remove($client_id);
        }
    );

    # Start event loop if necessary
    $class->start unless Mojo::IOLoop->is_running;
};

done_testing;
