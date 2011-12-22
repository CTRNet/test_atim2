#!/bin/bash
# author: FM L'Heureux
# desc: Script to create atim db in a single command line

if [ "$1" == "" -o "$2" == "" -o "$3" == "" ]; then
 echo "Missing parameters. You need to specify database schema, username[, password]";
 exit 0
fi

echo running atim_v2.2.0_upgrade.sql
mysql -u $2 -p$3 $1 --default-character-set=utf8 < v2.2.0/atim_v2.2.0_upgrade.sql

echo running atim_v2.2.1_upgrade.sql
mysql -u $2 -p$3 $1 --default-character-set=utf8 < v2.2.0/atim_v2.2.1_upgrade.sql

echo running atim_v2.2.2_upgrade.sql
mysql -u $2 -p$3 $1 --default-character-set=utf8 < v2.2.0/atim_v2.2.2_upgrade.sql

echo running atim_v2.3.0_upgrade.sql
mysql -u $2 -p$3 $1 --default-character-set=utf8 < v2.3.0/atim_v2.3.0_upgrade.sql

echo running atim_v2.3.1_upgrade.sql
mysql -u $2 -p$3 $1 --default-character-set=utf8 < v2.3.0/atim_v2.3.1_upgrade.sql

echo running atim_v2.3.2_upgrade.sql
mysql -u $2 -p$3 $1 --default-character-set=utf8 < v2.3.0/atim_v2.3.2_upgrade.sql

echo running atim_v2.3.3_upgrade.sql
mysql -u $2 -p$3 $1 --default-character-set=utf8 < v2.3.0/atim_v2.3.3_upgrade.sql

echo running atim_v2.3.4_upgrade.sql
mysql -u $2 -p$3 $1 --default-character-set=utf8 < v2.3.0/atim_v2.3.4_upgrade.sql

echo running atim_v2.3.5_upgrade.sql
mysql -u $2 -p$3 $1 --default-character-set=utf8 < v2.3.0/atim_v2.3.5_upgrade.sql

echo running atim_v2.3.6_upgrade.sql
mysql -u $2 -p$3 $1 --default-character-set=utf8 < v2.3.0/atim_v2.3.6_upgrade.sql
1
echo running custom_pre240.sql
mysql -u $2 -p$3 $1 --default-character-set=utf8 < v2.4.0/custom_pre240.sql

echo running atim_v2.4.0_upgrade.sql
mysql -u $2 -p$3 $1 --default-character-set=utf8 < v2.4.0/atim_v2.4.0_upgrade.sql

echo running custom_post240.sql
mysql -u $2 -p$3 $1 --default-character-set=utf8 < v2.4.0/custom_post240.sql

echo running atim_v2.4.1_upgrade.sql
mysql -u $2 -p$3 $1 --default-character-set=utf8 < v2.4.0/atim_v2.4.1_upgrade.sql

echo running custom_post241.sql
mysql -u $2 -p$3 $1 --default-character-set=utf8 < v2.4.0/custom_post241.sql

echo running atim_v2.4.2_upgrade.sql
mysql -u $2 -p$3 $1 --default-character-set=utf8 < v2.4.0/atim_v2.4.2_upgrade.sql

echo running custom_post242.sql
mysql -u $2 -p$3 $1 --default-character-set=utf8 < v2.4.0/custom_post242.sql


echo *****DONE*****
