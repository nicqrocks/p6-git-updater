
use Hiker::Model;
use Git::Wrapper;


class MyApp::Overview does Hiker::Model {
    method bind($req, $res) {

    }
}


class MyApp::Update does Hiker::Model {
  method bind($req, $res) {
    $res.data<who> = 'web!';
  }
}
