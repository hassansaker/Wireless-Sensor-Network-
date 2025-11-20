atget id myid
set normal_level 3.5
set warning_level 4.0
set critical_level 5.5
set emergency_level 7.0
set trend "UNKNOWN"
set water_level 0
set interval 0
set last 0
loop
   areadsensor reading
   rdata reading x y water_level
   if (water_level <= normal_level)
   set trend "NORMAL"
   else if (water_level <= warning_level && water_level > normal_level )
   set trend "WARNING"
   else if (water_level <= critical_level && water_level > warning_level )
   set trend "CRITICAL"
   else if (water_level > critical_level )
   set trend "EMERGENCY"
   end
   // Adaptive sensing based on water level
   if (trend == "NORMAL")
   set interval 900000
   else (trend == "WARNING")
   set interval 600000
   else if (trend == "CRITICAL")
   set interval 300000
   else if (trend == "EMERGENCY")
   set interval 60000
   end
   // Threshold Transmission
   data level_packet myid water_level trend 
   max y water_level last
   min x water_level last
   set dif (y-x)
   if (dif > 0.2)
   print "send the packet"
   send level_packet
   else
   print "The water level stable"
   end
   set last water_level 
   delay interval 