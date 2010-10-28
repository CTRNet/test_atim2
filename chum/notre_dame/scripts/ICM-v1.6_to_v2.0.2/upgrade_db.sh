#!/bin/bash
# author: FM L'Heureux
# desc: Script to migrate ICM ATiM 1.6 to ATiM 2.1.0.

if [ "$1" == "" -o "$2" == "" ]; then
 echo "Missing parameters. You need to specify database schema, username[, password]";
 exit 0
fi
echo "*********************************************************"
echo "****            ICM 1.6 to 2.1 MIGRATION             ****"
echo "*********************************************************"
echo "WARNING: It's assumed you have already run script 0-Check..."

if false; then
	echo Dumping database
	mysqldump -u $2 -p$3 $1 > ATiM_utf8.sql
	echo Fixing iso
	php iso_fix.php
	echo Adding drop, create, use queries
	mv ATiM_iso8859-1.sql ATiM_iso8859-1.sql2
	echo DROP DATABASE $1\; > ATiM_iso8859-1.sql
	echo CREATE DATABASE $1\; >> ATiM_iso8859-1.sql
	echo USE $1\; >> ATiM_iso8859-1.sql
	cat ATiM_iso8859-1.sql2 >> ATiM_iso8859-1.sql
	rm ATiM_iso8859-1.sql2
fi

	echo Importing iso fixed database
	mysql -u $2 -p$3 $1 < ATiM_iso8859-1.sql

files=( 
	1-AddNewTablesToExistingDb_v2.0.1.sql 
	2-AlterTablesOfExistingDb_v2.0.1.sql 
	3-LoadAllTrunkApplicationData_v2.0.1.sql
	4-atim_v2.0.2_upgrade.sql
	5-atim_v2.0.2A_upgrade.sql
	6-LoadCustomApplicationData_v2.0.2A.sql
	7-atim_v2.1.0_upgrade.sql
	8-LoadCustomApplicationData_v2.1.0.sql
	 )
for file in ${files[@]} 
do
	echo Running $file
	mysql -u $2 -p$3 $1 --default-character-set=utf8 < $file
	if [ "$?" != 0 ]; then
		echo "Exit on error"
		exit $?
	fi
done

echo "~~~~Done with upgrade scripts~~~~"
echo "Run rebuildLeftRight.php if you have problems with the permissions"
echo "Run create_language.php to create the languages files"
echo "~~~~~~~~~~~~~~~END~~~~~~~~~~~~~~~"


#echo running tmp_full_2.0.2A_script.sql
#mysql -u $2 -p$3 $1 --default-character-set=utf8 < tmp_full_2.0.2A_script.sql

