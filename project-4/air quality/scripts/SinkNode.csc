atget id myid
int report_counter 0
int high_count 0
int moderate_count 0
int low_count 0
loop
 inc report_counter
 receive packet
 rdata packet node_id aqi_value extra_data

 if (aqi_value < 50)
   print "Good Air Quality from node" node_id ": " aqi_value
   inc low_count
 else if(aqi_value >= 50 && aqi_value < 100)
   print "Moderate Air Quality from Node " node_id ": " aqi_value
   inc moderate_count
 else if(aqi_value >= 100)
   print "POOR Air Quality from Node " node_id ": " aqi_value
   inc high_count
 end

 // Generate report every 500 readings
 if(report_counter >= 500)
   // Calculate city-wide status
   if(high_count > 100)
     printfile "CITY STATUS: UNHEALTHY - Stay Indoors"
   else if(high_count <= 100 && moderate_count > 50)
     printfile  "CITY STATUS: MODERATE - Sensitive groups take care"
   else if(high_count == 0 && moderate_count <= 50)
     printfile  "CITY STATUS: GOOD - Safe for outdoor activities"
   end
   // reset counters
   set report_counter 0
   set high_count 0
   set moderate_count 0
   set low_count 0
 end






