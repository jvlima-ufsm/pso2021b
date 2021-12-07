#!/usr/bin/env python3

import socket

udp_ip = '127.0.0.1'
udp_port = 5005
message = 'Hello hello'

print("UDP target IP:" + udp_ip)
print("UDP target port: " + str(udp_port))
print("Messagem: " + message)

sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
sock.sendto(str.encode(message), (udp_ip, udp_port))
