#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
DBDIR=$1
counter=1

printf "\033c"


echo -e "*****************************************************************************\n"
echo "                       Welcome to Data Deletion Wizard"
echo -e "\n"
echo -e "*****************************************************************************\n"


while [ true ]
      do
        read -p "   please enter the table name to delete from : " tablename
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

       echo "*************************************************************************"

while [ true ]
do
       read -p "   please enter the PK to delete corresponding data : " pkey
        if [ "$pkey" ]; then
           break
        else
           read -p "   The pk value is not valid. 1 : try again , any : Database : " inp2
           if [[ $inp2 = 1 ]]; then
              continue
           else
              . $DIR/dbhome.sh $DBDIR
           fi
        fi
done

        echo "*************************************************************************"

linesnum=$(wc -l $tablename.csv | cut -d " " -f 1)

while [ true ]
do
    if [[ $counter -gt $linesnum ]]; then
       break
    fi
    pk=$(cat $tablename.csv | head -n $counter | tail -n 1 | cut -d "," -f 1)
    if [[ "$pk" -eq "$pkey" ]]; then
       sed -i "${counter}d" $tablename.csv
       break
    fi
    counter=$((counter+1))
done 


echo -e "\n"

echo "*********************************************************************"
echo "   Command applied to $tablename table successfully."
echo -e "*********************************************************************\n"

echo "   Press any key to continue ..."
read -n 1
if [ $? = 0 ]; then
   . $DIR/dbhome.sh $DBDIR
fi
