-- CCBR Customization Script
-- Version: v.03
-- ATiM Version: v2.4.0

REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('core_installname', 'Child and Family Research Institute - CCBR v0.3', ''); 

-- =============================================================================== -- 
-- 								CORE
-- =============================================================================== -- 

-- Disable CAP Reports (moved for v2.4)
UPDATE `event_controls` SET `flag_active`=0 WHERE `event_type`='cap report - small intestine';
UPDATE `event_controls` SET `flag_active`=0 WHERE `event_type`='cap report - perihilar bile duct';
UPDATE `event_controls` SET `flag_active`=0 WHERE `event_type`='cap report - pancreas exo';
UPDATE `event_controls` SET `flag_active`=0 WHERE `event_type`='cap report - pancreas endo';
UPDATE `event_controls` SET `flag_active`=0 WHERE `event_type`='cap report - intrahep bile duct';
UPDATE `event_controls` SET `flag_active`=0 WHERE `event_type`='cap report - hepato cellular carcinoma';
UPDATE `event_controls` SET `flag_active`=0 WHERE `event_type`='cap report - gallbladders';
UPDATE `event_controls` SET `flag_active`=0 WHERE `event_type`='cap report - distal ex bile duct';
UPDATE `event_controls` SET `flag_active`=0 WHERE `event_type`='cap report - colon/rectum - excisional biopsy';
UPDATE `event_controls` SET `flag_active`=0 WHERE `event_type`='cap report - ampulla of vater';
UPDATE `event_controls` SET `flag_active`=0 WHERE `event_type`='cap report - colon/rectum resection';

-- =============================================================================== -- 
-- 								CONSENT
-- =============================================================================== -- 

-- Fix consent table auto increment and FK
ALTER TABLE `cd_ccbr_consents` CHANGE COLUMN `id` `id` INT(11) NOT NULL AUTO_INCREMENT  ;
ALTER TABLE `cd_ccbr_consents` CHANGE COLUMN `consent_master_id` `consent_master_id` INT(11) NOT NULL  ;


-- =============================================================================== -- 
-- 								STORAGE
-- =============================================================================== -- 
/*
-- Create New Storage Entities
INSERT INTO `storage_controls` (`id`, `storage_type`, `storage_type_code`, `coord_x_title`, `coord_x_type`, `coord_x_size`, `coord_y_title`, `coord_y_type`, `coord_y_size`, `display_x_size`, `display_y_size`, `reverse_x_numbering`, `reverse_y_numbering`, `horizontal_increment`, `set_temperature`, `is_tma_block`, `flag_active`, `form_alias`, `detail_tablename`, `databrowser_label`, `check_conficts`) VALUES
(null, 'box100', 'B100', 'position', 'integer', 100, NULL, NULL, NULL, 10, 10, 0, 0, 1, 'FALSE', 'FALSE', 1, 'std_undetail_stg_with_surr_tmp', 'std_boxs', 'box100', 1);

INSERT INTO `storage_controls` (`id`, `storage_type`, `storage_type_code`, `coord_x_title`, `coord_x_type`, `coord_x_size`, `coord_y_title`, `coord_y_type`, `coord_y_size`, `display_x_size`, `display_y_size`, `reverse_x_numbering`, `reverse_y_numbering`, `horizontal_increment`, `set_temperature`, `is_tma_block`, `flag_active`, `form_alias`, `detail_tablename`, `databrowser_label`, `check_conficts`) VALUES
(null, 'rack15', 'R15', 'position', 'integer', 15, NULL, NULL, NULL, 1, 15, 0, 0, 1, 'FALSE', 'FALSE', 1, 'std_undetail_stg_with_surr_tmp', 'std_racks', 'rack15', 1);

INSERT INTO `storage_controls` (`id`, `storage_type`, `storage_type_code`, `coord_x_title`, `coord_x_type`, `coord_x_size`, `coord_y_title`, `coord_y_type`, `coord_y_size`, `display_x_size`, `display_y_size`, `reverse_x_numbering`, `reverse_y_numbering`, `horizontal_increment`, `set_temperature`, `is_tma_block`, `flag_active`, `form_alias`, `detail_tablename`, `databrowser_label`, `check_conficts`) VALUES
(null, 'nitrogen locator & quarters', 'NL+Q',  'quarter', 'integer', 4, NULL, NULL, NULL, 2, 2, 0, 0, 1, 'TRUE', 'FALSE', 1, 'std_undetail_stg_with_tmp', 'std_nitro_locates', 'nitrogen locator & quarters', 1);

UPDATE `storage_controls` SET `flag_active`=0 WHERE `id`='1';
UPDATE `storage_controls` SET `flag_active`=0 WHERE `id`='2';
UPDATE `storage_controls` SET `flag_active`=0 WHERE `id`='3';
UPDATE `storage_controls` SET `flag_active`=0 WHERE `id`='4';
UPDATE `storage_controls` SET `flag_active`=0 WHERE `id`='5';
UPDATE `storage_controls` SET `flag_active`=0 WHERE `id`='6';
UPDATE `storage_controls` SET `flag_active`=0 WHERE `id`='8';
UPDATE `storage_controls` SET `flag_active`=0 WHERE `id`='9';
UPDATE `storage_controls` SET `flag_active`=0 WHERE `id`='10';
UPDATE `storage_controls` SET `flag_active`=0 WHERE `id`='11';
UPDATE `storage_controls` SET `flag_active`=0 WHERE `id`='12';
UPDATE `storage_controls` SET `flag_active`=0 WHERE `id`='13';
UPDATE `storage_controls` SET `flag_active`=0 WHERE `id`='14';
UPDATE `storage_controls` SET `flag_active`=0 WHERE `id`='15';
UPDATE `storage_controls` SET `flag_active`=0 WHERE `id`='16';
UPDATE `storage_controls` SET `flag_active`=0 WHERE `id`='17';
UPDATE `storage_controls` SET `flag_active`=0 WHERE `id`='18';
UPDATE `storage_controls` SET `flag_active`=0 WHERE `id`='19';
UPDATE `storage_controls` SET `flag_active`=0 WHERE `id`='20';
*/

-- =============================================================================== -- 
-- 								PROFILE
-- =============================================================================== -- 

-- Drop Autopsy Code Validation from previous version
DELETE FROM `structure_validations` 
WHERE `structure_field_id` = (SELECT `id` FROM `structure_fields` WHERE plugin = 'Clinicalannotation' AND model = 'Participant' AND tablename = 'participants' AND field = 'ccbr_autopsy_code');

-- Set age at death to readonly for EDIT view
UPDATE structure_formats SET `flag_edit`='1', `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='ccbr_age_at_death' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'); 
	
-- =============================================================================== -- 
-- 								FAMILY HISTORY
-- =============================================================================== -- 

UPDATE structure_fields SET `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='ctrnet_submission_disease_site')  WHERE model='FamilyHistory' AND tablename='family_histories' AND field='ccbr_disease_site' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='event_disease_site_list');

-- =============================================================================== -- 
-- 								REPRODUCTIVE HISTORY
-- =============================================================================== -- 

-- Reproductive History
REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
('ccbr ever preg', 'Ever Pregnant', ''),
('ccbr current preg', 'Currently Pregnant', ''); 

-- Diable fields
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='reproductivehistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ReproductiveHistory' AND `tablename`='reproductive_histories' AND `field`='age_at_menopause_precision' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='age_accuracy') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='reproductivehistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ReproductiveHistory' AND `tablename`='reproductive_histories' AND `field`='hysterectomy_age_precision' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='age_accuracy') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='reproductivehistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ReproductiveHistory' AND `tablename`='reproductive_histories' AND `field`='menopause_status' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='menopause_status') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='reproductivehistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ReproductiveHistory' AND `tablename`='reproductive_histories' AND `field`='age_at_menopause' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='reproductivehistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ReproductiveHistory' AND `tablename`='reproductive_histories' AND `field`='hysterectomy_age' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='reproductivehistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ReproductiveHistory' AND `tablename`='reproductive_histories' AND `field`='hysterectomy' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='indicator') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='reproductivehistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ReproductiveHistory' AND `tablename`='reproductive_histories' AND `field`='ovary_removed_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ovary_removed_type') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='reproductivehistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ReproductiveHistory' AND `tablename`='reproductive_histories' AND `field`='menopause_onset_reason' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='menopause_reason') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='reproductivehistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ReproductiveHistory' AND `tablename`='reproductive_histories' AND `field`='hrt_use' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='indicator') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='reproductivehistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ReproductiveHistory' AND `tablename`='reproductive_histories' AND `field`='hrt_years_used' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='hrt_years_used') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='reproductivehistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ReproductiveHistory' AND `tablename`='reproductive_histories' AND `field`='age_at_menarche_precision' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='age_accuracy') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='reproductivehistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ReproductiveHistory' AND `tablename`='reproductive_histories' AND `field`='age_at_last_parturition_precision' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='age_accuracy') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='reproductivehistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ReproductiveHistory' AND `tablename`='reproductive_histories' AND `field`='gravida' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='reproductivehistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ReproductiveHistory' AND `tablename`='reproductive_histories' AND `field`='para' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='reproductivehistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ReproductiveHistory' AND `tablename`='reproductive_histories' AND `field`='age_at_first_parturition' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='reproductivehistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ReproductiveHistory' AND `tablename`='reproductive_histories' AND `field`='age_at_last_parturition' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='reproductivehistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ReproductiveHistory' AND `tablename`='reproductive_histories' AND `field`='age_at_menarche' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='reproductivehistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ReproductiveHistory' AND `tablename`='reproductive_histories' AND `field`='years_on_hormonal_contraceptives' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='reproductivehistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ReproductiveHistory' AND `tablename`='reproductive_histories' AND `field`='age_at_first_parturition_precision' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='age_accuracy') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='reproductivehistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ReproductiveHistory' AND `tablename`='reproductive_histories' AND `field`='hormonal_contraceptive_use' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='indicator') AND `flag_confidential`='0');

-- New fields
ALTER TABLE `reproductive_histories`
	ADD COLUMN `ccbr_ever_preg` VARCHAR(45) NULL AFTER `lnmp_date_accuracy` ,
	ADD COLUMN `ccbr_current_preg` VARCHAR(45) NULL  AFTER `ccbr_ever_preg` ;
	
ALTER TABLE `reproductive_histories_revs`
	ADD COLUMN `ccbr_ever_preg` VARCHAR(45) NULL AFTER `lnmp_date_accuracy` ,
	ADD COLUMN `ccbr_current_preg` VARCHAR(45) NULL  AFTER `ccbr_ever_preg` ;

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'ReproductiveHistory', 'reproductive_histories', 'ccbr_ever_preg', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='yesno') , '0', '', '', '', 'ccbr ever preg', ''), 
('Clinicalannotation', 'ReproductiveHistory', 'reproductive_histories', 'ccbr_current_preg', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='yesno') , '0', '', '', '', 'ccbr current preg', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='reproductivehistories'), (SELECT id FROM structure_fields WHERE `model`='ReproductiveHistory' AND `tablename`='reproductive_histories' AND `field`='ccbr_ever_preg' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yesno')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ccbr ever preg' AND `language_tag`=''), '1', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='reproductivehistories'), (SELECT id FROM structure_fields WHERE `model`='ReproductiveHistory' AND `tablename`='reproductive_histories' AND `field`='ccbr_current_preg' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yesno')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ccbr current preg' AND `language_tag`=''), '1', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0');

UPDATE structure_formats SET `display_column`='2' WHERE structure_id=(SELECT id FROM structures WHERE alias='txd_chemos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_chemos' AND `field`='ccbr_inthrathecal_therapy' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ccbr_yesnounknown') AND `flag_confidential`='0');

UPDATE structure_formats SET `display_column`='2', `display_order`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='txd_chemos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_chemos' AND `field`='ccbr_inthrathecal_therapy' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ccbr_yesnounknown') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='2', `display_order`='2' WHERE structure_id=(SELECT id FROM structures WHERE alias='txd_chemos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_chemos' AND `field`='ccbr_l_asparagine' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ccbr_yesnounknown') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='2', `display_order`='10' WHERE structure_id=(SELECT id FROM structures WHERE alias='txd_chemos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_chemos' AND `field`='ccbr_day8_bone_marrow_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='2', `display_order`='11' WHERE structure_id=(SELECT id FROM structures WHERE alias='txd_chemos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_chemos' AND `field`='ccbr_day8_percent_blasts' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='2', `display_order`='12' WHERE structure_id=(SELECT id FROM structures WHERE alias='txd_chemos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_chemos' AND `field`='ccbr_day8_mrd' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='20' WHERE structure_id=(SELECT id FROM structures WHERE alias='txd_chemos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_chemos' AND `field`='ccbr_date_induction_chemo' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='2', `display_order`='13' WHERE structure_id=(SELECT id FROM structures WHERE alias='txd_chemos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_chemos' AND `field`='ccbr_day15_bone_marrow_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='2', `display_order`='14' WHERE structure_id=(SELECT id FROM structures WHERE alias='txd_chemos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_chemos' AND `field`='ccbr_day15_percent_blasts' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='2', `display_order`='15' WHERE structure_id=(SELECT id FROM structures WHERE alias='txd_chemos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_chemos' AND `field`='ccbr_day15_mrd' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='2', `display_order`='16' WHERE structure_id=(SELECT id FROM structures WHERE alias='txd_chemos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_chemos' AND `field`='ccbr_day29_bone_marrow_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='2', `display_order`='17' WHERE structure_id=(SELECT id FROM structures WHERE alias='txd_chemos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_chemos' AND `field`='ccbr_day29_percent_blasts' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='2', `display_order`='18' WHERE structure_id=(SELECT id FROM structures WHERE alias='txd_chemos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_chemos' AND `field`='ccbr_day29_mrd' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='2', `display_order`='19' WHERE structure_id=(SELECT id FROM structures WHERE alias='txd_chemos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_chemos' AND `field`='ccbr_other_bone_marrow_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='2', `display_order`='20' WHERE structure_id=(SELECT id FROM structures WHERE alias='txd_chemos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_chemos' AND `field`='ccbr_other_percent_blasts' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='2', `display_order`='21' WHERE structure_id=(SELECT id FROM structures WHERE alias='txd_chemos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_chemos' AND `field`='ccbr_other_mrd' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- =============================================================================== -- 
-- 								ANNOTATION UPDATE
-- =============================================================================== --

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
('ccbr wbc count', 'WBC Count (x10^9 /L)', ''),
('ccbr platelet count', 'Platelet Count (x10^9 /L)', ''),
('ccbr neutrophil count', 'Neutrophil Count (x10^9 /L)', ''),
('ccbr percent blast cells', '% Blast Cells', '');

-- Cytogenetics
REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
('ccbr additions and deletions', 'Additions and Deletions', '');

UPDATE structure_formats SET `language_heading`='ccbr additions and deletions' WHERE structure_id=(SELECT id FROM structures WHERE alias='ed_ccbr_lab_cytogenetics') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_ccbr_lab_cytogenetics' AND `field`='ccbr_+x' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='6' WHERE structure_id=(SELECT id FROM structures WHERE alias='ed_ccbr_lab_cytogenetics') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_ccbr_lab_cytogenetics' AND `field`='ccbr_+11q23' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='7' WHERE structure_id=(SELECT id FROM structures WHERE alias='ed_ccbr_lab_cytogenetics') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_ccbr_lab_cytogenetics' AND `field`='ccbr_+17' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='8' WHERE structure_id=(SELECT id FROM structures WHERE alias='ed_ccbr_lab_cytogenetics') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_ccbr_lab_cytogenetics' AND `field`='ccbr_+18' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='9' WHERE structure_id=(SELECT id FROM structures WHERE alias='ed_ccbr_lab_cytogenetics') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_ccbr_lab_cytogenetics' AND `field`='ccbr_+21' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='2', `display_order`='11' WHERE structure_id=(SELECT id FROM structures WHERE alias='ed_ccbr_lab_cytogenetics') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_ccbr_lab_cytogenetics' AND `field`='ccbr_-5_5q' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='12' WHERE structure_id=(SELECT id FROM structures WHERE alias='ed_ccbr_lab_cytogenetics') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_ccbr_lab_cytogenetics' AND `field`='ccbr_-7' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- CBC and Bone Marrow, move summary to second column
UPDATE structure_formats SET `display_column`='2' WHERE structure_id=(SELECT id FROM structures WHERE alias='ed_ccbr_lab_cbc_bone_marrows') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_summary' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');


-- Table fix for Cytogenetics

DROP TABLE `ed_ccbr_lab_cytogenetics`;
CREATE TABLE `ed_ccbr_lab_cytogenetics` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `ccbr_pos_11q23` VARCHAR(10) NULL ,
  `ccbr_t_4_11` VARCHAR(10) NULL ,
  `ccbr_t_1_19` VARCHAR(10) NULL ,
  `ccbr_t_9_22` VARCHAR(10) NULL ,
  `ccbr_t_12_21` VARCHAR(10) NULL ,
  `ccbr_t_5_14` VARCHAR(10) NULL ,
  `ccbr_pos_x` VARCHAR(10) NULL ,
  `ccbr_pos_4` VARCHAR(10) NULL ,
  `ccbr_pos_10` VARCHAR(10) NULL ,
  `ccbr_pos_17` VARCHAR(10) NULL ,
  `ccbr_pos_21` VARCHAR(10) NULL ,
  `ccbr_pos_5` VARCHAR(10) NULL ,
  `ccbr_pos_18` VARCHAR(10) NULL ,
  `ccbr_t_15_17` VARCHAR(10) NULL ,
  `ccbr_inv_16_t_16_16` VARCHAR(10) NULL ,
  `ccbr_t_8_21` VARCHAR(10) NULL ,
  `ccbr_t_9_11` VARCHAR(10) NULL ,
  `ccbr_t_6_9` VARCHAR(10) NULL ,
  `ccbr_inv_3_t_3_3` VARCHAR(10) NULL ,
  `ccbr_t_1_22` VARCHAR(10) NULL ,
  `ccbr_pos_8` VARCHAR(10) NULL ,
  `ccbr_neg_7` VARCHAR(10) NULL ,
  `ccbr_neg_5_5q` VARCHAR(10) NULL ,
  `ccbr_hypodiploid_less_44` VARCHAR(10) NULL ,
  `ccbr_hyperdiploid_greater_44` VARCHAR(10) NULL ,
  `deleted` TINYINT UNSIGNED NOT NULL DEFAULT 0 ,
  `event_master_id` INT NULL DEFAULT NULL , 
  PRIMARY KEY (`id`) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COLLATE = latin1_swedish_ci;

DROP TABLE `ed_ccbr_lab_cytogenetics_revs`;
CREATE TABLE `ed_ccbr_lab_cytogenetics_revs` (
  `id` INT NOT NULL ,
  `ccbr_pos_11q23` VARCHAR(10) NULL ,
  `ccbr_t_4_11` VARCHAR(10) NULL ,
  `ccbr_t_1_19` VARCHAR(10) NULL ,
  `ccbr_t_9_22` VARCHAR(10) NULL ,
  `ccbr_t_12_21` VARCHAR(10) NULL ,
  `ccbr_t_5_14` VARCHAR(10) NULL ,
  `ccbr_pos_x` VARCHAR(10) NULL ,
  `ccbr_pos_4` VARCHAR(10) NULL ,
  `ccbr_pos_10` VARCHAR(10) NULL ,
  `ccbr_pos_17` VARCHAR(10) NULL ,
  `ccbr_pos_21` VARCHAR(10) NULL ,
  `ccbr_pos_5` VARCHAR(10) NULL ,
  `ccbr_pos_18` VARCHAR(10) NULL ,
  `ccbr_t_15_17` VARCHAR(10) NULL ,
  `ccbr_inv_16_t_16_16` VARCHAR(10) NULL ,
  `ccbr_t_8_21` VARCHAR(10) NULL ,
  `ccbr_t_9_11` VARCHAR(10) NULL ,
  `ccbr_t_6_9` VARCHAR(10) NULL ,
  `ccbr_inv_3_t_3_3` VARCHAR(10) NULL ,
  `ccbr_t_1_22` VARCHAR(10) NULL ,
  `ccbr_pos_8` VARCHAR(10) NULL ,
  `ccbr_neg_7` VARCHAR(10) NULL ,
  `ccbr_neg_5_5q` VARCHAR(10) NULL ,
  `ccbr_hypodiploid_less_44` VARCHAR(10) NULL ,
  `ccbr_hyperdiploid_greater_44` VARCHAR(10) NULL ,
  `event_master_id` INT NULL DEFAULT NULL ,
  `version_id` INT NOT NULL AUTO_INCREMENT ,
  `version_created` DATE NOT NULL ,    
  PRIMARY KEY (`version_id`) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COLLATE = latin1_swedish_ci; 

-- Update fields
UPDATE `structure_fields` SET `field` = 'ccbr_pos_11q23' WHERE `tablename` = 'ed_ccbr_lab_cytogenetics' AND `field` = 'ccbr_+11q23';
UPDATE `structure_fields` SET `field` = 'ccbr_t_4_11' WHERE `tablename` = 'ed_ccbr_lab_cytogenetics' AND `field` = 'ccbr_t(4_11)';
UPDATE `structure_fields` SET `field` = 'ccbr_t_1_19' WHERE `tablename` = 'ed_ccbr_lab_cytogenetics' AND `field` = 'ccbr_t(1_19)';
UPDATE `structure_fields` SET `field` = 'ccbr_t_9_22' WHERE `tablename` = 'ed_ccbr_lab_cytogenetics' AND `field` = 'ccbr_t(9_22)';
UPDATE `structure_fields` SET `field` = 'ccbr_t_12_21' WHERE `tablename` = 'ed_ccbr_lab_cytogenetics' AND `field` = 'ccbr_t(12_21)';
UPDATE `structure_fields` SET `field` = 'ccbr_t_5_14' WHERE `tablename` = 'ed_ccbr_lab_cytogenetics' AND `field` = 'ccbr_t(5_14)';
UPDATE `structure_fields` SET `field` = 'ccbr_pos_x' WHERE `tablename` = 'ed_ccbr_lab_cytogenetics' AND `field` = 'ccbr_+x';
UPDATE `structure_fields` SET `field` = 'ccbr_pos_4' WHERE `tablename` = 'ed_ccbr_lab_cytogenetics' AND `field` = 'ccbr_+4';
UPDATE `structure_fields` SET `field` = 'ccbr_pos_10' WHERE `tablename` = 'ed_ccbr_lab_cytogenetics' AND `field` = 'ccbr_+10';
UPDATE `structure_fields` SET `field` = 'ccbr_pos_17' WHERE `tablename` = 'ed_ccbr_lab_cytogenetics' AND `field` = 'ccbr_+17';
UPDATE `structure_fields` SET `field` = 'ccbr_pos_21' WHERE `tablename` = 'ed_ccbr_lab_cytogenetics' AND `field` = 'ccbr_+21';
UPDATE `structure_fields` SET `field` = 'ccbr_pos_5' WHERE `tablename` = 'ed_ccbr_lab_cytogenetics' AND `field` = 'ccbr_+5';
UPDATE `structure_fields` SET `field` = 'ccbr_pos_18' WHERE `tablename` = 'ed_ccbr_lab_cytogenetics' AND `field` = 'ccbr_+18';
UPDATE `structure_fields` SET `field` = 'ccbr_t_15_17' WHERE `tablename` = 'ed_ccbr_lab_cytogenetics' AND `field` = 'ccbr_t(15_17)';
UPDATE `structure_fields` SET `field` = 'ccbr_inv_16_t_16_16' WHERE `tablename` = 'ed_ccbr_lab_cytogenetics' AND `field` = 'ccbr_inv(16)_t(16_16)';
UPDATE `structure_fields` SET `field` = 'ccbr_t_8_21' WHERE `tablename` = 'ed_ccbr_lab_cytogenetics' AND `field` = 'ccbr_t(8_21)';
UPDATE `structure_fields` SET `field` = 'ccbr_t_9_11' WHERE `tablename` = 'ed_ccbr_lab_cytogenetics' AND `field` = 'ccbr_t(9_11)';
UPDATE `structure_fields` SET `field` = 'ccbr_t_6_9' WHERE `tablename` = 'ed_ccbr_lab_cytogenetics' AND `field` = 'ccbr_t(6_9)';
UPDATE `structure_fields` SET `field` = 'ccbr_inv_3_t_3_3' WHERE `tablename` = 'ed_ccbr_lab_cytogenetics' AND `field` = 'ccbr_inv(3)_t(3_3)';
UPDATE `structure_fields` SET `field` = 'ccbr_t_1_22' WHERE `tablename` = 'ed_ccbr_lab_cytogenetics' AND `field` = 'ccbr_t(1_22)';
UPDATE `structure_fields` SET `field` = 'ccbr_pos_8' WHERE `tablename` = 'ed_ccbr_lab_cytogenetics' AND `field` = 'ccbr_+8';
UPDATE `structure_fields` SET `field` = 'ccbr_neg_7' WHERE `tablename` = 'ed_ccbr_lab_cytogenetics' AND `field` = 'ccbr_-7';
UPDATE `structure_fields` SET `field` = 'ccbr_neg_5_5q' WHERE `tablename` = 'ed_ccbr_lab_cytogenetics' AND `field` = 'ccbr_-5_5q';



UPDATE `structure_fields` SET `field` = '' WHERE `tablename` = 'ed_ccbr_lab_cytogenetics' AND `field` = '';

-- =============================================================================== -- 
-- 								TREATMENT
-- =============================================================================== --

-- Fix transplant translation -> Bone Marrow Transplant
REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
('ccbr rad site', 'Radiation Site', '');

-- Fix control table entry
UPDATE `tx_controls` SET `tx_method`='bone marrow transplant' WHERE `tx_method`='transplant' AND `detail_tablename` ='txd_ccbr_bone_marrow_transplants';

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
('ccbr rad site', 'Radiation Site', ''),
('ccbr rad total dose', 'Total Dose (Gy)', ''),
('ccbr oncologist', 'Oncologist', ''),
('ccbr prophylactic', 'Prophylactic', ''),
('tumour', 'Tumour', ''),
('ccbr unknown', 'Unknown', ''),
('ccbr metastatic site only', 'Metastatic site only', ''),
('ccbr tumour and metastatic site', 'Tumour and metastatic site', '');

-- Radiotherapy Update
ALTER TABLE `txd_radiations`
	ADD COLUMN `ccbr_rad_site` VARCHAR(45) NULL AFTER `rad_completed` ,
	ADD COLUMN `ccbr_rad_total_dose` VARCHAR(45) NULL AFTER `ccbr_rad_site` ;
	
ALTER TABLE `txd_radiations_revs`
	ADD COLUMN `ccbr_rad_site` VARCHAR(45) NULL AFTER `rad_completed` ,
	ADD COLUMN `ccbr_rad_total_dose` VARCHAR(45) NULL AFTER `ccbr_rad_site` ;

-- Value domain for site	
INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('ccbr_treatment_site', '', '', NULL);
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("tumour", "tumour");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="ccbr_treatment_site"),  (SELECT id FROM structure_permissible_values WHERE value="tumour" AND language_alias="tumour"), "1", "1");

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("tumour and metastatic site", "ccbr tumour and metastatic site");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="ccbr_treatment_site"),  (SELECT id FROM structure_permissible_values WHERE value="tumour and metastatic site" AND language_alias="ccbr tumour and metastatic site"), "2", "1");

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("metastatic site only", "ccbr metastatic site only");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="ccbr_treatment_site"),  (SELECT id FROM structure_permissible_values WHERE value="metastatic site only" AND language_alias="ccbr metastatic site only"), "3", "1");

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("unknown", "ccbr unknown");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="ccbr_treatment_site"),  (SELECT id FROM structure_permissible_values WHERE value="unknown" AND language_alias="ccbr unknown"), "4", "1");

-- Add to intent drop down list
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("prophylactic", "ccbr prophylactic");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="intent"),  (SELECT id FROM structure_permissible_values WHERE value="prophylactic" AND language_alias="ccbr prophylactic"), "5", "1");

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("oncologist", "ccbr oncologist");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="information_source"),  (SELECT id FROM structure_permissible_values WHERE value="oncologist" AND language_alias="ccbr oncologist"), "3", "1");

-- Add new fields
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'TreatmentDetail', 'txd_radiations', 'ccbr_rad_site', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ccbr_treatment_site') , '0', '', '', '', 'ccbr rad site', ''), 
('Clinicalannotation', 'TreatmentDetail', 'txd_radiations', 'ccbr_rad_total_dose', 'integer', (SELECT id FROM structure_value_domains WHERE domain_name='ccbr_treatment_site') , '0', '', '', '', 'ccbr rad total dose', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='txd_radiations'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_radiations' AND `field`='ccbr_rad_site' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ccbr_treatment_site')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ccbr rad site' AND `language_tag`=''), '1', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='txd_radiations'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_radiations' AND `field`='ccbr_rad_total_dose' AND `type`='integer' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ccbr_treatment_site')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ccbr rad total dose' AND `language_tag`=''), '1', '11', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0');

-- Surgery

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
('ccbr biopsy', 'Biopsy', ''),
('ccbr limb salvage', 'Limb Salvage', ''),
('ccbr surgery details', 'Surgery Details', ''),
('ccbr partial excision', 'Partial Excision', ''),
('ccbr complete excision', 'Complete Excision', ''),
('ccbr subtotal excision', 'Subtotal Excision', ''),
('ccbr microscopic residual pathology', 'Microscopic Residual Pathology', '');

ALTER TABLE `txd_surgeries`
	ADD COLUMN `ccbr_biopsy` VARCHAR(45) NULL AFTER `primary` ,
	ADD COLUMN `ccbr_surgery_details` VARCHAR(45) NULL AFTER `ccbr_biopsy` ,
	ADD COLUMN `ccbr_limb_salvage` VARCHAR(45) NULL AFTER `ccbr_surgery_details` ;

ALTER TABLE `txd_surgeries_revs`
	ADD COLUMN `ccbr_biopsy` VARCHAR(45) NULL AFTER `primary` ,
	ADD COLUMN `ccbr_surgery_details` VARCHAR(45) NULL AFTER `ccbr_biopsy` ,
	ADD COLUMN `ccbr_limb_salvage` VARCHAR(45) NULL AFTER `ccbr_surgery_details` ;	

-- New fields
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'TreatmentDetail', 'txd_surgeries', 'ccbr_biopsy', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='yesno') , '0', '', '', '', 'ccbr biopsy', ''), 
('Clinicalannotation', 'TreatmentDetail', 'txd_surgeries', 'ccbr_limb_salvage', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='yesno') , '0', '', '', '', 'ccbr limb salvage', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='txd_surgeries'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_surgeries' AND `field`='ccbr_biopsy' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yesno')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ccbr biopsy' AND `language_tag`=''), '1', '11', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='txd_surgeries'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_surgeries' AND `field`='ccbr_limb_salvage' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yesno')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ccbr limb salvage' AND `language_tag`=''), '1', '12', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0');

-- Value Domain for Surgery Details
INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('ccbr_surgery_details', '', '', NULL);
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("partial excision", "ccbr partial excision");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="ccbr_surgery_details"),  (SELECT id FROM structure_permissible_values WHERE value="partial excision" AND language_alias="ccbr partial excision"), "1", "1");

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("complete excision", "ccbr complete excision");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="ccbr_surgery_details"),  (SELECT id FROM structure_permissible_values WHERE value="complete excision" AND language_alias="ccbr complete excision"), "2", "1");

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("subtotal excision", "ccbr subtotal excision");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="ccbr_surgery_details"),  (SELECT id FROM structure_permissible_values WHERE value="subtotal excision" AND language_alias="ccbr subtotal excision"), "3", "1");

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("microscopic residual pathology", "ccbr microscopic residual pathology");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="ccbr_surgery_details"),  (SELECT id FROM structure_permissible_values WHERE value="microscopic residual pathology" AND language_alias="ccbr microscopic residual pathology"), "4", "1");

-- Surgery Details fields
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'TreatmentDetail', 'txd_surgeries', 'ccbr_surgery_details', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ccbr_surgery_details') , '0', '', '', '', 'ccbr surgery details', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='txd_surgeries'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_surgeries' AND `field`='ccbr_surgery_details' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ccbr_surgery_details')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ccbr surgery details' AND `language_tag`=''), '1', '13', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0');


-- Bone Marrow Updates (See Word Doc)

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
('ccbr donor source', 'Donor Source', ''),
('ccbr tissue type', 'Tissue Type', ''),
('ccbr allogeneic', 'Allogeneic', ''),
('ccbr autologous', 'Autologous', ''),
('ccbr match related', 'Match Related', ''),
('ccbr match unrelated', 'Match Unrelated', ''),
('ccbr mismatch related', 'Mismatch Related', ''),
('ccbr mismatch unrelated', 'Mismatch Unrelated', ''),
('ccbr peripheral blood', 'Peripheral Blood', ''),
('ccbr bone marrow', 'Bone Marrow', ''),
('ccbr date of transplant', 'Date of Transplant', ''),
('ccbr cord', 'Cord', '');

ALTER TABLE `txd_ccbr_transplants` RENAME TO `txd_ccbr_bone_marrow_transplants` ;
ALTER TABLE `txd_ccbr_transplants_revs` RENAME TO `txd_ccbr_bone_marrow_transplants_revs` ;

ALTER TABLE `txd_ccbr_bone_marrow_transplants` 
	DROP COLUMN `ccbr_gvhd_status` ,
	CHANGE COLUMN `ccbr_patient_typing` `ccbr_donor_source` VARCHAR(50) NULL DEFAULT NULL  ,
	CHANGE COLUMN `ccbr_donor_mismatch` `ccbr_tissue_type` VARCHAR(50) NULL DEFAULT NULL  ;

-- Delete fields 'Patient Typing', 'Donor Mismatch', 'GVHD Status'
DELETE FROM `structure_formats` WHERE structure_id=(SELECT id FROM structures WHERE alias='txd_ccbr_bone_marrow_transplants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Clinicalannotation' AND `model`='TreatmentDetail' AND `tablename`='txd_ccbr_bone_marrow_transplants' AND `field`='ccbr_patient_typing' AND `language_label`='ccbr patient typing' AND `language_tag`='' AND `type`='input' AND `setting`='size=30' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM `structure_formats` WHERE structure_id=(SELECT id FROM structures WHERE alias='txd_ccbr_bone_marrow_transplants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Clinicalannotation' AND `model`='TreatmentDetail' AND `tablename`='txd_ccbr_bone_marrow_transplants' AND `field`='ccbr_donor_mismatch' AND `language_label`='ccbr donor mismatch' AND `language_tag`='' AND `type`='input' AND `setting`='size=30' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM `structure_formats` WHERE structure_id=(SELECT id FROM structures WHERE alias='txd_ccbr_bone_marrow_transplants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Clinicalannotation' AND `model`='TreatmentDetail' AND `tablename`='txd_ccbr_bone_marrow_transplants' AND `field`='ccbr_gvhd_status' AND `language_label`='ccbr gvhd status' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='ccbr_gvhd_status') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');

DELETE FROM `structure_fields` WHERE `public_identifier`='' AND `plugin`='Clinicalannotation' AND `model`='TreatmentDetail' AND `tablename`='txd_ccbr_bone_marrow_transplants' AND `field`='ccbr_patient_typing';
DELETE FROM `structure_fields` WHERE `public_identifier`='' AND `plugin`='Clinicalannotation' AND `model`='TreatmentDetail' AND `tablename`='txd_ccbr_bone_marrow_transplants' AND `field`='ccbr_donor_mismatch';
DELETE FROM `structure_fields` WHERE `public_identifier`='' AND `plugin`='Clinicalannotation' AND `model`='TreatmentDetail' AND `tablename`='txd_ccbr_bone_marrow_transplants' AND `field`='ccbr_gvhd_status';

-- New Value Domain: Donor Source
INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('ccbr_donor_source', '', '', NULL);
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("peripheral blood", "ccbr peripheral blood");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="ccbr_donor_source"),  (SELECT id FROM structure_permissible_values WHERE value="peripheral blood" AND language_alias="ccbr peripheral blood"), "1", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("bone marrow", "ccbr bone marrow");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="ccbr_donor_source"),  (SELECT id FROM structure_permissible_values WHERE value="bone marrow" AND language_alias="ccbr bone marrow"), "2", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("cord", "ccbr cord");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="ccbr_donor_source"),  (SELECT id FROM structure_permissible_values WHERE value="cord" AND language_alias="ccbr cord"), "3", "1");

-- New Value Domain: Tissue Type
INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('ccbr_tissue_type', '', '', NULL);
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("match related", "ccbr match related");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="ccbr_tissue_type"),  (SELECT id FROM structure_permissible_values WHERE value="match related" AND language_alias="ccbr match related"), "1", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("mismatch related", "ccbr mismatch related");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="ccbr_tissue_type"),  (SELECT id FROM structure_permissible_values WHERE value="mismatch related" AND language_alias="ccbr mismatch related"), "3", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("mismatch unrelated", "ccbr mismatch unrelated");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="ccbr_tissue_type"),  (SELECT id FROM structure_permissible_values WHERE value="mismatch unrelated" AND language_alias="ccbr mismatch unrelated"), "4", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("match unrelated", "ccbr match unrelated");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="ccbr_tissue_type"),  (SELECT id FROM structure_permissible_values WHERE value="match unrelated" AND language_alias="ccbr match unrelated"), "2", "1");

-- New Value Domain: Type of Transplant (Remove old permissible values first)
DELETE FROM `structure_value_domains_permissible_values` WHERE `structure_value_domain_id` = (SELECT `id` FROM `structure_value_domains` WHERE `domain_name` = 'ccbr_transplant_type') AND `structure_permissible_value_id` = (SELECT `id` FROM `structure_permissible_values` WHERE `value` = 'donor' AND `language_alias` = 'ccbr donor' );
DELETE FROM `structure_value_domains_permissible_values` WHERE `structure_value_domain_id` = (SELECT `id` FROM `structure_value_domains` WHERE `domain_name` = 'ccbr_transplant_type') AND `structure_permissible_value_id` = (SELECT `id` FROM `structure_permissible_values` WHERE `value` = 'stem cell' AND `language_alias` = 'ccbr stem cell' );
DELETE FROM `structure_value_domains_permissible_values` WHERE `structure_value_domain_id` = (SELECT `id` FROM `structure_value_domains` WHERE `domain_name` = 'ccbr_transplant_type') AND `structure_permissible_value_id` = (SELECT `id` FROM `structure_permissible_values` WHERE `value` = 'allogenic' AND `language_alias` = 'ccbr allogenic' );
DELETE FROM `structure_permissible_values` WHERE `value` = 'donor' AND `language_alias` = 'ccbr donor';
DELETE FROM `structure_permissible_values` WHERE `value` = 'stem cell' AND `language_alias` = 'ccbr stem cell';
DELETE FROM `structure_permissible_values` WHERE `value` = 'allogenic' AND `language_alias` = 'ccbr allogenic';

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("allogeneic", "ccbr allogeneic");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="ccbr_transplant_type"),  (SELECT id FROM structure_permissible_values WHERE value="allogeneic" AND language_alias="ccbr allogeneic"), "1", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("autologous", "ccbr autologous");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="ccbr_transplant_type"),  (SELECT id FROM structure_permissible_values WHERE value="autologous" AND language_alias="ccbr autologous"), "2", "1");

-- Add new fields
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'TreatmentDetail', 'txd_ccbr_bone_marrow_transplants', 'ccbr_donor_source', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ccbr_donor_source') , '0', '', '', '', 'ccbr donor source', ''), 
('Clinicalannotation', 'TreatmentDetail', 'txd_ccbr_bone_marrow_transplants', 'ccbr_tissue_type', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ccbr_tissue_type') , '0', '', '', '', 'ccbr tissue type', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='txd_ccbr_bone_marrow_transplants'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_ccbr_bone_marrow_transplants' AND `field`='ccbr_donor_source' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ccbr_donor_source')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ccbr donor source' AND `language_tag`=''), '1', '11', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='txd_ccbr_bone_marrow_transplants'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_ccbr_bone_marrow_transplants' AND `field`='ccbr_tissue_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ccbr_tissue_type')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ccbr tissue type' AND `language_tag`=''), '1', '12', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0');

-- Fix date fields (hide finish, rename start)
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='txd_ccbr_bone_marrow_transplants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='tx_masters' AND `field`='finish_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE `structure_formats` SET `flag_override_label` = '1', `language_label` = 'ccbr date of transplant' WHERE structure_id = (SELECT id FROM `structures` where alias = 'txd_ccbr_bone_marrow_transplants') AND structure_field_id = (SELECT id FROM `structure_fields` where field = 'start_date' and model = 'TreatmentMaster');

-- Other Treatment
ALTER TABLE `txd_ccbr_other_treatments` 
	ADD COLUMN `ccbr_transfusion_type` VARCHAR(45) NULL AFTER `id` ,
	ADD COLUMN `ccbr_transfusion_frequency` VARCHAR(45) NULL  AFTER `ccbr_transfusion_type` ,
	ADD COLUMN `ccbr_ivig` VARCHAR(45) NULL  AFTER `ccbr_transfusion_frequency` ,
	ADD COLUMN `ccbr_bone_marrow_transplant` VARCHAR(45) NULL  AFTER `ccbr_ivig` ,
	ADD COLUMN `ccbr_hydroxyurea` VARCHAR(45) NULL  AFTER `ccbr_bone_marrow_transplant` ,
	ADD COLUMN `ccbr_growth_factors` VARCHAR(45) NULL  AFTER `ccbr_hydroxyurea` ,
	ADD COLUMN `ccbr_surgery` VARCHAR(45) NULL  AFTER `ccbr_growth_factors` ;
	
ALTER TABLE `txd_ccbr_other_treatments_revs` 
	ADD COLUMN `ccbr_transfusion_type` VARCHAR(45) NULL AFTER `id` ,
	ADD COLUMN `ccbr_transfusion_frequency` VARCHAR(45) NULL  AFTER `ccbr_transfusion_type` ,
	ADD COLUMN `ccbr_ivig` VARCHAR(45) NULL  AFTER `ccbr_transfusion_frequency` ,
	ADD COLUMN `ccbr_bone_marrow_transplant` VARCHAR(45) NULL  AFTER `ccbr_ivig` ,
	ADD COLUMN `ccbr_hydroxyurea` VARCHAR(45) NULL  AFTER `ccbr_bone_marrow_transplant` ,
	ADD COLUMN `ccbr_growth_factors` VARCHAR(45) NULL  AFTER `ccbr_hydroxyurea` ,
	ADD COLUMN `ccbr_surgery` VARCHAR(45) NULL  AFTER `ccbr_growth_factors` ;

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
('ccbr platelets', 'Platelets', ''),
('ccbr rbc', 'RBC', ''),
('ccbr epo', 'EPO', ''),
('ccbr g-csf', 'G-CSF', ''),
('ccbr na', 'N/A', ''),
('ccbr splenectomy', 'Splenectomy', ''),
('ccbr cholecystectomy', 'Cholecystectomy', ''),
('ccbr other treatment details', 'Other Treatment Details', ''),
('ccbr transfusion type', 'Transfusion Type', ''),
('ccbr transfusion frequency', 'Transfusion Frequency', ''),
('ccbr ivig', 'IVIg', ''),
('ccbr hydroxyurea', 'Hydroxyurea', ''),
('ccbr growth factors', 'Growth Factors', ''),
('ccbr surgery', 'Surgery', '');

-- New Value Domains
INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('ccbr_transfusion_type', '', '', NULL);
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("platelets", "ccbr platelets");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="ccbr_transfusion_type"),  (SELECT id FROM structure_permissible_values WHERE value="platelets" AND language_alias="ccbr platelets"), "1", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("rbc", "ccbr rbc");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="ccbr_transfusion_type"),  (SELECT id FROM structure_permissible_values WHERE value="rbc" AND language_alias="ccbr rbc"), "2", "1");

INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('ccbr_growth_factors', '', '', NULL);
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("epo", "ccbr epo");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="ccbr_growth_factors"),  (SELECT id FROM structure_permissible_values WHERE value="epo" AND language_alias="ccbr epo"), "1", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("g-csf", "ccbr g-csf");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="ccbr_growth_factors"),  (SELECT id FROM structure_permissible_values WHERE value="g-csf" AND language_alias="ccbr g-csf"), "2", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("na", "ccbr na");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="ccbr_growth_factors"),  (SELECT id FROM structure_permissible_values WHERE value="na" AND language_alias="ccbr na"), "3", "1");

INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('ccbr_surgery', '', '', NULL);
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("splenectomy", "ccbr splenectomy");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="ccbr_surgery"),  (SELECT id FROM structure_permissible_values WHERE value="splenectomy" AND language_alias="ccbr splenectomy"), "1", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("cholecystectomy", "ccbr cholecystectomy");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="ccbr_surgery"),  (SELECT id FROM structure_permissible_values WHERE value="cholecystectomy" AND language_alias="ccbr cholecystectomy"), "2", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("na", "ccbr na");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="ccbr_surgery"),  (SELECT id FROM structure_permissible_values WHERE value="na" AND language_alias="ccbr na"), "3", "1");

-- New fields
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'TreatmentDetail', 'txd_ccbr_other_treatments', 'ccbr_transfusion_type', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ccbr_transfusion_type') , '0', '', '', '', 'ccbr transfusion type', ''), 
('Clinicalannotation', 'TreatmentDetail', 'txd_ccbr_other_treatments', 'ccbr_transfusion_frequency', 'input',  NULL , '0', 'size=20', '', '', 'ccbr transfusion frequency', ''), 
('Clinicalannotation', 'TreatmentDetail', 'txd_ccbr_other_treatments', 'ccbr_ivig', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ccbr_yesnounknown') , '0', '', '', '', 'ccbr ivig', ''), 
('Clinicalannotation', 'TreatmentDetail', 'txd_ccbr_other_treatments', 'ccbr_bone_marrow_transplant', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ccbr_yesnounknown') , '0', '', '', '', 'ccbr bone marrow transplant', ''), 
('Clinicalannotation', 'TreatmentDetail', 'txd_ccbr_other_treatments', 'ccbr_hydroxyurea', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ccbr_yesnounknown') , '0', '', '', '', 'ccbr hydroxyurea', ''), 
('Clinicalannotation', 'TreatmentDetail', 'txd_ccbr_other_treatments', 'ccbr_growth_factors', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ccbr_growth_factors') , '0', '', '', '', 'ccbr growth factors', ''), 
('Clinicalannotation', 'TreatmentDetail', 'txd_ccbr_other_treatments', 'ccbr_surgery', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ccbr_surgery') , '0', '', '', '', 'ccbr surgery', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='txd_ccbr_other_treatments'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_ccbr_other_treatments' AND `field`='ccbr_transfusion_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ccbr_transfusion_type')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ccbr transfusion type' AND `language_tag`=''), '1', '10', 'ccbr other treatment details', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='txd_ccbr_other_treatments'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_ccbr_other_treatments' AND `field`='ccbr_transfusion_frequency' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=20' AND `default`='' AND `language_help`='' AND `language_label`='ccbr transfusion frequency' AND `language_tag`=''), '1', '11', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='txd_ccbr_other_treatments'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_ccbr_other_treatments' AND `field`='ccbr_ivig' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ccbr_yesnounknown')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ccbr ivig' AND `language_tag`=''), '1', '12', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='txd_ccbr_other_treatments'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_ccbr_other_treatments' AND `field`='ccbr_bone_marrow_transplant' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ccbr_yesnounknown')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ccbr bone marrow transplant' AND `language_tag`=''), '1', '13', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='txd_ccbr_other_treatments'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_ccbr_other_treatments' AND `field`='ccbr_hydroxyurea' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ccbr_yesnounknown')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ccbr hydroxyurea' AND `language_tag`=''), '1', '14', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='txd_ccbr_other_treatments'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_ccbr_other_treatments' AND `field`='ccbr_growth_factors' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ccbr_growth_factors')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ccbr growth factors' AND `language_tag`=''), '1', '15', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='txd_ccbr_other_treatments'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_ccbr_other_treatments' AND `field`='ccbr_surgery' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ccbr_surgery')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ccbr surgery' AND `language_tag`=''), '1', '16', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0');


-- =============================================================================== -- 
-- 								DIAGNOSIS
-- =============================================================================== --

-- Flush all old CAP reports

DELETE FROM `diagnosis_controls` WHERE `controls_type` LIKE ('%cap report%');

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
('benign blood disorder', 'Benign blood disorder', ''),
('leukemia', 'Leukemia', ''),
('ccbr low', 'Low', ''),
('ccbr average', 'Average', ''),
('ccbr high', 'High', ''),
('ccbr very high', 'Very high', ''),
('solid tumour', 'Solid tumour', ''),
('ccbr blood disorder', 'Blood Disorder', ''),
('ccbr other blood disorder', 'If other, specify', ''),
('ccbr itp', 'ITP', ''),
('ccbr cytopenia', 'Cytopenia', ''),
('ccbr neutropenia', 'Neutropenia', ''),
('ccbr aplastic anemia', 'Aplastic anemia', ''),
('ccbr fancomi', 'Fancomi', ''),
('ccbr sickle cell anemia', 'Sickle cell anemia', ''),
('ccbr age at dx months', 'Months', ''),
('ccbr age at dx weeks', 'Weeks', ''),
('ccbr age at dx days', 'Days', ''),
('ccbr age at dx years', 'Years', ''),
('ccbr risk group', 'Risk Group', '');

-- Disable Blood/Tissue primary forms
UPDATE `diagnosis_controls` SET `flag_active`=0 WHERE `controls_type` = 'blood' AND `form_alias` = 'diagnosismasters,dx_primary,dx_bloods' ;
UPDATE `diagnosis_controls` SET `flag_active`=0 WHERE `controls_type` = 'tissue' AND `form_alias` = 'diagnosismasters,dx_primary,dx_tissues';

-- New Primary Forms
INSERT INTO `diagnosis_controls` (`category`, `controls_type`, `flag_active`, `form_alias`, `detail_tablename`, `display_order`, `databrowser_label`) VALUES
('primary', 'benign blood disorder', 1, 'diagnosismasters,dx_primary,dx_ccbr_benign_blood', 'dxd_ccbr_benign_blood', 0, 'primary|benign'),
('primary', 'lymphoma', 1, 'diagnosismasters,dx_primary,dx_ccbr_lymphoma', 'dxd_ccbr_lymphoma', 0, 'primary|lymphoma'),
('primary', 'leukemia', 1, 'diagnosismasters,dx_primary,dx_ccbr_leukemia', 'dxd_ccbr_leukemia', 0, 'primary|leukemia'),
('primary', 'solid tumour', 1, 'diagnosismasters,dx_primary,dx_ccbr_solid_tumour', 'dxd_ccbr_solid_tumour', 0, 'primary|solid tumour');

-- Detail tables
CREATE TABLE `dxd_ccbr_benign_blood` (
  `id` INT(11) NOT NULL AUTO_INCREMENT ,
  `ccbr_blood_disorder` VARCHAR(255) ,
  `ccbr_other_blood_disorder` VARCHAR(255) ,
  `diagnosis_master_id` INT NOT NULL DEFAULT 0 ,
  `deleted` INT NOT NULL DEFAULT 0 ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COLLATE = latin1_swedish_ci;

CREATE TABLE `dxd_ccbr_benign_blood_revs` (
  `id` INT(11) UNSIGNED NOT NULL  ,
  `ccbr_blood_disorder` VARCHAR(255) ,
  `ccbr_other_blood_disorder` VARCHAR(255) ,
  `diagnosis_master_id` INT NOT NULL DEFAULT 0 ,
  `deleted` INT NOT NULL DEFAULT 0 ,
  `version_id` INT(11) NOT NULL AUTO_INCREMENT ,
  `version_created` DATETIME NOT NULL ,
  PRIMARY KEY (`version_id`) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COLLATE = latin1_swedish_ci;

CREATE TABLE `dxd_ccbr_lymphoma` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `diagnosis_master_id` INT NOT NULL DEFAULT 0 ,
  `deleted` INT NOT NULL DEFAULT 0 ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COLLATE = latin1_swedish_ci;

CREATE TABLE `dxd_ccbr_lymphoma_revs` (
  `id` INT(11) UNSIGNED NOT NULL  ,
  `diagnosis_master_id` INT NOT NULL DEFAULT 0 ,
  `deleted` INT NOT NULL DEFAULT 0 ,
  `version_id` INT(11) NOT NULL AUTO_INCREMENT ,
  `version_created` DATETIME NOT NULL ,
  PRIMARY KEY (`version_id`) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COLLATE = latin1_swedish_ci;

CREATE TABLE `dxd_ccbr_solid_tumour` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `laterality` VARCHAR(50) NULL ,
  `diagnosis_master_id` INT NOT NULL DEFAULT 0 ,
  `deleted` INT NOT NULL DEFAULT 0 ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COLLATE = latin1_swedish_ci;

CREATE TABLE `dxd_ccbr_solid_tumour_revs` (
  `id` INT(11) UNSIGNED NOT NULL  ,
  `laterality` VARCHAR(50) NULL ,
  `diagnosis_master_id` INT NOT NULL DEFAULT 0 ,
  `deleted` INT NOT NULL DEFAULT 0 ,
  `version_id` INT(11) NOT NULL AUTO_INCREMENT ,
  `version_created` DATETIME NOT NULL ,
  PRIMARY KEY (`version_id`) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COLLATE = latin1_swedish_ci;

CREATE TABLE `dxd_ccbr_leukemia` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `diagnosis_master_id` INT NOT NULL DEFAULT 0 ,
  `deleted` INT NOT NULL DEFAULT 0 ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COLLATE = latin1_swedish_ci;

CREATE TABLE `dxd_ccbr_leukemia_revs` (
  `id` INT(11) UNSIGNED NOT NULL  ,
  `diagnosis_master_id` INT NOT NULL DEFAULT 0 ,
  `deleted` INT NOT NULL DEFAULT 0 ,
  `version_id` INT(11) NOT NULL AUTO_INCREMENT ,
  `version_created` DATETIME NOT NULL ,
  PRIMARY KEY (`version_id`) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COLLATE = latin1_swedish_ci;

-- Add structures
INSERT INTO `structures` (`alias`) VALUES ('dx_ccbr_benign_blood');
INSERT INTO `structures` (`alias`) VALUES ('dx_ccbr_lymphoma');
INSERT INTO `structures` (`alias`) VALUES ('dx_ccbr_solid_tumour');
INSERT INTO `structures` (`alias`) VALUES ('dx_ccbr_leukemia');

-- New Master Fields
ALTER TABLE `diagnosis_masters` 
	ADD COLUMN `ccbr_age_at_dx_months` INT(11) NULL AFTER `age_at_dx` ,
	ADD COLUMN `ccbr_age_at_dx_weeks` INT(11) NULL AFTER `ccbr_age_at_dx_months` ,
	ADD COLUMN `ccbr_age_at_dx_days` INT(11) NULL AFTER `ccbr_age_at_dx_weeks` ,
	ADD COLUMN `ccbr_risk_group` VARCHAR(45) NULL AFTER `ccbr_age_at_dx_days` ;
	
ALTER TABLE `diagnosis_masters_revs` 
	ADD COLUMN `ccbr_age_at_dx_months` INT(11) NULL AFTER `age_at_dx` ,
	ADD COLUMN `ccbr_age_at_dx_weeks` INT(11) NULL AFTER `ccbr_age_at_dx_months` ,
	ADD COLUMN `ccbr_age_at_dx_days` INT(11) NULL AFTER `ccbr_age_at_dx_weeks` ,
	ADD COLUMN `ccbr_risk_group` VARCHAR(45) NULL AFTER `ccbr_age_at_dx_days` ;

-- Value domain for Risk Group	
INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('ccbr_risk_groups', '', '', NULL);
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("low", "ccbr low");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="ccbr_risk_groups"),  (SELECT id FROM structure_permissible_values WHERE value="low" AND language_alias="ccbr low"), "1", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("average", "ccbr average");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="ccbr_risk_groups"),  (SELECT id FROM structure_permissible_values WHERE value="average" AND language_alias="ccbr average"), "2", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("high", "ccbr high");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="ccbr_risk_groups"),  (SELECT id FROM structure_permissible_values WHERE value="high" AND language_alias="ccbr high"), "3", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("very high", "ccbr very high");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="ccbr_risk_groups"),  (SELECT id FROM structure_permissible_values WHERE value="very high" AND language_alias="ccbr very high"), "4", "1");

-- Value domain for Blood Disorders
INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('ccbr_blood_disorders', '', '', NULL);
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("itp", "ccbr itp");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="ccbr_blood_disorders"),  (SELECT id FROM structure_permissible_values WHERE value="itp" AND language_alias="ccbr itp"), "1", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("cytopenia", "ccbr cytopenia");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="ccbr_blood_disorders"),  (SELECT id FROM structure_permissible_values WHERE value="cytopenia" AND language_alias="ccbr cytopenia"), "2", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("neutropenia", "ccbr neutropenia");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="ccbr_blood_disorders"),  (SELECT id FROM structure_permissible_values WHERE value="neutropenia" AND language_alias="ccbr neutropenia"), "3", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("aplastic anemia", "ccbr aplastic anemia");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="ccbr_blood_disorders"),  (SELECT id FROM structure_permissible_values WHERE value="aplastic anemia" AND language_alias="ccbr aplastic anemia"), "4", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("fancomi", "ccbr fancomi");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="ccbr_blood_disorders"),  (SELECT id FROM structure_permissible_values WHERE value="fancomi" AND language_alias="ccbr fancomi"), "5", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("sickle cell anemia", "ccbr sickle cell anemia");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="ccbr_blood_disorders"),  (SELECT id FROM structure_permissible_values WHERE value="sickle cell anemia" AND language_alias="ccbr sickle cell anemia"), "6", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("other", "ccbr other");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="ccbr_blood_disorders"),  (SELECT id FROM structure_permissible_values WHERE value="other" AND language_alias="ccbr other"), "8", "1");

-- Move notes to last field, column 1
UPDATE structure_formats SET `display_order`='99', `flag_override_help`='0', `language_help`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='diagnosismasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='notes' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- Blood Disorders Form
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'DiagnosisDetail', 'dxd_ccbr_benign_blood', 'ccbr_blood_disorder', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ccbr_blood_disorders') , '0', '', '', '', 'ccbr blood disorder', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'dxd_ccbr_benign_blood', 'ccbr_other_blood_disorder', 'input',  NULL , '0', 'size=30', '', '', '', 'ccbr other blood disorder');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='dx_ccbr_benign_blood'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_ccbr_benign_blood' AND `field`='ccbr_blood_disorder' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ccbr_blood_disorders')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ccbr blood disorder' AND `language_tag`=''), '1', '50', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='dx_ccbr_benign_blood'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_ccbr_benign_blood' AND `field`='ccbr_other_blood_disorder' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='ccbr other blood disorder'), '1', '51', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'DiagnosisMaster', 'diagnosis_masters', 'ccbr_age_at_dx_months', 'integer',  NULL , '0', '', '', '', '', 'ccbr age at dx months'), 
('Clinicalannotation', 'DiagnosisMaster', 'diagnosis_masters', 'ccbr_age_at_dx_weeks', 'integer',  NULL , '0', '', '', '', '', 'ccbr age at dx weeks'), 
('Clinicalannotation', 'DiagnosisMaster', 'diagnosis_masters', 'ccbr_age_at_dx_days', 'integer',  NULL , '0', '', '', '', '', 'ccbr age at dx days');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='dx_ccbr_benign_blood'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='age_at_dx' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '20', '', '', '', '1', 'ccbr age at dx years', '1', '', '1', 'integer', '1', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='dx_ccbr_benign_blood'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='ccbr_age_at_dx_months' AND `type`='integer' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='ccbr age at dx months'), '1', '21', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='dx_ccbr_benign_blood'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='ccbr_age_at_dx_weeks' AND `type`='integer' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='ccbr age at dx weeks'), '1', '22', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='dx_ccbr_benign_blood'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='ccbr_age_at_dx_days' AND `type`='integer' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='ccbr age at dx days'), '1', '23', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='dx_ccbr_benign_blood'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_nature' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='dx_nature') AND `flag_confidential`='0'), '1', '14', '', '0', '', '0', '', '1', '', '0', '', '0', '', '1', 'benign', '0', '0', '1', '1', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0');

-- Solid Tumour
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='dx_ccbr_solid_tumour'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_nature' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='dx_nature') AND `flag_confidential`='0'), '1', '14', '', '0', '', '0', '', '1', '', '0', '', '0', '', '1', 'benign', '0', '0', '1', '1', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='dx_ccbr_solid_tumour'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='age_at_dx' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '20', '', '', '', '1', 'ccbr age at dx years', '1', '', '1', 'integer', '1', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='dx_ccbr_solid_tumour'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='ccbr_age_at_dx_months' AND `type`='integer' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='ccbr age at dx months'), '1', '21', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='dx_ccbr_solid_tumour'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='ccbr_age_at_dx_weeks' AND `type`='integer' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='ccbr age at dx weeks'), '1', '22', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='dx_ccbr_solid_tumour'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='ccbr_age_at_dx_days' AND `type`='integer' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='ccbr age at dx days'), '1', '23', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='dx_ccbr_solid_tumour'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='tumour_grade' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tumour grade') AND `flag_confidential`='0'), '1', '14', '', '0', '', '0', '', '1', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='dx_ccbr_solid_tumour'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='ajcc_edition' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ajcc edition') AND `flag_confidential`='0'), '2', '24', 'staging', '0', '', '0', '', '1', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='dx_ccbr_solid_tumour'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='collaborative_staged' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yesno') AND `flag_confidential`='0'), '2', '25', '', '0', '', '0', '', '1', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='dx_ccbr_solid_tumour'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='clinical_stage_summary' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '2', '34', '', '0', '', '0', '', '1', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='dx_ccbr_solid_tumour'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='clinical_tstage' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=1,maxlength=3' AND `default`='' AND `language_help`='' AND `language_label`='clinical stage' AND `language_tag`='t stage'), '2', '31', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='dx_ccbr_solid_tumour'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='clinical_nstage' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=1,maxlength=3' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='n stage'), '2', '32', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='dx_ccbr_solid_tumour'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='clinical_mstage' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=1,maxlength=3' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='m stage'), '2', '33', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES
((SELECT id FROM structures WHERE alias='dx_ccbr_solid_tumour'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_tstage' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=1,maxlength=3' AND `language_tag`='t stage'), '2', '35', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='dx_ccbr_solid_tumour'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_nstage' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=1,maxlength=3' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='n stage'), '2', '36', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='dx_ccbr_solid_tumour'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_mstage' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=1,maxlength=3' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='m stage'), '2', '37', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='dx_ccbr_solid_tumour'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_stage_summary' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '2', '38', '', '0', '', '0', '', '1', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0');

UPDATE structure_formats SET `flag_override_default`='0', `default`='', `flag_add`='1', `flag_edit_readonly`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_ccbr_solid_tumour') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_nature' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='dx_nature') AND `flag_confidential`='0');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'DiagnosisDetail', 'dxd_ccbr_solid_tumour', 'laterality', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='laterality') , '0', '', '', '', 'laterality', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='dx_ccbr_solid_tumour'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_ccbr_solid_tumour' AND `field`='laterality' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='laterality')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='laterality' AND `language_tag`=''), '2', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0');
UPDATE structure_formats SET `display_order`='5' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_ccbr_solid_tumour') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='ajcc_edition' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ajcc edition') AND `flag_confidential`='0');

-- Leukemia
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'DiagnosisMaster', 'diagnosis_masters', 'ccbr_risk_group', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ccbr_risk_groups') , '0', '', '', '', 'ccbr risk group', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='dx_ccbr_leukemia'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='ccbr_risk_group' AND `type`='select' AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ccbr risk group' AND `language_tag`=''), '1', '12', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='dx_ccbr_leukemia'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_nature' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='dx_nature') AND `flag_confidential`='0'), '1', '14', '', '0', '', '0', '', '1', '', '0', '', '0', '', '', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='dx_ccbr_leukemia'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='age_at_dx' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '20', '', '', '', '1', 'ccbr age at dx years', '1', '', '1', 'integer', '1', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='dx_ccbr_leukemia'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='ccbr_age_at_dx_months' AND `type`='integer' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='ccbr age at dx months'), '1', '21', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='dx_ccbr_leukemia'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='ccbr_age_at_dx_weeks' AND `type`='integer' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='ccbr age at dx weeks'), '1', '22', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='dx_ccbr_leukemia'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='ccbr_age_at_dx_days' AND `type`='integer' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='ccbr age at dx days'), '1', '23', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='dx_ccbr_leukemia'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='tumour_grade' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tumour grade') AND `flag_confidential`='0'), '1', '14', '', '0', '', '0', '', '1', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0');

-- Lymphoma
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='dx_ccbr_lymphoma'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_nature' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='dx_nature') AND `flag_confidential`='0'), '1', '14', '', '0', '', '0', '', '1', '', '0', '', '0', '', '1', 'benign', '0', '0', '1', '1', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='dx_ccbr_lymphoma'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='age_at_dx' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '20', '', '', '', '1', 'ccbr age at dx years', '1', '', '1', 'integer', '1', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='dx_ccbr_lymphoma'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='ccbr_age_at_dx_months' AND `type`='integer' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='ccbr age at dx months'), '1', '21', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='dx_ccbr_lymphoma'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='ccbr_age_at_dx_weeks' AND `type`='integer' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='ccbr age at dx weeks'), '1', '22', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='dx_ccbr_lymphoma'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='ccbr_age_at_dx_days' AND `type`='integer' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='ccbr age at dx days'), '1', '23', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='dx_ccbr_lymphoma'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='tumour_grade' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tumour grade') AND `flag_confidential`='0'), '1', '14', '', '0', '', '0', '', '1', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='dx_ccbr_lymphoma'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='ajcc_edition' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ajcc edition') AND `flag_confidential`='0'), '2', '24', 'staging', '0', '', '0', '', '1', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='dx_ccbr_lymphoma'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='collaborative_staged' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yesno') AND `flag_confidential`='0'), '2', '25', '', '0', '', '0', '', '1', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='dx_ccbr_lymphoma'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='clinical_stage_summary' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '2', '34', '', '0', '', '0', '', '1', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='dx_ccbr_lymphoma'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='clinical_tstage' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=1,maxlength=3' AND `default`='' AND `language_help`='' AND `language_label`='clinical stage' AND `language_tag`='t stage'), '2', '31', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='dx_ccbr_lymphoma'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='clinical_nstage' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=1,maxlength=3' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='n stage'), '2', '32', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='dx_ccbr_lymphoma'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='clinical_mstage' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=1,maxlength=3' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='m stage'), '2', '33', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES
((SELECT id FROM structures WHERE alias='dx_ccbr_lymphoma'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_tstage' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=1,maxlength=3' AND `language_tag`='t stage'), '2', '35', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='dx_ccbr_lymphoma'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_nstage' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=1,maxlength=3' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='n stage'), '2', '36', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='dx_ccbr_lymphoma'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_mstage' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=1,maxlength=3' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='m stage'), '2', '37', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='dx_ccbr_lymphoma'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_stage_summary' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '2', '38', '', '0', '', '0', '', '1', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0');

UPDATE structure_formats SET `flag_override_default`='0', `default`='', `flag_add`='1', `flag_edit_readonly`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_ccbr_lymphoma') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_nature' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='dx_nature') AND `flag_confidential`='0');
