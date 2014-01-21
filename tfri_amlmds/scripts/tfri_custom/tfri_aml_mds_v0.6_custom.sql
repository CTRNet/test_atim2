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
	VALUES ('lab reports', 'Lab Reports', '');


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


/*
	Eventum Issue: #2 Treatment - Radiotherapy 1st version
*/

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

/*
	Eventum Issue: #
*/





/*
	Eventum Issue: #
*/



/*
	Eventum Issue: #
*/