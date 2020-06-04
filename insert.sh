#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
DBDIR=$1
counter=1
inputstring=""

printf "\033c"


echo -e "*****************************************************************************\n"
echo "                       Welcome to Data insertion Wizard"
echo -e "\n"
echo -e "*****************************************************************************\n"


while [ true ]
      do
        read -p "   please enter the table name to insert in : " tablename
        if [ "$tablename" ] && [ -f "$tablename.csv" ] && [ -f "$tablename-meta.csv" ]; then
           break
        else
           read -p "   The data table or meta data is missing. 1 : try again , any : Database : " inp
           if [[ $inp = 1 ]]; then
              continue
           else
              . $DIR/dbhome.sh $DBDIR
           fi
        fi
done


cnum=$(cat $tablename-meta.csv | head -n 1)
cntr=2


while [ true ]
      do
        if [[ $cntr -gt $((cnum+1)) ]]; then
           break
        fi
        cname=$(cat $tablename-meta.csv | head -n $cntr | tail -n 1 | cut -d "," -f 1) 
        ctype=$(cat $tablename-meta.csv | head -n $cntr | tail -n 1 | cut -d "," -f 2)
        while [ true ]
              do
                read -p "   Please enter the $cname of type $ctype : " field
                if [ "$ctype" = "number" ]; then
                   if [ "$field" ] && [ "$field" -eq "$field" 2>/dev/null ]; then
                      if [[ $cntr -eq $((cnum+1)) ]]; then
                         inputstring+="$field"
                         break 1
                      else
                         inputstring+="$field,"
                         break 1
                      fi
                   else
                      echo "   $field is not an integer or not defined , pleease try again ."
                      continue
                   fi
                else
                     if [ "$field" ]; then
                        if [[ $cntr -eq $((cnum+1)) ]]; then
                           inputstring+="$field"
                           break 1
                        else
                           inputstring+="$field,"
                           break 1
                        fi
                     else
                        echo "   Input is not defined , pleease try again ."
                        continue
                     fi
                fi
        done
        if [[ $cntr -eq 2 ]]; then
           linesnum=$(wc -l $tablename.csv | cut -d " " -f 1)
           current=1
           while [ true ]
           do
             if [[ $current -gt $linesnum ]]; then
                break 1;
             fi
             pk=$(cat $tablename.csv | head -n $current | tail -n 1 | cut -d "," -f 1)
             if [[ "$field" -eq $pk ]]; then
                echo "**************************************************************************"
                echo "   Primary key can not be duplicated . exitting process ......"
                echo -e "*********************************************************************\n"
                echo "   Press any key to continue ..."
                read -n 1
                if [ $? = 0 ]; then
                   . $DIR/dbhome.sh $DBDIR
                   return
                fi
             fi
             current=$((current+1))
           done
        fi
        cntr=$((cntr+1))
done 

echo "$inputstring" >> $tablename.csv

echo -e "\n"

echo "*********************************************************************"
echo "   Data inserted in "$tablename" table successfully."
echo -e "*********************************************************************\n"

echo "   Press any key to continue ..."
read -n 1
if [ $? = 0 ]; then
   . $DIR/dbhome.sh $DBDIR
fi
