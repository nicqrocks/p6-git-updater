
#Use the JSON::Fast module to read the JSON file
use JSON::Tiny;

#This will hold any utility functions that will be used with the models.

#Look for files within a given dir.
multi sub find($name, $loc where *.IO.d) {
    my @results;
    for $loc.IO.dir(test => none(/^'.'/)) {
        @results.append: |find $name, $_.Str
    }
    @results;
}
multi sub find($name, $loc where *.IO.f) {
    return $loc.Str if $loc.IO.basename ~~ $name
}


#Sub to load the json config file into a useable hash.
sub load-config() is export {
    #Find the file and cache it's location.
    state $config-loc;

    #First we have to find the JSON config file, so start searching from the
    #previous dir of the currently running file.
    unless $config-loc {
        given find 'repos.json', '..' {
            when 1 { $config-loc = .first }
            default { die "Cannot find 'repos.json' file." }
        }
    }

    #Translate it from JSON and return the hash.
    my %config = from-json "$config-loc".IO.slurp;
    return %config;
}

sub get-repos() is export {
    gather {
        take $_<repo>.IO for load-config<repos>.List
    }.cache;
}
