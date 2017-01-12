
use Hiker::Route;

class MyApp::Route1 does Hiker::Route {
    has $.path     = '/';
    has $.template = 'Overview.mustache';
    has $.model    = 'MyApp::Overview';

    method handler($req, $res) {
        $res.headers<Content-Type> = 'text/html';
    }
}


class MyApp::Route2 does Hiker::Route {
    has $.path     = '/update';
    has $.template = 'Update.mustache';
    has $.model    = 'MyApp::Update';

    method handler($req, $res) {
        $res.headers<Content-Type> = 'text/html';
    }
}
