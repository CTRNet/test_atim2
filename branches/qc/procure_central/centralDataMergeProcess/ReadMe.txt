-- -----------------------------------------------------------------------------------------------------------------------------------------------------
--    ATiM-PROCURE
-- -----------------------------------------------------------------------------------------------------------------------------------------------------
--
--   Instruction to format, transfert then merge the ATiM PROCURE data of the 4 PROCURE sites into an ATiM PROUCRE Central.
--
--   Version : 2018-08-22
-- -----------------------------------------------------------------------------------------------------------------------------------------------------


-- ## 1 ## Creation of a local database that will be use on a regular basis to copy then format the local ATiM-Procure data (On PROCURE sites server)
-- -----------------------------------------------------------------------------------------------------------------------------------------------------

   On each local server, create a second database {atimprocureps[1234]forcentral} loading the '1-tables_to_create_data_dump_for_procure_central_dump.sql' script 
   (see command line below):
     
      mysql -u {username} -p atimprocureps[1234]forcentral --default-character-set=utf8 < 1-tables_to_create_data_dump_for_procure_central_dump.sql
      
   Database don't have to be deleted after data transfert.


-- ## 2 ## Generate the site ATiM-PROCURE data (On PROCURE sites server)
-- -----------------------------------------------------------------------------------------------------------------------------------------------------

   Copy the '2-populate_local_copy_of_tables_for_datadump.sql' script then replace the following string %%local_procure_prod_database%% by the name
   of the site ATiM-PROCURE database.
   
   On a regular basis:
   
     a- Copy ATiM-PROCURE database to the {atimprocureps[1234]forcentral} database running following script
      
      mysql -u {username} -p atimprocureps[1234]forcentral --default-character-set=utf8 < 2-populate_local_copy_of_tables_for_datadump.sql
      
     b- Create a dump of the copy

      mysqldump -u {username} -p atimprocureps[1234]forcentral > ps[1234]_atim_procure_dump_for_central.sql
      
     c- Zip the file / Encrypt the zip
     
     ... TODO Yaser
     
     d- sFTP the file to the central server
     
     ... TODO Yaser
     
-- ## 3 ## Create the 4 sites databases copy (On PROCURE central server
-- -----------------------------------------------------------------------------------------------------------------------------------------------------   
     
     Create 4 databases to recieve the data of the 4 sites.
     
      mysql -u {username} -p atimprocureps1forcentral --default-character-set=utf8 < 1-tables_to_create_data_dump_for_procure_central_dump.sql
      mysql -u {username} -p atimprocureps2forcentral --default-character-set=utf8 < 1-tables_to_create_data_dump_for_procure_central_dump.sql
      mysql -u {username} -p atimprocureps3forcentral --default-character-set=utf8 < 1-tables_to_create_data_dump_for_procure_central_dump.sql
      mysql -u {username} -p atimprocureps4forcentral --default-character-set=utf8 < 1-tables_to_create_data_dump_for_procure_central_dump.sql
      
     Database don't have to be deleted after data transfert.
     
-- ## 4 ## Polulate the 4 sites databases copy (On PROCURE central server
-- -----------------------------------------------------------------------------------------------------------------------------------------------------   
     
     On a weekly basis erase the 4 sites databases then regnerate these one with new script
     
     a- Unzip / Devrypt the fieldthen 
     
      mysql -u {username} -p atimprocureps1forcentral --default-character-set=utf8 < 1-tables_to_create_data_dump_for_procure_central_dump.sql
      mysql -u {username} -p atimprocureps2forcentral --default-character-set=utf8 < 1-tables_to_create_data_dump_for_procure_central_dump.sql
      mysql -u {username} -p atimprocureps3forcentral --default-character-set=utf8 < 1-tables_to_create_data_dump_for_procure_central_dump.sql
      mysql -u {username} -p atimprocureps4forcentral --default-character-set=utf8 < 1-tables_to_create_data_dump_for_procure_central_dump.sql
      
-- ## 5 ## Sites data merge to ATiM Central (On PROCURE central server
-- -----------------------------------------------------------------------------------------------------------------------------------------------------  
      
     ... TODO Nicolas
     
      
-- ## 6 ## Last queries (On PROCURE central server
-- -----------------------------------------------------------------------------------------------------------------------------------------------------  
     
mysql -u root -pxxx atim_procure_central -e "DELETE FROM procure_banks_data_merge_messages WHERE type = 'merge_try_date'"
mysql -u root -pxxx atim_procure_central -e "INSERT INTO procure_banks_data_merge_messages  (type,details) VALUES ('merge_try_date', DATE(NOW()))"