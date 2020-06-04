#!/bin/bash

printf "\033c"
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
echo -e "*********************************************************************\n"

while [[ true ]]
do
   read -p "please enter the database name : " dbname
   if [ ! -d "$DIR/database/$dbname" ] && [ "$dbname" ]; then
      mkdir -p $DIR/database/$dbname
      break
   else
      echo "******************************************************************"
      read -p "Database already exists or input invalid. 1- try again  any- Home : " inp
      if [[ "$inp" -eq "1" ]]; then
         continue
      else
         . $DIR/home.sh
          return
      fi
   fi
done

echo -e "\n"
echo "*********************************************************************"
echo "Database "$dbname" has been created successfully."
echo -e "*********************************************************************\n"
echo "Press any key to continue ..."
read -n 1
if [ $? = 0 ]; then
   . $DIR/home.sh
fi
