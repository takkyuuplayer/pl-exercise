use common::sense;
use Mojolicious::Lite;

get '/' => sub {
    my $c = shift;
    $c->render('template' => 'index');
};
post '/' => sub {
    my $c = shift;

    $c->redirect_to('/');
};

app->start;

__DATA__

@@ index.html.ep
% my $url = url_for 'title';
<form action="/">
<button type="submit">Submit</button>
</form>
