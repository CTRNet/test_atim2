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

UPDATE users set flag_active=1 where id = 1;
update groups set flag_show_confidential = 1;


REPLACE INTO i18n (id,en) VALUES
('cytomet cd20', 'CD20 (%)'),
('cytomet cd5', 'CD5 (%)'),
('cytomet cd23', 'CD23 (%)'),
('cytomet cd2', 'CD2 (%)'),
('cytomet cd3', 'CD3 (%)'),
('cytomet cd4', 'CD4 (%)'),
('cytomet cd8', 'CD8 (%)'),
('cytomet lambda', '&#955; (%)'),
('cytomet kappa', '&#954; (%)'),
('cytomet cd10', 'CD10 (%)'),
('cytomet cd19', 'CD19 (%)');

INSERT INTO `versions` (version_number, date_installed, build_number) VALUES
('2.4.2', NOW(), '4022');

UPDATE structure_formats SET `display_order`='16' WHERE structure_id=(SELECT id FROM structures WHERE alias='ld_lymph_ed_imagings') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_imagings' AND `field`='initial_pet_suv_max' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

ALTER TABLE `ld_lymph_ed_imagings` MODIFY `initial_pet_suv_max` decimal(7,2) DEFAULT null;
ALTER TABLE `ld_lymph_ed_imagings_revs` MODIFY `initial_pet_suv_max` decimal(7,2) DEFAULT null;

INSERT IGNORE INTO i18n (id,en) VALUES
('axillary' , 'Axillary'),
('cervical' , 'Cervical'),
('inguinal' , 'Inguinal'),
('mediastinal' , 'Mediastinal'),
('mesenteric' , 'Mesenteric'),
('other nodes' , 'Other Nodes'),
('para aortic' , 'Para Aortic'),
('spleen nodes' , 'Spleen'),
('waldeyers ring' , 'Waldeyer''s Ring'),

('pe imag lymph node axillary' , 'Axillary'),
('pe imag lymph node ceuac' , 'Ceuac'),
('pe imag lymph node common illiac' , 'Common Illiac'),
('pe imag lymph node epitrochlear' , 'Epitrochlear'),
('pe imag lymph node external illiac' , 'External Illiac'),
('pe imag lymph node femoral' , 'Femoral'),
('pe imag lymph node hilar' , 'Hilar'),
('pe imag lymph node infraclavicular' , 'Infraclavicular'),
('pe imag lymph node inguinal' , 'Inguinal'),
('pe imag lymph node median lower cervical' , 'Median Lower Cervical'),
('pe imag lymph node mediastinal' , 'Mediastinal'),
('pe imag lymph node mesenteric' , 'Mesenteric'),
('pe imag lymph node para aortic' , 'Para Aortic'),
('pe imag lymph node paratracheal' , 'Paratracheal'),
('pe imag lymph node popliteral' , 'Popliteral'),
('pe imag lymph node portal' , 'Portal'),
('pe imag lymph node posterior cervical' , 'Posterior Cervical'),
('pe imag lymph node pre auricular' , 'Pre Auricular'),
('pe imag lymph node retrocrural' , 'Retrocrural'),
('pe imag lymph node spleen' , 'Spleen'),
('pe imag lymph node splenic hepatic hilar' , 'Splenic Hepatic hilar'),
('pe imag lymph node supraclavicular' , 'Supraclavicular'),
('pe imag lymph node upper cervical' , 'Upper Cervical'),
('pe imag lymph node waldeyers ring' , 'Waldeyer''s Ring');

UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='ld_lymph_ed_imagings') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_imagings' AND `field`='imaging_type_other' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='ld_lymph_ed_imagings') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_imagings' AND `field`='initial_pet_suv_max' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_fields SET language_label='' WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_imagings' AND `field`='pe_imag_lymph_node_supraclavicular_right';
UPDATE structure_formats SET `language_heading`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='ld_lymph_ed_imagings') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_imagings' AND `field`='pe_imag_lymph_node_paratracheal_right' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='mediastinal' WHERE structure_id=(SELECT id FROM structures WHERE alias='ld_lymph_ed_imagings') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_imagings' AND `field`='pe_imag_lymph_node_paratracheal_left' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

ALTER TABLE ld_lymph_ed_reasearch_studies
  ADD COLUMN prinicpal_investigator VARCHAR (50) DEFAULT NULL AFTER name;
ALTER TABLE ld_lymph_ed_reasearch_studies_revs
  ADD COLUMN prinicpal_investigator VARCHAR (50) DEFAULT NULL AFTER name;  

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_reasearch_studies', 'prinicpal_investigator', 'input',  NULL , '0', 'size=30', '', '', 'prinicpal investigator', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_reasearch_studies'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_reasearch_studies' AND `field`='prinicpal_investigator' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='' AND `language_label`='prinicpal investigator' AND `language_tag`=''), '1', '51', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0');

INSERT INTO i18n (id,en) VALUEs ('prinicpal investigator','Prinicpal Investigator');

-- -----------------------------------------------------------------------

ALTER TABLE ld_lymph_ed_imagings
  ADD COLUMN pe_imag_lymph_node_other char(1) DEFAULT '' AFTER pe_imag_lymph_node_popliteral,
  ADD COLUMN pe_imag_lymph_node_other_precision VARCHAR (250) DEFAULT NULL AFTER pe_imag_lymph_node_other;
ALTER TABLE ld_lymph_ed_imagings_revs
  ADD COLUMN pe_imag_lymph_node_other char(1) DEFAULT '' AFTER pe_imag_lymph_node_popliteral,
  ADD COLUMN pe_imag_lymph_node_other_precision VARCHAR (250) DEFAULT NULL AFTER pe_imag_lymph_node_other;  
  
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_imagings', 'pe_imag_lymph_node_other', 'yes_no',  NULL , '0', '', '', '', 'other', ''), 
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_imagings', 'pe_imag_lymph_node_other_precision', 'input',  NULL , '0', 'size=30', '', '', '', 'other precision');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_imagings'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_imagings' AND `field`='pe_imag_lymph_node_other' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='other' AND `language_tag`=''), '3', '88', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_imagings'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_imagings' AND `field`='pe_imag_lymph_node_other_precision' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='other precision'), '3', '89', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0');

ALTER TABLE `ld_lymph_ed_imagings`
  CHANGE `nodules_nbr` `nodal_sites_nbr` int(4) DEFAULT null;
ALTER TABLE `ld_lymph_ed_imagings_revs`
  CHANGE `nodules_nbr` `nodal_sites_nbr` int(4) DEFAULT null;  
UPDATE structure_fields SET field =  'nodal_sites_nbr', language_label = 'nodal sites nbr' WHERE field = 'nodules_nbr' AND tablename = 'ld_lymph_ed_imagings';
INSERT INTO i18n (id,en) VALUEs ('nodal sites nbr','Nodal Sites Nbr');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='ld_lymph_ed_imagings') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_imagings' AND `field`='nodal_sites_nbr' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');


-- 2012-04-17
INSERT INTO storage_controls (storage_type, coord_x_title, coord_x_type, coord_x_size, coord_y_title, coord_y_type, coord_y_size, display_x_size, display_y_size, reverse_x_numbering, reverse_y_numbering, horizontal_increment, set_temperature, is_tma_block, flag_active, form_alias, detail_tablename, databrowser_label, check_conflicts) VALUES
('box21 1A-3I', 'position', 'integer', 3, NULL, 'alphabetical', 9, 3, 9, 0, 0, 0, 0, 0, 1, 'storagemasters', 'std_boxs', 'box21 1A-3I', 1); 

REPLACE INTO i18n (id, en, fr) VALUES
("box21 1A-3I", "Box21 1A-3I", "Boîte21 1A-3I");

-- -----------------------------------------------------------------------------------------------------------------
-- 2012-05-07
-- -----------------------------------------------------------------------------------------------------------------

-- Age At Dx

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='dx_primary'),(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='age_at_dx'), '1', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1'),
((SELECT id FROM structures WHERE alias='dx_secondary'),(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='age_at_dx'), '1', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1');

-- Add finish date to observation

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='ld_lymph_txd_observations'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='finish_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_finish_date' AND `language_label`='finish date' AND `language_tag`=''), '1', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');

-- Biopsy site

ALTER TABLE `ld_lymph_ed_biopsies` MODIFY `site` varchar(150) DEFAULT '';
ALTER TABLE `ld_lymph_ed_biopsies_revs` MODIFY `site` varchar(150) DEFAULT '';

INSERT INTO `structure_value_domains` (`id`, `domain_name`, `override`, `category`, `source`) VALUES (NULL, 'custom_biopsy_site_list', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(''biopsy sites'')');
UPDATE structure_fields SET  `type`='select',  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='custom_biopsy_site_list') ,  `setting`='' WHERE model='EventDetail' AND tablename='ld_lymph_ed_biopsies' AND field='site' AND `type`='input' AND structure_value_domain  IS NULL ;
INSERT INTO structure_permissible_values_custom_controls (name,flag_active,values_max_length)
VALUES ('biopsy sites', '1', '150');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`) 
VALUES 
('lymph node', 'Lymph node', 'Ganglion lymphatique', 1, (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'biopsy sites')),
('spleen', 'Spleen', 'Rate', 1, (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'biopsy sites')),
('bone marrow', 'Bone marrow', 'Moelle osseuse', 1, (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'biopsy sites')),
('blood', 'Blood', 'Sang', 1, (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'biopsy sites')),
('extra nodal', 'Extra nodal', '', 1, (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'biopsy sites'));

-- lymphoma B symptoms descriptions

INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`) 
VALUES 
('fever', 'Fever', 'Fièvre', 1, (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'lymphoma B symptoms descriptions')),
('night sweating', 'Night sweating', 'Transpiration nocturne', 1, (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'lymphoma B symptoms descriptions')),
('weight loss', 'Weight loss', 'Perte de poids', 1, (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'lymphoma B symptoms descriptions'));

-- Surgery

INSERT INTO `treatment_controls` (`tx_method`, `disease_site`, `flag_active`, `detail_tablename`, `form_alias`, `extend_tablename`, `extend_form_alias`, `display_order`, `applied_protocol_control_id`, `extended_data_import_process`, `databrowser_label`) VALUES
('surgery', 'ld lymph.', 0, 'txd_surgeries', 'treatmentmasters,ld_lymph_txd_surgeries', 'txe_surgeries', 'txe_surgeries', 0, 2, NULL, 'ld lymph.|surgery');
INSERT INTO structures(`alias`) VALUES ('ld_lymph_txd_surgeries');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='ld_lymph_txd_surgeries'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='notes' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='rows=3,cols=30' AND `default`='' AND `language_help`='help_notes' AND `language_label`='notes' AND `language_tag`=''), '1', '99', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');
UPDATE treatment_controls SET flag_active = 1 WHERE tx_method = 'surgery' AND disease_site = 'ld lymph.';

-- Biopsy MUM1

REPLACE INTO i18n (id,en) VALUES ('immuno mum1','MUM1');

-- Molecular lab : MB/ML number.

ALTER TABLE `ld_lymph_ed_biopsies` MODIFY `molecular_mdl_number` varchar(50) DEFAULT '';
ALTER TABLE `ld_lymph_ed_biopsies` MODIFY `molecular_mb_number` varchar(50) DEFAULT '';
ALTER TABLE `ld_lymph_ed_biopsies_revs` MODIFY `molecular_mdl_number` varchar(50) DEFAULT '';
ALTER TABLE `ld_lymph_ed_biopsies_revs` MODIFY `molecular_mb_number` varchar(50) DEFAULT '';

UPDATE structure_fields SET type = 'input', setting = 'size=20' WHERE field IN ('molecular_mb_number','molecular_mdl_number');
UPDATE structure_fields SET tablename = 'ld_lymph_ed_biopsies' WHERE tablename = 'ld_lymph_ed_patho_summary';

-- Obersvation: progression date

ALTER TABLE ld_lymph_txd_observations
	ADD COLUMN `progression_date` date DEFAULT NULL AFTER `treatment_master_id`,
	ADD COLUMN `progression_date_accuracy` char(1) NOT NULL DEFAULT '' AFTER `progression_date` ; 
ALTER TABLE ld_lymph_txd_observations_revs
	ADD COLUMN `progression_date` date DEFAULT NULL AFTER `treatment_master_id`,
	ADD COLUMN `progression_date_accuracy` char(1) NOT NULL DEFAULT '' AFTER `progression_date` ;

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'TreatmentDetail', 'ld_lymph_txd_observations', 'progression_date', 'date',  NULL , '0', '', '', '', 'progression_date', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='ld_lymph_txd_observations'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='ld_lymph_txd_observations' AND `field`='progression_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='progression_date' AND `language_tag`=''), '1', '51', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0');
UPDATE structure_fields SET language_label = 'progression date' WHERE field = 'progression_date' AND tablename = 'ld_lymph_txd_observations';
UPDATE structure_formats SET `display_column`='2', `display_order`='21', `language_heading`='observation data' WHERE structure_id=(SELECT id FROM structures WHERE alias='ld_lymph_txd_observations') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='ld_lymph_txd_observations' AND `field`='progression_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

INSERT INTO i18n (id,en) VALUES ('progression date','Progression Date'),('observation data','Observation Data');

-- vital status at follow-up

ALTER TABLE `participants` MODIFY `vital_status` varchar(250) DEFAULT NULL;
ALTER TABLE `participants_revs` MODIFY `vital_status` varchar(250) DEFAULT NULL;

UPDATE participants SET vital_status = '';
UPDATE participants_revs SET vital_status = '';

UPDATE structure_value_domains SET source = 'StructurePermissibleValuesCustom::getCustomDropdown(''vital status at follow-up'')'   WHERE domain_name = 'ld_lymph_status_at_last_followup';
INSERT INTO structure_permissible_values_custom_controls (name,flag_active,values_max_length)
VALUES ('vital status at follow-up', '1', '250');

INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `display_order`) 
VALUES 
('0- no neoplasm documented, being observed.' ,'0- No neoplasm documented, being observed.', '', 1, (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'vital status at follow-up'), 1),
('1- free of disease after initial treatment.' ,'1- Free of disease after initial treatment.', '', 1, (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'vital status at follow-up'), 2),
('2- receiving initial treatment.' ,'2- Receiving initial treatment.', '', 1, (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'vital status at follow-up'), 3),
('3- with disease, after initial treatment.' ,'3- With disease, after initial treatment.', '', 1, (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'vital status at follow-up'), 4),
('4- free of disease after treatment for first relapse.' ,'4- Free of disease after treatment for first relapse.', '', 1, (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'vital status at follow-up'), 5),
('5- receiving treatment for first relapse.' ,'5- Receiving treatment for first relapse.', '', 1, (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'vital status at follow-up'), 6),
('6- with disease, after treatment of first relapse.' ,'6- With disease, after treatment of first relapse.', '', 1, (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'vital status at follow-up'), 7),
('7- free of disease, after of second relapse.' ,'7- Free of disease, after of second relapse.', '', 1, (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'vital status at follow-up'), 8),
('8- receiving treatment for second (or greater) relapse.' ,'8- Receiving treatment for second (or greater) relapse.', '', 1, (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'vital status at follow-up'), 9),
('9- with disease after treatment of second relapse.' ,'9- With disease after treatment of second relapse.', '', 1, (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'vital status at follow-up'), 10),
('66- lost to follow-up.' ,'66- Lost to follow-up.', '', 1, (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'vital status at follow-up'), 11),
('88- due to primary diagnosis.' ,'88- Due to primary diagnosis.', '', 1, (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'vital status at follow-up'), 12),
('T.- due to toxicity of primary treatment ( no additional qualifiers required).' ,'T.- Due to toxicity of primary treatment ( no additional qualifiers required).', '', 1, (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'vital status at follow-up'), 13),
('D.- unrelated to primary diagnosis or toxicity ( no additional qualifiers required). ' ,'D.- Unrelated to primary diagnosis or toxicity ( no additional qualifiers required). ', '', 1, (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'vital status at follow-up'), 14);

-- -----------------------------------------------------------------------------------------------------------------
-- 2012-05-10
-- -----------------------------------------------------------------------------------------------------------------

ALTER TABLE ld_lymph_dx_lymphomas DROP COLUMN baseline_b_desc;
ALTER TABLE ld_lymph_dx_lymphomas_revs DROP COLUMN baseline_b_desc;

ALTER TABLE ld_lymph_dx_lymphomas
	ADD COLUMN `baseline_b_symp_fever` char(1) DEFAULT '' AFTER baseline_b_symptoms,
	ADD COLUMN `baseline_b_symp_night_sweating` char(1) DEFAULT '' AFTER `baseline_b_symp_fever`,
	ADD COLUMN `baseline_b_symp_weight_loss` char(1) DEFAULT '' AFTER `baseline_b_symp_night_sweating`;
ALTER TABLE ld_lymph_dx_lymphomas_revs
	ADD COLUMN `baseline_b_symp_fever` char(1) DEFAULT '' AFTER baseline_b_symptoms,
	ADD COLUMN `baseline_b_symp_night_sweating` char(1) DEFAULT '' AFTER `baseline_b_symp_fever`,
	ADD COLUMN `baseline_b_symp_weight_loss` char(1) DEFAULT '' AFTER `baseline_b_symp_night_sweating`;

DELETE FROM structure_permissible_values_customs WHERE control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'lymphoma B symptoms descriptions');
DELETE FROM structure_permissible_values_custom_controls WHERE name LIKE 'lymphoma B symptoms descriptions';
DELETE FROM structure_formats WHERE structure_field_id = (SELECT id FROM structure_fields WHERE field = 'baseline_b_desc' AND tablename = 'ld_lymph_dx_lymphomas');
DELETE FROM structure_fields WHERE field = 'baseline_b_desc' AND tablename = 'ld_lymph_dx_lymphomas';
DELETE FROM structure_value_domains WHERE domain_name LIKE 'custom_baseline_b_desc_list';

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'DiagnosisDetail', 'ld_lymph_dx_lymphomas', 'baseline_b_symp_fever', 'yes_no',  NULL , '0', '', '', '', 'b symptoms : fever', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'ld_lymph_dx_lymphomas', 'baseline_b_symp_night_sweating', 'yes_no',  NULL , '0', '', '', '', 'b symptoms : night sweating', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'ld_lymph_dx_lymphomas', 'baseline_b_symp_weight_loss', 'yes_no',  NULL , '0', '', '', '', 'b symptoms : weight loss', ''); 

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='ld_lymph_dx_lymphomas'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='ld_lymph_dx_lymphomas' AND `field`='baseline_b_symp_fever'), '1', '32', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_dx_lymphomas'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='ld_lymph_dx_lymphomas' AND `field`='baseline_b_symp_night_sweating'), '1', '32', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_dx_lymphomas'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='ld_lymph_dx_lymphomas' AND `field`='baseline_b_symp_weight_loss'), '1', '32', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0');

INSERT INTO i18n (id,en) VALUES 
('b symptoms : fever', 'B Sympt. : Fever'), 
('b symptoms : night sweating', 'B Sympt. : Night Sweating'), 
('b symptoms : weight loss', 'B Sympt. : Weight loss');


-- 2012-05-16
INSERT INTO storage_controls (storage_type, coord_x_title, coord_x_type, coord_x_size, coord_y_title, coord_y_type, coord_y_size, display_x_size, display_y_size, reverse_x_numbering, reverse_y_numbering, horizontal_increment, set_temperature, is_tma_block, flag_active, form_alias, detail_tablename, databrowser_label, check_conflicts) VALUES
('box169 1A-13M', 'position', 'integer', 13, NULL, 'alphabetical', 13, 13, 13, 0, 0, 0, 0, 0, 1, 'storagemasters', 'std_boxs', 'box169 1A-13M', 1); 

REPLACE INTO i18n (id, en, fr) VALUES
("box169 1A-13M", "Box169 1A-13M", "Boîte169 1A-13M");



