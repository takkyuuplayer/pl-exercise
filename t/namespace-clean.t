package Test::Namespace::clean::None;
use common::sense;

use Moo;
with qw(PerlDoc::Moo::Role);

use Test::More;
use Test::Pretty;

subtest 'Test::Namespace::clean::None' => sub {
    ok __PACKAGE__->can($_) for qw(name has with);
};

package Test::Namespace::clean::Before;
use common::sense;

use Moo;
use namespace::clean;
with qw(PerlDoc::Moo::Role);

use Test::More;
use Test::Pretty;

subtest 'Test::Namespace::clean::Before' => sub {
    ok __PACKAGE__->can($_)  for qw(name);
    ok !__PACKAGE__->can($_) for qw(has with);
};

package Test::Namespace::clean::After;
use common::sense;

use Moo;
with qw(PerlDoc::Moo::Role);
use namespace::clean;

use Test::More;
use Test::Pretty;

subtest 'Test::Namespace::clean::After' => sub {
    ok __PACKAGE__->can($_)  for qw(name);
    ok !__PACKAGE__->can($_) for qw(has with);
};

done_testing;
