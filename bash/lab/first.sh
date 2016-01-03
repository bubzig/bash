#!/bin/bash
X=0
filename=0

printhelp() {
  echo "Input "create" for create file"
  echo "Input "remove" for remove file"
  echo "Input "quit" for quit"
}

inputfilename(){
 echo "Input name of file"
 read filename
}

# if argument #1 not exists
if [ -z $1 ]; then
  # interactive input
  while [ $X != "quit" ]; do
   printhelp
   read X
   if [ $X = "create" ]; then
    inputfilename
    touch $filename
    echo "File $filename was create"
    echo ""
   elif [ $X = "remove" ]; then
    inputfilename
    if [ $filename ]; then
      rm $filename
      echo "File $filename was removed"
      echo ""
    else   
      echo "File $filename not found"
      echo ""
    fi
   elif [ $X = "quit" ]; then
    break
   else
    echo "Incorrect input. Plese, try again."
    echo ""
   fi 
  done
else
  # non interacvive input
  if [ $1 = "create" ]; then
    # if argument #2 not exists
    if [ -z $2 ]; then
      echo "Input create <filename>"
    else
      touch $2
      echo "File $2 was created/updated"
    fi  
  elif [ $1 = "remove" ]; then
    # if argument #2 not exists
    if [ -z $2 ]; then
      echo "Input remove <filename>"
    elif [ -f $2 ]; then
      # if file $2 exists 
      rm $2
      echo "File $2 was removed"
    else   
      echo "File $2 not found"
    fi
  elif [ $1 = "-h" ]; then
    printhelp    
  fi
fi

