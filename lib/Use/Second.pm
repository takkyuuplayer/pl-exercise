package Use::Second;
use common::sense;

use Data::Dumper;

BEGIN {
    push @{main::ORDER}, 'a';
}

use Use::Second;

sub import {
    push @{main::ORDER}, 'd';
}

push @{main::ORDER}, 'c';

BEGIN {
    push @{main::ORDER}, 'b';
}

1;
