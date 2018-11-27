-- -----------------------------------------------------------------------------------------------------------------------------------
-- Mirgation from v254 (revs5176) to v271
--
-- mysql -u root ohri --default-character-set=utf8 < ./v2.6.0/custom_pre260.sql
-- mysql -u root ohri --default-character-set=utf8 < ./v2.6.0/atim_v2.6.0_upgrade.sql
-- mysql -u root ohri --default-character-set=utf8 < ./v2.6.0/custom_post260.sql
-- mysql -u root ohri --default-character-set=utf8 < ./v2.6.0/atim_v2.6.1_upgrade.sql
-- mysql -u root ohri --default-character-set=utf8 < ./v2.6.0/atim_v2.6.2_upgrade.sql
-- mysql -u root ohri --default-character-set=utf8 < ./v2.6.0/atim_v2.6.3_upgrade.sql
-- mysql -u root ohri --default-character-set=utf8 < ./v2.6.0/atim_v2.6.4_upgrade.sql
-- mysql -u root ohri --default-character-set=utf8 < ./v2.6.0/atim_v2.6.5_upgrade.sql
-- mysql -u root ohri --default-character-set=utf8 < ./v2.6.0/atim_v2.6.6_upgrade.sql
-- mysql -u root ohri --default-character-set=utf8 < ./v2.6.0/atim_v2.6.7_upgrade.sql
-- mysql -u root ohri --default-character-set=utf8 < ./v2.6.0/atim_v2.6.8_upgrade.sql
--
-- mysql -u root ohri --default-character-set=utf8 < ./v2.7.0/atim_v2.7.0_upgrade.sql
-- mysql -u root ohri --default-character-set=utf8 < ./v2.7.0/atim_v2.7.1_upgrade.sql
-- mysql -u root ohri --default-character-set=utf8 < ./v2.7.0/custom_post271.sql
--
--
-- -----------------------------------------------------------------------------------------------------------------------------------

SET GLOBAL sql_mode = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION';
SET SESSION sql_mode = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION';

-- Hide all fields displaying protocol data into Inventory Management module.
-- -----------------------------------------------------------------------------------------------------------------------------------

UPDATE structure_formats SET `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') 
AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='collection_protocol_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='collection_protocols') AND `flag_confidential`='0');

UPDATE structure_formats SET `language_heading`='collection' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') 
AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='acquisition_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats SET `language_heading`='', `flag_index`='0' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') 
AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='collection_protocol_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='collection_protocols') AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_index`='0', `flag_summary`='0' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='collections_for_collection_tree_view') 
AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='collection_protocol_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='collection_protocols') AND `flag_confidential`='0');

-- Users
-- -----------------------------------------------------------------------------------------------------------------------------------

UPDATE users SET first_name = 'Unknown', last_name = 'Unknown', email = '', password = 'ddeaa159a89375256a02d1cfbd9a1946ad01a979', flag_active = 0, deleted = 1 WHERE id IN (2,3);

-- Order
-- -----------------------------------------------------------------------------------------------------------------------------------

select count(*) AS 'Nbr of order lines should be equal to 0. Pelase validate below.' from order_lines where deleted <> 1;

-- Update databrowser
-- ------------------------------------------------------------------------

UPDATE datamart_browsing_controls set flag_active_1_to_2 = 1, flag_active_2_to_1 = 1 WHERE (id1 = 1 AND id2 =24) OR (id1 = 24 AND id2 =1);
UPDATE datamart_browsing_controls set flag_active_1_to_2 = 1, flag_active_2_to_1 = 1 WHERE (id1 = 24 AND id2 =3) OR (id1 = 3 AND id2 =24);
UPDATE datamart_browsing_controls set flag_active_1_to_2 = 1, flag_active_2_to_1 = 1 WHERE (id1 = 23 AND id2 =3) OR (id1 = 3 AND id2 =23);
UPDATE datamart_browsing_controls set flag_active_1_to_2 = 1, flag_active_2_to_1 = 1 WHERE (id1 = 23 AND id2 =24) OR (id1 = 24 AND id2 =23);
UPDATE datamart_browsing_controls set flag_active_1_to_2 = 1, flag_active_2_to_1 = 1 WHERE (id1 = 23 AND id2 =25) OR (id1 = 25 AND id2 =23);
UPDATE datamart_browsing_controls set flag_active_1_to_2 = 1, flag_active_2_to_1 = 1 WHERE (id1 = 8 AND id2 =25) OR (id1 = 25 AND id2 =8);
UPDATE datamart_browsing_controls set flag_active_1_to_2 = 1, flag_active_2_to_1 = 1 WHERE (id1 = 6 AND id2 =25) OR (id1 = 25 AND id2 =6);

-- Inveotry Configuration
-- ------------------------------------------------------------------------

UPDATE parent_to_derivative_sample_controls SET flag_active=false WHERE id IN('188', '189', '190', '194', '152', '193');
UPDATE parent_to_derivative_sample_controls SET flag_active=true WHERE id IN('9', '7', '8', '23', '136');
UPDATE parent_to_derivative_sample_controls SET flag_active=false WHERE id IN('192');

SELECT DISTINCT sample_type AS 'Unsupported sample type' FROM sample_controls WHERE sample_type NOT IN ('ascite', 'tissue', 'ascite cell', 'ascite supernatant', 'cell culture', 'rna')
AND id IN (SELECT sample_control_id FROM sample_masters WHERE deleted <> 1);

-- Event
-- ------------------------------------------------------------------------

UPDATE event_controls SET use_addgrid = '1', use_detail_form_for_index = '1' WHERE event_group = 'clinical' AND event_type IN ('ctscan', 'follow up') AND flag_active = 1;

UPDATE structure_formats SET `flag_override_setting`='1', `setting`='cols=40,rows=2', `flag_addgrid`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='ohri_ed_clinical_ctscans') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_summary' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_addgrid`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='ohri_ed_clinical_ctscans') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ohri_ed_clinical_ctscans' AND `field`='response' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='response') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='2' WHERE structure_id=(SELECT id FROM structures WHERE alias='ohri_ed_clinical_ctscans') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_summary' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats SET `display_column`='2', `flag_override_setting`='1', `setting`='cols=40,rows=2', `flag_addgrid`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='ohri_ed_clinical_followups') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_summary' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_addgrid`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='ohri_ed_clinical_followups') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ohri_ed_clinical_followups' AND `field`='recurrence_status' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_addgrid`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='ohri_ed_clinical_followups') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ohri_ed_clinical_followups' AND `field`='disease_status' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ohri_disease_status') AND `flag_confidential`='0');

UPDATE event_controls SET use_addgrid = '1', use_detail_form_for_index = '1' WHERE event_group = 'lab' AND event_type IN ('chemistry', 'markers') AND flag_active = 1;

UPDATE structure_formats SET `display_column`='2', `flag_addgrid`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='ohri_ed_lab_chemistries') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_summary' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_addgrid`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='ohri_ed_lab_chemistries') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ohri_ed_lab_chemistries' AND `field`='CA125_u_ml' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_addgrid`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='ohri_ed_lab_chemistries') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ohri_ed_lab_chemistries' AND `field`='ca125_progression' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_override_setting`='1', `setting`='cols=40,rows=2', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='ohri_ed_lab_chemistries') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_summary' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats SET `display_column`='2', `flag_addgrid`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='ohri_ed_lab_markers') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_summary' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_addgrid`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='ohri_ed_lab_markers') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ohri_ed_lab_markers' AND `field`='brca' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ohri_brca_result') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_addgrid`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='ohri_ed_lab_markers') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ohri_ed_lab_markers' AND `field`='platinum' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ohri_platinum_result') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_override_setting`='1', `setting`='cols=40,rows=2', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='ohri_ed_lab_markers') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_summary' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats SET `display_column`='3', `flag_index`='1',`language_heading`='summary' WHERE structure_id=(SELECT id FROM structures WHERE alias='ohri_ed_lab_pathologies') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_summary' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- Treatment
-- ------------------------------------------------------------------------
 
UPDATE treatment_controls SET use_addgrid = '1', use_detail_form_for_index = '1' WHERE flag_Active = 1 AND disease_site = 'ohri' AND tx_method IN ('surgery', 'radiation');
UPDATE treatment_controls SET use_addgrid = '0', use_detail_form_for_index = '1' WHERE flag_Active = 1 AND disease_site = 'ohri' AND tx_method IN ('chemotherapy');


UPDATE structure_formats SET `flag_addgrid`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='ohri_txd_surgeries') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='tx_intent' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='intent') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_addgrid`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='ohri_txd_surgeries') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='ohri_txd_surgeries' AND `field`='residual_disease' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ohri_residual_disease') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_addgrid`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='ohri_txd_surgeries') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='notes' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_addgrid`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='ohri_txd_surgeries') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='ohri_txd_surgeries' AND `field`='description' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ohri_surgery_description') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_override_setting`='1', `setting`='rows=2,cols=30', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='ohri_txd_surgeries') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='notes' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_addgrid`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='txd_radiations') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='tx_intent' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='intent') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_addgrid`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='txd_radiations') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='finish_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='2', `flag_override_setting`='1', `setting`='rows=2,cols=30', `flag_addgrid`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='txd_radiations') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='notes' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_addgrid`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='txd_radiations') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_radiations' AND `field`='rad_completed' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yesno') AND `flag_confidential`='0');

UPDATE structure_formats SET `display_column`='2', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='txd_chemos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='notes' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- Study Misc Identifier
-- ------------------------------------------------------------------------
 
INSERT INTO misc_identifier_controls (misc_identifier_name, flag_active, flag_link_to_study)
VALUES
('patient study id', '1', '1');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='miscidentifiers_for_participant_search') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='title' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1', `flag_detail`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='miscidentifiers') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='title' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_override_label`='1', `language_label`='identifier name' WHERE structure_id=(SELECT id FROM structures WHERE alias='miscidentifiers_for_participant_search') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='MiscIdentifierControl' AND `tablename`='misc_identifier_controls' AND `field`='misc_identifier_name' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='identifier_name_list') AND `flag_confidential`='0');
INSERT INTO i18n (id,en,fr)
VALUES
('patient study id', 'Patient Study#', '# Étude du patient');

-- Study Consent
-- ------------------------------------------------------------------------
 
INSERT INTO consent_controls (controls_type, flag_active, detail_form_alias, detail_tablename, databrowser_label)
VALUES
('study consent', '1', 'consent_masters_study', 'cd_nationals', 'study consent');
INSERT INTO `structure_validations` (`id`, `structure_field_id`, `rule`, `on_action`, `language_message`) 
VALUES 
(NULL, (SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='autocomplete_consent_study_summary_id' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), 'notBlank', '', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='consent_masters'), (SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='title' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '2', '', '0', '1', 'study / project', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');
INSERT INTO i18n (id,en,fr)
VALUES
('study consent', 'Study Consent', 'Consentement d''étude');

-- Batch actions & Databrowser
-- ------------------------------------------------------------------------

UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '1' WHERE fct.datamart_structure_id = str.id AND str.model = 'TmaBlock' AND label = 'create tma slide';
UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '1' WHERE fct.datamart_structure_id = str.id AND str.model = 'TmaSlide' AND label = 'edit';
UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '1' WHERE fct.datamart_structure_id = str.id AND str.model = 'Participant' AND label = 'create participant message (applied to all)';
UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '1' WHERE fct.datamart_structure_id = str.id AND str.model = 'TmaSlide' AND label = 'add to order';

UPDATE datamart_browsing_controls set flag_active_1_to_2 = 0, flag_active_2_to_1 = 0 WHERE (id1 = 21 AND id2 =1) OR (id1 = 1 AND id2 =21);
UPDATE datamart_browsing_controls set flag_active_1_to_2 = 0, flag_active_2_to_1 = 0 WHERE (id1 = 21 AND id2 =15) OR (id1 = 15 AND id2 =21);

UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '0' WHERE fct.datamart_structure_id = str.id AND str.model = 'ViewCollection' AND label = 'print barcodes';
UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '0' WHERE fct.datamart_structure_id = str.id AND str.model = 'ViewSample' AND label = 'print barcodes';
UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '0' WHERE fct.datamart_structure_id = str.id AND str.model = 'ViewAliquot' AND label = 'print barcodes';

UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '0' WHERE fct.datamart_structure_id = str.id AND str.model = 'AliquotReviewMaster' AND label = 'number of elements per participant';

-- Database validation
-- ------------------------------------------------------------------------

ALTER TABLE ohri_dx_others MODIFY diagnosis_master_id int(11) NOT NULL;
ALTER TABLE ohri_dx_ovaries MODIFY diagnosis_master_id int(11) NOT NULL;
ALTER TABLE ohri_ed_clinical_ctscans MODIFY event_master_id int(11) NOT NULL;
ALTER TABLE ohri_ed_clinical_followups MODIFY event_master_id int(11) NOT NULL;
ALTER TABLE ohri_ed_lab_chemistries MODIFY event_master_id int(11) NOT NULL;
ALTER TABLE ohri_ed_lab_markers MODIFY event_master_id int(11) NOT NULL;
ALTER TABLE ohri_ed_lab_pathologies MODIFY event_master_id int(11) NOT NULL;
ALTER TABLE ohri_txd_surgeries MODIFY treatment_master_id int(11) NOT NULL;
ALTER TABLE spr_ohri_ovarian_tissues MODIFY specimen_review_master_id int(11) NOT NULL;

ALTER TABLE spr_ohri_ovarian_tissues DROP COLUMN id;

ALTER TABLE ohri_dx_ovaries_revs MODIFY diagnosis_master_id  int(11) NOT NULL;
ALTER TABLE ohri_ed_clinical_ctscans_revs MODIFY event_master_id  int(11) NOT NULL;
ALTER TABLE ohri_ed_clinical_followups_revs MODIFY event_master_id  int(11) NOT NULL;
ALTER TABLE ohri_ed_lab_chemistries_revs MODIFY event_master_id  int(11) NOT NULL;
ALTER TABLE ohri_ed_lab_markers_revs MODIFY event_master_id  int(11) NOT NULL;
ALTER TABLE ohri_ed_lab_pathologies_revs MODIFY event_master_id  int(11) NOT NULL;
ALTER TABLE ohri_txd_surgeries_revs MODIFY treatment_master_id  int(11) NOT NULL;

ALTER TABLE spr_ohri_ovarian_tissues_revs DROP COLUMN created;
ALTER TABLE spr_ohri_ovarian_tissues_revs DROP COLUMN created_by;
ALTER TABLE spr_ohri_ovarian_tissues_revs DROP COLUMN modified;
ALTER TABLE spr_ohri_ovarian_tissues_revs DROP COLUMN modified_by;
ALTER TABLE spr_ohri_ovarian_tissues_revs DROP COLUMN deleted;
ALTER TABLE spr_ohri_ovarian_tissues_revs DROP COLUMN deleted_date;
ALTER TABLE spr_ohri_ovarian_tissues_revs DROP COLUMN id;
ALTER TABLE spr_ohri_ovarian_tissues_revs MODIFY specimen_review_master_id int(11) NOT NULL;

DROP TABLE announcements_revs;

ALTER TABLE ohri_dx_others_revs MODIFY diagnosis_master_id   int(11) NOT NULL;

ALTER TABLE ohri_ed_clinical_ctscans_revs DROP INDEX event_master_id;
ALTER TABLE ohri_ed_clinical_followups_revs DROP INDEX event_master_id;
ALTER TABLE ohri_ed_lab_chemistries_revs DROP INDEX event_master_id;
ALTER TABLE ohri_ed_lab_markers_revs DROP INDEX event_master_id;
ALTER TABLE ohri_ed_lab_pathologies_revs DROP INDEX event_master_id;

-- Missing i18n

INSERT INTO i18n (id,en,fr)
VALUES
('ohri - ovarian tissue', 'OHRI - Ovarian Tissue', '');

-- Queries to desactivate 'Participant Identifiers' demo report
-- --------------------------------------------------------------------------------------------------------
UPDATE datamart_reports SET flag_active = 0 WHERE name = 'participant identifiers';
UPDATE datamart_structure_functions SET flag_active = 0 WHERE link = (SELECT CONCAT('/Datamart/Reports/manageReport/',id) FROM datamart_reports WHERE name = 'participant identifiers');

-- Inveotry ocnfiguration

UPDATE parent_to_derivative_sample_controls SET flag_active=false WHERE id IN('220', '203');

-- Queries to desactivate 'Participant Identifiers' demo report
-- --------------------------------------------------------------------------------------------------------
UPDATE datamart_reports SET flag_active = 0 WHERE name = 'terry fox export';
UPDATE datamart_structure_functions SET flag_active = 0 WHERE link = (SELECT CONCAT('/Datamart/Reports/manageReport/',id) FROM datamart_reports WHERE name = 'terry fox export');

-- Hide Control disease site

update event_controls SET disease_site = '' WHERE disease_site = 'ohri';
update treatment_controls SET disease_site = '' WHERE disease_site = 'ohri';
update event_controls SET databrowser_label = event_type;
update treatment_controls SET databrowser_label = tx_method;

-- Move Bank# to misc identifier
-- ----------------------------------------------------------------------------------------------------------------

UPDATE users SET username = 'system' WHERE username = 'manager' AND id = 2;

INSERT INTO `misc_identifier_controls` (`id`, `misc_identifier_name`, `flag_active`, `display_order`, 
`autoincrement_name`, `misc_identifier_format`, 
`flag_once_per_participant`, `flag_confidential`, `flag_unique`, `pad_to_length`, `reg_exp_validation`, `user_readable_format`, `flag_link_to_study`) 
VALUES
(null, 'ohri_ovary_bank_participant_id', 1, 3, 
'', '', 
1, 0, 1, 0, '', '', 0);
INSERT INTO i18n (id,en,fr)
VALUES
('ohri_ovary_bank_participant_id', 'Ovary Bank#', 'Ovaire - Banque#');

SET @modified_by = (SELECT id FROM users WHERE username = 'system');
SET @modified = (SELECT NOW() FROM users WHERE username = 'system');
SET @misc_identifier_control_id = (SELECT id FROM misc_identifier_controls WHERE misc_identifier_name = 'ohri_ovary_bank_participant_id');

SELECT participant_identifier AS 'participant_identifier duplicated value to clean up' FROM (
	select count(*) as res, participant_identifier FROM participants WHERE deleted <> 1 GROUP BY participant_identifier
) res2 WHERE res2.res > 1;
SELECT participant_identifier 'participant_identifier duplicated : not migrated to bank number', id as participant_id FROM participants WHERE deleted <> 1 AND participant_identifier = '1159';
INSERT INTO misc_identifiers (`identifier_value`, `notes`, `participant_id`, `misc_identifier_control_id`, `flag_unique`, `modified`, `created`, `created_by`, `modified_by`) 
(SELECT participant_identifier, '', id, @misc_identifier_control_id, 1, @modified, @modified, @modified_by, @modified_by FROM participants WHERE deleted <> 1 AND participant_identifier != '1159');
INSERT INTO misc_identifiers_revs (`misc_identifier_control_id`, `tmp_deleted`, `identifier_value`, `notes`, `participant_id`, 
`flag_unique`, `modified_by`, `id`, `version_created`) 
(SELECT `misc_identifier_control_id`, `tmp_deleted`, `identifier_value`, `notes`, `participant_id`, 
`flag_unique`, `modified_by`, `id`, `modified` FROM misc_identifiers WHERE misc_identifier_control_id = @misc_identifier_control_id);

UPDATE participants SET participant_identifier = id, modified = @modified, modified_by = @modified_by WHERE deleted <> 1;

INSERT INTO participants_revs (id, title, first_name, middle_name, last_name, date_of_birth, date_of_birth_accuracy, marital_status,
 language_preferred, sex, race, vital_status, notes, date_of_death, date_of_death_accuracy, cod_icd10_code,
 secondary_cod_icd10_code, cod_confirmation_source, participant_identifier, last_chart_checked_date, last_chart_checked_date_accuracy, last_modification, last_modification_ds_id, 
 modified_by, version_created)
(SELECT id, title, first_name, middle_name, last_name, date_of_birth, date_of_birth_accuracy, marital_status,
 language_preferred, sex, race, vital_status, notes, date_of_death, date_of_death_accuracy, cod_icd10_code,
 secondary_cod_icd10_code, cod_confirmation_source, participant_identifier, last_chart_checked_date, last_chart_checked_date_accuracy, last_modification, last_modification_ds_id, 
 modified_by, `modified` FROM participants WHERE modified = @modified AND modified_by = @modified_by);

UPDATE structure_formats SET `display_column`='3', `display_order`='98', `language_heading`='system data', `flag_add`='0', `flag_edit_readonly`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='participant_identifier' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='created' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

REPLACE INTO i18n (id,en,fr) VALUES ('participant identifier', 'Participant ATiM#', 'Participant ATiM#');

ALTER TABLE collections ADD COLUMN misc_identifier_id int(11) DEFAULT NULL;
ALTER TABLE collections_revs ADD COLUMN misc_identifier_id int(11) DEFAULT NULL;
ALTER TABLE `collections`
  ADD CONSTRAINT `collections_ibfk_misc_identifiers` FOREIGN KEY (`misc_identifier_id`) REFERENCES `misc_identifiers` (`id`); 
SET @modified_by = (SELECT id FROM users WHERE username = 'system');
SET @modified = (SELECT NOW() FROM users WHERE username = 'system');
UPDATE collections Collection, misc_identifiers MiscIdentifier
SET Collection.misc_identifier_id = MiscIdentifier.id,
Collection.modified = @modified,
Collection.modified_by = @modified_by
WHERE Collection.participant_id = MiscIdentifier.participant_id
AND Collection.deleted <> 1
AND MiscIdentifier.deleted <> 1
AND MiscIdentifier.misc_identifier_control_id = (SELECT id FROM misc_identifier_controls WHERE misc_identifier_name = 'ohri_ovary_bank_participant_id');
INSERT INTO collections_revs (id, acquisition_label, bank_id, collection_site, collection_datetime, collection_datetime_accuracy, sop_master_id, collection_property,
collection_notes, participant_id, diagnosis_master_id, consent_master_id, treatment_master_id, event_master_id, 
misc_identifier_id,
version_created, modified_by)
(SELECT id, acquisition_label, bank_id, collection_site, collection_datetime, collection_datetime_accuracy, sop_master_id, collection_property,
collection_notes, participant_id, diagnosis_master_id, consent_master_id, treatment_master_id, event_master_id, 
misc_identifier_id,
modified, modified_by FROM collections WHERE modified = @modified AND modified_by = @modified_by);

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'ViewCollection', '', 'misc_identifier_value', 'input',  NULL , '0', 'size=30,class=range file', '', '', 'collection participant identifier', ''),
('InventoryManagement', 'ViewAliquot', '', 'misc_identifier_value', 'input',  NULL , '0', 'size=30,class=range file', '', '', 'collection participant identifier', ''),
('InventoryManagement', 'ViewSample', '', 'misc_identifier_value', 'input',  NULL , '0', 'size=30,class=range file', '', '', 'collection participant identifier', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='view_collection'), 
(SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='misc_identifier_value' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30,class=range file' AND `default`='' AND `language_help`='' AND `language_label`='collection participant identifier' AND `language_tag`=''), '0', '1', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'),
((SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection'), 
(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='misc_identifier_value' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30,class=range file' AND `default`='' AND `language_help`='' AND `language_label`='collection participant identifier' AND `language_tag`=''), '0', '1', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0'),
((SELECT id FROM structures WHERE alias='view_sample_joined_to_collection'), 
(SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='' AND `field`='misc_identifier_value' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30,class=range file' AND `default`='' AND `language_help`='' AND `language_label`='collection participant identifier' AND `language_tag`=''), '0', '1', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '1', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0');
UPDATE structure_formats SET `display_order`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='participant_identifier' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='clinicalcollectionlinks'), (SELECT id FROM structure_fields WHERE `model`='MiscIdentifier' AND `tablename`='misc_identifiers' AND `field`='identifier_value' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '0', '10', 'collection', '0', '1', 'collection participant identifier', '0', '', '0', '', '0', '', '1', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');
UPDATE structure_formats SET `language_heading`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='collection_site' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_collection_site') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='bank_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='banks') AND `flag_confidential`='0');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='collections_for_collection_tree_view'), (SELECT id FROM structure_fields WHERE `model`='MiscIdentifier' AND `tablename`='misc_identifiers' AND `field`='identifier_value' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '0', '-1', '', '0', '1', 'collection participant identifier', '0', '', '0', '', '0', '', '1', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');
UPDATE structure_formats SET `display_order`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='collections_for_collection_tree_view') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='bank_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='banks') AND `flag_confidential`='0');

REPLACE INTO i18n (id,en,fr) VALUES
('collection participant identifier','Participant Identifier','Identifiant du participant'),
('error_fk_frsq_number_linked_collection','Your data cannot be deleted! This identifier is linked to a collection.','Vos données ne peuvent être supprimées! Cet identifiant est attaché à une collection.');

-- Set participant into project

UPDATE misc_identifier_controls SET flag_unique = 0 WHERE misc_identifier_name = 'patient study id';

SET @misc_identifier_control_id = (SELECT id from misc_identifier_controls WHERE misc_identifier_name = 'patient study id');
SET @modified_by = (SELECT id FROM users WHERE username = 'system');
SET @modified = (SELECT NOW() FROM users WHERE username = 'system');

SET @study_summary_id = (SELECT id FROM study_summaries WHERE title LIKE '%Petkovich%');
INSERT INTO `misc_identifiers` (`identifier_value`, `notes`, `participant_id`, `misc_identifier_control_id`, `study_summary_id`, `modified`, `created`, `created_by`, `modified_by`)
(SELECT 'n/a', '', lookup_id, @misc_identifier_control_id, @study_summary_id, @modified, @modified, @modified_by, @modified_by
FROM datamart_batch_sets, datamart_batch_ids
WHERE title LIKE '%project%' AND datamart_structure_id IN (SELECT id FROM datamart_structures WHERE model = 'Participant')
AND datamart_batch_sets.id = set_id
AND title LIKE '%Petkovich%');

SET @study_summary_id = (SELECT id FROM study_summaries WHERE title LIKE '%Magliocco%');
INSERT INTO `misc_identifiers` (`identifier_value`, `notes`, `participant_id`, `misc_identifier_control_id`, `study_summary_id`, `modified`, `created`, `created_by`, `modified_by`)
(SELECT 'n/a', '', lookup_id, @misc_identifier_control_id, @study_summary_id, @modified, @modified, @modified_by, @modified_by
FROM datamart_batch_sets, datamart_batch_ids
WHERE title LIKE '%project%' AND datamart_structure_id IN (SELECT id FROM datamart_structures WHERE model = 'Participant')
AND datamart_batch_sets.id = set_id
AND title LIKE '%Magliocco%');

SET @study_summary_id = (SELECT id FROM study_summaries WHERE title LIKE '%Picketts%');
INSERT INTO `misc_identifiers` (`identifier_value`, `notes`, `participant_id`, `misc_identifier_control_id`, `study_summary_id`, `modified`, `created`, `created_by`, `modified_by`)
(SELECT 'n/a', '', lookup_id, @misc_identifier_control_id, @study_summary_id, @modified, @modified, @modified_by, @modified_by
FROM datamart_batch_sets, datamart_batch_ids
WHERE title LIKE '%project%' AND datamart_structure_id IN (SELECT id FROM datamart_structures WHERE model = 'Participant')
AND datamart_batch_sets.id = set_id
AND title LIKE '%Picketts%');

SET @study_summary_id = (SELECT id FROM study_summaries WHERE title LIKE '%Weberpals%');
INSERT INTO `misc_identifiers` (`identifier_value`, `notes`, `participant_id`, `misc_identifier_control_id`, `study_summary_id`, `modified`, `created`, `created_by`, `modified_by`)
(SELECT 'n/a', '', lookup_id, @misc_identifier_control_id, @study_summary_id, @modified, @modified, @modified_by, @modified_by
FROM datamart_batch_sets, datamart_batch_ids
WHERE title LIKE '%project%' AND datamart_structure_id IN (SELECT id FROM datamart_structures WHERE model = 'Participant')
AND datamart_batch_sets.id = set_id
AND title LIKE '%Weberpals%');

SET @study_summary_id = (SELECT id FROM study_summaries WHERE title LIKE '%Huntsman%');
INSERT INTO `misc_identifiers` (`identifier_value`, `notes`, `participant_id`, `misc_identifier_control_id`, `study_summary_id`, `modified`, `created`, `created_by`, `modified_by`)
(SELECT 'n/a', '', lookup_id, @misc_identifier_control_id, @study_summary_id, @modified, @modified, @modified_by, @modified_by
FROM datamart_batch_sets, datamart_batch_ids
WHERE title LIKE '%project%' AND datamart_structure_id IN (SELECT id FROM datamart_structures WHERE model = 'Participant')
AND datamart_batch_sets.id = set_id
AND title LIKE '%Huntsman%');

SET @study_summary_id = (SELECT id FROM study_summaries WHERE title LIKE '%Bachvarov%');
INSERT INTO `misc_identifiers` (`identifier_value`, `notes`, `participant_id`, `misc_identifier_control_id`, `study_summary_id`, `modified`, `created`, `created_by`, `modified_by`)
(SELECT 'n/a', '', lookup_id, @misc_identifier_control_id, @study_summary_id, @modified, @modified, @modified_by, @modified_by
FROM datamart_batch_sets, datamart_batch_ids
WHERE title LIKE '%project%' AND datamart_structure_id IN (SELECT id FROM datamart_structures WHERE model = 'Participant')
AND datamart_batch_sets.id = set_id
AND title LIKE '%Bachvarov%');

SET @study_summary_id = (SELECT id FROM study_summaries WHERE title LIKE '%Dr Tsang%');
INSERT INTO `misc_identifiers` (`identifier_value`, `notes`, `participant_id`, `misc_identifier_control_id`, `study_summary_id`, `modified`, `created`, `created_by`, `modified_by`)
(SELECT 'n/a', '', lookup_id, @misc_identifier_control_id, @study_summary_id, @modified, @modified, @modified_by, @modified_by
FROM datamart_batch_sets, datamart_batch_ids
WHERE title LIKE '%project%' AND datamart_structure_id IN (SELECT id FROM datamart_structures WHERE model = 'Participant')
AND datamart_batch_sets.id = set_id
AND title LIKE '%Tsang%');

INSERT INTO `misc_identifiers_revs` (`misc_identifier_control_id`, `tmp_deleted`, `identifier_value`, `notes`, `participant_id`, `study_summary_id`, `modified_by`, `id`, `version_created`) 
(SELECT `misc_identifier_control_id`, `tmp_deleted`, `identifier_value`, `notes`, `participant_id`, `study_summary_id`, `modified_by`, `id`, `modified` FROM misc_identifiers WHERE modified_by = @modified_by AND modified = @modified);

-- ---------------------------------------------------------------------------------------------------------------------------------------------------
-- ---------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE versions SET branch_build_number = '7496' WHERE version_number = '2.7.1';

INSERT IGNORE INTO i18n (id,en,fr) VALUES ('ATiM#', 'ATiM#', 'ATiM#');

UPDATE versions SET branch_build_number = '7497' WHERE version_number = '2.7.1';

-- Follow-up

SET @modified_by = (SELECT id FROM users WHERE username = 'system');
SET @modified = (SELECT NOW() FROM users WHERE username = 'system');

ALTER TABLE ohri_ed_clinical_followups
  ADD COLUMN recurence_evidence VARCHAR(150)  DEFAULT NULL;
ALTER TABLE ohri_ed_clinical_followups_revs
  ADD COLUMN recurence_evidence VARCHAR(150)  DEFAULT NULL;  
INSERT INTO structure_value_domains (domain_name, override, category, source) values
('ohri_followup_recurence_evidences', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(\'Recurrence Evidences\')');
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) 
VALUES
('Recurrence Evidences', 1, 150, 'clinial - annotation');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Recurrence Evidences');
INSERT INTO structure_permissible_values_customs 
(`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) 
VALUES
("biochemical","Biochemical", "", "1", "1", @control_id, @modified, @modified, @modified_by, @modified_by),
("clinical","Clinical", "", "2", "1", @control_id, @modified, @modified, @modified_by, @modified_by),
("radiological","Radiological", "", "3", "1", @control_id, @modified, @modified, @modified_by, @modified_by),
("biochemical & clinical","Biochemical & Clinical", "", "4", "1", @control_id, @modified, @modified, @modified_by, @modified_by),
("biochemical & radiological","Biochemical & Radiological", "", "5", "1", @control_id, @modified, @modified, @modified_by, @modified_by),
("biochemical & clinical & radiological","Biochemical & Clinical & Radiological", "", "6", "1", @control_id, @modified, @modified, @modified_by, @modified_by),
("clinical & radiological","Clinical & Radiological", "", "7", "1", @control_id, @modified, @modified, @modified_by, @modified_by),
("other evidence","Other Evidence", "", "8", "1", @control_id, @modified, @modified, @modified_by, @modified_by),
("no evidence","No evidence", "", "9", "1", @control_id, @modified, @modified, @modified_by, @modified_by);
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', 'ohri_ed_clinical_followups', 'recurence_evidence', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ohri_followup_recurence_evidences') , '0', '', '', '', 'basic recurrence', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ohri_ed_clinical_followups'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ohri_ed_clinical_followups' AND `field`='recurence_evidence' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ohri_followup_recurence_evidences')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='basic recurrence' AND `language_tag`=''), '2', '1', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '1', '0');
UPDATE structure_fields SET  `setting`='size=30',  `language_label`='',  `language_tag`='details' WHERE model='EventDetail' AND tablename='ohri_ed_clinical_followups' AND field='recurrence_status' AND `type`='input' AND structure_value_domain  IS NULL ;
UPDATE structure_formats SET `display_order`='6' WHERE structure_id=(SELECT id FROM structures WHERE alias='ohri_ed_clinical_followups') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ohri_ed_clinical_followups' AND `field`='recurrence_status' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_fields SET  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='ohri_followup_recurence_evidences') ,  `language_label`='recurrence evidence' WHERE model='EventDetail' AND tablename='ohri_ed_clinical_followups' AND field='recurence_evidence' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='ohri_followup_recurence_evidences');
UPDATE structure_formats SET `display_order`='5' WHERE structure_id=(SELECT id FROM structures WHERE alias='ohri_ed_clinical_followups') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ohri_ed_clinical_followups' AND `field`='recurence_evidence' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ohri_followup_recurence_evidences') AND `flag_confidential`='0');
INSERT IGNORE INTO i18n (id,en,fr) VALUES ('recurrence evidence', 'Recurrence Evidence', "Preuve de récurrence");

UPDATE event_masters EM, ohri_ed_clinical_followups ED
SET EM.modified = @modified,
EM.modified_by = @modified_by,
ED.recurence_evidence = 'biochemical'
WHERE EM.id = ED.event_master_id
AND EM.deleted <> 1
AND recurrence_status IN ('Biochemical', 'Biochemical evidence', 'Biochemical evidence/No clinical evidence');
											
UPDATE event_masters EM, ohri_ed_clinical_followups ED
SET EM.modified = @modified,
EM.modified_by = @modified_by,
ED.recurence_evidence = 'clinical'
WHERE EM.id = ED.event_master_id
AND EM.deleted <> 1
AND recurrence_status IN ('Clinical','Clinical evidence');

UPDATE event_masters EM, ohri_ed_clinical_followups ED
SET EM.modified = @modified,
EM.modified_by = @modified_by,
ED.recurence_evidence = 'radiological'
WHERE EM.id = ED.event_master_id
AND EM.deleted <> 1
AND recurrence_status IN ('Radiological evidence');

UPDATE event_masters EM, ohri_ed_clinical_followups ED
SET EM.modified = @modified,
EM.modified_by = @modified_by,
ED.recurence_evidence = 'biochemical & clinical'
WHERE EM.id = ED.event_master_id
AND EM.deleted <> 1
AND recurrence_status IN ('Biochemical and Clinical', 'Biochemical and Clinical Evidence', 'Clinical and Biochemical', 'Clinical and Biochemical evidence', 
'Clinical and Biological Evidence', 'Clinical Biochemical Evidence', 'Clinical Evidence and Biochemical evidence', 'Clinical, biochemical evidence');

UPDATE event_masters EM, ohri_ed_clinical_followups ED
SET EM.modified = @modified,
EM.modified_by = @modified_by,
ED.recurence_evidence = 'biochemical & radiological'
WHERE EM.id = ED.event_master_id
AND EM.deleted <> 1
AND recurrence_status IN ('Biochemical and Radiological', 'Biochemical and radiological evidence', 'Biochemical Radiological Evidence', 
'Biochemical  and Radiological', 'Radioligical and biochemical evidence');

UPDATE event_masters EM, ohri_ed_clinical_followups ED
SET EM.modified = @modified,
EM.modified_by = @modified_by,
ED.recurence_evidence = 'clinical & radiological'
WHERE EM.id = ED.event_master_id
AND EM.deleted <> 1
AND recurrence_status IN ('Clinical and Radioligical evidence', 'Clinical and Radiological', 'Clinical and Radiological evidence', 'Clinical Radiological Evidence');

UPDATE event_masters EM, ohri_ed_clinical_followups ED
SET EM.modified = @modified,
EM.modified_by = @modified_by,
ED.recurence_evidence = 'biochemical & clinical & radiological'
WHERE EM.id = ED.event_master_id
AND EM.deleted <> 1
AND recurrence_status IN ('Biochemical, clinical and radiological', 'Biochemical, clinical and radiological evidence', 'Clinical and Biochemical and radiological evidence', 
'Clinical and Biochemical evidence and Radiological', 'Clinical and Radiological and Biochemical Evidence', 'Clinical Biochemical and Radiological evidence', 
'Clinical Biochemical Radiological Evidence', 'Clinical,  Biochemical and radiological evidence', 'Clinical, biochemical and radiological', 
'Clinical, Biochemical and Radiological evidence', 'Clinical, Radioligical and biochemical evidence', 
'Clinical, Radiological and Biochemical evidence', 'Radiological and Biochemical and Clinical Evidence', 'Radiological, Biochemical and Clinical evidence');
		
UPDATE event_masters EM, ohri_ed_clinical_followups ED
SET EM.modified = @modified,
EM.modified_by = @modified_by,
ED.recurence_evidence = 'other evidence'
WHERE EM.id = ED.event_master_id
AND EM.deleted <> 1
AND recurrence_status IN ('Pathological evidence', 'Surgical Evidence (Biopsy)', 'Clinical, Radiological and Cytological', 'Physical Evidence');

UPDATE event_masters EM, ohri_ed_clinical_followups ED
SET EM.modified = @modified,
EM.modified_by = @modified_by,
ED.recurence_evidence = 'no evidence'
WHERE EM.id = ED.event_master_id
AND EM.deleted <> 1
AND recurrence_status IN ('No clinical evidence', 'No evidence', 'No evidence of recurrence');										

INSERT INTO event_masters_revs (id, event_control_id, event_status, event_summary, event_date, event_date_accuracy, information_source, 
urgency, date_required, date_required_accuracy, date_requested, date_requested_accuracy, reference_number, participant_id, diagnosis_master_id, 
version_created, modified_by)
(SELECT id, event_control_id, event_status, event_summary, event_date, event_date_accuracy, information_source, 
urgency, date_required, date_required_accuracy, date_requested, date_requested_accuracy, reference_number, participant_id, diagnosis_master_id, 
modified, modified_by FROM event_masters WHERE modified = @modified AND modified_by = @modified_by);

INSERT INTO ohri_ed_clinical_followups_revs (recurrence_status, disease_status, event_master_id, recurence_evidence, version_created)
(SELECT recurrence_status, disease_status, event_master_id, recurence_evidence, modified 
FROM event_masters INNER JOIN ohri_ed_clinical_followups ON id = event_master_id WHERE modified = @modified AND modified_by = @modified_by);

INSERT INTO structure_permissible_values_custom_controls 
(name, flag_active, values_max_length, category) VALUES
('Disease Status', 1, 50, 'clinical - annotation');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Disease Status');
SET @user_id = 2;
INSERT INTO structure_permissible_values_customs 
(`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) VALUES
("", "", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("remission", "Remission", "Rémission", "2", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("regression", "Regression", "", "3", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("stable", "Stable", "", "4", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("progressing", "Progressing", "", "5", "1", @control_id, NOW(), NOW(), @user_id, @user_id);
UPDATE structure_permissible_values_custom_controls 
 SET values_used_as_input_counter = 5, values_counter = 5 WHERE name = 'Disease Status';
UPDATE structure_value_domains SET source = 'StructurePermissibleValuesCustom::getCustomDropdown(\'Disease Status\')' WHERE domain_name = 'ohri_disease_status';
SET @id = (SELECT id FROM structure_value_domains WHERE domain_name = 'ohri_disease_status');
UPDATE structure_value_domains_permissible_values SET flag_active = 0 WHERE structure_value_domain_id = @id;

-- CT Scan

INSERT INTO structure_permissible_values_custom_controls 
(name, flag_active, values_max_length, category) VALUES
('CT Scan Responses', 1, 50, 'clinical - annotation');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'CT Scan Responses');
SET @user_id = 2;
INSERT INTO structure_permissible_values_customs 
(`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) VALUES
("progressive disease", "Progressive Disease", "Maladie progressive", "3", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("stable disease", "Stable Disease", "Maladie stable", "4", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("unknown", "Unknown", "Inconnu", "5", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("complete", "Complete response", "Réponse complète", "2", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("partial", "Partial response", "Réponse partielle", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id);
UPDATE structure_permissible_values_custom_controls 
 SET values_used_as_input_counter = 5, values_counter = 5 WHERE name = 'CT Scan Responses';
INSERT INTO structure_value_domains (domain_name, override, category, source) values
('ohri_ctscan_responses', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(\'CT Scan Responses\')');
UPDATE structure_fields SET  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='ohri_ctscan_responses')  WHERE model='EventDetail' AND tablename='ohri_ed_clinical_ctscans' AND field='response' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='response');

ALTER TABLE ohri_ed_clinical_ctscans
  ADD COLUMN type VARCHAR(50) DEFAULT NULL,
  ADD COLUMN site_of_response VARCHAR(50) DEFAULT NULL;
ALTER TABLE ohri_ed_clinical_ctscans_revs
  ADD COLUMN type VARCHAR(50) DEFAULT NULL,
  ADD COLUMN site_of_response VARCHAR(50) DEFAULT NULL;

INSERT INTO structure_value_domains (domain_name, override, category, source) values
('ohri_ctscan_types', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(\'CT-Scan Types\')'),
('ohri_ctscan_response_sites', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(\'CT-Scan Response Sites\')');
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) 
VALUES
('CT-Scan Types', 1, 50, 'clinial - annotation'),
('CT-Scan Response Sites', 1, 50, 'clinial - annotation');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'CT-Scan Types');
INSERT INTO structure_permissible_values_customs 
(`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) 
VALUES
("chest/thorax","Chest/Thorax", "", "1", "1", @control_id, @modified, @modified, @modified_by, @modified_by),
("brain","Brain", "", "1", "1", @control_id, @modified, @modified, @modified_by, @modified_by),
("abdomen/pelvis","Abdomen/Pelvis", "", "1", "1", @control_id, @modified, @modified, @modified_by, @modified_by);

SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'CT-Scan Response Sites');
INSERT INTO structure_permissible_values_customs 
(`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) 
VALUES
("ascites","Ascites", "", "1", "1", @control_id, @modified, @modified, @modified_by, @modified_by),
("lymph nodes","Lymph nodes", "", "1", "1", @control_id, @modified, @modified, @modified_by, @modified_by),
("omentum","Omentum", "", "1", "1", @control_id, @modified, @modified, @modified_by, @modified_by),
("liver","Liver", "", "1", "1", @control_id, @modified, @modified, @modified_by, @modified_by),
("bowel","Bowel", "", "1", "1", @control_id, @modified, @modified, @modified_by, @modified_by),
("peritoneal","Peritoneal", "", "1", "1", @control_id, @modified, @modified, @modified_by, @modified_by),
("vaginal vault","Vaginal Vault", "", "1", "1", @control_id, @modified, @modified, @modified_by, @modified_by),
("bone","Bone", "", "1", "1", @control_id, @modified, @modified, @modified_by, @modified_by),
("lungs","Lungs", "", "1", "1", @control_id, @modified, @modified, @modified_by, @modified_by),
("pleura","Pleura", "", "1", "1", @control_id, @modified, @modified, @modified_by, @modified_by),
("pleural effusion","Pleural effusion", "", "1", "1", @control_id, @modified, @modified, @modified_by, @modified_by);

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', 'ohri_ed_clinical_ctscans', 'type', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ohri_ctscan_types') , '0', '', '', '', 'type', ''), 
('ClinicalAnnotation', 'EventDetail', 'ohri_ed_clinical_ctscans', 'site_of_response', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ohri_ctscan_response_sites') , '0', '', '', '', '', ' site');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ohri_ed_clinical_ctscans'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ohri_ed_clinical_ctscans' AND `field`='type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ohri_ctscan_types')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='type' AND `language_tag`=''), '2', '20', 'data', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ohri_ed_clinical_ctscans'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ohri_ed_clinical_ctscans' AND `field`='site_of_response' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ohri_ctscan_response_sites')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`=' site'), '2', '22', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '1', '0');
UPDATE structure_formats SET `language_heading`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='ohri_ed_clinical_ctscans') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ohri_ed_clinical_ctscans' AND `field`='response' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ohri_ctscan_responses') AND `flag_confidential`='0');

-- ---------------------------------------------------------------------------------------------------------------------------

UPDATE versions set branch_build_number = '7507' WHERE version_number = '2.7.1';
UPDATE versions set branch_build_number = '7510' WHERE version_number = '2.7.1';
UPDATE versions set branch_build_number = '7511' WHERE version_number = '2.7.1';

