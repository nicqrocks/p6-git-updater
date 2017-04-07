
use Hiker::Model;
use Git::Wrapper;
use Config::From 'repos.json';

#Update one of the git repos.
class Model::Update does Hiker::Model {
    method bind($req, $res) {
        my $search = $req.params<project>;
        my @repos is from-config;

        #Search through the configs for a repo that matches the query.
        my %repo;
        try { %repo = @repos.grep(*<path>.IO.basename.lc eq $search.lc).first; }
        die "Repo '$search' not found" unless %repo;
        $res.data<name> = %repo<path>.IO.basename;

        my $git = Git::Wrapper.new: gitdir => %repo<path>;
        #Check if any changes have been made since last pull.
        die "Git repo is not clean!" unless $git.status ~~ /"directory clean"/;
        $git.pull;
        #Run the command given in the git repo's dir.
        shell %repo<exec>.Str, cwd => $git.gitdir;

        CATCH {
            default {
                $res.data<name> = $search;
                $res.data<error> = $_.Str;
                $res.status = 404;
                note $_;
                return;
            }
        }
    }
}
