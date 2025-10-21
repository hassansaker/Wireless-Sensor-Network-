atget id id
loop
areadsensor v
rdata v a b c
print "humidity value: " c
data message id c
send message 
delay 900000
