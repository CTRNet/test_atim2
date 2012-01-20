UPDATE users SET flag_active = 1 WHERE id = 1;
UPDATE groups SET flag_show_confidential = 1 WHERE id = 1;

-- ========================================================================================================
-- CLINICAL ANNOTATION
-- ========================================================================================================

INSERT INTO i18n (id,en,fr) VALUEs ('core_installname', 'CHUS - Breast/Ovary', 'CHUS - Sein/Ovaire');

-- --------------------------------------------------------------------------------------------------------
-- Profile
-- --------------------------------------------------------------------------------------------------------

UPDATE structure_fields SET  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='sex') ,  `language_help`='' WHERE model='Participant' AND tablename='participants' AND field='sex' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='sex');
UPDATE structure_fields SET  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='race') ,  `language_help`='' WHERE model='Participant' AND tablename='participants' AND field='race' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='race');
UPDATE structure_formats SET `flag_override_help`='0', `language_help`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='sex' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='sex') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit_readonly`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='participant_identifier' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='middle_name' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_batchedit`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='marital_status' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='marital_status') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_batchedit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='language_preferred' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='language_preferred') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='title' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='person title') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_override_help`='0', `language_help`='', `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='race' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='race') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_batchedit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='cod_icd10_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='cod_confirmation_source' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='secondary_cod_icd10_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats SET `display_column`='3', `display_order`='100' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='participant_identifier' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

REPLACE INTO i18n (id,en,fr) VALUES ('participant identifier', 'Participant System Code', 'Participant - Code système');

UPDATE structure_formats SET `language_heading`='', `flag_editgrid_readonly`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='participant_identifier' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='clin_demographics' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='first_name' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

INSERT INTO `structure_validations` (`structure_field_id`, `rule`) 
VALUES ((SELECT id FROM structure_fields WHERE field = 'first_name' AND model = 'Participant'), 'notEmpty'),
((SELECT id FROM structure_fields WHERE field = 'last_name' AND model = 'Participant'), 'notEmpty');

ALTER TABLE participants
  ADD COLUMN `chus_cause_of_death` varchar(250) DEFAULT NULL AFTER date_of_death_accuracy,
  ADD COLUMN `chus_date_of_status` date DEFAULT NULL AFTER vital_status,
  ADD COLUMN `chus_date_of_status_accuracy` char(1) NOT NULL DEFAULT '' AFTER chus_date_of_status,
  ADD COLUMN `date_of_recruitment_ovary` date DEFAULT NULL AFTER last_chart_checked_date_accuracy,
  ADD COLUMN `date_of_recruitment_breast` date DEFAULT NULL AFTER date_of_recruitment_ovary;  
  
ALTER TABLE participants_revs
  ADD COLUMN `chus_cause_of_death` varchar(250) DEFAULT NULL AFTER date_of_death_accuracy,
  ADD COLUMN `chus_date_of_status` date DEFAULT NULL AFTER vital_status,
  ADD COLUMN `chus_date_of_status_accuracy` char(1) NOT NULL DEFAULT '' AFTER chus_date_of_status,
  ADD COLUMN `date_of_recruitment_ovary` date DEFAULT NULL AFTER last_chart_checked_date_accuracy,
  ADD COLUMN `date_of_recruitment_breast` date DEFAULT NULL AFTER date_of_recruitment_ovary;  
    
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'Participant', 'participants', 'chus_cause_of_death', 'input',  NULL , '0', 'size=40', '', '', 'cause of death', ''), 
('Clinicalannotation', 'Participant', 'participants', 'date_of_recruitment_ovary', 'date',  NULL , '0', '', '', '', 'date of recruitment ovary', ''), 
('Clinicalannotation', 'Participant', 'participants', 'date_of_recruitment_breast', 'date',  NULL , '0', '', '', '', 'date of recruitment breast', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='chus_cause_of_death' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=40' AND `default`='' AND `language_help`='' AND `language_label`='cause of death' AND `language_tag`=''), '3', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='date_of_recruitment_ovary' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='date of recruitment ovary' AND `language_tag`=''), '1', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='date_of_recruitment_breast' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='date of recruitment breast' AND `language_tag`=''), '1', '9', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'Participant', 'participants', 'chus_date_of_status', 'date',  NULL , '0', '', '', '', 'chus date of status', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='chus_date_of_status' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='chus date of status' AND `language_tag`=''), '3', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '0', '0', '0', '0', '1', '0');

INSERT INTO i18n (id,en,fr) VALUES 
('chus date of status','Status Date','Date du statut'),
('date of recruitment breast','Date of Recruitment - Breast','Date de recrutement - Sein'),
('date of recruitment ovary','Date of Recruitment - Ovary','Date de recrutement - Ovaire');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'FunctionManagement', '', 'frsq_ov_nbr', 'input',  NULL , '0', '', '', '', '#FRSQ OV', ''),
('Clinicalannotation', 'FunctionManagement', '', 'frsq_br_nbr', 'input',  NULL , '0', '', '', '', '#FRSQ BR', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `field`='frsq_br_nbr' ), '1', '9', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1'),
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `field`='frsq_ov_nbr'), '1', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1');

ALTER TABLE participants
  ADD COLUMN `chus_brca_1` char(1) DEFAULT '' AFTER date_of_recruitment_breast,
  ADD COLUMN `chus_brca_2` char(1) DEFAULT '' AFTER chus_brca_1;
ALTER TABLE participants_revs
  ADD COLUMN `chus_brca_1` char(1) DEFAULT '' AFTER date_of_recruitment_breast,
  ADD COLUMN `chus_brca_2` char(1) DEFAULT '' AFTER chus_brca_1;

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'Participant', 'participants', 'chus_brca_1', 'yes_no',  NULL , '0', '', '', '', 'brca1 mutation', ''), 
('Clinicalannotation', 'Participant', 'participants', 'chus_brca_2', 'yes_no',  NULL , '0', '', '', '', 'brca2 mutation', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='chus_brca_1' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='brca1 mutation' AND `language_tag`=''), '3', '50', 'genetic profile', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='chus_brca_2' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='brca2 mutation' AND `language_tag`=''), '3', '51', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0');

INSERT INTO i18n (id,en,fr) VALUES 
('genetic profile','Genetic Profile','Profil génétique'),
('brca1 mutation','BRCA1 Mutation','Mutation BRAC1'),
('brca2 mutation','BRCA2 Mutation','Mutation BRAC2');

-- --------------------------------------------------------------------------------------------------------
-- MiscIdentifier
-- --------------------------------------------------------------------------------------------------------

INSERT INTO `misc_identifier_controls` (
`id` ,`misc_identifier_name` ,`flag_active` ,`display_order` ,`autoincrement_name` ,`misc_identifier_format` ,`flag_once_per_participant` ,`flag_confidential`)
VALUES 
(NULL , '#FRSQ BR', '1', '1', 'frsq_br', 'BR%%key_increment%%', '1', '0'),
(NULL , '#FRSQ OV', '1', '2', 'frsq_ov', 'OV%%key_increment%%', '1', '0'),
(NULL , 'RAMQ', '1', '3', '', '', '1', '1'),
(NULL , 'hospital number', '1', '4', '', '', '1', '1');

SELECT 'Set key_increments for ov and br #FRSQ' as MSG;

INSERT INTO `key_increments` (`key_name` ,`key_value`)
VALUES ('frsq_ov', '345'), ('frsq_br', '578');

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='miscidentifiers') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='MiscIdentifier' AND `tablename`='misc_identifiers' AND `field`='effective_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='miscidentifiers') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='MiscIdentifier' AND `tablename`='misc_identifiers' AND `field`='expiry_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='miscidentifiers') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='MiscIdentifier' AND `tablename`='misc_identifiers' AND `field`='notes' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE misc_identifier_controls SET flag_once_per_participant = 0 WHERE misc_identifier_name LIKE '#FRSQ%';

-- --------------------------------------------------------------------------------------------------------
-- Consent
-- --------------------------------------------------------------------------------------------------------

UPDATE consent_controls SET flag_active = 0;
INSERT INTO `consent_controls` (`id`, `controls_type`, `flag_active`, `form_alias`, `detail_tablename`, `display_order`, `databrowser_label`) VALUES
(null, 'ovary consent', 1, 'consent_masters', 'cd_nationals', 0, 'ovary consent'),
(null, 'breast consent', 1, 'consent_masters', 'cd_nationals', 0, 'breast consent');
INSERT INTO i18n (id,en,fr) VALUES ('ovary consent','Ovary Consent','Consentement Ovaire'), ('breast consent','Breast Consent','Consentement Sein');

UPDATE structure_formats SET `display_column`='2' WHERE structure_id=(SELECT id FROM structures WHERE alias='consent_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='reason_denied' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='2' WHERE structure_id=(SELECT id FROM structures WHERE alias='consent_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='notes' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- --------------------------------------------------------------------------------------------------------
-- Reproduc. histo.
-- --------------------------------------------------------------------------------------------------------

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='reproductivehistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ReproductiveHistory' AND `tablename`='reproductive_histories' AND `field`='date_captured' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='reproductivehistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ReproductiveHistory' AND `tablename`='reproductive_histories' AND `field`='years_on_hormonal_contraceptives' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='reproductivehistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ReproductiveHistory' AND `tablename`='reproductive_histories' AND `field`='hysterectomy_age' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='reproductivehistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ReproductiveHistory' AND `tablename`='reproductive_histories' AND `field`='hysterectomy' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='indicator') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='reproductivehistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ReproductiveHistory' AND `tablename`='reproductive_histories' AND `field`='ovary_removed_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ovary_removed_type') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='reproductivehistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ReproductiveHistory' AND `tablename`='reproductive_histories' AND `field`='hormonal_contraceptive_use' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='indicator') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='1', `display_order`='1', `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='reproductivehistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ReproductiveHistory' AND `tablename`='reproductive_histories' AND `field`='age_at_first_parturition' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='1', `display_order`='2', `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='reproductivehistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ReproductiveHistory' AND `tablename`='reproductive_histories' AND `field`='age_at_first_parturition_precision' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='age_accuracy') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='1', `display_order`='5', `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='reproductivehistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ReproductiveHistory' AND `tablename`='reproductive_histories' AND `field`='gravida' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='1', `display_order`='6', `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='reproductivehistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ReproductiveHistory' AND `tablename`='reproductive_histories' AND `field`='para' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='2', `display_order`='21', `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='reproductivehistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ReproductiveHistory' AND `tablename`='reproductive_histories' AND `field`='age_at_menopause' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='2', `display_order`='20', `flag_search`='1', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='reproductivehistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ReproductiveHistory' AND `tablename`='reproductive_histories' AND `field`='menopause_status' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='menopause_status') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='2', `display_order`='22' WHERE structure_id=(SELECT id FROM structures WHERE alias='reproductivehistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ReproductiveHistory' AND `tablename`='reproductive_histories' AND `field`='age_at_menopause_precision' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='age_accuracy') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='2', `display_order`='30', `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='reproductivehistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ReproductiveHistory' AND `tablename`='reproductive_histories' AND `field`='menopause_onset_reason' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='menopause_reason') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='40', `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='reproductivehistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ReproductiveHistory' AND `tablename`='reproductive_histories' AND `field`='hrt_use' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='indicator') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='41', `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='reproductivehistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ReproductiveHistory' AND `tablename`='reproductive_histories' AND `field`='hrt_years_used' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='hrt_years_used') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='reproductivehistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ReproductiveHistory' AND `tablename`='reproductive_histories' AND `field`='age_at_last_parturition_precision' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='age_accuracy') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='reproductivehistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ReproductiveHistory' AND `tablename`='reproductive_histories' AND `field`='age_at_first_parturition' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='reproductivehistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ReproductiveHistory' AND `tablename`='reproductive_histories' AND `field`='age_at_last_parturition' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='reproductivehistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ReproductiveHistory' AND `tablename`='reproductive_histories' AND `field`='age_at_first_parturition_precision' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='age_accuracy') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='1', `display_order`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='reproductivehistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ReproductiveHistory' AND `tablename`='reproductive_histories' AND `field`='age_at_menarche' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='1', `display_order`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='reproductivehistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ReproductiveHistory' AND `tablename`='reproductive_histories' AND `field`='age_at_menarche_precision' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='age_accuracy') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='reproductivehistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ReproductiveHistory' AND `tablename`='reproductive_histories' AND `field`='lnmp_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='reproductivehistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ReproductiveHistory' AND `tablename`='reproductive_histories' AND `field`='hysterectomy_age_precision' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='age_accuracy') AND `flag_confidential`='0');

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES
("surgical/induced", "surgical/induced"),
("chemo/radio", "chemo/radio");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) 
VALUES
((SELECT id FROM structure_value_domains WHERE domain_name="menopause_reason"),  
(SELECT id FROM structure_permissible_values WHERE value="surgical/induced" AND language_alias="surgical/induced"), "2", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="menopause_reason"),  
(SELECT id FROM structure_permissible_values WHERE value="chemo/radio" AND language_alias="chemo/radio"), "3", "1");

UPDATE structure_value_domains_permissible_values SET flag_active = 0
WHERE structure_value_domain_id = (SELECT id FROM structure_value_domains WHERE domain_name="menopause_reason")
AND structure_permissible_value_id IN (SELECT id FROM structure_permissible_values WHERE value IN ('radiation','other','surgical','chemical'));

INSERT INTO i18n (id,en,fr) VALUES
('surgical/induced','Surgical/Induced','Chirurgie/Provoquée'),
('chemo/radio','Chemo/Radio','Chimio/Radio');

ALTER TABLE reproductive_histories
  ADD COLUMN `chus_abortus` int(11) DEFAULT NULL AFTER para,
  ADD COLUMN `chus_evista_use` varchar(50) DEFAULT NULL AFTER lnmp_date_accuracy;
ALTER TABLE reproductive_histories_revs
  ADD COLUMN `chus_abortus` int(11) DEFAULT NULL AFTER para,
  ADD COLUMN `chus_evista_use` varchar(50) DEFAULT NULL AFTER lnmp_date_accuracy;

UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='reproductivehistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ReproductiveHistory' AND `tablename`='reproductive_histories' AND `field`='age_at_menarche' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_fields SET type = 'integer_positive', setting = 'size=5', structure_value_domain = null WHERE field = 'hrt_years_used' AND model = 'ReproductiveHistory';

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'ReproductiveHistory', 'reproductive_histories', 'chus_abortus', 'integer_positive', NULL, '0', 'size=5', '', '', 'abortus', ''),
('Clinicalannotation', 'ReproductiveHistory', 'reproductive_histories', 'chus_evista_use', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='indicator') , '0', '', '', '', 'evista use', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='reproductivehistories'), (SELECT id FROM structure_fields WHERE `model`='ReproductiveHistory' AND `field`='chus_abortus'), '1', '7', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'),
((SELECT id FROM structures WHERE alias='reproductivehistories'), (SELECT id FROM structure_fields WHERE `model`='ReproductiveHistory' AND `field`='chus_evista_use'), '2', '50', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0');

INSERT IGNORE INTO i18n (id,en,fr) VALUES ('abortus','Abortus','Abortus'),('evista use','EVISTA® use','EVISTA® use');

-- --------------------------------------------------------------------------------------------------------
-- Event
-- --------------------------------------------------------------------------------------------------------

UPDATE event_controls SET flag_active = 0;
UPDATE menus SET flag_active = '0' WHERE use_link LIKE '%/event_masters/listall/screening%' OR use_link LIKE '%/event_masters/listall/study%';

-- all : life style smoking

INSERT INTO `event_controls` (`disease_site`, `event_group`, `event_type`, `flag_active`, `form_alias`, `detail_tablename`, `display_order`, `databrowser_label`) VALUES
('all', 'lifestyle', 'smoking history questionnaire', 1, 'eventmasters,chus_ed_lifestyle_smoking', 'ed_all_lifestyle_smokings', 0, 'lifestyle|all|smoking history questionnaire');

INSERT INTO structures(`alias`) VALUES ('chus_ed_lifestyle_smoking');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='chus_ed_lifestyle_smoking'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_summary' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='cols=40,rows=6' AND `default`='' AND `language_help`='' AND `language_label`='summary' AND `language_tag`=''), '1', '99', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_ed_lifestyle_smoking'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_all_lifestyle_smokings' AND `field`='smoking_history' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='smoking_history')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='smoking history' AND `language_tag`=''), '1', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_ed_lifestyle_smoking'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_all_lifestyle_smokings' AND `field`='smoking_status' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='smoking_status')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='smoking status' AND `language_tag`=''), '1', '11', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='chus_ed_lifestyle_smoking'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_all_lifestyle_smokings' AND `field`='years_quit_smoking' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=10' AND `default`='' AND `language_help`='' AND `language_label`='years quit smoking' AND `language_tag`=''), '1', '14', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0');

ALTER TABLE ed_all_lifestyle_smokings
  ADD COLUMN chus_quantity_per_day int(11) DEFAULT NULL AFTER years_quit_smoking,
  ADD COLUMN chus_duration_in_years int(11) DEFAULT NULL AFTER chus_quantity_per_day;
  
ALTER TABLE ed_all_lifestyle_smokings_revs
  ADD COLUMN chus_quantity_per_day int(11) DEFAULT NULL AFTER years_quit_smoking,
  ADD COLUMN chus_duration_in_years int(11) DEFAULT NULL AFTER chus_quantity_per_day;

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'EventDetail', 'ed_all_lifestyle_smokings', 'chus_quantity_per_day', 'integer_positive',  NULL , '0', 'size=5', '', '', 'quantity per day', ''), 
('Clinicalannotation', 'EventDetail', 'ed_all_lifestyle_smokings', 'chus_duration_in_years', 'integer_positive',  NULL , '0', 'size=5', '', '', 'duration in years', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='chus_ed_lifestyle_smoking'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_all_lifestyle_smokings' AND `field`='chus_quantity_per_day' AND `type`='integer_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='quantity per day' AND `language_tag`=''), '1', '15', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_ed_lifestyle_smoking'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_all_lifestyle_smokings' AND `field`='chus_duration_in_years' AND `type`='integer_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='duration in years' AND `language_tag`=''), '1', '16', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0');

UPDATE event_controls SET flag_active = 0 WHERE event_group = 'lifestyle' AND event_type = 'smoking';

INSERT INTO i18n (id,en,fr) VALUEs 
('chus','CHUS','CHUS'),
('quantity per day', 'Quantity/Day', 'Quantité/Jour'),
('smoking history questionnaire', 'Smoking History Questionnaire', 'Quesationnaire sur le tabagisme'),
('duration in years', 'Duration (years)', 'Durée (annnées)');

-- all : event followup

INSERT INTO `event_controls` (`disease_site`, `event_group`, `event_type`, `flag_active`, `form_alias`, `detail_tablename`, `display_order`, `databrowser_label`) VALUES
('all', 'clinical', 'followup', 1, 'eventmasters,chus_ed_clinical_followups', 'chus_ed_clinical_followups', 0, 'clinical|all|followup');

CREATE TABLE IF NOT EXISTS `chus_ed_clinical_followups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  
  `weight_in_kg` decimal(6,2) DEFAULT NULL,  
  `weight_in_lbs` decimal(6,2) DEFAULT NULL,  
  `height_in_cm` decimal(6,2) DEFAULT NULL,  
  `height_in_feet` decimal(6,2) DEFAULT NULL,  
  `bmi` decimal(6,2) DEFAULT NULL, 
  
  `event_master_id` int(11) DEFAULT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE IF NOT EXISTS `chus_ed_clinical_followups_revs` (
  `id` int(11) NOT NULL,
  
  `weight_in_kg` decimal(6,2) DEFAULT NULL,  
  `weight_in_lbs` decimal(6,2) DEFAULT NULL,  
  `height_in_cm` decimal(6,2) DEFAULT NULL,  
  `height_in_feet` decimal(6,2) DEFAULT NULL,  
  `bmi` decimal(6,2) DEFAULT NULL, 
  
  `event_master_id` int(11) DEFAULT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`),
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

ALTER TABLE `chus_ed_clinical_followups`
  ADD CONSTRAINT `chus_ed_clinical_followups_ibfk_1` FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`);

INSERT INTO structures(`alias`) VALUES ('chus_ed_clinical_followups');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'EventDetail', 'chus_ed_clinical_followups', 'weight_in_kg', 'float',  NULL , '0', 'size=5', '', '', 'weight', 'kg'), 
('Clinicalannotation', 'EventDetail', 'chus_ed_clinical_followups', 'weight_in_lbs', 'float',  NULL , '0', 'size=5', '', '', '', 'lbs'), 
('Clinicalannotation', 'EventDetail', 'chus_ed_clinical_followups', 'height_in_cm', 'float',  NULL , '0', 'size=5', '', '', 'height', 'cm'), 
('Clinicalannotation', 'EventDetail', 'chus_ed_clinical_followups', 'height_in_feet', 'float',  NULL , '0', 'size=5', '', '', '', 'feet'), 
('Clinicalannotation', 'EventDetail', 'chus_ed_clinical_followups', 'bmi', 'float',  NULL , '0', 'size=5', '', '', 'body_mass_index_initial', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='chus_ed_clinical_followups'), 
(SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_summary' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='cols=40,rows=6' AND `default`='' AND `language_help`='' AND `language_label`='summary' AND `language_tag`=''), '1', '99', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_ed_clinical_followups'), 
(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='chus_ed_clinical_followups' AND `field`='weight_in_kg'), '1', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_ed_clinical_followups'), 
(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='chus_ed_clinical_followups' AND `field`='weight_in_lbs'), '1', '11', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_ed_clinical_followups'), 
(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='chus_ed_clinical_followups' AND `field`='height_in_cm'), '1', '12', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_ed_clinical_followups'), 
(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='chus_ed_clinical_followups' AND `field`='height_in_feet'), '1', '13', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_ed_clinical_followups'), 
(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='chus_ed_clinical_followups' AND `field`='bmi'), '1', '14', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0');

INSERT IGNORE INTO i18n (id,en,fr) VALUES ('kg','Kg','Kg'),('lbs','Lbs','Lbs'),('feet','Feet','Pied'),('cm','Cm','Cm'),('body_mass_index_initial','BMI','IMC');

INSERT IGNORE INTO i18n (id,en,fr) VALUES 
('weight or height can not be equal to 0','The weight or the height can not be equal to 0!','La taille ou le poids ne peut pas être égal à 0!'),
('weights or heights are not consistent','Weights or heights are not consistent!','Les poids et les tailles ne sont pas cohérent(e)s!');

-- all : CT Scan

INSERT INTO `event_controls` (`disease_site`, `event_group`, `event_type`, `flag_active`, `form_alias`, `detail_tablename`, `display_order`, `databrowser_label`) VALUES
('all', 'clinical', 'ctscan', 1, 'eventmasters,chus_ed_clinical_ctscans', 'chus_ed_clinical_ctscans', 0, 'clinical|all|ctscan');

CREATE TABLE IF NOT EXISTS `chus_ed_clinical_ctscans` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  
  `result` varchar(50) DEFAULT NULL, 
  
  `event_master_id` int(11) DEFAULT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE IF NOT EXISTS `chus_ed_clinical_ctscans_revs` (
  `id` int(11) NOT NULL,
  
  `result` varchar(50) DEFAULT NULL, 
  
  `event_master_id` int(11) DEFAULT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`),
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

ALTER TABLE `chus_ed_clinical_ctscans`
  ADD CONSTRAINT `chus_ed_clinical_ctscans_ibfk_1` FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`);

INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('chus_scan_score', '', '', NULL);
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="chus_scan_score"),  (SELECT id FROM structure_permissible_values WHERE value="positive" AND language_alias="positive"), "1", "1");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="chus_scan_score"),  (SELECT id FROM structure_permissible_values WHERE value="negative" AND language_alias="negative"), "1", "1");

INSERT INTO structures(`alias`) VALUES ('chus_ed_clinical_ctscans');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'EventDetail', 'chus_ed_clinical_ctscans', 'result', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='chus_scan_score') , '0', '', '', '', 'result', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='chus_ed_clinical_ctscans'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_summary' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='cols=40,rows=6' AND `default`='' AND `language_help`='' AND `language_label`='summary' AND `language_tag`=''), '1', '99', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_ed_clinical_ctscans'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='chus_ed_clinical_ctscans' AND `field`='result' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='chus_scan_score')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='result' AND `language_tag`=''), '1', '11', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0');

INSERT IGNORE INTO i18n (id,en,fr) VALUES ('ctscan', 'CTScan','CTScan');

-- Ovary : Immuno

INSERT INTO `event_controls` (`disease_site`, `event_group`, `event_type`, `flag_active`, `form_alias`, `detail_tablename`, `display_order`, `databrowser_label`) VALUES
('ovary', 'lab', 'immunohistochemistry', 1, 'eventmasters,chus_ed_lab_ovary_immunos', 'chus_ed_lab_ovary_immunos', 0, 'lab|ovary|immunohistochemistry');

CREATE TABLE IF NOT EXISTS `chus_ed_lab_ovary_immunos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  
  `ER_result` varchar(50) DEFAULT NULL, 
  `PR_result` varchar(50) DEFAULT NULL, 
  `P53_result` varchar(50) DEFAULT NULL, 
  `CA125_result` varchar(50) DEFAULT NULL, 
  
  `event_master_id` int(11) DEFAULT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE IF NOT EXISTS `chus_ed_lab_ovary_immunos_revs` (
  `id` int(11) NOT NULL,
  
  `ER_result` varchar(50) DEFAULT NULL, 
  `PR_result` varchar(50) DEFAULT NULL, 
  `P53_result` varchar(50) DEFAULT NULL, 
  `CA125_result` varchar(50) DEFAULT NULL, 
  
  `event_master_id` int(11) DEFAULT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`),
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

ALTER TABLE `chus_ed_lab_ovary_immunos`
  ADD CONSTRAINT `chus_ed_lab_ovary_immunos_ibfk_1` FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`);

INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('chus_immuno_score', '', '', NULL);
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="chus_immuno_score"),  (SELECT id FROM structure_permissible_values WHERE value="positive" AND language_alias="positive"), "1", "1");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="chus_immuno_score"),  (SELECT id FROM structure_permissible_values WHERE value="negative" AND language_alias="negative"), "1", "1");

INSERT INTO structures(`alias`) VALUES ('chus_ed_lab_ovary_immunos');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'EventDetail', 'chus_ed_lab_ovary_immunos', 'ER_result', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='chus_immuno_score') , '0', '', '', '', 'ER', ''),
('Clinicalannotation', 'EventDetail', 'chus_ed_lab_ovary_immunos', 'PR_result', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='chus_immuno_score') , '0', '', '', '', 'PR', ''),
('Clinicalannotation', 'EventDetail', 'chus_ed_lab_ovary_immunos', 'P53_result', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='chus_immuno_score') , '0', '', '', '', 'P53', ''),
('Clinicalannotation', 'EventDetail', 'chus_ed_lab_ovary_immunos', 'CA125_result', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='chus_immuno_score') , '0', '', '', '', 'CA125', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='chus_ed_lab_ovary_immunos'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_summary' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='cols=40,rows=6' AND `default`='' AND `language_help`='' AND `language_label`='summary' AND `language_tag`=''), '1', '99', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_ed_lab_ovary_immunos'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='chus_ed_lab_ovary_immunos' AND `field`='ER_result'), '1', '11', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_ed_lab_ovary_immunos'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='chus_ed_lab_ovary_immunos' AND `field`='PR_result'), '1', '12', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'),
((SELECT id FROM structures WHERE alias='chus_ed_lab_ovary_immunos'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='chus_ed_lab_ovary_immunos' AND `field`='P53_result'), '1', '13', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'),
((SELECT id FROM structures WHERE alias='chus_ed_lab_ovary_immunos'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='chus_ed_lab_ovary_immunos' AND `field`='CA125_result'), '1', '14', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0');

INSERT IGNORE INTO i18n (id,en,fr) VALUES ('immunohistochemistry', 'Immunohistochemistry','Immunohistochimie');

-- breast : Immuno

INSERT INTO `event_controls` (`disease_site`, `event_group`, `event_type`, `flag_active`, `form_alias`, `detail_tablename`, `display_order`, `databrowser_label`) VALUES
('breast', 'lab', 'immunohistochemistry', 1, 'eventmasters,chus_ed_lab_breast_immunos', 'chus_ed_lab_breast_immunos', 0, 'lab|breast|immunohistochemistry');

CREATE TABLE IF NOT EXISTS `chus_ed_lab_breast_immunos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  
  `ER_result` varchar(50) DEFAULT NULL, 
  `PR_result` varchar(50) DEFAULT NULL, 
  `Her2_Neu_result` varchar(50) DEFAULT NULL, 
  `EGFR_result` varchar(50) DEFAULT NULL, 
  
  `event_master_id` int(11) DEFAULT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE IF NOT EXISTS `chus_ed_lab_breast_immunos_revs` (
  `id` int(11) NOT NULL,
  
  `ER_result` varchar(50) DEFAULT NULL, 
  `PR_result` varchar(50) DEFAULT NULL, 
  `Her2_Neu_result` varchar(50) DEFAULT NULL, 
  `EGFR_result` varchar(50) DEFAULT NULL, 
  
  `event_master_id` int(11) DEFAULT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`),
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

ALTER TABLE `chus_ed_lab_breast_immunos`
  ADD CONSTRAINT `chus_ed_lab_breast_immunos_ibfk_1` FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`);

INSERT INTO structures(`alias`) VALUES ('chus_ed_lab_breast_immunos');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'EventDetail', 'chus_ed_lab_breast_immunos', 'ER_result', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='chus_immuno_score') , '0', '', '', '', 'ER', ''),
('Clinicalannotation', 'EventDetail', 'chus_ed_lab_breast_immunos', 'PR_result', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='chus_immuno_score') , '0', '', '', '', 'PR', ''),
('Clinicalannotation', 'EventDetail', 'chus_ed_lab_breast_immunos', 'Her2_Neu_result', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='chus_immuno_score') , '0', '', '', '', 'Her2/Neu', ''),
('Clinicalannotation', 'EventDetail', 'chus_ed_lab_breast_immunos', 'EGFR_result', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='chus_immuno_score') , '0', '', '', '', 'EGFR', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='chus_ed_lab_breast_immunos'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_summary' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='cols=40,rows=6' AND `default`='' AND `language_help`='' AND `language_label`='summary' AND `language_tag`=''), '1', '99', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_ed_lab_breast_immunos'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='chus_ed_lab_breast_immunos' AND `field`='ER_result'), '1', '11', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_ed_lab_breast_immunos'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='chus_ed_lab_breast_immunos' AND `field`='PR_result'), '1', '12', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'),
((SELECT id FROM structures WHERE alias='chus_ed_lab_breast_immunos'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='chus_ed_lab_breast_immunos' AND `field`='Her2_Neu_result'), '1', '13', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'),
((SELECT id FROM structures WHERE alias='chus_ed_lab_breast_immunos'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='chus_ed_lab_breast_immunos' AND `field`='EGFR_result'), '1', '14', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0');

-- Ovary : CA125

INSERT INTO `event_controls` (`disease_site`, `event_group`, `event_type`, `flag_active`, `form_alias`, `detail_tablename`, `display_order`, `databrowser_label`) VALUES
('ovary', 'lab', 'CA125', 1, 'eventmasters,chus_ed_lab_ovary_ca125_tests', 'chus_ed_lab_ovary_ca125_tests', 0, 'lab|ovary|CA125');

CREATE TABLE IF NOT EXISTS `chus_ed_lab_ovary_ca125_tests` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  
  `value` decimal(5,2) DEFAULT NULL, 
  `at_diagnostic` char(1) DEFAULT '', 
  
  `event_master_id` int(11) DEFAULT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE IF NOT EXISTS `chus_ed_lab_ovary_ca125_tests_revs` (
  `id` int(11) NOT NULL,
  
  `value` decimal(5,2) DEFAULT NULL, 
  `at_diagnostic` char(1) DEFAULT '', 
  
  `event_master_id` int(11) DEFAULT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`),
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

ALTER TABLE `chus_ed_lab_ovary_ca125_tests`
  ADD CONSTRAINT `chus_ed_lab_ovary_ca125_tests_ibfk_1` FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`);

INSERT INTO structures(`alias`) VALUES ('chus_ed_lab_ovary_ca125_tests');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'EventDetail', 'chus_ed_lab_ovary_ca125_tests', 'value', 'float_positive',  NULL , '0', 'size=5', '', '', 'value (u/ml)', ''), 
('Clinicalannotation', 'EventDetail', 'chus_ed_lab_ovary_ca125_tests', 'at_diagnostic', 'yes_no',  NULL , '0', '', '', '', 'at diagnostic', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='chus_ed_lab_ovary_ca125_tests'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_summary' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='cols=40,rows=6' AND `default`='' AND `language_help`='' AND `language_label`='summary' AND `language_tag`=''), '1', '99', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_ed_lab_ovary_ca125_tests'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='chus_ed_lab_ovary_ca125_tests' AND `field`='value'), '1', '11', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_ed_lab_ovary_ca125_tests'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='chus_ed_lab_ovary_ca125_tests' AND `field`='at_diagnostic'), '1', '12', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0');

INSERT IGNORE INTO i18n (id,en,fr) VALUES ('CA125', 'CA125','CA125'),('value (u/ml)','Value (U/mL)','Valeur (U/mL)'),('at diagnostic','At Diagnostic','Au diagnostic');

-- breast : CA153

INSERT INTO `event_controls` (`disease_site`, `event_group`, `event_type`, `flag_active`, `form_alias`, `detail_tablename`, `display_order`, `databrowser_label`) VALUES
('breast', 'lab', 'CA15.3', 1, 'eventmasters,chus_ed_lab_breast_ca153_tests', 'chus_ed_lab_breast_ca153_tests', 0, 'lab|breast|CA15.3');

CREATE TABLE IF NOT EXISTS `chus_ed_lab_breast_ca153_tests` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  
  `value` decimal(5,2) DEFAULT NULL, 
  `at_diagnostic` char(1) DEFAULT '', 
  
  `event_master_id` int(11) DEFAULT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE IF NOT EXISTS `chus_ed_lab_breast_ca153_tests_revs` (
  `id` int(11) NOT NULL,
  
  `value` decimal(5,2) DEFAULT NULL, 
  `at_diagnostic` char(1) DEFAULT '', 
  
  `event_master_id` int(11) DEFAULT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`),
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

ALTER TABLE `chus_ed_lab_breast_ca153_tests`
  ADD CONSTRAINT `chus_ed_lab_breast_ca153_tests_ibfk_1` FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`);

INSERT INTO structures(`alias`) VALUES ('chus_ed_lab_breast_ca153_tests');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'EventDetail', 'chus_ed_lab_breast_ca153_tests', 'value', 'float_positive',  NULL , '0', 'size=5', '', '', 'value (u/ml)', ''), 
('Clinicalannotation', 'EventDetail', 'chus_ed_lab_breast_ca153_tests', 'at_diagnostic', 'yes_no',  NULL , '0', '', '', '', 'at diagnostic', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='chus_ed_lab_breast_ca153_tests'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_summary' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='cols=40,rows=6' AND `default`='' AND `language_help`='' AND `language_label`='summary' AND `language_tag`=''), '1', '99', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_ed_lab_breast_ca153_tests'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='chus_ed_lab_breast_ca153_tests' AND `field`='value'), '1', '11', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_ed_lab_breast_ca153_tests'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='chus_ed_lab_breast_ca153_tests' AND `field`='at_diagnostic'), '1', '12', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0');

INSERT IGNORE INTO i18n (id,en,fr) VALUES ('CA15.3', 'CA15.3','CA15.3');

-- --------------------------------------------------------------------------------------------------------
-- Treatment
-- --------------------------------------------------------------------------------------------------------

UPDATE treatment_controls SET flag_active = 0;

-- OV - Surgery

INSERT INTO `treatment_controls` (`tx_method`, `disease_site`, `flag_active`, `detail_tablename`, `form_alias`, `extend_tablename`, `extend_form_alias`, `display_order`, `applied_protocol_control_id`, `extended_data_import_process`, `databrowser_label`) VALUES
('surgery', 'ovary', 1, 'chus_txd_ovary_surgeries', 'treatmentmasters,chus_txd_ovary_surgeries', NULL, NULL, 0, NULL, NULL, 'ovary|surgery');

DROP TABLE IF EXISTS `chus_txd_ovary_surgeries`;
CREATE TABLE IF NOT EXISTS `chus_txd_ovary_surgeries` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  
  patho_report_number varchar(50) DEFAULT NULL,

  type_HAT_HVAL_HVT char(1) DEFAULT '',
  type_SOG char(1) DEFAULT '',
  type_SOD char(1) DEFAULT '',
  type_SOB char(1) DEFAULT '',
  type_omentectomy char(1) DEFAULT '',
  type_ganglions char(1) DEFAULT '',
  
  ovg_size_cm decimal(5,2) DEFAULT NULL,
  ovd_size_cm decimal(5,2) DEFAULT NULL,
  
  primary_at_surgery_ovary char(1) DEFAULT '',
  primary_at_surgery_fallopian_tube char(1) DEFAULT '',
  primary_at_surgery_omentum char(1) DEFAULT '',
  primary_at_surgery_endometrial char(1) DEFAULT '',
  primary_at_surgery_uterus char(1) DEFAULT '',
  primary_at_surgery_peritoneum char(1) DEFAULT '',
  primary_at_surgery_colon char(1) DEFAULT '',
  primary_at_surgery_breast char(1) DEFAULT '',
  primary_at_surgery_stomach char(1) DEFAULT '',
  primary_at_surgery_hodgkin_lymphoma char(1) DEFAULT '',
  primary_at_surgery_non_hodgkin_lymphoma char(1) DEFAULT '',
  primary_at_surgery_rectum char(1) DEFAULT '',
  primary_at_surgery_appendix char(1) DEFAULT '',
  primary_at_surgery_pancreas char(1) DEFAULT '',
  primary_at_surgery_melanoma char(1) DEFAULT '',
  primary_at_surgery_kidney char(1) DEFAULT '',
  primary_uncertain_at_surgery char(1) DEFAULT '',
  
  cytoreduction varchar(50) DEFAULT NULL,
  
  `treatment_master_id` int(11) NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `tx_master_id` (`treatment_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

DROP TABLE IF EXISTS `chus_txd_ovary_surgeries_revs`;
CREATE TABLE IF NOT EXISTS `chus_txd_ovary_surgeries_revs` (
  `id` int(11) NOT NULL,
  
  patho_report_number varchar(50) DEFAULT NULL,

  type_HAT_HVAL_HVT char(1) DEFAULT '',
  type_SOG char(1) DEFAULT '',
  type_SOD char(1) DEFAULT '',
  type_SOB char(1) DEFAULT '',
  type_omentectomy char(1) DEFAULT '',
  type_ganglions char(1) DEFAULT '',
  
  ovg_size_cm decimal(5,2) DEFAULT NULL,
  ovd_size_cm decimal(5,2) DEFAULT NULL,
  
  primary_at_surgery_ovary char(1) DEFAULT '',
  primary_at_surgery_fallopian_tube char(1) DEFAULT '',
  primary_at_surgery_omentum char(1) DEFAULT '',
  primary_at_surgery_endometrial char(1) DEFAULT '',
  primary_at_surgery_uterus char(1) DEFAULT '',
  primary_at_surgery_peritoneum char(1) DEFAULT '',
  primary_at_surgery_colon char(1) DEFAULT '',
  primary_at_surgery_breast char(1) DEFAULT '',
  primary_at_surgery_stomach char(1) DEFAULT '',
  primary_at_surgery_hodgkin_lymphoma char(1) DEFAULT '',
  primary_at_surgery_non_hodgkin_lymphoma char(1) DEFAULT '',
  primary_at_surgery_rectum char(1) DEFAULT '',
  primary_at_surgery_appendix char(1) DEFAULT '',
  primary_at_surgery_pancreas char(1) DEFAULT '',
  primary_at_surgery_melanoma char(1) DEFAULT '',
  primary_at_surgery_kidney char(1) DEFAULT '',
  primary_uncertain_at_surgery char(1) DEFAULT '',
  
  cytoreduction varchar(50) DEFAULT NULL,
    
  `treatment_master_id` int(11) NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

ALTER TABLE `chus_txd_ovary_surgeries`
  ADD CONSTRAINT `chus_txd_ovary_surgeries_ibfk_1` FOREIGN KEY (`treatment_master_id`) REFERENCES `treatment_masters` (`id`);

INSERT INTO structures(`alias`) VALUES ('chus_txd_ovary_surgeries');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'TreatmentDetail', 'chus_txd_ovary_surgeries', 'patho_report_number', 'input',  NULL , '0', '', '', '', 'patho report number', ''), 
('Clinicalannotation', 'TreatmentDetail', 'chus_txd_ovary_surgeries', 'type_HAT_HVAL_HVT', 'yes_no',  NULL , '0', '', '', '', 'HAT/HVAL/HVT', ''), 
('Clinicalannotation', 'TreatmentDetail', 'chus_txd_ovary_surgeries', 'type_SOG', 'yes_no',  NULL , '0', '', '', '', 'SOG', ''), 
('Clinicalannotation', 'TreatmentDetail', 'chus_txd_ovary_surgeries', 'type_SOD', 'yes_no',  NULL , '0', '', '', '', 'SOD', ''), 
('Clinicalannotation', 'TreatmentDetail', 'chus_txd_ovary_surgeries', 'type_SOB', 'yes_no',  NULL , '0', '', '', '', 'SOB', ''), 
('Clinicalannotation', 'TreatmentDetail', 'chus_txd_ovary_surgeries', 'type_omentectomy', 'yes_no',  NULL , '0', '', '', '', 'omentectomy', ''), 
('Clinicalannotation', 'TreatmentDetail', 'chus_txd_ovary_surgeries', 'type_ganglions', 'yes_no',  NULL , '0', '', '', '', 'ganglions', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='chus_txd_ovary_surgeries'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='notes' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='rows=3,cols=30' AND `default`='' AND `language_help`='help_notes' AND `language_label`='notes' AND `language_tag`=''), '1', '99', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_txd_ovary_surgeries'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='chus_txd_ovary_surgeries' AND `field`='patho_report_number' AND `type`='input'), '1', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_txd_ovary_surgeries'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='chus_txd_ovary_surgeries' AND `field`='type_HAT_HVAL_HVT' AND `type`='yes_no'), '1', '20', 'surgery type', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_txd_ovary_surgeries'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='chus_txd_ovary_surgeries' AND `field`='type_SOG' AND `type`='yes_no'), '1', '21', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_txd_ovary_surgeries'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='chus_txd_ovary_surgeries' AND `field`='type_SOD' AND `type`='yes_no'), '1', '22', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_txd_ovary_surgeries'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='chus_txd_ovary_surgeries' AND `field`='type_SOB' AND `type`='yes_no'), '1', '23', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_txd_ovary_surgeries'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='chus_txd_ovary_surgeries' AND `field`='type_omentectomy' AND `type`='yes_no'), '1', '24', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_txd_ovary_surgeries'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='chus_txd_ovary_surgeries' AND `field`='type_ganglions' AND `type`='yes_no'), '1', '25', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0');

INSERT INTO `structure_value_domains` (`id`, `domain_name`, `override`, `category`, `source`) VALUES (NULL, 'custom_cytoreduction_values', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(''cytoreductions values'')');
INSERT INTO structure_permissible_values_custom_controls (name,flag_active,values_max_length)
VALUES ('cytoreductions values', '1', '50');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `display_order`, `control_id`, `use_as_input`) 
VALUES 
('ND','','', 1, (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'cytoreductions values'), 1),
('none','None','Aucune', 2, (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'cytoreductions values'), 1),
('microscpic','Microscpic','Microscopique', 3, (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'cytoreductions values'), 1),
('>2cm','','', 4, (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'cytoreductions values'), 1),
('<2cm','','', 5, (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'cytoreductions values'), 1),
('<1,5cm','','', 6, (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'cytoreductions values'), 1),
('>1cm','','', 7, (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'cytoreductions values'), 1),
('1cm','','', 8, (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'cytoreductions values'), 1),
('<1cm','','', 9, (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'cytoreductions values'), 1),
('<0,5cm','','', 10, (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'cytoreductions values'), 1),
('<5mm','','', 11, (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'cytoreductions values'), 1),
('<1mm','','', 12, (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'cytoreductions values'), 1);

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'TreatmentDetail', 'chus_txd_ovary_surgeries', 'primary_at_surgery_ovary', 'yes_no',  NULL , '0', '', '', '', 'ovary', ''), 
('Clinicalannotation', 'TreatmentDetail', 'chus_txd_ovary_surgeries', 'primary_at_surgery_fallopian_tube', 'yes_no',  NULL , '0', '', '', '', 'fallopian tube', ''), 
('Clinicalannotation', 'TreatmentDetail', 'chus_txd_ovary_surgeries', 'primary_at_surgery_omentum', 'yes_no',  NULL , '0', '', '', '', 'omentum', ''), 
('Clinicalannotation', 'TreatmentDetail', 'chus_txd_ovary_surgeries', 'primary_at_surgery_endometrial', 'yes_no',  NULL , '0', '', '', '', 'endometrial', ''), 
('Clinicalannotation', 'TreatmentDetail', 'chus_txd_ovary_surgeries', 'primary_at_surgery_uterus', 'yes_no',  NULL , '0', '', '', '', 'uterus', ''), 
('Clinicalannotation', 'TreatmentDetail', 'chus_txd_ovary_surgeries', 'primary_at_surgery_peritoneum', 'yes_no',  NULL , '0', '', '', '', 'peritoneum', ''), 
('Clinicalannotation', 'TreatmentDetail', 'chus_txd_ovary_surgeries', 'primary_at_surgery_colon', 'yes_no',  NULL , '0', '', '', '', 'colon', ''), 
('Clinicalannotation', 'TreatmentDetail', 'chus_txd_ovary_surgeries', 'primary_at_surgery_breast', 'yes_no',  NULL , '0', '', '', '', 'breast', ''), 
('Clinicalannotation', 'TreatmentDetail', 'chus_txd_ovary_surgeries', 'primary_at_surgery_stomach', 'yes_no',  NULL , '0', '', '', '', 'stomach', ''), 
('Clinicalannotation', 'TreatmentDetail', 'chus_txd_ovary_surgeries', 'primary_at_surgery_rectum', 'yes_no',  NULL , '0', '', '', '', 'rectum', ''), 
('Clinicalannotation', 'TreatmentDetail', 'chus_txd_ovary_surgeries', 'primary_at_surgery_appendix', 'yes_no',  NULL , '0', '', '', '', 'appendix', ''), 
('Clinicalannotation', 'TreatmentDetail', 'chus_txd_ovary_surgeries', 'primary_at_surgery_pancreas', 'yes_no',  NULL , '0', '', '', '', 'pancreas', ''), 
('Clinicalannotation', 'TreatmentDetail', 'chus_txd_ovary_surgeries', 'primary_at_surgery_melanoma', 'yes_no',  NULL , '0', '', '', '', 'melanoma', ''), 
('Clinicalannotation', 'TreatmentDetail', 'chus_txd_ovary_surgeries', 'primary_at_surgery_kidney', 'yes_no',  NULL , '0', '', '', '', 'kidney', ''), 
('Clinicalannotation', 'TreatmentDetail', 'chus_txd_ovary_surgeries', 'primary_uncertain_at_surgery', 'yes_no',  NULL , '0', '', '', '', 'primary uncertain at surgery', ''), 
('Clinicalannotation', 'TreatmentDetail', 'chus_txd_ovary_surgeries', 'cytoreduction', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='custom_cytoreduction_values') , '0', '', '', '', 'cytoreduction', ''), 
('Clinicalannotation', 'TreatmentDetail', 'chus_txd_ovary_surgeries', 'ovg_size_cm', 'float',  NULL , '0', 'size=5', '', '', 'ovary size (cm)', 'left'), 
('Clinicalannotation', 'TreatmentDetail', 'chus_txd_ovary_surgeries', 'ovd_size_cm', 'float',  NULL , '0', 'size=5', '', '', 'ovd size cm', 'right'), 
('Clinicalannotation', 'TreatmentDetail', 'chus_txd_ovary_surgeries', 'primary_at_surgery_non_hodgkin_lymphoma', 'yes_no',  NULL , '0', '', '', '', 'non hodgkin lymphoma', ''), 
('Clinicalannotation', 'TreatmentDetail', 'chus_txd_ovary_surgeries', 'primary_at_surgery_hodgkin_lymphoma', 'yes_no',  NULL , '0', '', '', '', 'hodgkin lymphoma', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='chus_txd_ovary_surgeries'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='chus_txd_ovary_surgeries' AND `field`='primary_at_surgery_ovary' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ovary' AND `language_tag`=''), '2', '40', 'primary at surgery', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_txd_ovary_surgeries'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='chus_txd_ovary_surgeries' AND `field`='primary_at_surgery_fallopian_tube' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='fallopian tube' AND `language_tag`=''), '2', '41', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_txd_ovary_surgeries'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='chus_txd_ovary_surgeries' AND `field`='primary_at_surgery_omentum' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='omentum' AND `language_tag`=''), '2', '42', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_txd_ovary_surgeries'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='chus_txd_ovary_surgeries' AND `field`='primary_at_surgery_endometrial' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='endometrial' AND `language_tag`=''), '2', '43', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_txd_ovary_surgeries'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='chus_txd_ovary_surgeries' AND `field`='primary_at_surgery_uterus' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='uterus' AND `language_tag`=''), '2', '44', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_txd_ovary_surgeries'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='chus_txd_ovary_surgeries' AND `field`='primary_at_surgery_peritoneum' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='peritoneum' AND `language_tag`=''), '2', '45', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_txd_ovary_surgeries'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='chus_txd_ovary_surgeries' AND `field`='primary_at_surgery_colon' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='colon' AND `language_tag`=''), '2', '46', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_txd_ovary_surgeries'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='chus_txd_ovary_surgeries' AND `field`='primary_at_surgery_breast' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='breast' AND `language_tag`=''), '2', '47', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_txd_ovary_surgeries'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='chus_txd_ovary_surgeries' AND `field`='primary_at_surgery_stomach' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='stomach' AND `language_tag`=''), '2', '48', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_txd_ovary_surgeries'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='chus_txd_ovary_surgeries' AND `field`='primary_at_surgery_rectum' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='rectum' AND `language_tag`=''), '2', '51', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_txd_ovary_surgeries'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='chus_txd_ovary_surgeries' AND `field`='primary_at_surgery_appendix' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='appendix' AND `language_tag`=''), '2', '52', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_txd_ovary_surgeries'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='chus_txd_ovary_surgeries' AND `field`='primary_at_surgery_pancreas' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='pancreas' AND `language_tag`=''), '2', '53', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_txd_ovary_surgeries'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='chus_txd_ovary_surgeries' AND `field`='primary_at_surgery_melanoma' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='melanoma' AND `language_tag`=''), '2', '54', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_txd_ovary_surgeries'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='chus_txd_ovary_surgeries' AND `field`='primary_at_surgery_kidney' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='kidney' AND `language_tag`=''), '2', '55', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_txd_ovary_surgeries'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='chus_txd_ovary_surgeries' AND `field`='primary_uncertain_at_surgery' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='primary uncertain at surgery' AND `language_tag`=''), '2', '56', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_txd_ovary_surgeries'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='chus_txd_ovary_surgeries' AND `field`='cytoreduction' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_cytoreduction_values')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='cytoreduction' AND `language_tag`=''), '1', '32', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_txd_ovary_surgeries'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='chus_txd_ovary_surgeries' AND `field`='ovg_size_cm' AND `type`='float' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='ovary size (cm)' AND `language_tag`='left'), '1', '30', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_txd_ovary_surgeries'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='chus_txd_ovary_surgeries' AND `field`='ovd_size_cm' AND `type`='float' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='ovd size cm' AND `language_tag`='right'), '1', '31', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_txd_ovary_surgeries'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='chus_txd_ovary_surgeries' AND `field`='primary_at_surgery_non_hodgkin_lymphoma' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='non hodgkin lymphoma' AND `language_tag`=''), '2', '50', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_txd_ovary_surgeries'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='chus_txd_ovary_surgeries' AND `field`='primary_at_surgery_hodgkin_lymphoma' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='hodgkin lymphoma' AND `language_tag`=''), '2', '49', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0');

UPDATE structure_fields SET  `language_label`='' WHERE model='TreatmentDetail' AND tablename='chus_txd_ovary_surgeries' AND field='ovd_size_cm' AND `type`='float' AND structure_value_domain  IS NULL ;
UPDATE structure_formats SET `display_order`='11' WHERE structure_id=(SELECT id FROM structures WHERE alias='chus_txd_ovary_surgeries') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='chus_txd_ovary_surgeries' AND `field`='ovg_size_cm' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='13' WHERE structure_id=(SELECT id FROM structures WHERE alias='chus_txd_ovary_surgeries') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='chus_txd_ovary_surgeries' AND `field`='ovd_size_cm' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='16' WHERE structure_id=(SELECT id FROM structures WHERE alias='chus_txd_ovary_surgeries') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='chus_txd_ovary_surgeries' AND `field`='cytoreduction' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_cytoreduction_values') AND `flag_confidential`='0');

INSERT INTO i18n (id,en,fr) VALUES
('ovary','Ovary','Ovaire'),
('patho report number','Patho. Report #','# Rapport Patho.'),		 
('ovary size (cm)','Ovary Size (Cm)','Taille Ovaire (Cm)'),
('cytoreduction','Cytoreduction','Cytoréduction'),
('surgery type','Surgery Type','Type de chirurgie'),
('HAT/HVAL/HVT','HAT/HVAL/HVT','HAT/HVAL/HVT'),
('SOG','SOG','SOG'),
('SOD','SOD','SOD'),
('SOB','SOB','SOB'),
('omentectomy','Omentectomy','Épiploectomie'),
('ganglions','Ganglions','Ganglions'),
('primary at surgery','Primary at Surgery','Diag. primair à la chirurgie');

UPDATE structure_formats SET `display_column`='3' WHERE structure_id=(SELECT id FROM structures WHERE alias='chus_txd_ovary_surgeries') AND `display_column`='2';
UPDATE structure_formats SET `display_column`='2' WHERE structure_id=(SELECT id FROM structures WHERE alias='chus_txd_ovary_surgeries') AND `display_order` > 19 and  `display_order`  < 28;

INSERT IGNORE INTO i18n (id,en,fr) VALUES
('fallopian tube','Fallopian Tube','Trompe de Fallope'),
('omentum','Omentum','Épiploon'),
('endometrial','Endometrial','Endomètre'),
('uterus','Uterus','Utérus'),
('peritoneum','Peritoneum','Péritoine'),
('hodgkin lymphoma',"Hodgkin's Lymphoma",'Lymphome Hodgkin'),
('non hodgkin lymphoma',"Non-Hodgkin's Lymphoma",'Lymphome Non-Hodgkin'),
('melanoma','Melanoma','Mélanome'),
('kidney','Kidney','Rein'),
('appendix','Appendix','Appendice'),
('primary uncertain at surgery','Uncertain','Incertain');

UPDATE structure_formats SET `display_column`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='chus_txd_ovary_surgeries') AND `display_column`='2';
UPDATE structure_formats SET `display_column`='2' WHERE structure_id=(SELECT id FROM structures WHERE alias='chus_txd_ovary_surgeries') AND `display_column`='3';
UPDATE structure_formats SET `display_order`='17' WHERE structure_id=(SELECT id FROM structures WHERE alias='chus_txd_ovary_surgeries') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='notes' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- OV - Surgery

INSERT INTO `treatment_controls` (`tx_method`, `disease_site`, `flag_active`, `detail_tablename`, `form_alias`, `extend_tablename`, `extend_form_alias`, `display_order`, `applied_protocol_control_id`, `extended_data_import_process`, `databrowser_label`) VALUES
('surgery', 'breast', 1, 'chus_txd_breast_surgeries', 'treatmentmasters,chus_txd_breast_surgeries', NULL, NULL, 0, NULL, NULL, 'breast|surgery');

DROP TABLE IF EXISTS `chus_txd_breast_surgeries`;
CREATE TABLE IF NOT EXISTS `chus_txd_breast_surgeries` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  
  patho_report_number varchar(50) DEFAULT NULL,
  
  laterality varchar(50) DEFAULT NULL,
  
  breast_reduction char(1) DEFAULT '',
  prophylaxis char(1) DEFAULT '',
  partial_mastectomy char(1) DEFAULT '',
  total_mastectomy char(1) DEFAULT '',
  partial_mastectomy_revision char(1) DEFAULT '',  
  axillary_dissection char(1) DEFAULT '',
  biopsy char(1) DEFAULT '',
  
  size_mm decimal(5,2) DEFAULT NULL,
  
  `treatment_master_id` int(11) NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `tx_master_id` (`treatment_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

DROP TABLE IF EXISTS `chus_txd_breast_surgeries_revs`;
CREATE TABLE IF NOT EXISTS `chus_txd_breast_surgeries_revs` (
  `id` int(11) NOT NULL,
  
  patho_report_number varchar(50) DEFAULT NULL,
  
  laterality varchar(50) DEFAULT NULL,
  
  breast_reduction char(1) DEFAULT '',
  prophylaxis char(1) DEFAULT '',
  partial_mastectomy char(1) DEFAULT '',
  total_mastectomy char(1) DEFAULT '',
  partial_mastectomy_revision char(1) DEFAULT '',  
  axillary_dissection char(1) DEFAULT '',
  biopsy char(1) DEFAULT '',
  
  size_mm decimal(5,2) DEFAULT NULL,
    
  `treatment_master_id` int(11) NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

ALTER TABLE `chus_txd_breast_surgeries`
  ADD CONSTRAINT `chus_txd_breast_surgeries_ibfk_1` FOREIGN KEY (`treatment_master_id`) REFERENCES `treatment_masters` (`id`);

INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('chus_laterality', '', '', NULL);
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("bilateral", "bilateral");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="chus_laterality"),  (SELECT id FROM structure_permissible_values WHERE value="right" AND language_alias="right"), "1", "1");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="chus_laterality"),  (SELECT id FROM structure_permissible_values WHERE value="left" AND language_alias="left"), "2", "1");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="chus_laterality"),  (SELECT id FROM structure_permissible_values WHERE value="bilateral" AND language_alias="bilateral"), "3", "1");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="chus_laterality"),  (SELECT id FROM structure_permissible_values WHERE value="unknown" AND language_alias="unknown"), "4", "1");

INSERT INTO structures(`alias`) VALUES ('chus_txd_breast_surgeries');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'TreatmentDetail', 'chus_txd_breast_surgeries', 'patho_report_number', 'input',  NULL , '0', '', '', '', 'patho report number', ''), 
('Clinicalannotation', 'TreatmentDetail', 'chus_txd_breast_surgeries', 'laterality', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='chus_laterality') , '0', '', '', '', 'laterality', ''), 
('Clinicalannotation', 'TreatmentDetail', 'chus_txd_breast_surgeries', 'breast_reduction', 'yes_no',  NULL , '0', '', '', '', 'breast reduction', ''), 
('Clinicalannotation', 'TreatmentDetail', 'chus_txd_breast_surgeries', 'prophylaxis', 'yes_no',  NULL , '0', '', '', '', 'prophylaxis', ''), 
('Clinicalannotation', 'TreatmentDetail', 'chus_txd_breast_surgeries', 'partial_mastectomy', 'yes_no',  NULL , '0', '', '', '', 'partial mastectomy', ''), 
('Clinicalannotation', 'TreatmentDetail', 'chus_txd_breast_surgeries', 'total_mastectomy', 'yes_no',  NULL , '0', '', '', '', 'total mastectomy', ''), 
('Clinicalannotation', 'TreatmentDetail', 'chus_txd_breast_surgeries', 'partial_mastectomy_revision', 'yes_no',  NULL , '0', '', '', '', 'partial mastectomy revision', ''), 
('Clinicalannotation', 'TreatmentDetail', 'chus_txd_breast_surgeries', 'axillary_dissection', 'yes_no',  NULL , '0', '', '', '', 'axillary dissection', ''), 
('Clinicalannotation', 'TreatmentDetail', 'chus_txd_breast_surgeries', 'biopsy', 'yes_no',  NULL , '0', '', '', '', 'biopsy', ''), 
('Clinicalannotation', 'TreatmentDetail', 'chus_txd_breast_surgeries', 'size_mm', 'float_positive',  NULL , '0', 'size=5', '', '', 'size mm', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='chus_txd_breast_surgeries'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='chus_txd_breast_surgeries' AND `field`='patho_report_number' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='patho report number' AND `language_tag`=''), '1', '30', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_txd_breast_surgeries'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='chus_txd_breast_surgeries' AND `field`='laterality' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='chus_laterality')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='laterality' AND `language_tag`=''), '1', '31', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_txd_breast_surgeries'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='chus_txd_breast_surgeries' AND `field`='breast_reduction' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='breast reduction' AND `language_tag`=''), '2', '50', 'surgery type', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_txd_breast_surgeries'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='chus_txd_breast_surgeries' AND `field`='prophylaxis' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='prophylaxis' AND `language_tag`=''), '2', '51', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_txd_breast_surgeries'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='chus_txd_breast_surgeries' AND `field`='partial_mastectomy' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='partial mastectomy' AND `language_tag`=''), '2', '52', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_txd_breast_surgeries'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='chus_txd_breast_surgeries' AND `field`='total_mastectomy' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='total mastectomy' AND `language_tag`=''), '2', '53', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_txd_breast_surgeries'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='chus_txd_breast_surgeries' AND `field`='partial_mastectomy_revision' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='partial mastectomy revision' AND `language_tag`=''), '2', '54', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_txd_breast_surgeries'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='chus_txd_breast_surgeries' AND `field`='axillary_dissection' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='axillary dissection' AND `language_tag`=''), '2', '55', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_txd_breast_surgeries'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='chus_txd_breast_surgeries' AND `field`='biopsy' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='biopsy' AND `language_tag`=''), '2', '56', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_txd_breast_surgeries'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='chus_txd_breast_surgeries' AND `field`='size_mm' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='size mm' AND `language_tag`=''), '1', '35', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0');

INSERT IGNORE INTO i18n (id,en,fr) VALUES
('bilateral','Bilateral','Bilatérale'),
('size mm','Size (mm)','Taille (mm)'),
('breast reduction','Breast Reduction','Réduction mammaire'),
('prophylaxis','Prophylaxis','Prophylaxie'),
('partial mastectomy','Partial Mastectomy','Mastectomie partielle'),
('total mastectomy','Total Mastectomy','Mastectomie Totale'),
('partial mastectomy revision','Partial Mastectomy - Revision','Mastectomie partielle - Révision'),
('axillary dissection','Axillary Dissection','Évidement axillaire');

REPLACE INTO i18n (id,en,fr) VALUES ('bilateral','Bilateral','Bilatérale'),('biopsy','Biopsy','Biopsie');

-- OV/Breast - Radiation

INSERT INTO `treatment_controls` (`tx_method`, `disease_site`, `flag_active`, `detail_tablename`, `form_alias`, `extend_tablename`, `extend_form_alias`, `display_order`, `applied_protocol_control_id`, `extended_data_import_process`, `databrowser_label`) VALUES
('radiation', 'ovary', 1, 'chus_txd_radiations', 'treatmentmasters,chus_txd_radiations', NULL, NULL, 0, NULL, NULL, 'ovary|radiation'),
('radiation', 'breast', 1, 'chus_txd_radiations', 'treatmentmasters,chus_txd_radiations', NULL, NULL, 0, NULL, NULL, 'breast|radiation');

DROP TABLE IF EXISTS `chus_txd_radiations`;
CREATE TABLE IF NOT EXISTS `chus_txd_radiations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  
  pre_post_surgery varchar(50) DEFAULT NULL,
  
  `treatment_master_id` int(11) NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `tx_master_id` (`treatment_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

DROP TABLE IF EXISTS `chus_txd_radiations_revs`;
CREATE TABLE IF NOT EXISTS `chus_txd_radiations_revs` (
  `id` int(11) NOT NULL,
  
  pre_post_surgery varchar(50) DEFAULT NULL,
  
  `treatment_master_id` int(11) NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

ALTER TABLE `chus_txd_radiations`
  ADD CONSTRAINT `chus_txd_radiations_ibfk_1` FOREIGN KEY (`treatment_master_id`) REFERENCES `treatment_masters` (`id`);

INSERT INTO structures(`alias`) VALUES ('chus_txd_radiations');

INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('pre_post_surgery', '', '', NULL);
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("pre", "pre surgery");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="pre_post_surgery"),  (SELECT id FROM structure_permissible_values WHERE value="pre" AND language_alias="pre surgery"), "1", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("post", "post surgery");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="pre_post_surgery"),  (SELECT id FROM structure_permissible_values WHERE value="post" AND language_alias="post surgery"), "2", "1");

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'TreatmentDetail', 'chus_txd_radiations', 'pre_post_surgery', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='pre_post_surgery') , '0', '', '', '', 'pre post surgery', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='chus_txd_radiations'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='finish_date'), '1', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_txd_radiations'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='notes'), '1', '99', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_txd_radiations'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='chus_txd_radiations' AND `field`='pre_post_surgery' AND `type`='select'), '1', '50', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0');

INSERT INTO i18n (id,en,fr) VALUES ('pre post surgery', 'Pre/Post surgery', 'Pré/Post Chirurgie'),('pre surgery', 'Pre', 'Pré'),('post surgery', 'Post', 'Post');

-- OV/Breast - Chemotherapy

INSERT INTO `treatment_controls` (`tx_method`, `disease_site`, `flag_active`, `detail_tablename`, `form_alias`, `extend_tablename`, `extend_form_alias`, `display_order`, `applied_protocol_control_id`, `extended_data_import_process`, `databrowser_label`) VALUES
('chemotherapy', 'ovary', 1, 'chus_txd_chemos', 'treatmentmasters,chus_txd_chemos', NULL, NULL, 0, NULL, NULL, 'ovary|chemotherapy'),
('chemotherapy', 'breast', 1, 'chus_txd_chemos', 'treatmentmasters,chus_txd_chemos', NULL, NULL, 0, NULL, NULL, 'breast|chemotherapy');

DROP TABLE IF EXISTS `chus_txd_chemos`;
CREATE TABLE IF NOT EXISTS `chus_txd_chemos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,

  `chemo_completed` varchar(50) DEFAULT NULL,
  `response` varchar(50) DEFAULT NULL,
  `num_cycles` int(11) DEFAULT NULL,
  `length_cycles` int(11) DEFAULT NULL,
  `completed_cycles` int(11) DEFAULT NULL,  
  `pre_post_surgery` varchar(50) DEFAULT NULL,
  
  `treatment_master_id` int(11) NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `tx_master_id` (`treatment_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

DROP TABLE IF EXISTS `chus_txd_chemos_revs`;
CREATE TABLE IF NOT EXISTS `chus_txd_chemos_revs` (
  `id` int(11) NOT NULL,
  
  `chemo_completed` varchar(50) DEFAULT NULL,
  `response` varchar(50) DEFAULT NULL,
  `num_cycles` int(11) DEFAULT NULL,
  `length_cycles` int(11) DEFAULT NULL,
  `completed_cycles` int(11) DEFAULT NULL,  
  `pre_post_surgery` varchar(50) DEFAULT NULL,
  
  `treatment_master_id` int(11) NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

ALTER TABLE `chus_txd_chemos`
  ADD CONSTRAINT `chus_txd_chemos_ibfk_1` FOREIGN KEY (`treatment_master_id`) REFERENCES `treatment_masters` (`id`);

INSERT INTO structures(`alias`) VALUES ('chus_txd_chemos');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'TreatmentDetail', 'chus_txd_chemos', 'pre_post_surgery', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='pre_post_surgery') , '0', '', '', '', 'pre post surgery', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='chus_txd_chemos'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='finish_date'), '1', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_txd_chemos'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='notes'), '1', '99', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_txd_chemos'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='chus_txd_chemos' AND `field`='pre_post_surgery' AND `type`='select'), '1', '50', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0');

UPDATE treatment_controls SET extend_tablename = 'txe_chemos', extend_form_alias ='txe_chemos', applied_protocol_control_id = '1', extended_data_import_process = 'importDrugFromChemoProtocol' WHERE tx_method = 'chemotherapy' AND disease_site IN ('ovary','breast');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='chus_txd_chemos'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='protocol_master_id' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='protocol_site_list')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_protocol_name' AND `language_label`='protocol' AND `language_tag`=''), '1', '9', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='chus_txd_chemos'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_chemos' AND `field`='chemo_completed' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yesno')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_chemo_completed' AND `language_label`='completed' AND `language_tag`=''), '1', '11', 'chemotherapy specific', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='chus_txd_chemos'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_chemos' AND `field`='response' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='response')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_response' AND `language_label`='response' AND `language_tag`=''), '1', '12', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='chus_txd_chemos'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_chemos' AND `field`='num_cycles' AND `type`='integer_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='help_num_cycles' AND `language_label`='number cycles' AND `language_tag`=''), '1', '13', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='chus_txd_chemos'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_chemos' AND `field`='length_cycles' AND `type`='integer_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='help_length_cycles' AND `language_label`='length cycles' AND `language_tag`=''), '1', '14', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='chus_txd_chemos'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_chemos' AND `field`='completed_cycles' AND `type`='integer_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='help_completed_cycles' AND `language_label`='completed cycles' AND `language_tag`=''), '1', '15', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1');

UPDATE structure_formats SET `display_order`='10' WHERE structure_id=(SELECT id FROM structures WHERE alias='chus_txd_chemos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='chus_txd_chemos' AND `field`='pre_post_surgery' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='pre_post_surgery') AND `flag_confidential`='0');

-- Breast - hormonotherapy

INSERT INTO `treatment_controls` (`tx_method`, `disease_site`, `flag_active`, `detail_tablename`, `form_alias`, `extend_tablename`, `extend_form_alias`, `display_order`, `applied_protocol_control_id`, `extended_data_import_process`, `databrowser_label`) VALUES
('hormonotherapy', 'breast', 1, 'chus_txd_hormonos', 'treatmentmasters,chus_txd_hormonos', NULL, NULL, 0, NULL, NULL, 'breast|hormonotherapy');

DROP TABLE IF EXISTS `chus_txd_hormonos`;
CREATE TABLE IF NOT EXISTS `chus_txd_hormonos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  
  pre_post_surgery varchar(50) DEFAULT NULL,
  
  `treatment_master_id` int(11) NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `tx_master_id` (`treatment_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

DROP TABLE IF EXISTS `chus_txd_hormonos_revs`;
CREATE TABLE IF NOT EXISTS `chus_txd_hormonos_revs` (
  `id` int(11) NOT NULL,
  
  pre_post_surgery varchar(50) DEFAULT NULL,
  
  `treatment_master_id` int(11) NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

ALTER TABLE `chus_txd_hormonos`
  ADD CONSTRAINT `chus_txd_hormonos_ibfk_1` FOREIGN KEY (`treatment_master_id`) REFERENCES `treatment_masters` (`id`);

INSERT INTO structures(`alias`) VALUES ('chus_txd_hormonos');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'TreatmentDetail', 'chus_txd_hormonos', 'pre_post_surgery', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='pre_post_surgery') , '0', '', '', '', 'pre post surgery', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='chus_txd_hormonos'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='finish_date'), '1', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_txd_hormonos'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='notes'), '1', '99', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_txd_hormonos'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='chus_txd_chemos' AND `field`='pre_post_surgery' AND `type`='select'), '1', '50', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0');

-- --------------------------------------------------------------------------------------------------------
-- Diagnosis
-- --------------------------------------------------------------------------------------------------------

UPDATE diagnosis_controls SET flag_active = 0 WHERE controls_type IN ('blood','tissue');

UPDATE structure_formats SET `flag_search`='0', `flag_index`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_diagnosis') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='topography');

-- Primary

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_primary') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_method' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='dx_method') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_primary') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='information_source' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='information_source') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_primary') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='topography' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_primary') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='survival_time_months' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_primary') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='morphology' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

INSERT INTO structures(`alias`) VALUES ('chus_dx_undetailed_primary');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='dx_primary'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='age_at_dx' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '6', '', '0', '', '0', '', '1', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'),
((SELECT id FROM structures WHERE alias='dx_primary'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='age_at_dx_precision' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='age_accuracy')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`=''), '1', '7', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');

INSERT INTO `structure_value_domains` (`id`, `domain_name`, `override`, `category`, `source`) VALUES (NULL, 'chus_dx_nature', 'open', '', NULL);
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES ("benign", "benign"),('borderline','borderline'), ('cancer','cancer');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES
((SELECT id FROM structure_value_domains WHERE domain_name="chus_dx_nature"),
(SELECT id FROM structure_permissible_values WHERE value="benign" AND language_alias="benign"), "1", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="chus_dx_nature"),
(SELECT id FROM structure_permissible_values WHERE value="borderline" AND language_alias="borderline"), "2", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="chus_dx_nature"),
(SELECT id FROM structure_permissible_values WHERE value="cancer" AND language_alias="cancer"), "3", "1");
INSERT IGNORE INTO i18n (id,en,fr) VALUES ('benign','Benign','Bénin'), ('borderline','Borderline','Borderline'),('cancer','Cancer','Cancer');
UPDATE structure_fields SET structure_value_domain = (SELECT id FROM structure_value_domains WHERE domain_name='chus_dx_nature') WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_nature' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='dx_nature') ;
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='dx_primary'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_nature' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='chus_dx_nature')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_dx nature' AND `language_label`='dx nature' AND `language_tag`=''), '1', '9', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1'); 

INSERT INTO `diagnosis_controls` (`category`, `controls_type`, `flag_active`, `form_alias`, `detail_tablename`, `display_order`, `databrowser_label`, `flag_compare_with_cap`) VALUES
('primary', 'undetailed', 1, 'diagnosismasters,dx_primary', 'dxd_primaries', 0, 'xxx', 1),
('primary', 'fallopian tube', 1, 'diagnosismasters,dx_primary', 'dxd_primaries', 0, 'xxx', 1),
('primary', 'omentum', 1, 'diagnosismasters,dx_primary', 'dxd_primaries', 0, 'xxx', 1),
('primary', 'endometrial', 1, 'diagnosismasters,dx_primary', 'dxd_primaries', 0, 'xxx', 1),
('primary', 'uterus', 1, 'diagnosismasters,dx_primary', 'dxd_primaries', 0, 'xxx', 1),
('primary', 'peritoneum', 1, 'diagnosismasters,dx_primary', 'dxd_primaries', 0, 'xxx', 1),
('primary', 'colon', 1, 'diagnosismasters,dx_primary', 'dxd_primaries', 0, 'xxx', 1),
('primary', 'stomach', 1, 'diagnosismasters,dx_primary', 'dxd_primaries', 0, 'xxx', 1),
('primary', 'hodgkin lymphoma', 1, 'diagnosismasters,dx_primary', 'dxd_primaries', 0, 'xxx', 1),
('primary', 'non hodgkin lymphoma', 1, 'diagnosismasters,dx_primary', 'dxd_primaries', 0, 'xxx', 1),
('primary', 'rectum', 1, 'diagnosismasters,dx_primary', 'dxd_primaries', 0, 'xxx', 1),
('primary', 'appendix', 1, 'diagnosismasters,dx_primary', 'dxd_primaries', 0, 'xxx', 1),
('primary', 'pancreas', 1, 'diagnosismasters,dx_primary', 'dxd_primaries', 0, 'xxx', 1),
('primary', 'melanoma', 1, 'diagnosismasters,dx_primary', 'dxd_primaries', 0, 'xxx', 1),
('primary', 'kidney', 1, 'diagnosismasters,dx_primary', 'dxd_primaries', 0, 'xxx', 1);

UPDATE diagnosis_controls SET databrowser_label = CONCAT(category,'|',controls_type) WHERE databrowser_label = 'xxx';

-- secondary

UPDATE structure_formats SET `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_secondary') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='morphology' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_secondary') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_method' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='dx_method') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_secondary') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='information_source' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='information_source') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_secondary') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='topography' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_secondary') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='morphology' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_secondary') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_method' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='dx_method') AND `flag_confidential`='0');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='dx_secondary'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='age_at_dx' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '6', '', '0', '', '0', '', '1', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'),
((SELECT id FROM structures WHERE alias='dx_secondary'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='age_at_dx_precision' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='age_accuracy')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`=''), '1', '7', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');

INSERT INTO `diagnosis_controls` (`category`, `controls_type`, `flag_active`, `form_alias`, `detail_tablename`, `display_order`, `databrowser_label`, `flag_compare_with_cap`) VALUES
('secondary', 'peritoneum', 1, 'diagnosismasters,dx_secondary', 'dxd_secondaries', 0, 'xxx', 1),
('secondary', 'omentum', 1, 'diagnosismasters,dx_secondary', 'dxd_secondaries', 0, 'xxx', 1),
('secondary', 'fornix', 1, 'diagnosismasters,dx_secondary', 'dxd_secondaries', 0, 'xxx', 1),
('secondary', 'colon', 1, 'diagnosismasters,dx_secondary', 'dxd_secondaries', 0, 'xxx', 1),
('secondary', 'small intestine', 1, 'diagnosismasters,dx_secondary', 'dxd_secondaries', 0, 'xxx', 1),
('secondary', 'ganglion', 1, 'diagnosismasters,dx_secondary', 'dxd_secondaries', 0, 'xxx', 1),
('secondary', 'stomach', 1, 'diagnosismasters,dx_secondary', 'dxd_secondaries', 0, 'xxx', 1),
('secondary', 'brain', 1, 'diagnosismasters,dx_secondary', 'dxd_secondaries', 0, 'xxx', 1),	
('secondary', 'bone', 1, 'diagnosismasters,dx_secondary', 'dxd_secondaries', 0, 'xxx', 1),
('secondary', 'rectum', 1, 'diagnosismasters,dx_secondary', 'dxd_secondaries', 0, 'xxx', 1),
('secondary', 'lung', 1, 'diagnosismasters,dx_secondary', 'dxd_secondaries', 0, 'xxx', 1),
('secondary', 'liver', 1, 'diagnosismasters,dx_secondary', 'dxd_secondaries', 0, 'xxx', 1);

UPDATE diagnosis_controls SET databrowser_label = CONCAT(category,'|',controls_type) WHERE databrowser_label = 'xxx';
	
INSERT INTO i18n (id,en,fr) VALUES 
('fornix', 'Fornix','Cul-de-sac'),
('small intestine','Small Intestine','Grêle');

-- OVARY

INSERT INTO `diagnosis_controls` (`category`, `controls_type`, `flag_active`, `form_alias`, `detail_tablename`, `display_order`, `databrowser_label`, `flag_compare_with_cap`) VALUES
('primary', 'ovary', 1, 'diagnosismasters,dx_primary,chus_dx_ovary', 'dxd_primaries', 0, 'primary|ovary', 1),
('secondary', 'ovary', 1, 'diagnosismasters,dx_secondary,chus_dx_ovary', 'dxd_primaries', 0, 'secondary|ovary', 1);

CREATE TABLE IF NOT EXISTS `chus_dxd_ovaries` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `diagnosis_master_id` int(11) NOT NULL DEFAULT '0',
  
  `laterality` varchar(50) NOT NULL DEFAULT '',
  `atcd` char(1) DEFAULT '',
  `atcd_description` varchar(250) NOT NULL DEFAULT '',
  `morphology` varchar(250) NOT NULL DEFAULT '',
  `stage` varchar(50) NOT NULL DEFAULT '',
    
  `deleted` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `diagnosis_master_id` (`diagnosis_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE IF NOT EXISTS `chus_dxd_ovaries_revs` (
  `id` int(11) NOT NULL,
  `diagnosis_master_id` int(11) NOT NULL DEFAULT '0',
  
  `laterality` varchar(50) NOT NULL DEFAULT '',
  `atcd` char(1) DEFAULT '',
  `atcd_description` varchar(250) NOT NULL DEFAULT '',
  `morphology` varchar(250) NOT NULL DEFAULT '',
  `stage` varchar(50) NOT NULL DEFAULT '',
  
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

ALTER TABLE `chus_dxd_ovaries`
  ADD CONSTRAINT `chus_dxd_ovaries_ibfk_1` FOREIGN KEY (`diagnosis_master_id`) REFERENCES `diagnosis_masters` (`id`);

INSERT INTO structures(`alias`) VALUES ('chus_dx_ovary');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'DiagnosisDetail', 'chus_dxd_ovaries', 'laterality', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='laterality') , '0', '', '', 'dx_laterality', 'laterality', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='chus_dx_ovary'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='tumour_grade' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tumour grade')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_tumour grade' AND `language_label`='tumour grade' AND `language_tag`=''), '1', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_dx_ovary'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='clinical_tstage' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=1,maxlength=3' AND `default`='' AND `language_help`='' AND `language_label`='clinical stage' AND `language_tag`='t stage'), '2', '19', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_dx_ovary'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='clinical_nstage' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=1,maxlength=3' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='n stage'), '2', '20', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_dx_ovary'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='clinical_mstage' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=1,maxlength=3' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='m stage'), '2', '21', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_dx_ovary'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='clinical_stage_summary' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=1,maxlength=3' AND `default`='' AND `language_help`='help_clinical_stage_summary' AND `language_label`='' AND `language_tag`='summary'), '2', '22', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_dx_ovary'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_tstage' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=1,maxlength=3' AND `default`='' AND `language_help`='' AND `language_label`='pathological stage' AND `language_tag`='t stage'), '2', '23', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_dx_ovary'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_nstage' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=1,maxlength=3' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='n stage'), '2', '24', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_dx_ovary'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_mstage' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=1,maxlength=3' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='m stage'), '2', '24', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_dx_ovary'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_stage_summary' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=1, maxlength=3' AND `default`='' AND `language_help`='help_path_stage_summary' AND `language_label`='' AND `language_tag`='summary'), '2', '25', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_dx_ovary'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='chus_dxd_ovaries' AND `field`='laterality' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='laterality')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='dx_laterality' AND `language_label`='laterality' AND `language_tag`=''), '2', '99', 'tissue specific', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0');

INSERT INTO `structure_value_domains` (`id`, `domain_name`, `override`, `category`, `source`) VALUES (NULL, 'chus_custom_tumour_grade', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(''tumour grades'')');
INSERT INTO structure_permissible_values_custom_controls (name,flag_active,values_max_length) VALUES ('tumour grades', '1', '150');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `display_order`, `control_id`, `use_as_input`) 
VALUES 
('1','','', 1, (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'tumour grades'), 1),
('2','','', 2, (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'tumour grades'), 1),
('3','','', 4, (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'tumour grades'), 1),
('1-2','','', 5, (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'tumour grades'), 1),
('2-3','','', 6, (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'tumour grades'), 1),
('1,3','','', 7, (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'tumour grades'), 1),
('LMP','','', 11, (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'tumour grades'), 1),
('ND','','', 12, (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'tumour grades'), 1);
UPDATE structure_fields SET structure_value_domain = (SELECT id FROM structure_value_domains WHERE domain_name='chus_custom_tumour_grade') WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='tumour_grade' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tumour grade');

UPDATE structure_formats SET `language_heading`='staging' WHERE structure_id=(SELECT id FROM structures WHERE alias='chus_dx_ovary') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='clinical_tstage' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

INSERT INTO `structure_value_domains` (`id`, `domain_name`, `override`, `category`, `source`) VALUES (NULL, 'chus_dx_stage', 'open', '', NULL);
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES
('I','I'),
('Ia', 'Ia'),
('Ib', 'Ib'),
('Ic', 'Ic'),
('II','II'),
('IIa', 'IIa'),
('IIb', 'IIb'),
('IIc', 'IIc'),
('III','III'),
('IIIa', 'IIIa'),
('IIIb', 'IIIb'),
('IIIc', 'IIIc'),
('IV', 'IV'),
('unknown', 'unknown');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) 
VALUES
((SELECT id FROM structure_value_domains WHERE domain_name="chus_dx_stage"),(SELECT id FROM structure_permissible_values WHERE value="I" AND language_alias="I"), "1", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="chus_dx_stage"),(SELECT id FROM structure_permissible_values WHERE value="Ia" AND language_alias="Ia"), "2", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="chus_dx_stage"),(SELECT id FROM structure_permissible_values WHERE value="Ib" AND language_alias="Ib"), "3", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="chus_dx_stage"),(SELECT id FROM structure_permissible_values WHERE value="Ic" AND language_alias="Ic"), "4", "1"),

((SELECT id FROM structure_value_domains WHERE domain_name="chus_dx_stage"),(SELECT id FROM structure_permissible_values WHERE value="II" AND language_alias="II"), "13", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="chus_dx_stage"),(SELECT id FROM structure_permissible_values WHERE value="IIa" AND language_alias="IIa"), "14", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="chus_dx_stage"),(SELECT id FROM structure_permissible_values WHERE value="IIb" AND language_alias="IIb"), "15", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="chus_dx_stage"),(SELECT id FROM structure_permissible_values WHERE value="IIc" AND language_alias="IIc"), "16", "1"),

((SELECT id FROM structure_value_domains WHERE domain_name="chus_dx_stage"),(SELECT id FROM structure_permissible_values WHERE value="III" AND language_alias="III"), "26", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="chus_dx_stage"),(SELECT id FROM structure_permissible_values WHERE value="IIIa" AND language_alias="IIIa"), "27", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="chus_dx_stage"),(SELECT id FROM structure_permissible_values WHERE value="IIIb" AND language_alias="IIIb"), "28", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="chus_dx_stage"),(SELECT id FROM structure_permissible_values WHERE value="IIIc" AND language_alias="IIIc"), "29", "1"),

((SELECT id FROM structure_value_domains WHERE domain_name="chus_dx_stage"),(SELECT id FROM structure_permissible_values WHERE value="IV" AND language_alias="IV"), "40", "1"),

((SELECT id FROM structure_value_domains WHERE domain_name="chus_dx_stage"),(SELECT id FROM structure_permissible_values WHERE value="unknown" AND language_alias="unknown"), "51", "1");

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'DiagnosisDetail', 'chus_dxd_ovaries', 'atcd', 'yes_no',  NULL , '0', '', '', '', 'atcd', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'chus_dxd_ovaries', 'atcd_description', 'input',  NULL , '0', 'size=30', '', '', '', 'description'), 
('Clinicalannotation', 'DiagnosisDetail', 'chus_dxd_ovaries', 'stage', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='chus_dx_stage') , '0', '', '', '', 'stage', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='chus_dx_ovary'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='chus_dxd_ovaries' AND `field`='atcd' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='atcd' AND `language_tag`=''), '1', '8', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_dx_ovary'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='chus_dxd_ovaries' AND `field`='atcd_description' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='description'), '1', '9', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_dx_ovary'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='chus_dxd_ovaries' AND `field`='stage' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='chus_dx_stage')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='stage' AND `language_tag`=''), '2', '26', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0');

INSERT IGNORE INTO i18n (id,en,fr) VALUEs ('atcd','ATCD','ATCD'),('stage','Stage','Stade');

INSERT INTO `structure_value_domains` (`id`, `domain_name`, `override`, `category`, `source`) VALUES (NULL, 'chus_custom_ovary_dx_morphology', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(''ovary diagnosis morphology'')');
INSERT INTO structure_permissible_values_custom_controls (name,flag_active,values_max_length) VALUES ('ovary diagnosis morphology', '1', '250');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `display_order`, `control_id`, `use_as_input`) 
VALUES 
('serous','Serous','Séreux', 1, (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'ovary diagnosis morphology'), 1),
('papillary','Papillary','Papillaire', 1, (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'ovary diagnosis morphology'), 1),
('mucinous','Mucinous','Mucineux', 1, (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'ovary diagnosis morphology'), 1),
('endometrioid/endometriotic/endometriosis','Endometrioid/Endometriotic/Endometriosis','Endométrioide/Endométriotique/Endométriosique', 1, (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'ovary diagnosis morphology'), 1),
('squamous','Squamous','Malpighien', 1, (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'ovary diagnosis morphology'), 1),
('Krukenberg','Krukenberg','Krukenberg', 1, (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'ovary diagnosis morphology'), 1),
('mullerian','Mullerian','Mullerien', 1, (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'ovary diagnosis morphology'), 1),
('granulosa','Granulosa','Granulosa', 1, (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'ovary diagnosis morphology'), 1),
('squamous/dermoid','Squamous/Dermoid','Épidermoide/Dermoide', 1, (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'ovary diagnosis morphology'), 1),
('mature teratoma','Mature Teratoma','Tératome Mature', 1, (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'ovary diagnosis morphology'), 1),
('immature teratoma','Immature Teratoma','Tératome Immature', 1, (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'ovary diagnosis morphology'), 1),
('brenner','Brenner','Brenner', 1, (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'ovary diagnosis morphology'), 1),
('neuroendocrine','Neuroendocrine','Neuroendocrine', 1, (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'ovary diagnosis morphology'), 1),
('sarcoma','Sarcoma','Sarcome', 1, (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'ovary diagnosis morphology'), 1),
('clear cell','Clear Cell','Clear Cell', 1, (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'ovary diagnosis morphology'), 1),
('small cell','Small Cell','Small Cell', 1, (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'ovary diagnosis morphology'), 1),
('sex cord','Sex Cord','Sex cord', 1, (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'ovary diagnosis morphology'), 1),
('cells in cat rings','Cells in Cat Rings','Cellules en bagues de chaton', 1, (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'ovary diagnosis morphology'), 1),
('struma ovarii','Struma Ovarii','Struma Ovarii', 1, (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'ovary diagnosis morphology'), 1),
('fibroma','Fibroma','Fibrome', 1, (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'ovary diagnosis morphology'), 1),
('atrophic','Atrophic','Atrophique', 1, (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'ovary diagnosis morphology'), 1),
('fibrothecoma','Fibrothecoma','Fibrothécale', 1, (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'ovary diagnosis morphology'), 1),
('polycystic','Polycystic','Polykystique', 1, (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'ovary diagnosis morphology'), 1),
('inclusion cyst','Inclusion Cyst','Kyste d''inclusion', 1, (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'ovary diagnosis morphology'), 1);

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'DiagnosisDetail', 'chus_dxd_ovaries', 'morphology', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='chus_custom_ovary_dx_morphology') , '0', '', '', '', 'morphology', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='chus_dx_ovary'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='chus_dxd_ovaries' AND `field`='morphology' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='chus_custom_ovary_dx_morphology')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='morphology' AND `language_tag`=''), '1', '11', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0');

UPDATE structure_formats SET `display_order`='8' WHERE structure_id=(SELECT id FROM structures WHERE alias='chus_dx_ovary') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='chus_dxd_ovaries' AND `field`='atcd_description' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE `diagnosis_controls` SET detail_tablename = 'chus_dxd_ovaries' WHERE form_alias LIKE 'diagnosismasters,%,chus_dx_ovary';

-- OVARY

INSERT INTO `diagnosis_controls` (`category`, `controls_type`, `flag_active`, `form_alias`, `detail_tablename`, `display_order`, `databrowser_label`, `flag_compare_with_cap`) VALUES
('primary', 'breast', 1, 'diagnosismasters,dx_primary,chus_dx_breast', 'chus_dxd_breasts', 0, 'primary|breast', 1),
('secondary', 'breast', 1, 'diagnosismasters,dx_secondary,chus_dx_breast', 'chus_dxd_breasts', 0, 'secondary|breast', 1);

CREATE TABLE IF NOT EXISTS `chus_dxd_breasts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `diagnosis_master_id` int(11) NOT NULL DEFAULT '0',
  
  `laterality` varchar(50) NOT NULL DEFAULT '',
  `atcd` char(1) DEFAULT '',
  `atcd_description` varchar(250) NOT NULL DEFAULT '',
  `stage` varchar(50) NOT NULL DEFAULT '',

  `infiltrative_ductal` char(1) DEFAULT '',
  `infiltrative_mucinous` char(1) DEFAULT '',
  `infiltrative_apocrine` char(1) DEFAULT '',
  `infiltrative_tubular` char(1) DEFAULT '',
  `infiltrative_trabecular` char(1) DEFAULT '',
  `infiltrative_alveolar` char(1) DEFAULT '',
  `infiltrative_papillary` char(1) DEFAULT '',
  `infiltrative_micropapillary` char(1) DEFAULT '',
  `infiltrative_cribriform` char(1) DEFAULT '',
  `infiltrative_lobular` char(1) DEFAULT '',
  `infiltrative_solid` char(1) DEFAULT '',
  `infiltrative_medullary` char(1) DEFAULT '',
  `infiltrative_polyadenoid` char(1) DEFAULT '',
  `infiltrative_neuroendocrine` char(1) DEFAULT '',
  `infiltrative_sarcomatoid` char(1) DEFAULT '',
  `infiltrative_ring_cell` char(1) DEFAULT '',
  `infiltrative_clear_cell` char(1) DEFAULT '',
  `infiltrative_giant_cells` char(1) DEFAULT '',
  `infiltrative_malpighian` char(1) DEFAULT '',
  `infiltrative_epidermoid` char(1) DEFAULT '',
  `infiltrative_pleomorphic` char(1) DEFAULT '',
  `infiltrative_basal_like` char(1) DEFAULT '',
  `infiltrative_sbr_grade` varchar(150) DEFAULT NULL,

  `intraductal_papillary` char(1) DEFAULT '',
  `intraductal_ductal` char(1) DEFAULT '',
  `intraductal_lobular` char(1) DEFAULT '',
  `intraductal_micropapillary` char(1) DEFAULT '',
  `intraductal_cribriform` char(1) DEFAULT '',
  `intraductal_apocrine` char(1) DEFAULT '',
  `intraductal_comedocarcinoma` char(1) DEFAULT '',
  `intraductal_solid` char(1) DEFAULT '',
  `intraductal_intraductal_not_specified` char(1) DEFAULT '',
  `intraductal_perc_of_infiltrating` decimal(5,2) DEFAULT NULL,
  `intraductal_ng_grade_holland` varchar(150) DEFAULT NULL,

  `ganglion_axillary_surgery` char(1) DEFAULT '',
  `ganglion_sentinel_node` char(1) DEFAULT '',
  `ganglion_total` int(6) DEFAULT NULL,
  `ganglion_invaded` int(6) DEFAULT NULL,
    
  `observation_necrosis` char(1) DEFAULT '',
  `observation_microcalcifications` char(1) DEFAULT '',
  `observation_angiolymphatic_invasion` char(1) DEFAULT '',
  `observation_multiple_foci_tumor` char(1) DEFAULT '',
  `observation_microinvasion` char(1) DEFAULT '',
  `observation_distant_metastasis` char(1) DEFAULT '',
  `observation_atypical_fibrocystic_changes` char(1) DEFAULT '',
  `observation_nipple_affected` char(1) DEFAULT '',
  `observation_epidermis_affected` char(1) DEFAULT '',
        
  `deleted` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `diagnosis_master_id` (`diagnosis_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE IF NOT EXISTS `chus_dxd_breasts_revs` (
  `id` int(11) NOT NULL,
  `diagnosis_master_id` int(11) NOT NULL DEFAULT '0',
  
  `laterality` varchar(50) NOT NULL DEFAULT '',
  `atcd` char(1) DEFAULT '',
  `atcd_description` varchar(250) NOT NULL DEFAULT '',
  `stage` varchar(50) NOT NULL DEFAULT '',

  `infiltrative_ductal` char(1) DEFAULT '',
  `infiltrative_mucinous` char(1) DEFAULT '',
  `infiltrative_apocrine` char(1) DEFAULT '',
  `infiltrative_tubular` char(1) DEFAULT '',
  `infiltrative_trabecular` char(1) DEFAULT '',
  `infiltrative_alveolar` char(1) DEFAULT '',
  `infiltrative_papillary` char(1) DEFAULT '',
  `infiltrative_micropapillary` char(1) DEFAULT '',
  `infiltrative_cribriform` char(1) DEFAULT '',
  `infiltrative_lobular` char(1) DEFAULT '',
  `infiltrative_solid` char(1) DEFAULT '',
  `infiltrative_medullary` char(1) DEFAULT '',
  `infiltrative_polyadenoid` char(1) DEFAULT '',
  `infiltrative_neuroendocrine` char(1) DEFAULT '',
  `infiltrative_sarcomatoid` char(1) DEFAULT '',
  `infiltrative_ring_cell` char(1) DEFAULT '',
  `infiltrative_clear_cell` char(1) DEFAULT '',
  `infiltrative_giant_cells` char(1) DEFAULT '',
  `infiltrative_malpighian` char(1) DEFAULT '',
  `infiltrative_epidermoid` char(1) DEFAULT '',
  `infiltrative_pleomorphic` char(1) DEFAULT '',
  `infiltrative_basal_like` char(1) DEFAULT '',
  `infiltrative_sbr_grade` varchar(150) DEFAULT NULL,

  `intraductal_papillary` char(1) DEFAULT '',
  `intraductal_ductal` char(1) DEFAULT '',
  `intraductal_lobular` char(1) DEFAULT '',
  `intraductal_micropapillary` char(1) DEFAULT '',
  `intraductal_cribriform` char(1) DEFAULT '',
  `intraductal_apocrine` char(1) DEFAULT '',
  `intraductal_comedocarcinoma` char(1) DEFAULT '',
  `intraductal_solid` char(1) DEFAULT '',
  `intraductal_intraductal_not_specified` char(1) DEFAULT '',
  `intraductal_perc_of_infiltrating` decimal(5,2) DEFAULT NULL,
  `intraductal_ng_grade_holland` varchar(150) DEFAULT NULL,

  `ganglion_axillary_surgery` char(1) DEFAULT '',
  `ganglion_sentinel_node` char(1) DEFAULT '',
  `ganglion_total` int(6) DEFAULT NULL,
  `ganglion_invaded` int(6) DEFAULT NULL,
    
  `observation_necrosis` char(1) DEFAULT '',
  `observation_microcalcifications` char(1) DEFAULT '',
  `observation_angiolymphatic_invasion` char(1) DEFAULT '',
  `observation_multiple_foci_tumor` char(1) DEFAULT '',
  `observation_microinvasion` char(1) DEFAULT '',
  `observation_distant_metastasis` char(1) DEFAULT '',
  `observation_atypical_fibrocystic_changes` char(1) DEFAULT '',
  `observation_nipple_affected` char(1) DEFAULT '',
  `observation_epidermis_affected` char(1) DEFAULT '',
        
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

ALTER TABLE `chus_dxd_breasts`
  ADD CONSTRAINT `chus_dxd_breasts_ibfk_1` FOREIGN KEY (`diagnosis_master_id`) REFERENCES `diagnosis_masters` (`id`);

INSERT INTO structures(`alias`) VALUES ('chus_dx_breast');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'DiagnosisDetail', 'chus_dxd_breasts', 'laterality', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='laterality') , '0', '', '', 'dx_laterality', 'laterality', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='chus_dx_breast'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='clinical_tstage' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=1,maxlength=3' AND `default`='' AND `language_help`='' AND `language_label`='clinical stage' AND `language_tag`='t stage'), '2', '19', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_dx_breast'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='clinical_nstage' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=1,maxlength=3' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='n stage'), '2', '20', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_dx_breast'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='clinical_mstage' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=1,maxlength=3' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='m stage'), '2', '21', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_dx_breast'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='clinical_stage_summary' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=1,maxlength=3' AND `default`='' AND `language_help`='help_clinical_stage_summary' AND `language_label`='' AND `language_tag`='summary'), '2', '22', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_dx_breast'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_tstage' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=1,maxlength=3' AND `default`='' AND `language_help`='' AND `language_label`='pathological stage' AND `language_tag`='t stage'), '2', '23', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_dx_breast'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_nstage' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=1,maxlength=3' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='n stage'), '2', '24', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_dx_breast'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_mstage' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=1,maxlength=3' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='m stage'), '2', '24', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_dx_breast'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_stage_summary' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=1, maxlength=3' AND `default`='' AND `language_help`='help_path_stage_summary' AND `language_label`='' AND `language_tag`='summary'), '2', '25', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_dx_breast'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='chus_dxd_breasts' AND `field`='laterality' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='laterality')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='dx_laterality' AND `language_label`='laterality' AND `language_tag`=''), '2', '99', 'tissue specific', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'DiagnosisDetail', 'chus_dxd_breasts', 'atcd', 'yes_no',  NULL , '0', '', '', '', 'atcd', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'chus_dxd_breasts', 'atcd_description', 'input',  NULL , '0', 'size=30', '', '', '', 'description'), 
('Clinicalannotation', 'DiagnosisDetail', 'chus_dxd_breasts', 'stage', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='chus_dx_stage') , '0', '', '', '', 'stage', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='chus_dx_breast'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='chus_dxd_breasts' AND `field`='atcd' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='atcd' AND `language_tag`=''), '1', '8', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_dx_breast'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='chus_dxd_breasts' AND `field`='atcd_description' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='description'), '1', '9', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_dx_breast'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='chus_dxd_breasts' AND `field`='stage' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='chus_dx_stage')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='stage' AND `language_tag`=''), '2', '26', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0');

UPDATE structure_formats SET `language_heading`='staging' WHERE structure_id=(SELECT id FROM structures WHERE alias='chus_dx_breast') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='clinical_tstage' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='8' WHERE structure_id=(SELECT id FROM structures WHERE alias='chus_dx_breast') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='chus_dxd_breasts' AND `field`='atcd_description' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'DiagnosisDetail', 'chus_dxd_breasts', 'infiltrative_ductal', 'yes_no',  NULL , '0', '', '', '', 'ductal', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'chus_dxd_breasts', 'infiltrative_mucinous', 'yes_no',  NULL , '0', '', '', '', 'mucinous', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'chus_dxd_breasts', 'infiltrative_apocrine', 'yes_no',  NULL , '0', '', '', '', 'apocrine', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'chus_dxd_breasts', 'infiltrative_tubular', 'yes_no',  NULL , '0', '', '', '', 'tubular', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'chus_dxd_breasts', 'infiltrative_trabecular', 'yes_no',  NULL , '0', '', '', '', 'trabecular', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'chus_dxd_breasts', 'infiltrative_alveolar', 'yes_no',  NULL , '0', '', '', '', 'alveolar', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'chus_dxd_breasts', 'infiltrative_papillary', 'yes_no',  NULL , '0', '', '', '', 'papillary', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'chus_dxd_breasts', 'infiltrative_micropapillary', 'yes_no',  NULL , '0', '', '', '', 'micropapillary', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'chus_dxd_breasts', 'infiltrative_cribriform', 'yes_no',  NULL , '0', '', '', '', 'cribriform', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'chus_dxd_breasts', 'infiltrative_lobular', 'yes_no',  NULL , '0', '', '', '', 'lobular', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'chus_dxd_breasts', 'infiltrative_solid', 'yes_no',  NULL , '0', '', '', '', 'solid', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'chus_dxd_breasts', 'infiltrative_medullary', 'yes_no',  NULL , '0', '', '', '', 'medullary', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'chus_dxd_breasts', 'infiltrative_polyadenoid', 'yes_no',  NULL , '0', '', '', '', 'polyadenoid', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'chus_dxd_breasts', 'infiltrative_neuroendocrine', 'yes_no',  NULL , '0', '', '', '', 'neuroendocrine', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'chus_dxd_breasts', 'infiltrative_sarcomatoid', 'yes_no',  NULL , '0', '', '', '', 'sarcomatoid', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'chus_dxd_breasts', 'infiltrative_ring_cell', 'yes_no',  NULL , '0', '', '', '', 'ring cell', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'chus_dxd_breasts', 'infiltrative_clear_cell', 'yes_no',  NULL , '0', '', '', '', 'clear cell', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'chus_dxd_breasts', 'infiltrative_giant_cells', 'yes_no',  NULL , '0', '', '', '', 'giant cells', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'chus_dxd_breasts', 'infiltrative_malpighian', 'yes_no',  NULL , '0', '', '', '', 'malpighian', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'chus_dxd_breasts', 'infiltrative_epidermoid', 'yes_no',  NULL , '0', '', '', '', 'epidermoid', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'chus_dxd_breasts', 'infiltrative_pleomorphic', 'yes_no',  NULL , '0', '', '', '', 'pleomorphic', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'chus_dxd_breasts', 'infiltrative_basal_like', 'yes_no',  NULL , '0', '', '', '', 'basal like', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'chus_dxd_breasts', 'infiltrative_sbr_grade', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='chus_custom_tumour_grade'), '0', '', '', '', 'sbr grade', '');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='chus_dx_breast'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='chus_dxd_breasts' AND `field`='infiltrative_ductal'), '2', '200', 'infiltrative', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_dx_breast'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='chus_dxd_breasts' AND `field`='infiltrative_mucinous'), '2', '201', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_dx_breast'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='chus_dxd_breasts' AND `field`='infiltrative_apocrine'), '2', '202', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_dx_breast'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='chus_dxd_breasts' AND `field`='infiltrative_tubular'), '2', '203', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_dx_breast'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='chus_dxd_breasts' AND `field`='infiltrative_trabecular'), '2', '204', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_dx_breast'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='chus_dxd_breasts' AND `field`='infiltrative_alveolar'), '2', '205', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_dx_breast'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='chus_dxd_breasts' AND `field`='infiltrative_papillary'), '2', '206', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_dx_breast'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='chus_dxd_breasts' AND `field`='infiltrative_micropapillary'), '2', '207', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_dx_breast'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='chus_dxd_breasts' AND `field`='infiltrative_cribriform'), '2', '208', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_dx_breast'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='chus_dxd_breasts' AND `field`='infiltrative_lobular'), '2', '209', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_dx_breast'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='chus_dxd_breasts' AND `field`='infiltrative_solid'), '2', '210', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_dx_breast'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='chus_dxd_breasts' AND `field`='infiltrative_medullary'), '2', '211', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_dx_breast'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='chus_dxd_breasts' AND `field`='infiltrative_polyadenoid'), '2', '212', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_dx_breast'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='chus_dxd_breasts' AND `field`='infiltrative_neuroendocrine'), '2', '213', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_dx_breast'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='chus_dxd_breasts' AND `field`='infiltrative_sarcomatoid'), '2', '214', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_dx_breast'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='chus_dxd_breasts' AND `field`='infiltrative_ring_cell'), '2', '215', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_dx_breast'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='chus_dxd_breasts' AND `field`='infiltrative_clear_cell'), '2', '216', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_dx_breast'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='chus_dxd_breasts' AND `field`='infiltrative_giant_cells'), '2', '217', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_dx_breast'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='chus_dxd_breasts' AND `field`='infiltrative_malpighian'), '2', '218', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_dx_breast'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='chus_dxd_breasts' AND `field`='infiltrative_epidermoid'), '2', '219', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_dx_breast'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='chus_dxd_breasts' AND `field`='infiltrative_pleomorphic'), '2', '221', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_dx_breast'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='chus_dxd_breasts' AND `field`='infiltrative_basal_like'), '2', '222', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_dx_breast'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='chus_dxd_breasts' AND `field`='infiltrative_sbr_grade'), '2', '223', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0');

INSERT IGNORE INTO i18n (id,en,fr) VALUES 
('ductal','Ductal','Canalaire (ductal)'),
('mucinous','Mucinous','Mucineux'),
('apocrine','Apocrine','Apocrine'),
('tubular','Tubular','Tubulaire'),
('trabecular','Trabecular','Trabéculaire'),
('alveolar','Alveolar','Alvéolaire'),
('papillary','Papillary','Papillaire'),
('micropapillary','Micropapillary','Micropapillaire'),
('cribriform','Cribriform','Cribriforme'),
('lobular','Lobular','Lobulaire'),
('solid','Solid','Solide'),
('medullary','Medullary','Médullaire'),
('polyadenoid','Polyadenoid','Polyadénoïde'),
('neuroendocrine','Neuroendocrine','Neuroendocrinienne'),
('sarcomatoid','Sarcomatoid','Sarcomatoide'),
('ring cell','Ring cell','Cellules en bague'),
('clear cell','Clear cell','Cellules Claires'),
('giant cells','Giant cells','Cellules géantes'),
('malpighian','Malpighian','Malpighienne'),
('epidermoid','Epidermoid','Épidermoide'),
('medullary','Medullary','Médullaire'),
('pleomorphic','Pleomorphic','Pléomorphe'),
('basal like','Basal-Like','Basal-Like'),
('sbr grade','SBR Grade','Grade SBR'),
('infiltrative','Infiltrative','Infiltrant');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'DiagnosisDetail', 'chus_dxd_breasts', 'intraductal_papillary', 'yes_no',  NULL , '0', '', '', '', 'papillary', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'chus_dxd_breasts', 'intraductal_ductal', 'yes_no',  NULL , '0', '', '', '', 'ductal', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'chus_dxd_breasts', 'intraductal_lobular', 'yes_no',  NULL , '0', '', '', '', 'lobular', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'chus_dxd_breasts', 'intraductal_micropapillary', 'yes_no',  NULL , '0', '', '', '', 'micropapillary', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'chus_dxd_breasts', 'intraductal_cribriform', 'yes_no',  NULL , '0', '', '', '', 'cribriform', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'chus_dxd_breasts', 'intraductal_apocrine', 'yes_no',  NULL , '0', '', '', '', 'apocrine', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'chus_dxd_breasts', 'intraductal_comedocarcinoma', 'yes_no',  NULL , '0', '', '', '', 'comedocarcinoma', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'chus_dxd_breasts', 'intraductal_solid', 'yes_no',  NULL , '0', '', '', '', 'solid', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'chus_dxd_breasts', 'intraductal_intraductal_not_specified', 'yes_no',  NULL , '0', '', '', '', 'intraductal not specified', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'chus_dxd_breasts', 'intraductal_perc_of_infiltrating', 'float_positive',  NULL , '0', 'size=5', '', '', 'perc of infiltrating', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'chus_dxd_breasts', 'intraductal_ng_grade_holland', 'select',  (SELECT id FROM structure_value_domains WHERE domain_name='chus_custom_tumour_grade') , '0', '', '', '', 'ng grade (holland)', '');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='chus_dx_breast'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='chus_dxd_breasts' AND `field`='intraductal_papillary'), '3', '300', 'intraductal (in situ)', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_dx_breast'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='chus_dxd_breasts' AND `field`='intraductal_ductal'), '3', '301', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_dx_breast'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='chus_dxd_breasts' AND `field`='intraductal_lobular'), '3', '302', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_dx_breast'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='chus_dxd_breasts' AND `field`='intraductal_micropapillary'), '3', '303', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_dx_breast'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='chus_dxd_breasts' AND `field`='intraductal_cribriform'), '3', '304', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_dx_breast'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='chus_dxd_breasts' AND `field`='intraductal_apocrine'), '3', '305', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_dx_breast'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='chus_dxd_breasts' AND `field`='intraductal_comedocarcinoma'), '3', '306', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_dx_breast'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='chus_dxd_breasts' AND `field`='intraductal_solid'), '3', '307', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_dx_breast'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='chus_dxd_breasts' AND `field`='intraductal_intraductal_not_specified'), '3', '308', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_dx_breast'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='chus_dxd_breasts' AND `field`='intraductal_perc_of_infiltrating'), '3', '309', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_dx_breast'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='chus_dxd_breasts' AND `field`='intraductal_ng_grade_holland'), '3', '310', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0');

INSERT IGNORE INTO i18n (id,en,fr) VALUES 
('papillary','Papillary','Papillaire'),
('ductal','Ductal','Ductal'),
('lobular','Lobular','Lobulaire'),
('micropapillary','Micropapillary','Micropapillaire'),
('cribriform','Cribriform','Cribriforme'),
('apocrine','Apocrine','Apocrine'),
('comedocarcinoma','Comedocarcinoma','Comédocarcinome'),
('solid','Solid','Solide'),
('intraductal not specified','Intraductal Not Specified','Intracanalaire (Pas spécification)'),
('perc of infiltrating','% Of Infiltrating','% de l''infiltrant'),
('ng grade (holland)','NG Grade (Holland)','Grade NG (Holland)'),
('intraductal (in situ)','Intraductal (In Situ)','Intracanalaire (In situ)');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'DiagnosisDetail', 'chus_dxd_breasts', 'ganglion_axillary_surgery', 'yes_no',  NULL , '0', '', '', '', 'axillary surgery', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'chus_dxd_breasts', 'ganglion_sentinel_node', 'yes_no',  NULL , '0', '', '', '', 'sentinel node', ''),
('Clinicalannotation', 'DiagnosisDetail', 'chus_dxd_breasts', 'ganglion_total', 'integer_positive',  NULL , '0', 'size=5', '', '', 'total', ''),
('Clinicalannotation', 'DiagnosisDetail', 'chus_dxd_breasts', 'ganglion_invaded', 'integer_positive',  NULL , '0', 'size=5', '', '', 'invaded', '');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='chus_dx_breast'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='chus_dxd_breasts' AND `field`='ganglion_axillary_surgery'), '3', '350', 'ganglions', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_dx_breast'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='chus_dxd_breasts' AND `field`='ganglion_sentinel_node'), '3', '351', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_dx_breast'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='chus_dxd_breasts' AND `field`='ganglion_total'), '3', '352', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_dx_breast'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='chus_dxd_breasts' AND `field`='ganglion_invaded'), '3', '353', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0');

INSERT IGNORE INTO i18n (id,en,fr) VALUES 
('axillary surgery','Axillary Surgery','Chirurgie aisselle'),
('sentinel node','Sentinel Node','Ganglion sentinelle'),
('ganglions','Ganglions','Ganglions'),
('total','Total','Total'),
('invaded','Invaded','Envahis');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'DiagnosisDetail', 'chus_dxd_breasts', 'observation_necrosis', 'yes_no',  NULL , '0', '', '', '', 'necrosis', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'chus_dxd_breasts', 'observation_microcalcifications', 'yes_no',  NULL , '0', '', '', '', 'microcalcifications', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'chus_dxd_breasts', 'observation_angiolymphatic_invasion', 'yes_no',  NULL , '0', '', '', '', 'angiolymphatic invasion', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'chus_dxd_breasts', 'observation_multiple_foci_tumor', 'yes_no',  NULL , '0', '', '', '', 'multiple foci tumor', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'chus_dxd_breasts', 'observation_microinvasion', 'yes_no',  NULL , '0', '', '', '', 'microinvasion', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'chus_dxd_breasts', 'observation_distant_metastasis', 'yes_no',  NULL , '0', '', '', '', 'distant metastasis', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'chus_dxd_breasts', 'observation_atypical_fibrocystic_changes', 'yes_no',  NULL , '0', '', '', '', 'atypical fibrocystic changes', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'chus_dxd_breasts', 'observation_nipple_affected', 'yes_no',  NULL , '0', '', '', '', 'nipple affected (paget)', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'chus_dxd_breasts', 'observation_epidermis_affected', 'yes_no',  NULL , '0', '', '', '', 'epidermis affected', '');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='chus_dx_breast'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='chus_dxd_breasts' AND `field`='observation_necrosis'), '3', '400', 'observations', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_dx_breast'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='chus_dxd_breasts' AND `field`='observation_microcalcifications'), '3', '401', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_dx_breast'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='chus_dxd_breasts' AND `field`='observation_angiolymphatic_invasion'), '3', '402', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_dx_breast'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='chus_dxd_breasts' AND `field`='observation_multiple_foci_tumor'), '3', '403', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_dx_breast'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='chus_dxd_breasts' AND `field`='observation_microinvasion'), '3', '404', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_dx_breast'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='chus_dxd_breasts' AND `field`='observation_distant_metastasis'), '3', '405', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_dx_breast'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='chus_dxd_breasts' AND `field`='observation_atypical_fibrocystic_changes'), '3', '406', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_dx_breast'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='chus_dxd_breasts' AND `field`='observation_nipple_affected'), '3', '407', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_dx_breast'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='chus_dxd_breasts' AND `field`='observation_epidermis_affected'), '3', '408', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'); 

INSERT IGNORE INTO i18n (id,en,fr) VALUES
('necrosis','Necrosis','Nécrose'),
('microcalcifications','Microcalcifications','Microcalcifications'),
('angiolymphatic invasion','Angiolymphatic Invasion','Perméations angiolymphatiques'),
('multiple foci tumor','Multiple Foci tumor','Tumeur à multiples foyers'),
('microinvasion','Microinvasion','Microinvasion'),
('distant metastasis','Distant Metastasis','Métastases à distance'),
('atypical fibrocystic changes','Atypical Fibrocystic Changes','Modifications fibrokystiques atypiques'),
('nipple affected (paget)','Nipple Affected (Paget)','Atteinte du mamelon (Paget)'),
('epidermis affected','Epidermis Affected','Atteinte de l''épiderme'),
('observations','Observations','Observations');

--

UPDATE diagnosis_controls SET flag_compare_with_cap = 0;
UPDATE diagnosis_controls SET databrowser_label = CONCAT(category,'|',controls_type);

-- --------------------------------------------------------------------------------------------------------
-- Fam Hist
-- --------------------------------------------------------------------------------------------------------

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='familyhistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='FamilyHistory' AND `tablename`='family_histories' AND `field`='previous_primary_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='familyhistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='FamilyHistory' AND `tablename`='family_histories' AND `field`='previous_primary_code_system' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');




ALTER TABLE family_histories
  ADD COLUMN `chus_primary_description` varchar(250) DEFAULT NULL AFTER primary_icd10_code;
ALTER TABLE family_histories_revs
  ADD COLUMN `chus_primary_description` varchar(250) DEFAULT NULL AFTER primary_icd10_code;

INSERT INTO `structure_value_domains` (`id`, `domain_name`, `override`, `category`, `source`) VALUES (NULL, 'chus_fam_histor_primary_list', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(''family history: primary'')');
INSERT INTO structure_permissible_values_custom_controls (name,flag_active,values_max_length)
VALUES ('family history: primary', '1', '250');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `control_id`, `use_as_input`) 
VALUES 
('brain','Brain','Cerveau', (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'family history: primary'), 1),
('settler','Settler','Colon', (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'family history: primary'), 1),
('stomach','Stomach','Estomac ', (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'family history: primary'), 1),
('ganglion','Ganglion','Ganglion', (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'family history: primary'), 1),
('generalized','Generalized','Généralisé', (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'family history: primary'), 1),
('gynecological','Gynecological','Gynecologique', (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'family history: primary'), 1),
('Hodgkin','Hodgkin','Hodgkin', (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'family history: primary'), 1),
('intestine','Intestine','Intestin', (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'family history: primary'), 1),
('larynx','Larynx','Larynx', (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'family history: primary'), 1),
('leukemia','Leukemia','Leucémie', (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'family history: primary'), 1),
('lymphoma','Lymphoma','Lymphome', (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'family history: primary'), 1),
('marrow','Marrow','Moelle', (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'family history: primary'), 1),
('bone','Bone','Os', (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'family history: primary'), 1),
('ovary','Ovary','Ovaire', (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'family history: primary'), 1),
('pancreas','Pancreas','Pancreas', (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'family history: primary'), 1),
('lung','Lung','Poumon', (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'family history: primary'), 1),
('prostate','Prostate','Prostate', (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'family history: primary'), 1),
('rectum','Rectum','Rectum', (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'family history: primary'), 1),
('kidney','Kidney','Rein', (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'family history: primary'), 1),
('breast','Breast','Sein', (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'family history: primary'), 1),
('testicle','Testicle','Testicule', (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'family history: primary'), 1),
('uterus','Uterus','Utérus', (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'family history: primary'), 1),
('bladder','Bladder','Vessie', (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'family history: primary'), 1),
('vulva','Vulva','Vulve', (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'family history: primary'), 1);

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'FamilyHistory', 'family_histories', 'chus_primary_description', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='chus_fam_histor_primary_list') , '0', '', '', '', 'primary', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='familyhistories'), (SELECT id FROM structure_fields WHERE `model`='FamilyHistory' AND `tablename`='family_histories' AND `field`='chus_primary_description' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='chus_fam_histor_primary_list')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='primary' AND `language_tag`=''), '1', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0');

-- ------------------------------------------------------------------------------------------------------

REPLACE INTO i18n (id,en,fr) VALUES 
('appendix','Appendix','Appendice'),
('colon','Colon','Colon'),
('ganglion','Ganglion','Ganglion'),
('hormonotherapy','Hormonotherapy','Hormonothérapie'),
('hospital number','Hospital Number','Numéro Hôpital'),
('liver','Liver','Foie'),
('pancreas','Pancreas','Pancréas'),
('rectum','Rectum','Rectum'),
('stomach','Stomach','Estomac');

-- ========================================================================================================
-- Inventory
-- ========================================================================================================

UPDATE parent_to_derivative_sample_controls SET flag_active=false WHERE id IN(142, 143, 141, 144, 101, 102, 140, 25, 3, 6);
UPDATE aliquot_controls SET flag_active=false WHERE id IN(11, 33, 10);
UPDATE realiquoting_controls SET flag_active=false WHERE id IN(12, 11, 34, 10);

UPDATE structure_formats 
SET flag_add = '0',flag_add_readonly = '0',flag_edit = '0',flag_edit_readonly = '0',flag_search = '0',flag_search_readonly = '0',flag_addgrid = '0',flag_addgrid_readonly = '0',flag_editgrid = '0',flag_editgrid_readonly = '0',flag_summary = '0',flag_batchedit = '0',flag_batchedit_readonly = '0',flag_index = '0',flag_detail = '0'
WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE field = 'sop_master_id');

UPDATE banks SET name = 'Sein/Breast', description = '' WHERE banks.id = 1;
UPDATE banks_revs SET name = 'Sein/Breast', description = '' WHERE id = 1;

INSERT INTO `banks` (`name`, `description`, `modified`, `created`, `created_by`, `modified_by`) VALUES ('Ovaire/Ovary', '', NOW(), NOW(), 1, 1);
SET @id = LAST_INSERT_ID();
INSERT INTO `banks_revs` (`name`, `description`, `modified_by`, `id`, `version_created`) VALUES ('Ovaire/Ovary', '', 1, @id, NOW());

-- --------------------------------------------------------------------------------------------------------------------------------
-- Collection
-- --------------------------------------------------------------------------------------------------------------------------------

INSERT INTO `structure_validations` (`structure_field_id`, `rule`, `on_action`, `language_message`) VALUES
((SELECT id FROM structure_fields WHERE model = 'Collection' AND field = 'bank_id'), 'notEmpty', '', '');

UPDATE structure_formats 
SET flag_add = '0',flag_add_readonly = '0',flag_edit = '0',flag_edit_readonly = '0',flag_search = '0',flag_search_readonly = '0',flag_addgrid = '0',flag_addgrid_readonly = '0',flag_editgrid = '0',flag_editgrid_readonly = '0',flag_summary = '0',flag_batchedit = '0',flag_batchedit_readonly = '0',flag_index = '0',flag_detail = '0'
WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE field = 'acquisition_label');

ALTER TABLE clinical_collection_links
	ADD `misc_identifier_id` int(11) DEFAULT NULL AFTER consent_master_id;
ALTER TABLE clinical_collection_links_revs
	ADD `misc_identifier_id` int(11) DEFAULT NULL AFTER consent_master_id;

ALTER TABLE `clinical_collection_links`
  ADD CONSTRAINT `FK_clinical_collection_links_misc_identifiers` FOREIGN KEY (`misc_identifier_id`) REFERENCES `misc_identifiers` (`id`);

DROP VIEW IF EXISTS view_collections;
DROP TABLE IF EXISTS view_collections;
CREATE VIEW `view_collections` AS 
select `col`.`id` AS `collection_id`,
`col`.`bank_id` AS `bank_id`,
`col`.`sop_master_id` AS `sop_master_id`,
`link`.`participant_id` AS `participant_id`,
`link`.`diagnosis_master_id` AS `diagnosis_master_id`,
`link`.`consent_master_id` AS `consent_master_id`,
`part`.`participant_identifier` AS `participant_identifier`,
	ident.identifier_value AS frsq_number,
`col`.`acquisition_label` AS `acquisition_label`,
`col`.`collection_site` AS `collection_site`,
`col`.`collection_datetime` AS `collection_datetime`,
`col`.`collection_datetime_accuracy` AS `collection_datetime_accuracy`,
`col`.`collection_property` AS `collection_property`,
`col`.`collection_notes` AS `collection_notes`,
`col`.`deleted` AS `deleted`,`banks`.`name` AS `bank_name`,
`col`.`created` AS `created` 
from `collections` `col` 
left join `clinical_collection_links` `link` on `col`.`id` = `link`.`collection_id` and `link`.`deleted` <> 1 
left join `participants` `part` on `link`.`participant_id` = `part`.`id` and `part`.`deleted` <> 1
	left join `misc_identifiers` `ident` on`link`.`misc_identifier_id` = `ident`.`id` and `ident`.`deleted` <> 1
left join `banks` on `col`.`bank_id` = `banks`.`id` and `banks`.`deleted` <> 1 
where `col`.`deleted` <> 1 ;

DROP VIEW IF EXISTS view_samples;
DROP TABLE IF EXISTS view_samples;
CREATE VIEW `view_samples` AS 
select `samp`.`id` AS `sample_master_id`,
`samp`.`parent_id` AS `parent_sample_id`,
`samp`.`initial_specimen_sample_id` AS `initial_specimen_sample_id`,
`samp`.`collection_id` AS `collection_id`,
`col`.`bank_id` AS `bank_id`,
`col`.`sop_master_id` AS `sop_master_id`,
`link`.`participant_id` AS `participant_id`,
`link`.`diagnosis_master_id` AS `diagnosis_master_id`,
`link`.`consent_master_id` AS `consent_master_id`,
`part`.`participant_identifier` AS `participant_identifier`,
	ident.identifier_value AS frsq_number,
`col`.`acquisition_label` AS `acquisition_label`,
`specimenc`.`sample_type` AS `initial_specimen_sample_type`,
`specimen`.`sample_control_id` AS `initial_specimen_sample_control_id`,
`parent_sampc`.`sample_type` AS `parent_sample_type`,`parent_samp`.
`sample_control_id` AS `parent_sample_control_id`,
`sampc`.`sample_type` AS `sample_type`,
`samp`.`sample_control_id` AS `sample_control_id`,
`samp`.`sample_code` AS `sample_code`,
`sampc`.`sample_category` AS `sample_category` from `sample_masters` `samp` 
join `sample_controls` `sampc` on `samp`.`sample_control_id` = `sampc`.`id` 
join `collections` `col` on `col`.`id` = `samp`.`collection_id` and `col`.`deleted` <> 1 
left join `sample_masters` `specimen` on `samp`.`initial_specimen_sample_id` = `specimen`.`id` and `specimen`.`deleted` <> 1
left join `sample_controls` `specimenc` on `specimen`.`sample_control_id` = `specimenc`.`id` 
left join `sample_masters` `parent_samp` on `samp`.`parent_id` = `parent_samp`.`id` and `parent_samp`.`deleted` <> 1 
left join `sample_controls` `parent_sampc` on `parent_samp`.`sample_control_id` = `parent_sampc`.`id` 
left join `clinical_collection_links` `link` on `col`.`id` = `link`.`collection_id` and `link`.`deleted` <> 1 
	left join `misc_identifiers` `ident` on`link`.`misc_identifier_id` = `ident`.`id` and `ident`.`deleted` <> 1
left join `participants` `part` on `link`.`participant_id` = `part`.`id` and `part`.`deleted` <> 1 
where `samp`.`deleted` <> 1 ;

DROP VIEW IF EXISTS view_aliquots;
DROP TABLE IF EXISTS view_aliquots;
CREATE VIEW `view_aliquots` AS 
select `al`.`id` AS `aliquot_master_id`,
`al`.`sample_master_id` AS `sample_master_id`,
`al`.`collection_id` AS `collection_id`,
`col`.`bank_id` AS `bank_id`,
`al`.`storage_master_id` AS `storage_master_id`,
`link`.`participant_id` AS `participant_id`,
`link`.`diagnosis_master_id` AS `diagnosis_master_id`,
`link`.`consent_master_id` AS `consent_master_id`,
`part`.`participant_identifier` AS `participant_identifier`,
	ident.identifier_value AS frsq_number,
`col`.`acquisition_label` AS `acquisition_label`,
`specimenc`.`sample_type` AS `initial_specimen_sample_type`,
`specimen`.`sample_control_id` AS `initial_specimen_sample_control_id`,
`parent_sampc`.`sample_type` AS `parent_sample_type`,
`parent_samp`.`sample_control_id` AS `parent_sample_control_id`,
`sampc`.`sample_type` AS `sample_type`,
`samp`.`sample_control_id` AS `sample_control_id`,
`al`.`barcode` AS `barcode`,`al`.`aliquot_label` AS `aliquot_label`,
`alc`.`aliquot_type` AS `aliquot_type`,
`al`.`aliquot_control_id` AS `aliquot_control_id`,
`al`.`in_stock` AS `in_stock`,`stor`.`code` AS `code`,
`stor`.`selection_label` AS `selection_label`,
`al`.`storage_coord_x` AS `storage_coord_x`,
`al`.`storage_coord_y` AS `storage_coord_y`,
`stor`.`temperature` AS `temperature`,
`stor`.`temp_unit` AS `temp_unit`,
`al`.`created` AS `created` 
from `aliquot_masters` `al` 
join `aliquot_controls` `alc` on `al`.`aliquot_control_id` = `alc`.`id` 
join `sample_masters` `samp` on `samp`.`id` = `al`.`sample_master_id` and `samp`.`deleted` <> 1 
join `sample_controls` `sampc` on `samp`.`sample_control_id` = `sampc`.`id` 
join `collections` `col` on `col`.`id` = `samp`.`collection_id` and `col`.`deleted` <> 1 
left join `sample_masters` `specimen` on `samp`.`initial_specimen_sample_id` = `specimen`.`id` and `specimen`.`deleted` <> 1 
left join `sample_controls` `specimenc` on `specimen`.`sample_control_id` = `specimenc`.`id` 
left join `sample_masters` `parent_samp` on `samp`.`parent_id` = `parent_samp`.`id` and `parent_samp`.`deleted` <> 1 
left join `sample_controls` `parent_sampc` on `parent_samp`.`sample_control_id` = `parent_sampc`.`id` 
left join `clinical_collection_links` `link` on `col`.`id` = `link`.`collection_id` and `link`.`deleted` <> 1 
left join `participants` `part` on `link`.`participant_id` = `part`.`id` and `part`.`deleted` <> 1 
left join `storage_masters` `stor` on `stor`.`id` = `al`.`storage_master_id` and `stor`.`deleted` <> 1 
	left join `misc_identifiers` `ident` on`link`.`misc_identifier_id` = `ident`.`id` and `ident`.`deleted` <> 1
where `al`.`deleted` <> 1 ;

INSERT INTO `structure_fields` (`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `flag_confidential`) VALUES
('', 'Inventorymanagement', 'ViewCollection', '', 'frsq_number', '#FRSQ', '', 'input', 'size=30', '', NULL, '', 0),
('', 'Inventorymanagement', 'ViewSample', '', 'frsq_number', '#FRSQ', '', 'input', 'size=30', '', NULL, '', 0),
('', 'Inventorymanagement', 'ViewAliquot', '', 'frsq_number', '#FRSQ', '', 'input', 'size=30', '', NULL, '', 0);

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='frsq_number' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='' AND `language_label`='#FRSQ' AND `language_tag`=''), '0', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '1');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='view_collection'), (SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='frsq_number' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='' AND `language_label`='#FRSQ' AND `language_tag`=''), '0', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='view_sample_joined_to_collection'), (SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='' AND `field`='frsq_number' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='' AND `language_label`='#FRSQ' AND `language_tag`=''), '0', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '1', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1');

INSERT INTO i18n (id,en,fr) VALUES ('error_fk_frsq_number_linked_collection','Your data cannot be deleted! This #FRSQ is linked to a collection.','Vos données ne peuvent être supprimées! Ce FRSQ# est attaché à une collection.');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='clinicalcollectionlinks'), (SELECT id FROM structure_fields WHERE `model`='MiscIdentifier' AND `field`='identifier_value' AND `setting`='size=30'), '0', '10', '', '1', '#FRSQ', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');

-- la duplication
-- link index

UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='topography' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'MiscIdentifier', '', 'col_copy_frsq_nbr', 'checkbox', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '0', '', '', '', 'copy #frsq (if it exists)', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='col_copy_binding_opt'), (SELECT id FROM structure_fields WHERE `model`='MiscIdentifier' AND `tablename`='' AND `field`='col_copy_frsq_nbr' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='copy #frsq (if it exists)' AND `language_tag`=''), '0', '21', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');
UPDATE structure_fields SET `default` = '1', model = 'FunctionManagement' WHERE field = 'col_copy_frsq_nbr';
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='col_copy_binding_opt') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='MiscIdentifier' AND `tablename`='' AND `field`='col_copy_frsq_nbr' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') AND `flag_confidential`='0');

INSERT INTO i18n (id,en,fr) VALUES ('copy #frsq (if it exists)','Copy #FRSQ (If it exists)','Copier le #FRSQ (si existe)');






















-- ========================================================================================================
-- TOOLS
-- ========================================================================================================

UPDATE menus SET flag_active = '0' WHERE use_link LIKE '/sop/sop_masters/%';

-- Protocol

UPDATE protocol_controls SET flag_active = 0 WHERE type = 'surgery';

SELECT 'Multi Creation Of #FRSQ to resolve' AS TODO;
