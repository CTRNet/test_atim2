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
-- Diagnosis
-- --------------------------------------------------------------------------------------------------------

-- --------------------------------------------------------------------------------------------------------
-- Event
-- --------------------------------------------------------------------------------------------------------

-- life style smoking

INSERT INTO `event_controls` (`disease_site`, `event_group`, `event_type`, `flag_active`, `form_alias`, `detail_tablename`, `display_order`, `databrowser_label`) VALUES
('chus', 'lifestyle', 'smoking history questionnaire', 1, 'eventmasters,chus_ed_lifestyle_smoking', 'ed_all_lifestyle_smokings', 0, 'lifestyle|chus|smoking history questionnaire');

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

-- event followup

INSERT INTO `event_controls` (`disease_site`, `event_group`, `event_type`, `flag_active`, `form_alias`, `detail_tablename`, `display_order`, `databrowser_label`) VALUES
('chus', 'clinical', 'followup', 1, 'eventmasters,chus_ed_clinical_followups', 'chus_ed_clinical_followups', 0, 'clinical|chus|followup');

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

-- --------------------------------------------------------------------------------------------------------
-- Treatment
-- --------------------------------------------------------------------------------------------------------

-- OV - Surgery

INSERT INTO `treatment_controls` (`tx_method`, `disease_site`, `flag_active`, `detail_tablename`, `form_alias`, `extend_tablename`, `extend_form_alias`, `display_order`, `applied_protocol_control_id`, `extended_data_import_process`, `databrowser_label`) VALUES
('surgery', 'ovary', 1, 'chus_txd_surgeries', 'treatmentmasters,chus_txd_surgeries', NULL, NULL, 0, NULL, NULL, 'ovary|surgery');

DROP TABLE IF EXISTS `chus_txd_surgeries`;
CREATE TABLE IF NOT EXISTS `chus_txd_surgeries` (
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

DROP TABLE IF EXISTS `chus_txd_surgeries_revs`;
CREATE TABLE IF NOT EXISTS `chus_txd_surgeries_revs` (
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

ALTER TABLE `chus_txd_surgeries`
  ADD CONSTRAINT `chus_txd_surgeries_ibfk_1` FOREIGN KEY (`treatment_master_id`) REFERENCES `treatment_masters` (`id`);

INSERT INTO structures(`alias`) VALUES ('chus_txd_surgeries');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'TreatmentDetail', 'chus_txd_surgeries', 'patho_report_number', 'input',  NULL , '0', '', '', '', 'patho report number', ''), 
('Clinicalannotation', 'TreatmentDetail', 'chus_txd_surgeries', 'type_HAT_HVAL_HVT', 'yes_no',  NULL , '0', '', '', '', 'HAT/HVAL/HVT', ''), 
('Clinicalannotation', 'TreatmentDetail', 'chus_txd_surgeries', 'type_SOG', 'yes_no',  NULL , '0', '', '', '', 'SOG', ''), 
('Clinicalannotation', 'TreatmentDetail', 'chus_txd_surgeries', 'type_SOD', 'yes_no',  NULL , '0', '', '', '', 'SOD', ''), 
('Clinicalannotation', 'TreatmentDetail', 'chus_txd_surgeries', 'type_SOB', 'yes_no',  NULL , '0', '', '', '', 'SOB', ''), 
('Clinicalannotation', 'TreatmentDetail', 'chus_txd_surgeries', 'type_omentectomy', 'yes_no',  NULL , '0', '', '', '', 'omentectomy', ''), 
('Clinicalannotation', 'TreatmentDetail', 'chus_txd_surgeries', 'type_ganglions', 'yes_no',  NULL , '0', '', '', '', 'ganglions', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='chus_txd_surgeries'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='notes' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='rows=3,cols=30' AND `default`='' AND `language_help`='help_notes' AND `language_label`='notes' AND `language_tag`=''), '1', '99', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_txd_surgeries'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='chus_txd_surgeries' AND `field`='patho_report_number' AND `type`='input'), '1', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_txd_surgeries'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='chus_txd_surgeries' AND `field`='type_HAT_HVAL_HVT' AND `type`='yes_no'), '1', '20', 'surgery type', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_txd_surgeries'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='chus_txd_surgeries' AND `field`='type_SOG' AND `type`='yes_no'), '1', '21', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_txd_surgeries'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='chus_txd_surgeries' AND `field`='type_SOD' AND `type`='yes_no'), '1', '22', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_txd_surgeries'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='chus_txd_surgeries' AND `field`='type_SOB' AND `type`='yes_no'), '1', '23', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_txd_surgeries'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='chus_txd_surgeries' AND `field`='type_omentectomy' AND `type`='yes_no'), '1', '24', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_txd_surgeries'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='chus_txd_surgeries' AND `field`='type_ganglions' AND `type`='yes_no'), '1', '25', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0');

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
('Clinicalannotation', 'TreatmentDetail', 'chus_txd_surgeries', 'primary_at_surgery_ovary', 'yes_no',  NULL , '0', '', '', '', 'ovary', ''), 
('Clinicalannotation', 'TreatmentDetail', 'chus_txd_surgeries', 'primary_at_surgery_fallopian_tube', 'yes_no',  NULL , '0', '', '', '', 'fallopian tube', ''), 
('Clinicalannotation', 'TreatmentDetail', 'chus_txd_surgeries', 'primary_at_surgery_omentum', 'yes_no',  NULL , '0', '', '', '', 'omentum', ''), 
('Clinicalannotation', 'TreatmentDetail', 'chus_txd_surgeries', 'primary_at_surgery_endometrial', 'yes_no',  NULL , '0', '', '', '', 'endometrial', ''), 
('Clinicalannotation', 'TreatmentDetail', 'chus_txd_surgeries', 'primary_at_surgery_uterus', 'yes_no',  NULL , '0', '', '', '', 'uterus', ''), 
('Clinicalannotation', 'TreatmentDetail', 'chus_txd_surgeries', 'primary_at_surgery_peritoneum', 'yes_no',  NULL , '0', '', '', '', 'peritoneum', ''), 
('Clinicalannotation', 'TreatmentDetail', 'chus_txd_surgeries', 'primary_at_surgery_colon', 'yes_no',  NULL , '0', '', '', '', 'colon', ''), 
('Clinicalannotation', 'TreatmentDetail', 'chus_txd_surgeries', 'primary_at_surgery_breast', 'yes_no',  NULL , '0', '', '', '', 'breast', ''), 
('Clinicalannotation', 'TreatmentDetail', 'chus_txd_surgeries', 'primary_at_surgery_stomach', 'yes_no',  NULL , '0', '', '', '', 'stomach', ''), 
('Clinicalannotation', 'TreatmentDetail', 'chus_txd_surgeries', 'primary_at_surgery_rectum', 'yes_no',  NULL , '0', '', '', '', 'rectum', ''), 
('Clinicalannotation', 'TreatmentDetail', 'chus_txd_surgeries', 'primary_at_surgery_pancreas', 'yes_no',  NULL , '0', '', '', '', 'pancreas', ''), 
('Clinicalannotation', 'TreatmentDetail', 'chus_txd_surgeries', 'primary_at_surgery_melanoma', 'yes_no',  NULL , '0', '', '', '', 'melanoma', ''), 
('Clinicalannotation', 'TreatmentDetail', 'chus_txd_surgeries', 'primary_at_surgery_kidney', 'yes_no',  NULL , '0', '', '', '', 'kidney', ''), 
('Clinicalannotation', 'TreatmentDetail', 'chus_txd_surgeries', 'primary_uncertain_at_surgery', 'yes_no',  NULL , '0', '', '', '', 'primary uncertain at surgery', ''), 
('Clinicalannotation', 'TreatmentDetail', 'chus_txd_surgeries', 'cytoreduction', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='custom_cytoreduction_values') , '0', '', '', '', 'cytoreduction', ''), 
('Clinicalannotation', 'TreatmentDetail', 'chus_txd_surgeries', 'ovg_size_cm', 'float',  NULL , '0', 'size=5', '', '', 'ovary size (cm)', 'left'), 
('Clinicalannotation', 'TreatmentDetail', 'chus_txd_surgeries', 'ovd_size_cm', 'float',  NULL , '0', 'size=5', '', '', 'ovd size cm', 'right'), 
('Clinicalannotation', 'TreatmentDetail', 'chus_txd_surgeries', 'primary_at_surgery_non_hodgkin_lymphoma', 'yes_no',  NULL , '0', '', '', '', 'non hodgkin lymphoma', ''), 
('Clinicalannotation', 'TreatmentDetail', 'chus_txd_surgeries', 'primary_at_surgery_hodgkin_lymphoma', 'yes_no',  NULL , '0', '', '', '', 'hodgkin lymphoma', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='chus_txd_surgeries'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='chus_txd_surgeries' AND `field`='primary_at_surgery_ovary' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ovary' AND `language_tag`=''), '2', '40', 'primary at surgery', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_txd_surgeries'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='chus_txd_surgeries' AND `field`='primary_at_surgery_fallopian_tube' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='fallopian tube' AND `language_tag`=''), '2', '41', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_txd_surgeries'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='chus_txd_surgeries' AND `field`='primary_at_surgery_omentum' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='omentum' AND `language_tag`=''), '2', '42', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_txd_surgeries'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='chus_txd_surgeries' AND `field`='primary_at_surgery_endometrial' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='endometrial' AND `language_tag`=''), '2', '43', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_txd_surgeries'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='chus_txd_surgeries' AND `field`='primary_at_surgery_uterus' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='uterus' AND `language_tag`=''), '2', '44', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_txd_surgeries'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='chus_txd_surgeries' AND `field`='primary_at_surgery_peritoneum' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='peritoneum' AND `language_tag`=''), '2', '45', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_txd_surgeries'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='chus_txd_surgeries' AND `field`='primary_at_surgery_colon' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='colon' AND `language_tag`=''), '2', '46', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_txd_surgeries'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='chus_txd_surgeries' AND `field`='primary_at_surgery_breast' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='breast' AND `language_tag`=''), '2', '47', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_txd_surgeries'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='chus_txd_surgeries' AND `field`='primary_at_surgery_stomach' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='stomach' AND `language_tag`=''), '2', '48', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_txd_surgeries'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='chus_txd_surgeries' AND `field`='primary_at_surgery_rectum' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='rectum' AND `language_tag`=''), '2', '51', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_txd_surgeries'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='chus_txd_surgeries' AND `field`='primary_at_surgery_pancreas' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='pancreas' AND `language_tag`=''), '2', '52', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_txd_surgeries'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='chus_txd_surgeries' AND `field`='primary_at_surgery_melanoma' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='melanoma' AND `language_tag`=''), '2', '53', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_txd_surgeries'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='chus_txd_surgeries' AND `field`='primary_at_surgery_kidney' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='kidney' AND `language_tag`=''), '2', '54', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_txd_surgeries'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='chus_txd_surgeries' AND `field`='primary_uncertain_at_surgery' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='primary uncertain at surgery' AND `language_tag`=''), '2', '55', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_txd_surgeries'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='chus_txd_surgeries' AND `field`='cytoreduction' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_cytoreduction_values')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='cytoreduction' AND `language_tag`=''), '1', '32', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_txd_surgeries'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='chus_txd_surgeries' AND `field`='ovg_size_cm' AND `type`='float' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='ovary size (cm)' AND `language_tag`='left'), '1', '30', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_txd_surgeries'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='chus_txd_surgeries' AND `field`='ovd_size_cm' AND `type`='float' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='ovd size cm' AND `language_tag`='right'), '1', '31', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_txd_surgeries'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='chus_txd_surgeries' AND `field`='primary_at_surgery_non_hodgkin_lymphoma' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='non hodgkin lymphoma' AND `language_tag`=''), '2', '50', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_txd_surgeries'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='chus_txd_surgeries' AND `field`='primary_at_surgery_hodgkin_lymphoma' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='hodgkin lymphoma' AND `language_tag`=''), '2', '49', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0');

UPDATE structure_fields SET  `language_label`='' WHERE model='TreatmentDetail' AND tablename='chus_txd_surgeries' AND field='ovd_size_cm' AND `type`='float' AND structure_value_domain  IS NULL ;
UPDATE structure_formats SET `display_order`='11' WHERE structure_id=(SELECT id FROM structures WHERE alias='chus_txd_surgeries') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='chus_txd_surgeries' AND `field`='ovg_size_cm' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='13' WHERE structure_id=(SELECT id FROM structures WHERE alias='chus_txd_surgeries') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='chus_txd_surgeries' AND `field`='ovd_size_cm' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='16' WHERE structure_id=(SELECT id FROM structures WHERE alias='chus_txd_surgeries') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='chus_txd_surgeries' AND `field`='cytoreduction' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_cytoreduction_values') AND `flag_confidential`='0');

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

UPDATE structure_formats SET `display_column`='3' WHERE structure_id=(SELECT id FROM structures WHERE alias='chus_txd_surgeries') AND `display_column`='2';
UPDATE structure_formats SET `display_column`='2' WHERE structure_id=(SELECT id FROM structures WHERE alias='chus_txd_surgeries') AND `display_order` > 19 and  `display_order`  < 28;

-- OV - Radiation

INSERT INTO `treatment_controls` (`tx_method`, `disease_site`, `flag_active`, `detail_tablename`, `form_alias`, `extend_tablename`, `extend_form_alias`, `display_order`, `applied_protocol_control_id`, `extended_data_import_process`, `databrowser_label`) VALUES
('radiation', 'ovary', 1, 'chus_txd_radiations', 'treatmentmasters,chus_txd_radiations', NULL, NULL, 0, NULL, NULL, 'ovary|radiation');

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
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="post_post_surgery"),  (SELECT id FROM structure_permissible_values WHERE value="post" AND language_alias="post surgery"), "2", "1");

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'TreatmentDetail', 'chus_txd_radiations', 'pre_post_surgery', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='pre_post_surgery') , '0', '', '', '', 'pre post surgery', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='chus_txd_radiations'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='finish_date'), '1', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_txd_radiations'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='notes'), '1', '99', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_txd_radiations'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='chus_txd_radiations' AND `field`='pre_post_surgery' AND `type`='select'), '1', '50', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0');

INSERT INTO i18n (id,en,fr) VALUES ('pre post surgery', 'Pre/Post surgery', 'Pré/Post Chirurgie'),('pre surgery', 'Pre', 'Pré'),('post surgery', 'Post', 'Post');

-- OV - Chemotherapy

INSERT INTO `treatment_controls` (`tx_method`, `disease_site`, `flag_active`, `detail_tablename`, `form_alias`, `extend_tablename`, `extend_form_alias`, `display_order`, `applied_protocol_control_id`, `extended_data_import_process`, `databrowser_label`) VALUES
('chemotherapy', 'ovary', 1, 'chus_txd_chemos', 'treatmentmasters,chus_txd_chemos', NULL, NULL, 0, NULL, NULL, 'ovary|chemotherapy');

DROP TABLE IF EXISTS `chus_txd_chemos`;
CREATE TABLE IF NOT EXISTS `chus_txd_chemos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  
  pre_post_surgery varchar(50) DEFAULT NULL,
  
  `treatment_master_id` int(11) NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `tx_master_id` (`treatment_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

DROP TABLE IF EXISTS `chus_txd_chemos_revs`;
CREATE TABLE IF NOT EXISTS `chus_txd_chemos_revs` (
  `id` int(11) NOT NULL,
  
  pre_post_surgery varchar(50) DEFAULT NULL,
  
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
