-- -----------------------------------------------------------------------------------------------------------------------------------
-- UPDATE & ADD CORRECTIONS FOR SEARCH ON SPENT TIMES (collection to storage spent time, etc)
-- -----------------------------------------------------------------------------------------------------------------------------------

UPDATE structure_formats 
SET flag_override_label = '1', `language_label`='collection to storage spent time (min)'
WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_spec_tiss_blocks') 
AND structure_field_id=(SELECT id FROM structure_fields WHERE `field`='coll_to_stor_spent_time_msg')
AND flag_search = '1';

UPDATE structure_formats 
SET flag_override_label = '1', `language_label`='collection to storage spent time (min)'
WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_spec_tubes_incl_ml_vol') 
AND structure_field_id=(SELECT id FROM structure_fields WHERE `field`='coll_to_stor_spent_time_msg')
AND flag_search = '1';

DELETE FROM structure_formats 
WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_der_tubes_incl_ml_vol') 
AND structure_field_id=(SELECT id FROM structure_fields WHERE `field`='creat_to_stor_spent_time_msg')
AND `language_label`='collection to storage spent time (min)';

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ad_der_tubes_incl_ml_vol'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='coll_to_stor_spent_time_msg' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '59', '', '1', 'collection to storage spent time (min)', '0', '', '0', '', '1', 'integer_positive', '1', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');

DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_der_tubes_qc_lady_dnas') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='InventoryManagement' AND `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='initial_specimen_sample_type' AND `language_label`='initial specimen type' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='specimen_sample_type') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_der_tubes_qc_lady_dnas') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='InventoryManagement' AND `model`='SampleMaster' AND `tablename`='' AND `field`='parent_sample_type' AND `language_label`='parent sample type' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='sample_type') AND `language_help`='generated_parent_sample_sample_type_help' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_der_tubes_qc_lady_dnas') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='coll_to_stor_spent_time_msg' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_der_tubes_qc_lady_dnas') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='creat_to_stor_spent_time_msg' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ad_der_tubes_qc_lady_dnas'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='coll_to_stor_spent_time_msg' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '59', '', '1', 'collection to storage spent time (min)', '0', '', '0', '', '1', 'integer_positive', '1', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='ad_der_tubes_qc_lady_dnas'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='creat_to_stor_spent_time_msg' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '60', '', '1', 'creation to storage spent time (min)', '0', '', '0', '', '1', 'integer_positive', '1', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');

DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_der_cel_gel_matrices') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='InventoryManagement' AND `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='initial_specimen_sample_type' AND `language_label`='initial specimen type' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='specimen_sample_type') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_der_cel_gel_matrices') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='InventoryManagement' AND `model`='SampleMaster' AND `tablename`='' AND `field`='parent_sample_type' AND `language_label`='parent sample type' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='sample_type') AND `language_help`='generated_parent_sample_sample_type_help' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_lady_sd_der_dnas') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='InventoryManagement' AND `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='initial_specimen_sample_type' AND `language_label`='initial specimen type' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='specimen_sample_type') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_lady_sd_der_dnas') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='InventoryManagement' AND `model`='SampleMaster' AND `tablename`='' AND `field`='parent_sample_type' AND `language_label`='parent sample type' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='sample_type') AND `language_help`='generated_parent_sample_sample_type_help' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');

-- ------------------------------------------------------------------------------------------
-- QC change
-- ------------------------------------------------------------------------------------------

ALTER TABLE quality_ctrls
	ADD COLUMN qc_lady_rin_score varchar(30) DEFAULT null,
	ADD COLUMN qc_lady_260_230_score varchar(30) DEFAULT null,
	ADD COLUMN qc_lady_260_280_score varchar(30) DEFAULT null;
ALTER TABLE quality_ctrls_revs
	ADD COLUMN qc_lady_rin_score varchar(30) DEFAULT null,
	ADD COLUMN qc_lady_260_230_score varchar(30) DEFAULT null,
	ADD COLUMN qc_lady_260_280_score varchar(30) DEFAULT null;	
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'QualityCtrl', 'quality_ctrls', 'qc_lady_rin_score', 'input',  NULL , '0', 'size=5', '', '', 'RIN', ''), 
('InventoryManagement', 'QualityCtrl', 'quality_ctrls', 'qc_lady_260_230_score', 'input',  NULL , '0', 'size=5', '', '', '260/230', ''), 
('InventoryManagement', 'QualityCtrl', 'quality_ctrls', 'qc_lady_260_280_score', 'input',  NULL , '0', 'size=5', '', '', '260/280', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qualityctrls'), (SELECT id FROM structure_fields WHERE `model`='QualityCtrl' AND `tablename`='quality_ctrls' AND `field`='qc_lady_rin_score' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='RIN' AND `language_tag`=''), '0', '17', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='qualityctrls'), (SELECT id FROM structure_fields WHERE `model`='QualityCtrl' AND `tablename`='quality_ctrls' AND `field`='qc_lady_260_230_score' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='260/230' AND `language_tag`=''), '0', '18', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='qualityctrls'), (SELECT id FROM structure_fields WHERE `model`='QualityCtrl' AND `tablename`='quality_ctrls' AND `field`='qc_lady_260_280_score' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='260/280' AND `language_tag`=''), '0', '19', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '1', '0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='qualityctrls') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='QualityCtrl' AND `tablename`='quality_ctrls' AND `field`='score' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='qualityctrls') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='QualityCtrl' AND `tablename`='quality_ctrls' AND `field`='unit' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='quality_control_unit') AND `flag_confidential`='0');

ALTER TABLE quality_ctrls
	ADD COLUMN qc_lady_rin_ccl varchar(30) DEFAULT null,
	ADD COLUMN qc_lady_260_230_ccl varchar(30) DEFAULT null,
	ADD COLUMN qc_lady_260_280_ccl varchar(30) DEFAULT null;
ALTER TABLE quality_ctrls_revs
	ADD COLUMN qc_lady_rin_ccl varchar(30) DEFAULT null,
	ADD COLUMN qc_lady_260_230_ccl varchar(30) DEFAULT null,
	ADD COLUMN qc_lady_260_280_ccl varchar(30) DEFAULT null;	
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'QualityCtrl', 'quality_ctrls', 'qc_lady_rin_ccl', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='quality_control_conclusion') , '0', '', '', '', '', 'qc test ccl'), 
('InventoryManagement', 'QualityCtrl', 'quality_ctrls', 'qc_lady_260_230_ccl', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='quality_control_conclusion') , '0', '', '', '', '', 'qc test ccl'), 
('InventoryManagement', 'QualityCtrl', 'quality_ctrls', 'qc_lady_260_280_ccl', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='quality_control_conclusion') , '0', '', '', '', '', 'qc test ccl');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qualityctrls'), (SELECT id FROM structure_fields WHERE `model`='QualityCtrl' AND `tablename`='quality_ctrls' AND `field`='qc_lady_rin_ccl' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='quality_control_conclusion')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='qc test ccl'), '0', '17', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qualityctrls'), (SELECT id FROM structure_fields WHERE `model`='QualityCtrl' AND `tablename`='quality_ctrls' AND `field`='qc_lady_260_230_ccl' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='quality_control_conclusion')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='qc test ccl'), '0', '18', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qualityctrls'), (SELECT id FROM structure_fields WHERE `model`='QualityCtrl' AND `tablename`='quality_ctrls' AND `field`='qc_lady_260_280_ccl' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='quality_control_conclusion')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='qc test ccl'), '0', '19', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO i18n (id,en,fr) VALUES ('qc test ccl','Ccl','Ccl');

-- ------------------------------------------------------------------------------------------
-- Consents
-- ------------------------------------------------------------------------------------------

UPDATE consent_masters SET form_version = '05 Nov 2010' WHERE form_version = '05 nov 2010';
UPDATE consent_masters SET form_version = '05 Nov 2010' WHERE form_version = '05Nov2010';
UPDATE consent_masters SET form_version = '05 Nov 2010' WHERE form_version = '05nov10';
UPDATE consent_masters SET form_version = '05 Nov 2010' WHERE form_version = '05Nov10';
UPDATE consent_masters_revs SET form_version = '05 Nov 2010' WHERE form_version = '05 nov 2010';
UPDATE consent_masters_revs SET form_version = '05 Nov 2010' WHERE form_version = '05Nov2010';
UPDATE consent_masters_revs SET form_version = '05 Nov 2010' WHERE form_version = '05nov10';
UPDATE consent_masters_revs SET form_version = '05 Nov 2010' WHERE form_version = '05Nov10';

-- ------------------------------------------------------------------------------------------
-- Path Review
-- ------------------------------------------------------------------------------------------

CREATE TABLE qc_lady_ar_qcrocs (
  aliquot_review_master_id int(11) NOT NULL,
  tumor_percentage decimal(5,1) DEFAULT NULL,
  normal_percentage decimal(5,1) DEFAULT NULL,
  necrosis_percentage_itz decimal(5,1) DEFAULT NULL,
  cellularity_percentage_itz decimal(5,1) DEFAULT NULL,
  stroma_percentage_itz decimal(5,1) DEFAULT NULL,
  inflammatory_cells_level_itz varchar(10) DEFAULT NULL,
  quality_control varchar(10) DEFAULT NULL,
  notes varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE qc_lady_ar_qcrocs_revs (
  aliquot_review_master_id int(11) NOT NULL,
  tumor_percentage decimal(5,1) DEFAULT NULL,
  normal_percentage decimal(5,1) DEFAULT NULL,
  necrosis_percentage_itz decimal(5,1) DEFAULT NULL,
  cellularity_percentage_itz decimal(5,1) DEFAULT NULL,
  stroma_percentage_itz decimal(5,1) DEFAULT NULL,
  inflammatory_cells_level_itz varchar(10) DEFAULT NULL,
  quality_control varchar(10) DEFAULT NULL,
  notes varchar(255) DEFAULT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;
ALTER TABLE `qc_lady_ar_qcrocs`
  ADD CONSTRAINT FK_qc_lady_ar_qcrocs_aliquot_review_masters FOREIGN KEY (aliquot_review_master_id) REFERENCES aliquot_review_masters (id);
CREATE TABLE qc_lady_spr_qcrocs (
  specimen_review_master_id int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE qc_lady_spr_qcrocs_revs (
  specimen_review_master_id int(11) NOT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;
ALTER TABLE `qc_lady_spr_qcrocs`
  ADD CONSTRAINT FK_qc_lady_spr_qcrocs_specimen_review_masters FOREIGN KEY (specimen_review_master_id) REFERENCES specimen_review_masters (id);

UPDATE structure_formats SET `flag_search`='0', `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='specimen_review_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SpecimenReviewMaster' AND `tablename`='specimen_review_masters' AND `field`='review_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='0', `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='specimen_review_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SpecimenReviewMaster' AND `tablename`='specimen_review_masters' AND `field`='review_status' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='specimen_review_status') AND `flag_confidential`='0');

UPDATE aliquot_review_controls SET flag_active = 0;
INSERT INTO `aliquot_review_controls` (`id`, `review_type`, `flag_active`, `detail_form_alias`, `detail_tablename`, `aliquot_type_restriction`) VALUES
(null, 'qcroc', 1, 'qc_lady_ar_qcrocs', 'qc_lady_ar_qcrocs', 'block');
UPDATE specimen_review_controls SET flag_active = 0;
INSERT INTO `specimen_review_controls` (`id`, `sample_control_id`, `aliquot_review_control_id`, `review_type`, `flag_active`, `detail_form_alias`, `detail_tablename`, `databrowser_label`) VALUES
(null, 3, (SELECT id FROM aliquot_review_controls WHERE review_type = 'qcroc'), 'Q-CROC-03', 1, 'qc_lady_spr_qcrocs', 'qc_lady_spr_qcrocs', 'tissue|Q-CROC-03');

INSERT INTO structures(`alias`) VALUES ('qc_lady_spr_qcrocs');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_lady_spr_qcrocs'), (SELECT id FROM structure_fields WHERE `model`='SpecimenReviewControl' AND `tablename`='specimen_review_controls' AND `field`='sample_control_id' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='specimen_type_for_review')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='specimen review type' AND `language_tag`=''), '0', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_lady_spr_qcrocs'), (SELECT id FROM structure_fields WHERE `model`='SpecimenReviewControl' AND `tablename`='specimen_review_controls' AND `field`='review_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='specimen_review_type')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='-'), '0', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_lady_spr_qcrocs'), (SELECT id FROM structure_fields WHERE `model`='SpecimenReviewMaster' AND `tablename`='specimen_review_masters' AND `field`='review_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='review date' AND `language_tag`=''), '0', '7', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_lady_spr_qcrocs'), (SELECT id FROM structure_fields WHERE `model`='SpecimenReviewMaster' AND `tablename`='specimen_review_masters' AND `field`='pathologist' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='' AND `language_label`='pathologist' AND `language_tag`=''), '0', '9', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_lady_spr_qcrocs'), (SELECT id FROM structure_fields WHERE `model`='SpecimenReviewMaster' AND `tablename`='specimen_review_masters' AND `field`='notes' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='rows=3,cols=30' AND `default`='' AND `language_help`='' AND `language_label`='notes' AND `language_tag`=''), '0', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');

INSERT INTO structures(`alias`) VALUES ('qc_lady_ar_qcrocs');
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("qc_lady_inflammatory_cells_level", "", "", NULL);
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="qc_lady_inflammatory_cells_level"), (SELECT id FROM structure_permissible_values WHERE value="0" AND language_alias="0"), "0", "1");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="qc_lady_inflammatory_cells_level"), (SELECT id FROM structure_permissible_values WHERE value="1" AND language_alias="1"), "1", "1");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="qc_lady_inflammatory_cells_level"), (SELECT id FROM structure_permissible_values WHERE value="2" AND language_alias="2"), "2", "1");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="qc_lady_inflammatory_cells_level"), (SELECT id FROM structure_permissible_values WHERE value="3" AND language_alias="3"), "3", "1");
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("qc_lady_review_qc", "", "", NULL);
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="qc_lady_review_qc"), (SELECT id FROM structure_permissible_values WHERE value="1" AND language_alias="1"), "1", "1");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="qc_lady_review_qc"), (SELECT id FROM structure_permissible_values WHERE value="2" AND language_alias="2"), "2", "1");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="qc_lady_review_qc"), (SELECT id FROM structure_permissible_values WHERE value="3" AND language_alias="3"), "3", "1");
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'AliquotReviewDetail', 'qc_lady_ar_qcrocs', 'tumor_percentage', 'float',  NULL , '0', 'size=5', '', '', 'tumor percentage', ''), 
('InventoryManagement', 'AliquotReviewDetail', 'qc_lady_ar_qcrocs', 'normal_percentage', 'float',  NULL , '0', 'size=5', '', '', 'normal percentage', ''), 
('InventoryManagement', 'AliquotReviewDetail', 'qc_lady_ar_qcrocs', 'necrosis_percentage_itz', 'float',  NULL , '0', 'size=5', '', '', 'necrosis percentage', ''), 
('InventoryManagement', 'AliquotReviewDetail', 'qc_lady_ar_qcrocs', 'cellularity_percentage_itz', 'float',  NULL , '0', 'size=5', '', '', 'cellularity percentage', ''), 
('InventoryManagement', 'AliquotReviewDetail', 'qc_lady_ar_qcrocs', 'stroma_percentage_itz', 'float',  NULL , '0', 'size=5', '', '', 'stroma percentage', ''), 
('InventoryManagement', 'AliquotReviewDetail', 'qc_lady_ar_qcrocs', 'inflammatory_cells_level_itz', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_lady_inflammatory_cells_level') , '0', '', '', '', 'inflammatory cells level', ''), 
('InventoryManagement', 'AliquotReviewDetail', 'qc_lady_ar_qcrocs', 'quality_control', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_lady_review_qc') , '0', '', '', '', 'qc', ''), 
('InventoryManagement', 'AliquotReviewDetail', 'qc_lady_ar_qcrocs', 'notes', 'input',  NULL , '0', 'size=30', '', '', 'comments', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_lady_ar_qcrocs'), (SELECT id FROM structure_fields WHERE `model`='AliquotReviewMaster' AND `tablename`='aliquot_review_masters' AND `field`='aliquot_master_id' AND `type`='select' AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='reviewed aliquot' AND `language_tag`=''), '0', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_lady_ar_qcrocs'), (SELECT id FROM structure_fields WHERE `model`='AliquotReviewMaster' AND `tablename`='aliquot_review_masters' AND `field`='id' AND `type`='hidden' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='aliquot_review_master_id' AND `language_tag`=''), '0', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_lady_ar_qcrocs'), (SELECT id FROM structure_fields WHERE `model`='AliquotReviewDetail' AND `tablename`='qc_lady_ar_qcrocs' AND `field`='tumor_percentage' AND `type`='float' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='tumor percentage' AND `language_tag`=''), '0', '7', 'inside the whole sample', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_lady_ar_qcrocs'), (SELECT id FROM structure_fields WHERE `model`='AliquotReviewDetail' AND `tablename`='qc_lady_ar_qcrocs' AND `field`='normal_percentage' AND `type`='float' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='normal percentage' AND `language_tag`=''), '0', '8', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_lady_ar_qcrocs'), (SELECT id FROM structure_fields WHERE `model`='AliquotReviewDetail' AND `tablename`='qc_lady_ar_qcrocs' AND `field`='necrosis_percentage_itz' AND `type`='float' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='necrosis percentage' AND `language_tag`=''), '0', '10', 'inside the tumor zone', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_lady_ar_qcrocs'), (SELECT id FROM structure_fields WHERE `model`='AliquotReviewDetail' AND `tablename`='qc_lady_ar_qcrocs' AND `field`='cellularity_percentage_itz' AND `type`='float' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='cellularity percentage' AND `language_tag`=''), '0', '11', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_lady_ar_qcrocs'), (SELECT id FROM structure_fields WHERE `model`='AliquotReviewDetail' AND `tablename`='qc_lady_ar_qcrocs' AND `field`='stroma_percentage_itz' AND `type`='float' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='stroma percentage' AND `language_tag`=''), '0', '12', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_lady_ar_qcrocs'), (SELECT id FROM structure_fields WHERE `model`='AliquotReviewDetail' AND `tablename`='qc_lady_ar_qcrocs' AND `field`='inflammatory_cells_level_itz' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_lady_inflammatory_cells_level')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='inflammatory cells level' AND `language_tag`=''), '0', '13', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_lady_ar_qcrocs'), (SELECT id FROM structure_fields WHERE `model`='AliquotReviewDetail' AND `tablename`='qc_lady_ar_qcrocs' AND `field`='quality_control' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_lady_review_qc')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='qc' AND `language_tag`=''), '0', '14', 'other', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_lady_ar_qcrocs'), (SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='CopyCtrl' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='copy control' AND `language_tag`=''), '0', '100', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '1', '1', '1', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_lady_ar_qcrocs'), (SELECT id FROM structure_fields WHERE `model`='AliquotReviewDetail' AND `tablename`='qc_lady_ar_qcrocs' AND `field`='notes' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='' AND `language_label`='comments' AND `language_tag`=''), '0', '15', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '0', '1', '0');
INSERT INTO structure_validations(structure_field_id, rule) VALUES
((SELECT id FROM structure_fields WHERE `model`='AliquotReviewMaster' AND `tablename`='aliquot_review_masters' AND `field`='aliquot_master_id' AND `type`='select' AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='reviewed aliquot' AND `language_tag`=''), 'notEmpty');

REPLACE INTO i18n (id,en,fr) 
VALUES 
('normal percentage','Normal &#37;', '&#37; Normal'),   	
('stroma percentage','Stroma &#37;', '&#37; Stroma');
INSERT  INTO i18n (id,en,fr) 
VALUES 
('inside the whole sample','Inside the whole sample','Dans tout l''échantillon'),	
('inside the tumor zone','Inside the tumor zone','Dans la zone tumorale'),	
('qc','QC','QC'),	
('comments','Comments','Commentaires'),	
('tumor percentage','Tumor &#37;','&#37; Tumeur'),	     	
('necrosis percentage','Necrosis &#37;','&#37; Nécrose'),	     	
('cellularity percentage','Cellularity &#37;','&#37; Cellularité'),	  
('inflammatory cells level','Inflammatory Cells Level','Niveau Cellules Inflammatoires');

-- ------------------------------------------------------------------------------------------
-- Reports
-- ------------------------------------------------------------------------------------------

UPDATE datamart_reports SET flag_active = '0' WHERE id = 5;
INSERT INTO i18n (id,en,fr) VALUES 
('Breast bank #','Breast bank #','Banque Sein #'),
('JGH #','JGH #','JGH #'),
('Q-CROC-03','Q-CROC-03','Q-CROC-03'),
('RAMQ','RAMQ','RAMQ'),
('Sardo #','Sardo #','Sardo #');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Datamart', '0', '', 'q_croc_03_identifier_value', 'input',  NULL , '0', 'size=10', '', '', 'Q-CROC-03', ''), 
('Datamart', '0', '', 'breast_bank_identifier_value', 'input',  NULL , '0', 'size=10', '', '', 'Breast bank #', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='report_date_range_definition'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='q_croc_03_identifier_value'), '0', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='report_date_range_definition'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='breast_bank_identifier_value' ), '0', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');
INSERT IGNORE INTO i18n (id,en,fr) VALUEs ('obtained consents','Obtained consents','Consentements obtenus');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='report_datetime_range_definition'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='q_croc_03_identifier_value'), '0', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='report_datetime_range_definition'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='breast_bank_identifier_value' ), '0', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ctrnet_calatogue_submission_file_params'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='q_croc_03_identifier_value'), '0', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='ctrnet_calatogue_submission_file_params'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='breast_bank_identifier_value' ), '0', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');
UPDATE structure_formats SET `display_order`='10' WHERE structure_id=(SELECT id FROM structures WHERE alias='ctrnet_calatogue_submission_file_params') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='q_croc_03_identifier_value' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='11' WHERE structure_id=(SELECT id FROM structures WHERE alias='ctrnet_calatogue_submission_file_params') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='breast_bank_identifier_value' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
