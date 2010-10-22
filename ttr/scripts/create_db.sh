#!/bin/bash
# author: FM L'Heureux
# desc: Script to create atim db in a single command line

if [ "$1" == "" -o "$2" == "" -o "$3" == "" ]; then
 echo "Missing parameters. You need to specify database schema, username[, password]";
 exit 0
fi

echo running tmp_full_2.0.2A_script.sql
mysql -u $2 -p$3 $1 --default-character-set=utf8 < tmp_full_2.0.2A_script.sql

echo running tmp_v2.1.0_upgrade.sql
mysql -u $2 -p$3 $1 --default-character-set=utf8 < tmp_v2.1.0_upgrade.sql

echo running tmp_v2.1.0_icd_upgrade.sql
mysql -u $2 -p$3 $1 --default-character-set=utf8 < tmp_v2.1.0_icd_upgrade.sql

echo running tmp_demo_data.sql
mysql -u $2 -p$3 $1 --default-character-set=utf8 < tmp_demo_data.sql

echo done

