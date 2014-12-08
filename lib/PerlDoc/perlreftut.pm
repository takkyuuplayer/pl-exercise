package PerlDoc::perlreftut;

sub sort {
    my $class = shift;
    my %city_country_map = @_;

    my %countries = ();
    while(my ($city, $country) = each %city_country_map) {
        $countries{$country} = [] if not exists $countries{$country};
        push @{$countries{$country}}, $city;
    }

    map { $_ => (join ', ', sort @{$countries{$_}}) . '.' } sort keys %countries;
}
1;
