-- NEVER RAN YET!!
REPLACE INTO i18n(id, en, fr) VALUES
('last contact date', 'Last contact date', 'Date du dernier contact');

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
('primary', 'sardo', 1, 'diagnosismasters,qc_nd_dx_primary_sardo', 'qc_nd_dxd_primary_sardo', 0, 'primary|sardo', 0);
	
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

INSERT INTO event_controls (disease_site, event_group, event_type, flag_active, form_alias, detail_tablename, display_order, databrowser_label) VALUES
('all', 'clinical', 'biopsy', 1, 'eventmasters,qc_nd_ed_biopsy', 'qc_nd_ed_biopsy', 0, 'clinical|all|biopsy'),
('all', 'clinical', 'cytology', 1, 'eventmasters', 'qc_nd_ed_cytology', 0, 'clinical|all|cytology'),
('all', 'lab', 'ca125', 1, 'eventmasters,qc_nd_ed_ca125', 'qc_nd_ed_ca125', 0, 'lab|all|ca125'),
('all', 'lab', 'pathology', 1, 'eventmasters', 'qc_nd_ed_pathologies', 0, 'lab|all|pathology');

CREATE TABLE qc_nd_ed_biopsy(
 id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
 event_master_id INT NOT NULL,
 type VARCHAR(50) NOT NULL DEFAULT '',
 no_patho VARCHAR(20) NOT NULL DEFAULT '',
 location VARCHAR(50) NOT NULL DEFAULT '',
 deleted BOOLEAN NOT NULL DEFAULT 0,
 FOREIGN KEY (event_master_id) REFERENCES event_masters(id)
)Engine=InnoDb;
CREATE TABLE qc_nd_ed_biopsy_revs(
 id INT UNSIGNED NOT NULL,
 event_master_id INT NOT NULL,
 type VARCHAR(50) NOT NULL DEFAULT '',
 no_patho VARCHAR(20) NOT NULL DEFAULT '',
 location VARCHAR(50) NOT NULL DEFAULT '',
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
 value MEDIUMINT DEFAULT NULL,
 deleted BOOLEAN NOT NULL DEFAULT 0,
 FOREIGN KEY (event_master_id) REFERENCES event_masters(id)
);
CREATE TABLE qc_nd_ed_ca125_revs(
 id INT UNSIGNED NOT NULL,
 event_master_id INT NOT NULL,
 value MEDIUMINT DEFAULT NULL,
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
 ADD COLUMN qc_nd_residual_disease VARCHAR(200) NOT NULL DEFAULT '' AFTER qc_nd_precision,
 ADD COLUMN qc_nd_no_patho VARCHAR(20) NOT NULL DEFAULT '' AFTER qc_nd_residual_disease,
 ADD COLUMN qc_nd_location VARCHAR(50) NOT NULL DEFAULT '' AFTER qc_nd_no_patho; 
ALTER TABLE txd_surgeries_revs
 ADD COLUMN qc_nd_precision VARCHAR(200) NOT NULL DEFAULT '' AFTER treatment_master_id,
 ADD COLUMN qc_nd_residual_disease VARCHAR(200) NOT NULL DEFAULT '' AFTER qc_nd_precision,
 ADD COLUMN qc_nd_no_patho VARCHAR(20) NOT NULL DEFAULT '' AFTER qc_nd_residual_disease,
 ADD COLUMN qc_nd_location VARCHAR(50) NOT NULL DEFAULT '' AFTER qc_nd_no_patho;

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
 ADD COLUMN qc_nd_year_menopause SMALLINT UNSIGNED DEFAULT NULL AFTER participant_id,
 ADD COLUMN qc_nd_cause VARCHAR(50) NOT NULL DEFAULT '' AFTER qc_nd_year_menopause,
 ADD COLUMN qc_nd_gravida_para_aborta VARCHAR(20) NOT NULL DEFAULT '' AFTER qc_nd_cause;
ALTER TABLE reproductive_histories_revs
 ADD COLUMN qc_nd_year_menopause SMALLINT UNSIGNED DEFAULT NULL AFTER participant_id,
 ADD COLUMN qc_nd_cause VARCHAR(50) NOT NULL DEFAULT '' AFTER qc_nd_year_menopause,
 ADD COLUMN qc_nd_gravida_para_aborta VARCHAR(20) NOT NULL DEFAULT '' AFTER qc_nd_cause;
 
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

INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('qc_nd_menopause_cause', '', '', NULL);
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("by medication", "by medication");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="qc_nd_menopause_cause"),  (SELECT id FROM structure_permissible_values WHERE value="by medication" AND language_alias="by medication"), "1", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("by surgery", "by surgery");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="qc_nd_menopause_cause"),  (SELECT id FROM structure_permissible_values WHERE value="by surgery" AND language_alias="by surgery"), "1", "1");

INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('qc_nd_sardo_morpho_code', '', '', NULL);
INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('qc_nd_sardo_family_history', '', '', NULL);

INSERT INTO structures(`alias`) VALUES ('qc_nd_dx_primary_sardo');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'DiagnosisMaster', 'diagnosis_masters', 'qc_nd_sardo_family_history', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_family_history') , '0', '', '', '', 'family history', ''), 
('Clinicalannotation', 'DiagnosisMaster', 'diagnosis_masters', 'qc_nd_sardo_morpho_code', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_morpho_code') , '0', '', '', '', 'morpho code', ''), 
('Clinicalannotation', 'DiagnosisMaster', 'diagnosis_masters', 'qc_nd_sardo_id', 'integer',  NULL , '0', '', '', '', '#', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='qc_nd_dx_primary_sardo'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='qc_nd_sardo_family_history' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_family_history')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='family history' AND `language_tag`=''), '3', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_dx_primary_sardo'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='qc_nd_sardo_morpho_code' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_morpho_code')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='morpho code' AND `language_tag`=''), '3', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_dx_primary_sardo'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='qc_nd_sardo_id' AND `type`='integer' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='#' AND `language_tag`=''), '3', '1', 'SARDO data', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'),
((SELECT id FROM structures WHERE alias='qc_nd_dx_primary_sardo'), 	815	, 2,	2	, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'),
((SELECT id FROM structures WHERE alias='qc_nd_dx_primary_sardo'), 	1122	, 2,	3	, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'),
((SELECT id FROM structures WHERE alias='qc_nd_dx_primary_sardo'), 	833	, 2,	4	, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'),
((SELECT id FROM structures WHERE alias='qc_nd_dx_primary_sardo'), 	834	, 2,	5	, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'),
((SELECT id FROM structures WHERE alias='qc_nd_dx_primary_sardo'), 	835	, 2,	6	, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'),
((SELECT id FROM structures WHERE alias='qc_nd_dx_primary_sardo'), 	836	, 2,	7	, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'),
((SELECT id FROM structures WHERE alias='qc_nd_dx_primary_sardo'), 	837	, 2,	8	, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'),
((SELECT id FROM structures WHERE alias='qc_nd_dx_primary_sardo'), 	829	, 2,	9	, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'),
((SELECT id FROM structures WHERE alias='qc_nd_dx_primary_sardo'), 	1129	, 2,	10	, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'),
((SELECT id FROM structures WHERE alias='qc_nd_dx_primary_sardo'), 	1140	, 2,	11	, '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');

INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('qc_nd_biopsy_type', '', '', NULL);
INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('qc_nd_sardo_location', '', '', NULL);

INSERT INTO structures(`alias`) VALUES ('qc_nd_ed_biopsy');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'EventDetail', 'qc_nd_ed_biopsy', 'type', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_biopsy_type') , '0', '', '', '', 'type', ''), 
('Clinicalannotation', 'EventDetail', 'qc_nd_ed_biopsy', 'no_patho', 'input',  NULL , '0', '', '', '', 'no patho', ''), 
('Clinicalannotation', 'EventDetail', 'qc_nd_ed_biopsy', 'location', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_location') , '0', '', '', '', 'location', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='qc_nd_ed_biopsy'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_nd_ed_biopsy' AND `field`='type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_biopsy_type')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='type' AND `language_tag`=''), '1', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_ed_biopsy'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_nd_ed_biopsy' AND `field`='no_patho' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='no patho' AND `language_tag`=''), '1', '6', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_ed_biopsy'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_nd_ed_biopsy' AND `field`='location' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_location')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='location' AND `language_tag`=''), '1', '7', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');

INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('qc_nd_surgery_precision', '', '', NULL);
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'TreatmentDetail', 'txd_surgeries', 'qc_nd_precision', 'input', (SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_surgery_precision') , '0', '', '', '', 'qc nd precision', ''), 
('Clinicalannotation', 'TreatmentDetail', 'txd_surgeries', 'qc_nd_residual_disease', 'input',  NULL , '0', '', '', '', 'qc nd residual disease', ''), 
('Clinicalannotation', 'TreatmentDetail', 'txd_surgeries', 'qc_nd_no_patho', 'input',  NULL , '0', '', '', '', 'qc nd no patho', ''), 
('Clinicalannotation', 'TreatmentDetail', 'txd_surgeries', 'qc_nd_location', 'input', (SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_location') , '0', '', '', '', 'qc nd location', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='txd_surgeries'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_surgeries' AND `field`='qc_nd_precision' AND `type`='input' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_surgery_precision')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='qc nd precision' AND `language_tag`=''), '1', '12', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='txd_surgeries'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_surgeries' AND `field`='qc_nd_residual_disease' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='qc nd residual disease' AND `language_tag`=''), '1', '13', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='txd_surgeries'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_surgeries' AND `field`='qc_nd_no_patho' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='qc nd no patho' AND `language_tag`=''), '1', '14', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='txd_surgeries'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_surgeries' AND `field`='qc_nd_location' AND `type`='input' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_location')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='qc nd location' AND `language_tag`=''), '1', '15', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');

INSERT INTO structures(`alias`) VALUES ('qc_nd_ed_ca125');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'EventDetail', 'qc_nd_ed_ca125', 'value', 'integer',  NULL , '0', '', '', '', 'value', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='qc_nd_ed_ca125'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_nd_ed_ca125' AND `field`='value' AND `type`='integer' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='value' AND `language_tag`=''), '1', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');

UPDATE menus SET flag_active=true WHERE id IN('clin_CAN_75', 'clin_CAN_79');
UPDATE menus SET flag_active=true WHERE id IN('clin_CAN_31');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'TreatmentDetail', 'txd_chemos', 'qc_nd_type', 'input',  NULL , '0', '', '', '', 'type', ''), 
('Clinicalannotation', 'TreatmentDetail', 'txd_chemos', 'qc_nd_is_neoadjuvant', 'yes_no',  NULL , '0', '', '', '', 'is neoadjuvant', ''), 
('Clinicalannotation', 'TreatmentDetail', 'txd_chemos', 'qc_nd_pre_chir', 'yes_no',  NULL , '0', '', '', '', 'pre surgery', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='txd_chemos'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_chemos' AND `field`='qc_nd_type' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='type' AND `language_tag`=''), '2', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='txd_chemos'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_chemos' AND `field`='qc_nd_is_neoadjuvant' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='is neoadjuvant' AND `language_tag`=''), '2', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='txd_chemos'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_chemos' AND `field`='qc_nd_pre_chir' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='pre surgery' AND `language_tag`=''), '2', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'DiagnosisDetail', 'qc_nd_dxd_primary_sardo', 'laterality', 'input',  NULL , '0', '', '', '', 'laterality', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='qc_nd_dx_primary_sardo'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_nd_dxd_primary_sardo' AND `field`='laterality' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='laterality' AND `language_tag`=''), '2', '12', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');

DROP VIEW view_aliquots;
CREATE VIEW `view_aliquots` AS select `al`.`id` AS `aliquot_master_id`,`al`.`sample_master_id` AS `sample_master_id`,
`al`.`collection_id` AS `collection_id`,`col`.`bank_id` AS `bank_id`,`al`.`storage_master_id` AS `storage_master_id`,
`link`.`participant_id` AS `participant_id`,`link`.`diagnosis_master_id` AS `diagnosis_master_id`,`link`.`consent_master_id` AS `consent_master_id`,
`part`.`participant_identifier` AS `participant_identifier`,`mic`.`misc_identifier_name` AS `identifier_name`,
`ident`.`identifier_value` AS `identifier_value`,`col`.`acquisition_label` AS `acquisition_label`,`col`.`visit_label` AS `visit_label`,
`specimen_control`.`sample_type` AS `initial_specimen_sample_type`,`specimen`.`sample_control_id` AS `initial_specimen_sample_control_id`,
`parent_samp_control`.`sample_type` AS `parent_sample_type`,`parent_samp`.`sample_control_id` AS `parent_sample_control_id`,
`samp_control`.`sample_type` AS `sample_type`,`samp`.`sample_control_id` AS `sample_control_id`,`samp`.`sample_label` AS `sample_label`,
`al`.`barcode` AS `barcode`,`al`.`aliquot_label` AS `aliquot_label`,`al_control`.`aliquot_type` AS `aliquot_type`,
`al`.`aliquot_control_id` AS `aliquot_control_id`,`al`.`in_stock` AS `in_stock`,`stor`.`code` AS `code`,`stor`.`selection_label` AS `selection_label`,
`al`.`storage_coord_x` AS `storage_coord_x`,`al`.`storage_coord_y` AS `storage_coord_y`, al.study_summary_id AS study_summary_id,
`stor`.`temperature` AS `temperature`,`stor`.`temp_unit` AS `temp_unit`,`al`.`created` AS `created` 
from ((((((((((((((`aliquot_masters` `al` join `aliquot_controls` `al_control` on((`al`.`aliquot_control_id` = `al_control`.`id`))) join `sample_masters` `samp` on(((`samp`.`id` = `al`.`sample_master_id`) and (`samp`.`deleted` <> 1)))) join `sample_controls` `samp_control` on((`samp`.`sample_control_id` = `samp_control`.`id`))) 
left join `sample_masters` `specimen` on(((`samp`.`initial_specimen_sample_id` = `specimen`.`id`) and (`specimen`.`deleted` <> 1)))) 
left join `sample_controls` `specimen_control` on((`specimen`.`sample_control_id` = `specimen_control`.`id`))) 
left join `sample_masters` `parent_samp` on(((`samp`.`parent_id` = `parent_samp`.`id`) and (`parent_samp`.`deleted` <> 1)))) 
left join `sample_controls` `parent_samp_control` on((`parent_samp`.`sample_control_id` = `parent_samp_control`.`id`))) join `collections` `col` on(((`col`.`id` = `samp`.`collection_id`) and (`col`.`deleted` <> 1)))) 
left join `clinical_collection_links` `link` on(((`col`.`id` = `link`.`collection_id`) and (`link`.`deleted` <> 1)))) 
left join `participants` `part` on(((`link`.`participant_id` = `part`.`id`) and (`part`.`deleted` <> 1)))) 
left join `storage_masters` `stor` on(((`stor`.`id` = `al`.`storage_master_id`) and (`stor`.`deleted` <> 1)))) 
left join `banks` on(((`col`.`bank_id` = `banks`.`id`) and (`banks`.`deleted` <> 1)))) 
left join `misc_identifiers` `ident` on(((`ident`.`misc_identifier_control_id` = `banks`.`misc_identifier_control_id`) and (`ident`.`participant_id` = `part`.`id`) and (`ident`.`deleted` <> 1)))) 
left join `misc_identifier_controls` `mic` on((`ident`.`misc_identifier_control_id` = `mic`.`id`))) where (`al`.`deleted` <> 1);

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Inventorymanagement', 'ViewAliquot', 'view_aliquots', 'study_summary_id', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='study_list') , '0', '', '', '', 'study', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='study_summary_id' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='study_list')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='study' AND `language_tag`=''), '0', '27', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '1');
UPDATE structure_formats SET display_order=28 WHERE id IN(4432, 2495);
UPDATE structure_formats SET display_order=30 WHERE id IN(2993);
UPDATE structure_formats SET display_order=27 WHERE id IN(4432);


INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length) VALUES
('researchers', 1, 50);
INSERT INTO structure_value_domains(domain_name, override, category, source) VALUES
('custom_researchers', 'open', '', "StructurePermissibleValuesCustom::getCustomDropdown('researchers')");
UPDATE structure_fields SET  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='custom_researchers')  WHERE model='StudySummary' AND tablename='study_summaries' AND field='qc_nd_researcher' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_staff');
