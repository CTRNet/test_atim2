#!/bin/bash
# author: FM L'Heureux
# desc: Script to create atim db in a single command line

if [ "$1" == "" -o "$2" == "" -o "$3" == "" ]; then
 echo "Missing parameters. You need to specify database schema, username[, password]";
 exit 0
fi

echo running atim_v2.1.0B_upgrade.sql
mysql -u $2 -p$3 $1 --default-character-set=utf8 < v2.1.0/atim_v2.1.0B_upgrade.sql

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

echo running atim_v2.4.0_upgrade.sql
mysql -u $2 -p$3 $1 --default-character-set=utf8 < v2.4.0/atim_v2.4.0_upgrade.sql

echo "running custom.sql (for 2.4.0)"
mysql -u $2 -p$3 $1 --default-character-set=utf8 < v2.4.0/custom.sql

echo *****DONE*****
