#!/bin/bash

quit(){
 while [ true ]; do
  echo "Do you want to continue? (y/n)"
  read ANS
  if [ $ANS = 'y' ]; then
    break
  elif [ $ANS = 'n' ]; then
    exit $1
  else
	echo "Incorrect answer $ANS"
    continue
  fi
 done

 continue 
}

# main loop
while [ true ];
do
 echo
 echo "Please, choose option:"
 echo "(1) Display all processes"
 echo "(2) Display processes by name"
 echo "(3) Input PID(s)"
 echo "(4) Quit "

 read OPT

 case "$OPT" in
  1) ps -xco pid,uid,tty,stat,cmd
	 GROUP=-1
	 continue  
     ;;
  2) echo "Input name of process"
 	 read PNAME
	 GROUP=$(pidof -x $PNAME)
	 ps -co pid,uid,tty,stat,cmd -p $GROUP
	 continue
     ;;
  3) if [ "$GROUP" == "-1" ]; then
	   echo "Please, input PID(s):"
	 else
	   echo "Please, input PID(s) (press 0 to select all):"
	 fi
	  
	 read PID

	 if [ "$GROUP" != "-1" ] && [ "$PID" == "0" ]; then
	   PID=$(echo $GROUP) 
	   echo "All"
	   echo "$PID"      
	 else

	   re='[1-9][0-9]*(\s[1-9][0-9]*)*'

	   if ! [[ $PID =~ $re ]] ; then
		echo "Wrong PID(s)" >&2
		quit 250
	   fi 

	   ps -p $PID > /dev/null 

	   if [ $? != 0 ]; then
		echo "PID(s) not found" >&2
		quit 250
	   fi 
	 fi

	 while [ true ];
	  do
	   echo "Please, choose signal:"
	   echo "(1)  for SIGHUB"  
	   echo "(2)  for SIGINT"
	   echo "(9)  for SIGKILL"
	   echo "(15) for SIGTERM"
	   echo "(18) for SIGCONT"
	   echo "(20) for SIGTSTP"
	   echo "(0)  for return"

	   read SIG

	   case "$SIG" in
		0)  break
			;;
	    1)  echo "Sending signal 1 (SIGHUB)"
		    kill -1 $PID
		    ;;
	    2)  echo "Sending signal 2 (SIGINT)"
	   	    kill -2 $PID
		    ;;
	    9)  echo "Sending signal 9 (SIGKILL)"
		    kill -9 $PID 
		    ;;		   
	    15) echo "Sending signal 15 (SIGTERM)"
		    kill -15 $PID 
		    ;;
	    18) echo "Sending signal 18 (SIGCONT)"
		    kill -18 $PID 
		    ;;
	    20) echo "Sending signal 20 (SIGTSTP)"
		    kill -20 $PID 
		    ;;
	    *)  echo "Unknown signal." >&2
		    quit 250 
		    ;;
	   esac
	 done	    
     ;;
  4) exit 0   
     ;;
  *) echo "Wrong option!" >&2
     quit 250
     ;;
 esac

 quit 0

done
