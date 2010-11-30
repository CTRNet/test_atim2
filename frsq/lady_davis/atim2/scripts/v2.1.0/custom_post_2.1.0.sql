DROP VIEW view_collections;
CREATE VIEW `view_collections` AS SELECT `col`.`id` AS `collection_id`,`col`.`bank_id` AS `bank_id`,`col`.`sop_master_id` AS `sop_master_id`,
`link`.`participant_id` AS `participant_id`,`link`.`diagnosis_master_id` AS `diagnosis_master_id`,`link`.`consent_master_id` AS `consent_master_id`,
`mi`.`identifier_value` AS `participant_identifier`,`col`.`acquisition_label` AS `acquisition_label`,`col`.`collection_site` AS `collection_site`,
`col`.`collection_datetime` AS `collection_datetime`,`col`.`collection_datetime_accuracy` AS `collection_datetime_accuracy`,
`col`.`collection_property` AS `collection_property`,`col`.`collection_notes` AS `collection_notes`,`col`.`deleted` AS `deleted`,`banks`.`name` AS `bank_name`,
`col`.`created` AS `created`,
`col`.`qc_lady_type` AS qc_lady_type, `col`.`qc_lady_follow_up` AS qc_lady_follow_up
FROM (((`collections` `col` left join `clinical_collection_links` `link` on(((`col`.`id` = `link`.`collection_id`) and (`link`.`deleted` <> 1)))) 
LEFT JOIN `participants` `part` ON(((`link`.`participant_id` = `part`.`id`) AND (`part`.`deleted` <> 1)))) 
LEFT JOIN `banks` ON(((`col`.`bank_id` = `banks`.`id`) AND (`banks`.`deleted` <> 1))))
LEFT JOIN `misc_identifiers` AS `mi` ON (((`mi`.`participant_id` = `part`.`id`) AND (LCASE(SUBSTR(`mi`.`identifier_value`,1,1)) = LCASE(SUBSTR(`col`.`qc_lady_type`,1,1)))))
WHERE (`col`.`deleted` <> 1);

INSERT INTO i18n (`id`, `en`, `fr`) VALUES
("tissue type", "Tissue type", "Type de tissu"),
("contains", "Contains", "Contient"),
("extraction method", "Extraction method", "Méthode d'extraction"),
("storage solution", "Storage solution", "Solution d'entreposage");



select `ccl`.`collection_id` AS `collection_id`,`collections`.`bank_id` AS `bank_id`,`collections`.`sop_master_id` AS `sop_master_id`,`ccl`.`participant_id` AS `participant_id`,`ccl`.`diagnosis_master_id` AS `diagnosis_master_id`,`ccl`.`consent_master_id` AS `consent_master_id`,`collections`.`acquisition_label` AS `acquisition_label`,`collections`.`collection_site` AS `collection_site`,`collections`.`collection_datetime` AS `collection_datetime`,`collections`.`collection_datetime_accuracy` AS `collection_datetime_accuracy`,`collections`.`collection_property` AS `collection_property`,`collections`.`collection_notes` AS `collection_notes`,`collections`.`deleted` AS `deleted`,`collections`.`deleted_date` AS `deleted_date`,`mi`.`identifier_value` AS `participant_identifier`,`banks`.`name` AS `bank_name`,`sops`.`title` AS `sop_title`,`sops`.`code` AS `sop_code`,`sops`.`version` AS `sop_version`,`sops`.`sop_group` AS `sop_group`,`sops`.`type` AS `type`,`collections`.`qc_lady_type` AS `qc_lady_type`,`collections`.`qc_lady_follow_up` AS `qc_lady_follow_up` from 
(((((`collections` 
left join `clinical_collection_links` `ccl` on(((`collections`.`id` = `ccl`.`collection_id`) and (`ccl`.`deleted` <> 1)))) 
left join `participants` on(((`ccl`.`participant_id` = `participants`.`id`) and (`participants`.`deleted` <> 1)))) 
left join `banks` on(((`collections`.`bank_id` = `banks`.`id`) and (`banks`.`deleted` <> 1)))) 
left join `sop_masters` `sops` on(((`collections`.`sop_master_id` = `sops`.`id`) and (`sops`.`deleted` <> 1)))) 
left join `misc_identifiers` `mi` on(((`mi`.`participant_id` = `participants`.`id`) and (lcase(substr(`mi`.`identifier_value`,1,1)) = lcase(substr(`collections`.`qc_lady_type`,1,1)))))) */;