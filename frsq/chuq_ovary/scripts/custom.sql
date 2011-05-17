INSERT INTO i18n (id, en, fr) VALUES
('core_installname', 'CHUQ - Ovary', 'CHUQ - Ovaire');

-- -----------------------------------------------------------------
-- PROFILE
-- -----------------------------------------------------------------

UPDATE users SET flag_active = 1 WHERE id = 1;
UPDATE groups SET flag_show_confidential = 1 WHERE id = 1;

REPLACE INTO i18n (id,en,fr) VALUES ('participant identifier', 'NS', 'NS');

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' , `flag_search`='0' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='participants')
AND structure_field_id IN (SELECT id FROM structure_fields WHERE field IN ('title','cod_confirmation_source','marital_status','middle_name', 'race', 'secondary_cod_icd10_code'));

INSERT INTO i18n (id,en,fr) VALUES 
('the submitted NS value already exists','The submitted NS value already exists!','La valeur de l''identifiant ''NS'' a déjà été enregistré!');

UPDATE structure_fields SET type = 'integer_positive', setting='size=4' WHERE field = 'participant_identifier' AND model = 'Participant';

UPDATE structure_formats SET `flag_override_type`='1', `type`='input', `flag_override_setting`='1', `setting`='size=20' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='participant_identifier' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_edit_readonly`='1', `flag_editgrid_readonly`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='participant_identifier');

UPDATE structure_fields SET flag_confidential =1
WHERE model = 'Participant' AND field IN ('first_name', 'last_name', 'date_of_birth');

UPDATE structure_fields SET flag_confidential =1
WHERE model = 'Participant' AND field IN ('first_name', 'last_name', 'date_of_birth');

-- -----------------------------------------------------------------
-- INDENTIFIER
-- -----------------------------------------------------------------

INSERT INTO misc_identifier_controls
(misc_identifier_name, misc_identifier_name_abbrev, flag_active, display_order, autoincrement_name, misc_identifier_format, flag_once_per_participant, flag_confidential) VALUES
('RAMQ', 'RAMQ', 1, 3, '', '', 1, 1),
('NO DOS', 'NO DOS', 1, 1, '', '', 1, 1),
('NO PATHO', 'NO PATHO', 1, 2, '', '', 0, 0);

UPDATE structure_formats SET `flag_add`='0', `flag_add_readonly`='0', `flag_edit`='0', `flag_edit_readonly`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='miscidentifiers') 
AND structure_field_id IN (SELECT id FROM structure_fields WHERE model='MiscIdentifier' AND tablename='misc_identifiers' 
AND field IN ('notes','effective_date','identifier_abrv','expiry_date'));

-- -----------------------------------------------------------------
-- CONSENT
-- -----------------------------------------------------------------

INSERT INTO `consent_controls` (`id`, `controls_type`, `flag_active`, `form_alias`, `detail_tablename`, `display_order`, `databrowser_label`) VALUES
(null, 'consent chuq ovary', 1, 'chuq_cd_consents', 'cd_nationals', 0, 'consent chuq ovary');

INSERT INTO structures(`alias`) VALUES ('chuq_cd_consents');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='chuq_cd_consents'), (SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='form_version' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=10' AND `default`='' AND `language_help`='help_form_version' AND `language_label`='form_version' AND `language_tag`=''), '1', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='chuq_cd_consents'), (SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='consent_status' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='consent_status')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_consent_status' AND `language_label`='consent status' AND `language_tag`=''), '1', '8', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='chuq_cd_consents'), (SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='status_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='NULL' AND `language_help`='help_status_date' AND `language_label`='status date' AND `language_tag`=''), '1', '9', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='chuq_cd_consents'), (SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='consent_signed_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_consent_signed_date' AND `language_label`='consent signed date' AND `language_tag`=''), '1', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='chuq_cd_consents'), (SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='reason_denied' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='cols=35,rows=6' AND `default`='' AND `language_help`='help_reason_denied' AND `language_label`='reason denied or withdrawn' AND `language_tag`=''), '1', '15', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='chuq_cd_consents'), (SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='notes' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='rows=3,cols=30' AND `default`='' AND `language_help`='help_notes' AND `language_label`='notes' AND `language_tag`=''), '2', '50', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');

UPDATE consent_controls set flag_active = 0 WHERE id = 1;

UPDATE structure_formats SET `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='consent_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='process_status' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='consent_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='date_first_contact' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

INSERT INTO i18n (id,en,fr) VALUES 
('consent chuq ovary','CHUQ Consent','Consentement CHUQ');

INSERT INTO structure_validations (structure_field_id, rule, language_message) VALUES
((SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `field`='consent_status'), 'notEmpty', 'value is required');

-- -----------------------------------------------------------------
-- DIAGNOSIS
-- -----------------------------------------------------------------

UPDATE `diagnosis_controls` SET flag_active=0;
INSERT INTO `diagnosis_controls` (`controls_type`, `flag_active`, `form_alias`, `detail_tablename`, `display_order`, `databrowser_label`) VALUES
 ('chuq diagnosis', 1, 'chuq_dx_all_sites', 'chuq_dx_all_sites', 1, 'chuq diagnosis');;  

CREATE TABLE chuq_dx_all_sites(
 `id` INTEGER UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
 `diagnosis_master_id` INTEGER NOT NULL,
 
 `figo` VARCHAR(20) NOT NULL DEFAULT '',
 `pathology_diagnosis` TEXT, 
 `laterality` VARCHAR(20) NOT NULL DEFAULT '',
 
 `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `modified_by` int(10) unsigned NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  FOREIGN KEY (`diagnosis_master_id`) REFERENCES `diagnosis_masters`(`id`)
)Engine=InnoDb;

CREATE TABLE chuq_dx_all_sites_revs(
 `id` INTEGER UNSIGNED NOT NULL,
 `diagnosis_master_id` INTEGER NOT NULL,
 
 `figo` VARCHAR(20) NOT NULL DEFAULT '',
 `pathology_diagnosis` TEXT, 
 `laterality` VARCHAR(20) NOT NULL DEFAULT '',
 
 `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `modified_by` int(10) unsigned NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
)Engine=InnoDb;

INSERT INTO structures(`alias`) VALUES ('chuq_dx_all_sites');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='chuq_dx_all_sites'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_identifier' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=4' AND `default`='' AND `language_help`='help_dx identifier' AND `language_label`='diagnosis identifier' AND `language_tag`=''), '1', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='chuq_dx_all_sites'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='primary_icd10_code' AND `type`='autocomplete' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=10,url=/codingicd/CodingIcd10s/autocomplete,tool=/codingicd/CodingIcd10s/tool/who' AND `default`='' AND `language_help`='help_primary code' AND `language_label`='primary disease code' AND `language_tag`=''), '2', '1', 'coding', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='chuq_dx_all_sites'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='primary_number' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=10' AND `default`='' AND `language_help`='help_primary number' AND `language_label`='primary_number' AND `language_tag`=''), '1', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='chuq_dx_all_sites'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_origin' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='origin')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_dx origin' AND `language_label`='origin' AND `language_tag`=''), '1', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='chuq_dx_all_sites'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '4', '', '0', '', '0', '', '1', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='chuq_dx_all_sites'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_date_accuracy' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='date_accuracy')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`=''), '1', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='chuq_dx_all_sites'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='age_at_dx' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '6', '', '0', '', '0', '', '1', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='chuq_dx_all_sites'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='topography' AND `type`='autocomplete' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=10,url=/codingicd/CodingIcdo3s/autocomplete/topo,tool=/codingicd/CodingIcdo3s/tool/topo' AND `default`='' AND `language_help`='help_topography' AND `language_label`='topography' AND `language_tag`=''), '2', '6', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='chuq_dx_all_sites'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='morphology' AND `type`='autocomplete' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=10,url=/codingicd/CodingIcdo3s/autocomplete/morpho,tool=/codingicd/CodingIcdo3s/tool/morpho' AND `default`='' AND `language_help`='help_morphology' AND `language_label`='morphology' AND `language_tag`=''), '2', '7', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='chuq_dx_all_sites'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='age_at_dx_accuracy' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='age_accuracy')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`=''), '1', '7', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='chuq_dx_all_sites'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_nature' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='dx_nature')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_dx nature' AND `language_label`='dx nature' AND `language_tag`=''), '1', '8', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='chuq_dx_all_sites'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='notes' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '13', '', '0', '', '0', '', '1', 'help_memo', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='chuq_dx_all_sites'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='clinical_tstage' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=1,maxlength=3' AND `default`='' AND `language_help`='' AND `language_label`='clinical stage' AND `language_tag`='t stage'), '2', '19', 'staging', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='chuq_dx_all_sites'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='clinical_nstage' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=1,maxlength=3' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='n stage'), '2', '20', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='chuq_dx_all_sites'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='clinical_mstage' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=1,maxlength=3' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='m stage'), '2', '21', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='chuq_dx_all_sites'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='clinical_stage_summary' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=1,maxlength=3' AND `default`='' AND `language_help`='help_clinical_stage_summary' AND `language_label`='' AND `language_tag`='summary'), '2', '22', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='chuq_dx_all_sites'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_tstage' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=1,maxlength=3' AND `default`='' AND `language_help`='' AND `language_label`='pathological stage' AND `language_tag`='t stage'), '2', '23', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='chuq_dx_all_sites'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_nstage' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=1,maxlength=3' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='n stage'), '2', '24', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='chuq_dx_all_sites'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_mstage' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=1,maxlength=3' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='m stage'), '2', '24', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='chuq_dx_all_sites'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_stage_summary' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=1, maxlength=3' AND `default`='' AND `language_help`='help_path_stage_summary' AND `language_label`='' AND `language_tag`='summary'), '2', '25', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='chuq_dx_all_sites'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_tissues' AND `field`='laterality' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='laterality')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='dx_laterality' AND `language_label`='laterality' AND `language_tag`=''), '2', '99', 'tissue specific', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'DiagnosisDetail', 'chuq_dx_all_sites', 'laterality', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='laterality') , '0', '', '', 'dx_laterality', 'laterality', '');
UPDATE structure_formats SET `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='chuq_dx_all_sites' AND `field`='laterality' AND `type`='select' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='laterality') ) WHERE structure_id=(SELECT id FROM structures WHERE alias='chuq_dx_all_sites') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_tissues' AND `field`='laterality' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='laterality') AND `flag_confidential`='0');

INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('chuq_ovary_grade', '', '', NULL);
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES
('1-2', '1-2'),
('2-3', '2-3'),
(1, 1),
(2, 2),
(3, 3);
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES
((SELECT id FROM structure_value_domains WHERE domain_name="chuq_ovary_grade"),  (SELECT id FROM structure_permissible_values WHERE value='1' AND language_alias='1'), 1,1),
((SELECT id FROM structure_value_domains WHERE domain_name="chuq_ovary_grade"),  (SELECT id FROM structure_permissible_values WHERE value='1-2' AND language_alias='1-2'), 2,1),
((SELECT id FROM structure_value_domains WHERE domain_name="chuq_ovary_grade"),  (SELECT id FROM structure_permissible_values WHERE value='2' AND language_alias='2'), 3,1),
((SELECT id FROM structure_value_domains WHERE domain_name="chuq_ovary_grade"),  (SELECT id FROM structure_permissible_values WHERE value='2-3' AND language_alias='2-3'), 4,1),
((SELECT id FROM structure_value_domains WHERE domain_name="chuq_ovary_grade"),  (SELECT id FROM structure_permissible_values WHERE value='3' AND language_alias='3'), 5,1);

INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('chuq_ovary_figo', '', '', NULL);
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES
('Ia', 'Ia'),
('Ib', 'Ib'),
('Ic', 'Ic'),
('IIa', 'IIa'),
('IIb', 'IIb'),
('IIc', 'IIc'),
('IIIa', 'IIIa'),
('IIIb', 'IIIb'),
('IIIc', 'IIIc'),
('IV', 'IV'),
('unknown', 'unknown');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES
((SELECT id FROM structure_value_domains WHERE domain_name="chuq_ovary_figo"), (SELECT id FROM structure_permissible_values WHERE value='Ia' AND language_alias='Ia'), 1,1),
((SELECT id FROM structure_value_domains WHERE domain_name="chuq_ovary_figo"), (SELECT id FROM structure_permissible_values WHERE value='Ib' AND language_alias='Ib'), 2,1),
((SELECT id FROM structure_value_domains WHERE domain_name="chuq_ovary_figo"), (SELECT id FROM structure_permissible_values WHERE value='Ic' AND language_alias='Ic'), 3,1),
((SELECT id FROM structure_value_domains WHERE domain_name="chuq_ovary_figo"), (SELECT id FROM structure_permissible_values WHERE value='IIa' AND language_alias='IIa'), 4,1),
((SELECT id FROM structure_value_domains WHERE domain_name="chuq_ovary_figo"), (SELECT id FROM structure_permissible_values WHERE value='IIb' AND language_alias='IIb'), 5,1),
((SELECT id FROM structure_value_domains WHERE domain_name="chuq_ovary_figo"), (SELECT id FROM structure_permissible_values WHERE value='IIc' AND language_alias='IIc'), 6,1),
((SELECT id FROM structure_value_domains WHERE domain_name="chuq_ovary_figo"), (SELECT id FROM structure_permissible_values WHERE value='IIIa' AND language_alias='IIIa'), 7,1),
((SELECT id FROM structure_value_domains WHERE domain_name="chuq_ovary_figo"), (SELECT id FROM structure_permissible_values WHERE value='IIIb' AND language_alias='IIIb'), 8,1),
((SELECT id FROM structure_value_domains WHERE domain_name="chuq_ovary_figo"), (SELECT id FROM structure_permissible_values WHERE value='IIIc' AND language_alias='IIIc'), 9,1),
((SELECT id FROM structure_value_domains WHERE domain_name="chuq_ovary_figo"), (SELECT id FROM structure_permissible_values WHERE value='IV' AND language_alias='IV'), 10,1),
((SELECT id FROM structure_value_domains WHERE domain_name="chuq_ovary_figo"), (SELECT id FROM structure_permissible_values WHERE value='unknown' AND language_alias='unknown'), 11,1);

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'DiagnosisDetail', 'chuq_dx_all_sites', 'figo', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='chuq_ovary_figo') , '0', '', '', '', 'figo', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'chuq_dx_all_sites', 'pathology_diagnosis', 'textarea',  NULL , '0', 'rows=3,cols=30', '', '', 'pathology diagnosis', ''), 
('Clinicalannotation', 'DiagnosisMaster', 'diagnosis_masters', 'tumour_grade', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='chuq_ovary_grade') , '0', '', '', '', 'tumour grade', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='chuq_dx_all_sites'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='chuq_dx_all_sites' AND `field`='figo' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='chuq_ovary_figo')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='figo' AND `language_tag`=''), '1', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chuq_dx_all_sites'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='chuq_dx_all_sites' AND `field`='pathology_diagnosis'), '1', '15', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='chuq_dx_all_sites'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='tumour_grade' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='chuq_ovary_grade')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tumour grade' AND `language_tag`=''), '1', '13', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0');

UPDATE structure_formats SET `display_order`='16' WHERE structure_id=(SELECT id FROM structures WHERE alias='chuq_dx_all_sites') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='notes' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

INSERT IGNORE INTO i18n (id,en,fr) VALUES 
('chuq diagnosis','CHUQ Diagnosis','Diagnostic CHUQ'),
('figo','Figo','Figo'),
('pathology diagnosis','Pathology Diagnosis','Diagnostic de pathologie');

-- -----------------------------------------------------------------
-- TRT
-- -----------------------------------------------------------------

UPDATE tx_controls SET flag_active = 0;

-- -----------------------------------------------------------------
-- INVENTORY GENERAL
-- -----------------------------------------------------------------

UPDATE parent_to_derivative_sample_controls SET flag_active=false WHERE id IN(131, 23, 136, 25, 3, 132, 142, 143, 144, 130, 101, 102, 140);
UPDATE sample_to_aliquot_controls SET flag_active=false WHERE id IN(23, 3, 41, 8);
UPDATE realiquoting_controls SET flag_active=false WHERE id IN(17, 3, 7, 8, 5);















