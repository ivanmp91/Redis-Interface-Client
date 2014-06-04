#!perl -T
use 5.006;
use strict;
use warnings FATAL => 'all';
use Test::More;

plan tests => 1;

BEGIN {
    use_ok( 'Redis::Interface::Client' ) || print "Bail out!\n";
}

diag( "Testing Redis::Interface::Client $Redis::Interface::Client::VERSION, Perl $], $^X" );
