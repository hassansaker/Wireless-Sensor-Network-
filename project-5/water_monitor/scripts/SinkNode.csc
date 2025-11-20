atget id myid
set report_cnt 0
set emerg_cnt 0
set critic_cnt 0
set warn_cnt 0
set normal_cnt 0
loop
   inc report_cnt 
   receive packet
   rdata packet source level status
   if(status == "EMERGENCY")
      cprint "========================================"
      cprint "!!EMERGENCY ALERT!!"
      cprint "Source: Node " source
      cprint "Water Level: " level " meters"
      cprint "Status: " status
      cprint "========================================"
      inc emerg_cnt
   else if(status == "CRITICAL")
      cprint "========================================"
      cprint "!!CRITICAL WARNING!!"
      cprint "Source: " source " | Level: " level "m"
      cprint "Action: " status
      cprint "========================================"
      inc critic_cnt 
    else if(status == "WARNING")
      cprint "========================================"
      cprint "WARNING"
      cprint "Source: " source " | Level: " level "m"
      cprint "Action: " status
      cprint "========================================"
      inc warn_cnt
    else if(status == "NORMAL")
      cprint "========================================"
      cprint "NORMAL"
      cprint "Source: " source " | Level: " level "m"
      cprint "Action: " status
      cprint "========================================"
      inc normal_cnt 
    end

    if (report_cnt == 100)
    printfile "===================================================="
    printfile "--------REPORT AFTER 100 Reading--------"
    printfile "The total number of normal reading is: " normal_cnt 
    printfile "The total number of warning reading is: " warn_cnt 
    printfile "The total number of critical reading is: " critic_cnt 
    printfile "The total number of emergency reading is: " emerg_cnt 
    printfile "====================================================="
    set normal_cnt 0
    set warn_cnt 0
    set critic_cnt 0
    set emerg_cnt 0
    set report_cnt 0
    end
   



