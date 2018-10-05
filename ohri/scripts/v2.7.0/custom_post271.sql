-- -----------------------------------------------------------------------------------------------------------------------------------
-- Mirgation from v254 (revs5176) to v271
--
-- mysql -u root ohri --default-character-set=utf8 < ./v2.6.0/custom_pre270.sql
-- mysql -u root ohri --default-character-set=utf8 < ./v2.6.0/atim_v2.6.0_upgrade.sql
-- mysql -u root ohri --default-character-set=utf8 < ./v2.6.0/custom_post270.sql
-- mysql -u root ohri --default-character-set=utf8 < ./v2.6.0/atim_v2.6.1_upgrade.sql
-- mysql -u root ohri --default-character-set=utf8 < ./v2.6.0/atim_v2.6.2_upgrade.sql
-- mysql -u root ohri --default-character-set=utf8 < ./v2.6.0/atim_v2.6.3_upgrade.sql
-- mysql -u root ohri --default-character-set=utf8 < ./v2.6.0/atim_v2.6.4_upgrade.sql
-- mysql -u root ohri --default-character-set=utf8 < ./v2.6.0/atim_v2.6.5_upgrade.sql
-- mysql -u root ohri --default-character-set=utf8 < ./v2.6.0/atim_v2.6.6_upgrade.sql
-- mysql -u root ohri --default-character-set=utf8 < ./v2.6.0/atim_v2.6.7_upgrade.sql
-- mysql -u root ohri --default-character-set=utf8 < ./v2.6.0/atim_v2.6.8_upgrade.sql
--
-- mysql -u root ohri --default-character-set=utf8 < ./v2.7.0/atim_v2.7.0_upgrade.sql
-- mysql -u root ohri --default-character-set=utf8 < ./v2.7.0/atim_v2.7.1_upgrade.sql
-- mysql -u root ohri --default-character-set=utf8 < ./v2.7.0/custom_post271.sql
--
--
-- -----------------------------------------------------------------------------------------------------------------------------------

SET GLOBAL sql_mode = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION';
SET SESSION sql_mode = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION';

-- Hide all fields displaying protocol data into Inventory Management module.
-- -----------------------------------------------------------------------------------------------------------------------------------

UPDATE structure_formats SET `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') 
AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='collection_protocol_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='collection_protocols') AND `flag_confidential`='0');

UPDATE structure_formats SET `language_heading`='collection' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') 
AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='acquisition_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats SET `language_heading`='', `flag_index`='0' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') 
AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='collection_protocol_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='collection_protocols') AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_index`='0', `flag_summary`='0' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='collections_for_collection_tree_view') 
AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='collection_protocol_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='collection_protocols') AND `flag_confidential`='0');



SELECT count(*) FROM orderline






















PARTICIPANT IDENTIFIER REPORT
----------------------------------------------------------------------------------------------------------
Queries to desactivate 'Participant Identifiers' demo report
----------------------------------------------------------------------------------------------------------
UPDATE datamart_reports SET flag_active = 0 WHERE name = 'participant identifiers';
UPDATE datamart_structure_functions SET flag_active = 0 WHERE link = (SELECT CONCAT('/Datamart/Reports/manageReport/',id) FROM datamart_reports WHERE name = 'participant identifiers');

TODO
----------------------------------------------------------------------------------------------------------
Added new relationsips into databrowser


Should change trunk ViewSample

Review user - inactif/actif password

### MESSAGE ###
Application Change: Added new code to create treatment in batch. 

### MESSAGE ###
Changed way all records linked to a study are displayed. Please review code of StudySummary.listAllLinkedRecords() and change custom code if required.

### MESSAGE ###
Added option to link a MiscIdentifier to a study.
To activate option: Run following queries and change value of the misc_identifier_controls.flag_link_to_study to 1.
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1', `flag_summary`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='miscidentifiers_for_participant_search') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='MiscIdentifier' AND `tablename`='misc_identifiers' AND `field`='study_summary_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='study_list') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1', `flag_detail`='1', `flag_summary`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='miscidentifiers') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='MiscIdentifier' AND `tablename`='misc_identifiers' AND `field`='study_summary_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='study_list') AND `flag_confidential`='0');
### MESSAGE ###
Added option to link a ConsentMaster to a study. (See structures 'consent_masters_study').

### MESSAGE ###
Added option to link a TMA slide to a study. (See structures 'tma_slides').

### MESSAGE ###
Created funtion 'Create message (applied to all)'. Run following query to activate the function.
UPDATE datamart_structure_functions SET flag_active = 1 WHERE label = 'create participant message (applied to all)';
### MESSAGE ###
Updated 'Databrowser Relationship Diagram' to add TMA blocks to TMA slides relationship. To customize.

   ### 8 # Option to copy user logs data to a server file
   -----------------------------------------------------------
