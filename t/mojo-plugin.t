package Test::App;
use common::sense;
use Mojo::Base 'Mojolicious';
use JSON::XS ();

sub startup {
    my $self = shift;

    $self->plugin('JSON::XS');

    $self->routes->get('/json')->to(
        cb => sub {
            my $c = shift;
            $c->render(json => { env => $c->req->env, },);
        }
    );
}

package main;

use common::sense;
use Data::Dumper;
use Test::Mock::Guard qw(mock_guard);
use Test::Mojo;
use Test::More;
use Test::Pretty;

subtest 'load' => sub {
    my $guard = mock_guard('Mojolicious::Plugin::JSON::XS' => { register => 1, });
    Test::Mojo->new('Test::App');

    is $guard->call_count('Mojolicious::Plugin::JSON::XS', 'register'), 1;
};

done_testing;
