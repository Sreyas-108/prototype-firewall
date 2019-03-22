%adap('any','Accept').
adap_cont('F','H','Reject').
adap_disc(['A','E'],'Accept').
adap('A','Accept').
adap('C','Drop').

%srcv4_1('any','Accept').
srcv4_1(1080,'Reject').
srcv4_2(10,20,'Accept').
srcv4_3([23,24],'Accept').
dstv4_1(1080,'Accept').
dstv4_2(10,20,'Accept').
dstv4_3([23,24],'Accept').
addrv4_1(1080,'Accept').
addrv4_2(10,20,'Accept').
addrv4_3([23,24],'Accept').
protov4_1(0,'Accept').
protov4_2(10,20,'Accept').
protov4_3([23,24],'Accept').

srcvdst4_1_1(30,30,'Accept').
srcvdst4_1_2(30,30,50,'Accept').
srcvdst4_1_3(30,[30],'Accept').
srcvdst4_2_1(30,30,30,'Accept').
srcvdst4_2_2(30,30,30,50,'Accept').
srcvdst4_2_3(30,30,[30],'Accept').
srcvdst4_3_1([30],30,'Accept').
srcvdst4_3_2(30,30,50,'Accept').
srcvdst4_3_3([30],[30],'Accept').

srcvdstproto4_1_1_1(30,30,30,'Accept').
srcvdstproto4_1_1_2(30,30,30,50,'Accept').
srcvdstproto4_1_1_3(30,30,[30],'Accept').
srcvdstproto4_1_2_1(30,30,30,30,'Accept').
srcvdstproto4_1_2_2(30,30,30,30,50,'Accept').
srcvdstproto4_1_2_3(30,30,30,[30],'Accept').
srcvdstproto4_1_3_1(30,[30],30,'Accept').
srcvdstproto4_1_3_2(30,30,30,50,'Accept').
srcvdstproto4_1_3_3(30,[30],[30],'Accept').

srcvdstproto4_2_1_1(30,30,30,30,'Accept').
srcvdstproto4_2_1_2(30,30,30,30,50,'Accept').
srcvdstproto4_2_1_3(30,30,30,[30],'Accept').
srcvdstproto4_2_2_1(30,30,30,30,30,'Accept').
srcvdstproto4_2_2_2(30,30,30,30,30,50,'Accept').
srcvdstproto4_2_2_3(30,30,30,30,[30],'Accept').
srcvdstproto4_2_3_1(30,30,[30],30,'Accept').
srcvdstproto4_2_3_2(30,30,30,30,50,'Accept').
srcvdstproto4_2_3_3(30,30,[30],[30],'Accept').

srcvdstproto4_3_1_1([30],30,30,'Accept').
srcvdstproto4_3_1_2([30],30,30,50,'Accept').
srcvdstproto4_3_1_3([30],30,[30],'Accept').
srcvdstproto4_3_2_1([30],30,30,30,'Accept').
srcvdstproto4_3_2_2([30],30,30,30,50,'Accept').
srcvdstproto4_3_2_3([30],30,30,[30],'Accept').
srcvdstproto4_3_3_1([30],[30],30,'Accept').
srcvdstproto4_3_3_2([30],30,30,50,'Accept').
srcvdstproto4_3_3_3([30],[30],[30],'Accept').


srcvdst4_2(10,20,10,20,'Accept').
srcvdst4_3([23,24],[23,24],'Accept').
srcvdstproto4_1(0,0,0,'Accept').
srcvdstproto4_2(10,20,10,20,10,20,'Accept').
srcvdstproto4_3([23,24],[23,24],[23,24],'Accept').


src_port(109,'Accept').
src_port(80,'Drop').
src_port(60,'Accept').
dst_port(110,'Accept').
dst_port(80,'Drop').
dst_port(60,'Accept').

srcv6('any','Accept').
dstv6('any','Accept').
addrv6('any','Accept').
protov6('any','Accept').
srcv6_1(1080,'Accept').
srcv6_2(10,20,'Accept').
srcv6_3([23,26],'Accept').
dstv6_1(1080,'Accept').
dstv6_2(10,20,'Accept').
dstv6_3([23,26],'Accept').
addrv6_1(1080,'Accept').
addrv6_2(10,20,'Accept').
addrv6_3([23,26],'Accept').
protov6_1(0,'Accept').
protov6_2(10,20,'Accept').
protov6_3([23,26],'Accept').

srcvdst6(30,30,'Accept').
srcvdst6_1_1(30,30,'Accept').
srcvdst6_1_2(30,30,50,'Accept').
srcvdst6_1_3(30,[30],'Accept').
srcvdst6_2_1(30,30,30,'Accept').
srcvdst6_2_2(30,30,30,50,'Accept').
srcvdst6_2_3(30,30,[30],'Accept').
srcvdst6_3_1([30],30,'Accept').
srcvdst6_3_2(30,30,50,'Accept').
srcvdst6_3_3([30],[30],'Accept').

srcvdstproto6_1_1_1(30,30,30,'Accept').
srcvdstproto6_1_1_2(30,30,30,50,'Accept').
srcvdstproto6_1_1_3(30,30,[30],'Accept').
srcvdstproto6_1_2_1(30,30,30,30,'Accept').
srcvdstproto6_1_2_2(30,30,30,30,50,'Accept').
srcvdstproto6_1_2_3(30,30,30,[30],'Accept').
srcvdstproto6_1_3_1(30,[30],30,'Accept').
srcvdstproto6_1_3_2(30,30,30,50,'Accept').
srcvdstproto6_1_3_3(30,[30],[30],'Accept').

srcvdstproto6_2_1_1(30,30,30,30,'Accept').
srcvdstproto6_2_1_2(30,30,30,30,50,'Accept').
srcvdstproto6_2_1_3(30,30,30,[30],'Accept').
srcvdstproto6_2_2_1(30,30,30,30,30,'Accept').
srcvdstproto6_2_2_2(30,30,30,30,30,50,'Accept').
srcvdstproto6_2_2_3(30,30,30,30,[30],'Accept').
srcvdstproto6_2_3_1(30,30,[30],30,'Accept').
srcvdstproto6_2_3_2(30,30,30,30,50,'Accept').
srcvdstproto6_2_3_3(30,30,[30],[30],'Accept').

srcvdstproto6_3_1_1([30],30,30,'Accept').
srcvdstproto6_3_1_2([30],30,30,50,'Accept').
srcvdstproto6_3_1_3([30],30,[30],'Accept').
srcvdstproto6_3_2_1([30],30,30,30,'Accept').
srcvdstproto6_3_2_2([30],30,30,30,50,'Accept').
srcvdstproto6_3_2_3([30],30,30,[30],'Accept').
srcvdstproto6_3_3_1([30],[30],30,'Accept').
srcvdstproto6_3_3_2([30],30,30,50,'Accept').
srcvdstproto6_3_3_3([30],[30],[30],'Accept').


%	ICMP  TEST KNOWLEDGE BASE


icmp_type(100,'Reject').
icmp_type(200,'Drop').

icmp_code(100,'Reject').
icmp_code(200,'Drop').


icmp_type_2([300,400],'Reject').
icmp_type_3(500,600,'Drop').

icmp_code_2([300,400],'Reject').
icmp_code_3(500,600,'Drop').



icmp_type_code(800,800,'Reject').
icmp_type_code(900,900,'Drop').
icmp_type_code_12(201,[109,110],'Drop').
icmp_type_code_13(202,301,305,'Reject').

icmp_type_code_21([101,102],203,'Drop').
icmp_type_code_22([105,106],[301,305],'Reject').
icmp_type_code_23([107,108],306,310,'Drop').

icmp_type_code_31(311,315,204,'Reject').
icmp_type_code_32(316,320,[111,112],'Drop').
icmp_type_code_33(321,325,326,330,'Reject').


%	icmpv6  TEST KNOWLEDGE BASE

icmpv6_type(100,'Reject').
icmpv6_type(200,'Drop').

icmpv6_code(100,'Reject').
icmpv6_code(200,'Drop').



icmpv6_type_2([300,400],'Reject').
icmpv6_type_3(500,600,'Drop').

icmpv6_code_2([300,400],'Reject').
icmpv6_code_3(500,600,'Drop').



icmpv6_type_code(800,800,'Reject').
icmpv6_type_code(900,900,'Drop').
icmpv6_type_code_12(201,[109,110],'Drop').
icmpv6_type_code_13(202,301,305,'Reject').

icmpv6_type_code_21([101,102],203,'Drop').
icmpv6_type_code_22([105,106],[301,305],'Reject').
icmpv6_type_code_23([107,108],306,310,'Drop').

icmpv6_type_code_31(311,315,204,'Reject').
icmpv6_type_code_32(316,320,[111,112],'Drop').
icmpv6_type_code_33(321,325,326,330,'Reject').



%tcp_ports(Destination_Address,Source_Address).
tcp_ports(200,500,'Accept').
tcp_ports(100,[401,420],'Drop').
tcp_ports([8,9],[401,420],'Reject').
tcp_ports(125,250,275,'Accept').
tcp_ports(225,350,375,'Reject').
tcp_ports(5000,5050,5000,5070,'Drop').

udp_ports(100,[401,420],'Accept').
udp_ports(200,500,'Accept').
udp_ports([8,9],[401,420],'Reject').
udp_ports(125,250,275,'Accept').
udp_ports(5000,5050,5000,5070,'Drop').


%tcp_src_port('any','Accept').
tcp_src_port(570,'Accept').
tcp_src_port(575,'Drop').
tcp_src_port(601,'Reject').
tcp_src_port(5007,'Accept').
tcp_src_port(500,600,'Reject').

tcp_dst_port(5007,'Accept').
tcp_dst_port(600,'Reject').
%tcp_dst_port('any','Accept').
tcp_dst_port(540,'Drop').

udp_src_port(601,'Reject').
udp_src_port(651,'Drop').
udp_dst_port(600,'Reject').
udp_dst_port(605,'Drop').

vid(877,'Reject').

proto_eth(180,'Reject').

%Here, proto_eth has both vid as well as Proto_ID
proto_eth(1,0x0800,'Reject').
proto_eth(2,0x86dd,'Reject').
proto_eth(1,-1,'Accept').
proto_eth(4,69,'Drop').
proto_eth(20,1000,'Reject').
proto_eth(21,1000,'Drop').
proto_eth(22,1000,'Reject').
proto_eth(23,1000,'Accept').
proto_eth(875,1000,'Reject').
proto_eth([30,40],[2045,2046],'Reject').

%Here, proto_eth is of the format proto_eth(VLAN_ID_Start,VLAN_ID_End,Proto_ID,Z).
proto_eth(10,20,2044,'Reject').
proto_eth(10,20,2054,'Accept').

