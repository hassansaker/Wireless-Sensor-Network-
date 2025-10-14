atget id id
loop
areadsensor v
rdata v a b c
print c 1
data message id c 
send message 
delay 300000
