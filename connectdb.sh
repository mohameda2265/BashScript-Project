#!/bin/bash

printf "\033c"
echo -e "*******************************************************************\n"
echo -e "           Welecome to database connection wizard                 \n "
echo -e  "*********************************************************************"
echo "                     Available Databases are :                          "
echo -e "**********************************************************************"

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
mkdir -p $DIR/database/
ls  $DIR/database/ | awk '{print "              " NR" - " , $0}'

echo -e "\n"
echo -e "*******************************************************************\n"
while [ true ]
  do
    while [ true ]
    do
    read -p "     Enter target database name : " name
    if [[ "$name" ]]; then
       break
    else
       read -p "   Database name is not valid. 1 - try again , any - Main : " db
           if [[ $db = 1 ]]; then
              continue
           else
              . $DIR/home.sh $DBDIR
              return
           fi
    fi
    done
    echo -e "\n"
    echo "****************************************************************"
    if [ -d "$DIR/database/$name/" ]; then
      cd $DIR/database/$name/
      echo -e "You are connected successfully to database "$name""
      SDIR=$DIR/database/$name/
      echo "****************************************************************"
      . $DIR/dbhome.sh $SDIR
       break
    else
      echo -e "Database "$name" doesn't exist , please check your input \n"
      echo -e "*******************************************************************\n"

      read -p "Press 1 to try again or any other key to go main menu : " inpkey

      echo -e "\n"
      echo -e "*******************************************************************\n"

      if [[ $inpkey = 1 ]]; then
           continue
      else
           . $DIR/home.sh
      fi
    fi
  done
