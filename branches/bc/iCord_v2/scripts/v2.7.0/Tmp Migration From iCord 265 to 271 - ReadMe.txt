-- -----------------------------------------------------------------------------------------------------------------------------------
-- iCord ATiM Migration From  ATiM v2.6.5 (revs 6230/7559) to ATiM v2.7.1 (revs 7393/to define)                                                                                                     --
-- -----------------------------------------------------------------------------------------------------------------------------------
--                                                                                                                                --
-- Notes: Temporary ReadMe file to delete after the migration.                                            --
-- -----------------------------------------------------------------------------------------------------------------------------------

mysql -u {user} -p{password} {database} --default-character-set=utf8 < ./v2.6.0/atim_v2.6.6_upgrade.sql
mysql -u {user} -p{password} {database} --default-character-set=utf8 < ./v2.6.0/atim_v2.6.7_upgrade.sql
mysql -u {user} -p{password} {database} --default-character-set=utf8 < ./v2.6.0/atim_v2.6.8_upgrade.sql

mysql -u {user} -p{password} {database} --default-character-set=utf8 < ./v2.7.0/atim_v2.7.0_upgrade.sql
mysql -u {user} -p{password} {database} --default-character-set=utf8 < ./v2.7.0/atim_v2.7.1_upgrade.sql
mysql -u {user} -p{password} {database} --default-character-set=utf8 < ./v2.7.0/custom_post_271.sql









