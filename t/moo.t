use common::sense;

use Test::More;
use Data::Dumper;

my $c = 'PerlDoc::Moo';
use_ok $c;

my $cat_food = 'PerlDoc::Moo::Cat::Food';
use_ok $cat_food;

{
    note 'accessor';

    my $full = $cat_food->new(
        taste  => 'DELICIOUS.',
        brand  => 'SWEET-TREATZ',
        pounds => 10,
    );

    is $full->taste, 'DELICIOUS.', 'taste field';
    is $full->brand, 'SWEET-TREATZ', 'brand field';
    is $full->pounds, '10', 'pounds field';

};


done_testing;

