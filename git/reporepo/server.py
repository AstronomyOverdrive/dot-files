import http.server
import socketserver
import threading
import socket
from websockets.sync.server import serve
import os
import json
import re

# Will be overwritten
IPAdress = "127.0.0.1"
PortSocket = 5001
PortHTTP = 5000
Username = ""

with open("settings.json", "r") as file:
    settings = json.load(file)
    IPAdress = settings["ip"]
    PortSocket = settings["wsPort"]
    PortHTTP = settings["httpPort"]
    Username = settings["serverUser"]
    RepoDir = settings["repoDir"]
    if Username == "":
        Username = os.popen("whoami").read().split("\n")[0]


def SocketServer(WebSocket):
    for ClientData in WebSocket:
        try:
            Parsed = json.loads(ClientData)
            Action = Parsed["action"]
            Name = re.sub("[^A-Za-z0-9-_]", "", Parsed["name"])
            if Action == "create" and Name != "":
                os.popen(f'cd $HOME && mkdir -p {RepoDir}{Name} && cd {RepoDir}{Name} && git init --bare')
            elif Action == "delete" and Name != "":
                os.popen(f'cd $HOME && rm -rf {RepoDir}{Name}')
            elif Action == "fetch":
                Data = {
                    "url": f'{Username}@{IPAdress}:{RepoDir}',
                    "repos": os.popen(f'cd $HOME && ls {RepoDir}').read()
                }
                WebSocket.send(json.dumps(Data))
        except:
            print("Something went wrong!")


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
