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
