# RepoRepo
While [Forgejo](https://forgejo.org/) is great it's also a bit overkill for my use case (store and manage remote repos on my local network) so I created this instead. *Prefer mercurial over git? See my [hg-server](https://github.com/AstronomyOverdrive/dot-files/tree/main/mercurial/hg-server).*
<br><br>
*NOTE: This should* ***NOT*** *be used on a public facing server, pythons http.server is not secure and there is no authentication or authorization implemented.*

## Features
Web interface features:
- List existing repos + clone commands
- Search for repos
- Create new repos
- Delete repos

## Usage
### Setup
- Start a SSH server with login access to your user on the server. (For repo cloning/pushing)
- Setup a python3 venv and install websockets. [GitHub](https://github.com/python-websockets/websockets) | [PyPI](https://pypi.org/project/websockets)
- Edit **settings.json** to fit your server.
### Run
- cd to this directory and run "venv/bin/python3 server.py" (replace "venv" with your actual venv directory)
