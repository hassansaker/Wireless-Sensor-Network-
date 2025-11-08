atget id myid 
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
send aqi_packet
delay 300000
