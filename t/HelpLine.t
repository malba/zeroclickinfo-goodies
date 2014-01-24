#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;
use DDG::Test::Location;
use DDG::Request;

zci answer_type => 'helpline';

my @queries = (
    'suicide',
    'suicide hotline',
    'kill myself',
    'suicidal thoughts',
    'end my life',
    'suicidal thoughts',
    'suicidal',
    'suicidal ideation',
    'i want to kill myself',
    'commit suicide',
    'suicide pills',
    'suicide pill',
    'suicide prevention',
    'kill myself',
);

my @locations = (
    'au',
    'ca',
    'us',
);

my @ok_queries = (
    'suicide girls',
    'suicide silence',
);

ddg_goodie_test(
	[qw(
		DDG::Goodie::HelpLine
	)],
    (map {
        my $query = $queries[$_];
        map {
            DDG::Request->new(
                query_raw => "$query",
                location => test_location("$locations[$_]")
            ),
            test_zci(qr/24 Hour Suicide Hotline: /),
        } 0 .. scalar @locations - 1
    } 0 .. scalar @queries - 1),
    (map {
        my $query = $ok_queries[$_];
        map {
            DDG::Request->new(
                query_raw => "$query",
                location => test_location("$locations[$_]")
            ),
            undef
        } 0 .. scalar @locations - 1
    } 0 .. scalar @ok_queries - 1),
);

done_testing(
    (scalar @queries * scalar @locations * 2) +
    (scalar @ok_queries * scalar @locations)
);
