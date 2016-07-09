package Example::Data::Section::Simple;
use common::sense;
use Data::Section::Simple ();

sub get_data_section {
    my $section_name = shift;

    Data::Section::Simple->new(caller)->get_data_section($section_name);
}

package main;
use common::sense;

use Data::Section::Simple qw(get_data_section);
use Test::More;
use Test::Pretty;

subtest get_data_section => sub {

    subtest 'test.yml will not be parsed.' => sub {
        is get_data_section('test.yml'), '- hoge:
    fuga: 1
    hige: 2

';
    };
    subtest all => sub {
        is_deeply get_data_section,
            {
            'foo.html' => get_data_section('foo.html'),
            'test.yml' => get_data_section('test.yml'),
            'bar.tt'   => get_data_section('bar.tt'),
            };
    };
};

subtest 'from an another package' => sub {
    is get_data_section('foo.html'), Example::Data::Section::Simple::get_data_section('foo.html');
};
done_testing;

__DATA__


@@ foo.html
<html>
 <body>Hello</body>
</html>

@@ test.yml
- hoge:
    fuga: 1
    hige: 2

@@ bar.tt
[% IF true %]
  Foo
[% END %]
