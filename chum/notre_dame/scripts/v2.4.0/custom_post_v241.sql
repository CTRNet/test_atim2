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
mic.misc_identifier_name AS identifier_name,
ident.identifier_value AS identifier_value,

col.acquisition_label, 
col.visit_label AS visit_label,

specimen_control.sample_type AS initial_specimen_sample_type,
specimen.sample_control_id AS initial_specimen_sample_control_id,
parent_samp_control.sample_type AS parent_sample_type,
parent_samp.sample_control_id AS parent_sample_control_id,
samp_control.sample_type,
samp.sample_control_id,
samp.sample_label AS sample_label,

al.barcode,
al.aliquot_label AS aliquot_label,
al_control.aliquot_type,
al.aliquot_control_id,
al.in_stock,

stor.code,
stor.selection_label,
al.storage_coord_x,
al.storage_coord_y,

stor.temperature,
stor.temp_unit,

al.created

FROM aliquot_masters as al
INNER JOIN aliquot_controls AS al_control ON al.aliquot_control_id=al_control.id
INNER JOIN sample_masters as samp ON samp.id = al.sample_master_id AND samp.deleted != 1
INNER JOIN sample_controls AS samp_control ON samp.sample_control_id=samp_control.id
LEFT JOIN sample_masters as specimen ON samp.initial_specimen_sample_id = specimen.id AND specimen.deleted != 1
LEFT JOIN sample_controls AS specimen_control ON specimen.sample_control_id=specimen_control.id
LEFT JOIN sample_masters as parent_samp ON samp.parent_id = parent_samp.id AND parent_samp.deleted != 1
LEFT JOIN sample_controls AS parent_samp_control ON parent_samp.sample_control_id=parent_samp_control.id
INNER JOIN collections AS col ON col.id = samp.collection_id AND col.deleted != 1
LEFT JOIN clinical_collection_links AS link ON col.id = link.collection_id AND link.deleted != 1
LEFT JOIN participants AS part ON link.participant_id = part.id AND part.deleted != 1
LEFT JOIN storage_masters AS stor ON stor.id = al.storage_master_id AND stor.deleted != 1
LEFT JOIN banks ON col.bank_id = banks.id AND banks.deleted != 1
LEFT JOIN misc_identifiers AS ident ON ident.misc_identifier_control_id = banks.misc_identifier_control_id AND ident.participant_id = part.id AND ident.deleted != 1
LEFT JOIN misc_identifier_controls AS mic ON ident.misc_identifier_control_id=mic.id
WHERE al.deleted != 1;

DELETE FROM structure_formats WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE field IN ('tmp_tube_storage_method' ,'tmp_tube_storage_solution'));
DELETE FROM structure_fields WHERE field IN ('tmp_tube_storage_method' ,'tmp_tube_storage_solution');

ALTER TABLE ad_blocks
 DROP COLUMN path_report_code;
ALTER TABLE ad_blocks_revs
 DROP COLUMN path_report_code;

DELETE FROM structure_formats WHERE structure_field_id = (SELECT id FROM structure_fields WHERE field = 'path_report_code');
DELETE FROM structure_fields WHERE field = 'path_report_code' ;

ALTER TABLE quality_ctrls
 ADD COLUMN qc_nd_is_irrelevant BOOLEAN NOT NULL DEFAULT false AFTER used_volume;
ALTER TABLE quality_ctrls_revs
 ADD COLUMN qc_nd_is_irrelevant BOOLEAN NOT NULL DEFAULT false AFTER used_volume;
 
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Inventorymanagement', 'QualityCtrl', 'quality_ctrls', 'qc_nd_is_irrelevant', 'checkbox',  NULL , '0', '', '', '', 'is irrelevant', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='qualityctrls'), (SELECT id FROM structure_fields WHERE `model`='QualityCtrl' AND `tablename`='quality_ctrls' AND `field`='qc_nd_is_irrelevant' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='is irrelevant' AND `language_tag`=''), '0', '26', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '1');

INSERT IGNORE INTO i18n (id, en, fr) VALUES
('is irrelevant', 'Is irrelevant', 'N''est pas pertinent'),
('immunofluorescence', 'Immunofluorescence', 'Immunofluorescence'),
("an old bank number is matched to the one used as search parameter", 
 "An old bank number is matched to the one used as search parameter.",
 "Un ancien numéro de banque correspond à celui utilisé comme paramètre de recherche."),
("this hospital identifier must start with capital letter %s and be followed by numbers",
 "This hospital identifier must start with capital letter %s and be followed by numbers.",
 "Cet identifiant d'hôpital doit commencer avec la lettre majuscule %s et être suivi par des chiffres."),
("researcher", "Researcher", "Chercheur"),
("the code format must be {year}-{###}", "The code format must be {year}-{###}.", "Le format du code doit être {année}-{###}.");

UPDATE structure_formats SET `display_order`='21' WHERE structure_id=(SELECT id FROM structures WHERE alias='participantcontacts') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ParticipantContact' AND `tablename`='participant_contacts' AND `field`='phone_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='phone_type') AND `flag_confidential`='1');
UPDATE structure_formats SET `display_order`='24' WHERE structure_id=(SELECT id FROM structures WHERE alias='participantcontacts') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ParticipantContact' AND `tablename`='participant_contacts' AND `field`='phone_secondary_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='phone_type') AND `flag_confidential`='1');

UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='querytool_batch_set') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='BatchSet' AND `tablename`='datamart_batch_sets' AND `field`='description' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');




DELETE FROM structure_formats WHERE structure_field_id=332 AND structure_id!=88;
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='derivatives'), (SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='initial_specimen_sample_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='specimen_sample_type')  AND `flag_confidential`='0'), '0', '100', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '1', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1');

UPDATE menus SET use_link='/clinicalannotation/participants/search/' WHERE id='clin_CAN_1';

UPDATE structure_formats SET `flag_override_help`='0', `language_help`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='sex' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='sex') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_edit`='0', `flag_edit_readonly`='0', `flag_search`='0', `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='participant_identifier' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_override_help`='0', `language_help`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='race' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='race') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='0', `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='participant_identifier' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE misc_identifiers SET identifier_value=CONCAT('H', identifier_value) WHERE misc_identifier_control_id=8 AND LEFT(identifier_value, 1)!='H';
UPDATE misc_identifiers SET identifier_value=CONCAT('N', identifier_value) WHERE misc_identifier_control_id=9 AND LEFT(identifier_value, 1)!='N';
UPDATE misc_identifiers SET identifier_value=CONCAT('S', identifier_value) WHERE misc_identifier_control_id=10 AND LEFT(identifier_value, 1)!='S';

UPDATE menus SET use_link='/study/study_summaries/search/' WHERE id='tool_CAN_100';

UPDATE structure_fields SET  `language_label`='start' WHERE model='StudySummary' AND tablename='study_summaries' AND field='start_date' AND `type`='date' AND structure_value_domain  IS NULL ;
UPDATE structure_fields SET  `language_label`='end',  `language_tag`='' WHERE model='StudySummary' AND tablename='study_summaries' AND field='end_date' AND `type`='date' AND structure_value_domain  IS NULL ;
UPDATE structure_formats SET `display_order`='8' WHERE structure_id=(SELECT id FROM structures WHERE alias='studysummaries') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='end_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Study', 'StudySummary', 'study_summaries', 'qc_nd_researcher', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_staff') , '0', '', '', '', 'researcher', ''), 
('Study', 'StudySummary', 'study_summaries', 'qc_nd_contact', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_staff') , '0', '', '', '', 'contact', ''), 
('Study', 'StudySummary', 'study_summaries', 'qc_nd_code', 'input', NULL, '0', '', '', '', 'code', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='studysummaries'), (SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='qc_nd_researcher' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_staff')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='researcher' AND `language_tag`=''), '1', '9', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='studysummaries'), (SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='qc_nd_contact' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_staff')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='contact' AND `language_tag`=''), '1', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='studysummaries'), (SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='qc_nd_code' AND `type`='input' AND `structure_value_domain` IS NULL AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='code' AND `language_tag`=''), '1', '11', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1');

ALTER TABLE study_summaries
 ADD COLUMN qc_nd_researcher VARCHAR(50) NOT NULL DEFAULT '' AFTER additional_clinical,
 ADD COLUMN qc_nd_contact VARCHAR(50) NOT NULL DEFAULT '' AFTER qc_nd_researcher,
 ADD COLUMN qc_nd_code VARCHAR(50) NOT NULL DEFAULT '' AFTER qc_nd_contact;
ALTER TABLE study_summaries_revs
 ADD COLUMN qc_nd_researcher VARCHAR(50) NOT NULL DEFAULT '' AFTER additional_clinical,
 ADD COLUMN qc_nd_contact VARCHAR(50) NOT NULL DEFAULT '' AFTER qc_nd_researcher,
 ADD COLUMN qc_nd_code VARCHAR(50) NOT NULL DEFAULT '' AFTER qc_nd_contact;

INSERT INTO structure_validations (structure_field_id, rule, on_action, language_message) VALUES
((SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='qc_nd_code' AND `type`='input' AND `structure_value_domain` IS NULL AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='code' AND `language_tag`=''), 'isUnique', '', ''),
((SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='qc_nd_code' AND `type`='input' AND `structure_value_domain` IS NULL AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='code' AND `language_tag`=''), 'custom,/^[0-9]{4}-[0-9]{3}$/', '', 'the code format must be {year}-{###}');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Inventorymanagement', 'ViewAliquot', 'view_aliquots', 'study_summary_id', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='study_list') , '0', '', '', '', 'study', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='study_summary_id' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='study_list')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='study' AND `language_tag`=''), '0', '27', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '1');
UPDATE structure_formats SET display_order=28 WHERE id IN(4432, 2495);
UPDATE structure_formats SET display_order=30 WHERE id IN(2993);
UPDATE structure_formats SET display_order=27 WHERE id IN(4432);

INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length) VALUES
('researchers', 1, 50);
INSERT INTO structure_value_domains(domain_name, override, category, source) VALUES
('custom_researchers', 'open', '', "StructurePermissibleValuesCustom::getCustomDropdown('researchers')");
UPDATE structure_fields SET  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='custom_researchers')  WHERE model='StudySummary' AND tablename='study_summaries' AND field='qc_nd_researcher' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_staff');

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("doctor", "doctor");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="participant_contact_relationship"),  (SELECT id FROM structure_permissible_values WHERE value="doctor" AND language_alias="doctor"), "3", "1");

UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='orderlines') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='OrderLine' AND `tablename`='order_lines' AND `field`='date_required' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

DELETE FROM structure_formats WHERE structure_id IN(222,223) AND structure_field_id=372;


-- ------------------------------------------------------------------
-- Already executed on server on 2012-02-13
-- ------------------------------------------------------------------

INSERT INTO `datamart_reports` (`name`, `description`, `form_alias_for_search`, `form_alias_for_results`, `form_type_for_results`, `function`, `flag_active`) VALUES
('participant identifications list', 'report_participant_id_list_desc', 'report_participant_id_list_search', 'report_participant_id_list_result', 'index', 'participantIdentificationsList', 1);

INSERT INTO `structure_value_domains` (`id`, `domain_name`, `override`, `category`, `source`) VALUES
(null, 'bank_identifier_name_list_from_id', 'open', '', 'Clinicalannotation.MiscIdentifierControl::getIcmBankIdentifierNamesFromId');

DELETE FROM structure_formats WHERE structure_id = (SELECT id FROM structures WHERE alias='report_participant_id_list_search');
DELETE FROM structure_fields WHERE field IN ('no_labo_misc_identifier_control_id','no_labo_value');
DELETE FROM structures WHERE alias='report_participant_id_list_search';

INSERT INTO structures(`alias`) VALUES ('report_participant_id_list_search');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Datamart', '0', '', 'no_labo_misc_identifier_control_id', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='bank_identifier_name_list_from_id') , '0', '', '', 'participant_with_no_labo_help', 'participant having', ''),
('Datamart', '0', '', 'no_labo_value', 'integer', NULL , '0', 'size=20', '', '', 'no labo', '');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='report_participant_id_list_search'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='no_labo_misc_identifier_control_id'), '0', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='report_participant_id_list_search'), (SELECT id FROM structure_fields WHERE `model`='0' AND `field`='no_labo_value'), '0', '2', '', '0', '', '0', '', '0', '', '1', 'integer', '1', 'size=20', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');

INSERT INTO i18n (id,en,fr) VALUES ('no labo', "'No Labo'", "'No Labo'"), 
('participant identifications list','Participant Identifications List','Liste des identifiants de participants'),
('report_participant_id_list_desc', 
"List all participant identifiers (RAMQ, 'No Labo', Hospital Numbers, etc).", 
"Liste tous les identifiants de participants (RAMQ, 'No Labo', numéro d''hôpital, etc).");

INSERT INTO i18n (id,en,fr) VALUES ('participant having', 'Participant Having', 'Participant ayant un'),
('participant_with_no_labo_help',"Will list only participants having the selected 'No labo' type.", "Listera seulement les participantts ayant le type de 'No labo' sélectionné.");

INSERT INTO structures(`alias`) VALUES ('report_participant_id_list_result');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Datamart', '0', '', 'first_name', 'input',  NULL , '0', '', '', '', 'first name', ''),
('Datamart', '0', '', 'last_name', 'input',  NULL , '0', '', '', '', 'last name', ''),
('Datamart', '0', '', 'breast_bank_no_lab', 'input',  NULL , '0', '', '', '', 'breast bank no lab', ''),
('Datamart', '0', '', 'prostate_bank_no_lab', 'input',  NULL , '0', '', '', '', 'prostate bank no lab', ''),
('Datamart', '0', '', 'head_and_neck_bank_no_lab', 'input',  NULL , '0', '', '', '', 'head and neck bank no lab', ''),
('Datamart', '0', '', 'kidney_bank_no_lab', 'input',  NULL , '0', '', '', '', 'kidney bank no lab', ''),
('Datamart', '0', '', 'ovary_bank_no_lab', 'input',  NULL , '0', '', '', '', 'ovary bank no lab', ''),
('Datamart', '0', '', 'hotel_dieu_id_nbr', 'input',  NULL , '0', '', '', '', 'hotel-dieu id nbr', ''),
('Datamart', '0', '', 'notre_dame_id_nbr', 'input',  NULL , '0', '', '', '', 'notre-dame id nbr', ''),
('Datamart', '0', '', 'other_center_id_nbr', 'input',  NULL , '0', '', '', '', 'other center id nbr', ''),
('Datamart', '0', '', 'saint_luc_id_nbr', 'input',  NULL , '0', '', '', '', 'saint-luc id nbr', ''),
('Datamart', '0', '', 'ramq_nbr', 'input',  NULL , '0', '', '', '', 'ramq nbr', ''),
('Datamart', '0', '', 'code_barre', 'input',  NULL , '0', '', '', '', 'code-barre', ''),
('Datamart', '0', '', 'old_bank_no_lab', 'input',  NULL , '0', '', '', '', 'old bank no lab', ''),
('Datamart', '0', '', 'participant_patho_identifier', 'input',  NULL , '0', '', '', '', 'participant patho identifier', '');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='report_participant_id_list_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND field = 'first_name'), '0', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='report_participant_id_list_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND field = 'last_name'), '0', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='report_participant_id_list_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND field = 'breast_bank_no_lab'), '0', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='report_participant_id_list_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND field = 'prostate_bank_no_lab'), '0', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='report_participant_id_list_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND field = 'head_and_neck_bank_no_lab'), '0', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='report_participant_id_list_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND field = 'kidney_bank_no_lab'), '0', '6', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='report_participant_id_list_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND field = 'ovary_bank_no_lab'), '0', '7', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='report_participant_id_list_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND field = 'hotel_dieu_id_nbr'), '0', '8', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='report_participant_id_list_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND field = 'notre_dame_id_nbr'), '0', '9', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='report_participant_id_list_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND field = 'other_center_id_nbr'), '0', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='report_participant_id_list_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND field = 'saint_luc_id_nbr'), '0', '11', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='report_participant_id_list_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND field = 'ramq_nbr'), '0', '12', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='report_participant_id_list_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND field = 'code_barre'), '0', '13', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='report_participant_id_list_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND field = 'old_bank_no_lab'), '0', '14', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='report_participant_id_list_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND field = 'participant_patho_identifier'), '0', '15', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');

INSERT INTO i18n (id,en,fr) VALUES 
('no labo should be a numeric value',"'No Labo' should be a numeric value!","'No Labo' doit être un numérique!"),
('a no labo type should be selected',"A 'No Labo' type should be selected!","Un 'No Labo' doit être sélectionné!");

INSERT INTO i18n (id,en,fr) VALUES 
('more than 3000 records are returned by the query - please redefine search criteria',
'More than 3000 records are returned by the query! Please redefine search criteria!',
'Plus de 3000 enregistrements sont retournés par la requête! Veuillez redéfinir vos paramêtres de recherche!');

ALTER TABLE consent_masters
 MODIFY COLUMN consent_version_date VARCHAR(25) NOT NULL DEFAULT '';
ALTER TABLE consent_masters_revs
 MODIFY COLUMN consent_version_date VARCHAR(25) NOT NULL DEFAULT '';
