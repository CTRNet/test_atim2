1-Create a database named "atim"

2-Run the following scripts
--tmp_atim_v2.1.0A_script_FULL.sql
--v2.1.0/bc_ttr_alter_tables.sql
--v2.1.0/bc_ttr_custom.sql

3-Migrate the data with "v2.1.0/bc_ttr_migration.sql". Your command should
target the OLD database. You new database is expected to have the name "atim".
An example of command would be
--mysql -u [] -p atim_v1 <  v2.1.0/bc_ttr_migration.sql

4-Run the following scripts (to upgrade atim to version 2.1.1 and run the
final custom script.
--tmp_atim_v2.1.1_upgrade.sql
--bc_ttr_custom.sql
