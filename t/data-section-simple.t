use common::sense;

use Data::Section::Simple qw(get_data_section);
use Test::More;
use Test::Pretty;
use Perldoc::DataSectionSimple;

subtest get_data_section => sub {

    my $all = get_data_section;               # All data in hash reference
    my $foo = get_data_section('foo.html');

    use Data::Dumper;
    warn Dumper $foo;

    warn 1 x 100;
    my $test = get_data_section('test.yml');
    warn Dumper $test;

    warn 1 x 100;
    my $all = get_data_section();
    warn Dumper $all;


};

subtest 'after_new' => sub {
    my $text = Perldoc::DataSectionSimple::get_data_section('foo.html');
    warn 1 x 100;
    warn Dumper $text;
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
