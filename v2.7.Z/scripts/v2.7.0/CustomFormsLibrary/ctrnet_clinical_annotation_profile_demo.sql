-- ------------------------------------------------------
-- ATiM xxxxx Data Script
-- version: 2.7.2
-- ------------------------------------------------------

-- --------------------------------------------------------------------------------
-- participant_identifier CSV Browsing Icon
-- ................................................................................
-- Add the 'participant_identifier CSV Browsing' icon to let users to look for
-- participants based on Participant Identifier from a CSV file.
-- --------------------------------------------------------------------------------

UPDATE structure_formats 
SET `flag_override_setting`='1', `setting`='size=20,class=file range' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') 
AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='participant_identifier' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- --------------------------------------------------------------------------------
-- Participant Last Contact Date
-- ................................................................................
-- Add a custom field 'Last Contact' to the participants form.
-- --------------------------------------------------------------------------------

ALTER TABLE participants
   ADD COLUMN ctrnet_demo_last_contact_date date DEFAULT NULL,
   ADD COLUMN ctrnet_demo_last_contact_date_accuracy char(1) NOT NULL DEFAULT ''; 
ALTER TABLE participants_revs
   ADD COLUMN ctrnet_demo_last_contact_date date DEFAULT NULL,
   ADD COLUMN ctrnet_demo_last_contact_date_accuracy char(1) NOT NULL DEFAULT ''; 

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'Participant', 'participants', 'ctrnet_demo_last_contact_date', 'date',  NULL , '0', '', '', '', 'last contact', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='participants'), 
(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='ctrnet_demo_last_contact_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='last contact' AND `language_tag`=''), 
'3', '2', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '1', '1', '0', '0');

INSERT IGNORE INTO i18n (id,en,fr)
VALUES 
('last contact', 'Last Contact', 'Dernier contact');

-- --------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------

UPDATE versions SET permissions_regenerated = 0;