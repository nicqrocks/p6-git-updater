
use Hiker::Model;
use Git::Wrapper;
use lib 'lib';
use Utils;

#Have a general overview of the git repos.
class Model::Overview does Hiker::Model {
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
