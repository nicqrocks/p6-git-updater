
use Hiker::Model;
use Git::Wrapper;

#Sub to pull the local list of git repos, and return them as a list.
sub get-repos() {
    my $config = "{$*PROGRAM.dirname}/repos.conf";

    return gather {
        for slurp($config).lines {
            when /^ '#' .* / { } #Comment, so ignore.
            when .IO.d { take .IO; }
            default { say "{.Str} is not a valid path"; }
        }
    }.cache;
}


#Have a general overview of the git repos.
class MyApp::Model::Overview does Hiker::Model {
    method bind($req, $res) {
        for get-repos() {
            #Wrap git around the given dir.
            my $git = Git::Wrapper.new: gitdir => $_;
            #Hash to store the projects data.
            my %proj;

            #Store data about the project and return it.
            #The name of the project.
            %proj<name> = $_.basename;
            #The project description if available.
            try {
                given slurp("$_/README.md").lines[1..3] {
                    when / [\w+]+ % \s+ / { %proj<description> = $/.Str }
                }
                # %proj<description> = slurp("$_/README.md").lines[1..3];

                CATCH {
                    default { %proj<description> = 'No Description'; }
                }
            }

            #Get the last log entry.
            given $git.log(:max-count(1)).first {
                %proj<commit> = .sha1;
                %proj<author> = .author;
                %proj<message> = .message;
            }

            #Get the origin URL if it exists.
            my $url = $git.run("config", "remote.origin.url").chomp;
            if $url -> $r {
                %proj<has_remote> = True;
                %proj<origin> = $r;
            }

            #Return the info gathered.
            $res.data<project>.push: %proj;
        }
    }
}


#Update one of the git repos.
class MyApp::Model::Update does Hiker::Model {
    method bind($req, $res) {
        #Look for the repo to update.
        my $search = $req.params<project>;
        my @repos = get-repos.grep: /:i $search /;

        #Unless one repo returns, return an error.
        given @repos.elems {
            when * > 1 {
                $res.data<name> = $search;
                $res.data<error> = "Too many repos match that name";
                return;
            }
            when * < 1 {
                $res.data<name> = $search;
                $res.data<error> = "No repos match that name";
                return;
            }
        }

        #Looks like we found the right repo to update.
        my $git = Git::Wrapper.new: gitdir => @repos.first;
        #Pull from the origin.
        $git.pull;
        $res.data<name> = $git.gitdir.basename;
    }
}
