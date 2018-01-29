-- ----------------------------------------------------------------------------------------------------------------------------------------
-- Reports
-- ----------------------------------------------------------------------------------------------------------------------------------------

UPDATE datamart_browsing_controls SET flag_active_1_to_2 = '0', flag_active_2_to_1 = '0' 
WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'ParticipantContact') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'Participant');

UPDATE datamart_structure_functions SET flag_active = 0 
WHERE label IN ('add to order', 'create tma slide', 'edit', 'create participant message (applied to all)', 'defined as returned', 'edit', 'add to order');

-- ----------------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------------------------------------

UPDATE versions SET site_branch_build_number = '6473' WHERE version_number = '2.6.7';
UPDATE versions SET permissions_regenerated = 0;

-- ----------------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------------------------------------

ALTER TABLE procure_ed_lab_pathologies MODIFY histology_other_precision varchar(250) DEFAULT NULL;
ALTER TABLE procure_ed_lab_pathologies_revs MODIFY histology_other_precision varchar(250) DEFAULT NULL;

UPDATE datamart_browsing_controls SET flag_active_1_to_2 = '0', flag_active_2_to_1 = '0' 
WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'ViewAliquot') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'StudySummary');

INSERT IGNORE INTO i18n (id,en,fr) 
VALUES 
('no data', 'No Data', 'Aucune données'),
('report limited to', 'Report limited to', 'Rapport limité à');

UPDATE structure_fields SET language_label = "encountered patients with no collection"  WHERE language_label = "encountered patients with collection with no collection";
INSERT IGNORE INTO i18n (id,en,fr) 
VALUES
('encountered patients with no collection', 'Encountered patients with no collection', "Patients recontrés sans collection");

REPLACE INTO i18n (id,en,fr) 
VALUES
('patients whose clinical data have been updated', 'Patients with at least one clinical event (recorded into ATiM)', "Patients ayant au moins un événement clinique (enregistré dans ATiM)");

UPDATE versions SET site_branch_build_number = '6748' WHERE version_number = '2.6.8';
UPDATE versions SET permissions_regenerated = 0;

-- ----------------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------------------------------------

ALTER TABLE `study_summaries`
  CHANGE COLUMN `procure_site_ethics_committee_convenience_chum` `procure_site_ethics_committee_convenience_ps1` char(1) DEFAULT '',
  CHANGE COLUMN `procure_site_ethics_committee_convenience_chus` `procure_site_ethics_committee_convenience_ps4` char(1) DEFAULT '',
  CHANGE COLUMN `procure_site_ethics_committee_convenience_chuq` `procure_site_ethics_committee_convenience_ps2` char(1) DEFAULT '',
  CHANGE COLUMN `procure_site_ethics_committee_convenience_cusm` `procure_site_ethics_committee_convenience_ps3` char(1) DEFAULT '';

ALTER TABLE `study_summaries_revs`
  CHANGE COLUMN `procure_site_ethics_committee_convenience_chum` `procure_site_ethics_committee_convenience_ps1` char(1) DEFAULT '',
  CHANGE COLUMN `procure_site_ethics_committee_convenience_chus` `procure_site_ethics_committee_convenience_ps4` char(1) DEFAULT '',
  CHANGE COLUMN `procure_site_ethics_committee_convenience_chuq` `procure_site_ethics_committee_convenience_ps2` char(1) DEFAULT '',
  CHANGE COLUMN `procure_site_ethics_committee_convenience_cusm` `procure_site_ethics_committee_convenience_ps3` char(1) DEFAULT '';

UPDATE structure_fields SET field = 'procure_site_ethics_committee_convenience_ps1', language_label = 'PS1' WHERE field = 'procure_site_ethics_committee_convenience_chum';
UPDATE structure_fields SET field = 'procure_site_ethics_committee_convenience_ps2', language_label = 'PS2' WHERE field = 'procure_site_ethics_committee_convenience_chuq';
UPDATE structure_fields SET field = 'procure_site_ethics_committee_convenience_ps3', language_label = 'PS3' WHERE field = 'procure_site_ethics_committee_convenience_cusm';
UPDATE structure_fields SET field = 'procure_site_ethics_committee_convenience_ps4', language_label = 'PS4' WHERE field = 'procure_site_ethics_committee_convenience_chus';

DELETE FROM i18n WHERE id IN ('chum', 'cusm', 'chuq', 'chus');

-- Add CHUM (PS1) consent field

INSERT INTO structures(`alias`) VALUES ('qc_cd_ps1');
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("ps1_stop_followup", "", "", NULL);
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES ("y","yes"),("n","no"),("y-pho.acc.","yes (but accept to be contacted)");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) 
VALUES 
((SELECT id FROM structure_value_domains WHERE domain_name="ps1_stop_followup"), (SELECT id FROM structure_permissible_values WHERE value="n" AND language_alias="no"), "1", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ps1_stop_followup"), (SELECT id FROM structure_permissible_values WHERE value="y" AND language_alias="yes"), "1", "2"),
((SELECT id FROM structure_value_domains WHERE domain_name="ps1_stop_followup"), (SELECT id FROM structure_permissible_values WHERE value="y-pho.acc."), "1", "4");
INSERT IGNORE INTO i18n (id,en,fr) 
VALUES 
("yes (but accept to be contacted)","Yes (But accept to be contacted)","Oui (Mais accepte d'être contacté"),
('participant stopped the followup but accept to be contacted', 'Participant stopped the followup but accept to be contacted', 'Le participant a arrêté le suivi mais accepte d''être contacté');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'ConsentDetail', 'procure_cd_sigantures', 'ps1_biological_material_use', 'yes_no',  NULL , '0', '', '', '', 'biological material use', ''), 
('ClinicalAnnotation', 'ConsentDetail', 'procure_cd_sigantures', 'ps1_use_of_urine', 'yes_no',  NULL , '0', '', '', '', 'use of urine', ''), 
('ClinicalAnnotation', 'ConsentDetail', 'procure_cd_sigantures', 'ps1_use_of_blood', 'yes_no',  NULL , '0', '', '', '', 'use of blood', ''), 
('ClinicalAnnotation', 'ConsentDetail', 'procure_cd_sigantures', 'ps1_research_other_disease', 'yes_no',  NULL , '0', '', '', '', 'research other disease', ''), 
('ClinicalAnnotation', 'ConsentDetail', 'procure_cd_sigantures', 'ps1_urine_blood_use_for_followup', 'yes_no',  NULL , '0', '', '', '', 'urine blood use for followup', ''), 
('ClinicalAnnotation', 'ConsentDetail', 'procure_cd_sigantures', 'ps1_stop_followup', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ps1_stop_followup') , '0', '', '', '', 'stop followup', ''), 
('ClinicalAnnotation', 'ConsentDetail', 'procure_cd_sigantures', 'ps1_stop_followup_date', 'date',  NULL , '0', '', '', '', 'stop followup date', ''), 
('ClinicalAnnotation', 'ConsentDetail', 'procure_cd_sigantures', 'ps1_allow_questionnaire', 'yes_no',  NULL , '0', '', '', '', 'allow questionnaire', ''), 
('ClinicalAnnotation', 'ConsentDetail', 'procure_cd_sigantures', 'ps1_stop_questionnaire', 'yes_no',  NULL , '0', '', '', '', 'stop questionnaire', ''), 
('ClinicalAnnotation', 'ConsentDetail', 'procure_cd_sigantures', 'ps1_stop_questionnaire_date', 'date',  NULL , '0', '', '', '', 'stop questionnaire date', ''), 
('ClinicalAnnotation', 'ConsentDetail', 'procure_cd_sigantures', 'ps1_contact_for_additional_data', 'yes_no',  NULL , '0', '', '', '', 'contact for additional data', ''), 
('ClinicalAnnotation', 'ConsentDetail', 'procure_cd_sigantures', 'ps1_inform_significant_discovery', 'yes_no',  NULL , '0', '', '', '', 'inform significant discovery', ''), 
('ClinicalAnnotation', 'ConsentDetail', 'procure_cd_sigantures', 'ps1_inform_discovery_on_other_disease', 'yes_no',  NULL , '0', '', '', '', 'inform discovery on other disease', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_cd_ps1'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='procure_cd_sigantures' AND `field`='ps1_biological_material_use' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='biological material use' AND `language_tag`=''), '2', '1', 'PS1', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_cd_ps1'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='procure_cd_sigantures' AND `field`='ps1_use_of_urine' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='use of urine' AND `language_tag`=''), '2', '2', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_cd_ps1'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='procure_cd_sigantures' AND `field`='ps1_use_of_blood' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='use of blood' AND `language_tag`=''), '2', '3', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_cd_ps1'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='procure_cd_sigantures' AND `field`='ps1_research_other_disease' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='research other disease' AND `language_tag`=''), '2', '4', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_cd_ps1'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='procure_cd_sigantures' AND `field`='ps1_urine_blood_use_for_followup' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='urine blood use for followup' AND `language_tag`=''), '2', '10', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_cd_ps1'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='procure_cd_sigantures' AND `field`='ps1_stop_followup' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ps1_stop_followup')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='stop followup' AND `language_tag`=''), '2', '11', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_cd_ps1'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='procure_cd_sigantures' AND `field`='ps1_stop_followup_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='stop followup date' AND `language_tag`=''), '2', '12', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_cd_ps1'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='procure_cd_sigantures' AND `field`='ps1_allow_questionnaire' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='allow questionnaire' AND `language_tag`=''), '2', '30', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_cd_ps1'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='procure_cd_sigantures' AND `field`='ps1_stop_questionnaire' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='stop questionnaire' AND `language_tag`=''), '2', '31', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_cd_ps1'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='procure_cd_sigantures' AND `field`='ps1_stop_questionnaire_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='stop questionnaire date' AND `language_tag`=''), '2', '32', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_cd_ps1'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='procure_cd_sigantures' AND `field`='ps1_contact_for_additional_data' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='contact for additional data' AND `language_tag`=''), '2', '39', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_cd_ps1'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='procure_cd_sigantures' AND `field`='ps1_inform_significant_discovery' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='inform significant discovery' AND `language_tag`=''), '2', '40', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_cd_ps1'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='procure_cd_sigantures' AND `field`='ps1_inform_discovery_on_other_disease' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='inform discovery on other disease' AND `language_tag`=''), '2', '42', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
UPDATE consent_controls 
SET detail_form_alias = CONCAT(detail_form_alias, ',qc_cd_ps1') WHERE controls_type = 'procure consent form signature';
ALTER TABLE `procure_cd_sigantures`
  ADD COLUMN   `ps1_biological_material_use` varchar(50) DEFAULT NULL,
  ADD COLUMN   `ps1_use_of_urine` varchar(50) DEFAULT NULL,
  ADD COLUMN   `ps1_use_of_blood` varchar(50) DEFAULT NULL,
  ADD COLUMN   `ps1_research_other_disease` varchar(50) DEFAULT NULL,
  ADD COLUMN   `ps1_urine_blood_use_for_followup` varchar(10) DEFAULT NULL,
  ADD COLUMN   `ps1_stop_followup` varchar(10) DEFAULT NULL,
  ADD COLUMN   `ps1_stop_followup_date` date DEFAULT NULL,
  ADD COLUMN   `ps1_allow_questionnaire` varchar(10) DEFAULT NULL,
  ADD COLUMN   `ps1_stop_questionnaire` varchar(10) DEFAULT NULL,
  ADD COLUMN   `ps1_stop_questionnaire_date` date DEFAULT NULL,
  ADD COLUMN   `ps1_contact_for_additional_data` varchar(10) DEFAULT NULL,
  ADD COLUMN   `ps1_inform_significant_discovery` varchar(50) DEFAULT NULL,
  ADD COLUMN   `ps1_inform_discovery_on_other_disease` varchar(10) DEFAULT NULL;
INSERT IGNORE INTO i18n (id,en,fr)
VALUES
("allow questionnaire", "Allow Questionnaire", "Autorise questionnaire"),
("biological material use", "Biological Material Use", "Utilisation du materiel biologique"),
("contact for additional data", "Contact for additional data", "Contact pour données suplémentaires"),
("inform discovery on other disease", "Inform discovery on other disease", "Informer des découvertes sur autre maladie"),
("inform significant discovery", "Inform of disease significant discovery", "Informer des découvertes importantes sur la maladie"),
("research other disease", "Research On Other Diseases", "Recherche sur autres maladies"),
("stop followup", "Stop Followup", "Arrêt du suivi"),
("stop followup date", "Stop Date", "Date d'arrêt"),
("stop questionnaire", "Stop Questionnaire", "Arrêt du questionnaire"),
("stop questionnaire date", "Stop Date", "Date d'arrêt"),
("urine blood use for followup", "Urine/Blood Use For Followup", "Utilisation urine/sang pour suivi"),
("use of blood", "Use of Blood", "Utilisation du sang"),
("use of urine", "Use of Urine", "Utilisation de l'urine");

-- Add CHUQ consent field (PS2)

INSERT INTO structures(`alias`) VALUES ('qc_cd_ps2');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'ConsentDetail', 'procure_cd_sigantures', 'ps2_tissue', 'yes_no',  NULL , '0', '', '', '', 'tissue', ''), 
('ClinicalAnnotation', 'ConsentDetail', 'procure_cd_sigantures', 'ps2_blood', 'yes_no',  NULL , '0', '', '', '', 'blood', ''), 
('ClinicalAnnotation', 'ConsentDetail', 'procure_cd_sigantures', 'ps2_urine', 'yes_no',  NULL , '0', '', '', '', 'urine', ''), 
('ClinicalAnnotation', 'ConsentDetail', 'procure_cd_sigantures', 'ps2_followup', 'yes_no',  NULL , '0', '', '', '', 'followup', ''), 
('ClinicalAnnotation', 'ConsentDetail', 'procure_cd_sigantures', 'ps2_questionnaire', 'yes_no',  NULL , '0', '', '', '', 'questionnaire', ''), 
('ClinicalAnnotation', 'ConsentDetail', 'procure_cd_sigantures', 'ps2_contact_for_additional_data', 'yes_no',  NULL , '0', '', '', '', 'contact for additional data', ''), 
('ClinicalAnnotation', 'ConsentDetail', 'procure_cd_sigantures', 'ps2_inform_significant_discovery', 'yes_no',  NULL , '0', '', '', '', 'inform significant discovery', ''), 
('ClinicalAnnotation', 'ConsentDetail', 'procure_cd_sigantures', 'ps2_contact_in_case_of_death', 'yes_no',  NULL , '0', '', '', '', 'contact in case of death', ''), 
('ClinicalAnnotation', 'ConsentDetail', 'procure_cd_sigantures', 'ps2_witness', 'yes_no',  NULL , '0', '', '', '', 'witness', ''), 
('ClinicalAnnotation', 'ConsentDetail', 'procure_cd_sigantures', 'ps2_complete', 'yes_no',  NULL , '0', '', '', '', 'complete', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_cd_ps2'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='procure_cd_sigantures' AND `field`='ps2_tissue' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tissue' AND `language_tag`=''), '2', '20', 'PS2', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_cd_ps2'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='procure_cd_sigantures' AND `field`='ps2_blood' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='blood' AND `language_tag`=''), '2', '21', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_cd_ps2'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='procure_cd_sigantures' AND `field`='ps2_urine' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='urine' AND `language_tag`=''), '2', '22', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_cd_ps2'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='procure_cd_sigantures' AND `field`='ps2_followup' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='followup' AND `language_tag`=''), '2', '23', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_cd_ps2'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='procure_cd_sigantures' AND `field`='ps2_questionnaire' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='questionnaire' AND `language_tag`=''), '2', '24', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_cd_ps2'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='procure_cd_sigantures' AND `field`='ps2_contact_for_additional_data' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='contact for additional data' AND `language_tag`=''), '2', '25', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_cd_ps2'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='procure_cd_sigantures' AND `field`='ps2_inform_significant_discovery' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='inform significant discovery' AND `language_tag`=''), '2', '26', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_cd_ps2'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='procure_cd_sigantures' AND `field`='ps2_contact_in_case_of_death' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='contact in case of death' AND `language_tag`=''), '2', '27', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_cd_ps2'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='procure_cd_sigantures' AND `field`='ps2_witness' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='witness' AND `language_tag`=''), '2', '28', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_cd_ps2'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='procure_cd_sigantures' AND `field`='ps2_complete' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='complete' AND `language_tag`=''), '2', '29', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
UPDATE structure_formats SET display_order = (100+display_order) WHERE structure_id = (SELECT id FROM structures WHERE alias='qc_cd_ps2');
UPDATE structure_formats SET display_column = 3 WHERE structure_id = (SELECT id FROM structures WHERE alias='qc_cd_ps2');
UPDATE consent_controls 
SET detail_form_alias = CONCAT(detail_form_alias, ',qc_cd_ps2') WHERE controls_type = 'procure consent form signature';
INSERT IGNORE INTO i18n (id,en,fr)
VALUES
("contact in case of death", "Contact in Case of Death", "Contact en cas de décès"),
("witness", "Witness", "Témoin");
ALTER TABLE `procure_cd_sigantures`
  ADD COLUMN  `ps2_tissue` char(1) DEFAULT '',
  ADD COLUMN  `ps2_blood` char(1) DEFAULT '',
  ADD COLUMN  `ps2_urine` char(1) DEFAULT '',
  ADD COLUMN  `ps2_followup` char(1) DEFAULT '',
  ADD COLUMN  `ps2_questionnaire` char(1) DEFAULT '',
  ADD COLUMN  `ps2_contact_for_additional_data` char(1) DEFAULT '',
  ADD COLUMN  `ps2_inform_significant_discovery` char(1) DEFAULT '',
  ADD COLUMN  `ps2_contact_in_case_of_death` char(1) DEFAULT '',
  ADD COLUMN  `ps2_witness` char(1) DEFAULT '',
  ADD COLUMN  `ps2_complete` char(1) DEFAULT '';
ALTER TABLE `procure_cd_sigantures_revs`
  ADD COLUMN  `ps2_tissue` char(1) DEFAULT '',
  ADD COLUMN  `ps2_blood` char(1) DEFAULT '',
  ADD COLUMN  `ps2_urine` char(1) DEFAULT '',
  ADD COLUMN  `ps2_followup` char(1) DEFAULT '',
  ADD COLUMN  `ps2_questionnaire` char(1) DEFAULT '',
  ADD COLUMN  `ps2_contact_for_additional_data` char(1) DEFAULT '',
  ADD COLUMN  `ps2_inform_significant_discovery` char(1) DEFAULT '',
  ADD COLUMN  `ps2_contact_in_case_of_death` char(1) DEFAULT '',
  ADD COLUMN  `ps2_witness` char(1) DEFAULT '',
  ADD COLUMN  `ps2_complete` char(1) DEFAULT '';
  
-- Add CUSM consent field (PS3)

INSERT INTO structures(`alias`) VALUES ('qc_cd_ps3');
UPDATE consent_controls 
SET detail_form_alias = CONCAT(detail_form_alias, ',qc_cd_ps3') WHERE controls_type = 'procure consent form signature';

-- Add CHUS consent field (PS4)

INSERT INTO structures(`alias`) VALUES ('qc_cd_ps4');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'ConsentDetail', 'procure_cd_sigantures', 'ps4_contact_for_more_info', 'yes_no',  NULL , '0', '', '', '', 'contact if need more information', ''), 
('ClinicalAnnotation', 'ConsentDetail', 'procure_cd_sigantures', 'ps4_contact_if_scientific_discovery', 'yes_no',  NULL , '0', '', '', '', 'contact if scientific discovery', ''), 
('ClinicalAnnotation', 'ConsentDetail', 'procure_cd_sigantures', 'ps4_study_on_other_diseases', 'yes_no',  NULL , '0', '', '', '', 'study on other disease', ''), 
('ClinicalAnnotation', 'ConsentDetail', 'procure_cd_sigantures', 'ps4_contact_if_discovery_on_other_diseases', 'yes_no',  NULL , '0', '', '', '', 'contact if discovered on other diseases', ''), 
('ClinicalAnnotation', 'ConsentDetail', 'procure_cd_sigantures', 'ps4_other_contacts_in_case_of_death', 'yes_no',  NULL , '0', '', '', '', 'other contacts in case of death', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_cd_ps4'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='procure_cd_sigantures' AND `field`='ps4_contact_for_more_info' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='contact if need more information' AND `language_tag`=''), '3', '30', 'PS4', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_cd_ps4'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='procure_cd_sigantures' AND `field`='ps4_contact_if_scientific_discovery' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='contact if scientific discovery' AND `language_tag`=''), '3', '31', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_cd_ps4'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='procure_cd_sigantures' AND `field`='ps4_study_on_other_diseases' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='study on other disease' AND `language_tag`=''), '3', '32', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_cd_ps4'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='procure_cd_sigantures' AND `field`='ps4_contact_if_discovery_on_other_diseases' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='contact if discovered on other diseases' AND `language_tag`=''), '3', '33', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_cd_ps4'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='procure_cd_sigantures' AND `field`='ps4_other_contacts_in_case_of_death' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='other contacts in case of death' AND `language_tag`=''), '3', '34', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
UPDATE consent_controls 
SET detail_form_alias = CONCAT(detail_form_alias, ',qc_cd_ps4') WHERE controls_type = 'procure consent form signature';
INSERT IGNORE INTO i18n (id,en,fr)
VALUES
("contact if discovered on other diseases", "Contact if discovered on other diseases", "Contacter si découvertes sur d'autres maladies"),
("contact if need more information", "Contact if need more information", "Contacter si besoin d'informations supplémentaires"),
("contact if scientific discovery", "Contact if scientific discovery", "Contacter si découverte scientifique"),
("other contacts in case of death", "Other contacts in case of death", "Autres contacts en cas de décès"),
("study on other disease", "Study on other disease", "Étude sur d'autre maladie");
UPDATE structure_formats SET display_order = (400+display_order) WHERE structure_id = (SELECT id FROM structures WHERE alias='qc_cd_ps2');
ALTER TABLE `procure_cd_sigantures`
  ADD COLUMN  `ps4_contact_for_more_info` char(1) DEFAULT '',
  ADD COLUMN  `ps4_contact_if_scientific_discovery` char(1) DEFAULT '',
  ADD COLUMN  `ps4_study_on_other_diseases` char(1) DEFAULT '',
  ADD COLUMN  `ps4_contact_if_discovery_on_other_diseases` char(1) DEFAULT '',
  ADD COLUMN  `ps4_other_contacts_in_case_of_death` char(1) DEFAULT '';
ALTER TABLE `procure_cd_sigantures_revs`
  ADD COLUMN  `ps4_contact_for_more_info` char(1) DEFAULT '',
  ADD COLUMN  `ps4_contact_if_scientific_discovery` char(1) DEFAULT '',
  ADD COLUMN  `ps4_study_on_other_diseases` char(1) DEFAULT '',
  ADD COLUMN  `ps4_contact_if_discovery_on_other_diseases` char(1) DEFAULT '',
  ADD COLUMN  `ps4_other_contacts_in_case_of_death` char(1) DEFAULT '';  

UPDATE versions SET site_branch_build_number = '6948' WHERE version_number = '2.6.8';
UPDATE versions SET permissions_regenerated = 0;

-- ----------------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------------------------------------

INSERT INTO i18n (id,en,fr)
VALUES
('participant study number PS1', 'Participant Study # - PS1', 'No étude patient - PS1'),
('participant study number PS2', 'Participant Study # - PS2', 'No étude patient - PS2'),
('participant study number PS3', 'Participant Study # - PS3', 'No étude patient - PS3'),
('participant study number PS4', 'Participant Study # - PS4', 'No étude patient - PS4');

UPDATE structure_formats SET `flag_index`='1', `flag_detail`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='studysummaries') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='procure_created_by_bank' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_banks') AND `flag_confidential`='0');












  
  
L'onglet contact ne sert à rien pour nous
L'onglet message ne sert à rien
