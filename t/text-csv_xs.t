use common::sense;

use Test::More;
use Data::Dumper;

use IO::File;
use Text::CSV_XS;

my $c = 'PerlDoc::fields';
use_ok $c;

subtest 'write' => sub {
    my $out = IO::File->new("./cache/test.csv", 'w');
    my $rows = [
        {
            name => 'col1',
            value => 'val1',
        },
        {
            name => 'col2',
            value => 'val2',
        },
        {
            name => 'col3',
            value => 'val3',
        },
    ];
    my $csv = Text::CSV_XS->new({binary => 1});
    for my $row (@$rows) {
        my @columns = map { $row->{$_} } qw(name value);
        ok $csv->combine(@columns);
        $out->print($csv->string() . "\n");
    }
    $out->close();
};

done_testing;
