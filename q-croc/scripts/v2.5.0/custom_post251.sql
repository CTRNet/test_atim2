
UPDATE users SET flag_active = 1;
INSERT INTO i18n (id,en,fr) VALUES ('core_installname', 'Q-CROC','Q-CROC');

-- -------------------------------------------------------------------------------------------
-- CLINICAL ANNOTATION
-- -------------------------------------------------------------------------------------------

UPDATE structure_formats SET flag_add= '0', flag_add_readonly= '0', flag_edit= '0', flag_edit_readonly= '0', flag_search= '0', flag_search_readonly= '0', flag_addgrid= '0', flag_addgrid_readonly= '0', flag_editgrid= '0', flag_editgrid_readonly= '0', flag_batchedit= '0', flag_batchedit_readonly= '0', flag_index= '0', flag_detail= '0', flag_summary= '0'
WHERE structure_id IN (SELECT id FROM structures WHERE alias = 'participants') 
AND structure_field_id NOT IN (SELECT id FROM structure_fields WHERE field IN ('ids','created','participant_identifier','notes') AND model = 'Participant');

ALTER TABLE participants ADD COLUMN `qcroc_initials` varchar(10) DEFAULT NULL AFTER participant_identifier;
ALTER TABLE participants_revs ADD COLUMN `qcroc_initials` varchar(10) DEFAULT NULL AFTER participant_identifier;
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'Participant', 'participants', 'qcroc_initials', 'input',  NULL , '0', 'size=6', '', '', 'initials', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='qcroc_initials' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=6' AND `default`='' AND `language_help`='' AND `language_label`='initials' AND `language_tag`=''), '1', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0');
INSERT INTO `structure_validations` (`structure_field_id`, `rule`, `on_action`, `language_message`) VALUES ((SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='qcroc_initials'), 'notEmpty', '', '');

INSERT IGNORE INTO i18n (id,en,fr) VALUES ('initials','Initials','Initiales');

UPDATE menus SET flag_active = 0 WHERE use_link LIKE '/ClinicalAnnotation/FamilyHistories%';
UPDATE menus SET flag_active = 0 WHERE use_link LIKE '/ClinicalAnnotation/ParticipantContacts%';
UPDATE menus SET flag_active = 0 WHERE use_link LIKE '/ClinicalAnnotation/MiscIdentifiers%';
UPDATE menus SET flag_active = 0 WHERE use_link LIKE '/ClinicalAnnotation/EventMasters%';
UPDATE menus SET flag_active = 0 WHERE use_link LIKE '/ClinicalAnnotation/DiagnosisMasters%';
UPDATE menus SET flag_active = 0 WHERE use_link LIKE '/ClinicalAnnotation/ReproductiveHistories%';
UPDATE menus SET flag_active = 0 WHERE use_link LIKE '/ClinicalAnnotation/TreatmentMasters%';
UPDATE menus SET flag_active = 0 WHERE use_link LIKE '/ClinicalAnnotation/ConsentMasters%';
UPDATE menus SET flag_active = 0 WHERE use_link LIKE '/ClinicalAnnotation/Participants/chronology/%';

UPDATE structure_formats SET flag_add= '0', flag_add_readonly= '0', flag_edit= '0', flag_edit_readonly= '0', flag_search= '0', flag_search_readonly= '0', flag_addgrid= '0', flag_addgrid_readonly= '0', flag_editgrid= '0', flag_editgrid_readonly= '0', flag_batchedit= '0', flag_batchedit_readonly= '0', flag_index= '0', flag_detail= '0', flag_summary= '0'
WHERE structure_id IN (SELECT id FROM structures WHERE alias = 'clinicalcollectionlinks') 
AND structure_field_id NOT IN (SELECT id FROM structure_fields WHERE model = 'Collection');

-- -------------------------------------------------------------------------------------------
-- INVENTORY
-- -------------------------------------------------------------------------------------------

-- ** COLLECTION **

UPDATE structure_formats SET flag_add= '0', flag_add_readonly= '0', flag_edit= '0', flag_edit_readonly= '0', flag_search= '0', flag_search_readonly= '0', flag_addgrid= '0', flag_addgrid_readonly= '0', flag_editgrid= '0', flag_editgrid_readonly= '0', flag_batchedit= '0', flag_batchedit_readonly= '0', flag_index= '0', flag_detail= '0', flag_summary= '0'
WHERE structure_id IN (SELECT id FROM structures WHERE alias = 'view_collection') 
AND structure_field_id NOT IN (SELECT id FROM structure_fields WHERE model = 'ViewCollection' AND field IN ('collection_site','collection_datetime','sop_master_id','participant_identifier','created','collection_notes'));

UPDATE structure_formats SET flag_add= '0', flag_add_readonly= '0', flag_edit= '0', flag_edit_readonly= '0', flag_search= '0', flag_search_readonly= '0', flag_addgrid= '0', flag_addgrid_readonly= '0', flag_editgrid= '0', flag_editgrid_readonly= '0', flag_batchedit= '0', flag_batchedit_readonly= '0', flag_index= '0', flag_detail= '0', flag_summary= '0'
WHERE structure_id IN (SELECT id FROM structures WHERE alias = 'linked_collections') 
AND structure_field_id NOT IN (SELECT id FROM structure_fields WHERE model = 'Collection' AND field IN ('collection_site','collection_datetime','sop_master_id','participant_identifier','created','collection_notes'));

UPDATE structure_formats SET flag_add= '0', flag_add_readonly= '0', flag_edit= '0', flag_edit_readonly= '0', flag_search= '0', flag_search_readonly= '0', flag_addgrid= '0', flag_addgrid_readonly= '0', flag_editgrid= '0', flag_editgrid_readonly= '0', flag_batchedit= '0', flag_batchedit_readonly= '0', flag_index= '0', flag_detail= '0', flag_summary= '0'
WHERE structure_id IN (SELECT id FROM structures WHERE alias = 'collections') 
AND structure_field_id NOT IN (SELECT id FROM structure_fields WHERE model = 'Collection' AND field IN ('collection_site','collection_datetime','sop_master_id','participant_identifier','created','collection_notes'));

INSERT INTO `structure_validations` (`structure_field_id`, `rule`, `on_action`, `language_message`) VALUES ((SELECT id FROM structure_fields WHERE `model`='Collection'  AND `field`='collection_datetime'), 'notEmpty', '', '');
INSERT INTO `structure_validations` (`structure_field_id`, `rule`, `on_action`, `language_message`) VALUES ((SELECT id FROM structure_fields WHERE `model`='Collection'  AND `field`='collection_site'), 'notEmpty', '', '');

UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='sop_master_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='collection_sop_list') AND `flag_confidential`='0');

ALTER TABLE collections ADD COLUMN `qcroc_sop_followed` char(1) DEFAULT '' AFTER sop_master_id;
ALTER TABLE collections_revs ADD COLUMN `qcroc_sop_followed` char(1) DEFAULT '' AFTER sop_master_id;

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'ViewCollection', '', 'qcroc_sop_followed', 'yes_no',  NULL , '0', '', '', '', '', 'sop followed');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='view_collection'), (SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='qcroc_sop_followed'), '1', '11', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'Collection', 'collections', 'qcroc_sop_followed', 'yes_no',  NULL , '0', '', '', '', '', 'sop followed');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='linked_collections'), (SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='qcroc_sop_followed'), '0', '11', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='collections'), (SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='qcroc_sop_followed'), '0', '11', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');

INSERT INTO i18n (id,en) VALUES ('sop followed','Followed');
REPLACE INTO i18n (id,en) VALUES ('inv_collection_datetime_defintion','Time of blood draw or time of biopsy, etc.');

-- Invetory Configuration

UPDATE parent_to_derivative_sample_controls SET flag_active=false WHERE id IN(137, 1, 12, 19, 131, 23, 136, 2, 25, 3, 119, 132, 6, 142, 105, 112, 106, 120, 124, 121, 103, 109, 104, 122, 127, 123, 7, 130, 101, 102, 11, 10);
UPDATE parent_to_derivative_sample_controls SET flag_active=false WHERE id IN(143, 141, 144);
UPDATE aliquot_controls SET flag_active=false WHERE id IN(11, 33);
UPDATE realiquoting_controls SET flag_active=false WHERE id IN(12, 34);
UPDATE parent_to_derivative_sample_controls SET flag_active=false WHERE id IN(140);

-- ** SAMPLE **

UPDATE structure_formats SET flag_add= '0', flag_add_readonly= '0', flag_edit= '0', flag_edit_readonly= '0', flag_search= '0', flag_search_readonly= '0', flag_addgrid= '0', flag_addgrid_readonly= '0', flag_editgrid= '0', flag_editgrid_readonly= '0', flag_batchedit= '0', flag_batchedit_readonly= '0', flag_index= '0', flag_detail= '0', flag_summary= '0'
WHERE structure_id IN (SELECT id FROM structures WHERE alias = 'sample_masters') 
AND structure_field_id IN (SELECT id FROM structure_fields WHERE model = 'SampleMaster' AND field IN ('sop_master_id','is_problematic'));

-- Blood

UPDATE structure_formats SET flag_add= '0', flag_add_readonly= '0', flag_edit= '0', flag_edit_readonly= '0', flag_search= '0', flag_search_readonly= '0', flag_addgrid= '0', flag_addgrid_readonly= '0', flag_editgrid= '0', flag_editgrid_readonly= '0', flag_batchedit= '0', flag_batchedit_readonly= '0', flag_index= '0', flag_detail= '0', flag_summary= '0'
WHERE structure_id IN (SELECT id FROM structures WHERE alias = 'sd_spe_bloods') 
AND structure_field_id IN (SELECT id FROM structure_fields WHERE model = 'SampleDetail' AND field IN ('collected_tube_nbr'));

UPDATE structure_formats SET flag_add= '0', flag_add_readonly= '0', flag_edit= '0', flag_edit_readonly= '0', flag_search= '0', flag_search_readonly= '0', flag_addgrid= '0', flag_addgrid_readonly= '0', flag_editgrid= '0', flag_editgrid_readonly= '0', flag_batchedit= '0', flag_batchedit_readonly= '0', flag_index= '0', flag_detail= '0', flag_summary= '0'
WHERE structure_id IN (SELECT id FROM structures WHERE alias = 'specimens');

ALTER TABLE sd_spe_bloods 
	ADD COLUMN `qcroc_drawn_prior_to_chemo` char(1) DEFAULT '' AFTER collected_volume_unit,
	ADD COLUMN `qcroc_drawn_prior_to_chemo_desc` varchar(250) DEFAULT '' AFTER qcroc_drawn_prior_to_chemo;
ALTER TABLE sd_spe_bloods_revs
	ADD COLUMN `qcroc_drawn_prior_to_chemo` char(1) DEFAULT '' AFTER collected_volume_unit,
	ADD COLUMN `qcroc_drawn_prior_to_chemo_desc` varchar(250) DEFAULT '' AFTER qcroc_drawn_prior_to_chemo;	
	
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'SampleDetail', '', 'qcroc_drawn_prior_to_chemo', 'yes_no',  NULL , '0', '', '', '', 'drawn prior to chemo', ''), 
('InventoryManagement', 'SampleDetail', '', 'qcroc_drawn_prior_to_chemo_desc', 'input',  NULL , '0', 'size=30', '', '', '', 'prior to chemo specify');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='sd_spe_bloods'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='' AND `field`='qcroc_drawn_prior_to_chemo' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='drawn prior to chemo' AND `language_tag`=''), '1', '335', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='sd_spe_bloods'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='' AND `field`='qcroc_drawn_prior_to_chemo_desc' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='prior to chemo specify'), '1', '336', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO i18n (id,en) VALUES ('drawn prior to chemo','Drawn Prior to Chemo'),('prior to chemo specify','Specify');

 	YesNo prior to chemo specify


-- -------------------------------------------------------------------------------------------
-- ADMINISTRATION
-- -------------------------------------------------------------------------------------------

SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'specimen collection sites');
INSERT INTO structure_permissible_values_customs (control_id, value, display_order, use_as_input, created, created_by, modified, modified_by, deleted) VALUES 
(@control_id, 'CHUS', 1, 1, NOW(), 1, NOW(), 1, 0),
(@control_id, 'CHUM-HDM', 2, 1, NOW(), 1, NOW(), 1, 0),
(@control_id, 'CHUM-HND', 3, 1, NOW(), 1, NOW(), 1, 0),
(@control_id, 'CHUM-HSL', 4, 1, NOW(), 1, NOW(), 1, 0),
(@control_id, 'CHUQ-CHUL', 5, 1, NOW(), 1, NOW(), 1, 0),
(@control_id, 'CHUQ-HDQ', 6, 1, NOW(), 1, NOW(), 1, 0),
(@control_id, 'CHUQ-HSFA', 7, 1, NOW(), 1, NOW(), 1, 0),
(@control_id, 'HSCM', 8, 1, NOW(), 1, NOW(), 1, 0),
(@control_id, 'HSS', 9, 1, NOW(), 1, NOW(), 1, 0),
(@control_id, 'McGill-HSM', 10, 1, NOW(), 1, NOW(), 1, 0),
(@control_id, 'McGill-JGH', 11, 1, NOW(), 1, NOW(), 1, 0),
(@control_id, 'McGill-MGH', 12, 1, NOW(), 1, NOW(), 1, 0),
(@control_id, 'McGill-RVH', 13, 1, NOW(), 1, NOW(), 1, 0);
INSERT INTO structure_permissible_values_customs_revs (id, control_id, value, display_order, use_as_input, modified_by, version_created)
(SELECT id, control_id, value, display_order, use_as_input, modified_by, modified FROM structure_permissible_values_customs WHERE control_id = @control_id);

-- -------------------------------------------------------------------------------------------
-- SOP
-- -------------------------------------------------------------------------------------------

-- SOP

UPDATE sop_controls SET flag_active = '0';
INSERT INTO `sop_controls` (`id`, `sop_group`, `type`, `detail_tablename`, `detail_form_alias`, `extend_tablename`, `extend_form_alias`, `display_order`, `created`, `created_by`, `modified`, `modified_by`, `flag_active`) VALUES
(null, 'Q-CROC', 'all', 'sopd_general_alls', '', '', '', 0, NULL, 0, NULL, 0, 1);
SET @control_id = LAST_INSERT_ID();
INSERT INTO `sop_masters` (`code`, `sop_control_id`, `modified`, `created`, `created_by`, `modified_by`) 
VALUES 
('SOP-TR-001', @control_id, NOW(), NOW(), 1, 1),
('SOP-TR-002', @control_id, NOW(), NOW(), 1, 1),
('SOP-TR-003', @control_id, NOW(), NOW(), 1, 1),
('SOP-TR-004', @control_id, NOW(), NOW(), 1, 1),
('SOP-TR-005', @control_id, NOW(), NOW(), 1, 1),
('SOP-TR-006', @control_id, NOW(), NOW(), 1, 1),
('SOP-TR-011', @control_id, NOW(), NOW(), 1, 1);
INSERT INTO `sop_masters_revs` (`code`, `sop_control_id`, `modified_by`, `id`, `version_created`) 
(SELECT `code`, `sop_control_id`, `modified_by`, `id`, `modified` FROM sop_masters);
INSERT INTO `sopd_general_alls` (`sop_master_id`) (SELECT `id` FROM sop_masters);
INSERT INTO `sopd_general_alls_revs` (`sop_master_id`, `version_created`) (SELECT `id`, `modified` FROM sop_masters);

UPDATE structure_formats SET flag_add= '0', flag_add_readonly= '0', flag_edit= '0', flag_edit_readonly= '0', flag_search= '0', flag_search_readonly= '0', flag_addgrid= '0', flag_addgrid_readonly= '0', flag_editgrid= '0', flag_editgrid_readonly= '0', flag_batchedit= '0', flag_batchedit_readonly= '0', flag_index= '0', flag_detail= '0', flag_summary= '0'
WHERE structure_id IN (SELECT id FROM structures WHERE alias = 'sopmasters') 
AND structure_field_id NOT IN (SELECT id FROM structure_fields WHERE model = 'SopMaster' AND field IN ('code','version','activated_date','notes'));

-- other

UPDATE menus SET flag_active = 0 WHERE use_link LIKE '/Protocol/%';
UPDATE menus SET flag_active = 0 WHERE use_link LIKE '/Drug/%';

-- datanart

UPDATE datamart_browsing_controls SET flag_active_1_to_2 = 0, flag_active_2_to_1 = 0 
WHERE id1 IN (SELECT id FROM datamart_structures WHERE model IN ('ReproductiveHistory','ParticipantContact','EventMaster','FamilyHistory','TreatmentMaster','DiagnosisMaster','ConsentMaster','MiscIdentifier'))
OR id2 IN (SELECT id FROM datamart_structures WHERE model IN ('ReproductiveHistory','ParticipantContact','EventMaster','FamilyHistory','TreatmentMaster','DiagnosisMaster','ConsentMaster','MiscIdentifier'));



