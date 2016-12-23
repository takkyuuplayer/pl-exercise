package Test::Locale::Maketext::Lexicon;
use common::sense;
use parent qw(Locale::Maketext);

use Locale::Maketext::Lexicon ();

sub import {
    my $class = shift;

    my %locales = map { $_ => [ JSON => "t/data/locale/$_.json", ], } qw( en_US ja_JP);
    Locale::Maketext::Lexicon->import(
        {   %locales,
            _decode  => 1,
            _preload => 1,
        }
    );
}

sub fallback_languages { 'en_US'; }

package main;
use common::sense;
use Data::Dumper;
use Test::Exception;
use Test::More;

Test::Locale::Maketext::Lexicon->import;

subtest en_US => sub {
    my $i18n = Test::Locale::Maketext::Lexicon->get_handle('en_US');
    is $i18n->fallback_languages, 'en_US';

    isa_ok $i18n, 'Test::Locale::Maketext::Lexicon::en_us';
    is $i18n->maketext('hello-world'),    'Hello! world!';
    is $i18n->maketext('hello-universe'), 'Hello! universe!';
};

subtest ja_JP => sub {
    my $i18n = Test::Locale::Maketext::Lexicon->get_handle('ja_JP');

    is $i18n->fallback_languages, 'en_US';
    isa_ok $i18n, 'Test::Locale::Maketext::Lexicon::ja_jp';
    is $i18n->maketext('hello-world'), 'こんにちは！世界！';
    dies_ok { $i18n->maketext('hello-universe') };
};

subtest fallback => sub {
    my $i18n = Test::Locale::Maketext::Lexicon->get_handle('en_JP');
    isa_ok $i18n, 'Test::Locale::Maketext::Lexicon::en_us';
};

done_testing;
