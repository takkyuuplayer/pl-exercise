package Perldoc::DataSectionSimple;
use common::sense;
use Data::Section::Simple ();


sub get_data_section {
    my $section_name = shift;

    Data::Section::Simple->new(caller)->get_data_section($section_name);
}

1;

