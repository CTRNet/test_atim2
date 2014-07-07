-- NPTTB Custom Script
-- Version: v0.8
-- ATiM Version: v2.5.2

-- Update bank name for version tracking during customization
REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('core_installname', 'Clark H. Smith NPTTB - v0.8', '');

-- Eventum ID: 3066 - New consent form
INSERT INTO `structure_permissible_values_customs` (`control_id`, `value`, `en`, `fr`, `display_order`, `use_as_input`, `created`, `created_by`, `modified`, `modified_by`) VALUES
((SELECT `id` FROM `structure_permissible_values_custom_controls` WHERE `name` = 'Consent Form Versions'), 'v5.0 nov-1-2013', 'v5.0 Nov-1-2013', 'v5.0 nov-1-2013', '6', '1', '2014-07-03 17:21:49', '1', '2014-07-03 17:21:49', '1');

-- Eventum ID: 2746 - Consent - Autoincrement issue
ALTER TABLE `cd_npttb_autopsy` CHANGE `id` `id` INT(11) NOT NULL AUTO_INCREMENT;
ALTER TABLE `cd_npttb_consent_sno_calgary` CHANGE `id` `id` INT(11) NOT NULL AUTO_INCREMENT;

-- Eventum ID: 3067 - Add TTB diagnosis to all child records
ALTER TABLE `diagnosis_masters` 
ADD `npttb_path_final_dx` VARCHAR(255) NULL DEFAULT NULL AFTER `notes`,
ADD `npttb_ttb_diagnosis` VARCHAR(255) NULL DEFAULT NULL AFTER `npttb_path_final_dx`,
ADD `npttb_grade` VARCHAR(255) NULL DEFAULT NULL AFTER `npttb_ttb_diagnosis`;

ALTER TABLE `diagnosis_masters_revs` 
ADD `npttb_path_final_dx` VARCHAR(255) NULL DEFAULT NULL AFTER `notes`,
ADD `npttb_ttb_diagnosis` VARCHAR(255) NULL DEFAULT NULL AFTER `npttb_path_final_dx`,
ADD `npttb_grade` VARCHAR(255) NULL DEFAULT NULL AFTER `npttb_ttb_diagnosis`;

-- Migrate existing values from tissue detail table to master
UPDATE `diagnosis_masters` SET `diagnosis_masters`.`npttb_path_final_dx` = 
(SELECT `dxd_npttb_tissue`.`npttb_path_final_dx` FROM `dxd_npttb_tissue`
WHERE `dxd_npttb_tissue`.`diagnosis_master_id` = `diagnosis_masters`.`id`);

UPDATE `diagnosis_masters` SET `diagnosis_masters`.`npttb_ttb_diagnosis` = 
(SELECT `dxd_npttb_tissue`.`npttb_ttb_diagnosis` FROM `dxd_npttb_tissue`
WHERE `dxd_npttb_tissue`.`diagnosis_master_id` = `diagnosis_masters`.`id`);

UPDATE `diagnosis_masters` SET `diagnosis_masters`.`npttb_grade` = 
(SELECT `dxd_npttb_tissue`.`npttb_grade` FROM `dxd_npttb_tissue`
WHERE `dxd_npttb_tissue`.`diagnosis_master_id` = `diagnosis_masters`.`id`);

/*
SELECT `diagnosis_masters`.`npttb_path_final_dx` AS 'Master', `dxd_npttb_tissue`.`npttb_path_final_dx` AS 'Detail'
FROM `diagnosis_masters`, `dxd_npttb_tissue`
WHERE `diagnosis_masters`.`id` = `dxd_npttb_tissue`.`diagnosis_master_id`;
*/

-- Disable tissue detail form fields
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_npttb_tissue') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_npttb_tissue' AND `field`='npttb_path_final_dx' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_npttb_tissue') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_npttb_tissue' AND `field`='npttb_ttb_diagnosis' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='npttb_final_diagnosis') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_npttb_tissue') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_npttb_tissue' AND `field`='npttb_grade' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='npttb_grade') AND `flag_confidential`='0');

-- delete structure_formats
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_npttb_tissue') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='dxd_npttb_tissue' AND `field`='npttb_path_final_dx' AND `language_label`='npttb path final dx' AND `language_tag`='' AND `type`='input' AND `setting`='size=50' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='npttb help path final' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_npttb_tissue') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='dxd_npttb_tissue' AND `field`='npttb_ttb_diagnosis' AND `language_label`='npttb ttb diagnosis' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='npttb_final_diagnosis') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_npttb_tissue') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='dxd_npttb_tissue' AND `field`='npttb_grade' AND `language_label`='' AND `language_tag`='npttb grade' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='npttb_grade') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
-- Delete obsolete structure fields and validations
DELETE FROM structure_validations WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='dxd_npttb_tissue' AND `field`='npttb_path_final_dx' AND `language_label`='npttb path final dx' AND `language_tag`='' AND `type`='input' AND `setting`='size=50' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='npttb help path final' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0') OR (
`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='dxd_npttb_tissue' AND `field`='npttb_ttb_diagnosis' AND `language_label`='npttb ttb diagnosis' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='npttb_final_diagnosis') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0') OR (
`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='dxd_npttb_tissue' AND `field`='npttb_grade' AND `language_label`='' AND `language_tag`='npttb grade' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='npttb_grade') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0'));
DELETE FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='dxd_npttb_tissue' AND `field`='npttb_path_final_dx' AND `language_label`='npttb path final dx' AND `language_tag`='' AND `type`='input' AND `setting`='size=50' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='npttb help path final' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0') OR (
`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='dxd_npttb_tissue' AND `field`='npttb_ttb_diagnosis' AND `language_label`='npttb ttb diagnosis' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='npttb_final_diagnosis') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0') OR (
`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='dxd_npttb_tissue' AND `field`='npttb_grade' AND `language_label`='' AND `language_tag`='npttb grade' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='npttb_grade') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');


-- Add fields to master form
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'DiagnosisMaster', 'diagnosis_masters', 'npttb_path_final_dx', 'input',  NULL , '0', 'size=50', '', '', 'npttb path final dx', ''), 
('ClinicalAnnotation', 'DiagnosisMaster', 'diagnosis_masters', 'npttb_ttb_diagnosis', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='npttb_final_diagnosis') , '0', '', '', '', 'npttb ttb diagnosis', ''), 
('ClinicalAnnotation', 'DiagnosisMaster', 'diagnosis_masters', 'npttb_grade', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='npttb_grade') , '0', '', '', '', 'npttb grade', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='diagnosismasters'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='npttb_path_final_dx' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=50' AND `default`='' AND `language_help`='' AND `language_label`='npttb path final dx' AND `language_tag`=''), '1', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='diagnosismasters'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='npttb_ttb_diagnosis' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='npttb_final_diagnosis')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='npttb ttb diagnosis' AND `language_tag`=''), '1', '6', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='diagnosismasters'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='npttb_grade' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='npttb_grade')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='npttb grade' AND `language_tag`=''), '1', '7', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
UPDATE structure_fields SET  `language_help`='help_memo' WHERE model='DiagnosisMaster' AND tablename='diagnosis_masters' AND field='notes' AND `type`='textarea' AND structure_value_domain  IS NULL ;
UPDATE structure_formats SET `flag_override_help`='0', `language_help`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='diagnosismasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='notes' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');


