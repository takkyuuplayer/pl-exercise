package PerlDoc::Moo::Cat::Food;

use Carp ();
use Moo;

sub feed_lion {
    my $self = shift;
    my $amount = shift || 1;

    $self->pounds($self->punds - $amount);
}

has taste => (
    is => 'ro',
    default => sub { 'strawberry' },
);

has brand =>(
    is => 'ro',
    isa => sub {
        Carp::croak 'Only SWEET-TREATZ supported!' if $_[0] ne 'SWEET-TREATZ';
    }
);

has pounds => (
    is => 'rw',
    isa => sub {
        Carp::croak "$_[0] is too much cat food!" if $_[0] >= 15;
    }
);

1;
