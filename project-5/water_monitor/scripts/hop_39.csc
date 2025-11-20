atget id myid
loop
receive packet
rdata packet source level status
data forward myid level status
send forward 13
delay 10
