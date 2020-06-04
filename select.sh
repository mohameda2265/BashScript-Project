#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
DBDIR=$1
counter=1
index=0
selexist=0

printf "\033c"


echo -e "*****************************************************************************\n"
echo "                       Welcome to Data Selection Wizard"
echo -e "\n"
echo -e "*****************************************************************************\n"


while [ true ]
      do
        read -p "   please enter the table name to select from : " tablename
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

       echo "****************************************************************************"

while [ true ]
do
       read -p "   Please Choose , 1 - Select All  Or  2 - Select by PK   :  " selector
       if [[ "$selector" -eq 1 ]]; then
          break
       elif [[ "$selector" -eq 2 ]]; then
            read -p "   please enter the PK to select corresponding data : " pkey
            if [ "$pkey" ]; then
               index=1
               break
            else
               read -p "   The pk value is not valid. 1 : try again , any : Database : " inp2
               if [[ $inp2 = 1 ]]; then
                  continue
               else
                  . $DIR/dbhome.sh $DBDIR
               fi
            fi
       else*
          echo "**************************************************************************"
          read -p "   your input is not valid. 1 : try again , any : Database : " inp3
          if [[ $inp3 = 1 ]]; then
             continue
          else
             . $DIR/dbhome.sh $DBDIR
          fi
       fi
done

        echo -e "****************************************************************************\n"

linesnum=$(wc -l $tablename.csv | cut -d " " -f 1)
metalinenum=$(wc -l $tablename-meta.csv | cut -d " " -f 1)
metacounter=2
metastring=""
while [ true ]
do
  if [[ $metacounter -gt $((metalinenum+1)) ]]; then
     break;
  fi
  metastring+=$(sed "${metacounter}q;d" $tablename-meta.csv | cut -d "," -f 1)
  metastring+=" "
  metacounter=$((metacounter+1))
done

echo "-------------------------------------------------------------------------------"
echo "               User table headers order is applied to data                     "
echo "-------------------------------------------------------------------------------"
echo "$metastring" | column -t -s " " -c100
echo "-------------------------------------------------------------------------------"

if [[ $index -eq 0 ]]; then
   cat $tablename.csv | column -t -s "," -c100
   selexist=1
elif [[ $index -eq 1 ]]; then
     while [ true ] 
     do
       if [[ $counter -gt $linesnum ]]; then
          break
       fi
       pk=$(cat $tablename.csv | head -n $counter | tail -n 1 | cut -d "," -f 1)
       if [[ "$pk" -eq "$pkey" ]]; then
          oplnum=$(sed "${counter}q;d" $tablename.csv | wc -l | cut -d " " -f 1)
          if [[ $oplnum -eq 1 ]]; then 
             sed "${counter}q;d" $tablename.csv | column -t -s "," -c100
             selexist=1
          fi
          break
       fi
       counter=$((counter+1))
       done
fi 
echo "-------------------------------------------------------------------------------"

if [[ $selexist -eq 0 ]]; then
   echo "   No record in $tablename table match your input."
fi

echo -e "\n"

echo "****************************************************************************"
echo "   Command applied to $tablename table successfully."
echo -e "****************************************************************************\n"

echo "   Press any key to continue ..."
read -n 1
if [ $? = 0 ]; then
   . $DIR/dbhome.sh $DBDIR
fi
