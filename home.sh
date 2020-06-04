#!/bin/bash

printf "\033c"
echo -e "*******************************************************************\n"
echo "                              DBMS Main Menu                            "
echo -e "\n"
echo -e "*******************************************************************\n"
echo "                              License : Free                            "
echo "                            Organization : ITI                          "
echo "                                Year : 2020                             "
echo "             By : Ahmed Aly , Mohamed Ashraf , Ahmed Hendi              "
echo "       Special Thanks to our great instructor, Eng : Romany Nageh       "
echo -e "\n"
echo -e "*******************************************************************\n"
echo "                            1 - Create Database                         "
echo "                            2 - List  Databases                         "
echo "                            3 - Connect Database                        "
echo "                            4 - Drop a Database                         "
echo "                            5 - Exit the Program                        "
echo -e "\n"
echo "************************************************************************"
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
while [ true ] 
do
    read -p "              Select an operation from above options : " inp
    echo "************************************************************************"
    if [[ $inp = 1 ]]; then
       echo "Create database ."
       . $DIR/createdb.sh
    elif [[ $inp = 2 ]]; then
       echo "List database ."
       . $DIR/listdb.sh
    elif [[ $inp = 3 ]]; then
       . $DIR/connectdb.sh
    elif [[ $inp = 4 ]]; then
       echo "Drop a  database ."
       . $DIR/dropdb.sh
    elif [[ $inp = 5 ]]; then
       exit
    else
       continue
    fi
done
