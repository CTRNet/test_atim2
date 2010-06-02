-- Version: v2.0.3
-- Description: This SQL script is an upgrade for ATiM v2.0.2. to 2.0.3. and must be run against
-- an existing ATiM installation. Be sure to backup your database before running this script!

-- Update version information
UPDATE `versions` 
SET `version_number` = 'v2.1.0pre', `date_installed` = CURDATE(), `build_number` = ''
WHERE `versions`.`id` =1;

-- Clean help bullets in participants
UPDATE structure_formats SET `flag_override_tag`='0', `language_tag`='', `flag_override_help`='0', `language_help`='', `flag_override_type`='0', `type`='', `flag_override_setting`='0', `setting`='', `flag_override_default`='0', `default`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='Participant' AND tablename='participants' AND field='first_name');
UPDATE structure_formats SET `flag_override_tag`='0', `language_tag`='', `flag_override_help`='0', `language_help`='', `flag_override_type`='0', `type`='', `flag_override_setting`='0', `setting`='', `flag_override_default`='0', `default`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='Participant' AND tablename='participants' AND field='last_name');
UPDATE structure_formats SET `flag_override_tag`='0', `language_tag`='', `flag_override_help`='0', `language_help`='', `flag_override_type`='0', `type`='', `flag_override_setting`='0', `setting`='', `flag_override_default`='0', `default`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='Participant' AND tablename='participants' AND field='middle_name');
UPDATE structure_formats SET `flag_override_help`='1', `language_help`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='Participant' AND tablename='participants' AND field='sex');
UPDATE structure_formats SET `flag_override_help`='1', `language_help`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='Participant' AND tablename='participants' AND field='race');
UPDATE structure_formats SET `flag_override_tag`='0', `language_tag`='', `flag_override_help`='1', `language_help`='', `flag_override_type`='0', `type`='', `flag_override_setting`='0', `setting`='', `flag_override_default`='0', `default`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='Participant' AND tablename='participants' AND field='title');

-- Clean help bullets in dx_bloods
UPDATE structure_formats SET `flag_override_help`='1', `language_help`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_bloods') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='DiagnosisMaster' AND tablename='diagnosis_masters' AND field='dx_date');
UPDATE structure_formats SET `flag_override_help`='1', `language_help`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_bloods') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='DiagnosisMaster' AND tablename='diagnosis_masters' AND field='age_at_dx');
UPDATE structure_formats SET `flag_override_help`='1', `language_help`='help_memo' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_bloods') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='DiagnosisMaster' AND tablename='diagnosis_masters' AND field='notes');

-- Clean help bullets in dx_tissues
UPDATE structure_formats SET `flag_override_help`='1', `language_help`='help_memo' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_tissues') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='DiagnosisMaster' AND tablename='diagnosis_masters' AND field='notes');
UPDATE structure_formats SET `flag_override_help`='1', `language_help`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_tissues') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='DiagnosisMaster' AND tablename='diagnosis_masters' AND field='dx_date');
UPDATE structure_formats SET `flag_override_help`='1', `language_help`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_tissues') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='DiagnosisMaster' AND tablename='diagnosis_masters' AND field='age_at_dx');

INSERT INTO i18n (`id`, `en`, `fr`) VALUES
("no identifier available", "No identifier available", "Aucun identifiant disponible");

-- Clean help bullets in participant contacts
UPDATE structure_fields SET  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='contact_type') ,  `language_help`='' WHERE model='ParticipantContact' AND tablename='participant_contacts' AND field='contact_type';
UPDATE structure_fields SET  `language_help`='' WHERE model='ParticipantContact' AND tablename='participant_contacts' AND field='contact_name';
UPDATE structure_fields SET  `language_help`='' WHERE model='ParticipantContact' AND tablename='participant_contacts' AND field='street';
UPDATE structure_fields SET  `language_help`='' WHERE model='ParticipantContact' AND tablename='participant_contacts' AND field='locality';
UPDATE structure_fields SET  `language_help`='' WHERE model='ParticipantContact' AND tablename='participant_contacts' AND field='region';
UPDATE structure_fields SET  `language_help`='' WHERE model='ParticipantContact' AND tablename='participant_contacts' AND field='country';
UPDATE structure_fields SET  `language_help`='' WHERE model='ParticipantContact' AND tablename='participant_contacts' AND field='mail_code';
UPDATE structure_fields SET  `language_help`='help_memo' WHERE model='ParticipantContact' AND tablename='participant_contacts' AND field='notes';

-- Eventum 923
ALTER TABLE aliquot_masters DROP KEY `unique_barcode`, ADD KEY (`barcode`);