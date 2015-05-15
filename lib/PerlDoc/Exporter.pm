package PerlDoc::Exporter;
use common::sense;
use Exporter qw(import);

our @EXPORT = our @EXPORT_OK = qw(hoge);

sub hoge { }

1;

