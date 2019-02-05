REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('core_installname', 'iCord v0.2.6', '');


REPLACE INTO `i18n` (`id`, `en`, `fr`)
VALUES 
('occiput', 'Occiput', ''),
('coccyx', 'Coccyx', ''),
('ilium', 'Ilium', ''),
('Animal Details', 'Animal Details', '');


REPLACE INTO `i18n` (`id`, `en`, `fr`)
VALUES 
('c1', 'C1', ''),
('c2', 'C2', ''),
('c3', 'C3', ''),
('c4', 'C4', ''),
('c5', 'C5', ''),
('c6', 'C6', ''),
('c7', 'C7', '');

REPLACE INTO `i18n` (`id`, `en`, `fr`)
VALUES 
('t1', 'T1', ''),
('t2', 'T2', ''),
('t3', 'T3', ''),
('t4', 'T4', ''),
('t5', 'T5', ''),
('t6', 'T6', ''),
('t7', 'T7', ''),
('t8', 'T8', ''),
('t9', 'T9', ''),
('t10', 'T10', ''),
('t11', 'T11', ''),
('t12', 'T12', '');

REPLACE INTO `i18n` (`id`, `en`, `fr`)
VALUES 
('l1', 'L1', ''),
('l2', 'L2', ''),
('l3', 'L3', ''),
('l4', 'L4', ''),
('l5', 'L5', ''),
('l6', 'L6', '');

REPLACE INTO `i18n` (`id`, `en`, `fr`)
VALUES 
('s1', 'S1', ''),
('s2', 'S2', ''),
('s3', 'S3', ''),
('s4', 'S4', ''),
('s5', 'S5', '');

REPLACE INTO `i18n` (`id`, `en`, `fr`)
VALUES 
('Locations of Injury (Occiput, C, T)', 'Locations of Injury (Occiput, C, T)', ''),
('Locations of Injury (L, S, Coccyx, Ilium)', 'Locations of Injury (L, S, Coccyx, Ilium)', '');



UPDATE structure_formats
SET `display_order` = `display_order` + 100
WHERE `display_column` = 2
AND `structure_id` = (SELECT `id` FROM structures WHERE `alias` = 'cd_biobanks');

UPDATE structure_formats
SET `display_column` = 1
WHERE `display_column` = 2
AND `structure_id` = (SELECT `id` FROM structures WHERE `alias` = 'cd_biobanks');

ALTER TABLE cd_biobanks
ADD COLUMN `injury_location_ilium` TINYINT DEFAULT 0 AFTER `admission_location_of_injury`,
ADD COLUMN `injury_location_coccyx` TINYINT DEFAULT 0 AFTER `admission_location_of_injury`,
ADD COLUMN `injury_location_s5` TINYINT DEFAULT 0 AFTER `admission_location_of_injury`,
ADD COLUMN `injury_location_s4` TINYINT DEFAULT 0 AFTER `admission_location_of_injury`,
ADD COLUMN `injury_location_s3` TINYINT DEFAULT 0 AFTER `admission_location_of_injury`,
ADD COLUMN `injury_location_s2` TINYINT DEFAULT 0 AFTER `admission_location_of_injury`,
ADD COLUMN `injury_location_s1` TINYINT DEFAULT 0 AFTER `admission_location_of_injury`,
ADD COLUMN `injury_location_l6` TINYINT DEFAULT 0 AFTER `admission_location_of_injury`,
ADD COLUMN `injury_location_l5` TINYINT DEFAULT 0 AFTER `admission_location_of_injury`,
ADD COLUMN `injury_location_l4` TINYINT DEFAULT 0 AFTER `admission_location_of_injury`,
ADD COLUMN `injury_location_l3` TINYINT DEFAULT 0 AFTER `admission_location_of_injury`,
ADD COLUMN `injury_location_l2` TINYINT DEFAULT 0 AFTER `admission_location_of_injury`,
ADD COLUMN `injury_location_l1` TINYINT DEFAULT 0 AFTER `admission_location_of_injury`,
ADD COLUMN `injury_location_t12` TINYINT DEFAULT 0 AFTER `admission_location_of_injury`,
ADD COLUMN `injury_location_t11` TINYINT DEFAULT 0 AFTER `admission_location_of_injury`,
ADD COLUMN `injury_location_t10` TINYINT DEFAULT 0 AFTER `admission_location_of_injury`,
ADD COLUMN `injury_location_t9` TINYINT DEFAULT 0 AFTER `admission_location_of_injury`,
ADD COLUMN `injury_location_t8` TINYINT DEFAULT 0 AFTER `admission_location_of_injury`,
ADD COLUMN `injury_location_t7` TINYINT DEFAULT 0 AFTER `admission_location_of_injury`,
ADD COLUMN `injury_location_t6` TINYINT DEFAULT 0 AFTER `admission_location_of_injury`,
ADD COLUMN `injury_location_t5` TINYINT DEFAULT 0 AFTER `admission_location_of_injury`,
ADD COLUMN `injury_location_t4` TINYINT DEFAULT 0 AFTER `admission_location_of_injury`,
ADD COLUMN `injury_location_t3` TINYINT DEFAULT 0 AFTER `admission_location_of_injury`,
ADD COLUMN `injury_location_t2` TINYINT DEFAULT 0 AFTER `admission_location_of_injury`,
ADD COLUMN `injury_location_t1` TINYINT DEFAULT 0 AFTER `admission_location_of_injury`,
ADD COLUMN `injury_location_c7` TINYINT DEFAULT 0 AFTER `admission_location_of_injury`,
ADD COLUMN `injury_location_c6` TINYINT DEFAULT 0 AFTER `admission_location_of_injury`,
ADD COLUMN `injury_location_c5` TINYINT DEFAULT 0 AFTER `admission_location_of_injury`,
ADD COLUMN `injury_location_c4` TINYINT DEFAULT 0 AFTER `admission_location_of_injury`,
ADD COLUMN `injury_location_c3` TINYINT DEFAULT 0 AFTER `admission_location_of_injury`,
ADD COLUMN `injury_location_c2` TINYINT DEFAULT 0 AFTER `admission_location_of_injury`,
ADD COLUMN `injury_location_c1` TINYINT DEFAULT 0 AFTER `admission_location_of_injury`,
ADD COLUMN `injury_location_occiput` TINYINT DEFAULT 0 AFTER `admission_location_of_injury`;

ALTER TABLE cd_biobanks_revs
ADD COLUMN `injury_location_ilium` TINYINT DEFAULT 0 AFTER `admission_location_of_injury`,
ADD COLUMN `injury_location_coccyx` TINYINT DEFAULT 0 AFTER `admission_location_of_injury`,
ADD COLUMN `injury_location_s5` TINYINT DEFAULT 0 AFTER `admission_location_of_injury`,
ADD COLUMN `injury_location_s4` TINYINT DEFAULT 0 AFTER `admission_location_of_injury`,
ADD COLUMN `injury_location_s3` TINYINT DEFAULT 0 AFTER `admission_location_of_injury`,
ADD COLUMN `injury_location_s2` TINYINT DEFAULT 0 AFTER `admission_location_of_injury`,
ADD COLUMN `injury_location_s1` TINYINT DEFAULT 0 AFTER `admission_location_of_injury`,
ADD COLUMN `injury_location_l6` TINYINT DEFAULT 0 AFTER `admission_location_of_injury`,
ADD COLUMN `injury_location_l5` TINYINT DEFAULT 0 AFTER `admission_location_of_injury`,
ADD COLUMN `injury_location_l4` TINYINT DEFAULT 0 AFTER `admission_location_of_injury`,
ADD COLUMN `injury_location_l3` TINYINT DEFAULT 0 AFTER `admission_location_of_injury`,
ADD COLUMN `injury_location_l2` TINYINT DEFAULT 0 AFTER `admission_location_of_injury`,
ADD COLUMN `injury_location_l1` TINYINT DEFAULT 0 AFTER `admission_location_of_injury`,
ADD COLUMN `injury_location_t12` TINYINT DEFAULT 0 AFTER `admission_location_of_injury`,
ADD COLUMN `injury_location_t11` TINYINT DEFAULT 0 AFTER `admission_location_of_injury`,
ADD COLUMN `injury_location_t10` TINYINT DEFAULT 0 AFTER `admission_location_of_injury`,
ADD COLUMN `injury_location_t9` TINYINT DEFAULT 0 AFTER `admission_location_of_injury`,
ADD COLUMN `injury_location_t8` TINYINT DEFAULT 0 AFTER `admission_location_of_injury`,
ADD COLUMN `injury_location_t7` TINYINT DEFAULT 0 AFTER `admission_location_of_injury`,
ADD COLUMN `injury_location_t6` TINYINT DEFAULT 0 AFTER `admission_location_of_injury`,
ADD COLUMN `injury_location_t5` TINYINT DEFAULT 0 AFTER `admission_location_of_injury`,
ADD COLUMN `injury_location_t4` TINYINT DEFAULT 0 AFTER `admission_location_of_injury`,
ADD COLUMN `injury_location_t3` TINYINT DEFAULT 0 AFTER `admission_location_of_injury`,
ADD COLUMN `injury_location_t2` TINYINT DEFAULT 0 AFTER `admission_location_of_injury`,
ADD COLUMN `injury_location_t1` TINYINT DEFAULT 0 AFTER `admission_location_of_injury`,
ADD COLUMN `injury_location_c7` TINYINT DEFAULT 0 AFTER `admission_location_of_injury`,
ADD COLUMN `injury_location_c6` TINYINT DEFAULT 0 AFTER `admission_location_of_injury`,
ADD COLUMN `injury_location_c5` TINYINT DEFAULT 0 AFTER `admission_location_of_injury`,
ADD COLUMN `injury_location_c4` TINYINT DEFAULT 0 AFTER `admission_location_of_injury`,
ADD COLUMN `injury_location_c3` TINYINT DEFAULT 0 AFTER `admission_location_of_injury`,
ADD COLUMN `injury_location_c2` TINYINT DEFAULT 0 AFTER `admission_location_of_injury`,
ADD COLUMN `injury_location_c1` TINYINT DEFAULT 0 AFTER `admission_location_of_injury`,
ADD COLUMN `injury_location_occiput` TINYINT DEFAULT 0 AFTER `admission_location_of_injury`;


INSERT INTO structure_fields 
(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`,`flag_confidential`) VALUES
('ClinicalAnnotation', 'ConsentDetail', 'cd_biobanks', 'injury_location_occiput', 'occiput', '', 'checkbox', '', '', NULL, '', 0),
('ClinicalAnnotation', 'ConsentDetail', 'cd_biobanks', 'injury_location_c1', 'c1', '', 'checkbox', '', '', NULL, '', 0),
('ClinicalAnnotation', 'ConsentDetail', 'cd_biobanks', 'injury_location_c2', 'c2', '', 'checkbox', '', '', NULL, '', 0),
('ClinicalAnnotation', 'ConsentDetail', 'cd_biobanks', 'injury_location_c3', 'c3', '', 'checkbox', '', '', NULL, '', 0),
('ClinicalAnnotation', 'ConsentDetail', 'cd_biobanks', 'injury_location_c4', 'c4', '', 'checkbox', '', '', NULL, '', 0),
('ClinicalAnnotation', 'ConsentDetail', 'cd_biobanks', 'injury_location_c5', 'c5', '', 'checkbox', '', '', NULL, '', 0),
('ClinicalAnnotation', 'ConsentDetail', 'cd_biobanks', 'injury_location_c6', 'c6', '', 'checkbox', '', '', NULL, '', 0),
('ClinicalAnnotation', 'ConsentDetail', 'cd_biobanks', 'injury_location_c7', 'c7', '', 'checkbox', '', '', NULL, '', 0);

INSERT INTO `structure_formats` (`structure_id`, `structure_field_id`, 
`display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, 
`flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, 
`flag_index`, `flag_detail`, `flag_summary`, `flag_float`, `margin`)
VALUES
((SELECT `id` FROM structures WHERE `alias` = 'cd_biobanks'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_biobanks' AND `field`='injury_location_occiput' AND `type`='checkbox'), 
2, 10, 'Locations of Injury (Occiput, C, T)', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 
1, 0, 0, 0, 0, 0, 
0, 1, 0, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'cd_biobanks'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_biobanks' AND `field`='injury_location_c1' AND `type`='checkbox'), 
2, 12, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 
1, 0, 0, 0, 0, 0, 
0, 1, 0, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'cd_biobanks'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_biobanks' AND `field`='injury_location_c2' AND `type`='checkbox'), 
2, 14, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 
1, 0, 0, 0, 0, 0, 
0, 1, 0, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'cd_biobanks'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_biobanks' AND `field`='injury_location_c3' AND `type`='checkbox'), 
2, 16, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 
1, 0, 0, 0, 0, 0, 
0, 1, 0, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'cd_biobanks'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_biobanks' AND `field`='injury_location_c4' AND `type`='checkbox'), 
2, 18, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 
1, 0, 0, 0, 0, 0, 
0, 1, 0, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'cd_biobanks'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_biobanks' AND `field`='injury_location_c5' AND `type`='checkbox'), 
2, 20, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 
1, 0, 0, 0, 0, 0, 
0, 1, 0, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'cd_biobanks'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_biobanks' AND `field`='injury_location_c6' AND `type`='checkbox'), 
2, 22, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 
1, 0, 0, 0, 0, 0, 
0, 1, 0, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'cd_biobanks'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_biobanks' AND `field`='injury_location_c7' AND `type`='checkbox'), 
2, 24, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 
1, 0, 0, 0, 0, 0, 
0, 1, 0, 0, 0);


INSERT INTO structure_fields 
(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`,`flag_confidential`) VALUES
('ClinicalAnnotation', 'ConsentDetail', 'cd_biobanks', 'injury_location_t1', 't1', '', 'checkbox', '', '', NULL, '', 0),
('ClinicalAnnotation', 'ConsentDetail', 'cd_biobanks', 'injury_location_t2', 't2', '', 'checkbox', '', '', NULL, '', 0),
('ClinicalAnnotation', 'ConsentDetail', 'cd_biobanks', 'injury_location_t3', 't3', '', 'checkbox', '', '', NULL, '', 0),
('ClinicalAnnotation', 'ConsentDetail', 'cd_biobanks', 'injury_location_t4', 't4', '', 'checkbox', '', '', NULL, '', 0),
('ClinicalAnnotation', 'ConsentDetail', 'cd_biobanks', 'injury_location_t5', 't5', '', 'checkbox', '', '', NULL, '', 0),
('ClinicalAnnotation', 'ConsentDetail', 'cd_biobanks', 'injury_location_t6', 't6', '', 'checkbox', '', '', NULL, '', 0),
('ClinicalAnnotation', 'ConsentDetail', 'cd_biobanks', 'injury_location_t7', 't7', '', 'checkbox', '', '', NULL, '', 0),
('ClinicalAnnotation', 'ConsentDetail', 'cd_biobanks', 'injury_location_t8', 't8', '', 'checkbox', '', '', NULL, '', 0),
('ClinicalAnnotation', 'ConsentDetail', 'cd_biobanks', 'injury_location_t9', 't9', '', 'checkbox', '', '', NULL, '', 0),
('ClinicalAnnotation', 'ConsentDetail', 'cd_biobanks', 'injury_location_t10', 't10', '', 'checkbox', '', '', NULL, '', 0),
('ClinicalAnnotation', 'ConsentDetail', 'cd_biobanks', 'injury_location_t11', 't11', '', 'checkbox', '', '', NULL, '', 0),
('ClinicalAnnotation', 'ConsentDetail', 'cd_biobanks', 'injury_location_t12', 't12', '', 'checkbox', '', '', NULL, '', 0);

INSERT INTO `structure_formats` (`structure_id`, `structure_field_id`, 
`display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, 
`flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, 
`flag_index`, `flag_detail`, `flag_summary`, `flag_float`, `margin`)
VALUES
((SELECT `id` FROM structures WHERE `alias` = 'cd_biobanks'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_biobanks' AND `field`='injury_location_t1' AND `type`='checkbox'), 
2, 30, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 
1, 0, 0, 0, 0, 0, 
0, 1, 0, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'cd_biobanks'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_biobanks' AND `field`='injury_location_t2' AND `type`='checkbox'), 
2, 32, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 
1, 0, 0, 0, 0, 0, 
0, 1, 0, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'cd_biobanks'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_biobanks' AND `field`='injury_location_t3' AND `type`='checkbox'), 
2, 34, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 
1, 0, 0, 0, 0, 0, 
0, 1, 0, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'cd_biobanks'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_biobanks' AND `field`='injury_location_t4' AND `type`='checkbox'), 
2, 36, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 
1, 0, 0, 0, 0, 0, 
0, 1, 0, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'cd_biobanks'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_biobanks' AND `field`='injury_location_t5' AND `type`='checkbox'), 
2, 38, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 
1, 0, 0, 0, 0, 0, 
0, 1, 0, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'cd_biobanks'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_biobanks' AND `field`='injury_location_t6' AND `type`='checkbox'), 
2, 40, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 
1, 0, 0, 0, 0, 0, 
0, 1, 0, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'cd_biobanks'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_biobanks' AND `field`='injury_location_t7' AND `type`='checkbox'), 
2, 42, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 
1, 0, 0, 0, 0, 0, 
0, 1, 0, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'cd_biobanks'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_biobanks' AND `field`='injury_location_t8' AND `type`='checkbox'), 
2, 44, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 
1, 0, 0, 0, 0, 0, 
0, 1, 0, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'cd_biobanks'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_biobanks' AND `field`='injury_location_t9' AND `type`='checkbox'), 
2, 46, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 
1, 0, 0, 0, 0, 0, 
0, 1, 0, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'cd_biobanks'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_biobanks' AND `field`='injury_location_t10' AND `type`='checkbox'), 
2, 48, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 
1, 0, 0, 0, 0, 0, 
0, 1, 0, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'cd_biobanks'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_biobanks' AND `field`='injury_location_t11' AND `type`='checkbox'), 
2, 50, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 
1, 0, 0, 0, 0, 0, 
0, 1, 0, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'cd_biobanks'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_biobanks' AND `field`='injury_location_t12' AND `type`='checkbox'), 
2, 52, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 
1, 0, 0, 0, 0, 0, 
0, 1, 0, 0, 0);

INSERT INTO structure_fields 
(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`,`flag_confidential`) VALUES
('ClinicalAnnotation', 'ConsentDetail', 'cd_biobanks', 'injury_location_l1', 'l1', '', 'checkbox', '', '', NULL, '', 0),
('ClinicalAnnotation', 'ConsentDetail', 'cd_biobanks', 'injury_location_l2', 'l2', '', 'checkbox', '', '', NULL, '', 0),
('ClinicalAnnotation', 'ConsentDetail', 'cd_biobanks', 'injury_location_l3', 'l3', '', 'checkbox', '', '', NULL, '', 0),
('ClinicalAnnotation', 'ConsentDetail', 'cd_biobanks', 'injury_location_l4', 'l4', '', 'checkbox', '', '', NULL, '', 0),
('ClinicalAnnotation', 'ConsentDetail', 'cd_biobanks', 'injury_location_l5', 'l5', '', 'checkbox', '', '', NULL, '', 0),
('ClinicalAnnotation', 'ConsentDetail', 'cd_biobanks', 'injury_location_l6', 'l6', '', 'checkbox', '', '', NULL, '', 0);

INSERT INTO `structure_formats` (`structure_id`, `structure_field_id`, 
`display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, 
`flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, 
`flag_index`, `flag_detail`, `flag_summary`, `flag_float`, `margin`)
VALUES
((SELECT `id` FROM structures WHERE `alias` = 'cd_biobanks'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_biobanks' AND `field`='injury_location_l1' AND `type`='checkbox'), 
3, 10, 'Locations of Injury (L, S, Coccyx, Ilium)', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 
1, 0, 0, 0, 0, 0, 
0, 1, 0, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'cd_biobanks'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_biobanks' AND `field`='injury_location_l2' AND `type`='checkbox'), 
3, 12, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 
1, 0, 0, 0, 0, 0, 
0, 1, 0, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'cd_biobanks'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_biobanks' AND `field`='injury_location_l3' AND `type`='checkbox'), 
3, 14, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 
1, 0, 0, 0, 0, 0, 
0, 1, 0, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'cd_biobanks'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_biobanks' AND `field`='injury_location_l4' AND `type`='checkbox'), 
3, 16, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 
1, 0, 0, 0, 0, 0, 
0, 1, 0, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'cd_biobanks'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_biobanks' AND `field`='injury_location_l5' AND `type`='checkbox'), 
3, 18, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 
1, 0, 0, 0, 0, 0, 
0, 1, 0, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'cd_biobanks'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_biobanks' AND `field`='injury_location_l6' AND `type`='checkbox'), 
3, 20, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 
1, 0, 0, 0, 0, 0, 
0, 1, 0, 0, 0);





INSERT INTO structure_fields 
(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`,`flag_confidential`) VALUES
('ClinicalAnnotation', 'ConsentDetail', 'cd_biobanks', 'injury_location_s1', 's1', '', 'checkbox', '', '', NULL, '', 0),
('ClinicalAnnotation', 'ConsentDetail', 'cd_biobanks', 'injury_location_s2', 's2', '', 'checkbox', '', '', NULL, '', 0),
('ClinicalAnnotation', 'ConsentDetail', 'cd_biobanks', 'injury_location_s3', 's3', '', 'checkbox', '', '', NULL, '', 0),
('ClinicalAnnotation', 'ConsentDetail', 'cd_biobanks', 'injury_location_s4', 's4', '', 'checkbox', '', '', NULL, '', 0),
('ClinicalAnnotation', 'ConsentDetail', 'cd_biobanks', 'injury_location_s5', 's5', '', 'checkbox', '', '', NULL, '', 0),
('ClinicalAnnotation', 'ConsentDetail', 'cd_biobanks', 'injury_location_coccyx', 'coccyx', '', 'checkbox', '', '', NULL, '', 0),
('ClinicalAnnotation', 'ConsentDetail', 'cd_biobanks', 'injury_location_ilium', 'ilium', '', 'checkbox', '', '', NULL, '', 0);



INSERT INTO `structure_formats` (`structure_id`, `structure_field_id`, 
`display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, 
`flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, 
`flag_index`, `flag_detail`, `flag_summary`, `flag_float`, `margin`)
VALUES
((SELECT `id` FROM structures WHERE `alias` = 'cd_biobanks'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_biobanks' AND `field`='injury_location_s1' AND `type`='checkbox'), 
3, 30, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 
1, 0, 0, 0, 0, 0, 
0, 1, 0, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'cd_biobanks'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_biobanks' AND `field`='injury_location_s2' AND `type`='checkbox'), 
3, 32, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 
1, 0, 0, 0, 0, 0, 
0, 1, 0, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'cd_biobanks'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_biobanks' AND `field`='injury_location_s3' AND `type`='checkbox'), 
3, 34, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 
1, 0, 0, 0, 0, 0, 
0, 1, 0, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'cd_biobanks'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_biobanks' AND `field`='injury_location_s4' AND `type`='checkbox'), 
3, 36, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 
1, 0, 0, 0, 0, 0, 
0, 1, 0, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'cd_biobanks'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_biobanks' AND `field`='injury_location_s5' AND `type`='checkbox'), 
3, 38, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 
1, 0, 0, 0, 0, 0, 
0, 1, 0, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'cd_biobanks'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_biobanks' AND `field`='injury_location_coccyx' AND `type`='checkbox'), 
3, 40, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 
1, 0, 0, 0, 0, 0, 
0, 1, 0, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'cd_biobanks'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_biobanks' AND `field`='injury_location_ilium' AND `type`='checkbox'), 
3, 42, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 
1, 0, 0, 0, 0, 0, 
0, 1, 0, 0, 0);


-- Reactivate the Diagnosis

UPDATE menus
set `flag_active` = 1
WHERE `id` = 'clin_CAN_5' AND `parent_id` = 'clin_CAN_1' AND `language_title` = 'diagnosis';

-- Create animal diagnosis

CREATE TABLE `dxd_animals` (
	`diagnosis_master_id` INT(11) NOT NULL,
	`species` VARCHAR(100) NULL DEFAULT NULL,
	`breed` VARCHAR(100) NULL DEFAULT NULL,
	`common_name` VARCHAR(100) NULL DEFAULT NULL,
	`animal_id` VARCHAR(100) NULL DEFAULT NULL,
	`pig_body_weight_surgery` DECIMAL(5,2) NULL DEFAULT NULL,
	`pig_injury_type` VARCHAR(50) NULL DEFAULT NULL,
	`injury_level` VARCHAR(200) NULL DEFAULT NULL,
	`pig_injury_height` DECIMAL(5,2) NULL DEFAULT NULL,
	`pig_injury_force` DECIMAL(5,2) NULL DEFAULT NULL,
	`pig_compression` VARCHAR(25) NULL DEFAULT NULL,
	`pig_compression_time` DECIMAL(7,2) NULL DEFAULT NULL,
	`pig_surgery_detail` TEXT NULL,
	`pig_sacrifice_datetime` DATETIME NULL DEFAULT NULL,
	`pig_sacrifice_datetime_accuracy` CHAR(1) NULL DEFAULT NULL,
	`surgery_datetime` DATETIME NULL DEFAULT NULL,
	`surgery_datetime_accuracy` CHAR(1) NOT NULL DEFAULT '',
	INDEX `diagnosis_master_id` (`diagnosis_master_id`)
)
COLLATE='latin1_swedish_ci'
ENGINE=InnoDB;

CREATE TABLE `dxd_animals_revs` (
	`diagnosis_master_id` INT(11) NOT NULL,
	`species` VARCHAR(100) NULL DEFAULT NULL,
	`breed` VARCHAR(100) NULL DEFAULT NULL,
	`common_name` VARCHAR(100) NULL DEFAULT NULL,
	`animal_id` VARCHAR(100) NULL DEFAULT NULL,
	`pig_body_weight_surgery` DECIMAL(5,2) NULL DEFAULT NULL,
	`pig_injury_type` VARCHAR(50) NULL DEFAULT NULL,
	`injury_level` VARCHAR(200) NULL DEFAULT NULL,
	`pig_injury_height` DECIMAL(5,2) NULL DEFAULT NULL,
	`pig_injury_force` DECIMAL(5,2) NULL DEFAULT NULL,
	`pig_compression` VARCHAR(25) NULL DEFAULT NULL,
	`pig_compression_time` DECIMAL(7,2) NULL DEFAULT NULL,
	`pig_surgery_detail` TEXT NULL,
	`pig_sacrifice_datetime` DATETIME NULL DEFAULT NULL,
	`pig_sacrifice_datetime_accuracy` CHAR(1) NULL DEFAULT NULL,
	`surgery_datetime` DATETIME NULL DEFAULT NULL,
	`surgery_datetime_accuracy` CHAR(1) NOT NULL DEFAULT '',
	`version_id` INT(11) NOT NULL AUTO_INCREMENT,
	`version_created` DATETIME NOT NULL,
	PRIMARY KEY (`version_id`)
)
COLLATE='latin1_swedish_ci'
ENGINE=InnoDB;


INSERT INTO diagnosis_controls
(`category`, `controls_type`, `flag_active`, `detail_form_alias`, `detail_tablename`, `display_order`, `databrowser_label`, `flag_compare_with_cap`)
VALUES
('primary', 'animal', 1, 'dx_primary,dx_animals', 'dxd_animals', 0, 'primary|animal', 1);

DELETE FROM structure_formats
WHERE
`structure_id` = (SELECT `id` FROM structures WHERE `alias` = 'participants')
AND
`structure_field_id` IN (SELECT `id` FROM structure_fields WHERE `plugin` = 'ClinicalAnnotation' AND `model` = 'Participant' AND `tablename` = 'participants'
AND `field` IN ('icord_species', 'icord_breed', 'icord_common_name', 'icord_animal_id', 'icord_pig_body_weight_surgery', 'icord_pig_injury_type', 'icord_injury_level',
 'icord_pig_injury_height','icord_pig_injury_force','icord_pig_compression','icord_pig_compression_time','icord_pig_surgery_detail', 'icord_pig_sacrifice_datetime',
 'icord_surgery_datetime'));

UPDATE structure_fields
SET `model` = 'DiagnosisDetail', `tablename` = 'dxd_animals', `field` = 'species'
WHERE `model` = 'Participant' AND `tablename` = 'participants' AND `field` = 'icord_species';
UPDATE structure_fields
SET `model` = 'DiagnosisDetail', `tablename` = 'dxd_animals', `field` = 'breed'
WHERE `model` = 'Participant' AND `tablename` = 'participants' AND `field` = 'icord_breed';
UPDATE structure_fields
SET `model` = 'DiagnosisDetail', `tablename` = 'dxd_animals', `field` = 'common_name'
WHERE `model` = 'Participant' AND `tablename` = 'participants' AND `field` = 'icord_common_name';
UPDATE structure_fields
SET `model` = 'DiagnosisDetail', `tablename` = 'dxd_animals', `field` = 'animal_id'
WHERE `model` = 'Participant' AND `tablename` = 'participants' AND `field` = 'icord_animal_id';
UPDATE structure_fields
SET `model` = 'DiagnosisDetail', `tablename` = 'dxd_animals', `field` = 'pig_body_weight_surgery'
WHERE `model` = 'Participant' AND `tablename` = 'participants' AND `field` = 'icord_pig_body_weight_surgery';
UPDATE structure_fields
SET `model` = 'DiagnosisDetail', `tablename` = 'dxd_animals', `field` = 'pig_injury_type'
WHERE `model` = 'Participant' AND `tablename` = 'participants' AND `field` = 'icord_pig_injury_type';
UPDATE structure_fields
SET `model` = 'DiagnosisDetail', `tablename` = 'dxd_animals', `field` = 'injury_level'
WHERE `model` = 'Participant' AND `tablename` = 'participants' AND `field` = 'icord_injury_level';
UPDATE structure_fields
SET `model` = 'DiagnosisDetail', `tablename` = 'dxd_animals', `field` = 'pig_injury_height'
WHERE `model` = 'Participant' AND `tablename` = 'participants' AND `field` = 'icord_pig_injury_height';
UPDATE structure_fields
SET `model` = 'DiagnosisDetail', `tablename` = 'dxd_animals', `field` = 'pig_injury_force'
WHERE `model` = 'Participant' AND `tablename` = 'participants' AND `field` = 'icord_pig_injury_force';
UPDATE structure_fields
SET `model` = 'DiagnosisDetail', `tablename` = 'dxd_animals', `field` = 'pig_compression'
WHERE `model` = 'Participant' AND `tablename` = 'participants' AND `field` = 'icord_pig_compression';
UPDATE structure_fields
SET `model` = 'DiagnosisDetail', `tablename` = 'dxd_animals', `field` = 'pig_compression_time'
WHERE `model` = 'Participant' AND `tablename` = 'participants' AND `field` = 'icord_pig_compression_time';
UPDATE structure_fields
SET `model` = 'DiagnosisDetail', `tablename` = 'dxd_animals', `field` = 'pig_surgery_detail'
WHERE `model` = 'Participant' AND `tablename` = 'participants' AND `field` = 'icord_pig_surgery_detail';
UPDATE structure_fields
SET `model` = 'DiagnosisDetail', `tablename` = 'dxd_animals', `field` = 'pig_sacrifice_datetime'
WHERE `model` = 'Participant' AND `tablename` = 'participants' AND `field` = 'icord_pig_sacrifice_datetime';
UPDATE structure_fields
SET `model` = 'DiagnosisDetail', `tablename` = 'dxd_animals', `field` = 'surgery_datetime'
WHERE `model` = 'Participant' AND `tablename` = 'participants' AND `field` = 'icord_surgery_datetime';

INSERT INTO structures
(`alias`, `description`)
VALUES
('dx_animals', 'Animal Diagnosis');

INSERT INTO `structure_formats` (`structure_id`, `structure_field_id`, 
`display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, 
`flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, 
`flag_index`, `flag_detail`, `flag_summary`, `flag_float`, `margin`)
VALUES
((SELECT `id` FROM structures WHERE `alias` = 'dx_animals'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='dxd_animals' AND `field`='species'), 
2, 20, 'Animal Details', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 
1, 0, 0, 0, 0, 0, 
0, 1, 0, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'dx_animals'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='dxd_animals' AND `field`='breed'), 
2, 22, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 
1, 0, 0, 0, 0, 0, 
0, 1, 0, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'dx_animals'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='dxd_animals' AND `field`='common_name'), 
2, 23, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 
1, 0, 0, 0, 0, 0, 
0, 1, 0, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'dx_animals'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='dxd_animals' AND `field`='animal_id'), 
2, 24, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 
1, 0, 0, 0, 0, 0, 
0, 1, 0, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'dx_animals'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='dxd_animals' AND `field`='pig_body_weight_surgery'), 
2, 30, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 
1, 0, 0, 0, 0, 0, 
0, 1, 0, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'dx_animals'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='dxd_animals' AND `field`='pig_injury_type'), 
2, 32, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 
1, 0, 0, 0, 0, 0, 
0, 1, 0, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'dx_animals'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='dxd_animals' AND `field`='injury_level'), 
2, 34, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 
1, 0, 0, 0, 0, 0, 
0, 1, 0, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'dx_animals'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='dxd_animals' AND `field`='pig_injury_height'), 
2, 36, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 
1, 0, 0, 0, 0, 0, 
0, 1, 0, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'dx_animals'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='dxd_animals' AND `field`='pig_injury_force'), 
2, 38, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 
1, 0, 0, 0, 0, 0, 
0, 1, 0, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'dx_animals'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='dxd_animals' AND `field`='pig_compression'), 
2, 40, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 
1, 0, 0, 0, 0, 0, 
0, 1, 0, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'dx_animals'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='dxd_animals' AND `field`='pig_compression_time'), 
2, 42, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 
1, 0, 0, 0, 0, 0, 
0, 1, 0, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'dx_animals'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='dxd_animals' AND `field`='pig_surgery_detail'), 
2, 28, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 
1, 0, 0, 0, 0, 0, 
0, 1, 0, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'dx_animals'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='dxd_animals' AND `field`='pig_sacrifice_datetime'), 
2, 25, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 
1, 0, 0, 0, 0, 0, 
0, 1, 0, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'dx_animals'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='dxd_animals' AND `field`='surgery_datetime'), 
2, 26, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 
1, 0, 0, 0, 0, 0, 
0, 1, 0, 0, 0);


