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

echo "Watch processes list"
ps ux

while [ true ];
do 
 
 echo "Input PIDs of processes"
 read UserAnsw

 re='^[1-9][0-9]*(\s[1-9][0-9]*)*$'

 if ! [[ $UserAnsw =~ $re ]] ; then
  echo "Wrong PID(s)" >&2
  quit 250
 fi 
 
 PID=0
 i=1
 stop=0
 while [ true ]
 do 
  PID=$(echo $UserAnsw | cut -d' ' -f$i)

  if ! [ "$PID" ]; then
   break
  fi

  ps -p $PID > /dev/null
  if [ $? != 0 ]; then
   echo "PID $PID not found" >&2
   stop=1
   break 
  fi 
  i="$(($i+1))"
 done 

 if [ $stop == 1 ]; then 
  quit 250
 fi
 ps -o pid,uid,tty,stat,cmd -p $UserAnsw

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

 quit 0

done


