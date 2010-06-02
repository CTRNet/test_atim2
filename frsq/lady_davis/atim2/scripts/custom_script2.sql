-- This script needs to be run right before 2.0.2. upgrade script

-- New language aliases

INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('define_date_format', '', 'Date Format', ''),
('define_csv_separator', '', 'File Export Character Separator', ''),
('define_show_summary', '', 'Show Summary', ''),
('help visible', '', 'Help Information Visible', ''),
('language', '', 'Language', ''),
('core_pagination', '', 'Pagination', '');

-- Plugins

UPDATE `structure_fields` SET `plugin` = 'Administrate' WHERE `structure_fields`.`id` =1;
UPDATE `structure_fields` SET `plugin` = 'Administrate' WHERE `structure_fields`.`id` =13;
UPDATE `structure_fields` SET `plugin` = 'Administrate' WHERE `structure_fields`.`id` =14;
UPDATE `structure_fields` SET `plugin` = 'Administrate' WHERE `structure_fields`.`id` =15;
UPDATE `structure_fields` SET `plugin` = 'Administrate' WHERE `structure_fields`.`id` =16;
UPDATE `structure_fields` SET `plugin` = 'Administrate' WHERE `structure_fields`.`id` =17;
UPDATE `structure_fields` SET `plugin` = 'Administrate' WHERE `structure_fields`.`id` =18;
UPDATE `structure_fields` SET `plugin` = 'Administrate' WHERE `structure_fields`.`id` =23;

UPDATE `structure_fields` SET `plugin` = 'Administrate',
`tablename` = 'users' WHERE `structure_fields`.`id` =58;
UPDATE `structure_fields` SET `plugin` = 'Administrate',
`tablename` = 'users' WHERE `structure_fields`.`id` =59;

UPDATE `structure_fields` SET `plugin` = 'Administrate',
`tablename` = 'structures' WHERE `structure_fields`.`id` =19;
UPDATE `structure_fields` SET `plugin` = 'Administrate',
`tablename` = 'structures' WHERE `structure_fields`.`id` =20;
UPDATE `structure_fields` SET `plugin` = 'Administrate',
`tablename` = 'structures' WHERE `structure_fields`.`id` =21;
UPDATE `structure_fields` SET `plugin` = 'Administrate',
`tablename` = 'structures' WHERE `structure_fields`.`id` =22;

UPDATE `structure_fields` SET `plugin` = 'Administrate',
`tablename` = 'structure_fields' WHERE `structure_fields`.`id` =24;
UPDATE `structure_fields` SET `plugin` = 'Administrate',
`tablename` = 'structure_fields' WHERE `structure_fields`.`id` =25;
UPDATE `structure_fields` SET `plugin` = 'Administrate',
`tablename` = 'structure_fields' WHERE `structure_fields`.`id` =26;
UPDATE `structure_fields` SET `plugin` = 'Administrate',
`tablename` = 'structure_fields' WHERE `structure_fields`.`id` =27;
UPDATE `structure_fields` SET `plugin` = 'Administrate',
`tablename` = 'structure_fields' WHERE `structure_fields`.`id` =28;
UPDATE `structure_fields` SET `plugin` = 'Administrate',
`tablename` = 'structure_fields' WHERE `structure_fields`.`id` =29;
UPDATE `structure_fields` SET `plugin` = 'Administrate',
`tablename` = 'structure_fields' WHERE `structure_fields`.`id` =30;

UPDATE `structure_fields` SET `plugin` = 'Administrate',
`tablename` = 'structure_fields' WHERE `structure_fields`.`id` =31;
UPDATE `structure_fields` SET `plugin` = 'Administrate',
`tablename` = 'structure_fields' WHERE `structure_fields`.`id` =32;
UPDATE `structure_fields` SET `plugin` = 'Administrate',
`tablename` = 'structure_fields' WHERE `structure_fields`.`id` =33;
UPDATE `structure_fields` SET `plugin` = 'Administrate',
`tablename` = 'structure_fields' WHERE `structure_fields`.`id` =34;
UPDATE `structure_fields` SET `plugin` = 'Administrate',
`tablename` = 'structure_fields' WHERE `structure_fields`.`id` =35;
UPDATE `structure_fields` SET `plugin` = 'Administrate',
`tablename` = 'structure_fields' WHERE `structure_fields`.`id` =36;
UPDATE `structure_fields` SET `plugin` = 'Administrate',
`tablename` = 'structure_fields' WHERE `structure_fields`.`id` =37;

UPDATE `structure_fields` SET `plugin` = 'Administrate',
`tablename` = 'structure_fields' WHERE `structure_fields`.`id` = 38;
UPDATE `structure_fields` SET `plugin` = 'Administrate',
`tablename` = 'structure_fields' WHERE `structure_fields`.`id` = 39;
UPDATE `structure_fields` SET `plugin` = 'Administrate',
`tablename` = 'structure_fields' WHERE `structure_fields`.`id` = 40;
UPDATE `structure_fields` SET `plugin` = 'Administrate',
`tablename` = 'structure_fields' WHERE `structure_fields`.`id` = 41;
UPDATE `structure_fields` SET `plugin` = 'Administrate',
`tablename` = 'structure_fields' WHERE `structure_fields`.`id` = 42;
UPDATE `structure_fields` SET `plugin` = 'Administrate',
`tablename` = 'structure_fields' WHERE `structure_fields`.`id` = 43;
UPDATE `structure_fields` SET `plugin` = 'Administrate',
`tablename` = 'structure_fields' WHERE `structure_fields`.`id` = 44;

UPDATE `structure_fields` SET `plugin` = 'Administrate' WHERE `structure_fields`.`id` =66;
UPDATE `structure_fields` SET `plugin` = 'Administrate' WHERE `structure_fields`.`id` =67;

UPDATE `structure_fields` SET `plugin` = 'Administrate',
`tablename` = 'user_logs' WHERE `structure_fields`.`id` =82;
UPDATE `structure_fields` SET `plugin` = 'Administrate',
`tablename` = 'user_logs' WHERE `structure_fields`.`id` =83;
UPDATE `structure_fields` SET `plugin` = 'Administrate',
`tablename` = 'user_logs' WHERE `structure_fields`.`id` =84;

UPDATE `structure_fields` SET `plugin` = 'Administrate',
`tablename` = 'users' WHERE `structure_fields`.`id` =60;
UPDATE `structure_fields` SET `plugin` = 'Administrate',
`tablename` = 'users' WHERE `structure_fields`.`id` =61;
UPDATE `structure_fields` SET `plugin` = 'Administrate',
`tablename` = 'users' WHERE `structure_fields`.`id` =62;
UPDATE `structure_fields` SET `plugin` = 'Administrate',
`tablename` = 'users' WHERE `structure_fields`.`id` =63;
UPDATE `structure_fields` SET `plugin` = 'Administrate',
`tablename` = 'users' WHERE `structure_fields`.`id` =65;
UPDATE `structure_fields` SET `plugin` = 'Administrate',
`tablename` = 'users' WHERE `structure_fields`.`id` =68;
UPDATE `structure_fields` SET `plugin` = 'Administrate',
`tablename` = 'users' WHERE `structure_fields`.`id` =69;

UPDATE `structure_fields` SET `plugin` = 'Administrate',
`tablename` = 'users' WHERE `structure_fields`.`id` =70;
UPDATE `structure_fields` SET `plugin` = 'Administrate',
`tablename` = 'users' WHERE `structure_fields`.`id` =71;
UPDATE `structure_fields` SET `plugin` = 'Administrate',
`tablename` = 'users' WHERE `structure_fields`.`id` =72;
UPDATE `structure_fields` SET `plugin` = 'Administrate',
`tablename` = 'users' WHERE `structure_fields`.`id` =73;
UPDATE `structure_fields` SET `plugin` = 'Administrate',
`tablename` = 'users' WHERE `structure_fields`.`id` =74;
UPDATE `structure_fields` SET `plugin` = 'Administrate',
`tablename` = 'users' WHERE `structure_fields`.`id` =81;
UPDATE `structure_fields` SET `plugin` = 'Administrate',
`tablename` = 'users' WHERE `structure_fields`.`id` =94;

UPDATE `structure_fields` SET `plugin` = 'Administrate',
`tablename` = 'groups' WHERE `structure_fields`.`id` =76;
UPDATE `structure_fields` SET `plugin` = 'Administrate',
`tablename` = 'groups' WHERE `structure_fields`.`id` =77;
UPDATE `structure_fields` SET `plugin` = 'Administrate',
`tablename` = 'groups' WHERE `structure_fields`.`id` =78;
UPDATE `structure_fields` SET `plugin` = 'Administrate',
`tablename` = 'groups' WHERE `structure_fields`.`id` =79;

UPDATE `structure_fields` SET `plugin` = 'Administrate',
`tablename` = 'annoucements' WHERE `structure_fields`.`id` =88;
UPDATE `structure_fields` SET `plugin` = 'Administrate',
`tablename` = 'annoucements' WHERE `structure_fields`.`id` =89;
UPDATE `structure_fields` SET `plugin` = 'Administrate',
`tablename` = 'annoucements' WHERE `structure_fields`.`id` =90;
UPDATE `structure_fields` SET `plugin` = 'Administrate',
`tablename` = 'annoucements' WHERE `structure_fields`.`id` =91;
UPDATE `structure_fields` SET `plugin` = 'Administrate',
`tablename` = 'annoucements' WHERE `structure_fields`.`id` =92;

UPDATE `structure_fields` SET `plugin` = 'Order',
`tablename` = 'order_lines' WHERE `structure_fields`.`id` =890;

UPDATE `structure_fields` SET `plugin` = 'Clinicalannotation',
`tablename` = 'participants' WHERE `structure_fields`.`id` =867;

UPDATE `structure_fields` SET `plugin` = 'Administrate',
`tablename` = 'acos' WHERE `structure_fields`.`id` =80;

UPDATE `structure_fields` SET `tablename` = 'banks' WHERE `structure_fields`.`id` =10;
UPDATE `structure_fields` SET `tablename` = 'banks' WHERE `structure_fields`.`id` =11;

-- Drop unused query structure
DELETE FROM `structure_formats` WHERE `structure_formats`.`structure_id` = 169;
DELETE FROM `structures` WHERE `structures`.`id` = 169;
DELETE FROM `structure_fields` WHERE `structure_fields`.`id` = 866;

-- Drop transaction structure and fields
DELETE FROM `structure_formats` WHERE `structure_formats`.`structure_id` = 17;
DELETE FROM `structures` WHERE `structures`.`id` = 17;
DELETE FROM `structure_fields` WHERE `structure_fields`.`model` = 'Transaction';


UPDATE `structure_fields` SET `tablename` = 'menus' WHERE `structure_fields`.`id` =13;
UPDATE `structure_fields` SET `tablename` = 'menus' WHERE `structure_fields`.`id` =14;
UPDATE `structure_fields` SET `tablename` = 'menus' WHERE `structure_fields`.`id` =15;
UPDATE `structure_fields` SET `tablename` = 'menus' WHERE `structure_fields`.`id` =16;
UPDATE `structure_fields` SET `tablename` = 'menus' WHERE `structure_fields`.`id` =17;
UPDATE `structure_fields` SET `tablename` = 'menus' WHERE `structure_fields`.`id` =18;
UPDATE `structure_fields` SET `tablename` = 'acos' WHERE `structure_fields`.`id` =952;
UPDATE `structure_fields` SET `tablename` = 'users' WHERE `structure_fields`.`id` =1;
UPDATE `structure_fields` SET `tablename` = 'users' WHERE `structure_fields`.`id` =23;

-- Old consent data fields (878, 879)
DELETE FROM `structure_fields` WHERE `structure_fields`.`model` = 'ConsentDetail'
AND `structure_fields`.`field` = 'data';

-- Delete depricated diagnosis_master_id
DELETE FROM `structure_fields` WHERE `structure_fields`.`field` = 'diagnosis_master_id'
AND `structure_fields`.`model` = 'EventMaster';
DELETE FROM `structure_fields` WHERE `structure_fields`.`field` = 'diagnosis_master_id'
AND `structure_fields`.`model` = 'TreatmentMaster';

UPDATE `structure_fields` SET `tablename` = 'datamart_adhoc_saved' WHERE `structure_fields`.`id` =853;
UPDATE `structure_fields` SET `tablename` = 'datamart_adhoc_saved' WHERE `structure_fields`.`id` =854;
UPDATE `structure_fields` SET `tablename` = 'datamart_adhoc_saved' WHERE `structure_fields`.`id` =855;

UPDATE `structure_fields` SET `tablename` = 'drugs' WHERE `structure_fields`.`model` ='Drug'
AND `structure_fields`.`plugin` = 'Drug';
UPDATE `structure_fields` SET `tablename` = 'collections' WHERE `structure_fields`.`model` ='Collection'
AND `structure_fields`.`plugin` = 'Inventorymanagement';
UPDATE `structure_fields` SET `tablename` = 'materials' WHERE `structure_fields`.`model` ='Material'
AND `structure_fields`.`plugin` = 'Material';
UPDATE `structure_fields` SET `tablename` = 'orders' WHERE `structure_fields`.`model` ='Order'
AND `structure_fields`.`plugin` = 'Order';
UPDATE `structure_fields` SET `tablename` = 'order_items' WHERE `structure_fields`.`model` ='OrderItem'
AND `structure_fields`.`plugin` = 'Order';
UPDATE `structure_fields` SET `tablename` = 'order_lines' WHERE `structure_fields`.`model` ='OrderLine'
AND `structure_fields`.`plugin` = 'Order';

UPDATE `structure_fields` SET `tablename` = 'quality_ctrls' WHERE `structure_fields`.`model` ='QualityCtrl'
AND `structure_fields`.`plugin` = 'Inventorymanagement';
UPDATE `structure_fields` SET `tablename` = 'aliquot_masters' WHERE `structure_fields`.`model` ='AliquotMaster'
AND `structure_fields`.`plugin` = 'Inventorymanagement';
UPDATE `structure_fields` SET `tablename` = 'aliquot_uses' WHERE `structure_fields`.`model` ='AliquotUse'
AND `structure_fields`.`plugin` = 'Inventorymanagement';
UPDATE `structure_fields` SET `tablename` = 'sample_masters' WHERE `structure_fields`.`model` ='SampleMaster'
AND `structure_fields`.`plugin` = 'Inventorymanagement';
UPDATE `structure_fields` SET `tablename` = 'shipments' WHERE `structure_fields`.`model` ='Shipment'
AND `structure_fields`.`plugin` = 'Order';
UPDATE `structure_fields` SET `tablename` = 'protocol_masters' WHERE `structure_fields`.`model` ='ProtocolMaster'
AND `structure_fields`.`plugin` = 'Protocol';
UPDATE `structure_fields` SET `tablename` = 'providers' WHERE `structure_fields`.`model` ='Provider'
AND `structure_fields`.`plugin` = 'Provider';
UPDATE `structure_fields` SET `tablename` = 'rtbforms' WHERE `structure_fields`.`model` ='Rtbform'
AND `structure_fields`.`plugin` = 'Rtbform';
UPDATE `structure_fields` SET `tablename` = 'sop_masters' WHERE `structure_fields`.`model` ='SopMaster'
AND `structure_fields`.`plugin` = 'Sop';
UPDATE `structure_fields` SET `tablename` = 'study_reviews' WHERE `structure_fields`.`model` ='StudyReview'
AND `structure_fields`.`plugin` = 'Study';
UPDATE `structure_fields` SET `tablename` = 'storage_masters' WHERE `structure_fields`.`model` ='StorageMaster'
AND `structure_fields`.`plugin` = 'Storagelayout';
UPDATE `structure_fields` SET `tablename` = 'storage_coordinates' WHERE `structure_fields`.`model` ='StorageCoordinate'
AND `structure_fields`.`plugin` = 'Storagelayout';
UPDATE `structure_fields` SET `tablename` = 'tma_slides' WHERE `structure_fields`.`model` ='TmaSlide'
AND `structure_fields`.`plugin` = 'Storagelayout';
UPDATE `structure_fields` SET `tablename` = 'study_contacts' WHERE `structure_fields`.`model` ='StudyContact'
AND `structure_fields`.`plugin` = 'Study';
UPDATE `structure_fields` SET `tablename` = 'study_ethics_boards' WHERE `structure_fields`.`model` ='StudyEthicsBoard'
AND `structure_fields`.`plugin` = 'Study';
UPDATE `structure_fields` SET `tablename` = 'study_fundings' WHERE `structure_fields`.`model` ='StudyFunding'
AND `structure_fields`.`plugin` = 'Study';
UPDATE `structure_fields` SET `tablename` = 'study_investigators' WHERE `structure_fields`.`model` ='StudyInvestigator'
AND `structure_fields`.`plugin` = 'Study';
UPDATE `structure_fields` SET `tablename` = 'study_related' WHERE `structure_fields`.`model` ='StudyRelated'
AND `structure_fields`.`plugin` = 'Study';
UPDATE `structure_fields` SET `tablename` = 'study_results' WHERE `structure_fields`.`model` ='StudyResult'
AND `structure_fields`.`plugin` = 'Study';
UPDATE `structure_fields` SET `tablename` = 'study_summaries' WHERE `structure_fields`.`model` ='StudySummary'
AND `structure_fields`.`plugin` = 'Study';
UPDATE `structure_fields` SET `tablename` = 'sopd_general_all' WHERE `structure_fields`.`model` ='SopDetail'
AND `structure_fields`.`plugin` = 'Sop';
UPDATE `structure_fields` SET `tablename` = 'sope_general_all' WHERE `structure_fields`.`model` ='SopExtend'
AND `structure_fields`.`plugin` = 'Sop';
UPDATE `structure_fields` SET `tablename` = 'pe_chemos' WHERE `structure_fields`.`model` ='ProtocolExtend'
AND `structure_fields`.`plugin` = 'Protocol';

UPDATE `structure_fields` SET `tablename` = 'ed_all_clinical_followup'
WHERE `structure_fields`.`model` ='EventDetail' AND
	  `structure_fields`.`plugin` = 'Clinicalannotation' AND
	  `structure_fields`.`id` IN (SELECT `structure_field_id` FROM `structure_formats` WHERE `structure_id` = 114);
	  
UPDATE `structure_fields` SET `tablename` = 'ed_all_clinical_presentation'
WHERE `structure_fields`.`model` ='EventDetail' AND
	  `structure_fields`.`plugin` = 'Clinicalannotation' AND
	  `structure_fields`.`id` IN (SELECT `structure_field_id` FROM `structure_formats` WHERE `structure_id` = 112);

UPDATE `structure_fields` SET `tablename` = 'ed_all_lifestyle_smoking'
WHERE `structure_fields`.`model` ='EventDetail' AND
	  `structure_fields`.`plugin` = 'Clinicalannotation' AND
	  `structure_fields`.`id` IN (SELECT `structure_field_id` FROM `structure_formats` WHERE `structure_id` = 126);

UPDATE `structure_fields` SET `tablename` = 'ed_all_study_research'
WHERE `structure_fields`.`model` ='EventDetail' AND
	  `structure_fields`.`plugin` = 'Clinicalannotation' AND
	  `structure_fields`.`id` IN (SELECT `structure_field_id` FROM `structure_formats` WHERE `structure_id` = 144);

UPDATE `structure_fields` SET `tablename` = 'ed_breast_lab_pathology'
WHERE `structure_fields`.`model` ='EventDetail' AND
	  `structure_fields`.`plugin` = 'Clinicalannotation' AND
	  `structure_fields`.`id` IN (SELECT `structure_field_id` FROM `structure_formats` WHERE `structure_id` = 26);
	  
UPDATE `structure_fields` SET `tablename` = 'ed_allsolid_lab_pathology'
WHERE `structure_fields`.`model` ='EventDetail' AND
	  `structure_fields`.`plugin` = 'Clinicalannotation' AND
	  `structure_fields`.`id` IN (SELECT `structure_field_id` FROM `structure_formats` WHERE `structure_id` = 115);

UPDATE `structure_fields` SET `plugin` = 'Core' WHERE `structure_fields`.`id` =235;
UPDATE `structure_fields` SET `plugin` = 'Storagelayout' WHERE `structure_fields`.`id` =326;
UPDATE `structure_fields` SET `plugin` = 'Core' WHERE `structure_fields`.`id` =274;
UPDATE `structure_fields` SET `plugin` = 'Storagelayout' WHERE `structure_fields`.`id` =315;
UPDATE `structure_fields` SET `plugin` = 'Storagelayout' WHERE `structure_fields`.`id` =317;
UPDATE `structure_fields` SET `plugin` = 'Storagelayout' WHERE `structure_fields`.`id` =318;
UPDATE `structure_fields` SET `plugin` = 'Storagelayout' WHERE `structure_fields`.`id` =874;
UPDATE `structure_fields` SET `plugin` = 'Order' WHERE `structure_fields`.`id` =889;

-- Delete Pathology Review Fields
DELETE FROM `structure_formats` WHERE `structure_id` IN (SELECT `id` FROM `structures` WHERE `alias` = 'pathcollectionreviews');
DELETE FROM `structures` WHERE `structures`.`alias` = 'pathcollectionreviews';
DELETE FROM `structure_fields` WHERE `structure_fields`.`model` = 'PathCollectionReview';

DELETE FROM `structure_formats` WHERE `structure_id` = (SELECT `id` FROM `structures` WHERE `alias` = 'reviewmasters');
DELETE FROM `structures` WHERE `structures`.`alias` = 'reviewmasters';

DELETE FROM `structure_formats` WHERE `structure_field_id` IN (SELECT `id` FROM `structure_fields` WHERE `model` = 'ReviewMaster');
DELETE FROM `structure_validations` WHERE `structure_field_id` IN (SELECT `id` FROM `structure_fields` WHERE `model` = 'ReviewMaster');
DELETE FROM `structure_fields` WHERE `structure_fields`.`model` = 'ReviewMaster';

DELETE FROM `structure_formats` WHERE `structure_field_id` IN (SELECT `id` FROM `structure_fields` WHERE `model` = 'ReviewDetail');
DELETE FROM `structure_validations` WHERE `structure_field_id` IN (SELECT `id` FROM `structure_fields` WHERE `model` = 'ReviewDetail');
DELETE FROM `structure_fields` WHERE `structure_fields`.`model` = 'ReviewDetail';

-- Delete adverse event structure and fields
DELETE FROM `structure_formats` WHERE `structure_id` IN (SELECT `id` FROM `structures` WHERE `alias` = 'ed_all_adverse_events_adverse_event');
DELETE FROM `structures` WHERE `structures`.`alias` = 'ed_all_adverse_events_adverse_event';
DELETE FROM `structure_fields` WHERE `id` IN (589,590,591,592);

-- Delete annotation -> protocol structure and fields
DELETE FROM `structure_formats` WHERE `structure_id` IN (SELECT `id` FROM `structures` WHERE `alias` = 'ed_all_protocol_followup');
DELETE FROM `structures` WHERE `structures`.`alias` = 'ed_all_protocol_followup';
DELETE FROM `structure_fields` WHERE `old_id` = 'CAN-999-999-000-999-515';

-- Delete misc. annotation fields no longer in use
DELETE FROM `structure_fields` WHERE `id` IN (495,496,497,498,526,529,530,531);
DELETE FROM `structure_fields` WHERE `structure_fields`.`id` IN (870, 871, 872, 873);

DELETE FROM `structure_fields` WHERE `structure_fields`.`id` = 336;

UPDATE `structure_fields` SET `tablename` = 'datamart_adhoc' WHERE `structure_fields`.`id` =847;
UPDATE `structure_fields` SET `tablename` = 'datamart_adhoc' WHERE `structure_fields`.`id` =868;
UPDATE `structure_fields` SET `tablename` = 'datamart_adhoc' WHERE `structure_fields`.`id` =848;
UPDATE `structure_fields` SET `tablename` = 'datamart_adhoc' WHERE `structure_fields`.`id` =869;
UPDATE `structure_fields` SET `tablename` = 'datamart_adhoc' WHERE `structure_fields`.`id` =864;

UPDATE `structure_fields` SET `tablename` = 'datamart_batch_sets' WHERE `structure_fields`.`id` =849;
UPDATE `structure_fields` SET `tablename` = 'datamart_batch_sets' WHERE `structure_fields`.`id` =850;
UPDATE `structure_fields` SET `tablename` = 'datamart_batch_sets' WHERE `structure_fields`.`id` =851;
UPDATE `structure_fields` SET `tablename` = 'datamart_batch_sets' WHERE `structure_fields`.`id` =852;

UPDATE `structure_fields` SET `tablename` = 'std_rooms' WHERE `structure_fields`.`id` =311;
UPDATE `structure_fields` SET `tablename` = 'std_rooms' WHERE `structure_fields`.`id` =312;
UPDATE `structure_fields` SET `tablename` = 'std_incubators' WHERE `structure_fields`.`id` =313;
UPDATE `structure_fields` SET `tablename` = 'std_incubators' WHERE `structure_fields`.`id` =314;
UPDATE `structure_fields` SET `tablename` = 'tma_slides' WHERE `structure_fields`.`id` =335;
UPDATE `structure_fields` SET `tablename` = 'tma_slides' WHERE `structure_fields`.`id` =349;

UPDATE `structure_fields` SET `tablename` = 'ad_tubes' WHERE `structure_fields`.`id` =261;
UPDATE `structure_fields` SET `tablename` = 'ad_cell_tubes' WHERE `structure_fields`.`id` =354;

-- Fix yes/no value domains
UPDATE `structure_fields`
SET structure_value_domain = 14
WHERE structure_value_domain = 22;

DELETE FROM `structure_value_domains_permissible_values` WHERE `structure_value_domain_id` = 22;
DELETE FROM `structure_value_domains` WHERE `structure_value_domains`.`id` = 22;

DELETE FROM `structure_value_domains_permissible_values` WHERE `structure_value_domain_id` = 64;
DELETE FROM `structure_value_domains` WHERE `structure_value_domains`.`id` = 64;

DELETE FROM `structure_value_domains_permissible_values` WHERE `structure_value_domain_id` = 171;
DELETE FROM `structure_value_domains` WHERE `structure_value_domains`.`id` = 171;

UPDATE `structure_value_domains` SET `domain_name` = 'yesno' WHERE `structure_value_domains`.`id` =14;

-- Drop old id fields from Structure tables
ALTER TABLE `structures` DROP `old_id`;

ALTER TABLE `structure_fields` DROP `old_id` ;
ALTER TABLE `structure_formats`
  DROP `old_id`,
  DROP `structure_old_id`,
  DROP `structure_field_old_id`;

-- Unique constraint for fields, move to end of script
ALTER TABLE `structure_fields`
	ADD UNIQUE `unique_fields` (`field`, `tablename`, `model`, `plugin`);
