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
     
      mysql -u {username} -p{password} atimprocureps[1234]forcentral --default-character-set=utf8 < 1-tables_to_create_data_dump_for_procure_central_dump.sql
      
   Database don't have to be deleted after data transfert.
   Database user should have access in read only to the ATiM PROCURE prod database and in read and write mode on the atimprocureps[1234]forcentral database on 
   local server



-- ## 2 ## Generate the site ATiM-PROCURE data (On PROCURE sites server)
-- -----------------------------------------------------------------------------------------------------------------------------------------------------

   Copy the '2-populate_local_copy_of_tables_for_datadump.sql' script then replace the following string %%local_procure_prod_database%% by the name
   of the site ATiM-PROCURE database.
   
   On a regular basis:
   
     - a - Copy ATiM-PROCURE database to the {atimprocureps[1234]forcentral} database running following script
      
      mysql -u {username} -p{password} atimprocureps[1234]forcentral --default-character-set=utf8 < 2-populate_local_copy_of_tables_for_datadump.sql
      
     - b - Create a dump of the copy

      mysqldump -u {username} -p{password} atimprocureps[1234]forcentral > atimprocureps[1234]forcentral.sql
      
     - c - Zip the file / Encrypt the zip

      gpg --batch --yes --compress-level 9 --passphrase {phrase} -o atimprocureps[1234]forcentral.atim -c atimprocureps[1234]forcentral.sql
     
     - d - sFTP the file to the central server (/ATiM/sites_dumps/ps[1234])
     
     ... TODO    
     
     
     
-- ## 3 ## Create the 4 sites databases copy (On PROCURE central server)
-- -----------------------------------------------------------------------------------------------------------------------------------------------------   
     
     Create 4 databases to recieve the data of the 4 sites : atimprocureps[1234].


     
-- ## 4 ## Polulate the 4 sites databases copy (On PROCURE central server)
-- -----------------------------------------------------------------------------------------------------------------------------------------------------   
     
     On a weekly basis, erase the 4 sites databases then regnerate these one with new scripts.
     
     gpg2 --batch --yes --passphrase {phrase} -o /ATiM/sites_data_merge/files/atimprocureps[1234]forcentral.sql -d /ATiM/sites_dumps/ps[1234]/atimprocureps[1234]forcentral.atim
     mysql -u {username} -p{password} atimprocureps[1234] --default-character-set=utf8 < /ATiM/sites_data_merge/files/atimprocureps[1234]forcentral.sql
     
     
      
-- ## 5 ## Sites data merge to ATiM Central (On PROCURE central server)
-- -----------------------------------------------------------------------------------------------------------------------------------------------------  
      
     php 3-mergeParocureSitesData.php > mergeParocureSitesData.res.html
