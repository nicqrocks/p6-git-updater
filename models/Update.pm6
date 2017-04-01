
use Hiker::Model;
use Git::Wrapper;
use Config::From 'repos.json';

#Update one of the git repos.
class Model::Update does Hiker::Model {
    method bind($req, $res) {
        #Look for the repo to update.
        my $search = $req.params<project>;
        my @repos is from-config;
        my %repo = @repos.grep(*<path>.IO.basename.lc eq $search.lc).first;
        $res.data<name> = %repo<path>.IO.basename;

        start {
            my $git = Git::Wrapper.new: gitdir => %repo<path>;
            $git.pull;
            shell %repo<exec>.Str, cwd => $git.gitdir;
            CATCH { default { note $_ } }
        }

        CATCH {
            default {
                $res.data<name> = $search;
                $res.data<error> = "Repo not found";
                $res.status = 404;
                note $_;
                return;
            }
        }
    }
}
