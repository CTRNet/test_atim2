#!/bin/bash
# author: FM L'Heureux
# desc: Script to create atim db in a single command line

if [ "$1" == "" -o "$2" == "" -o "$3" == "" ]; then
 echo "Missing parameters. You need to specify database schema, username[, password]";
 exit 0
fi

echo running tmp_atim_v2.1.0A_script_FULL.sql
mysql -u $2 -p$3 $1 --default-character-set=utf8 < tmp_atim_v2.1.0A_script_FULL.sql

echo running tmp_atim_v2.1.1_upgrade.sql
mysql -u $2 -p$3 $1 --default-character-set=utf8 < tmp_atim_v2.1.1_upgrade.sql

echo running tmp_atim_v2.1.1_demo_data.sql
mysql -u $2 -p$3 $1 --default-character-set=utf8 < tmp_atim_v2.1.1_demo_data.sql

echo running custom.sql
mysql -u $2 -p$3 $1 --default-character-set=utf8 < custom.sql


echo done
