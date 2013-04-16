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
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="blood_type"), (SELECT id FROM structure_permissible_values WHERE value="ACB" AND language_alias="npttb ACB"), "1", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("serum", "npttb serum");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="blood_type"), (SELECT id FROM structure_permissible_values WHERE value="serum" AND language_alias="npttb serum"), "4", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("lithium heparin", "npttb lithium heparin");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="blood_type"), (SELECT id FROM structure_permissible_values WHERE value="lithium heparin" AND language_alias="npttb lithium heparin"), "3", "1");

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
 ('npttb ACB', 'ACB', ''),
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

