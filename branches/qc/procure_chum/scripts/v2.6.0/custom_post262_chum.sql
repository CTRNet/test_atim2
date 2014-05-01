-- To run after custom_post262.sql

ALTER TABLE participants
  MODIFY `first_name` varchar(50) DEFAULT NULL,
  MODIFY `last_name` varchar(50) DEFAULT NULL;
ALTER TABLE participants_revs
  MODIFY `first_name` varchar(50) DEFAULT NULL,
  MODIFY `last_name` varchar(50) DEFAULT NULL; 

ALTER TABLE participants ADD COLUMN `qc_nd_last_contact` date DEFAULT NULL;
ALTER TABLE participants_revs ADD COLUMN `qc_nd_last_contact` date DEFAULT NULL;
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'Participant', 'participants', 'qc_nd_last_contact', 'date',  NULL , '0', '', '', '', 'last contact', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='qc_nd__last_contact' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='last contact' AND `language_tag`=''), '3', '4', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO i18n (id,en,fr) VALUES ('last contact','Last Contact','Dernier contact');

INSERT INTO i18n (id,en,fr) 
VALUES 
('code-barre',"Code-barre","Code à barres"),
('hotel-dieu id nbr',"Hôtel-Dieu Medical Record Number","Numéro de dossier 'Hôtel-Dieu'"),
('notre-dame id nbr',"Notre-Dame Medical Record Number","Numéro de dossier 'Notre-Dame'"),
('old bank no lab',"'No Labo' of Old Bank","Ancien 'No Labo' de banque"),
('other center id nbr',"Other Center Participant Number","Numéro participant autre banque"),
('participant patho identifier',"Patho Identifier","Identifiant de pathologie"),
('prostate bank no lab',"'No Labo' of Prostate Bank","'No Labo' de la banque Prostate"),
('ramq nbr',"RAMQ","RAMQ"),
('saint-luc id nbr',"Saint-Luc Medical Record Number","Numéro de dossier 'Saint-Luc'");
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Datamart', '0', '', 'prostate_bank_no_lab', 'input',  NULL , '0', 'size=20', '', '', 'prostate bank no lab', ''), 
('Datamart', '0', '', 'ramq_nbr', 'input',  NULL , '0', 'size=20', '', '', 'ramq nbr', ''), 
('Datamart', '0', '', 'hotel_dieu_id_nbr', 'input',  NULL , '0', 'size=20', '', '', 'hotel-dieu id nbr', ''), 
('Datamart', '0', '', 'notre_dame_id_nbr', 'input',  NULL , '0', 'size=20', '', '', 'notre-dame id nbr', ''), 
('Datamart', '0', '', 'saint_luc_id_nbr', 'input',  NULL , '0', 'size=20', '', '', 'saint-luc id nbr', ''), 
('Datamart', '0', '', 'participant_patho_identifier', 'input',  NULL , '0', 'size=20', '', '', 'participant patho identifier', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='report_participant_identifiers_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='prostate_bank_no_lab' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=20' AND `default`='' AND `language_help`='' AND `language_label`='prostate bank no lab' AND `language_tag`=''), '0', '7', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='report_participant_identifiers_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='ramq_nbr' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=20' AND `default`='' AND `language_help`='' AND `language_label`='ramq nbr' AND `language_tag`=''), '0', '8', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='report_participant_identifiers_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='hotel_dieu_id_nbr' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=20' AND `default`='' AND `language_help`='' AND `language_label`='hotel-dieu id nbr' AND `language_tag`=''), '0', '9', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='report_participant_identifiers_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='notre_dame_id_nbr' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=20' AND `default`='' AND `language_help`='' AND `language_label`='notre-dame id nbr' AND `language_tag`=''), '0', '10', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='report_participant_identifiers_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='saint_luc_id_nbr' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=20' AND `default`='' AND `language_help`='' AND `language_label`='saint-luc id nbr' AND `language_tag`=''), '0', '11', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='report_participant_identifiers_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='participant_patho_identifier' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=20' AND `default`='' AND `language_help`='' AND `language_label`='participant patho identifier' AND `language_tag`=''), '0', '12', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');
UPDATE structure_fields SET  `model`='Datamart' WHERE model='0' AND tablename='' AND field='RAMQ' AND `type`='input' AND structure_value_domain  IS NULL ;
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='report_participant_identifiers_result') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='hospital_number' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='1');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='report_participant_identifiers_result') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='RAMQ' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='report_participant_identifiers_result') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Datamart' AND `tablename`='' AND `field`='RAMQ' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

INSERT INTO structures(`alias`) VALUES ('qc_nd_cd_data');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'ConsentDetail', 'procure_cd_sigantures', 'qc_nd_biological_material_use', 'yes_no',  NULL , '0', '', '', '', 'biological material use', ''), 
('ClinicalAnnotation', 'ConsentDetail', 'procure_cd_sigantures', 'qc_nd_use_of_urine', 'yes_no',  NULL , '0', '', '', '', 'use of urine', ''), 
('ClinicalAnnotation', 'ConsentDetail', 'procure_cd_sigantures', 'qc_nd_use_of_blood', 'yes_no',  NULL , '0', '', '', '', 'use of blood', ''), 
('ClinicalAnnotation', 'ConsentDetail', 'procure_cd_sigantures', 'qc_nd_research_other_disease', 'yes_no',  NULL , '0', '', '', '', 'research other disease', ''), 
('ClinicalAnnotation', 'ConsentDetail', 'procure_cd_sigantures', 'qc_nd_urine_blood_use_for_followup', 'yes_no',  NULL , '0', '', '', '', 'urine blood use for followup', ''), 
('ClinicalAnnotation', 'ConsentDetail', 'procure_cd_sigantures', 'qc_nd_stop_followup', 'yes_no',  NULL , '0', '', '', '', 'stop followup', ''), 
('ClinicalAnnotation', 'ConsentDetail', 'procure_cd_sigantures', 'qc_nd_stop_followup_date', 'date',  NULL , '0', '', '', '', 'stop followup date', ''), 
('ClinicalAnnotation', 'ConsentDetail', 'procure_cd_sigantures', 'qc_nd_allow_questionnaire', 'yes_no',  NULL , '0', '', '', '', 'allow questionnaire', ''), 
('ClinicalAnnotation', 'ConsentDetail', 'procure_cd_sigantures', 'qc_nd_stop_questionnaire', 'yes_no',  NULL , '0', '', '', '', 'stop questionnaire', ''), 
('ClinicalAnnotation', 'ConsentDetail', 'procure_cd_sigantures', 'qc_nd_stop_questionnaire_date', 'date',  NULL , '0', '', '', '', 'stop questionnaire date', ''), 
('ClinicalAnnotation', 'ConsentDetail', 'procure_cd_sigantures', 'qc_nd_contact_for_additional_data', 'yes_no',  NULL , '0', '', '', '', 'contact for additional data', ''), 
('ClinicalAnnotation', 'ConsentDetail', 'procure_cd_sigantures', 'qc_nd_inform_significant_discovery', 'yes_no',  NULL , '0', '', '', '', 'inform significant discovery', ''), 
('ClinicalAnnotation', 'ConsentDetail', 'procure_cd_sigantures', 'qc_nd_inform_discovery_on_other_disease', 'yes_no',  NULL , '0', '', '', '', 'inform discovery on other disease', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_nd_cd_data'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='procure_cd_sigantures' AND `field`='qc_nd_biological_material_use' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='biological material use' AND `language_tag`=''), '2', '1', 'agreements', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_cd_data'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='procure_cd_sigantures' AND `field`='qc_nd_use_of_urine' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='use of urine' AND `language_tag`=''), '2', '2', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_cd_data'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='procure_cd_sigantures' AND `field`='qc_nd_use_of_blood' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='use of blood' AND `language_tag`=''), '2', '3', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_cd_data'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='procure_cd_sigantures' AND `field`='qc_nd_research_other_disease' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='research other disease' AND `language_tag`=''), '2', '4', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_cd_data'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='procure_cd_sigantures' AND `field`='qc_nd_urine_blood_use_for_followup' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='urine blood use for followup' AND `language_tag`=''), '2', '10', 'followup', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_cd_data'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='procure_cd_sigantures' AND `field`='qc_nd_stop_followup' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='stop followup' AND `language_tag`=''), '2', '11', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_cd_data'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='procure_cd_sigantures' AND `field`='qc_nd_stop_followup_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='stop followup date' AND `language_tag`=''), '2', '12', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_cd_data'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='procure_cd_sigantures' AND `field`='qc_nd_allow_questionnaire' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='allow questionnaire' AND `language_tag`=''), '2', '30', 'questionnaire', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_cd_data'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='procure_cd_sigantures' AND `field`='qc_nd_stop_questionnaire' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='stop questionnaire' AND `language_tag`=''), '2', '31', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_cd_data'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='procure_cd_sigantures' AND `field`='qc_nd_stop_questionnaire_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='stop questionnaire date' AND `language_tag`=''), '2', '32', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_cd_data'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='procure_cd_sigantures' AND `field`='qc_nd_contact_for_additional_data' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='contact for additional data' AND `language_tag`=''), '2', '39', 'contact agreement', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_cd_data'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='procure_cd_sigantures' AND `field`='qc_nd_inform_significant_discovery' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='inform significant discovery' AND `language_tag`=''), '2', '40', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_cd_data'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='procure_cd_sigantures' AND `field`='qc_nd_inform_discovery_on_other_disease' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='inform discovery on other disease' AND `language_tag`=''), '2', '42', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
UPDATE consent_controls SET detail_form_alias = CONCAT(detail_form_alias,',qc_nd_cd_data') WHERE controls_type = 'procure consent form signature';
INSERT INTO i18n (id,en,fr) 
VALUES
("agreements","Agreements","Autorisations"),
("allow questionnaire","Allow Questionnaire","Autorise questionnaire"),
("biological material use","Biological Material Use","Utilisation du materiel biologique"),
("contact agreement","Contact Agreement","Autorisation de contact"),
("contact for additional data","Contact for additional data","Contact pour données suplémentaires"),
("inform discovery on other disease","Inform discovery on other disease","Informer des découvertes sur autre maladie"),
("inform significant discovery","Inform of disease significant discovery","Informer des découvertes importantes sur la maladie"),
("questionnaire","Questionnaire","Questionnaire"),
("research other disease","Research On Other Diseases","Recherche sur autres maladies"),
("stop followup","Stop Followup","Arrêt du suivi"),
("stop followup date","Stop Date","Date d'arrêt"),
("stop questionnaire","Stop Questionnaire","Arrêt du questionnaire"),
("stop questionnaire date","Stop Date","Date d'arrêt"),
("urine blood use for followup","Urine/Blood Use For Followup","Utilisation urine/sang pour suivi"),
("use of blood","Use of Blood","Utilisation du sang"),
("use of urine","Use of Urine","Utilisation de l'urine");
ALTER TABLE procure_cd_sigantures
  ADD COLUMN `qc_nd_biological_material_use` varchar(50) DEFAULT NULL,
  ADD COLUMN `qc_nd_use_of_urine` varchar(50) DEFAULT NULL,
  ADD COLUMN `qc_nd_use_of_blood` varchar(50) DEFAULT NULL,
  ADD COLUMN `qc_nd_research_other_disease` varchar(50) DEFAULT NULL,
  ADD COLUMN `qc_nd_urine_blood_use_for_followup` varchar(10) DEFAULT NULL,
  ADD COLUMN `qc_nd_stop_followup` varchar(10) DEFAULT NULL,
  ADD COLUMN `qc_nd_stop_followup_date` date DEFAULT NULL,
  ADD COLUMN `qc_nd_allow_questionnaire` varchar(10) DEFAULT NULL,
  ADD COLUMN `qc_nd_stop_questionnaire` varchar(10) DEFAULT NULL,
  ADD COLUMN `qc_nd_stop_questionnaire_date` date DEFAULT NULL,
  ADD COLUMN `qc_nd_contact_for_additional_data` varchar(10) DEFAULT NULL,
  ADD COLUMN `qc_nd_inform_significant_discovery` varchar(50) DEFAULT NULL,
  ADD COLUMN `qc_nd_inform_discovery_on_other_disease` varchar(10) DEFAULT NULL;
ALTER TABLE procure_cd_sigantures_revs
  ADD COLUMN `qc_nd_biological_material_use` varchar(50) DEFAULT NULL,
  ADD COLUMN `qc_nd_use_of_urine` varchar(50) DEFAULT NULL,
  ADD COLUMN `qc_nd_use_of_blood` varchar(50) DEFAULT NULL,
  ADD COLUMN `qc_nd_research_other_disease` varchar(50) DEFAULT NULL,
  ADD COLUMN `qc_nd_urine_blood_use_for_followup` varchar(10) DEFAULT NULL,
  ADD COLUMN `qc_nd_stop_followup` varchar(10) DEFAULT NULL,
  ADD COLUMN `qc_nd_stop_followup_date` date DEFAULT NULL,
  ADD COLUMN `qc_nd_allow_questionnaire` varchar(10) DEFAULT NULL,
  ADD COLUMN `qc_nd_stop_questionnaire` varchar(10) DEFAULT NULL,
  ADD COLUMN `qc_nd_stop_questionnaire_date` date DEFAULT NULL,
  ADD COLUMN `qc_nd_contact_for_additional_data` varchar(10) DEFAULT NULL,
  ADD COLUMN `qc_nd_inform_significant_discovery` varchar(50) DEFAULT NULL,
  ADD COLUMN `qc_nd_inform_discovery_on_other_disease` varchar(10) DEFAULT NULL;
  
UPDATE menus SET flag_active =1 WHERE use_link LIKE '/ClinicalAnnotation/ParticipantMessages%';
UPDATE menus SET flag_active =1 WHERE use_link LIKE '/ClinicalAnnotation/ParticipantContacts%';
 
ALTER TABLE participant_contacts MODIFY phone varchar(30) NOT NULL DEFAULT '';
ALTER TABLE participant_contacts_revs MODIFY phone varchar(30) NOT NULL DEFAULT '';

ALTER TABLE participant_messages ADD COLUMN qc_nd_status varchar(20);
ALTER TABLE participant_messages_revs ADD COLUMN qc_nd_status varchar(20);
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("qc_nd_participant_message_status", "open", "", NULL);
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="qc_nd_participant_message_status"), (SELECT id FROM structure_permissible_values WHERE value="pending" AND language_alias="pending"), "1", "1");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="qc_nd_participant_message_status"), (SELECT id FROM structure_permissible_values WHERE value="in process" AND language_alias="in process"), "2", "1");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="qc_nd_participant_message_status"), (SELECT id FROM structure_permissible_values WHERE value="completed" AND language_alias="completed"), "3", "1");
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'ParticipantMessage', 'participant_messages', 'status', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_participant_message_status') , '0', '', '', '', 'status', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='participantmessages'), (SELECT id FROM structure_fields WHERE `model`='ParticipantMessage' AND `tablename`='participant_messages' AND `field`='status' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_participant_message_status')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='status' AND `language_tag`=''), '2', '20', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0');
UPDATE structure_fields SET field = 'qc_nd_status' WHERE field = 'status' AND model = 'ParticipantMessage';
UPDATE structure_formats SET `display_column`='2', `display_order`='17' WHERE structure_id=(SELECT id FROM structures WHERE alias='participantmessages') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ParticipantMessage' AND `tablename`='participant_messages' AND `field`='expiry_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='2', `display_order`='15' WHERE structure_id=(SELECT id FROM structures WHERE alias='participantmessages') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ParticipantMessage' AND `tablename`='participant_messages' AND `field`='date_requested' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='2', `display_order`='16' WHERE structure_id=(SELECT id FROM structures WHERE alias='participantmessages') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ParticipantMessage' AND `tablename`='participant_messages' AND `field`='due_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE datamart_browsing_controls 
SET flag_active_1_to_2 = 1, flag_active_2_to_1 = 1 
WHERE id1 IN (SELECT id FROM datamart_structures WHERE model IN('ParticipantMessage', 'ParticipantContact')) AND id2 IN (SELECT id FROM datamart_structures WHERE model = 'Participant');
