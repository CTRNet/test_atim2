ALTER TABLE participants
 ADD COLUMN qc_nd_last_contact DATE DEFAULT NULL;
ALTER TABLE participants_revs
 ADD COLUMN qc_nd_last_contact DATE DEFAULT NULL;
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'Participant', 'participants', 'qc_nd_last_contact', 'date',  NULL , '0', '', '', '', 'last contact date', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='qc_nd_last_contact' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='last contact date' AND `language_tag`=''), '3', '7', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '0', '1', '0', '0', '1', '0');

ALTER TABLE diagnosis_masters
 ADD COLUMN qc_nd_sardo_id INT NOT NULL DEFAULT 0 AFTER participant_id,
 ADD COLUMN qc_nd_sardo_morpho_code VARCHAR(10) NOT NULL DEFAULT '' AFTER qc_nd_sardo_id,
 ADD COLUMN qc_nd_sardo_family_history VARCHAR(50) NOT NULL DEFAULT '' AFTER qc_nd_sardo_morpho_code;
ALTER TABLE diagnosis_masters_revs
 ADD COLUMN qc_nd_sardo_id INT NOT NULL DEFAULT 0 AFTER participant_id,
 ADD COLUMN qc_nd_sardo_morpho_code VARCHAR(10) NOT NULL DEFAULT '' AFTER qc_nd_sardo_id,
 ADD COLUMN qc_nd_sardo_family_history VARCHAR(50) NOT NULL DEFAULT '' AFTER qc_nd_sardo_morpho_code;
 
UPDATE menus SET flag_active=1 WHERE id IN('clin_CAN_5', 'clin_CAN_5_1');

INSERT INTO diagnosis_controls (category, controls_type, flag_active, form_alias, detail_tablename, display_order, databrowser_label, flag_compare_with_cap) VALUES
('primary', 'sardo', 1, 'diagnosismasters,dx_primary_sardo', 'qc_nd_dxd_primary_sardo', 0, 'primary|sardo', 0);
	
CREATE TABLE qc_nd_dxd_primary_sardo(
 id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
 diagnosis_master_id INT NOT NULL,
 laterality VARCHAR(50) NOT NULL DEFAULT '',
 tnm_g VARCHAR(50) NOT NULL DEFAULT '',
 figo VARCHAR(50) NOT NULL DEFAULT '',
 deleted TINYINT UNSIGNED NOT NULL DEFAULT 0,
 FOREIGN KEY (diagnosis_master_id) REFERENCES diagnosis_masters(id)
)Engine=InnoDb;
CREATE TABLE qc_nd_dxd_primary_sardo_revs(
 id INT UNSIGNED NOT NULL,
 diagnosis_master_id INT NOT NULL,
 laterality VARCHAR(50) NOT NULL,
 deleted TINYINT UNSIGNED NOT NULL DEFAULT 0,
 `version_id` int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
 `version_created` datetime NOT NULL 
)Engine=InnoDb;

DELETE FROM structure_formats WHERE structure_field_id=332 AND structure_id!=88;

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='derivatives'), (SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='initial_specimen_sample_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='specimen_sample_type')  AND `flag_confidential`='0'), '0', '100', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '1', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1');

UPDATE menus SET use_link='/clinicalannotation/participants/search/' WHERE id='clin_CAN_1';

UPDATE structure_formats SET `flag_override_help`='0', `language_help`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='sex' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='sex') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_edit`='0', `flag_edit_readonly`='0', `flag_search`='0', `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='participant_identifier' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_override_help`='0', `language_help`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='race' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='race') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='0', `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='participant_identifier' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE misc_identifiers SET identifier_value=CONCAT('H', identifier_value) WHERE misc_identifier_control_id=8 AND LEFT(identifier_value, 1)!='H';
UPDATE misc_identifiers SET identifier_value=CONCAT('N', identifier_value) WHERE misc_identifier_control_id=9 AND LEFT(identifier_value, 1)!='N';
UPDATE misc_identifiers SET identifier_value=CONCAT('S', identifier_value) WHERE misc_identifier_control_id=10 AND LEFT(identifier_value, 1)!='S';

UPDATE menus SET use_link='/study/study_summaries/search/' WHERE id='tool_CAN_100';

UPDATE structure_fields SET  `language_label`='start' WHERE model='StudySummary' AND tablename='study_summaries' AND field='start_date' AND `type`='date' AND structure_value_domain  IS NULL ;
UPDATE structure_fields SET  `language_label`='end',  `language_tag`='' WHERE model='StudySummary' AND tablename='study_summaries' AND field='end_date' AND `type`='date' AND structure_value_domain  IS NULL ;
UPDATE structure_formats SET `display_order`='8' WHERE structure_id=(SELECT id FROM structures WHERE alias='studysummaries') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='end_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Study', 'StudySummary', 'study_summaries', 'qc_nd_researcher', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_staff') , '0', '', '', '', 'researcher', ''), 
('Study', 'StudySummary', 'study_summaries', 'qc_nd_contact', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_staff') , '0', '', '', '', 'contact', ''), 
('Study', 'StudySummary', 'study_summaries', 'qc_nd_code', 'input', NULL, '0', '', '', '', 'code', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='studysummaries'), (SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='qc_nd_researcher' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_staff')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='researcher' AND `language_tag`=''), '1', '9', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='studysummaries'), (SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='qc_nd_contact' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_staff')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='contact' AND `language_tag`=''), '1', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='studysummaries'), (SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='qc_nd_code' AND `type`='input' AND `structure_value_domain` IS NULL AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='code' AND `language_tag`=''), '1', '11', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1');

ALTER TABLE study_summaries
 ADD COLUMN qc_nd_researcher VARCHAR(50) NOT NULL DEFAULT '' AFTER additional_clinical,
 ADD COLUMN qc_nd_contact VARCHAR(50) NOT NULL DEFAULT '' AFTER qc_nd_researcher,
 ADD COLUMN qc_nd_code VARCHAR(50) NOT NULL DEFAULT '' AFTER qc_nd_contact;
ALTER TABLE study_summaries_revs
 ADD COLUMN qc_nd_researcher VARCHAR(50) NOT NULL DEFAULT '' AFTER additional_clinical,
 ADD COLUMN qc_nd_contact VARCHAR(50) NOT NULL DEFAULT '' AFTER qc_nd_researcher,
 ADD COLUMN qc_nd_code VARCHAR(50) NOT NULL DEFAULT '' AFTER qc_nd_contact;

INSERT INTO structure_validations (structure_field_id, rule, on_action, language_message) VALUES
((SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='qc_nd_code' AND `type`='input' AND `structure_value_domain` IS NULL AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='code' AND `language_tag`=''), 'isUnique', '', ''),
((SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='qc_nd_code' AND `type`='input' AND `structure_value_domain` IS NULL AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='code' AND `language_tag`=''), 'custom,/^[0-9]{4}-[0-9]{3}$/', '', 'the code format must be {year}-{###}');


INSERT INTO event_controls (disease_site, event_group, event_type, flag_active, form_alias, detail_tablename, display_order, databrowser_label) VALUES
('all', 'clinical', 'biopsy', 1, 'eventmasters', 'qc_nd_ed_biopsy', 0, 'clinical|all|biopsy'),
('all', 'clinical', 'cytology', 1, 'eventmasters', 'qc_nd_ed_cytology', 0, 'clinical|all|cytology'),
('all', 'lab', 'ca125', 1, 'eventmasters', 'qc_nd_ed_ca125', 0, 'lab|all|ca125'),
('all', 'lab', 'pathology', 1, 'eventmasters', 'qc_nd_ed_pathologies', 0, 'lab|all|pathology');

CREATE TABLE qc_nd_ed_biopsy(
 id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
 event_master_id INT NOT NULL,
 type VARCHAR(50) NOT NULL DEFAULT '',
 deleted BOOLEAN NOT NULL DEFAULT 0,
 FOREIGN KEY (event_master_id) REFERENCES event_masters(id)
)Engine=InnoDb;
CREATE TABLE qc_nd_ed_biopsy_revs(
 id INT UNSIGNED NOT NULL,
 event_master_id INT NOT NULL,
 type VARCHAR(50) NOT NULL DEFAULT '',
 deleted BOOLEAN NOT NULL DEFAULT 0,
 `version_id` int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
 `version_created` datetime NOT NULL
)Engine=InnoDb;

CREATE TABLE qc_nd_ed_cytology(
 id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
 event_master_id INT NOT NULL,
 type VARCHAR(50) NOT NULL DEFAULT '',
 deleted BOOLEAN NOT NULL DEFAULT 0,
 FOREIGN KEY (event_master_id) REFERENCES event_masters(id)
);
CREATE TABLE qc_nd_ed_cytology_revs(
 id INT UNSIGNED NOT NULL,
 event_master_id INT NOT NULL,
 type VARCHAR(50) NOT NULL DEFAULT '',
 deleted BOOLEAN NOT NULL DEFAULT 0,
 `version_id` int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
 `version_created` datetime NOT NULL
);

CREATE TABLE qc_nd_ed_ca125(
 id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
 event_master_id INT NOT NULL,
 type VARCHAR(50) NOT NULL DEFAULT '',
 deleted BOOLEAN NOT NULL DEFAULT 0,
 FOREIGN KEY (event_master_id) REFERENCES event_masters(id)
);
CREATE TABLE qc_nd_ed_ca125_revs(
 id INT UNSIGNED NOT NULL,
 event_master_id INT NOT NULL,
 type VARCHAR(50) NOT NULL DEFAULT '',
 deleted BOOLEAN NOT NULL DEFAULT 0,
 `version_id` int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
 `version_created` datetime NOT NULL
);

CREATE TABLE qc_nd_ed_pathologies(
 id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
 event_master_id INT NOT NULL,
 atteinte_multicentrique VARCHAR(100) NOT NULL DEFAULT '',
 atteinte_multifocale VARCHAR(100) NOT NULL DEFAULT '',
 ganglions_regionaux VARCHAR(100) NOT NULL DEFAULT '',
 ganglions_regionaux_prop VARCHAR(100) NOT NULL DEFAULT '',
 ganglions_regionaux_sent VARCHAR(100) NOT NULL DEFAULT '',
 grade_nottingham VARCHAR(100) NOT NULL DEFAULT '',
 grade_histologique_sur_3 VARCHAR(100) NOT NULL DEFAULT '',
 grade_nucleaire VARCHAR(100) NOT NULL DEFAULT '',
 her2neu VARCHAR(100) NOT NULL DEFAULT '',
 her2neu_fish VARCHAR(100) NOT NULL DEFAULT '',
 her2neu_herceptest VARCHAR(100) NOT NULL DEFAULT '',
 her2neu_tab_250 VARCHAR(100) NOT NULL DEFAULT '',
 index_miotique VARCHAR(100) NOT NULL DEFAULT '',
 marges_resection VARCHAR(100) NOT NULL DEFAULT '',
 recepteur_oestrogene VARCHAR(100) NOT NULL DEFAULT '',
 recepteur_progestatifs VARCHAR(100) NOT NULL DEFAULT '',
 recepteur_hormonaux VARCHAR(100) NOT NULL DEFAULT '',
 taille_tumeur_mm VARCHAR(100) NOT NULL DEFAULT '',
 taile_tummeur_mm_num VARCHAR(100) NOT NULL DEFAULT '',
 deleted BOOLEAN NOT NULL DEFAULT 0,
 FOREIGN KEY (event_master_id) REFERENCES event_masters(id)
)Engine=InnoDb;
CREATE TABLE qc_nd_ed_pathologies_revs(
 id INT UNSIGNED NOT NULL,
 event_master_id INT NOT NULL,
 atteinte_multicentrique VARCHAR(100) NOT NULL DEFAULT '',
 atteinte_multifocale VARCHAR(100) NOT NULL DEFAULT '',
 ganglions_regionaux VARCHAR(100) NOT NULL DEFAULT '',
 ganglions_regionaux_prop VARCHAR(100) NOT NULL DEFAULT '',
 ganglions_regionaux_sent VARCHAR(100) NOT NULL DEFAULT '',
 grade_nottingham VARCHAR(100) NOT NULL DEFAULT '',
 grade_histologique_sur_3 VARCHAR(100) NOT NULL DEFAULT '',
 grade_nucleaire VARCHAR(100) NOT NULL DEFAULT '',
 her2neu VARCHAR(100) NOT NULL DEFAULT '',
 her2neu_fish VARCHAR(100) NOT NULL DEFAULT '',
 her2neu_herceptest VARCHAR(100) NOT NULL DEFAULT '',
 her2neu_tab_250 VARCHAR(100) NOT NULL DEFAULT '',
 index_miotique VARCHAR(100) NOT NULL DEFAULT '',
 marges_resection VARCHAR(100) NOT NULL DEFAULT '',
 recepteur_oestrogene VARCHAR(100) NOT NULL DEFAULT '',
 recepteur_progestatifs VARCHAR(100) NOT NULL DEFAULT '',
 recepteur_hormonaux VARCHAR(100) NOT NULL DEFAULT '',
 taille_tumeur_mm VARCHAR(100) NOT NULL DEFAULT '',
 taile_tummeur_mm_num VARCHAR(100) NOT NULL DEFAULT '',
 deleted BOOLEAN NOT NULL DEFAULT 0,
 `version_id` int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
 `version_created` datetime NOT NULL
)Engine=InnoDb;


DELETE FROM treatment_controls;
DELETE FROM protocol_controls;
INSERT INTO `protocol_controls` (`id`, `tumour_group`, `type`, `detail_tablename`, `form_alias`, `extend_tablename`, `extend_form_alias`, `created`, `created_by`, `modified`, `modified_by`, `flag_active`) VALUES
(1, 'all', 'chemotherapy', 'pd_chemos', 'pd_chemos', 'pe_chemos', 'pe_chemos', NULL, 0, NULL, 0, 1),
(2, 'all', 'surgery', 'pd_surgeries', 'pd_surgeries', NULL, NULL, NULL, 0, NULL, 0, 1);

INSERT INTO `treatment_controls` (`id`, `tx_method`, `disease_site`, `flag_active`, `detail_tablename`, `form_alias`, `extend_tablename`, `extend_form_alias`, `display_order`, `applied_protocol_control_id`, `extended_data_import_process`, `databrowser_label`) VALUES
(1, 'chemotherapy', 'all', 1, 'txd_chemos', 'treatmentmasters,txd_chemos', 'txe_chemos', 'txe_chemos', 0, 1, 'importDrugFromChemoProtocol', 'all|chemotherapy'),
(2, 'radiation', 'all', 1, 'txd_radiations', 'treatmentmasters,txd_radiations', NULL, NULL, 0, NULL, NULL, 'all|radiation'),
(3, 'surgery', 'all', 1, 'txd_surgeries', 'treatmentmasters,txd_surgeries', 'txe_surgeries', 'txe_surgeries', 0, 2, NULL, 'all|surgery'),
(4, 'surgery without extension', 'all', 1, 'txd_surgeries', 'treatmentmasters,txd_surgeries', NULL, NULL, 0, 2, NULL, 'all|surgery without extension');

ALTER TABLE shipments
 MODIFY recipient VARCHAR(60) NOT NULL DEFAULT '';
ALTER TABLE shipments_revs
 MODIFY recipient VARCHAR(60) NOT NULL DEFAULT '';

UPDATE ad_tubes SET tmp_storage_solution='DMSO + Serum' WHERE tmp_storage_solution='DMSO + FBS'; 
UPDATE ad_tubes_revs SET tmp_storage_solution='DMSO + Serum' WHERE tmp_storage_solution='DMSO + FBS';

DELETE FROM structure_value_domains_permissible_values WHERE structure_permissible_value_id=1050; 
DELETE FROM structure_permissible_values WHERE id=1050;

ALTER TABLE txd_surgeries
 ADD COLUMN qc_nd_precision VARCHAR(200) NOT NULL DEFAULT '' AFTER treatment_master_id,
 ADD COLUMN qc_nd_residual_disease VARCHAR(200) NOT NULL DEFAULT '' AFTER qc_nd_precision; 
ALTER TABLE txd_surgeries_revs
 ADD COLUMN qc_nd_precision VARCHAR(200) NOT NULL DEFAULT '' AFTER treatment_master_id,
 ADD COLUMN qc_nd_residual_disease VARCHAR(200) NOT NULL DEFAULT '' AFTER qc_nd_precision;

ALTER TABLE txd_chemos
 ADD COLUMN qc_nd_type VARCHAR(200) NOT NULL DEFAULT '' AFTER treatment_master_id,
 ADD COLUMN qc_nd_is_neoadjuvant CHAR(1) NOT NULL DEFAULT '' AFTER qc_nd_type,
 ADD COLUMN qc_nd_pre_chir CHAR(1) NOT NULL DEFAULT '' AFTER qc_nd_is_neoadjuvant;
ALTER TABLE txd_chemos_revs
 ADD COLUMN qc_nd_type VARCHAR(200) NOT NULL DEFAULT '' AFTER treatment_master_id,
 ADD COLUMN qc_nd_is_neoadjuvant CHAR(1) NOT NULL DEFAULT '' AFTER qc_nd_type,
 ADD COLUMN qc_nd_pre_chir CHAR(1) NOT NULL DEFAULT '' AFTER qc_nd_is_neoadjuvant;
 
ALTER TABLE txd_radiations
 ADD COLUMN qc_nd_is_neoadjuvant CHAR(1) NOT NULL DEFAULT '' AFTER rad_completed,
 ADD COLUMN qc_nd_type VARCHAR(100) NOT NULL DEFAULT '' AFTER qc_nd_is_neoadjuvant; 
ALTER TABLE txd_radiations_revs
 ADD COLUMN qc_nd_is_neoadjuvant CHAR(1) NOT NULL DEFAULT '' AFTER rad_completed,
 ADD COLUMN qc_nd_type VARCHAR(100) NOT NULL DEFAULT '' AFTER qc_nd_is_neoadjuvant; 

UPDATE menus SET flag_active=true WHERE id IN('clin_CAN_28');

ALTER TABLE dxd_progressions
 ADD COLUMN qc_nd_sites VARCHAR(200) NOT NULL DEFAULT '' AFTER diagnosis_master_id;
ALTER TABLE dxd_progressions_revs
 ADD COLUMN qc_nd_sites VARCHAR(200) NOT NULL DEFAULT '' AFTER diagnosis_master_id;

ALTER TABLE reproductive_histories
 ADD COLUMN qc_nd_year_menopause SMALLINT UNSIGNED DEFAULT NULL AFTER participant_id;
ALTER TABLE reproductive_histories_revs
 ADD COLUMN qc_nd_year_menopause SMALLINT UNSIGNED DEFAULT NULL AFTER participant_id;
 
INSERT INTO `treatment_controls` (`tx_method`, `disease_site`, `flag_active`, `detail_tablename`, `form_alias`, `extend_tablename`, `extend_form_alias`, `display_order`, `applied_protocol_control_id`, `extended_data_import_process`, `databrowser_label`) VALUES
('hormonotherapy', 'all', 1, 'qc_nd_txd_hormonotherapies', 'treatmentmasters,qc_nd_txd_hormonotherapies', NULL, NULL, 0, NULL, NULL, 'all|hormonotherapy');

CREATE TABLE qc_nd_txd_hormonotherapies(
 id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
 treatment_master_id INT NOT NULL,
 type VARCHAR(50) NOT NULL DEFAULT '',
 is_neoadjuvant CHAR(1) NOT NULL DEFAULT '',
 deleted BOOLEAN NOT NULL DEFAULT FALSE,
 FOREIGN KEY (treatment_master_id) REFERENCES treatment_masters(id)
)Engine=InnoDb;
CREATE TABLE qc_nd_txd_hormonotherapies_revs(
 id INT UNSIGNED NOT NULL,
 treatment_master_id INT NOT NULL,
 type VARCHAR(50) NOT NULL DEFAULT '',
 is_neoadjuvant CHAR(1) NOT NULL DEFAULT '',
 deleted BOOLEAN NOT NULL DEFAULT FALSE,
 `version_id` int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
 `version_created` datetime NOT NULL
)Engine=InnoDb;

# TO CALCULATE AGE
# SELECT name, birth, CURDATE(),
#    -> (YEAR(CURDATE())-YEAR(birth))
#    -> - (RIGHT(CURDATE(),5)<RIGHT(birth,5))
#    -> AS age
#    -> FROM pet;
