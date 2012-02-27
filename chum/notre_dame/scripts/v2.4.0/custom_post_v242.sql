-- NEVER RAN YET!!
REPLACE INTO i18n(id, en, fr) VALUES
('last contact date', 'Last contact date', 'Date du dernier contact'),
("the bank number matches an old bank number", "The bank number matches an old bank number.", "Le numéro de banque correspond à un ancien numéro de banque."),
("sardo type", "SARDO type", "Type SARDO"),
("breast cancer", "Breast cancer", "Cancer du sein");

ALTER TABLE participants
 ADD COLUMN qc_nd_last_contact DATE DEFAULT NULL;
ALTER TABLE participants_revs
 ADD COLUMN qc_nd_last_contact DATE DEFAULT NULL;
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'Participant', 'participants', 'qc_nd_last_contact', 'date',  NULL , '0', '', '', '', 'last contact date', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='qc_nd_last_contact' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='last contact date' AND `language_tag`=''), '3', '7', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '0', '1', '0', '0', '1', '0');

ALTER TABLE diagnosis_masters
 ADD COLUMN qc_nd_sardo_id INT DEFAULT NULL AFTER participant_id,
 MODIFY COLUMN dx_nature VARCHAR(100) NOT NULL DEFAULT '';
ALTER TABLE diagnosis_masters_revs
 ADD COLUMN qc_nd_sardo_id INT DEFAULT NULL AFTER participant_id,
 MODIFY COLUMN dx_nature VARCHAR(100) NOT NULL DEFAULT '';
 
UPDATE menus SET flag_active=1 WHERE id IN('clin_CAN_5', 'clin_CAN_5_1');

INSERT INTO diagnosis_controls (category, controls_type, flag_active, form_alias, detail_tablename, display_order, databrowser_label, flag_compare_with_cap) VALUES
('primary', 'sardo', 1, 'diagnosismasters,qc_nd_dx_primary_sardo', 'qc_nd_dxd_primary_sardos', 0, 'primary|sardo', 0),
('progression', 'sardo', 1, 'diagnosismasters,qc_nd_dx_progression_sardos', 'qc_nd_dx_progression_sardos', 0, 'progression|sardo', 0);
	
CREATE TABLE qc_nd_dxd_primary_sardos(
 id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
 diagnosis_master_id INT NOT NULL,
 laterality VARCHAR(50) NOT NULL DEFAULT '',
 tnm_g VARCHAR(50) NOT NULL DEFAULT '',
 figo VARCHAR(50) NOT NULL DEFAULT '',
 deleted TINYINT UNSIGNED NOT NULL DEFAULT 0,
 FOREIGN KEY (diagnosis_master_id) REFERENCES diagnosis_masters(id)
)Engine=InnoDb;
CREATE TABLE qc_nd_dxd_primary_sardos_revs(
 id INT UNSIGNED NOT NULL,
 diagnosis_master_id INT NOT NULL,
 laterality VARCHAR(50) NOT NULL,
 tnm_g VARCHAR(50) NOT NULL DEFAULT '',
 figo VARCHAR(50) NOT NULL DEFAULT '',
 `version_id` int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
 `version_created` datetime NOT NULL 
)Engine=InnoDb;

INSERT INTO event_controls (disease_site, event_group, event_type, flag_active, form_alias, detail_tablename, display_order, databrowser_label) VALUES
('all', 'clinical', 'biopsy', 1, 'eventmasters,qc_nd_ed_biopsy', 'qc_nd_ed_biopsy', 0, 'clinical|all|biopsy'),
('all', 'clinical', 'cytology', 1, 'eventmasters', 'qc_nd_ed_cytology', 0, 'clinical|all|cytology'),
('all', 'lab', 'ca125', 1, 'eventmasters,qc_nd_ed_ca125', 'qc_nd_ed_ca125', 0, 'lab|all|ca125'),
('all', 'lab', 'pathology', 1, 'eventmasters,qc_nd_ed_pathologies', 'qc_nd_ed_pathologies', 0, 'lab|all|pathology'),
('all', 'lab', 'observation', 1, 'eventmasters', 'qc_nd_ed_observations', 0, 'lab|all|observation'),
('prostate', 'lab', 'pathology', 1, 'eventmasters,qc_nd_ed_patho_prostates', 'qc_nd_ed_patho_prostates', 0, 'lab|prostate|pathology'),
('prostate', 'lab', 'aps', 1, 'eventmasters', 'qc_nd_ed_aps_prostates', 0, 'lab|prostate|aps');

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
 value FLOAT DEFAULT NULL,
 deleted BOOLEAN NOT NULL DEFAULT 0,
 FOREIGN KEY (event_master_id) REFERENCES event_masters(id)
);
CREATE TABLE qc_nd_ed_ca125_revs(
 id INT UNSIGNED NOT NULL,
 event_master_id INT NOT NULL,
 value FLOAT DEFAULT NULL,
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
 her2neu text,
 her2neu_fish VARCHAR(100) NOT NULL DEFAULT '',
 her2neu_herceptest VARCHAR(100) NOT NULL DEFAULT '',
 her2neu_tab_250 VARCHAR(100) NOT NULL DEFAULT '',
 index_miotique VARCHAR(100) NOT NULL DEFAULT '',
 marges_resection VARCHAR(100) NOT NULL DEFAULT '',
 recepteur_oestrogene TEXT,
 recepteur_progestatifs TEXT,
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
 her2neu text,
 her2neu_fish VARCHAR(100) NOT NULL DEFAULT '',
 her2neu_herceptest VARCHAR(100) NOT NULL DEFAULT '',
 her2neu_tab_250 VARCHAR(100) NOT NULL DEFAULT '',
 index_miotique VARCHAR(100) NOT NULL DEFAULT '',
 marges_resection VARCHAR(100) NOT NULL DEFAULT '',
 recepteur_oestrogene TEXT,
 recepteur_progestatifs TEXT,
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
 ADD COLUMN qc_nd_type VARCHAR(200) NOT NULL DEFAULT '' AFTER qc_nd_is_neoadjuvant; 
ALTER TABLE txd_radiations_revs
 ADD COLUMN qc_nd_is_neoadjuvant CHAR(1) NOT NULL DEFAULT '' AFTER rad_completed,
 ADD COLUMN qc_nd_type VARCHAR(200) NOT NULL DEFAULT '' AFTER qc_nd_is_neoadjuvant; 

UPDATE menus SET flag_active=true WHERE id IN('clin_CAN_28');

ALTER TABLE dxd_progressions
 ADD COLUMN qc_nd_sites TEXT AFTER diagnosis_master_id;
ALTER TABLE dxd_progressions_revs
 ADD COLUMN qc_nd_sites TEXT AFTER diagnosis_master_id;

ALTER TABLE reproductive_histories
 ADD COLUMN qc_nd_year_menopause SMALLINT UNSIGNED DEFAULT NULL AFTER participant_id,
 ADD COLUMN qc_nd_cause VARCHAR(50) NOT NULL DEFAULT '' AFTER qc_nd_year_menopause,
 ADD COLUMN qc_nd_gravida_para_aborta VARCHAR(20) NOT NULL DEFAULT '' AFTER qc_nd_cause;
ALTER TABLE reproductive_histories_revs
 ADD COLUMN qc_nd_year_menopause SMALLINT UNSIGNED DEFAULT NULL AFTER participant_id,
 ADD COLUMN qc_nd_cause VARCHAR(50) NOT NULL DEFAULT '' AFTER qc_nd_year_menopause,
 ADD COLUMN qc_nd_gravida_para_aborta VARCHAR(20) NOT NULL DEFAULT '' AFTER qc_nd_cause;
 
INSERT INTO `treatment_controls` (`tx_method`, `disease_site`, `flag_active`, `detail_tablename`, `form_alias`, `extend_tablename`, `extend_form_alias`, `display_order`, `applied_protocol_control_id`, `extended_data_import_process`, `databrowser_label`) VALUES
('hormonotherapy', 'all', 1, 'qc_nd_txd_hormonotherapies', 'treatmentmasters,qc_nd_txd_hormonotherapies', NULL, NULL, 0, NULL, NULL, 'all|hormonotherapy'),
('medication', 'all', 1, 'qc_nd_txd_medications', 'treatmentmasters,qc_nd_txd_medications', NULL, NULL, 0, NULL, NULL, 'all|medication');


CREATE TABLE qc_nd_txd_hormonotherapies(
 id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
 treatment_master_id INT NOT NULL,
 type VARCHAR(200) NOT NULL DEFAULT '',
 is_neoadjuvant CHAR(1) NOT NULL DEFAULT '',
 deleted BOOLEAN NOT NULL DEFAULT FALSE,
 FOREIGN KEY (treatment_master_id) REFERENCES treatment_masters(id)
)Engine=InnoDb;
CREATE TABLE qc_nd_txd_hormonotherapies_revs(
 id INT UNSIGNED NOT NULL,
 treatment_master_id INT NOT NULL,
 type VARCHAR(200) NOT NULL DEFAULT '',
 is_neoadjuvant CHAR(1) NOT NULL DEFAULT '',
 deleted BOOLEAN NOT NULL DEFAULT FALSE,
 `version_id` int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
 `version_created` datetime NOT NULL
)Engine=InnoDb;

CREATE TABLE qc_nd_txd_medications(
 id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
 treatment_master_id INT NOT NULL,
 type VARCHAR(200) NOT NULL DEFAULT '',
 deleted BOOLEAN NOT NULL DEFAULT FALSE,
 FOREIGN KEY (treatment_master_id) REFERENCES treatment_masters(id)
)Engine=InnoDb;
CREATE TABLE qc_nd_txd_medications_revs(
 id INT UNSIGNED NOT NULL,
 treatment_master_id INT NOT NULL,
 type VARCHAR(200) NOT NULL DEFAULT '',
 deleted BOOLEAN NOT NULL DEFAULT FALSE,
 `version_id` int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
 `version_created` datetime NOT NULL
)Engine=InnoDb;

INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('qc_nd_menopause_cause', '', '', NULL);
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("by medication", "by medication");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="qc_nd_menopause_cause"),  (SELECT id FROM structure_permissible_values WHERE value="by medication" AND language_alias="by medication"), "1", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("by surgery", "by surgery");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="qc_nd_menopause_cause"),  (SELECT id FROM structure_permissible_values WHERE value="by surgery" AND language_alias="by surgery"), "1", "1");

INSERT INTO structures(`alias`) VALUES ('qc_nd_dx_primary_sardo');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'DiagnosisMaster', 'diagnosis_masters', 'qc_nd_sardo_id', 'integer',  NULL , '0', '', '', '', '#', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
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
('Clinicalannotation', 'DiagnosisDetail', 'qc_nd_dxd_primary_sardos', 'laterality', 'input',  NULL , '0', '', '', '', 'laterality', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='qc_nd_dx_primary_sardo'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_nd_dxd_primary_sardos' AND `field`='laterality' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='laterality' AND `language_tag`=''), '2', '12', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');

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

INSERT INTO protocol_controls (tumour_group, `type`, detail_tablename, form_alias, extend_tablename, extend_form_alias, created, created_by, modified, modified_by, flag_active) VALUES
('all', 'SARDO radiation', 'qc_nd_pd_sardo_radiations', 'qc_nd_pd_sardo_radiations', NULL, NULL, NOW(), 1, NOW(), 1, 1),  
('all', 'SARDO chemotherapy', 'qc_nd_pd_sardo_chemotherapies', 'qc_nd_pd_sardo_chemotherapies', NULL, NULL, NOW(), 1, NOW(), 1, 1);

CREATE TABLE qc_nd_pd_sardo_radiations(
 id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
 protocol_master_id INT NOT NULL,
 deleted BOOLEAN NOT NULL DEFAULT FALSE,
 FOREIGN KEY (protocol_master_id) REFERENCES protocol_masters(id)
)Engine=InnoDb;
CREATE TABLE qc_nd_pd_sardo_radiations_revs(
 id INT UNSIGNED NOT NULL,
 protocol_master_id INT NOT NULL,
 `version_id` int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
 `version_created` datetime NOT NULL
)Engine=InnoDb;

CREATE TABLE qc_nd_pd_sardo_chemotherapies(
 id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
 protocol_master_id INT NOT NULL,
 deleted BOOLEAN NOT NULL DEFAULT FALSE,
 FOREIGN KEY (protocol_master_id) REFERENCES protocol_masters(id)
)Engine=InnoDb;
CREATE TABLE qc_nd_pd_sardo_chemotherapies_revs(
 id INT UNSIGNED NOT NULL,
 protocol_master_id INT NOT NULL,
 `version_id` int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
 `version_created` datetime NOT NULL
)Engine=InnoDb;

INSERT INTO protocol_masters (protocol_control_id, name, created_by, modified_by) VALUES
(3, "Etude PCS III BRAS 3", 1, 1), 
(3, "Radiothérapie du cerveau", 1, 1),
(3, "Radiothérapie du thorax/poumon", 1, 1),
(3, "Implant d'iode 125", 1, 1),
(3, "Radiothérapie pelvienne externe", 1, 1),
(4, "Protocole 5-FU perfusion + RT pré-opératoire", 1, 1),
(4, "Protocole R-CHOP", 1, 1),
(4, "Protocole Taxol + Cisplatin + 5-FU", 1, 1),
(3, "Radiothérapie interstitielle de la prostate", 1, 1),
(3, "Etude CUOG P 0401", 1, 1),
(3, "Radiothérapie de la région pelvienne", 1, 1),
(3, "Etude Abbott M00-244", 1, 1),
(3, "Etude G-0029 BRAS 2", 1, 1),
(3, "Radiothérapie (RT) SAI", 1, 1),
(3, "Radiothérapie pancrénienne", 1, 1),
(3, "Etude Abbott C94-011 pré-op 3 mois", 1, 1),
(3, "Radiothérapie de l'amygdale", 1, 1),
(3, "Etude RTOG 9813 BRAS 2", 1, 1),
(3, "Radiothérapie externe du petit bassin (true pelvis)", 1, 1),
(3, "Etude Abbott C94-011 pré-op 8 mois", 1, 1),
(3, "Etude Abbott M01-366", 1, 1),
(4, "Protocole 5-FU + Leucovorin", 1, 1),
(3, "Etude RTOG 9601 (RT +/- Casodex)", 1, 1),
(3, "Chimiothérapie RAI", 1, 1),
(3, "Radiothérapie abdomino-pelvienne", 1, 1),
(3, "Etude RTOG 0534 BRAS 2", 1, 1),
(4, "Protocole FOLFOX", 1, 1),
(3, "Etude TAX 3503 BRAS 1", 1, 1),
(3, "Etude NCIC PR.7 BRAS 1 (déprivation androgénique intermittente)", 1, 1),
(3, "Radiothérapie de la parotide", 1, 1),
(4, "Protocole CHB Lupron + Euflex", 1, 1),
(4, "Protocole CHB Lupron + Casodex", 1, 1),
(4, "Protocole CHB Zoladex + Casodex", 1, 1),
(4, "Protocole Cisplatin + radiothérapie", 1, 1),
(3, "Etude RTOG 0534 BRAS 1", 1, 1),
(4, "Protocole mFOLFOX 6", 1, 1),
(4, "Protocole Taxol/Carboplatin", 1, 1),
(4, "Docetaxel ou placebo", 1, 1),
(4, "Doxorubicine", 1, 1),
(4, "Vinorelbine", 1, 1),
(4, "Gemcitabine", 1, 1),
(4, "Docetaxel", 1, 1),
(4, "Carboplatine", 1, 1),
(4, "Paclitaxel", 1, 1),
(4, "CP-751871", 1, 1),
(3, "Radiothérapie de la tête et du cou", 1, 1);





INSERT INTO protocol_masters_revs (id, protocol_control_id, name, modified_by, version_created) 
(SELECT id, protocol_control_id, name, modified_by, NOW() FROM protocol_masters);

INSERT INTO qc_nd_pd_sardo_radiations(protocol_master_id) VALUES
(1),
(2),
(3),
(4),
(5);
INSERT INTO qc_nd_pd_sardo_radiations_revs(id, protocol_master_id, version_created) VALUES
(1, 1, NOW()),
(2, 2, NOW()),
(3, 3, NOW()),
(4, 4, NOW()),
(5, 5, NOW());
INSERT INTO qc_nd_pd_sardo_chemotherapies(protocol_master_id) VALUES
(6),
(7),
(8);
INSERT INTO qc_nd_pd_sardo_chemotherapies_revs(id, protocol_master_id, version_created) VALUES
(1, 6, NOW()),
(2, 7, NOW()),
(3, 8, NOW());

CREATE TABLE qc_nd_ed_patho_prostates(
 id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
 event_master_id INT NOT NULL,
 atypie_cellulaire VARCHAR(200) NOT NULL DEFAULT '',
 atypie_cellulaire_blocs VARCHAR(200) NOT NULL DEFAULT '',
 cancer VARCHAR(200) NOT NULL DEFAULT '',
 cancer_prop VARCHAR(200) NOT NULL DEFAULT '',
 cancer_blocs text,
 ganglions_regionaux VARCHAR(200) NOT NULL DEFAULT '',
 ganglions_regionaux_prop VARCHAR(200) NOT NULL DEFAULT '',
 gleason_num VARCHAR(200) NOT NULL DEFAULT '',
 gleason VARCHAR(200) NOT NULL DEFAULT '',
 grade_histologique_sur_3 VARCHAR(200) NOT NULL DEFAULT '',
 hyperplasie_bph VARCHAR(200) NOT NULL DEFAULT '',
 hyperplasie_bph_blocs VARCHAR(200) NOT NULL DEFAULT '',
 infiltration_peineurale VARCHAR(200) NOT NULL DEFAULT '',
 invasion_extra_capsulaire VARCHAR(200) NOT NULL DEFAULT '',
 invasion_lymph_vasc VARCHAR(200) NOT NULL DEFAULT '',
 marges_de_resection VARCHAR(200) NOT NULL DEFAULT '',
 marges_de_resection_blocs VARCHAR(200) NOT NULL DEFAULT '',
 marges_resection_uretre VARCHAR(200) NOT NULL DEFAULT '',
 marges_resection_uretre_blocs VARCHAR(200) NOT NULL DEFAULT '',
 pin_1 VARCHAR(200) NOT NULL DEFAULT '',
 pin_1_blocs VARCHAR(200) NOT NULL DEFAULT '',
 pin_2_3 VARCHAR(200) NOT NULL DEFAULT '',
 pin_2_3_blocs VARCHAR(200) NOT NULL DEFAULT '',
 poids_prostate_num VARCHAR(200) NOT NULL DEFAULT '',
 prostatite VARCHAR(200) NOT NULL DEFAULT '',
 prostatite_blocs VARCHAR(200) NOT NULL DEFAULT '',
 ves_seminales_atteintes VARCHAR(200) NOT NULL DEFAULT '',
 deleted BOOLEAN NOT NULL DEFAULT FALSE,
 FOREIGN KEY (event_master_id) REFERENCES event_masters(id)
)Engine=InnoDb;
CREATE TABLE qc_nd_ed_patho_prostates_revs(
 id INT UNSIGNED NOT NULL,
 event_master_id INT NOT NULL,
 atypie_cellulaire VARCHAR(200) NOT NULL DEFAULT '',
 atypie_cellulaire_blocs VARCHAR(200) NOT NULL DEFAULT '',
 cancer VARCHAR(200) NOT NULL DEFAULT '',
 cancer_prop VARCHAR(200) NOT NULL DEFAULT '',
 cancer_blocs text,
 ganglions_regionaux VARCHAR(200) NOT NULL DEFAULT '',
 ganglions_regionaux_prop VARCHAR(200) NOT NULL DEFAULT '',
 gleason_num VARCHAR(200) NOT NULL DEFAULT '',
 gleason VARCHAR(200) NOT NULL DEFAULT '',
 grade_histologique_sur_3 VARCHAR(200) NOT NULL DEFAULT '',
 hyperplasie_bph VARCHAR(200) NOT NULL DEFAULT '',
 hyperplasie_bph_blocs VARCHAR(200) NOT NULL DEFAULT '',
 infiltration_peineurale VARCHAR(200) NOT NULL DEFAULT '',
 invasion_extra_capsulaire VARCHAR(200) NOT NULL DEFAULT '',
 invasion_lymph_vasc VARCHAR(200) NOT NULL DEFAULT '',
 marges_de_resection VARCHAR(200) NOT NULL DEFAULT '',
 marges_de_resection_blocs VARCHAR(200) NOT NULL DEFAULT '',
 marges_resection_uretre VARCHAR(200) NOT NULL DEFAULT '',
 marges_resection_uretre_blocs VARCHAR(200) NOT NULL DEFAULT '',
 pin_1 VARCHAR(200) NOT NULL DEFAULT '',
 pin_1_blocs VARCHAR(200) NOT NULL DEFAULT '',
 pin_2_3 VARCHAR(200) NOT NULL DEFAULT '',
 pin_2_3_blocs VARCHAR(200) NOT NULL DEFAULT '',
 poids_prostate_num VARCHAR(200) NOT NULL DEFAULT '',
 prostatite VARCHAR(200) NOT NULL DEFAULT '',
 prostatite_blocs VARCHAR(200) NOT NULL DEFAULT '',
 ves_seminales_atteintes VARCHAR(200) NOT NULL DEFAULT '',
 `version_id` int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
 `version_created` datetime NOT NULL
)Engine=InnoDb;

CREATE TABLE qc_nd_ed_aps_prostates(
 id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
 event_master_id INT NOT NULL,
 value FLOAT DEFAULT NULL,
 deleted BOOLEAN NOT NULL DEFAULT FALSE,
 FOREIGN KEY (event_master_id) REFERENCES event_masters(id)
)Engine=InnoDb;
CREATE TABLE qc_nd_ed_aps_prostates_revs(
 id INT UNSIGNED NOT NULL,
 event_master_id INT NOT NULL,
 value FLOAT DEFAULT NULL,
 `version_id` int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
 `version_created` datetime NOT NULL
)Engine=InnoDb;

CREATE TABLE qc_nd_dx_progression_sardos(
 id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
 diagnosis_master_id INT NOT NULL,
 value FLOAT DEFAULT NULL,
 deleted BOOLEAN NOT NULL DEFAULT FALSE,
 FOREIGN KEY (diagnosis_master_id) REFERENCES diagnosis_masters(id)
)Engine=InnoDb;
CREATE TABLE qc_nd_dx_progression_sardos_revs(
 id INT UNSIGNED NOT NULL,
 diagnosis_master_id INT NOT NULL,
 value FLOAT DEFAULT NULL,
 `version_id` int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
 `version_created` datetime NOT NULL
)Engine=InnoDb;

UPDATE structure_formats SET `flag_override_setting`='1', `setting`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_nd_dx_primary_sardo') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='clinical_stage_summary' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_override_setting`='1', `setting`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_nd_dx_primary_sardo') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_tstage' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_override_setting`='1', `setting`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_nd_dx_primary_sardo') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_nstage' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_override_setting`='1', `setting`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_nd_dx_primary_sardo') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_mstage' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_override_setting`='1', `setting`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_nd_dx_primary_sardo') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_stage_summary' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

ALTER TABLE diagnosis_masters
 MODIFY COLUMN path_tstage VARCHAR(20) NOT NULL DEFAULT '',
 MODIFY COLUMN path_mstage VARCHAR(20) NOT NULL DEFAULT '',
 MODIFY COLUMN path_nstage VARCHAR(20) NOT NULL DEFAULT '';
ALTER TABLE diagnosis_masters_revs
 MODIFY COLUMN path_tstage VARCHAR(20) NOT NULL DEFAULT '',
 MODIFY COLUMN path_mstage VARCHAR(20) NOT NULL DEFAULT '',
 MODIFY COLUMN path_nstage VARCHAR(20) NOT NULL DEFAULT '';

DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_nd_dx_primary_sardo') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Clinicalannotation' AND `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='topography' AND `language_label`='topography' AND `language_tag`='' AND `type`='autocomplete' AND `setting`='size=10,url=/codingicd/CodingIcdo3s/autocomplete/topo,tool=/codingicd/CodingIcdo3s/tool/topo' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='help_topography' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_nd_dx_primary_sardo') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Clinicalannotation' AND `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='morphology' AND `language_label`='morphology' AND `language_tag`='' AND `type`='autocomplete' AND `setting`='size=10,url=/codingicd/CodingIcdo3s/autocomplete/morpho,tool=/codingicd/CodingIcdo3s/tool/morpho' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='help_morphology' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
 
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'DiagnosisDetail', 'qc_nd_dxd_primary_sardos', 'tnm_g', 'input',  NULL , '0', '', '', '', 'tnm g', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='qc_nd_dx_primary_sardo'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_nd_dxd_primary_sardos' AND `field`='tnm_g' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tnm g' AND `language_tag`=''), '2', '9', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');
UPDATE structure_formats SET `display_order`='10' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_nd_dx_primary_sardo') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='diagnosis_masters' AND `field`='survival_time_months' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

INSERT INTO structures(`alias`) VALUES ('qc_nd_dx_progression_sardos');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'DiagnosisDetail', 'qc_nd_dx_progression_sardos', 'value', 'integer',  NULL , '0', '', '', '', 'sites', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='qc_nd_dx_progression_sardos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_nd_dx_progression_sardos' AND `field`='value' AND `type`='integer' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='sites' AND `language_tag`=''), '1', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');

INSERT INTO structures(`alias`) VALUES ('qc_nd_ed_pathologies');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'EventDetail', 'qc_nd_ed_pathologies', 'atteinte_multicentrique', 'input',  NULL , '0', '', '', '', 'atteinte multicentrique', ''), 
('Clinicalannotation', 'EventDetail', 'qc_nd_ed_pathologies', 'atteinte_multifocale', 'input',  NULL , '0', '', '', '', 'atteinte multifocale', ''), 
('Clinicalannotation', 'EventDetail', 'qc_nd_ed_pathologies', 'ganglions_regionaux', 'input',  NULL , '0', '', '', '', 'ganglions regionaux', ''), 
('Clinicalannotation', 'EventDetail', 'qc_nd_ed_pathologies', 'ganglions_regionaux_prop', 'input',  NULL , '0', '', '', '', 'ganglions regionaux prop', ''), 
('Clinicalannotation', 'EventDetail', 'qc_nd_ed_pathologies', 'ganglions_regionaux_sent', 'input',  NULL , '0', '', '', '', 'ganglions regionaux sent', ''), 
('Clinicalannotation', 'EventDetail', 'qc_nd_ed_pathologies', 'grade_nottingham', 'input',  NULL , '0', '', '', '', 'grade nottingham', ''), 
('Clinicalannotation', 'EventDetail', 'qc_nd_ed_pathologies', 'grade_histologique_sur_3', 'input',  NULL , '0', '', '', '', 'grade histologique sur 3', ''), 
('Clinicalannotation', 'EventDetail', 'qc_nd_ed_pathologies', 'grade_nucleaire', 'input',  NULL , '0', '', '', '', 'grade nucleaire', ''), 
('Clinicalannotation', 'EventDetail', 'qc_nd_ed_pathologies', 'her2neu', 'input',  NULL , '0', '', '', '', 'her2neu', ''), 
('Clinicalannotation', 'EventDetail', 'qc_nd_ed_pathologies', 'her2neu_fish', 'input',  NULL , '0', '', '', '', 'her2neu fish', ''), 
('Clinicalannotation', 'EventDetail', 'qc_nd_ed_pathologies', 'her2neu_herceptest', 'input',  NULL , '0', '', '', '', 'her2neu herceptest', ''), 
('Clinicalannotation', 'EventDetail', 'qc_nd_ed_pathologies', 'her2neu_tab_250', 'input',  NULL , '0', '', '', '', 'her2neu tab 250', ''), 
('Clinicalannotation', 'EventDetail', 'qc_nd_ed_pathologies', 'index_miotique', 'input',  NULL , '0', '', '', '', 'index miotique', ''), 
('Clinicalannotation', 'EventDetail', 'qc_nd_ed_pathologies', 'marges_resection', 'input',  NULL , '0', '', '', '', 'marges resection', ''), 
('Clinicalannotation', 'EventDetail', 'qc_nd_ed_pathologies', 'recepteur_oestrogene', 'input',  NULL , '0', '', '', '', 'recepteur oestrogene', ''), 
('Clinicalannotation', 'EventDetail', 'qc_nd_ed_pathologies', 'recepteur_progestatifs', 'input',  NULL , '0', '', '', '', 'recepteur progestatifs', ''), 
('Clinicalannotation', 'EventDetail', 'qc_nd_ed_pathologies', 'recepteur_hormonaux', 'input',  NULL , '0', '', '', '', 'recepteur hormonaux', ''), 
('Clinicalannotation', 'EventDetail', 'qc_nd_ed_pathologies', 'taille_tumeur_mm', 'input',  NULL , '0', '', '', '', 'taille tumeur mm', ''), 
('Clinicalannotation', 'EventDetail', 'qc_nd_ed_pathologies', 'taile_tummeur_mm_num', 'input',  NULL , '0', '', '', '', 'taile tummeur mm num', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='qc_nd_ed_pathologies'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_nd_ed_pathologies' AND `field`='atteinte_multicentrique' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='atteinte multicentrique' AND `language_tag`=''), '1', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_ed_pathologies'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_nd_ed_pathologies' AND `field`='atteinte_multifocale' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='atteinte multifocale' AND `language_tag`=''), '1', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_ed_pathologies'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_nd_ed_pathologies' AND `field`='ganglions_regionaux' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ganglions regionaux' AND `language_tag`=''), '1', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_ed_pathologies'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_nd_ed_pathologies' AND `field`='ganglions_regionaux_prop' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ganglions regionaux prop' AND `language_tag`=''), '1', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_ed_pathologies'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_nd_ed_pathologies' AND `field`='ganglions_regionaux_sent' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ganglions regionaux sent' AND `language_tag`=''), '1', '6', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_ed_pathologies'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_nd_ed_pathologies' AND `field`='grade_nottingham' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='grade nottingham' AND `language_tag`=''), '1', '7', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_ed_pathologies'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_nd_ed_pathologies' AND `field`='grade_histologique_sur_3' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='grade histologique sur 3' AND `language_tag`=''), '1', '8', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_ed_pathologies'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_nd_ed_pathologies' AND `field`='grade_nucleaire' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='grade nucleaire' AND `language_tag`=''), '1', '9', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_ed_pathologies'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_nd_ed_pathologies' AND `field`='her2neu' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='her2neu' AND `language_tag`=''), '1', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_ed_pathologies'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_nd_ed_pathologies' AND `field`='her2neu_fish' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='her2neu fish' AND `language_tag`=''), '1', '11', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_ed_pathologies'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_nd_ed_pathologies' AND `field`='her2neu_herceptest' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='her2neu herceptest' AND `language_tag`=''), '1', '12', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_ed_pathologies'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_nd_ed_pathologies' AND `field`='her2neu_tab_250' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='her2neu tab 250' AND `language_tag`=''), '1', '13', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_ed_pathologies'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_nd_ed_pathologies' AND `field`='index_miotique' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='index miotique' AND `language_tag`=''), '2', '14', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_ed_pathologies'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_nd_ed_pathologies' AND `field`='marges_resection' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='marges resection' AND `language_tag`=''), '2', '15', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_ed_pathologies'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_nd_ed_pathologies' AND `field`='recepteur_oestrogene' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='recepteur oestrogene' AND `language_tag`=''), '2', '16', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_ed_pathologies'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_nd_ed_pathologies' AND `field`='recepteur_progestatifs' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='recepteur progestatifs' AND `language_tag`=''), '2', '17', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_ed_pathologies'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_nd_ed_pathologies' AND `field`='recepteur_hormonaux' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='recepteur hormonaux' AND `language_tag`=''), '2', '18', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_ed_pathologies'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_nd_ed_pathologies' AND `field`='taille_tumeur_mm' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='taille tumeur mm' AND `language_tag`=''), '2', '19', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_ed_pathologies'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_nd_ed_pathologies' AND `field`='taile_tummeur_mm_num' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='taile tummeur mm num' AND `language_tag`=''), '2', '20', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');

UPDATE structure_fields SET `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_surgery_precision') ,  `language_label`='precision' WHERE model='TreatmentDetail' AND tablename='txd_surgeries' AND field='qc_nd_precision' AND `type`='input' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_surgery_precision');
UPDATE structure_fields SET `language_label`='residual disease' WHERE model='TreatmentDetail' AND tablename='txd_surgeries' AND field='qc_nd_residual_disease' AND `type`='input' AND structure_value_domain  IS NULL ;
UPDATE structure_fields SET `language_label`='no patho' WHERE model='TreatmentDetail' AND tablename='txd_surgeries' AND field='qc_nd_no_patho' AND `type`='input' AND structure_value_domain  IS NULL ;
UPDATE structure_fields SET `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_location') ,  `language_label`='location' WHERE model='TreatmentDetail' AND tablename='txd_surgeries' AND field='qc_nd_location' AND `type`='input' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_location');

INSERT INTO structures(`alias`) VALUES ('qc_nd_txd_hormonotherapies');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'TreatmentDetail', 'qc_nd_txd_hormonotherapies', 'type', 'input',  NULL , '0', '', '', '', 'type', ''), 
('Clinicalannotation', 'TreatmentDetail', 'qc_nd_txd_hormonotherapies', 'is_neoadjuvant', 'yes_no',  NULL , '0', '', '', '', 'is neoadjuvant', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='qc_nd_txd_hormonotherapies'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_nd_txd_hormonotherapies' AND `field`='type' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='type' AND `language_tag`=''), '1', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_txd_hormonotherapies'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_nd_txd_hormonotherapies' AND `field`='is_neoadjuvant' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='is neoadjuvant' AND `language_tag`=''), '1', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'TreatmentDetail', 'txd_radiations', 'qc_nd_type', 'input',  NULL , '0', '', '', '', 'type', ''), 
('Clinicalannotation', 'TreatmentDetail', 'txd_radiations', 'qc_nd_is_neoadjuvant', 'yes_no',  NULL , '0', '', '', '', 'is neoadjuvant', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='txd_radiations'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_radiations' AND `field`='qc_nd_type' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='type' AND `language_tag`=''), '1', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='txd_radiations'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_radiations' AND `field`='qc_nd_is_neoadjuvant' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='is neoadjuvant' AND `language_tag`=''), '1', '11', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');

UPDATE structure_formats SET `display_order`='11' WHERE structure_id=(SELECT id FROM structures WHERE alias='txd_radiations') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_radiations' AND `field`='rad_completed' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yesno') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='9' WHERE structure_id=(SELECT id FROM structures WHERE alias='txd_radiations') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_radiations' AND `field`='qc_nd_type' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='10' WHERE structure_id=(SELECT id FROM structures WHERE alias='txd_radiations') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_radiations' AND `field`='qc_nd_is_neoadjuvant' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'ReproductiveHistory', 'reproductive_histories', 'qc_nd_year_menopause', 'integer_positive',  NULL , '0', '', '', '', 'year menopause', ''), 
('Clinicalannotation', 'ReproductiveHistory', 'reproductive_histories', 'qc_nd_cause', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_menopause_cause') , '0', '', '', '', 'cause', ''), 
('Clinicalannotation', 'ReproductiveHistory', 'reproductive_histories', 'qc_nd_gravida_para_aborta', 'input',  NULL , '0', '', '', '', 'gravida para aborta', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='reproductivehistories'), (SELECT id FROM structure_fields WHERE `model`='ReproductiveHistory' AND `tablename`='reproductive_histories' AND `field`='qc_nd_year_menopause' AND `type`='integer_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='year menopause' AND `language_tag`=''), '1', '16', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='reproductivehistories'), (SELECT id FROM structure_fields WHERE `model`='ReproductiveHistory' AND `tablename`='reproductive_histories' AND `field`='qc_nd_cause' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_menopause_cause')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='cause' AND `language_tag`=''), '1', '17', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='reproductivehistories'), (SELECT id FROM structure_fields WHERE `model`='ReproductiveHistory' AND `tablename`='reproductive_histories' AND `field`='qc_nd_gravida_para_aborta' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='gravida para aborta' AND `language_tag`=''), '1', '18', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');

INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('qc_nd_figo', '', '', NULL);

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'DiagnosisDetail', 'qc_nd_dxd_primary_sardos', 'figo', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_figo') , '0', '', '', '', 'figo', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='qc_nd_dx_primary_sardo'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_nd_dxd_primary_sardos' AND `field`='figo' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_figo')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='figo' AND `language_tag`=''), '2', '13', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');

CREATE TABLE qc_nd_ed_observations(
 id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
 event_master_id INT NOT NULL,
 type VARCHAR(200) NOT NULL DEFAULT '',
 end_date DATE DEFAULT NULL,
 end_date_accuracy CHAR(1) NOT NULL DEFAULT '',
 deleted BOOLEAN NOT NULL DEFAULT 0,
 FOREIGN KEY (event_master_id) REFERENCES event_masters(id)
)Engine=InnoDb;
CREATE TABLE qc_nd_ed_observations_revs(
 id INT UNSIGNED NOT NULL,
 event_master_id INT NOT NULL,
 type VARCHAR(200) NOT NULL DEFAULT '',
 end_date DATE DEFAULT NULL,
 end_date_accuracy CHAR(1) NOT NULL DEFAULT '',
 deleted BOOLEAN NOT NULL DEFAULT 0,
 `version_id` int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
 `version_created` datetime NOT NULL
)Engine=InnoDb;

UPDATE datamart_adhoc SET sql_query_for_results='SELECT BankNumber.identifier_value AS bank_number, NdNumber.identifier_value AS nd_number, HdNumber.identifier_value AS hd_number,
SlNumber.identifier_value AS sl_number, Participant.last_name, Participant.first_name, RamqNumber.identifier_value as ramq_number,
Collection.collection_site AS collection_site, Collection.collection_datetime AS collection_datetime,
Collection.collection_datetime_accuracy AS collection_datetime_accuracy, Collection.id AS id
 FROM collections AS Collection
INNER JOIN clinical_collection_links AS ccl ON Collection.id=ccl.collection_id
INNER JOIN participants AS Participant ON ccl.participant_id=Participant.id
LEFT JOIN banks ON Collection.bank_id = banks.id
LEFT JOIN misc_identifiers AS BankNumber ON BankNumber.participant_id=Participant.id AND banks.misc_identifier_control_id=BankNumber.misc_identifier_control_id  
LEFT JOIN misc_identifiers AS NdNumber ON  NdNumber.participant_id=Participant.id AND NdNumber.misc_identifier_control_id=9
LEFT JOIN misc_identifiers AS HdNumber ON HdNumber.participant_id=Participant.id AND HdNumber.misc_identifier_control_id=8
LEFT JOIN misc_identifiers AS SlNumber ON SlNumber.participant_id=Participant.id AND SlNumber.misc_identifier_control_id=10
LEFT JOIN misc_identifiers as RamqNumber ON RamqNumber.participant_id=Participant.id AND RamqNumber.misc_identifier_control_id=7
WHERE TRUE AND Collection.collection_datetime >= "@@Collection.collection_datetime_start@@" 
 AND Collection.collection_datetime <= "@@Collection.collection_datetime_end@@" 
 AND Collection.collection_site = "@@Collection.collection_site@@"
 AND Collection.bank_id = "@@Collection.bank_id@@"' WHERE id=3;
 
INSERT INTO structures(`alias`) VALUES ('qc_nd_txd_medications');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'TreatmentDetail', 'qc_nd_txd_medications', 'type', 'input',  NULL , '0', '', '', '', 'type', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='qc_nd_txd_medications'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_nd_txd_medications' AND `field`='type' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='type' AND `language_tag`=''), '1', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');

CREATE TABLE qc_nd_sardo_conflicts(
 id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
 table_n_field VARCHAR(50) NOT NULL DEFAULT '',
 ref_id INT UNSIGNED NOT NULL,
 new_value text,
 import_date TIMESTAMP NOT NULL DEFAULT NOW()
)Engine=InnoDb;

UPDATE structure_formats SET `flag_search`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='sardo_participant_id' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='sardo_medical_record_number' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='1');

UPDATE structure_fields SET  `language_label`='tnm grade' WHERE model='DiagnosisDetail' AND tablename='qc_nd_dxd_primary_sardos' AND field='tnm_g' AND `type`='input' AND structure_value_domain  IS NULL ;
UPDATE structure_formats SET display_column=1, `display_order`='10' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_nd_dx_primary_sardo') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_nd_dxd_primary_sardos' AND `field`='figo' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_figo') AND `flag_confidential`='0');
UPDATE structure_formats SET display_column=1, `display_order`='3' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_nd_dx_primary_sardo') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_nd_dxd_primary_sardos' AND `field`='laterality' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET display_column=1, `display_order`='11' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_nd_dx_primary_sardo') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='survival_time_months' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET display_column=1, `display_order`='5' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_nd_dx_primary_sardo') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_nd_dxd_primary_sardos' AND `field`='tnm_g' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET display_column=1, `display_order`='9' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_nd_dx_primary_sardo') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_stage_summary' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET display_column=1, `display_order`='8' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_nd_dx_primary_sardo') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_mstage' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET display_column=1, `display_order`='7' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_nd_dx_primary_sardo') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_nstage' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET display_column=1, `display_order`='6' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_nd_dx_primary_sardo') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_tstage' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET display_column=1, `display_order`='2' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_nd_dx_primary_sardo') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='icd10_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET display_column=1, `display_order`='12' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_nd_dx_primary_sardo') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_nature' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='dx_nature') AND `flag_confidential`='0');
UPDATE structure_formats SET display_column=1, `display_order`='13' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_nd_dx_primary_sardo') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='clinical_stage_summary' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='dx_nature') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_nd_dx_primary_sardo') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='clinical_stage_summary' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='qc_nd_dx_primary_sardo'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='morphology' AND `type`='autocomplete' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=10,url=/codingicd/CodingIcdo3s/autocomplete/morpho,tool=/codingicd/CodingIcdo3s/tool/morpho' AND `default`='' AND `language_help`='help_morphology' AND `language_label`='morphology' AND `language_tag`=''), '1', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');

UPDATE menus SET flag_active=true WHERE id IN('clin_CAN_10');

UPDATE structure_formats SET `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='familyhistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='FamilyHistory' AND `tablename`='family_histories' AND `field`='relation' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='relation') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='familyhistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='FamilyHistory' AND `tablename`='family_histories' AND `field`='family_domain' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='domain') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='familyhistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='FamilyHistory' AND `tablename`='family_histories' AND `field`='previous_primary_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='familyhistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='FamilyHistory' AND `tablename`='family_histories' AND `field`='primary_icd10_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='familyhistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='FamilyHistory' AND `tablename`='family_histories' AND `field`='age_at_dx' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_fields SET setting='size=10,url=/codingicd/CodingIcd10s/autocomplete/ca,tool=/codingicd/CodingIcd10s/tool/ca' WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='icd10_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0';

ALTER TABLE family_histories
 ADD COLUMN qc_nd_sardo_type VARCHAR(20) NOT NULL DEFAULT '' AFTER last_sardo_import_date;
ALTER TABLE family_histories_revs
 ADD COLUMN qc_nd_sardo_type VARCHAR(20) NOT NULL DEFAULT '' AFTER last_sardo_import_date;

INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("qc_nd_fam_hist_sardo_type", "", "", "");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("breast cancer", "breast cancer");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="qc_nd_fam_hist_sardo_type"), (SELECT id FROM structure_permissible_values WHERE value="breast cancer" AND language_alias="breast cancer"), "0", "1");

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'FamilyHistory', 'family_histories', 'qc_nd_sardo_type', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_fam_hist_sardo_type') , '0', '', '', '', 'sardo type', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='familyhistories'), (SELECT id FROM structure_fields WHERE `model`='FamilyHistory' AND `tablename`='family_histories' AND `field`='qc_nd_sardo_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_fam_hist_sardo_type')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='sardo type' AND `language_tag`=''), '1', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');

UPDATE structure_formats SET `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='familyhistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='FamilyHistory' AND `tablename`='family_histories' AND `field`='last_sardo_import_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1', `flag_detail`='1', `flag_summary`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='familyhistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='FamilyHistory' AND `tablename`='family_histories' AND `field`='qc_nd_sardo_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_fam_hist_sardo_type') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='2', display_order=23 WHERE structure_id=(SELECT id FROM structures WHERE alias='familyhistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='FamilyHistory' AND `tablename`='family_histories' AND `field`='qc_nd_sardo_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_fam_hist_sardo_type') AND `flag_confidential`='0');

UPDATE structure_formats SET `display_order`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='diagnosismasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats SET `display_order`='13' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_nd_dx_primary_sardo') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_nature' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='dx_nature') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='10', `flag_override_label`='1', `language_label`='clinical stage' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_nd_dx_primary_sardo') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='clinical_stage_summary' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='12' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_nd_dx_primary_sardo') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='survival_time_months' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='11' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_nd_dx_primary_sardo') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_nd_dxd_primary_sardos' AND `field`='figo' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_figo') AND `flag_confidential`='0');

UPDATE datamart_browsing_controls SET flag_active_1_to_2=1, flag_active_2_to_1=1 WHERE use_field IN('DiagnosisMaster.participant_id', 'TreatmentMaster.participant_id');
UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_nd_dx_primary_sardo') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='icd10_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_nd_dx_primary_sardo') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_tstage' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_nd_dx_primary_sardo') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_nstage' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_nd_dx_primary_sardo') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_mstage' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_nd_dx_primary_sardo') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='survival_time_months' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_nd_dx_primary_sardo') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_nd_dxd_primary_sardos' AND `field`='tnm_g' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_nd_dx_primary_sardo') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='morphology' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_fields SET  `language_label`='SARDO laterality' WHERE model='DiagnosisDetail' AND tablename='qc_nd_dxd_primary_sardos' AND field='laterality' AND `type`='input' AND structure_value_domain  IS NULL ;
UPDATE structure_formats SET `flag_override_setting`='1', `setting`='size=4' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_nd_dx_primary_sardo') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_tstage' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_override_setting`='1', `setting`='size=4' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_nd_dx_primary_sardo') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_nstage' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_override_setting`='1', `setting`='size=4' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_nd_dx_primary_sardo') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_mstage' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');



