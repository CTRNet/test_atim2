-- -----------------------------------------------------------------------------------------------------------------------------------------------------
--    ATiM-PROCURE
-- -----------------------------------------------------------------------------------------------------------------------------------------------------
--
--   Instruction to format, transfert then merge the ATiM PROCURE data of the 4 PROCURE sites into an ATiM PROUCRE Central.
--
--   Version : 2018-08-22
-- -----------------------------------------------------------------------------------------------------------------------------------------------------


-- ## 1 ## Creation of a local database that will be use on a regular basis to copy then format the local ATiM-Procure data 
-- -----------------------------------------------------------------------------------------------------------------------------------------------------

   On each local server, create a second database {atimprocurefordump} loading the '1-tables_to_create_data_dump_for_procure_central_dump.sql' script 
   (see command line below):
     
      mysql -u {username} -p {atimprocurefordump} --default-character-set=utf8 < 1-tables_to_create_data_dump_for_procure_central_dump.sql


-- ## 2 ## Generate the site ATiM-PROCURE data
-- -----------------------------------------------------------------------------------------------------------------------------------------------------

   Copy the '2-populate_local_copy_of_tables_for_datadump.sql' script then replace the following string %%local_procure_prod_database%% by the name
   of the site ATiM-PROCURE database.
   
   On a regular basis:
   
     a- Copy ATiM-PROCURE database to the {atimprocurefordump} database running following script
      
      mysql -u {username} -p {atimprocurefordump} --default-character-set=utf8 < 2-populate_local_copy_of_tables_for_datadump.sql
      
     b- Create a dump of the copy

      mysqldump -u {username} -p {atimprocurefordump} > ps{1,2,3,4}_atim_procure_dump_for_central.sql
      
     c- Zip the file   

      zip ps{1,2,3,4}_atim_procure_dump_for_central.zip ps{1,2,3,4}_atim_procure_dump_for_central.sql
      
     d- Encrypt the zip
     
     ... 