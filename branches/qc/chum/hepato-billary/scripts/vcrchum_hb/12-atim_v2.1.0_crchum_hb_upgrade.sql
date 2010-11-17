DROP VIEW `view_collections`;
CREATE VIEW `view_collections` AS SELECT 
`col`.`id` AS `collection_id`,
`col`.`bank_id` AS `bank_id`,
`col`.`sop_master_id` AS `sop_master_id`,
`link`.`participant_id` AS `participant_id`,
`link`.`diagnosis_master_id` AS `diagnosis_master_id`,
`link`.`consent_master_id` AS `consent_master_id`,
`part`.`participant_identifier` AS `participant_identifier`,
`col`.`acquisition_label` AS `acquisition_label`,
`col`.`collection_site` AS `collection_site`,
`col`.`collection_datetime` AS `collection_datetime`,
`col`.`collection_datetime_accuracy` AS `collection_datetime_accuracy`,
`col`.`collection_property` AS `collection_property`,
`col`.`collection_notes` AS `collection_notes`,
`col`.`deleted` AS `deleted`,
`banks`.`name` AS `bank_name`,
`col`.`created` AS `created`,
`misc_identifiers`.`identifier_value` AS hepato_bil_bank_participant_id  
FROM `collections` `col` 
LEFT JOIN `clinical_collection_links` `link` ON `col`.`id` = `link`.`collection_id` AND `link`.`deleted` <> 1 
LEFT JOIN `participants` `part` ON `link`.`participant_id` = `part`.`id` AND `part`.`deleted` <> 1 
LEFT JOIN `banks` ON `col`.`bank_id` = `banks`.`id` AND `banks`.`deleted` <> 1 
LEFT JOIN `misc_identifiers` ON part.id=misc_identifiers.participant_id AND misc_identifiers.identifier_name='hepato_bil_bank_participant_id'
WHERE `col`.`deleted` <> 1;

UPDATE structure_fields SET field = 'hepato_bil_bank_participant_id', language_label = 'hepato_bil_bank_participant_id' WHERE field = 'no_labo';

DROP VIEW view_aliquots;
CREATE VIEW view_aliquots AS 
SELECT 
al.id AS aliquot_master_id,
al.sample_master_id AS sample_master_id,
al.collection_id AS collection_id, 
col.bank_id, 
al.storage_master_id AS storage_master_id,
link.participant_id, 
link.diagnosis_master_id, 
link.consent_master_id,

part.participant_identifier, 

col.acquisition_label, 

specimen.sample_type AS initial_specimen_sample_type,
specimen.sample_control_id AS initial_specimen_sample_control_id,
parent_samp.sample_type AS parent_sample_type,
parent_samp.sample_control_id AS parent_sample_control_id,
samp.sample_type,
samp.sample_control_id,

al.barcode,
al.qc_hb_label AS qc_hb_label,
al.aliquot_type,
al.aliquot_control_id,
al.in_stock,

stor.code,
stor.selection_label,
al.storage_coord_x,
al.storage_coord_y,

stor.temperature,
stor.temp_unit,

al.created,
al.deleted

FROM aliquot_masters as al
INNER JOIN sample_masters as samp ON samp.id = al.sample_master_id AND samp.deleted != 1
INNER JOIN collections AS col ON col.id = samp.collection_id AND col.deleted != 1
LEFT JOIN sample_masters as specimen ON samp.initial_specimen_sample_id = specimen.id AND specimen.deleted != 1
LEFT JOIN sample_masters as parent_samp ON samp.parent_id = parent_samp.id AND parent_samp.deleted != 1
LEFT JOIN clinical_collection_links AS link ON col.id = link.collection_id AND link.deleted != 1
LEFT JOIN participants AS part ON link.participant_id = part.id AND part.deleted != 1
LEFT JOIN storage_masters AS stor ON stor.id = al.storage_master_id AND stor.deleted != 1
WHERE al.deleted != 1;

UPDATE `users` SET `flag_active` = '1' WHERE `users`.`id` =1;

TRUNCATE structure_permissible_values_customs;
TRUNCATE structure_permissible_values_customs_revs;

INSERT INTO `structure_permissible_values_customs` (`id`, `control_id`, `value`, `en`, `fr`, `created`, `created_by`, `modified`, `modified_by`, `deleted`, `deleted_date`) VALUES
(null, (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'laboratory staff'), 'urszula krzemien', 'Urszula Krzemien', 'Urszula Krzemien', '0000-00-00 00:00:00', 0, NULL, 0, 0, NULL),
(null, (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'laboratory sites'), 'ICM', 'ICM', 'ICM', '0000-00-00 00:00:00', 0, NULL, 0, 0, NULL),
(null, (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'specimen collection sites'), 'saint-luc hospital', 'Saint-Luc Hospital', 'Hï¿½pital Saint-Luc', '0000-00-00 00:00:00', 0, NULL, 0, 0, NULL),
(null, (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'specimen supplier departments'), 'operating room', 'Operating Room', 'Salle d''opï¿½ration', '0000-00-00 00:00:00', 0, NULL, 0, 0, NULL),
(null, (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'specimen supplier departments'), 'pathology', 'Pathology', 'Pathologie', '0000-00-00 00:00:00', 0, NULL, 0, 0, NULL),
(null, (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'specimen supplier departments'), 'preadmission = preoperative checkup', 'Preadmission (Preoperative Checkup)', 'Prï¿½admission (bilan prï¿½opï¿½ratoire)', '0000-00-00 00:00:00', 0, NULL, 0, 0, NULL),
(null, (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'specimen supplier departments'), 'service hbp', 'Service HBP', 'Service HPB', '0000-00-00 00:00:00', 0, NULL, 0, 0, NULL);

-- just to be sure
DELETE FROM `structure_value_domains_permissible_values` WHERE 	structure_value_domain_id IN (
	SELECT id FROM  `structure_value_domains` 
	WHERE domain_name IN ('qc_hb_tx_surgery_associated_surgery',
	'qc_hb_tx_surgery_liver_appearance',
	'qc_hb_tx_surgery_liver_type_of_vascular_occlusion',
	'qc_hb_tx_surgery_other_organ_resection',
	'qc_hb_tx_surgery_pancreas_appearance',
	'qc_hb_tx_surgery_pancreas_type_of_anastomosis',
	'qc_hb_tx_surgery_pathological_report',
	'qc_hb_tx_surgery_principal_surgery',
	'qc_hb_tx_surgery_type_of_drain',
	'qc_hb_tx_surgery_type_of_glue',
	'qc_hb_suregry_complication_organ_list',
	'qc_hb_chemos_reason_of_change',
	'qc_hb_chemos_toxicity')
);

INSERT INTO `structure_permissible_values_custom_controls` (`id`, `name`, `flag_active`) VALUES
(null, 'surgery: principal surgery', 1),	-- 'qc_hb_tx_surgery_principal_surgery',
(null, 'surgery: associated surgery', 1),	-- qc_hb_tx_surgery_associated_surgery
(null, 'surgery: other organ resection', 1),	-- qc_hb_tx_surgery_other_organ_resection
(null, 'surgery: pathological report', 1),	-- qc_hb_tx_surgery_pathological_report
(null, 'surgery: type of drain', 1),	-- qc_hb_tx_surgery_type_of_drain
(null, 'surgery: type of glue', 1),	-- qc_hb_tx_surgery_type_of_glue

(null, 'surgey - liver detail : liver appearance', 1),	-- qc_hb_tx_surgery_liver_appearance
(null, 'surgey - liver detail : type of vascular occlusion', 1),		-- qc_hb_tx_surgery_liver_type_of_vascular_occlusion

(null, 'surgey - liver pancreas : pancreas appearance', 1),	-- qc_hb_tx_surgery_pancreas_appearance
(null, 'surgey - liver pancreas : type of pancreas anastomosis', 1),	-- qc_hb_tx_surgery_pancreas_type_of_anastomosis

(null, 'surgey - complication : organ list', 1),	-- qc_hb_suregry_complication_organ_list

(null, 'chemotherapy : reason of change', 1),	-- qc_hb_chemos_reason_of_change
(null, 'chemotherapy : toxicity', 1);	-- qc_hb_chemos_toxicity

UPDATE structure_value_domains SET source = 'StructurePermissibleValuesCustom::getDropdownAssociatedSurgery' WHERE domain_name = 'qc_hb_tx_surgery_associated_surgery';
UPDATE structure_value_domains SET source = 'StructurePermissibleValuesCustom::getDropdownLiverAppearance' WHERE domain_name = 'qc_hb_tx_surgery_liver_appearance';
UPDATE structure_value_domains SET source = 'StructurePermissibleValuesCustom::getDropdownTypeOfVascularOcclusion' WHERE domain_name = 'qc_hb_tx_surgery_liver_type_of_vascular_occlusion';
UPDATE structure_value_domains SET source = 'StructurePermissibleValuesCustom::getDropdownOtherOrganResection' WHERE domain_name = 'qc_hb_tx_surgery_other_organ_resection';
UPDATE structure_value_domains SET source = 'StructurePermissibleValuesCustom::getDropdownPancreasAppearance' WHERE domain_name = 'qc_hb_tx_surgery_pancreas_appearance';
UPDATE structure_value_domains SET source = 'StructurePermissibleValuesCustom::getDropdownTypeOfAnastomosis' WHERE domain_name = 'qc_hb_tx_surgery_pancreas_type_of_anastomosis';
UPDATE structure_value_domains SET source = 'StructurePermissibleValuesCustom::getDropdownSurgeryPathologicalReport' WHERE domain_name = 'qc_hb_tx_surgery_pathological_report';
UPDATE structure_value_domains SET source = 'StructurePermissibleValuesCustom::getDropdownPrincipalSurgery' WHERE domain_name = 'qc_hb_tx_surgery_principal_surgery';
UPDATE structure_value_domains SET source = 'StructurePermissibleValuesCustom::getDropdownTypeOfDrain' WHERE domain_name = 'qc_hb_tx_surgery_type_of_drain';
UPDATE structure_value_domains SET source = 'StructurePermissibleValuesCustom::getDropdownTypeOfGlue' WHERE domain_name = 'qc_hb_tx_surgery_type_of_glue';
UPDATE structure_value_domains SET source = 'StructurePermissibleValuesCustom::getDropdownComplicationOrganList' WHERE domain_name = 'qc_hb_suregry_complication_organ_list';
UPDATE structure_value_domains SET source = 'StructurePermissibleValuesCustom::getDropdownChemosChangeReason' WHERE domain_name = 'qc_hb_chemos_reason_of_change';
UPDATE structure_value_domains SET source = 'StructurePermissibleValuesCustom::getDropdownChemosToxicity' WHERE domain_name = 'qc_hb_chemos_toxicity';

DELETE FROM `structure_value_domains_permissible_values` WHERE 	structure_value_domain_id IN (
	SELECT id FROM  `structure_value_domains` 
	WHERE domain_name IN ('qc_hb_surgery_complication_treatment_list')
);

INSERT INTO `structure_permissible_values_custom_controls` 
(`id`, `name`, `flag_active`) 
VALUES
(null, 'surgery - complication: treatment', 1);	-- 'qc_hb_surgery_complication_treatment_list'

UPDATE structure_value_domains SET source = 'StructurePermissibleValuesCustom::getDropdownSurgeryComplicationTreatment' WHERE domain_name = 'qc_hb_surgery_complication_treatment_list';

INSERT INTO `structure_permissible_values_custom_controls` 
(`id`, `name`, `flag_active`) 
VALUES
(null, 'surgery: local treatment type', 1);	-- 'qc_hb_tx_surgery_type_of_local_treatment'

SET @last_control_id = LAST_INSERT_ID();

INSERT INTO structure_permissible_values_customs (`control_id`, `value`, `en`, `fr`)
(SELECT @last_control_id, value.value, i18n.en, i18n.fr
FROM structure_value_domains AS dom
LEFT JOIN structure_value_domains_permissible_values AS link ON link.structure_value_domain_id 	= dom.id
LEFT JOIN structure_permissible_values AS value ON value.id = link.structure_permissible_value_id
LEFT JOIN i18n ON i18n.id = value.language_alias
WHERE dom.domain_name LIKE 'qc_hb_tx_surgery_type_of_local_treatment');

DELETE FROM `structure_value_domains_permissible_values` WHERE 	structure_value_domain_id IN (
	SELECT id FROM  `structure_value_domains` 
	WHERE domain_name IN ('qc_hb_tx_surgery_type_of_local_treatment')
);

UPDATE structure_value_domains SET source = 'StructurePermissibleValuesCustom::getDropdownSurgeryLocalTreatment' WHERE domain_name = 'qc_hb_tx_surgery_type_of_local_treatment';

INSERT INTO `structure_permissible_values_custom_controls` 
(`id`, `name`, `flag_active`) 
VALUES
(null, 'surgey - complication : type', 1);	-- 'qc_hb_suregry_complication_list'

SET @last_control_id = LAST_INSERT_ID();

INSERT INTO structure_permissible_values_customs (`control_id`, `value`, `en`, `fr`)
(SELECT @last_control_id, value.value, i18n.en, i18n.fr
FROM structure_value_domains AS dom
LEFT JOIN structure_value_domains_permissible_values AS link ON link.structure_value_domain_id 	= dom.id
LEFT JOIN structure_permissible_values AS value ON value.id = link.structure_permissible_value_id
LEFT JOIN i18n ON i18n.id = value.language_alias
WHERE dom.domain_name LIKE 'qc_hb_suregry_complication_list');

DELETE FROM `structure_value_domains_permissible_values` WHERE 	structure_value_domain_id IN (
	SELECT id FROM  `structure_value_domains` 
	WHERE domain_name IN ('qc_hb_suregry_complication_list')
);

UPDATE structure_value_domains SET source = 'StructurePermissibleValuesCustom::getDropdownSurgeryComplicationList' WHERE domain_name = 'qc_hb_suregry_complication_list';

INSERT INTO `structure_permissible_values_custom_controls` 
(`id`, `name`, `flag_active`) 
VALUES
(null, 'surgey : surgeon list', 1);	-- 'qc_hb_hbp_surgeon_list'

SET @last_control_id = LAST_INSERT_ID();

INSERT INTO structure_permissible_values_customs (`control_id`, `value`, `en`, `fr`)
(SELECT @last_control_id, value.value, i18n.en, i18n.fr
FROM structure_value_domains AS dom
LEFT JOIN structure_value_domains_permissible_values AS link ON link.structure_value_domain_id 	= dom.id
LEFT JOIN structure_permissible_values AS value ON value.id = link.structure_permissible_value_id
LEFT JOIN i18n ON i18n.id = value.language_alias
WHERE dom.domain_name LIKE 'qc_hb_hbp_surgeon_list');

DELETE FROM `structure_value_domains_permissible_values` WHERE 	structure_value_domain_id IN (
	SELECT id FROM  `structure_value_domains` 
	WHERE domain_name IN ('qc_hb_hbp_surgeon_list')
);

UPDATE structure_value_domains SET source = 'StructurePermissibleValuesCustom::getDropdownSurgeonList' WHERE domain_name = 'qc_hb_hbp_surgeon_list';

INSERT INTO `structure_permissible_values_custom_controls` 
(`id`, `name`, `flag_active`) 
VALUES
(null, 'doctor : speciality list', 1);	-- 'qc_hb_specialty'

SET @last_control_id = LAST_INSERT_ID();

INSERT INTO structure_permissible_values_customs (`control_id`, `value`, `en`, `fr`)
(SELECT @last_control_id, value.value, i18n.en, i18n.fr
FROM structure_value_domains AS dom
LEFT JOIN structure_value_domains_permissible_values AS link ON link.structure_value_domain_id 	= dom.id
LEFT JOIN structure_permissible_values AS value ON value.id = link.structure_permissible_value_id
LEFT JOIN i18n ON i18n.id = value.language_alias
WHERE dom.domain_name LIKE 'qc_hb_specialty');

DELETE FROM `structure_value_domains_permissible_values` WHERE 	structure_value_domain_id IN (
	SELECT id FROM  `structure_value_domains` 
	WHERE domain_name IN ('qc_hb_specialty')
);

UPDATE structure_value_domains SET source = 'StructurePermissibleValuesCustom::getDropdownDoctorSpecialtyList' WHERE domain_name = 'qc_hb_specialty';

INSERT INTO `structure_permissible_values_custom_controls` 
(`id`, `name`, `flag_active`) 
VALUES
(null, 'chemotherapy : regimen list', 1);	-- 'qc_hb_chemos_treatment'

SET @last_control_id = LAST_INSERT_ID();

INSERT INTO structure_permissible_values_customs (`control_id`, `value`, `en`, `fr`)
(SELECT @last_control_id, value.value, i18n.en, i18n.fr
FROM structure_value_domains AS dom
LEFT JOIN structure_value_domains_permissible_values AS link ON link.structure_value_domain_id 	= dom.id
LEFT JOIN structure_permissible_values AS value ON value.id = link.structure_permissible_value_id
LEFT JOIN i18n ON i18n.id = value.language_alias
WHERE dom.domain_name LIKE 'qc_hb_chemos_treatment');

DELETE FROM `structure_value_domains_permissible_values` WHERE 	structure_value_domain_id IN (
	SELECT id FROM  `structure_value_domains` 
	WHERE domain_name IN ('qc_hb_chemos_treatment')
);

UPDATE structure_value_domains SET source = 'StructurePermissibleValuesCustom::getDropdownChemoRegimenList' WHERE domain_name = 'qc_hb_chemos_treatment';

UPDATE structure_value_domains SET source = "StructurePermissibleValuesCustom::getCustomDropdown('doctor : speciality list')" WHERE source LIKE '%getDropdownDoctorSpecialtyList%';
UPDATE structure_value_domains SET source = "StructurePermissibleValuesCustom::getCustomDropdown('surgey : surgeon list')" WHERE source LIKE '%getDropdownSurgeonList%';
UPDATE structure_value_domains SET source = "StructurePermissibleValuesCustom::getCustomDropdown('chemotherapy : regimen list')" WHERE source LIKE '%getDropdownChemoRegimenList%';
UPDATE structure_value_domains SET source = "StructurePermissibleValuesCustom::getCustomDropdown('chemotherapy : reason of change')" WHERE source LIKE '%getDropdownChemosChangeReason%';
UPDATE structure_value_domains SET source = "StructurePermissibleValuesCustom::getCustomDropdown('chemotherapy : toxicity')" WHERE source LIKE '%getDropdownChemosToxicity%';
UPDATE structure_value_domains SET source = "StructurePermissibleValuesCustom::getCustomDropdown('surgery: principal surgery')" WHERE source LIKE '%getDropdownPrincipalSurgery%';
UPDATE structure_value_domains SET source = "StructurePermissibleValuesCustom::getCustomDropdown('surgery: associated surgery')" WHERE source LIKE '%getDropdownAssociatedSurgery%';
UPDATE structure_value_domains SET source = "StructurePermissibleValuesCustom::getCustomDropdown('surgery: local treatment type')" WHERE source LIKE '%getDropdownSurgeryLocalTreatment%';
UPDATE structure_value_domains SET source = "StructurePermissibleValuesCustom::getCustomDropdown('surgery: other organ resection')" WHERE source LIKE '%getDropdownOtherOrganResection%';
UPDATE structure_value_domains SET source = "StructurePermissibleValuesCustom::getCustomDropdown('surgery: pathological report')" WHERE source LIKE '%getDropdownSurgeryPathologicalReport%';
UPDATE structure_value_domains SET source = "StructurePermissibleValuesCustom::getCustomDropdown('surgery: type of drain')" WHERE source LIKE '%getDropdownTypeOfDrain%';
UPDATE structure_value_domains SET source = "StructurePermissibleValuesCustom::getCustomDropdown('surgery: type of glue')" WHERE source LIKE '%getDropdownTypeOfGlue%';
UPDATE structure_value_domains SET source = "StructurePermissibleValuesCustom::getCustomDropdown('surgey - liver detail : liver appearance')" WHERE source LIKE '%getDropdownLiverAppearance%';
UPDATE structure_value_domains SET source = "StructurePermissibleValuesCustom::getCustomDropdown('surgey - liver detail : type of vascular occlusion')" WHERE source LIKE '%getDropdownTypeOfVascularOcclusion%';
UPDATE structure_value_domains SET source = "StructurePermissibleValuesCustom::getCustomDropdown('surgey - liver pancreas : pancreas appearance')" WHERE source LIKE '%getDropdownPancreasAppearance%';
UPDATE structure_value_domains SET source = "StructurePermissibleValuesCustom::getCustomDropdown('surgey - liver pancreas : type of pancreas anastomosis')" WHERE source LIKE '%getDropdownTypeOfAnastomosis%';
UPDATE structure_value_domains SET source = "StructurePermissibleValuesCustom::getCustomDropdown('surgey - complication : type')" WHERE source LIKE '%getDropdownSurgeryComplicationList%';
UPDATE structure_value_domains SET source = "StructurePermissibleValuesCustom::getCustomDropdown('surgey - complication : organ list')" WHERE source LIKE '%getDropdownComplicationOrganList%';
UPDATE structure_value_domains SET source = "StructurePermissibleValuesCustom::getCustomDropdown('surgery - complication: treatment')" WHERE source LIKE '%getDropdownSurgeryComplicationTreatment%';

UPDATE structure_formats
SET flag_override_label = '1', language_label = 'participant code'
WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE field = 'participant_identifier');

UPDATE structure_formats
SET language_heading = 'system data', display_column = '3', display_order = '98'
WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE field = 'participant_identifier') AND 
structure_id IN (SELECT id FROM structures WHERE alias = 'participants');
 	
UPDATE structure_formats
SET flag_search = '0', flag_index = '0', flag_detail = '0'
WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE field = 'participant_identifier') AND 
structure_id IN (SELECT id FROM structures WHERE alias IN ('view_aliquot_joined_to_sample_and_collection', 'view_collection', 'view_sample_joined_to_collection'));
 	
INSERT IGNORE INTO i18n (id, en, fr)
VALUES ('system data', 'System Data', 'Données système');

UPDATE i18n SET en = 'Bank Nbr', fr = 'No Banque' WHERE id = 'hepato_bil_bank_participant_id';

UPDATE misc_identifier_controls
SET misc_identifier_name_abbrev = '#', misc_identifier_format = '%%key_increment%%', flag_once_per_participant = '1' 
WHERE misc_identifier_name = 'hepato_bil_bank_participant_id';

-- Consent

INSERT INTO `consent_controls` (`id`, `controls_type`, `flag_active`, `form_alias`, `detail_tablename`, `display_order`) VALUES
(null, 'consent v2010-01-22', 1, 'qc_hb_consents', 'qc_hb_consents', 1);

CREATE TABLE IF NOT EXISTS `qc_hb_consents` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `consent_master_id` int(11) NOT NULL,
  
  `medical_data_access` varchar(5) DEFAULT NULL,  
  `biological_material_collection` varchar(5) DEFAULT NULL,  
  `blood_collection` varchar(5) DEFAULT NULL,  
  `contact_for_additional_info` varchar(5) DEFAULT NULL,  
  `contact_for_additional_questionnaire` varchar(5) DEFAULT NULL,  
   
  `contact_if_news_on_hb` varchar(5) DEFAULT NULL,  
  `allow_research_on_other_disease` varchar(5) DEFAULT NULL,  
  `contact_if_news_on_other_disease` varchar(5) DEFAULT NULL,  
  
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime DEFAULT NULL,
  `modified_by` int(10) unsigned NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `consent_master_id` (`consent_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;


ALTER TABLE `qc_hb_consents`
  ADD CONSTRAINT `qc_hb_consents_ibfk_1` FOREIGN KEY (`consent_master_id`) REFERENCES `consent_masters` (`id`);

CREATE TABLE IF NOT EXISTS `qc_hb_consents_revs` (
  `id` int(11) NOT NULL,
  `consent_master_id` int(11) NOT NULL,
  
  `medical_data_access` varchar(5) DEFAULT NULL,  
  `biological_material_collection` varchar(5) DEFAULT NULL,  
  `blood_collection` varchar(5) DEFAULT NULL,  
  `contact_for_additional_info` varchar(5) DEFAULT NULL,  
  `contact_for_additional_questionnaire` varchar(5) DEFAULT NULL,  
   
  `contact_if_news_on_hb` varchar(5) DEFAULT NULL,  
  `allow_research_on_other_disease` varchar(5) DEFAULT NULL,  
  `contact_if_news_on_other_disease` varchar(5) DEFAULT NULL,  

  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime DEFAULT NULL,
  `modified_by` int(10) unsigned NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

INSERT INTO structures(`alias`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`) 
VALUES 
('qc_hb_consents', '', '', '1', '1', '0', '1');

INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES
('', 'Clinicalannotation', 'ConsentDetail', 'qc_hb_consents', 'medical_data_access', 'allow medical data access', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yesno') , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'ConsentDetail', 'qc_hb_consents', 'biological_material_collection', 'allow biological material collection', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yesno') , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'ConsentDetail', 'qc_hb_consents', 'blood_collection', 'allow blood collection', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yesno') , '', 'open', 'open', 'open'), 

('', 'Clinicalannotation', 'ConsentDetail', 'qc_hb_consents', 'contact_for_additional_info', 'allow to be contacted for additional information', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yesno') , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'ConsentDetail', 'qc_hb_consents', 'contact_for_additional_questionnaire', 'allow to be contacted for additional questionnaire', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yesno') , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'ConsentDetail', 'qc_hb_consents', 'contact_if_news_on_hb', 'to inform when new discovery on hepato-bilary or pancreatic research', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yesno') , '', 'open', 'open', 'open'), 

('', 'Clinicalannotation', 'ConsentDetail', 'qc_hb_consents', 'allow_research_on_other_disease', 'allow research on other disease', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yesno') , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'ConsentDetail', 'qc_hb_consents', 'contact_if_news_on_other_disease', 'to inform when new discovery on other disease', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yesno') , '', 'open', 'open', 'open');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='qc_hb_consents'), 
(SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `field`='consent_status'), 
'0', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'),
((SELECT id FROM structures WHERE alias='qc_hb_consents'), 
(SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `field`='status_date'), 
'0', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'),
((SELECT id FROM structures WHERE alias='qc_hb_consents'), 
(SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `field`='consent_signed_date'), 
'0', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'),

((SELECT id FROM structures WHERE alias='qc_hb_consents'), 
(SELECT id FROM structure_fields WHERE `tablename`='qc_hb_consents' AND `field`='medical_data_access'), 
'0', '10', 'hepato-bilary and pancreatic tumor', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'),
((SELECT id FROM structures WHERE alias='qc_hb_consents'), 
(SELECT id FROM structure_fields WHERE `tablename`='qc_hb_consents' AND `field`='blood_collection'), 
'0', '11', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'),
((SELECT id FROM structures WHERE alias='qc_hb_consents'), 
(SELECT id FROM structure_fields WHERE `tablename`='qc_hb_consents' AND `field`='biological_material_collection'), 
'0', '12', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'),

((SELECT id FROM structures WHERE alias='qc_hb_consents'), 
(SELECT id FROM structure_fields WHERE `tablename`='qc_hb_consents' AND `field`='contact_for_additional_info'), 
'0', '20', 'contact data', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'),
((SELECT id FROM structures WHERE alias='qc_hb_consents'), 
(SELECT id FROM structure_fields WHERE `tablename`='qc_hb_consents' AND `field`='contact_for_additional_questionnaire'), 
'0', '21', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'),
((SELECT id FROM structures WHERE alias='qc_hb_consents'), 
(SELECT id FROM structure_fields WHERE `tablename`='qc_hb_consents' AND `field`='contact_if_news_on_hb'), 
'0', '22', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'),

((SELECT id FROM structures WHERE alias='qc_hb_consents'), 
(SELECT id FROM structure_fields WHERE `tablename`='qc_hb_consents' AND `field`='allow_research_on_other_disease'), 
'0', '30', 'other disease', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'),
((SELECT id FROM structures WHERE alias='qc_hb_consents'), 
(SELECT id FROM structure_fields WHERE `tablename`='qc_hb_consents' AND `field`='contact_if_news_on_other_disease'), 
'0', '31', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'),
 
((SELECT id FROM structures WHERE alias='qc_hb_consents'), 
(SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `field`='notes'), 
'0', '40', 'other', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1');

INSERT IGNORE INTO i18n (id, en, fr)
VALUES 
('allow biological material collection','Allow Biological Material Collection','Autorise la collecte du matériel biologique'),
('allow blood collection','Allow Blood Collection','Autorise la collecte de sang'),
('allow medical data access','Allow Medical Data Access','Autorise l''accès au dossier médical'),
('allow research on other disease','Allow Research On Other Disease','Autorise la recherche sur d''autres maladies'),
('allow to be contacted for additional information','Allow To Be Contacted For Additional Information','Peut être contacté pour des renseignements supplémentaires'),
('allow to be contacted for additional questionnaire','Allow To Be Contacted For Additional Questionnaire','Peut être contacté pour d''autres questionnaires'),
('consent v2010-01-22','Consent v2010-01-22','Consentement v2010-01-22'),
('contact data','Contacts',''),
('hepato-bilary and pancreatic tumor','Hepato-Bilary And Pancreatic Tumor','Tumeur hépato-biliaire et pancréatique'),
('other disease','Other Disease','Autre malade'),
('to inform when new discovery on hepato-bilary or pancreatic research','To Inform When New Discovery On H.B or Panc. Reasearch','Informer lors de nouvelles découvertes en recherche sur H.B ou Panc.'),
('to inform when new discovery on other disease','To Inform When New Discovery On Other Disease','Informer lors de nouvelles découvertes en recherche sur autres maladies');

DROP TABLE IF EXISTS qc_hb_hepatobiliary_medical_past_history_ctrls;
DELETE FROM structure_formats WHERE `structure_field_id` = (SELECT id FROM structure_fields WHERE tablename = 'qc_hb_ed_hepatobiliary_medical_past_history' AND field LIKE 'disease_precision');
DELETE FROM structure_validations WHERE `structure_field_id` = (SELECT id FROM structure_fields WHERE tablename = 'qc_hb_ed_hepatobiliary_medical_past_history' AND field LIKE 'disease_precision');
DELETE  FROM structure_fields WHERE tablename = 'qc_hb_ed_hepatobiliary_medical_past_history' AND field LIKE 'disease_precision';

ALTER TABLE qc_hb_ed_hepatobiliary_medical_past_history
  ADD `who_icd10_code` varchar(50) DEFAULT NULL AFTER `event_master_id`,
  DROP `disease_precision`;
ALTER TABLE qc_hb_ed_hepatobiliary_medical_past_history_revs
  ADD `who_icd10_code` varchar(50) DEFAULT NULL AFTER `event_master_id`,
  DROP `disease_precision`;

INSERT INTO `structure_fields` (`id`, `public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, '', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobiliary_medical_past_history', 'who_icd10_code', 'precision', '', 'autocomplete', 'size=10,url=/codingicd/CodingIcd10s/autocomplete/who,tool=/codingicd/CodingIcd10s/tool/who', '', NULL, 'help_cod_icd10_code', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0);
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='qc_hb_ed_hepatobiliary_medical_past_history'), 
(SELECT id FROM structure_fields WHERE tablename = 'qc_hb_ed_hepatobiliary_medical_past_history' AND field LIKE 'who_icd10_code'), 
'0', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'); 

INSERT INTO `event_controls` (`id`, `disease_site`, `event_group`, `event_type`, `flag_active`, `form_alias`, `detail_tablename`, `display_order`) VALUES
(null, 'hepatobiliary', 'clinical', 'other cancer medical past history', 1, 'qc_hb_ed_hepatobiliary_medical_past_history', 'qc_hb_ed_hepatobiliary_medical_past_history', 0);

INSERT IGNORE INTO i18n (id, en, fr)
VALUES 
('other cancer medical past history', 'Other Cancer', 'Autre Cancer');

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_add = '0', sfo.flag_add_readonly = '0', 
sfo.flag_edit = '0', sfo.flag_edit_readonly = '0',
sfo.flag_datagrid = '0',sfo.flag_datagrid_readonly = '0',
sfo.flag_search = '0', sfo.flag_search_readonly = '0',
sfo.flag_index = '0', sfo.flag_detail = '0'
WHERE sfi.field IN ('previous_primary_code_system', 'previous_primary_code') AND sfi.model = 'FamilyHistory' 
AND str.alias LIKE 'familyhistories'
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

INSERT INTO `structure_permissible_values_custom_controls` (`id`, `name`, `flag_active`) VALUES
(null, 'hepatitis treatment', '1'),
(null, 'type of hepatitis', '1');
UPDATE structure_value_domains SET source = 'StructurePermissibleValuesCustom::getCustomDropdown(''hepatitis treatment'')' WHERE domain_name = 'hepatitis_treatment';
UPDATE structure_value_domains SET source = 'StructurePermissibleValuesCustom::getCustomDropdown(''type of hepatitis'')' WHERE domain_name = 'type_of_hepatitis';

INSERT INTO `structure_permissible_values_custom_controls` (`id`, `name`, `flag_active`) VALUES
(null, 'cirrhosis type', '1');
UPDATE structure_value_domains SET source = 'StructurePermissibleValuesCustom::getCustomDropdown(''cirrhosis type'')' WHERE domain_name = 'cirrhosis_type';
 
UPDATE `tx_controls`
	SET extended_data_import_process = 'importDrugFromChemoProtocol' WHERE tx_method = 'chemotherapy' AND disease_site = 'hepatobiliary';
UPDATE `tx_controls`
	SET flag_active = '0' WHERE tx_method = 'surgery without extend' AND disease_site = 'all';

UPDATE structure_fields SET type = 'integer_positive' WHERE tablename = 'qc_hb_txd_surgery_livers' AND field IN 
('operative_time', 'operative_bleeding', 'rbc_units', 'plasma_units', 'platelets_units', 'resected_liver_weight');
UPDATE structure_fields SET type = 'integer_positive' WHERE tablename = 'qc_hb_txd_surgery_pancreas' AND field IN 
('operative_time', 'operative_bleeding', 'rbc_units', 'plasma_units', 'platelets_units', 'resected_liver_weight', 'wisung_diameter', 'gastric_tube_duration_in_days');

INSERT IGNORE INTO i18n (id, en)
VALUES 
('pancreas appearance', 'Pancreas Appearance'),
('wisung diameter', 'Wisung Diameter'),
('recoupe pancreas', 'Recoupe Pancreas'),
('portal vein resection', 'Portal Vein resection'),
('pancreas anastomosis', 'Pancreas Anastomosis'),
('type of pancreas anastomosis', 'Type of Pancreas Anastomosis'),
('pylori preservation', 'Pylori Preservation'),
('portacaval gradient', 'Portacaval Gradient'),
('clavien score', 'Clavien Score'),
('preoperative sandostatin', 'Preoperative Sandostatin');

UPDATE structure_permissible_values_custom_controls SET name = 'surgey - liver pancreas : anastomosis type' 
WHERE name like 'surgey - liver pancreas : type of pancreas anastom%';
UPDATE structure_value_domains SET source = 'StructurePermissibleValuesCustom::getCustomDropdown(''surgey - liver pancreas : anastomosis type'')' WHERE domain_name = 'qc_hb_tx_surgery_pancreas_type_of_anastomosis';

DROP TABLE IF EXISTS qc_hb_surgery_complication_treatments;
DROP TABLE IF EXISTS  qc_hb_surgery_complication_treatments_revs;

DELETE FROM structure_formats WHERE structure_id = (SELECT id FROM structures WHERE alias = 'qc_hb_surgery_complication_treatments');
DELETE FROM structures WHERE alias = 'qc_hb_surgery_complication_treatments';
DELETE FROM structure_validations WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE model = 'SurgeryComplicationTreatment');
DELETE FROM structure_fields WHERE model = 'SurgeryComplicationTreatment'; 

ALTER TABLE qc_hb_txe_surgery_complications
  ADD `other_type_from_icd10_who` varchar(50) DEFAULT NULL AFTER `type`,
  
  ADD `treatment_1_date` date DEFAULT NULL AFTER `organ_precision`,
  ADD `treatment_1` varchar(50) DEFAULT NULL AFTER `treatment_1_date`,
  ADD `treatment_1_other_specify` varchar(250) DEFAULT NULL AFTER `treatment_1`,
 
  ADD `treatment_2_date` date DEFAULT NULL AFTER `treatment_1_other_specify`,
  ADD `treatment_2` varchar(50) DEFAULT NULL AFTER `treatment_2_date`,
  ADD `treatment_2_other_specify` varchar(250) DEFAULT NULL AFTER `treatment_2`,
 
  ADD `treatment_3_date` date DEFAULT NULL AFTER `treatment_2_other_specify`,
  ADD `treatment_3` varchar(50) DEFAULT NULL AFTER `treatment_3_date`,
  ADD `treatment_3_other_specify` varchar(250) DEFAULT NULL AFTER `treatment_3`;
ALTER TABLE qc_hb_txe_surgery_complications_revs
  ADD `other_type_from_icd10_who` varchar(50) DEFAULT NULL AFTER `type`,
  
  ADD `treatment_1_date` date DEFAULT NULL AFTER `organ_precision`,
  ADD `treatment_1` varchar(50) DEFAULT NULL AFTER `treatment_1_date`,
  ADD `treatment_1_other_specify` varchar(250) DEFAULT NULL AFTER `treatment_1`,
 
  ADD `treatment_2_date` date DEFAULT NULL AFTER `treatment_1_other_specify`,
  ADD `treatment_2` varchar(50) DEFAULT NULL AFTER `treatment_2_date`,
  ADD `treatment_2_other_specify` varchar(250) DEFAULT NULL AFTER `treatment_2`,
 
  ADD `treatment_3_date` date DEFAULT NULL AFTER `treatment_2_other_specify`,
  ADD `treatment_3` varchar(50) DEFAULT NULL AFTER `treatment_3_date`,
  ADD `treatment_3_other_specify` varchar(250) DEFAULT NULL AFTER `treatment_3`;  

INSERT INTO structure_value_domains (domain_name, source) VALUES 
('qc_hb_surgery_complication_treatment', 'StructurePermissibleValuesCustom::getCustomDropdown(''surgery: complication treatment'')');
INSERT INTO `structure_permissible_values_custom_controls` (`id`, `name`, `flag_active`) VALUES
(null, 'surgery: complication treatment', '1');

INSERT INTO `structure_fields` (`id`, `public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES
(null, '', 'Clinicalannotation', 'TreatmentExtend', 'qc_hb_txe_surgery_complications', 'other_type_from_icd10_who', 'other type precision', '', 'autocomplete', 'size=10,url=/codingicd/CodingIcd10s/autocomplete/who,tool=/codingicd/CodingIcd10s/tool/who', '', NULL, 'help_cod_icd10_code', 'open', 'open', 'open'),

(null, '', 'Clinicalannotation', 'TreatmentExtend', 'qc_hb_txe_surgery_complications', 'treatment_1_date', 'surgery complication treatment 1 date', '', 'date', '', '', NULL, '', 'open', 'open', 'open'),
(null, '', 'Clinicalannotation', 'TreatmentExtend', 'qc_hb_txe_surgery_complications', 'treatment_1', 'surgery complication treatment 1', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name = 'qc_hb_surgery_complication_treatment'), '', 'open', 'open', 'open'),
(null, '', 'Clinicalannotation', 'TreatmentExtend', 'qc_hb_txe_surgery_complications', 'treatment_1_other_specify', 'other surgery complication treatment 1', '', 'input', 'size=10', '', NULL, '', 'open', 'open', 'open'),

(null, '', 'Clinicalannotation', 'TreatmentExtend', 'qc_hb_txe_surgery_complications', 'treatment_2_date', 'surgery complication treatment 2 date', '', 'date', '', '', NULL, '', 'open', 'open', 'open'),
(null, '', 'Clinicalannotation', 'TreatmentExtend', 'qc_hb_txe_surgery_complications', 'treatment_2', 'surgery complication treatment 2', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name = 'qc_hb_surgery_complication_treatment'), '', 'open', 'open', 'open'),
(null, '', 'Clinicalannotation', 'TreatmentExtend', 'qc_hb_txe_surgery_complications', 'treatment_2_other_specify', 'other surgery complication treatment 2', '', 'input', 'size=10', '', NULL, '', 'open', 'open', 'open'),

(null, '', 'Clinicalannotation', 'TreatmentExtend', 'qc_hb_txe_surgery_complications', 'treatment_3_date', 'surgery complication treatment 3 date', '', 'date', '', '', NULL, '', 'open', 'open', 'open'),
(null, '', 'Clinicalannotation', 'TreatmentExtend', 'qc_hb_txe_surgery_complications', 'treatment_3', 'surgery complication treatment 3', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name = 'qc_hb_surgery_complication_treatment'), '', 'open', 'open', 'open'),
(null, '', 'Clinicalannotation', 'TreatmentExtend', 'qc_hb_txe_surgery_complications', 'treatment_3_other_specify', 'other surgery complication treatment 3', '', 'input', 'size=10', '', NULL, '', 'open', 'open', 'open');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='qc_hb_txe_surgery_complications'), 
(SELECT id FROM structure_fields WHERE tablename = 'qc_hb_txe_surgery_complications' AND field LIKE 'other_type_from_icd10_who'), 
'0', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'),

((SELECT id FROM structures WHERE alias='qc_hb_txe_surgery_complications'), 
(SELECT id FROM structure_fields WHERE tablename = 'qc_hb_txe_surgery_complications' AND field LIKE 'treatment_1_date'), 
'1', '10', 'treatment 1', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='qc_hb_txe_surgery_complications'), 
(SELECT id FROM structure_fields WHERE tablename = 'qc_hb_txe_surgery_complications' AND field LIKE 'treatment_1'), 
'1', '11', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='qc_hb_txe_surgery_complications'), 
(SELECT id FROM structure_fields WHERE tablename = 'qc_hb_txe_surgery_complications' AND field LIKE 'treatment_1_other_specify'), 
'1', '12', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 

((SELECT id FROM structures WHERE alias='qc_hb_txe_surgery_complications'), 
(SELECT id FROM structure_fields WHERE tablename = 'qc_hb_txe_surgery_complications' AND field LIKE 'treatment_2_date'), 
'1', '13', 'treatment 2', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='qc_hb_txe_surgery_complications'), 
(SELECT id FROM structure_fields WHERE tablename = 'qc_hb_txe_surgery_complications' AND field LIKE 'treatment_2'), 
'1', '14', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='qc_hb_txe_surgery_complications'), 
(SELECT id FROM structure_fields WHERE tablename = 'qc_hb_txe_surgery_complications' AND field LIKE 'treatment_2_other_specify'), 
'1', '15', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 

((SELECT id FROM structures WHERE alias='qc_hb_txe_surgery_complications'), 
(SELECT id FROM structure_fields WHERE tablename = 'qc_hb_txe_surgery_complications' AND field LIKE 'treatment_3_date'), 
'1', '16', 'treatment 3', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='qc_hb_txe_surgery_complications'), 
(SELECT id FROM structure_fields WHERE tablename = 'qc_hb_txe_surgery_complications' AND field LIKE 'treatment_3'), 
'1', '17', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='qc_hb_txe_surgery_complications'), 
(SELECT id FROM structure_fields WHERE tablename = 'qc_hb_txe_surgery_complications' AND field LIKE 'treatment_3_other_specify'), 
'1', '18', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1');

INSERT IGNORE INTO i18n (id, en)
VALUES 
('organ precision','Organ Precision'),
('other type precision','Other Precision'),

('treatment 1','Treatment 1'),
('surgery complication treatment 1','Treatment'),
('surgery complication treatment 1 date','Date'),
('other surgery complication treatment 1','Other Treatment'),

('treatment 2','Treatment 2'),
('surgery complication treatment 2','Treatment'),
('surgery complication treatment 2 date','Date'),
('other surgery complication treatment 2','Other Treatment'),

('treatment 3','Treatment 3'),
('surgery complication treatment 3','Treatment'),
('surgery complication treatment 3 date','Date'),
('other surgery complication treatment 3','Other Treatment'),

('drugs', 'Drugs'),
('complications', 'Complications');

UPDATE structure_value_domains SET source = 'StructurePermissibleValuesCustom::getCustomDropdown(''liver metastasis : hitologic type'')'
WHERE domain_name = 'qc_hb_liver_metastasis_hitologic_type';
INSERT INTO `structure_permissible_values_custom_controls` (`id`, `name`, `flag_active`) VALUES
(null, 'liver metastasis : hitologic type', '1');

INSERT INTO structure_value_domains (domain_name, source) VALUES 
('qc_hb_liver_metastasis_tumor_site', 'StructurePermissibleValuesCustom::getCustomDropdown(''liver metastasis : tumor site'')');
INSERT INTO `structure_permissible_values_custom_controls` (`id`, `name`, `flag_active`) VALUES
(null, 'liver metastasis : tumor site', '1');
UPDATE structure_fields SET structure_value_domain = (SELECT id FROM structure_value_domains WHERE domain_name = 'qc_hb_liver_metastasis_tumor_site')
WHERE tablename = 'dxd_liver_metastases' AND field = 'tumor_site';

DELETE FROM `i18n` WHERE `id` IN ('health_insurance_card', 'saint_luc_hospital_nbr', 'hepato_bil_bank_participant_id');
INSERT IGNORE INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('health_insurance_card', 'global', 'RAMQ', 'RAMQ'),
('saint_luc_hospital_nbr', 'global', 'St-Luc Hospital Number', 'No Hôpital St-Luc'),
('hepato_bil_bank_participant_id', 'global', 'Bank Nbr', 'No Banque');

UPDATE structure_formats sfo INNER JOIN structure_fields sfi INNER JOIN structures s
SET sfo.flag_add = '0', sfo.flag_add_readonly = '0', 
sfo.flag_edit = '0', sfo.flag_edit_readonly = '0', 
sfo.flag_search = '0', sfo.flag_search_readonly = '0', 
sfo.flag_datagrid = '0', sfo.flag_datagrid_readonly = '0', 
sfo.flag_index = '0', sfo.flag_detail = '0'
WHERE sfi.id = sfo.structure_field_id
AND sfo.structure_id = s.id
AND sfi.plugin = 'Clinicalannotation'
AND sfi.model = 'MiscIdentifier'
AND sfi.field  = 'identifier_abrv'
AND s.alias IN ('incrementedmiscidentifiers', 'miscidentifiers', 'miscidentifiers_for_participant_search'); 

UPDATE structure_formats sfo INNER JOIN structure_fields sfi INNER JOIN structures s
SET sfo.flag_add = '0', sfo.flag_add_readonly = '0', 
sfo.flag_edit = '0', sfo.flag_edit_readonly = '0', 
sfo.flag_search = '0', sfo.flag_search_readonly = '0', 
sfo.flag_datagrid = '0', sfo.flag_datagrid_readonly = '0', 
sfo.flag_index = '0', sfo.flag_detail = '0'
WHERE sfi.id = sfo.structure_field_id
AND sfo.structure_id = s.id
AND sfi.model = 'AliquotDetail'
AND sfi.field  = 'lot_number'
AND s.alias LIKE 'ad_%'; 

UPDATE structure_formats sfo INNER JOIN structure_fields sfi INNER JOIN structures s
SET sfo.flag_override_label = '1', sfo.language_label = 'sample code'
WHERE sfi.id = sfo.structure_field_id
AND sfo.structure_id = s.id
AND sfi.field  = 'sample_code';

UPDATE i18n SET en = 'Sample System Code', fr = 'Code systême échantillon' WHERE id = 'sample code';
	 	
UPDATE structure_formats sfo INNER JOIN structure_fields sfi INNER JOIN structures s
SET sfo.flag_override_label = '1', sfo.language_label = 'aliquot code'
WHERE sfi.id = sfo.structure_field_id
AND sfo.structure_id = s.id
AND sfi.field  = 'barcode'
AND model IN ('AliquotMaster', 'ViewAliquot');

INSERT IGNORE INTO i18n (id,en,fr) 
VALUES 
('aliquot code','Aliquot System Code','Code systême aliquot'),
('qc hb label', 'Label', 'Étiquette');

UPDATE structure_fields SET model = 'SampleDetail' WHERE field IN ('qc_hb_nb_cells', 'qc_hb_nb_cell_unit');

ALTER TABLE sd_der_pbmcs
  MODIFY `qc_hb_nb_cells` float unsigned;
ALTER TABLE `sd_der_pbmcs_revs` ADD `qc_hb_nb_cells` FLOAT UNSIGNED,
ADD `qc_hb_nb_cell_unit` VARCHAR( 50 ) NOT NULL DEFAULT '';
    
UPDATE storage_controls SET flag_active = '0' WHERE storage_type NOT IN (  
'room','cupboard','nitrogen locator','fridge','freezer','box','box81','rack16',
'rack10','rack24','shelf','rack11','rack9','ice');

INSERT INTO `storage_controls` (`id`, `storage_type`, `storage_type_code`, `coord_x_title`, `coord_x_type`, `coord_x_size`, `coord_y_title`, `coord_y_type`, `coord_y_size`, 
`display_x_size`, `display_y_size`, `reverse_x_numbering`, `reverse_y_numbering`, `horizontal_increment`, 
`set_temperature`, `is_tma_block`, `flag_active`, `form_alias`, `form_alias_for_children_pos`, `detail_tablename`, `databrowser_label`) 
VALUES
(null, 'box27', 'B27', 'position', 'integer', 27, NULL, NULL, NULL, 
3, 9, 0, 0, 1, 
'FALSE', 'FALSE', 1, 'std_undetail_stg_with_surr_tmp', 'std_1_dim_position_selection', 'std_boxs', 'box27'),
(null, 'box100', 'B100', 'position', 'integer', 100, NULL, NULL, NULL, 
10, 10, 0, 0, 1, 
'FALSE', 'FALSE', 1, 'std_undetail_stg_with_surr_tmp', 'std_1_dim_position_selection', 'std_boxs', 'box100');
 
UPDATE structure_formats sfo INNER JOIN structure_fields sfi INNER JOIN structures s
SET sfo.flag_edit_readonly = '1'
WHERE sfi.id = sfo.structure_field_id
AND sfo.structure_id = s.id
AND sfi.field  = 'qc_hb_label'
AND sfo.flag_edit = '1' AND sfo.flag_edit_readonly = '0'; 

SET @structure_id = ( SELECT id FROM structures WHERE alias='ad_spec_conical_tubes');
DELETE FROM structure_formats WHERE structure_id = @structure_id;
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) 
SELECT @structure_id, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`
FROM structure_formats WHERE structure_id = (SELECT id FROM structures WHERE alias='ad_spec_tubes');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='ad_spec_conical_tubes'), 
(SELECT id FROM structure_fields WHERE tablename = 'ad_tubes' AND field LIKE 'qc_hb_milieu' AND structure_value_domain = (SELECT id FROM structure_value_domains WHERE domain_name = 'qc_hb_conical_tube_milieu')), 
'0', '16', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '1');
 
UPDATE sample_to_aliquot_controls as link,sample_controls AS samp,aliquot_controls AS al
SET link.flag_active = '0'
WHERE samp.id = link.sample_control_id
AND al.id = link.aliquot_control_id
AND al.form_alias = 'ad_spec_tubes'
AND samp.sample_type = 'tissue';

UPDATE aliquot_controls SET form_alias = 'ad_spec_qc_hb_tissue_tubes', aliquot_type = 'tube', databrowser_label = 'tube', aliquot_type_precision = 'tissue'
WHERE form_alias = 'ad_spec_conical_tubes';

UPDATE structures SET alias = 'ad_spec_qc_hb_tissue_tubes' WHERE alias = 'ad_spec_conical_tubes';

ALTER TABLE `ad_tubes` ADD `qc_hb_is_conic_tube` tinyint(3) unsigned NOT NULL DEFAULT '0';
ALTER TABLE `ad_tubes_revs` ADD `qc_hb_is_conic_tube` tinyint(3) unsigned NOT NULL DEFAULT '0';

INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES
('', 'Inventorymanagement', 'AliquotDetail', 'ad_tubes', 'qc_hb_is_conic_tube', 'conic tube', '', 'checkbox', '', '',  (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '', 'open', 'open', 'open'); 

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='ad_spec_qc_hb_tissue_tubes'), 
(SELECT id FROM structure_fields WHERE tablename = 'ad_tubes' AND field LIKE 'qc_hb_is_conic_tube'), 
'0', '15', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '1');

INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('box100', '', 'Box100 1-100', 'Boîte100 1-100'),
('box27', '', 'Box27 1-27', 'Boîte27 1-27'),
('conic tube', '', 'Conic Tube', 'Tube conique');

ALTER TABLE dxd_liver_metastases_revs ADD `version_created` datetime NOT NULL AFTER `version_id`;
ALTER TABLE dxd_liver_metastases  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
ALTER TABLE ed_score_child_pugh MODIFY `event_master_id` int(11) NOT NULL;
ALTER TABLE ed_score_child_pugh_revs MODIFY `event_master_id` int(11) NOT NULL;
ALTER TABLE qc_hb_ed_hepatobilary_lab_report_biology  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
ALTER TABLE qc_hb_ed_hepatobilary_lab_report_biology_revs  MODIFY `id` int(11) NOT NULL ;
ALTER TABLE qc_hb_ed_hepatobilary_medical_imagings  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
ALTER TABLE qc_hb_ed_hepatobilary_medical_imagings_revs  MODIFY `id` int(11) NOT NULL ;
ALTER TABLE qc_hb_txd_portal_vein_embolizations  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
ALTER TABLE qc_hb_txd_portal_vein_embolizations_revs  MODIFY `id` int(11) NOT NULL ;
ALTER TABLE qc_hb_txd_surgery_livers  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
ALTER TABLE qc_hb_txd_surgery_livers_revs  MODIFY `id` int(11) NOT NULL ;
ALTER TABLE qc_hb_ed_hepatobiliary_medical_past_history_cirrhosis MODIFY `event_master_id` int(11) NOT NULL;
ALTER TABLE qc_hb_ed_hepatobiliary_medical_past_history_cirrhosis_revs MODIFY `event_master_id` int(11) NOT NULL;
ALTER TABLE qc_hb_txd_surgery_pancreas  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
ALTER TABLE qc_hb_txd_surgery_pancreas_revs  MODIFY `id` int(11) NOT NULL ;
ALTER TABLE sd_der_pbmcs  MODIFY `qc_hb_nb_cells` float unsigned DEFAULT NULL;
ALTER TABLE sd_der_pbmcs_revs  MODIFY `qc_hb_nb_cells` float unsigned DEFAULT NULL;

UPDATE structure_formats sfo INNER JOIN structure_fields sfi INNER JOIN structures s
SET sfo.flag_add = '0', sfo.flag_add_readonly = '0', 
sfo.flag_edit = '0', sfo.flag_edit_readonly = '0', 
sfo.flag_search = '0', sfo.flag_search_readonly = '0', 
sfo.flag_datagrid = '0', sfo.flag_datagrid_readonly = '0', 
sfo.flag_index = '0', sfo.flag_detail = '0'
WHERE sfi.id = sfo.structure_field_id
AND sfo.structure_id = s.id
AND sfi.model IN ('AliquotMaster', 'TmaSlide', 'SampleMaster', 'Collection', 'StorageDetail', 'ViewCollection')
AND sfi.field  = 'sop_master_id'; 

UPDATE specimen_review_controls SET flag_active = '0';

UPDATE protocol_controls SET flag_active = '0' WHERE type != 'chemotherapy';

UPDATE structure_formats sfo INNER JOIN structure_fields sfi INNER JOIN structures s
SET sfo.flag_add = '0', sfo.flag_add_readonly = '0', 
sfo.flag_edit = '0', sfo.flag_edit_readonly = '0', 
sfo.flag_search = '0', sfo.flag_search_readonly = '0', 
sfo.flag_datagrid = '0', sfo.flag_datagrid_readonly = '0', 
sfo.flag_index = '0', sfo.flag_detail = '0'
WHERE sfi.id = sfo.structure_field_id
AND sfo.structure_id = s.id
AND sfi.model = 'StudySummary'
AND sfi.field  NOT IN ('title', 'start_date', 'end_date', 'summary')
AND s.alias = 'studysummaries'; 

UPDATE structure_formats sfo INNER JOIN structure_fields sfi INNER JOIN structures s
SET sfo.flag_add = '0', sfo.flag_add_readonly = '0', 
sfo.flag_edit = '0', sfo.flag_edit_readonly = '0', 
sfo.flag_search = '0', sfo.flag_search_readonly = '0', 
sfo.flag_datagrid = '0', sfo.flag_datagrid_readonly = '0', 
sfo.flag_index = '0', sfo.flag_detail = '0'
WHERE sfi.id = sfo.structure_field_id
AND sfo.structure_id = s.id
AND sfi.model = 'Generated'
AND sfi.field IN ('field1')
AND s.alias = 'collections'; 

UPDATE structure_formats sfo INNER JOIN structure_fields sfi INNER JOIN structures s
SET sfo.flag_add = '0', sfo.flag_add_readonly = '0', 
sfo.flag_edit = '0', sfo.flag_edit_readonly = '0', 
sfo.flag_search = '0', sfo.flag_search_readonly = '0', 
sfo.flag_datagrid = '0', sfo.flag_datagrid_readonly = '0', 
sfo.flag_index = '0', sfo.flag_detail = '0'
WHERE sfi.id = sfo.structure_field_id
AND sfo.structure_id = s.id
AND sfi.model = 'SampleDetail'
AND sfi.field IN ('tissue_laterality'); 
		 
UPDATE  structure_fields
SET setting = 'size=40'
WHERE field = 'qc_hb_label';

UPDATE i18n SET en = 'Collection/Resection Date', fr = 'Date de prélèvement/résection' WHERE id = 'collection datetime';
UPDATE i18n SET en = 'Collection/Resection to Creation Spent Time', fr = 'Temps écoulé entre prélèvement/résection et création' WHERE id = 'collection to creation spent time';
UPDATE i18n SET en = 'Collection/Resection to Reception Spent Time', fr = 'Temps écoulé entre prélèvement/résection et réception' WHERE id = 'collection to reception spent time';
UPDATE i18n SET en = 'Collection/Resection to Storage Spent Time', fr = 'Temps écoulé entre prélèvement/résection et entreposage' WHERE id = 'collection to storage spent time';

UPDATE i18n SET en = 'Collection/Resection to Acquisition Spent Time', fr = 'Temps écoulé entre prélèvement/résection et acquisition' WHERE id = 'collection to reception spent time';
UPDATE i18n SET en = 'Acquisition Date', fr = 'Date d''acquisition' WHERE id = 'reception date';
UPDATE i18n SET en = 'Acquisition to Storage Spent Time', fr = 'Temps écoulé entre la acquisition et l''entreposage' WHERE id = 'reception to storage spent time';

UPDATE `storage_controls` SET `horizontal_increment` = '0' WHERE `storage_type` = 'box27';

-----------------------------------------------------------------------
- TASKS TODO BEFORE GO LIVE -

- UPDATE PERMISSION: NO ACCESS TO FORMS, MATERIAL, EQUIP., SOP, LIMITED ACCESS TO STUDY
- REVIEW ALL FLAG_SEARCH FLAG_INDEX FOR DATABROWSER (INCLUDING MASTER/DETAIL MODEL)
- RUN DB VALIDATION
- COMPARE CODE WITH TRUNK
,