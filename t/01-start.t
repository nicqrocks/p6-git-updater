
#This file should test if the system starts up properly.

use Test;
use Hiker;

plan 4;

#Make sure that there is a `repos.json` file.
try {
    copy("example.json", "repos.json", :createonly);
    use JSON::Fast;
    my $conf = from-json slurp("repos.json");
    $conf<repos>[0]<path> = $*CWD.Str;
    spurt "repos.json".IO, to-json($conf);
}

#Start the server.
my $app = Hiker.new(
    hikes     => ['controllers', 'models'],
    templates => 'templates',
    host      => "localhost",
    port      => 8888
);
my $srv = $app.listen;
sleep 2;

#Make a sub to talk to the server with.
sub get(Str $req) {
    my $con = IO::Socket::INET.new: host => "localhost", port => 8888;
    my Str $res = "";
    $con.print: $req;
    sleep .5;
    while my $d = $con.recv { $res ~= $d }
    CATCH { default { fail $_.gist; } }
    try {
        $con.close;
        CATCH { default { fail "Could not close socket." } }
    }
    return $res;
}

#Check that the server and it's connections are ok.
ok $srv.status ~~ Planned|Kept, "Server status";
ok get("GET / HTTP/1.0\n") ~~ /"Repo: " \S+ "<\/h2>"/,
    "Talking to main page";
ok get("GET /style.css HTTP/1.0\n") ~~ /"div"/,
    "Talking to CSS page";
ok get("GET /update/does-not-exist HTTP/1.0\n") ~~ /"Error: "/,
    "Talking to bad update page";

done-testing;
