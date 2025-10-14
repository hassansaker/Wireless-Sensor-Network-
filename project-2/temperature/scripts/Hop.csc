atget id id
loop
print id
receive message
rdata message rid x
data message2 id x
send message2 * rid
