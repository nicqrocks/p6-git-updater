
use Hiker::Model;


class MyApp::Overview does Hiker::Model {
    has $.config = "../config".IO;

    method bind($req, $res) {
        my @repos = gather {
            
        }
        $res.data<project> = @!paths || 'None Found';
    }
}
