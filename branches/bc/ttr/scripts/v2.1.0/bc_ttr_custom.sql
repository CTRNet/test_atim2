-- hack for script compatibility
ALTER TABLE structure_formats
 ADD flag_addgrid varchar(10),
 ADD flag_addgrid_readonly varchar(10),
 ADD flag_editgrid varchar(10),
 ADD flag_editgrid_readonly varchar(10);

#--------------------------
#-- Menu Changes --
#--------------------------


UPDATE `atim`.`menus` SET `flag_active` = '0' WHERE `menus`.`id` = 'clin_CAN_68' LIMIT 1 ;
UPDATE `atim`.`menus` SET `flag_active` = '0' WHERE `menus`.`id` = 'clin_CAN_75' LIMIT 1 ;
UPDATE `atim`.`menus` SET `flag_active` = '0' WHERE `menus`.`id` = 'clin_CAN_79' LIMIT 1 ;
UPDATE `atim`.`menus` SET `flag_active` = '0' WHERE `menus`.`id` = 'core_CAN_41_1_3_5' LIMIT 1 ;
UPDATE `atim`.`menus` SET `flag_active` = '0' WHERE `menus`.`id` = 'core_CAN_41_2_2' LIMIT 1 ;
UPDATE `atim`.`menus` SET `flag_active` = '0' WHERE `menus`.`id` = 'clin_CAN_24' LIMIT 1 ;
UPDATE `atim`.`menus` SET `flag_active` = '0' WHERE `menus`.`id` = 'clin_CAN_10' LIMIT 1 ;
UPDATE `atim`.`menus` SET `flag_active` = '0' WHERE `menus`.`id` = 'clin_CAN_1_13' LIMIT 1 ;
UPDATE `atim`.`menus` SET `flag_active` = '0' WHERE `menus`.`id` = 'clin_CAN_26' LIMIT 1 ;
UPDATE `atim`.`menus` SET `flag_active` = '0' WHERE `menus`.`id` = 'clin_CAN_5' LIMIT 1 ;
UPDATE `atim`.`menus` SET `flag_active` = '0' WHERE `menus`.`id` = 'clin_CAN_25' LIMIT 1 ;
UPDATE `atim`.`menus` SET `flag_active` = '0' WHERE `menus`.`id` = 'clin_CAN_57' LIMIT 1 ;
UPDATE `atim`.`menus` SET `flag_active` = '0' WHERE `menus`.`id` = 'clin_CAN_4' LIMIT 1 ;




#-- Participants


#-- Remove Cause of Death and Secondary Cause of Death


#-- PHN


INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`) VALUES
('Clinicalannotation', 'Participant', 'participants', 'bc_ttr_phn', 'phn', '', 'input', 'size=20', '',  NULL , '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='bc_ttr_phn' AND `language_label`='phn' AND `language_tag`='' AND `type`='input' AND `setting`='size=20' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '1', '1', '0', '0', '0', '0', '0', '1', '1');


INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES ('phn', '', 'PHN', 'PHN');



#-------------------------
#-- Consents ( cd_nationals)
#-------------------------


#-- Consent Closed

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`) VALUES
('Clinicalannotation', 'ConsentMaster', 'consent_masters', 'bc_ttr_consent_closed', 'consent closed', '', 'select', '', '',  NULL , '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='cd_nationals'), (SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='bc_ttr_consent_closed' AND `language_label`='consent closed' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '9', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1');

#-- Protocol



#-- Diagnosis
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`) VALUES
('Clinicalannotation', 'ConsentMaster', 'consent_masters', 'bc_ttr_diagnosis', 'diagnosis', '', 'input', 'size=20', '',  NULL , '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='cd_nationals'), (SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='bc_ttr_diagnosis' AND `language_label`='diagnosis' AND `language_tag`='' AND `type`='input' AND `setting`='size=20' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '11', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1');


#-- Nurse Log Cancer Type
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`) VALUES
('Clinicalannotation', 'ConsentMaster', 'consent_masters', 'bc_ttr_cancer_type', 'nurse log cancer type', '', 'select', '', '',  NULL , '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='cd_nationals'), (SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='bc_ttr_diagnosis' AND `language_label`='diagnosis' AND `language_tag`='' AND `type`='input' AND `setting`='size=20' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '11', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='cd_nationals'), (SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='bc_ttr_cancer_type' AND `language_label`='nurse log cancer type' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '12', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1');

#-- Referral Souce

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`) VALUES
('Clinicalannotation', 'ConsentMaster', 'consent_masters', 'bc_ttr_referral_source', 'referral source', '', 'select', '', '',  NULL , '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='cd_nationals'), (SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='bc_ttr_referral_source' AND `language_label`='referral source' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '13', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1');



#-- Phone home, work, cell, fax, email

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`) VALUES
('Clinicalannotation', 'ConsentMaster', 'consent_masters', 'bc_ttr_home_phone', 'home phone', '', 'input', 'size=20', '',  NULL , '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='cd_nationals'), (SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='bc_ttr_home_phone' AND `language_label`='home phone' AND `language_tag`='' AND `type`='input' AND `setting`='size=20' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '14', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1');


INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`) VALUES
('Clinicalannotation', 'ConsentMaster', 'consent_masters', 'bc_ttr_cell_phone', 'cell phone', '', 'input', 'size=20', '',  NULL , '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='cd_nationals'), (SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='bc_ttr_cell_phone' AND `language_label`='cell phone' AND `language_tag`='' AND `type`='input' AND `setting`='size=20' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '15', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1');


INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`) VALUES
('Clinicalannotation', 'ConsentMaster', 'consent_masters', 'bc_ttr_work_phone', 'work phone', '', 'input', 'size=20', '',  NULL , '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='cd_nationals'), (SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='bc_ttr_work_phone' AND `language_label`='work phone' AND `language_tag`='' AND `type`='input' AND `setting`='size=20' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '16', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1');


INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`) VALUES
('Clinicalannotation', 'ConsentMaster', 'consent_masters', 'bc_ttr_fax_number', 'fax number', '', 'input', 'size=20', '',  NULL , '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='cd_nationals'), (SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='bc_ttr_fax_number' AND `language_label`='fax number' AND `language_tag`='' AND `type`='input' AND `setting`='size=20' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '17', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`) VALUES
('Clinicalannotation', 'ConsentMaster', 'consent_masters', 'bc_ttr_email', 'email', '', 'input', 'size=20', '',  NULL , '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='cd_nationals'), (SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='bc_ttr_email' AND `language_label`='email' AND `language_tag`='' AND `type`='input' AND `setting`='size=20' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '18', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1');


#--  iroc number
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`) VALUES
('Clinicalannotation', 'ConsentMaster', 'consent_masters', 'bc_ttr_iroc_number', 'iroc number', '', 'input', 'size=10', '',  NULL , '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='cd_nationals'), (SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='bc_ttr_iroc_number' AND `language_label`='iroc number' AND `language_tag`='' AND `type`='input' AND `setting`='size=10' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '19', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1');

-- iroc flag
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`) VALUES
('Clinicalannotation', 'ConsentMaster', 'consent_masters', 'bc_ttr_iroc_flag', 'iroc flag', '', 'select', '', '',  NULL , '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='cd_nationals'), (SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='bc_ttr_iroc_flag' AND `language_label`='iroc flag' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '20', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1');


#---------------------
-- pathologist 
#---------------------

-- Create Pathologist Select field
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`) VALUES
('Clinicalannotation', 'ConsentMaster', 'consent_masters', 'bc_ttr_pathologist', 'pathologist', '', 'select', '', '',  NULL , '');


--  Drop Down Value Options for Pathologist


INSERT IGNORE INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('bc_ttr_pathologist', '', '', NULL);


INSERT IGNORE INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`) VALUES
('Clinicalannotation', 'ConsentMaster', 'consent_masters', 'bc_ttr_pathologist', 'bc_ttr_pathologist', '', 'select', ' ', '', (SELECT id FROM structure_value_domains WHERE domain_name='bc_ttr_pathologist') , 'help_form_version');


UPDATE structure_formats SET `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='bc_ttr_pathologist' AND `type`='select' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='bc_ttr_pathologist') ) WHERE structure_id=(SELECT id FROM structures WHERE alias='cd_nationals') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='ConsentMaster' AND tablename='consent_masters' AND field='bc_ttr_pathologist' AND type='select' AND structure_value_domain  IS NULL );

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("Cavers,D", "Cavers,D");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="bc_ttr_pathologist"),  (SELECT id FROM structure_permissible_values WHERE value="Cavers,D" AND language_alias="Cavers,D"), "1", "1");
INSERT IGNORE INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('Cavers,D',  '',  'Cavers,D',  '');


#------------
-- Consent id
#------------


INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`) VALUES
('Clinicalannotation', 'ConsentMaster', 'consent_masters', 'bc_ttr_consent_id', 'consent id', '', 'input', 'size=10', '',  NULL , '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='cd_nationals'), (SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='bc_ttr_consent_id' AND `language_label`='consent id' AND `language_tag`='' AND `type`='input' AND `setting`='size=10' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '7', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1');



-- acquisition id
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`) VALUES
('Clinicalannotation', 'ConsentMaster', 'consent_masters', 'bc_ttr_acquisition_id', 'acquisition id', '', 'input', 'size=10', '',  NULL , '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='cd_nationals'), (SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='bc_ttr_acquisition_id' AND `language_label`='acquisition id' AND `language_tag`='' AND `type`='input' AND `setting`='size=10' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '8', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1');

-- ttr appt datettime
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`) VALUES
('Clinicalannotation', 'ConsentMaster', 'consent_masters', 'bc_ttr_ttr_appt_datetime', 'ttr appointment', '', 'datetime', '', '',  NULL , '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='cd_nationals'), (SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='bc_ttr_ttr_appt_datetime' AND `language_label`='ttr appointment' AND `language_tag`='' AND `type`='datetime' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '9', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1');


-- blood collected
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`) VALUES
('Clinicalannotation', 'ConsentMaster', 'consent_masters', 'bc_ttr_blood_collected', 'blood collected', '', 'select', '', '',  NULL , '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='cd_nationals'), (SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='bc_ttr_blood_collected' AND `language_label`='blood collected' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1');


-- tissue collected
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`) VALUES
('Clinicalannotation', 'ConsentMaster', 'consent_masters', 'bc_ttr_tissue_collected', 'tissue collected', '', 'select', '', '',  NULL , '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='cd_nationals'), (SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='bc_ttr_tissue_collected' AND `language_label`='tissue collected' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '11', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1');



-- contact for genetic research
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`) VALUES
('Clinicalannotation', 'ConsentMaster', 'consent_masters', 'bc_ttr_contact_for_genetic_research', 'contact for genetic research', '', 'select', '', '',  NULL , '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='cd_nationals'), (SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='bc_ttr_contact_for_genetic_research' AND `language_label`='contact for genetic research' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '12', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1');



-- surgery
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`) VALUES
('Clinicalannotation', 'ConsentMaster', 'consent_masters', 'bc_ttr_surgery', 'surgery', '', 'select', '', '',  NULL , '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='cd_nationals'), (SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='bc_ttr_surgery' AND `language_label`='surgery' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '13', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1');

-- smoking history
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`) VALUES
('Clinicalannotation', 'ConsentMaster', 'consent_masters', 'bc_ttr_smoking_history', 'smoking history', '', 'select', '', '',  NULL , '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='cd_nationals'), (SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='bc_ttr_smoking_history' AND `language_label`='smoking history' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '14', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1');

-- pack years
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`) VALUES
('Clinicalannotation', 'ConsentMaster', 'consent_masters', 'bc_ttr_pack_years', 'pack years', '', 'input', 'size=10', '',  NULL , '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='cd_nationals'), (SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='bc_ttr_pack_years' AND `language_label`='pack years' AND `language_tag`='' AND `type`='input' AND `setting`='size=10' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '15', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1');

-- years since quit
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`) VALUES
('Clinicalannotation', 'ConsentMaster', 'consent_masters', 'bc_ttr_years_since_quit', 'years since quit', '', 'input', 'size=10', '',  NULL , '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='cd_nationals'), (SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='bc_ttr_years_since_quit' AND `language_label`='years since quit' AND `language_tag`='' AND `type`='input' AND `setting`='size=10' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '16', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1');


-- MRN
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`) VALUES
('Clinicalannotation', 'ConsentMaster', 'consent_masters', 'bc_ttr_medical_record_no', 'medical record no', '', 'input', 'size=20', '',  NULL , '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='cd_nationals'), (SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='bc_ttr_medical_record_no' AND `language_label`='medical record no' AND `language_tag`='' AND `type`='input' AND `setting`='size=20' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '17', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1');

-- Path Spec
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`) VALUES
('Clinicalannotation', 'ConsentMaster', 'consent_masters', 'bc_ttr_pathology_specification', 'pathology specification', '', 'input', 'size=20', '',  NULL , '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='cd_nationals'), (SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='bc_ttr_pathology_specification' AND `language_label`='pathology specification' AND `language_tag`='' AND `type`='input' AND `setting`='size=20' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '18', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1');


-- Date Consent Denied
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`) VALUES
('Clinicalannotation', 'ConsentMaster', 'consent_masters', 'bc_ttr_date_consent_denied', 'date consent denied', '', 'date', '', '',  NULL , '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='cd_nationals'), (SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='bc_ttr_date_consent_denied' AND `language_label`='date consent denied' AND `language_tag`='' AND `type`='date' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '19', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1');


-- Date consent Withdrawn
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`) VALUES
('Clinicalannotation', 'ConsentMaster', 'consent_masters', 'bc_ttr_date_consent_withdrawn', 'date consent withdrawn', '', 'date', '', '',  NULL , '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='cd_nationals'), (SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='bc_ttr_date_consent_withdrawn' AND `language_label`='date consent withdrawn' AND `language_tag`='' AND `type`='date' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '20', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1');

-- Date Referral withdrawn
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`) VALUES
('Clinicalannotation', 'ConsentMaster', 'consent_masters', 'bc_ttr_date_referral_withdrawn', 'date referral withdrawn', '', 'date', '', '',  NULL , '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='cd_nationals'), (SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='bc_ttr_date_referral_withdrawn' AND `language_label`='date referral withdrawn' AND `language_tag`='' AND `type`='date' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '21', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1');






-- Insert Language label
INSERT IGNORE INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('consent closed',  '',  'Consent Closed',  '');

INSERT IGNORE INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('date consent denied',  '',  'Date Consent Denied',  '');

INSERT IGNORE INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('date consent withdrawn',  '',  'Date Consent Withdrawn',  '');

INSERT IGNORE INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('date referral withdrawn',  '',  'Date Referral Withdrawn',  '');

INSERT IGNORE INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('referral method',  '',  'Referral Method',  '');

INSERT IGNORE INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('referral source',  '',  'Referral Source',  '');

INSERT IGNORE INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('ttr appt datetime',  '',  'TTR Appt Datetime',  '');

INSERT IGNORE INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('consent id',  '',  'Consent ID',  '');

INSERT IGNORE INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('acquisition id',  '',  'Acquisition ID',  '');

INSERT IGNORE INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('blood collected',  '',  'Blood collected',  '');

INSERT IGNORE INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('tissue collected',  '',  'Tissue collected',  '');

INSERT IGNORE INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('medical record no',  '',  'Medical Record No',  '');

INSERT IGNORE INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('pathology specification',  '',  'Pathology  Specification',  '');

INSERT IGNORE INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('iroc number',  '',  'IROC Number',  '');

INSERT IGNORE INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('iroc flag',  '',  'IROC Flag',  '');

INSERT IGNORE INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('src',  '',  'SRC',  '');

INSERT IGNORE INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('nurse log cancer type',  '',  'Nurse Log Cancer Type',  '');

INSERT IGNORE INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('ttr appointment',  '',  'TTR appointment',  '');

INSERT IGNORE INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('contact for genetic research',  '',  'Contact for genetic research',  '');

INSERT IGNORE INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('pack per year',  '',  'Pack per year',  '');

INSERT IGNORE INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('years since quit',  '',  'Years since quit',  '');

INSERT IGNORE INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('home phone',  '',  'Home phone',  '');

INSERT IGNORE INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('work phone',  '',  'Work phone',  '');

INSERT IGNORE INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('cell phone',  '',  'Cell phone',  '');

INSERT IGNORE INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('fax number',  '',  'Fax number',  '');

INSERT IGNORE INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('iroc number',  '',  'IROC number',  '');

INSERT IGNORE INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('iroc flag',  '',  'IROC flag',  '');

INSERT IGNORE INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('bc_ttr_pathologist',  '',  'Pathologist',  '');



-- Drop Down List for Referral Source

INSERT IGNORE  INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('bc_ttr_referral_source', '', '', NULL);

UPDATE structure_fields SET  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='bc_ttr_referral_source')  WHERE model='ConsentMaster' AND tablename='consent_masters' AND field='bc_ttr_referral_source' AND `type`='select' AND structure_value_domain  IS NULL ;

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("surgical office", "Surgical Office");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="bc_ttr_referral_source"),  (SELECT id FROM structure_permissible_values WHERE value="surgical office" AND language_alias="Surgical Office"), "1", "1");

INSERT IGNORE INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('Surgical Office',  '',  'Surgical Office',  '');

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("PREDICT", "PREDICT");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="bc_ttr_referral_source"),  (SELECT id FROM structure_permissible_values WHERE value="PREDICT" AND language_alias="PREDICT"), "2", "1");

INSERT IGNORE INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('PREDICT',  '',  'PREDICT',  '');


INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("Breast Health Centre", "Breast Health Centre");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="bc_ttr_referral_source"),  (SELECT id FROM structure_permissible_values WHERE value="Breast Health Centre" AND language_alias="Breast Health Centre"), "3", "1");

INSERT IGNORE INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('Breast Health Centre',  '',  'Breast Health Centre',  '');


INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("self-referral", "self-referral");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="bc_ttr_referral_source"),  (SELECT id FROM structure_permissible_values WHERE value="self-referral" AND language_alias="self-referral"), "4", "1");

INSERT IGNORE INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('self-referral',  '',  'Self-Referral',  '');

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("BCCA oncologist", "BCCA oncologist");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="bc_ttr_referral_source"),  (SELECT id FROM structure_permissible_values WHERE value="BCCA oncologist" AND language_alias="BCCA oncologist"), "5", "1");

INSERT IGNORE INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('BCCA oncologist',  '',  'BCCA oncologist',  '');


INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("PAC", "PAC");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="bc_ttr_referral_source"),  (SELECT id FROM structure_permissible_values WHERE value="PAC" AND language_alias="PAC"), "6", "1");

INSERT IGNORE INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('PAC',  '',  'PAC',  '');

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("other", "other");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="bc_ttr_referral_source"),  (SELECT id FROM structure_permissible_values WHERE value="other" AND language_alias="other"), "7", "1");




-- Drop Down Value Options for Consent Closed
INSERT IGNORE INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('bc_ttr_consent_closed', '', '', NULL);

UPDATE structure_fields SET  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='bc_ttr_consent_closed')  WHERE model='ConsentMaster' AND tablename='consent_masters' AND field='bc_ttr_consent_closed' AND `type`='select' AND structure_value_domain  IS NULL ;

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("obtained-tissue direct to TTR", "obtained-tissue direct to TTR");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="bc_ttr_consent_closed"),  (SELECT id FROM structure_permissible_values WHERE value="obtained-tissue direct to TTR" AND language_alias="obtained-tissue direct to TTR"), "1", "1");
INSERT IGNORE INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('obtained-tissue direct to TTR',  '',  'obtained-tissue direct to TTR',  '');

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("obtained-tissue available indirectly", "obtained-tissue available indirectly");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="bc_ttr_consent_closed"),  (SELECT id FROM structure_permissible_values WHERE value="obtained-tissue available indirectly" AND language_alias="obtained-tissue available indirectly"), "2", "1");
INSERT IGNORE INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('obtained-tissue available indirectly',  '',  'obtained-tissue available indirectly',  '');

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("obtained-no tissue", "obtained-no tissue");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="bc_ttr_consent_closed"),  (SELECT id FROM structure_permissible_values WHERE value="obtained-no tissue" AND language_alias="obtained-no tissue"), "3", "1");
INSERT IGNORE INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('obtained-no tissue',  '',  'obtained-no tissue',  '');


INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("unknown-lost to follow-up", "unknown-lost to follow-up");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="bc_ttr_consent_closed"),  (SELECT id FROM structure_permissible_values WHERE value="unknown-lost to follow-up" AND language_alias="unknown-lost to follow-up"), "4", "1");
INSERT IGNORE INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('unknown-lost to follow-up',  '',  'unknown-lost to follow-up',  '');


INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("unknown-no response", "unknown-no response");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="bc_ttr_consent_closed"),  (SELECT id FROM structure_permissible_values WHERE value="unknown-no response" AND language_alias="unknown-no response"), "5", "1");
INSERT IGNORE INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('unknown-no response',  '',  'unknown-no response',  '');

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("unknown-tissue direct to TTR", "unknown-tissue direct to TTR");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="bc_ttr_consent_closed"),  (SELECT id FROM structure_permissible_values WHERE value="unknown-tissue direct to TTR" AND language_alias="unknown-tissue direct to TTR"), "6", "1");
INSERT IGNORE INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('unknown-tissue direct to TTR',  '',  'unknown-tissue direct to TTR',  '');


INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("unknown-verbal consent/signed consent not returned", "unknown-verbal consent/signed consent not returned");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="bc_ttr_consent_closed"),  (SELECT id FROM structure_permissible_values WHERE value="unknown-verbal consent/signed consent not returned" AND language_alias="unknown-verbal consent/signed consent not returned"), "7", "1");
INSERT IGNORE INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('unknown-verbal consent/signed consent not returned',  '',  'unknown-verbal consent/signed consent not returned',  '');


INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("withdrawn-by clinical office", "withdrawn-by clinical office");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="bc_ttr_consent_closed"),  (SELECT id FROM structure_permissible_values WHERE value="withdrawn-by clinical office" AND language_alias="withdrawn-by clinical office"), "8", "1");
INSERT IGNORE INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('withdrawn-by clinical office',  '',  'withdrawn-by clinical office',  '');


INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("withdrawn-by TTR nurse", "withdrawn-by TTR nurse");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="bc_ttr_consent_closed"),  (SELECT id FROM structure_permissible_values WHERE value="withdrawn-by TTR nurse" AND language_alias="withdrawn-by TTR nurse"), "9", "1");
INSERT IGNORE INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('withdrawn-by TTR nurse',  '',  'withdrawn-by TTR nurse',  '');


INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("withheld-anytime from tissue collection", "withheld-anytime from tissue collection");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="bc_ttr_consent_closed"),  (SELECT id FROM structure_permissible_values WHERE value="withheld-anytime from tissue collection" AND language_alias="withheld-anytime from tissue collection"), "10", "1");
INSERT IGNORE INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('withheld-anytime from tissue collection',  '',  'withheld-anytime from tissue collection',  '');

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("withheld-referral contact/consent meeting/form", "withheld-referral contact/consent meeting/form");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="bc_ttr_consent_closed"),  (SELECT id FROM structure_permissible_values WHERE value="withheld-referral contact/consent meeting/form" AND language_alias="withheld-referral contact/consent meeting/form"), "11", "1");
INSERT IGNORE INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('withheld-referral contact/consent meeting/form',  '',  'withheld-referral contact/consent meeting/form',  '');





-- Drop Down Value Options for Blood Collected

INSERT IGNORE INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('bc_ttr_blood_collected', '', '', NULL);

UPDATE structure_fields SET  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='bc_ttr_blood_collected')  WHERE model='ConsentMaster' AND tablename='consent_masters' AND field='bc_ttr_blood_collected' AND `type`='select' AND structure_value_domain  IS NULL ;

INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="bc_ttr_blood_collected"),  (SELECT id FROM structure_permissible_values WHERE value="yes" AND language_alias="yes"), "1", "1");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="bc_ttr_blood_collected"),  (SELECT id FROM structure_permissible_values WHERE value="no" AND language_alias="no"), "2", "1");





-- Drop Down Value Options for Tissue Collected

INSERT IGNORE INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('bc_ttr_tissue_collected', '', '', NULL);
UPDATE structure_fields SET  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='bc_ttr_tissue_collected')  WHERE model='ConsentMaster' AND tablename='consent_masters' AND field='bc_ttr_tissue_collected' AND `type`='select' AND structure_value_domain  IS NULL ;

INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="bc_ttr_tissue_collected"),  (SELECT id FROM structure_permissible_values WHERE value="yes" AND language_alias="yes"), "1", "1");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="bc_ttr_tissue_collected"),  (SELECT id FROM structure_permissible_values WHERE value="no" AND language_alias="no"), "2", "1");

-- Drop Down Value Options for Contact for Genetic Research

INSERT IGNORE INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('bc_ttr_contact_for_genetic_research', '', '', NULL);
UPDATE structure_fields SET  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='bc_ttr_contact_for_genetic_research')  WHERE model='ConsentMaster' AND tablename='consent_masters' AND field='bc_ttr_contact_for_genetic_research' AND `type`='select' AND structure_value_domain  IS NULL ;

INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="bc_ttr_contact_for_genetic_research"),  (SELECT id FROM structure_permissible_values WHERE value="yes" AND language_alias="yes"), "1", "1");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="bc_ttr_contact_for_genetic_research"),  (SELECT id FROM structure_permissible_values WHERE value="no" AND language_alias="no"), "2", "1");




-- Drop Down Value Options for IROC flag

INSERT IGNORE INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('bc_ttr_iroc_flag', '', '', NULL);
UPDATE structure_fields SET  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='bc_ttr_iroc_flag')  WHERE model='ConsentMaster' AND tablename='consent_masters' AND field='bc_ttr_iroc_flag' AND `type`='select' AND structure_value_domain  IS NULL ;

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("decline", "decline");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="bc_ttr_iroc_flag"),  (SELECT id FROM structure_permissible_values WHERE value="decline" AND language_alias="decline"), "1", "1");
INSERT IGNORE INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('decline',  '',  'Decline',  '');




-- Drop Down Value Options for Smoking History (Ever Smoke)
INSERT IGNORE INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('bc_ttr_smoking_history', '', '', NULL);

UPDATE structure_fields SET  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='bc_ttr_smoking_history')  WHERE model='ConsentMaster' AND tablename='consent_masters' AND field='bc_ttr_smoking_history' AND `type`='select' AND structure_value_domain  IS NULL ;

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("never", "never");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="bc_ttr_smoking_history"),  (SELECT id FROM structure_permissible_values WHERE value="never" AND language_alias="never"), "1", "1");
INSERT IGNORE INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('never',  '',  'Never',  '');

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("former", "former");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="bc_ttr_smoking_history"),  (SELECT id FROM structure_permissible_values WHERE value="former" AND language_alias="former"), "2", "1");
INSERT IGNORE INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('former',  '',  'Former',  '');

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("current", "current");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="bc_ttr_smoking_history"),  (SELECT id FROM structure_permissible_values WHERE value="current" AND language_alias="current"), "3", "1");





-- Drop Down Value Options for Facility 

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`) VALUES
('Clinicalannotation', 'ConsentMaster', 'consent_masters', 'facility', 'facility', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='facility') , 'help_facility');
UPDATE structure_formats SET `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='facility' AND `type`='select' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='facility') ) WHERE structure_id=(SELECT id FROM structures WHERE alias='cd_nationals') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='ConsentMaster' AND tablename='consent_masters' AND field='facility' AND type='select' AND structure_value_domain  IS NULL );



INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("Royal Jubilee", "Royal Jubilee");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="facility"),  (SELECT id FROM structure_permissible_values WHERE value="Royal Jubilee" AND language_alias="Royal Jubilee"), "1", "1");
INSERT IGNORE INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('Royal Jubilee',  '',  'Royal Jubilee',  '');


INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("Victoria General", "Victoria General");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="facility"),  (SELECT id FROM structure_permissible_values WHERE value="Victoria General" AND language_alias="Victoria General"), "2", "1");
INSERT IGNORE INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('Victoria General',  '',  'Victoria General',  '');


INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("VIC/RJH Radiology", "VIC/RJH Radiology");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="facility"),  (SELECT id FROM structure_permissible_values WHERE value="VIC/RJH Radiology" AND language_alias="VIC/RJH Radiology"), "3", "1");
INSERT IGNORE INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('VIC/RJH Radiology',  '',  'VIC/RJH Radiology',  '');



-- Drop Down Value Options for Protocol
INSERT IGNORE INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('bc_ttr_protocol', '', '', NULL);

UPDATE structure_fields SET  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='bc_ttr_protocol')  WHERE model='ConsentMaster' AND tablename='consent_masters' AND field='bc_ttr_protocol' AND `type`='select' AND structure_value_domain  IS NULL ;

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("A", "A");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="bc_ttr_protocol"),  (SELECT id FROM structure_permissible_values WHERE value="A" AND language_alias="A"), "1", "1");
INSERT IGNORE INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('A',  '',  'A',  '');


INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("B", "B");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="bc_ttr_protocol"),  (SELECT id FROM structure_permissible_values WHERE value="B" AND language_alias="B"), "2", "1");
INSERT IGNORE INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('B',  '',  'B',  '');


INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("C", "C");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="bc_ttr_protocol"),  (SELECT id FROM structure_permissible_values WHERE value="C" AND language_alias="C"), "3", "1");
INSERT IGNORE INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('C',  '',  'C',  '');


INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("D", "D");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="bc_ttr_protocol"),  (SELECT id FROM structure_permissible_values WHERE value="D" AND language_alias="D"), "4", "1");
INSERT IGNORE INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('D',  '',  'D',  '');




-- Drop Down Value Options for BC TTR Cancer Type
INSERT IGNORE INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('bc_ttr_cancer_type', '', '', NULL);

UPDATE structure_fields SET  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='bc_ttr_cancer_type')  WHERE model='ConsentMaster' AND tablename='consent_masters' AND field='bc_ttr_cancer_type' AND `type`='select' AND structure_value_domain  IS NULL ;



INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("Breast", "Breast");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="bc_ttr_cancer_type"),  (SELECT id FROM structure_permissible_values WHERE value="Breast" AND language_alias="Breast"), "1", "1");
INSERT IGNORE INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('Breast',  '',  'Breast',  '');


INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("GI Large Bowel", "GI Large Bowel");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="bc_ttr_cancer_type"),  (SELECT id FROM structure_permissible_values WHERE value="GI Large Bowel" AND language_alias="GI Large Bowel"), "2", "1");
INSERT IGNORE INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('GI Large Bowel',  '',  'GI Large Bowel',  '');

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("Lung", "Lung");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="bc_ttr_cancer_type"),  (SELECT id FROM structure_permissible_values WHERE value="Lung" AND language_alias="Lung"), "3", "1");


INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("Ovarian", "Ovarian");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="bc_ttr_cancer_type"),  (SELECT id FROM structure_permissible_values WHERE value="Ovarian" AND language_alias="Ovarian"), "4", "1");
INSERT IGNORE INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('Ovarian',  '',  'Ovarian',  '');

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("Endometrial", "Endometrial");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="bc_ttr_cancer_type"),  (SELECT id FROM structure_permissible_values WHERE value="Endometrial" AND language_alias="Endometrial"), "5", "1");
INSERT IGNORE INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('Endometrial',  '',  'Endometrial',  '');


INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("Esophageal", "Esophageal");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="bc_ttr_cancer_type"),  (SELECT id FROM structure_permissible_values WHERE value="Esophageal" AND language_alias="Esophageal"), "6", "1");
INSERT IGNORE INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('Esophageal',  '',  'Esophageal',  '');


INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("Prostate", "Prostate");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="bc_ttr_cancer_type"),  (SELECT id FROM structure_permissible_values WHERE value="Prostate" AND language_alias="Prostate"), "7", "1");
INSERT IGNORE INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('Prostate',  '',  'Prostate',  '');


INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("Other", "Other");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="bc_ttr_cancer_type"),  (SELECT id FROM structure_permissible_values WHERE value="Other" AND language_alias="Other"), "8", "1");



INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("Lymphoma", "Lymphoma");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="bc_ttr_cancer_type"),  (SELECT id FROM structure_permissible_values WHERE value="Lymphoma" AND language_alias="Lymphoma"), "9", "1");


INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("Stomach", "Stomach");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="bc_ttr_cancer_type"),  (SELECT id FROM structure_permissible_values WHERE value="Stomach" AND language_alias="Stomach"), "10", "1");


INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("Head/Neck", "Head/Neck");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="bc_ttr_cancer_type"),  (SELECT id FROM structure_permissible_values WHERE value="Head/Neck" AND language_alias="Head/Neck"), "11", "1");
INSERT IGNORE INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('Head/Neck',  '',  'Head/Neck',  '');


INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("Skin-Melanoma", "Skin-Melanoma");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="bc_ttr_cancer_type"),  (SELECT id FROM structure_permissible_values WHERE value="Skin-Melanoma" AND language_alias="Skin-Melanoma"), "12", "1");
INSERT IGNORE INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('Skin-Melanoma',  '',  'Skin-Melanoma',  '');


INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("Thyroid", "Thyroid");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="bc_ttr_cancer_type"),  (SELECT id FROM structure_permissible_values WHERE value="Thyroid" AND language_alias="Thyroid"), "13", "1");
INSERT IGNORE INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('Thyroid',  '',  'Thyroid',  '');


INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("Renal", "Renal");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="bc_ttr_cancer_type"),  (SELECT id FROM structure_permissible_values WHERE value="Renal" AND language_alias="Renal"), "14", "1");
INSERT IGNORE INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('Renal',  '',  'Renal',  '');


INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("Oral", "Oral");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="bc_ttr_cancer_type"),  (SELECT id FROM structure_permissible_values WHERE value="Oral" AND language_alias="Oral"), "15", "1");
INSERT IGNORE INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('Oral',  '',  'Oral',  '');


INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("Sarcoma", "Sarcoma");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="bc_ttr_cancer_type"),  (SELECT id FROM structure_permissible_values WHERE value="Sarcoma" AND language_alias="Sarcoma"), "16", "1");
INSERT IGNORE INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('Sarcoma',  '',  'Sarcoma',  '');


INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("Liver", "Liver");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="bc_ttr_cancer_type"),  (SELECT id FROM structure_permissible_values WHERE value="Liver" AND language_alias="Liver"), "17", "1");


INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("Pancreas", "Pancreas");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="bc_ttr_cancer_type"),  (SELECT id FROM structure_permissible_values WHERE value="Pancreas" AND language_alias="Pancreas"), "18", "1");


INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("Brain", "Brain");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="bc_ttr_cancer_type"),  (SELECT id FROM structure_permissible_values WHERE value="Brain" AND language_alias="Brain"), "19", "1");



INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("Ampullary", "Ampullary");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="bc_ttr_cancer_type"),  (SELECT id FROM structure_permissible_values WHERE value="Ampullary" AND language_alias="Ampullary"), "20", "1");
INSERT IGNORE INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('Ampullary',  '',  'Ampullary',  '');


INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("Adrenal", "Adrenal");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="bc_ttr_cancer_type"),  (SELECT id FROM structure_permissible_values WHERE value="Adrenal" AND language_alias="Adrenal"), "21", "1");
INSERT IGNORE INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('Adrenal',  '',  'Adrenal',  '');


INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("Vulva", "Vulva");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="bc_ttr_cancer_type"),  (SELECT id FROM structure_permissible_values WHERE value="Vulva" AND language_alias="Vulva"), "22", "1");
INSERT IGNORE INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('Vulva',  '',  'Vulva',  '');


INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("Intra-abdominal", "Intra-abdominal");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="bc_ttr_cancer_type"),  (SELECT id FROM structure_permissible_values WHERE value="Intra-abdominal" AND language_alias="Intra-abdominal"), "23", "1");
INSERT IGNORE INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('Intra-abdominal',  '',  'Intra-abdominal',  '');


INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("GI Small Bowel", "GI Small Bowel");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="bc_ttr_cancer_type"),  (SELECT id FROM structure_permissible_values WHERE value="GI Small Bowel" AND language_alias="GI Small Bowel"), "24", "1");
INSERT IGNORE INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('GI Small Bowel',  '',  'GI Small Bowel',  '');



INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("Bladder", "Bladder");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="bc_ttr_cancer_type"),  (SELECT id FROM structure_permissible_values WHERE value="Bladder" AND language_alias="Bladder"), "25", "1");
INSERT IGNORE INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('Bladder',  '',  'Bladder',  '');


INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("Parathyroid", "Parathyroid");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="bc_ttr_cancer_type"),  (SELECT id FROM structure_permissible_values WHERE value="Parathyroid" AND language_alias="Parathyroid"), "26", "1");
INSERT IGNORE INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('Parathyroid',  '',  'Parathyroid',  '');


INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("Skin-Non-Melanoma", "Skin-Non-Melanoma");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="bc_ttr_cancer_type"),  (SELECT id FROM structure_permissible_values WHERE value="Skin-Non-Melanoma" AND language_alias="Skin-Non-Melanoma"), "27", "1");
INSERT IGNORE INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('Skin-Non-Melanoma',  '',  'Skin-Non-Melanoma',  '');



INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("Placenta", "Placenta");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="bc_ttr_cancer_type"),  (SELECT id FROM structure_permissible_values WHERE value="Placenta" AND language_alias="Placenta"), "28", "1");
INSERT IGNORE INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('Placenta',  '',  'Placenta',  '');







-- Drop Down Value Options for Process Status
INSERT IGNORE INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('bc_ttr_consent_process_status', '', '', NULL);

UPDATE structure_fields SET  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='bc_ttr_consent_process_status')  WHERE model='ConsentMaster' AND tablename='consent_masters' AND field='process_status' AND `type`='select' AND structure_value_domain  IS NULL ;


INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("Open", "Open");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="bc_ttr_consent_process_status"),  (SELECT id FROM structure_permissible_values WHERE value="Open" AND language_alias="Open"), "1", "1");
INSERT IGNORE INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('Open',  '',  'Open',  '');

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("Obtained", "Obtained");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="bc_ttr_consent_process_status"),  (SELECT id FROM structure_permissible_values WHERE value="Obtained" AND language_alias="Obtained"), "2", "1");

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("Sent", "Sent");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="bc_ttr_consent_process_status"),  (SELECT id FROM structure_permissible_values WHERE value="Sent" AND language_alias="Sent"), "3", "1");
INSERT IGNORE INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('Sent',  '',  'Sent',  '');

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("Verbal", "Verbal");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="bc_ttr_consent_process_status"),  (SELECT id FROM structure_permissible_values WHERE value="Verbal" AND language_alias="Verbal"), "4", "1");
INSERT IGNORE INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('Verbal',  '',  'Verbal',  '');

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("Closed", "Closed");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="bc_ttr_consent_process_status"),  (SELECT id FROM structure_permissible_values WHERE value="Closed" AND language_alias="Closed"), "5", "1");

#-----------------
-- SURGEON
#-----------------

-- Change Surgeon to select field

UPDATE structure_formats SET `flag_override_type`='1', `type`='select', `flag_override_setting`='1', `setting`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='cd_nationals') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='ConsentMaster' AND tablename='consent_masters' AND field='surgeon' AND type='input' AND structure_value_domain  IS NULL );

-- Drop Down Value Options for Surgeons

INSERT IGNORE INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('bc_ttr_surgeon', '', '', NULL);

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`) VALUES
('Clinicalannotation', 'ConsentMaster', 'consent_masters', 'surgeon', 'surgeon', '', 'select', ' ', '', (SELECT id FROM structure_value_domains WHERE domain_name='bc_ttr_surgeon') , 'help_form_version');

UPDATE structure_formats SET `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='surgeon' AND `type`='select' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='bc_ttr_surgeon') ) WHERE structure_id=(SELECT id FROM structures WHERE alias='cd_nationals') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='ConsentMaster' AND tablename='consent_masters' AND field='surgeon' AND type='input' AND structure_value_domain  IS NULL );

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("Alscher", "Alscher");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="bc_ttr_surgeon"),  (SELECT id FROM structure_permissible_values WHERE value="Alscher" AND language_alias="Alscher"), "1", "1");
INSERT IGNORE INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('Alscher',  '',  'Alscher',  '');


-- Drop Down List for Form version
-- Update Form Version to become drop down list

UPDATE structure_formats SET `flag_override_type`='1', `type`='select', `flag_override_setting`='1', `setting`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='cd_nationals') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='ConsentMaster' AND tablename='consent_masters' AND field='form_version' AND type='input' AND structure_value_domain  IS NULL );

INSERT IGNORE INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('bc_ttr_consent_form_version', '', '', NULL);


INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`) VALUES
('Clinicalannotation', 'ConsentMaster', 'consent_masters', 'form_version', 'form_version', '', 'select', ' ', '', (SELECT id FROM structure_value_domains WHERE domain_name='bc_ttr_consent_form_version') , 'help_form_version');

UPDATE structure_formats SET `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='form_version' AND `type`='select' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='bc_ttr_consent_form_version') ) WHERE structure_id=(SELECT id FROM structures WHERE alias='cd_nationals') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='ConsentMaster' AND tablename='consent_masters' AND field='form_version' AND type='input' AND structure_value_domain  IS NULL );



INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("TTR-2010-07-26", "TTR-2010-07-26");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="bc_ttr_consent_form_version"),  (SELECT id FROM structure_permissible_values WHERE value="TTR-2010-07-26" AND language_alias="TTR-2010-07-26"), "1", "1");
INSERT IGNORE INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('TTR-2010-07-26',  '',  'TTR-2010-07-26',  '');



INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("TTR-IROC-2010-07-26", "TTR-IROC-2010-07-26");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="bc_ttr_consent_form_version"),  (SELECT id FROM structure_permissible_values WHERE value="TTR-IROC-2010-07-26" AND language_alias="TTR-IROC-2010-07-26"), "2", "1");
INSERT IGNORE INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('TTR-IROC-2010-07-26',  '',  'TTR-IROC-2010-07-26',  '');


INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("TTR-BRT-2010-07-26", "TTR-BRT-2010-07-26");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="bc_ttr_consent_form_version"),  (SELECT id FROM structure_permissible_values WHERE value="TTR-BRT-2010-07-26" AND language_alias="TTR-BRT-2010-07-26"), "3", "1");
INSERT IGNORE INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('TTR-BRT-2010-07-26',  '',  'TTR-BRT-2010-07-26',  '');



INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("TTR-2009-03-20", "TTR-2009-03-20");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="bc_ttr_consent_form_version"),  (SELECT id FROM structure_permissible_values WHERE value="TTR-2009-03-20" AND language_alias="TTR-2009-03-20"), "4", "1");
INSERT IGNORE INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('TTR-2009-03-20',  '',  'TTR-2009-03-20',  '');



-- Drop Down Option for Surgery
INSERT IGNORE INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('bc_ttr_surgery', '', '', NULL);

INSERT IGNORE INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`) VALUES
('Clinicalannotation', 'ConsentMaster', 'consent_masters', 'bc_ttr_surgery', 'bc_ttr_surgery', '', 'select', ' ', '', (SELECT id FROM structure_value_domains WHERE domain_name='bc_ttr_surgery') , 'help_form_version');

UPDATE structure_formats SET `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='bc_ttr_surgery' AND `type`='select' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='bc_ttr_surgery') ) WHERE structure_id=(SELECT id FROM structures WHERE alias='cd_nationals') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='ConsentMaster' AND tablename='consent_masters' AND field='bc_ttr_surgery' AND type='select' AND structure_value_domain  IS NULL );



INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="bc_ttr_surgery"),  (SELECT id FROM structure_permissible_values WHERE value="Yes" AND language_alias="Yes"), "1", "1");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="bc_ttr_surgery"),  (SELECT id FROM structure_permissible_values WHERE value="No" AND language_alias="No"), "2", "1");


INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("On-hold", "On-hold");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="bc_ttr_surgery"),  (SELECT id FROM structure_permissible_values WHERE value="On-hold" AND language_alias="On-hold"), "3", "1");
INSERT IGNORE INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('On-hold',  '',  'On-hold',  '');


INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("Paracentesis", "Paracentesis");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="bc_ttr_surgery"),  (SELECT id FROM structure_permissible_values WHERE value="Paracentesis" AND language_alias="Paracentesis"), "4", "1");
INSERT IGNORE INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('Paracentesis',  '',  'Paracentesis',  '');


INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("Thoracentesis", "Thoracentesis");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="bc_ttr_surgery"),  (SELECT id FROM structure_permissible_values WHERE value="Thoracentesis" AND language_alias="Thoracentesis"), "5", "1");
INSERT IGNORE INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('Thoracentesis',  '',  'Thoracentesis',  '');


INSERT IGNORE INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('bc_ttr_surgery',  '',  'Surgery',  '');

-- This is to fix the structure format error in Consent form
UPDATE `atim`.`structure_fields` SET `setting` = '' WHERE `structure_fields`.`id` =1892 LIMIT 1 ;
UPDATE `atim`.`structure_formats` SET `flag_override_setting` = '0' WHERE `structure_formats`.`id` =1181 LIMIT 1 ;
UPDATE `atim`.`structure_fields` SET `setting` = '' WHERE `structure_fields`.`id` =1893 LIMIT 1 ;


-- Remove Unneeded fields in Participant form
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='Participant' AND tablename='participants' AND field='cod_icd10_code' AND type='autocomplete' AND structure_value_domain  IS NULL );
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='Participant' AND tablename='participants' AND field='participant_identifier' AND type='input' AND structure_value_domain  IS NULL );
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='Participant' AND tablename='participants' AND field='race' AND type='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='race'));
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='Participant' AND tablename='participants' AND field='secondary_cod_icd10_code' AND type='autocomplete' AND structure_value_domain  IS NULL );
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='Participant' AND tablename='participants' AND field='dob_date_accuracy' AND type='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='datetime_accuracy_indicator'));

-- Remove readonly on PHN
UPDATE structure_formats SET `flag_edit_readonly`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='Participant' AND tablename='participants' AND field='bc_ttr_phn' AND type='input' AND structure_value_domain  IS NULL );




#-----------------------
-- Inventory Management
#------------------------


UPDATE parent_to_derivative_sample_controls SET flag_active=false WHERE id IN(137, 25, 119, 118, 142, 143, 141, 144, 7, 130, 8, 9, 101, 102, 140, 11);

UPDATE parent_to_derivative_sample_controls SET flag_active=false WHERE id IN(16, 132, 18);

UPDATE parent_to_derivative_sample_controls SET flag_active=false WHERE id IN(15, 24);

UPDATE sample_to_aliquot_controls SET flag_active=false WHERE id IN(18, 41, 51);



#-----------------
-- Collections 
#----------------

-- Hide Bank ID
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='Collection' AND tablename='collections' AND field='bank_id' AND type='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='banks'));

-- Hide Collection Datetime Accuracy
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='Collection' AND tablename='collections' AND field='collection_datetime_accuracy' AND type='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='datetime_accuracy_indicator'));

-- Hide Collection SOP 
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='Collection' AND tablename='collections' AND field='sop_master_id' AND type='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='collection_sop_list'));


-- Hide Collection Property
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='Collection' AND tablename='collections' AND field='collection_property' AND type='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='collection_property'));


-- batch entry
/*INSERT INTO structures(`alias`) VALUES ('BcTtrBeBlood');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`) VALUES
('', 'BcTtrBeBlood', '', 'blood_count', 'blood count', '', 'integer_positive', '', '',  NULL , ''), 
('', 'BcTtrBeBlood', '', 'tube_lot', 'tube lot', '', 'input', '', '',  NULL , ''), 
('', 'BcTtrBeBlood', '', 'volume', 'volume (ml)', '', 'float_positive', '', '',  NULL , '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='BcTtrBeBlood'), (SELECT id FROM structure_fields WHERE `model`='BcTtrBeBlood' AND `tablename`='' AND `field`='blood_count' AND `language_label`='blood count' AND `language_tag`='' AND `type`='integer_positive' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='BcTtrBeBlood'), (SELECT id FROM structure_fields WHERE `model`='BcTtrBeBlood' AND `tablename`='' AND `field`='tube_lot' AND `language_label`='tube lot' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='BcTtrBeBlood'), (SELECT id FROM structure_fields WHERE `model`='BcTtrBeBlood' AND `tablename`='' AND `field`='volume' AND `language_label`='volume (ml)' AND `language_tag`='' AND `type`='float_positive' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0');
*/

INSERT INTO structures(`alias`) VALUES ('BcTtrBePlasma');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`) VALUES
('', 'BcTtrBePlasma', '', 'batch_count', 'batch count', '', 'integer_positive', '', '',  NULL , ''), 
('', 'BcTtrBePlasma', '', 'box', 'box', '', 'autocomplete', 'url=/storagelayout/storage_masters/autocompleteLabel', '',  NULL , ''), 
('', 'BcTtrBePlasma', '', 'starting_x', 'starting column', '', 'input', '', '',  NULL , ''), 
('', 'BcTtrBePlasma', '', 'starting_y', 'starting row', '', 'input', '', '',  NULL , ''), 
('', 'BcTtrBePlasma', '', 'stored_datetime', 'datetime stored', '', 'datetime', '', '',  NULL , ''), 
('', 'BcTtrBePlasma', '', 'volume', 'volume (ml)', '', 'float_positive', '', '',  NULL , '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='BcTtrBePlasma'), (SELECT id FROM structure_fields WHERE `model`='BcTtrBePlasma' AND `tablename`='' AND `field`='batch_count' AND `language_label`='batch count' AND `language_tag`='' AND `type`='integer_positive' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='BcTtrBePlasma'), (SELECT id FROM structure_fields WHERE `model`='BcTtrBePlasma' AND `tablename`='' AND `field`='box' AND `language_label`='box' AND `language_tag`='' AND `type`='autocomplete' AND `setting`='url=/storagelayout/storage_masters/autocompleteLabel' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='BcTtrBePlasma'), (SELECT id FROM structure_fields WHERE `model`='BcTtrBePlasma' AND `tablename`='' AND `field`='starting_x' AND `language_label`='starting column' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='BcTtrBePlasma'), (SELECT id FROM structure_fields WHERE `model`='BcTtrBePlasma' AND `tablename`='' AND `field`='starting_y' AND `language_label`='starting row' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='BcTtrBePlasma'), (SELECT id FROM structure_fields WHERE `model`='BcTtrBePlasma' AND `tablename`='' AND `field`='stored_datetime' AND `language_label`='datetime stored' AND `language_tag`='' AND `type`='datetime' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='BcTtrBePlasma'), (SELECT id FROM structure_fields WHERE `model`='BcTtrBePlasma' AND `tablename`='' AND `field`='volume' AND `language_label`='volume (ml)' AND `language_tag`='' AND `type`='float_positive' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '6', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0');

INSERT INTO structures(`alias`) VALUES ('BcTtrBloodCell');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`) VALUES
('', 'BcTtrBloodCell', '', 'batch_count', 'batch count', '', 'integer_positive', '', '',  NULL , ''), 
('', 'BcTtrBloodCell', '', 'box', 'box', '', 'autocomplete', 'url=/storagelayout/storage_masters/autocompleteLabel', '',  NULL , ''), 
('', 'BcTtrBloodCell', '', 'starting_x', 'sarting column', '', 'input', '', '',  NULL , ''), 
('', 'BcTtrBloodCell', '', 'starting_y', 'starting row', '', 'input', '', '',  NULL , ''), 
('', 'BcTtrBloodCell', '', 'datetime_stored', 'stored datetime', '', 'datetime', '', '',  NULL , ''), 
('', 'BcTtrBloodCell', '', 'volume', 'volume (ml)', '', 'float_positive', '', '',  NULL , '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='BcTtrBloodCell'), (SELECT id FROM structure_fields WHERE `model`='BcTtrBloodCell' AND `tablename`='' AND `field`='batch_count' AND `language_label`='batch count' AND `language_tag`='' AND `type`='integer_positive' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='BcTtrBloodCell'), (SELECT id FROM structure_fields WHERE `model`='BcTtrBloodCell' AND `tablename`='' AND `field`='box' AND `language_label`='box' AND `language_tag`='' AND `type`='autocomplete' AND `setting`='url=/storagelayout/storage_masters/autocompleteLabel' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='BcTtrBloodCell'), (SELECT id FROM structure_fields WHERE `model`='BcTtrBloodCell' AND `tablename`='' AND `field`='starting_x' AND `language_label`='sarting column' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='BcTtrBloodCell'), (SELECT id FROM structure_fields WHERE `model`='BcTtrBloodCell' AND `tablename`='' AND `field`='starting_y' AND `language_label`='starting row' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='BcTtrBloodCell'), (SELECT id FROM structure_fields WHERE `model`='BcTtrBloodCell' AND `tablename`='' AND `field`='datetime_stored' AND `language_label`='stored datetime' AND `language_tag`='' AND `type`='datetime' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='BcTtrBloodCell'), (SELECT id FROM structure_fields WHERE `model`='BcTtrBloodCell' AND `tablename`='' AND `field`='volume' AND `language_label`='volume (ml)' AND `language_tag`='' AND `type`='float_positive' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '6', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0');

INSERT INTO structures(`alias`) VALUES ('BcTtrBeWhatman');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`) VALUES
('', 'BcTtrBeWhatman', '', 'batch_count', 'batch count', '', 'integer_positive', '', '',  NULL , ''), 
('', 'BcTtrBeWhatman', '', 'type', 'type', '', 'select', '', '',  NULL , ''), 
('', 'BcTtrBeWhatman', '', 'lot_nb', 'lot #', '', 'input', '', '',  NULL , ''), 
('', 'BcTtrBeWhatman', '', 'time_created', 'time created', '', 'time', '', '',  NULL , ''), 
('', 'BcTtrBeWhatman', '', 'time_stored', 'time stored', '', 'time', '', '',  NULL , '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='BcTtrBeWhatman'), (SELECT id FROM structure_fields WHERE `model`='BcTtrBeWhatman' AND `tablename`='' AND `field`='batch_count' AND `language_label`='batch count' AND `language_tag`='' AND `type`='integer_positive' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='BcTtrBeWhatman'), (SELECT id FROM structure_fields WHERE `model`='BcTtrBeWhatman' AND `tablename`='' AND `field`='type' AND `language_label`='type' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='BcTtrBeWhatman'), (SELECT id FROM structure_fields WHERE `model`='BcTtrBeWhatman' AND `tablename`='' AND `field`='lot_nb' AND `language_label`='lot #' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='BcTtrBeWhatman'), (SELECT id FROM structure_fields WHERE `model`='BcTtrBeWhatman' AND `tablename`='' AND `field`='time_created' AND `language_label`='time created' AND `language_tag`='' AND `type`='time' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='BcTtrBeWhatman'), (SELECT id FROM structure_fields WHERE `model`='BcTtrBeWhatman' AND `tablename`='' AND `field`='time_stored' AND `language_label`='time stored' AND `language_tag`='' AND `type`='time' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0');

INSERT INTO structure_value_domains (domain_name) VALUES
('bc_ttr_tissue_type'),
('bc_ttr_tissue_site'),
('bc_ttr_tissue_subsite');

INSERT INTO structures(`alias`) VALUES ('bc_ttr_be_block');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`) VALUES
('Inventorymanagement', 'AliquotMaster', '', 'batch_count', 'batch count', '', 'integer_positive', '', '',  NULL , ''), 
('Inventorymanagement', 'AliquotDetail', 'ad_blocks', 'block_type', 'block type', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='block_type') , ''), 
('Inventorymanagement', 'AliquotDetail', 'ad_blocks', 'bc_ttr_tissue_type', 'tissue type', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='bc_ttr_tissue_type') , ''), 
('Inventorymanagement', 'AliquotDetail', 'ad_blocks', 'bc_ttr_tissue_site', 'tissue site', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='bc_ttr_tissue_site') , ''), 
('Inventorymanagement', 'AliquotDetail', 'ad_blocks', 'bc_ttr_size_of_tumour', 'size of tumour', '', 'input', '', '',  NULL , ''), 
('Inventorymanagement', 'AliquotDetail', 'ad_blocks', 'bc_ttr_tissue_observation', 'tissue observation', '', 'input', '', '',  NULL , ''), 
('Inventorymanagement', 'AliquotDetail', 'ad_blocks', 'bc_ttr_time_of_removal', 'time of removal', '', 'time', '', '',  NULL , ''), 
('Inventorymanagement', 'AliquotDetail', 'ad_blocks', 'bc_ttr_page_time', 'page time', '', 'time', '', '',  NULL , ''), 
('Inventorymanagement', 'AliquotDetail', 'ad_blocks', 'bc_ttr_tissue_arrival_in_patho_lab', 'tissue arrival in pathology lab', '', 'time', '', '',  NULL , ''), 
('Inventorymanagement', 'AliquotDetail', 'ad_blocks', 'bc_ttr_pathologist_presence', 'pathologist presence', '', 'time', '', '',  NULL , ''), 
('Inventorymanagement', 'AliquotDetail', 'ad_blocks', 'bc_ttr_tissue_in_transporter', 'tissue in transporter', '', 'time', '', '',  NULL , ''), 
('Inventorymanagement', 'AliquotDetail', 'ad_blocks', 'bc_ttr_transporter', 'transporter', '', 'input', '', '',  NULL , ''), 
('Inventorymanagement', 'AliquotDetail', 'ad_blocks', 'bc_ttr_path_reference', 'path reference', '', 'input', '', '',  NULL , ''), 
('Inventorymanagement', 'AliquotDetail', 'ad_blocks', 'bc_ttr_size1', 'size (cm)', '', 'float_positive', '', '',  NULL , ''), 
('Inventorymanagement', 'AliquotDetail', 'ad_blocks', 'bc_ttr_size2', '', 'x', 'float_positive', '', '',  NULL , ''), 
('Inventorymanagement', 'AliquotDetail', 'ad_blocks', 'bc_ttr_size3', '', 'x', 'float_positive', '', '',  NULL , ''), 
('Inventorymanagement', 'AliquotDetail', 'ad_blocks', 'bc_ttr_block_observation', 'block observation', '', 'input', '', '',  NULL , ''), 
('', 'FunctionManagement', '', 'recorded_storage_selection_label', 'storage box', '', 'autocomplete', 'url=/storagelayout/storage_masters/autocompleteLabel', '', NULL , ''), 
('Inventorymanagement', 'AliquotDetail', 'ad_blocks', 'bc_ttr_tissue_subsite', 'tissue subsite', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='bc_ttr_tissue_subsite') , '');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='bc_ttr_be_block'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='' AND `field`='batch_count' AND `language_label`='batch count' AND `language_tag`='' AND `type`='integer_positive' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='bc_ttr_be_block'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_blocks' AND `field`='block_type' AND `language_label`='block type' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='block_type')  AND `language_help`=''), '1', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='bc_ttr_be_block'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_blocks' AND `field`='bc_ttr_tissue_type' AND `language_label`='tissue type' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='bc_ttr_tissue_type')  AND `language_help`=''), '1', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='bc_ttr_be_block'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_blocks' AND `field`='bc_ttr_tissue_site' AND `language_label`='tissue site' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='bc_ttr_tissue_site')  AND `language_help`=''), '1', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='bc_ttr_be_block'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_blocks' AND `field`='bc_ttr_size_of_tumour' AND `language_label`='size of tumour' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '7', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='bc_ttr_be_block'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_blocks' AND `field`='bc_ttr_tissue_observation' AND `language_label`='tissue observation' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '6', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='bc_ttr_be_block'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_blocks' AND `field`='bc_ttr_time_of_removal' AND `language_label`='time of removal' AND `language_tag`='' AND `type`='time' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '8', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='bc_ttr_be_block'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_blocks' AND `field`='bc_ttr_page_time' AND `language_label`='page time' AND `language_tag`='' AND `type`='time' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '9', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='bc_ttr_be_block'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_blocks' AND `field`='bc_ttr_tissue_arrival_in_patho_lab' AND `language_label`='tissue arrival in pathology lab' AND `language_tag`='' AND `type`='time' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='bc_ttr_be_block'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_blocks' AND `field`='bc_ttr_pathologist_presence' AND `language_label`='pathologist presence' AND `language_tag`='' AND `type`='time' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '11', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='bc_ttr_be_block'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_blocks' AND `field`='bc_ttr_tissue_in_transporter' AND `language_label`='tissue in transporter' AND `language_tag`='' AND `type`='time' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '12', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='bc_ttr_be_block'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_blocks' AND `field`='bc_ttr_transporter' AND `language_label`='transporter' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '13', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='bc_ttr_be_block'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_blocks' AND `field`='bc_ttr_path_reference' AND `language_label`='path reference' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '14', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='bc_ttr_be_block'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_blocks' AND `field`='bc_ttr_size1' AND `language_label`='size (cm)' AND `language_tag`='' AND `type`='float_positive' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '15', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='bc_ttr_be_block'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_blocks' AND `field`='bc_ttr_size2' AND `language_label`='' AND `language_tag`='x' AND `type`='float_positive' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '16', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='bc_ttr_be_block'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_blocks' AND `field`='bc_ttr_size3' AND `language_label`='' AND `language_tag`='x' AND `type`='float_positive' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '17', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='bc_ttr_be_block'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_blocks' AND `field`='bc_ttr_block_observation' AND `language_label`='block observation' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '18', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='bc_ttr_be_block'), (SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='recorded_storage_selection_label' AND `language_label`='storage box' AND `language_tag`='' AND `type`='autocomplete' AND `setting`='url=/storagelayout/storage_masters/autocompleteLabel' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`=''), '1', '19', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='bc_ttr_be_block'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='storage_datetime' AND `structure_value_domain`  IS NULL  ), '1', '20', '', '1', 'datetime stored', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='bc_ttr_be_block'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_blocks' AND `field`='bc_ttr_tissue_subsite' AND `language_label`='tissue subsite' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='bc_ttr_tissue_subsite')  AND `language_help`=''), '1', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0');

INSERT INTO structures(`alias`) VALUES ('bc_ttr_be_slides');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`) VALUES
('', 'AliquotDetail', '', 'bc_ttr_slide_stain', 'slide stain', '', 'input', '', '',  NULL , ''), 
('', 'AliquotDetail', '', 'bc_ttr_date_created', 'date created', '', 'date', '', '',  NULL , ''), 
('', 'AliquotDetail', '', 'bc_ttr_slide_location', 'slide location', '', 'input', '', '',  NULL , ''), 
('', 'AliquotMaster', '', 'notes', 'notes', '', 'textarea', '', '',  NULL , ''), 
('', 'AliquotDetail', '', 'bc_ttr_lab_technician', 'lab technician', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_staff') , '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='bc_ttr_be_slides'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='' AND `field`='bc_ttr_slide_stain' AND `language_label`='slide stain' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='bc_ttr_be_slides'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='' AND `field`='bc_ttr_date_created' AND `language_label`='date created' AND `language_tag`='' AND `type`='date' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='bc_ttr_be_slides'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='' AND `field`='bc_ttr_slide_location' AND `language_label`='slide location' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='bc_ttr_be_slides'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='' AND `field`='notes' AND `language_label`='notes' AND `language_tag`='' AND `type`='textarea' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='bc_ttr_be_slides'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='' AND `field`='bc_ttr_lab_technician' AND `language_label`='lab technician' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_staff')  AND `language_help`=''), '1', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0');

UPDATE structure_formats SET flag_datagrid='1' WHERE flag_addgrid='1' OR flag_editgrid='1';
UPDATE structure_formats SET flag_datagrid_readonly='1' WHERE flag_addgrid_readonly='1' OR flag_editgrid_readonly='1';

 
 
 
 
-- Insert and Update BC TTR Correspondences
 
#--------------------------------------------
#-- Create Correspondences Menu
#--------------------------------------------
INSERT INTO `atim`.`menus` (`id`, `parent_id`, `is_root`, `display_order`, `language_title`, `language_description`, `use_link`, `use_params`, `use_summary`, `flag_active`, `created`, `created_by`, `modified`, `modified_by`) VALUES ('clin_CAN_200', 'clin_CAN_1', '0', '3', 'correspondence', 'correspondence', '/clinicalannotation/correspondences/listall/%%Participant.id%%', '', 'Clinicalannotation.Participant::summary', '1', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0);
INSERT INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('correspondence',  '',  'Correspondence',  'Correspondence');


INSERT INTO structures(`alias`) VALUES ('correspondences');


-- Correspondence Datetime
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`) VALUES
('Clinicalannotation', 'Correspondence', 'bc_ttr_correspondences', 'bc_ttr_correspondence_datetime', 'correspondence date time', ' ', 'datetime', '', '',  NULL , '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='correspondences'), (SELECT id FROM structure_fields WHERE `model`='Correspondence' AND `tablename`='bc_ttr_correspondences' AND `field`='bc_ttr_correspondence_datetime' AND `language_label`='correspondence date time' AND `language_tag`=' ' AND `type`='datetime' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1');
 
INSERT INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('correspondence date time',  '',  'Correspondence Datetime',  '');

-- TTR bc_ttr_correspondence_nurse
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`) VALUES
('Clinicalannotation', 'Correspondence', 'bc_ttr_correspondences', 'bc_ttr_correspondence_nurse', 'ttr nurse', '', 'select', '', '',  NULL , '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='correspondences'), (SELECT id FROM structure_fields WHERE `model`='Correspondence' AND `tablename`='bc_ttr_correspondences' AND `field`='bc_ttr_correspondence_nurse' AND `language_label`='ttr nurse' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1');

 
INSERT INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('ttr nurse',  '',  'TTR Nurse',  '');


-- Correspondence Type
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`) VALUES
('Clinicalannotation', 'Correspondence', 'bc_ttr_correspondences', 'bc_ttr_correspondence_type', 'correspondence type', '', 'select', '', '',  NULL , '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='correspondences'), (SELECT id FROM structure_fields WHERE `model`='Correspondence' AND `tablename`='bc_ttr_correspondences' AND `field`='bc_ttr_correspondence_type' AND `language_label`='correspondence type' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1');

INSERT INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('correspondence type',  '',  'Type',  '');

-- Purpose
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`) VALUES
('Clinicalannotation', 'Correspondence', 'bc_ttr_correspondences', 'bc_ttr_purpose', 'purpose', '', 'select', '', '',  NULL , '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='correspondences'), (SELECT id FROM structure_fields WHERE `model`='Correspondence' AND `tablename`='bc_ttr_correspondences' AND `field`='bc_ttr_purpose' AND `language_label`='purpose' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1');

INSERT INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('purpose',  '',  'Purpose',  '');

-- Location

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`) VALUES
('Clinicalannotation', 'Correspondence', 'bc_ttr_correspondences', 'bc_ttr_location', 'location', '', 'select', '', '',  NULL , '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='correspondences'), (SELECT id FROM structure_fields WHERE `model`='Correspondence' AND `tablename`='bc_ttr_correspondences' AND `field`='bc_ttr_location' AND `language_label`='location' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1');

INSERT INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('location',  '',  'Location',  '');

--
-- TODO  Correspondence Notes
--
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`) VALUES
('Clinicalannotation', 'Correspondence', 'bc_ttr_correspondences', 'bc_ttr_correspondence_notes', 'notes', '', 'text', '', '',  NULL , '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='correspondences'), (SELECT id FROM structure_fields WHERE `model`='Correspondence' AND `tablename`='bc_ttr_correspondences' AND `field`='bc_ttr_correspondence_notes' AND `language_label`='notes' AND `language_tag`='' AND `type`='text' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1');




-- Drop Down Value Options for TTR Nurse
INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('bc_ttr_correspondence_nurse', '', '', NULL);

UPDATE structure_fields SET  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='bc_ttr_correspondence_nurse')  WHERE model='Correspondence' AND tablename='bc_ttr_correspondences' AND field='bc_ttr_correspondence_nurse' AND `type`='select' AND structure_value_domain  IS NULL ;

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("Jodi Le Blanc", "Jodi Le Blanc");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="bc_ttr_correspondence_nurse"),  (SELECT id FROM structure_permissible_values WHERE value="Jodi Le Blanc" AND language_alias="Jodi Le Blanc"), "1", "1");
INSERT INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('Jodi Le Blanc',  '',  'Jodi Le Blanc',  '');

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("Rebecca Barnes", "Rebecca Barnes");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="bc_ttr_correspondence_nurse"),  (SELECT id FROM structure_permissible_values WHERE value="Rebecca Barnes" AND language_alias="Rebecca Barnes"), "2", "1");
INSERT INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('Rebecca Barnes',  '',  'Rebecca Barnes',  '');

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("Sindy Babinszky", "Sindy Babinszky");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="bc_ttr_correspondence_nurse"),  (SELECT id FROM structure_permissible_values WHERE value="Sindy Babinszky" AND language_alias="Sindy Babinszky"), "3", "1");
INSERT INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('Sindy Babinszky',  '',  'Sindy Babinszky',  '');

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("Elizabeth Mason", "Elizabeth Mason");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="bc_ttr_correspondence_nurse"),  (SELECT id FROM structure_permissible_values WHERE value="Elizabeth Mason" AND language_alias="Elizabeth Mason"), "4", "1");
INSERT INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('Elizabeth Mason',  '',  'Elizabeth Mason',  '');

-- Drop Down Value Options for Correspondence Type

INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('bc_ttr_correspondence_type', '', '', NULL);

UPDATE structure_fields SET  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='bc_ttr_correspondence_type')  WHERE model='Correspondence' AND tablename='bc_ttr_correspondences' AND field='bc_ttr_correspondence_type' AND `type`='select' AND structure_value_domain  IS NULL ;


INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("By Phone", "By Phone");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="bc_ttr_correspondence_type"),  (SELECT id FROM structure_permissible_values WHERE value="By Phone" AND language_alias="By Phone"), "1", "1");
INSERT INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('By Phone',  '',  'By Phone',  '');


INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("In Person", "In Person");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="bc_ttr_correspondence_type"),  (SELECT id FROM structure_permissible_values WHERE value="In Person" AND language_alias="In Person"), "2", "1");

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("Other", "Other");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="bc_ttr_correspondence_type"),  (SELECT id FROM structure_permissible_values WHERE value="Other" AND language_alias="Other"), "3", "1");


-- 
-- Drop Down Value Options for Purpose
--
INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('bc_ttr_purpose', '', '', NULL);

UPDATE structure_fields SET  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='bc_ttr_purpose')  WHERE model='Correspondence' AND tablename='bc_ttr_correspondences' AND field='bc_ttr_purpose' AND `type`='select' AND structure_value_domain  IS NULL ;


INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("Arrange Consent Appt.", "Arrange Consent Appt.");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="bc_ttr_purpose"),  (SELECT id FROM structure_permissible_values WHERE value="Arrange Consent Appt." AND language_alias="Arrange Consent Appt."), "1", "1");
INSERT INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('Arrange Consent Appt.',  '',  'Arrange Consent Appt.',  '');



INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("Sign Consent", "Sign Consent");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="bc_ttr_purpose"),  (SELECT id FROM structure_permissible_values WHERE value="Sign Consent" AND language_alias="Sign Consent"), "2", "1");
INSERT INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('Sign Consent',  '',  'Sign Consent',  '');



INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES(" Post-op Follow-up", " Post-op Follow-up");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="bc_ttr_purpose"),  (SELECT id FROM structure_permissible_values WHERE value=" Post-op Follow-up" AND language_alias=" Post-op Follow-up"), "3", "1");
INSERT INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES (' Post-op Follow-up',  '',  ' Post-op Follow-up',  '');



INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("Other", "Other");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="bc_ttr_purpose"),  (SELECT id FROM structure_permissible_values WHERE value="Other" AND language_alias="Other"), "4", "1");


INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("IROC", "IROC");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="bc_ttr_purpose"),  (SELECT id FROM structure_permissible_values WHERE value="IROC" AND language_alias="IROC"), "5", "1");
INSERT INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('IROC',  '',  'IROC',  '');

--
-- Drop Down Value Options for Location
-- 
INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('bc_ttr_location', '', '', NULL);

UPDATE structure_fields SET  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='bc_ttr_location')  WHERE model='Correspondence' AND tablename='bc_ttr_correspondences' AND field='bc_ttr_location' AND `type`='select' AND structure_value_domain  IS NULL ;


INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("Victoria General", "Victoria General");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="bc_ttr_location"),  (SELECT id FROM structure_permissible_values WHERE value="Victoria General" AND language_alias="Victoria General"), "1", "1");



INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("Royal Jubilee", "Royal Jubilee");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="bc_ttr_location"),  (SELECT id FROM structure_permissible_values WHERE value="Royal Jubilee" AND language_alias="Royal Jubilee"), "2", "1");

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("VicGH-PAC", "VicGH-PAC");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="bc_ttr_location"),  (SELECT id FROM structure_permissible_values WHERE value="VicGH-PAC" AND language_alias="VicGH-PAC"), "3", "1");
INSERT INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('VicGH-PAC',  '',  'VicGH-PAC',  '');

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("VicGH-ward", "VicGH-ward");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="bc_ttr_location"),  (SELECT id FROM structure_permissible_values WHERE value="VicGH-ward" AND language_alias="VicGH-ward"), "4", "1");
INSERT INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('VicGH-ward',  '',  'VicGH-ward',  '');

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("VicGH-SDC", "VicGH-SDC");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="bc_ttr_location"),  (SELECT id FROM structure_permissible_values WHERE value="VicGH-SDC" AND language_alias="VicGH-SDC"), "5", "1");
INSERT INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('VicGH-SDC',  '',  'VicGH-SDC',  '');

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("RJH-PAC", "RJH-PAC");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="bc_ttr_location"),  (SELECT id FROM structure_permissible_values WHERE value="RJH-PAC" AND language_alias="RJH-PAC"), "6", "1");
INSERT INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('RJH-PAC',  '',  'RJH-PAC',  '');

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("RJH-ward", "RJH-ward");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="bc_ttr_location"),  (SELECT id FROM structure_permissible_values WHERE value="RJH-ward" AND language_alias="RJH-ward"), "7", "1");
INSERT INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('RJH-ward',  '',  'RJH-ward',  '');

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("RJH-SDC", "RJH-SDC");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="bc_ttr_location"),  (SELECT id FROM structure_permissible_values WHERE value="RJH-SDC" AND language_alias="RJH-SDC"), "8", "1");
INSERT INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('RJH-SDC',  '',  'RJH-SDC',  '');

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("VICC", "VICC");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="bc_ttr_location"),  (SELECT id FROM structure_permissible_values WHERE value="VICC" AND language_alias="VICC"), "9", "1");
INSERT INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('VICC',  '',  'VICC',  '');

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("Other", "Other");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="bc_ttr_location"),  (SELECT id FROM structure_permissible_values WHERE value="Other" AND language_alias="Other"), "10", "1");



INSERT INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('tissue block',  '',  'Tissue Block',  '');
INSERT INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('batch count',  '',  'Batch Count',  '');
-- INSERT INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('tissue site',  '',  'Tissue Site',  '');
-- INSERT INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('tissue subsite',  '',  'Tissue Subsite',  '');
INSERT INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('tissue type',  '',  'Tissue Type',  '');
INSERT INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('size of tumour',  '',  'Size of Tumour',  '');
INSERT INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('tissue observation',  '',  'Tissue Observation',  '');
INSERT INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('time of removal',  '',  'Time of Removal',  '');
INSERT INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('large',  '',  'Large',  '');
INSERT INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('page time',  '',  'Page time',  '');
INSERT INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('tissue arrival in pathology lab',  '',  'Tissue arrival in pathology lab',  '');
INSERT INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('pathologist presence',  '',  'Pathologist Presence',  '');
INSERT INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('tissue in transporter',  '',  'Tissue in transporter',  '');
INSERT INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('transporter',  '',  'Transporter',  '');
INSERT INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('path reference',  '',  'Path Reference',  '');
INSERT INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('size (cm)',  '',  'Size (cm)',  '');
INSERT INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('block observation',  '',  'Block observation',  '');
INSERT INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('storage box',  '',  'Storage box',  '');
INSERT INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('datetime stored',  '',  'Datetime stored',  '');
INSERT INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('tissue slide',  '',  'Tissue Slide',  '');
INSERT INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('one slide created per tissue block',  '',  'one slide created per tissue block',  '');
INSERT INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('slide stain',  '',  'Slide stain',  '');
INSERT INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('slide location',  '',  'Slide location',  '');
INSERT INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('lab technician',  '',  'Lab Technician',  '');
INSERT INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('batch entry',  '',  'Batch Entry',  '');



-- Always add the following drop data fields at the end of file. 
ALTER TABLE structure_formats
 DROP COLUMN flag_addgrid,
 DROP COLUMN flag_addgrid_readonly,
 DROP COLUMN flag_editgrid,
 DROP COLUMN flag_editgrid_readonly;
 
 
 