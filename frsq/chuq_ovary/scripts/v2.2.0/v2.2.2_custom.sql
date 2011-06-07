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

INSERT INTO misc_identifier_controls
(misc_identifier_name, misc_identifier_name_abbrev, flag_active, display_order, autoincrement_name, misc_identifier_format, flag_once_per_participant, flag_confidential) VALUES
('MDEIE', 'MDEIE', 1, 4, '', '', 0, 0);

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

INSERT INTO `tx_controls` (`id`, `tx_method`, `disease_site`, `flag_active`, `detail_tablename`, `form_alias`, `extend_tablename`, `extend_form_alias`, `display_order`, `applied_protocol_control_id`, `extended_data_import_process`, `databrowser_label`) VALUES
(null, 'chemotherapy', 'CHUQ', 1, 'txd_chemos', 'chuq_txd_chemos', NULL, NULL, 0, 1, NULL, 'chemotherapy'),
(null, 'radiation', 'CHUQ', 1, 'txd_radiations', 'chuq_txd_radiations', NULL, NULL, 0, NULL, NULL, 'radiation'),
(null, 'surgery', 'CHUQ', 1, 'txd_surgeries', 'chuq_txd_surgeries', NULL, NULL, 0, 2, NULL, 'surgery');

INSERT INTO structures(`alias`) VALUES ('chuq_txd_chemos'),('chuq_txd_radiations'),('chuq_txd_surgeries');

SET @ref_structre_id = (SELECT id FROM structures WHERE alias = 'txd_radiations');
SET @dest_structre_id = (SELECT id FROM structures WHERE alias = 'chuq_txd_radiations');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`)
(SELECT @dest_structre_id, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`
FROM structure_formats WHERE structure_id = @ref_structre_id);

DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='chuq_txd_radiations') 
AND structure_field_id IN (SELECT id FROM structure_fields WHERE `field` IN ('facility','information_source','protocol_master_id'));

SET @ref_structre_id = (SELECT id FROM structures WHERE alias = 'txd_surgeries');
SET @dest_structre_id = (SELECT id FROM structures WHERE alias = 'chuq_txd_surgeries');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`)
(SELECT @dest_structre_id, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`
FROM structure_formats WHERE structure_id = @ref_structre_id);

DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='chuq_txd_surgeries') 
AND structure_field_id IN (SELECT id FROM structure_fields WHERE `field` IN ('facility','target_site_icdo','information_source','protocol_master_id'));

SET @ref_structre_id = (SELECT id FROM structures WHERE alias = 'txd_chemos');
SET @dest_structre_id = (SELECT id FROM structures WHERE alias = 'chuq_txd_chemos');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`)
(SELECT @dest_structre_id, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`
FROM structure_formats WHERE structure_id = @ref_structre_id);

DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='chuq_txd_chemos') 
AND structure_field_id IN (SELECT id FROM structure_fields WHERE `field` IN ('facility','target_site_icdo','information_source','protocol_master_id'));

UPDATE structure_formats SET `flag_search`='0', `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='treatmentmasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='tx_masters' AND `field`='tx_intent' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='intent') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='0', `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='treatmentmasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='tx_masters' AND `field`='protocol_master_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='protocol_site_list') AND `flag_confidential`='0');

-- -----------------------------------------------------------------
-- ANNOTATION
-- -----------------------------------------------------------------

-- CA 125

UPDATE event_controls SET flag_active = 0;

INSERT INTO `event_controls` (`id`, `disease_site`, `event_group`, `event_type`, `flag_active`, `form_alias`, `detail_tablename`, `display_order`, `databrowser_label`) VALUES
(null, 'CHUQ', 'lab', 'ca125', 1, 'chuq_ed_labs', 'chuq_ed_labs', 0, 'lab|CHUQ|ca125');

CREATE TABLE IF NOT EXISTS `chuq_ed_labs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  
  `ca_125` decimal(10,5) DEFAULT NULL,
  
  `created` datetime DEFAULT NULL,
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime DEFAULT NULL,
  `modified_by` int(10) unsigned NOT NULL,
  `event_master_id` int(11) DEFAULT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  `breast_tumour_size` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

ALTER TABLE `chuq_ed_labs`
  ADD CONSTRAINT `chuq_ed_labs_ibfk_1` FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`);

CREATE TABLE IF NOT EXISTS `chuq_ed_labs_revs` (
  `id` int(11) NOT NULL,
  
  `ca_125` decimal(10,5) DEFAULT NULL,
  
  `created` datetime DEFAULT NULL,
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime DEFAULT NULL,
  `modified_by` int(10) unsigned NOT NULL,
  `event_master_id` int(11) DEFAULT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  `breast_tumour_size` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

INSERT INTO structures(`alias`) VALUES ('chuq_ed_labs');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'EventDetail', 'chuq_ed_labs', 'ca_125', 'float_positive',  NULL , '0', '', '', '', 'ca125', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='chuq_ed_labs'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='date' AND `language_tag`=''), '1', '1', 'ca125', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='chuq_ed_labs'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_summary' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='cols=40,rows=6' AND `default`='' AND `language_help`='' AND `language_label`='summary' AND `language_tag`=''), '1', '99', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='chuq_ed_labs'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='chuq_ed_labs' AND `field`='ca_125' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ca125' AND `language_tag`=''), '1', '90', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1');

INSERT into i18n (id,en,fr) VALUES ('ca125', 'CA125', 'CA125');

SET @id = (SELECT use_link FROM menus WHERE id = 'clin_CAN_28');
UPDATE menus SET use_link = @id WHERE id = 'clin_CAN_4';

UPDATE menus SET flag_active = 0 WHERE use_link like '%event%' AND id NOT IN ('clin_CAN_4','clin_CAN_28');

-- -----------------------------------------------------------------
-- TOOLS
-- -----------------------------------------------------------------

UPDATE menus SET flag_active = 0 WHERE use_link like '/protocol%' OR  use_link like '/drug%' OR  use_link like '/material%' OR  use_link like '/sop%' OR  use_link like '/labbok%';
UPDATE menus SET flag_active = 0 WHERE use_link like '/study%' AND use_link NOT LIKE '%listall%' AND use_link NOT LIKE '%detail%';

UPDATE structure_formats sf, structures st, structure_fields sfi 
SET sf.flag_add = 0, sf.flag_detail = 0, sf.flag_edit = 0 , sf.flag_index = 0
WHERE sf.structure_id = st.id AND sfi.id = sf.structure_field_id
AND st.alias = 'studysummaries'
AND sfi.field NOT IN ('title','summary');

-- -----------------------------------------------------------------
-- INVENTORY GENERAL
-- -----------------------------------------------------------------

INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `control_id`) 
VALUES 
('Dimcho Bachvarov', 'Dimcho Bachvarov', 'Dimcho Bachvarov', 1),
('Magdalena Batchvarova', 'Magdalena Batchvarova', 'Magdalena Batchvarova', 1);

UPDATE banks SET name = 'CHUQ Ovary/ovaire', description = '' WHERE id = 1;

UPDATE structure_formats sf, structure_fields sfi 
SET `flag_add` = 0, `flag_add_readonly` = 0, `flag_edit` = 0, `flag_edit_readonly` = 0, `flag_search` = 0, `flag_search_readonly` = 0, `flag_addgrid` = 0, `flag_addgrid_readonly` = 0, `flag_editgrid` = 0, `flag_editgrid_readonly` = 0, `flag_batchedit` = 0, `flag_batchedit_readonly` = 0, `flag_index` = 0, `flag_detail` = 0, `flag_summary` = 0
WHERE sfi.id = sf.structure_field_id
AND sfi.field IN ('sop_master_id','collection_site');

UPDATE parent_to_derivative_sample_controls SET flag_active=false WHERE id IN(131, 23, 136, 25, 3, 132, 142, 143, 144, 130, 101, 102, 140);
UPDATE sample_to_aliquot_controls SET flag_active=false WHERE id IN(23, 3, 41, 8);
UPDATE realiquoting_controls SET flag_active=false WHERE id IN(17, 3, 7, 8, 5);

-- TISSUE ----------------------------------------------------------------

INSERT IGNORE INTO i18n (id, en, fr) VALUES
('metastatic','Metastatic','Métastatique'),
('tissue nature','Tissue Nature','Nature du tissu');

INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('chuq_tissue_nature', '', '', NULL);
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Inventorymanagement', 'SampleDetail', 'sd_spe_tissues', 'tissue_nature', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='chuq_tissue_nature') , '0', '', '', '', 'tissue nature', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='sd_spe_tissues'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_spe_tissues' AND `field`='tissue_nature' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='chuq_tissue_nature')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tissue nature' AND `language_tag`=''), '1', '40', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0');

CREATE TABLE IF NOT EXISTS `chuq_tissue_code_defintions` (
  	`id` int(11) NOT NULL AUTO_INCREMENT,
	`tissue_code` varchar(50) NOT NULL UNIQUE,
	`tissue_source` varchar(50) DEFAULT NULL,
	`tissue_nature` varchar(15) DEFAULT NULL,
	`tissue_laterality` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

INSERT INTO chuq_tissue_code_defintions (tissue_code,tissue_source,tissue_laterality,tissue_nature) VALUES
('OV', 'ovary', '',''),
('OVD', 'ovary', 'right',''),
('OVG', 'ovary', 'left',''),
	
('BOV', 'ovary', '','benin'),
('BOVD', 'ovary', 'right','benin'),
('BOVG', 'ovary', 'left','benin'),
		
('KOV', 'ovary', '','cyst'),
('KOVD', 'ovary', 'right','cyst'),
('KOVG', 'ovary', 'left','cyst'),
		
('NOV', 'ovary', '','normal'),
('NOVD', 'ovary', 'right','normal'),
('NOVG', 'ovary', 'left','normal'),
		
('TOV', 'ovary', '','tumoral'),
('TOVD', 'ovary', 'right','tumoral'),
('TOVG', 'ovary', 'left','tumoral'),
		
('AP', 'other', '',''),
('APD', 'other', 'right',''),
('APG', 'other', 'left',''),
	
('NAP', 'other', '','normal'),
('NAPD', 'other', 'right','normal'),
('NAPG', 'other', 'left','normal'),
		
('TAP', 'other', '','tumoral'),
('TAPD', 'other', 'right','tumoral'),
('TAPG', 'other', 'left','tumoral'),
	
('EP', 'epiplon', '',''),
('EPD', 'epiplon', 'right',''),
('EPG', 'epiplon', 'left',''),

('NEP', 'epiplon', '','normal'),
('NEPD', 'epiplon', 'right','normal'),
('NEPG', 'epiplon', 'left','normal'),
		
('TEP', 'epiplon', '','tumoral'),
('TEPD', 'epiplon', 'right','tumoral'),
('TEPG', 'epiplon', 'left','tumoral'),
	
('IP', 'peritoneal implant', '',''),
('IPD', 'peritoneal implant', 'right',''),
('IPG', 'peritoneal implant', 'left',''),
		
('NIP', 'peritoneal implant', '','normal'),
('NIPD', 'peritoneal implant', 'right','normal'),
('NIPG', 'peritoneal implant', 'left','normal'),
		
('TIP', 'peritoneal implant', '','tumoral'),
('TIPD', 'peritoneal implant', 'right','tumoral'),
('TIPG', 'peritoneal implant', 'left','tumoral'),

('MP', 'pelvic mass', '',''),
('MPD', 'pelvic mass', 'right',''),
('MPG', 'pelvic mass', 'left',''),
		
('NMP', 'pelvic mass', '','normal'),
('NMPD', 'pelvic mass', 'right','normal'),
('NMPG', 'pelvic mass', 'left','normal'),
		
('TMP', 'pelvic mass', '','tumoral'),
('TMPD', 'pelvic mass', 'right','tumoral'),
('TMPG', 'pelvic mass', 'left','tumoral');

ALTER TABLE sd_spe_tissues
	ADD chuq_tissue_code varchar(50) DEFAULT NULL AFTER sample_master_id;
ALTER TABLE sd_spe_tissues_revs
	ADD chuq_tissue_code varchar(50) DEFAULT NULL AFTER sample_master_id;

INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES 
('chuq_tissue_code', '', '', "Inventorymanagement.TissueCodeDefintion::getTissueCodeList");	
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Inventorymanagement', 'SampleDetail', '', 'chuq_tissue_code', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='chuq_tissue_code') , '0', '', '', '', 'chuq tissue code', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='sd_spe_tissues'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='' AND `field`='chuq_tissue_code'), '1', '38', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '1');

INSERT INTO structure_validations (structure_field_id, rule, language_message) VALUES
((SELECT id FROM structure_fields WHERE model='SampleDetail' AND field='chuq_tissue_code'), 'notEmpty', 'value is required');

UPDATE structure_value_domains SET source="Inventorymanagement.TissueCodeDefintion::getTissueSourceList" WHERE domain_name='tissue_source_list';
UPDATE structure_value_domains SET source="Inventorymanagement.TissueCodeDefintion::getTissueNatureList" WHERE domain_name='chuq_tissue_nature';

INSERT INTO i18n (id,en,fr) VALUES ('chuq tissue code','Tissue Code', 'Code du tissu'),
('abdominal mass','abdominal mass','Masse abdominale'),
('benin','Benin','Bénin'),
('cyst','Cyst','Kyste'),
('endometrium','Endometrium','Endomètre'),
('epiplon','Epiplon','Epiplon'),
('nodule','Nodule','Nodule'),
('ovary','Ovary','Ovaire'),
('pelvic mass','Pelvic Mass','Masse pelvienne'),
('peritoneal implant','Peritoneal Implant','Implant péritonéale'),
('peritoneum','Peritoneum','Péritoine'),
('chuq ap precision', 'AP - Precision', 'AP - Précision');

ALTER TABLE sd_spe_tissues
	ADD chuq_ap_tissue_precision varchar(50) DEFAULT NULL AFTER chuq_tissue_code;
ALTER TABLE sd_spe_tissues_revs
	ADD chuq_ap_tissue_precision varchar(50) DEFAULT NULL AFTER chuq_tissue_code;

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Inventorymanagement', 'SampleDetail', '', 'chuq_ap_tissue_precision', 'input', NULL , '0', 'size=15', '', '', '', 'chuq ap precision');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='sd_spe_tissues'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='' AND `field`='chuq_ap_tissue_precision'), '1', '39', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0');

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0' ,`flag_add_readonly`='0', `flag_edit_readonly`='0', `flag_addgrid_readonly`='0' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_spe_tissues') 
AND structure_field_id IN (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `field` IN ('tissue_source', 'tissue_nature', 'tissue_laterality'));

ALTER TABLE specimen_details
	ADD chuq_evaluated_spent_time_from_coll int(10) DEFAULT NULL AFTER reception_datetime_accuracy,
	ADD chuq_evaluated_spent_time_from_coll_unit varchar (10) DEFAULT NULL AFTER chuq_evaluated_spent_time_from_coll;
ALTER TABLE specimen_details_revs
	ADD chuq_evaluated_spent_time_from_coll int(10) DEFAULT NULL AFTER reception_datetime_accuracy,
	ADD chuq_evaluated_spent_time_from_coll_unit varchar (10) DEFAULT NULL AFTER chuq_evaluated_spent_time_from_coll;

INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('chuq_spent_time_unit', '', '', NULL);
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES
('d', 'days'),
('h', 'hours'),
('mn', 'minutes');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES
((SELECT id FROM structure_value_domains WHERE domain_name="chuq_spent_time_unit"), (SELECT id FROM structure_permissible_values WHERE value='d' AND language_alias='days'), 1,1),
((SELECT id FROM structure_value_domains WHERE domain_name="chuq_spent_time_unit"), (SELECT id FROM structure_permissible_values WHERE value='h' AND language_alias='hours'), 2,1),
((SELECT id FROM structure_value_domains WHERE domain_name="chuq_spent_time_unit"), (SELECT id FROM structure_permissible_values WHERE value='mn' AND language_alias='minutes'), 3,1);

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Inventorymanagement', 'SpecimenDetail', '', 'chuq_evaluated_spent_time_from_coll', 'integer_positive', NULL , '0', 'size=5', '', '', 'evaluated collection to reception spent time', ''),
('Inventorymanagement', 'SpecimenDetail', '', 'chuq_evaluated_spent_time_from_coll_unit', 'select', (SELECT id FROM structure_value_domains WHERE domain_name="chuq_spent_time_unit")  , '0', '', '', '', '', 'unit');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='sd_spe_tissues'), 
(SELECT id FROM structure_fields WHERE `model`='SpecimenDetail' AND `tablename`='' AND `field`='chuq_evaluated_spent_time_from_coll'), '1', '35', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0'),
((SELECT id FROM structures WHERE alias='sd_spe_tissues'), 
(SELECT id FROM structure_fields WHERE `model`='SpecimenDetail' AND `tablename`='' AND `field`='chuq_evaluated_spent_time_from_coll_unit'), '1', '36', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='sd_spe_ascites'), 
(SELECT id FROM structure_fields WHERE `model`='SpecimenDetail' AND `tablename`='' AND `field`='chuq_evaluated_spent_time_from_coll'), '1', '35', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0'),
((SELECT id FROM structures WHERE alias='sd_spe_ascites'), 
(SELECT id FROM structure_fields WHERE `model`='SpecimenDetail' AND `tablename`='' AND `field`='chuq_evaluated_spent_time_from_coll_unit'), '1', '36', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='sd_spe_bloods'), 
(SELECT id FROM structure_fields WHERE `model`='SpecimenDetail' AND `tablename`='' AND `field`='chuq_evaluated_spent_time_from_coll'), '1', '35', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0'),
((SELECT id FROM structures WHERE alias='sd_spe_bloods'), 
(SELECT id FROM structure_fields WHERE `model`='SpecimenDetail' AND `tablename`='' AND `field`='chuq_evaluated_spent_time_from_coll_unit'), '1', '36', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='sd_spe_peritoneal_washes'), 
(SELECT id FROM structure_fields WHERE `model`='SpecimenDetail' AND `tablename`='' AND `field`='chuq_evaluated_spent_time_from_coll'), '1', '35', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0'),
((SELECT id FROM structures WHERE alias='sd_spe_peritoneal_washes'), 
(SELECT id FROM structure_fields WHERE `model`='SpecimenDetail' AND `tablename`='' AND `field`='chuq_evaluated_spent_time_from_coll_unit'), '1', '36', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0');

INSERT INTO i18n (id,en,fr) VALUES 
('evaluated collection to reception spent time', 'Collection to Reception Evaluated Spent Time', 'Délai évalué entre le pr&eacute;l&egrave;vement et la r&eacute;ception');

INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('chuq_consent_version', '', '', "StructurePermissibleValuesCustom::getCustomDropdown('chuq ovary consent version')");
UPDATE structure_fields SET `type` = 'select' , `setting` = '', `structure_value_domain` = (SELECT id FROM structure_value_domains WHERE domain_name="chuq_consent_version")
WHERE `model`='ConsentMaster' AND `field` IN ('form_version');

INSERT INTO `structure_permissible_values_custom_controls` (`id`, `name`, `flag_active`, `values_max_length`) VALUES
(null, 'chuq ovary consent version', 1, 30);

ALTER TABLE aliquot_masters
 ADD COLUMN aliquot_label VARCHAR(60) NOT NULL DEFAULT '' AFTER barcode;
ALTER TABLE aliquot_masters_revs
 ADD COLUMN aliquot_label VARCHAR(60) NOT NULL DEFAULT '' AFTER barcode;

INSERT INTO structure_fields(plugin, model, tablename, field, language_label, language_tag, `type`, `setting`, `default`, structure_value_domain, language_help) VALUES
('Inventorymanagement', 'AliquotMaster', 'aliquot_masters', 'aliquot_label', 'aliquot label', '', 'input', '', '',  NULL , '');
INSERT INTO structure_fields(plugin, model, tablename, field, language_label, language_tag, `type`, `setting`, `default`, structure_value_domain, language_help) VALUES
('Inventorymanagement', 'ViewAliquot', '', 'aliquot_label', 'aliquot label', '', 'input', '', '',  NULL , '');

INSERT INTO `structure_validations` (`id`, `structure_field_id`, `rule`, `on_action`, `language_message`) VALUES
(null, (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `field`='aliquot_label' ), 'notEmpty', '', 'value is required');

INSERT IGNORE INTO i18n (id,en,fr) VALUES ('aliquot label', 'Label', 'Étiquette');

SET @structure_field_id = (SELECT id FROM structure_fields WHERE model = 'AliquotMaster' AND field = 'aliquot_label');
INSERT INTO structure_formats(structure_id, structure_field_id, display_column, display_order, language_heading, flag_override_label, language_label, flag_override_tag, language_tag, flag_override_help, language_help, flag_override_type, `type`, flag_override_setting, `setting`, flag_override_default, `default`, flag_add, flag_add_readonly, flag_edit, flag_edit_readonly, flag_search, flag_search_readonly, flag_addgrid, flag_addgrid_readonly, flag_editgrid, flag_editgrid_readonly, flag_batchedit, flag_batchedit_readonly, flag_index, flag_detail, flag_summary) 
SELECT 
sf.structure_id, @structure_field_id, sf.display_column, (sf.display_order +1), '', sf.flag_override_label, sf.language_label, sf.flag_override_tag, sf.language_tag, sf.flag_override_help, sf.language_help, sf.flag_override_type, sf.type, sf.flag_override_setting, sf.setting, sf.flag_override_default, sf.default, 
sf.flag_add, sf.flag_add_readonly, sf.flag_edit, sf.flag_edit_readonly, sf.flag_search, sf.flag_search_readonly, sf.flag_addgrid, sf.flag_addgrid_readonly, sf.flag_editgrid, sf.flag_editgrid_readonly, sf.flag_batchedit, sf.flag_batchedit_readonly, sf.flag_index, sf.flag_detail, sf.flag_summary
FROM structure_formats AS sf 
INNER JOIN structure_fields AS bc_field ON bc_field.id = sf.structure_field_id 
INNER JOIN structures AS str ON str.id = sf.structure_id
WHERE  bc_field.model = 'AliquotMaster' AND bc_field.field = 'barcode' 
AND str.alias NOT IN ('lab_book_realiquotings_summary');

UPDATE structure_formats sf, structures str, structure_fields sfield
 SET sf.flag_add = '0' 
 WHERE sfield.id = sf.structure_field_id AND str.id = sf.structure_id
 AND str.alias IN ('orderitems') AND sfield.field = 'aliquot_label';

SET @structure_field_id = (SELECT id FROM structure_fields WHERE model = 'ViewAliquot' AND field = 'aliquot_label');
INSERT INTO structure_formats(structure_id, structure_field_id, display_column, display_order, language_heading, flag_override_label, language_label, flag_override_tag, language_tag, flag_override_help, language_help, flag_override_type, `type`, flag_override_setting, `setting`, flag_override_default, `default`, flag_add, flag_add_readonly, flag_edit, flag_edit_readonly, flag_search, flag_search_readonly, flag_addgrid, flag_addgrid_readonly, flag_editgrid, flag_editgrid_readonly, flag_batchedit, flag_batchedit_readonly, flag_index, flag_detail, flag_summary) 
(SELECT 
sf.structure_id, @structure_field_id, sf.display_column, (sf.display_order +1), '', sf.flag_override_label, sf.language_label, sf.flag_override_tag, sf.language_tag, sf.flag_override_help, sf.language_help, sf.flag_override_type, sf.type, sf.flag_override_setting, sf.setting, sf.flag_override_default, sf.default, 
sf.flag_add, sf.flag_add_readonly, sf.flag_edit, sf.flag_edit_readonly, sf.flag_search, sf.flag_search_readonly, sf.flag_addgrid, sf.flag_addgrid_readonly, sf.flag_editgrid, sf.flag_editgrid_readonly, sf.flag_batchedit, sf.flag_batchedit_readonly, sf.flag_index, sf.flag_detail, sf.flag_summary
FROM structure_formats AS sf 
INNER JOIN structure_fields AS bc_field ON bc_field.id = sf.structure_field_id 
WHERE  bc_field.model = 'ViewAliquot' AND bc_field.field = 'barcode');

DROP VIEW view_aliquots;
CREATE VIEW view_aliquots AS 
SELECT 
al.id AS aliquot_master_id,
al.sample_master_id AS sample_master_id,
al.collection_id AS collection_id, 
col.bank_id, 
al.storage_master_id AS storage_master_id,
link.participant_id, 
link.diagnosis_master_id, 
link.consent_master_id,

part.participant_identifier, 

col.acquisition_label, 

specimen.sample_type AS initial_specimen_sample_type,
specimen.sample_control_id AS initial_specimen_sample_control_id,
parent_samp.sample_type AS parent_sample_type,
parent_samp.sample_control_id AS parent_sample_control_id,
samp.sample_type,
samp.sample_control_id,

al.barcode,
al.aliquot_label,
al.aliquot_type,
al.aliquot_control_id,
al.in_stock,

stor.code,
stor.selection_label,
al.storage_coord_x,
al.storage_coord_y,

stor.temperature,
stor.temp_unit,

al.created,
al.deleted

FROM aliquot_masters as al
INNER JOIN sample_masters as samp ON samp.id = al.sample_master_id AND samp.deleted != 1
INNER JOIN collections AS col ON col.id = samp.collection_id AND col.deleted != 1
LEFT JOIN sample_masters as specimen ON samp.initial_specimen_sample_id = specimen.id AND specimen.deleted != 1
LEFT JOIN sample_masters as parent_samp ON samp.parent_id = parent_samp.id AND parent_samp.deleted != 1
LEFT JOIN clinical_collection_links AS link ON col.id = link.collection_id AND link.deleted != 1
LEFT JOIN participants AS part ON link.participant_id = part.id AND part.deleted != 1
LEFT JOIN storage_masters AS stor ON stor.id = al.storage_master_id AND stor.deleted != 1
WHERE al.deleted != 1;

INSERT INTO i18n (id, en, fr) VALUES
("sample system code", "Sample System Code", "Code système d'échantillon"),
("aliquot system code", "Aliquot system code", "Code système d'aliquot");

-- update sample code label to sample system code
UPDATE structure_fields SET language_label='sample system code' WHERE field='sample_code';

CREATE TABLE tmp
(SELECT sf1.id, MAX(sf2.display_column) AS display_column, MAX(sf2.display_order) AS display_order FROM structure_formats AS sf1 
INNER JOIN structure_formats AS sf2 ON sf1.structure_id=sf2.structure_id
WHERE sf1.structure_field_id IN (SELECT id FROM structure_fields WHERE field='sample_code')
GROUP BY sf1.structure_id);

UPDATE structure_formats AS sf1 
INNER JOIN tmp AS sf2 USING(id)
SET sf1.display_column=sf2.display_column, sf1.display_order=sf2.display_order + 1;

DROP TABLE tmp;

UPDATE structure_formats SET `language_heading`='system data' 
WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE field='sample_code');

INSERT IGNORE INTO i18n (id,en,fr) VALUES
('system data', 'System Data', 'Données système');

CREATE TABLE tmp
(SELECT sf1.id, MAX(sf2.display_column) AS display_column, MAX(sf2.display_order) AS display_order FROM structure_formats AS sf1 
INNER JOIN structure_formats AS sf2 ON sf1.structure_id=sf2.structure_id
WHERE sf1.structure_field_id IN (SELECT id FROM structure_fields WHERE field='barcode' AND model IN('AliquotMaster', 'AliquotMasterChildren', 'ViewAliquot'))
GROUP BY sf1.structure_id);

UPDATE structure_formats AS sf1 
INNER JOIN tmp AS sf2 USING(id)
SET sf1.display_column=sf2.display_column, sf1.display_order=sf2.display_order + 1, sf1.flag_add=0, sf1.flag_edit_readonly='1', sf1.flag_addgrid=0, sf1.flag_editgrid_readonly='1', sf1.flag_batchedit_readonly='1';

DROP TABLE tmp;

-- rename barcode to aliquot system code
UPDATE structure_fields
SET language_label='aliquot system code'
WHERE field='barcode' AND model IN('AliquotMaster', 'AliquotMasterChildren', 'ViewAliquot');

SET @display_order = (SELECT display_order FROM structure_formats 
WHERE structure_id = (SELECT id FROM structures WHERE  alias='aliquot_masters') 
AND structure_field_id IN (SELECT id FROM structure_fields WHERE field = 'barcode' AND model IN('AliquotMaster')));

UPDATE structure_formats
SET display_order = (@display_order + 1)
WHERE structure_id IN (SELECT id FROM structures WHERE  alias LIKE 'ad_%')
AND structure_field_id IN (SELECT id FROM structure_fields WHERE field = 'created' AND model IN('AliquotMaster'));

UPDATE structure_formats
SET language_heading = 'system data'
WHERE structure_id IN (SELECT id FROM structures WHERE  alias = 'aliquot_masters')
AND structure_field_id IN (SELECT id FROM structure_fields WHERE field = 'barcode' AND model IN('AliquotMaster'));

UPDATE structure_formats AS sfo, structure_fields AS sfi
SET sfo.flag_add = '0', sfo.flag_add_readonly = '0', 
sfo.flag_edit = '0', sfo.flag_edit_readonly = '0',
sfo.flag_search = '0', sfo.flag_search_readonly = '0',
sfo.flag_index = '0', sfo.flag_detail = '0'
WHERE sfi.field = 'barcode'
AND  sfi.model = 'StorageMaster'
AND sfi.id = sfo.structure_field_id;

DROP VIEW view_samples;
CREATE VIEW view_samples AS 
SELECT 
samp.id AS sample_master_id,
samp.parent_id AS parent_sample_id,
samp.initial_specimen_sample_id,
samp.collection_id AS collection_id,

col.bank_id, 
col.sop_master_id, 
link.participant_id, 
link.diagnosis_master_id, 
link.consent_master_id,

part.participant_identifier, 

col.acquisition_label, 
col.collection_datetime, 

specimen.sample_type AS initial_specimen_sample_type,
specimen.sample_control_id AS initial_specimen_sample_control_id,
parent_samp.sample_type AS parent_sample_type,
parent_samp.sample_control_id AS parent_sample_control_id,
samp.sample_type,
samp.sample_control_id,
samp.sample_code,
samp.sample_category,
samp.deleted

FROM sample_masters as samp
INNER JOIN collections AS col ON col.id = samp.collection_id AND col.deleted != 1
LEFT JOIN sample_masters as specimen ON samp.initial_specimen_sample_id = specimen.id AND specimen.deleted != 1
LEFT JOIN sample_masters as parent_samp ON samp.parent_id = parent_samp.id AND parent_samp.deleted != 1
LEFT JOIN clinical_collection_links AS link ON col.id = link.collection_id AND link.deleted != 1
LEFT JOIN participants AS part ON link.participant_id = part.id AND part.deleted != 1
WHERE samp.deleted != 1;

UPDATE structure_formats
SET flag_add=0, flag_edit=0, flag_addgrid=0, flag_editgrid=0, flag_search=0, flag_index=0, flag_detail=0, flag_batchedit=0, flag_summary=0
WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE field IN('lab_book_master_code', 'lab_book_master_id', 'sync_with_lab_book', 'sync_with_lab_book_now'));

UPDATE structure_formats SET `language_heading`='', `flag_add`='0', `flag_addgrid`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='in_stock_detail') AND structure_field_id IN (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='barcode' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='parent aliquot data update' WHERE structure_id=(SELECT id FROM structures WHERE alias='in_stock_detail') AND structure_field_id IN (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='aliquot_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

SET @sample_control_id = (SELECT id FROM sample_controls WHERE sample_type = 'blood');
SET @old_aliquot_control_id = (SELECT aliquot_control_id FROM sample_to_aliquot_controls AS link
INNER JOIN aliquot_controls as al on link.aliquot_control_id = al.id
WHERE link.sample_control_id = (SELECT id FROM sample_controls WHERE sample_type = 'blood')
AND aliquot_type = 'tube');

INSERT INTO aliquot_controls (aliquot_type, aliquot_type_precision, form_alias, detail_tablename, volume_unit, comment, display_order, databrowser_label) VALUES
('tube', 'blood tube', 'aliquot_masters,ad_spec_tubes_incl_ml_vol,chuq_blood_tube_solution', 'ad_tubes', 'ml', 'Blood tube', 0, 'tube');
SET @new_aliquot_control_id = LAST_INSERT_ID();

UPDATE sample_to_aliquot_controls SET aliquot_control_id=@new_aliquot_control_id WHERE aliquot_control_id=@old_aliquot_control_id
AND sample_control_id = @sample_control_id;

ALTER TABLE ad_tubes
	ADD chuq_blood_solution varchar(20) DEFAULT NULL AFTER cell_count_unit;
ALTER TABLE ad_tubes_revs
	ADD chuq_blood_solution varchar(20) DEFAULT NULL AFTER cell_count_unit;

INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('chuq_blood_solutions', '', '', NULL);
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES
('RNA later', 'RNA later');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES
((SELECT id FROM structure_value_domains WHERE domain_name="chuq_blood_solutions"), 
(SELECT id FROM structure_permissible_values WHERE value='RNA later' AND language_alias='RNA later'), 1,1);

INSERT INTO structures (alias) VALUES ('chuq_blood_tube_solution');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Inventorymanagement', 'SampleDetail', '', 'chuq_blood_solution', 'select', (SELECT id FROM structure_value_domains WHERE domain_name="chuq_blood_solutions") , '0', '', '', '', '', 'storage solution');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='chuq_blood_tube_solution'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `field`='chuq_blood_solution'), 
'1', '75', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0');

INSERT into i18n (id,en,fr) VALUES ('storage solution', 'Storage Solution', 'Solution d''entreposage');

