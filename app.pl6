#!/usr/bin/env perl6

use Hiker;
use Config::From 'repos.json';

#Import settings from the config.
my $host is from-config;
my $port is from-config;

my $app = Hiker.new(
    hikes     => ['controllers', 'models'],
    templates => 'templates',
    host      => ~$host || "localhost",
    port      => +$port || 8080
);

$app.listen(:block);
