1.1 Database Upgrade
--------------------------------------------------------

1. 	Run the upgrade_v1.6.0.A_CREATE_TABLES.sql script. This script will do the following:
	- Creates the cakePHP 1.2 permissions tables (acos, aros, aros_acos)
	- Creates the ATiM 2.0 configuration table (configs)
	- Creates the ATiM 2.0 structures tables for upgrade from the forms tables. Includes:
		- structures
		- structure_fields
		- structure_formats
		- structure_validations
		- structure_options
		- structure_value_domains
		- structure_permissible_values
		- structure_value_domains_permissible_values
	- Creates the ATiM versions table
	- Recreates the ATiM menus table for the new ATiM 2.0 menu structure
		* Note: Your old menus table will be stored as the table menus_old
	
2. 	Copy the convert_forms_to_structures.php to the \www folder. Then in your internet browser
	go to http://localhost/convert_forms_to_structures.php. This script will update the entries in the
	forms, form_fields, and form_formats to the new ATiM 2.0 structures tables.
		Note: This script will take a long time to run, so go grab a coffee.
		
3.	Run the upgrade_v1.6.0.A_ALTER_TABLES.sql script. The script will do the following:
	- Add the deleted and deleted_date fields to all tables. This will be used to implement
	  the new soft delete feature
	- Add a few fields to tables to specific tables to improve the functionality of the application
	- Make a few adjustments to data in the menus table to update the menus structure for ATiM 2.0
	- Adds the correct entries in the plugin field in structure_fields
	
4. 	Run the upgrade_v1.6.0.A_REVISION_TABLES.sql script. The script will do the following:
	- Add revisions table for all the tables. This will implement the audit trail feature
	- Create the atim_information table, which will hold information of the ATiM 2.0 schema
	  and all its fields
	- Add the tables, and entries required for the provider module
	
5. 	Copy the convert_global_lookups.php script into the \www folder. Then in your internet browser
	go to http://localhost/convert_global_lookups.php. This script will convert all the global lookups
	from the ATiM 1.6 database to the new structure value domain and structure permissible values
	structures
	
6. 	Copy the convert_user_table.php script to the \www folder. Then in your internet browser go to
	http://localhost/convert_user_table.php. This script will update th entries in the user table
	to the new user table structure.
	
7.	Copy the convert_validations.php script to the \www folder. Then in your internet browser go to
	http://localhost/convert_validations.php. This script will port the validations from the the old
	form validations table to the new validations table. 
	
7.	Delete or move the following scripts out of the \www folder:
	- convert_forms_to_structures.php
	- convert_global_lookups.php
	- convert_user_table.php
	- convert_validations.php