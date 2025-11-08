atget id myid
loop
receive message
rdata message rid x
data message2 myid x
send message2 17 rid
delay 100
