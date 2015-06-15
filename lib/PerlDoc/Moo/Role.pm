package PerlDoc::Moo::Role;
use common::sense;
use Moo::Role;

has name => (
    is => 'ro',
    defaule => sub { say ' name is called' },
);

1;
