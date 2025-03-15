atget id id
set x 0
loop
print "hello World" x
data message id x
send message
set x x+1
time t
printfile Time =$t
delay 1000