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
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='qc_nd_last_contact' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='last contact' AND `language_tag`=''), '3', '4', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
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
















