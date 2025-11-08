atget id myid
set x 0
set y 0
set last 0
set dif 0
loop
areadsensor aqi_reading
rdata aqi_reading x y aqi_value
   // Display current reading with color code
   if(aqi_value < 50)
      print "[GREEN] Node " myid " AQI: " aqi_value " - Good"
   else if(aqi_value >= 50 && aqi_value < 100)
      print "[YELLOW] Node " myid " AQI: " aqi_value " - Moderate"
   else if(aqi_value >= 100 && aqi_value < 150)
      print "[ORANGE] Node " myid " AQI: " aqi_value " - Unhealthy for Sensitive"
   else if(aqi_value >= 150)
      print "[RED] Node " myid " AQI: " aqi_value " - Unhealthy"
   end

data aqi_packet myid aqi_value 
max y aqi_value last
min x aqi_value last
print "max value is: " x
print "min value is: " y
set dif (y-x)
 if (dif > 10)
  print "Now send the packet with air: " aqi_value 
  send aqi_packet
 else
  print "no need to send Now the diff is: " dif
 end
set last aqi_value
delay 300000
