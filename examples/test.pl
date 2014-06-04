#!/usr/bin/env perl
use strict;
use warnings;
use Redis::Interface::Client;

my $cache = Redis::Interface::Client->new(server=>"redis1:6379");
my %hash_test = (poma=>"apple",taronja=>"orange");
my %hash_test2 = (platan=>"banana",maduixa=>"strawberry");
my %returned_hash;

$cache->set("key",\%hash_test);
$cache->append("key",\%hash_test2);
%returned_hash = $cache->get("key");
$cache->disconnect();

print %returned_hash;
