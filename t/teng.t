package Test::Model::Schema;
use Teng::Schema::Declare;
table {
    name 'user';
    pk 'id';
    columns qw( name );
};

package Test::Model;
use common::sense;
use parent 'Teng';

sub new {
    my $class = shift;

    $class->SUPER::new(connect_info =>
            [ 'DBI:mysql:database=test;host=127.0.0.1;port=3306', 'testuser', 'testpass' ]);
}

package main;
use common::sense;
use Data::Dumper;
use Test::More;
use Test::Pretty;

my $handle = Test::Model->new;
isa_ok $handle, 'Test::Model';

subtest insert => sub {
    $handle->dbh->do('DROP TABLE IF EXISTS `user`');
    $handle->dbh->do(
        qq|
        CREATE TABLE `user` (
          `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
          `name` VARCHAR(255) NOT NULL,
          PRIMARY KEY (`id`))
        ENGINE = InnoDB;
        |
    );

    subtest 'Succeed w/ id' => sub {
        ok $handle->insert(user => { id => 1, name => 'foobar' });
    };

    subtest 'Fails w/o id' => sub {
        ok $handle->insert(user => { name => 'foobar' });    # fail in MySQL 5.7.15
    };
};

done_testing;
