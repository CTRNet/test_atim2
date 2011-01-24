DIE -- TODO: Verify the query to generate the collection
UPDATE misc_identifiers SET identifier_value=SUBSTR(identifier_value, 3), misc_identifier_control_id=9, identifier_name='collection' WHERE misc_identifier_control_id IN(1,2,3,4);
ALTER TABLE misc_identifiers
 ADD COLUMN delete_me int not null default 0;
UPDATE misc_identifiers AS mi1
LEFT JOIN misc_identifiers AS mi2 ON mi1.participant_id=mi2.participant_id AND mi1.id < mi2.id AND mi2.misc_identifier_control_id=9
SET mi2.delete_me=1
WHERE mi1.misc_identifier_control_id=9;
DELETE FROM misc_identifiers WHERE delete_me=1;
ALTER TABLE misc_identifiers
 DROP COLUMN delete_me;


INSERT INTO `misc_identifier_controls` (`misc_identifier_name`, `flag_active`, `autoincrement_name`, `display_order`, `misc_identifier_format`, `flag_once_per_participant`) VALUES
('collection', '1', 'main_participant_id', 8, '%%key_increment%%', '1');

-- missing data
INSERT INTO specimen_details(`sample_master_id`, `created`, `created_by`, `modified`, `modified_by`, `deleted`, `deleted_date`)
(SELECT `id`, `created`, `created_by`, `modified`, `modified_by`, `deleted`, `deleted_date` FROM sample_masters WHERE id NOT IN(SELECT sample_master_id FROM specimen_details WHERE sample_master_id IS NOT NULL) AND sample_category='specimen');
INSERT INTO specimen_details_revs(`id`, `sample_master_id`, `created`, `created_by`, `modified`, `modified_by`, `deleted`, `deleted_date`)
(SELECT `id`, `sample_master_id`, `created`, `created_by`, `modified`, `modified_by`, `deleted`, `deleted_date` FROM specimen_details WHERE id NOT IN(SELECT id FROM specimen_details_revs));


CREATE VIEW qc_lady_supplier_depts1 AS
SELECT collection_id, supplier_dept AS supplier_dept FROM sample_masters AS sm
LEFT JOIN specimen_details AS sd ON sm.id=sd.sample_master_id
WHERE sample_category='specimen' AND sm.deleted != 1
GROUP BY collection_id, supplier_dept;
CREATE VIEW qc_lady_supplier_depts2 AS
SELECT collection_id, GROUP_CONCAT(supplier_dept) AS supplier_dept_grouped
FROM qc_lady_supplier_depts1
GROUP BY collection_id;

DROP VIEW view_collections;
CREATE VIEW `view_collections` AS SELECT `col`.`id` AS `collection_id`,`col`.`bank_id` AS `bank_id`,`col`.`sop_master_id` AS `sop_master_id`,
`link`.`participant_id` AS `participant_id`,`link`.`diagnosis_master_id` AS `diagnosis_master_id`,`link`.`consent_master_id` AS `consent_master_id`,
`mi`.`identifier_value` AS `participant_identifier`,`col`.`acquisition_label` AS `acquisition_label`,`col`.`collection_site` AS `collection_site`,
`col`.`collection_datetime` AS `collection_datetime`,`col`.`collection_datetime_accuracy` AS `collection_datetime_accuracy`,
`col`.`collection_property` AS `collection_property`,`col`.`collection_notes` AS `collection_notes`,`col`.`deleted` AS `deleted`,`banks`.`name` AS `bank_name`,
`col`.`created` AS `created`,
`col`.`qc_lady_type` AS qc_lady_type, `col`.`qc_lady_follow_up` AS qc_lady_follow_up,
`sd`.`supplier_dept_grouped` AS qc_lady_supplier_dept_grouped
FROM `collections` AS `col` 
LEFT JOIN `clinical_collection_links` AS `link` ON `col`.`id` = `link`.`collection_id` AND `link`.`deleted` <> 1 
LEFT JOIN `participants` AS `part` ON `link`.`participant_id` = `part`.`id` AND `part`.`deleted` <> 1 
LEFT JOIN `banks` ON `col`.`bank_id` = `banks`.`id` AND `banks`.`deleted` <> 1
LEFT JOIN `misc_identifiers` AS `mi` ON `mi`.`participant_id` = `part`.`id` AND mi.misc_identifier_control_id=9
LEFT JOIN qc_lady_supplier_depts2 AS sd ON sd.collection_id=col.id
WHERE `col`.`deleted` <> 1;

INSERT INTO `structure_fields` (`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES 
('', '', 'ViewCollection', 'view_collection', 'qc_lady_supplier_dept_grouped', 'supplier departments', '', 'input', '', '', NULL , '', 'open', 'open', 'open');
INSERT INTO `structure_formats` (`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='view_collection'), (SELECT id FROM structure_fields WHERE model='ViewCollection' AND field='qc_lady_supplier_dept_grouped'), '1', '102', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '1', '1');

UPDATE structure_formats SET language_label='participant collection identifier', flag_override_label='1' WHERE structure_field_id=925;
UPDATE structure_formats SET flag_add='0', flag_edit='0', flag_index='0', flag_search='0', flag_detail='0' WHERE structure_field_id IN(SELECT id FROM structure_fields WHERE field='acquisition_label');

REPLACE INTO i18n(id, en, fr) VALUES
('participant collection identifier', "Participant Collection Identifier", "Identifiant de collection du participant"),
("supplier departments", "Supplier Departments", "Départements fournisseur");