use common::sense;

use Test::More;
use Test::Pretty;

my $class = 'JSV::Validator';
use_ok $class;

my $v = $class->new(environment => "draft4");
subtest empty => sub {
    ok $v->validate({}, 42);
    ok $v->validate({}, "I'm a string");
    ok $v->validate({}, { "an" => [ "arbitrarily", "nested" ], "data" => "structure" });
};

subtest 'validate' => sub {
    my $schema = {
        type       => "object",
        properties => {
            foo => { type => "integer" },
            bar => { type => "string" }
        },
        required => ["foo"]
    };

    my $res = $v->validate($schema, { foo => 1.2, bar => "xyz" }, { loose_type => 1 });

    is $v->validate($schema, {}, { loose_type => 1 }), 0;
    is $v->validate($schema, { foo => 1 }), 1;
    is $v->validate($schema, { foo => 10,  bar => "xyz" }), 1;
    is $v->validate($schema, { foo => 1.2, bar => "xyz" }), 0;
};

subtest 'type' => sub {
    ok $v->validate({ "type" => "string" }, "I'm a string");
    ok !$v->validate({ "type" => "string" }, 42);

    ok $v->validate({ type => 'number' }, 42);
    ok $v->validate({ type => 'number' }, 42.1);
    ok !$v->validate({ type => 'number' }, '42');

    ok $v->validate({ type => [ 'number', 'string' ] }, 42);
    ok $v->validate({ type => [ 'number', 'string' ] }, "Life, the universe, and everything");
    ok !$v->validate({ type => [ 'number', 'string' ] },
        [ "Life", "the universe", "and everything" ]);

    subtest number => sub {
        ok $v->validate({ type => 'integer' }, 42);
        ok !$v->validate({ type => 'integer' }, 42.0);

        ok $v->validate({ type => 'integer', 'multipleOf' => 10, }, 20);
        ok $v->validate({ type => 'integer', 'multipleOf' => 10, }, -10);
        ok !$v->validate({ type => 'integer', 'multipleOf' => 10, }, -15);

        ok $v->validate({ type => 'integer', 'maximum' => 10, }, -15);
        ok $v->validate({ type => 'integer', 'maximum' => 10, }, 10);
        ok !$v->validate({ type => 'integer', 'maximum' => 10, exclusiveMaximum => 1 }, 10);
    };

    subtest object => sub {
        ok $v->validate({ type => "object" }, {});
        ok $v->validate({ type => "object" }, { hoo => 'bar' });

        subtest properties => sub {
            my $schema = {
                "type"       => "object",
                "properties" => {
                    "number"      => { "type" => "number" },
                    "street_name" => { "type" => "string" },
                    "street_type" => {
                        "type" => "string",
                        "enum" => [ "Street", "Avenue", "Boulevard" ]
                    }
                }
            };
            ok $v->validate($schema,
                { "number" => 1600, "street_name" => "Pennsylvania", "street_type" => "Avenue" });
            ok !$v->validate($schema,
                { "number" => '1600', "street_name" => "Pennsylvania", "street_type" => "Avenue" });
        };

        subtest required => sub {
            my $schema = {
                "type"       => "object",
                "properties" => {
                    "name"      => { "type" => "string" },
                    "email"     => { "type" => "string" },
                    "address"   => { "type" => "string" },
                    "telephone" => { "type" => "string" }
                },
                "required" => [ "name", "email" ]
            };
            ok $v->validate(
                $schema,
                {   "name"  => "William Shakespeare",
                    "email" => 'bill@stratford-upon-avon.co.uk'
                }
            );
            ok !$v->validate(
                $schema,
                {   "name"    => "William Shakespeare",
                    "address" => "Henley Street, Stratford-upon-Avon, Warwickshire, England",
                }

            );

        };

        subtest size => sub {
            my $schema = {
                "type"          => "object",
                "minProperties" => 2,
                "maxProperties" => 3
            };
            ok !$v->validate($schema, {});
            ok $v->validate($schema, { hoge => 'fuga', foo => 'bar', });
            ok !$v->validate($schema,
                { hoge => 'fuga', foo => 'bar', hara => 'holo', hire => 'hare', });
        };

        subtest dependencies => sub {
            subtest property => sub {
                my $schema = {
                    "type" => "object",

                    "properties" => {
                        "name"            => { "type" => "string" },
                        "credit_card"     => { "type" => "number" },
                        "billing_address" => { "type" => "string" }
                    },

                    "required" => ["name"],

                    "dependencies" => { "credit_card" => ["billing_address"] }
                };
                ok $v->validate(
                    $schema,
                    {   "name"            => "John Doe",
                        "credit_card"     => 5555555555555555,
                        "billing_address" => "555 Debtor's Lane"
                    }
                );
                ok $v->validate(
                    $schema,
                    {   "name"            => "John Doe",
                        "billing_address" => "555 Debtor's Lane"
                    }
                );
                ok !$v->validate(
                    $schema,
                    {   "name"        => "John Doe",
                        "credit_card" => 5555555555555555,
                    }
                );
            };
            subtest schema => sub {
                my $schema = {
                    "type"       => "object",
                    "properties" => {
                        "name"        => { "type" => "string" },
                        "credit_card" => { "type" => "number" }
                    },
                    "required"     => ["name"],
                    "dependencies" => {
                        "credit_card" => {
                            "properties" => { "billing_address" => { "type" => "string" } },
                            "required"   => ["billing_address"]
                        }
                    }
                };
                ok $v->validate(
                    $schema,
                    {   "name"            => "John Doe",
                        "credit_card"     => 5555555555555555,
                        "billing_address" => "555 Debtor's Lane"
                    }
                );
                ok $v->validate(
                    $schema,
                    {   "name"            => "John Doe",
                        "billing_address" => "555 Debtor's Lane"
                    }
                );
                ok !$v->validate(
                    $schema,
                    {   "name"        => "John Doe",
                        "credit_card" => 5555555555555555,
                    }
                );
            };
        };
        subtest pattern => sub {
            my $schema = {
                "type"              => "object",
                "patternProperties" => {
                    "^S_" => { "type" => "string" },
                    "^I_" => { "type" => "integer" }
                },
                "additionalProperties" => 0,
            };
            ok $v->validate($schema, { "S_25"=> "This is a string" });
            ok $v->validate($schema, { "I_0"=> 42 });
            ok ! $v->validate($schema, { "I_0"=> 'This is a string'});
        };
    };
};

subtest 'error messages' => sub {
    my $schema = {
        type       => "object",
        properties => {
            foo => { type => "integer" },
            bar => { type => "string" }
        },
        required => ["foo"]
    };

    is $v->validate($schema, {}), 0;
    is $v->validate($schema, { foo => 1 }), 1;
    is $v->validate($schema, { foo => 10,  bar => "xyz" }), 1;
    is $v->validate($schema, { foo => 1.2, bar => "xyz" }), 0;
};

done_testing;

__DATA__


