NOTE:
 - All of the followin is useless if you simply run the create_db.sh script
 - run command line into scripts folder...
 - the current ttr data should be into the ""ttrdb" 

drop database ttrdb;
create database ttrdb;

mysql -u root -p ttrdb --default-character-set=utf8 < .\v2.1.0\ttr_v2_db.sql

---------------------------------------------------------------------------------

1-Create a destination database

2-Run the following scripts on your newly created database
--tmp_atim_v2.1.0A_script_FULL.sql
--v2.1.0/bc_ttr_alter_tables.sql
--v2.1.0/bc_ttr_custom.sql
--v2.1.0/bc_ttr_migration.sql
--tmp_atim_v2.1.1_upgrade.sql
--bc_ttr_custom.sql

mysql -u root -p [destination database] --default-character-set=utf8 < tmp_atim_v2.1.0A_script_FULL.sql
mysql -u root -p [destination database] --default-character-set=utf8 < ./v2.1.0/bc_ttr_alter_tables.sql
mysql -u root -p [destination database] --default-character-set=utf8 < ./v2.1.0/bc_ttr_custom.sql
mysql -u root -p [destination database] --default-character-set=utf8 < ./v2.1.0/bc_ttr_migration.sql
mysql -u root -p [destination database] --default-character-set=utf8 < ./tmp_atim_v2.1.1_upgrade.sql 
mysql -u root -p [destination database] --default-character-set=utf8 < ./bc_ttr_custom.sql 


3- Build left rght data for storage + selection label + revs table

php rebuildLeftRight.php atim root 
php populateRevs.php atim root 

