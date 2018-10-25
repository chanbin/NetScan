#install WinPcap
#pip install scapy
from scapy.all import *

dst_ip = sys.argv[1]
start_port = int(sys.argv[2])
end_port = int(sys.argv[3])#여기까지 스캔 하겠다고 선언

#dst_ip = "192.168.0.1"
print("ACK_Scan started!!")
ack_scan = sr(IP(dst=dst_ip)/TCP(sport=RandShort(),dport=(start_port,end_port),flags="A"),timeout=0.2,verbose=False)
#sr oprtion verbose=False -> 결과출력 끄기
#ip = * 혹은 1-255 사용가능
#port = x단일, (x,y)범위, [x,y,z]개별 
#ACK scan, 방화벽 필터여부, 오픈여부는 아님, 차단되면 응답없음, 허용되면 RST
#FIN scan, 오픈여부, 열려있으면 응답없음, 닫혀있으면 RST
#print(ack_scan.show())
#print(ack_scan.summary())
print(" ")
for count in range(len(ack_scan[0])):
	if ack_scan[0][count][1][1].flags == "R":
		print("UnFillterd port!! - "+str(ack_scan[0][count][1][1].sport))
	else:
		continue
		#[결과,유실],패킷상세(순서),[보낸거:0, 받은거:1],[IP,TCP:0 TCP:1]
#ack_scan[0][0][1][1].flags == "R"
#ack_scan[0][1][1][1].flags == "R"
#찾고자 하는 포트 ack_scan[0][0][1][1].sport

print("SYN_Scan started!!")
syn_scan = sr(IP(dst=dst_ip)/TCP(sport=RandShort(),dport=(start_port,end_port),flags="S"),timeout=0.2,verbose=False)
print(" ")
for count in range(len(syn_scan[0])):
	if syn_scan[0][count][1][1].flags == "SA":
		print("Open port!! - " + str(syn_scan[0][count][1][1].sport))
	else:
		continue