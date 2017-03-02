#!/usr/bin/env perl6

#Make sure that all the modules can be loaded as needed.

use Test;
use lib 'lib';
use Utils;

plan 3;

#Make sure that the 'get-repos' funtion works properly.
ok get-repos, "Can call `get-repos`";
isa-ok get-repos, "List", "`get-repos` returns a List";
subtest {
    for get-repos() -> $repo {
        isa-ok $repo, "IO::Path", "'get-repos' contains IO::Path";
    }
}

done-testing;
