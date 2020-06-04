#!/bin/bash

printf "\033c"
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
echo -e  "************************************************************************"
echo "                            Available Database are :                    "
echo -e "************************************************************************\n"

mkdir -p $DIR/database
ls  $DIR/database/ | awk '{print "              " NR" - " , $0}'

echo -e "\n"
echo -e "************************************************************************\n"

echo "Press any key to continue ..."
read -n 1
if [ $? = 0 ]; then
   . $DIR/home.sh
fi
