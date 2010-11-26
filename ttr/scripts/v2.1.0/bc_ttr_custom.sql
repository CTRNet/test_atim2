
-- Participants
-- PHN
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='bc_ttr_phn' AND `language_label`='phn' AND `language_tag`='' AND `type`='input' AND `setting`='size=20' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '3', '100', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1');

INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES ('bc_ttr_phn', '', 'PHN', 'PHN');




-- Consents ( cd_nationals)

-- Consent Closed
INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES
('', 'Clinicalannotation', 'ConsentMaster', 'consent_masters', 'bc_ttr_consent_closed', 'consent closed', '', 'select', '', '',  NULL , '', 'open', 'open', 'open');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='cd_nationals'), (SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='bc_ttr_consent_closed' AND `language_label`='consent closed' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '101', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='cd_nationals'), (SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='bc_ttr_consent_closed' AND `language_label`='consent closed' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '9', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1');
-- delete structure_formats
DELETE FROM structure_formats WHERE `display_column`='2' AND `display_order`='101' AND `language_heading`='' AND `flag_override_label`='0' AND `language_label`='' AND `flag_override_tag`='0' AND `language_tag`='' AND `flag_override_help`='0' AND `language_help`='' AND `flag_override_type`='0' AND `type`='' AND `flag_override_setting`='0' AND `setting`='' AND `flag_override_default`='0' AND `default`='' AND `flag_add`='1' AND `flag_add_readonly`='0' AND `flag_edit`='1' AND `flag_edit_readonly`='0' AND `flag_search`='0' AND `flag_search_readonly`='0' AND `flag_datagrid`='0' AND `flag_datagrid_readonly`='0' AND `flag_index`='0' AND `flag_detail`='1' AND `created`='0000-00-00 00:00:00' AND `created_by`='0' AND `modified`='0000-00-00 00:00:00' AND `modified_by`='0' ;

-- Date denied
INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES
('', 'Clinicalannotation', 'ConsentMaster', 'consent_masters', 'bc_ttr_date_denied', 'date denied', '', 'date', '', '',  NULL , '', 'open', 'open', 'open');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='cd_nationals'), (SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='bc_ttr_date_denied' AND `language_label`='date denied' AND `language_tag`='' AND `type`='date' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '3', '100', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1');

UPDATE structure_formats SET `display_column`='2' WHERE structure_id=(SELECT id FROM structures WHERE alias='cd_nationals') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='ConsentMaster' AND tablename='consent_masters' AND field='bc_ttr_date_denied' AND type='date' AND structure_value_domain  IS NULL );


-- Date Withdrawn
INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES
('', 'Clinicalannotation', 'ConsentMaster', 'consent_masters', 'bc_ttr_date_withdrawn', 'date withdrawn', '', 'date', '', 'NULL',  NULL , '', 'open', 'open', 'open');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='cd_nationals'), (SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='bc_ttr_date_withdrawn' AND `language_label`='date withdrawn' AND `language_tag`='' AND `type`='date' AND `setting`='' AND `default`='NULL' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '101', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1');


--Date Referral Withdrawn

INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES
('', 'Clinicalannotation', 'ConsentMaster', 'consent_masters', 'bc_ttr_date_referral_withdrawn', 'date referral withdrawn', '', 'date', '', 'NULL',  NULL , '', 'open', 'open', 'open');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='cd_nationals'), (SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='bc_ttr_date_referral_withdrawn' AND `language_label`='date referral withdrawn' AND `language_tag`='' AND `type`='date' AND `setting`='' AND `default`='NULL' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '102', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1');


-- Diagnosis


-- Cancer Type
INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES
('', 'Clinicalannotation', 'ConsentMaster', 'consent_masters', 'bc_ttr_cancer_type', 'cancer type', '', 'select', '', '',  NULL , '', 'open', 'open', 'open');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='cd_nationals'), (SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='bc_ttr_cancer_type' AND `language_label`='cancer type' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '104', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1');


-- Phone numbers, fax, email
INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES
('', 'Clinicalannotation', 'ConsentMaster', 'consent_masters', 'bc_ttr_home_phone', 'home phone', '', 'input', 'size=20', '',  NULL , '', 'open', 'open', 'open');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='cd_nationals'), (SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='bc_ttr_cancer_type' AND `language_label`='cancer type' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '104', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='cd_nationals'), (SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='bc_ttr_home_phone' AND `language_label`='home phone' AND `language_tag`='' AND `type`='input' AND `setting`='size=20' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '3', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1');


INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES
('', 'Clinicalannotation', 'ConsentMaster', 'consent_masters', 'bc_ttr_work_phone', 'work phone', '', 'input', 'size=20', '',  NULL , '', 'open', 'open', 'open');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='cd_nationals'), (SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='bc_ttr_work_phone' AND `language_label`='work phone' AND `language_tag`='' AND `type`='input' AND `setting`='size=20' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '3', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1');


INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES
('', 'Clinicalannotation', 'ConsentMaster', 'consent_masters', 'bc_ttr_cell_phone', 'cell phone', '', 'input', 'size=20', '',  NULL , '', 'open', 'open', 'open');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='cd_nationals'), (SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='bc_ttr_work_phone' AND `language_label`='work phone' AND `language_tag`='' AND `type`='input' AND `setting`='size=20' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '3', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='cd_nationals'), (SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='bc_ttr_cell_phone' AND `language_label`='cell phone' AND `language_tag`='' AND `type`='input' AND `setting`='size=20' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '3', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1');


INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES
('', 'Clinicalannotation', 'ConsentMaster', 'consent_masters', 'bc_ttr_email', 'email', '', 'input', 'size=20', '',  NULL , '', 'open', 'open', 'open');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='cd_nationals'), (SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='bc_ttr_fax_number' AND `language_label`='fax number' AND `language_tag`='' AND `type`='input' AND `setting`='size=20' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '3', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='cd_nationals'), (SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='bc_ttr_email' AND `language_label`='email' AND `language_tag`='' AND `type`='input' AND `setting`='size=20' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '3', '6', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1');

-- OR Datetime


-- Pathologist
INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES
('', 'Clinicalannotation', 'ConsentMaster', 'consent_masters', 'bc_ttr_pathologist', 'pathologist', '', 'input', '', '',  NULL , '', 'open', 'open', 'open');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='cd_nationals'), (SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='bc_ttr_pathologist' AND `language_label`='pathologist' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '105', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1');


-- Referral Method
INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES
('', 'Clinicalannotation', 'ConsentMaster', 'consent_masters', 'bc_ttr_referral_method', 'referral method', '', 'select', '', '',  NULL , '', 'open', 'open', 'open');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='cd_nationals'), (SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='bc_ttr_referral_method' AND `language_label`='referral method' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '106', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1');

-- Referral Source


-- Is AC Appt
INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES
('', 'Clinicalannotation', 'ConsentMaster', 'consent_masters', 'bc_ttr_is_ac_appt', 'is ac appt', '', 'select', '', '',  NULL , '', 'open', 'open', 'open');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='cd_nationals'), (SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='bc_ttr_is_ac_appt' AND `language_label`='is ac appt' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '109', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1');

-- TTR Appt Datetime
INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES
('', 'Clinicalannotation', 'ConsentMaster', 'consent_masters', 'bc_ttr_ttr_appt_datetime', 'ttr appt datetime', '', 'datetime', '', '',  NULL , '', 'open', 'open', 'open');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='cd_nationals'), (SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='bc_ttr_ttr_appt_datetime' AND `language_label`='ttr appt datetime' AND `language_tag`='' AND `type`='datetime' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '110', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1');

--Consent ID
INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES
('', 'Clinicalannotation', 'ConsentMaster', 'consent_masters', 'bc_ttr_consent_id', 'consent id', '', 'input', 'size=20', '',  NULL , '', 'open', 'open', 'open');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='cd_nationals'), (SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='bc_ttr_consent_id' AND `language_label`='consent id' AND `language_tag`='' AND `type`='input' AND `setting`='size=20' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '111', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1');


--Acquisition ID


-- Blood Collected
INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES
('', 'Clinicalannotation', 'ConsentMaster', 'consent_masters', 'bc_ttr_blood_collected', 'blood collected', '', 'select', '', '',  NULL , '', 'open', 'open', 'open');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='cd_nationals'), (SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='bc_ttr_blood_collected' AND `language_label`='blood collected' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '113', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1');

-- Tissue Collected

INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES
('', 'Clinicalannotation', 'ConsentMaster', 'consent_masters', 'bc_ttr_tissue_collected', 'tissue collected', '', 'select', '', '',  NULL , '', 'open', 'open', 'open');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='cd_nationals'), (SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='bc_ttr_tissue_collected' AND `language_label`='tissue collected' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '115', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1');

-- MRN

-- Path Spec
INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES
('', 'Clinicalannotation', 'ConsentMaster', 'consent_masters', 'bc_ttr_path_spec', 'path spec', '', 'input', 'size=20', '',  NULL , '', 'open', 'open', 'open');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='cd_nationals'), (SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='bc_ttr_path_spec' AND `language_label`='path spec' AND `language_tag`='' AND `type`='input' AND `setting`='size=20' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '117', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1');

--Protocol
INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES
('', 'Clinicalannotation', 'ConsentMaster', 'consent_masters', 'bc_ttr_protocol', 'protocol', '', 'input', 'size=20', '',  NULL , '', 'open', 'open', 'open');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='cd_nationals'), (SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='bc_ttr_protocol' AND `language_label`='protocol' AND `language_tag`='' AND `type`='input' AND `setting`='size=20' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '118', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1');

--SRC

INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES
('', 'Clinicalannotation', 'ConsentMaster', 'consent_masters', 'bc_ttr_src', 'src', '', 'select', '', '',  NULL , '', 'open', 'open', 'open');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='cd_nationals'), (SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='bc_ttr_src' AND `language_label`='src' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '121', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1');

--Outlook

INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES
('', 'Clinicalannotation', 'ConsentMaster', 'consent_masters', 'bc_ttr_outlook', 'bc ttr outlook', '', 'select', '', '',  NULL , '', 'open', 'open', 'open');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='cd_nationals'), (SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='bc_ttr_outlook' AND `language_label`='bc ttr outlook' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '122', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1');

UPDATE structure_fields SET  `language_label`='outlook' WHERE model='ConsentMaster' AND tablename='consent_masters' AND field='bc_ttr_outlook' AND `type`='select' AND structure_value_domain  IS NULL ;

-- TTR Appt Flag
INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES
('', 'Clinicalannotation', 'ConsentMaster', 'consent_masters', 'bc_ttr_appt', 'appt', '', 'select', '', '',  NULL , '', 'open', 'open', 'open');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='cd_nationals'), (SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='bc_ttr_appt' AND `language_label`='appt' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '123', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1');

-- Contact for genetic research
INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES
('', 'Clinicalannotation', 'ConsentMaster', 'consent_masters', 'bc_ttr_contact_for_genetic_research', 'contact for genetic research', '', 'input', '', '',  NULL , '', 'open', 'open', 'open');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='cd_nationals'), (SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='bc_ttr_contact_for_genetic_research' AND `language_label`='contact for genetic research' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '124', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1');

UPDATE structure_formats SET `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='bc_ttr_contact_for_genetic_research' AND `type`='select' AND `structure_value_domain` IS NULL ) WHERE structure_id=(SELECT id FROM structures WHERE alias='cd_nationals') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='ConsentMaster' AND tablename='consent_masters' AND field='bc_ttr_contact_for_genetic_research' AND type='input' AND structure_value_domain  IS NULL );

-- Smoking History
INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES
('', 'Clinicalannotation', 'ConsentMaster', 'consent_masters', 'bc_ttr_smoking_history', 'smoking history', '', 'select', '', '',  NULL , '', 'open', 'open', 'open');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='cd_nationals'), (SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='bc_ttr_smoking_history' AND `language_label`='smoking history' AND `language_tag`='' AND `type`='input' AND `setting`='size=20' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '125', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1');

-- Pack per year
INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES
('', 'Clinicalannotation', 'ConsentMaster', 'consent_masters', 'bc_ttr_pack_years', 'pack per year', '', 'input', 'size=20', '',  NULL , '', 'open', 'open', 'open');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='cd_nationals'), (SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='bc_ttr_pack_years' AND `language_label`='pack per year' AND `language_tag`='' AND `type`='input' AND `setting`='size=20' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '126', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1');



-- Insert Language label
INSERT INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('consent closed',  '',  'Consent Closed',  '');

INSERT INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('date denied',  '',  'Date Denied',  '');

INSERT INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('date withdrawn',  '',  'Date Withdrawn',  '');

INSERT INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('date referral withdrawn',  '',  'Date Referral Withdrawn',  '');

INSERT INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('referral method',  '',  'Referral Method',  '');

INSERT INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('referral source',  '',  'Referral Source',  '');

INSERT INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('is ac appt',  '',  'Is AC Appt',  '');

INSERT INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('ttr appt datetime',  '',  'TTR Appt Datetime',  '');

INSERT INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('consent id',  '',  'Consent ID',  '');

INSERT INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('acquisition id',  '',  'Acquisition ID',  '');

INSERT INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('blood collected',  '',  'Blood collected',  '');

INSERT INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('tissue collected',  '',  'Tissue collected',  '');

INSERT INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('mrn',  '',  'MRN',  '');

INSERT INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('path spec',  '',  'Path Spec',  '');

INSERT INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('iroc number',  '',  'IROC Number',  '');

INSERT INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('iroc flag',  '',  'IROC Flag',  '');

INSERT INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('src',  '',  'SRC',  '');

INSERT INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('outlook',  '',  'Outlook',  '');

INSERT INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('appt',  '',  'Appt',  '');

INSERT INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('contact for genetic research',  '',  'Contact for genetic research',  '');

INSERT INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('pack per year',  '',  'Pack per year',  '');

INSERT INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('years since quit',  '',  'Years since quit',  '');

INSERT INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('home phone',  '',  'Home phone',  '');

INSERT INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('work phone',  '',  'Work phone',  '');

INSERT INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('cell phone',  '',  'Cell phone',  '');

INSERT INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('or datetime',  '',  'OR Datetime',  '');


-- Updating Original ATiM fields in Consents
-- Hide Status Date
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='cd_nationals') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='ConsentMaster' AND tablename='consent_masters' AND field='status_date' AND type='date' AND structure_value_domain  IS NULL );
-- Hide Translator Indicator
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='cd_nationals') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='ConsentMaster' AND tablename='consent_masters' AND field='translator_indicator' AND type='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='access_medical_information'));


-- Create Drop Down Value Options for Referral Method
INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('bc_ttr_referral_method', '', '', NULL);

UPDATE `structure_fields` SET  `structure_value_domain` =  '227' WHERE  `structure_fields`.`id` =1072 LIMIT 1 

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("phone", "Phone");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="bc_ttr_referral_method"),  (SELECT id FROM structure_permissible_values WHERE value="phone" AND language_alias="Phone"), "1", "1");

INSERT INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('Phone',  '',  'Phone',  '');


INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("fax", "Fax");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="bc_ttr_referral_method"),  (SELECT id FROM structure_permissible_values WHERE value="fax" AND language_alias="Fax"), "2", "1");


INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("email", "Email");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="bc_ttr_referral_method"),  (SELECT id FROM structure_permissible_values WHERE value="email" AND language_alias="Email"), "3", "1");


INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("other", "Other");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="bc_ttr_referral_method"),  (SELECT id FROM structure_permissible_values WHERE value="other" AND language_alias="Other"), "4", "1");

-- Create Drop Down Value Options for Referral Source

INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('bc_ttr_referral_source', '', '', NULL);

UPDATE  `structure_fields` SET  `structure_value_domain` =  '228' WHERE  `structure_fields`.`id` =1073 LIMIT 1 

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("surgical office", "Surgical Office");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="bc_ttr_referral_source"),  (SELECT id FROM structure_permissible_values WHERE value="surgical office" AND language_alias="Surgical Office"), "1", "1");

INSERT INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('Surgical Office',  '',  'Surgical Office',  '');

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("PREDICT", "PREDICT");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="bc_ttr_referral_source"),  (SELECT id FROM structure_permissible_values WHERE value="PREDICT" AND language_alias="PREDICT"), "2", "1");

INSERT INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('PREDICT',  '',  'PREDICT',  '');


INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("Breast Health Centre", "Breast Health Centre");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="bc_ttr_referral_source"),  (SELECT id FROM structure_permissible_values WHERE value="Breast Health Centre" AND language_alias="Breast Health Centre"), "3", "1");

INSERT INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('Breast Health Centre',  '',  'Breast Health Centre',  '');


INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("self-referral", "self-referral");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="bc_ttr_referral_source"),  (SELECT id FROM structure_permissible_values WHERE value="self-referral" AND language_alias="self-referral"), "4", "1");

INSERT INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('self-referral',  '',  'Self-Referral',  '');

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("BCCA oncologist", "BCCA oncologist");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="bc_ttr_referral_source"),  (SELECT id FROM structure_permissible_values WHERE value="BCCA oncologist" AND language_alias="BCCA oncologist"), "5", "1");

INSERT INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('BCCA oncologist',  '',  'BCCA oncologist',  '');


INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("PAC", "PAC");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="bc_ttr_referral_source"),  (SELECT id FROM structure_permissible_values WHERE value="PAC" AND language_alias="PAC"), "6", "1");

INSERT INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('PAC',  '',  'PAC',  '');

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("other", "other");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="bc_ttr_referral_source"),  (SELECT id FROM structure_permissible_values WHERE value="other" AND language_alias="other"), "7", "1");

INSERT INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('other',  '',  'Other',  '');

-- Create Drop Down Value Options for Is AC Appt

INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('bc_ttr_is_ac_appt', '', '', NULL);

UPDATE  `structure_fields` SET  `structure_value_domain` =  '229' WHERE  `structure_fields`.`id` =1074 LIMIT 1 ;

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("yes", "yes");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="bc_ttr_is_ac_appt"),  (SELECT id FROM structure_permissible_values WHERE value="yes" AND language_alias="yes"), "1", "1");

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("no", "no");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="bc_ttr_is_ac_appt"),  (SELECT id FROM structure_permissible_values WHERE value="no" AND language_alias="no"), "2", "1");

-- Create Drop Down Value Options for Blood Collected

INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('bc_ttr_blood_collected', '', '', NULL);

UPDATE  `structure_fields` SET  `structure_value_domain` =  '233' WHERE  `structure_fields`.`id` =1078 LIMIT 1 ;
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="bc_ttr_blood_collected"),  (SELECT id FROM structure_permissible_values WHERE value="yes" AND language_alias="yes"), "1", "1");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="bc_ttr_blood_collected"),  (SELECT id FROM structure_permissible_values WHERE value="no" AND language_alias="no"), "2", "1");


-- Create Drop Down Value Options for Tissue Collected

INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('bc_ttr_tissue_collected', '', '', NULL);

UPDATE  `structure_fields` SET  `structure_value_domain` =  '234' WHERE  `structure_fields`.`id` =1079 LIMIT 1 ;
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="bc_ttr_tissue_collected"),  (SELECT id FROM structure_permissible_values WHERE value="yes" AND language_alias="yes"), "1", "1");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="bc_ttr_tissue_collected"),  (SELECT id FROM structure_permissible_values WHERE value="no" AND language_alias="no"), "2", "1");

-- Create Drop Down Value Options for SRC

INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('bc_ttr_src', '', '', NULL);

UPDATE  `structure_fields` SET  `structure_value_domain` =  '235' WHERE  `structure_fields`.`id` =1085 LIMIT 1 ;
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="bc_ttr_src"),  (SELECT id FROM structure_permissible_values WHERE value="yes" AND language_alias="yes"), "1", "1");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="bc_ttr_src"),  (SELECT id FROM structure_permissible_values WHERE value="no" AND language_alias="no"), "2", "1");


-- Create Drop Down Value Options for Outlook
INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('bc_ttr_outlook', '', '', NULL);


UPDATE  `structure_fields` SET  `structure_value_domain` =  '236' WHERE  `structure_fields`.`id` =1086 LIMIT 1 ;
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="bc_ttr_outlook"),  (SELECT id FROM structure_permissible_values WHERE value="yes" AND language_alias="yes"), "1", "1");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="bc_ttr_outlook"),  (SELECT id FROM structure_permissible_values WHERE value="no" AND language_alias="no"), "2", "1");


-- Create Drop Down Value Options for TTR Appt
INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('bc_ttr_appt', '', '', NULL);


UPDATE  `structure_fields` SET  `structure_value_domain` =  '237' WHERE  `structure_fields`.`id` =1087 LIMIT 1 ;
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="bc_ttr_appt"),  (SELECT id FROM structure_permissible_values WHERE value="yes" AND language_alias="yes"), "1", "1");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="bc_ttr_appt"),  (SELECT id FROM structure_permissible_values WHERE value="no" AND language_alias="no"), "2", "1");



-- Create Drop Down Value Options for Smoking History (Ever Smoke)
INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('bc_ttr_smoking_history', '', '', NULL);

UPDATE  `structure_fields` SET  `structure_value_domain` =  '238' WHERE  `structure_fields`.`id` =1089 LIMIT 1 ;

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("never", "never");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="bc_ttr_smoking_history"),  (SELECT id FROM structure_permissible_values WHERE value="never" AND language_alias="never"), "1", "1");
INSERT INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('never',  '',  'Never',  '');

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("former", "former");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="bc_ttr_smoking_history"),  (SELECT id FROM structure_permissible_values WHERE value="former" AND language_alias="former"), "2", "1");
INSERT INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('former',  '',  'Former',  '');

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("current", "current");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="bc_ttr_smoking_history"),  (SELECT id FROM structure_permissible_values WHERE value="current" AND language_alias="current"), "3", "1");
INSERT INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('current',  '',  'Current',  '');

-- Create Drop Down Value Options for Facility (103)
INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('facility', '', '', NULL);

UPDATE  `structure_fields` SET  `structure_value_domain` =  '163' WHERE  `structure_fields`.`id` =121 LIMIT 1 ;


INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("Royal Jubilee", "Royal Jubilee");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="facility"),  (SELECT id FROM structure_permissible_values WHERE value="Royal Jubilee" AND language_alias="Royal Jubilee"), "1", "1");
INSERT INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('Royal Jubilee',  '',  'Royal Jubilee',  '');



INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("Victoria General", "Victoria General");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="facility"),  (SELECT id FROM structure_permissible_values WHERE value="Victoria General" AND language_alias="Victoria General"), "2", "1");
INSERT INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('Victoria General',  '',  'Victoria General',  '');



INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("VIC/RJH Radiology", "VIC/RJH Radiology");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="facility"),  (SELECT id FROM structure_permissible_values WHERE value="VIC/RJH Radiology" AND language_alias="VIC/RJH Radiology"), "3", "1");
INSERT INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('VIC/RJH Radiology',  '',  'VIC/RJH Radiology',  '');



-- Create Drop Down Value Options for Consent Closed
INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('bc_ttr_consent_closed', '', '', NULL);

UPDATE  `structure_fields` SET  `structure_value_domain` =  '240' WHERE  `structure_fields`.`id` =1058 LIMIT 1 ;


INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("obtained-tissue direct to TTR", "obtained-tissue direct to TTR");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="bc_ttr_consent_closed"),  (SELECT id FROM structure_permissible_values WHERE value="obtained-tissue direct to TTR" AND language_alias="obtained-tissue direct to TTR"), "1", "1");
INSERT INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('obtained-tissue direct to TTR',  '',  'obtained-tissue direct to TTR',  '');



INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("obtained-tissue available indirectly", "obtained-tissue available indirectly");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="bc_ttr_consent_closed"),  (SELECT id FROM structure_permissible_values WHERE value="obtained-tissue available indirectly" AND language_alias="obtained-tissue available indirectly"), "2", "1");
INSERT INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('obtained-tissue available indirectly',  '',  'obtained-tissue available indirectly',  '');



INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("obtained-no tissue", "obtained-no tissue");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="bc_ttr_consent_closed"),  (SELECT id FROM structure_permissible_values WHERE value="obtained-no tissue" AND language_alias="obtained-no tissue"), "3", "1");
INSERT INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('obtained-no tissue',  '',  'obtained-no tissue',  '');




INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("unknown-lost to follow-up", "unknown-lost to follow-up");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="bc_ttr_consent_closed"),  (SELECT id FROM structure_permissible_values WHERE value="unknown-lost to follow-up" AND language_alias="unknown-lost to follow-up"), "4", "1");
INSERT INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('unknown-lost to follow-up',  '',  'unknown-lost to follow-up',  '');



INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("unknown-no response", "unknown-no response");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="bc_ttr_consent_closed"),  (SELECT id FROM structure_permissible_values WHERE value="unknown-no response" AND language_alias="unknown-no response"), "5", "1");
INSERT INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('unknown-no response',  '',  'unknown-no response',  '');



INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("unknown-tissue direct to TTR", "unknown-tissue direct to TTR");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="bc_ttr_consent_closed"),  (SELECT id FROM structure_permissible_values WHERE value="unknown-tissue direct to TTR" AND language_alias="unknown-tissue direct to TTR"), "6", "1");
INSERT INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('unknown-tissue direct to TTR',  '',  'unknown-tissue direct to TTR',  '');



INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("unknown-verbal consent/signed consent not returned", "unknown-verbal consent/signed consent not returned");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="bc_ttr_consent_closed"),  (SELECT id FROM structure_permissible_values WHERE value="unknown-verbal consent/signed consent not returned" AND language_alias="unknown-verbal consent/signed consent not returned"), "7", "1");
INSERT INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('unknown-verbal consent/signed consent not returned',  '',  'unknown-verbal consent/signed consent not returned',  '');


INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("withdrawn-by clinical office", "withdrawn-by clinical office");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="bc_ttr_consent_closed"),  (SELECT id FROM structure_permissible_values WHERE value="withdrawn-by clinical office" AND language_alias="withdrawn-by clinical office"), "8", "1");
INSERT INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('withdrawn-by clinical office',  '',  'withdrawn-by clinical office',  '');


INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("withdrawn-by TTR nurse", "withdrawn-by TTR nurse");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="bc_ttr_consent_closed"),  (SELECT id FROM structure_permissible_values WHERE value="withdrawn-by TTR nurse" AND language_alias="withdrawn-by TTR nurse"), "9", "1");
INSERT INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('withdrawn-by TTR nurse',  '',  'withdrawn-by TTR nurse',  '');



INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("withheld-anytime from tissue collection", "withheld-anytime from tissue collection");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="bc_ttr_consent_closed"),  (SELECT id FROM structure_permissible_values WHERE value="withheld-anytime from tissue collection" AND language_alias="withheld-anytime from tissue collection"), "10", "1");
INSERT INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('withheld-anytime from tissue collection',  '',  'withheld-anytime from tissue collection',  '');



INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("withheld-referral contact/consent meeting/form", "withheld-referral contact/consent meeting/form");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="bc_ttr_consent_closed"),  (SELECT id FROM structure_permissible_values WHERE value="withheld-referral contact/consent meeting/form" AND language_alias="withheld-referral contact/consent meeting/form"), "11", "1");
INSERT INTO  `i18n` (`id` ,`page_id` ,`en` ,`fr`)VALUES ('withheld-referral contact/consent meeting/form',  '',  'withheld-referral contact/consent meeting/form',  '');


