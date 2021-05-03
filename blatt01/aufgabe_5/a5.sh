#!/bin/bash


if [ -f ./a5 ]
then 
   continue
else 
    echo "please first compile the file: \"a5.cc\"!"
    exit 1 
fi


VAR1=0
VAR2=0
for i in {1..100}
do
    echo "Execution number: $i"
    ./a5
    if [ $? = 0 ]
    then VAR1=$((VAR1+1)) 
    else VAR2=$((VAR2+1)) 
    fi
done

echo "successfull runs: " $VAR1
echo "failed runs: " $VAR2

