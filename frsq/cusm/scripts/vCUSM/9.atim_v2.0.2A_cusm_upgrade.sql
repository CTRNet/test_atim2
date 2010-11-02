
DELETE FROM structure_formats 
WHERE structure_id = (SELECT id FROM structures WHERE alias = 'qc_cusm_dxd_procure') 
AND structure_field_id = (SELECT id FROM structure_fields WHERE field = 'morphology');

DELETE FROM `i18n` WHERE `id` IN ('health_insurance_card', 'prostate_bank_participant_id');
INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) 
VALUES
('health_insurance_card', 'global', 'RAMQ', 'RAMQ'),
('prostate_bank_participant_id', 'global', 'Bank Nbr', 'Numéro de banque');

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_add = '0', sfo.flag_add_readonly = '0', 
sfo.flag_edit = '0', sfo.flag_edit_readonly = '0',
sfo.flag_datagrid = '0',sfo.flag_datagrid_readonly = '0',
sfo.flag_search = '0', sfo.flag_search_readonly = '0',
sfo.flag_index = '0', sfo.flag_detail = '0'
WHERE sfi.field = 'identifier_abrv' AND sfi.model = 'MiscIdentifier' 
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_override_label  = '1',
sfo.language_label  = 'participant code'
WHERE sfi.field = 'participant_identifier' 
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id; 		

UPDATE `i18n` SET en = 'Participant System Code', fr = 'Code systême participant' WHERE id = 'participant code';

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.language_heading = 'other', sfo.display_column = '3', sfo.display_order = '98'
WHERE sfi.field = 'participant_identifier' 
AND str.alias = 'participants'
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id; 		

UPDATE structure_permissible_values_customs SET en = 'Armen Aprikian', fr = 'Armen Aprikian' WHERE value = 'armen aprikian';
UPDATE structure_permissible_values_customs SET en = 'Chrysoula Makris', fr = 'Chrysoula Makris' WHERE value = 'chrysoula makris';
UPDATE structure_permissible_values_customs SET en = 'Eleonora Scarlata Villegas', fr = 'Eleonora Scarlata Villegas' WHERE value = 'eleonora scarlata villegas';
UPDATE structure_permissible_values_customs SET en = 'Jinsong Chen', fr = 'Jinsong Chen' WHERE value = 'jinsong chen';
UPDATE structure_permissible_values_customs SET en = 'Lucie Hamel', fr = 'Lucie Hamel' WHERE value = 'lucie hamel';
UPDATE structure_permissible_values_customs SET en = 'Other', fr = 'Autre' WHERE value = 'other';
UPDATE structure_permissible_values_customs SET en = 'Simone Chevalier', fr = 'Simone Chevalier' WHERE value = 'simone chevalier';

UPDATE structure_permissible_values_customs SET en = 'MUHC', fr = 'CUSM' WHERE value = 'muhc';
UPDATE structure_permissible_values_customs SET en = 'Urology Clinic', fr = 'clinique d''urologie' WHERE value = 'urology clinic';
UPDATE structure_permissible_values_customs SET en = 'Operating Room', fr = 'Salle d''opération' WHERE value = 'operating room';

INSERT INTO structure_permissible_values_custom_controls (name,flag_active) 
VALUES 
('consent versions', '1');

SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'consent versions');

INSERT INTO structure_permissible_values_customs(control_id, value, en, fr)
(SELECT @control_id, value.language_alias, i18n.en, i18n.fr
FROM structure_value_domains AS domain
INNER JOIN structure_value_domains_permissible_values AS link ON link.structure_value_domain_id = domain.id
INNER JOIN structure_permissible_values AS value ON link.structure_permissible_value_id = value.id
LEFT JOIN i18n ON i18n.id = value.language_alias
WHERE domain.domain_name = 'qc_cusm_consent_version');

DELETE FROM structure_value_domains_permissible_values WHERE structure_value_domain_id = (SELECT id FROM structure_value_domains WHERE domain_name = 'qc_cusm_consent_version');

UPDATE structure_value_domains SET source = 'StructurePermissibleValuesCustom::getCustomDropdown(''consent versions'')' WHERE domain_name = 'qc_cusm_consent_version';

INSERT INTO structure_permissible_values_custom_controls (name,flag_active) 
VALUES 
('life style versions', '1');

SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'life style versions');

INSERT INTO structure_permissible_values_customs(control_id, value, en, fr)
(SELECT @control_id, value.language_alias, i18n.en, i18n.fr
FROM structure_value_domains AS domain
INNER JOIN structure_value_domains_permissible_values AS link ON link.structure_value_domain_id = domain.id
INNER JOIN structure_permissible_values AS value ON link.structure_permissible_value_id = value.id
LEFT JOIN i18n ON i18n.id = value.language_alias
WHERE domain.domain_name = 'qc_cusm_lifestyle_form_version');

DELETE FROM structure_value_domains_permissible_values WHERE structure_value_domain_id = (SELECT id FROM structure_value_domains WHERE domain_name = 'qc_cusm_lifestyle_form_version');

UPDATE structure_value_domains SET source = 'StructurePermissibleValuesCustom::getCustomDropdown(''consent versions'')' WHERE domain_name = 'qc_cusm_lifestyle_form_version';

ALTER TABLE qc_cusm_dxd_procure MODIFY `diagnosis_master_id` int(11) NOT NULL DEFAULT '0';
ALTER TABLE qc_cusm_dxd_procure_revs MODIFY `diagnosis_master_id` int(11) NOT NULL DEFAULT '0';
ALTER TABLE storage_masters_revs ADD `label_precision` varchar(10) DEFAULT NULL AFTER `short_label`;
