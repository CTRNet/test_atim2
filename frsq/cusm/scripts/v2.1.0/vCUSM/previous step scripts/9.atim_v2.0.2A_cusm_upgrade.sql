UPDATE `menus` SET `flag_active` = '0' WHERE `parent_id` LIKE 'clin_CAN_4' AND language_title NOT IN ('lifestyle');
UPDATE `menus` SET `use_link` = '/clinicalannotation/event_masters/listall/lifestyle/%%Participant.id%%'  WHERE `id` LIKE 'clin_CAN_4';

UPDATE structure_formats
SET display_column = '0', display_order = '4'
WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_cusm_dxd_procure') 
AND structure_field_id=(SELECT id FROM structure_fields WHERE model='DiagnosisMaster' AND field='notes');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='qc_cusm_dxd_procure'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `field`='primary_number'), 
'1', '100', 'other', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'0', '0', '0', '0', '1', '0', '0', '0', '1', '1');

UPDATE structure_formats
SET flag_index = '0', flag_detail = '0'
WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') 
AND structure_field_id IN (SELECT id FROM structure_fields WHERE model='DiagnosisMaster' AND field NOT IN ('dx_date'));

UPDATE structure_formats
SET `language_heading` = 'diagnosis', `flag_override_label` = '1', `language_label` = 'report date'
WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') 
AND structure_field_id IN (SELECT id FROM structure_fields WHERE model='DiagnosisMaster' AND field ='dx_date');

ALTER TABLE qc_cusm_dxd_procure
   ADD `morphology` varchar(50) DEFAULT NULL AFTER `diagnosis_master_id`;
ALTER TABLE qc_cusm_dxd_procure_revs
   ADD `morphology` varchar(50) DEFAULT NULL AFTER `diagnosis_master_id`;

INSERT INTO `structure_fields` (`id`, `public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, '', 'Clinicalannotation', 'DiagnosisDetail', 'qc_cusm_dxd_procure', 'morphology', 'morphology (histology)', '', 'select', '', '', (SELECT `id` FROM `structure_value_domains` WHERE `domain_name` = 'qc_cusm_histology_values'), '', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0);

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='clinicalcollectionlinks'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `field`='report_number'), 
'1', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'0', '0', '0', '0', '0', '0', '0', '0', '1', '1'),
((SELECT id FROM structures WHERE alias='clinicalcollectionlinks'), 
(SELECT id FROM structure_fields WHERE `tablename`='qc_cusm_dxd_procure' AND `field`='morphology'), 
'1', '11', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'0', '0', '0', '0', '0', '0', '0', '0', '1', '1'),
((SELECT id FROM structures WHERE alias='clinicalcollectionlinks'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `field`='path_tstage'), 
'1', '12', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'0', '0', '0', '0', '0', '0', '0', '0', '0', '1'),
((SELECT id FROM structures WHERE alias='clinicalcollectionlinks'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `field`='path_nstage'), 
'1', '13', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'0', '0', '0', '0', '0', '0', '0', '0', '0', '1'),
((SELECT id FROM structures WHERE alias='clinicalcollectionlinks'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `field`='path_mstage'), 
'1', '13', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'0', '0', '0', '0', '0', '0', '0', '0', '0', '1');

INSERT INTO `structure_validations` (`id`, `structure_field_id`, `rule`, `flag_empty`, `flag_required`, `on_action`, `language_message`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, (SELECT id FROM structure_fields WHERE model='DiagnosisMaster' AND field ='dx_date'), 'notEmpty', '0', '0', '', '', '0000-00-00 00:00:00', 0, '2010-02-12 00:00:00', 0);

INSERT IGNORE INTO `i18n` (`id`, `en`, `fr`)
VALUES
('report date', 'Report Date', 'Date du Rapport');

-- UPDATE  `structure_value_domains`
-- SET source = NULL
-- WHERE `domain_name` LIKE 'morphology';

INSERT IGNORE INTO `structure_permissible_values` 
(`value`, `language_alias`) 
VALUES
('adenocarcinoma / moderate', 'adenocarcinoma / moderate'),
('hyperplasia', 'hyperplasia'),
('no cancer', 'no cancer'),

('adenocarcinoma / well differentiated', 'adenocarcinoma / well differentiated'),
('adenocarcinoma / little differentiated', 'adenocarcinoma / little differentiated'),
('ductal adenocarcinoma', 'ductal adenocarcinoma'),
('mucinous adenocarcinoma', 'mucinous adenocarcinoma'),
('signet ring cell carcinoma', 'signet ring cell carcinoma'),
('adenosquamous carcinoma', 'adenosquamous carcinoma'),
('small cell carcinoma', 'small cell carcinoma'),
('sarcomatoid carcinoma', 'sarcomatoid carcinoma');

DELETE FROM `structure_value_domains_permissible_values` WHERE `structure_value_domain_id` = (SELECT `id` FROM `structure_value_domains` WHERE `domain_name` = 'qc_cusm_histology_values');
INSERT INTO `structure_value_domains_permissible_values` 
(`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`, `language_alias`) 
VALUES
((SELECT `id` FROM `structure_value_domains` WHERE `domain_name` = 'qc_cusm_histology_values'), (SELECT `id` FROM `structure_permissible_values` WHERE `value` = 'adenocarcinoma / well differentiated'), 0, 1, ''),
((SELECT `id` FROM `structure_value_domains` WHERE `domain_name` = 'qc_cusm_histology_values'), (SELECT `id` FROM `structure_permissible_values` WHERE `value` = 'adenocarcinoma / little differentiated'), 1, 1, ''),
((SELECT `id` FROM `structure_value_domains` WHERE `domain_name` = 'qc_cusm_histology_values'), (SELECT `id` FROM `structure_permissible_values` WHERE `value` = 'adenocarcinoma / moderate'), 2, 1, ''),
((SELECT `id` FROM `structure_value_domains` WHERE `domain_name` = 'qc_cusm_histology_values'), (SELECT `id` FROM `structure_permissible_values` WHERE `value` = 'ductal adenocarcinoma'), 3, 1, ''),
((SELECT `id` FROM `structure_value_domains` WHERE `domain_name` = 'qc_cusm_histology_values'), (SELECT `id` FROM `structure_permissible_values` WHERE `value` = 'mucinous adenocarcinoma'), 4, 1, ''),
((SELECT `id` FROM `structure_value_domains` WHERE `domain_name` = 'qc_cusm_histology_values'), (SELECT `id` FROM `structure_permissible_values` WHERE `value` = 'signet ring cell carcinoma'), 5, 1, ''),
((SELECT `id` FROM `structure_value_domains` WHERE `domain_name` = 'qc_cusm_histology_values'), (SELECT `id` FROM `structure_permissible_values` WHERE `value` = 'adenosquamous carcinoma'), 6, 1, ''),
((SELECT `id` FROM `structure_value_domains` WHERE `domain_name` = 'qc_cusm_histology_values'), (SELECT `id` FROM `structure_permissible_values` WHERE `value` = 'small cell carcinoma'), 7, 1, ''),
((SELECT `id` FROM `structure_value_domains` WHERE `domain_name` = 'qc_cusm_histology_values'), (SELECT `id` FROM `structure_permissible_values` WHERE `value` = 'sarcomatoid carcinoma'), 8, 1, ''),

((SELECT `id` FROM `structure_value_domains` WHERE `domain_name` = 'qc_cusm_histology_values'), (SELECT `id` FROM `structure_permissible_values` WHERE `value` = 'hyperplasia' and language_alias = 'hyperplasia'), 15, 1, ''),
((SELECT `id` FROM `structure_value_domains` WHERE `domain_name` = 'qc_cusm_histology_values'), (SELECT `id` FROM `structure_permissible_values` WHERE `value` = 'no cancer' and language_alias = 'no cancer'), 16, 1, ''),

((SELECT `id` FROM `structure_value_domains` WHERE `domain_name` = 'qc_cusm_histology_values'), (SELECT `id` FROM `structure_permissible_values` WHERE `value` = 'other'), 20, 1, '');

DELETE FROM i18n 
WHERE id IN (
'adenocarcinoma / moderate', 
'hyperplasia',
'no cancer',

'adenocarcinoma / well differentiated', 
'adenocarcinoma / little differentiated', 
'ductal adenocarcinoma', 
'mucinous adenocarcinoma',
'signet ring cell carcinoma', 
'adenosquamous carcinoma', 
'small cell carcinoma', 
'sarcomatoid carcinoma');

INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('adenocarcinoma / moderate', '', 'Adenocarcinoma / Moderate', 'Adénocarcinome / modéré'),
('hyperplasia', '', 'Hyperplasia', 'Hyperplasie'),
('no cancer', '', 'No Cancer', 'Aucun cancer'),

('adenocarcinoma / well differentiated', '', 'Adenocarcinoma / Well Differentiated', 'Adénocarcinome / bien différencié'),
('adenocarcinoma / little differentiated', '', 'Adenocarcinoma / Little Differentiated', 'Adénocarcinome / peu différencié'),
('ductal adenocarcinoma', '', 'Ductal Adenocarcinoma', 'Adénocarcinome ductal'),
('mucinous adenocarcinoma', '', 'Mucinous Sdenocarcinoma', 'Adénocarcinome mucineux'),
('signet ring cell carcinoma', '', 'Signet Ring Cell Carcinoma', 'Carcinome à cellules indépendantes'),
('adenosquamous carcinoma', '', 'Adenosquamous Carcinoma', 'Carcinome Adénosquameux'),
('small cell carcinoma', '', 'Small Cell Carcinoma', 'Carcinome à petites cellules'),
('sarcomatoid carcinoma', '', 'Sarcomatoid Carcinoma', 'Carcinome sarcomatoïde');

DELETE FROM structure_formats 
WHERE structure_id = (SELECT id FROM structures WHERE alias = 'qc_cusm_dxd_procure') 
AND structure_field_id IN (SELECT id FROM structure_fields WHERE field = 'morphology');

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

ALTER TABLE qc_cusm_dxd_procure MODIFY `diagnosis_master_id` int(11) NOT NULL DEFAULT '0';
ALTER TABLE qc_cusm_dxd_procure_revs MODIFY `diagnosis_master_id` int(11) NOT NULL DEFAULT '0';
ALTER TABLE storage_masters_revs ADD `qc_cusm_label_precision` varchar(10) DEFAULT NULL AFTER `short_label`;
