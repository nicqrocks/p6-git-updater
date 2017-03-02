#!/usr/bin/env perl6

#Make sure that all the modules can be loaded as needed.

use Test;
use lib 'lib';

my @mods = <Utils>;

plan @mods.elems;

#Make sure all the modules can be imported.
for @mods -> $mod {
    use-ok "$mod", "'$mod' can be used";
}

done-testing;
