#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
DBDIR=$1
counter=1
index=0
selexist=0

printf "\033c"


echo -e "*****************************************************************************\n"
echo "                         Welcome to Data Update Wizard"
echo -e "\n"
echo -e "*****************************************************************************\n"


while [ true ]
      do
        read -p "   please enter the table name to update it : " tablename
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

while [ true ]
      do
        read -p "   please enter the table pk value to update by : " pkey
        if [ "$pkey" ]; then
           break
        else
           read -p "   Pk input is not valid. 1 : try again , any : Database : " inp
           if [[ $inp = 1 ]]; then
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


fieldcounter=1
fieldsnum=$(echo "$metastring" | wc -w | cut -d " " -f 1)
targetnum=0


echo "Available fields that can be updated are : $metastring ."
echo "***********************************************************************************"

while [ true ]
do
read -p "Enter  the  field  name  you  want to update : " fname
read -p "Enter the value of field  you want to update : " fvalue
if [[ "$fnmae" = " " ]] || [[ "$fvalue" = " " ]]; then
      read -p "   field name or value is not valid. 1 : try again , any : Database : " inp
           if [[ $inp = 1 ]]; then
              continue
           else
              . $DIR/dbhome.sh $DBDIR
              return
           fi
else
    break
fi
done

while [ true ]
do
   if [[ $fieldcounter -gt $fieldsnum ]]; then
      echo "Field $fname not fount. exitting........"
      break
   fi
   currentname=$(echo "$metastring" | cut -d " " -f $fieldcounter)
   if [ "$fname" = "$currentname" ]; then
      targetnum=$fieldcounter
      if [[ "$targetnum" -eq "1" ]]; then
         echo " Fatal invalid operation , A primary key can not be updated. "
         echo "exitting........."
         sleep 4
         . $DIR/dbhome.sh $DBDIR
      else
         break
      fi
   fi
   fieldcounter=$((fieldcounter+1)) 
done

ln=1

while read p; do
       pk=$(echo "$p" | cut -d "," -f 1)
       if [[ "$pk" -eq "$pkey" ]]; then
          p=$(echo "$p" | awk -v fc="$fieldcounter" -v val="$fvalue" -F, ' $fc=val ')
          sed -i "${ln}d" $tablename.csv
          echo ${p// /,} >> $tablename.csv
          break
       fi
       ln=$((ln+1))
done < $tablename.csv     


echo "************************************************************************************"
echo "   Command applied to $tablename table successfully (Rows are affected when exist)."
echo -e "*******************************************************************************\n"

echo "   Press any key to continue ..."
read -n 1
if [ $? = 0 ]; then
   . $DIR/dbhome.sh $DBDIR
fi
