-- ------------------------------------------------------
-- ATiM ... Data Script
-- version: 2.7.2
-- ------------------------------------------------------

-- user_id (To Define)

SET @user_id = (SELECT id FROM users WHERE username LIKE '%' AND id LIKE '1');

-- --------------------------------------------------------------------------------
-- QBCF Breast Progression
-- ................................................................................
-- Secondary diagnosis forms developped to capture data of breast cancer 
-- progression for the central ATiM of the Quebec Breast Cancer Foundation.
-- --------------------------------------------------------------------------------

INSERT INTO `diagnosis_controls` (`id`, `category`, `controls_type`, `flag_active`, `detail_form_alias`, `detail_tablename`, `display_order`, `databrowser_label`, `flag_compare_with_cap`) 
VALUES
(null, 'secondary - distant', 'qbcf - breast progression', 1, 'qbcf_dxd_breast_progressions', 'qbcf_dxd_breast_progressions', 0, 'secondary - distant|qbcf - breast progression', 0);

DROP TABLE IF EXISTS `qbcf_dxd_breast_progressions`;
CREATE TABLE IF NOT EXISTS `qbcf_dxd_breast_progressions` (
  `diagnosis_master_id` int(11) NOT NULL,
  `confirmation` varchar(250) NOT NULL DEFAULT '',
  KEY `diagnosis_master_id` (`diagnosis_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
DROP TABLE IF EXISTS `qbcf_dxd_breast_progressions_revs`;
CREATE TABLE IF NOT EXISTS `qbcf_dxd_breast_progressions_revs` (
  `diagnosis_master_id` int(11) NOT NULL,
  `confirmation` varchar(250) NOT NULL DEFAULT '',
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
ALTER TABLE `qbcf_dxd_breast_progressions`
  ADD CONSTRAINT `FK_qbcf_dxd_breast_progressions_diagnosis_masters` FOREIGN KEY (`diagnosis_master_id`) REFERENCES `diagnosis_masters` (`id`);

INSERT INTO structure_value_domains (domain_name, override, category, source) 
VALUES
('qbcf_diagnosis_progression_sites', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(\'QBCF: Breast Progression Sites\')');
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) 
VALUES
('QBCF: Breast Progression Sites', 1, 250, 'clinical - diagnosis');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'QBCF: Breast Progression Sites');
INSERT INTO structure_permissible_values_customs 
(`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) VALUES
("bone", "Bone", "", "246", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("brain", "Brain", "", "247", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("liver", "Liver", "", "248", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("lung", "Lung", "", "249", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("lymph node - distal", "Lymph Node - distal", "", "251", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("lymph node - regional", "Lymph Node - regional", "", "250", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("other", "Other", "", "253", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("skin", "Skin", "", "252", "1", @control_id, NOW(), NOW(), @user_id, @user_id);

INSERT INTO structure_value_domains (domain_name, override, category, source) 
VALUES
('qbcf_diagnosis_progression_confirmations', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(\'QBCF : Breast Progression Confirmations\')');
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) 
VALUES
('QBCF : Breast Progression Confirmations', 1, 250, 'clinical - diagnosis');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'QBCF : Breast Progression Confirmations');
INSERT INTO structure_permissible_values_customs (`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) 
VALUES
("confirmed by other means", "Confirmed by other means", "", "0", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("confirmed by pathology", "Confirmed by pathology", "", "0", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("suspicious by Imaging", "Suspicious by Imaging", "", "0", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("uncertain if from other cancer", "Uncertain if from other cancer", "", "0", "1", @control_id, NOW(), NOW(), @user_id, @user_id);
 
INSERT INTO structures(`alias`) VALUES ('qbcf_dxd_breast_progressions');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'DiagnosisMaster', 'diagnosis_masters', 'topography', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qbcf_diagnosis_progression_sites') , '0', '', '', '', 'site', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'qbcf_dxd_breast_progressions', 'confirmation', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qbcf_diagnosis_progression_confirmations') , '0', '', '', '', 'confirmation', '');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qbcf_dxd_breast_progressions'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='topography' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qbcf_diagnosis_progression_sites')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='site' AND `language_tag`=''), 
'1', '11', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qbcf_dxd_breast_progressions'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qbcf_dxd_breast_progressions' AND `field`='confirmation' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qbcf_diagnosis_progression_confirmations')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='confirmation' AND `language_tag`=''), 
'1', '12', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0');

INSERT IGNORE INTO i18n (id,en,fr) 
VALUES 
("qbcf - breast progression", "Breast Progression (QBCF)", "Progression sein (QBCF)"),
("site", "Site", "Site"),
("confirmation", "Confirmation", "Confirmation");
 
-- --------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------

UPDATE versions SET permissions_regenerated = 0;