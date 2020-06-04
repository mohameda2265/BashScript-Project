#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
DBDIR=$1
counter=1
colnames=""

printf "\033c"
echo -e "**************************************************************************\n"
while [ true ]
do
while [ true ]
do
read -p "please enter the table name : " tablename
if [[ $tablename ]]; then
   break
else
   continue
fi
done
if [[ -f "$tablename.csv" ]]
then
    read -p "There is a table of the same name. 1 : try again , any : main menu : " inp
    if [[ $inp = 1 ]]; then
       continue
    else
       return
    fi
else
    break
fi
done
touch $tablename.csv
touch $tablename-meta.csv
while [ true ]
do
read -p "please enter the number of columns of table $tablename : " cnum
if [[ $cnum ]] && [ $cnum -eq $cnum 2>/dev/null ]
then
    echo "$cnum" >> $tablename-meta.csv
    break
else
    continue
fi
done
while [ true ]
do
if [[ "$counter" -gt "$cnum" ]]; then
   break
fi
while [ true ]
do
if [[ $counter = 1 ]]; then
read -p "please enter the P.K. name: " cname
else
read -p "please enter the column $counter name: " cname
fi
if [[ $cname ]]; then
   for w in $(echo $colnames | sed "s/,/ /g")   
   do
       if [ "$w" = "$cname" ]; then
          echo "column names can not be duplicated."
          sleep 2
          . $DIR/dbhome.sh $DBDIR
          return
       fi
   done
   colnames+="$cname,"
   break
else
    continue
fi
done

while [[ true ]]
do
read -p "enter $cname data type. 1 : number , 2 : string : " ctype
if [[ $ctype = 1 ]]; then
   echo "$cname,number" >> $tablename-meta.csv
   break
elif [[ $ctype = 2 ]]; then
   echo "$cname,string" >> $tablename-meta.csv
   break
else
   echo "invalid choice , please try again."
   continue
fi
done
counter=$((counter+1))  
done
echo -e "\n"
echo "*********************************************************************"
echo "Table "$tablename" has been created successfully."
echo -e "*********************************************************************\n"
echo "Press any key to continue ..."
read -n 1
if [ $? = 0 ]; then
   . $DIR/dbhome.sh $DBDIR
fi
