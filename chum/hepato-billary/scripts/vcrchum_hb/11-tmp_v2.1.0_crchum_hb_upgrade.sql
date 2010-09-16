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
`misc_identifiers`.`identifier_value` AS no_labo  
FROM (((`collections` `col` 
LEFT JOIN `clinical_collection_links` `link` ON(((`col`.`id` = `link`.`collection_id`) AND (`link`.`deleted` <> 1)))) 
LEFT JOIN `participants` `part` ON(((`link`.`participant_id` = `part`.`id`) AND (`part`.`deleted` <> 1)))) 
LEFT JOIN `banks` ON(((`col`.`bank_id` = `banks`.`id`) AND (`banks`.`deleted` <> 1)))) 
LEFT JOIN `misc_identifiers` ON part.id=misc_identifiers.participant_id AND (misc_identifiers.misc_identifier_control_id=3 AND col.bank_id=1)
WHERE (`col`.`deleted` <> 1);

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

UPDATE `qc_chum_hb`.`users` SET `flag_active` = '1' WHERE `users`.`id` =1;

TRUNCATE structure_permissible_values_customs;
TRUNCATE structure_permissible_values_customs_revs;

INSERT INTO `structure_permissible_values_customs` (`id`, `control_id`, `value`, `en`, `fr`, `created`, `created_by`, `modified`, `modified_by`, `deleted`, `deleted_date`) VALUES
(null, (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'laboratory staff'), 'urszula krzemien', 'Urszula Krzemien', 'Urszula Krzemien', '0000-00-00 00:00:00', 0, NULL, 0, 0, NULL),
(null, (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'laboratory sites'), 'ICM', 'ICM', 'ICM', '0000-00-00 00:00:00', 0, NULL, 0, 0, NULL),
(null, (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'specimen collection sites'), 'saint-luc hospital', 'Saint-Luc Hospital', 'H�pital Saint-Luc', '0000-00-00 00:00:00', 0, NULL, 0, 0, NULL),
(null, (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'specimen supplier departments'), 'operating room', 'Operating Room', 'Salle d''op�ration', '0000-00-00 00:00:00', 0, NULL, 0, 0, NULL),
(null, (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'specimen supplier departments'), 'pathology', 'Pathology', 'Pathologie', '0000-00-00 00:00:00', 0, NULL, 0, 0, NULL),
(null, (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'specimen supplier departments'), 'preadmission = preoperative checkup', 'Preadmission (Preoperative Checkup)', 'Pr�admission (bilan pr�op�ratoire)', '0000-00-00 00:00:00', 0, NULL, 0, 0, NULL),
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

UPDATE structure_value_domains SET source = 'StructurePermissibleValuesCustom::getCustomDropdown('doctor : speciality list')' WHERE source LIKE '%getDropdownDoctorSpecialtyList%';
UPDATE structure_value_domains SET source = 'StructurePermissibleValuesCustom::getCustomDropdown('surgey : surgeon list')' WHERE source LIKE '%getDropdownSurgeonList%';
UPDATE structure_value_domains SET source = 'StructurePermissibleValuesCustom::getCustomDropdown('chemotherapy : regimen list')' WHERE source LIKE '%getDropdownChemoRegimenList%';
UPDATE structure_value_domains SET source = 'StructurePermissibleValuesCustom::getCustomDropdown('chemotherapy : reason of change')' WHERE source LIKE '%getDropdownChemosChangeReason%';
UPDATE structure_value_domains SET source = 'StructurePermissibleValuesCustom::getCustomDropdown('chemotherapy : toxicity')' WHERE source LIKE '%getDropdownChemosToxicity%';
UPDATE structure_value_domains SET source = 'StructurePermissibleValuesCustom::getCustomDropdown('surgery: principal surgery')' WHERE source LIKE '%getDropdownPrincipalSurgery%';
UPDATE structure_value_domains SET source = 'StructurePermissibleValuesCustom::getCustomDropdown('surgery: associated surgery')' WHERE source LIKE '%getDropdownAssociatedSurgery%';
UPDATE structure_value_domains SET source = 'StructurePermissibleValuesCustom::getCustomDropdown('surgery: local treatment type')' WHERE source LIKE '%getDropdownSurgeryLocalTreatment%';
UPDATE structure_value_domains SET source = 'StructurePermissibleValuesCustom::getCustomDropdown('surgery: other organ resection')' WHERE source LIKE '%getDropdownOtherOrganResection%';
UPDATE structure_value_domains SET source = 'StructurePermissibleValuesCustom::getCustomDropdown('surgery: pathological report')' WHERE source LIKE '%getDropdownSurgeryPathologicalReport%';
UPDATE structure_value_domains SET source = 'StructurePermissibleValuesCustom::getCustomDropdown('surgery: type of drain')' WHERE source LIKE '%getDropdownTypeOfDrain%';
UPDATE structure_value_domains SET source = 'StructurePermissibleValuesCustom::getCustomDropdown('surgery: type of glue')' WHERE source LIKE '%getDropdownTypeOfGlue%';
UPDATE structure_value_domains SET source = 'StructurePermissibleValuesCustom::getCustomDropdown('surgey - liver detail : liver appearance')' WHERE source LIKE '%getDropdownLiverAppearance%';
UPDATE structure_value_domains SET source = 'StructurePermissibleValuesCustom::getCustomDropdown('surgey - liver detail : type of vascular occlusion')' WHERE source LIKE '%getDropdownTypeOfVascularOcclusion%';
UPDATE structure_value_domains SET source = 'StructurePermissibleValuesCustom::getCustomDropdown('surgey - liver pancreas : pancreas appearance')' WHERE source LIKE '%getDropdownPancreasAppearance%';
UPDATE structure_value_domains SET source = 'StructurePermissibleValuesCustom::getCustomDropdown('surgey - liver pancreas : type of pancreas anastomosis')' WHERE source LIKE '%getDropdownTypeOfAnastomosis%';
UPDATE structure_value_domains SET source = 'StructurePermissibleValuesCustom::getCustomDropdown('surgey - complication : type')' WHERE source LIKE '%getDropdownSurgeryComplicationList%';
UPDATE structure_value_domains SET source = 'StructurePermissibleValuesCustom::getCustomDropdown('surgey - complication : organ list')' WHERE source LIKE '%getDropdownComplicationOrganList%';
UPDATE structure_value_domains SET source = 'StructurePermissibleValuesCustom::getCustomDropdown('surgery - complication: treatment')' WHERE source LIKE '%getDropdownSurgeryComplicationTreatment%';









