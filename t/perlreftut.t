use common::sense;

use Test::More;
use Data::Dumper;

my $c = 'PerlDoc::perlreftut';
use_ok $c;


{ # Make Rule 1
    my @array = (1, 2, 3);
    my $aref = \@array;
    is ref $aref, ref [], 'ARRAY';

    my %hash = (
        hoge => 'hage',
        fuga => 'faga',
        piyo => 'payo'
    );
    my $href = \%hash;
    is ref $href, ref {}, 'HASH';
};
{ # Make Rule 2
    my $aref = [1, 'foo', undef, 13];
    is ref $aref, ref [], 'ARRAY';

    my $href = { APR => 4, AUG => 8 };
    is ref $href, ref {}, 'HASH';

};
{ # Use Rule 1
    my $aref = [1, 'foo', undef, 13];
    is @{$aref}, 4, 'ARRAY in Scalar Context';
    warn reverse @{$aref};
    is @{$aref}[3], 13, '4th element';
    ${$aref}[3] = 17;
    is @{$aref}[3], 17, 'substituted';
};
{ # Use Rule 2
    my $aref = [1, 'foo', undef, 13];
    is $aref->[3], ${$aref}[3], 'Same as ${$aref}[3]';

    my $href = { APR => 4, AUG => 8 };
    is $href->{APR}, ${$href}{APR}, 'Same as ${$href}{APR}';
};
{ # Use Rule 2.1
    my @array = (
        [1, 2, 3],
        [4, 5, 6],
        [7, 8, 9]
    );
    is $array[1]->[1], ${$array[1]}[1], '2d array';
    is $array[1][1], $array[1]->[1], '2d array';

    my @array = (
        [[1, 2, 3], [4, 5, 6], [7, 8, 9]],
        [[4, 5, 6], [7, 8, 9], [1, 2, 3]],
        [[7, 8, 9], [1, 2, 3], [4, 5, 6]],
    );
    is ${${$array[1]}[1]}[1], 8, '3d array';
    is $array[1]->[1]->[1], 8, '3d array';
    is $array[1][1][1], 8, '3d array';
};
{
    my %hash = (
        Chicago    => 'USA',
        Frankfurt  => 'Germany',
        Berlin     => 'Germany',
        Washington => 'USA',
        Helsinki   => 'Finland',
        'New York' => 'USA',
    );

    my $expected = {
        Finland => 'Helsinki.',
        Germany => 'Berlin, Frankfurt.',
        USA => 'Chicago, New York, Washington.',
    };

    my %got = $c->sort(%hash);
    is_deeply($expected, \%got, 'sorted');
};

done_testing;
