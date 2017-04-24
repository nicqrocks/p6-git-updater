# Perl6 Git Updater
==================

Update a local git repo using a nice web interface.

## How does this work?

The idea for this project, is to have a web interface that is able to keep track of all the different git repos that are floating around servers or even personal machines. Not only that, but update them as new commits are made to the remote repo.

To accomplish this, a config file called `repos.json` will define the local repositories that need to be watched, along with what happens when an update is done. A web server will be available to display information about the repositories, but also be able to trigger updates by sending a request to the URL: `http:/host-name/update/project-name`. The update can be triggered by any request, so you can have the local repo updated whenever the URL is called from any git host (Gitlab, Github, Bitbucket, etc) or other application (curl, wget, etc).

## Configuration

When cloning or downloading this repo, you will find a file called `example.json`. This file is an example config that should be edited to your liking and renamed to `repos.json`. The `repos.json` file must be configured in the following manner:

```
{
   "host": "hostname",
   "port": 80,
   "repos": [
      {
         "path": "/path/to/local/repo",
         "exec": "echo 'Shell command to evoke after update'"
      },
      {
         "path": "/path/to/another/repo",
         "exec": "echo 'Shell command to evoke after update'"
      }
   ]
}
```

## Needed Modules

The following modules are needed:
- Hiker
- Config::From
- Git::Wrapper
