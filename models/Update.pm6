
use Hiker::Model;

class MyApp::Update does Hiker::Model {
  method bind($req, $res) {
    $res.data<who> = 'web!';
  }
}
