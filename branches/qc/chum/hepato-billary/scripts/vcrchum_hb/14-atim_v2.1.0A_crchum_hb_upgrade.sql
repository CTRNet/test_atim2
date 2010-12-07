
CREATE TABLE IF NOT EXISTS `qc_hb_ed_hepatobiliary_medical_past_history_asa` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  
  `asa_score` varchar(10) DEFAULT NULL,
  `event_master_id` int(11) NOT NULL,
  
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime DEFAULT NULL,
  `modified_by` int(10) unsigned NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

ALTER TABLE `qc_hb_ed_hepatobiliary_medical_past_history_asa`
  ADD FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT;

CREATE TABLE IF NOT EXISTS `qc_hb_ed_hepatobiliary_medical_past_history_asa_revs` (
  `id` int(11) NOT NULL,
  
  `asa_score` varchar(10) DEFAULT NULL,
  `event_master_id` int(11) NOT NULL,
  
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime DEFAULT NULL,
  `modified_by` int(10) unsigned NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

UPDATE event_controls SET form_alias = 'qc_hb_ed_hepatobiliary_medical_past_history_asa', detail_tablename = 'qc_hb_ed_hepatobiliary_medical_past_history_asa'
WHERE event_type = 'asa medical past history';

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("1", "1"),("2", "2"),("3", "3"),("4", "4"),("5", "5");
INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('qc_hb_asa_score', '', '', NULL);
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) 
VALUES
((SELECT id FROM structure_value_domains WHERE domain_name="qc_hb_asa_score"),  
(SELECT id FROM structure_permissible_values WHERE value="1" AND language_alias="1"), "1", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_hb_asa_score"),  
(SELECT id FROM structure_permissible_values WHERE value="2" AND language_alias="2"), "2", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_hb_asa_score"),  
(SELECT id FROM structure_permissible_values WHERE value="3" AND language_alias="3"), "3", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_hb_asa_score"),  
(SELECT id FROM structure_permissible_values WHERE value="4" AND language_alias="4"), "4", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_hb_asa_score"),  
(SELECT id FROM structure_permissible_values WHERE value="5" AND language_alias="5"), "5", "1");

INSERT INTO structures(`alias`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`) 
VALUES 
('qc_hb_ed_hepatobiliary_medical_past_history_asa', '', '', '1', '1', '1', '1');

INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES
('', '', 'EventDetail', 'qc_hb_ed_hepatobiliary_medical_past_history_asa', 'asa_score', 'asa score', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_asa_score') , '', 'open', 'open', 'open');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='qc_hb_ed_hepatobiliary_medical_past_history_asa'), 
(SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_date' ), '0', '1', '', '1', 'diagnostic date', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='qc_hb_ed_hepatobiliary_medical_past_history_asa'), 
(SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='disease_site' AND `language_label`='event_form_type' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='event_disease_site_list')  AND `language_help`=''), '0', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_hb_ed_hepatobiliary_medical_past_history_asa'), 
(SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_type' AND `language_label`='' AND `language_tag`='-' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='event_type_list')  AND `language_help`=''), '0', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_hb_ed_hepatobiliary_medical_past_history_asa'), 
(SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_summary' AND `language_label`='summary' AND `language_tag`='' AND `type`='textarea' AND `setting`='cols=40,rows=6' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '0', '20', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='qc_hb_ed_hepatobiliary_medical_past_history_asa'), 
(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_hb_ed_hepatobiliary_medical_past_history_asa' AND `field`='asa_score' AND `language_label`='asa score' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_asa_score')  AND `language_help`=''), '0', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1');

INSERT IGNORE INTO i18n (id,en,fr) VALUES ('asa score', 'Score', 'Score');

UPDATE structure_fields 
SET setting = 'size=10,url=/codingicd/CodingIcd10s/autocomplete/ca,tool=/codingicd/CodingIcd10s/tool/ca'
WHERE setting LIKE 'size=10,url=/codingicd/CodingIcd10s/%,tool=/codingicd/CodingIcd10s/%';

UPDATE structure_validations as val, structure_fields as fil
SET val.rule = 'validateIcd10CaCode'
WHERE val.structure_field_id = fil.id
AND fil.setting = 'size=10,url=/codingicd/CodingIcd10s/autocomplete/ca,tool=/codingicd/CodingIcd10s/tool/ca';

UPDATE structure_formats sfo INNER JOIN structure_fields sfi INNER JOIN structures s
SET sfo.flag_add = '0', sfo.flag_add_readonly = '0', 
sfo.flag_edit = '0', sfo.flag_edit_readonly = '0', 
sfo.flag_search = '0', sfo.flag_search_readonly = '0', 
sfo.flag_datagrid = '0', sfo.flag_datagrid_readonly = '0', 
sfo.flag_index = '0', sfo.flag_detail = '0'
WHERE sfi.id = sfo.structure_field_id
AND sfo.structure_id = s.id
AND sfi.field NOT IN ('dx_date', 'diagnosis_control_id')
AND s.alias = 'diagnosismasters'; 

UPDATE structure_formats sfo INNER JOIN structure_fields sfi INNER JOIN structures s
SET sfo.flag_add = '0', sfo.flag_add_readonly = '0', 
sfo.flag_edit = '0', sfo.flag_edit_readonly = '0', 
sfo.flag_search = '0', sfo.flag_search_readonly = '0', 
sfo.flag_datagrid = '0', sfo.flag_datagrid_readonly = '0', 
sfo.flag_index = '0', sfo.flag_detail = '0'
WHERE sfi.id = sfo.structure_field_id
AND sfo.structure_id = s.id
AND s.alias = 'treatmentmasters'; 

UPDATE structure_formats sfo INNER JOIN structure_fields sfi INNER JOIN structures s
SET sfo.flag_add = '0', sfo.flag_add_readonly = '0', 
sfo.flag_edit = '0', sfo.flag_edit_readonly = '0', 
sfo.flag_search = '1', sfo.flag_search_readonly = '0', 
sfo.flag_datagrid = '0', sfo.flag_datagrid_readonly = '0', 
sfo.flag_index = '1', sfo.flag_detail = '0'
WHERE sfi.id = sfo.structure_field_id
AND sfo.structure_id = s.id
AND sfi.field IN ('disease_site', 'tx_method', 'start_date')
AND s.alias = 'treatmentmasters'; 

UPDATE structure_formats sfo INNER JOIN structure_fields sfi INNER JOIN structures s
SET sfo.flag_add = '0', sfo.flag_add_readonly = '0', 
sfo.flag_edit = '0', sfo.flag_edit_readonly = '0', 
sfo.flag_search = '0', sfo.flag_search_readonly = '0', 
sfo.flag_datagrid = '0', sfo.flag_datagrid_readonly = '0', 
sfo.flag_index = '0', sfo.flag_detail = '0'
WHERE sfi.id = sfo.structure_field_id
AND sfo.structure_id = s.id
AND s.alias = 'consent_masters'; 

UPDATE structure_formats sfo INNER JOIN structure_fields sfi INNER JOIN structures s
SET sfo.flag_add = '0', sfo.flag_add_readonly = '0', 
sfo.flag_edit = '0', sfo.flag_edit_readonly = '0', 
sfo.flag_search = '1', sfo.flag_search_readonly = '0', 
sfo.flag_datagrid = '0', sfo.flag_datagrid_readonly = '0', 
sfo.flag_index = '1', sfo.flag_detail = '0'
WHERE sfi.id = sfo.structure_field_id
AND sfo.structure_id = s.id
AND sfi.field IN ('consent_control_id', 'consent_status', 'consent_signed_date', 'status_date')
AND s.alias = 'consent_masters'; 

UPDATE structure_formats sfo INNER JOIN structure_fields sfi INNER JOIN structures s
SET sfo.flag_add = '0', sfo.flag_add_readonly = '0', 
sfo.flag_edit = '0', sfo.flag_edit_readonly = '0', 
sfo.flag_search = '0', sfo.flag_search_readonly = '0', 
sfo.flag_datagrid = '0', sfo.flag_datagrid_readonly = '0', 
sfo.flag_index = '0', sfo.flag_detail = '0'
WHERE sfi.id = sfo.structure_field_id
AND sfo.structure_id = s.id
AND sfi.model = 'DiagnosisMaster'
AND sfi.field NOT IN ('dx_date')
AND s.alias = 'clinicalcollectionlinks'; 

UPDATE structure_formats sfo INNER JOIN structure_fields sfi INNER JOIN structures s
SET sfo.flag_add = '0', sfo.flag_add_readonly = '0', 
sfo.flag_edit = '0', sfo.flag_edit_readonly = '0', 
sfo.flag_search = '0', sfo.flag_search_readonly = '0', 
sfo.flag_datagrid = '0', sfo.flag_datagrid_readonly = '0', 
sfo.flag_index = '0', sfo.flag_detail = '0'
WHERE sfi.id = sfo.structure_field_id
AND sfo.structure_id = s.id
AND sfi.model = 'ConsentMaster'
AND sfi.field NOT IN ('consent_control_id', 'consent_status', 'consent_signed_date', 'status_date')
AND s.alias = 'clinicalcollectionlinks'; 

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='clinicalcollectionlinks'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `field`='diagnosis_control_id' ), '1', '0', 'diagnosis', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='clinicalcollectionlinks'), 
(SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `field`='consent_control_id' ), '2', '0', 'consent', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='clinicalcollectionlinks'), 
(SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `field`='consent_signed_date' ), '2', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1'); 

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("bilateral", "bilateral");
INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('qc_hb_laterality', '', '', NULL);
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) 
VALUES
((SELECT id FROM structure_value_domains WHERE domain_name="qc_hb_laterality"),  
(SELECT id FROM structure_permissible_values WHERE value="left" AND language_alias="left"), "1", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_hb_laterality"),  
(SELECT id FROM structure_permissible_values WHERE value="right" AND language_alias="right"), "2", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_hb_laterality"),  
(SELECT id FROM structure_permissible_values WHERE value="bilateral" AND language_alias="bilateral"), "3", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_hb_laterality"),  
(SELECT id FROM structure_permissible_values WHERE value="unknown" AND language_alias="unknown"), "4", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_hb_laterality"),  
(SELECT id FROM structure_permissible_values WHERE value="not applicable" AND language_alias="not applicable"), "5", "1");

UPDATE structure_fields
SET structure_value_domain = (SELECT id FROM structure_value_domains WHERE domain_name="qc_hb_laterality")
WHERE tablename = 'qc_hb_ed_hepatobilary_medical_imagings' AND field = 'lungs_laterality';

UPDATE structure_formats sfo INNER JOIN structure_fields sfi INNER JOIN structures s
SET display_column = '0'
WHERE sfi.id = sfo.structure_field_id
AND sfo.structure_id = s.id
AND s.alias = 'qc_hb_volumetry'; 

INSERT INTO i18n (id, en) VALUES ('pancreas (tumoral invasion)', 'Pancreas (Tumoral Invasion)');

UPDATE i18n SET en = 'Superior Mesenteric Artery' WHERE id = 'superior mesenteric artery';
UPDATE i18n SET en = 'Splenic Vein' WHERE id = 'splenic vein';
UPDATE i18n SET en = 'Superior Mesenteric Vein' WHERE id = 'superior mesenteric vein';

ALTER TABLE qc_hb_ed_hepatobilary_lab_report_biology
  ADD `other_marker_1_description` varchar(50) DEFAULT NULL AFTER `other_marker_1`,
  ADD `other_marker_2_description` varchar(50) DEFAULT NULL AFTER `other_marker_2`;
  
ALTER TABLE qc_hb_ed_hepatobilary_lab_report_biology_revs
  ADD `other_marker_1_description` varchar(50) DEFAULT NULL AFTER `other_marker_1`,
  ADD `other_marker_2_description` varchar(50) DEFAULT NULL AFTER `other_marker_2`;  
  
UPDATE structure_formats SET `display_order`='42' WHERE structure_id=(SELECT id FROM structures WHERE alias='ed_hepatobiliary_lab_report_biology') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='EventDetail' AND tablename='qc_hb_ed_hepatobilary_lab_report_biology' AND field='other_marker_2' AND type='float_positive' AND structure_value_domain  IS NULL );

INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_lab_report_biology', 'other_marker_1_description', 'other marker 1 description', '', 'input', 'size=10', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_lab_report_biology', 'other_marker_2_description', 'other marker 2 description', '', 'input', 'size=10', '',  NULL , '', 'open', 'open', 'open');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='ed_hepatobiliary_lab_report_biology'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_hb_ed_hepatobilary_lab_report_biology' AND `field`='other_marker_1_description' AND `language_label`='other marker 1 description' AND `language_tag`='' AND `type`='input' AND `setting`='size=10' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '41', '', '1', '', '1', 'type', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='ed_hepatobiliary_lab_report_biology'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_hb_ed_hepatobilary_lab_report_biology' AND `field`='other_marker_2_description' AND `language_label`='other marker 2 description' AND `language_tag`='' AND `type`='input' AND `setting`='size=10' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '43', '', '1', '', '1', 'type', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1');

UPDATE structure_formats sfo INNER JOIN structure_fields sfi INNER JOIN structures s
SET sfo.language_heading = 'surgery data (if post surgery report)'
WHERE sfi.id = sfo.structure_field_id
AND sfo.structure_id = s.id
AND sfi.field = 'surgery_tx_master_id'
AND s.alias = 'ed_hepatobiliary_lab_report_biology'; 
  
INSERT INTO i18n (id, en) VALUES ('surgery data (if post surgery report', 'Surgery Data (If post surgery report');

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("day 5", "day 5");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`)
 VALUES((SELECT id FROM structure_value_domains WHERE domain_name="post_surgery_report_type"),  (SELECT id FROM structure_permissible_values WHERE value="day 5" AND language_alias="day 5"), "5", "1");

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("other", "other");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="post_surgery_report_type"),  (SELECT id FROM structure_permissible_values WHERE value="other" AND language_alias="other"), "100", "1");

INSERT INTO i18n (id, en) VALUES ('day 5', 'Day 5');

UPDATE `i18n` SET `en` = 'Medical History Review Checklist' WHERE `id` = 'medical past history record summary';

UPDATE structure_permissible_values_customs SET en = '1-Initial Treatment', fr = '1-Traitement initial' WHERE value = 'initial treatment';
UPDATE structure_permissible_values_customs SET en = '2-Second Regimen', fr = '2-Second régime' WHERE value = 'second regimen';
UPDATE structure_permissible_values_customs SET en = '3-Third Regimen', fr = '3-Troisième régime' WHERE value = 'third regimen';
UPDATE structure_permissible_values_customs SET en = '4-Fourth Regimen', fr = '4-Quatrième régime' WHERE value = 'fourth regimen';

INSERT INTO i18n (id, en) VALUES ('surgery data (if post surgery report)', 'Surgery Data (If post surgery report)');

UPDATE menus SET flag_active = '0' WHERE use_link LIKE '/clinicalannotation/reproductive_histories%';

UPDATE structure_formats sfo INNER JOIN structure_fields sfi INNER JOIN structures s
SET sfo.flag_add = '0', sfo.flag_add_readonly = '0', 
sfo.flag_edit = '0', sfo.flag_edit_readonly = '0', 
sfo.flag_search = '0', sfo.flag_search_readonly = '0', 
sfo.flag_datagrid = '0', sfo.flag_datagrid_readonly = '0', 
sfo.flag_index = '0', sfo.flag_detail = '0'
WHERE sfi.id = sfo.structure_field_id
AND sfo.structure_id = s.id
AND sfi.model = 'MiscIdentifier'
AND sfi.field IN ('effective_date','expiry_date'); 

UPDATE structure_permissible_values_customs SET en = 'Arterial Thrombosis' WHERE value = 'arterial thrombosis';
UPDATE structure_permissible_values_customs SET en = 'Biliary Fistula' WHERE value = 'biliary fistula';
UPDATE structure_permissible_values_customs SET en = 'Biliary Stenosis' WHERE value = 'biliary stenosis';
UPDATE structure_permissible_values_customs SET en = 'Biological Insuffisancy' WHERE value = 'biological insuffisancy';
UPDATE structure_permissible_values_customs SET en = 'Endocrine Pancreatic Insuffisancy' WHERE value = 'endocrine pancreatic insuffisancy';
UPDATE structure_permissible_values_customs SET en = 'Exocrine Pancreatic Insuffisancy' WHERE value = 'exocrine pancreatic insuffisancy';
UPDATE structure_permissible_values_customs SET en = 'Hemorrhage' WHERE value = 'hemorrhage';
UPDATE structure_permissible_values_customs SET en = 'Hepatic' WHERE value = 'hepatic';
UPDATE structure_permissible_values_customs SET en = 'Hepatic Abcess' WHERE value = 'hepatic abcess';
UPDATE structure_permissible_values_customs SET en = 'Hepatic Insuffisancy' WHERE value = 'hepatic insuffisancy';
UPDATE structure_permissible_values_customs SET en = 'Jaundice' WHERE value = 'jaundice';
UPDATE structure_permissible_values_customs SET en = 'Pancreatic' WHERE value = 'pancreatic';
UPDATE structure_permissible_values_customs SET en = 'Pancreatic Abcess' WHERE value = 'pancreatic abcess';
UPDATE structure_permissible_values_customs SET en = 'Pancreatic Fistula' WHERE value = 'pancreatic fistula';

UPDATE structure_permissible_values_customs SET en = 'Encephalopathy' WHERE value = 'encephalopathy';

DROP TABLE IF EXISTS qc_hb_txd_portal_vein_embolizations;
DROP TABLE IF EXISTS qc_hb_txd_portal_vein_embolizations_revs;

DELETE FROM tx_masters WHERE tx_control_id = (SELECT id FROM tx_controls WHERE tx_method = 'portal vein embolization');
DELETE FROM tx_controls WHERE tx_method = 'portal vein embolization';
DELETE FROM structure_formats WHERE structure_id = (SELECT id FROM structures WHERE alias = 'qc_hb_txd_portal_vein_embolizations');
DELETE FROM structures WHERE alias = 'qc_hb_txd_portal_vein_embolizations';

CREATE TABLE IF NOT EXISTS `qc_hb_ed_hepatobiliary_medical_past_history_pve` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `event_master_id` int(11) NOT NULL,
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime DEFAULT NULL,
  `modified_by` int(10) unsigned NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

ALTER TABLE `qc_hb_ed_hepatobiliary_medical_past_history_pve`
  ADD CONSTRAINT `qc_hb_ed_hepatobiliary_medical_past_history_pve_ibfk_1` FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`);

CREATE TABLE IF NOT EXISTS `qc_hb_ed_hepatobiliary_medical_past_history_pve_revs` (
  `id` int(11) NOT NULL,
  `event_master_id` int(11) NOT NULL,
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime DEFAULT NULL,
  `modified_by` int(10) unsigned NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

INSERT INTO `event_controls` (`id`, `disease_site`, `event_group`, `event_type`, `flag_active`, `form_alias`, `detail_tablename`, `display_order`, `databrowser_label`) VALUES
(null, 'hepatobiliary', 'clinical', 'portal vein embolization medical past history', 1, 'qc_hb_ed_hepatobiliary_medical_past_history_pve', 'qc_hb_ed_hepatobiliary_medical_past_history_pve', 0, '');

ALTER TABLE `event_controls` CHANGE `databrowser_label` `databrowser_label` VARCHAR( 100 ) NOT NULL;
UPDATE event_controls SET databrowser_label = CONCAT(event_group,'|',event_type);

INSERT INTO structures(`alias`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`) VALUES ('qc_hb_ed_hepatobiliary_medical_past_history_pve', '', '', '1', '1', '1', '1');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='qc_hb_ed_hepatobiliary_medical_past_history_pve'), 
(SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_date'), '0', '1', '', '1', 'treatment date', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='qc_hb_ed_hepatobiliary_medical_past_history_pve'), 
(SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='disease_site'), '0', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_hb_ed_hepatobiliary_medical_past_history_pve'), 
(SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_type'), '0', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_hb_ed_hepatobiliary_medical_past_history_pve'), 
(SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_summary'), '0', '20', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1');

INSERT INTO i18n (id, en) VALUES ('scores','Scores'),('treatment date','Treatment Date'),('portal vein embolization medical past history','Portal Vein Embolization');

UPDATE consent_controls SET databrowser_label = controls_type;

INSERT INTO `tx_controls` (`id`, `tx_method`, `disease_site`, `flag_active`, `detail_tablename`, `form_alias`, `extend_tablename`, `extend_form_alias`, `display_order`, `applied_protocol_control_id`, `extended_data_import_process`, `databrowser_label`) VALUES
(null, 'chemo-embolization', 'hepatobiliary', 1, 'txd_chemos', 'qc_hb_tx_chemoembolizations', 'txe_chemos', 'txe_chemos', 0, NULL, 'importDrugFromChemoProtocol', 'hepatobiliary|chemotherapy');

INSERT INTO structures(`alias`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`) VALUES ('qc_hb_tx_chemoembolizations', '', '', '1', '1', '1', '1');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='qc_hb_tx_chemoembolizations'), 
(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='tx_masters' AND `field`='start_date'), '1', '1', '', '1', 'treatment date', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='qc_hb_tx_chemoembolizations'), 
(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='tx_masters' AND `field`='start_date_accuracy'), '1', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='qc_hb_tx_chemoembolizations'), 
(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='tx_masters' AND `field`='protocol_master_id'), '1', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='qc_hb_tx_chemoembolizations'), 
(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_chemos' AND `field`='num_cycles'), '1', '6', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='qc_hb_tx_chemoembolizations'), 
(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_chemos' AND `field`='qc_hb_toxicity'), '1', '7', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='qc_hb_tx_chemoembolizations'), 
(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='tx_masters' AND `field`='disease_site'), '1', '-1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_hb_tx_chemoembolizations'), 
(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='tx_masters' AND `field`='tx_method'), '1', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');

UPDATE tx_controls SET databrowser_label = CONCAT(disease_site,'|',tx_method);

INSERT INTO i18n (id, en) VALUES ('chemo-embolization', 'Chemo-Embolization');

UPDATE structure_value_domains_permissible_values 
SET structure_permissible_value_id = (SELECT id FROM structure_permissible_values WHERE value="0" AND language_alias="0")
WHERE structure_permissible_value_id = (SELECT id FROM structure_permissible_values WHERE value="0" AND language_alias="_0_");

DELETE FROM structure_permissible_values WHERE value="0" AND language_alias="_0_";

UPDATE structure_fields set language_label = concat(language_label, ' (umol/l)') WHERE tablename = 'qc_hb_ed_score_meld' AND field IN ('bilirubin', 'creatinine');

INSERT INTO i18n (id,en) VALUES ('bilirubin (umol/l)','Bilirubin (umol/l)'),('creatinine (umol/l)','Creatinine (umol/l)');

ALTER TABLE `qc_hb_ed_score_meld` 
  ADD `sodium` FLOAT UNSIGNED DEFAULT NULL AFTER `dialysis`,
  ADD `sodium_result` FLOAT UNSIGNED DEFAULT NULL AFTER `result`;
  
ALTER TABLE `qc_hb_ed_score_meld_revs` 
  ADD `sodium` FLOAT UNSIGNED DEFAULT NULL AFTER `dialysis`,
  ADD `sodium_result` FLOAT UNSIGNED DEFAULT NULL AFTER `result`;
  
INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_score_meld', 'sodium', 'sodium (meq/l)', '', 'float', 'size=5', '',  NULL , '', 'open', 'open', 'open'),
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_score_meld', 'sodium_result', 'MELD-Na', '', 'number', '', '',  NULL , '', 'open', 'open', 'open');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) 
VALUES 
((SELECT id FROM structures WHERE alias='qc_hb_ed_score_meld'), 
(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_hb_ed_score_meld' AND `field`='sodium' ), 
'1', '8', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'),
((SELECT id FROM structures WHERE alias='qc_hb_ed_score_meld'), 
(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_hb_ed_score_meld' AND `field`='sodium_result' ), 
'1', '9', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1');

INSERT INTO i18n (id,en) VALUES ('sodium (meq/l)', 'Sodium (mEq/l)');

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("partial pancreatectomy, pancreatic body & tail", "partial pancreatectomy, pancreatic body & tail");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="procedure_dxd_pex"),  (SELECT id FROM structure_permissible_values WHERE value="partial pancreatectomy, pancreatic body & tail" AND language_alias="partial pancreatectomy, pancreatic body & tail"), "6", "1");

INSERT INTO i18n (id,en) VALUES ('partial pancreatectomy, pancreatic body & tail','Partial pancreatectomy, pancreatic body & tail');

ALTER TABLE `dxd_cap_report_pancreasexos`
  ADD `tumor_site_splenectomy` tinyint(1) NULL DEFAULT 0 AFTER `tumor_site_pancreatic_tail`;
ALTER TABLE `dxd_cap_report_pancreasexos_revs`
  ADD `tumor_site_splenectomy` tinyint(1) NULL DEFAULT 0 AFTER `tumor_site_pancreatic_tail`;

INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasexos', 'tumor_site_splenectomy', 'splenectomy', '', 'checkbox', '', '',  (SELECT id FROM structure_value_domains WHERE domain_name LIKE 'yes_no_checkbox') , '', 'open', 'open', 'open'); 

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) 
VALUES 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasexos'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasexos' AND `field`='tumor_site_splenectomy'), 
'1', '25', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'); 

INSERT IGNORE INTO i18n (id,en) VALUES ('splenectomy','Splenectomy'),('pm0: no metastasis','pM0: No metastasis'),('pmX: unknown','pMX: Unknown');

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("pm0: no metastasis", "pm0: no metastasis"),('pmX: unknown','pmX: unknown');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES
((SELECT id FROM structure_value_domains WHERE domain_name="path_mstage_a"),  
(SELECT id FROM structure_permissible_values WHERE value="pm0: no metastasis" AND language_alias="pm0: no metastasis"), "11", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="path_mstage_a"),  
(SELECT id FROM structure_permissible_values WHERE value="pmX: unknown" AND language_alias="pmX: unknown"), "10", "1"),

((SELECT id FROM structure_value_domains WHERE domain_name="path_mstage_cr"),  
(SELECT id FROM structure_permissible_values WHERE value="pm0: no metastasis" AND language_alias="pm0: no metastasis"), "11", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="path_mstage_cr"),  
(SELECT id FROM structure_permissible_values WHERE value="pmX: unknown" AND language_alias="pmX: unknown"), "10", "1"),

((SELECT id FROM structure_value_domains WHERE domain_name="path_mstage_dbd"),  
(SELECT id FROM structure_permissible_values WHERE value="pm0: no metastasis" AND language_alias="pm0: no metastasis"), "11", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="path_mstage_dbd"),  
(SELECT id FROM structure_permissible_values WHERE value="pmX: unknown" AND language_alias="pmX: unknown"), "10", "1"),

((SELECT id FROM structure_value_domains WHERE domain_name="path_mstage_gb"),  
(SELECT id FROM structure_permissible_values WHERE value="pm0: no metastasis" AND language_alias="pm0: no metastasis"), "11", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="path_mstage_gb"),  
(SELECT id FROM structure_permissible_values WHERE value="pmX: unknown" AND language_alias="pmX: unknown"), "10", "1"),

((SELECT id FROM structure_value_domains WHERE domain_name="path_mstage_hc"),  
(SELECT id FROM structure_permissible_values WHERE value="pm0: no metastasis" AND language_alias="pm0: no metastasis"), "11", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="path_mstage_hc"),  
(SELECT id FROM structure_permissible_values WHERE value="pmX: unknown" AND language_alias="pmX: unknown"), "10", "1"),

((SELECT id FROM structure_value_domains WHERE domain_name="path_mstage_ibd"),  
(SELECT id FROM structure_permissible_values WHERE value="pm0: no metastasis" AND language_alias="pm0: no metastasis"), "11", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="path_mstage_ibd"),  
(SELECT id FROM structure_permissible_values WHERE value="pmX: unknown" AND language_alias="pmX: unknown"), "10", "1"),

((SELECT id FROM structure_value_domains WHERE domain_name="path_mstage_pbd"),  
(SELECT id FROM structure_permissible_values WHERE value="pm0: no metastasis" AND language_alias="pm0: no metastasis"), "11", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="path_mstage_pbd"),  
(SELECT id FROM structure_permissible_values WHERE value="pmX: unknown" AND language_alias="pmX: unknown"), "10", "1"),

((SELECT id FROM structure_value_domains WHERE domain_name="path_mstage_pe"),  
(SELECT id FROM structure_permissible_values WHERE value="pm0: no metastasis" AND language_alias="pm0: no metastasis"), "11", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="path_mstage_pe"),  
(SELECT id FROM structure_permissible_values WHERE value="pmX: unknown" AND language_alias="pmX: unknown"), "10", "1"),

((SELECT id FROM structure_value_domains WHERE domain_name="path_mstage_pex"),  
(SELECT id FROM structure_permissible_values WHERE value="pm0: no metastasis" AND language_alias="pm0: no metastasis"), "11", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="path_mstage_pex"),  
(SELECT id FROM structure_permissible_values WHERE value="pmX: unknown" AND language_alias="pmX: unknown"), "10", "1"),

((SELECT id FROM structure_value_domains WHERE domain_name="path_mstage_sm"),  
(SELECT id FROM structure_permissible_values WHERE value="pm0: no metastasis" AND language_alias="pm0: no metastasis"), "11", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="path_mstage_sm"),  
(SELECT id FROM structure_permissible_values WHERE value="pmX: unknown" AND language_alias="pmX: unknown"), "10", "1");

ALTER TABLE `qc_hb_ed_hepatobilary_medical_imagings` 
  ADD `density` FLOAT UNSIGNED DEFAULT NULL AFTER `segment_8_size`,
  ADD `type` VARCHAR(255) DEFAULT NULL AFTER `density`;
ALTER TABLE `qc_hb_ed_hepatobilary_medical_imagings_revs` 
  ADD `density` FLOAT UNSIGNED DEFAULT NULL AFTER `segment_8_size`,
  ADD `type` VARCHAR(255) DEFAULT NULL AFTER `density`;  
  
INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('qc_hb_medical_imaging_sgt_type', '', '', NULL);
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("homogeneous", "homogeneous");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="qc_hb_medical_imaging_sgt_type"),  (SELECT id FROM structure_permissible_values WHERE value="homogeneous" AND language_alias="homogeneous"), "1", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("n/a", "n/a");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="qc_hb_medical_imaging_sgt_type"),  (SELECT id FROM structure_permissible_values WHERE value="n/a" AND language_alias="n/a"), "3", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("heterogeneous", "heterogeneous");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) 
VALUES((SELECT id FROM structure_value_domains WHERE domain_name="qc_hb_medical_imaging_sgt_type"),  (SELECT id FROM structure_permissible_values WHERE value="heterogeneous" AND language_alias="heterogeneous"), "2", "1");

INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_medical_imagings', 'density', 'density (iu)', '', 'float', '', '', NULL, '', '', '', '');
INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES
('', 'Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_medical_imagings', 'type', 'type', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name="qc_hb_medical_imaging_sgt_type"), '', '', '', '');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) 
VALUES 
((SELECT id FROM structures WHERE alias='qc_hb_segment'), 
(SELECT id FROM structure_fields WHERE field = 'density' AND plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobilary_medical_imagings'), '1', '20', 'other', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '1'),
((SELECT id FROM structures WHERE alias='qc_hb_segment'), 
(SELECT id FROM structure_fields WHERE field = 'type' AND plugin = 'Clinicalannotation' AND model = 'EventDetail' AND tablename = 'qc_hb_ed_hepatobilary_medical_imagings'), '1', '21', '', '', '', '', '', '', '', '', '', '', '', '', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '1');

INSERT INTO i18n (id,en) VALUES ('density (iu)', 'Density (IU)'),('heterogeneous', 'Heterogeneous'), ('homogeneous','Homogeneous');

UPDATE structure_formats SET language_heading = 'gastric tube' WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE field = 'gastric_tube_duration_in_days');
DELETE FROM structure_formats WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE model = 'TreatmentDetail' AND field IN ('hospitalization_start_date','hospitalization_end_date','hospitalization_duration_in_days'));
DELETE FROM structure_fields WHERE model = 'TreatmentDetail' AND field IN ('hospitalization_start_date','hospitalization_end_date','hospitalization_duration_in_days');

ALTER TABLE `qc_hb_txd_surgery_pancreas`
 DROP COLUMN hospitalization_start_date,
 DROP COLUMN hospitalization_end_date,
 DROP COLUMN hospitalization_duration_in_days;

ALTER TABLE `qc_hb_txd_surgery_pancreas_revs`
 DROP COLUMN hospitalization_start_date,
 DROP COLUMN hospitalization_end_date,
 DROP COLUMN hospitalization_duration_in_days;

ALTER TABLE `qc_hb_txd_surgery_livers`
 DROP COLUMN hospitalization_start_date,
 DROP COLUMN hospitalization_end_date,
 DROP COLUMN hospitalization_duration_in_days;

ALTER TABLE `qc_hb_txd_surgery_livers_revs`
 DROP COLUMN hospitalization_start_date,
 DROP COLUMN hospitalization_end_date,
 DROP COLUMN hospitalization_duration_in_days;

CREATE TABLE IF NOT EXISTS `qc_hb_ed_hospitalization` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  
  `hospitalization_end_date` DATE DEFAULT NULL,
  `hospitalization_duration_in_days` INT(10) DEFAULT NULL ,
  
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `modified_by` int(10) unsigned NOT NULL,
  `event_master_id` int(11) DEFAULT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;


CREATE TABLE IF NOT EXISTS `qc_hb_ed_hospitalization_revs` (
  `id` int(11) NOT NULL,
  
  `hospitalization_end_date` DATE DEFAULT NULL,
  `hospitalization_duration_in_days` INT(10) DEFAULT NULL ,
  
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `modified_by` int(10) unsigned NOT NULL,
  `event_master_id` int(11) DEFAULT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`version_id`),
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;


ALTER TABLE `qc_hb_ed_hospitalization`
  ADD CONSTRAINT `qc_hb_ed_hospitalization_ibfk_1` FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`);

INSERT INTO `event_controls` (`id`, `disease_site`, `event_group`, `event_type`, `flag_active`, `form_alias`, `detail_tablename`, `display_order`, `databrowser_label`) VALUES
(null, 'hepatobiliary', 'clinical', 'hospitalization', 1, 'qc_hb_ed_hospitalization', 'qc_hb_ed_hospitalization', 0, 'clinical|hospitalization');

INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES
('', 'Clinicalannotation', 'EventDetail', '', 'hospitalization_end_date', 'hospitalization end date', '', 'date', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'EventDetail', '', 'hospitalization_duration_in_days', 'hospitalization duration in days', '', 'integer', '', '',  NULL , '', 'open', 'open', 'open');

INSERT INTO `structures` 
(`id`, `alias`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`, `created`, `created_by`, `modified`, `modified_by`) 
VALUES
(null, 'qc_hb_ed_hospitalization', '', '', '1', '1', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

SET @QC_HB_000001_structure_id = (SELECT id FROM structures WHERE alias = 'qc_hb_ed_hospitalization');
INSERT INTO `structure_formats` (`id`, `structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
-- disease_site
(null, @QC_HB_000001_structure_id, 
(SELECT id FROM structure_fields WHERE plugin = 'Clinicalannotation' AND model = 'EventMaster' AND tablename = 'event_masters' AND field IN ('disease_site')), 0, 2, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
-- event_type
(null, @QC_HB_000001_structure_id, 
(SELECT id FROM structure_fields WHERE plugin = 'Clinicalannotation' AND model = 'EventMaster' AND tablename = 'event_masters' AND field IN ('event_type')), 0, 3, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),

(null, @QC_HB_000001_structure_id, 
(SELECT id FROM structure_fields WHERE plugin = 'Clinicalannotation' AND model = 'EventMaster' AND tablename = 'event_masters' AND field IN ('event_date')), 0, 4, '', '1', 'hospitalization start date', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, @QC_HB_000001_structure_id, 
(SELECT id FROM structure_fields WHERE plugin = 'Clinicalannotation' AND model = 'EventDetail' AND field IN ('hospitalization_end_date')), 0, 5, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(null, @QC_HB_000001_structure_id, 
(SELECT id FROM structure_fields WHERE plugin = 'Clinicalannotation' AND model = 'EventDetail' AND field IN ('hospitalization_duration_in_days')), 0, 5, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),

-- event_summary
(null, @QC_HB_000001_structure_id,
(SELECT id FROM structure_fields WHERE plugin = 'Clinicalannotation' AND model = 'EventMaster' AND tablename = 'event_masters' AND field IN ('event_summary')), 0, 20, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

INSERT INTO i18n (id,en) VALUES ('gastric tube', ''),('hospitalization','Hospitalization');

UPDATE menus set display_order = '1' WHERE parent_id = 'clin_CAN_1' AND language_title = 'profile';
UPDATE menus set display_order = '2' WHERE parent_id = 'clin_CAN_1' AND language_title = 'identification';
UPDATE menus set display_order = '3' WHERE parent_id = 'clin_CAN_1' AND language_title = 'contacts';
UPDATE menus set display_order = '4' WHERE parent_id = 'clin_CAN_1' AND language_title = 'family history';
UPDATE menus set display_order = '5' WHERE parent_id = 'clin_CAN_1' AND language_title = 'annotation';
UPDATE menus set display_order = '6' WHERE parent_id = 'clin_CAN_1' AND language_title = 'treatment';
UPDATE menus set display_order = '7' WHERE parent_id = 'clin_CAN_1' AND language_title = 'diagnosis';
UPDATE menus set display_order = '8' WHERE parent_id = 'clin_CAN_1' AND language_title = 'consent';
UPDATE menus set display_order = '9' WHERE parent_id = 'clin_CAN_1' AND language_title = 'message';
UPDATE menus set display_order = '9' WHERE parent_id = 'clin_CAN_1' AND language_title = 'participant inventory';
UPDATE menus set display_order = '9' WHERE parent_id = 'clin_CAN_1' AND language_title = 'chronology';

DELETE FROM structure_permissible_values_customs WHERE control_id = (SELECT id FROM  `structure_permissible_values_custom_controls` WHERE name like 'surgey - complication : type');
INSERT INTO structure_permissible_values_customs (value,en,control_id) VALUES
('arterial thrombosis', 'HEPATIC - Arterial thrombosis', (SELECT id FROM  `structure_permissible_values_custom_controls` WHERE name like 'surgey - complication : type')),
('ascite', 'HEPATIC - Ascite', (SELECT id FROM  `structure_permissible_values_custom_controls` WHERE name like 'surgey - complication : type')),
('biliary fistule', 'HEPATIC - Biliary fistule', (SELECT id FROM  `structure_permissible_values_custom_controls` WHERE name like 'surgey - complication : type')),
('biliary stenosis', 'HEPATIC - Biliary stenosis', (SELECT id FROM  `structure_permissible_values_custom_controls` WHERE name like 'surgey - complication : type')),
('biological hepatic insufficiency', 'HEPATIC - Biological hepatic insufficiency', (SELECT id FROM  `structure_permissible_values_custom_controls` WHERE name like 'surgey - complication : type')),
('clinical hepatic insufficiency', 'HEPATIC - Clinical hepatic insufficiency', (SELECT id FROM  `structure_permissible_values_custom_controls` WHERE name like 'surgey - complication : type')),
('encephalopathy', 'HEPATIC - Encephalopathy', (SELECT id FROM  `structure_permissible_values_custom_controls` WHERE name like 'surgey - complication : type')),
('hepatic abcess', 'HEPATIC - Hepatic abcess', (SELECT id FROM  `structure_permissible_values_custom_controls` WHERE name like 'surgey - complication : type')),
('jaundice', 'HEPATIC - Jaundice', (SELECT id FROM  `structure_permissible_values_custom_controls` WHERE name like 'surgey - complication : type')),

('delayed gastric emptying', 'PANCREATIC - Delayed gastric emptying', (SELECT id FROM  `structure_permissible_values_custom_controls` WHERE name like 'surgey - complication : type')),
('endocrine pancreatic insufficiency', 'PANCREATIC - Endocrine pancreatic insufficiency', (SELECT id FROM  `structure_permissible_values_custom_controls` WHERE name like 'surgey - complication : type')),
('exocrine pancreatic insufficiency', 'PANCREATIC - xocrine pancreatic insufficiency', (SELECT id FROM  `structure_permissible_values_custom_controls` WHERE name like 'surgey - complication : type')),
('pancreatic fistula', 'PANCREATIC - Pancreatic fistula', (SELECT id FROM  `structure_permissible_values_custom_controls` WHERE name like 'surgey - complication : type')),
('biliary fistula', 'PANCREATIC - Biliary fistula', (SELECT id FROM  `structure_permissible_values_custom_controls` WHERE name like 'surgey - complication : type')),
('intestinal fistula', 'PANCREATIC - Intestinal fistula', (SELECT id FROM  `structure_permissible_values_custom_controls` WHERE name like 'surgey - complication : type')),

('abcess', 'OTHERS - Abcess',(SELECT id FROM  `structure_permissible_values_custom_controls` WHERE name like 'surgey - complication : type')),
('hemorrhage', 'OTHERS - Hemorrhage',(SELECT id FROM  `structure_permissible_values_custom_controls` WHERE name like 'surgey - complication : type'));

UPDATE sample_to_aliquot_controls as link,sample_controls AS samp,aliquot_controls AS al
SET link.flag_active = '1'
WHERE samp.id = link.sample_control_id
AND al.id = link.aliquot_control_id
AND al.form_alias = 'ad_spec_tubes'
AND samp.sample_type = 'tissue';

SET @ctr_id_to_del = (SELECT id FROM sample_to_aliquot_controls WHERE aliquot_control_id IN (SELECT id FROM aliquot_controls WHERE form_alias = 'ad_spec_qc_hb_tissue_tubes'));
DELETE FROM realiquoting_controls WHERE parent_sample_to_aliquot_control_id = (@ctr_id_to_del) OR child_sample_to_aliquot_control_id = (@ctr_id_to_del);
DELETE FROM sample_to_aliquot_controls WHERE aliquot_control_id IN (SELECT id FROM aliquot_controls WHERE form_alias = 'ad_spec_qc_hb_tissue_tubes');
DELETE FROM aliquot_controls WHERE form_alias = 'ad_spec_qc_hb_tissue_tubes';

DELETE FROM structure_formats WHERE structure_id = (SELECT id FROM structures WHERE alias = 'ad_spec_qc_hb_tissue_tubes');
DELETE FROM structure_fields WHERE field = 'qc_hb_is_conic_tube';
DELETE FROM structure_fields WHERE field = 'qc_hb_milieu' AND structure_value_domain = (SELECT id FROM structure_value_domains WHERE domain_name = 'qc_hb_conical_tube_milieu');
DELETE FROM structure_value_domains_permissible_values WHERE structure_value_domain_id = (SELECT id FROM structure_value_domains WHERE domain_name = 'qc_hb_conical_tube_milieu');
DELETE FROM structure_value_domains WHERE domain_name = 'qc_hb_conical_tube_milieu';

ALTER TABLE `ad_tubes` DROP COLUMN `qc_hb_is_conic_tube`;
ALTER TABLE `ad_tubes_revs` DROP COLUMN `qc_hb_is_conic_tube`;

ALTER TABLE `sd_der_tiss_susps` 
  ADD `qc_hb_tissue_source_in_serum` varchar(50)  AFTER `qc_hb_viability_perc`;
ALTER TABLE `sd_der_tiss_susps_revs` 
  ADD `qc_hb_tissue_source_in_serum` varchar(50)  AFTER `qc_hb_viability_perc`;

INSERT INTO structure_fields (`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES
('', 'Inventorymanagement', 'SampleDetail', 'sd_der_tiss_susps', 'qc_hb_tissue_source_in_serum', 'tissue source into serum (rpmi + fbs)', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_yes_no_unknwon') , '', 'open', 'open', 'open');

INSERT INTO structure_formats (`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='sd_tissue_susp'), 
(SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_der_tiss_susps' AND `field`='qc_hb_tissue_source_in_serum'), '1', '55', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1');

INSERT INTO i18n (id,en) VALUES ('tissue source into serum (rpmi + fbs)', 'Tissue Source Into Serum (RPMI + FBS)');

UPDATE structure_permissible_values SET value = '10^6', language_alias = '10^6' WHERE value = '10e6' AND language_alias = '10e6';
UPDATE structure_permissible_values SET value = '10^7', language_alias = '10^7' WHERE value = '10e7' AND language_alias = '10e7';
UPDATE structure_permissible_values SET value = '10^8', language_alias = '10^8' WHERE value = '10e8' AND language_alias = '10e8';

UPDATE structure_formats SET display_order = 22
WHERE structure_id = (SELECT id FROM structures WHERE alias='dx_cap_report_pancreasexos')
AND structure_field_id = (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasexos' AND `field`='tumor_site_splenectomy');



-----------------------------------------------------------------------
- TASKS TODO BEFORE GO LIVE -

- UPDATE PERMISSION: NO ACCESS TO FORMS, MATERIAL, EQUIP., SOP, LIMITED ACCESS TO STUDY, NO REPROD HIST
- REVIEW ALL FLAG_SEARCH FLAG_INDEX FOR DATABROWSER (INCLUDING MASTER/DETAIL MODEL)
- RUN DB VALIDATION

-- Tester les vu
-- Tester le meld
