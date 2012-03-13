-- run post 2.4.1
DROP VIEW qc_lady_supplier_depts1;
CREATE VIEW qc_lady_supplier_depts1 AS
SELECT collection_id, supplier_dept AS supplier_dept 
FROM sample_masters AS sm
INNER JOIN sample_controls AS sc ON sm.sample_control_id=sc.id 
LEFT JOIN specimen_details AS sd ON sm.id=sd.sample_master_id
WHERE sample_category='specimen' AND sm.deleted != 1
GROUP BY collection_id, supplier_dept;

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='acquisition_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='linked_collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='acquisition_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

DELETE FROM structure_formats WHERE structure_field_id=(SELECT id FROM structure_fields WHERE field='qc_lady_label');
DELETE FROM structure_fields WHERE field='qc_lady_label';

DELETE FROM i18n WHERE id IN('event', 'deceased', 'precision', 'metastasis);
REPLACE INTO i18n (id, en, fr) VALUES
('may', 'May', 'Mai'),
('deceased', 'Deceased', 'Décédé'),
('event', 'Event', 'Événement'),
('precision', 'Precision', 'Précision'),
('metastasis', 'Metastasis', 'Métastase');
UPDATE aliquot_masters SET in_stock='yes - available' WHERE in_stock='available';
UPDATE aliquot_masters_revs SET in_stock='yes - available' WHERE in_stock='available';

UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='middle_name' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0', flag_search=0 WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='title' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='person title') AND `flag_confidential`='0');

UPDATE structure_fields SET  `type`='yes_no' WHERE model='ViewCollection' AND tablename='view_collections' AND field='qc_lady_pre_op' AND `type`='checkbox' AND structure_value_domain  IS NULL ;

ALTER TABLE collections
 MODIFY qc_lady_pre_op CHAR(1) NOT NULL DEFAULT '';
ALTER TABLE collections_revs
 MODIFY qc_lady_pre_op CHAR(1) NOT NULL DEFAULT '';
UPDATE collections SET qc_lady_pre_op='y' WHERE qc_lady_pre_op='1'; 
UPDATE collections SET qc_lady_pre_op='n' WHERE qc_lady_pre_op='0'; 
UPDATE collections_revs SET qc_lady_pre_op='y' WHERE qc_lady_pre_op='1'; 
UPDATE collections_revs SET qc_lady_pre_op='n' WHERE qc_lady_pre_op='0'; 

DROP VIEW view_samples;
CREATE VIEW `view_samples` AS select `samp`.`id` AS `sample_master_id`,`samp`.`parent_id` AS `parent_sample_id`,
`samp`.`initial_specimen_sample_id` AS `initial_specimen_sample_id`,`samp`.`collection_id` AS `collection_id`,`col`.`bank_id` AS `bank_id`,
`col`.`sop_master_id` AS `sop_master_id`,`link`.`participant_id` AS `participant_id`,`link`.`diagnosis_master_id` AS `diagnosis_master_id`,
`link`.`consent_master_id` AS `consent_master_id`,`mi`.`identifier_value` AS `participant_identifier`,
`col`.`acquisition_label` AS `acquisition_label`,`specimenc`.`sample_type` AS `initial_specimen_sample_type`,
`specimen`.`sample_control_id` AS `initial_specimen_sample_control_id`,`parent_sampc`.`sample_type` AS `parent_sample_type`,
`parent_samp`.`sample_control_id` AS `parent_sample_control_id`,`sampc`.`sample_type` AS `sample_type`,`samp`.`sample_control_id` AS `sample_control_id`,
`samp`.`sample_code` AS `sample_code`,`sampc`.`sample_category` AS `sample_category` 
FROM ((((((((`sample_masters` `samp`
join `sample_controls` `sampc` on((`samp`.`sample_control_id` = `sampc`.`id`)))
join `collections` `col` on(((`col`.`id` = `samp`.`collection_id`) and (`col`.`deleted` <> 1)))) 
left join `sample_masters` `specimen` on(((`samp`.`initial_specimen_sample_id` = `specimen`.`id`) and (`specimen`.`deleted` <> 1)))) 
left join `sample_controls` `specimenc` on((`specimen`.`sample_control_id` = `specimenc`.`id`))) 
left join `sample_masters` `parent_samp` on(((`samp`.`parent_id` = `parent_samp`.`id`) and (`parent_samp`.`deleted` <> 1)))) 
left join `sample_controls` `parent_sampc` on((`parent_samp`.`sample_control_id` = `parent_sampc`.`id`))) 
left join `clinical_collection_links` `link` on(((`col`.`id` = `link`.`collection_id`) and (`link`.`deleted` <> 1)))) 
left join `participants` `part` on(((`link`.`participant_id` = `part`.`id`) and (`part`.`deleted` <> 1))))
LEFT JOIN misc_identifiers AS mi ON mi.participant_id=part.id AND mi.misc_identifier_control_id=9 AND mi.deleted <> 1
where (`samp`.`deleted` <> 1);
 
DROP VIEW view_aliquots;
CREATE VIEW `view_aliquots` AS select `al`.`id` AS `aliquot_master_id`,`al`.`sample_master_id` AS `sample_master_id`,
`al`.`collection_id` AS `collection_id`,`col`.`bank_id` AS `bank_id`,`al`.`storage_master_id` AS `storage_master_id`,
`link`.`participant_id` AS `participant_id`,`link`.`diagnosis_master_id` AS `diagnosis_master_id`,`link`.`consent_master_id` AS `consent_master_id`,
`mi`.`identifier_value` AS `participant_identifier`,`col`.`acquisition_label` AS `acquisition_label`,
`specimenc`.`sample_type` AS `initial_specimen_sample_type`,`specimen`.`sample_control_id` AS `initial_specimen_sample_control_id`,
`parent_sampc`.`sample_type` AS `parent_sample_type`,`parent_samp`.`sample_control_id` AS `parent_sample_control_id`,
`sampc`.`sample_type` AS `sample_type`,`samp`.`sample_control_id` AS `sample_control_id`,`al`.`barcode` AS `barcode`,
`al`.`aliquot_label` AS `aliquot_label`,`alc`.`aliquot_type` AS `aliquot_type`,`al`.`aliquot_control_id` AS `aliquot_control_id`,
`al`.`in_stock` AS `in_stock`,`stor`.`code` AS `code`,`stor`.`selection_label` AS `selection_label`,`al`.`storage_coord_x` AS `storage_coord_x`,
`al`.`storage_coord_y` AS `storage_coord_y`,`stor`.`temperature` AS `temperature`,`stor`.`temp_unit` AS `temp_unit`,
`al`.`created` AS `created` 
from (((((((((((`aliquot_masters` `al`
join `aliquot_controls` `alc` on((`al`.`aliquot_control_id` = `alc`.`id`)))
join `sample_masters` `samp` on(((`samp`.`id` = `al`.`sample_master_id`) and (`samp`.`deleted` <> 1))))
join `sample_controls` `sampc` on((`samp`.`sample_control_id` = `sampc`.`id`)))
join `collections` `col` on(((`col`.`id` = `samp`.`collection_id`) and (`col`.`deleted` <> 1)))) 
left join `sample_masters` `specimen` on(((`samp`.`initial_specimen_sample_id` = `specimen`.`id`) and (`specimen`.`deleted` <> 1)))) 
left join `sample_controls` `specimenc` on((`specimen`.`sample_control_id` = `specimenc`.`id`))) 
left join `sample_masters` `parent_samp` on(((`samp`.`parent_id` = `parent_samp`.`id`) and (`parent_samp`.`deleted` <> 1)))) 
left join `sample_controls` `parent_sampc` on((`parent_samp`.`sample_control_id` = `parent_sampc`.`id`))) 
left join `clinical_collection_links` `link` on(((`col`.`id` = `link`.`collection_id`) and (`link`.`deleted` <> 1)))) 
left join `participants` `part` on(((`link`.`participant_id` = `part`.`id`) and (`part`.`deleted` <> 1))))
LEFT JOIN misc_identifiers AS mi ON part.id=mi.participant_id AND mi.misc_identifier_control_id=9 AND mi.deleted <> 1 
left join `storage_masters` `stor` on(((`stor`.`id` = `al`.`storage_master_id`) and (`stor`.`deleted` <> 1)))) 
where (`al`.`deleted` <> 1); 

UPDATE storage_controls SET coord_x_size=100 WHERE id=21;
UPDATE structure_fields SET  `setting`='' WHERE model='StorageMaster' AND tablename='storage_masters' AND field='short_label' AND `type`='input' AND structure_value_domain  IS NULL ;

-- ran on 2012-03-13
REPLACE INTO i18n (id, page_id, en, fr) VALUES
('rack 1-12', 'global', 'Rack 1-12', 'Étagère 1-12'),
('rack 4x4', 'global', 'Rack 4x4', 'Étagère 4x4'),
('freezer 4x5', 'global', 'Freezer 4x5', 'Congélateur 4x5'),
('freezer 6x5', 'global', 'Freezer 6x5', 'Congélateur 6x5'),
('freezer vertical 4x3', 'global', 'Vertical freezer 4x3', 'Congélateur vertical 4x3'),
('box100 1-100', '', 'Box100 1-100', 'Boîte100 1-100'),
('label', 'Label', 'Étiquette');

UPDATE structure_value_domains AS svd INNER JOIN structure_value_domains_permissible_values AS svdpv ON svdpv.structure_value_domain_id=svd.id INNER JOIN structure_permissible_values AS spv ON spv.id=svdpv.structure_permissible_value_id SET `flag_active`="1" WHERE svd.domain_name='block_type' AND spv.id=(SELECT id FROM structure_permissible_values WHERE value="OCT" AND language_alias="oct solution");

UPDATE structure_formats SET `flag_override_default`='1', `default`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_spec_tiss_blocks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='' AND `field`='block_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='block_type') AND `flag_confidential`='0');

UPDATE parent_to_derivative_sample_controls SET flag_active=true WHERE id IN(8, 9);


UPDATE structure_formats SET `flag_edit_readonly`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=216;
UPDATE structure_formats SET `flag_edit_readonly`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='aliquot_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

REPLACE INTO i18n (id, en, fr) VALUES
("barcode [%s] was created more than once", 
 "Barcode [%s] was created more than once.",
 "Le code à barres [%s] a été créé plus d'une fois."); 
 
 
