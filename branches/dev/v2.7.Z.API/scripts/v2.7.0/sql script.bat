mysql -u root atimapi1 --default-character-set=utf8 < atim_v2.7.0_full_installation.sql
mysql -u root atimapi1 --default-character-set=utf8 < atim_v2.7.0_upgrade.sql
mysql -u root atimapi1 --default-character-set=utf8 < atim_v2.7.1_upgrade.sql

mysql -u root atimapi1 --default-character-set=utf8 < DemoData\atim_v2.7.0_demo_data.sql



