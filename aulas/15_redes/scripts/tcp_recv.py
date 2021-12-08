#!/usr/bin/env python3
import socket

host = 'localhost'
port = 50007

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.connect((host, port))
s.sendall(b'Hello, world')
data = s.recv(1024)
print('Received', repr(data))
