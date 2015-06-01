use common::sense;

use Time::Piece                      ();
use Text::MicroTemplate::DataSection ();
use Test::More;
use Test::Pretty;
use YAML ();

subtest 'pass' => sub {
    my $yyyymm = Time::Piece->localtime->strftime('%Y%m');
    is_deeply YAML::Load(
        Text::MicroTemplate::DataSection::render_mt('fixtures')),
        {
        table_name =>
            [ { id => 1, comment => 'foo' }, { id => 2, comment => 'bar' }, ],
        "table_name_$yyyymm" => [
            { id => 1, comment => 'foo', yyyymm => $yyyymm},
            { id => 2, comment => 'bar', yyyymm => $yyyymm},
        ]
        };
};

done_testing;

__DATA__

@@ fixtures

table_name:
  -
    id: 1
    comment: foo
  -
    id: 2
    comment: bar

table_name_<?= Time::Piece->localtime->strftime('%Y%m') ?>:
  -
    id: 1
    comment: foo
    yyyymm: <?= Time::Piece->localtime->strftime('%Y%m') ?>
  -
    id: 2
    comment: bar
    yyyymm: <?= Time::Piece->localtime->strftime('%Y%m') ?>
