import http.server
import socketserver
import threading
import socket
from websockets.sync.server import serve
import os
import json
import re

# Change ports here
PortHTTP = 5050
PortSocket = 5001
# Change IP here
IPAdress = "127.0.0.1"
# Change repo location here
Repos = "$HOME/hg-repos"


def SocketServer(WebSocket):
    for ClientData in WebSocket:
        try:
            Parsed = json.loads(ClientData)
            Action = Parsed["action"]
            Name = cleanInput(Parsed["name"])
            Folder = re.sub("[^A-Za-z0-9-_]", "", Name)
            if Action == "create":
                Description = cleanInput(Parsed["description"])
                Contact = cleanInput(Parsed["contact"])
                os.popen(f'cd {Repos} && mkdir {Folder} && cd {Folder} && hg init && printf "[web]\\nname={Name}\\ndescription={Description}\\ncontact={Contact}\\n" > .hg/hgrc')
            elif Action == "remove":
                os.popen(f'rm -rf {Repos}/{Folder}')
        except:
            print("Something went wrong!")


def cleanInput(String): # Prevent user from messing up the printf command
    return re.sub("[%$`]", "", String.replace('"', "'"))


def StartSocket():
    print("Serving websocket at " + IPAdress + ":" + str(PortSocket))
    with serve(SocketServer, IPAdress, PortSocket) as Server:
        Server.serve_forever()


def WebServer():
    print("Serving HTTP server at " + IPAdress + ":" + str(PortHTTP))
    Handler = http.server.SimpleHTTPRequestHandler
    with socketserver.TCPServer((IPAdress, PortHTTP), Handler) as HTTPd:
        HTTPd.serve_forever()


threadWebSocket = threading.Thread(target=StartSocket)
threadHTTPServer = threading.Thread(target=WebServer)
threadWebSocket.start()
threadHTTPServer.start()
