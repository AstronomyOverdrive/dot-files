# Mercurial web interface extended
Quick hack that adds buttons to create or remove repos via the hg serve web interface.<br>
I run this on a raspberry pi on my local network and did therefor not make the server secure.<br>
***WARNING: DO NOT EXPOSE THIS SERVER OUTSIDE OF YOUR TRUSTED LAN***
## Usage
### Setup
**server.py** requires websockets. [GitHub](https://github.com/python-websockets/websockets) | [PyPI](https://pypi.org/project/websockets)<br>
Alternatively you can write your own websockets server as it is pretty simple.
<br><br>
**Replace the following:**
- **src="http://127.0.0.1:5000"** in **index.html** &lt;iframe&gt; with you mercurial server ip/port
- **ws://127.0.0.1:5001** in **index.html** &lt;script&gt; with your websocket server ip/port
- **IPAdress = "127.0.0.1"** in **server.py** with your server ip
- **PortHTTP = 5050** in **server.py** with whatever port you want to serve the webpage on
- **PortSocket = 5001** in **server.py** with whatever port you want to use for websockets
- **Repos = "$HOME/hg-repos"** in **server.py** with whatever folder you want to store your repos in
### Run
1. Start your mercurial server. *(e.g. "hg serve -d --webdir-conf $HOME/hg-server/hgweb.config")*
2. Start your HTTP/websockets server. *(e.g. "cd $HOME/hg-server && venv/bin/python3 server.py")*

To autostart use crontab, see [man crontab](https://man.openbsd.org/crontab) and [man crontab.5](https://man.openbsd.org/crontab.5).
