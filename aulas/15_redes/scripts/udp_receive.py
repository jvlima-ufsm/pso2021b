#!/usr/bin/env python3

import socket

udp_ip = '127.0.0.1'
udp_port = 5005
message = 'Hello hello'

sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
sock.bind((udp_ip, udp_port))

while True:
  data, addr = sock.recvfrom(1024) 
  print("Received: " + str(data))
