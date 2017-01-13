
use Hiker::Route;

class MyApp::Overview does Hiker::Route {
    has $.path     = '/';
    has $.template = 'Overview.mustache';
    has $.model    = 'MyApp::Overview';

    method handler($req, $res) {
        $res.headers<Content-Type> = 'text/html';
    }
}


class MyApp::Update does Hiker::Route {
    has $.path     = '/update/:project';
    has $.template = 'Update.mustache';
    has $.model    = 'MyApp::Update';

    method handler($req, $res) {
        $res.headers<Content-Type> = 'text/html';
    }
}


class MyApp::Error does Hiker::Route {
    has $.path      = /.*/;
    has $.template  = '404.mustache';

    method handler($req, $res) {
        $res.headers<Content-Type> = 'text/plain';
    }
}
