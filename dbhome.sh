#!/bin/bash

printf "\033c"
echo -e "*******************************************************************\n"
echo "                            Database Main Menu                          "
echo -e "\n"
echo -e "*******************************************************************\n"
echo "                 1 - Create Table                                       "
echo "                 2 - List  Tables                                       "
echo "                 3 - Drop  Tables                                       "
echo "                 4 - Insert Data                                        "
echo "                 5 - Select Data                                        "
echo "                 6 - Update Data                                        "
echo "                 7 - Delete Data                                        "
echo "                 8 - Disconnect and go Home Page                        "
echo "                 9 - Exit Program                                       "
echo -e "\n"
echo "************************************************************************"
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
DBDIR=$1
while [ true ] 
do
    read -p "              Select an operation from above options : " inp
    echo "************************************************************************"
    if [[ $inp = 1 ]]; then
       . $DIR/createtable.sh $DBDIR
       break
    elif [[ $inp = 2 ]]; then
       ls | grep -x -l -v *".csv" | sed -e 's/\..*$//' | cut -d "-" -f 1 |awk '{print "              " NR" - " , $0}'
       echo "************************************************************************"		
       echo "Press any key to continue....."
       read -n 1
       if [ $? = 0 ]; then
          . $DIR/dbhome.sh $DBDIR
       fi
    elif [[ $inp = 3 ]]; then
       read -p "Enter the name of table to drop : " tblname
       if [ -f "$tblname.csv" ] && [ -f "$tblname-meta.csv" ]; then
           rm -r $DBDIR/$tblname.csv
           rm -r $DBDIR/$tblname-meta.csv
           echo "**********************************************************************"
           echo "Table deleted successfully."
       else
           echo "The tables doesn't exist or missing files "
       fi
       echo "**************************************************************************"
       echo "Press any key to continue .........................."
       read -n 1
       if [ $? = 0 ]; then
          . $DIR/dbhome.sh $DBDIR
       fi
    elif [[ $inp = 4 ]]; then
       . $DIR/insert.sh $DBDIR
       return	
    elif [[ $inp = 5 ]]; then
       . $DIR/select.sh $DBDIR
       return	
    elif [[ $inp = 6 ]]; then
       . $DIR/update.sh $DBDIR
       return
    elif [[ $inp = 7 ]]; then
       . $DIR/delete.sh $DBDIR
       return
    elif [[ $inp = 8 ]]; then
       . $DIR/home.sh
       return
    elif [[ $inp = 9 ]]; then
       exit 0
    else
       continue
    fi
done
