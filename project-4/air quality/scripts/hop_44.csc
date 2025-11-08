atget id myid
loop
receive message
rdata message rid x
data message2 myid x
send message2 43 rid
delay 100
