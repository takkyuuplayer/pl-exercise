use common::sense;
use Mojolicious::Lite;
use LWP::UserAgent;
use Mojo::JSON  ();

our $RECAPTCHA_SECRET = $ENV{RECAPTCHA_SECRET};

my $app = app();

$app->plugin('xslate_renderer');

my $routes = $app->routes;

$routes->get('/')->name('index')->to(cb => sub { });

$routes->post('/')->name('index')->to(
    cb => sub {
        my $c      = shift;
        my $params = $c->req->params->to_hash;

        my $ua  = LWP::UserAgent->new;
        my $res = $ua->post(
            'https://www.google.com/recaptcha/api/siteverify',
            {   secret   => $ENV{RECAPTCHA_SECRET},
                response => $params->{'g-recaptcha-response'},
            }
        );

        $c->stash->{response} = {
            code    => $res->code,
            content => $res->content,
            posted => Mojo::JSON::encode_json($params),
        };
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
    <script src='https://www.google.com/recaptcha/api.js'></script>
  </head>
  <body>
    <form method="post">
      <div class="g-recaptcha" data-sitekey="6LdIbxEUAAAAAFOX-u1fG21lmrng9BWIhEhH5cnG"></div>
      <input type="submit">
    </form>
    <pre>
        code    = <: $response.code :>
        content = <: $response.content :>
        posted  = <: $response.posted :>
    </pre>
  </body>
</html>

