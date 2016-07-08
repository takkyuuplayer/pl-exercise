use common::sense;
use Data::Dumper;
use Test::More;

subtest '&&' => sub {
    ok ! (1 && 0);
    ok (1 && 1);

    my $profile = {
        q001 => undef,
    };

    say 1 unless ($profile && $profile->{q001});

    warn Dumper $profile;

    say 2 unless ($profile &&  $profile->{q001});

    warn Dumper $profile;

    ok ! ($profile && $profile->{q001});

    ok ! ($profile && $profile->{q001});

    ok ($profile, $profile->{q001});
};

done_testing;

__DATA__

