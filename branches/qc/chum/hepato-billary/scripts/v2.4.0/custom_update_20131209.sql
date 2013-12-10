-- 1)Nous voulons ajouter dans Imagery : Fibroscan avec une case pour la date de l'examen et  les scores de fibrose dans un menu déroulant:  

INSERT INTO `event_controls` (`id`, `disease_site`, `event_group`, `event_type`, `flag_active`, `form_alias`, `detail_tablename`, `display_order`, `databrowser_label`) VALUES
(null, 'hepatobiliary', 'imagery', 'medical imaging fibroscans', 1, 'eventmasters,qc_hb_ed_hepatobilary_fibroscans', 'qc_hb_ed_hepatobilary_fibroscans', 0, 'imagery|medical imaging fibroscans');
CREATE TABLE IF NOT EXISTS `qc_hb_ed_hepatobilary_fibroscans` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `event_master_id` int(11) NOT NULL,
	scores varchar(20) default null,
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime DEFAULT NULL,
  `modified_by` int(10) unsigned NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;
CREATE TABLE IF NOT EXISTS `qc_hb_ed_hepatobilary_fibroscans_revs` (
  `id` int(11) NOT NULL,
  `event_master_id` int(11) NOT NULL,
	scores varchar(20) default null,
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime DEFAULT NULL,
  `modified_by` int(10) unsigned NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;
ALTER TABLE `qc_hb_ed_hepatobilary_fibroscans`
  ADD CONSTRAINT `qc_hb_ed_hepatobilary_fibroscans_event_masters` FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`);
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("qc_hb_fibroscan_scores", "", "", NULL);
INSERT INTO structure_permissible_values (value, language_alias) VALUES
("F0", "F0"),
("F0-F1", "F0-F1"),
("F1", "F1"),
("F1-F2", "F1-F2"),
("F2", "F2"),
("F2-F3", "F2-F3"),
("F3", "F3"),
("F3-F4", "F3-F4"),
("F4", "F4");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) 
VALUES 
((SELECT id FROM structure_value_domains WHERE domain_name="qc_hb_fibroscan_scores"), (SELECT id FROM structure_permissible_values WHERE value="F0" AND language_alias="F0"), "1", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_hb_fibroscan_scores"), (SELECT id FROM structure_permissible_values WHERE value="F0-F1" AND language_alias="F0-F1"), "1", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_hb_fibroscan_scores"), (SELECT id FROM structure_permissible_values WHERE value="F1" AND language_alias="F1"), "1", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_hb_fibroscan_scores"), (SELECT id FROM structure_permissible_values WHERE value="F1-F2" AND language_alias="F1-F2"), "1", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_hb_fibroscan_scores"), (SELECT id FROM structure_permissible_values WHERE value="F2" AND language_alias="F2"), "1", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_hb_fibroscan_scores"), (SELECT id FROM structure_permissible_values WHERE value="F2-F3" AND language_alias="F2-F3"), "1", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_hb_fibroscan_scores"), (SELECT id FROM structure_permissible_values WHERE value="F3" AND language_alias="F3"), "1", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_hb_fibroscan_scores"), (SELECT id FROM structure_permissible_values WHERE value="F3-F4" AND language_alias="F3-F4"), "1", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_hb_fibroscan_scores"), (SELECT id FROM structure_permissible_values WHERE value="F4" AND language_alias="F4"), "1", "1");
INSERT INTO i18n (id,en) VALUES
("F0", "F0"),
("F0-F1", "F0-F1"),
("F1", "F1"),
("F1-F2", "F1-F2"),
("F2", "F2"),
("F2-F3", "F2-F3"),
("F3", "F3"),
("F3-F4", "F3-F4"),
("F4", "F4");
INSERT INTO structures(`alias`) VALUES ('qc_hb_ed_hepatobilary_fibroscans');
INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES 
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_fibroscans', 'scores', 'scores', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name = 'qc_hb_fibroscan_scores'), '', '', '', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, 
`display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='qc_hb_ed_hepatobilary_fibroscans'), (SELECT id FROM structure_fields WHERE field = 'scores' AND tablename = 'qc_hb_ed_hepatobilary_fibroscans'), 
'2', '50', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0');
INSERT INTO structure_validations (structure_field_id, rule, language_message) VALUES
((SELECT id FROM structure_fields WHERE field = 'scores' AND tablename = 'qc_hb_ed_hepatobilary_fibroscans'), 'notEmpty', ''); 
INSERT INTO i18n (id,en) VALUES
("medical imaging fibroscans","Fibroscans");

-- 2) Dans le CAP-Report de hepato-cellular carcinoma, peux-tu ajouter Score fibrosis dans Additional Pathologic Findings, juste avant
-- (SCORE FIBROSIS, à ajouter)   Cirrhosis Severe Fibrosis   None To Moderate Fibrosis    

UPDATE structure_fields SET language_tag = language_label WHERE field IN ('cirrhosis_severe_fibrosis','none_to_moderate_fibrosis') AND tablename = 'ed_cap_report_hepatocellular_carcinomas';
UPDATE structure_fields SET language_label = '' WHERE field IN ('cirrhosis_severe_fibrosis','none_to_moderate_fibrosis') AND tablename = 'ed_cap_report_hepatocellular_carcinomas';
UPDATE structure_fields SET language_label = 'fibrosis score' WHERE field IN ('cirrhosis_severe_fibrosis') AND tablename = 'ed_cap_report_hepatocellular_carcinomas';
UPDATE i18n set en = 'Cirrhosis/Severe Fibrosis' WHERE en = 'Cirrhosis Severe Fibrosis';
INSERT INTO i18n (id,en) VALUES ('fibrosis score','Fibrosis Score');

-- 3) Ajouter une boite Notes pour les complications post-opératoire en-dessous de Score

ALTER TABLE qc_hb_txe_surgery_complications ADD COLUMN notes text default null;
ALTER TABLE qc_hb_txe_surgery_complications_revs ADD COLUMN notes text default null;
INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES
('', 'Clinicalannotation', 'TreatmentExtend', 'qc_hb_txe_surgery_complications', 'notes', 'notes', '', 'input', 'rows=3,cols=30', '', NULL , '', 'open', 'open', 'open');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, 
`display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='qc_hb_txe_surgery_complications'), 
(SELECT id FROM structure_fields WHERE `model`='TreatmentExtend' AND `tablename`='qc_hb_txe_surgery_complications' AND `field`='notes'), 
'0', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0');
