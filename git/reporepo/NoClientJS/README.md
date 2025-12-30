# RepoRepo (NoClientJS)
*This version has no client side JavaScript and will therefor work in browsers such as [eww](https://www.gnu.org/software/emacs/manual/html_node/eww/Overview.html).*
<br><br>
While [Forgejo](https://forgejo.org/) is great it's also a bit overkill for my use case (store and manage remote repos on my local network) so I created this instead. *Prefer mercurial over git? See my [hg-server](https://github.com/AstronomyOverdrive/dot-files/tree/main/mercurial/hg-server).*
<br><br>
*NOTE: This should* ***NOT*** *be used on a public facing server, ~~pythons http.server is not secure and~~ there is no authentication or authorization implemented.*

## Features
Web interface features:
- List existing repos + clone commands
- See list of files and latest commit message
- Search for repos
- Create new repos
- Delete repos
- Preview files (as long as their names follows: \[A-Za-z0-9-_.])

## Usage
### Setup
- Start a SSH server with login access to your user on the server. (For repo cloning/pushing)
- cd to this directory and run "npm install" to install [Express](https://www.npmjs.com/package/express).
- Edit **settings.json** to fit your server. (wsPort is not used on this version)
### Run
- cd to this directory and run "node server" to start the server.
