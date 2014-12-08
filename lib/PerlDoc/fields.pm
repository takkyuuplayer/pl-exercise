package PerlDoc::fields;

use fields qw( foo bar _Foo_private);

sub new {
    my PerlDoc::fields $self = shift;
    unless (ref $self) {
        warn $self;
        $self = fields::new($self);
        warn $self;
        $self->{_Foo_private} = 'this is secret';
    }
    $self->{foo} = 10;
    $self->{bar} = 20;

    $self;
}

1;
