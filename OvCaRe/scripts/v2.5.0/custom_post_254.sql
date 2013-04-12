UPDATE `versions` SET branch_build_number = 'xxx' WHERE version_number = '2.5.4';

UPDATE menus SET use_link = '/ClinicalAnnotation/EventMasters/listall/lab/%%Participant.id%%' WHERE id = 'clin_CAN_4';

UPDATE consent_controls SET detail_form_alias = '' WHERE controls_type = 'ovcare';

UPDATE treatment_controls SET extend_tablename = 'txe_chemos', extend_form_alias = 'txe_chemos' WHERE tx_method = 'chemotherapy' AND disease_site = 'ovcare';
UPDATE menus SET flag_active = 1 WHERE use_link like '/Drug/Drugs/%';

UPDATE treatment_controls SET extend_tablename = 'txe_surgeries', extend_form_alias = 'txe_surgeries' WHERE tx_method = 'surgery' AND disease_site = 'ovcare';
INSERT structure_value_domains (domain_name,source) VALUES ('ovcare_surgery_procedure_type', "StructurePermissibleValuesCustom::getCustomDropdown('Surgery type')");
INSERT INTO structure_permissible_values_custom_controls (name,flag_active, values_max_length) VALUES ('Surgery type', '1', '50');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Surgery type');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`) 
VALUES 
('hysterectomy','Hysterectomy', '', '1', @control_id),
('l. oophorectomy','L. Oophorectomy', '', '1', @control_id),
('r. oophorectomy','R. Oophorectomy', '', '1', @control_id),
('l. salpingectomy','L. Salpingectomy', '', '1', @control_id),
('r. salpingectomy','R. Salpingectomy', '', '1', @control_id),
('omentectomy','Omentectomy', '', '1', @control_id),
('omental biopsy','Omental Biopsy', '', '1', @control_id),
('cul de sac biopsy','Cul de Sac Biopsy', '', '1', @control_id),
('paracentesis','Paracentesis', '', '1', @control_id),
('pelvic lymphadnectomy','Pelvic Lymphadnectomy', '', '1', @control_id),
('pelvic sidewall biopsy','Pelvic Sidewall Biopsy', '', '1', @control_id),
('Bladder peritoneum biopsy','Bladder Peritoneum Biopsy', '', '1', @control_id),
('para-aortic lymphadnectomy','Para-aortic Lymphadnectomy', '', '1', @control_id),
('hemicolectomy','Hemicolectomy', '', '1', @control_id),
('sigmoid colon','Sigmoid Colon', '', '1', @control_id),
('transverse colon','Transverse Colon', '', '1', @control_id),
('large bowel','Large Bowel', '', '1', @control_id),
('small bowel','Small Bowel', '', '1', @control_id),
('right colon','Right Colon', '', '1', @control_id),
('appendectomy','Appendectomy', '', '1', @control_id),
('liver resection','Liver Resection', '', '1', @control_id),
('vaginal biopsy','Vaginal Biopsy', '', '1', @control_id),
('core biopsy','Core Biopsy', '', '1', @control_id),
('uterine myomectomy','Uterine Myomectomy', '', '1', @control_id),
('miscellaneous debulking','Miscellaneous Debulking', '', '1', @control_id);
UPDATE structure_fields SET  `type`='select',  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_surgery_procedure_type') ,  `setting`='',  `language_help`='' WHERE model='TreatmentExtend' AND tablename='txe_surgeries' AND field='surgical_procedure' AND `type`='input' AND structure_value_domain  IS NULL ;
INSERT INTO structure_validations(structure_field_id, rule) VALUES
((SELECT id FROM structure_fields WHERE model='TreatmentExtend' AND tablename='txe_surgeries' AND field='surgical_procedure'), 'notEmpty');

UPDATE menus SET flag_active = '1' WHERE language_title = 'clin_study';
INSERT INTO study_summaries (`title`, `modified`, `created`, `created_by`, `modified_by`) 
VALUES 
('Intratumoural Heterogenity', NOW(), NOW(), 1, 1),
('High Grade Endometrial', NOW(), NOW(), 1, 1),
('TFRI COEUR', NOW(), NOW(), 1, 1),
('TCGA', NOW(), NOW(), 1, 1),
('Tumour Bank TMA', NOW(), NOW(), 1, 1),
('Endometriosis', NOW(), NOW(), 1, 1),
('Ovarian Cancer Diagnosis', NOW(), NOW(), 1, 1),
('Precursor to Prevention (TICS)', NOW(), NOW(), 1, 1),
('Fimbrial Scraping for Culture', NOW(), NOW(), 1, 1),
('Xenograft', NOW(), NOW(), 1, 1),
('Cell Culture', NOW(), NOW(), 1, 1);
INSERT INTO study_summaries_revs (`id`, `title`, `modified_by`, `version_created`) 
(SELECT id, title, created_by, created FROM  study_summaries);

INSERT INTO `event_controls` (`id`, `disease_site`, `event_group`, `event_type`, `flag_active`, `detail_form_alias`, `detail_tablename`, `display_order`, `databrowser_label`, `flag_use_for_ccl`) VALUES
(null, 'ovcare', 'study', 'study inclusion', 1, 'ovcare_ed_study_inclusions', 'ovcare_ed_study_inclusions', 0, 'study inclusion', 1);
INSERT INTO structures(`alias`) VALUES ('ovcare_ed_study_inclusions');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', 'ovcare_ed_study_inclusions', 'study_summary_id', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='study_list') , '0', '', '', '', 'study / project', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ovcare_ed_study_inclusions'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_study_inclusions' AND `field`='study_summary_id' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='study_list')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='study / project' AND `language_tag`=''), '2', '11', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0');
CREATE TABLE IF NOT EXISTS `ovcare_ed_study_inclusions` (
  `study_summary_id` int(11) DEFAULT NULL,
  `event_master_id` int(11) NOT NULL,
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE IF NOT EXISTS `ovcare_ed_study_inclusions_revs` (
  `study_summary_id` int(11) DEFAULT NULL,
  `event_master_id` int(11) NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`),
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;
ALTER TABLE `ovcare_ed_study_inclusions`
  ADD CONSTRAINT `ovcare_ed_study_inclusions_ibfk_1` FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`);
INSERT INTO structure_validations(structure_field_id, rule) VALUES
((SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_study_inclusions' AND `field`='study_summary_id'), 'notEmpty');
INSERT INTO i18n (id,en) VALUES ('study inclusion','Study Inclusion ');

UPDATE event_controls SET databrowser_label = event_type WHERE flag_active = 1;
UPDATE treatment_controls SET databrowser_label = tx_method WHERE flag_active = 1;

TODO: enlever les ovcare dans add even ou add trt
TODO: Add in batch pour study aussi

















