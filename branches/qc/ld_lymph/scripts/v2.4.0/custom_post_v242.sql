ALTER TABLE ld_lymph_txd_observations
 DROP FOREIGN KEY FK_ld_lymph_txd_observations_tx_masters,
 CHANGE tx_master_id treatment_master_id INT NOT NULL,
 ADD FOREIGN KEY (treatment_master_id) REFERENCES treatment_masters(id);
ALTER TABLE ld_lymph_txd_observations_revs
 CHANGE tx_master_id treatment_master_id INT NOT NULL;

ALTER TABLE ld_lymph_txd_stem_cell_transplants
 DROP FOREIGN KEY FK_ld_lymph_txd_stem_cell_transplants_tx_masters,
 CHANGE tx_master_id treatment_master_id INT NOT NULL,
 ADD FOREIGN KEY (treatment_master_id) REFERENCES treatment_masters(id);
ALTER TABLE ld_lymph_txd_stem_cell_transplants_revs
 CHANGE tx_master_id treatment_master_id INT NOT NULL;

ALTER TABLE ld_lymph_txd_treatments
 DROP FOREIGN KEY FK_ld_lymph_txd_treatments_tx_masters,
 CHANGE tx_master_id treatment_master_id INT NOT NULL,
 ADD FOREIGN KEY (treatment_master_id) REFERENCES treatment_masters(id);
ALTER TABLE ld_lymph_txd_treatments_revs
 CHANGE tx_master_id treatment_master_id INT NOT NULL; 

UPDATE event_controls SET flag_active = 0 WHERE event_type = 'comorbidity';

DELETE FROM structure_formats WHERE structure_id IN (SELECT id FROM structures WHERE alias IN ('ld_lymph_ed_biopsies'))
AND structure_field_id = (SELECT id FROM structure_fields WHERE field = 'event_date');

CREATE TABLE IF NOT EXISTS `ld_lymph_consent_details` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `consent_master_id` int(11) NOT NULL,
  
  `allow_to_be_contacted` char(1) DEFAULT '',  
  
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `consent_master_id` (`consent_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE IF NOT EXISTS `ld_lymph_consent_details_revs` (
  `id` int(11) NOT NULL,
  `consent_master_id` int(11) NOT NULL,
  
  `allow_to_be_contacted` char(1) DEFAULT '',  
  
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;


ALTER TABLE `ld_lymph_consent_details`
  ADD CONSTRAINT `ld_lymph_consent_details_ibfk_1` FOREIGN KEY (`consent_master_id`) REFERENCES `consent_masters` (`id`);

UPDATE consent_controls SET detail_tablename = 'ld_lymph_consent_details', form_alias = 'consent_masters,ld_lymph_consent_details' WHERE controls_type = 'ld lymph. consent';

INSERT INTO structures(`alias`) VALUES ('ld_lymph_consent_details');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'ConsentDetail', 'ld_lymph_consent_details', 'allow_to_be_contacted', 'yes_no',  NULL , '0', '', '', '', 'allow to be contacted', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='ld_lymph_consent_details'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='ld_lymph_consent_details' AND `field`='allow_to_be_contacted' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='allow to be contacted' AND `language_tag`=''), '2', '22', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0');

INSERT INTO i18n (id,en) VALUEs ('allow to be contacted','Allow To Be Contacted');

ALTER TABLE ld_lymph_ed_biopsies DROP COLUMN surgery_nbr;
ALTER TABLE ld_lymph_ed_biopsies_revs DROP COLUMN surgery_nbr;
DELETE FROM structure_formats WHERE structure_field_id = (SELECT id FROM structure_fields WHERE field = 'surgery_nbr' AND tablename = 'ld_lymph_ed_biopsies');
DELETE FROM structure_fields WHERE field = 'surgery_nbr' AND tablename = 'ld_lymph_ed_biopsies';

UPDATE structure_fields SET type='input', setting = 'size=10' WHERE field = 'who_class' AND model = 'EventDetail';

INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) 
VALUES
((SELECT id FROM structure_value_domains WHERE domain_name="pos_neg_equivocal"),  
(SELECT id FROM structure_permissible_values WHERE value="not performed" AND language_alias="not performed"), "4", "1");
UPDATE structure_fields SET structure_value_domain = (SELECT id FROM structure_value_domains WHERE domain_name="pos_neg_equivocal") 
WHERE structure_value_domain = (SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_pos_neg");

DELETE FROM structure_value_domains_permissible_values  WHERE structure_value_domain_id = (SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_pos_neg");
DELETE FROM structure_value_domains WHERE domain_name = 'ld_lymph_pos_neg';

INSERT INTO `structure_value_domains` (`id`, `domain_name`, `override`, `category`, `source`) VALUES (NULL, 'ld_lymph_labs_hiv_test_values', 'open', '', NULL);
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_labs_hiv_test_values"),  
(SELECT id FROM structure_permissible_values WHERE value="negative" AND language_alias="negative"), "1", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_labs_hiv_test_values"),  
(SELECT id FROM structure_permissible_values WHERE value="positive" AND language_alias="positive"), "2", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_labs_hiv_test_values"),  
(SELECT id FROM structure_permissible_values WHERE value="not performed" AND language_alias="not performed"), "3", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_labs_hiv_test_values"),  
(SELECT id FROM structure_permissible_values WHERE value="hidden" AND language_alias="hidden"), "4", "1");

UPDATE structure_fields SET structure_value_domain = (SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_labs_hiv_test_values") 
WHERE field = 'hiv' AND tablename = 'ld_lymph_ed_labs';

DELETE FROM structure_value_domains_permissible_values  WHERE structure_value_domain_id = (SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_labs_test_values")
AND structure_permissible_value_id = (SELECT id FROM structure_permissible_values WHERE value="hidden" AND language_alias="hidden");

ALTER TABLE ld_lymph_ed_reasearch_studies 
  ADD COLUMN `tumor_dna_in_molecular_lab` char(1) DEFAULT '' AFTER consent_date, 
  ADD COLUMN `germ_dna_available` char(1) DEFAULT '' AFTER tumor_dna_in_molecular_lab;
ALTER TABLE ld_lymph_ed_reasearch_studies_revs 
  ADD COLUMN `tumor_dna_in_molecular_lab` char(1) DEFAULT '' AFTER consent_date, 
  ADD COLUMN `germ_dna_available` char(1) DEFAULT '' AFTER tumor_dna_in_molecular_lab;  
  
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_reasearch_studies', 'tumor_dna_in_molecular_lab', 'yes_no', NULL, '0', '', '', '', 'tumor dna in molecular lab', ''),
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_reasearch_studies', 'germ_dna_available', 'yes_no', NULL, '0', '', '', '', 'germline dna available', '');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_reasearch_studies'), 
(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_reasearch_studies' AND `field`='tumor_dna_in_molecular_lab'), 
'1', '53', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'),
((SELECT id FROM structures WHERE alias='ld_lymph_ed_reasearch_studies'), 
(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_reasearch_studies' AND `field`='germ_dna_available'), 
'1', '53', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0');

INSERT INTO i18n (id,en) VALUES ('tumor dna in molecular lab','Tumor DNA In Molecular Lab'),('germline dna available','Germline DNA Available');

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='consent_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='status_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='consent_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='status_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

ALTER TABLE ld_lymph_consent_details 
ADD COLUMN withdrawn_date date DEFAULT NULL AFTER allow_to_be_contacted,
ADD COLUMN withdrawn_date_accuracy char(1) NOT NULL DEFAULT '' AFTER withdrawn_date;

ALTER TABLE ld_lymph_consent_details_revs
ADD COLUMN withdrawn_date date DEFAULT NULL AFTER allow_to_be_contacted,
ADD COLUMN withdrawn_date_accuracy char(1) NOT NULL DEFAULT '' AFTER withdrawn_date;

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'ConsentDetail', 'ld_lymph_consent_details', 'withdrawn_date', 'datetime',  NULL , '0', '', '', '', 'withdrawn date', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='ld_lymph_consent_details'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='ld_lymph_consent_details' AND `field`='withdrawn_date'), '2', '22', 'withdrawn', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0');

UPDATE structure_formats SET `display_column`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='consent_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='notes' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='ld_lymph_consent_details') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `field`='allow_to_be_contacted');

INSERT IGNORE INTO i18n (id,en) VALUES ('withdrawn','Withdrawn'),('withdrawn date','Withdrawn Date');

INSERT INTO `structure_value_domains` (`domain_name`) VALUES ('ld_lymph_status_at_last_followup');
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES 
("progression","progression"),
("stable disease","stable disease"),
("complete remission","complete remission"),
("relapse","relapse");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_status_at_last_followup"),  
(SELECT id FROM structure_permissible_values WHERE value="progression" AND language_alias="progression"), "0", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_status_at_last_followup"),  
(SELECT id FROM structure_permissible_values WHERE value="stable disease" AND language_alias="stable disease"), "1", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_status_at_last_followup"),  
(SELECT id FROM structure_permissible_values WHERE value="complete remission" AND language_alias="complete remission"), "2", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_status_at_last_followup"),  
(SELECT id FROM structure_permissible_values WHERE value="relapse" AND language_alias="relapse"), "3", "1");

UPDATE structure_fields SET  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='ld_lymph_status_at_last_followup') ,  `language_help`='',  `language_label`='status at last follow-up' WHERE model='Participant' AND tablename='participants' AND field='vital_status' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='health_status');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='vital_status' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='health_status') AND `flag_confidential`='0');

INSERT IGNORE INTO i18n (id,en) VALUES ('relapse','Relapse'),('complete remission','Complete Remission'),('status at last follow-up','Status at Last Follow-up');

UPDATE structure_fields SET type = 'date' WHERE tablename = 'ld_lymph_consent_details' AND field = 'withdrawn_date';

UPDATE structure_fields SET language_label = 'lymphoma type' WHERE field = 'lymphoma_type';
INSERT IGNORE INTO i18n (id,en) VALUES ('lymphoma type','Lymphoma Type');
REPLaCE INTO i18n (id,en) VALUES ('lymphoma type','Lymphoma Type');

ALTER TABLE ld_lymph_dx_lymphomas
  MODIFY baseline_b_desc VARCHAR(250) NULL;
ALTER TABLE ld_lymph_dx_lymphomas_revs
  MODIFY baseline_b_desc VARCHAR(250) NULL;

INSERT INTO `structure_value_domains` (`id`, `domain_name`, `override`, `category`, `source`) VALUES (NULL, 'custom_baseline_b_desc_list', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(''lymphoma B symptoms descriptions'')');
INSERT INTO structure_permissible_values_custom_controls (name,flag_active,values_max_length)
VALUES ('lymphoma B symptoms descriptions', '1', '250');
UPDATE structure_fields SET type = 'select', setting = '', structure_value_domain = (SELECT id FROM structure_value_domains WHERE domain_name = 'custom_baseline_b_desc_list')
WHERE field = 'baseline_b_desc';

ALTER TABLE ld_lymph_ed_imagings DROP COLUMN scan_nbr;
ALTER TABLE ld_lymph_ed_imagings_revs DROP COLUMN scan_nbr;

DELETE FROM structure_formats WHERE structure_field_id = (SELECT id FROM structure_fields WHERE field = 'scan_nbr' AND tablename = 'ld_lymph_ed_imagings');
DELETE FROM structure_fields WHERE field = 'scan_nbr' AND tablename = 'ld_lymph_ed_imagings';

ALTER TABLE `ld_lymph_ed_imagings` 
 ADD COLUMN lymph_node_for_petsuv_other_desc VARCHAR (250) AFTER lymph_node_for_petsuv_other;
ALTER TABLE `ld_lymph_ed_imagings_revs` 
 ADD COLUMN lymph_node_for_petsuv_other_desc VARCHAR (250) AFTER lymph_node_for_petsuv_other;
  
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_imagings', 'lymph_node_for_petsuv_other_desc', 'input',  NULL , '0', 'size=30', '', '', '', 'lymph node other description'); 
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_imagings'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_imagings' AND `field`='lymph_node_for_petsuv_other_desc'), '3', '44', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');

UPDATE structure_formats SET `display_order`='45' WHERE structure_id=(SELECT id FROM structures WHERE alias='ld_lymph_ed_imagings') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_imagings' AND `field`='initial_pet_suv_max' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
 
INSERT INTO i18n (id,en) VALUEs ('lymph node other description','Precision');

ALTER TABLE `ld_lymph_ed_biopsies`
  MODIFY `cytomet_cd20` decimal(5,2) DEFAULT null,		
  MODIFY `cytomet_cd19` decimal(5,2) DEFAULT null,	
  MODIFY `cytomet_cd10` decimal(5,2) DEFAULT null,	
  MODIFY `cytomet_cd5` decimal(5,2) DEFAULT null,	
  MODIFY `cytomet_cd23` decimal(5,2) DEFAULT null,	
  MODIFY `cytomet_cd2` decimal(5,2) DEFAULT null,	
  MODIFY `cytomet_cd3` decimal(5,2) DEFAULT null,	
  MODIFY `cytomet_cd4` decimal(5,2) DEFAULT null,	
  MODIFY `cytomet_cd8` decimal(5,2) DEFAULT null,	
  MODIFY `cytomet_lambda` decimal(5,2) DEFAULT null,	
  MODIFY `cytomet_kappa` decimal(5,2) DEFAULT null;
ALTER TABLE `ld_lymph_ed_biopsies_revs`
  MODIFY `cytomet_cd20` decimal(5,2) DEFAULT null,		
  MODIFY `cytomet_cd19` decimal(5,2) DEFAULT null,	
  MODIFY `cytomet_cd10` decimal(5,2) DEFAULT null,	
  MODIFY `cytomet_cd5` decimal(5,2) DEFAULT null,	
  MODIFY `cytomet_cd23` decimal(5,2) DEFAULT null,	
  MODIFY `cytomet_cd2` decimal(5,2) DEFAULT null,	
  MODIFY `cytomet_cd3` decimal(5,2) DEFAULT null,	
  MODIFY `cytomet_cd4` decimal(5,2) DEFAULT null,	
  MODIFY `cytomet_cd8` decimal(5,2) DEFAULT null,	
  MODIFY `cytomet_lambda` decimal(5,2) DEFAULT null,	
  MODIFY `cytomet_kappa` decimal(5,2) DEFAULT null;  
  
UPDATE structure_fields SET type = 'float', setting = 'size=3', structure_value_domain = null
WHERE tablename = 'ld_lymph_ed_biopsies' AND field in ('cytomet_cd20', 'cytomet_cd19', 'cytomet_cd10', 'cytomet_cd5', 'cytomet_cd23', 'cytomet_cd2', 'cytomet_cd3', 'cytomet_cd4', 'cytomet_cd8', 'cytomet_lambda', 'cytomet_kappa');
  
ALTER TABLE `ld_lymph_ed_biopsies`  
  CHANGE `cytomet_other_title` `cytomet_other` varchar(100) DEFAULT '';
ALTER TABLE `ld_lymph_ed_biopsies_revs`  
  CHANGE `cytomet_other_title` `cytomet_other` varchar(100) DEFAULT '';
  
ALTER TABLE `ld_lymph_ed_biopsies` DROP COLUMN cytomet_other_value;
ALTER TABLE `ld_lymph_ed_biopsies_revs` DROP COLUMN cytomet_other_value;
  
DELETE FROM structure_formats WHERE structure_field_id = (SELECT id FROM structure_fields WHERE field = 'cytomet_other_value' AND tablename = 'ld_lymph_ed_biopsies');
DELETE FROM structure_fields WHERE field = 'cytomet_other_value' AND tablename = 'ld_lymph_ed_biopsies';
  	
UPDATE structure_fields SET field = 'cytomet_other' WHERE field = 'cytomet_other_title' AND tablename = 'ld_lymph_ed_biopsies';  
 
UPDATE structure_fields SET type = 'integer_positive', setting = 'size=10' WHERE field = 'participant_identifier';

ALTER TABLE participants MODIFY participant_identifier INT(7) NOT NULL;
ALTER TABLE participants_revs MODIFY participant_identifier INt(7) NOT NULL;

 
 
 
 
 

-- ---------------------------------------------------------
-- DEMO
-- -------------------------------------------------------

INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`) 
VALUES 
('custom cst v1', 'custom cst v1', 'custom cst v1', 1, (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'consent form versions'));

INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`) 
VALUES 
('lymphoma custom 1', 'lymphoma custom 1', 'lymphoma custom 1', 1, (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'lymphoma types'));

INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`) 
VALUES 
('lymphoma prog custom 1', 'lymphoma prog custom 1', 'lymphoma prog custom 1', 1, (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'lymphoma progression sites'));

INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`) 
VALUES 
('lymphoma B symptoms descriptions 1', 'lymphoma B symptoms descriptions 1', 'lymphoma prog custom 1', 1, (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'lymphoma B symptoms descriptions'));


UPDATE users set flag_active=1;
update groups set flag_show_confidential = 1;

















