#!/bin/bash
# author: FM L'Heureux
# desc: Script to create atim db in a single command line
#
# $1: new database to build (atim v2)
# $2: user name
# $3: password
#

if [ "$1" == "" -o "$2" == "" -o "$3" == "" ]; then
 echo "Missing parameters. You need to specify schema_db_v2, username, password";
 exit 0
fi

echo running tmp_atim_v2.1.0A_script_FULL.sql
mysql -u $2 -p$3 $1 --default-character-set=utf8 < tmp_atim_v2.1.0A_script_FULL.sql

echo running v2.1.0/bc_ttr_alter_tables.sql
mysql -u $2 -p$3 $1 --default-character-set=utf8 < v2.1.0/bc_ttr_alter_tables.sql

echo running v2.1.0/bc_ttr_custom.sql
mysql -u $2 -p$3 $1 --default-character-set=utf8 < v2.1.0/bc_ttr_custom.sql

echo running v2.1.0/bc_ttr_migration.sql
mysql -u $2 -p$3 $1 --default-character-set=utf8 < v2.1.0/bc_ttr_migration.sql

echo running tmp_atim_v2.1.1_upgrade.sql
mysql -u $2 -p$3 $1 --default-character-set=utf8 < tmp_atim_v2.1.1_upgrade.sql

echo running bc_ttr_custom.sql
mysql -u $2 -p$3 $1 --default-character-set=utf8 < bc_ttr_custom.sql

echo running rebuildLeftRight.php
php rebuildLeftRight.php $1 $2 $3

echo populateRevs.php
php populateRevs.php $1 $2 $3

echo done



 
