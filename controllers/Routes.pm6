
use Hiker::Route;

class Route::Overview does Hiker::Route {
    has $.path     = '/';
    has $.template = 'Overview.mustache';
    has $.model    = 'Model::Overview';

    method handler($req, $res) {
        $res.headers<Content-Type> = 'text/html';
    }
}


class Route::Update does Hiker::Route {
    has $.path     = '/update/:project';
    has $.template = 'Update.mustache';
    has $.model    = 'Model::Update';

    method handler($req, $res) {
        $res.headers<Content-Type> = 'text/html';
    }
}
