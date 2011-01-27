#!/bin/bash
# author: FM L'Heureux
# desc: Script to create atim db in a single command line
#
# $1: current database to migrate (atim v1)
# $2: new database to build (atim v2)
# $3: user name
# $4: password
#
# TODO : the atim v2 db should be empty

if [ "$1" == "" -o "$2" == "" -o "$3" == "" -o "$4" == "" ]; then
 echo "Missing parameters. You need to specify database schema_db_v1, schema_db_v2, username[, password]";
 exit 0
fi

if [ "$1" == "ttrdb" ]; 
 then echo "DB source = ttrdb";
 else echo "atim v1 should be named [ttrdb] and atim v2 should be named [atim]";
 exit 0
fi

if [ "$2" == "atim" ]; 
 then echo "New DB = atim";
 else echo "atim v1 should be named [ttrdb] and atim v2 should be named [atim]";
 exit 0
fi

echo running tmp_atim_v2.1.0A_script_FULL.sql
mysql -u $3 -p$4 $2 --default-character-set=utf8 < tmp_atim_v2.1.0A_script_FULL.sql

echo running v2.1.0/bc_ttr_alter_tables.sql
mysql -u $3 -p$4 $2 --default-character-set=utf8 < v2.1.0/bc_ttr_alter_tables.sql

echo running v2.1.0/bc_ttr_custom.sql
mysql -u $3 -p$4 $2 --default-character-set=utf8 < v2.1.0/bc_ttr_custom.sql

echo running v2.1.0/bc_ttr_migration.sql
mysql -u $3 -p$4 $1 --default-character-set=utf8 < v2.1.0/bc_ttr_migration.sql

echo running tmp_atim_v2.1.1_upgrade.sql
mysql -u $3 -p$4 $2 --default-character-set=utf8 < tmp_atim_v2.1.1_upgrade.sql

echo running bc_ttr_custom.sql
mysql -u $3 -p$4 $2 --default-character-set=utf8 < bc_ttr_custom.sql

echo running rebuildLeftRight.php
php rebuildLeftRight.php $2 $3 $4

echo populateRevs.php
php populateRevs.php $2 $3 $4

echo done



 