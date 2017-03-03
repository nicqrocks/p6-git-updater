
#Class to organize config data.

#Make some exception classes.
class X::NoExec { has $.message = "No command given"; }

class Repo {
    has IO::Path $.path = !!! "Path for the repo is required";
    has @.cmd;

    method run() {
        if @.cmd { return run |@!cmd; }
        else { X::NoExec.new.throw; }
    }
}
