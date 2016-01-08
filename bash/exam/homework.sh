#!/bin/bash

quit(){
 while [ true ]; do
  echo "Do you want to start again? (y/n)"
  read UserAnsw
  if [ $UserAnsw = 'y' ]; then
    break
  elif [ $UserAnsw = 'n' ]; then
    exit $1
  else
    continue
  fi
 done

 continue 
}

#echo "Watch processes list"
#ps ux

while [ true ];
do 
 
 echo
 echo "Please, choose option:"
 echo "(1) Display all processes"
 echo "(2) Display processes by name"
 echo "(3) Input PID(s) for sending signals"
 echo "(4) Quit "

 #echo "Input PIDs of processes"
 read UserAnsw
 
 case "$UserAnsw" in
  1) ps -xco pid,uid,tty,stat,cmd
	 GROUP=-1
	 continue  
     ;;
  2) echo "Input name of process"
 	 read PNAME
	 GROUP=$(pidof -x $PNAME)

	 if [ $? != 0 ]; then
	  echo
	  echo "Process with name $PNAME not found" >&2
	  continue	  
	 fi 

	 ps -co pid,uid,tty,stat,cmd -p $GROUP
	 continue
     ;;
  3) if [ "$GROUP" == "-1" ]; then
	   echo "Please, input PID(s):"
	 else
	   echo "Please, input PID(s) (press 0 to select all):"
	 fi
	  
	 read PID

	 # group of PIDs with same name
	 if [ "$GROUP" != "-1" ] && [ "$PID" == "0" ]; then
	   PID=$(echo $GROUP) 
	   echo "All"
	   echo "$PID"      
	 else
       re='^[1-9][0-9]*(\s[1-9][0-9]*)*$'
 
       if ! [[ $PID =~ $re ]] ; then
		echo "Wrong PID(s)" >&2
		quit 250
	   fi 

	   # verify PIDs are exsist
	   PIDS=$(echo $PID)
	   stop=0
	   for p in $PIDS; do
         ps -p $p > /dev/null
         
	     if [ $? != 0 ]; then
	      echo "PID $p not found" >&2
	      stop=1
	      break 
	     fi
	   done
	   
	   if [ $stop == 1 ]; then 
	    quit 250
	   fi	   
	 fi
   while [ true];
   do
    echo ""
    echo "Input number of signal:"
    echo ""
    echo "1 for SIGHUB" # lost connection with terminal
    echo "2 for SIGINT" # program interrupt
    echo "9 for SIGKILL" 
    echo "15 for SIGTERM" # program termination
    echo "20 for SIGTSTP" # stop like Ctrl-Z
    echo "18 for SIGCONT" # continue
    echo "Another number of signal that you want"

    read SIG
    case $SIG in
     1) echo "Sending signal 1"
       kill -1 $UserAnsw
       ;; 
     2) echo "Sending signal 2"
       kill -2 $UserAnsw
       ;;
     9) echo "Sending signal 9"
       kill -9 $UserAnsw
       ;; 
     15) echo "Sending signal 15"
       kill -15 $UserAnsw  
       ;;
     18) echo "Sending signal 18"
       kill -18 $UserAnsw
       ;; 
     20) echo "Sending signal 20"
       kill -20 $UserAnsw 
       ;;
     $SIG)  
	   if (($SIG>0 && $SIG<65)); then
        echo "Sending signal $SIG" 	
        kill -$SIG $UserAnsw
       else
        echo "Wrong number of signal! Input number from 1 to 64." >&2
        quit 250
       fi
       ;;
    esac
   done
  4) exit 0   
     ;;
  *) echo "Wrong option!" >&2
     quit 250
     ;;
 esac

 quit 0

done


