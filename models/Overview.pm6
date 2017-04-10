
use Hiker::Model;
use Git::Wrapper;
use Config::From 'repos.json';

#Have a general overview of the git repos.
class Model::Overview does Hiker::Model {
    method bind($req, $res) {
        #Import from the config.
        my @repos is from-config;

        #Loop through each path
        for @repos.map(*<path>.IO) -> $repo {
            #Make sure that the path given exists.
            unless $repo.e {
                note "`$repo` is not a valid path";
                next;
            }

            #Wrap git around the given dir.
            my $git = Git::Wrapper.new: gitdir => $repo;
            #Hash to store the projects data.
            my %proj;

            #Store data about the project and return it.
            #The name of the project.
            %proj<name> = $repo.basename;
            #The project description if available.
            try {
                given slurp("$repo/README.md").lines[1..3] {
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
                %proj<message> = .date ~ " => " ~  .message.chomp;
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
