import http.server
import socketserver
import threading
import socket
from websockets.sync.server import serve
import os

# Change ports here
PortHTTP = 5050
PortSocket = 5001
# Change IP here
IPAdress = "127.0.0.1"


def SocketServer(WebSocket):
    for ClientData in WebSocket:
        os.popen(ClientData)


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
