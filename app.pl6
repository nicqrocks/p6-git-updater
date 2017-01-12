#!/usr/bin/env perl6

use Hiker;

my $app = Hiker.new(
    hikes     => ['controllers', 'models'],
    templates => 'templates',
);

$app.listen(:block);
