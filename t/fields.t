use common::sense;

use Test::More;
use Data::Dumper;

my $c = 'PerlDoc::fields';
use_ok $c;

{
    my $foo = $c->new;
    is $foo->{foo}, 10, 'foo is set';

    eval {
        $foo->{not_found};
    };
    if ($@) {
        pass('Should Occur exception');
    } else {
        fail('Should Occur exception');
    }
};

done_testing;
