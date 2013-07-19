-- CCBR Customization Script
-- Version: v0.93
-- ATiM Version: v2.5.1
-- Notes: Run against an upgraded v2.5.1 CCBR installation. Minor patch to change layout of sample/aliquot forms

-- Update bank name for version tracking during customization
REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('core_installname', 'Child and Family Research Institute - CCBR v0.93', '');
	
--  --------------------------------------------------------------------------
--	EVENTUM ISSUE: #2506 - Update Blood Aliquot Form
--	--------------------------------------------------------------------------

-- Hide volume fields
UPDATE structure_formats SET `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_spec_tubes_incl_ml_vol') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='current_volume' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_spec_tubes_incl_ml_vol') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='initial_volume' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- Hide volume unit
UPDATE structure_formats SET `flag_add`='0', `flag_add_readonly`='0', `flag_edit`='0', `flag_edit_readonly`='0', `flag_addgrid`='0', `flag_addgrid_readonly`='0', `flag_editgrid`='0', `flag_editgrid_readonly`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_spec_tubes_incl_ml_vol') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotControl' AND `tablename`='aliquot_controls' AND `field`='volume_unit' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_volume_unit') AND `flag_confidential`='0');

-- Add cell count fields to blood tube aliquot
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ad_spec_tubes_incl_ml_vol'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='' AND `field`='cell_count' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='cell count' AND `language_tag`=''), '1', '451', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES
((SELECT id FROM structures WHERE alias='ad_spec_tubes_incl_ml_vol'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='' AND `field`='cell_count_unit' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='cell_count_unit')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`=''), '1', '452', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0');

UPDATE structure_formats SET `flag_override_label`='0', `language_label`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_ccbr_spec_tubes_incl_cell_count') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='' AND `field`='cell_count_unit' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='cell_count_unit') AND `flag_confidential`='0');

--  --------------------------------------------------------------------------
--	EVENTUM ISSUE: #2507 - Update Blood Sample Form
--	--------------------------------------------------------------------------

-- Alter blood tube type to match CCBR
UPDATE structure_value_domains AS svd INNER JOIN structure_value_domains_permissible_values AS svdpv ON svdpv.structure_value_domain_id=svd.id INNER JOIN structure_permissible_values AS spv ON spv.id=svdpv.structure_permissible_value_id SET `flag_active`="0" WHERE svd.domain_name='blood_type' AND spv.id=(SELECT id FROM structure_permissible_values WHERE value="gel CSA" AND language_alias="gel CSA");
UPDATE structure_value_domains AS svd INNER JOIN structure_value_domains_permissible_values AS svdpv ON svdpv.structure_value_domain_id=svd.id INNER JOIN structure_permissible_values AS spv ON spv.id=svdpv.structure_permissible_value_id SET `flag_active`="0" WHERE svd.domain_name='blood_type' AND spv.id=(SELECT id FROM structure_permissible_values WHERE value="heparin" AND language_alias="heparin");
UPDATE structure_value_domains AS svd INNER JOIN structure_value_domains_permissible_values AS svdpv ON svdpv.structure_value_domain_id=svd.id INNER JOIN structure_permissible_values AS spv ON spv.id=svdpv.structure_permissible_value_id SET `flag_active`="0" WHERE svd.domain_name='blood_type' AND spv.id=(SELECT id FROM structure_permissible_values WHERE value="paxgene" AND language_alias="paxgene");
UPDATE structure_value_domains AS svd INNER JOIN structure_value_domains_permissible_values AS svdpv ON svdpv.structure_value_domain_id=svd.id INNER JOIN structure_permissible_values AS spv ON spv.id=svdpv.structure_permissible_value_id SET `flag_active`="0" WHERE svd.domain_name='blood_type' AND spv.id=(SELECT id FROM structure_permissible_values WHERE value="unknown" AND language_alias="unknown");
UPDATE structure_value_domains AS svd INNER JOIN structure_value_domains_permissible_values AS svdpv ON svdpv.structure_value_domain_id=svd.id INNER JOIN structure_permissible_values AS spv ON spv.id=svdpv.structure_permissible_value_id SET `flag_active`="0" WHERE svd.domain_name='blood_type' AND spv.id=(SELECT id FROM structure_permissible_values WHERE value="ZCSA" AND language_alias="ZCSA");
UPDATE structure_value_domains AS svd INNER JOIN structure_value_domains_permissible_values AS svdpv ON svdpv.structure_value_domain_id=svd.id INNER JOIN structure_permissible_values AS spv ON spv.id=svdpv.structure_permissible_value_id SET `flag_active`="0" WHERE svd.domain_name='blood_type' AND spv.id=(SELECT id FROM structure_permissible_values WHERE value="titrate" AND language_alias="ccbr titrate");

INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="blood_type"), (SELECT id FROM structure_permissible_values WHERE value="citrate" AND language_alias="ccbr citrate"), "8", "1");

-- Hide number of collected tubes field
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_spe_bloods') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='' AND `field`='collected_tube_nbr' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- Change order of tube type for consistancy
UPDATE structure_formats SET `display_order`='441' WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_spe_bone_marrows') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_spe_bone_marrows' AND `field`='ccbr_tube_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ccbr_bm_tube_type') AND `flag_confidential`='0');

-- Lang aliases
REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('blood tube type', 'Tube Type', '');
	
--  --------------------------------------------------------------------------
--	EVENTUM ISSUE: #2515 - Sample code - must be required field
--	--------------------------------------------------------------------------
	
INSERT INTO `structure_validations` (`structure_field_id`, `rule`) VALUES ((SELECT id FROM structure_fields where field = 'sample_code' AND model = 'SampleMaster'), 'notEmpty');

--  --------------------------------------------------------------------------
--	EVENTUM ISSUE: #2516 - Update blood tube type to match bone marrow tubes
--	--------------------------------------------------------------------------

UPDATE structure_value_domains AS svd INNER JOIN structure_value_domains_permissible_values AS svdpv ON svdpv.structure_value_domain_id=svd.id INNER JOIN structure_permissible_values AS spv ON spv.id=svdpv.structure_permissible_value_id SET `flag_active`="0" WHERE svd.domain_name='blood_type' AND spv.id=(SELECT id FROM structure_permissible_values WHERE value="gel CSA" AND language_alias="gel CSA");
UPDATE structure_value_domains AS svd INNER JOIN structure_value_domains_permissible_values AS svdpv ON svdpv.structure_value_domain_id=svd.id INNER JOIN structure_permissible_values AS spv ON spv.id=svdpv.structure_permissible_value_id SET `flag_active`="0" WHERE svd.domain_name='blood_type' AND spv.id=(SELECT id FROM structure_permissible_values WHERE value="heparin" AND language_alias="heparin");
UPDATE structure_value_domains AS svd INNER JOIN structure_value_domains_permissible_values AS svdpv ON svdpv.structure_value_domain_id=svd.id INNER JOIN structure_permissible_values AS spv ON spv.id=svdpv.structure_permissible_value_id SET `flag_active`="0" WHERE svd.domain_name='blood_type' AND spv.id=(SELECT id FROM structure_permissible_values WHERE value="paxgene" AND language_alias="paxgene");
UPDATE structure_value_domains AS svd INNER JOIN structure_value_domains_permissible_values AS svdpv ON svdpv.structure_value_domain_id=svd.id INNER JOIN structure_permissible_values AS spv ON spv.id=svdpv.structure_permissible_value_id SET `flag_active`="0" WHERE svd.domain_name='blood_type' AND spv.id=(SELECT id FROM structure_permissible_values WHERE value="ZCSA" AND language_alias="ZCSA");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="blood_type"), (SELECT id FROM structure_permissible_values WHERE value="citrate" AND language_alias="ccbr citrate"), "8", "1");

REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('ccbr citrate', 'Citrate', '');

--  --------------------------------------------------------------------------
--	EVENTUM ISSUE: #2520 - Turn off PBMC derivative from blood
--	--------------------------------------------------------------------------

UPDATE parent_to_derivative_sample_controls SET flag_active=false WHERE id IN(4);

--  --------------------------------------------------------------------------
--	EVENTUM ISSUE: #2521 - Enable Blood -> Blood Cells -> DNA
--	--------------------------------------------------------------------------	

UPDATE parent_to_derivative_sample_controls SET flag_active=true WHERE id IN(3);
UPDATE parent_to_derivative_sample_controls SET flag_active=false WHERE id IN(119, 16);

--  --------------------------------------------------------------------------
--	EVENTUM ISSUE: #2519 - Enable Blood Cells from Bone Marrow
--	--------------------------------------------------------------------------	

INSERT INTO `parent_to_derivative_sample_controls` (`parent_sample_control_id`, `derivative_sample_control_id`, `flag_active`) VALUES ('120', '7', '1');


--  --------------------------------------------------------------------------
--	EVENTUM ISSUE: #2528 - Unable to search by Verbal Consent
--	--------------------------------------------------------------------------
	
UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='cd_ccbr_consents') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_ccbr_consents' AND `field`='ccbr_verbal_consent' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ccbr_consent_status') AND `flag_confidential`='0');

--  --------------------------------------------------------------------------
--	EVENTUM ISSUE: #2646 - Consent form - Enable all search flags
--	--------------------------------------------------------------------------

UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='cd_ccbr_consents') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_ccbr_consents' AND `field`='ccbr_consent_blood_donation' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ccbr_consent_yesnona') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='cd_ccbr_consents') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_ccbr_consents' AND `field`='ccbr_consent_international_research' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ccbr_consent_yesnona') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='cd_ccbr_consents') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_ccbr_consents' AND `field`='ccbr_consent_any_research' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ccbr_consent_yesnona') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='cd_ccbr_consents') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_ccbr_consents' AND `field`='ccbr_withdrawal_samples' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yesno') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='cd_ccbr_consents') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_ccbr_consents' AND `field`='ccbr_consent_stem_cells' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ccbr_consent_yesnona') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='cd_ccbr_consents') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_ccbr_consents' AND `field`='ccbr_withdraw_all_samples' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yesno') AND `flag_confidential`='0');

