check(Ad,Eth,Ipv4,Ipv6,TcpCmdList,UdpCmdList,IcmpList,Icmpv6List,X)  :- adapter(Ad,A), ether_check(Eth,E), (is_list(Ipv4); is_list(Ipv6)), ipv4(Ipv4,I4), ipv6(Ipv6,I6), tcp(TcpCmdList,T), udp(UdpCmdList,U),icmp(IcmpList,R1),icmpv6(Icmpv6List,R2),cond(A,E,I4,I6,T,U,R1,R2,X).

cond(A,E,I4,I6,T,U,R1,R2,'Accept') :- A='Accept', E='Accept', I4='Accept', I6='Accept', T='Accept',U='Accept', R1='Accept',R2='Accept'.
cond(A,E,I4,I6,T,U,R1,R2,'Reject') :- (A='Reject'; E='Reject'; I4='Reject'; I6='Reject'; T='Reject'; U='Reject'; R1='Reject'; R2='Reject'), write('Invalid input. \n').
cond(A,E,I4,I6,T,U,R1,R2,'Drop') :- ((A='Drop'; E='Drop'; I4='Drop'; I6='Drop'; T='Drop'; U='Drop'; R1='Drop';R2='Drop'), \+(A='Reject'; E='Reject'; I4='Reject'; I6='Reject'; T='Reject';U='Reject'; R1='Reject'; R2='Reject')).

adapter(Y,'Accept') :- adap('any','Accept'), char_code(Y,Code), (Code>64), (Code<73).
adapter(Y,Adapval) :- adap(Y,Adapval).
adapter(Y,Adapval) :- adap_cont(A,B,Adapval), char_code(A,ACode), char_code(B,BCode), char_code(Y,YCode), (YCode>ACode; YCode=ACode), (YCode<BCode; YCode=BCode).
adapter(Y,Adapval) :- adap_disc(T,Adapval), member(Y,T).
adapter(Y,'Accept'):- \+(adapter(Y,'Reject')), \+(adapter(Y,'Drop')).

ipv4(T,'Reject') :- is_list(T),length(T,9), nth0(1,T,'src'), nth0(3,T,IpElem1), (srcv4(IpElem1,'Reject'); dstv4(IpElem2,'Reject'); protov4(IpElem3,'Reject')),
                           nth0(4,T,'dst'), nth0(6,T,IpElem2),
                           nth0(7,T,'proto'), nth0(8,T,IpElem3).
ipv4(T,'Drop') :- is_list(T),length(T,9), nth0(1,T,'src'), nth0(3,T,IpElem1),
                           nth0(4,T,'dst'), nth0(6,T,IpElem2), 
                           nth0(7,T,'proto'), nth0(8,T,IpElem3), (srcv4(IpElem1,'Drop'); dstv4(IpElem2,'Drop'); protov4(IpElem3,'Drop')).
ipv4(T,'Accept') :- is_list(T),length(T,9), nth0(1,T,'src'), nth0(3,T,IpElem1), (srcv4(IpElem1,'Accept'), dstv4(IpElem2,'Accept'), protov4(IpElem3,'Accept')),
                           nth0(4,T,'dst'), nth0(6,T,IpElem2),
                           nth0(7,T,'proto'), nth0(8,T,IpElem3).

ipv4(T,'Reject') :- is_list(T),length(T,9), nth0(1,T,'src'), nth0(3,T,IpElem1),
                           nth0(4,T,'dst'), nth0(6,T,IpElem2), 
                           nth0(7,T,'proto'), nth0(8,T,IpElem3), (srcvdst4(IpElem1,IpElem2,'Reject'); protov4(IpElem3,'Reject')).
ipv4(T,'Drop') :- is_list(T),length(T,9), nth0(1,T,'src'), nth0(3,T,IpElem1),
                           nth0(4,T,'dst'), nth0(6,T,IpElem2), 
                           nth0(7,T,'proto'), nth0(8,T,IpElem3), (srcvdst4(IpElem1,IpElem2,'Drop'); protov4(IpElem3,'Drop')).
ipv4(T,'Accept') :- is_list(T),length(T,9), nth0(1,T,'src'), nth0(3,T,IpElem1),
                           nth0(4,T,'dst'), nth0(6,T,IpElem2),
                           nth0(7,T,'proto'), nth0(8,T,IpElem3), (srcvdst4(IpElem1,IpElem2,'Accept'), protov4(IpElem3,'Accept')).

ipv4(T,Is) :- is_list(T),length(T,9), nth0(1,T,'src'), nth0(3,T,IpElem1),
                           nth0(4,T,'dst'), nth0(6,T,IpElem2),
                           nth0(7,T,'proto'), nth0(8,T,IpElem3), srcvdstprotov4(IpElem1,IpElem2,IpElem3,Is).

ipv4(T,'Accept') :- \+(ipv4(T,'Reject')), \+(ipv4(T,'Drop')).

contain(Addr,B,E) :- (B<Addr;B=Addr), (E>Addr;E=Addr).

srcv4(_,'Accept') :- srcv4_1('any','Accept');addrv4_1('any','Accept').
srcv4(Addr,Value) :- srcv4_1(Addr,Value);addrv4_1(Addr,Value).
srcv4(Addr,Value) :- (srcv4_2(B,E,Value), contain(Addr,B,E));(addrv4_2(B,E,Value), contain(Addr,B,E)).
srcv4(Addr,Value) :- (srcv4_3(T,Value),  member(Addr,T));(addrv4_3(T,Value),  member(Addr,T)).

dstv4(_,Value) :- dstv4_1('any',Value);addrv4_1('any','Accept').
dstv4(Addr,Value) :- dstv4_1(Addr,Value);addrv4_1(Addr,Value).
dstv4(Addr,Value) :- (dstv4_2(B,E,Value), contain(Addr,B,E));(addrv4_2(B,E,Value), contain(Addr,B,E)).
dstv4(Addr,Value) :- (dstv4_3(T,Value),  member(Addr,T));(addrv4_3(T,Value),  member(Addr,T)).

protov4(_,'Accept') :- protov4_1('any','Accept').
protov4(Type,Value) :- protov4_1(Type,Value).
protov4(Type,Value) :- (protov4_2(B,E,Value), contain(Type,B,E)).
protov4(Type,Value) :- protov4_3(T,Value),  member(Type,T).

srcvdst4(Addr1,Addr2,Value) :- srcvdst4_1_1(Addr1,Addr2,Value).
srcvdst4(Addr1,Addr2,Value) :- srcvdst4_1_2(Addr1,B2,E2,Value), contain(Addr2,B2,E2).
srcvdst4(Addr1,Addr2,Value) :- srcvdst4_1_3(Addr1,T2,Value), member(Addr2,T2).

srcvdst4(Addr1,Addr2,Value) :- srcvdst4_2_1(B1,E1,Addr2,Value), contain(Addr1,B1,E1).
srcvdst4(Addr1,Addr2,Value) :- srcvdst4_2_2(B1,E1,B2,E2,Value), contain(Addr1,B1,E1), contain(Addr2,B2,E2).
srcvdst4(Addr1,Addr2,Value) :- srcvdst4_2_3(B1,E1,T2,Value), contain(Addr1,B1,E1), member(Addr2,T2).

srcvdst4(Addr1,Addr2,Value) :- (srcvdst4_3_1(T1,Addr2,Value), member(Addr1,T1)).
srcvdst4(Addr1,Addr2,Value) :- (srcvdst4_3_2(T1,B2,E2,Value),  member(Addr1,T1), contain(Addr2,B2,E2)).
srcvdst4(Addr1,Addr2,Value) :- (srcvdst4_3_3(T1,T2,Value),  member(Addr1,T1), member(Addr2,T2)).

srcvdstprotov4(Addr1,Addr2,Addr3,Value) :- srcvdstproto4_1_1_1(Addr1,Addr2,Addr3,Value).
srcvdstprotov4(Addr1,Addr2,Addr3,Value) :- srcvdstproto4_1_1_2(Addr1,Addr2,B3,E3,Value), contain(Addr3,B3,E3).
srcvdstprotov4(Addr1,Addr2,Addr3,Value) :- srcvdstproto4_1_1_3(Addr1,Addr2,T3,Value), member(Addr3,T3).

srcvdstprotov4(Addr1,Addr2,Addr3,Value) :- srcvdstproto4_1_2_1(Addr1,B2,E2,Addr3,Value), contain(Addr2,B2,E2).
srcvdstprotov4(Addr1,Addr2,Addr3,Value) :- srcvdstproto4_1_2_2(Addr1,B2,E2,B3,E3,Value), contain(Addr2,B2,E2), contain(Addr3,B3,E3).
srcvdstprotov4(Addr1,Addr2,Addr3,Value) :- srcvdstproto4_1_2_3(Addr1,B2,E2,T3,Value), contain(Addr2,B2,E2), member(Addr3,T3).

srcvdstprotov4(Addr1,Addr2,Addr3,Value) :- (srcvdstproto4_1_3_1(Addr1,T2,Addr3,Value), member(Addr2,T2)).
srcvdstprotov4(Addr1,Addr2,Addr3,Value) :- (srcvdstproto4_1_3_2(Addr1,T2,B3,E3,Value),  member(Addr2,T2), contain(Addr3,B3,E3)).
srcvdstprotov4(Addr1,Addr2,Addr3,Value) :- (srcvdstproto4_1_3_3(Addr1,T2,T3,Value),  member(Addr2,T2), member(Addr3,T3)).

srcvdstprotov4(Addr1,Addr2,Addr3,Value) :- srcvdstproto4_2_1_1(B1,E1,Addr2,Addr3,Value),  contain(Addr1,B1,E1).
srcvdstprotov4(Addr1,Addr2,Addr3,Value) :- srcvdstproto4_2_1_2(B1,E1,Addr2,B3,E3,Value),  contain(Addr1,B1,E1), contain(Addr3,B3,E3).
srcvdstprotov4(Addr1,Addr2,Addr3,Value) :- srcvdstproto4_2_1_3(B1,E1,Addr2,T3,Value) ,  contain(Addr1,B1,E1), member(Addr3,T3).

srcvdstprotov4(Addr1,Addr2,Addr3,Value) :- srcvdstproto4_2_2_1(B1,E1,B2,E2,Addr3,Value) ,  contain(Addr1,B1,E1), contain(Addr2,B2,E2).
srcvdstprotov4(Addr1,Addr2,Addr3,Value) :- srcvdstproto4_2_2_2(B1,E1,B2,E2,B3,E3,Value) ,  contain(Addr1,B1,E1), contain(Addr2,B2,E2), contain(Addr3,B3,E3).
srcvdstprotov4(Addr1,Addr2,Addr3,Value) :- srcvdstproto4_2_2_3(B1,E1,B2,E2,T3,Value) ,  contain(Addr1,B1,E1), contain(Addr2,B2,E2), member(Addr3,T3).

srcvdstprotov4(Addr1,Addr2,Addr3,Value) :- (srcvdstproto4_2_3_1(B1,E1,T2,Addr3,Value) ,  contain(Addr1,B1,E1), member(Addr2,T2)).
srcvdstprotov4(Addr1,Addr2,Addr3,Value) :- (srcvdstproto4_2_3_2(B1,E1,T2,B3,E3,Value) ,  contain(Addr1,B1,E1),  member(Addr2,T2), contain(Addr3,B3,E3)).
srcvdstprotov4(Addr1,Addr2,Addr3,Value) :- (srcvdstproto4_2_3_3(B1,E1,T2,T3,Value) ,  contain(Addr1,B1,E1),  member(Addr2,T2), member(Addr3,T3)).

srcvdstprotov4(Addr1,Addr2,Addr3,Value) :- srcvdstproto4_3_1_1(T1,Addr2,Addr3,Value),  member(Addr1,T1).
srcvdstprotov4(Addr1,Addr2,Addr3,Value) :- srcvdstproto4_3_1_2(T1,Addr2,B3,E3,Value),  member(Addr1,T1), contain(Addr3,B3,E3).
srcvdstprotov4(Addr1,Addr2,Addr3,Value) :- srcvdstproto4_3_1_3(T1,Addr2,T3,Value),  member(Addr1,T1), member(Addr3,T3).

srcvdstprotov4(Addr1,Addr2,Addr3,Value) :- srcvdstproto4_3_2_1(T1,B2,E2,Addr3,Value),  member(Addr1,T1), contain(Addr2,B2,E2).
srcvdstprotov4(Addr1,Addr2,Addr3,Value) :- srcvdstproto4_3_2_2(T1,B2,E2,B3,E3,Value),  member(Addr1,T1), contain(Addr2,B2,E2), contain(Addr3,B3,E3).
srcvdstprotov4(Addr1,Addr2,Addr3,Value) :- srcvdstproto4_3_2_3(T1,B2,E2,T3,Value),  member(Addr1,T1), contain(Addr2,B2,E2), member(Addr3,T3).

srcvdstprotov4(Addr1,Addr2,Addr3,Value) :- (srcvdstproto4_3_3_1(T1,T2,Addr3,Value),  member(Addr1,T1),member(Addr2,T2)).
srcvdstprotov4(Addr1,Addr2,Addr3,Value) :- (srcvdstproto4_3_3_2(T1,T2,B3,E3,Value),    member(Addr1,T1),member(Addr2,T2), contain(Addr3,B3,E3)).
srcvdstprotov4(Addr1,Addr2,Addr3,Value) :- (srcvdstproto4_3_3_3(T1,T2,T3,Value),    member(Addr1,T1), member(Addr2,T2), member(Addr3,T3)).


ipv6(T,'Reject') :- is_list(T),length(T,9), nth0(1,T,'src'), nth0(3,T,IpElem1), (srcv6(IpElem1,'Reject'); dstv6(IpElem2,'Reject'); protov6(IpElem3,'Reject')),
                           nth0(4,T,'dst'), nth0(6,T,IpElem2),
                           nth0(7,T,'proto'), nth0(8,T,IpElem3).
ipv6(T,'Drop') :- is_list(T),length(T,9), nth0(1,T,'src'), nth0(3,T,IpElem1),
                           nth0(4,T,'dst'), nth0(6,T,IpElem2), 
                           nth0(7,T,'proto'), nth0(8,T,IpElem3), (srcv6(IpElem1,'Drop'); dstv6(IpElem2,'Drop'); protov6(IpElem3,'Drop')).
ipv6(T,'Accept') :- is_list(T),length(T,9), nth0(1,T,'src'), nth0(3,T,IpElem1), (srcv6(IpElem1,'Accept'), dstv6(IpElem2,'Accept'), protov6(IpElem3,'Accept')),
                           nth0(4,T,'dst'), nth0(6,T,IpElem2),
                           nth0(7,T,'proto'), nth0(8,T,IpElem3).

ipv6(T,'Reject') :- is_list(T),length(T,9), nth0(1,T,'src'), nth0(3,T,IpElem1),
                           nth0(4,T,'dst'), nth0(6,T,IpElem2), 
                           nth0(7,T,'proto'), nth0(8,T,IpElem3), (srcvdst6(IpElem1,IpElem2,'Reject'); protov6(IpElem3,'Reject')).
ipv6(T,'Drop') :- is_list(T),length(T,9), nth0(1,T,'src'), nth0(3,T,IpElem1),
                           nth0(4,T,'dst'), nth0(6,T,IpElem2), 
                           nth0(4,T,'proto'), nth0(8,T,IpElem3), (srcvdst6(IpElem1,IpElem2,'Drop'); protov6(IpElem3,'Drop')).
ipv6(T,'Accept') :- is_list(T),length(T,9), nth0(1,T,'src'), nth0(3,T,IpElem1),
                           nth0(4,T,'dst'), nth0(6,T,IpElem2),
                           nth0(7,T,'proto'), nth0(8,T,IpElem3), (srcvdst6(IpElem1,IpElem2,'Accept'), protov6(IpElem3,'Accept')).

ipv6(T,Is) :- is_list(T),length(T,9), nth0(1,T,'src'), nth0(3,T,IpElem1),
                           nth0(4,T,'dst'), nth0(6,T,IpElem2),
                           nth0(7,T,'proto'), nth0(8,T,IpElem3), srcvdstprotov6(IpElem1,IpElem2,IpElem3,Is).

ipv6(T,'Accept') :- \+(ipv6(T,'Reject')), \+(ipv6(T,'Drop')).

srcv6(_,'Accept') :- srcv6_1('any','Accept');addrv6_1('any','Accept').
dstv6(_,Value) :- dstv6_1('any',Value);addrv6_1('any','Accept').
protov6(_,'Accept') :- protov6_1('any','Accept').
srcv6(Addr,Value) :- srcv6_1(Addr,Value);addrv6_1(Addr,Value).
srcv6(Addr,Value) :- (srcv6_2(B,E,Value), contain(Addr,B,E));(addrv6_2(B,E,Value), contain(Addr,B,E)).
srcv6(Addr,Value) :- (srcv6_3(T,Value),  member(Addr,T));(addrv6_3(T,Value),  member(Addr,T)).

dstv6(Addr,Value) :- dstv6_1(Addr,Value);addrv6_1(Addr,Value).
dstv6(Addr,Value) :- (dstv6_2(B,E,Value), contain(Addr,B,E));(addrv6_2(B,E,Value), contain(Addr,B,E)).
dstv6(Addr,Value) :- (dstv6_3(T,Value),  member(Addr,T));(addrv6_3(T,Value),  member(Addr,T)).

protov6(Type,Value) :- protov6_1(Type,Value).
protov6(Type,Value) :- (protov6_2(B,E,Value), contain(Type,B,E)).
protov6(Type,Value) :- protov6_3(T,Value),  member(Type,T).

srcvdst6(Addr1,Addr2,Value) :- srcvdst6_1_1(Addr1,Addr2,Value).
srcvdst6(Addr1,Addr2,Value) :- srcvdst6_1_2(Addr1,B2,E2,Value), contain(Addr2,B2,E2).
srcvdst6(Addr1,Addr2,Value) :- srcvdst6_1_3(Addr1,T2,Value), member(Addr2,T2).

srcvdst6(Addr1,Addr2,Value) :- srcvdst6_2_1(B1,E1,Addr2,Value), contain(Addr1,B1,E1).
srcvdst6(Addr1,Addr2,Value) :- srcvdst6_2_2(B1,E1,B2,E2,Value), contain(Addr1,B1,E1), contain(Addr2,B2,E2).
srcvdst6(Addr1,Addr2,Value) :- srcvdst6_2_3(B1,E1,T2,Value), contain(Addr1,B1,E1), member(Addr2,T2).

srcvdst6(Addr1,Addr2,Value) :- (srcvdst6_3_1(T1,Addr2,Value), member(Addr1,T1)).
srcvdst6(Addr1,Addr2,Value) :- (srcvdst6_3_2(T1,B2,E2,Value),  member(Addr1,T1), contain(Addr2,B2,E2)).
srcvdst6(Addr1,Addr2,Value) :- (srcvdst6_3_3(T1,T2,Value),  member(Addr1,T1), member(Addr2,T2)).

srcvdstprotov6(Addr1,Addr2,Addr3,Value) :- srcvdstproto6_1_1_1(Addr1,Addr2,Addr3,Value).
srcvdstprotov6(Addr1,Addr2,Addr3,Value) :- srcvdstproto6_1_1_2(Addr1,Addr2,B3,E3,Value), contain(Addr3,B3,E3).
srcvdstprotov6(Addr1,Addr2,Addr3,Value) :- srcvdstproto6_1_1_3(Addr1,Addr2,T3,Value), member(Addr3,T3).

srcvdstprotov6(Addr1,Addr2,Addr3,Value) :- srcvdstproto6_1_2_1(Addr1,B2,E2,Addr3,Value), contain(Addr2,B2,E2).
srcvdstprotov6(Addr1,Addr2,Addr3,Value) :- srcvdstproto6_1_2_2(Addr1,B2,E2,B3,E3,Value), contain(Addr2,B2,E2), contain(Addr3,B3,E3).
srcvdstprotov6(Addr1,Addr2,Addr3,Value) :- srcvdstproto6_1_2_3(Addr1,B2,E2,T3,Value), contain(Addr2,B2,E2), member(Addr3,T3).

srcvdstprotov6(Addr1,Addr2,Addr3,Value) :- (srcvdstproto6_1_3_1(Addr1,T2,Addr3,Value), member(Addr2,T2)).
srcvdstprotov6(Addr1,Addr2,Addr3,Value) :- (srcvdstproto6_1_3_2(Addr1,T2,B3,E3,Value),  member(Addr2,T2), contain(Addr3,B3,E3)).
srcvdstprotov6(Addr1,Addr2,Addr3,Value) :- (srcvdstproto6_1_3_3(Addr1,T2,T3,Value),  member(Addr2,T2), member(Addr3,T3)).

srcvdstprotov6(Addr1,Addr2,Addr3,Value) :- srcvdstproto6_2_1_1(B1,E1,Addr2,Addr3,Value),  contain(Addr1,B1,E1).
srcvdstprotov6(Addr1,Addr2,Addr3,Value) :- srcvdstproto6_2_1_2(B1,E1,Addr2,B3,E3,Value),  contain(Addr1,B1,E1), contain(Addr3,B3,E3).
srcvdstprotov6(Addr1,Addr2,Addr3,Value) :- srcvdstproto6_2_1_3(B1,E1,Addr2,T3,Value) ,  contain(Addr1,B1,E1), member(Addr3,T3).

srcvdstprotov6(Addr1,Addr2,Addr3,Value) :- srcvdstproto6_2_2_1(B1,E1,B2,E2,Addr3,Value) ,  contain(Addr1,B1,E1), contain(Addr2,B2,E2).
srcvdstprotov6(Addr1,Addr2,Addr3,Value) :- srcvdstproto6_2_2_2(B1,E1,B2,E2,B3,E3,Value) ,  contain(Addr1,B1,E1), contain(Addr2,B2,E2), contain(Addr3,B3,E3).
srcvdstprotov6(Addr1,Addr2,Addr3,Value) :- srcvdstproto6_2_2_3(B1,E1,B2,E2,T3,Value) ,  contain(Addr1,B1,E1), contain(Addr2,B2,E2), member(Addr3,T3).

srcvdstprotov6(Addr1,Addr2,Addr3,Value) :- (srcvdstproto6_2_3_1(B1,E1,T2,Addr3,Value) ,  contain(Addr1,B1,E1), member(Addr2,T2)).
srcvdstprotov6(Addr1,Addr2,Addr3,Value) :- (srcvdstproto6_2_3_2(B1,E1,T2,B3,E3,Value) ,  contain(Addr1,B1,E1),  member(Addr2,T2), contain(Addr3,B3,E3)).
srcvdstprotov6(Addr1,Addr2,Addr3,Value) :- (srcvdstproto6_2_3_3(B1,E1,T2,T3,Value) ,  contain(Addr1,B1,E1),  member(Addr2,T2), member(Addr3,T3)).

srcvdstprotov6(Addr1,Addr2,Addr3,Value) :- srcvdstproto6_3_1_1(T1,Addr2,Addr3,Value),  member(Addr1,T1).
srcvdstprotov6(Addr1,Addr2,Addr3,Value) :- srcvdstproto6_3_1_2(T1,Addr2,B3,E3,Value),  member(Addr1,T1), contain(Addr3,B3,E3).
srcvdstprotov6(Addr1,Addr2,Addr3,Value) :- srcvdstproto6_3_1_3(T1,Addr2,T3,Value),  member(Addr1,T1), member(Addr3,T3).

srcvdstprotov6(Addr1,Addr2,Addr3,Value) :- srcvdstproto6_3_2_1(T1,B2,E2,Addr3,Value),  member(Addr1,T1), contain(Addr2,B2,E2).
srcvdstprotov6(Addr1,Addr2,Addr3,Value) :- srcvdstproto6_3_2_2(T1,B2,E2,B3,E3,Value),  member(Addr1,T1), contain(Addr2,B2,E2), contain(Addr3,B3,E3).
srcvdstprotov6(Addr1,Addr2,Addr3,Value) :- srcvdstproto6_3_2_3(T1,B2,E2,T3,Value),  member(Addr1,T1), contain(Addr2,B2,E2), member(Addr3,T3).

srcvdstprotov6(Addr1,Addr2,Addr3,Value) :- (srcvdstproto6_3_3_1(T1,T2,Addr3,Value),  member(Addr1,T1),member(Addr2,T2)).
srcvdstprotov6(Addr1,Addr2,Addr3,Value) :- (srcvdstproto6_3_3_2(T1,T2,B3,E3,Value),    member(Addr1,T1),member(Addr2,T2), contain(Addr3,B3,E3)).
srcvdstprotov6(Addr1,Addr2,Addr3,Value) :- (srcvdstproto6_3_3_3(T1,T2,T3,Value),    member(Addr1,T1), member(Addr2,T2), member(Addr3,T3)).








%	ICMP RULES

icmp_type(X,Y):- icmp_type_2([H|T],Y) , member(X,[H|T]).
icmp_type(X,Y):- icmp_type_3(L,U,Y), (X>L ; X=L) ,  (X<U ; X=U).

icmp_code(X,Y):- icmp_code_2([H|T],Y) , member(X,[H|T]).
icmp_code(X,Y):- icmp_code_3(L,U,Y), (X>L ; X=L) ,  (X<U ; X=U).


icmp_type_code(X,Y,Z):- icmp_type_code_12(X,[H|T],Z), member(Y,[H|T]).
icmp_type_code(X,Y,Z):- icmp_type_code_13(X,L,U,Z), (Y>L ; Y=L) ,  (Y<U ; Y=U).
icmp_type_code(X,Y,Z):- icmp_type_code_21([H|T],Y,Z), member(X,[H|T]).
icmp_type_code(X,Y,Z):- icmp_type_code_22([H1|T1],[H2|T2],Z), member(Y,[H2|T2]), member(X,[H1|T1]).
icmp_type_code(X,Y,Z):- icmp_type_code_23([H1|T1],L,U,Z), (Y>L ; Y=L), (Y<U ; Y=U), member(X,[H1|T1]).
icmp_type_code(X,Y,Z):- icmp_type_code_31(L,U,Y,Z), (X>L ; X=L) , (X<U ; X=U).
icmp_type_code(X,Y,Z):- icmp_type_code_32(L,U,[H|T],Z), (X>L ; X=L) , (X<U ; X=U), member(Y,[H|T]).
icmp_type_code(X,Y,Z):- icmp_type_code_33(L1,U1,L2,U2,Z), (X>L1 ; X=L1) , (X<U1; X=U1), (Y>L2 ; Y=L2) , (Y<U2 ; Y=U2).


icmp_type(Y,'Accept'):- \+((icmp_type(Y,'Reject');icmp_type(Y,'Drop'))).

icmp_code(Y,'Accept'):- \+((icmp_code(Y,'Reject');icmp_code(Y,'Drop'))).

icmp_type_code(X,Y,'Accept'):- \+((icmp_type_code(X,Y,'Reject'); icmp_type_code(X,Y,'Drop'))).


icmp('_','Accept').
icmp(IcmpList,Return):-is_list(IcmpList),
length(IcmpList,5), nth0(0,IcmpList,'icmp'), nth0(1,IcmpList,'type'),nth0(2,IcmpList,Type), icmp_type(Type,X), nth0(3,IcmpList,'code'),nth0(4,IcmpList,Code), icmp_code(Code,Y),icmp_type_code(Type,Code,Z),final(X,Y,Z,Return).





final(X,Y,Z,'Reject'):- (X='Reject' ; Y='Reject'; Z='Reject').
final(X,Y,Z,'Drop'):- \+(X='Reject' ; Y='Reject' ; Z='Reject') , (X='Drop' ; Y='Drop' ; Z='Drop').
final(X,Y,Z,'Accept'):- X='Accept' , Y='Accept', Z='Accept'.




%	icmpv6 RULES


icmpv6_type(X,Y):- icmpv6_type_2([H|T],Y) , member(X,[H|T]).
icmpv6_type(X,Y):- icmpv6_type_3(L,U,Y), (X>L ; X=L) ,  (X<U ; X=U).

icmpv6_code(X,Y):- icmpv6_code_2([H|T],Y) , member(X,[H|T]).
icmpv6_code(X,Y):- icmpv6_code_3(L,U,Y), (X>L ; X=L) ,  (X<U ; X=U).

icmpv6_type_code(X,Y,Z):- icmpv6_type_code_12(X,[H|T],Z), member(Y,[H|T]).
icmpv6_type_code(X,Y,Z):- icmpv6_type_code_13(X,L,U,Z), (Y>L ; Y=L) ,  (Y<U ; Y=U).
icmpv6_type_code(X,Y,Z):- icmpv6_type_code_21([H|T],Y,Z), member(X,[H|T]).
icmpv6_type_code(X,Y,Z):- icmpv6_type_code_22([H1|T1],[H2|T2],Z), member(Y,[H2|T2]), member(X,[H1|T1]).
icmpv6_type_code(X,Y,Z):- icmpv6_type_code_23([H1|T1],L,U,Z), (Y>L ; Y=L), (Y<U ; Y=U), member(X,[H1|T1]).
icmpv6_type_code(X,Y,Z):- icmpv6_type_code_31(L,U,Y,Z), (X>L ; X=L) , (X<U ; X=U).
icmpv6_type_code(X,Y,Z):- icmpv6_type_code_32(L,U,[H|T],Z), (X>L ; X=L) , (X<U ; X=U), member(Y,[H|T]).
icmpv6_type_code(X,Y,Z):- icmpv6_type_code_33(L1,U1,L2,U2,Z), (X>L1 ; X=L1) , (X<U1; X=U1), (Y>L2 ; Y=L2) , (Y<U2 ; Y=U2).


icmpv6_type(Y,'Accept'):- \+((icmpv6_type(Y,'Reject');icmpv6_type(Y,'Drop'))).

icmpv6_code(Y,'Accept'):- \+((icmpv6_code(Y,'Reject');icmpv6_code(Y,'Drop'))).

icmpv6_type_code(X,Y,'Accept'):- \+((icmpv6_type_code(X,Y,'Reject'); icmpv6_type_code(X,Y,'Drop'))).


icmpv6('_','Accept').
icmpv6(Icmpv6List,Return2):-
(is_list(Icmpv6List),length(Icmpv6List,5), nth0(0,Icmpv6List,'icmpv6'), nth0(1,Icmpv6List,'type'),nth0(2,Icmpv6List,Type), icmpv6_type(Type,X), nth0(3,Icmpv6List,'code'),nth0(4,Icmpv6List,Code), icmpv6_code(Code,Y),icmpv6_type_code(Type,Code,Z),final2(X,Y,Z,Return2)).



final2(X,Y,Z,'Reject'):- (X='Reject' ; Y='Reject' ; Z='Reject').
final2(X,Y,Z,'Drop'):- \+(X='Reject' ; Y='Reject' ; Z='Reject') , (X='Drop' ; Y='Drop' ; Z='Drop').
final2(X,Y,Z,'Accept'):- X='Accept' , Y='Accept', Z='Accept'.


%TCP Conditions

tcp_compare(A,B,'Accept'):-A='Accept',B='Accept'.
tcp_compare(A,B,'Reject'):- A='Reject';B='Reject'.
tcp_compare(A,B,'Drop'):-A='Drop';B='Drop'.

tcp2(Dst,'Reject'):-tcp_ports(A,B,'Reject'),(A<Dst;A=Dst),(B>Dst;B=Dst).
tcp2(Dst,'Accept'):-tcp_ports(A,B,'Accept'),(A<Dst;A=Dst),(B>Dst;B=Dst).
tcp2(Dst,'Drop'):-tcp_ports(A,B,'Drop'),(A<Dst;A=Dst),(B>Dst;B=Dst).

%Double Ranges for TCP
tcprange(Dst,Src,'Reject'):-tcp_ports(Dst1,Dst2,A,B,'Reject'),(A<Src;A=Src),(B>Src;B=Src),(Dst1<Dst;Dst1=Dst),(Dst2>Dst;Dst2=Dst).
tcprange(Dst,Src,'Accept'):-tcp_ports(Dst1,Dst2,A,B,'Accept'),(A<Src;A=Src),(B>Src;B=Src),(Dst1<Dst;Dst1=Dst),(Dst2>Dst;Dst2=Dst).
tcprange(Dst,Src,'Drop'):-tcp_ports(Dst1,Dst2,A,B,'Drop'),(A<Src;A=Src),(B>Src;B=Src),(Dst1<Dst;Dst1=Dst),(Dst2>Dst;Dst2=Dst).
tcprange(Dst,Src,'Accept').



tcp3(Dst,Src,'Reject'):-tcp_ports(Dst,A,B,'Reject'),(A<Src;A=Src),(B>Src;B=Src).
tcp3(Dst,Src,'Accept'):-tcp_ports(Dst,A,B,'Accept'),(A<Src;A=Src),(B>Src;B=Src).
tcp3(Dst,Src,'Drop'):-tcp_ports(Dst,A,B,'Drop'),(A<Src;A=Src),(B>Src;B=Src).


tcp6(A,B,'Reject'):-tcp_ports(Src,Dst,'Reject'),is_list(Src),is_list(Dst),(member(Src,A,Z),member(Dst,B,Z)).
tcp6(A,B,'Drop'):-tcp_ports(Src,Dst,'Drop'),is_list(Src),is_list(Dst),member(Dst,B,Z),(member(Src,A,Z)).
tcp6(A,B,'Accept'):-tcp_ports(Src,Dst,'Accept'),is_list(Src),is_list(Dst),member(Dst,B,Z),member(Src,A,Z).

tcp4(A,B,'Reject'):-tcp_ports(A,Dst,'Reject'),is_list(Dst),member(Dst,B,Z).
tcp4(A,B,'Drop'):-tcp_ports(A,Dst,'Drop'),is_list(Dst),member(Dst,B,Z).
tcp4(A,B,'Accept'):-tcp_ports(A,Dst,'Accept'),is_list(Dst),member(Dst,B,Z).

tcp5(B,'Reject'):-tcp_ports(Dst,'Reject'),is_list(Dst),member(Dst,B,Z).
tcp5(B,'Drop'):-tcp_ports(Dst,'Drop'),is_list(Dst),member(Dst,B,Z).
tcp5(B,'Accept'):-tcp_ports(Dst,'Accept'),is_list(Dst),member(Dst,B,Z).




%THis is fine(orig))
tcp(TcpCmdList,Answer):- length(TcpCmdList,7), nth0(0,TcpCmdList,'tcp'), nth0(1,TcpCmdList,'dst'), nth0(2,TcpCmdList,'port'),nth0(3,TcpCmdList,Port1),nth0(4,TcpCmdList,'src'),nth0(6,TcpCmdList,Port2),tcp6(Port1,Port2,Answer).

tcp(TcpCmdList,Answer):- length(TcpCmdList,7), nth0(0,TcpCmdList,'tcp'), nth0(1,TcpCmdList,'dst'), nth0(2,TcpCmdList,'port'),nth0(3,TcpCmdList,Port1),nth0(4,TcpCmdList,'src'),nth0(6,TcpCmdList,Port2),tcp4(Port1,Port2,Answer).

tcp(TcpCmdList,Answer):- length(TcpCmdList,7), nth0(0,TcpCmdList,'tcp'), nth0(1,TcpCmdList,'dst'), nth0(2,TcpCmdList,'port'),nth0(3,TcpCmdList,Port1), dst_port(Port1,Answer1),Answer1='Reject',nth0(4,TcpCmdList,'src'),nth0(6,TcpCmdList,Port2), tcp_src_port(Port2,Answer),Answer='Reject'.
tcp(TcpCmdList,Answer):- length(TcpCmdList,7), nth0(0,TcpCmdList,'tcp'), nth0(1,TcpCmdList,'dst'), nth0(2,TcpCmdList,'port'),nth0(3,TcpCmdList,Port1), tcp_dst_port(Port1,Answer),(Answer='Reject').
tcp(TcpCmdList,Answer):- length(TcpCmdList,7), nth0(0,TcpCmdList,'tcp'), nth0(1,TcpCmdList,'dst'), nth0(2,TcpCmdList,'port'),nth0(4,TcpCmdList,'src'),nth0(6,TcpCmdList,Port2), tcp_src_port(Port2,Answer),Answer='Reject'.

tcp(TcpCmdList,Answer):- length(TcpCmdList,4), nth0(0,TcpCmdList,'tcp'), nth0(1,TcpCmdList,'src'), nth0(2,TcpCmdList,'port'),nth0(3,TcpCmdList,Port), tcp_src_port(Port,Answer),(Answer='Reject').
tcp(TcpCmdList,Answer):- length(TcpCmdList,4), nth0(0,TcpCmdList,'tcp'), nth0(1,TcpCmdList,'dst'), nth0(2,TcpCmdList,'port'),nth0(3,TcpCmdList,Port), tcp_dst_port(Port,Answer),(Answer='Reject').


tcp(TcpCmdList,Answer):- length(TcpCmdList,7), nth0(0,TcpCmdList,'tcp'), nth0(1,TcpCmdList,'dst'), nth0(2,TcpCmdList,'port'),nth0(3,TcpCmdList,Port1), dst_port(Port1,Answer),Answer='Drop',nth0(4,TcpCmdList,'src'),nth0(6,TcpCmdList,Port2), tcp_src_port(Port2,Answer).
tcp(TcpCmdList,Answer):- length(TcpCmdList,7), nth0(0,TcpCmdList,'tcp'), nth0(1,TcpCmdList,'dst'), nth0(2,TcpCmdList,'port'),nth0(4,TcpCmdList,'src'),nth0(6,TcpCmdList,Port2), tcp_src_port(Port2,Answer).
tcp(TcpCmdList,Answer):- length(TcpCmdList,7), nth0(0,TcpCmdList,'tcp'), nth0(1,TcpCmdList,'dst'), nth0(2,TcpCmdList,'port'),nth0(3,TcpCmdList,Port1), tcp_dst_port(Port1,Answer).
tcp(TcpCmdList,Answer):- length(TcpCmdList,7), nth0(0,TcpCmdList,'tcp'), nth0(1,TcpCmdList,'dst'), nth0(2,TcpCmdList,'port'),nth0(4,TcpCmdList,'src'),nth0(6,TcpCmdList,Port2), tcp_src_port(Port2,Answer).

tcp(TcpCmdList,Answer):- length(TcpCmdList,4), nth0(0,TcpCmdList,'tcp'), nth0(1,TcpCmdList,'src'), nth0(2,TcpCmdList,'port'),nth0(3,TcpCmdList,Port), tcp_src_port(Port,Answer).
tcp(TcpCmdList,Answer):- length(TcpCmdList,4), nth0(0,TcpCmdList,'tcp'), nth0(1,TcpCmdList,'dst'), nth0(2,TcpCmdList,'port'),nth0(3,TcpCmdList,Port), tcp_dst_port(Port,Answer).



tcp(TcpCmdList,Answer):- length(TcpCmdList,4), nth0(0,TcpCmdList,'tcp'), nth0(1,TcpCmdList,'src'), nth0(2,TcpCmdList,'port'),nth0(3,TcpCmdList,Port), tcp_src_port(Port,Answer).

tcp(TcpCmdList,Answer):- length(TcpCmdList,4), nth0(0,TcpCmdList,'tcp'), nth0(1,TcpCmdList,'dst'), nth0(2,TcpCmdList,'port'),nth0(3,TcpCmdList,Port), tcp2(Port,Answer).

tcp(TcpCmdList,Answer):- length(TcpCmdList,4), nth0(0,TcpCmdList,'tcp'), nth0(1,TcpCmdList,'dst'), nth0(2,TcpCmdList,'port'),nth0(3,TcpCmdList,Port), tcp5(Port,Answer).



tcp(TcpCmdList,Answer):- length(TcpCmdList,4), nth0(0,TcpCmdList,'tcp'), nth0(1,TcpCmdList,'dst'), nth0(2,TcpCmdList,'port'),nth0(3,TcpCmdList,Port), tcp_dst_port(Port,Answer).

tcp(TcpCmdList,Answer):- length(TcpCmdList,7), nth0(0,TcpCmdList,'tcp'), nth0(1,TcpCmdList,'dst'), nth0(2,TcpCmdList,'port'),nth0(3,TcpCmdList,Port1),nth0(4,TcpCmdList,'src'),nth0(6,TcpCmdList,Port2),tcp3(Port1,Port2,Answer).

tcp(TcpCmdList,Answer):- length(TcpCmdList,7), nth0(0,TcpCmdList,'tcp'), nth0(1,TcpCmdList,'dst'), nth0(2,TcpCmdList,'port'),nth0(3,TcpCmdList,Port1),nth0(4,TcpCmdList,'src'),nth0(6,TcpCmdList,Port2),tcprange(Port1,Port2,Answer).

tcp(TcpCmdList,Answer):- length(TcpCmdList,7), nth0(0,TcpCmdList,'tcp'), nth0(1,TcpCmdList,'dst'), nth0(2,TcpCmdList,'port'),nth0(3,TcpCmdList,Port1), tcp_dst_port(Port1,Answer1),nth0(4,TcpCmdList,'src'),nth0(6,TcpCmdList,Port2), tcp_src_port(Port2,Answer2),tcp_compare(Answer1,Answer2,Answer).

tcp(TcpCmdList,Answer):- length(TcpCmdList,7), nth0(0,TcpCmdList,'tcp'), nth0(1,TcpCmdList,'dst'), nth0(2,TcpCmdList,'port'),nth0(3,TcpCmdList,Port1), dst_port(Port1,Answer1),\+(Answer1='Reject'),nth0(4,TcpCmdList,'src'),nth0(6,TcpCmdList,Port2), tcp_src_port(Port2,Answer).


tcp(TcpCmdList,'Accept').

%UDP Conditions
udp_compare(A,B,'Accept'):-A='Accept',B='Accept'.
udp_compare(A,B,'Reject'):- A='Reject';B='Reject'.
udp_compare(A,B,'Drop'):-A='Drop';B='Drop'.

udprange(Dst,Src,'Reject'):-udp_ports(Dst1,Dst2,A,B,'Reject'),(A<Src;A=Src),(B>Src;B=Src),(Dst1<Dst;Dst1=Dst),(Dst2>Dst;Dst2=Dst).
udprange(Dst,Src,'Accept'):-udp_ports(Dst1,Dst2,A,B,'Accept'),(A<Src;A=Src),(B>Src;B=Src),(Dst1<Dst;Dst1=Dst),(Dst2>Dst;Dst2=Dst).
udprange(Dst,Src,'Drop'):-udp_ports(Dst1,Dst2,A,B,'Drop'),(A<Src;A=Src),(B>Src;B=Src),(Dst1<Dst;Dst1=Dst),(Dst2>Dst;Dst2=Dst).
udprange(Dst,Src,'Accept').


udp2(Dst,'Reject'):-udp_ports(A,B,'Reject'),(A<Dst;A=Dst),(B>Dst;B=Dst).
udp2(Dst,'Accept'):-udp_ports(A,B,'Accept'),(A<Dst;A=Dst),(B>Dst;B=Dst).
udp2(Dst,'Drop'):-udp_ports(A,B,'Drop'),(A<Dst;A=Dst),(B>Dst;B=Dst).

udp3(Dst,Src,'Reject'):-udp_ports(Dst,A,B,'Reject'),(A<Src;A=Src),(B>Src;B=Src).
udp3(Dst,Src,'Accept'):-udp_ports(Dst,A,B,'Accept'),(A<Src;A=Src),(B>Src;B=Src).
udp3(Dst,Src,'Drop'):-udp_ports(Dst,A,B,'Drop'),(A<Src;A=Src),(B>Src;B=Src).


udp6(A,B,'Reject'):-udp_ports(Src,Dst,'Reject'),is_list(Src),is_list(Dst),(member(Src,A,Z),member(Dst,B,Z)).
udp6(A,B,'Drop'):-udp_ports(Src,Dst,'Drop'),is_list(Src),is_list(Dst),member(Dst,B,Z),(member(Src,A,Z)).
udp6(A,B,'Accept'):-udp_ports(Src,Dst,'Accept'),is_list(Src),is_list(Dst),member(Dst,B,Z),member(Src,A,Z).


udp4(A,B,'Reject'):-udp_ports(A,Dst,'Reject'),is_list(Dst),member(Dst,B,Z).
udp4(A,B,'Drop'):-udp_ports(A,Dst,'Drop'),is_list(Dst),member(Dst,B,Z).
udp4(A,B,'Accept'):-udp_ports(A,Dst,'Accept'),is_list(Dst),member(Dst,B,Z).

udp5(B,'Reject'):-udp_ports(Dst,'Reject'),is_list(Dst),member(Dst,B,Z).
udp5(B,'Drop'):-udp_ports(Dst,'Drop'),is_list(Dst),member(Dst,B,Z).
udp5(B,'Accept'):-udp_ports(Dst,'Accept'),is_list(Dst),member(Dst,B,Z).


udp(UdpCmdList,Answer):- length(UdpCmdList,7), nth0(0,UdpCmdList,'udp'), nth0(1,UdpCmdList,'dst'), nth0(2,UdpCmdList,'port'),nth0(3,UdpCmdList,Port1),nth0(4,UdpCmdList,'src'),nth0(6,UdpCmdList,Port2),udp6(Port1,Port2,Answer).

udp(UdpCmdList,Answer):- length(UdpCmdList,7), nth0(0,UdpCmdList,'udp'), nth0(1,UdpCmdList,'dst'), nth0(2,UdpCmdList,'port'),nth0(3,UdpCmdList,Port1),nth0(4,UdpCmdList,'src'),nth0(6,UdpCmdList,Port2),udp4(Port1,Port2,Answer).

udp(UdpCmdList,Answer):- length(UdpCmdList,7), nth0(0,UdpCmdList,'udp'), nth0(1,UdpCmdList,'dst'), nth0(2,UdpCmdList,'port'),nth0(3,UdpCmdList,Port1), dst_port(Port1,Answer1),Answer1='Reject',nth0(4,TcpCmdList,'src'),nth0(6,TcpCmdList,Port2), udp_src_port(Port2,Answer),Answer='Reject'.
udp(UdpCmdList,Answer):- length(UdpCmdList,7), nth0(0,UdpCmdList,'udp'), nth0(1,UdpCmdList,'dst'), nth0(2,UdpCmdList,'port'),nth0(3,UdpCmdList,Port1), udp_dst_port(Port1,Answer),(Answer='Reject').
udp(UdpCmdList,Answer):- length(UdpCmdList,7), nth0(0,UdpCmdList,'udp'), nth0(1,UdpCmdList,'dst'), nth0(2,UdpCmdList,'port'),nth0(4,UdpCmdList,'src'),nth0(6,UdpCmdList,Port2), udp_src_port(Port2,Answer),Answer='Reject'.

udp(UdpCmdList,Answer):- length(UdpCmdList,4), nth0(0,UdpCmdList,'udp'), nth0(1,UdpCmdList,'src'), nth0(2,UdpCmdList,'port'),nth0(3,UdpCmdList,Port), udp_src_port(Port,Answer),(Answer='Reject').
udp(UdpCmdList,Answer):- length(UdpCmdList,4), nth0(0,UdpCmdList,'udp'), nth0(1,UdpCmdList,'src'), nth0(2,UdpCmdList,'port'),nth0(3,UdpCmdList,Port), udp_src_port(Port,Answer),Answer='Reject'.
udp(UdpCmdList,Answer):- length(UdpCmdList,4), nth0(0,UdpCmdList,'udp'), nth0(1,UdpCmdList,'dst'), nth0(2,UdpCmdList,'port'),nth0(3,UdpCmdList,Port), udp_dst_port(Port,Answer),(Answer='Reject'),nl.

udp(UdpCmdList,Answer):- length(UdpCmdList,7), nth0(0,UdpCmdList,'udp'), nth0(1,UdpCmdList,'dst'), nth0(2,UdpCmdList,'port'),nth0(3,UdpCmdList,Port1), dst_port(Port1,Answer),Answer='Drop',nth0(4,UdpCmdList,'src'),nth0(6,UdpCmdList,Port2), udp_src_port(Port2,Answer).
udp(UdpCmdList,Answer):- length(UdpCmdList,7), nth0(0,UdpCmdList,'udp'), nth0(1,UdpCmdList,'dst'), nth0(2,UdpCmdList,'port'),nth0(4,UdpCmdList,'src'),nth0(6,UdpCmdList,Port2), udp_src_port(Port2,Answer).
udp(UdpCmdList,Answer):- length(UdpCmdList,7), nth0(0,UdpCmdList,'udp'), nth0(1,UdpCmdList,'dst'), nth0(2,UdpCmdList,'port'),nth0(3,UdpCmdList,Port1), udp_dst_port(Port1,Answer).
udp(UdpCmdList,Answer):- length(UdpCmdList,7), nth0(0,UdpCmdList,'udp'), nth0(1,UdpCmdList,'dst'), nth0(2,UdpCmdList,'port'),nth0(4,UdpCmdList,'src'),nth0(6,UdpCmdList,Port2), udp_src_port(Port2,Answer).


udp(UdpCmdList,Answer):- length(UdpCmdList,4), nth0(0,UdpCmdList,'udp'), nth0(1,UdpCmdList,'src'), nth0(2,UdpCmdList,'port'),nth0(3,UdpCmdList,Port), udp_src_port(Port,Answer).

udp(UdpCmdList,Answer):- length(UdpCmdList,4), nth0(0,UdpCmdList,'udp'), nth0(1,UdpCmdList,'dst'), nth0(2,UdpCmdList,'port'),nth0(3,UdpCmdList,Port), udp2(Port,Answer).


udp(UdpCmdList,Answer):- length(UdpCmdList,4), nth0(0,UdpCmdList,'udp'), nth0(1,UdpCmdList,'dst'), nth0(2,UdpCmdList,'port'),nth0(3,UdpCmdList,Port), udp5(Port,Answer).


udp(UdpCmdList,Answer):- length(UdpCmdList,4), nth0(0,UdpCmdList,'udp'), nth0(1,UdpCmdList,'dst'), nth0(2,UdpCmdList,'port'),nth0(3,UdpCmdList,Port), udp_dst_port(Port,Answer).

udp(UdpCmdList,Answer):- length(UdpCmdList,7), nth0(0,UdpCmdList,'udp'), nth0(1,UdpCmdList,'dst'), nth0(2,UdpCmdList,'port'),nth0(3,UdpCmdList,Port1),nth0(4,UdpCmdList,'src'),nth0(6,UdpCmdList,Port2),(udp3(Port1,Port2,Answer)).

udp(UdpCmdList,Answer):- length(UdpCmdList,7), nth0(0,UdpCmdList,'udp'), nth0(1,UdpCmdList,'dst'), nth0(2,UdpCmdList,'port'),nth0(3,UdpCmdList,Port1),nth0(4,UdpCmdList,'src'),nth0(6,UdpCmdList,Port2),udprange(Port1,Port2,Answer).


udp(TcpCmdList,Answer):- length(TcpCmdList,7), nth0(0,TcpCmdList,'udp'), nth0(1,TcpCmdList,'dst'), nth0(2,TcpCmdList,'port'),nth0(3,TcpCmdList,Port1), udp_dst_port(Port1,Answer1),nth0(4,TcpCmdList,'src'),nth0(6,TcpCmdList,Port2), udp_src_port(Port2,Answer2),udp_compare(Answer1,Answer2,Answer).

udp(UdpCmdList,Answer):- length(UdpCmdList,7), nth0(0,UdpCmdList,'udp'), nth0(1,UdpCmdList,'dst'), nth0(2,UdpCmdList,'port'),nth0(3,UdpCmdList,Port1), udp_dst_port(Port1,Answer1),\+(Answer1='Reject'), nth0(4,UdpCmdList,'src'),nth0(6,UdpCmdList,Port2), udp_src_port(Port2,Answer).

udp(UdpCmdList,'Accept').




member([A|_],A,_).
member([H|T],A,Z):- \+(H=A),member(T,A,Z).

member1(Orig,[],_,_).
member1(Orig,[],[R|S],Z):-member1(Orig,Orig,S,Z).
member1(Orig,[P|Q],[R|S],Z):- \+(P=R),member1(Orig,Q,[R|S],Z).

proto_eth3(A,B,'Reject'):-proto_eth(VLAN_ID,Proto_ID,'Reject'),is_list(VLAN_ID),is_list(Proto_ID),member(VLAN_ID,A,Z),member(Proto_ID,B,Y).
proto_eth3(A,B,'Accept'):-proto_eth(VLAN_ID,Proto_ID,'Accept'),is_list(VLAN_ID),is_list(Proto_ID),member(VLAN_ID,A,Z),member(Proto_ID,B,Y).

proto_eth2(VLAN,Proto_ID,'Reject'):-proto_eth(A,B,Proto_ID,'Reject'),(A<VLAN;A=VLAN),(B>VLAN;B=VLAN).
proto_eth2(VLAN,Proto_ID,'Accept'):-proto_eth(A,B,Proto_ID,'Accept'),(A<VLAN;A=VLAN),(B>VLAN;B=VLAN).
proto_eth2(VLAN,Proto_ID,'Drop'):-proto_eth(A,B,Proto_ID,'Drop'),(A<VLAN;A=VLAN),(B>VLAN;B=VLAN).

proto_eth2(VLAN,Proto_ID,'Reject'):-vid(VLAN,'Reject');proto_eth(Proto_ID,'Reject').
proto_eth2(VLAN,Proto_ID,'Drop'):-vid(VLAN,'Drop');proto_eth(Proto_ID,'Drop').
proto_eth2(VLAN,Proto_ID,'Accept'):-vid(VLAN,'Accept');proto_eth(Proto_ID,'Accept').





proto_eth(A,A,Proto_ID,Z):-proto_eth(A,Proto_ID,'Reject');proto_eth(A,Proto_ID,'Accept');proto_eth(A,Proto_ID,'Drop').

proto_eth(Start,End,Proto_ID,Z):-proto_eth(Start,Proto_ID,Z),Z='Reject',A is Start+1,proto_eth(A,End,Proto_ID,Z).

proto_eth(Start,End,Proto_ID,Z):-proto_eth(Start,Proto_ID,Z),Z='Accept',A is Start+1,proto_eth(A,End,Proto_ID,Z).

proto_eth(Start,End,Proto_ID,Z):-proto_eth(Start,Proto_ID,Z),A is Start+1,proto_eth(A,End,Proto_ID,Z).

list_check(Start,End,[],Z).
list_check(Start,End,[A|B],Z):-proto_eth(Start,End,A,Z),list_check(Start,End,B,Z).

ether_check(EthList,Z):-is_list(EthList),length(EthList,3),nth0(1,EthList,'proto'),nth0(2,EthList,M),proto_eth(M,Z),Z='Reject'.

ether_check(EthList,Z):-is_list(EthList),length(EthList,3),nth0(1,EthList,'proto'),nth0(2,EthList,M),proto_eth(M,Z).

ether_check(EthList,Z):-is_list(EthList),length(EthList,3),nth0(1,EthList,'vid'),nth0(2,EthList,M),vid(M,Z),Z='Reject'.
ether_check(EthList,Z):-is_list(EthList),length(EthList,3),nth0(1,EthList,'vid'),nth0(2,EthList,M),vid(M,Z).

ether_check(EthList,Z):-is_list(EthList),length(EthList,5),nth0(1,EthList,'vid'),nth0(3,EthList,'proto'),nth0(2,EthList,A),nth0(4,EthList,Proto_ID),(proto_eth2(A,Proto_ID,Z)).

ether_check(EthList,Z):-is_list(EthList),length(EthList,5),nth0(1,EthList,'vid'),nth0(3,EthList,'proto'),nth0(2,EthList,A),nth0(4,EthList,Proto_ID),(proto_eth3(A,Proto_ID,Z)).

ether_check(EthList,Z):-is_list(EthList),length(EthList,5),nth0(1,EthList,'vid'),nth0(3,EthList,'proto'),nth0(2,EthList,VLAN),nth0(4,EthList,Proto_ID),(proto_eth(VLAN,Proto_ID,'Reject'));(vid(VLAN,'Reject'));proto_eth(Proto_ID,'Reject'),Z='Reject'.

ether_check(EthList,Z):-is_list(EthList),length(EthList,5),nth0(1,EthList,'vid'),nth0(3,EthList,'proto'),nth0(2,EthList,VLAN),nth0(4,EthList,Proto_ID),(proto_eth(Proto_ID,'Accept')),Z='Accept'.

ether_check(EthList,Z):-is_list(EthList),length(EthList,5),nth0(1,EthList,'vid'),nth0(3,EthList,'proto'),nth0(2,EthList,VLAN),nth0(4,EthList,Proto_ID),(proto_eth(VLAN,Proto_ID,'Drop')),Z='Drop'.

ether_check(EthList,'Accept').


