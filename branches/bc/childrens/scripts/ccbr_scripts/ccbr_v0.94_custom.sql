-- CCBR Customization Script
-- Version: v0.94
-- ATiM Version: v2.5.1
-- Notes: Run against an upgraded v2.5.1 CCBR installation. Minor patch to change layout of sample/aliquot forms

-- Update bank name for version tracking during customization
REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('core_installname', 'Child and Family Research Institute - CCBR v0.94', '');
	
--  --------------------------------------------------------------------------
--	EVENTUM ISSUE: #2791 - Diagnosis form - New bone marrow fields
--	--------------------------------------------------------------------------

ALTER TABLE `dxd_ccbr_solid_tumour` 
ADD COLUMN `ccbr_bone_marrow_right` INT(11) NULL DEFAULT NULL AFTER `laterality`,
ADD COLUMN `ccbr_bone_marrow_left` INT(11) NULL DEFAULT NULL AFTER `ccbr_bone_marrow_right`;

ALTER TABLE `dxd_ccbr_solid_tumour_revs` 
ADD COLUMN `ccbr_bone_marrow_right` INT(11) NULL DEFAULT NULL AFTER `laterality`,
ADD COLUMN `ccbr_bone_marrow_left` INT(11) NULL DEFAULT NULL AFTER `ccbr_bone_marrow_right`;

-- Add fields to diagnosis solid tumour form
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'DiagnosisDetail', 'dxd_ccbr_solid_tumour', 'ccbr_bone_marrow_left', 'integer_positive',  NULL , '0', 'size=5', '', '', 'ccbr bone marrow left', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'dxd_ccbr_solid_tumour', 'ccbr_bone_marrow_right', 'integer',  NULL , '0', 'size=5', '', '', 'ccbr bone marrow right', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='dx_ccbr_solid_tumour'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_ccbr_solid_tumour' AND `field`='ccbr_bone_marrow_left' AND `type`='integer_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='ccbr bone marrow left' AND `language_tag`=''), '1', '30', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='dx_ccbr_solid_tumour'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_ccbr_solid_tumour' AND `field`='ccbr_bone_marrow_right' AND `type`='integer' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='ccbr bone marrow right' AND `language_tag`=''), '1', '35', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
 ('ccbr bone marrow left', 'Bone Marrow Involvement - Left', ''),
 ('ccbr bone marrow right', 'Bone Marrow Involvement - Right', ''); 


--  --------------------------------------------------------------------------
--	EVENTUM ISSUE: #2742 - Consent update - New questions
--	--------------------------------------------------------------------------

ALTER TABLE `cd_ccbr_consents` 
ADD COLUMN `ccbr_consent_left_over_csf` VARCHAR(45) NULL DEFAULT NULL AFTER `ccbr_withdraw_all_samples`,
ADD COLUMN `ccbr_consent_left_over_leukapheresis` VARCHAR(45) NULL DEFAULT NULL AFTER `ccbr_consent_left_over_csf`,
ADD COLUMN `ccbr_permission_to_contact` VARCHAR(45) NULL DEFAULT NULL AFTER `ccbr_consent_left_over_leukapheresis`,
ADD COLUMN `ccbr_old_biospecimens` VARCHAR(45) NULL DEFAULT NULL AFTER `ccbr_permission_to_contact`,
ADD COLUMN `ccbr_consent_donation_bone_marrow` VARCHAR(45) NULL DEFAULT NULL AFTER `ccbr_old_biospecimens`;

ALTER TABLE `cd_ccbr_consents_revs` 
ADD COLUMN `ccbr_consent_left_over_csf` VARCHAR(45) NULL DEFAULT NULL AFTER `ccbr_withdraw_all_samples`,
ADD COLUMN `ccbr_consent_left_over_leukapheresis` VARCHAR(45) NULL DEFAULT NULL AFTER `ccbr_consent_left_over_csf`,
ADD COLUMN `ccbr_permission_to_contact` VARCHAR(45) NULL DEFAULT NULL AFTER `ccbr_consent_left_over_leukapheresis`,
ADD COLUMN `ccbr_old_biospecimens` VARCHAR(45) NULL DEFAULT NULL AFTER `ccbr_permission_to_contact`,
ADD COLUMN `ccbr_consent_donation_bone_marrow` VARCHAR(45) NULL DEFAULT NULL AFTER `ccbr_old_biospecimens`;

-- Add fields to consent detail form
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'ConsentDetail', 'cd_ccbr_consents', 'ccbr_consent_left_over_csf', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ccbr_consent_yesnona') , '0', '', '', '', 'ccbr consent left over csf', ''), 
('ClinicalAnnotation', 'ConsentDetail', 'cd_ccbr_consents', 'ccbr_consent_left_over_leukapheresis', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ccbr_consent_yesnona') , '0', '', '', '', 'ccbr consent left over leukapheresis', ''), 
('ClinicalAnnotation', 'ConsentDetail', 'cd_ccbr_consents', 'ccbr_permission_to_contact', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ccbr_consent_yesnona') , '0', '', '', '', 'ccbr permission to contact', ''), 
('ClinicalAnnotation', 'ConsentDetail', 'cd_ccbr_consents', 'ccbr_old_biospecimens', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ccbr_consent_yesnona') , '0', '', '', '', 'ccbr old biospecimens', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='cd_ccbr_consents'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_ccbr_consents' AND `field`='ccbr_consent_left_over_csf' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ccbr_consent_yesnona')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ccbr consent left over csf' AND `language_tag`=''), '1', '30', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='cd_ccbr_consents'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_ccbr_consents' AND `field`='ccbr_consent_left_over_leukapheresis' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ccbr_consent_yesnona')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ccbr consent left over leukapheresis' AND `language_tag`=''), '1', '35', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='cd_ccbr_consents'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_ccbr_consents' AND `field`='ccbr_permission_to_contact' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ccbr_consent_yesnona')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ccbr permission to contact' AND `language_tag`=''), '1', '40', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='cd_ccbr_consents'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_ccbr_consents' AND `field`='ccbr_old_biospecimens' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ccbr_consent_yesnona')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ccbr old biospecimens' AND `language_tag`=''), '1', '45', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'ConsentDetail', 'cd_ccbr_consents', 'ccbr_consent_donation_bone_marrow', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ccbr_consent_yesnona') , '0', '', '', '', 'ccbr consent donation bone marrow', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='cd_ccbr_consents'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_ccbr_consents' AND `field`='ccbr_consent_donation_bone_marrow' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ccbr_consent_yesnona')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ccbr consent donation bone marrow' AND `language_tag`=''), '1', '48', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');

-- Move master fields
UPDATE structure_fields SET  `setting`='cols=35,rows=6' WHERE model='ConsentMaster' AND tablename='consent_masters' AND field='notes' AND `type`='textarea' AND structure_value_domain  IS NULL ;
UPDATE structure_formats SET `display_order`='50' WHERE structure_id=(SELECT id FROM structures WHERE alias='consent_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='consent_status' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='consent_status') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='55' WHERE structure_id=(SELECT id FROM structures WHERE alias='consent_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='status_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='60' WHERE structure_id=(SELECT id FROM structures WHERE alias='consent_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='consent_signed_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='65' WHERE structure_id=(SELECT id FROM structures WHERE alias='consent_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='reason_denied' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='99' WHERE structure_id=(SELECT id FROM structures WHERE alias='consent_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='notes' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');


REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
 ('ccbr consent left over csf', 'Use of Left Over CSF', ''),
 ('ccbr consent left over leukapheresis', 'Use of Left Over Leukapheresis', ''),
 ('ccbr permission to contact', 'Permission to Contact', ''), 
 ('ccbr consent donation bone marrow', 'Consent to Bone Marrow Donation', ''),  
 ('ccbr old biospecimens', 'Use of Old Biospecimens', '');
 
--  --------------------------------------------------------------------------
--	EVENTUM ISSUE: #2806 - Consent - Hide status date and consent signed
--	-------------------------------------------------------------------------- 

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='consent_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='status_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='consent_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='consent_signed_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

--  --------------------------------------------------------------------------
--	EVENTUM ISSUE: #2807 - Consent form - Improve layout
--	--------------------------------------------------------------------------

-- Move withdrawal reason to second column
UPDATE structure_formats SET `display_column`='2', `display_order`='5' WHERE structure_id=(SELECT id FROM structures WHERE alias='consent_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='reason_denied' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- Move status
UPDATE structure_formats SET `display_order`='6' WHERE structure_id=(SELECT id FROM structures WHERE alias='consent_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='consent_status' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='consent_status') AND `flag_confidential`='0');   

-- Move translator
UPDATE structure_formats SET `display_order`='7' WHERE structure_id=(SELECT id FROM structures WHERE alias='cd_ccbr_consents') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='translator_indicator' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='7' WHERE structure_id=(SELECT id FROM structures WHERE alias='cd_ccbr_consents') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='translator_signature' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- Add heading for quesions section
UPDATE structure_formats SET `language_heading`='ccbr_consent details' WHERE structure_id=(SELECT id FROM structures WHERE alias='cd_ccbr_consents') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_ccbr_consents' AND `field`='ccbr_consent_blood_donation' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ccbr_consent_yesnona') AND `flag_confidential`='0');

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
 ('ccbr_consent details', 'Consent Details', '');

