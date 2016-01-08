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

SendSignals(){
  while [ true ];
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
    echo "0  for return"

    read SIG
    case $SIG in
	 0) break
		;;
     1) echo "Sending signal 1"
       kill -1 $PIDS
       ;; 
     2) echo "Sending signal 2"
       kill -2 $PIDS
       ;;
     9) echo "Sending signal 9"
       kill -9 $PIDS
       ;; 
     15) echo "Sending signal 15"
       kill -15 $PIDS  
       ;;
     18) echo "Sending signal 18"
       kill -18 $PIDS
       ;; 
     20) echo "Sending signal 20"
       kill -20 $PIDS 
       ;;
     $SIG)  
	   if (($SIG>0 && $SIG<65)); then
        echo "Sending signal $SIG" 	
        kill -$SIG $PIDS
       else
        echo "Wrong number of signal! Input number from 1 to 64." >&2
        quit 250
       fi
       ;;
    esac
   done
}

while [ true ];
do 
 
 echo
 echo "Please, choose option:"
 echo "(1) Display all processes"
 echo "(2) Send signal by name"
 echo "(3) Send signal by PID(s)"
 echo "(4) Quit "

 read OPT
 
 case "$OPT" in
  1) ps -xco pid,uid,tty,stat,cmd

	 continue  
     ;;
  2) echo "Please, input name of process"

 	 read PNAME

	 PIDS=$(pidof -x $PNAME)

	 if [ $? != 0 ]; then
	  echo
	  echo "Process with name $PNAME not found" >&2
	  continue	  
	 fi 

	 ps -co pid,uid,tty,stat,cmd -p $PIDS

     SendSignals

	 continue
     ;;
  3) echo "Please, input PID(s)"
	  
	 read PIDS

     # verify that PIDs are correct
     re='^[1-9][0-9]*(\s[1-9][0-9]*)*$'
 
     if ! [[ $PIDS =~ $re ]] ; then
	   echo "Incorrect PID(s)" >&2
	   quit 250
	 fi 

	 # verify that processes are exsist
	 PIDS=$(echo $PIDS)
	 stop=0
	 for PID in $PIDS; do
       ps -p $PID > /dev/null
       
	   if [ $? != 0 ]; then
	    echo "PID $PID not found" >&2
	    stop=1
	    break 
	   fi
	 done
	   
	 if [ $stop == 1 ]; then 
	  quit 250
	 fi
     
     ps -co pid,uid,tty,stat,cmd -p $PIDS

     SendSignals

	 continue
     ;;
  4) exit 0   
     ;;
  *) echo "Wrong option!" >&2
     quit 250
     ;;
 esac

 quit 0

done


