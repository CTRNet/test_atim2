REPLACE INTO i18n (id, en, fr) VALUES
("ccbr CD10", "CD10", "CD10"),
("ccbr CD45", "CD45", "CD45");

ALTER TABLE ed_ccbr_lab_cbc_bone_marrows
 MODIFY ccbr_wbc_count FLOAT DEFAULT NULL,
 MODIFY ccbr_hemoglobin FLOAT DEFAULT NULL,
 MODIFY ccbr_platelet_count FLOAT DEFAULT NULL,
 MODIFY ccbr_ldh_level FLOAT DEFAULT NULL,
 MODIFY ccbr_abnormal_cell_count CHAR(1) DEFAULT '',
 MODIFY ccbr_neutrophil_count FLOAT DEFAULT NULL,
 MODIFY ccbr_bone_marrow_cellularity FLOAT DEFAULT NULL,
 MODIFY ccbr_percent_blast_cells FLOAT DEFAULT NULL;
ALTER TABLE ed_ccbr_lab_cbc_bone_marrows_revs
 MODIFY ccbr_wbc_count FLOAT DEFAULT NULL,
 MODIFY ccbr_hemoglobin FLOAT DEFAULT NULL,
 MODIFY ccbr_platelet_count FLOAT DEFAULT NULL,
 MODIFY ccbr_ldh_level FLOAT DEFAULT NULL,
 MODIFY ccbr_abnormal_cell_count CHAR(1) DEFAULT '',
 MODIFY ccbr_neutrophil_count FLOAT DEFAULT NULL,
 MODIFY ccbr_bone_marrow_cellularity FLOAT DEFAULT NULL,
 MODIFY ccbr_percent_blast_cells FLOAT DEFAULT NULL;

UPDATE structure_fields SET  `type`='float' WHERE model='EventDetail' AND tablename='ed_ccbr_lab_cbc_bone_marrows' AND field='ccbr_wbc_count' AND `type`='integer' AND structure_value_domain  IS NULL ;
UPDATE structure_fields SET  `type`='float' WHERE model='EventDetail' AND tablename='ed_ccbr_lab_cbc_bone_marrows' AND field='ccbr_platelet_count' AND `type`='integer' AND structure_value_domain  IS NULL ;
UPDATE structure_fields SET  `type`='float' WHERE model='EventDetail' AND tablename='ed_ccbr_lab_cbc_bone_marrows' AND field='ccbr_ldh_level' AND `type`='integer' AND structure_value_domain  IS NULL ;
UPDATE structure_fields SET  `type`='yes_no',  `structure_value_domain`= NULL  WHERE model='EventDetail' AND tablename='ed_ccbr_lab_cbc_bone_marrows' AND field='ccbr_abnormal_cell_count' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='yesno');
UPDATE structure_fields SET  `type`='float' WHERE model='EventDetail' AND tablename='ed_ccbr_lab_cbc_bone_marrows' AND field='ccbr_neutrophil_count' AND `type`='integer' AND structure_value_domain  IS NULL ;
UPDATE structure_fields SET  `type`='float' WHERE model='EventDetail' AND tablename='ed_ccbr_lab_cbc_bone_marrows' AND field='ccbr_bone_marrow_cellularity' AND `type`='integer' AND structure_value_domain  IS NULL ;
UPDATE structure_fields SET  `type`='yes_no',  `structure_value_domain`= NULL  WHERE model='EventDetail' AND tablename='ed_ccbr_lab_cbc_bone_marrows' AND field='ccbr_abnormal_infiltrate_present' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='yesno');
UPDATE structure_fields SET  `type`='float' WHERE model='EventDetail' AND tablename='ed_ccbr_lab_cbc_bone_marrows' AND field='ccbr_percent_blast_cells' AND `type`='integer' AND structure_value_domain  IS NULL ;
UPDATE structure_fields SET  `type`='yes_no',  `structure_value_domain`= NULL  WHERE model='EventDetail' AND tablename='ed_ccbr_lab_cbc_bone_marrows' AND field='ccbr_dysplasia' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='yesno');
UPDATE structure_fields SET  `type`='yes_no',  `structure_value_domain`= NULL  WHERE model='EventDetail' AND tablename='ed_ccbr_lab_cbc_bone_marrows' AND field='ccbr_erythropoiesis' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='yesno');
UPDATE structure_fields SET  `type`='yes_no',  `structure_value_domain`= NULL  WHERE model='EventDetail' AND tablename='ed_ccbr_lab_cbc_bone_marrows' AND field='ccbr_mylopoiesis' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='yesno');
UPDATE structure_fields SET  `type`='yes_no',  `structure_value_domain`= NULL  WHERE model='EventDetail' AND tablename='ed_ccbr_lab_cbc_bone_marrows' AND field='ccbr_megakaryopoiesis' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='yesno');

ALTER TABLE ed_ccbr_lab_immunophenotypes
 ADD COLUMN ccbr_CD10 CHAR(1) NOT NULL DEFAULT '' AFTER ccbr_CD7,
 ADD COLUMN ccbr_CD45 CHAR(1) NOT NULL DEFAULT '' AFTER ccbr_CD41,
 MODIFY ccbr_CD34 CHAR(1) NOT NULL DEFAULT '',
CHANGE `ccbr_HLA-DR` ccbr_HLA_DR CHAR(1) NOT NULL DEFAULT '',
MODIFY ccbr_CD19 CHAR(1) NOT NULL DEFAULT '',
MODIFY ccbr_CD20 CHAR(1) NOT NULL DEFAULT '',
MODIFY ccbr_CD22 CHAR(1) NOT NULL DEFAULT '',
MODIFY ccbr_CD23 CHAR(1) NOT NULL DEFAULT '',
MODIFY ccbr_kappa CHAR(1) NOT NULL DEFAULT '',
MODIFY ccbr_lambda CHAR(1) NOT NULL DEFAULT '',
MODIFY ccbr_CD2 CHAR(1) NOT NULL DEFAULT '',
MODIFY ccbr_CD3 CHAR(1) NOT NULL DEFAULT '',
MODIFY ccbr_CD4 CHAR(1) NOT NULL DEFAULT '',
MODIFY ccbr_CD8 CHAR(1) NOT NULL DEFAULT '',
MODIFY ccbr_CD1 CHAR(1) NOT NULL DEFAULT '',
MODIFY ccbr_CD5 CHAR(1) NOT NULL DEFAULT '',
MODIFY ccbr_CD7 CHAR(1) NOT NULL DEFAULT '',
MODIFY ccbr_CD13 CHAR(1) NOT NULL DEFAULT '',
MODIFY ccbr_CD33 CHAR(1) NOT NULL DEFAULT '',
MODIFY ccbr_CD15 CHAR(1) NOT NULL DEFAULT '',
MODIFY ccbr_CD14 CHAR(1) NOT NULL DEFAULT '',
MODIFY ccbr_CD11c CHAR(1) NOT NULL DEFAULT '',
MODIFY ccbr_CD117 CHAR(1) NOT NULL DEFAULT '',
MODIFY ccbr_CD64 CHAR(1) NOT NULL DEFAULT '',
MODIFY ccbr_CD41 CHAR(1) NOT NULL DEFAULT '',
MODIFY ccbr_CD61 CHAR(1) NOT NULL DEFAULT '',
MODIFY ccbr_cyto_CD79a CHAR(1) NOT NULL DEFAULT '',
MODIFY ccbr_cyto_CD3 CHAR(1) NOT NULL DEFAULT '',
MODIFY ccbr_cyto_MPO CHAR(1) NOT NULL DEFAULT '',
MODIFY ccbr_cyto_mu CHAR(1) NOT NULL DEFAULT '',
MODIFY ccbr_cyto_CD22 CHAR(1) NOT NULL DEFAULT '',
MODIFY ccbr_TdT CHAR(1) NOT NULL DEFAULT '';
ALTER TABLE ed_ccbr_lab_immunophenotypes_revs
 ADD COLUMN ccbr_CD10 CHAR(1) NOT NULL DEFAULT '' AFTER ccbr_CD7,
 ADD COLUMN ccbr_CD45 CHAR(1) NOT NULL DEFAULT '' AFTER ccbr_CD41,
 MODIFY ccbr_CD34 CHAR(1) NOT NULL DEFAULT '',
CHANGE `ccbr_HLA-DR` ccbr_HLA_DR CHAR(1) NOT NULL DEFAULT '',
MODIFY ccbr_CD19 CHAR(1) NOT NULL DEFAULT '',
MODIFY ccbr_CD20 CHAR(1) NOT NULL DEFAULT '',
MODIFY ccbr_CD22 CHAR(1) NOT NULL DEFAULT '',
MODIFY ccbr_CD23 CHAR(1) NOT NULL DEFAULT '',
MODIFY ccbr_kappa CHAR(1) NOT NULL DEFAULT '',
MODIFY ccbr_lambda CHAR(1) NOT NULL DEFAULT '',
MODIFY ccbr_CD2 CHAR(1) NOT NULL DEFAULT '',
MODIFY ccbr_CD3 CHAR(1) NOT NULL DEFAULT '',
MODIFY ccbr_CD4 CHAR(1) NOT NULL DEFAULT '',
MODIFY ccbr_CD8 CHAR(1) NOT NULL DEFAULT '',
MODIFY ccbr_CD1 CHAR(1) NOT NULL DEFAULT '',
MODIFY ccbr_CD5 CHAR(1) NOT NULL DEFAULT '',
MODIFY ccbr_CD7 CHAR(1) NOT NULL DEFAULT '',
MODIFY ccbr_CD13 CHAR(1) NOT NULL DEFAULT '',
MODIFY ccbr_CD33 CHAR(1) NOT NULL DEFAULT '',
MODIFY ccbr_CD15 CHAR(1) NOT NULL DEFAULT '',
MODIFY ccbr_CD14 CHAR(1) NOT NULL DEFAULT '',
MODIFY ccbr_CD11c CHAR(1) NOT NULL DEFAULT '',
MODIFY ccbr_CD117 CHAR(1) NOT NULL DEFAULT '',
MODIFY ccbr_CD64 CHAR(1) NOT NULL DEFAULT '',
MODIFY ccbr_CD41 CHAR(1) NOT NULL DEFAULT '',
MODIFY ccbr_CD61 CHAR(1) NOT NULL DEFAULT '',
MODIFY ccbr_cyto_CD79a CHAR(1) NOT NULL DEFAULT '',
MODIFY ccbr_cyto_CD3 CHAR(1) NOT NULL DEFAULT '',
MODIFY ccbr_cyto_MPO CHAR(1) NOT NULL DEFAULT '',
MODIFY ccbr_cyto_mu CHAR(1) NOT NULL DEFAULT '',
MODIFY ccbr_cyto_CD22 CHAR(1) NOT NULL DEFAULT '',
MODIFY ccbr_TdT CHAR(1) NOT NULL DEFAULT '';
 
UPDATE structure_fields SET field='ccbr_HLA_DR' WHERE field='ccbr_HLA-DR';

INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("yesnopartial", "", "", NULL);
INSERT INTO structure_permissible_values (value, language_alias) VALUES("y", "yes");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="yesnopartial"), (SELECT id FROM structure_permissible_values WHERE value="y" AND language_alias="yes"), "1", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("n", "no");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="yesnopartial"), (SELECT id FROM structure_permissible_values WHERE value="n" AND language_alias="no"), "2", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("p", "partial");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="yesnopartial"), (SELECT id FROM structure_permissible_values WHERE value="p" AND language_alias="partial"), "3", "1");

UPDATE structure_fields SET type='select', structure_value_domain=(SELECT id FROM structure_value_domains WHERE domain_name='yesnopartial') WHERE tablename='ed_ccbr_lab_immunophenotypes' AND type='y_n_u';

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'EventDetail', 'ed_ccbr_lab_immunophenotypes', 'ccbr_CD10', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='yesnopartial') , '0', '', 'n', '', 'ccbr CD10', ''), 
('Clinicalannotation', 'EventDetail', 'ed_ccbr_lab_immunophenotypes', 'ccbr_CD45', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='yesnopartial') , '0', '', 'n', '', 'ccbr CD45', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='ed_ccbr_lab_immunophenotypes'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_ccbr_lab_immunophenotypes' AND `field`='ccbr_CD10' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yesnopartial')  AND `flag_confidential`='0' AND `setting`='' AND `default`='n' AND `language_help`='' AND `language_label`='ccbr CD10' AND `language_tag`=''), '1', '8', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='ed_ccbr_lab_immunophenotypes'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_ccbr_lab_immunophenotypes' AND `field`='ccbr_CD45' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yesnopartial')  AND `flag_confidential`='0' AND `setting`='' AND `default`='n' AND `language_help`='' AND `language_label`='ccbr CD45' AND `language_tag`=''), '2', '8', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');

REPLACE INTO i18n (id, en, fr) VALUES
('partial', 'Partial', 'Partiel');