NOTE:
 - run commande line into scripts folder...
 - the current ttr data should be into the ""ttrdb" 

drop database ttrdb;
create database ttrdb;

mysql -u root -p ttrdb --default-character-set=utf8 < .\v2.1.0\ttr_v1_db.sql

---------------------------------------------------------------------------------

1-Create a database named "atim"

drop database atim;
create database atim;

2-Run the following scripts
--tmp_atim_v2.1.0A_script_FULL.sql
--v2.1.0/bc_ttr_alter_tables.sql
--v2.1.0/bc_ttr_custom.sql

mysql -u root -p atim --default-character-set=utf8 < tmp_atim_v2.1.0A_script_FULL.sql
mysql -u root -p atim --default-character-set=utf8 < .\v2.1.0\bc_ttr_alter_tables.sql
mysql -u root -p atim --default-character-set=utf8 < .\v2.1.0\bc_ttr_custom.sql

3-Migrate the data with "v2.1.0/bc_ttr_migration.sql". Your command should
target the OLD database. You new database is expected to have the name "atim".
An example of command would be
--mysql -u [] -p ttrdb <  v2.1.0/bc_ttr_migration.sql

mysql -u root -p ttrdb <  .\v2.1.0\bc_ttr_migration.sql

4-Run the following scripts (to upgrade atim to version 2.1.1 and run the
final custom script.
--tmp_atim_v2.1.1_upgrade.sql
--bc_ttr_custom.sql

mysql -u root -p atim --default-character-set=utf8 < tmp_atim_v2.1.1_upgrade.sql
mysql -u root -p atim --default-character-set=utf8 < bc_ttr_custom.sql

