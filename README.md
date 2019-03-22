# prototype-firewall
A prototype of working of firewall on prolog.

It includes rules for adapter, ethernet, IPv4, IPv6, TCP, UDP, ICMP, ICMPv6.
It is based on Reject packet by default.

Format for adding rules to facts.pl

Adapter format : adap('A','Accept').

Ethernet format : 
%Here, proto_eth has both vid as well as Proto_ID
proto_eth(875,1000,'Reject').
%Here, proto_eth is of the format proto_eth(VLAN_ID_Start,VLAN_ID_End,Proto_ID,Z).
proto_eth(10,20,2044,'Reject').
%Only vid.
vid(877,'Reject').
%Only proto
proto_eth(180,'Reject').

Ipv4 or Ipv6 format : 
to add single clauses use
value can be 'Accept' 'Reject'  'Drop'
use
srcv4_3([23,24],'Accept').
dstv4_1(1080,'Accept').
FOR GIVING RANGES USE SUBCRIPTS (LIKE 1_2_3)
1 - Single
2- range
3 - list
use 
srcvdstproto4_2_1_1(30,30,30,30,'Accept').
srcvdstproto4_2_1_2(30,30,30,30,50,'Accept').
srcvdstproto4_2_1_3(30,30,30,[30],'Accept').

Similar rule are applied to other predicates of facts for ipv4 and ipv6.

Tcp or Udp : 
Use
%tcp_ports(Destination_Address,Source_Address).
tcp_ports(200,500,'Accept').
tcp_ports(100,[401,420],'Drop').

Similar format for other facts of tcp and udp.


Icmp4 or Icmpv6 format :
to add single clauses use

value can be 'Accept' 'Reject'  'Drop'

icmp_type(type no,value).
icmp_code( msg code,value).


FOR GIVING RANGES USE SUBCRIPTS LIKE 12
1 - Single
2- list
3-range
  

use 

icmp_type_code_12(201,[109,110],'Drop').
icmp_type_code_13(202,301,305,'Reject').

icmp_type_code_21([101,102],203,'Drop').
icmp_type_code_22([105,106],[301,305],'Reject').
icmp_type_code_23([107,108],306,310,'Drop').

icmp_type_code_31(311,315,204,'Reject').
icmp_type_code_32(316,320,[111,112],'Drop').
icmp_type_code_33(321,325,326,330,'Reject').


Done by,
SREYAS RAVICHANDRAN,
ROHIT K,
VIJAY K.
