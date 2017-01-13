
use Hiker::Model;
use Git::Wrapper;

#Sub to pull the local list of git repos, and return them as a list.
sub get-repos() {
    my $config = "{$*PROGRAM.dirname}/config";

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
                %proj<description> = slurp("$_/README.md").lines[2..3];

                CATCH {
                    default { %proj<description> = 'No Description'; }
                }
            }

            #Get the last log entry.
            given $git.log[0] {
                %proj<commit> = .sha1;
                %proj<author> = .author;
                %proj<message> = .message;
            }

            #Get the origin URL if it exists.
            if $git.run("remote", :v) -> $r {
                %proj<has_remote> = True;
                %proj<URL> = $r.split(/\s+/)[1] if $r ~~ /"fetch"/;
            }

            #Return the info gathered.
            $res.data<project>.push: %proj;
        }
    }
}


#Update one of the git repos.
class MyApp::Model::Update does Hiker::Model {
  method bind($req, $res) {
    $res.data<who> = 'web!';
  }
}
