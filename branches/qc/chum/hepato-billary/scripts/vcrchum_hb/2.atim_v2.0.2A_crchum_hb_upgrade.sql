-- add last_news_date

ALTER TABLE participants
	ADD last_news_date DATE DEFAULT NULL AFTER notes;

ALTER TABLE participants_revs
	ADD last_news_date DATE DEFAULT NULL AFTER notes;
		
INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES
('', 'Clinicalannotation', 'Participant', 'participants', 'last_news_date', 'last news date', '', 'date', '', '',  NULL , '', 'open', 'open', 'open');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='last_news_date' AND `language_label`='last news date' AND `language_tag`='' AND `type`='date' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '3', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1');	

UPDATE structure_formats SET `language_heading`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='Participant' AND tablename='participants' AND field='vital_status');

UPDATE structure_formats SET `language_heading`='vital status' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='last_news_date' AND `language_label`='last news date' AND `language_tag`='' AND `type`='date' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL);

INSERT IGNORE INTO `i18n` (`id`, `page_id`, `en`, `fr`) 
VALUES
('last news date', '', 'Last News Date', 'Date DerniÃ¨re Nouvelle');

UPDATE tx_controls SET allow_administration = '1' WHERE tx_method = 'chemotherapy' AND disease_site = 'hepatobiliary';

-- Add portal vein embolization

CREATE TABLE IF NOT EXISTS `qc_hb_txd_portal_vein_embolizations` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `tx_master_id` int(11) NOT NULL,
  `created` datetime NOT NULL,
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime NOT NULL,
  `modified_by` int(10) unsigned NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL,
  `deleted_by` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `tx_master_id` (`tx_master_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

ALTER TABLE `qc_hb_txd_portal_vein_embolizations`
  ADD CONSTRAINT `qc_hb_txd_portal_vein_embolizations_ibfk_1` FOREIGN KEY (`tx_master_id`) REFERENCES `tx_masters` (`id`);

CREATE TABLE IF NOT EXISTS `qc_hb_txd_portal_vein_embolizations_revs` (
  `id` int(10) unsigned NOT NULL,
  `tx_master_id` int(11) NOT NULL,  
  `created` datetime NOT NULL,
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime NOT NULL,
  `modified_by` int(10) unsigned NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL,
  `deleted_by` int(10) unsigned NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

INSERT INTO `tx_controls` (`id`, `tx_method`, `disease_site`, `flag_active`, `detail_tablename`, `form_alias`, `extend_tablename`, `extend_form_alias`, `display_order`, `allow_administration`) VALUES
(null, 'portal vein embolization', 'hepatobiliary', 1, 'qc_hb_txd_portal_vein_embolizations', 'qc_hb_txd_portal_vein_embolizations', '', '', 0, 0);

INSERT INTO structures(`alias`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`) VALUES ('qc_hb_txd_portal_vein_embolizations', '', '', '1', '1', '1', '1');

DELETE FROM structure_formats WHERE structure_id = (SELECT id FROM structures WHERE alias='qc_hb_txd_portal_vein_embolizations');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='qc_hb_txd_portal_vein_embolizations'), 
(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='tx_masters' AND `field`='disease_site'), '1', '0', '', '1', 'type', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_hb_txd_portal_vein_embolizations'), 
(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='tx_masters' AND `field`='tx_method'), '1', '1', '', '1', '', '1', '-', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_hb_txd_portal_vein_embolizations'), 
(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='tx_masters' AND `field`='start_date'), '1', '3', '', '1', 'pve date', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='qc_hb_txd_portal_vein_embolizations'), 
(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='tx_masters' AND `field`='notes'), '1', '99', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='qc_hb_txd_portal_vein_embolizations'), 
(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='tx_masters' AND `field`='start_date_accuracy'), '1', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1');

UPDATE structure_formats
SET flag_index = '0'
WHERE structure_id = (SELECT id FROM structures WHERE alias='treatmentmasters')
AND structure_field_id NOT IN (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='tx_masters' 
AND `field` IN ('disease_site', 'tx_method', 'start_date'));

UPDATE structure_formats 
SET flag_index = '0'
WHERE structure_id IN (SELECT id FROM structures WHERE alias IN ('qc_hb_tx_chemos', 'qc_hb_txd_surgery_livers', 'qc_hb_txd_surgery_pancreas'));

UPDATE structure_formats 
SET flag_index = '1'
WHERE structure_id IN (SELECT id FROM structures WHERE alias IN ('qc_hb_tx_chemos', 'qc_hb_txd_surgery_livers', 'qc_hb_txd_surgery_pancreas'))
AND structure_field_id IN (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='tx_masters' 
AND `field` IN ('start_date'));

DELETE FROM structure_formats 
WHERE structure_id IN (SELECT id FROM structures WHERE alias IN ('qc_hb_tx_chemos', 'qc_hb_txd_surgery_livers', 'qc_hb_txd_surgery_pancreas'))
AND structure_field_id IN (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='tx_masters' AND `field` IN ('disease_site', 'tx_method'));

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='qc_hb_txd_surgery_livers'), 
(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='tx_masters' AND `field`='disease_site'), '1', '-1', '', '1', 'type', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_hb_txd_surgery_livers'), 
(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='tx_masters' AND `field`='tx_method'), '1', '0', '', '1', '', '1', '-', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');

UPDATE structure_formats 
SET flag_index = '1'
WHERE structure_id IN (SELECT id FROM structures WHERE alias IN ('qc_hb_txd_surgery_livers'))
AND structure_field_id IN (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_hb_txd_surgery_livers' 
AND `field` IN ('principal_surgery', 'surgeon'));

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='qc_hb_txd_surgery_pancreas'), 
(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='tx_masters' AND `field`='disease_site'), '1', '-1', '', '1', 'type', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_hb_txd_surgery_pancreas'), 
(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='tx_masters' AND `field`='tx_method'), '1', '0', '', '1', '', '1', '-', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');

UPDATE structure_formats 
SET flag_index = '1'
WHERE structure_id IN (SELECT id FROM structures WHERE alias IN ('qc_hb_txd_surgery_pancreas'))
AND structure_field_id IN (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_hb_txd_surgery_pancreas' 
AND `field` IN ('principal_surgery', 'surgeon'));

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='qc_hb_tx_chemos'), 
(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='tx_masters' AND `field`='disease_site'), '1', '-1', '', '1', 'type', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_hb_tx_chemos'), 
(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='tx_masters' AND `field`='tx_method'), '1', '0', '', '1', '', '1', '-', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');

UPDATE structure_formats 
SET flag_index = '1'
WHERE structure_id IN (SELECT id FROM structures WHERE alias IN ('qc_hb_tx_chemos'))
AND structure_field_id IN (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_chemos' 
AND `field` IN ('qc_hb_treatment'));

UPDATE structure_formats 
SET flag_index = '1'
WHERE structure_id IN (SELECT id FROM structures WHERE alias IN ('qc_hb_tx_chemos'))
AND structure_field_id IN (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='tx_masters' 
AND `field` IN ('protocol_master_id'));

UPDATE structure_formats 
SET `flag_override_label` = '1', `language_label` = 'date'
WHERE structure_id = (SELECT id FROM structures WHERE alias='treatmentmasters')
AND structure_field_id IN (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='tx_masters' 
AND `field` IN ('start_date'));

INSERT IGNORE INTO `i18n` (`id`, `page_id`, `en`, `fr`) 
VALUES
('pve date', '', 'PVE Date', 'Date de l''EVP'),
('portal vein embolization', '', 'Portal Vein Embolization', 'Embolisation veine porte');

UPDATE structure_fields SET `structure_value_domain` = (SELECT id FROM `structure_value_domains` WHERE `domain_name` LIKE 'qc_hb_hbp_surgeon_list')
WHERE model = 'TreatmentDetail' AND field = 'surgeon';

-- Divers

UPDATE consent_controls SET flag_active = '0';

UPDATE `i18n` SET en = 'Participant System Code', fr = 'Code systÃªme participant' WHERE id = 'participant code';

UPDATE diagnosis_controls SET flag_active = '0';

INSERT INTO `structure_validations` 
(`id`, `structure_field_id`, `rule`, `flag_empty`, `flag_required`, `on_action`, `language_message`, `created`, `created_by`, `modified`, `modified_by`) 
VALUES
(null, (SELECT id FROM structure_fields WHERE model = 'EventDetail' AND field = 'disease_precision'), 'notEmpty', '0', '0', '', 'value is required', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');
 
INSERT INTO `structure_validations` 
(`id`, `structure_field_id`, `rule`, `flag_empty`, `flag_required`, `on_action`, `language_message`, `created`, `created_by`, `modified`, `modified_by`) 
VALUES
(null, (SELECT id FROM structure_fields WHERE model = 'EventMaster' AND field = 'event_date'), 'notEmpty', '0', '0', '', 'value is required', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');
 
UPDATE structure_formats
SET `flag_search` = '0', `flag_search_readonly` = '0', `flag_datagrid` = '0', `flag_datagrid_readonly` = '0'
WHERE structure_id IN (SELECT distinct str.id FROM structures AS str INNER JOIN event_controls AS ev ON ev.form_alias = str.alias);

UPDATE structure_formats
SET `flag_index` = '1'
WHERE structure_id IN (SELECT str.id FROM structures AS str INNER JOIN event_controls AS ev ON ev.form_alias = str.alias WHERE ev.event_group = 'clinical' AND event_type = 'hepatitis medical past history');

INSERT INTO `structure_validations` 
(`id`, `structure_field_id`, `rule`, `flag_empty`, `flag_required`, `on_action`, `language_message`, `created`, `created_by`, `modified`, `modified_by`) 
VALUES
(null, (SELECT id FROM structure_fields WHERE model = 'TreatmentMaster' AND field = 'start_date'), 'notEmpty', '0', '0', '', 'value is required', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- Add labo post surgery report

UPDATE structure_formats SET `display_order`='-3' WHERE structure_id=(SELECT id FROM structures WHERE alias='ed_hepatobiliary_lab_report_biology') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='EventMaster' AND tablename='event_masters' AND field='disease_site');
UPDATE structure_formats SET `display_order`='-2' WHERE structure_id=(SELECT id FROM structures WHERE alias='ed_hepatobiliary_lab_report_biology') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='EventMaster' AND tablename='event_masters' AND field='event_type');
UPDATE structure_formats SET `display_order`='-1' WHERE structure_id=(SELECT id FROM structures WHERE alias='ed_hepatobiliary_lab_report_biology') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='EventMaster' AND tablename='event_masters' AND field='event_date');

ALTER TABLE `qc_hb_ed_hepatobilary_lab_report_biology`
  ADD `surgery_tx_master_id` int(11) DEFAULT NULL AFTER `id`,
  ADD `post_surgery_report_type` varchar(20) DEFAULT NULL AFTER `surgery_tx_master_id`;

ALTER TABLE `qc_hb_ed_hepatobilary_lab_report_biology`
  ADD CONSTRAINT `qc_hb_ed_hepatobilary_lab_report_biology_surgey` FOREIGN KEY (`surgery_tx_master_id`) REFERENCES `tx_masters` (`id`);

ALTER TABLE `qc_hb_ed_hepatobilary_lab_report_biology_revs`
  ADD `surgery_tx_master_id` int(11) DEFAULT NULL AFTER `id`,
  ADD `post_surgery_report_type` varchar(20) DEFAULT NULL AFTER `surgery_tx_master_id`;
  
INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('post_surgery_report_type', '', '', NULL);

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("day 1", "day 1");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="post_surgery_report_type"),  (SELECT id FROM structure_permissible_values WHERE value="day 1" AND language_alias="day 1"), "1", "1");

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("day 2", "day 2");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="post_surgery_report_type"),  (SELECT id FROM structure_permissible_values WHERE value="day 2" AND language_alias="day 2"), "2", "1");

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("day 3", "day 3");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="post_surgery_report_type"),  (SELECT id FROM structure_permissible_values WHERE value="day 3" AND language_alias="day 3"), "3", "1");

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("day 7", "day 7");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="post_surgery_report_type"),  (SELECT id FROM structure_permissible_values WHERE value="day 7" AND language_alias="day 7"), "7", "1");

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("day 9", "day 9");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="post_surgery_report_type"),  (SELECT id FROM structure_permissible_values WHERE value="day 9" AND language_alias="day 9"), "9", "1");

INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_lab_report_biology', 'post_surgery_report_type', 'post surgery report type', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='post_surgery_report_type') , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_lab_report_biology', 'surgery_tx_master_id', 'surgery linked to lab report', '', 'select', '', '', NULL, '', 'open', 'open', 'open');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='ed_hepatobiliary_lab_report_biology'), 
(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_hb_ed_hepatobilary_lab_report_biology' AND `field`='surgery_tx_master_id'), '0', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='ed_hepatobiliary_lab_report_biology'), 
(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_hb_ed_hepatobilary_lab_report_biology' AND `field`='post_surgery_report_type'), '0', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1');

INSERT IGNORE INTO `i18n` (`id`, `page_id`, `en`, `fr`) 
VALUES
('at least one biology lab report is linked to this treatment', '', 'At least one biology lab report is linked to this treatment!', 'Au moins un rapport de biologie mÃ©dicale est attachÃ© au traitement!'),
('surgery linked to lab report', '', 'Surgery', 'Chirurgie'),
('post surgery report type', '', 'Report Nbr', 'Num. rapport'),
('day 1', '', 'Day 1', 'Jour 1'),
('day 2', '', 'Day 2', 'Jour 2'),
('day 3', '', 'Day 3', 'Jour 3'),
('day 7', '', 'Day 7', 'Jour 7'),
('day 9', '', 'Day 9', 'Jour 9');

UPDATE structure_formats AS sfo, structure_fields AS sfi
SET sfo.flag_index = '1'
WHERE sfi.field = 'qc_hb_sample_code' AND sfi.model = 'SpecimenDetail'
AND sfi.id = sfo.structure_field_id;

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_add = '0', sfo.flag_datagrid = '0'
WHERE sfi.field = 'barcode' AND sfi.model = 'AliquotMaster' AND str.alias LIKE 'ad_%'
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET `flag_add` = '0', `flag_add_readonly` = '0', 
`flag_edit` = '0', `flag_edit_readonly` = '0', 
`flag_search` = '0', `flag_search_readonly` = '0', 
`flag_datagrid` = '0', `flag_datagrid_readonly` = '0', 
`flag_index` = '0', `flag_detail` = '0'
WHERE sfi.field = 'barcode' AND sfi.model = 'StorageMaster' AND str.alias IN ('std_incubators', 'std_rooms', 'std_tma_blocks', 
'std_undetail_stg_with_surr_tmp', 'std_undetail_stg_with_tmp', 'storagemasters')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;


-- update ad_spec_tubes posiitons

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET display_column = '0', display_order = '1'
WHERE sfi.field = 'qc_hb_label' AND sfi.model = 'AliquotMaster' AND str.alias IN ('ad_spec_tubes')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;
UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET display_column = '1', display_order = '80', language_heading = 'other'
WHERE sfi.field = 'barcode' AND sfi.model = 'AliquotMaster' AND str.alias IN ('ad_spec_tubes')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;
UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET display_column = '0', display_order = '33'
WHERE sfi.field = 'in_stock' AND sfi.model = 'AliquotMaster' AND str.alias IN ('ad_spec_tubes')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;
UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET display_column = '0', display_order = '34'
WHERE sfi.field = 'in_stock_detail' AND sfi.model = 'AliquotMaster' AND str.alias IN ('ad_spec_tubes')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;
UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET display_column = '1', display_order = '63'
WHERE sfi.field = 'aliquot_use_counter' AND sfi.model = 'Generated' AND str.alias IN ('ad_spec_tubes')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;
UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET display_column = '1', display_order = '64'
WHERE sfi.field = 'study_summary_id' AND sfi.model = 'AliquotMaster' AND str.alias IN ('ad_spec_tubes')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;
UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET display_column = '1', display_order = '65'
WHERE sfi.field = 'sop_master_id' AND sfi.model = 'AliquotMaster' AND str.alias IN ('ad_spec_tubes')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;
UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET display_column = '1', display_order = '75'
WHERE sfi.field = 'notes' AND sfi.model = 'AliquotMaster' AND str.alias IN ('ad_spec_tubes')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;
UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET display_column = '0', display_order = '25'
WHERE sfi.field = 'qc_hb_stored_by' AND sfi.model = 'AliquotMaster' AND str.alias IN ('ad_spec_tubes')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

-- update ad_spec_conical_tubes posiitons

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET display_column = '0', display_order = '1'
WHERE sfi.field = 'qc_hb_label' AND sfi.model = 'AliquotMaster' AND str.alias IN ('ad_spec_conical_tubes')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;
UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET display_column = '1', display_order = '80', language_heading = 'other'
WHERE sfi.field = 'barcode' AND sfi.model = 'AliquotMaster' AND str.alias IN ('ad_spec_conical_tubes')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;
UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET display_column = '0', display_order = '33'
WHERE sfi.field = 'in_stock' AND sfi.model = 'AliquotMaster' AND str.alias IN ('ad_spec_conical_tubes')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;
UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET display_column = '0', display_order = '34'
WHERE sfi.field = 'in_stock_detail' AND sfi.model = 'AliquotMaster' AND str.alias IN ('ad_spec_conical_tubes')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;
UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET display_column = '1', display_order = '63'
WHERE sfi.field = 'aliquot_use_counter' AND sfi.model = 'Generated' AND str.alias IN ('ad_spec_conical_tubes')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;
UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET display_column = '1', display_order = '64'
WHERE sfi.field = 'study_summary_id' AND sfi.model = 'AliquotMaster' AND str.alias IN ('ad_spec_conical_tubes')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;
UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET display_column = '1', display_order = '65'
WHERE sfi.field = 'sop_master_id' AND sfi.model = 'AliquotMaster' AND str.alias IN ('ad_spec_conical_tubes')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;
UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET display_column = '1', display_order = '75'
WHERE sfi.field = 'notes' AND sfi.model = 'AliquotMaster' AND str.alias IN ('ad_spec_conical_tubes')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;
UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET display_column = '0', display_order = '25'
WHERE sfi.field = 'qc_hb_stored_by' AND sfi.model = 'AliquotMaster' AND str.alias IN ('ad_spec_conical_tubes')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

UPDATE structures
SET `flag_add_columns` = '1', `flag_edit_columns` = '1', `flag_detail_columns` = '1'
WHERE alias = 'ad_spec_conical_tubes';

-- update ad_spec_tiss_blocks posiitons

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET display_column = '0', display_order = '1'
WHERE sfi.field = 'qc_hb_label' AND sfi.model = 'AliquotMaster' AND str.alias IN ('ad_spec_tiss_blocks')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;
UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET display_column = '1', display_order = '80', language_heading = 'other'
WHERE sfi.field = 'barcode' AND sfi.model = 'AliquotMaster' AND str.alias IN ('ad_spec_tiss_blocks')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;
UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET display_column = '0', display_order = '33'
WHERE sfi.field = 'in_stock' AND sfi.model = 'AliquotMaster' AND str.alias IN ('ad_spec_tiss_blocks')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;
UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET display_column = '0', display_order = '34'
WHERE sfi.field = 'in_stock_detail' AND sfi.model = 'AliquotMaster' AND str.alias IN ('ad_spec_tiss_blocks')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;
UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET display_column = '1', display_order = '63'
WHERE sfi.field = 'aliquot_use_counter' AND sfi.model = 'Generated' AND str.alias IN ('ad_spec_tiss_blocks')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;
UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET display_column = '1', display_order = '64'
WHERE sfi.field = 'study_summary_id' AND sfi.model = 'AliquotMaster' AND str.alias IN ('ad_spec_tiss_blocks')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;
UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET display_column = '1', display_order = '65'
WHERE sfi.field = 'sop_master_id' AND sfi.model = 'AliquotMaster' AND str.alias IN ('ad_spec_tiss_blocks')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;
UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET display_column = '1', display_order = '75'
WHERE sfi.field = 'notes' AND sfi.model = 'AliquotMaster' AND str.alias IN ('ad_spec_tiss_blocks')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;
UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET display_column = '0', display_order = '25'
WHERE sfi.field = 'qc_hb_stored_by' AND sfi.model = 'AliquotMaster' AND str.alias IN ('ad_spec_tiss_blocks')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET display_column = '0', display_order = '16'
WHERE sfi.field = 'block_type' AND sfi.model = 'AliquotDetail' AND str.alias IN ('ad_spec_tiss_blocks')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

-- update ad_der_tubes_incl_ml_vol posiitons

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET display_column = '0', display_order = '1'
WHERE sfi.field = 'qc_hb_label' AND sfi.model = 'AliquotMaster' AND str.alias IN ('ad_der_tubes_incl_ml_vol')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;
UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET display_column = '1', display_order = '80', language_heading = 'other'
WHERE sfi.field = 'barcode' AND sfi.model = 'AliquotMaster' AND str.alias IN ('ad_der_tubes_incl_ml_vol')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;
UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET display_column = '0', display_order = '33'
WHERE sfi.field = 'in_stock' AND sfi.model = 'AliquotMaster' AND str.alias IN ('ad_der_tubes_incl_ml_vol')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;
UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET display_column = '0', display_order = '34'
WHERE sfi.field = 'in_stock_detail' AND sfi.model = 'AliquotMaster' AND str.alias IN ('ad_der_tubes_incl_ml_vol')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;
UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET display_column = '1', display_order = '63'
WHERE sfi.field = 'aliquot_use_counter' AND sfi.model = 'Generated' AND str.alias IN ('ad_der_tubes_incl_ml_vol')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;
UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET display_column = '1', display_order = '64'
WHERE sfi.field = 'study_summary_id' AND sfi.model = 'AliquotMaster' AND str.alias IN ('ad_der_tubes_incl_ml_vol')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;
UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET display_column = '1', display_order = '65'
WHERE sfi.field = 'sop_master_id' AND sfi.model = 'AliquotMaster' AND str.alias IN ('ad_der_tubes_incl_ml_vol')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;
UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET display_column = '1', display_order = '75'
WHERE sfi.field = 'notes' AND sfi.model = 'AliquotMaster' AND str.alias IN ('ad_der_tubes_incl_ml_vol')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;
UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET display_column = '0', display_order = '25'
WHERE sfi.field = 'qc_hb_stored_by' AND sfi.model = 'AliquotMaster' AND str.alias IN ('ad_der_tubes_incl_ml_vol')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET display_column = '0', display_order = '16'
WHERE sfi.field = 'current_volume' AND sfi.model = 'AliquotMaster' AND str.alias IN ('ad_der_tubes_incl_ml_vol')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;
UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET display_column = '0', display_order = '17'
WHERE sfi.field = 'aliquot_volume_unit' AND sfi.model = 'AliquotMaster' AND str.alias IN ('ad_der_tubes_incl_ml_vol')
AND display_order = '72'
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;
UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET display_column = '0', display_order = '18'
WHERE sfi.field = 'initial_volume' AND sfi.model = 'AliquotMaster' AND str.alias IN ('ad_der_tubes_incl_ml_vol')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;
UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET display_column = '0', display_order = '19'
WHERE sfi.field = 'aliquot_volume_unit' AND sfi.model = 'AliquotMaster' AND str.alias IN ('ad_der_tubes_incl_ml_vol')
AND display_order = '74'
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

-- update ad_der_cell_tubes_incl_ml_vol posiitons

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET display_column = '0', display_order = '1'
WHERE sfi.field = 'qc_hb_label' AND sfi.model = 'AliquotMaster' AND str.alias IN ('ad_der_cell_tubes_incl_ml_vol')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;
UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET display_column = '1', display_order = '80', language_heading = 'other'
WHERE sfi.field = 'barcode' AND sfi.model = 'AliquotMaster' AND str.alias IN ('ad_der_cell_tubes_incl_ml_vol')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;
UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET display_column = '0', display_order = '33'
WHERE sfi.field = 'in_stock' AND sfi.model = 'AliquotMaster' AND str.alias IN ('ad_der_cell_tubes_incl_ml_vol')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;
UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET display_column = '0', display_order = '34'
WHERE sfi.field = 'in_stock_detail' AND sfi.model = 'AliquotMaster' AND str.alias IN ('ad_der_cell_tubes_incl_ml_vol')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;
UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET display_column = '1', display_order = '63'
WHERE sfi.field = 'aliquot_use_counter' AND sfi.model = 'Generated' AND str.alias IN ('ad_der_cell_tubes_incl_ml_vol')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;
UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET display_column = '1', display_order = '64'
WHERE sfi.field = 'study_summary_id' AND sfi.model = 'AliquotMaster' AND str.alias IN ('ad_der_cell_tubes_incl_ml_vol')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;
UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET display_column = '1', display_order = '65'
WHERE sfi.field = 'sop_master_id' AND sfi.model = 'AliquotMaster' AND str.alias IN ('ad_der_cell_tubes_incl_ml_vol')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;
UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET display_column = '1', display_order = '75'
WHERE sfi.field = 'notes' AND sfi.model = 'AliquotMaster' AND str.alias IN ('ad_der_cell_tubes_incl_ml_vol')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;
UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET display_column = '0', display_order = '25'
WHERE sfi.field = 'qc_hb_stored_by' AND sfi.model = 'AliquotMaster' AND str.alias IN ('ad_der_cell_tubes_incl_ml_vol')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET display_column = '0', display_order = '16'
WHERE sfi.field = 'current_volume' AND sfi.model = 'AliquotMaster' AND str.alias IN ('ad_der_cell_tubes_incl_ml_vol')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;
UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET display_column = '0', display_order = '17'
WHERE sfi.field = 'aliquot_volume_unit' AND sfi.model = 'AliquotMaster' AND str.alias IN ('ad_der_cell_tubes_incl_ml_vol')
AND display_order = '72'
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;
UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET display_column = '0', display_order = '18'
WHERE sfi.field = 'initial_volume' AND sfi.model = 'AliquotMaster' AND str.alias IN ('ad_der_cell_tubes_incl_ml_vol')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;
UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET display_column = '0', display_order = '19'
WHERE sfi.field = 'aliquot_volume_unit' AND sfi.model = 'AliquotMaster' AND str.alias IN ('ad_der_cell_tubes_incl_ml_vol')
AND display_order = '74'
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET display_column = '0', display_order = '10'
WHERE sfi.field = 'qc_hb_milieu' AND sfi.model = 'AliquotDetail' AND str.alias IN ('ad_der_cell_tubes_incl_ml_vol')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;
UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET display_column = '0', display_order = '11'
WHERE sfi.field = 'cell_count' AND sfi.model = 'AliquotDetail' AND str.alias IN ('ad_der_cell_tubes_incl_ml_vol')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;
UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET display_column = '0', display_order = '12'
WHERE sfi.field = 'cell_count_unit' AND sfi.model = 'AliquotDetail' AND str.alias IN ('ad_der_cell_tubes_incl_ml_vol')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;
UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET display_column = '0', display_order = '13'
WHERE sfi.field = 'concentration' AND sfi.model = 'AliquotDetail' AND str.alias IN ('ad_der_cell_tubes_incl_ml_vol')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;
UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET display_column = '0', display_order = '14'
WHERE sfi.field = 'concentration_unit' AND sfi.model = 'AliquotDetail' AND str.alias IN ('ad_der_cell_tubes_incl_ml_vol')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

-- Change label flag

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET flag_edit = '1', flag_search = '1'
WHERE sfi.field = 'qc_hb_label' AND sfi.model = 'AliquotMaster' AND str.alias LIKE 'ad_%'
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;


-- Add label to other structures

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='aliquot_masters_for_collection_tree_view'), 
(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='qc_hb_label'), '0', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');
UPDATE structure_formats SET `flag_index`='0' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters_for_collection_tree_view') 
AND structure_field_id=(SELECT id FROM structure_fields WHERE model='AliquotMaster' AND tablename='aliquot_masters' AND field='barcode');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='aliquot_masters_for_storage_tree_view'), 
(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='qc_hb_label'), '0', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');
UPDATE structure_formats SET `flag_index`='0' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters_for_storage_tree_view') 
AND structure_field_id=(SELECT id FROM structure_fields WHERE model='AliquotMaster' AND tablename='aliquot_masters' AND field='barcode');


INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='orderitems'), 
(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='qc_hb_label'), 
'0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'0', '0', '1', '1', '0', '0', '1', '1', '1', '1');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='qctestedaliquots'), 
(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='qc_hb_label'), 
'0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'0', '0', '0', '0', '0', '0', '1', '1', '1', '0');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='realiquotedparent'), 
(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='qc_hb_label'), 
'0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'0', '0', '0', '0', '0', '0', '0', '0', '1', '0');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='shippeditems'), 
(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='qc_hb_label'), 
'1', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'0', '0', '0', '0', '0', '0', '1', '1', '1', '0');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='sourcealiquots'), 
(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='qc_hb_label'), 
'0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'0', '0', '0', '0', '0', '0', '1', '1', '1', '0');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='aliquotmasters'), 
(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='qc_hb_label'), 
'0', '8', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'0', '0', '0', '0', '0', '0', '0', '0', '1', '0');

INSERT INTO `structure_fields` (`id`, `public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, '', 'Inventorymanagement', 'ViewAliquot', '', 'qc_hb_label', 'label', '', 'input', 'size=30', '', NULL, '', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0);
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample'), 
(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `field`='qc_hb_label'), 
'0', '8', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'0', '0', '0', '0', '0', '0', '0', '0', '1', '0');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='view_aliquot_joined_to_collection'), 
(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `field`='qc_hb_label'), 
'0', '8', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'0', '0', '0', '0', '0', '0', '0', '0', '1', '0');

DROP VIEW `view_aliquots`;
CREATE VIEW `view_aliquots` AS select 
`al`.`id` AS `aliquot_master_id`,
`samp`.`id` AS `sample_master_id`,
`col`.`id` AS `collection_id`,
`col`.`bank_id` AS `bank_id`,
`stor`.`id` AS `storage_master_id`,
`link`.`participant_id` AS `participant_id`,
`link`.`diagnosis_master_id` AS `diagnosis_master_id`,
`link`.`consent_master_id` AS `consent_master_id`,
`part`.`participant_identifier` AS `participant_identifier`,
`col`.`acquisition_label` AS `acquisition_label`,
`samp`.`initial_specimen_sample_type` AS `initial_specimen_sample_type`,
`parent_samp`.`sample_type` AS `parent_sample_type`,
`samp`.`sample_type` AS `sample_type`,
`al`.`barcode` AS `barcode`,
`al`.`qc_hb_label` AS `qc_hb_label`,
`al`.`aliquot_type` AS `aliquot_type`,
`al`.`in_stock` AS `in_stock`,
`stor`.`code` AS `code`,
`stor`.`selection_label` AS `selection_label`,
`al`.`storage_coord_x` AS `storage_coord_x`,
`al`.`storage_coord_y` AS `storage_coord_y`,
`stor`.`temperature` AS `temperature`,
`stor`.`temp_unit` AS `temp_unit`,
count(`al_use`.`id`) AS `aliquot_use_counter`,
`al`.`deleted` AS `deleted` from (((((((`aliquot_masters` `al` join `sample_masters` `samp` on(((`samp`.`id` = `al`.`sample_master_id`) and (`samp`.`deleted` <> 1)))) join `collections` `col` on(((`col`.`id` = `samp`.`collection_id`) and (`col`.`deleted` <> 1)))) left join `aliquot_uses` `al_use` on(((`al_use`.`aliquot_master_id` = `al`.`id`) and (`al_use`.`deleted` <> 1)))) left join `sample_masters` `parent_samp` on(((`samp`.`parent_id` = `parent_samp`.`id`) and (`parent_samp`.`deleted` <> 1)))) left join `clinical_collection_links` `link` on(((`col`.`id` = `link`.`collection_id`) and (`link`.`deleted` <> 1)))) left join `participants` `part` on(((`link`.`participant_id` = `part`.`id`) and (`part`.`deleted` <> 1)))) left join `storage_masters` `stor` on(((`stor`.`id` = `al`.`storage_master_id`) and (`stor`.`deleted` <> 1)))) where (`al`.`deleted` <> 1) group by `al`.`id`;

-- Add post operative data

UPDATE structure_formats SET `language_heading`='specific liver surgery data' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_txd_surgery_livers') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='TreatmentDetail' AND tablename='qc_hb_txd_surgery_livers' AND field='liver_appearance');
UPDATE structure_formats SET `language_heading`='specific pancreas surgery data' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_txd_surgery_pancreas') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='TreatmentDetail' AND tablename='qc_hb_txd_surgery_pancreas' AND field='pancreas_appearance');

ALTER TABLE `qc_hb_txd_surgery_pancreas`
	ADD hospitalization_start_date DATE DEFAULT NULL AFTER `splen_size`,
	ADD hospitalization_end_date DATE DEFAULT NULL AFTER `hospitalization_start_date`,
	ADD hospitalization_duration_in_days INT(10) DEFAULT NULL AFTER `hospitalization_end_date`,
	ADD gastric_tube_duration_in_days INT(4) DEFAULT NULL AFTER `hospitalization_duration_in_days`,
	
	ADD is_intensive_care_1 tinyint(3) DEFAULT NULL AFTER `gastric_tube_duration_in_days`,
	ADD ic_1_start_date DATE DEFAULT NULL AFTER `is_intensive_care_1`,
	ADD ic_1_end_date DATE DEFAULT NULL AFTER `ic_1_start_date`,
	ADD ic_1_duration_in_days INT(10) DEFAULT NULL AFTER `ic_1_end_date`,
	
	ADD is_intensive_care_2 tinyint(3) DEFAULT NULL AFTER `ic_1_duration_in_days`,
	ADD ic_2_start_date DATE DEFAULT NULL AFTER `is_intensive_care_2`,
	ADD ic_2_end_date DATE DEFAULT NULL AFTER `ic_2_start_date`,
	ADD ic_2_duration_in_days INT(10) DEFAULT NULL AFTER `ic_2_end_date`,
	
	ADD is_intensive_care_3 tinyint(3) DEFAULT NULL AFTER `ic_2_duration_in_days`,
	ADD ic_3_start_date DATE DEFAULT NULL AFTER `is_intensive_care_3`,
	ADD ic_3_end_date DATE DEFAULT NULL AFTER `ic_3_start_date`,
	ADD ic_3_duration_in_days INT(10) DEFAULT NULL AFTER `ic_3_end_date`,
	
	ADD total_ic_duration_in_days INT(10) DEFAULT NULL AFTER `ic_3_duration_in_days`,
	
	ADD survival_time_in_months INT(10) DEFAULT NULL AFTER `total_ic_duration_in_days`;
	
ALTER TABLE `qc_hb_txd_surgery_pancreas_revs`
	ADD hospitalization_start_date DATE DEFAULT NULL AFTER `splen_size`,
	ADD hospitalization_end_date DATE DEFAULT NULL AFTER `hospitalization_start_date`,
	ADD hospitalization_duration_in_days INT(10) DEFAULT NULL AFTER `hospitalization_end_date`,
	ADD gastric_tube_duration_in_days INT(4) DEFAULT NULL AFTER `hospitalization_duration_in_days`,
	
	ADD is_intensive_care_1 tinyint(3) DEFAULT NULL AFTER `gastric_tube_duration_in_days`,
	ADD ic_1_start_date DATE DEFAULT NULL AFTER `is_intensive_care_1`,
	ADD ic_1_end_date DATE DEFAULT NULL AFTER `ic_1_start_date`,
	ADD ic_1_duration_in_days INT(10) DEFAULT NULL AFTER `ic_1_end_date`,
	
	ADD is_intensive_care_2 tinyint(3) DEFAULT NULL AFTER `ic_1_duration_in_days`,
	ADD ic_2_start_date DATE DEFAULT NULL AFTER `is_intensive_care_2`,
	ADD ic_2_end_date DATE DEFAULT NULL AFTER `ic_2_start_date`,
	ADD ic_2_duration_in_days INT(10) DEFAULT NULL AFTER `ic_2_end_date`,
	
	ADD is_intensive_care_3 tinyint(3) DEFAULT NULL AFTER `ic_2_duration_in_days`,
	ADD ic_3_start_date DATE DEFAULT NULL AFTER `is_intensive_care_3`,
	ADD ic_3_end_date DATE DEFAULT NULL AFTER `ic_3_start_date`,
	ADD ic_3_duration_in_days INT(10) DEFAULT NULL AFTER `ic_3_end_date`,
	
	ADD total_ic_duration_in_days INT(10) DEFAULT NULL AFTER `ic_3_duration_in_days`,
	
	ADD survival_time_in_months INT(10) DEFAULT NULL AFTER `total_ic_duration_in_days`;
	
ALTER TABLE `qc_hb_txd_surgery_livers`
	ADD hospitalization_start_date DATE DEFAULT NULL AFTER `splen_size`,
	ADD hospitalization_end_date DATE DEFAULT NULL AFTER `hospitalization_start_date`,
	ADD hospitalization_duration_in_days INT(10) DEFAULT NULL AFTER `hospitalization_end_date`,
	ADD gastric_tube_duration_in_days INT(4) DEFAULT NULL AFTER `hospitalization_duration_in_days`,
	
	ADD is_intensive_care_1 tinyint(3) DEFAULT NULL AFTER `gastric_tube_duration_in_days`,
	ADD ic_1_start_date DATE DEFAULT NULL AFTER `is_intensive_care_1`,
	ADD ic_1_end_date DATE DEFAULT NULL AFTER `ic_1_start_date`,
	ADD ic_1_duration_in_days INT(10) DEFAULT NULL AFTER `ic_1_end_date`,
	
	ADD is_intensive_care_2 tinyint(3) DEFAULT NULL AFTER `ic_1_duration_in_days`,
	ADD ic_2_start_date DATE DEFAULT NULL AFTER `is_intensive_care_2`,
	ADD ic_2_end_date DATE DEFAULT NULL AFTER `ic_2_start_date`,
	ADD ic_2_duration_in_days INT(10) DEFAULT NULL AFTER `ic_2_end_date`,
	
	ADD is_intensive_care_3 tinyint(3) DEFAULT NULL AFTER `ic_2_duration_in_days`,
	ADD ic_3_start_date DATE DEFAULT NULL AFTER `is_intensive_care_3`,
	ADD ic_3_end_date DATE DEFAULT NULL AFTER `ic_3_start_date`,
	ADD ic_3_duration_in_days INT(10) DEFAULT NULL AFTER `ic_3_end_date`,
	
	ADD total_ic_duration_in_days INT(10) DEFAULT NULL AFTER `ic_3_duration_in_days`,
	
	ADD survival_time_in_months INT(10) DEFAULT NULL AFTER `total_ic_duration_in_days`;
	
ALTER TABLE `qc_hb_txd_surgery_livers_revs`
	ADD hospitalization_start_date DATE DEFAULT NULL AFTER `splen_size`,
	ADD hospitalization_end_date DATE DEFAULT NULL AFTER `hospitalization_start_date`,
	ADD hospitalization_duration_in_days INT(10) DEFAULT NULL AFTER `hospitalization_end_date`,
	ADD gastric_tube_duration_in_days INT(4) DEFAULT NULL AFTER `hospitalization_duration_in_days`,
	
	ADD is_intensive_care_1 tinyint(3) DEFAULT NULL AFTER `gastric_tube_duration_in_days`,
	ADD ic_1_start_date DATE DEFAULT NULL AFTER `is_intensive_care_1`,
	ADD ic_1_end_date DATE DEFAULT NULL AFTER `ic_1_start_date`,
	ADD ic_1_duration_in_days INT(10) DEFAULT NULL AFTER `ic_1_end_date`,
	
	ADD is_intensive_care_2 tinyint(3) DEFAULT NULL AFTER `ic_1_duration_in_days`,
	ADD ic_2_start_date DATE DEFAULT NULL AFTER `is_intensive_care_2`,
	ADD ic_2_end_date DATE DEFAULT NULL AFTER `ic_2_start_date`,
	ADD ic_2_duration_in_days INT(10) DEFAULT NULL AFTER `ic_2_end_date`,
	
	ADD is_intensive_care_3 tinyint(3) DEFAULT NULL AFTER `ic_2_duration_in_days`,
	ADD ic_3_start_date DATE DEFAULT NULL AFTER `is_intensive_care_3`,
	ADD ic_3_end_date DATE DEFAULT NULL AFTER `ic_3_start_date`,
	ADD ic_3_duration_in_days INT(10) DEFAULT NULL AFTER `ic_3_end_date`,
	
	ADD total_ic_duration_in_days INT(10) DEFAULT NULL AFTER `ic_3_duration_in_days`,
	
	ADD survival_time_in_months INT(10) DEFAULT NULL AFTER `total_ic_duration_in_days`;
		
INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES
('', 'Clinicalannotation', 'TreatmentDetail', '', 'hospitalization_start_date', 'hospitalization start date', '', 'date', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'TreatmentDetail', '', 'hospitalization_end_date', 'hospitalization end date', '', 'date', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'TreatmentDetail', '', 'hospitalization_duration_in_days', 'hospitalization duration in days', '', 'integer', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'TreatmentDetail', '', 'gastric_tube_duration_in_days', 'gastric tube duration in days', '', 'integer', '', '',  NULL , '', 'open', 'open', 'open'),

('', 'Clinicalannotation', 'TreatmentDetail', '', 'is_intensive_care_1', 'is intensive care 1', '', 'checkbox', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'TreatmentDetail', '', 'ic_1_start_date', 'ic 1 start date', '', 'date', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'TreatmentDetail', '', 'ic_1_end_date', 'ic 1 end date', '', 'date', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'TreatmentDetail', '', 'ic_1_duration_in_days', 'ic 1 duration in days', '', 'integer', '', '',  NULL , '', 'open', 'open', 'open'), 

('', 'Clinicalannotation', 'TreatmentDetail', '', 'is_intensive_care_2', 'is intensive care 2', '', 'checkbox', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'TreatmentDetail', '', 'ic_2_start_date', 'ic 2 start date', '', 'date', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'TreatmentDetail', '', 'ic_2_end_date', 'ic 2 end date', '', 'date', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'TreatmentDetail', '', 'ic_2_duration_in_days', 'ic 2 duration in days', '', 'integer', '', '',  NULL , '', 'open', 'open', 'open'), 

('', 'Clinicalannotation', 'TreatmentDetail', '', 'is_intensive_care_3', 'is intensive care 3', '', 'checkbox', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'TreatmentDetail', '', 'ic_3_start_date', 'ic 3 start date', '', 'date', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'TreatmentDetail', '', 'ic_3_end_date', 'ic 3 end date', '', 'date', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'TreatmentDetail', '', 'ic_3_duration_in_days', 'ic 3 duration in days', '', 'integer', '', '',  NULL , '', 'open', 'open', 'open'), 

('', 'Clinicalannotation', 'TreatmentDetail', '', 'total_ic_duration_in_days', 'total ic duration in days', '', 'integer', '', '',  NULL , '', 'open', 'open', 'open');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='qc_hb_txd_surgery_pancreas'), 
(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='' AND `field`='hospitalization_start_date' AND `language_label`='hospitalization start date' AND `language_tag`='' AND `type`='date' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '20', 'hospitalization unit', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='qc_hb_txd_surgery_pancreas'), 
(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='' AND `field`='hospitalization_end_date' AND `language_label`='hospitalization end date' AND `language_tag`='' AND `type`='date' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '21', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='qc_hb_txd_surgery_pancreas'), 
(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='' AND `field`='hospitalization_duration_in_days' AND `language_label`='hospitalization duration in days' AND `language_tag`='' AND `type`='integer' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '22', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='qc_hb_txd_surgery_pancreas'), 
(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='' AND `field`='gastric_tube_duration_in_days' AND `language_label`='gastric tube duration in days' AND `language_tag`='' AND `type`='integer' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '23', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'),

((SELECT id FROM structures WHERE alias='qc_hb_txd_surgery_pancreas'), 
(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='' AND `field`='is_intensive_care_1' AND `language_label`='is intensive care 1' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `language_help`=''), '2', '24', 'intensive care', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='qc_hb_txd_surgery_pancreas'), 
(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='' AND `field`='ic_1_start_date' AND `language_label`='ic 1 start date' AND `language_tag`='' AND `type`='date' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '25', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='qc_hb_txd_surgery_pancreas'), 
(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='' AND `field`='ic_1_end_date' AND `language_label`='ic 1 end date' AND `language_tag`='' AND `type`='date' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '26', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='qc_hb_txd_surgery_pancreas'), 
(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='' AND `field`='ic_1_duration_in_days' AND `language_label`='ic 1 duration in days' AND `language_tag`='' AND `type`='integer' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '27', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1'), 

((SELECT id FROM structures WHERE alias='qc_hb_txd_surgery_pancreas'), 
(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='' AND `field`='is_intensive_care_2' AND `language_label`='is intensive care 2' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `language_help`=''), '2', '28', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='qc_hb_txd_surgery_pancreas'), 
(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='' AND `field`='ic_2_start_date' AND `language_label`='ic 2 start date' AND `language_tag`='' AND `type`='date' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '29', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='qc_hb_txd_surgery_pancreas'), 
(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='' AND `field`='ic_2_end_date' AND `language_label`='ic 2 end date' AND `language_tag`='' AND `type`='date' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '30', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='qc_hb_txd_surgery_pancreas'), 
(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='' AND `field`='ic_2_duration_in_days' AND `language_label`='ic 2 duration in days' AND `language_tag`='' AND `type`='integer' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '31', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='qc_hb_txd_surgery_pancreas'), 

(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='' AND `field`='is_intensive_care_3' AND `language_label`='is intensive care 3' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `language_help`=''), '2', '32', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='qc_hb_txd_surgery_pancreas'), 
(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='' AND `field`='ic_3_start_date' AND `language_label`='ic 3 start date' AND `language_tag`='' AND `type`='date' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '33', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='qc_hb_txd_surgery_pancreas'), 
(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='' AND `field`='ic_3_end_date' AND `language_label`='ic 3 end date' AND `language_tag`='' AND `type`='date' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '34', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='qc_hb_txd_surgery_pancreas'), 
(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='' AND `field`='ic_3_duration_in_days' AND `language_label`='ic 3 duration in days' AND `language_tag`='' AND `type`='integer' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '35', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1'), 

((SELECT id FROM structures WHERE alias='qc_hb_txd_surgery_pancreas'), 
(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='' AND `field`='total_ic_duration_in_days' AND `language_label`='total ic duration in days' AND `language_tag`='' AND `type`='integer' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '36', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='qc_hb_txd_surgery_livers'), 
(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='' AND `field`='hospitalization_start_date' AND `language_label`='hospitalization start date' AND `language_tag`='' AND `type`='date' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '20', 'hospitalization unit', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='qc_hb_txd_surgery_livers'), 
(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='' AND `field`='hospitalization_end_date' AND `language_label`='hospitalization end date' AND `language_tag`='' AND `type`='date' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '21', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='qc_hb_txd_surgery_livers'), 
(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='' AND `field`='hospitalization_duration_in_days' AND `language_label`='hospitalization duration in days' AND `language_tag`='' AND `type`='integer' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '22', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='qc_hb_txd_surgery_livers'), 
(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='' AND `field`='gastric_tube_duration_in_days' AND `language_label`='gastric tube duration in days' AND `language_tag`='' AND `type`='integer' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '23', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'),

((SELECT id FROM structures WHERE alias='qc_hb_txd_surgery_livers'), 
(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='' AND `field`='is_intensive_care_1' AND `language_label`='is intensive care 1' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `language_help`=''), '2', '24', 'intensive care', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='qc_hb_txd_surgery_livers'), 
(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='' AND `field`='ic_1_start_date' AND `language_label`='ic 1 start date' AND `language_tag`='' AND `type`='date' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '25', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='qc_hb_txd_surgery_livers'), 
(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='' AND `field`='ic_1_end_date' AND `language_label`='ic 1 end date' AND `language_tag`='' AND `type`='date' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '26', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='qc_hb_txd_surgery_livers'), 
(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='' AND `field`='ic_1_duration_in_days' AND `language_label`='ic 1 duration in days' AND `language_tag`='' AND `type`='integer' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '27', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1'), 

((SELECT id FROM structures WHERE alias='qc_hb_txd_surgery_livers'), 
(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='' AND `field`='is_intensive_care_2' AND `language_label`='is intensive care 2' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `language_help`=''), '2', '28', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='qc_hb_txd_surgery_livers'), 
(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='' AND `field`='ic_2_start_date' AND `language_label`='ic 2 start date' AND `language_tag`='' AND `type`='date' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '29', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='qc_hb_txd_surgery_livers'), 
(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='' AND `field`='ic_2_end_date' AND `language_label`='ic 2 end date' AND `language_tag`='' AND `type`='date' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '30', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='qc_hb_txd_surgery_livers'), 
(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='' AND `field`='ic_2_duration_in_days' AND `language_label`='ic 2 duration in days' AND `language_tag`='' AND `type`='integer' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '31', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='qc_hb_txd_surgery_livers'), 

(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='' AND `field`='is_intensive_care_3' AND `language_label`='is intensive care 3' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `language_help`=''), '2', '32', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='qc_hb_txd_surgery_livers'), 
(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='' AND `field`='ic_3_start_date' AND `language_label`='ic 3 start date' AND `language_tag`='' AND `type`='date' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '33', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='qc_hb_txd_surgery_livers'), 
(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='' AND `field`='ic_3_end_date' AND `language_label`='ic 3 end date' AND `language_tag`='' AND `type`='date' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '34', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='qc_hb_txd_surgery_livers'), 
(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='' AND `field`='ic_3_duration_in_days' AND `language_label`='ic 3 duration in days' AND `language_tag`='' AND `type`='integer' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '35', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1'), 

((SELECT id FROM structures WHERE alias='qc_hb_txd_surgery_livers'), 
(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='' AND `field`='total_ic_duration_in_days' AND `language_label`='total ic duration in days' AND `language_tag`='' AND `type`='integer' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '36', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1');

INSERT IGNORE INTO i18n (id, en, fr) VALUES
('specific liver surgery data' ,'Specific Data', 'Données Spécifiques'), 
('specific pancreas surgery data' ,'Specific Data', 'Données Spécifiques'),

('hospitalization unit', 'Hospitalization Unit', 'Données d''hospitalisation'),
('hospitalization start date', 'Hospitalization Start', 'Début hospitalisation'),
('hospitalization end date', 'Hospitalization End', 'Fin hospitalisation'),
('hospitalization duration in days', 'Hospitalization Duration (Days)', 'Durée hopsitalisation (jours)'),
('intensive care', 'Intensive Care', 'Soins intensifs'),
('is intensive care 1', '1st Intensive Care', '1er Soins intensifs'),
('ic 1 start date', 'IC-1 Start', 'Début SI-1'),
('ic 1 end date', 'IC-1 End', 'Fin SI-1'),
('ic 1 duration in days', 'IC-1 Duration (Days)', 'Durée SI-1 (Jours)'),

('is intensive care 2', '2nd Intensive Care', '2nd Soins intensifs'),
('ic 2 start date', 'IC-2 Start', 'Début SI-2'),
('ic 2 end date', 'IC-2 End', 'Fin SI-2'),
('ic 2 duration in days', 'IC-2 Duration (Days)', 'Durée SI-2 (Jours)'),

('is intensive care 3', '3rd Intensive Care', '3eme Soins intensifs'),
('ic 3 start date', 'IC-3 Start', 'Début SI-3'),
('ic 3 end date', 'IC-3 End', 'Fin SI-3'),
('ic 3 duration in days', 'IC-3 Duration (Days)', 'Durée SI-3 (Jours)'),


('gastric tube duration in days', 'Gastric Tube Use (Days)', 'Utilisation Sonde Gastrique (Jours)');
('total ic duration in days', 'Total IC Duration (Days)', 'Durée SI totale (Jours)');







