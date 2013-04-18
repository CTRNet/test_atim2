-- NPTTB Custom Script
-- Version: v0.5
-- ATiM Version: v2.5.2

-- Update bank name for version tracking during customization
REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('core_installname', 'Clark H. Smith NPTTB - v0.5 DEV', '');
	
/*
	------------------------------------------------------------
	Eventum ID: 2530 - Update sample types
	------------------------------------------------------------
*/

UPDATE parent_to_derivative_sample_controls SET flag_active=false WHERE id IN(137, 142, 143, 141, 144);


/*
	------------------------------------------------------------
	Eventum ID: 2531 - Inventory blood tube type
	------------------------------------------------------------
*/

UPDATE structure_value_domains AS svd INNER JOIN structure_value_domains_permissible_values AS svdpv ON svdpv.structure_value_domain_id=svd.id INNER JOIN structure_permissible_values AS spv ON spv.id=svdpv.structure_permissible_value_id SET `flag_active`="0" WHERE svd.domain_name='blood_type' AND spv.id=(SELECT id FROM structure_permissible_values WHERE value="gel CSA" AND language_alias="gel CSA");
UPDATE structure_value_domains AS svd INNER JOIN structure_value_domains_permissible_values AS svdpv ON svdpv.structure_value_domain_id=svd.id INNER JOIN structure_permissible_values AS spv ON spv.id=svdpv.structure_permissible_value_id SET `flag_active`="0" WHERE svd.domain_name='blood_type' AND spv.id=(SELECT id FROM structure_permissible_values WHERE value="heparin" AND language_alias="heparin");
UPDATE structure_value_domains AS svd INNER JOIN structure_value_domains_permissible_values AS svdpv ON svdpv.structure_value_domain_id=svd.id INNER JOIN structure_permissible_values AS spv ON spv.id=svdpv.structure_permissible_value_id SET `flag_active`="0" WHERE svd.domain_name='blood_type' AND spv.id=(SELECT id FROM structure_permissible_values WHERE value="paxgene" AND language_alias="paxgene");
UPDATE structure_value_domains AS svd INNER JOIN structure_value_domains_permissible_values AS svdpv ON svdpv.structure_value_domain_id=svd.id INNER JOIN structure_permissible_values AS spv ON spv.id=svdpv.structure_permissible_value_id SET `display_order`="5" WHERE svd.domain_name='blood_type' AND spv.id=(SELECT id FROM structure_permissible_values WHERE value="unknown" AND language_alias="unknown");
UPDATE structure_value_domains AS svd INNER JOIN structure_value_domains_permissible_values AS svdpv ON svdpv.structure_value_domain_id=svd.id INNER JOIN structure_permissible_values AS spv ON spv.id=svdpv.structure_permissible_value_id SET `flag_active`="0" WHERE svd.domain_name='blood_type' AND spv.id=(SELECT id FROM structure_permissible_values WHERE value="ZCSA" AND language_alias="ZCSA");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("ACB", "npttb ACB");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="blood_type"), (SELECT id FROM structure_permissible_values WHERE value="ACD" AND language_alias="npttb ACD"), "1", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("serum", "npttb serum");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="blood_type"), (SELECT id FROM structure_permissible_values WHERE value="serum" AND language_alias="npttb serum"), "4", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("lithium heparin", "npttb lithium heparin");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="blood_type"), (SELECT id FROM structure_permissible_values WHERE value="lithium heparin" AND language_alias="npttb lithium heparin"), "3", "1");

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
 ('npttb ACD', 'ACD', ''),
 ('npttb serum', 'Serum', ''),
 ('npttb lithium heparin', 'Lithium Heparin', '');


/*
	------------------------------------------------------------
	Eventum ID: 2533 - Fix MRN Validation
	------------------------------------------------------------
*/

UPDATE `misc_identifier_controls` SET `reg_exp_validation`='\\A\\d{10}$', `user_readable_format`='is 10 digits' WHERE `misc_identifier_name`='Medical Record Number';


/*
	------------------------------------------------------------
	Eventum ID: 2534 - Rename TTB Identifier
	------------------------------------------------------------
*/

UPDATE `misc_identifier_controls` SET `misc_identifier_name`='TTB Number (Pre-2010)' WHERE `misc_identifier_name`='TTB Number';

REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('TTB Number (Pre-2010)', 'TTB Number (Pre-2010)', '');

	
/*
	------------------------------------------------------------
	Eventum ID: 2538 - Add melanoma to diagnosis drop down
	------------------------------------------------------------
*/
	
INSERT INTO structure_permissible_values (value, language_alias) VALUES("Melanoma", "npttb Melanoma");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_final_diagnosis"), (SELECT id FROM structure_permissible_values WHERE value="Melanoma" AND language_alias="npttb Melanoma"), "36", "1");

REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('npttb Melanoma', 'Melanoma', '');
	
/*
	------------------------------------------------------------
	Eventum ID: 2539 - Disable un-needed clinical events	
	------------------------------------------------------------
*/	

UPDATE `event_controls` SET `flag_active`='0' WHERE `id`='18';
UPDATE `event_controls` SET `flag_active`='0' WHERE `id`='32';
UPDATE `event_controls` SET `flag_active`='0' WHERE `id`='34';
UPDATE `event_controls` SET `flag_active`='0' WHERE `id`='35';
UPDATE `event_controls` SET `flag_active`='0' WHERE `id`='36';
UPDATE `event_controls` SET `flag_active`='0' WHERE `id`='37';
UPDATE `event_controls` SET `flag_active`='0' WHERE `id`='38';
UPDATE `event_controls` SET `flag_active`='0' WHERE `id`='39';
UPDATE `event_controls` SET `flag_active`='0' WHERE `id`='40';
UPDATE `event_controls` SET `flag_active`='0' WHERE `id`='41';
UPDATE `event_controls` SET `flag_active`='0' WHERE `id`='45';
UPDATE `event_controls` SET `flag_active`='0' WHERE `id`='44';
UPDATE `event_controls` SET `flag_active`='0' WHERE `id`='43';
UPDATE `event_controls` SET `flag_active`='0' WHERE `id`='42';
UPDATE `event_controls` SET `flag_active`='0' WHERE `id`='20';
UPDATE `event_controls` SET `flag_active`='0' WHERE `id`='22';

	
/*
	------------------------------------------------------------
	Eventum ID: 2540 - Clinical Form: Tests	
	------------------------------------------------------------
*/

-- Create table, structure and control record
INSERT INTO `event_controls` (`disease_site`, `event_group`, `event_type`, `flag_active`, `detail_form_alias`, `detail_tablename`, `databrowser_label`) VALUES ('npttb', 'clinical', 'tests', '1', 'ed_npttb_clinical_tests', 'ed_npttb_clinical_tests', 'clinical|npttb|tests');

INSERT INTO `structures` (`alias`) VALUES ('ed_npttb_clinical_tests');

CREATE TABLE `ed_npttb_clinical_tests` (
  `npttb_egfr_amplification` varchar(50) default null,
  `npttb_pdgfr_amplification` varchar(50) default null,
  `npttb_egfr_iii` varchar(50) default null,
  `npttb_nfi` varchar(50) default null,
  `npttb_p53` varchar(50) default null,
  `npttb_idh_1_2` varchar(50) default null,
  `npttb_mgmt` varchar(50) default null,
  `npttb_1p_19q` varchar(50) default null,
  `npttb_pten` varchar(50) default null,
  `npttb_braf` varchar(50) default null,
  `npttb_mb_subclass` varchar(50) default null,
  `npttb_gbm_subclass` varchar(50) default null,      
  `event_master_id` int(11) NOT NULL,
  KEY `event_master_id` (`event_master_id`),
  CONSTRAINT `ed_npttb_clinical_tests_ibfk_1` FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `ed_npttb_clinical_tests_revs` (
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `npttb_egfr_amplification` varchar(50) default null,
  `npttb_pdgfr_amplification` varchar(50) default null,
  `npttb_egfr_iii` varchar(50) default null,
  `npttb_nfi` varchar(50) default null,
  `npttb_p53` varchar(50) default null,
  `npttb_idh_1_2` varchar(50) default null,
  `npttb_mgmt` varchar(50) default null,
  `npttb_1p_19q` varchar(50) default null,
  `npttb_pten` varchar(50) default null,
  `npttb_braf` varchar(50) default null,
  `npttb_mb_subclass` varchar(50) default null,
  `npttb_gbm_subclass` varchar(50) default null,      
  `event_master_id` int(11) NOT NULL,
  PRIMARY KEY (`version_id`),
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1; 

-- Create value domain: EGDR Amplification
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("npttb_egfr_amp", "", "", NULL);
INSERT INTO structure_permissible_values (value, language_alias) VALUES("highly amplified", "npttb highly amplified");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_egfr_amp"), (SELECT id FROM structure_permissible_values WHERE value="highly amplified" AND language_alias="npttb highly amplified"), "1", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("abnormal- not amplified", "npttb abnormal - not amplified");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_egfr_amp"), (SELECT id FROM structure_permissible_values WHERE value="abnormal- not amplified" AND language_alias="npttb abnormal - not amplified"), "2", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("normal", "npttb normal");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_egfr_amp"), (SELECT id FROM structure_permissible_values WHERE value="normal" AND language_alias="npttb normal"), "3", "1");

-- Create value domain: PDGFR Amplification
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("npttb_pdgfr_amp", "", "", NULL);
INSERT INTO structure_permissible_values (value, language_alias) VALUES("highly amplified", "npttb highly amplified");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_pdgfr_amp"), (SELECT id FROM structure_permissible_values WHERE value="highly amplified" AND language_alias="npttb highly amplified"), "1", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("abnormal - not amplified", "npttb abnormal - not amplified");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_pdgfr_amp"), (SELECT id FROM structure_permissible_values WHERE value="abnormal - not amplified" AND language_alias="npttb abnormal - not amplified"), "2", "1");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_pdgfr_amp"), (SELECT id FROM structure_permissible_values WHERE value="normal" AND language_alias="npttb normal"), "3", "1");

-- Create value domain: EGFR III
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("npttb_egfr_iii", "", "", NULL);
INSERT INTO structure_permissible_values (value, language_alias) VALUES("present", "npttb present");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_egfr_iii"), (SELECT id FROM structure_permissible_values WHERE value="present" AND language_alias="npttb present"), "1", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("absent", "npttb absent");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_egfr_iii"), (SELECT id FROM structure_permissible_values WHERE value="absent" AND language_alias="npttb absent"), "2", "1");

-- Create value domain: NFI
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("npttb_nfi", "", "", NULL);
INSERT INTO structure_permissible_values (value, language_alias) VALUES("loss", "npttb loss");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_nfi"), (SELECT id FROM structure_permissible_values WHERE value="loss" AND language_alias="npttb loss"), "1", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("mutation", "npttb mutation");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_nfi"), (SELECT id FROM structure_permissible_values WHERE value="mutation" AND language_alias="npttb mutation"), "2", "1");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_nfi"), (SELECT id FROM structure_permissible_values WHERE value="normal" AND language_alias="npttb normal"), "3", "1");

-- Create value domain: p53
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("npttb_p53", "", "", NULL);
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_p53"), (SELECT id FROM structure_permissible_values WHERE value="normal" AND language_alias="npttb normal"), "2", "1");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_p53"), (SELECT id FROM structure_permissible_values WHERE value="mutation" AND language_alias="npttb mutation"), "1", "1");

-- Create value domain: IDH 1/2
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("npttb_idh-1_2", "", "", NULL);
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_idh-1_2"), (SELECT id FROM structure_permissible_values WHERE value="mutation" AND language_alias="npttb mutation"), "1", "1");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_idh-1_2"), (SELECT id FROM structure_permissible_values WHERE value="normal" AND language_alias="npttb normal"), "2", "1");

-- Create value domain: MGMT
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("npttb_mgmt", "", "", NULL);
INSERT INTO structure_permissible_values (value, language_alias) VALUES("methylated", "npttb methylated");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_mgmt"), (SELECT id FROM structure_permissible_values WHERE value="methylated" AND language_alias="npttb methylated"), "1", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("unmethylated", "npttb unmethylated");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_mgmt"), (SELECT id FROM structure_permissible_values WHERE value="unmethylated" AND language_alias="npttb unmethylated"), "2", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("unknown", "npttb unknown");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_mgmt"), (SELECT id FROM structure_permissible_values WHERE value="unknown" AND language_alias="npttb unknown"), "3", "1");

-- Create value domain: 1p/19q
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("npttb_1p_19q", "", "", NULL);
INSERT INTO structure_permissible_values (value, language_alias) VALUES("co-deleted", "npttb co-deleted");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_1p_19q"), (SELECT id FROM structure_permissible_values WHERE value="co-deleted" AND language_alias="npttb co-deleted"), "1", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("1p loss only", "npttb 1p loss only");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_1p_19q"), (SELECT id FROM structure_permissible_values WHERE value="1p loss only" AND language_alias="npttb 1p loss only"), "2", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("19q loss only", "npttb 19q loss only");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_1p_19q"), (SELECT id FROM structure_permissible_values WHERE value="19q loss only" AND language_alias="npttb 19q loss only"), "3", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("no 19q loss", "npttb no 19q loss");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_1p_19q"), (SELECT id FROM structure_permissible_values WHERE value="no 19q loss" AND language_alias="npttb no 19q loss"), "4", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("no 19q polyploidy", "npttb 19q polyploidy");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_1p_19q"), (SELECT id FROM structure_permissible_values WHERE value="no 19q polyploidy" AND language_alias="npttb 19q polyploidy"), "5", "1");

-- Create value domain: PTEN
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("npttb_pten", "", "", NULL);
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_pten"), (SELECT id FROM structure_permissible_values WHERE value="loss" AND language_alias="npttb loss"), "1", "1");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_pten"), (SELECT id FROM structure_permissible_values WHERE value="normal" AND language_alias="npttb normal"), "2", "1");

-- Create value domain: BRAF
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("npttb_braf", "", "", NULL);
INSERT INTO structure_permissible_values (value, language_alias) VALUES("V600E", "npttb V600E");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_braf"), (SELECT id FROM structure_permissible_values WHERE value="V600E" AND language_alias="npttb V600E"), "1", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("rearrangement", "npttb rearrangement");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_braf"), (SELECT id FROM structure_permissible_values WHERE value="rearrangement" AND language_alias="npttb rearrangement"), "2", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("other mutation", "npttb other mutation");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_braf"), (SELECT id FROM structure_permissible_values WHERE value="other mutation" AND language_alias="npttb other mutation"), "3", "1");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_braf"), (SELECT id FROM structure_permissible_values WHERE value="normal" AND language_alias="npttb normal"), "4", "1");

-- Create value domain: GBM Subclass
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("npttb_gbm_subclass", "", "", NULL);
INSERT INTO structure_permissible_values (value, language_alias) VALUES("proneural", "npttb proneural");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_gbm_subclass"), (SELECT id FROM structure_permissible_values WHERE value="proneural" AND language_alias="npttb proneural"), "1", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("neural", "npttb neural");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_gbm_subclass"), (SELECT id FROM structure_permissible_values WHERE value="neural" AND language_alias="npttb neural"), "2", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("classical", "npttb classical");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_gbm_subclass"), (SELECT id FROM structure_permissible_values WHERE value="classical" AND language_alias="npttb classical"), "3", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("mesenchymal", "npttb mesenchymal");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_gbm_subclass"), (SELECT id FROM structure_permissible_values WHERE value="mesenchymal" AND language_alias="npttb mesenchymal"), "4", "1");

-- Create value domain: MB Subclass
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("npttb_mb_subclass", "", "", NULL);
INSERT INTO structure_permissible_values (value, language_alias) VALUES("SHH", "npttb SHH");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_mb_subclass"), (SELECT id FROM structure_permissible_values WHERE value="SHH" AND language_alias="npttb SHH"), "1", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("WNT", "npttb WNT");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_mb_subclass"), (SELECT id FROM structure_permissible_values WHERE value="WNT" AND language_alias="npttb WNT"), "2", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("group C", "npttb group C");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_mb_subclass"), (SELECT id FROM structure_permissible_values WHERE value="group C" AND language_alias="npttb group C"), "3", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("group D", "npttb group D");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_mb_subclass"), (SELECT id FROM structure_permissible_values WHERE value="group D" AND language_alias="npttb group D"), "4", "1");

-- Build form
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', 'ed_npttb_clinical_tests', 'npttb_egfr_amplification', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='npttb_egfr_amp') , '0', '', '', '', 'npttb egfr amplification', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ed_npttb_clinical_tests'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_npttb_clinical_tests' AND `field`='npttb_egfr_amplification' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='npttb_egfr_amp')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='npttb egfr amplification' AND `language_tag`=''), '1', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', 'ed_npttb_clinical_tests', 'npttb_pdgfr_amplification', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='npttb_pdgfr_amp') , '0', '', '', '', 'npttb pdgfr amplification', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_npttb_clinical_tests', 'npttb_egfr_iii', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='npttb_egfr_iii') , '0', '', '', '', 'npttb egfr iii', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_npttb_clinical_tests', 'npttb_nfi', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='npttb_nfi') , '0', '', '', '', 'npttb nfi', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_npttb_clinical_tests', 'npttb_p53', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='npttb_p53') , '0', '', '', '', 'npttb p53', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_npttb_clinical_tests', 'npttb_idh_1_2', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='npttb_idh-1_2') , '0', '', '', '', 'npttb idh 1 2', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_npttb_clinical_tests', 'npttb_mgmt', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='npttb_mgmt') , '0', '', '', '', 'npttb mgmt', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_npttb_clinical_tests', 'npttb_1p_19q', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='npttb_1p_19q') , '0', '', '', '', 'npttb 1p 19q', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_npttb_clinical_tests', 'npttb_pten', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='npttb_pten') , '0', '', '', '', 'npttb pten', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_npttb_clinical_tests', 'npttb_braf', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='npttb_braf') , '0', '', '', '', 'npttb braf', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_npttb_clinical_tests', 'npttb_mb_subclass', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='npttb_mb_subclass') , '0', '', '', '', 'npttb mb subclass', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_npttb_clinical_tests', 'npttb_gbm_subclass', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='npttb_gbm_subclass') , '0', '', '', '', 'npttb gbm subclass', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ed_npttb_clinical_tests'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_npttb_clinical_tests' AND `field`='npttb_pdgfr_amplification' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='npttb_pdgfr_amp')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='npttb pdgfr amplification' AND `language_tag`=''), '1', '8', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_npttb_clinical_tests'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_npttb_clinical_tests' AND `field`='npttb_egfr_iii' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='npttb_egfr_iii')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='npttb egfr iii' AND `language_tag`=''), '1', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_npttb_clinical_tests'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_npttb_clinical_tests' AND `field`='npttb_nfi' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='npttb_nfi')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='npttb nfi' AND `language_tag`=''), '1', '12', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_npttb_clinical_tests'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_npttb_clinical_tests' AND `field`='npttb_p53' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='npttb_p53')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='npttb p53' AND `language_tag`=''), '1', '14', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_npttb_clinical_tests'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_npttb_clinical_tests' AND `field`='npttb_idh_1_2' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='npttb_idh-1_2')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='npttb idh 1 2' AND `language_tag`=''), '1', '16', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_npttb_clinical_tests'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_npttb_clinical_tests' AND `field`='npttb_mgmt' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='npttb_mgmt')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='npttb mgmt' AND `language_tag`=''), '1', '18', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_npttb_clinical_tests'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_npttb_clinical_tests' AND `field`='npttb_1p_19q' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='npttb_1p_19q')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='npttb 1p 19q' AND `language_tag`=''), '1', '20', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_npttb_clinical_tests'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_npttb_clinical_tests' AND `field`='npttb_pten' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='npttb_pten')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='npttb pten' AND `language_tag`=''), '1', '22', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_npttb_clinical_tests'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_npttb_clinical_tests' AND `field`='npttb_braf' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='npttb_braf')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='npttb braf' AND `language_tag`=''), '1', '24', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_npttb_clinical_tests'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_npttb_clinical_tests' AND `field`='npttb_mb_subclass' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='npttb_mb_subclass')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='npttb mb subclass' AND `language_tag`=''), '1', '26', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_npttb_clinical_tests'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_npttb_clinical_tests' AND `field`='npttb_gbm_subclass' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='npttb_gbm_subclass')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='npttb gbm subclass' AND `language_tag`=''), '1', '28', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');

-- Language Updates
REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
	('tests', 'Clinical Tests', '');

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
	('npttb', 'NPTTB', '');		

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
	('npttb egfr amplification', 'EGFR Amplification', ''),
	('npttb pdgfr amplification', 'PDGFR Amplification', ''),
	('npttb egfr iii', 'EGFR III', ''),
	('npttb nfi', 'NFI', ''),
	('npttb p53', 'p53', ''),
	('npttb idh 1 2', "IDH 1/2", ''),
	('npttb mgmt', 'MGMT', ''),
	('npttb 1p 19q', "1p/19q", ''),
	('npttb pten', 'PTEN', ''),
	('npttb braf', 'BRAF', ''),
	('npttb mb subclass', 'MB Subclass', ''),
	('npttb gbm subclass', 'GBM Subclass', '');

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
	('npttb highly amplified', 'Highly amplified', ''),
	('npttb abnormal - not amplified', 'Abnormal - Not amplified', ''),
	('npttb normal', 'Normal', ''),
	('npttb present', 'Present', ''),
	('npttb absent', 'Absent', ''),
	('npttb loss', 'Loss', ''),
	('npttb mutation', 'Mutation', ''),
	('npttb methylated', 'Methylated', ''),
	('npttb unmethylated', 'Unmethylated', ''),
	('npttb unknown', 'Unknown', ''),
	('npttb group D', 'Group D', ''),
	('npttb group C', 'Group C', ''),
	('npttb WNT', 'WNT', ''),
	('npttb SHH', 'SHH', ''),
	('npttb proneural', 'Proneural', ''),
	('npttb neural', 'Neural', ''),
	('npttb classical', 'Classical', ''),
	('npttb mesenchymal', 'Mesenchmal', ''),
	('npttb V600E', 'V600E', ''),
	('npttb rearrangement', 'Rearrangement', ''),		
	('npttb other mutation', 'Other mutation', ''),
	('npttb co-deleted', 'Co-deleted', ''),
	('npttb 1p loss only', '1p loss only', ''),
	('npttb 19q loss only', '19q loss only', ''),
	('npttb no 19q loss', 'No 19q loss', ''),
	('npttb 19q polyploidy', '19q polyploidy', '');	