
-- -----------------------------------------------------------------------------------------------------------------------------------------------
-- datamart_browsing_controls : Add contact and message
-- -----------------------------------------------------------------------------------------------------------------------------------------------

UPDATE datamart_browsing_controls 
SET flag_active_1_to_2 = '1', flag_active_2_to_1 = '1'
WHERE id1 IN (SELECT id FROM datamart_structures WHERE model IN ('ParticipantMessage', 'ParticipantContact'))
AND id2 IN (SELECT id FROM datamart_structures WHERE model IN ('Participant'));
UPDATE datamart_browsing_controls 
SET flag_active_1_to_2 = '1', flag_active_2_to_1 = '1'
WHERE id2 IN (SELECT id FROM datamart_structures WHERE model IN ('ParticipantMessage', 'ParticipantContact'))
AND id1 IN (SELECT id FROM datamart_structures WHERE model IN ('Participant'));

-- -----------------------------------------------------------------------------------------------------------------------------------------------
-- remove unused storage control
-- -----------------------------------------------------------------------------------------------------------------------------------------------

UPDATE storage_controls SET flag_active = 0 WHERE id NOT IN (SELECT DISTINCT storage_control_id FROM storage_masters WHERE deleted <> 1);

SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Storage Types');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
('rack20 1a-5d', 'Rack 20 1a-5d',  'Râtelier 20 1a-5d', '1', @control_id, NOW(), NOW(), 1, 1),
('rack4-procure', 'Rack 4-procure',  'Râtelier 4-procure', '1', @control_id, NOW(), NOW(), 1, 1),
('box27', 'Box27',  'Boîte27', '1', @control_id, NOW(), NOW(), 1, 1),
('rack8-procure', 'Rack 8-procure',  'Râtelier 8-procure', '1', @control_id, NOW(), NOW(), 1, 1),
('box2-procure', 'Box2-procure',  'Boîte2-procure', '1', @control_id, NOW(), NOW(), 1, 1),
('rack', 'Rack ',  'Râtelier ', '1', @control_id, NOW(), NOW(), 1, 1),
('rack20', 'Rack 20',  'Râtelier 20', '1', @control_id, NOW(), NOW(), 1, 1),
('rack20 vertical numbering', 'Rack 20 vertical numbering',  'Râtelier 20 vertical numbering', '1', @control_id, NOW(), NOW(), 1, 1),
('box16 1-16', 'Box16 1-16',  'Boîte16 1-16', '1', @control_id, NOW(), NOW(), 1, 1);

-- -----------------------------------------------------------------------------------------------------------------------------------------------
-- Add data to PROCURE - Patients Followup Summary 
-- -----------------------------------------------------------------------------------------------------------------------------------------------

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES 
('Datamart', 'Generated', '', 'qc_nd_ramq', 'input',  NULL , '1', '', '', '', 'ramq nbr', ''), 
('Datamart', 'Generated', '', 'qc_nd_all_phone_numbers', 'input',  NULL , '1', '', '', '', 'phone', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='Generated' AND `tablename`='' AND `field`='qc_nd_ramq' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='1' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ramq nbr' AND `language_tag`=''), '0', '-1', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='first_name' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='1'), '0', '-3', '', '0', '1', 'first name', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='last_name' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='1'), '0', '-2', '', '0', '1', 'last name', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='Generated' AND `tablename`='' AND `field`='qc_nd_all_phone_numbers' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='1' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='phone' AND `language_tag`=''), '0', '0', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');
UPDATE structure_formats SET `display_order`='-5' WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_followups_report_result') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='participant_identifier' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='-4' WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_followups_report_result') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='MiscIdentifier' AND `tablename`='misc_identifiers' AND `field`='identifier_value' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- -----------------------------------------------------------------------------------------------------------------------------------------------
-- Change consent stop follow-up option
-- -----------------------------------------------------------------------------------------------------------------------------------------------

INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("qc_nd_stop_followup", "", "", NULL);
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES ("y","yes"),("n","no"),("y-pho.acc.","yes (but accept to be contacted)");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) 
VALUES 
((SELECT id FROM structure_value_domains WHERE domain_name="qc_nd_stop_followup"), (SELECT id FROM structure_permissible_values WHERE value="n" AND language_alias="no"), "", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_nd_stop_followup"), (SELECT id FROM structure_permissible_values WHERE value="y" AND language_alias="yes"), "", "2"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_nd_stop_followup"), (SELECT id FROM structure_permissible_values WHERE value="y-pho.acc."), "", "4");
UPDATE structure_fields SET  `type`='select',  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_stop_followup')  WHERE model='ConsentDetail' AND tablename='procure_cd_sigantures' AND field='qc_nd_stop_followup' AND `type`='yes_no' AND structure_value_domain  IS NULL ;
INSERT IGNORE INTO i18n (id,en,fr) 
VALUES 
("yes (but accept to be contacted)","Yes (But accept to be contacted)","Oui (Mais accepte d'être contacté"),
('participant stopped the followup but accept to be contacted', 'Participant stopped the followup but accept to be contacted', 'Le participant a arrêté le suivi mais accepte d''être contacté');

-- -----------------------------------------------------------------------------------------------------------------------------------------------

UPDATE versions SET permissions_regenerated = 0;
UPDATE versions SET site_branch_build_number = '6334' WHERE version_number = '2.6.6';

-- -----------------------------------------------------------------------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------------------------------------------------------------------

UPDATE structure_formats SET `flag_override_label`='0', `language_label`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='aliquot_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
REPLACE INTO i18n (id,en,fr) VALUES ('aliquot label', 'Label (ICM)', 'Étiquette (ICM)');
REPLACE INTO i18n (id,en,fr) VALUES ('used aliquot label', 'Label (ICM)', 'Étiquette (ICM)');

UPDATE versions SET permissions_regenerated = 0;
UPDATE versions SET site_branch_build_number = '6347' WHERE version_number = '2.6.6';









