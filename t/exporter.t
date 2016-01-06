package main;
use common::sense;

use PerlDoc::Exporter;
use Test::More;
use Test::Pretty;

my $class = 'PerlDoc::Exporter';
use_ok $class;

can_ok __PACKAGE__, 'hoge';

$class->hoge;
__PACKAGE__->hoge;

done_testing;
