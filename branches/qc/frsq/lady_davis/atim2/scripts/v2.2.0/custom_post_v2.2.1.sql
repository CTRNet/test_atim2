REPLACE INTO i18n (id, en, fr) VALUES
("the collection identifier cannot be deleted", "The collection identifier cannot be deleted", "L'identifiant de collection ne peut pas être supprimé"),
("supplier departments", "Supplier Departments", "Départements fournisseur"),
('core_installname', "Lady Davis - Breast", "Lady Davis - Sein"),
('qc_lady_participant_bt_query_desc', "Searches for participants having B and T collections", "Cherche les participant ayant les collections B et T"),
('qc_lady_participant_bmt_query_desc', "Searches for participants having B, M and T collections", "Cherche les participant ayant les colletions B, M et T"),
('participant B-T', 'Participant B-T', 'Participant B-T');

INSERT INTO datamart_adhoc (title, description, plugin, model, form_alias_for_search, form_alias_for_results, form_links_for_results, sql_query_for_results, flag_use_query_results) VALUES
('participant B-T', 'qc_lady_participant_bt_query_desc', 'clinicalannotation', 'Participant', 'participants', 'participants', '', 
'SELECT Participant.* FROM clinical_collection_links AS ccl_tumor
 INNER JOIN collections AS c_tumor ON ccl_tumor.collection_id=c_tumor.id AND c_tumor.qc_lady_type="tumor"
 INNER JOIN participants AS Participant ON Participant.id= ccl_tumor.participant_id
 WHERE participant_id IN(
  SELECT participant_id FROM clinical_collection_links AS ccl_biopsy
  INNER JOIN collections AS c_biopsy ON ccl_biopsy.collection_id=c_biopsy.id AND c_biopsy.qc_lady_type="biopsy"
  INNER JOIN participants AS Participant ON ccl_biopsy.participant_id=Participant.id
  WHERE Participant.created >= "@@Participant.created_start@@" AND Participant.created <= "@@Participant.created_end@@"
  AND Participant.title = "@@Participant.title@@" AND Participant.first_name = "@@Participant.first_name@@"
  AND Participant.last_name = "@@Participant.last_name@@" AND Participant.race = "@@Participant.race@@" AND Participant.sex = "@@Participant.sex@@"
  AND Participant.deleted=0
)',
false);

ALTER TABLE collections
 ADD COLUMN qc_lady_pre_op TINYINT UNSIGNED DEFAULT NULL;
ALTER TABLE collections_revs
 ADD COLUMN qc_lady_pre_op TINYINT UNSIGNED DEFAULT NULL;
 
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Inventorymanagement', 'Collection', 'collections', 'qc_lady_pre_op', 'checkbox',  NULL , '0', '', '', '', 'pre-op', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='collections'), (SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='qc_lady_pre_op' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='pre-op' AND `language_tag`=''), '1', '103', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1');

DROP VIEW view_collections;
CREATE VIEW `view_collections` AS select `col`.`id` AS `collection_id`,`col`.`bank_id` AS `bank_id`,`col`.`sop_master_id` AS `sop_master_id`,
 `link`.`participant_id` AS `participant_id`,`link`.`diagnosis_master_id` AS `diagnosis_master_id`,`link`.`consent_master_id` AS `consent_master_id`,
 `mi`.`identifier_value` AS `participant_identifier`,`col`.`acquisition_label` AS `acquisition_label`,`col`.`collection_site` AS `collection_site`,
 `col`.`collection_datetime` AS `collection_datetime`,`col`.`collection_datetime_accuracy` AS `collection_datetime_accuracy`,
 `col`.`collection_property` AS `collection_property`,`col`.`collection_notes` AS `collection_notes`,`col`.`deleted` AS `deleted`,
 `banks`.`name` AS `bank_name`,`col`.`created` AS `created`,`col`.`qc_lady_type` AS `qc_lady_type`,`col`.`qc_lady_follow_up` AS `qc_lady_follow_up`,
 `col`.`qc_lady_pre_op` AS `qc_lady_pre_op`, 
 `sd`.`supplier_dept_grouped` AS `qc_lady_supplier_dept_grouped` 
from (((((`collections` `col` 
 left join `clinical_collection_links` `link` on(((`col`.`id` = `link`.`collection_id`) and (`link`.`deleted` <> 1)))) 
 left join `participants` `part` on(((`link`.`participant_id` = `part`.`id`) and (`part`.`deleted` <> 1)))) 
 left join `banks` on(((`col`.`bank_id` = `banks`.`id`) and (`banks`.`deleted` <> 1)))) 
 left join `misc_identifiers` `mi` on(((`mi`.`participant_id` = `part`.`id`) and (`mi`.`misc_identifier_control_id` = 9)))) 
 left join `qc_lady_supplier_depts2` `sd` on((`sd`.`collection_id` = `col`.`id`))) 
where (`col`.`deleted` <> 1);

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Inventorymanagement', 'ViewCollection', 'view_collections', 'qc_lady_pre_op', 'checkbox',  NULL , '0', '', '', '', 'pre-op', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='view_collection'), (SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='view_collections' AND `field`='qc_lady_pre_op' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='pre-op' AND `language_tag`=''), '1', '101', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='clinicalcollectionlinks'), (SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='qc_lady_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_lady_coll_type')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='type' AND `language_tag`=''), '0', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1'),
((SELECT id FROM structures WHERE alias='clinicalcollectionlinks'), (SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='qc_lady_follow_up' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_lady_coll_follow_up')  AND `flag_confidential`='0'), '0', '4', '', '1', 'follow up (months)', '0', '', '0', '', '0', '', '1', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '1'),
((SELECT id FROM structures WHERE alias='clinicalcollectionlinks'), (SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='qc_lady_pre_op' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='pre-op' AND `language_tag`=''), '0', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1');


