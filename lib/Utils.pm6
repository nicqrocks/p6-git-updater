
unit module Utils;
#This will hold any utility functions that will be used with the models.

#Sub to pull the local list of git repos, and return them as a list.
sub get-repos() is export {
    my $config = "{$*PROGRAM.dirname}/repos.conf";

    return gather {
        for slurp($config).lines {
            when /^ '#' .* / { } #Comment, so ignore.
            when .IO.d { take .IO; }
            default { say "{.Str} is not a valid path"; }
        }
    }.cache;
}
