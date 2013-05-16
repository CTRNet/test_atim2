#!/bin/bash
# author: N Luc
# desc: Script to create ovcare atim db in a single command line

echo =$1=$2=$3

if [ "$1$2$3" = "" -o "$1" = "" -o "$2" = "" ]
then
 echo "ATiM Database installation : Missing parameters. You need to specify database schema, username[, password]. sh create_254_db.sh schema username [password]";
 exit 0
fi

echo OvCare ATiM Database installation

echo running atim_v2.4.3A_custom_full_installation
mysql -u $2 -p$3 $1 --default-character-set=utf8 < atim_v2.4.3A_custom_full_installation.sql

echo running atim_v2.5.0_upgrade
mysql -u $2 -p$3 $1 --default-character-set=utf8 < atim_v2.5.0_upgrade.sql

echo running custom_post_250
mysql -u $2 -p$3 $1 --default-character-set=utf8 < custom_post_250.sql

echo running atim_v2.5.1_upgrade
mysql -u $2 -p$3 $1 --default-character-set=utf8 < atim_v2.5.1_upgrade.sql

echo running atim_v2.5.2_upgrade
mysql -u $2 -p$3 $1 --default-character-set=utf8 < atim_v2.5.2_upgrade.sql

echo running atim_v2.5.3_upgrade
mysql -u $2 -p$3 $1 --default-character-set=utf8 < atim_v2.5.3_upgrade.sql

echo running atim_v2.5.4_upgrade
mysql -u $2 -p$3 $1 --default-character-set=utf8 < atim_v2.5.4_upgrade.sql

echo running custom_post_254
mysql -u $2 -p$3 $1 --default-character-set=utf8 < custom_post_254.sql

echo OvCare ATiM Database installation done
