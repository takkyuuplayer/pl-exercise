package PerlDoc::Exporter;
use common::sense;
use Exporter qw(import);

our @EXPORT = our @EXPORT_OK = qw(hoge);

sub hoge {
    my $self = shift;
    use Data::Dumper; warn Dumper $self;
}

1;

