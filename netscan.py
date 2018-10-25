#pip install ping3
import os
import socket
import sys
from ping3 import ping

#net_ip = input("network_ip: ")
net_ip = sys.argv[1]
try:
	time = int(sys.argv[2])
except:
	time = 0.03

net_ip_tmp = net_ip.split(".")

for host in range(1,255):
	net_ip_tmp[3] = str(host)
	target = ".".join(net_ip_tmp)
	target_status = ping(target, timeout=time)
	if not target_status:
		continue
	else:
		print(target + " is Activated")