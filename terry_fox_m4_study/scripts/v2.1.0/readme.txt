ATiM v2.1.0 has three SQL files required for installation. These files are only
valid against a v2.0.2A installation. Using them against earlier versions may cause
unpredicible behavior. Please run them in the following order to ensure a clean upgrade:

BE SURE TO BACKUP YOUR DATABASE BEFOREHAND

1 - atim_v2.1.0_upgrade.sql
2 - atim_v2.1.0_icd_upgrade.sql
3 - cap_report_2009_gastrointestinal.all.sql

ATiM v2.1.0A is a minor bug fix release to correct a critical issue with validation. A few other
small bug fixes were addressed in this release as well. To upgrade the database run:

1 - atim_v2.1.0A_upgrade.sql