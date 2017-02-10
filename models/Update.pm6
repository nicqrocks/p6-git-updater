
use Hiker::Model;
use Git::Wrapper;
use lib 'lib';
use Utils;

#Update one of the git repos.
class Model::Update does Hiker::Model {
    method bind($req, $res) {
        #Look for the repo to update.
        my $search = $req.params<project>;
        my @repos = get-repos.grep: /:i $search /;

        #Unless one repo returns, return an error.
        unless @repos.elems == 1 {
            $res.data<name> = $search;
            $res.data<error> = @repos.elems > 1
                ?? "Too many repos match that name"
                !! "No repos match that name";
            $res.status = 404;
            return;
        }

        $res.data<name> = @repos.first.basename;
        start {
            #Looks like we found the right repo to update.
            my $git = Git::Wrapper.new: gitdir => @repos.first;
            #Pull from the origin.
            $git.pull;
        }
    }
}
