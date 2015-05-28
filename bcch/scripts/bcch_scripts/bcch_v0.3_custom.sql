-- BCCH Customization Script
-- Version 0.3
-- ATiM Version: 2.6.3

-- Update bank name for version tracking during customization
REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('core_installname', "BCCH Biobank - BCCH v0.3", '');

--  =========================================================================
--	Eventum ID: #3217 - Storage System Code not displaying
--  BB-45
--	=========================================================================

UPDATE view_storage_masters
SET view_storage_masters.code = view_storage_masters.id
WHERE view_storage_masters.code = '';

--  =========================================================================
--	Eventum ID: #3235 - Repairing old participant data
--  BB-46
--	=========================================================================

-- Move CCBR240 identifier from C00331 (deleted) to C00379

UPDATE misc_identifiers SET `participant_id`=379 WHERE `participant_id`=331 AND `identifier_value`='CCBR240';
UPDATE misc_identifiers_revs SET `participant_id`=379 WHERE `participant_id`=331 AND `identifier_value`='CCBR240';

-- Move CCBR167 identifier from C00188 (deleted) to C00211

UPDATE misc_identifiers SET `participant_id`=211 WHERE `participant_id`=188 AND `identifier_value`='CCBR167';
UPDATE misc_identifiers_revs SET `participant_id`=211 WHERE `participant_id`=188 AND `identifier_value`='CCBR167';

-- Move CCBR49 identifier FROM C00106 (deleted) to C00107

UPDATE misc_identifiers SET `participant_id`=107 WHERE `participant_id`=106 AND `identifier_value`='CCBR49';
UPDATE misc_identifiers_revs SET `participant_id`=107 WHERE `participant_id`=106 AND `identifier_value`='CCBR49';

-- Move first_name and last_name FROM C00106 (deleted) to C00107

UPDATE participants as p1,
(SELECT `title`, `first_name`, `last_name` FROM participants WHERE `id`=106) as p2
SET p1.title = p2.title, p1.first_name = p2.first_name, p1.last_name = p2.last_name
WHERE p1.id=107;

-- Move CCBR56 identifier FROM C00010 (deleted) to C00039

UPDATE misc_identifiers SET `participant_id`=39 WHERE `participant_id`=10 AND `identifier_value`='CCBR56';
UPDATE misc_identifiers_revs SET `participant_id`=39 WHERE `participant_id`=10 AND `identifier_value`='CCBR56';

-- Move CCBR34 identifier FROM C00069 (deleted) to C00089

UPDATE misc_identifiers SET `participant_id`=89 WHERE `participant_id`=69 AND `identifier_value`='CCBR34';
UPDATE misc_identifiers_revs SET `participant_id`=89 WHERE `participant_id`=69 AND `identifier_value`='CCBR34';

-- Move CCBR124 identifier FROM C00143 (deleted) to C00158

UPDATE misc_identifiers SET `participant_id`=158 WHERE `participant_id`=143 AND `identifier_value`='CCBR124';
UPDATE misc_identifiers_revs SET `participant_id`=158 WHERE `participant_id`=143 AND `identifier_value`='CCBR124';

-- Move CCBR55 identifier FROM C00009 (deleted) to C00052

UPDATE misc_identifiers SET `participant_id`=52 WHERE `participant_id`=9 AND `identifier_value`='CCBR55';
UPDATE misc_identifiers_revs SET `participant_id`=52 WHERE `participant_id`=9 AND `identifier_value`='CCBR55';

-- Move CCBR144 identifier FROM C00167 (deleted) to C00204
-- Hold it! The 204 also has CCBR182 and CCBR144
-- No samples for C00167, Just keep the patient as CCBR182, don't add CCBR 144

-- UPDATE misc_identifiers SET `participant_id`=204 WHERE `participant_id`=167 AND `identifier_value`='CCBR144';
-- UPDATE misc_identifiers_revs SET `participant_id`=204 WHERE `participant_id`=167 AND `identifier_value`='CCBR144';

-- Move CCBR102 identifier FROM C00119 (deleted) to C00121

UPDATE misc_identifiers SET `participant_id`=121 WHERE `participant_id`=119 AND `identifier_value`='CCBR102';
UPDATE misc_identifiers_revs SET `participant_id`=121 WHERE `participant_id`=119 AND `identifier_value`='CCBR102';

-- Move CCBR68 identifier FROM C00045 (deleted) to C00054

UPDATE misc_identifiers SET `participant_id`=54 WHERE `participant_id`=45 AND `identifier_value`='CCBR68';
UPDATE misc_identifiers_revs SET `participant_id`=54 WHERE `participant_id`=45 AND `identifier_value`='CCBR68';

-- Move CCBR243 identifier FROM C00334 (deleted) to C00344

UPDATE misc_identifiers SET `participant_id`=344 WHERE `participant_id`=334 AND `identifier_value`='CCBR243';
UPDATE misc_identifiers_revs SET `participant_id`=344 WHERE `participant_id`=334 AND `identifier_value`='CCBR243';

-- Move CCBR66 identifier FROM C00043 (deleted) to C00053

UPDATE misc_identifiers SET `participant_id`=53 WHERE `participant_id`=43 AND `identifier_value`='CCBR66';
UPDATE misc_identifiers_revs SET `participant_id`=53 WHERE `participant_id`=43 AND `identifier_value`='CCBR66'; 
 
--  =========================================================================
--	Eventum ID: #3192 - BCWH Consent Form
--  BB-40
--	=========================================================================

DROP TABLE IF EXISTS `cd_bcwh_consents`;

CREATE TABLE cd_bcwh_consents (
	`id` int(11) NOT NULL AUTO_INCREMENT,
	`bcwh_verbal_consent` varchar(45) DEFAULT NULL,
	`bcwh_date_verbal_consent` date DEFAULT NULL,
	`bcwh_person_verbal_consent` varchar(45) DEFAULT NULL,
	`bcwh_formal_consent` varchar(45) DEFAULT NULL,
	`bcwh_formal_consent_type` varchar(45) DEFAULT NULL,
	`bcwh_date_formal_consent` date DEFAULT NULL,
	`bcwh_person_formal_consent` varchar(45) DEFAULT NULL,
	`bcwh_consent_all_donation` varchar(45) DEFAULT NULL,
	`bcwh_consent_tissue` varchar(45) DEFAULT NULL,
	`bcwh_consent_blood` varchar(45) DEFAULT NULL,
	`bcwh_consent_extra_blood` varchar(45) DEFAULT NULL,
	`bcwh_consent_genetic_material` varchar(45) DEFAULT NULL,
	`bcwh_consent_swabs` varchar(45) DEFAULT NULL,
	`bcwh_consent_placenta` varchar(45) DEFAULT NULL,
	`bcwh_consent_umbilical_cord_blood` varchar(45) DEFAULT NULL,
	`bcwh_consent_urine` varchar(45) DEFAULT NULL,
	`bcwh_consent_stool` varchar(45) DEFAULT NULL,
	`bcwh_consent_prev_materials` varchar(45) DEFAULT NULL,
	`bcwh_consent_other_materials` varchar(45) DEFAULT NULL,
	`bcwh_other_materials_description` varchar(45) DEFAULT NULL,
	`bcwh_date_withdrawal_revoke` date DEFAULT NULL,
	`bcwh_consent_withdrawal` varchar(45) DEFAULT NULL,
	`bcwh_consent_revoke` varchar(45) DEFAULT NULL,
	`bcwh_assent_adolescent_capacity` varchar(45) DEFAULT NULL,
	`consent_master_id` int(11) NOT NULL,
	`deleted` tinyint(3) DEFAULT '0',
	PRIMARY KEY (`id`)
);

DROP TABLE IF EXISTS `cd_bcwh_consents_revs`;

CREATE TABLE cd_bcwh_consents_revs (
	`id` int(11) NOT NULL,
	`bcwh_verbal_consent` varchar(45) DEFAULT NULL,
	`bcwh_date_verbal_consent` date DEFAULT NULL,
	`bcwh_person_verbal_consent` varchar(45) DEFAULT NULL,
	`bcwh_formal_consent` varchar(45) DEFAULT NULL,
	`bcwh_formal_consent_type` varchar(45) DEFAULT NULL,
	`bcwh_date_formal_consent` date DEFAULT NULL,
	`bcwh_person_formal_consent` varchar(45) DEFAULT NULL,
	`bcwh_consent_all_donation` varchar(45) DEFAULT NULL,
	`bcwh_consent_tissue` varchar(45) DEFAULT NULL,
	`bcwh_consent_blood` varchar(45) DEFAULT NULL,
	`bcwh_consent_extra_blood` varchar(45) DEFAULT NULL,
	`bcwh_consent_genetic_material` varchar(45) DEFAULT NULL,
	`bcwh_consent_swabs` varchar(45) DEFAULT NULL,
	`bcwh_consent_placenta` varchar(45) DEFAULT NULL,
	`bcwh_consent_umbilical_cord_blood` varchar(45) DEFAULT NULL,
	`bcwh_consent_urine` varchar(45) DEFAULT NULL,
	`bcwh_consent_stool` varchar(45) DEFAULT NULL,
	`bcwh_consent_prev_materials` varchar(45) DEFAULT NULL,
	`bcwh_consent_other_materials` varchar(45) DEFAULT NULL,
	`bcwh_other_materials_description` varchar(45) DEFAULT NULL,
	`bcwh_date_withdrawal_revoke` date DEFAULT NULL,
	`bcwh_consent_withdrawal` varchar(45) DEFAULT NULL,
	`bcwh_consent_revoke` varchar(45) DEFAULT NULL,
	`bcwh_assent_adolescent_capacity` varchar(45) DEFAULT NULL,
	`consent_master_id` int(11) NOT NULL,
	`version_id` int(11) NOT NULL AUTO_INCREMENT,
	`version_created` DATETIME NOT NULL,
	PRIMARY KEY (`version_id`)
);

-- Linking the consent form with consent masters
INSERT INTO consent_controls (`controls_type`, `flag_active`, `detail_form_alias`, `detail_tablename`, `display_order`, `databrowser_label`)
VALUES ('BCWH Consent', '1', 'cd_bcwh_consents', 'cd_bcwh_consents', 3, 'BCWH Consent');

-- Registering the form as a sturcture
INSERT INTO structures (`alias`, `description`) VALUES ('cd_bcwh_consents', NULL);

-- BCWH Verbal and Formal Consent Date

INSERT INTO structure_fields
(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`)
VALUES
('ClinicalAnnotation', 'ConsentDetail', 'cd_bcwh_consents', 'bcwh_date_formal_consent', 'date',  NULL , 0, '', '', '', 'bcwh date formal consent', ''),
('ClinicalAnnotation', 'ConsentDetail', 'cd_bcwh_consents', 'bcwh_date_verbal_consent', 'date',  NULL , 0, '', '', '', 'bcwh date verbal consent', '');

INSERT INTO structure_formats (`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_summary`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_float`, `margin`) VALUES 
((SELECT `id` FROM structures WHERE alias='cd_bcwh_consents'), (SELECT `id` FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_bcwh_consents' AND `field`='bcwh_date_formal_consent' AND `type`='date' AND `language_label`='bcwh date formal consent' AND `flag_confidential`='0' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open'), '1', '8', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '0', '0', '1', '1', '0', '0'),
((SELECT `id` FROM structures WHERE alias='cd_bcwh_consents'), (SELECT `id` FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_bcwh_consents' AND `field`='bcwh_date_verbal_consent' AND `type`='date' AND `language_label`='bcwh date verbal consent' AND `flag_confidential`='0' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open'), '1', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '0', '0', '1', '1', '0', '0');


-- BCWH Verbal and Formal Consent Status

INSERT INTO structure_value_domains (`domain_name`, `override`) VALUES ('bcwh_consent_status', 'open');

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`)
VALUES
('consented', 'bcwh_consented'),
('declined', 'bcwh_declined'),
('withdrawn', 'bcwh_withdrawn');

INSERT INTO structure_value_domains_permissible_values
(`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`)
VALUES
((SELECT `id` FROM structure_value_domains WHERE `domain_name`='bcwh_consent_status'), (SELECT `id` FROM structure_permissible_values WHERE `value`='consented' AND `language_alias`='bcwh_consented'), 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name`='bcwh_consent_status'), (SELECT `id` FROM structure_permissible_values WHERE `value`='declined' AND `language_alias`='bcwh_declined'), 2, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name`='bcwh_consent_status'), (SELECT `id` FROM structure_permissible_values WHERE `value`='withdrawn' AND `language_alias`='bcwh_withdrawn'), 3, 1);

INSERT INTO structure_fields
(`plugin`, `model`, `tablename`, `field`, `language_label`, `type`, `structure_value_domain`, `validation_control`, `value_domain_control`, `field_control`, `flag_confidential`)
VALUES
('ClinicalAnnotation', 'ConsentDetail', 'cd_bcwh_consents', 'bcwh_formal_consent', 'bcwh formal consent', 'select', (SELECT `id` FROM structure_value_domains WHERE `domain_name`='bcwh_consent_status'), 'open', 'open', 'open', 0),
('ClinicalAnnotation', 'ConsentDetail', 'cd_bcwh_consents', 'bcwh_verbal_consent', 'bcwh verbal consent', 'select', (SELECT `id` FROM structure_value_domains WHERE `domain_name`='bcwh_consent_status'), 'open', 'open', 'open', 0);


INSERT INTO structure_formats
(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`, `margin`)
VALUES
((SELECT `id` FROM structures WHERE alias='cd_bcwh_consents'), (SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_bcwh_consents' AND `field`='bcwh_formal_consent' AND `type`='select' AND `structure_value_domain`=(SELECT `id` FROM structure_value_domains WHERE `domain_name`='bcwh_consent_status')), '1', '4', 'bcwh formal consent', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT `id` FROM structures WHERE alias='cd_bcwh_consents'), (SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_bcwh_consents' AND `field`='bcwh_verbal_consent' AND `type`='select' AND `structure_value_domain`=(SELECT `id` FROM structure_value_domains WHERE `domain_name`='bcwh_consent_status')), '1', '1', 'bcwh verbal consent', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');

-- BCWH Consent Yes/No/NA for different samples

INSERT INTO structure_value_domains (`domain_name`, `override`) VALUES ('bcwh_consent_yesnona', 'open');

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`)
VALUES
('yes', 'bcwh_yes'),
('no', 'bcwh_no'),
('na', 'bcwh_na');

INSERT INTO structure_value_domains_permissible_values
(`structure_value_domain_id`,`structure_permissible_value_id`,`display_order`,`flag_active`,`use_as_input`)
VALUES
((SELECT `id` FROM structure_value_domains WHERE `domain_name`='bcwh_consent_yesnona'), (SELECT `id` FROM structure_permissible_values WHERE `language_alias` LIKE 'bcwh_yes'), 1, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name`='bcwh_consent_yesnona'), (SELECT `id` FROM structure_permissible_values WHERE `language_alias` LIKE 'bcwh_no'), 2, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name`='bcwh_consent_yesnona'), (SELECT `id` FROM structure_permissible_values WHERE `language_alias` LIKE 'bcwh_na'), 3, 1, 1);

INSERT INTO structure_fields
(`plugin`, `model`, `tablename`, `field`, `language_label`, `type`, `structure_value_domain`, `validation_control`, `value_domain_control`, `field_control`, `flag_confidential`)
VALUES
('ClinicalAnnotation', 'ConsentDetail', 'cd_bcwh_consents', 'bcwh_consent_all_donation', 'bcwh consent all donation', 'select', (SELECT `id` FROM structure_value_domains WHERE `domain_name`='bcwh_consent_yesnona'), 'open', 'open', 'open', '0'),
('ClinicalAnnotation', 'ConsentDetail', 'cd_bcwh_consents', 'bcwh_consent_tissue', 'bcwh consent tissue', 'select', (SELECT `id` FROM structure_value_domains WHERE `domain_name`='bcwh_consent_yesnona'), 'open', 'open', 'open', '0'),
('ClinicalAnnotation', 'ConsentDetail', 'cd_bcwh_consents', 'bcwh_consent_blood', 'bcwh consent blood', 'select', (SELECT `id` FROM structure_value_domains WHERE `domain_name`='bcwh_consent_yesnona'), 'open', 'open', 'open', '0'),
('ClinicalAnnotation', 'ConsentDetail', 'cd_bcwh_consents', 'bcwh_consent_extra_blood', 'bcwh consent extra blood', 'select', (SELECT `id` FROM structure_value_domains WHERE `domain_name`='bcwh_consent_yesnona'), 'open', 'open', 'open', '0'),
('ClinicalAnnotation', 'ConsentDetail', 'cd_bcwh_consents', 'bcwh_consent_genetic_material', 'bcwh consent genetic material', 'select', (SELECT `id` FROM structure_value_domains WHERE `domain_name`='bcwh_consent_yesnona'), 'open', 'open', 'open', '0'),
('ClinicalAnnotation', 'ConsentDetail', 'cd_bcwh_consents', 'bcwh_consent_swabs', 'bcwh consent swabs', 'select', (SELECT `id` FROM structure_value_domains WHERE `domain_name`='bcwh_consent_yesnona'), 'open', 'open', 'open', '0'),
('ClinicalAnnotation', 'ConsentDetail', 'cd_bcwh_consents', 'bcwh_consent_placenta', 'bcwh consent placenta', 'select', (SELECT `id` FROM structure_value_domains WHERE `domain_name`='bcwh_consent_yesnona'), 'open', 'open', 'open', '0'),
('ClinicalAnnotation', 'ConsentDetail', 'cd_bcwh_consents', 'bcwh_consent_umbilical_cord_blood', 'bcwh consent umbilical cord blood', 'select', (SELECT `id` FROM structure_value_domains WHERE `domain_name`='bcwh_consent_yesnona'), 'open', 'open', 'open', '0'),
('ClinicalAnnotation', 'ConsentDetail', 'cd_bcwh_consents', 'bcwh_consent_urine', 'bcwh consent urine', 'select', (SELECT `id` FROM structure_value_domains WHERE `domain_name`='bcwh_consent_yesnona'), 'open', 'open', 'open', '0'),
('ClinicalAnnotation', 'ConsentDetail', 'cd_bcwh_consents', 'bcwh_consent_stool', 'bcwh consent stool', 'select', (SELECT `id` FROM structure_value_domains WHERE `domain_name`='bcwh_consent_yesnona'), 'open', 'open', 'open', '0'),
('ClinicalAnnotation', 'ConsentDetail', 'cd_bcwh_consents', 'bcwh_consent_prev_materials', 'bcwh consent other materials', 'select', (SELECT `id` FROM structure_value_domains WHERE `domain_name`='bcwh_consent_yesnona'), 'open', 'open', 'open', '0'),
('ClinicalAnnotation', 'ConsentDetail', 'cd_bcwh_consents', 'bcwh_consent_other_materials', 'bcwh consent previous materials', 'select', (SELECT `id` FROM structure_value_domains WHERE `domain_name`='bcwh_consent_yesnona'), 'open', 'open', 'open', '0');

INSERT INTO structure_formats
(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `flag_override_tag`, `flag_override_help`, `flag_override_type`, `flag_override_setting`, `flag_override_default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_summary`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_float`, `margin`)
VALUES
((SELECT `id` FROM structures WHERE `alias`='cd_bcwh_consents'), (SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_bcwh_consents' AND `field`='bcwh_consent_all_donation' AND `type`='select'), 1, 12, 'bcwh consent details', 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='cd_bcwh_consents'), (SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_bcwh_consents' AND `field`='bcwh_consent_tissue' AND `type`='select'), 1, 13, '', 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='cd_bcwh_consents'), (SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_bcwh_consents' AND `field`='bcwh_consent_blood' AND `type`='select'), 1, 14, '', 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='cd_bcwh_consents'), (SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_bcwh_consents' AND `field`='bcwh_consent_extra_blood' AND `type`='select'), 1, 15, '', 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='cd_bcwh_consents'), (SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_bcwh_consents' AND `field`='bcwh_consent_genetic_material' AND `type`='select'), 1, 16, '', 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='cd_bcwh_consents'), (SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_bcwh_consents' AND `field`='bcwh_consent_swabs' AND `type`='select'), 1, 17, '', 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='cd_bcwh_consents'), (SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_bcwh_consents' AND `field`='bcwh_consent_placenta' AND `type`='select'), 1, 18, '', 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='cd_bcwh_consents'), (SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_bcwh_consents' AND `field`='bcwh_consent_umbilical_cord_blood' AND `type`='select'), 1, 19, '', 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='cd_bcwh_consents'), (SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_bcwh_consents' AND `field`='bcwh_consent_urine' AND `type`='select'), 1, 20, '', 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='cd_bcwh_consents'), (SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_bcwh_consents' AND `field`='bcwh_consent_stool' AND `type`='select'), 1, 21, '', 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='cd_bcwh_consents'), (SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_bcwh_consents' AND `field`='bcwh_consent_prev_materials' AND `type`='select'), 1, 24, '', 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='cd_bcwh_consents'), (SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_bcwh_consents' AND `field`='bcwh_consent_other_materials' AND `type`='select'), 1, 23, '', 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0);

-- BCWH Other Materials Description

INSERT INTO structure_fields
(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `flag_confidential`)
VALUES
('ClinicalAnnotation', 'ConsentDetail', 'cd_bcwh_consents', 'bcwh_other_materials_description', '', 'bcwh other materials description', 'textarea', 'cols=20,rows=1', '', NULL, '', 'open', 'open', 'open', '0');

INSERT INTO structure_formats
(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_summary`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_float`, `margin`)
VALUES
((SELECT `id` FROM structures WHERE `alias`='cd_bcwh_consents'), (SELECT `id` FROM structure_fields WHERE plugin='ClinicalAnnotation' AND model='ConsentDetail' AND tablename='cd_bcwh_consents' AND field='bcwh_other_materials_description' AND type='textarea'), '1', '26', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');

-- Formal Consent Type

INSERT INTO structure_value_domains (`domain_name`) VALUES ('bcwh_formal_consent_type');

INSERT INTO structure_permissible_values (`value`, `language_alias`) VALUES 
('participant', 'bcwh participant'),
('parental', 'bcwh parental');

INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`, `use_as_input`) VALUES
((SELECT `id` FROM structure_value_domains WHERE `domain_name`='bcwh_formal_consent_type'),
 (SELECT `id` FROM structure_permissible_values WHERE `value`='participant' AND `language_alias`='bcwh participant'), 
 1, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name`='bcwh_formal_consent_type'),
 (SELECT `id` FROM structure_permissible_values WHERE `value`='parental' AND `language_alias`='bcwh parental'), 
 1, 1, 1);

INSERT INTO `structure_fields` (`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `flag_confidential`) VALUES ('ClinicalAnnotation', 'ConsentDetail', 'cd_bcwh_consents', 'bcwh_formal_consent_type', '', 'bcwh formal consent', 'select', '', '', (SELECT `id` FROM structure_value_domains WHERE `domain_name`='bcwh_formal_consent_type'), '', 'open', 'open', 'open', '0');

INSERT INTO `structure_formats` (`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_summary`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_float`, `margin`) VALUES ((SELECT `id` FROM structures WHERE `alias`='cd_bcwh_consents'), (SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_bcwh_consents' AND `field`='bcwh_formal_consent_type' AND `type`='select' AND `structure_value_domain`=(SELECT `id` FROM structure_value_domains WHERE `domain_name`='bcwh_formal_consent_type')), '1', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');

-- Consent Withdrawal

INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`, `use_as_input`) VALUES
((SELECT `id` FROM structure_value_domains WHERE `domain_name`='bcwh_consent_yesnona'),
 (SELECT `id` FROM structure_permissible_values WHERE `value`='yes' AND `language_alias`='bcwh_yes'), 
 1, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name`='bcwh_consent_yesnona'),
 (SELECT `id` FROM structure_permissible_values WHERE `value`='no' AND `language_alias`='bcwh_no'), 
 2, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name`='bcwh_consent_yesnona'),
 (SELECT `id` FROM structure_permissible_values WHERE `value`='na' AND `language_alias`='bcwh_na'), 
 3, 1, 1);

INSERT INTO `structure_fields` (`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `flag_confidential`) VALUES 
('ClinicalAnnotation', 'ConsentDetail', 'cd_bcwh_consents', 'bcwh_date_withdrawal_revoke', 'bcwh date withdrawal revoke', '', 'date', '', '', NULL, '', 'open', 'open', 'open', '0'),
('ClinicalAnnotation', 'ConsentDetail', 'cd_bcwh_consents', 'bcwh_consent_revoke', 'bcwh consent revoke', '', 'select', '', '', (SELECT `id` FROM structure_value_domains WHERE `domain_name`='bcwh_consent_yesnona'), '', 'open', 'open', 'open', '0'),
('ClinicalAnnotation', 'ConsentDetail', 'cd_bcwh_consents', 'bcwh_consent_withdrawal', 'bcwh consent withdrawal', '', 'select', '', '', (SELECT `id` FROM structure_value_domains WHERE `domain_name`='bcwh_consent_yesnona'), '', 'open', 'open', 'open', '0');

INSERT INTO `structure_formats` (`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_summary`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_float`, `margin`) VALUES 
((SELECT `id` FROM structures WHERE `alias`='cd_bcwh_consents'), (SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_bcwh_consents' AND `field`='bcwh_date_withdrawal_revoke' AND `type`='date'), 2, 1, 'bcwh withdrawal', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '',
 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='cd_bcwh_consents'), (SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_bcwh_consents' AND `field`='bcwh_consent_revoke' AND `type`='select' AND `structure_value_domain`=(SELECT `id` FROM structure_value_domains WHERE `domain_name`='bcwh_consent_yesnona')), 2, 2, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '',
 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='cd_bcwh_consents'), (SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_bcwh_consents' AND `field`='bcwh_consent_withdrawal' AND `type`='select' AND `structure_value_domain`=(SELECT `id` FROM structure_value_domains WHERE `domain_name`='bcwh_consent_yesnona')), 2, 3, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '',
 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0);

-- Person Consenting (Verbal and Formal)

INSERT INTO structure_fields (`id`, `public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `flag_confidential`)
VALUES (NULL, '', 'ClinicalAnnotation', 'ConsentDetail', 'cd_bcwh_consents', 'bcwh_person_verbal_consent', 'bcwh person verbal consent', '', 'select', '', '', (SELECT id FROM `structure_value_domains` WHERE `domain_name`='custom_person_consenting'), '', 'open', 'open', 'open', '0');
INSERT INTO structure_fields (`id`, `public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `flag_confidential`)
VALUES (NULL, '', 'ClinicalAnnotation', 'ConsentDetail', 'cd_bcwh_consents', 'bcwh_person_formal_consent', 'bcwh person formal consent', '', 'select', '', '', (SELECT id FROM `structure_value_domains` WHERE `domain_name`='custom_person_consenting'), '', 'open', 'open', 'open', '0');

INSERT INTO structure_formats (`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_summary`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_float`, `margin`)
VALUES ((SELECT id FROM structures WHERE alias='cd_bcwh_consents'), (SELECT id FROM structure_fields WHERE plugin='ClinicalAnnotation' AND model='ConsentDetail' AND tablename='cd_bcwh_consents' AND field='bcwh_person_verbal_consent' AND type='select' AND structure_value_domain=(SELECT id FROM `structure_value_domains` WHERE `domain_name`='custom_person_consenting')), '1', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='cd_bcwh_consents'), (SELECT id FROM structure_fields WHERE plugin='ClinicalAnnotation' AND model='ConsentDetail' AND tablename='cd_bcwh_consents' AND field='bcwh_person_formal_consent' AND type='select' AND structure_value_domain=(SELECT id FROM `structure_value_domains` WHERE `domain_name`='custom_person_consenting')), '1', '7', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');

-- Linking translator used field in the master form to BCCH form

INSERT INTO structure_formats (`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_summary`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_float`, `margin`)
VALUES ((SELECT id FROM structures WHERE alias='cd_bcwh_consents'), (SELECT id FROM structure_fields WHERE plugin='ClinicalAnnotation' AND model='ConsentMaster' AND tablename='consent_masters' AND field='translator_indicator' AND type='yes_no'), '1', '9', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', 'n', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='cd_bcwh_consents'), (SELECT id FROM structure_fields WHERE plugin='ClinicalAnnotation' AND model='ConsentMaster' AND tablename='consent_masters' AND field='translator_signature' AND type='yes_no'), '1', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');

-- Adolescent capacity to consent

INSERT INTO structure_fields (`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `flag_confidential`)
VALUES ('ClinicalAnnotation', 'ConsentDetail', 'cd_bcwh_consents', 'bcwh_assent_adolescent_capacity', 'bcwh assent adolescent capacity', '', 'yes_no', '', '', NULL, '', 'open', 'open', 'open', '0');

INSERT INTO structure_formats (`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_summary`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_float`, `margin`)
VALUES ((SELECT id FROM structures WHERE alias='cd_bcwh_consents'), (SELECT id FROM structure_fields WHERE plugin='ClinicalAnnotation' AND model='ConsentDetail' AND tablename='cd_bcwh_consents' AND field='bcwh_assent_adolescent_capacity' AND type='yes_no'), '1', '11', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');

-- Translation Files

REPLACE INTO i18n (`id`, `en`) VALUES
('BCWH Consent', 'BCWH Consent Form'),
('bcwh verbal consent', 'Verbal Consent'),
('bcwh date verbal consent', 'Date of Verbal Consent'),
('bcwh_consented', 'Consented'),
('bcwh_declined', 'Declined'),
('bcwh_withdrawn', 'Withdrawn'),
('bcwh date formal consent', 'Date of Formal Consent'),
('bcwh consent details', 'Consent Details'),
('bcwh consent all donation', 'Consent to Donation of All Sample Types'),
('bcwh consent tissue', 'Consent to Tissue Donation'),
('bcwh consent blood', 'Consent to Donation of Blood'),
('bcwh consent extra blood', 'Consent to Collection of an Additional Blood Draw'),
('bcwh consent genetic material', 'Use of Left over Genetic Materials'),
('bcwh consent swabs', 'Use of Swabs'),
('bcwh consent placenta', 'Consent to Donation of Placenta'),
('bcwh consent umbilical cord blood', 'Consent to Donation of Umbilical Cord Blood'),
('bcwh consent urine', 'Use of Urine'),
('bcwh consent stool', 'Use of Stool'),
('bcwh consent other materials', 'Consent to Other Materials'),
('bcwh consent previous materials', 'Use of Samples Previously Collected'),
('bcwh other materials description', 'Other Materials:'),
('bcwh_yes', 'Yes'),
('bcwh_no', 'No'),
('bcwh_na', 'N/A'),
('bcwh parental', 'Parental'),
('bcwh participant', 'Participant'),
('bcwh formal consent', 'Formal Consent'),
('bcwh withdrawal', 'Withdrawal'),
('bcwh date withdrawal revoke', 'Date of Withdrawal/Revoke'),
('bcwh consent revoke', 'Revoke of Consent'),
('bcwh consent withdrawal', 'Withdrawal of Consent'),
('bcwh person verbal consent', 'Person Consenting (Verbal)'),
('bcwh person formal consent', 'Person Consenting (Formal)'),
('bcwh assent adolescent capacity', 'Adolescent Capacity to Consent');

--  =========================================================================
--	Eventum ID: #3212 - BCWH Maternal Consent Form
--	=========================================================================

DROP TABLE IF EXISTS `cd_bcwh_maternal_consents`;

CREATE TABLE cd_bcwh_maternal_consents (
	`id` int(11) NOT NULL AUTO_INCREMENT,
	`bcwh_maternal_verbal_consent` varchar(45) DEFAULT NULL,
	`bcwh_maternal_date_verbal_consent` date DEFAULT NULL,
	`bcwh_maternal_person_verbal_consent` varchar(45) DEFAULT NULL,
	`bcwh_maternal_formal_consent` varchar(45) DEFAULT NULL,
	`bcwh_maternal_formal_consent_type` varchar(45) DEFAULT NULL,
	`bcwh_maternal_date_formal_consent` date DEFAULT NULL,
	`bcwh_maternal_person_formal_consent` varchar(45) DEFAULT NULL,
	`bcwh_maternal_consent_all_donation` varchar(45) DEFAULT NULL,
	`bcwh_maternal_consent_tissue` varchar(45) DEFAULT NULL,
	`bcwh_maternal_consent_blood` varchar(45) DEFAULT NULL,
	`bcwh_maternal_consent_extra_blood` varchar(45) DEFAULT NULL,
	`bcwh_maternal_consent_genetic_material` varchar(45) DEFAULT NULL,
	`bcwh_maternal_consent_swabs` varchar(45) DEFAULT NULL,
	`bcwh_maternal_consent_placenta` varchar(45) DEFAULT NULL,
	`bcwh_maternal_consent_umbilical_cord_blood` varchar(45) DEFAULT NULL,
	`bcwh_maternal_consent_urine` varchar(45) DEFAULT NULL,
	`bcwh_maternal_consent_stool` varchar(45) DEFAULT NULL,
	`bcwh_maternal_consent_prev_materials` varchar(45) DEFAULT NULL,
	`bcwh_maternal_consent_other_materials` varchar(45) DEFAULT NULL,
	`bcwh_maternal_other_materials_description` varchar(45) DEFAULT NULL,
	`bcwh_maternal_date_withdrawal_revoke` date DEFAULT NULL,
	`bcwh_maternal_consent_withdrawal` varchar(45) DEFAULT NULL,
	`bcwh_maternal_consent_revoke` varchar(45) DEFAULT NULL,
	`bcwh_maternal_assent_adolescent_capacity` varchar(45) DEFAULT NULL,
	`consent_master_id` int(11) NOT NULL,
	`deleted` tinyint(3) DEFAULT '0',
	PRIMARY KEY (`id`)
);

DROP TABLE IF EXISTS `cd_bcwh_maternal_consents_revs`;

CREATE TABLE cd_bcwh_maternal_consents_revs (
	`id` int(11) NOT NULL,
	`bcwh_maternal_verbal_consent` varchar(45) DEFAULT NULL,
	`bcwh_maternal_date_verbal_consent` date DEFAULT NULL,
	`bcwh_maternal_person_verbal_consent` varchar(45) DEFAULT NULL,
	`bcwh_maternal_formal_consent` varchar(45) DEFAULT NULL,
	`bcwh_maternal_formal_consent_type` varchar(45) DEFAULT NULL,
	`bcwh_maternal_date_formal_consent` date DEFAULT NULL,
	`bcwh_maternal_person_formal_consent` varchar(45) DEFAULT NULL,
	`bcwh_maternal_consent_all_donation` varchar(45) DEFAULT NULL,
	`bcwh_maternal_consent_tissue` varchar(45) DEFAULT NULL,
	`bcwh_maternal_consent_blood` varchar(45) DEFAULT NULL,
	`bcwh_maternal_consent_extra_blood` varchar(45) DEFAULT NULL,
	`bcwh_maternal_consent_genetic_material` varchar(45) DEFAULT NULL,
	`bcwh_maternal_consent_swabs` varchar(45) DEFAULT NULL,
	`bcwh_maternal_consent_placenta` varchar(45) DEFAULT NULL,
	`bcwh_maternal_consent_umbilical_cord_blood` varchar(45) DEFAULT NULL,
	`bcwh_maternal_consent_urine` varchar(45) DEFAULT NULL,
	`bcwh_maternal_consent_stool` varchar(45) DEFAULT NULL,
	`bcwh_maternal_consent_prev_materials` varchar(45) DEFAULT NULL,
	`bcwh_maternal_consent_other_materials` varchar(45) DEFAULT NULL,
	`bcwh_maternal_other_materials_description` varchar(45) DEFAULT NULL,
	`bcwh_maternal_date_withdrawal_revoke` date DEFAULT NULL,
	`bcwh_maternal_consent_withdrawal` varchar(45) DEFAULT NULL,
	`bcwh_maternal_consent_revoke` varchar(45) DEFAULT NULL,
	`bcwh_maternal_assent_adolescent_capacity` varchar(45) DEFAULT NULL,
	`consent_master_id` int(11) NOT NULL,
	`version_id` int(11) NOT NULL AUTO_INCREMENT,
	`version_created` DATETIME NOT NULL,
	PRIMARY KEY (`version_id`)
);

-- Linking the consent form with consent masters
INSERT INTO consent_controls (`controls_type`, `flag_active`, `detail_form_alias`, `detail_tablename`, `display_order`, `databrowser_label`)
VALUES ('BCWH Maternal Consent', '1', 'cd_bcwh_maternal_consents', 'cd_bcwh_maternal_consents', 4, 'BCWH Maternal Consent');

-- Registering the form as a sturcture
INSERT INTO structures (`alias`, `description`) VALUES ('cd_bcwh_maternal_consents', NULL);


-- BCWH Maternal Verbal and Formal Consent Date

INSERT INTO structure_fields
(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`)
VALUES
('ClinicalAnnotation', 'ConsentDetail', 'cd_bcwh_maternal_consents', 'bcwh_maternal_date_formal_consent', 'date',  NULL , 0, '', '', '', 'bcwh maternal date formal consent', ''),
('ClinicalAnnotation', 'ConsentDetail', 'cd_bcwh_maternal_consents', 'bcwh_maternal_date_verbal_consent', 'date',  NULL , 0, '', '', '', 'bcwh maternal date verbal consent', '');

INSERT INTO structure_formats (`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_summary`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_float`, `margin`) VALUES 
((SELECT `id` FROM structures WHERE alias='cd_bcwh_maternal_consents'), (SELECT `id` FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_bcwh_maternal_consents' AND `field`='bcwh_maternal_date_formal_consent' AND `type`='date' AND `language_label`='bcwh maternal date formal consent' AND `flag_confidential`='0' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open'), 1, 8, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 1, 0, 1, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE alias='cd_bcwh_maternal_consents'), (SELECT `id` FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_bcwh_maternal_consents' AND `field`='bcwh_maternal_date_verbal_consent' AND `type`='date' AND `language_label`='bcwh maternal date verbal consent' AND `flag_confidential`='0' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open'), 1, 2, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 1, 0, 1, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 1, 1, 0, 0);


-- BCWH Verbal and Formal Consent Status

INSERT INTO structure_value_domains (`domain_name`, `override`) VALUES ('bcwh_maternal_consent_status', 'open');

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`)
VALUES
('consented', 'bcwh_maternal_consented'),
('declined', 'bcwh_maternal_declined'),
('withdrawn', 'bcwh_maternal_withdrawn');

INSERT INTO structure_value_domains_permissible_values
(`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`)
VALUES
((SELECT `id` FROM structure_value_domains WHERE `domain_name`='bcwh_maternal_consent_status'), (SELECT `id` FROM structure_permissible_values WHERE `value`='consented' AND `language_alias`='bcwh_maternal_consented'), 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name`='bcwh_maternal_consent_status'), (SELECT `id` FROM structure_permissible_values WHERE `value`='declined' AND `language_alias`='bcwh_maternal_declined'), 2, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name`='bcwh_maternal_consent_status'), (SELECT `id` FROM structure_permissible_values WHERE `value`='withdrawn' AND `language_alias`='bcwh_maternal_withdrawn'), 3, 1);

INSERT INTO structure_fields
(`plugin`, `model`, `tablename`, `field`, `language_label`, `type`, `structure_value_domain`, `validation_control`, `value_domain_control`, `field_control`, `flag_confidential`)
VALUES
('ClinicalAnnotation', 'ConsentDetail', 'cd_bcwh_maternal_consents', 'bcwh_maternal_formal_consent', 'bcwh maternal formal consent', 'select', (SELECT `id` FROM structure_value_domains WHERE `domain_name`='bcwh_maternal_consent_status'), 'open', 'open', 'open', 0),
('ClinicalAnnotation', 'ConsentDetail', 'cd_bcwh_maternal_consents', 'bcwh_maternal_verbal_consent', 'bcwh maternal verbal consent', 'select', (SELECT `id` FROM structure_value_domains WHERE `domain_name`='bcwh_maternal_consent_status'), 'open', 'open', 'open', 0);


INSERT INTO structure_formats
(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`, `margin`)
VALUES
((SELECT `id` FROM structures WHERE alias='cd_bcwh_maternal_consents'), (SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_bcwh_maternal_consents' AND `field`='bcwh_maternal_formal_consent' AND `type`='select' AND `structure_value_domain`=(SELECT `id` FROM structure_value_domains WHERE `domain_name`='bcwh_maternal_consent_status')), 1, 4, 'bcwh maternal formal consent', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 1, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE alias='cd_bcwh_maternal_consents'), (SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_bcwh_maternal_consents' AND `field`='bcwh_maternal_verbal_consent' AND `type`='select' AND `structure_value_domain`=(SELECT `id` FROM structure_value_domains WHERE `domain_name`='bcwh_maternal_consent_status')), 1, 1, 'bcwh maternal verbal consent', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 1, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0);

-- BCWH Consent Yes/No/NA for different samples

INSERT INTO structure_value_domains (`domain_name`, `override`) VALUES ('bcwh_maternal_consent_yesnona', 'open');

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`)
VALUES
('yes', 'bcwh_maternal_yes'),
('no', 'bcwh_maternal_no'),
('na', 'bcwh_maternal_na');

INSERT INTO structure_value_domains_permissible_values
(`structure_value_domain_id`,`structure_permissible_value_id`,`display_order`,`flag_active`,`use_as_input`)
VALUES
((SELECT `id` FROM structure_value_domains WHERE `domain_name`='bcwh_maternal_consent_yesnona'), (SELECT `id` FROM structure_permissible_values WHERE `language_alias` LIKE 'bcwh_maternal_yes'), 1, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name`='bcwh_maternal_consent_yesnona'), (SELECT `id` FROM structure_permissible_values WHERE `language_alias` LIKE 'bcwh_maternal_no'), 2, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name`='bcwh_maternal_consent_yesnona'), (SELECT `id` FROM structure_permissible_values WHERE `language_alias` LIKE 'bcwh_maternal_na'), 3, 1, 1);

INSERT INTO structure_fields
(`plugin`, `model`, `tablename`, `field`, `language_label`, `type`, `structure_value_domain`, `validation_control`, `value_domain_control`, `field_control`, `flag_confidential`)
VALUES
('ClinicalAnnotation', 'ConsentDetail', 'cd_bcwh_maternal_consents', 'bcwh_maternal_consent_all_donation', 'bcwh maternal consent all donation', 'select', (SELECT `id` FROM structure_value_domains WHERE `domain_name`='bcwh_maternal_consent_yesnona'), 'open', 'open', 'open', 0),
('ClinicalAnnotation', 'ConsentDetail', 'cd_bcwh_maternal_consents', 'bcwh_maternal_consent_tissue', 'bcwh maternal consent tissue', 'select', (SELECT `id` FROM structure_value_domains WHERE `domain_name`='bcwh_maternal_consent_yesnona'), 'open', 'open', 'open', 0),
('ClinicalAnnotation', 'ConsentDetail', 'cd_bcwh_maternal_consents', 'bcwh_maternal_consent_blood', 'bcwh maternal consent blood', 'select', (SELECT `id` FROM structure_value_domains WHERE `domain_name`='bcwh_maternal_consent_yesnona'), 'open', 'open', 'open', 0),
('ClinicalAnnotation', 'ConsentDetail', 'cd_bcwh_maternal_consents', 'bcwh_maternal_consent_extra_blood', 'bcwh maternal consent extra blood', 'select', (SELECT `id` FROM structure_value_domains WHERE `domain_name`='bcwh_maternal_consent_yesnona'), 'open', 'open', 'open', 0),
('ClinicalAnnotation', 'ConsentDetail', 'cd_bcwh_maternal_consents', 'bcwh_maternal_consent_genetic_material', 'bcwh maternal consent genetic material', 'select', (SELECT `id` FROM structure_value_domains WHERE `domain_name`='bcwh_maternal_consent_yesnona'), 'open', 'open', 'open', 0),
('ClinicalAnnotation', 'ConsentDetail', 'cd_bcwh_maternal_consents', 'bcwh_maternal_consent_swabs', 'bcwh maternal consent swabs', 'select', (SELECT `id` FROM structure_value_domains WHERE `domain_name`='bcwh_maternal_consent_yesnona'), 'open', 'open', 'open', 0),
('ClinicalAnnotation', 'ConsentDetail', 'cd_bcwh_maternal_consents', 'bcwh_maternal_consent_placenta', 'bcwh maternal consent placenta', 'select', (SELECT `id` FROM structure_value_domains WHERE `domain_name`='bcwh_maternal_consent_yesnona'), 'open', 'open', 'open', 0),
('ClinicalAnnotation', 'ConsentDetail', 'cd_bcwh_maternal_consents', 'bcwh_maternal_consent_umbilical_cord_blood', 'bcwh maternal consent umbilical cord blood', 'select', (SELECT `id` FROM structure_value_domains WHERE `domain_name`='bcwh_maternal_consent_yesnona'), 'open', 'open', 'open', 0),
('ClinicalAnnotation', 'ConsentDetail', 'cd_bcwh_maternal_consents', 'bcwh_maternal_consent_urine', 'bcwh maternal consent urine', 'select', (SELECT `id` FROM structure_value_domains WHERE `domain_name`='bcwh_maternal_consent_yesnona'), 'open', 'open', 'open', 0),
('ClinicalAnnotation', 'ConsentDetail', 'cd_bcwh_maternal_consents', 'bcwh_maternal_consent_stool', 'bcwh maternal consent stool', 'select', (SELECT `id` FROM structure_value_domains WHERE `domain_name`='bcwh_maternal_consent_yesnona'), 'open', 'open', 'open', 0),
('ClinicalAnnotation', 'ConsentDetail', 'cd_bcwh_maternal_consents', 'bcwh_maternal_consent_prev_materials', 'bcwh maternal consent other materials', 'select', (SELECT `id` FROM structure_value_domains WHERE `domain_name`='bcwh_maternal_consent_yesnona'), 'open', 'open', 'open', 0),
('ClinicalAnnotation', 'ConsentDetail', 'cd_bcwh_maternal_consents', 'bcwh_maternal_consent_other_materials', 'bcwh maternal consent previous materials', 'select', (SELECT `id` FROM structure_value_domains WHERE `domain_name`='bcwh_maternal_consent_yesnona'), 'open', 'open', 'open', 0);

INSERT INTO structure_formats
(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `flag_override_tag`, `flag_override_help`, `flag_override_type`, `flag_override_setting`, `flag_override_default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_summary`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_float`, `margin`)
VALUES
((SELECT `id` FROM structures WHERE `alias`='cd_bcwh_maternal_consents'), (SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_bcwh_maternal_consents' AND `field`='bcwh_maternal_consent_all_donation' AND `type`='select'), 1, 12, 'bcwh maternal consent details', 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='cd_bcwh_maternal_consents'), (SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_bcwh_maternal_consents' AND `field`='bcwh_maternal_consent_tissue' AND `type`='select'), 1, 13, '', 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='cd_bcwh_maternal_consents'), (SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_bcwh_maternal_consents' AND `field`='bcwh_maternal_consent_blood' AND `type`='select'), 1, 14, '', 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='cd_bcwh_maternal_consents'), (SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_bcwh_maternal_consents' AND `field`='bcwh_maternal_consent_extra_blood' AND `type`='select'), 1, 15, '', 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='cd_bcwh_maternal_consents'), (SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_bcwh_maternal_consents' AND `field`='bcwh_maternal_consent_genetic_material' AND `type`='select'), 1, 16, '', 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='cd_bcwh_maternal_consents'), (SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_bcwh_maternal_consents' AND `field`='bcwh_maternal_consent_swabs' AND `type`='select'), 1, 17, '', 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='cd_bcwh_maternal_consents'), (SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_bcwh_maternal_consents' AND `field`='bcwh_maternal_consent_placenta' AND `type`='select'), 1, 18, '', 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='cd_bcwh_maternal_consents'), (SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_bcwh_maternal_consents' AND `field`='bcwh_maternal_consent_umbilical_cord_blood' AND `type`='select'), 1, 19, '', 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='cd_bcwh_maternal_consents'), (SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_bcwh_maternal_consents' AND `field`='bcwh_maternal_consent_urine' AND `type`='select'), 1, 20, '', 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='cd_bcwh_maternal_consents'), (SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_bcwh_maternal_consents' AND `field`='bcwh_maternal_consent_stool' AND `type`='select'), 1, 21, '', 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='cd_bcwh_maternal_consents'), (SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_bcwh_maternal_consents' AND `field`='bcwh_maternal_consent_prev_materials' AND `type`='select'), 1, 24, '', 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='cd_bcwh_maternal_consents'), (SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_bcwh_maternal_consents' AND `field`='bcwh_maternal_consent_other_materials' AND `type`='select'), 1, 23, '', 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0);

-- BCWH Other Materials Description

INSERT INTO structure_fields
(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `flag_confidential`)
VALUES
('ClinicalAnnotation', 'ConsentDetail', 'cd_bcwh_maternal_consents', 'bcwh_maternal_other_materials_description', '', 'bcwh maternal other materials description', 'textarea', 'cols=20,rows=1', '', NULL, '', 'open', 'open', 'open', '0');

INSERT INTO structure_formats
(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_summary`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_float`, `margin`)
VALUES
((SELECT `id` FROM structures WHERE `alias`='cd_bcwh_maternal_consents'), (SELECT `id` FROM structure_fields WHERE plugin='ClinicalAnnotation' AND model='ConsentDetail' AND tablename='cd_bcwh_maternal_consents' AND field='bcwh_maternal_other_materials_description' AND type='textarea'), '1', '26', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');

-- Formal Consent Type

INSERT INTO structure_value_domains (`domain_name`) VALUES ('bcwh_maternal_formal_consent_type');

INSERT INTO structure_permissible_values (`value`, `language_alias`) VALUES 
('participant', 'bcwh maternal participant'),
('parental', 'bcwh maternal parental');

INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`, `use_as_input`) VALUES
((SELECT `id` FROM structure_value_domains WHERE `domain_name`='bcwh_maternal_formal_consent_type'),
 (SELECT `id` FROM structure_permissible_values WHERE `value`='participant' AND `language_alias`='bcwh maternal participant'), 
 1, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name`='bcwh_maternal_formal_consent_type'),
 (SELECT `id` FROM structure_permissible_values WHERE `value`='parental' AND `language_alias`='bcwh maternal parental'), 
 1, 1, 1);

INSERT INTO `structure_fields` (`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `flag_confidential`) VALUES ('ClinicalAnnotation', 'ConsentDetail', 'cd_bcwh_maternal_consents', 'bcwh_maternal_formal_consent_type', '', 'bcwh maternal formal consent', 'select', '', '', (SELECT `id` FROM structure_value_domains WHERE `domain_name`='bcwh_maternal_formal_consent_type'), '', 'open', 'open', 'open', '0');

INSERT INTO `structure_formats` (`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_summary`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_float`, `margin`) VALUES ((SELECT `id` FROM structures WHERE `alias`='cd_bcwh_maternal_consents'), (SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_bcwh_maternal_consents' AND `field`='bcwh_maternal_formal_consent_type' AND `type`='select' AND `structure_value_domain`=(SELECT `id` FROM structure_value_domains WHERE `domain_name`='bcwh_maternal_formal_consent_type')), '1', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');

-- Consent Withdrawal

INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`, `use_as_input`) VALUES
((SELECT `id` FROM structure_value_domains WHERE `domain_name`='bcwh_maternal_consent_yesnona'),
 (SELECT `id` FROM structure_permissible_values WHERE `value`='yes' AND `language_alias`='bcwh_maternal_yes'), 
 1, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name`='bcwh_maternal_consent_yesnona'),
 (SELECT `id` FROM structure_permissible_values WHERE `value`='no' AND `language_alias`='bcwh_maternal_no'), 
 2, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name`='bcwh_maternal_consent_yesnona'),
 (SELECT `id` FROM structure_permissible_values WHERE `value`='na' AND `language_alias`='bcwh_maternal_na'), 
 3, 1, 1);

INSERT INTO `structure_fields` (`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `flag_confidential`) VALUES 
('ClinicalAnnotation', 'ConsentDetail', 'cd_bcwh_maternal_consents', 'bcwh_maternal_date_withdrawal_revoke', 'bcwh maternal date withdrawal revoke', '', 'date', '', '', NULL, '', 'open', 'open', 'open', '0'),
('ClinicalAnnotation', 'ConsentDetail', 'cd_bcwh_maternal_consents', 'bcwh_maternal_consent_revoke', 'bcwh maternal consent revoke', '', 'select', '', '', (SELECT `id` FROM structure_value_domains WHERE `domain_name`='bcwh_maternal_consent_yesnona'), '', 'open', 'open', 'open', '0'),
('ClinicalAnnotation', 'ConsentDetail', 'cd_bcwh_maternal_consents', 'bcwh_maternal_consent_withdrawal', 'bcwh maternal consent withdrawal', '', 'select', '', '', (SELECT `id` FROM structure_value_domains WHERE `domain_name`='bcwh_maternal_consent_yesnona'), '', 'open', 'open', 'open', '0');

INSERT INTO `structure_formats` (`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_summary`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_float`, `margin`) VALUES 
((SELECT `id` FROM structures WHERE `alias`='cd_bcwh_maternal_consents'), (SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_bcwh_maternal_consents' AND `field`='bcwh_maternal_date_withdrawal_revoke' AND `type`='date'), 2, 1, 'bcwh maternal withdrawal', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '',
 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='cd_bcwh_maternal_consents'), (SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_bcwh_maternal_consents' AND `field`='bcwh_maternal_consent_revoke' AND `type`='select' AND `structure_value_domain`=(SELECT `id` FROM structure_value_domains WHERE `domain_name`='bcwh_maternal_consent_yesnona')), 2, 2, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '',
 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='cd_bcwh_maternal_consents'), (SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_bcwh_maternal_consents' AND `field`='bcwh_maternal_consent_withdrawal' AND `type`='select' AND `structure_value_domain`=(SELECT `id` FROM structure_value_domains WHERE `domain_name`='bcwh_maternal_consent_yesnona')), 2, 3, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '',
 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0);

-- Person Consenting (Verbal and Formal)

INSERT INTO structure_fields (`id`, `public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `flag_confidential`)
VALUES (NULL, '', 'ClinicalAnnotation', 'ConsentDetail', 'cd_bcwh_maternal_consents', 'bcwh_maternal_person_verbal_consent', 'bcwh maternal person verbal consent', '', 'select', '', '', (SELECT id FROM `structure_value_domains` WHERE `domain_name`='custom_person_consenting'), '', 'open', 'open', 'open', '0');
INSERT INTO structure_fields (`id`, `public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `flag_confidential`)
VALUES (NULL, '', 'ClinicalAnnotation', 'ConsentDetail', 'cd_bcwh_maternal_consents', 'bcwh_maternal_person_formal_consent', 'bcwh maternal person formal consent', '', 'select', '', '', (SELECT id FROM `structure_value_domains` WHERE `domain_name`='custom_person_consenting'), '', 'open', 'open', 'open', '0');

INSERT INTO structure_formats (`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_summary`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_float`, `margin`)
VALUES ((SELECT id FROM structures WHERE alias='cd_bcwh_maternal_consents'), (SELECT id FROM structure_fields WHERE plugin='ClinicalAnnotation' AND model='ConsentDetail' AND tablename='cd_bcwh_maternal_consents' AND field='bcwh_maternal_person_verbal_consent' AND type='select' AND structure_value_domain=(SELECT id FROM `structure_value_domains` WHERE `domain_name`='custom_person_consenting')), '1', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='cd_bcwh_maternal_consents'), (SELECT id FROM structure_fields WHERE plugin='ClinicalAnnotation' AND model='ConsentDetail' AND tablename='cd_bcwh_maternal_consents' AND field='bcwh_maternal_person_formal_consent' AND type='select' AND structure_value_domain=(SELECT id FROM `structure_value_domains` WHERE `domain_name`='custom_person_consenting')), '1', '7', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');

-- Linking translator used field in the master form to BCCH form

INSERT INTO structure_formats (`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_summary`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_float`, `margin`)
VALUES ((SELECT id FROM structures WHERE alias='cd_bcwh_maternal_consents'), (SELECT id FROM structure_fields WHERE plugin='ClinicalAnnotation' AND model='ConsentMaster' AND tablename='consent_masters' AND field='translator_indicator' AND type='yes_no'), '1', '9', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', 'n', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='cd_bcwh_maternal_consents'), (SELECT id FROM structure_fields WHERE plugin='ClinicalAnnotation' AND model='ConsentMaster' AND tablename='consent_masters' AND field='translator_signature' AND type='yes_no'), '1', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');

-- Adolescent capacity to consent

INSERT INTO structure_fields (`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `flag_confidential`)
VALUES ('ClinicalAnnotation', 'ConsentDetail', 'cd_bcwh_maternal_consents', 'bcwh_maternal_assent_adolescent_capacity', 'bcwh maternal assent adolescent capacity', '', 'yes_no', '', '', NULL, '', 'open', 'open', 'open', '0');

INSERT INTO structure_formats (`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_summary`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_float`, `margin`)
VALUES ((SELECT id FROM structures WHERE alias='cd_bcwh_maternal_consents'), (SELECT id FROM structure_fields WHERE plugin='ClinicalAnnotation' AND model='ConsentDetail' AND tablename='cd_bcwh_maternal_consents' AND field='bcwh_maternal_assent_adolescent_capacity' AND type='yes_no'), '1', '11', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');

-- Translation Files

REPLACE INTO i18n (`id`, `en`) VALUES
('BCWH Maternal Consent', 'BCWH Maternal Consent Form'),
('bcwh maternal verbal consent', 'Verbal Consent'),
('bcwh maternal date verbal consent', 'Date of Verbal Consent'),
('bcwh_maternal_consented', 'Consented'),
('bcwh_maternal_declined', 'Declined'),
('bcwh_maternal_withdrawn', 'Withdrawn'),
('bcwh maternal date formal consent', 'Date of Formal Consent'),
('bcwh maternal consent details', 'Consent Details'),
('bcwh maternal consent all donation', 'Consent to Donation of All Sample Types'),
('bcwh maternal consent tissue', 'Consent to Tissue Donation'),
('bcwh maternal consent blood', 'Consent to Donation of Blood'),
('bcwh maternal consent extra blood', 'Consent to Collection of an Additional Blood Draw'),
('bcwh maternal consent genetic material', 'Use of Left over Genetic Materials'),
('bcwh maternal consent swabs', 'Use of Swabs'),
('bcwh maternal consent placenta', 'Consent to Donation of Placenta'),
('bcwh maternal consent umbilical cord blood', 'Consent to Donation of Umbilical Cord Blood'),
('bcwh maternal consent urine', 'Use of Urine'),
('bcwh maternal consent stool', 'Use of Stool'),
('bcwh maternal consent other materials', 'Consent to Other Materials'),
('bcwh maternal consent previous materials', 'Use of Samples Previously Collected'),
('bcwh maternal other materials description', 'Other Materials:'),
('bcwh_maternal_yes', 'Yes'),
('bcwh_maternal_no', 'No'),
('bcwh_maternal_na', 'N/A'),
('bcwh maternal parental', 'Parental'),
('bcwh maternal participant', 'Participant'),
('bcwh maternal formal consent', 'Formal Consent'),
('bcwh maternal withdrawal', 'Withdrawal'),
('bcwh maternal date withdrawal revoke', 'Date of Withdrawal/Revoke'),
('bcwh maternal consent revoke', 'Revoke of Consent'),
('bcwh maternal consent withdrawal', 'Withdrawal of Consent'),
('bcwh maternal person verbal consent', 'Person Consenting (Verbal)'),
('bcwh maternal person formal consent', 'Person Consenting (Formal)'),
('bcwh maternal assent adolescent capacity', 'Adolescent Capacity to Consent');

--  =========================================================================
--	Eventum ID: #3213 - Study/Project Module Update
--  BB-41
--	=========================================================================

-- Add Biobank Services Provider for Study Summary

ALTER TABLE study_summaries
	ADD `service_consent` VARCHAR(50) DEFAULT NULL AFTER `additional_clinical`,
	ADD `service_collection` VARCHAR(50) DEFAULT NULL AFTER `service_consent`,
	ADD `service_processing` VARCHAR(50) DEFAULT NULL AFTER `service_collection`,
	ADD `service_simple_data_collection` VARCHAR(50) DEFAULT NULL AFTER `service_processing`,
	ADD `service_clinical_data_collection` VARCHAR(50) DEFAULT NULL AFTER `service_simple_data_collection`,
	ADD `service_storage` VARCHAR(50) DEFAULT NULL AFTER `service_clinical_data_collection`;

ALTER TABLE study_summaries_revs
	ADD `service_consent` VARCHAR(50) DEFAULT NULL AFTER `additional_clinical`,
	ADD `service_collection` VARCHAR(50) DEFAULT NULL AFTER `service_consent`,
	ADD `service_processing` VARCHAR(50) DEFAULT NULL AFTER `service_collection`,
	ADD `service_simple_data_collection` VARCHAR(50) DEFAULT NULL AFTER `service_processing`,
	ADD `service_clinical_data_collection` VARCHAR(50) DEFAULT NULL AFTER `service_simple_data_collection`,
	ADD `service_storage` VARCHAR(50) DEFAULT NULL AFTER `service_clinical_data_collection`;

INSERT INTO structure_fields
(`plugin`, `model`, `tablename`, `field`, `language_label`, `type`, `validation_control`, `value_domain_control`, `field_control`, `flag_confidential`) VALUES
('Study', 'StudySummary', 'study_summaries', 'service_consent', 'service_consent', 'yes_no', 'open', 'open', 'open', 0),
('Study', 'StudySummary', 'study_summaries', 'service_collection', 'service_collection', 'yes_no', 'open', 'open', 'open', 0),
('Study', 'StudySummary', 'study_summaries', 'service_processing', 'service_processing', 'yes_no', 'open', 'open', 'open', 0),
('Study', 'StudySummary', 'study_summaries', 'service_simple_data_collection', 'service_simple_data_collection', 'yes_no', 'open', 'open', 'open', 0),
('Study', 'StudySummary', 'study_summaries', 'service_clinical_data_collection', 'service_clinical_data_collection', 'yes_no', 'open', 'open', 'open', 0),
('Study', 'StudySummary', 'study_summaries', 'service_storage', 'service_storage', 'yes_no', 'open', 'open', 'open', 0);

INSERT INTO structure_formats
(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `flag_override_tag`, `flag_override_help`, `flag_override_type`, `flag_override_setting`, `flag_override_default`,
 `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, 
 `flag_addgrid`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_summary`, `flag_batchedit`, `flag_batchedit_readonly`,
 `flag_index`, `flag_detail`, `flag_float`, `margin`) VALUES
((SELECT `id` FROM structures WHERE `alias`='studysummaries'), (SELECT `id` FROM structure_fields WHERE `plugin`='Study' AND `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='service_consent' AND `language_label`='service_consent' AND `type`='yes_no'), 1, 12, 'biobank services provided', 0,
 0, 0, 0, 0, 0,
 1, 0, 1, 0, 0, 0,
 0, 0, 0, 1, 0, 0,
 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='studysummaries'), (SELECT `id` FROM structure_fields WHERE `plugin`='Study' AND `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='service_collection' AND `language_label`='service_collection' AND `type`='yes_no'), 1, 13, '', 0,
 0, 0, 0, 0, 0,
 1, 0, 1, 0, 0, 0,
 0, 0, 0, 1, 0, 0,
 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='studysummaries'), (SELECT `id` FROM structure_fields WHERE `plugin`='Study' AND `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='service_processing' AND `language_label`='service_processing' AND `type`='yes_no'), 1, 14, '', 0,
 0, 0, 0, 0, 0,
 1, 0, 1, 0, 0, 0,
 0, 0, 0, 1, 0, 0,
 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='studysummaries'), (SELECT `id` FROM structure_fields WHERE `plugin`='Study' AND `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='service_simple_data_collection' AND `language_label`='service_simple_data_collection' AND `type`='yes_no'), 1, 15, '', 0,
 0, 0, 0, 0, 0,
 1, 0, 1, 0, 0, 0,
 0, 0, 0, 1, 0, 0,
 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='studysummaries'), (SELECT `id` FROM structure_fields WHERE `plugin`='Study' AND `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='service_clinical_data_collection' AND `language_label`='service_clinical_data_collection' AND `type`='yes_no'), 1, 16, '', 0,
 0, 0, 0, 0, 0,
 1, 0, 1, 0, 0, 0,
 0, 0, 0, 1, 0, 0,
 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='studysummaries'), (SELECT `id` FROM structure_fields WHERE `plugin`='Study' AND `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='service_storage' AND `language_label`='service_storage' AND `type`='yes_no'), 1, 17, '', 0,
 0, 0, 0, 0, 0,
 1, 0, 1, 0, 0, 0,
 0, 0, 0, 1, 0, 0,
 1, 1, 0, 0);

REPLACE INTO i18n (`id`, `en`) VALUES
('biobank services provided', 'Biobank Services Provided'),
('service_consent', 'Consent'),
('service_collection', 'Coordination of Collection'),
('service_processing', 'Processing'),
('service_simple_data_collection', 'Simple Data Collection'),
('service_clinical_data_collection', 'Clinical Data Collection'),
('service_storage', 'Storage');



-- Enable "Type of Study" and add values to the drop down menu in Study Summary

UPDATE structure_formats
SET `flag_add` = 1, `flag_edit` = 1, `flag_search` = 1, `flag_summary` = 1, `flag_index` = 1, `flag_detail` = 1
WHERE `structure_id` = (SELECT `id` FROM structures WHERE `alias`='studysummaries')
AND `structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin`='Study' AND `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='study_type' AND `language_label`='study_type' AND `type`='select' AND `structure_value_domain`=(SELECT `id` FROM structure_value_domains WHERE `domain_name`='study_type')); 

UPDATE structure_value_domains_permissible_values
SET flag_active = 0
WHERE `structure_value_domain_id` = (SELECT `id` FROM structure_value_domains WHERE `domain_name`='study_type') 
AND (`structure_permissible_value_id` = (SELECT `id` FROM structure_permissible_values WHERE `value`='retrospective' AND `language_alias`='retrospective') OR `structure_permissible_value_id` = (SELECT `id` FROM structure_permissible_values WHERE `value`='prospective' AND `language_alias`='prospective'));

INSERT INTO structure_permissible_values
(`value`, `language_alias`) VALUES
('clinical trial', 'clinical trial'),
('academic research', 'academic research'),
('biobank', 'biobank');

INSERT INTO structure_value_domains_permissible_values
(`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`, `use_as_input`) VALUES
((SELECT `id` FROM structure_value_domains WHERE `domain_name`='study_type'), 
 (SELECT `id` FROM structure_permissible_values WHERE `value`='clinical trial' AND `language_alias`='clinical trial'), 1, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name`='study_type'), 
 (SELECT `id` FROM structure_permissible_values WHERE `value`='academic research' AND `language_alias`='academic research'), 2, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name`='study_type'), 
 (SELECT `id` FROM structure_permissible_values WHERE `value`='biobank' AND `language_alias`='biobank'), 3, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name`='study_type'), 
 (SELECT `id` FROM structure_permissible_values WHERE `value`='other' AND `language_alias`='other'), 4, 1, 1);

ALTER TABLE study_summaries
	ADD `study_type_other_desc` VARCHAR(255) AFTER `study_type`;

ALTER TABLE study_summaries_revs
	ADD `study_type_other_desc` VARCHAR(255) AFTER `study_type`;

INSERT INTO structure_fields 
(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `validation_control`, `value_domain_control`, `field_control`, `flag_confidential`) VALUES
('Study', 'StudySummary', 'study_summaries', 'study_type_other_desc', '', 'study_type_other_desc', 'textarea', 'cols=20,rows=1', 'open', 'open', 'open', 0);

INSERT INTO structure_formats
(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `flag_override_label`, `flag_override_tag`, `flag_override_help`, `flag_override_type`, `flag_override_setting`, `flag_override_default`,
 `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, 
 `flag_addgrid`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_summary`, `flag_batchedit`, `flag_batchedit_readonly`,
 `flag_index`, `flag_detail`, `flag_float`, `margin`) VALUES
((SELECT `id` FROM structures WHERE `alias`='studysummaries'), (SELECT `id` FROM structure_fields WHERE `plugin`='Study' AND `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='study_type_other_desc'), 1, 3, 0, 0,
 0, 0, 0, 0,
 1, 0, 1, 0, 1, 0,
 0, 0, 0, 1, 0, 1, 
 1, 1, 0, 0);

REPLACE INTO i18n (`id`, `en`) VALUES
('clinical trial', 'Clinical Trial'),
('academic research', 'Academic Research'),
('biobank', 'Biobank'),
('study_type_other_desc', 'If other');

-- Terms of Payment for Study Summary

ALTER TABLE study_summaries
	ADD `payment_term` VARCHAR(45) DEFAULT NULL AFTER `additional_clinical`,
	ADD `payment_term_other_desc` text DEFAULT NULL AFTER `payment_term`;

ALTER TABLE study_summaries_revs
	ADD `payment_term` VARCHAR(45) DEFAULT NULL AFTER `additional_clinical`,
	ADD `payment_term_other_desc` text DEFAULT NULL AFTER `payment_term`;


INSERT INTO structure_value_domains (`domain_name`, `override`) VALUES
('study_payment_term', 'open');

INSERT INTO structure_permissible_values (`value`, `language_alias`) VALUES
('monthly', 'payment_monthly'),
('quarterly', 'payment_quarterly'),
('semi-annually', 'payment_semi_annually'),
('annually', 'payment_annually'),
('other', 'payment_other');

INSERT INTO structure_value_domains_permissible_values 
(`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`, `use_as_input`) VALUES
((SELECT `id` FROM structure_value_domains WHERE `domain_name`='study_payment_term'), (SELECT `id` FROM structure_permissible_values WHERE `value`='monthly' AND `language_alias`='payment_monthly'), 1, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name`='study_payment_term'), (SELECT `id` FROM structure_permissible_values WHERE `value`='quarterly' AND `language_alias`='payment_quarterly'), 2, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name`='study_payment_term'), (SELECT `id` FROM structure_permissible_values WHERE `value`='semi-annually' AND `language_alias`='payment_semi_annually'), 3, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name`='study_payment_term'), (SELECT `id` FROM structure_permissible_values WHERE `value`='annually' AND `language_alias`='payment_annually'), 4, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name`='study_payment_term'), (SELECT `id` FROM structure_permissible_values WHERE `value`='other' AND `language_alias`='payment_other'), 5, 1, 1);

INSERT INTO structure_fields
(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `structure_value_domain`, `validation_control`, `value_domain_control`, `field_control`, `flag_confidential`) VALUES
('Study', 'StudySummary', 'study_summaries', 'payment_term', 'payment_term', '', 'select', '', (SELECT `id` FROM structure_value_domains WHERE `domain_name`='study_payment_term'), 'open', 'open', 'open', 0);

INSERT INTO structure_formats
(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `flag_override_label`, `flag_override_tag`, `flag_override_help`, `flag_override_type`, `flag_override_setting`, `flag_override_default`,
 `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, 
 `flag_addgrid`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_summary`, `flag_batchedit`, `flag_batchedit_readonly`,
 `flag_index`, `flag_detail`, `flag_float`, `margin`) VALUES
((SELECT `id` FROM structures WHERE `alias`='studysummaries'), (SELECT `id` FROM structure_fields WHERE `plugin`='Study' AND `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='payment_term' AND `type`='select'), 1, 8, 0, 0,
 0, 0, 0, 0,
 1, 0, 1, 0, 1, 0, 
 0, 0, 0, 1, 0, 0,
 1, 1, 0, 0);

INSERT INTO structure_fields
(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `structure_value_domain`, `validation_control`, `value_domain_control`, `field_control`, `flag_confidential`) VALUES
('Study', 'StudySummary', 'study_summaries', 'payment_term_other_desc', '', 'payment_term_other_desc', 'textarea', 'cols=20,rows=1', NULL, 'open', 'open', 'open', 0);

INSERT INTO structure_formats
(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `flag_override_label`, `flag_override_tag`, `flag_override_help`, `flag_override_type`, `flag_override_setting`, `flag_override_default`,
 `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, 
 `flag_addgrid`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_summary`, `flag_batchedit`, `flag_batchedit_readonly`,
 `flag_index`, `flag_detail`, `flag_float`, `margin`) VALUES
((SELECT `id` FROM structures WHERE `alias`='studysummaries'), (SELECT `id` FROM structure_fields WHERE `plugin`='Study' AND `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='payment_term_other_desc' AND `type`='textarea'), 1, 9, 0, 0,
 0, 0, 0, 0,
 1, 0, 1, 0, 1, 0, 
 0, 0, 0, 1, 0, 0,
 1, 1, 0, 0);

REPLACE INTO i18n (`id`, `en`) VALUES
('payment_term', 'Terms of Payment'),
('payment_term_other_desc', 'If Other'),
('payment_monthly', 'Monthly'),
('payment_quarterly', 'Quarterly'),
('payment_semi_annually', 'Semi-annually'),
('payment_annually', 'Annually'),
('payment_other', 'Other');

-- Requisition with Study for Study Summary

ALTER TABLE study_summaries
	ADD `requisition` VARCHAR(255) DEFAULT NULL AFTER `payment_term_other_desc`;

INSERT INTO structure_fields
(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `structure_value_domain`, `validation_control`, `value_domain_control`, `field_control`, `flag_confidential`) VALUES
('Study', 'StudySummary', 'study_summaries', 'requisition', 'requisition', '', 'textarea', 'cols=20,rows=1', NULL, 'open', 'open', 'open', 0);

INSERT INTO structure_formats
(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `flag_override_label`, `flag_override_tag`, `flag_override_help`, `flag_override_type`, `flag_override_setting`, `flag_override_default`,
 `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, 
 `flag_addgrid`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_summary`, `flag_batchedit`, `flag_batchedit_readonly`,
 `flag_index`, `flag_detail`, `flag_float`, `margin`) VALUES
((SELECT `id` FROM structures WHERE `alias`='studysummaries'), (SELECT `id` FROM structure_fields WHERE `plugin`='Study' AND `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='requisition' AND `type`='textarea'), 1, 10, 0, 0,
 0, 0, 0, 0,
 1, 0, 1, 0, 1, 0, 
 0, 0, 0, 1, 0, 0,
 1, 1, 0, 0);

REPLACE INTO i18n (`id`, `en`) VALUES
('requisition', 'Requisition associated with this study:');

-- RedCap Project ID for Study Summary

ALTER TABLE study_summaries
	ADD `redcap_project_id` VARCHAR(255) DEFAULT NULL AFTER `requisition`;

INSERT INTO structure_fields
(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `structure_value_domain`, `validation_control`, `value_domain_control`, `field_control`, `flag_confidential`) VALUES
('Study', 'StudySummary', 'study_summaries', 'redcap_project_id', 'redcap_project_id', '', 'textarea', 'cols=20,rows=1', NULL, 'open', 'open', 'open', 0);

INSERT INTO structure_formats
(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `flag_override_label`, `flag_override_tag`, `flag_override_help`, `flag_override_type`, `flag_override_setting`, `flag_override_default`,
 `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, 
 `flag_addgrid`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_summary`, `flag_batchedit`, `flag_batchedit_readonly`,
 `flag_index`, `flag_detail`, `flag_float`, `margin`) VALUES
((SELECT `id` FROM structures WHERE `alias`='studysummaries'), (SELECT `id` FROM structure_fields WHERE `plugin`='Study' AND `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='redcap_project_id' AND `type`='textarea'), 1, 11, 0, 0,
 0, 0, 0, 0,
 1, 0, 1, 0, 1, 0, 
 0, 0, 0, 1, 0, 0,
 1, 1, 0, 0);

REPLACE INTO i18n (`id`, `en`) VALUES
('redcap_project_id', 'RedCap Project ID associated with this study:');

-- Enable StudyContact, StudyInvestigator, StudyEhtics

UPDATE menus
SET flag_active=1 
WHERE `parent_id`='tool_CAN_100' 
AND `language_title`='tool_contact' AND `language_description`='tool_contact' 
AND `use_link`='/Study/StudyContacts/listall/%%StudySummary.id%%/' 
AND `use_summary`='Study.StudySummary::summary';

UPDATE menus
SET flag_active=1 
WHERE `parent_id`='tool_CAN_100' 
AND `language_title`='tool_investigator' AND `language_description`='tool_investigator' 
AND `use_link`='/Study/StudyInvestigators/listall/%%StudySummary.id%%/' 
AND `use_summary`='Study.StudySummary::summary';

UPDATE menus
SET flag_active=1 
WHERE `parent_id`='tool_CAN_100' 
AND `language_title`='tool_ethics' AND `language_description`='tool_ethics' 
AND `use_link`='/Study/StudyEthicsBoards/listall/%%StudySummary.id%%/' 
AND `use_summary`='Study.StudySummary::summary';

-- StudyInvestigators Update

ALTER TABLE study_investigators
	ADD `affil_cfri` VARCHAR(50) DEFAULT NULL AFTER `organization`;

ALTER TABLE study_investigators_revs
	ADD `affil_cfri` VARCHAR(50) DEFAULT NULL AFTER `organization`;

INSERT INTO structure_fields
(`plugin`, `model`, `tablename`, `field`, `language_label`, `type`, `validation_control`, `value_domain_control`, `field_control`, `flag_confidential`) VALUES
('Study', 'StudyInvestigator', 'study_investigators', 'affil_cfri', 'cfri affiliation', 'yes_no', 'open', 'open', 'open', 0);

INSERT INTO structure_formats
(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `flag_override_tag`, `flag_override_help`, `flag_override_type`, `flag_override_setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, 
 `flag_addgrid`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_summary`, `flag_batchedit`, `flag_batchedit_readonly`,
 `flag_index`, `flag_detail`, `flag_float`, `margin`) VALUES
((SELECT `id` FROM structures WHERE `alias`='studyinvestigators'), (SELECT `id` FROM structure_fields WHERE `plugin`='Study' AND `model`='StudyInvestigator' AND `tablename`='study_investigators' AND `field`='affil_cfri' AND `language_label`='cfri affiliation' AND `type`='yes_no'), 2, 0, 'pi research affiliations', 0,
 0, 0, 0, 0, 1,
 'n', 1, 0, 1, 0, 1, 0, 
 0, 0, 0, 1, 0, 0,
 1, 1, 0, 0);

ALTER TABLE study_investigators
	ADD `affil_whri` VARCHAR(50) DEFAULT NULL AFTER `affil_cfri`,
	ADD `affil_bcmhri` VARCHAR(50) DEFAULT NULL AFTER `affil_whri`,
	ADD `affil_vchri` VARCHAR(50) DEFAULT NULL AFTER `affil_bcmhri`,
	ADD `affil_bcca` VARCHAR(50) DEFAULT NULL AFTER `affil_vchri`,
	ADD `affil_other` TEXT DEFAULT NULL AFTER `affil_bcca`;

ALTER TABLE study_investigators_revs
	ADD `affil_whri` VARCHAR(50) DEFAULT NULL AFTER `affil_cfri`,
	ADD `affil_bcmhri` VARCHAR(50) DEFAULT NULL AFTER `affil_whri`,
	ADD `affil_vchri` VARCHAR(50) DEFAULT NULL AFTER `affil_bcmhri`,
	ADD `affil_bcca` VARCHAR(50) DEFAULT NULL AFTER `affil_vchri`,
	ADD `affil_other` TEXT DEFAULT NULL AFTER `affil_bcca`;


INSERT INTO structure_fields
(`plugin`, `model`, `tablename`, `field`, `language_label`, `type`, `setting`, `validation_control`, `value_domain_control`, `field_control`, `flag_confidential`) VALUES
('Study', 'StudyInvestigator', 'study_investigators', 'affil_whri', 'whri affiliation', 'yes_no', '', 'open', 'open', 'open', 0),
('Study', 'StudyInvestigator', 'study_investigators', 'affil_bcmhri', 'bcmhri affiliation', 'yes_no', '', 'open', 'open', 'open', 0),
('Study', 'StudyInvestigator', 'study_investigators', 'affil_vchri', 'vchri affiliation', 'yes_no', '', 'open', 'open', 'open', 0),
('Study', 'StudyInvestigator', 'study_investigators', 'affil_bcca', 'bcca affiliation', 'yes_no', '', 'open', 'open', 'open', 0),
('Study', 'StudyInvestigator', 'study_investigators', 'affil_other', 'other affiliation', 'textarea', 'cols=20,rows=1', 'open', 'open', 'open', 0);

INSERT INTO structure_formats
(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `flag_override_tag`, `flag_override_help`, `flag_override_type`, `flag_override_setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, 
 `flag_addgrid`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_summary`, `flag_batchedit`, `flag_batchedit_readonly`,
 `flag_index`, `flag_detail`, `flag_float`, `margin`) VALUES
((SELECT `id` FROM structures WHERE `alias`='studyinvestigators'), (SELECT `id` FROM structure_fields WHERE `plugin`='Study' AND `model`='StudyInvestigator' AND `tablename`='study_investigators' AND `field`='affil_whri' AND `language_label`='whri affiliation' AND `type`='yes_no'), 2, 1, '', 0,
 0, 0, 0, 0, 1,
 'n', 1, 0, 1, 0, 1, 0, 
 0, 0, 0, 1, 0, 0,
 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='studyinvestigators'), (SELECT `id` FROM structure_fields WHERE `plugin`='Study' AND `model`='StudyInvestigator' AND `tablename`='study_investigators' AND `field`='affil_bcmhri' AND `language_label`='bcmhri affiliation' AND `type`='yes_no'), 2, 2, '', 0,
 0, 0, 0, 0, 1,
 'n', 1, 0, 1, 0, 1, 0, 
 0, 0, 0, 1, 0, 0,
 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='studyinvestigators'), (SELECT `id` FROM structure_fields WHERE `plugin`='Study' AND `model`='StudyInvestigator' AND `tablename`='study_investigators' AND `field`='affil_vchri' AND `language_label`='vchri affiliation' AND `type`='yes_no'), 2, 3, '', 0,
 0, 0, 0, 0, 1,
 'n', 1, 0, 1, 0, 1, 0, 
 0, 0, 0, 1, 0, 0,
 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='studyinvestigators'), (SELECT `id` FROM structure_fields WHERE `plugin`='Study' AND `model`='StudyInvestigator' AND `tablename`='study_investigators' AND `field`='affil_bcca' AND `language_label`='bcca affiliation' AND `type`='yes_no'), 2, 4, '', 0,
 0, 0, 0, 0, 1,
 'n', 1, 0, 1, 0, 1, 0, 
 0, 0, 0, 1, 0, 0,
 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='studyinvestigators'), (SELECT `id` FROM structure_fields WHERE `plugin`='Study' AND `model`='StudyInvestigator' AND `tablename`='study_investigators' AND `field`='affil_other' AND `language_label`='other affiliation' AND `type`='textarea'), 2, 5, '', 0,
 0, 0, 0, 0, 0,
 '', 1, 0, 1, 0, 1, 0, 
 0, 0, 0, 1, 0, 0,
 1, 1, 0, 0);

REPLACE INTO i18n (`id`, `en`) VALUES
('pi research affiliations', 'Investigator Research Affiliations'),
('cfri affiliation', 'CFRI'),
('whri affiliation', 'WHRI'),
('bcmhri affiliation', 'BCMHRI'),
('vchri affiliation', 'VCHRI'),
('bcca affiliation', 'BCCA'),
('other affiliation', 'Other Affiliations:');


-- Enable StudyEthics

INSERT INTO structure_permissible_values (`value`, `language_alias`) VALUES
('Not Required - Administrative', 'not_required_admin'),
('Not Required - Quality Assurance', 'not_required_qa'),
('Not Required - Quality Improvement', 'not_required_qi');

INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`, `use_as_input`) VALUES
((SELECT `id` FROM structure_value_domains WHERE `domain_name`='processing_status'), (SELECT `id` FROM structure_permissible_values WHERE `value`='Not Required - Administrative' AND `language_alias`='not_required_admin'), 4, 1, 1),
 ((SELECT `id` FROM structure_value_domains WHERE `domain_name`='processing_status'), (SELECT `id` FROM structure_permissible_values WHERE `value`='Not Required - Quality Assurance' AND `language_alias`='not_required_qa'), 5, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name`='processing_status'), (SELECT `id` FROM structure_permissible_values WHERE `value`='Not Required - Quality Improvement' AND `language_alias`='not_required_qi'), 6, 1, 1);
 
ALTER TABLE study_ethics_boards
 	ADD `reb_irb_number` VARCHAR(255) DEFAULT NULL AFTER `ohrp_fwa_number`,
 	ADD `bcchb_app_number` VARCHAR(255) DEFAULT NULL AFTER `reb_irb_number`,
 	ADD `phsa_certified` VARCHAR(45) DEFAULT NULL AFTER `bcchb_app_number`;

ALTER TABLE study_ethics_boards_revs
 	ADD `reb_irb_number` VARCHAR(255) DEFAULT NULL AFTER `ohrp_fwa_number`,
 	ADD `bcchb_app_number` VARCHAR(255) DEFAULT NULL AFTER `reb_irb_number`,
  	ADD `phsa_certified` VARCHAR(45) DEFAULT NULL AFTER `bcchb_app_number`;
 
INSERT INTO structure_fields
(`plugin`, `model`, `tablename`, `field`, `language_label`, `type`, `setting`, `structure_value_domain`, `validation_control`, `value_domain_control`, `field_control`, `flag_confidential`) VALUES
('Study', 'StudyEthicsBoard', 'study_ethics_boards', 'reb_irb_number', 'reb_irb_number', 'input', 'size=44', NULL, 'open', 'open', 'open', 0),
('Study', 'StudyEthicsBoard', 'study_ethics_boards', 'bcchb_app_number', 'bcchb_app_number', 'input', 'size=44', NULL, 'open', 'open', 'open', 0),
 ('Study', 'StudyEthicsBoard', 'study_ethics_boards', 'phsa_certified', 'phsa_certified', 'yes_no', '', NULL, 'open', 'open', 'open', 0);

INSERT INTO structure_formats
(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `flag_override_tag`, `flag_override_help`, `flag_override_type`, `flag_override_setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, 
 `flag_addgrid`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_summary`, `flag_batchedit`, `flag_batchedit_readonly`,
 `flag_index`, `flag_detail`, `flag_float`, `margin`) VALUES
((SELECT `id` FROM structures WHERE `alias`='studyethicsboards'), (SELECT `id` FROM structure_fields WHERE `plugin`='Study' AND `model`='StudyEthicsBoard' AND `tablename`='study_ethics_boards' AND `field`='reb_irb_number' AND `language_label`='reb_irb_number' AND `type`='input'), 1, 3, '', 0,
 0, 0, 0, 0, 0,
 '', 1, 0, 1, 0, 1, 0, 
 0, 0, 0, 1, 0, 0, 
 1, 1, 0, 0),
 ((SELECT `id` FROM structures WHERE `alias`='studyethicsboards'), (SELECT `id` FROM structure_fields WHERE `plugin`='Study' AND `model`='StudyEthicsBoard' AND `tablename`='study_ethics_boards' AND `field`='bcchb_app_number' AND `language_label`='bcchb_app_number' AND `type`='input'), 1, 4, '', 0,
 0, 0, 0, 0, 0,
 '', 1, 0, 1, 0, 1, 0, 
 0, 0, 0, 1, 0, 0, 
 1, 1, 0, 0),
 ((SELECT `id` FROM structures WHERE `alias`='studyethicsboards'), (SELECT `id` FROM structure_fields WHERE `plugin`='Study' AND `model`='StudyEthicsBoard' AND `tablename`='study_ethics_boards' AND `field`='phsa_certified' AND `language_label`='phsa_certified' AND `type`='yes_no'), 1, 5, '', 0,
 0, 0, 0, 0, 1,
 'n', 1, 0, 1, 0, 1, 0, 
 0, 0, 0, 1, 0, 0, 
 1, 1, 0, 0);
 
REPLACE INTO i18n (`id`, `en`) VALUES
('reb_irb_number', 'REB/IRB Number:'),
('bcchb_app_number', 'BCCHB Application Number:'),
('phsa_certified', 'PHSA Privacy and Confidentiality Certification Completion');

REPLACE INTO i18n (`id`, `en`) VALUES
('not_required_admin', 'Not Required - Administrative'),
('not_required_qa', 'Not Required - Quality Assurance'),
('not_required_qi', 'Not Required - Quality Improvement');

-- Need to check this, position not working quite correctly
UPDATE structure_formats 
SET display_order = display_order + 3
WHERE `structure_id` = (SELECT `id` FROM structures WHERE `alias`='studyethicsboards') 
AND 
(`structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin`='Study' AND `model`='StudyEthicsBoard' AND `tablename`='study_ethics_boards' AND `field`='date') OR `structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin`='Study' AND `model`='StudyEthicsBoard' AND `tablename`='study_ethics_boards' AND `field`='status'));

-- Disable File Location
UPDATE structure_formats
SET `flag_add` = 0, `flag_edit`=0, `flag_detail`=0
WHERE `structure_id`=(SELECT `id` FROM structures WHERE `alias`='studyethicsboards')
AND `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `plugin`='Study' AND `model`='StudyEthicsBoard' AND `tablename`='study_ethics_boards' AND `field`='path_to_file' AND `type`='input');

-- Disable Contact

UPDATE structure_formats
SET `flag_add` = 0, `flag_edit`=0, `flag_detail`=0
WHERE `structure_id`=(SELECT `id` FROM structures WHERE `alias`='studyethicsboards')
AND `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `plugin`='Study' AND `model`='StudyEthicsBoard' AND `tablename`='study_ethics_boards' AND `field`='contact' AND `type`='input');

-- Disable Phone Number

UPDATE structure_formats
SET `flag_add` = 0, `flag_edit`=0, `flag_detail`=0
WHERE `structure_id`=(SELECT `id` FROM structures WHERE `alias`='studyethicsboards')
AND `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `plugin`='Study' AND `model`='StudyEthicsBoard' AND `tablename`='study_ethics_boards' AND `field`='phone_number' AND `type`='input');

UPDATE structure_formats
SET `flag_add` = 0, `flag_edit`=0, `flag_detail`=0
WHERE `structure_id`=(SELECT `id` FROM structures WHERE `alias`='studyethicsboards')
AND `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `plugin`='Study' AND `model`='StudyEthicsBoard' AND `tablename`='study_ethics_boards' AND `field`='phone_extension' AND `type`='input');

-- Disable Fax

UPDATE structure_formats
SET `flag_add` = 0, `flag_edit`=0, `flag_detail`=0
WHERE `structure_id`=(SELECT `id` FROM structures WHERE `alias`='studyethicsboards')
AND `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `plugin`='Study' AND `model`='StudyEthicsBoard' AND `tablename`='study_ethics_boards' AND `field`='fax_number' AND `type`='input');

UPDATE structure_formats
SET `flag_add` = 0, `flag_edit`=0, `flag_detail`=0
WHERE `structure_id`=(SELECT `id` FROM structures WHERE `alias`='studyethicsboards')
AND `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `plugin`='Study' AND `model`='StudyEthicsBoard' AND `tablename`='study_ethics_boards' AND `field`='fax_extension' AND `type`='input');

-- Disable Email

UPDATE structure_formats
SET `flag_add` = 0, `flag_edit`=0, `flag_detail`=0
WHERE `structure_id`=(SELECT `id` FROM structures WHERE `alias`='studyethicsboards')
AND `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `plugin`='Study' AND `model`='StudyEthicsBoard' AND `tablename`='study_ethics_boards' AND `field`='email' AND `type`='input');

-- Move restrictions to the bottom

UPDATE structure_formats
SET `display_column` = 1, `display_order` = 13
WHERE `structure_id`=(SELECT `id` FROM structures WHERE `alias`='studyethicsboards')
AND `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `plugin`='Study' AND `model`='StudyEthicsBoard' AND `tablename`='study_ethics_boards' AND `field`='restrictions' AND `type`='textarea');

-- Change the size of textboxes

UPDATE structure_fields
SET `setting`='size=44'
WHERE `plugin`='Study' AND `model`='StudyEthicsBoard' AND `tablename`='study_ethics_boards' AND `field`='approval_number' AND `type`='input';

UPDATE structure_fields
SET `setting`='size=44'
WHERE `plugin`='Study' AND `model`='StudyEthicsBoard' AND `tablename`='study_ethics_boards' AND `field`='ethics_board' AND `type`='input';


-- Reorganize the Study Contact UI 

UPDATE structure_formats 
SET `display_column` = 1, `display_order` = 8
WHERE `structure_id`=(SELECT `id` FROM structures WHERE `alias`='studycontacts')
AND `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `plugin`='Study' AND `model`='StudyContact' AND `tablename`='study_contacts' AND `field`='address_street' AND `type`='input');

UPDATE structure_formats 
SET `display_column` = 1, `display_order` = 9
WHERE `structure_id`=(SELECT `id` FROM structures WHERE `alias`='studycontacts')
AND `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `plugin`='Study' AND `model`='StudyContact' AND `tablename`='study_contacts' AND `field`='address_city' AND `type`='input');

UPDATE structure_formats 
SET `display_column` = 1, `display_order` = 10
WHERE `structure_id`=(SELECT `id` FROM structures WHERE `alias`='studycontacts')
AND `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `plugin`='Study' AND `model`='StudyContact' AND `tablename`='study_contacts' AND `field`='address_province' AND `type`='select');

UPDATE structure_formats 
SET `display_column` = 1, `display_order` = 11
WHERE `structure_id`=(SELECT `id` FROM structures WHERE `alias`='studycontacts')
AND `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `plugin`='Study' AND `model`='StudyContact' AND `tablename`='study_contacts' AND `field`='address_country' AND `type`='input');

UPDATE structure_formats 
SET `display_column` = 1, `display_order` = 12
WHERE `structure_id`=(SELECT `id` FROM structures WHERE `alias`='studycontacts')
AND `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `plugin`='Study' AND `model`='StudyContact' AND `tablename`='study_contacts' AND `field`='address_postal' AND `type`='input');

UPDATE structure_formats 
SET `display_column` = 1, `display_order` = 13
WHERE `structure_id`=(SELECT `id` FROM structures WHERE `alias`='studycontacts')
AND `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `plugin`='Study' AND `model`='StudyContact' AND `tablename`='study_contacts' AND `field`='phone_number' AND `type`='input');

UPDATE structure_formats 
SET `display_column` = 1, `display_order` = 14
WHERE `structure_id`=(SELECT `id` FROM structures WHERE `alias`='studycontacts')
AND `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `plugin`='Study' AND `model`='StudyContact' AND `tablename`='study_contacts' AND `field`='phone_extension' AND `type`='input');

UPDATE structure_formats 
SET `display_column` = 1, `display_order` = 15
WHERE `structure_id`=(SELECT `id` FROM structures WHERE `alias`='studycontacts')
AND `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `plugin`='Study' AND `model`='StudyContact' AND `tablename`='study_contacts' AND `field`='phone2_number' AND `type`='input');

UPDATE structure_formats 
SET `display_column` = 1, `display_order` = 16
WHERE `structure_id`=(SELECT `id` FROM structures WHERE `alias`='studycontacts')
AND `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `plugin`='Study' AND `model`='StudyContact' AND `tablename`='study_contacts' AND `field`='phone2_extension' AND `type`='input');

UPDATE structure_formats 
SET `display_column` = 1, `display_order` = 17
WHERE `structure_id`=(SELECT `id` FROM structures WHERE `alias`='studycontacts')
AND `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `plugin`='Study' AND `model`='StudyContact' AND `tablename`='study_contacts' AND `field`='fax_number' AND `type`='input');

UPDATE structure_formats 
SET `display_column` = 1, `display_order` = 18
WHERE `structure_id`=(SELECT `id` FROM structures WHERE `alias`='studycontacts')
AND `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `plugin`='Study' AND `model`='StudyContact' AND `tablename`='study_contacts' AND `field`='fax_extension' AND `type`='input');

UPDATE structure_formats 
SET `display_column` = 1, `display_order` = 19
WHERE `structure_id`=(SELECT `id` FROM structures WHERE `alias`='studycontacts')
AND `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `plugin`='Study' AND `model`='StudyContact' AND `tablename`='study_contacts' AND `field`='email' AND `type`='input');

UPDATE structure_formats 
SET `display_column` = 1, `display_order` = 20
WHERE `structure_id`=(SELECT `id` FROM structures WHERE `alias`='studycontacts')
AND `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `plugin`='Study' AND `model`='StudyContact' AND `tablename`='study_contacts' AND `field`='website' AND `type`='input');

-- Reorganize the Study Investigator UI 


UPDATE structure_formats 
SET `display_column` = 1, `display_order` = 8
WHERE `structure_id`=(SELECT `id` FROM structures WHERE `alias`='studyinvestigators')
AND `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `plugin`='Study' AND `model`='StudyInvestigator' AND `tablename`='study_investigators' AND `field`='address_street' AND `type`='input');

UPDATE structure_formats 
SET `display_column` = 1, `display_order` = 9
WHERE `structure_id`=(SELECT `id` FROM structures WHERE `alias`='studyinvestigators')
AND `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `plugin`='Study' AND `model`='StudyInvestigator' AND `tablename`='study_investigators' AND `field`='address_city' AND `type`='input');

UPDATE structure_formats 
SET `display_column` = 1, `display_order` = 10
WHERE `structure_id`=(SELECT `id` FROM structures WHERE `alias`='studyinvestigators')
AND `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `plugin`='Study' AND `model`='StudyInvestigator' AND `tablename`='study_investigators' AND `field`='address_province' AND `type`='input');

UPDATE structure_formats 
SET `display_column` = 1, `display_order` = 11
WHERE `structure_id`=(SELECT `id` FROM structures WHERE `alias`='studyinvestigators')
AND `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `plugin`='Study' AND `model`='StudyInvestigator' AND `tablename`='study_investigators' AND `field`='address_country' AND `type`='input');


UPDATE structure_formats 
SET `display_column` = 1, `display_order` = 12
WHERE `structure_id`=(SELECT `id` FROM structures WHERE `alias`='studyinvestigators')
AND `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `plugin`='Study' AND `model`='StudyInvestigator' AND `tablename`='study_investigators' AND `field`='email' AND `type`='input');

UPDATE structure_formats 
SET `display_column` = 1, `display_order` = 13
WHERE `structure_id`=(SELECT `id` FROM structures WHERE `alias`='studyinvestigators')
AND `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `plugin`='Study' AND `model`='StudyInvestigator' AND `tablename`='study_investigators' AND `field`='role' AND `type`='select');

UPDATE structure_formats 
SET `display_column` = 1, `display_order` = 14
WHERE `structure_id`=(SELECT `id` FROM structures WHERE `alias`='studyinvestigators')
AND `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `plugin`='Study' AND `model`='StudyInvestigator' AND `tablename`='study_investigators' AND `field`='brief' AND `type`='textarea');

-- Change the position of some fields in Study Investigators 

UPDATE structure_formats
SET `display_column`=1, `display_order`=20
WHERE `structure_id`=(SELECT `id` FROM structures WHERE `alias`='studyinvestigators')
AND `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `plugin`='Study' AND `model`='StudyInvestigator' AND `tablename`='study_investigators' AND `field`='affil_cfri');

UPDATE structure_formats
SET `display_column`=1, `display_order`=21
WHERE `structure_id`=(SELECT `id` FROM structures WHERE `alias`='studyinvestigators')
AND `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `plugin`='Study' AND `model`='StudyInvestigator' AND `tablename`='study_investigators' AND `field`='affil_whri');

UPDATE structure_formats
SET `display_column`=1, `display_order`=22
WHERE `structure_id`=(SELECT `id` FROM structures WHERE `alias`='studyinvestigators')
AND `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `plugin`='Study' AND `model`='StudyInvestigator' AND `tablename`='study_investigators' AND `field`='affil_bcmhri');

UPDATE structure_formats
SET `display_column`=1, `display_order`=23
WHERE `structure_id`=(SELECT `id` FROM structures WHERE `alias`='studyinvestigators')
AND `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `plugin`='Study' AND `model`='StudyInvestigator' AND `tablename`='study_investigators' AND `field`='affil_vchri');

UPDATE structure_formats
SET `display_column`=1, `display_order`=24
WHERE `structure_id`=(SELECT `id` FROM structures WHERE `alias`='studyinvestigators')
AND `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `plugin`='Study' AND `model`='StudyInvestigator' AND `tablename`='study_investigators' AND `field`='affil_bcca');

UPDATE structure_formats
SET `display_column`=1, `display_order`=25
WHERE `structure_id`=(SELECT `id` FROM structures WHERE `alias`='studyinvestigators')
AND `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `plugin`='Study' AND `model`='StudyInvestigator' AND `tablename`='study_investigators' AND `field`='affil_other');

-- Update the province field in both contacts and investigators to be consistent
-- Should be a drop down with all the provinces and "other"

UPDATE structure_fields 
SET `type`='select', `setting`='', `structure_value_domain`=(SELECT `id` FROM structure_value_domains WHERE `domain_name`='provinces'), `value_domain_control`='locked'
WHERE `plugin`='Study' AND `model`='StudyInvestigator' AND `tablename`='study_investigators' AND `field`='address_province';

INSERT INTO structure_value_domains_permissible_values
(`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`, `use_as_input`)
VALUES
((SELECT `id` FROM structure_value_domains WHERE `domain_name`='provinces'), (SELECT `id` FROM structure_permissible_values WHERE `value`='other' AND `language_alias`='ccbr other'), 14, 1, 1);

ALTER TABLE study_contacts
	ADD COLUMN `address_province_other` VARCHAR(30) AFTER `address_province`;

ALTER TABLE study_contacts_revs
	ADD COLUMN `address_province_other` VARCHAR(30) AFTER `address_province`;
	
ALTER TABLE study_investigators
	ADD COLUMN `address_province_other` VARCHAR(30) AFTER `address_province`;

ALTER TABLE study_investigators_revs
	ADD COLUMN `address_province_other` VARCHAR(30) AFTER `address_province`;
	
INSERT INTO structure_fields 
(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `validation_control`, `value_domain_control`, `field_control`, `flag_confidential`)
VALUES
('Study', 'StudyContact', 'study_contacts', 'address_province_other', '', 'study_province_other', 'input', 'size=15', 'open', 'open', 'open', 0),
('Study', 'StudyInvestigator', 'study_investigators', 'address_province_other', '', 'study_province_other', 'input', 'size=15', 'open', 'open', 'open', 0);

UPDATE structure_fields
SET `language_label`='study_province', `language_tag`=''
WHERE `plugin`='Study' AND `model`='StudyInvestigator' AND `tablename`='study_investigators' AND `field`='address_province';

UPDATE structure_fields
SET `language_label`='study_country', `language_tag`=''
WHERE `plugin`='Study' AND `model`='StudyInvestigator' AND `tablename`='study_investigators' AND `field`='address_country';

INSERT INTO structure_formats 
(`structure_id`, `structure_field_id`, 
`display_column`, `display_order`, `language_heading`, `flag_override_label`, `flag_override_tag`, `flag_override_help`, `flag_override_type`, 
`flag_override_setting`, `flag_override_default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, 
`flag_addgrid`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_summary`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, 
`flag_float`, `margin`) 
VALUES
((SELECT `id` FROM structures WHERE `alias`='studycontacts'), (SELECT `id` FROM structure_fields WHERE `plugin`='Study' AND `model`='StudyContact' AND `tablename`='study_contacts' AND `field`='address_province_other'),
 1, 11, '', 0, 0, 0, 0,
 0, 0, 1, 0, 1, 0, 0, 0,
 0, 0, 0, 0, 0, 0, 0, 1, 
 0, 0),
((SELECT `id` FROM structures WHERE `alias`='studyinvestigators'), (SELECT `id` FROM structure_fields WHERE `plugin`='Study' AND `model`='StudyInvestigator' AND `tablename`='study_investigators' AND `field`='address_province_other'),
 1, 11, '', 0, 0, 0, 0,
 0, 0, 1, 0, 1, 0, 0, 0,
 0, 0, 0, 0, 0, 0, 0, 1, 
 0, 0);
 
 REPLACE INTO i18n (`id`, `en`) VALUES
 ('study_province_other', 'If other');


--  =========================================================================
--	Eventum ID: #3236 - Rename the consent form menu
--  BB-42
--	=========================================================================

REPLACE INTO i18n (`id`, `en`) VALUES
('BCCH Consent Form', 'BCCH Consent Form (Children)'),
('BCWH Consent', 'BCWH Consent Form (Women)'),
('BCWH Maternal Consent', 'BCWH Consent Form (Maternal)');

--  =========================================================================
--	Eventum ID: #3218 - Storage Changes
--  BB-43
--	=========================================================================

-- Enable Room 

UPDATE storage_controls
SET `flag_active`=1
WHERE `storage_type`='room' AND `detail_tablename`='std_rooms';

-- Enable Racks 24

UPDATE storage_controls
SET `flag_active`=1
WHERE `storage_type`='rack24' AND `detail_tablename`='std_racks';

-- Enable box81 1A-91

UPDATE storage_controls
SET `flag_active`=1
WHERE `storage_type`='box81 1A-9I' AND `detail_tablename`='std_boxs';

-- Enable longer short label

ALTER TABLE storage_masters MODIFY `short_label` VARCHAR(30);
ALTER TABLE storage_masters_revs MODIFY `short_label` VARCHAR(30);
ALTER TABLE view_storage_masters MODIFY `short_label` VARCHAR(30);

-- Expand the length of the selection label to be 

ALTER TABLE storage_masters MODIFY `selection_label` VARCHAR(210);
ALTER TABLE storage_masters_revs MODIFY `selection_label` VARCHAR(210);
ALTER TABLE view_storage_masters MODIFY `selection_label` VARCHAR(210);

-- Make the input box for short label wider
UPDATE structure_fields
SET `setting`='size=20'
WHERE `plugin`='StorageLayout' AND `model`='StorageMaster' AND `tablename`='storage_masters' AND `field`='short_label' AND `type`='input';

--  =========================================================================
--	Eventum ID: #3214 - Linking Consent Forms with Study
--  BB-41
--	=========================================================================

ALTER TABLE consent_masters
	 	ADD `study_summary_id` INT(11) DEFAULT NULL AFTER `type`;

ALTER TABLE consent_masters_revs
	 	ADD `study_summary_id` INT(11) DEFAULT NULL AFTER `type`;

INSERT INTO structure_fields (`plugin`, `model`, `tablename`, `field`, `language_label`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `flag_confidential`) VALUES
('ClinicalAnnotation', 'ConsentMaster', 'consent_masters', 'study_summary_id', 'project title', 'select', '', '', (SELECT `id` FROM structure_value_domains WHERE `domain_name`='study_list' AND `source`='Study.StudySummary::getStudyPermissibleValues'), 'help_select_study', 'open', 'open', 'open', 0);

INSERT INTO structure_formats (`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`,
`flag_override_label`, `flag_override_tag`, `flag_override_help`, `flag_override_type`, `flag_override_setting`, `flag_override_default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_summary`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_float`, `margin`) VALUES
((SELECT `id` FROM structures WHERE `alias`='consent_masters'), (SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='study_summary_id' AND `type`='select' AND `structure_value_domain`=(SELECT `id` FROM structure_value_domains WHERE `domain_name`='study_list' AND `source`='Study.StudySummary::getStudyPermissibleValues')), 2, 90, 'study/project',
 0, 0, 0, 0, 0,
 0, 1, 0, 1, 0, 1,
 0, 0, 0, 0, 1, 0, 
 0, 1, 1, 0, 0);


--  =========================================================================
--	Eventum ID: #3216 - Displaying Participant Identifier in Consent Form
--  BB-41
--	=========================================================================

ALTER TABLE consent_masters
	 	ADD `participant_identifier` VARCHAR(50) DEFAULT NULL AFTER `participant_id`;

ALTER TABLE consent_masters_revs
	 	ADD `participant_identifier` VARCHAR(50) DEFAULT NULL AFTER `participant_id`;

INSERT INTO structure_fields (`plugin`, `model`, `tablename`, `field`, `language_label`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `flag_confidential`) VALUES
('ClinicalAnnotation', 'ConsentMaster', 'consent_masters', 'participant_identifier', 'participant identifier', 'hidden', '', '', NULL, '', 'open', 'open', 'open', 0);

INSERT INTO structure_formats (`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`,
`flag_override_label`, `flag_override_tag`, `flag_override_help`, `flag_override_type`, `flag_override_setting`, `flag_override_default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_summary`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_float`, `margin`) VALUES
((SELECT `id` FROM structures WHERE `alias`='consent_masters'), (SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='participant_identifier' AND `type`='hidden'), 2, 91, '',
 0, 0, 0, 0, 0,
 0, 0, 1, 0, 1, 0,
 1, 0, 1, 0, 1, 
 1, 0, 1, 1, 1, 1, 0);

INSERT INTO i18n (`id`, `en`) VALUES
('consent masters', 'Consent Forms'),
('study/project', 'Study & Project'),
('project title', 'Project Title'),
('participant information', 'Participant Information'),
('help_select_study', 'The project/study that associates with this consent form.');

-- Update the old consent_masters data to have proper participant identifiers

UPDATE consent_masters, participants
SET consent_masters.participant_identifier = participants.participant_identifier
WHERE consent_masters.participant_id = participants.id;

UPDATE consent_masters_revs, participants
SET consent_masters_revs.participant_identifier = participants.participant_identifier
WHERE consent_masters_revs.participant_id = participants.id;

--  =========================================================================
--	Eventum ID: #3237 - Pleural Fluid Sample Type
--  BB-50
--	=========================================================================

-- Enable Pleural Fluid as a specimen
UPDATE parent_to_derivative_sample_controls
SET `flag_active` = 1
WHERE `derivative_sample_control_id`=(SELECT `id` FROM sample_controls WHERE `sample_type`='pleural fluid' AND `sample_category`='specimen' AND `detail_tablename`='sd_spe_pleural_fluids');

-- Enable Pluerual Fluid Cell as derivative
UPDATE parent_to_derivative_sample_controls
SET `flag_active` = 1
WHERE `parent_sample_control_id`=(SELECT `id` FROM sample_controls WHERE `sample_type`='pleural fluid' AND `sample_category`='specimen' AND `detail_tablename`='sd_spe_pleural_fluids')
AND `derivative_sample_control_id`=(SELECT `id` FROM sample_controls WHERE `sample_type`='pleural fluid cell' AND `sample_category`='derivative' AND `detail_tablename`='sd_der_pleural_fl_cells');

-- Enable Pluerual Fluid Supernatant as derivative
UPDATE parent_to_derivative_sample_controls
SET `flag_active` = 1
WHERE `parent_sample_control_id`=(SELECT `id` FROM sample_controls WHERE `sample_type`='pleural fluid' AND `sample_category`='specimen' AND `detail_tablename`='sd_spe_pleural_fluids')
AND `derivative_sample_control_id`=(SELECT `id` FROM sample_controls WHERE `sample_type`='pleural fluid supernatant' AND `sample_category`='derivative' AND `detail_tablename`='sd_der_pleural_fl_sups');

-- Enable DNA as derivatives
/* Disabled this line based on feedback from user
INSERT INTO parent_to_derivative_sample_controls
(`parent_sample_control_id`, `derivative_sample_control_id`, `flag_active`) VALUES
((SELECT `id` FROM sample_controls WHERE `sample_type`='pleural fluid' AND `sample_category`='specimen' AND `detail_tablename`='sd_spe_pleural_fluids'),
 (SELECT `id` FROM sample_controls WHERE `sample_type`='dna' AND `sample_category`='derivative' AND `detail_tablename`='sd_der_dnas'), 1);
*/


INSERT INTO parent_to_derivative_sample_controls
(`parent_sample_control_id`, `derivative_sample_control_id`, `flag_active`) VALUES
((SELECT `id` FROM sample_controls WHERE `sample_type`='pleural fluid supernatant' AND `sample_category`='derivative' AND `detail_tablename`='sd_der_pleural_fl_sups'),
 (SELECT `id` FROM sample_controls WHERE `sample_type`='dna' AND `sample_category`='derivative' AND `detail_tablename`='sd_der_dnas'), 1);

UPDATE parent_to_derivative_sample_controls
SET `flag_active` = 1
WHERE `parent_sample_control_id`=(SELECT `id` FROM sample_controls WHERE `sample_type`='pleural fluid cell' AND `sample_category`='derivative' AND `detail_tablename`='sd_der_pleural_fl_cells')
AND `derivative_sample_control_id`=(SELECT `id` FROM sample_controls WHERE `sample_type`='dna' AND `sample_category`='derivative' AND `detail_tablename`='sd_der_dnas');

-- Enable RNA as derivatives
/* Disabled this line based on feedback from user
INSERT INTO parent_to_derivative_sample_controls
(`parent_sample_control_id`, `derivative_sample_control_id`, `flag_active`) VALUES
((SELECT `id` FROM sample_controls WHERE `sample_type`='pleural fluid' AND `sample_category`='specimen' AND `detail_tablename`='sd_spe_pleural_fluids'),
 (SELECT `id` FROM sample_controls WHERE `sample_type`='rna' AND `sample_category`='derivative' AND `detail_tablename`='sd_der_rnas'), 1);
*/
 
INSERT INTO parent_to_derivative_sample_controls
(`parent_sample_control_id`, `derivative_sample_control_id`, `flag_active`) VALUES
((SELECT `id` FROM sample_controls WHERE `sample_type`='pleural fluid supernatant' AND `sample_category`='derivative' AND `detail_tablename`='sd_der_pleural_fl_sups'),
 (SELECT `id` FROM sample_controls WHERE `sample_type`='rna' AND `sample_category`='derivative' AND `detail_tablename`='sd_der_rnas'), 1);

UPDATE parent_to_derivative_sample_controls
SET `flag_active` = 1
WHERE `parent_sample_control_id`=(SELECT `id` FROM sample_controls WHERE `sample_type`='pleural fluid cell' AND `sample_category`='derivative' AND `detail_tablename`='sd_der_pleural_fl_cells')
AND `derivative_sample_control_id`=(SELECT `id` FROM sample_controls WHERE `sample_type`='rna' AND `sample_category`='derivative' AND `detail_tablename`='sd_der_rnas');
 
 -- Enable Aliquots for the sample and derivatives
 INSERT INTO aliquot_controls
 (`sample_control_id`, 
 `aliquot_type`, `aliquot_type_precision`, `detail_form_alias`, `detail_tablename`, `volume_unit`, `flag_active`, `comment`, `display_order`, `databrowser_label`)
 VALUES
 ((SELECT `id` FROM sample_controls WHERE `sample_type`='pleural fluid' AND `sample_category`='specimen' AND `detail_tablename`='sd_spe_pleural_fluids'),
  'tube', '(ul)', 'ad_spec_tubes_incl_ul_vol', 'ad_tubes', 'ul', 1, 'Specimen tube requiring volume in ul', 0, 'pleural fluid|tube'),
  ((SELECT `id` FROM sample_controls WHERE `sample_type`='pleural fluid cell' AND `sample_category`='derivative' AND `detail_tablename`='sd_der_pleural_fl_cells'),
  'tube', '(ul)', 'ad_der_tubes_incl_ul_vol', 'ad_tubes', 'ul', 1, 'Derivative tube requiring volume in ul', 0, 'pleural fluid cell|tube'),
  ((SELECT `id` FROM sample_controls WHERE `sample_type`='pleural fluid supernatant' AND `sample_category`='derivative' AND `detail_tablename`='sd_der_pleural_fl_sups'),
  'tube', '(ul)', 'ad_der_tubes_incl_ul_vol', 'ad_tubes', 'ul', 1, 'Derivative tube requiring volume in ul', 0, 'pleural fluid supernatant|tube');
  
 
--  =========================================================================
--	Eventum ID: #3238 - Urine Sample Type
--  BB-51
--	=========================================================================

UPDATE parent_to_derivative_sample_controls
SET `flag_active` = 1
WHERE `derivative_sample_control_id`=(SELECT `id` FROM sample_controls WHERE `sample_type`='urine' AND `sample_category`='specimen' AND `detail_tablename`='sd_spe_urines');
/*
-- Enable Concentrated Urine as derivative
UPDATE parent_to_derivative_sample_controls
SET `flag_active` = 1
WHERE `parent_sample_control_id`=(SELECT `id` FROM sample_controls WHERE `sample_type`='urine' AND `sample_category`='specimen' AND `detail_tablename`='sd_spe_urines')
AND `derivative_sample_control_id`=(SELECT `id` FROM sample_controls WHERE `sample_type`='concentrated urine' AND `sample_category`='derivative' AND `detail_tablename`='sd_der_urine_cons');

-- Enable Centrifuged Urine as derivative
UPDATE parent_to_derivative_sample_controls
SET `flag_active` = 1
WHERE `parent_sample_control_id`=(SELECT `id` FROM sample_controls WHERE `sample_type`='urine' AND `sample_category`='specimen' AND `detail_tablename`='sd_spe_urines')
AND `derivative_sample_control_id`=(SELECT `id` FROM sample_controls WHERE `sample_type`='centrifuged urine' AND `sample_category`='derivative' AND `detail_tablename`='sd_der_urine_cents');
*/
-- Enable DNA as derivatives
INSERT INTO parent_to_derivative_sample_controls
(`parent_sample_control_id`, `derivative_sample_control_id`, `flag_active`) VALUES
((SELECT `id` FROM sample_controls WHERE `sample_type`='urine' AND `sample_category`='specimen' AND `detail_tablename`='sd_spe_urines'),
 (SELECT `id` FROM sample_controls WHERE `sample_type`='dna' AND `sample_category`='derivative' AND `detail_tablename`='sd_der_dnas'), 1);
/*
UPDATE parent_to_derivative_sample_controls
SET `flag_active` = 1
WHERE `parent_sample_control_id`=(SELECT `id` FROM sample_controls WHERE `sample_type`='concentrated urine' AND `sample_category`='derivative' AND `detail_tablename`='sd_der_urine_cons')
AND `derivative_sample_control_id`=(SELECT `id` FROM sample_controls WHERE `sample_type`='dna' AND `sample_category`='derivative' AND `detail_tablename`='sd_der_dnas');

UPDATE parent_to_derivative_sample_controls
SET `flag_active` = 1
WHERE `parent_sample_control_id`=(SELECT `id` FROM sample_controls WHERE `sample_type`='centrifuged urine' AND `sample_category`='derivative' AND `detail_tablename`='sd_der_urine_cents')
AND `derivative_sample_control_id`=(SELECT `id` FROM sample_controls WHERE `sample_type`='dna' AND `sample_category`='derivative' AND `detail_tablename`='sd_der_dnas');
*/
-- Enable RNA as derivatives
INSERT INTO parent_to_derivative_sample_controls
(`parent_sample_control_id`, `derivative_sample_control_id`, `flag_active`) VALUES
((SELECT `id` FROM sample_controls WHERE `sample_type`='urine' AND `sample_category`='specimen' AND `detail_tablename`='sd_spe_urines'),
 (SELECT `id` FROM sample_controls WHERE `sample_type`='rna' AND `sample_category`='derivative' AND `detail_tablename`='sd_der_rnas'), 1);

/*
UPDATE parent_to_derivative_sample_controls
SET `flag_active` = 1
WHERE `parent_sample_control_id`=(SELECT `id` FROM sample_controls WHERE `sample_type`='concentrated urine' AND `sample_category`='derivative' AND `detail_tablename`='sd_der_urine_cons')
AND `derivative_sample_control_id`=(SELECT `id` FROM sample_controls WHERE `sample_type`='rna' AND `sample_category`='derivative' AND `detail_tablename`='sd_der_rnas');

UPDATE parent_to_derivative_sample_controls
SET `flag_active` = 1
WHERE `parent_sample_control_id`=(SELECT `id` FROM sample_controls WHERE `sample_type`='centrifuged urine' AND `sample_category`='derivative' AND `detail_tablename`='sd_der_urine_cents')
AND `derivative_sample_control_id`=(SELECT `id` FROM sample_controls WHERE `sample_type`='rna' AND `sample_category`='derivative' AND `detail_tablename`='sd_der_rnas');
*/

-- Enable Aliquot for Urine
 INSERT INTO aliquot_controls
 (`sample_control_id`, 
 `aliquot_type`, `aliquot_type_precision`, `detail_form_alias`, `detail_tablename`, `volume_unit`, `flag_active`, `comment`, `display_order`, `databrowser_label`)
 VALUES
 ((SELECT `id` FROM sample_controls WHERE `sample_type`='urine' AND `sample_category`='specimen' AND `detail_tablename`='sd_spe_urines'),
  'tube', '(ml)', 'ad_spec_tubes_incl_ml_vol', 'ad_tubes', 'ml', 1, 'Specimen tube requiring volume in ml', 0, 'urine|tube');

--  =========================================================================
--	Issue: #3173- New sample type (Cord Blood)
--  BB-53
--  From Aaron's code at version 2.6.4
--  Don't need to run the code again when upgrading to 2.6.4
--  =========================================================================

SELECT "New Sample Type: Created 'Cord Blood' specimen. 1- Comment line if already created in the custom version. 2- Disable sample_type if this sample type is not supported into your bank." AS '### MESSAGE ###';

CREATE TABLE `sd_spe_cord_bloods` (
  `sample_master_id` int(11) NOT NULL,
  KEY `FK_sd_spe_cord_bloods_sample_masters` (`sample_master_id`),
  CONSTRAINT `FK_sd_spe_cord_bloods` FOREIGN KEY (`sample_master_id`) REFERENCES `sample_masters` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `sd_spe_cord_bloods_revs` (
  `sample_master_id` int(11) NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Add structure
INSERT INTO `structures` (`alias`) VALUES ('sd_spe_cord_bloods');

-- Add control row
INSERT INTO `sample_controls` (`sample_type`, `sample_category`, `detail_form_alias`, `detail_tablename`, `display_order`, `databrowser_label`) VALUES
 ('cord blood', 'specimen', 'sd_spe_cord_bloods,specimens', 'sd_spe_cord_bloods', '0', 'cord blood');

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
('cord blood', "Cord Blood", 'Sang de cordon');

-- Enable new sample type
INSERT INTO `parent_to_derivative_sample_controls` (`derivative_sample_control_id`, `flag_active`) VALUES ((SELECT `id` FROM `sample_controls` WHERE `sample_type` = 'cord blood'), '1');

-- Create aliquot tube for cord blood
INSERT INTO `aliquot_controls` (`sample_control_id`, `aliquot_type`, `aliquot_type_precision`, `detail_form_alias`, `detail_tablename`, `volume_unit`, `flag_active`, `comment`, `display_order`, `databrowser_label`) VALUES 
((SELECT `id` FROM `sample_controls` where `sample_type` = 'cord blood'), 'tube', '(ul + conc)', 'ad_spec_tubes_incl_ul_vol_and_conc', 'ad_tubes', 'ul', '1', 'Specimen tube requiring volume in ul and concentration', '0', 'cord blood|tube');

-- Add new specimen tube for cord blood
INSERT INTO `structures` (`alias`) VALUES ('ad_spec_tubes_incl_ul_vol_and_conc');

-- Add cell count fields
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ad_spec_tubes_incl_ul_vol_and_conc'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `field`='cell_count' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='cell count' AND `language_tag`=''), '1', '451', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ad_spec_tubes_incl_ul_vol_and_conc'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `field`='cell_count_unit' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='cell_count_unit')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_tag`=''), '1', '452', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0', '0');

-- Add volume fields
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ad_spec_tubes_incl_ul_vol_and_conc'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='initial_volume' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='initial volume' AND `language_tag`=''), '1', '73', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='ad_spec_tubes_incl_ul_vol_and_conc'), (SELECT id FROM structure_fields WHERE `model`='AliquotControl' AND `tablename`='aliquot_controls' AND `field`='volume_unit' AND `type`='select' AND `structure_value_domain`=6  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`=''), '1', '74', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0', '0');


-- Enable DNA as derivatives
INSERT INTO parent_to_derivative_sample_controls
(`parent_sample_control_id`, `derivative_sample_control_id`, `flag_active`) VALUES
((SELECT `id` FROM sample_controls WHERE `sample_type`='cord blood' AND `sample_category`='specimen' AND `detail_tablename`='sd_spe_cord_bloods'),
 (SELECT `id` FROM sample_controls WHERE `sample_type`='dna' AND `sample_category`='derivative' AND `detail_tablename`='sd_der_dnas'), 1);

-- Enable RNA as derivatives
INSERT INTO parent_to_derivative_sample_controls
(`parent_sample_control_id`, `derivative_sample_control_id`, `flag_active`) VALUES
((SELECT `id` FROM sample_controls WHERE `sample_type`='cord blood' AND `sample_category`='specimen' AND `detail_tablename`='sd_spe_cord_bloods'),
 (SELECT `id` FROM sample_controls WHERE `sample_type`='rna' AND `sample_category`='derivative' AND `detail_tablename`='sd_der_rnas'), 1);

--  =========================================================================
--	Issue: #3239 - Add DNA/RNA purity ratio
--  BB-54
--  =========================================================================


ALTER TABLE ad_tubes
ADD COLUMN `ratio_260_280` decimal(7,4) DEFAULT NULL
AFTER `hemolysis_signs`;

ALTER TABLE ad_tubes_revs
ADD COLUMN `ratio_260_280` decimal(7,4) DEFAULT NULL
AFTER `hemolysis_signs`;

ALTER TABLE ad_tubes
ADD COLUMN `ratio_260_230` decimal(7,4) DEFAULT NULL
AFTER `ratio_260_280`;

ALTER TABLE ad_tubes_revs
ADD COLUMN `ratio_260_230` decimal(7,4) DEFAULT NULL
AFTER `ratio_260_280`;

INSERT INTO structure_fields 
(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `structure_value_domain`, `language_help`, 
`validation_control`, `value_domain_control`, `field_control`, `flag_confidential`)
VALUES
('InventoryManagement', 'AliquotDetail', 'ad_tubes', 'ratio_260_280', 'ratio_260_280', '', 'float', 'size=7', NULL, 'help_260_280', 
'open', 'open', 'open', 0),
('InventoryManagement', 'AliquotDetail', 'ad_tubes', 'ratio_260_230', 'ratio_260_230', '', 'float', 'size=7', NULL, 'help_260_230', 
'open', 'open', 'open', 0);

INSERT INTO structure_formats
(`structure_id`, `structure_field_id`, 
 `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, 
 `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`,  `flag_override_default`, `default`, 
 `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, 
 `flag_editgrid`, `flag_editgrid_readonly`, `flag_summary`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_float`, 
 `margin` ) VALUES
((SELECT `id` FROM structures WHERE `alias`='ad_der_tubes_incl_ul_vol_and_conc'),
 (SELECT `id` FROM structure_fields WHERE `plugin`='InventoryManagement' AND `model`='AliquotDetail' AND `tablename`='ad_tubes' AND `field`='ratio_260_280'),
 1, 77, '', 0, '', 0, '',
 0, '', 0, '', 0, '', 0, '',
 1, 0, 1, 0, 1, 0, 1, 0, 
 1, 0, 1, 0, 0, 1, 1, 0, 
 0),
((SELECT `id` FROM structures WHERE `alias`='ad_der_tubes_incl_ul_vol_and_conc'),
 (SELECT `id` FROM structure_fields WHERE `plugin`='InventoryManagement' AND `model`='AliquotDetail' AND `tablename`='ad_tubes' AND `field`='ratio_260_230'),
 1, 78, '', 0, '', 0, '',
 0, '', 0, '', 0, '', 0, '',
 1, 0, 1, 0, 1, 0, 1, 0, 
 1, 0, 1, 0, 0, 1, 1, 0, 
 0);
 
 REPLACE INTO i18n (`id`, `en`) VALUES
 ('ratio_260_280', '260/280 Ratio'),
 ('ratio_260_230', '260/230 Ratio'),
 ('help_260_280', '260/280 ratio from the Nanodrop'),
 ('help_260_230', '260/230 ratio from the Nanodrop');
 
--  =========================================================================
--	Issue: #3240 - New sample type (Stool)
--  BB-52
--  =========================================================================

CREATE TABLE `sd_spe_stools` (
  `sample_master_id` int(11) NOT NULL,
  KEY `FK_sd_spe_stools_sample_masters` (`sample_master_id`),
  CONSTRAINT `FK_sd_spe_stools` FOREIGN KEY (`sample_master_id`) REFERENCES `sample_masters` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `sd_spe_stools_revs` (
  `sample_master_id` int(11) NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Add structure
INSERT INTO `structures` (`alias`) VALUES ('sd_spe_stools');

-- Add control row
INSERT INTO `sample_controls` (`sample_type`, `sample_category`, `detail_form_alias`, `detail_tablename`, `display_order`, `databrowser_label`) VALUES
 ('stool', 'specimen', 'sd_spe_stools,specimens', 'sd_spe_stools', '0', 'stool');

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
('stool', "Stool", 'Tabouret');

-- Enable new sample type
INSERT INTO `parent_to_derivative_sample_controls` (`derivative_sample_control_id`, `flag_active`) VALUES ((SELECT `id` FROM `sample_controls` WHERE `sample_type` = 'stool'), '1');

-- Create aliquot tube for stool

INSERT INTO `aliquot_controls` (`sample_control_id`, `aliquot_type`, `aliquot_type_precision`, `detail_form_alias`, `detail_tablename`, `volume_unit`, `flag_active`, `comment`, `display_order`, `databrowser_label`) VALUES 
((SELECT `id` FROM `sample_controls` where `sample_type` = 'stool'), 'tube', '(ml)', 'ad_spec_tubes_incl_ml_vol', 'ad_tubes', 'ml', '1', 'Specimen tube requiring volume in ml', '0', 'stool|tube');

-- Enable DNA as derivatives
INSERT INTO parent_to_derivative_sample_controls
(`parent_sample_control_id`, `derivative_sample_control_id`, `flag_active`) VALUES
((SELECT `id` FROM sample_controls WHERE `sample_type`='stool' AND `sample_category`='specimen' AND `detail_tablename`='sd_spe_stools'),
 (SELECT `id` FROM sample_controls WHERE `sample_type`='dna' AND `sample_category`='derivative' AND `detail_tablename`='sd_der_dnas'), 1);

-- Enable RNA as derivatives
INSERT INTO parent_to_derivative_sample_controls
(`parent_sample_control_id`, `derivative_sample_control_id`, `flag_active`) VALUES
((SELECT `id` FROM sample_controls WHERE `sample_type`='stool' AND `sample_category`='specimen' AND `detail_tablename`='sd_spe_stools'),
 (SELECT `id` FROM sample_controls WHERE `sample_type`='rna' AND `sample_category`='derivative' AND `detail_tablename`='sd_der_rnas'), 1);
 
 -- User request weight to be added as a new field
 ALTER TABLE ad_tubes
 	ADD COLUMN `mass` DECIMAL(7,4) DEFAULT NULL AFTER `ratio_260_230`,
	ADD COLUMN `mass_unit` VARCHAR(10) DEFAULT NULL AFTER `mass`;

 ALTER TABLE ad_tubes_revs
 	ADD COLUMN `mass` DECIMAL(7,4) DEFAULT NULL AFTER `ratio_260_230`,
	ADD COLUMN `mass_unit` VARCHAR(10) DEFAULT NULL AFTER `mass`;

UPDATE aliquot_controls
SET `aliquot_type_precision`='', `detail_form_alias`='ad_ccbr_spec_tubes_incl_mass', `comment`='Specimen tube requiring mass for CCBR', `volume_unit`=''
WHERE `sample_control_id`=(SELECT `id` FROM sample_controls WHERE `sample_type`='stool' AND `sample_category`='specimen' AND `detail_form_alias`='sd_spe_stools,specimens' AND `detail_tablename`='sd_spe_stools')
AND `aliquot_type`='tube'
AND `detail_tablename`='ad_tubes';	 	 	

INSERT INTO structure_value_domains (`domain_name`, `override`) VALUES
('mass_unit', 'open');
	
INSERT INTO structure_permissible_values (`value`, `language_alias`) VALUES
('g', 'g'),
('mg', 'mg'),
('ug', 'ug');

INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`, `use_as_input`) VALUES
((SELECT `id` FROM structure_value_domains WHERE `domain_name`='mass_unit'), 
 (SELECT `id` FROM structure_permissible_values WHERE `value`='mg' AND `language_alias`='mg'), 1, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name`='mass_unit'), 
 (SELECT `id` FROM structure_permissible_values WHERE `value`='ug' AND `language_alias`='ug'), 2, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name`='mass_unit'), 
 (SELECT `id` FROM structure_permissible_values WHERE `value`='g' AND `language_alias`='g'), 3, 1, 1);

INSERT INTO structures (`alias`) VALUES ('ad_ccbr_spec_tubes_incl_mass'); 
 
INSERT INTO structure_fields 
(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `structure_value_domain`, `language_help`, 
`validation_control`, `value_domain_control`, `field_control`, `flag_confidential`)
VALUES
('InventoryManagement', 'AliquotDetail', 'ad_tubes', 'mass', 'mass', '', 'float', 'size=7', NULL, 'help_mass', 
'open', 'open', 'open', 0),
('InventoryManagement', 'AliquotDetail', 'ad_tubes', 'mass_unit', '', '', 'select', '', (SELECT `id` FROM structure_value_domains WHERE `domain_name`='mass_unit'), 'help_mass_unit', 
'open', 'open', 'open', 0);

INSERT INTO structure_formats
(`structure_id`, `structure_field_id`, 
 `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, 
 `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`,  `flag_override_default`, `default`, 
 `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, 
 `flag_editgrid`, `flag_editgrid_readonly`, `flag_summary`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_float`, 
 `margin` ) VALUES
((SELECT `id` FROM structures WHERE `alias`='ad_ccbr_spec_tubes_incl_mass'),
 (SELECT `id` FROM structure_fields WHERE `plugin`='InventoryManagement' AND `model`='AliquotDetail' AND `tablename`='ad_tubes' AND `field`='mass'),
 1, 79, '', 0, '', 0, '',
 0, '', 0, '', 0, '', 0, '',
 1, 0, 1, 0, 1, 0, 1, 0, 
 1, 0, 1, 0, 0, 1, 1, 0, 
 0),
((SELECT `id` FROM structures WHERE `alias`='ad_ccbr_spec_tubes_incl_mass'),
 (SELECT `id` FROM structure_fields WHERE `plugin`='InventoryManagement' AND `model`='AliquotDetail' AND `tablename`='ad_tubes' AND `field`='mass_unit'),
 1, 80, '', 0, '', 0, '',
 0, '', 0, '', 0, '', 0, '',
 1, 0, 1, 0, 1, 0, 1, 0, 
 1, 0, 1, 0, 0, 1, 1, 0, 
 0);
 
REPLACE INTO i18n (`id`, `en`) VALUES
('mass', 'Mass'),
('g',  'g'),
('ug', 'ug'),
('mg', 'mg'); 


--  =========================================================================
--	Issue: #3241 - Remove DNA and RNA as direct derivatives for CSF
--  BB-57
--  =========================================================================

UPDATE parent_to_derivative_sample_controls
SET `flag_active`=0
WHERE `parent_sample_control_id`=(SELECT `id` FROM sample_controls WHERE `sample_type`='csf' AND `sample_category`='specimen' AND `detail_tablename`='sd_spe_csfs')
AND `derivative_sample_control_id`=(SELECT `id` FROM sample_controls WHERE `sample_type`='dna' AND `sample_category`='derivative' AND `detail_tablename`='sd_der_dnas');

UPDATE parent_to_derivative_sample_controls
SET `flag_active`=0
WHERE `parent_sample_control_id`=(SELECT `id` FROM sample_controls WHERE `sample_type`='csf' AND `sample_category`='specimen' AND `detail_tablename`='sd_spe_csfs')
AND `derivative_sample_control_id`=(SELECT `id` FROM sample_controls WHERE `sample_type`='rna' AND `sample_category`='derivative' AND `detail_tablename`='sd_der_rnas');

 
--  =========================================================================
--	Eventum ID: #XXXX - Enable barcode searching at the search page
--	=========================================================================

/*
INSERT INTO structure_formats (`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`,
`flag_override_label`, `flag_override_tag`, `flag_override_help`, `flag_override_type`, `flag_override_setting`, `flag_override_default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_summary`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_float`, `margin`) VALUES
((SELECT `id` FROM structures WHERE `alias`='participants'), (SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='MiscIdentifier' AND `tablename`='misc_identifiers' AND `field`='identifier_value' AND `type`='input'), 1, 10, '',
 0, 0, 0, 0, 0,
 0, 0, 0, 0, 0, 1,
 0, 0, 0, 0, 0, 0,
 0, 0, 0, 0, 0);


INSERT INTO structure_formats (`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`,
`flag_override_label`, `flag_override_tag`, `flag_override_help`, `flag_override_type`, `flag_override_setting`, `flag_override_default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_summary`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_float`, `margin`) VALUES
((SELECT `id` FROM structures WHERE `alias`='view_collection'), (SELECT `id` FROM structure_fields WHERE `plugin`='InventoryManagement' AND `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='barcode' AND `type`='input'), 1, 10, '',
 0, 0, 0, 0, 0,
 0, 0, 0, 0, 0, 1,
 0, 0, 0, 0, 0, 0,
 0, 0, 0, 0, 0); */