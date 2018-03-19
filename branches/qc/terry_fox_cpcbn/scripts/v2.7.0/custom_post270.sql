







### MESSAGE ###
Created funtion 'Create message (applied to all)'. Run following query to activate the function.
UPDATE datamart_structure_functions SET flag_active = 1 WHERE label = 'create participant message (applied to all)';
### MESSAGE ###
Updated 'Databrowser Relationship Diagram' to add TMA blocks to TMA slides relationship. To customize.


-- -----------------------------------------------------------------------------------------------------------------------------------
-- ATiM v2.6.8 Upgrade Script
--
-- See ATiM wiki for more information: 
--    http://www.ctrnet.ca/mediawiki/index.php/Main_Page
-- -----------------------------------------------------------------------------------------------------------------------------------
--
-- MIGRATION DETAIL:
-- 
--   ### 1 # Added Investigator and Funding sub-models to study tool
--   ---------------------------------------------------------------
--
--      To be able to create one to many investigators or fundings of a study.
--
--      TODO:
--
--      In /app/Plugin/StudyView/StudySummaries/detail.ctp, set the variables $display_study_fundings and/or $display_study_investigators
--      to 'false' to hide the section.
--
--		
--   ### 2 # Replaced the study drop down list to both an autocomplete field and a text field
--   ----------------------------------------------------------------------------------------
--
--      Replaced all 'study_summary_id' field with 'select' type and 'domain_name' equals to 'study_list' by the 2 following fields
--			- Study.FunctionManagement.autocomplete_{.*}_study_summary_id for any data creation and update
--			- Study.StudySummary.title for any data display in detail or index form.
--		
--		A field study_summary_title has been created for both ViewAliquot and ViewAliquotUse.
--		
--      The definition of study linked to a created/updated data is now done through an 'autocomplete' field.
--		
--      The search of a study linked to a data is done by the use of the text field (list could be complex to use for any long list of values).
--		
--      TODO:
--
--      Review any of these forms:
--         - aliquotinternaluses
--         - aliquot_masters
--         - aliquot_master_edit_in_batchs
--         - consent_masters_study
--         - miscidentifiers_study
--         - orderlines
--         - orders
--         - tma_slides
--         - tma_slide_uses
--         - view_aliquot_joined_to_sample_and_collection
--         - viewaliquotuses
--
--      Update $table_querie variables of the ViewAliquotCustom and ViewAliquotUseCustom models (if exists).
--
--		
--   ### 2 # Added Study Model to the databrowser
--   --------------------------------------------
--
--      TODO:
--
--		Review the /app/webroot/img/dataBrowser/datamart_structures_relationships.vsd document.
--
--		Activate databrowser links (if required) using following query:
--			UPDATE datamart_browsing_controls 
--          SET flag_active_1_to_2 = 1, flag_active_2_to_1 = 1 
--          WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'Model1') OR id2 = (SELECT id FROM datamart_structures WHERE model = 'Model2');
--
--
--   ### 3 # Added ICD-0-3-Topo Categories (tissue site/category)
--   ------------------------------------------------------------
--
--		The ICD-0-3-Topo categories have been defined based on an internet research (no source file).
--		
--		Created field 'diagnosis_masters.icd_0_3_topography_category' to record a ICD-0-3-Topo 3 digits codes (C07, etc) 
--		and to let user searches on tissue site/category (more generic than tissue description - ex: colon, etc).
--		
--		A search field on ICD-0-3-Topo categories has been created for each form displaying a field linked to the ICD-0-3-Topo tool.
--		
--      Note the StructureValueDomain 'icd_0_3_topography_categories' can also be used to set the site of any record of surgery, radiation, tissue source, etc .
--
--      TODO:
--
--		Check field has been correctly linked to any form displaying the ICD-0-3-Topo tool.
--		
--		Check field diagnosis_masters.icd_0_3_topography_category of existing records has been correctly populated based on diagnosis_masters.topography 
--		
--		field (when the diagnosis_masters.topography field contains ICD-0-3-Topo codes).
--
--		
--   ### 4 # Changed field 'Disease Code (ICD-10_WHO code)' of secondary diagnosis form from ICD-10_WHO tool to a limited drop down list
--   -----------------------------------------------------------------------------------------------------------------------------------
--
-- 		New field is linked to the StructureValueDomain 'secondary_diagnosis_icd10_code_who' that gathers only ICD-10 codes of secondaries.
--
--      TODO:
--
--		Check any of your secondary diagnosis forms.
--		
--
--   ### 5 # Changed DiagnosisControl.category values
--   ------------------------------------------------
-- 	
--		Changed:	
--         - 'secondary' to 'secondary - distant'
--         - 'progression' to 'progression - locoregional'
--         - 'recurrence' to 'recurrence - locoregional'
--
--      TODO:
--
--		Update custom code if required.
--		
--
--   ### 6 # Replaced the drug drop down list to both an autocomplete field and a text field plus moved drug_id field to Master model
--   --------------------------------------------------------------------------------------------------------------------------------
--
--		Replaced all 'drug_id' field with 'select' type and 'domain_name' equals to 'drug_list' by the 3 following field
--			- ClinicalAnnotation.FunctionManagement.autocomplete_treatment_drug_id for any data creation and update
--			- Protocol.FunctionManagement.autocomplete_protocol_drug_id for any data creation and update
--			- Drug.Drug.generic_name for any data display in detail or index form
--
--      The definition of drug linked to a created/updated data is now done through an 'autocomplete' field.
--		
--      The search of a drug linked to a data is done by the use of the text field (list could be complex to use for any long list of values).
--		
--      The drug_id table fields of the models 'TreatmentExtendDetail' and 'ProtocolExtendDetail' should be moved to the Master level (already done for txe_chemos and pe_chemos).
--
--      TODO:
--
--      Review any forms listed in treatment_extend_controls.detail_form_alias and protocol_extend_controls.detail_form_alias 
--      to update any of them containing a drug_id field.
--		
--      Migrate drug_id values of any tablename listed in treatment_extend_controls.detail_tablename and protocol_extend_controls.detail_tablename
-- 		and having a drug_id field to the treatment_extend_masters.drug_id or protocol_extend_masters.drug_id field.
--      
--      UPDATE protocol_extend_masters Master, {tablename} Detail SET Master.drug_id = Detail.drug_id WHERE Master.id = Detail.protocol_extend_master_id;
--      UPDATE protocol_extend_masters_revs Master, {tablename}_revs Detail SET Master.drug_id = Detail.drug_id WHERE Master.id = Detail.protocol_extend_master_id AND CAST(Master.version_created AS DATE) = CAST(Detail.version_created AS DATE);
--      ALTER TABLE `{tablename}` DROP FOREIGN KEY `FK_{tablename}_drugs`;
--      ALTER TABLE {tablename} DROP COLUMN drug_id;
--      ALTER TABLE {tablename}_revs DROP COLUMN drug_id;
--      
--      UPDATE treatment_extend_masters Master, {tablename} Detail SET Master.drug_id = Detail.drug_id WHERE Master.id = Detail.treatment_extend_master_id;
--      UPDATE treatment_extend_masters_revs Master, {tablename}_revs Detail SET Master.drug_id = Detail.drug_id WHERE Master.id = Detail.treatment_extend_master_id AND CAST(Master.version_created AS DATE) = CAST(Detail.version_created AS DATE);
--      ALTER TABLE `{tablename}` DROP FOREIGN KEY `FK_{tablename}_drugs`;
--      ALTER TABLE {tablename} DROP COLUMN drug_id;
--      ALTER TABLE {tablename}_revs DROP COLUMN drug_id;
--		
--
--   ### 7 # TMA slide new features
--   ------------------------------
--
--      Created an immunochemistry autocomplete field.
--		
-- 		Created a new object TmaSlideUse linked to a TmaSlide to track any slide scoring or analysis and added this one to the databrowser.
--		
--		Changed code to be able to add a TMA Slide to an Order (see point 8 below).
--
--		TODO:
--
--		Customize the TmaSlideUse controller and forms if required.
--		
--		Activate the TmaSlide to TmaSlideUse databrowser link if required.
--			UPDATE datamart_browsing_controls 
--          SET flag_active_1_to_2 = 1, flag_active_2_to_1 = 1 
--          WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'TmaSlideUse') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'TmaSlide');
--		
--		Review the /app/webroot/img/dataBrowser/datamart_structures_relationships.vsd document.
--		
--
--   ### 8 # Order tool upgrade
--   --------------------------
--
--      The all Order tool has been redesigned to be able to:
--			- Add tma slide to an order (both aliquot and tma slide will be considered as OrderItem).
--			- Define a shipped item as returned to the bank.
--			- Browse on OrderLine model with the databrowser.
--
--		TODO:
--
--		The OrderItem.addAliquotsInBatch() function has been renamed to OrderItem.addOrderItemsInBatch(). Check if custom code has to be update or not.
--		
--		Core variables 'AddAliquotToOrder_processed_items_limit' and 'AddAliquotToShipment_processed_items_limit' have been renamed to 'AddToOrder_processed_items_limit' and 'AddToShipment_processed_items_limit'
--		plus two new ones have been created 'edit_processed_items_limit'and 'defineOrderItemsReturned_processed_items_limit'. Check if custom code has to be update or not.
--		
--		Set the new core variable 'order_item_type_config' to define the type(s) of item that could be added to order ('both tma slide and aliquot' or 'aliquot only' or 'tma slide only'). Based on this variable,  
--      the fields display properties (flag_index, flag_add, etc) of the following forms 'shippeditems', 'orderitems', 'orderitems_returned' and 'orderlines' will be updated by 
--      the AppController.newVersionSetup() function.
--		
--		Activate databrowser links if required plus review the /app/webroot/img/dataBrowser/datamart_structures_relationships.vsd document.
--		
--      Update $table_querie variable of the ViewAliquotUseCustom model (if exists).
--		
--
--   ### 9 # New Sample and aliquot controls
--   ---------------------------------------
--
--      Created:
--			- Buffy Coat
--			- Nail
--			- Stool
--			- Vaginal swab
--
--		TODO:
--
--		Activate these sample types if required.
--		
--
--   ### 10 # Removed AliquotMaster.use_counter field
--   ------------------------------------------------
--
-- 		Function AliquotMaster.updateAliquotUseAndVolume() is now deprecated and replaced by AliquotMaster.updateAliquotVolume().
--
--		TODO:
--
--		Validate no custom code or migration script populate/update/use this field.
--		
--		Check custom function AliquotMasterCustom.updateAliquotUseAndVolume() exists and update this one if required.
--		
--
--   ### 11 # datamart_structures 'storage' replaced by either datamart_structures 'storage (non tma block)' and datamart_structures 'tma blocks (storages sub-set)'
--   ---------------------------------------------------------------------------------------------------------------------------------------------------------------
--
--		TODO:
--		
--		Run following queries to check if some custom functions and reports have to be reviewed:
--			SELECT * FROM datamart_structure_functions WHERE datamart_structure_id = (SELECT id FROM datamart_structures WHERE model = 'NonTmaBlockStorage') AND label != 'list all children storages';
--			SELECT * FROM datamart_reports WHERE associated_datamart_structure_id = (SELECT id FROM datamart_structures WHERE model = 'NonTmaBlockStorage') AND name != 'list all children storages';
--
--
--   ### 12 # Added new controls on storage_controls: coord_x_size and coord_y_size should be bigger than 1 if set
--   -------------------------------------------------------------------------------------------------------------
--
--		TODO:
--		
--		Run following query to detect errors
--			SELECT storage_type, coord_x_size, coord_y_size FROM storage_controls WHERE (coord_x_size IS NOT NULL AND coord_x_size < 2) OR (coord_y_size IS NOT NULL AND coord_y_size < 2);
--
--		
--   ### 13 # Replaced AliquotMaster.getDefaultStorageDate() by AliquotMaster.getDefaultStorageDateAndAccuracy()
--   -----------------------------------------------------------------------------------------------------------
--
--		TODO:
--		
--		Check any custom code using AliquotMaster.getDefaultStorageDate().
--
--		
--   ### 14 # Changed displayed pages workflow after treatment creation.
--   ------------------------------------------------------------------
--
--		Based on the created treatment type and the selected protocol (when option exists), the next page displayed after a treatment creation could be:
--			- The treatment detail form.
--			- The treatment detail form with the list of all treatment precisions already attached to the treatment based on the selected protocol (when protocol is itself linked to precisions).
--          - The treatment precision creation form when no protocol is attached to the treatment and treatment precision can be attached to the treatment.
--
--		TODO:
--		
--		Change workflow by hook if required.
--
--
--   ### 15 # Changed way we format the displayed results of a search on a Coding System List (WHO-10, etc).
--   ------------------------------------------------------------------------------------------------------
--
--		Removed the CodingIcd.%_title, CodingIcd.%_sub_title and CodingIcd.%_descriptions fields.
--
--		TODO:
--		
--		Override the CodingIcdAppModel.globalSearch and CodingIcdAppModel.getDescription functions.
--
--		
--  ### 16 # Added CAP Report "Protocol for the Examination of Specimens From Patients With Primary Carcinoma of the Colon and Rectum" (version 2016 - v3.4.0.0) 
--   -----------------------------------------------------------------------------------------------------------------------------------------------------------
--
--		TODO:
--		
--		Run queries to activate the reports:
--			- UPDATE event_controls SET flag_active = '1' WHERE event_type = 'cap report 2016 - colon/rectum - excisional biopsy';
--			- UPDATE event_controls SET flag_active = '1' WHERE event_type = 'cap report 2016 - colon/rectum - excis. resect.';
--
--
--   ### 17 # Added aliquot in stock detail to ViewAliquot
--   -----------------------------------------------------
--
--      TODO:
--
--      Update $table_querie variable of the ViewAliquotCustom model (if exists).
--
--
--   ### 18 # Added field structure_fields.sortable
--   ---------------------------------------------- 
--
--      In index view, the 'sortable' value will define if the user can sort records based on field column data or not. A field
--      displaying data generated by the system can not be used as sort criteria.
--
--      TODO:
--
--      Review custom fields and set value to 0 if fields can not be used to sort data
--
--
--   ### 19 # Added new password management features
--   -----------------------------------------------
--   
--      Some features have been developed to:
--			- Ban use of a limited number of previous passwords for any user who has to change his password.
--			- Allow users to reset a forgotten password with no support of the administrator.
--
--      TODO:
--
--		Set the new core variables 'reset_forgotten_password_feature' and 'different_passwords_number_before_re_use'.
--		Change the list of questions a user can select to record personal answers that will be used by the 'Reset forgotten password feature'. See the 'Password Reset Questions' list 
--		of the 'Dropdown List Configuration' tool.
--
--
--   ### 20 # Changed trunk code to support sql_mode ONLY_FULL_GROUP_BY
--   ------------------------------------------------------------------
--   
--       TODO:
--
--		Review any custom code if your installation set up includes the sql_mode ONLY_FULL_GROUP_BY.
-- 
-- -----------------------------------------------------------------------------------------------------------------------------------






















UPDATE versions SET branch_build_number = 'xxxxx' WHERE version_number = '2.7.0';



Types de lames doivent être déplacés au niveau des blocs de TMA
Ajouter 'Suregry pour métastases.
