package Locale::Maketext::Lexicon::JSON;
use common::sense;
use Carp ();
use JSON::XS qw(decode_json);

sub parse {
    my $self = shift;

    Carp::cluck "Undefined source called\n" unless defined $_[0];

    +{ map { %{ decode_json($_) } } @_ };
}

1;

