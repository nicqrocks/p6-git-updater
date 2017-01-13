
use Hiker::Route;

class MyApp::Route::Overview does Hiker::Route {
    has $.path     = '/';
    has $.template = 'Overview.mustache';
    has $.model    = 'MyApp::Model::Overview';

    method handler($req, $res) {
        $res.headers<Content-Type> = 'text/html';
    }
}


class MyApp::Route::Update does Hiker::Route {
    has $.path     = '/update/:project';
    has $.template = 'Update.mustache';
    has $.model    = 'MyApp::Model::Update';

    method handler($req, $res) {
        $res.headers<Content-Type> = 'text/html';
    }
}


class MyApp::Route::Error does Hiker::Route {
    has $.path      = /.*/;
    has $.template  = '404.mustache';

    method handler($req, $res) {
        $res.headers<Content-Type> = 'text/plain';
    }
}
