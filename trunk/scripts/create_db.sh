#!/bin/bash
# author: FM L'Heureux
# desc: Script to create atim db in a single command line

if [ "$1" == "" -o "$2" == "" -o "$3" == "" ]; then
 echo "Missing parameters. You need to specify database schema, username[, password]";
 exit 0
fi

echo running atim_v2.2.0_full_installation.sql
mysql -u $2 -p$3 $1 --default-character-set=utf8 < v2.2.0/atim_v2.2.0_full_installation.sql

echo running atim_v2.2.0_demo_data.sql
mysql -u $2 -p$3 $1 --default-character-set=utf8 < v2.2.0/atim_v2.2.0_demo_data.sql

echo running atim_v2.2.1_upgrade.sql
mysql -u $2 -p$3 $1 --default-character-set=utf8 < v2.2.0/atim_v2.2.1_upgrade.sql

echo running atim_v2.2.2_upgrade.sql
mysql -u $2 -p$3 $1 --default-character-set=utf8 < v2.2.0/atim_v2.2.2_upgrade.sql

echo running tmp_atim_v2.3.0_upgrade.sql
mysql -u $2 -p$3 $1 --default-character-set=utf8 < tmp_atim_v2.3.0_upgrade.sql


echo done
