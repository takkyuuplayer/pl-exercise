use common::sense;
use Mojolicious::Lite;
use Time::Piece ();
use Mojo::JSON  ();

my $app = app();

$app->plugin('xslate_renderer');

my $routes = $app->routes;

$routes->get('/')->name('index')->to(
    cb => sub {
        my $c = shift;
        $c->stash->{session} = Mojo::JSON::encode_json($c->session);
    }
);

$routes->get('/api')->to(
    cb => sub {
        my $c      = shift;
        my $before = { %{ $c->session } };
        $c->session->{time} = Time::Piece->localtime->strftime('%F %T');
        $c->render(
            json => {
                before => $before,
                after  => $c->session,
            }
        );
    }
);

$app->start;

__DATA__

@@ index.html.tx

<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <script src="https://unpkg.com/jquery@3.1.1"></script>

    <title>React App</title>
  </head>
  <body>
    <button id="api">API</button>
    <pre><: $session :></pre>
    <script type="text/javascript">
jQuery(function($) {
  $('#api').on('click', function() {
    $.get('/api').then(function(response) { console.log(response); });
  });
});
    </script>
  </body>
</html>
