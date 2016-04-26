
C:\_NicolasLuc\Server\www\chum_onco_axis\scripts\v2.6.0>mysql -u root chumoncoaxis --default-character-set=utf8 < atim_v2.6.4_upgrade.sql


### MESSAGE ###
Application Change: DatamartAppController::$display_limit variable has been removed and replaced by core variable 'databrowser_and_report_results_display_limit'. Please review any custom process or report that uses this variable and that has to be updated.
### MESSAGE ###
Application Change: Added new code to create treatment in batch. To use this functionality, please review all of your treatment creation processes (including both structures and hooks call) and change trreatment_controls data.
### MESSAGE ###
Application Change: Added new code to display details of treatments in index form : Please review all of structures of your treatments, hooks and change control data if required
### MESSAGE ###
New Realiquoting Control: Created 'tisue block' to 'tissue block' realiquoting link but set it as 'disabled'. 1- Comment line if already created in the custom version. 2- Activate link if you link has to be used in your bank.
### MESSAGE ###
New Sample Type: Created 'Xenograft' derivative. 1- Comment line if already created in the custom version. 2- Disable sample_type if this sample type is not supported into your bank.
### MESSAGE ###
New Sample Type: Created 'Cord Blood' specimen. 1- Comment line if already created in the custom version. 2- Disable sample_type if this sample type is not supported into your bank.



C:\_NicolasLuc\Server\www\chum_onco_axis\scripts\v2.6.0>mysql -u root chumoncoaxis --default-character-set=utf8 < atim_v2.6.5_upgrade.sql


### MESSAGE ###
New Sample Types: Created 'Xeno' derivatives to record any tissue, blood (plus all derivatives) collected from animal used for 'Xenograft' and different than human tissues plus all linked aliquots.
All controls will be disabled.
1- Comment line if already created in the custom version. 2- Activate sample_type and aliquot_type if required into your bank.
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
 delete  ADD CONSTRAINT `FK_consent_masters_study_summaries` FOREIGN KEY (`qc_nd_study_summary_id`) REFERENCES `study_summaries` (`id`);
 
 
 
C:\_NicolasLuc\Server\www\chum_onco_axis\scripts\v2.6.0>mysql -u root chumoncoaxis --default-character-set=utf8 < atim_v2.6.6_upgrade.sql


### TODO ####
Changed order line creation form type from 'add' to 'addgrid': OrderLine.add() to review if custom code exists
### TODO ####
Changed order item creation form type from 'add' to 'addgrid': OrderItem.add() to review if custom code exists
ERROR 1452 (23000) at line 134: Cannot add or update a child row: a foreign key constraint fails (`chumoncoaxis`.`structure_formats`, CONSTRAINT `FK_structure_formats_structure_fields` FOREIGN KEY (`structure_field_id`) REFERENCES `structure_fields` (`id`))
### TODO ###
Function Shipment.formatDataForShippedItemsSelection() has been updated. Please review customised function if exists.
### MESSAGE ###
Added option to link a TMA slide to a study. (See structures 'tma_slides').



C:\_NicolasLuc\Server\www\chum_onco_axis\scripts\v2.6.0>mysql -u root chumoncoaxis --default-character-set=utf8 < atim_v2.6.7_upgrade.sql


### MESSAGE ###
Created funtion 'Create message (applied to all)'. Run following query to activate the function.
UPDATE datamart_structure_functions SET flag_active = 1 WHERE label = 'create participant message (applied to all)';
### MESSAGE ###
Updated 'Databrowser Relationship Diagram' to add TMA blocks to TMA slides relationship. To customize.

