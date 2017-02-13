
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

class Route::CSS does Hiker::Route {
    has $.path     = '/:style';
    has $.template = 'css.mustache';

    method handler($req, $res) {
        $res.headers<Content-Type> = 'text/css';

        my %style;
        %style<normal> = {
                padding_small   => 5,
                padding_large   => 15,
                repos_width     => 90,
                color_bg        => "white",
                color_header    => "#2c3e50",
                color_repo      => "#bdc3c7",
        };

        my $scheme = $req.params<style> // "normal";
        $scheme = "normal" unless ?%style{"$scheme"};
        $res.data.append: %style{"$scheme"}.pairs;
    }
}
