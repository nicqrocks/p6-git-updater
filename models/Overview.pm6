
use Hiker::Model;


class MyApp::Overview does Hiker::Model {
    has $.path = '/home/nic/git_repos/git-updater';

    method bind($req, $res) {
        $res.data<path> = $.path || 'foo/bar';
        $res.data<project> = $.path.IO.basename;
    }
}
