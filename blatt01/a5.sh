#!/bin/bash

VAR1=0
VAR2=0
for i in {1..100}
do
    echo "Execution number: $i"
    ./b1
    if [ $? = 0 ]
    then VAR1=$((VAR1+1)) 
    else VAR2=$((VAR2+1)) 
    fi
done

echo "successfull runs: " $VAR1
echo "failed runs: " $VAR2

