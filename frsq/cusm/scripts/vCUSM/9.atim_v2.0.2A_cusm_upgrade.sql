
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

ALTER TABLE qc_cusm_dxd_procure MODIFY `diagnosis_master_id` int(11) NOT NULL DEFAULT '0';
ALTER TABLE qc_cusm_dxd_procure_revs MODIFY `diagnosis_master_id` int(11) NOT NULL DEFAULT '0';
ALTER TABLE storage_masters_revs ADD `label_precision` varchar(10) DEFAULT NULL AFTER `short_label`;
