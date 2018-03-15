mysql -u root atim2 --default-character-set=utf8 < atim_v2.6.0_full_installation.sql
mysql -u root atim2 --default-character-set=utf8 < atim_v2.6.1_upgrade.sql
mysql -u root atim2 --default-character-set=utf8 < atim_v2.6.2_upgrade.sql
mysql -u root atim2 --default-character-set=utf8 < atim_v2.6.3_upgrade.sql
mysql -u root atim2 --default-character-set=utf8 < atim_v2.6.4_upgrade.sql
mysql -u root atim2 --default-character-set=utf8 < atim_v2.6.5_upgrade.sql 
mysql -u root atim2 --default-character-set=utf8 < atim_v2.6.6_upgrade.sql
mysql -u root atim2 --default-character-set=utf8 < atim_v2.6.7_upgrade.sql
mysql -u root atim2 --default-character-set=utf8 < atim_v2.6.8_upgrade.sql

mysql -u root -p atim2 --default-character-set=utf8 < atim_v2.6.8_demo_data.sql