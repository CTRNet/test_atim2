-- TFRI AML/MDS Custom Script
-- Version: v0.6
-- ATiM Version: v2.5.4

-- Update bank name for version tracking during customization
REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('core_installname', 'TFRI MDS-AML v0.6 DEV', '');
	
/*
	Eventum Issue: #2913 Followup 6 Month - KPS dropdown
*/

ALTER TABLE `ed_tfri_clinical_section_2` 
CHANGE COLUMN `karnofsky_performance_3month` `karnofsky_performance_3month` VARCHAR(100) NULL DEFAULT NULL ,
CHANGE COLUMN `karnofsky_performance_6month` `karnofsky_performance_6month` VARCHAR(100) NULL DEFAULT NULL ;
ALTER TABLE `ed_tfri_clinical_section_2_revs` 
CHANGE COLUMN `karnofsky_performance_3month` `karnofsky_performance_3month` VARCHAR(100) NULL DEFAULT NULL ,
CHANGE COLUMN `karnofsky_performance_6month` `karnofsky_performance_6month` VARCHAR(100) NULL DEFAULT NULL ;

ALTER TABLE `ed_tfri_clinical_section_1` 
CHANGE COLUMN `karnofsky_performance_baseline` `karnofsky_performance_baseline` VARCHAR(100) NULL DEFAULT NULL ;
ALTER TABLE `ed_tfri_clinical_section_1_revs` 
CHANGE COLUMN `karnofsky_performance_baseline` `karnofsky_performance_baseline` VARCHAR(100) NULL DEFAULT NULL ;


UPDATE structure_fields SET  `type`='select',  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='kps_options')  WHERE model='EventDetail' AND tablename='ed_tfri_clinical_section_2' AND field='karnofsky_performance_3month' AND `type`='integer' AND structure_value_domain  IS NULL ;
UPDATE structure_fields SET  `type`='select',  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='kps_options')  WHERE model='EventDetail' AND tablename='ed_tfri_clinical_section_2' AND field='karnofsky_performance_6month' AND `type`='integer' AND structure_value_domain  IS NULL ;


/*
	Eventum Issue: #2914 Sample master - Collection to reception
*/

UPDATE structure_formats SET `flag_index`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='specimens') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='view_samples' AND `field`='coll_to_rec_spent_time_msg' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='specimens') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='view_samples' AND `field`='coll_to_rec_spent_time_msg' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');


/*
	Eventum Issue: #2872 Clinical Annotation Sub menu
*/

UPDATE `menus` SET `language_title`='lab reports', `language_description`='lab reports' WHERE `id`='clin_CAN_28';
REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('lab reports', 'Lab (Clinical Lab Source Documents)', '');


/*
	Eventum Issue: #2915 Treatment - Chemotherapy 1st version
*/

-- Change menu option to match naming convention
UPDATE `treatment_controls` SET `tx_method`='Section 6: chemotherapy' WHERE `id`='1';
UPDATE `treatment_controls` SET `tx_method`='Section 7: radiation' WHERE `id`='2';

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
 ('mds aml', 'MDS/AML', ''),
 ('Section 6: chemotherapy', 'Section 6: Chemotherapy', ''),
 ('Section 7: radiation', 'Section 7: Radiation', '');

-- Hide master field - Date started
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='treatmentmasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='start_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- Disable default chemo fields
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='txd_chemos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='tx_intent' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='intent') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='txd_chemos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='finish_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='txd_chemos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='facility' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='facility') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='txd_chemos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='information_source' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='information_source') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='txd_chemos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='protocol_master_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='protocol_site_list') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='txd_chemos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_chemos' AND `field`='chemo_completed' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yesno') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='txd_chemos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_chemos' AND `field`='response' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='response') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='txd_chemos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_chemos' AND `field`='num_cycles' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='txd_chemos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_chemos' AND `field`='length_cycles' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='txd_chemos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_chemos' AND `field`='completed_cycles' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- Add fields to chemo detail
ALTER TABLE `txd_chemos` 
ADD COLUMN `followup_period` VARCHAR(45) NULL AFTER `completed_cycles`;
ALTER TABLE `txd_chemos_revs` 
ADD COLUMN `followup_period` VARCHAR(45) NULL AFTER `completed_cycles`;

-- Extend table fields
ALTER TABLE `txe_chemos` 
ADD COLUMN `dose_units` VARCHAR(45) NULL DEFAULT NULL AFTER `dose`,
ADD COLUMN `frequency` VARCHAR(45) NULL AFTER `dose_units`,
ADD COLUMN `freq_custom_days_period` VARCHAR(45) NULL DEFAULT NULL AFTER `frequency`,
ADD COLUMN `freq_other` VARCHAR(45) NULL DEFAULT NULL AFTER `freq_custom_days_period`,
ADD COLUMN `therapy_start_date` DATE NULL DEFAULT NULL AFTER `freq_other`,
ADD COLUMN `therapy_end_date` DATE NULL DEFAULT NULL AFTER `therapy_start_date`,
ADD COLUMN `therapy_reason` VARCHAR(150) NULL DEFAULT NULL AFTER `therapy_end_date`,
ADD COLUMN `part_clinical_trial` VARCHAR(10) NULL DEFAULT NULL AFTER `therapy_reason`;

ALTER TABLE `txe_chemos_revs` 
ADD COLUMN `dose_units` VARCHAR(45) NULL DEFAULT NULL AFTER `dose`,
ADD COLUMN `frequency` VARCHAR(45) NULL AFTER `dose_units`,
ADD COLUMN `freq_custom_days_period` VARCHAR(45) NULL DEFAULT NULL AFTER `frequency`,
ADD COLUMN `freq_other` VARCHAR(45) NULL DEFAULT NULL AFTER `freq_custom_days_period`,
ADD COLUMN `therapy_start_date` DATE NULL DEFAULT NULL AFTER `freq_other`,
ADD COLUMN `therapy_end_date` DATE NULL DEFAULT NULL AFTER `therapy_start_date`,
ADD COLUMN `therapy_reason` VARCHAR(150) NULL DEFAULT NULL AFTER `therapy_end_date`,
ADD COLUMN `part_clinical_trial` VARCHAR(10) NULL DEFAULT NULL AFTER `therapy_reason`;

-- Dosage units value domain
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("dose_units", "", "", NULL);
INSERT INTO structure_permissible_values (value, language_alias) VALUES("mg/kg", "mg/kg");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="dose_units"), (SELECT id FROM structure_permissible_values WHERE value="mg/kg" AND language_alias="mg/kg"), "1", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("mg/me2", "mg/me2");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="dose_units"), (SELECT id FROM structure_permissible_values WHERE value="mg/me2" AND language_alias="mg/me2"), "2", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("mg", "mg");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="dose_units"), (SELECT id FROM structure_permissible_values WHERE value="mg" AND language_alias="mg"), "3", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("mls", "mls");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="dose_units"), (SELECT id FROM structure_permissible_values WHERE value="mls" AND language_alias="mls"), "4", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("gm", "gm");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="dose_units"), (SELECT id FROM structure_permissible_values WHERE value="gm" AND language_alias="gm"), "5", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("mcg", "mcg");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="dose_units"), (SELECT id FROM structure_permissible_values WHERE value="mcg" AND language_alias="mcg"), "6", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("drops", "drops");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="dose_units"), (SELECT id FROM structure_permissible_values WHERE value="drops" AND language_alias="drops"), "7", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("puffs", "puffs");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="dose_units"), (SELECT id FROM structure_permissible_values WHERE value="puffs" AND language_alias="puffs"), "8", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("tablet", "tablet");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="dose_units"), (SELECT id FROM structure_permissible_values WHERE value="tablet" AND language_alias="tablet"), "9", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("percent", "percent");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="dose_units"), (SELECT id FROM structure_permissible_values WHERE value="percent" AND language_alias="percent"), "10", "1");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="dose_units"), (SELECT id FROM structure_permissible_values WHERE value="other" AND language_alias="other"), "11", "1");

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
 ('mg/kg', 'mg/kg', ''),
 ('mg/me2', 'mg/me2', ''),
 ('mg', 'mg', ''),
 ('mls', 'mls', ''),
 ('gm', 'gm', ''),
 ('mcg', 'mcg', ''),
 ('drops', 'drops', ''),
 ('puffs', 'puffs', ''), 
 ('tablet', 'tablet', ''), 
 ('percent', 'percent', '');
 
-- Route value domain
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("route_units", "", "", NULL);
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="route_units"), (SELECT id FROM structure_permissible_values WHERE value="po" AND language_alias="po"), "1", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("iv", "iv");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="route_units"), (SELECT id FROM structure_permissible_values WHERE value="iv" AND language_alias="iv"), "2", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("civi", "civi");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="route_units"), (SELECT id FROM structure_permissible_values WHERE value="civi" AND language_alias="civi"), "3", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("sc", "sc");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="route_units"), (SELECT id FROM structure_permissible_values WHERE value="sc" AND language_alias="sc"), "4", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("intrathecal", "intrathecal");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="route_units"), (SELECT id FROM structure_permissible_values WHERE value="intrathecal" AND language_alias="intrathecal"), "5", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("topical", "topical");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="route_units"), (SELECT id FROM structure_permissible_values WHERE value="topical" AND language_alias="topical"), "6", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("inhaled", "inhaled");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="route_units"), (SELECT id FROM structure_permissible_values WHERE value="inhaled" AND language_alias="inhaled"), "7", "1");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="route_units"), (SELECT id FROM structure_permissible_values WHERE value="other" AND language_alias="other"), "8", "1");

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
 ('po', 'PO', ''),
 ('iv', 'IV', ''),
 ('civi', 'CIVI', ''),
 ('sc', 'SC', ''),
 ('intrathecal', 'intrathecal', ''),
 ('topical', 'topical', ''),
 ('inhaled', 'inhaled', '');        

-- Frequency Value domain
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("frequency_options", "", "", NULL);
INSERT INTO structure_permissible_values (value, language_alias) VALUES("od", "od");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="frequency_options"), (SELECT id FROM structure_permissible_values WHERE value="od" AND language_alias="od"), "1", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("bid", "bid");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="frequency_options"), (SELECT id FROM structure_permissible_values WHERE value="bid" AND language_alias="bid"), "2", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("tid", "tid");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="frequency_options"), (SELECT id FROM structure_permissible_values WHERE value="tid" AND language_alias="tid"), "3", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("qid", "qid");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="frequency_options"), (SELECT id FROM structure_permissible_values WHERE value="qid" AND language_alias="qid"), "4", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("eod", "eod");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="frequency_options"), (SELECT id FROM structure_permissible_values WHERE value="eod" AND language_alias="eod"), "5", "1");

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
 ('od', 'OD', ''),
 ('bid', 'BID', ''),
 ('tid', 'TID', ''),
 ('eod', 'EOD', ''),
 ('qid', 'QID', '');

-- Intent Value domain
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("intent_options", "", "", NULL);
INSERT INTO structure_permissible_values (value, language_alias) VALUES("(1) induction", "(1) induction");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="intent_options"), (SELECT id FROM structure_permissible_values WHERE value="(1) induction" AND language_alias="(1) induction"), "1", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("(2) salvage/re-induction", "(2) salvage/re-induction");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="intent_options"), (SELECT id FROM structure_permissible_values WHERE value="(2) salvage/re-induction" AND language_alias="(2) salvage/re-induction"), "2", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("(3) consolidation", "(3) consolidation");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="intent_options"), (SELECT id FROM structure_permissible_values WHERE value="(3) consolidation" AND language_alias="(3) consolidation"), "3", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("(4) treatment", "(4) treatment");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="intent_options"), (SELECT id FROM structure_permissible_values WHERE value="(4) treatment" AND language_alias="(4) treatment"), "4", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("(5) palliation/disease control", "(5) palliation/disease control");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="intent_options"), (SELECT id FROM structure_permissible_values WHERE value="(5) palliation/disease control" AND language_alias="(5) palliation/disease control"), "5", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("(6) treatment of relapse", "(6) treatment of relapse");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="intent_options"), (SELECT id FROM structure_permissible_values WHERE value="(6) treatment of relapse" AND language_alias="(6) treatment of relapse"), "6", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("(7) preparative regimen for autologous or allogeneic HPCT", "(7) preparative regimen for autologous or allogeneic HPCT");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="intent_options"), (SELECT id FROM structure_permissible_values WHERE value="(7) preparative regimen for autologous or allogeneic HPCT" AND language_alias="(7) preparative regimen for autologous or allogeneic HPCT"), "7", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("(8) treatment of new malignancy", "(8) treatment of new malignancy");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="intent_options"), (SELECT id FROM structure_permissible_values WHERE value="(8) treatment of new malignancy" AND language_alias="(8) treatment of new malignancy"), "8", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("(9) other", "(9) other");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="intent_options"), (SELECT id FROM structure_permissible_values WHERE value="(9) other" AND language_alias="(9) other"), "9", "1");

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
 ('(1) induction', '(1) induction', ''),
 ('(2) salvage/re-induction', '(2) salvage/re-induction', ''),
 ('(3) consolidation', '(3) consolidation', ''),
 ('(4) treatment', '(4) treatment', ''),
 ('(5) palliation/disease control', '(5) palliation/disease control', ''),
 ('(6) treatment of relapse', '(6) treatment of relapse', ''),
 ('(7) preparative regimen for autologous or allogeneic HPCT', '(7) preparative regimen for autologous or allogeneic HPCT', ''),
 ('(8) treatment of new malignancy', '(8) treatment of new malignancy', ''), 
 ('(9) other', '(9) other', '');     

-- Add followup period to chemo detail
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'TreatmentDetail', 'txd_chemos', 'followup_period', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='tfri_followup_period') , '0', '', '', '', 'followup period', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='txd_chemos'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_chemos' AND `field`='followup_period' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tfri_followup_period')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='followup period' AND `language_tag`=''), '1', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');

-- Value domain for treatment followup
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("tx_followup_period", "", "", NULL);
INSERT INTO structure_permissible_values (value, language_alias) VALUES("day 0 to month 6", "day 0 to month 6");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="tx_followup_period"), (SELECT id FROM structure_permissible_values WHERE value="day 0 to month 6" AND language_alias="day 0 to month 6"), "1", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("day after month 6 to month 12", "day after month 6 to month 12");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="tx_followup_period"), (SELECT id FROM structure_permissible_values WHERE value="day after month 6 to month 12" AND language_alias="day after month 6 to month 12"), "2", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("day after month 12 to month 18", "day after month 12 to month 18");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="tx_followup_period"), (SELECT id FROM structure_permissible_values WHERE value="day after month 12 to month 18" AND language_alias="day after month 12 to month 18"), "3", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("day after month 18 to month 24", "day after month 18 to month 24");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="tx_followup_period"), (SELECT id FROM structure_permissible_values WHERE value="day after month 18 to month 24" AND language_alias="day after month 18 to month 24"), "4", "1");

UPDATE structure_fields SET  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='tx_followup_period')  WHERE model='TreatmentDetail' AND tablename='txd_chemos' AND field='followup_period' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='tfri_followup_period');

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
 ('day 0 to month 6', 'Day 0 to month 6', ''),
 ('day after month 6 to month 12', 'Day after month 6 to month 12', ''),
 ('day after month 12 to month 18', 'Day after month 12 to month 18', ''),
 ('day after month 18 to month 24', 'Day after month 18 to month 24', '');

-- Extend form customization

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'TreatmentDetail', 'txe_chemos', 'therapy_start_date', 'date',  NULL , '0', '', '', '', 'therapy start date', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'txe_chemos', 'therapy_end_date', 'date',  NULL , '0', '', '', '', 'therapy end date', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'txe_chemos', 'therapy_reason', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='intent_options') , '0', '', '', '', 'therapy reason', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'txe_chemos', 'part_clinical_trial', 'checkbox', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '0', '', '', '', 'part clinical trial', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'txe_chemos', 'dose_units', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='dose_units') , '0', '', '', '', 'dose units', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'txe_chemos', 'frequency', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='frequency_options') , '0', '', '', '', 'frequency', '');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='txe_chemos'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txe_chemos' AND `field`='therapy_start_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='therapy start date' AND `language_tag`=''), '1', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='txe_chemos'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txe_chemos' AND `field`='therapy_end_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='therapy end date' AND `language_tag`=''), '1', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='txe_chemos'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txe_chemos' AND `field`='therapy_reason' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='intent_options')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='therapy reason' AND `language_tag`=''), '1', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='txe_chemos'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txe_chemos' AND `field`='part_clinical_trial' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='part clinical trial' AND `language_tag`=''), '1', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='txe_chemos'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txe_chemos' AND `field`='dose_units' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='dose_units')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='dose units' AND `language_tag`=''), '1', '6', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='txe_chemos'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txe_chemos' AND `field`='frequency' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='frequency_options')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='frequency' AND `language_tag`=''), '1', '8', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0');

UPDATE structure_fields SET  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='route_units')  WHERE model='TreatmentExtend' AND tablename='txe_chemos' AND field='method' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='chemotherapy_method');
UPDATE structure_formats SET `display_order`='5' WHERE structure_id=(SELECT id FROM structures WHERE alias='txe_chemos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentExtend' AND `tablename`='txe_chemos' AND `field`='dose' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='7' WHERE structure_id=(SELECT id FROM structures WHERE alias='txe_chemos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentExtend' AND `tablename`='txe_chemos' AND `field`='method' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='chemotherapy_method') AND `flag_confidential`='0');

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
 ('therapy start date', 'First dose', ''),
 ('therapy end date', 'Last dose', ''),
 ('therapy reason', 'Reason', ''),
 ('part clinical trial', 'Part of clinical trial?', ''),
 ('dose units', 'Units', ''),
 ('method', 'Route', ''),
 ('drug', 'Therapy', ''),
 ('frequency', 'Frequency', '');     

-- Fix extended ordering
UPDATE structure_formats SET `display_order`='6' WHERE structure_id=(SELECT id FROM structures WHERE alias='txe_chemos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentExtend' AND `tablename`='txe_chemos' AND `field`='dose' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='8' WHERE structure_id=(SELECT id FROM structures WHERE alias='txe_chemos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentExtend' AND `tablename`='txe_chemos' AND `field`='method' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='route_units') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='txe_chemos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentExtend' AND `tablename`='txe_chemos' AND `field`='drug_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='drug_list') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='txe_chemos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txe_chemos' AND `field`='therapy_start_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='2' WHERE structure_id=(SELECT id FROM structures WHERE alias='txe_chemos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txe_chemos' AND `field`='therapy_end_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='4' WHERE structure_id=(SELECT id FROM structures WHERE alias='txe_chemos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txe_chemos' AND `field`='therapy_reason' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='intent_options') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='5' WHERE structure_id=(SELECT id FROM structures WHERE alias='txe_chemos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txe_chemos' AND `field`='part_clinical_trial' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='7' WHERE structure_id=(SELECT id FROM structures WHERE alias='txe_chemos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txe_chemos' AND `field`='dose_units' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='dose_units') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='9' WHERE structure_id=(SELECT id FROM structures WHERE alias='txe_chemos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txe_chemos' AND `field`='frequency' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='frequency_options') AND `flag_confidential`='0');

UPDATE structure_fields SET  `model`='TreatmentExtend' WHERE model='TreatmentDetail' AND tablename='txe_chemos' AND field='therapy_start_date' AND `type`='date' AND structure_value_domain  IS NULL ;
UPDATE structure_fields SET  `model`='TreatmentExtend' WHERE model='TreatmentDetail' AND tablename='txe_chemos' AND field='therapy_end_date' AND `type`='date' AND structure_value_domain  IS NULL ;
UPDATE structure_fields SET  `model`='TreatmentExtend',  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='intent_options')  WHERE model='TreatmentDetail' AND tablename='txe_chemos' AND field='therapy_reason' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='intent_options');
UPDATE structure_fields SET  `model`='TreatmentExtend',  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  WHERE model='TreatmentDetail' AND tablename='txe_chemos' AND field='part_clinical_trial' AND `type`='checkbox' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox');
UPDATE structure_fields SET  `model`='TreatmentExtend',  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='dose_units')  WHERE model='TreatmentDetail' AND tablename='txe_chemos' AND field='dose_units' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='dose_units');
UPDATE structure_fields SET  `model`='TreatmentExtend',  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='frequency_options')  WHERE model='TreatmentDetail' AND tablename='txe_chemos' AND field='frequency' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='frequency_options');

/*
	Eventum Issue: #2928 Treatment - Radiotherapy 1st version
*/

-- Enable extended radiation
UPDATE `treatment_controls` SET `extend_tablename`='txe_radiations', `extend_form_alias`='txe_radiations' WHERE `id`='2';

-- Fix extend table keys
ALTER TABLE `txe_radiations` 
DROP FOREIGN KEY `FK_txe_radiations_tx_masters`;
ALTER TABLE `txe_radiations` 
CHANGE COLUMN `tx_master_id` `treatment_master_id` INT(11) NOT NULL ;
ALTER TABLE `txe_radiations` 
ADD CONSTRAINT `FK_txe_radiations_tx_masters`
  FOREIGN KEY (`treatment_master_id`)
  REFERENCES `treatment_masters` (`id`);


-- Disable default radiation fields
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='txd_radiations') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='tx_intent' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='intent') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='txd_radiations') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='finish_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='txd_radiations') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='facility' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='facility') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='txd_radiations') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='information_source' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='information_source') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='txd_radiations') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='protocol_master_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='protocol_site_list') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='txd_radiations') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_radiations' AND `field`='rad_completed' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yesno') AND `flag_confidential`='0');

-- Add fields to radiation detail
ALTER TABLE `txd_radiations` 
ADD COLUMN `followup_period` VARCHAR(45) NULL AFTER `rad_completed`;
ALTER TABLE `txd_radiations_revs` 
ADD COLUMN `followup_period` VARCHAR(45) NULL AFTER `rad_completed`;

-- Extend table fields
ALTER TABLE `txe_radiations` 
ADD COLUMN `dose_start_date` DATE NULL DEFAULT NULL AFTER `completed`,
ADD COLUMN `dose_end_date` DATE NULL DEFAULT NULL AFTER `dose_start_date`,
ADD COLUMN `dose_reason` VARCHAR(150) NULL DEFAULT NULL AFTER `dose_end_date`,
ADD COLUMN `part_clinical_trial` VARCHAR(10) NULL DEFAULT NULL AFTER `dose_reason`,
ADD COLUMN `dose_per_fraction` VARCHAR(10) NULL DEFAULT NULL AFTER `part_clinical_trial`,
ADD COLUMN `location` VARCHAR(45) NULL DEFAULT NULL AFTER `dose_per_fraction`,
ADD COLUMN `location_tumour_specific` VARCHAR(45) NULL DEFAULT NULL AFTER `location`,
ADD COLUMN `freq_custom_days_period` VARCHAR(45) NULL DEFAULT NULL AFTER `location_tumour_specific`,
ADD COLUMN `freq_other` VARCHAR(45) NULL DEFAULT NULL AFTER `freq_custom_days_period`;

ALTER TABLE `txe_radiations_revs` 
ADD COLUMN `dose_start_date` DATE NULL DEFAULT NULL AFTER `completed`,
ADD COLUMN `dose_end_date` DATE NULL DEFAULT NULL AFTER `dose_start_date`,
ADD COLUMN `dose_reason` VARCHAR(150) NULL DEFAULT NULL AFTER `dose_end_date`,
ADD COLUMN `part_clinical_trial` VARCHAR(10) NULL DEFAULT NULL AFTER `dose_reason`,
ADD COLUMN `dose_per_fraction` VARCHAR(10) NULL DEFAULT NULL AFTER `part_clinical_trial`,
ADD COLUMN `location` VARCHAR(45) NULL DEFAULT NULL AFTER `dose_per_fraction`,
ADD COLUMN `location_tumour_specific` VARCHAR(45) NULL DEFAULT NULL AFTER `location`,
ADD COLUMN `freq_custom_days_period` VARCHAR(45) NULL DEFAULT NULL AFTER `location_tumour_specific`,
ADD COLUMN `freq_other` VARCHAR(45) NULL DEFAULT NULL AFTER `freq_custom_days_period`;

-- Detail fields on radiation form
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'TreatmentDetail', 'txd_radiations', 'followup_period', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='tx_followup_period') , '0', '', '', '', 'followup period', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='txd_radiations'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_radiations' AND `field`='followup_period' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tx_followup_period')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='followup period' AND `language_tag`=''), '1', '9', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');

-- Extended radiation form
INSERT INTO structures(`alias`) VALUES ('txe_radiations');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'TreatmentExtend', 'txe_radiations', 'dose_start_date', 'date',  NULL , '0', '', '', '', 'dose start date', ''), 
('ClinicalAnnotation', 'TreatmentExtend', 'txe_radiations', 'dose_end_date', 'date',  NULL , '0', '', '', '', 'dose end date', ''), 
('ClinicalAnnotation', 'TreatmentExtend', 'txe_radiations', 'dose_reason', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='intent_options') , '0', '', '', '', 'dose reason', ''), 
('ClinicalAnnotation', 'TreatmentExtend', 'txe_radiations', 'part_clinical_trial', 'checkbox', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '0', '', '', '', 'part clinical trial', ''), 
('ClinicalAnnotation', 'TreatmentExtend', 'txe_radiations', 'dose_per_fraction', 'input',  NULL , '0', 'size=5', '', '', 'dose per fraction', ''), 
('ClinicalAnnotation', 'TreatmentExtend', 'txe_radiations', 'location_other', 'input',  NULL , '0', 'size=12', '', '', '', 'location other'), 
('ClinicalAnnotation', 'TreatmentExtend', 'txe_radiations', 'frequency', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='frequency_options') , '0', '', '', '', 'frequency', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='txe_radiations'), (SELECT id FROM structure_fields WHERE `model`='TreatmentExtend' AND `tablename`='txe_radiations' AND `field`='dose_start_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='dose start date' AND `language_tag`=''), '1', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='txe_radiations'), (SELECT id FROM structure_fields WHERE `model`='TreatmentExtend' AND `tablename`='txe_radiations' AND `field`='dose_end_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='dose end date' AND `language_tag`=''), '1', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='txe_radiations'), (SELECT id FROM structure_fields WHERE `model`='TreatmentExtend' AND `tablename`='txe_radiations' AND `field`='dose_reason' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='intent_options')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='dose reason' AND `language_tag`=''), '1', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='txe_radiations'), (SELECT id FROM structure_fields WHERE `model`='TreatmentExtend' AND `tablename`='txe_radiations' AND `field`='part_clinical_trial' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='part clinical trial' AND `language_tag`=''), '1', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='txe_radiations'), (SELECT id FROM structure_fields WHERE `model`='TreatmentExtend' AND `tablename`='txe_radiations' AND `field`='dose_per_fraction' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='dose per fraction' AND `language_tag`=''), '1', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='txe_radiations'), (SELECT id FROM structure_fields WHERE `model`='TreatmentExtend' AND `tablename`='txe_radiations' AND `field`='location_other' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=12' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='location other'), '1', '8', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='txe_radiations'), (SELECT id FROM structure_fields WHERE `model`='TreatmentExtend' AND `tablename`='txe_radiations' AND `field`='frequency' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='frequency_options')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='frequency' AND `language_tag`=''), '1', '9', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '1', '0', '0');

-- Value domain for location
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("radiation_location", "", "", NULL);
INSERT INTO structure_permissible_values (value, language_alias) VALUES("tumour specific", "tumour specific");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="radiation_location"), (SELECT id FROM structure_permissible_values WHERE value="tumour specific" AND language_alias="tumour specific"), "1", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("total body", "total body");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="radiation_location"), (SELECT id FROM structure_permissible_values WHERE value="total body" AND language_alias="total body"), "2", "1");

-- Fix other location field
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'TreatmentExtend', 'txe_radiations', 'location_tumour_specific', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='radiation_location') , '0', '', '', '', 'location tumour specific', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='txe_radiations'), (SELECT id FROM structure_fields WHERE `model`='TreatmentExtend' AND `tablename`='txe_radiations' AND `field`='location_tumour_specific' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='radiation_location')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='location tumour specific' AND `language_tag`=''), '1', '7', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '1', '0', '0');

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
 ('dose start date', 'First dose', ''),
 ('dose end date', 'Last dose', ''),
 ('dose reason', 'Reason', ''),
 ('dose per fraction', 'Dose per fraction', '');    

/*
	Eventum Issue: #2927 Profile - Hide system fields
*/
UPDATE structure_formats SET `flag_edit`='0', `flag_edit_readonly`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='created' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_batchedit`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='ids' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_edit`='0', `flag_edit_readonly`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='last_modification' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='tfri_aml_site_number' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='tfri_aml_other_diagnosis' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');


/*
	Eventum Issue: #2926 Disable Whatman Paper Aliquot
*/
UPDATE aliquot_controls SET flag_active=false WHERE id IN(11);


/*
	Eventum Issue: #2925 Label for Collected volume
*/
REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
 ('collected volume', 'Total Collected Volume', '');

/*
	Eventum Issue: #2923 Bank name update 
*/
UPDATE `banks` SET `name`='PMCCLCLB' WHERE `id`='4';

/*
	Eventum Issue: #2921 Profile - Other diagnosis fix
*/
REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
 ('tfri aml other diagnosis', 'If other diagnosis, specify', '');

/*
	Eventum Issue: #2919 Profile - Search form
*/
UPDATE structure_formats SET `flag_search`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='tfri_aml_other_diagnosis' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='tfri_cause_of_death' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tfri_cause_of_death') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='tfri_cause_of_death_other' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

/*
	Eventum Issue: #2929 Barcode - Enable edit mode
*/
UPDATE structure_formats SET `flag_edit_readonly`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='barcode' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');


/*
	Eventum Issue: #2932 Volume collected one decimal place
*/
ALTER TABLE `sd_spe_bloods` 
CHANGE COLUMN `collected_volume` `collected_volume` DECIMAL(10,1) NULL DEFAULT NULL ;
ALTER TABLE `sd_spe_bloods` 
CHANGE COLUMN `collected_volume` `collected_volume` DECIMAL(10,1) NULL DEFAULT NULL ;
ALTER TABLE `sd_spe_bone_marrows` 
CHANGE COLUMN `collected_volume` `collected_volume` DECIMAL(10,1) NULL DEFAULT NULL ;
ALTER TABLE `sd_spe_bone_marrows` 
CHANGE COLUMN `collected_volume` `collected_volume` DECIMAL(10,1) NULL DEFAULT NULL ;


/*
	Eventum Issue: #2936 Baseline - Language updates
*/

UPDATE structure_formats SET `language_heading`='other previous malignancies' WHERE structure_id=(SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_1') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_1' AND `field`='oth_malignancy_leukemia' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') AND `flag_confidential`='0');

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
 ('flt status', 'FLT status', ''),
 ('wbc', '1.20 WBC (10^9/L)', ''),
 ('neutrophils', '1.21 Neutrophils (10^9/L)', ''), 
 ('lymphocytes', '1.22 Lymphocytes (10^9/L)', ''), 
 ('hemoglobin', '1.23 Hemoglobin (10^9/L)', ''), 
 ('hematocrit', '1.24 Hematocrit (10^9/L)', ''), 
 ('platelets', '1.25 Platelets (10^9/L)', ''), 
 ('blasts', '1.26 Blasts (10^9/L)', ''), 
 ('alcohol consumption greater month', '1.39 Alcohol consumption (see website copy of S1 for full text)', ''), 
 ('other previous malignancies', '1.33 Other previous malignancies', ''),
 ('ast sgot date collection', '1.14 Date of Collection', ''),
 ('total bilirubin date collection', '1.16 Date of Collection', ''),
 ('creatinine date collection', '1.18 Date of Collection', ''),
 ('ast sgot', '1.13 AST(SGOT) (U/L)', ''),
 ('total bilirubin', '1.15 Total bilirubin (umol/L)', ''),
 ('creatinine', '1.17 Creatinine (umol/L)', '');


/*
	Eventum Issue: #2941 Baseline 1.6, 1.8, 1.10 Add select list
*/

-- Value domain 
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("genetic_status_options", "", "", NULL);
INSERT INTO structure_permissible_values (value, language_alias) VALUES("POS", "POS");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="genetic_status_options"), (SELECT id FROM structure_permissible_values WHERE value="POS" AND language_alias="POS"), "1", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("NEG", "NEG");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="genetic_status_options"), (SELECT id FROM structure_permissible_values WHERE value="NEG" AND language_alias="NEG"), "2", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("UNK", "UNK");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="genetic_status_options"), (SELECT id FROM structure_permissible_values WHERE value="UNK" AND language_alias="UNK"), "3", "1");

UPDATE structure_fields SET  `type`='select',  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='genetic_status_options') ,  `setting`='' WHERE model='EventDetail' AND tablename='ed_tfri_clinical_section_1' AND field='flt_status_at_dx' AND `type`='input' AND structure_value_domain  IS NULL ;
UPDATE structure_fields SET  `type`='select',  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='genetic_status_options') ,  `setting`='' WHERE model='EventDetail' AND tablename='ed_tfri_clinical_section_1' AND field='npm_status_at_dx' AND `type`='input' AND structure_value_domain  IS NULL ;
UPDATE structure_fields SET  `type`='select',  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='genetic_status_options') ,  `setting`='' WHERE model='EventDetail' AND tablename='ed_tfri_clinical_section_1' AND field='cepba_status_at_dx' AND `type`='input' AND structure_value_domain  IS NULL ;
UPDATE structure_formats SET `language_heading`='other previous malignancies' WHERE structure_id=(SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_1') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_1' AND `field`='oth_malignancy_leukemia' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') AND `flag_confidential`='0');

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
 ('POS', 'POS', ''),
 ('NEG', 'NEG', ''),
 ('UNK', 'UNK', '');
 
/*
	Eventum Issue: #2939 1.6 FLT Status
*/   
 
ALTER TABLE `ed_tfri_clinical_section_1` 
ADD COLUMN `flt_tkd_status_at_dx` VARCHAR(45) NULL DEFAULT NULL AFTER `flt_status_at_dx`;
ALTER TABLE `ed_tfri_clinical_section_1_revs` 
ADD COLUMN `flt_tkd_status_at_dx` VARCHAR(45) NULL DEFAULT NULL AFTER `flt_status_at_dx`;


REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
 ('flt status at dx', '1.6 FLT-3 ITD status at diagnosis', ''),
 ('flt tkd status at dx', '1.6 FLT-3 TKD status at diagnosis', '');
 
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_1', 'flt_tkd_status_at_dx', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='genetic_status_options') , '0', '', '', '', 'flt tkd status at dx', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_1'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_1' AND `field`='flt_tkd_status_at_dx' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='genetic_status_options')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='flt tkd status at dx' AND `language_tag`=''), '1', '84', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'); 


/*
	Eventum Issue: #2933 DCF 9 Hospitalization form first version
*/

INSERT INTO `treatment_controls` (`tx_method`, `disease_site`, `flag_active`, `detail_tablename`, `detail_form_alias`, `extend_tablename`, `extend_form_alias`, `display_order`, `databrowser_label`, `flag_use_for_ccl`) VALUES ('Section 9: Hospitalization', 'mds aml', '1', 'txd_hospitalization', 'txd_hospitalization', 'txe_hospitalization', 'txe_hospitalization', '0', 'all|hospitalization', '0');



