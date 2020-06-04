#!/bin/bash

printf "\033c"
echo -e "***********************************************************************\n"
echo -e "                      Welcome to database drop wizard                    "
echo -e "\n"
echo -e "***********************************************************************\n"

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

while [ true  ]
   do
     read -p "   Please enter name of target database :  " dbname
     echo -e "*************************************************************************"
      if [ -d "$DIR/database/$dbname" ] && [ "$dbname" ]; then
         rm -r $DIR/database/$dbname
         echo "               Database $dbname has been deleted successfully."
         echo -e "************************************************************************"
         echo " Press any key to continue ..... "
         read -n 1
         if [ $? = 0 ]; then
            . $DIR/home.sh
         fi
         . $DIR/home.sh
      else
         read -p "There is no database named $dbname ,1 : try again , any key: Menu : " inp
         echo -e "************************************************************************\n"
         if [[ $inp = "1" ]]; then
            continue
         else
            . $DIR/home.sh
         fi
      fi
done
