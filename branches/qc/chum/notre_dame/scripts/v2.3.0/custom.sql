#POST v2.3.0. script

#INSERT INTO storage_controls(storage_type, storage_type_code, coord_x_title, coord_x_type, coord_x_size, coord_y_title, coord_y_type, coord_y_size, display_x_size, display_y_size, reverse_x_numbering, reverse_y_numbering, horizontal_increment, set_temperature, is_tma_block, flag_active, form_alias, detail_tablename, databrowser_label) VALUES
#('rack20 vertical numbering', 'R20vn', 'position', 'integer', 20, NULL, NULL, NULL, 4, 5, 0, 0, 0, FALSE, FALSE, 1, 'std_undetail_stg_with_surr_tmp', 'std_racks', 'rack20 horizontal numbering'); 

#CREATE VIEW `view_structure_formats_simplified` AS select `str`.`alias` AS `structure_alias`,`sfo`.`id` AS `structure_format_id`,`sfi`.`id` AS `structure_field_id`,`sfo`.`structure_id` AS `structure_id`,`sfi`.`plugin` AS `plugin`,`sfi`.`model` AS `model`,`sfi`.`tablename` AS `tablename`,`sfi`.`field` AS `field`,`sfi`.`structure_value_domain` AS `structure_value_domain`,`svd`.`domain_name` AS `structure_value_domain_name`,`sfi`.`flag_confidential` AS `flag_confidential`,if((`sfo`.`flag_override_label` = '1'),`sfo`.`language_label`,`sfi`.`language_label`) AS `language_label`,if((`sfo`.`flag_override_tag` = '1'),`sfo`.`language_tag`,`sfi`.`language_tag`) AS `language_tag`,if((`sfo`.`flag_override_help` = '1'),`sfo`.`language_help`,`sfi`.`language_help`) AS `language_help`,if((`sfo`.`flag_override_type` = '1'),`sfo`.`type`,`sfi`.`type`) AS `type`,if((`sfo`.`flag_override_setting` = '1'),`sfo`.`setting`,`sfi`.`setting`) AS `setting`,if((`sfo`.`flag_override_default` = '1'),`sfo`.`default`,`sfi`.`default`) AS `default`,`sfo`.`flag_add` AS `flag_add`,`sfo`.`flag_add_readonly` AS `flag_add_readonly`,`sfo`.`flag_edit` AS `flag_edit`,`sfo`.`flag_edit_readonly` AS `flag_edit_readonly`,`sfo`.`flag_search` AS `flag_search`,`sfo`.`flag_search_readonly` AS `flag_search_readonly`,`sfo`.`flag_addgrid` AS `flag_addgrid`,`sfo`.`flag_addgrid_readonly` AS `flag_addgrid_readonly`,`sfo`.`flag_editgrid` AS `flag_editgrid`,`sfo`.`flag_editgrid_readonly` AS `flag_editgrid_readonly`,`sfo`.`flag_batchedit` AS `flag_batchedit`,`sfo`.`flag_batchedit_readonly` AS `flag_batchedit_readonly`,`sfo`.`flag_index` AS `flag_index`,`sfo`.`flag_detail` AS `flag_detail`,`sfo`.`flag_summary` AS `flag_summary`,`sfo`.`display_column` AS `display_column`,`sfo`.`display_order` AS `display_order`,`sfo`.`language_heading` AS `language_heading` from (((`structure_formats` `sfo` join `structure_fields` `sfi` on((`sfo`.`structure_field_id` = `sfi`.`id`))) join `structures` `str` on((`str`.`id` = `sfo`.`structure_id`))) left join `structure_value_domains` `svd` on((`svd`.`id` = `sfi`.`structure_value_domain`)));

#DROP VIEW view_collections;
CREATE VIEW `view_collections` AS 
SELECT `col`.`id` AS `collection_id`,`col`.`bank_id` AS `bank_id`,`col`.`sop_master_id` AS `sop_master_id`,`link`.`participant_id` 
 AS `participant_id`,`link`.`diagnosis_master_id` AS `diagnosis_master_id`,`link`.`consent_master_id` 
 AS `consent_master_id`,`part`.`participant_identifier` AS `participant_identifier`,`mic`.`misc_identifier_name` 
 AS `identifier_name`,`ident`.`identifier_value` AS `identifier_value`,`col`.`acquisition_label` AS `acquisition_label`,`col`.`collection_site` 
 AS `collection_site`,`col`.`visit_label` AS `visit_label`,`col`.`collection_datetime` 
 AS `collection_datetime`,`col`.`collection_datetime_accuracy` AS `collection_datetime_accuracy`,`col`.`collection_property` 
 AS `collection_property`,`col`.`collection_notes` AS `collection_notes`,`col`.`deleted` 
 AS `deleted`,`banks`.`name` AS `bank_name`,`col`.`created` AS `created` 
FROM ((((`collections` `col` 
 LEFT JOIN `clinical_collection_links` `link` on(((`col`.`id` = `link`.`collection_id`) and (`link`.`deleted` <> 1)))) 
 LEFT JOIN `participants` `part` on(((`link`.`participant_id` = `part`.`id`) and (`part`.`deleted` <> 1)))) 
 LEFT JOIN `banks` on(((`col`.`bank_id` = `banks`.`id`) and (`banks`.`deleted` <> 1)))) 
 LEFT JOIN `misc_identifiers` `ident` on (((`ident`.`misc_identifier_control_id` = `banks`.`misc_identifier_control_id`) and (`ident`.`participant_id` = `part`.`id`) and (`ident`.`deleted` <> 1)))
 LEFT JOIN misc_identifier_controls AS mic ON ident.misc_identifier_control_id=mic.id) 
WHERE (`col`.`deleted` <> 1); 

#DROP VIEW view_samples;
CREATE VIEW `view_samples` AS select `samp`.`id` AS `sample_master_id`,`samp`.`parent_id` 
 AS `parent_sample_id`,`samp`.`initial_specimen_sample_id` AS `initial_specimen_sample_id`,`samp`.`collection_id` 
 AS `collection_id`,`col`.`bank_id` AS `bank_id`,`col`.`sop_master_id` AS `sop_master_id`,`link`.`participant_id` 
 AS `participant_id`,`link`.`diagnosis_master_id` AS `diagnosis_master_id`,`link`.`consent_master_id` 
 AS `consent_master_id`,`part`.`participant_identifier` AS `participant_identifier`,`mic`.`misc_identifier_name` 
 AS `identifier_name`,`ident`.`identifier_value` AS `identifier_value`,`col`.`acquisition_label` AS `acquisition_label`,`col`.`visit_label` 
 AS `visit_label`,`specimen`.`sample_type` AS `initial_specimen_sample_type`,`specimen`.`sample_control_id` 
 AS `initial_specimen_sample_control_id`,`parent_samp`.`sample_type` AS `parent_sample_type`,`parent_samp`.`sample_control_id` 
 AS `parent_sample_control_id`,`samp`.`sample_type` AS `sample_type`,`samp`.`sample_control_id` AS `sample_control_id`,`samp`.`sample_code` 
 AS `sample_code`,`samp`.`sample_label` AS `sample_label`,`samp`.`sample_category` AS `sample_category`,`samp`.`deleted` 
 AS `deleted` 
FROM (((((((`sample_masters` `samp` 
 JOIN `collections` `col` on(((`col`.`id` = `samp`.`collection_id`) and (`col`.`deleted` <> 1)))) 
 LEFT JOIN `sample_masters` `specimen` on(((`samp`.`initial_specimen_sample_id` = `specimen`.`id`) and (`specimen`.`deleted` <> 1)))) 
 LEFT JOIN `sample_masters` `parent_samp` on(((`samp`.`parent_id` = `parent_samp`.`id`) and (`parent_samp`.`deleted` <> 1)))) 
 LEFT JOIN `clinical_collection_links` `link` on(((`col`.`id` = `link`.`collection_id`) and (`link`.`deleted` <> 1)))) 
 LEFT JOIN `participants` `part` on(((`link`.`participant_id` = `part`.`id`) and (`part`.`deleted` <> 1)))) 
 LEFT JOIN `banks` on(((`col`.`bank_id` = `banks`.`id`) and (`banks`.`deleted` <> 1)))) 
 LEFT JOIN `misc_identifiers` `ident` on(((`ident`.`misc_identifier_control_id` = `banks`.`misc_identifier_control_id`) and (`ident`.`participant_id` = `part`.`id`) and (`ident`.`deleted` <> 1)))
 LEFT JOIN misc_identifier_controls AS mic ON ident.misc_identifier_control_id=mic.id)
WHERE (`samp`.`deleted` <> 1);

UPDATE structure_fields SET  `type`='yes_no',  `structure_value_domain`= NULL  WHERE model='ConsentDetail' AND tablename='cd_icm_generics' AND field='inform_discovery_on_other_disease' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='yesno');
UPDATE structure_fields SET  `type`='yes_no',  `structure_value_domain`= NULL  WHERE model='ConsentDetail' AND tablename='cd_icm_generics' AND field='inform_significant_discovery' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='yesno');
UPDATE structure_fields SET  `type`='yes_no',  `structure_value_domain`= NULL  WHERE model='ConsentDetail' AND tablename='cd_icm_generics' AND field='contact_for_additional_data' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='yesno');
UPDATE structure_fields SET  `type`='yes_no',  `structure_value_domain`= NULL  WHERE model='ConsentDetail' AND tablename='cd_icm_generics' AND field='stop_questionnaire' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='yesno');
UPDATE structure_fields SET  `type`='yes_no',  `structure_value_domain`= NULL  WHERE model='ConsentDetail' AND tablename='cd_icm_generics' AND field='allow_questionnaire' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='yesno');
UPDATE structure_fields SET  `type`='yes_no',  `structure_value_domain`= NULL  WHERE model='ConsentDetail' AND tablename='cd_icm_generics' AND field='stop_followup' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='yesno');
UPDATE structure_fields SET  `type`='yes_no',  `structure_value_domain`= NULL  WHERE model='ConsentDetail' AND tablename='cd_icm_generics' AND field='urine_blood_use_for_followup' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='yesno');
UPDATE structure_formats SET `flag_override_type`='1', `type`='yes_no', `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_icm_generics' AND `field`='research_other_disease' AND `type`='checkbox' AND `structure_value_domain` IS NULL ) WHERE structure_id=(SELECT id FROM structures WHERE alias='cd_icm_generics') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_icm_generics' AND `field`='research_other_disease' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yesno') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_override_type`='1', `type`='yes_no', `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_icm_generics' AND `field`='use_of_blood' AND `type`='checkbox' AND `structure_value_domain` IS NULL ) WHERE structure_id=(SELECT id FROM structures WHERE alias='cd_icm_generics') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_icm_generics' AND `field`='use_of_blood' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yesno') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_override_type`='1', `type`='yes_no', `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_icm_generics' AND `field`='use_of_urine' AND `type`='checkbox' AND `structure_value_domain` IS NULL ) WHERE structure_id=(SELECT id FROM structures WHERE alias='cd_icm_generics') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_icm_generics' AND `field`='use_of_urine' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yesno') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_override_type`='1', `type`='yes_no', `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_icm_generics' AND `field`='biological_material_use' AND `type`='checkbox' AND `structure_value_domain` IS NULL ) WHERE structure_id=(SELECT id FROM structures WHERE alias='cd_icm_generics') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_icm_generics' AND `field`='biological_material_use' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yesno') AND `flag_confidential`='0');

-- Delete obsolete structure fields and validations
DELETE FROM structure_fields WHERE (model='ConsentDetail' AND tablename='cd_icm_generics' AND field='research_other_disease' AND `type`='select' AND structure_value_domain=(SELECT id FROM structure_value_domains WHERE domain_name='yesno'));
DELETE FROM structure_fields WHERE (model='ConsentDetail' AND tablename='cd_icm_generics' AND field='use_of_blood' AND `type`='select' AND structure_value_domain=(SELECT id FROM structure_value_domains WHERE domain_name='yesno'));
DELETE FROM structure_fields WHERE (model='ConsentDetail' AND tablename='cd_icm_generics' AND field='use_of_urine' AND `type`='select' AND structure_value_domain=(SELECT id FROM structure_value_domains WHERE domain_name='yesno'));
DELETE FROM structure_fields WHERE (model='ConsentDetail' AND tablename='cd_icm_generics' AND field='biological_material_use' AND `type`='select' AND structure_value_domain=(SELECT id FROM structure_value_domains WHERE domain_name='yesno'));

UPDATE cd_icm_generics SET use_of_blood='y' WHERE use_of_blood='yes';
UPDATE cd_icm_generics SET use_of_blood='n' WHERE use_of_blood='no';

UPDATE cd_icm_generics SET use_of_urine='y' WHERE use_of_urine='yes';
UPDATE cd_icm_generics SET use_of_urine='n' WHERE use_of_urine='no';

UPDATE cd_icm_generics SET urine_blood_use_for_followup='y' WHERE urine_blood_use_for_followup='yes';
UPDATE cd_icm_generics SET urine_blood_use_for_followup='n' WHERE urine_blood_use_for_followup='no';

UPDATE cd_icm_generics SET stop_followup='y' WHERE stop_followup='yes';
UPDATE cd_icm_generics SET stop_followup='n' WHERE stop_followup='no';

UPDATE cd_icm_generics SET contact_for_additional_data='y' WHERE contact_for_additional_data='yes';
UPDATE cd_icm_generics SET contact_for_additional_data='n' WHERE contact_for_additional_data='no';

UPDATE cd_icm_generics SET allow_questionnaire='y' WHERE allow_questionnaire='yes';
UPDATE cd_icm_generics SET allow_questionnaire='n' WHERE allow_questionnaire='no';

UPDATE cd_icm_generics SET stop_questionnaire='y' WHERE stop_questionnaire='yes';
UPDATE cd_icm_generics SET stop_questionnaire='n' WHERE stop_questionnaire='no';

UPDATE cd_icm_generics SET research_other_disease='y' WHERE research_other_disease='yes';
UPDATE cd_icm_generics SET research_other_disease='n' WHERE research_other_disease='no';

UPDATE cd_icm_generics SET inform_discovery_on_other_disease='y' WHERE inform_discovery_on_other_disease='yes';
UPDATE cd_icm_generics SET inform_discovery_on_other_disease='n' WHERE inform_discovery_on_other_disease='no';

UPDATE cd_icm_generics SET inform_significant_discovery='y' WHERE inform_significant_discovery='yes';
UPDATE cd_icm_generics SET inform_significant_discovery='n' WHERE inform_significant_discovery='no';

DELETE FROM structure_formats WHERE id=4279;

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

specimen.sample_type AS initial_specimen_sample_type,
specimen.sample_control_id AS initial_specimen_sample_control_id,
parent_samp.sample_type AS parent_sample_type,
parent_samp.sample_control_id AS parent_sample_control_id,
samp.sample_type,
samp.sample_control_id,
samp.sample_label AS sample_label,

al.barcode,
al.aliquot_label AS aliquot_label,
al.aliquot_type,
al.aliquot_control_id,
al.in_stock,

stor.code,
stor.selection_label,
al.storage_coord_x,
al.storage_coord_y,

stor.temperature,
stor.temp_unit,

tubes.tmp_storage_solution AS tmp_tube_storage_solution,
tubes.tmp_storage_method AS tmp_tube_storage_method,

al.created,
al.deleted

FROM aliquot_masters as al
INNER JOIN sample_masters as samp ON samp.id = al.sample_master_id AND samp.deleted != 1
LEFT JOIN sample_masters as specimen ON samp.initial_specimen_sample_id = specimen.id AND specimen.deleted != 1
LEFT JOIN sample_masters as parent_samp ON samp.parent_id = parent_samp.id AND parent_samp.deleted != 1
INNER JOIN collections AS col ON col.id = samp.collection_id AND col.deleted != 1
LEFT JOIN clinical_collection_links AS link ON col.id = link.collection_id AND link.deleted != 1
LEFT JOIN participants AS part ON link.participant_id = part.id AND part.deleted != 1
LEFT JOIN storage_masters AS stor ON stor.id = al.storage_master_id AND stor.deleted != 1
LEFT JOIN banks ON col.bank_id = banks.id AND banks.deleted != 1
LEFT JOIN misc_identifiers AS ident ON ident.misc_identifier_control_id = banks.misc_identifier_control_id AND ident.participant_id = part.id AND ident.deleted != 1
LEFT JOIN misc_identifier_controls AS mic ON ident.misc_identifier_control_id=mic.id
LEFT JOIN ad_tubes AS tubes ON tubes.aliquot_master_id=al.id
WHERE al.deleted != 1;

UPDATE structure_fields SET  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_type_from_id') ,  `language_label`='specific aliquot type' WHERE model='ViewAliquot' AND tablename='' AND field='aliquot_control_id' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_type_from_id');
UPDATE structure_formats SET `flag_override_label`='0', `language_label`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='aliquot_control_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_type_from_id') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='28' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='created' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='27' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='barcode' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='tmp_tube_storage_solution' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_all_tubes_storage_solution')  AND `flag_confidential`='0'), '0', '25', '', '0', '', '0', '', '0', '', '0', '', '0', 'size=30', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '1'), 
((SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='tmp_tube_storage_method' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_all_tubes_storage_method')  AND `flag_confidential`='0'), '0', '26', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '1');

REPLACE INTO i18n (id, en, fr) VALUES
('none', 'None', 'Aucun'),
('obtained consents', 'Obtained consents', 'Consentements obtenus'),
('contact if discovery', 'Contact if discovery', 'Informer des découvertes'),
('source cell passage number', 'Source Cell Passage Number', 'Nombre de passages cellulaires de la source'); 

DELETE FROM structure_formats WHERE id=4276;
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='derivatives') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Inventorymanagement' AND `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='initial_specimen_sample_type' AND `language_label`='initial specimen type' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='specimen_sample_type') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
UPDATE structure_fields SET  `setting`='class=range file' WHERE model='ViewCollection' AND tablename='' AND field='identifier_value' AND `type`='input' AND structure_value_domain  IS NULL ;
UPDATE structure_fields SET  `setting`='class=range file' WHERE model='ViewAliquot' AND tablename='' AND field='identifier_value' AND `type`='input' AND structure_value_domain  IS NULL ;

UPDATE structure_fields SET  `language_label`='contact if discovery' WHERE model='0' AND tablename='' AND field='contact_if_discovery' AND `type`='integer' AND structure_value_domain  IS NULL ;

UPDATE structure_formats SET `display_column`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_sample_joined_to_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='' AND `field`='sample_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_der_dnas') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Inventorymanagement' AND `model`='DerivativeDetail' AND `tablename`='' AND `field`='creation_datetime' AND `language_label`='creation date' AND `language_tag`='' AND `type`='datetime' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_der_dnas') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Inventorymanagement' AND `model`='DerivativeDetail' AND `tablename`='' AND `field`='creation_by' AND `language_label`='created by' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_staff') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_der_dnas') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Inventorymanagement' AND `model`='DerivativeDetail' AND `tablename`='' AND `field`='creation_site' AND `language_label`='creation site' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_site') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_der_blood_cells') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Inventorymanagement' AND `model`='DerivativeDetail' AND `tablename`='' AND `field`='creation_datetime' AND `language_label`='creation date' AND `language_tag`='' AND `type`='datetime' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_der_blood_cells') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Inventorymanagement' AND `model`='DerivativeDetail' AND `tablename`='' AND `field`='creation_by' AND `language_label`='created by' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_staff') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_der_blood_cells') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Inventorymanagement' AND `model`='DerivativeDetail' AND `tablename`='' AND `field`='creation_site' AND `language_label`='creation site' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_site') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_der_pbmcs') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Inventorymanagement' AND `model`='DerivativeDetail' AND `tablename`='' AND `field`='creation_datetime' AND `language_label`='creation date' AND `language_tag`='' AND `type`='datetime' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_der_pbmcs') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Inventorymanagement' AND `model`='DerivativeDetail' AND `tablename`='' AND `field`='creation_by' AND `language_label`='created by' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_staff') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_der_pbmcs') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Inventorymanagement' AND `model`='DerivativeDetail' AND `tablename`='' AND `field`='creation_site' AND `language_label`='creation site' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_site') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_der_rnas') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Inventorymanagement' AND `model`='DerivativeDetail' AND `tablename`='' AND `field`='creation_datetime' AND `language_label`='creation date' AND `language_tag`='' AND `type`='datetime' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_der_rnas') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Inventorymanagement' AND `model`='DerivativeDetail' AND `tablename`='' AND `field`='creation_by' AND `language_label`='created by' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_staff') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_der_rnas') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Inventorymanagement' AND `model`='DerivativeDetail' AND `tablename`='' AND `field`='creation_site' AND `language_label`='creation site' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_site') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_der_amplified_rnas') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Inventorymanagement' AND `model`='DerivativeDetail' AND `tablename`='' AND `field`='creation_datetime' AND `language_label`='creation date' AND `language_tag`='' AND `type`='datetime' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_der_amplified_rnas') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Inventorymanagement' AND `model`='DerivativeDetail' AND `tablename`='' AND `field`='creation_by' AND `language_label`='created by' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_staff') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_der_amplified_rnas') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Inventorymanagement' AND `model`='DerivativeDetail' AND `tablename`='' AND `field`='creation_site' AND `language_label`='creation site' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_site') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');

DELETE FROM structure_formats WHERE id IN(2674, 2677, 2678, 2680, 2681);
DELETE FROM structure_formats WHERE id IN(4274, 4245);

DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_der_pbmcs') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Inventorymanagement' AND `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='sample_type' AND `language_label`='sample type' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='sample_type') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_der_pbmcs') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Inventorymanagement' AND `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='sample_category' AND `language_label`='category' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='sample_category') AND `language_help`='inv_sample_category_defintion' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_der_pbmcs') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Inventorymanagement' AND `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='parent_id' AND `language_label`='parent sample code' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='sample_master_parent_id') AND `language_help`='inv_sample_parent_id_defintion' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_der_pbmcs') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Inventorymanagement' AND `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='is_problematic' AND `language_label`='is problematic' AND `language_tag`='' AND `type`='yes_no' AND `setting`='' AND `default`='0' AND `structure_value_domain` IS NULL  AND `language_help`='inv_is_problematic_sample_defintion' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_der_pbmcs') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Inventorymanagement' AND `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='notes' AND `language_label`='notes' AND `language_tag`='' AND `type`='textarea' AND `setting`='rows=3,cols=30' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');

DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_der_dnas') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Inventorymanagement' AND `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='sample_type' AND `language_label`='sample type' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='sample_type') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_der_dnas') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Inventorymanagement' AND `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='sample_category' AND `language_label`='category' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='sample_category') AND `language_help`='inv_sample_category_defintion' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_der_dnas') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Inventorymanagement' AND `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='parent_id' AND `language_label`='parent sample code' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='sample_master_parent_id') AND `language_help`='inv_sample_parent_id_defintion' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_der_dnas') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Inventorymanagement' AND `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='is_problematic' AND `language_label`='is problematic' AND `language_tag`='' AND `type`='yes_no' AND `setting`='' AND `default`='0' AND `structure_value_domain` IS NULL  AND `language_help`='inv_is_problematic_sample_defintion' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_der_dnas') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Inventorymanagement' AND `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='notes' AND `language_label`='notes' AND `language_tag`='' AND `type`='textarea' AND `setting`='rows=3,cols=30' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');

DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_der_dnas') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Inventorymanagement' AND `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='sample_type' AND `language_label`='sample type' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='sample_type') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_der_dnas') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Inventorymanagement' AND `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='sample_category' AND `language_label`='category' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='sample_category') AND `language_help`='inv_sample_category_defintion' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_der_dnas') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Inventorymanagement' AND `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='parent_id' AND `language_label`='parent sample code' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='sample_master_parent_id') AND `language_help`='inv_sample_parent_id_defintion' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_der_dnas') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Inventorymanagement' AND `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='is_problematic' AND `language_label`='is problematic' AND `language_tag`='' AND `type`='yes_no' AND `setting`='' AND `default`='0' AND `structure_value_domain` IS NULL  AND `language_help`='inv_is_problematic_sample_defintion' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_der_dnas') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Inventorymanagement' AND `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='notes' AND `language_label`='notes' AND `language_tag`='' AND `type`='textarea' AND `setting`='rows=3,cols=30' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');

DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_der_rnas') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Inventorymanagement' AND `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='sample_type' AND `language_label`='sample type' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='sample_type') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_der_rnas') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Inventorymanagement' AND `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='sample_category' AND `language_label`='category' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='sample_category') AND `language_help`='inv_sample_category_defintion' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_der_rnas') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Inventorymanagement' AND `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='parent_id' AND `language_label`='parent sample code' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='sample_master_parent_id') AND `language_help`='inv_sample_parent_id_defintion' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_der_rnas') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Inventorymanagement' AND `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='is_problematic' AND `language_label`='is problematic' AND `language_tag`='' AND `type`='yes_no' AND `setting`='' AND `default`='0' AND `structure_value_domain` IS NULL  AND `language_help`='inv_is_problematic_sample_defintion' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_der_rnas') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Inventorymanagement' AND `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='notes' AND `language_label`='notes' AND `language_tag`='' AND `type`='textarea' AND `setting`='rows=3,cols=30' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');

ALTER TABLE storage_masters
 MODIFY short_label VARCHAR(50) NOT NULL DEFAULT '';
ALTER TABLE storage_masters_revs
 MODIFY short_label VARCHAR(50) NOT NULL DEFAULT '';