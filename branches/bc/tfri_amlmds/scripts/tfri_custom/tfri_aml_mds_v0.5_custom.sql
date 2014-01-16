-- TFRI AML/MDS Custom Script
-- Version: v0.5
-- ATiM Version: v2.5.4

-- Update bank name for version tracking during customization
REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('core_installname', 'TFRI MDS-AML v0.5 DEV', '');


/*
	Eventum Issue: #2866 - Profile COD - Add value Other
*/

INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="tfri_cause_of_death"), (SELECT id FROM structure_permissible_values WHERE value="other" AND language_alias="other"), "9", "1");

/*
	Eventum Issue: #2860 - Acquisition Label
*/

REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('acquisition_label', 'Collection Identifier', '');
	
REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('acquisition label is required', 'Collection identifier is required', '');
	
/*
	Eventum Issue: #2862 - Treatment config - Hide Surgery
*/

UPDATE `treatment_controls` SET `flag_active`='0' WHERE `tx_method`='surgery';
UPDATE `treatment_controls` SET `flag_active`='0' WHERE `tx_method`='surgery without extension';

/*
	Eventum Issue: #2863 - Treatment dropdown
*/

UPDATE `treatment_controls` SET `disease_site`='mds aml' WHERE `tx_method`='chemotherapy';
UPDATE `treatment_controls` SET `disease_site`='mds aml' WHERE `tx_method`='radiation';


/*
	Eventum Issue: #2858 - Aliquot - Hide system field created
*/

UPDATE structure_formats SET `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='created' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

/*
	Eventum Issue: #2859 - Aliquot cell count - Add to index view
*/

UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_spec_tubes_incl_ml_vol') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='ad_tubes' AND `field`='cell_count' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_spec_tubes_incl_ml_vol') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='ad_tubes' AND `field`='cell_count_unit' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='cell_count_unit') AND `flag_confidential`='0');

/*
	Eventum Issue: #2847 - Cell count field at vial level
*/

UPDATE structure_fields SET  `model`='AliquotDetail' WHERE model='SampleDetail' AND tablename='ad_tubes' AND field='cell_count' AND `type`='float' AND structure_value_domain  IS NULL ;
UPDATE structure_fields SET  `model`='AliquotDetail',  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='cell_count_unit')  WHERE model='SampleDetail' AND tablename='ad_tubes' AND field='cell_count_unit' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='cell_count_unit');

REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('cell count unit', 'Cell Count Unit', '');
	
/*
	Eventum Issue: #2846 - Bone marrow vials
*/

UPDATE structure_formats SET `flag_search`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_spec_tubes_incl_ml_vol') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='rec_to_stor_spent_time_msg' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_spec_tubes_incl_ml_vol') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='coll_to_stor_spent_time_msg' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_index`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_spec_tubes_incl_ml_vol') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='rec_to_stor_spent_time_msg' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_spec_tubes_incl_ml_vol') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='coll_to_stor_spent_time_msg' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

/*
	Eventum Issue: #2848 - Blood sample - Translations for units
*/

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
 ('tfri blast units', 'Blast Units', ''),
 ('tfri wbc units', 'WBC Units', '');
 

-- Eventum ID: 2977 Collection Identifier for local bank

-- Add field
ALTER TABLE `collections` 
ADD COLUMN `tfri_local_collection_identifier` VARCHAR(75) NULL DEFAULT NULL AFTER `collection_notes`;

ALTER TABLE `collections_revs` 
ADD COLUMN `tfri_local_collection_identifier` VARCHAR(75) NULL DEFAULT NULL AFTER `collection_notes`;

-- Add field to form and collection view
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'Collection', 'collections', 'tfri_local_collection_identifier', 'input',  NULL , '0', 'size=20', '', '', 'tfri local collection identifier', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='collections'), (SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='tfri_local_collection_identifier' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=20' AND `default`='' AND `language_help`='' AND `language_label`='tfri local collection identifier' AND `language_tag`=''), '0', '2', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'ViewCollection', '', 'tfri_local_collection_identifier', 'input',  NULL , '0', 'size=20', '', '', 'tfri local collection identifier', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='view_collection'), (SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='tfri_local_collection_identifier' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=20' AND `default`='' AND `language_help`='' AND `language_label`='tfri local collection identifier' AND `language_tag`=''), '1', '1', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0');

UPDATE structure_fields SET  `model`='Collection' WHERE model='ViewCollection' AND tablename='' AND field='tfri_local_collection_identifier' AND `type`='input' AND structure_value_domain  IS NULL ;

REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('tfri local collection identifier', 'Local Collection Identifier', '');
	
-- Eventum ID: 2876 Participant Code - Hide on add collection
UPDATE structure_formats SET `flag_add`='0', `flag_add_readonly`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Generated' AND `tablename`=' ' AND `field`='field1' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- Eventum ID: 2874 COD Label for other
REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('tfri cause of death other', 'COD, If Other', '');

-- Eventum ID: 2872 Clinical Annotation Sub menu
UPDATE `menus` SET `flag_active`='0' WHERE `id`='clin_CAN_27';
UPDATE `menus` SET `flag_active`='0' WHERE `id`='clin_CAN_30';

-- Eventum ID: 2864 Change Clinical Annotation
REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('clinical annotation', 'Clinical Data', '');
	
-- Eventum ID: 2873 Consent Status - ICR and Other
ALTER TABLE `consent_masters` 
ADD COLUMN `tfri_other_research_status` VARCHAR(45) NULL DEFAULT NULL AFTER `tfri_aml_local_consent_status`,
ADD COLUMN `tfri_icr_consent_status` VARCHAR(45) NULL DEFAULT NULL AFTER `tfri_other_research_status`;

ALTER TABLE `consent_masters_revs` 
ADD COLUMN `tfri_other_research_status` VARCHAR(45) NULL DEFAULT NULL AFTER `tfri_aml_local_consent_status`,
ADD COLUMN `tfri_icr_consent_status` VARCHAR(45) NULL DEFAULT NULL AFTER `tfri_other_research_status`;

-- Add other status to all fields
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'ConsentMaster', 'consent_masters', 'tfri_other_research_status', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='consent_status') , '0', '', '', '', 'tfri other research status', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='consent_masters'), (SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='tfri_other_research_status' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='consent_status')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tfri other research status' AND `language_tag`=''), '1', '13', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'ConsentMaster', 'consent_masters', 'tfri_icr_consent_status', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='consent_status') , '0', '', '', '', 'tfri icr consent status', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='cd_tfri_site_4'), (SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='tfri_icr_consent_status' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='consent_status')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tfri icr consent status' AND `language_tag`=''), '1', '14', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
 ('tfri other research status', 'Other Research Consent Status', ''),
 ('tfri icr consent status', 'ICR Consent Status', '');
 

-- Eventum ID: 2889 Create form - Transplant module
INSERT INTO `event_controls` (`disease_site`, `event_group`, `event_type`, `flag_active`, `detail_form_alias`, `detail_tablename`, `display_order`, `databrowser_label`, `flag_use_for_ccl`) VALUES ('tfri', 'clinical', 'DCF - Section 8: Transplant', '1', 'ed_tfri_clinical_transplant', 'ed_tfri_clinical_transplant', '0', 'clinical|tfri|transplant', '0');
INSERT INTO `structures` (`alias`) VALUES ('ed_tfri_clinical_transplant');

CREATE TABLE `ed_tfri_clinical_transplant` (
  `transplant_type` VARCHAR(45) NULL DEFAULT NULL,
  `preparative_regimen` VARCHAR(45) NULL DEFAULT NULL,
  `progenitor_cell_source` VARCHAR(45) NULL DEFAULT NULL,
  `donor_type` VARCHAR(45) NULL DEFAULT NULL,
  `hla_match_hla-a` VARCHAR(45) NULL DEFAULT NULL,
  `hla_match_hla-b` VARCHAR(45) NULL DEFAULT NULL,
  `hla_match_hla-c` VARCHAR(45) NULL DEFAULT NULL,
  `hla_match_dqb1` VARCHAR(45) NULL DEFAULT NULL,
  `hla_match_drb1` VARCHAR(45) NULL DEFAULT NULL,
  `graft_manipulation` VARCHAR(45) NULL DEFAULT NULL,
  `graft_manipulation_other` VARCHAR(45) NULL DEFAULT NULL,
  `graft_manipulation_tcell_other` VARCHAR(45) NULL DEFAULT NULL,
  `agents_received` VARCHAR(45) NULL DEFAULT NULL,
  `agents_received_other` VARCHAR(45) NULL DEFAULT NULL,  
  `event_master_id` int(11) NOT NULL,
  KEY `event_master_id` (`event_master_id`),
  CONSTRAINT `ed_tfri_clinical_transplant_ibfk_1` FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `ed_tfri_clinical_transplant_revs` (
  `transplant_type` VARCHAR(45) NULL DEFAULT NULL,
  `preparative_regimen` VARCHAR(45) NULL DEFAULT NULL,
  `progenitor_cell_source` VARCHAR(45) NULL DEFAULT NULL,
  `donor_type` VARCHAR(45) NULL DEFAULT NULL,
  `hla_match_hla-a` VARCHAR(45) NULL DEFAULT NULL,
  `hla_match_hla-b` VARCHAR(45) NULL DEFAULT NULL,
  `hla_match_hla-c` VARCHAR(45) NULL DEFAULT NULL,
  `hla_match_dqb1` VARCHAR(45) NULL DEFAULT NULL,
  `hla_match_drb1` VARCHAR(45) NULL DEFAULT NULL,
  `graft_manipulation` VARCHAR(45) NULL DEFAULT NULL,
  `graft_manipulation_other` VARCHAR(45) NULL DEFAULT NULL,
  `graft_manipulation_tcell_other` VARCHAR(45) NULL DEFAULT NULL,
  `agents_received` VARCHAR(45) NULL DEFAULT NULL,
  `agents_received_other` VARCHAR(45) NULL DEFAULT NULL, 
  `event_master_id` int(11) NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`),
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Add value domains

-- Transplant type
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("tfri_transplant_type", "", "", NULL);
INSERT INTO structure_permissible_values (value, language_alias) VALUES("autologous", "tfri autologous");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="tfri_transplant_type"), (SELECT id FROM structure_permissible_values WHERE value="autologous" AND language_alias="tfri autologous"), "1", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("allogeneic", "tfri allogeneic");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="tfri_transplant_type"), (SELECT id FROM structure_permissible_values WHERE value="allogeneic" AND language_alias="tfri allogeneic"), "2", "1");

-- Preparative Regimen
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("tfri_preparative_regimen", "", "", NULL);
INSERT INTO structure_permissible_values (value, language_alias) VALUES("myeloablative", "tfri myeloablative");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="tfri_preparative_regimen"), (SELECT id FROM structure_permissible_values WHERE value="myeloablative" AND language_alias="tfri myeloablative"), "1", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("non-myeloablative", "tfri non-myeloablative");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="tfri_preparative_regimen"), (SELECT id FROM structure_permissible_values WHERE value="non-myeloablative" AND language_alias="tfri non-myeloablative"), "2", "1");

-- Progenitor Cell Source
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("tfri_progenitor_source", "", "", NULL);
INSERT INTO structure_permissible_values (value, language_alias) VALUES("peripheral blood stem cells", "tfri peripheral blood stem cells");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="tfri_progenitor_source"), (SELECT id FROM structure_permissible_values WHERE value="peripheral blood stem cells" AND language_alias="tfri peripheral blood stem cells"), "1", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("bone marrow", "tfri bone marrow");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="tfri_progenitor_source"), (SELECT id FROM structure_permissible_values WHERE value="bone marrow" AND language_alias="tfri bone marrow"), "2", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("cord", "tfri cord");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="tfri_progenitor_source"), (SELECT id FROM structure_permissible_values WHERE value="cord" AND language_alias="tfri cord"), "3", "1");

-- Donor type
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("tfri_donor_type", "", "", NULL);
INSERT INTO structure_permissible_values (value, language_alias) VALUES("unrelated", "tfri unrelated");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="tfri_donor_type"), (SELECT id FROM structure_permissible_values WHERE value="unrelated" AND language_alias="tfri unrelated"), "1", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("sibling", "tfri sibling");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="tfri_donor_type"), (SELECT id FROM structure_permissible_values WHERE value="sibling" AND language_alias="tfri sibling"), "2", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("haploidentical", "tfri haploidentical");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="tfri_donor_type"), (SELECT id FROM structure_permissible_values WHERE value="haploidentical" AND language_alias="tfri haploidentical"), "3", "1");

-- Graft manipulated
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("tfri_graft_manipulated", "", "", NULL);
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="tfri_graft_manipulated"), (SELECT id FROM structure_permissible_values WHERE value="no" AND language_alias="no"), "1", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("red cell depleted", "tfri red cell depleted");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="tfri_graft_manipulated"), (SELECT id FROM structure_permissible_values WHERE value="red cell depleted" AND language_alias="tfri red cell depleted"), "2", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("plasma cell depleted", "tfri plasma cell depleted");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="tfri_graft_manipulated"), (SELECT id FROM structure_permissible_values WHERE value="plasma cell depleted" AND language_alias="tfri plasma cell depleted"), "3", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("t-cell depleted", "tfri t-cell depleted");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="tfri_graft_manipulated"), (SELECT id FROM structure_permissible_values WHERE value="t-cell depleted" AND language_alias="tfri t-cell depleted"), "4", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("cryopreserved", "tfri cryopreserved");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="tfri_graft_manipulated"), (SELECT id FROM structure_permissible_values WHERE value="cryopreserved" AND language_alias="tfri cryopreserved"), "5", "1");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="tfri_graft_manipulated"), (SELECT id FROM structure_permissible_values WHERE value="other" AND language_alias="other"), "6", "1");

-- Agents received
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("tfri_agents_received", "", "", NULL);
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="tfri_agents_received"), (SELECT id FROM structure_permissible_values WHERE value="no" AND language_alias="no"), "1", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("g-csf", "tfri g-csf");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="tfri_agents_received"), (SELECT id FROM structure_permissible_values WHERE value="g-csf" AND language_alias="tfri g-csf"), "2", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("mozibil", "tfri mozibil");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="tfri_agents_received"), (SELECT id FROM structure_permissible_values WHERE value="mozibil" AND language_alias="tfri mozibil"), "3", "1");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="tfri_agents_received"), (SELECT id FROM structure_permissible_values WHERE value="other" AND language_alias="other"), "4", "1");

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_transplant', 'transplant_type', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='tfri_transplant_type') , '0', '', '', '', 'transplant type', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_transplant', 'preparative_regimen', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='tfri_preparative_regimen') , '0', '', '', '', 'preparative regimen', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_transplant', 'progenitor_cell_source', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='tfri_progenitor_source') , '0', '', '', '', 'progenitor cell source', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_transplant', 'donor_type', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='tfri_donor_type') , '0', '', '', '', 'donor type', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_transplant', 'graft_manipulation', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='tfri_donor_type') , '0', '', '', '', 'graft manipulation', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_transplant', 'agents_received', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='tfri_agents_received') , '0', '', '', '', 'agents received', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_transplant', 'agents_received_other', 'input', (SELECT id FROM structure_value_domains WHERE domain_name='tfri_agents_received') , '0', 'size=20', '', '', '', 'agents received other'), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_transplant', 'graft_manipulation_tcell_other', 'input', (SELECT id FROM structure_value_domains WHERE domain_name='tfri_agents_received') , '0', 'size=20', '', '', '', 'graft manipulation tcell other'), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_transplant', 'graft_manipulation_other', 'input', (SELECT id FROM structure_value_domains WHERE domain_name='tfri_agents_received') , '0', 'size=20', '', '', '', 'graft manipulation other');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_transplant'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_transplant' AND `field`='transplant_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tfri_transplant_type')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='transplant type' AND `language_tag`=''), '1', '5', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_transplant'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_transplant' AND `field`='preparative_regimen' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tfri_preparative_regimen')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='preparative regimen' AND `language_tag`=''), '1', '10', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_transplant'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_transplant' AND `field`='progenitor_cell_source' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tfri_progenitor_source')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='progenitor cell source' AND `language_tag`=''), '1', '15', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_transplant'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_transplant' AND `field`='donor_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tfri_donor_type')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='donor type' AND `language_tag`=''), '1', '20', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_transplant'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_transplant' AND `field`='graft_manipulation' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tfri_donor_type')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='graft manipulation' AND `language_tag`=''), '1', '30', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_transplant'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_transplant' AND `field`='agents_received' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tfri_agents_received')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='agents received' AND `language_tag`=''), '1', '35', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_transplant'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_transplant' AND `field`='agents_received_other' AND `type`='input' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tfri_agents_received')  AND `flag_confidential`='0' AND `setting`='size=20' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='agents received other'), '1', '36', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_transplant'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_transplant' AND `field`='graft_manipulation_tcell_other' AND `type`='input' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tfri_agents_received')  AND `flag_confidential`='0' AND `setting`='size=20' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='graft manipulation tcell other'), '1', '31', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_transplant'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_transplant' AND `field`='graft_manipulation_other' AND `type`='input' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tfri_agents_received')  AND `flag_confidential`='0' AND `setting`='size=20' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='graft manipulation other'), '1', '32', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_transplant', 'hla_match_hla-a', 'radio',  NULL , '0', '', '', '', 'hla match hla-a', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_transplant'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_transplant' AND `field`='hla_match_hla-a' AND `type`='radio' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='hla match hla-a' AND `language_tag`=''), '1', '22', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');

INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("tfri_hla_match", "", "", NULL);
INSERT INTO structure_permissible_values (value, language_alias) VALUES("matched", "matched");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="tfri_hla_match"), (SELECT id FROM structure_permissible_values WHERE value="matched" AND language_alias="matched"), "1", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("not matched", "not matched");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="tfri_hla_match"), (SELECT id FROM structure_permissible_values WHERE value="not matched" AND language_alias="not matched"), "2", "1");

UPDATE structure_fields SET  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='tfri_hla_match')  WHERE model='EventDetail' AND tablename='ed_tfri_clinical_transplant' AND field='hla_match_hla-a' AND `type`='radio' AND structure_value_domain  IS NULL ;
UPDATE structure_formats SET `language_heading`='tfri hla match info' WHERE structure_id=(SELECT id FROM structures WHERE alias='ed_tfri_clinical_transplant') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_transplant' AND `field`='hla_match_hla-a' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tfri_hla_match') AND `flag_confidential`='0');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_transplant', 'hla_match_hla-b', 'radio', (SELECT id FROM structure_value_domains WHERE domain_name='tfri_hla_match') , '0', '', '', '', 'hla match hla-b', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_transplant', 'hla_match_hla-c', 'radio', (SELECT id FROM structure_value_domains WHERE domain_name='tfri_hla_match') , '0', '', '', '', 'hla match hla-c', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_transplant', 'hla_match_dqb1', 'radio', (SELECT id FROM structure_value_domains WHERE domain_name='tfri_hla_match') , '0', '', '', '', 'hla match dqb1', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_transplant', 'hla_match_drb1', 'radio', (SELECT id FROM structure_value_domains WHERE domain_name='tfri_hla_match') , '0', '', '', '', 'hla match drb1', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_transplant'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_transplant' AND `field`='hla_match_hla-b' AND `type`='radio' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tfri_hla_match')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='hla match hla-b' AND `language_tag`=''), '1', '23', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_transplant'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_transplant' AND `field`='hla_match_hla-c' AND `type`='radio' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tfri_hla_match')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='hla match hla-c' AND `language_tag`=''), '1', '24', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_transplant'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_transplant' AND `field`='hla_match_dqb1' AND `type`='radio' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tfri_hla_match')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='hla match dqb1' AND `language_tag`=''), '1', '25', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_transplant'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_transplant' AND `field`='hla_match_drb1' AND `type`='radio' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tfri_hla_match')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='hla match drb1' AND `language_tag`=''), '1', '26', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
UPDATE structure_formats SET `language_heading`='tfri hla match info' WHERE structure_id=(SELECT id FROM structures WHERE alias='ed_tfri_clinical_transplant') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_transplant' AND `field`='hla_match_hla-a' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tfri_hla_match') AND `flag_confidential`='0');

UPDATE structure_fields SET  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='tfri_graft_manipulated')  WHERE model='EventDetail' AND tablename='ed_tfri_clinical_transplant' AND field='graft_manipulation' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='tfri_donor_type');

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
 ('transplant type', '8.2 Type of transplant', ''),
 ('preparative regimen', '8.3 Type of preparative regimen received regarding allogeneic HPCT', ''),
 ('progenitor cell source', '8.4 Progenitor cell source', ''),
 ('donor type', '8.5 Type of donor', ''),
 ('DCF - Section 8: Transplant', 'DCF - Section 8: Transplant', ''),
 ('tfri hla match info', '8.6 Enter HLA match information', ''),
 ('hla match hla-a', 'HLA-A', ''),
 ('hla match hla-b', 'HLA-B', ''),
 ('hla match hla-c', 'HLA-C', ''),
 ('hla match dqb1', 'DQB1', ''),
 ('hla match drb1', 'DRB1', ''),
 ('graft manipulation', '8.7 Was the graft product manipulated', ''),
 ('agents received', '8.8 Donor receive any agents as part of the donation process', ''),
 ('agents received other', 'If other agents, specify', ''), 
 ('graft manipulation other', 'If other manipulation, specify', ''),
 ('graft manipulation tcell other', 'T-cell method', ''), 
 ('matched', 'Matched', ''),
 ('not matched', 'Not matched', ''),
 ('tfri autologous', 'Autologous', ''),
 ('tfri myeloablative', 'Myeloablative', ''),  
 ('tfri peripheral blood stem cells', 'Peripheral blood stem cells', ''),
 ('tfri unrelated', 'Unrelated', ''),  
 ('tfri g-csf', 'G-CSF', ''),
 ('tfri allogeneic', 'Allogeneic', ''),  
 ('tfri non-myeloablative', 'Non-myeloablative', ''),
 ('tfri bone marrow', 'Bone marrow', ''),
 ('tfri sibling', 'Sibling', ''),  
 ('tfri mozibil', 'Mozibil', ''),
 ('tfri cord', 'Cord', ''),  
 ('tfri haploidentical', 'Haploidentical', ''),  
 ('tfri red cell depleted', 'Red cell depleted', ''),
 ('tfri plasma cell depleted', 'Plasma cell depleted', ''),
 ('tfri t-cell depleted', 'T-cell depleted', ''),  
 ('tfri cryopreserved', 'Cryopreserved', '');
 
 -- Eventum ID: 2890 DCF Section 2: Followup form

ALTER TABLE `ed_tfri_clinical_section_2` 
ADD COLUMN `followup_start_date` DATE NULL AFTER `event_master_id`,
ADD COLUMN `followup_end_date` DATE NULL AFTER `followup_start_date`,
ADD COLUMN `chemo_treatment_status` VARCHAR(45) NULL DEFAULT NULL AFTER `followup_end_date`,
ADD COLUMN `radiation_treatment_status` VARCHAR(45) NULL DEFAULT NULL AFTER `chemo_treatment_status`,
ADD COLUMN `disease_status` VARCHAR(45) NULL DEFAULT NULL AFTER `radiation_treatment_status`,
ADD COLUMN `hpct_status` VARCHAR(45) NULL DEFAULT NULL AFTER `disease_status`,
ADD COLUMN `new_malignancy_status` VARCHAR(45) NULL DEFAULT NULL AFTER `hpct_status`,
ADD COLUMN `new_malignancy_type` VARCHAR(45) NULL DEFAULT NULL AFTER `new_malignancy_status`,
ADD COLUMN `dodx_new_malignancy` DATE NULL AFTER `new_malignancy_type`,
ADD COLUMN `tx_for_new_malignancy` VARCHAR(45) NULL DEFAULT NULL AFTER `dodx_new_malignancy`,
ADD COLUMN `participant_vs_status` VARCHAR(45) NULL DEFAULT NULL AFTER `tx_for_new_malignancy`,
ADD COLUMN `date_of_death` DATE NULL AFTER `participant_vs_status`,
ADD COLUMN `other_study_status` VARCHAR(45) NULL DEFAULT NULL AFTER `date_of_death`,
ADD COLUMN `study_type` VARCHAR(45) NULL DEFAULT NULL AFTER `other_study_status`,
ADD COLUMN `study_type_other` VARCHAR(45) NULL DEFAULT NULL AFTER `study_type`,
ADD COLUMN `study_type_observational` VARCHAR(45) NULL DEFAULT NULL AFTER `study_type_other`,
ADD COLUMN `investigational_therapy_status` VARCHAR(45) NULL DEFAULT NULL AFTER `study_type_observational`,
ADD COLUMN `karnofsky_performance_3month` INT NULL AFTER `investigational_therapy_status`,
ADD COLUMN `karnofsky_date_3month` DATE NULL AFTER `karnofsky_performance_3month`,
ADD COLUMN `karnofsky_performance_6month` VARCHAR(45) NULL DEFAULT NULL AFTER `karnofsky_date_3month`,
ADD COLUMN `karnofsky_date_6month` DATE NULL AFTER `karnofsky_performance_6month`;

ALTER TABLE `ed_tfri_clinical_section_2_revs` 
ADD COLUMN `followup_start_date` DATE NULL AFTER `event_master_id`,
ADD COLUMN `followup_end_date` DATE NULL AFTER `followup_start_date`,
ADD COLUMN `chemo_treatment_status` VARCHAR(45) NULL DEFAULT NULL AFTER `followup_end_date`,
ADD COLUMN `radiation_treatment_status` VARCHAR(45) NULL DEFAULT NULL AFTER `chemo_treatment_status`,
ADD COLUMN `disease_status` VARCHAR(45) NULL DEFAULT NULL AFTER `radiation_treatment_status`,
ADD COLUMN `hpct_status` VARCHAR(45) NULL DEFAULT NULL AFTER `disease_status`,
ADD COLUMN `new_malignancy_status` VARCHAR(45) NULL DEFAULT NULL AFTER `hpct_status`,
ADD COLUMN `new_malignancy_type` VARCHAR(45) NULL DEFAULT NULL AFTER `new_malignancy_status`,
ADD COLUMN `dodx_new_malignancy` DATE NULL AFTER `new_malignancy_type`,
ADD COLUMN `tx_for_new_malignancy` VARCHAR(45) NULL DEFAULT NULL AFTER `dodx_new_malignancy`,
ADD COLUMN `participant_vs_status` VARCHAR(45) NULL DEFAULT NULL AFTER `tx_for_new_malignancy`,
ADD COLUMN `date_of_death` DATE NULL AFTER `participant_vs_status`,
ADD COLUMN `other_study_status` VARCHAR(45) NULL DEFAULT NULL AFTER `date_of_death`,
ADD COLUMN `study_type` VARCHAR(45) NULL DEFAULT NULL AFTER `other_study_status`,
ADD COLUMN `study_type_other` VARCHAR(45) NULL DEFAULT NULL AFTER `study_type`,
ADD COLUMN `study_type_observational` VARCHAR(45) NULL DEFAULT NULL AFTER `study_type_other`,
ADD COLUMN `investigational_therapy_status` VARCHAR(45) NULL DEFAULT NULL AFTER `study_type_observational`,
ADD COLUMN `karnofsky_performance_3month` INT NULL AFTER `investigational_therapy_status`,
ADD COLUMN `karnofsky_date_3month` DATE NULL AFTER `karnofsky_performance_3month`,
ADD COLUMN `karnofsky_performance_6month` VARCHAR(45) NULL DEFAULT NULL AFTER `karnofsky_date_3month`,
ADD COLUMN `karnofsky_date_6month` DATE NULL AFTER `karnofsky_performance_6month`;

-- Add fields for followup form 2
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_2', 'followup_start_date', 'date',  NULL , '0', '', '', '', 'followup start date', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_2', 'followup_end_date', 'date',  NULL , '0', '', '', '', 'followup end date', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_2', 'chemo_treatment_status', 'checkbox', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '0', '', '', '', 'chemo treatment status', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_2', 'radiation_treatment_status', 'checkbox', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '0', '', '', '', 'radiation treatment status', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_2', 'disease_status', 'checkbox', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '0', '', '', '', 'fu disease status', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_2', 'hpct_status', 'checkbox', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '0', '', '', '', 'hpct status', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_2', 'new_malignancy_status', 'checkbox', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '0', '', '', '', 'new malignancy status', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_2', 'new_malignancy_type', 'input',  NULL , '0', 'size=20', '', '', 'new malignancy type', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_2', 'dodx_new_malignancy', 'date',  NULL , '0', '', '', '', '', 'dodx new malignancy'), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_2', 'tx_for_new_malignancy', 'checkbox', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '0', '', '', '', 'tx for new malignancy', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_2', 'participant_vs_status', 'checkbox', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '0', '', '', '', 'participant vs status', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_2', 'date_of_death', 'date',  NULL , '0', '', '', '', '', 'date of death'), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_2', 'other_study_status', 'checkbox', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '0', '', '', '', 'other study status', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_2', 'investigational_therapy_status', 'checkbox', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '0', '', '', '', 'investigational therapy status', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_2', 'karnofsky_performance_3month', 'integer',  NULL , '0', '', '', '', 'karnofsky performance 3month', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_2', 'karnofsky_date_3month', 'date',  NULL , '0', '', '', '', '', 'karnofsky date 3month'), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_2', 'karnofsky_performance_6month', 'integer',  NULL , '0', '', '', '', 'karnofsky performance 6month', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_2', 'karnofsky_date_6month', 'date',  NULL , '0', '', '', '', '', 'karnofsky date 6month');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_2'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_2' AND `field`='followup_start_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='followup start date' AND `language_tag`=''), '1', '5', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_2'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_2' AND `field`='followup_end_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='followup end date' AND `language_tag`=''), '1', '10', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_2'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_2' AND `field`='chemo_treatment_status' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='chemo treatment status' AND `language_tag`=''), '1', '15', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_2'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_2' AND `field`='radiation_treatment_status' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='radiation treatment status' AND `language_tag`=''), '1', '20', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_2'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_2' AND `field`='disease_status' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='fu disease status' AND `language_tag`=''), '1', '25', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_2'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_2' AND `field`='hpct_status' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='hpct status' AND `language_tag`=''), '1', '30', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_2'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_2' AND `field`='new_malignancy_status' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='new malignancy status' AND `language_tag`=''), '1', '35', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_2'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_2' AND `field`='new_malignancy_type' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=20' AND `default`='' AND `language_help`='' AND `language_label`='new malignancy type' AND `language_tag`=''), '1', '40', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_2'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_2' AND `field`='dodx_new_malignancy' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='dodx new malignancy'), '1', '45', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_2'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_2' AND `field`='tx_for_new_malignancy' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tx for new malignancy' AND `language_tag`=''), '1', '50', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_2'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_2' AND `field`='participant_vs_status' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='participant vs status' AND `language_tag`=''), '1', '55', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_2'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_2' AND `field`='date_of_death' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='date of death'), '1', '60', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_2'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_2' AND `field`='other_study_status' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='other study status' AND `language_tag`=''), '1', '65', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_2'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_2' AND `field`='investigational_therapy_status' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='investigational therapy status' AND `language_tag`=''), '1', '75', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_2'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_2' AND `field`='karnofsky_performance_3month' AND `type`='integer' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='karnofsky performance 3month' AND `language_tag`=''), '1', '80', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_2'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_2' AND `field`='karnofsky_date_3month' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='karnofsky date 3month'), '1', '85', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_2'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_2' AND `field`='karnofsky_performance_6month' AND `type`='integer' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='karnofsky performance 6month' AND `language_tag`=''), '1', '90', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_2'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_2' AND `field`='karnofsky_date_6month' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='karnofsky date 6month'), '1', '95', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');

-- Value domain for Clinical trials type
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("study_trial_type", "", "", NULL);
INSERT INTO structure_permissible_values (value, language_alias) VALUES("treatment of hematologic malignancy", "treatment of hematologic malignancy");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="study_trial_type"), (SELECT id FROM structure_permissible_values WHERE value="treatment of hematologic malignancy" AND language_alias="treatment of hematologic malignancy"), "1", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("prevention of GVHD", "prevention of GVHD");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="study_trial_type"), (SELECT id FROM structure_permissible_values WHERE value="prevention of GVHD" AND language_alias="prevention of GVHD"), "2", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("treatment of GVHD", "treatment of GVHD");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="study_trial_type"), (SELECT id FROM structure_permissible_values WHERE value="treatment of GVHD" AND language_alias="treatment of GVHD"), "3", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("infection prophylaxis", "infection prophylaxis");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="study_trial_type"), (SELECT id FROM structure_permissible_values WHERE value="infection prophylaxis" AND language_alias="infection prophylaxis"), "4", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("infection treatment", "infection treatment");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="study_trial_type"), (SELECT id FROM structure_permissible_values WHERE value="infection treatment" AND language_alias="infection treatment"), "5", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("observational sample collection", "observational sample collection");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="study_trial_type"), (SELECT id FROM structure_permissible_values WHERE value="observational sample collection" AND language_alias="observational sample collection"), "6", "1");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="study_trial_type"), (SELECT id FROM structure_permissible_values WHERE value="other" AND language_alias="other"), "7", "1");

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_2', 'study_type', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='study_trial_type') , '0', '', '', '', 'study type', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_2', 'study_type_observational', 'input',  NULL , '0', 'size=20', '', '', '', 'study type observational'), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_2', 'study_type_other', 'input',  NULL , '0', 'size=20', '', '', 'study type other', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_2'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_2' AND `field`='study_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='study_trial_type')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='study type' AND `language_tag`=''), '1', '70', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_2'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_2' AND `field`='study_type_observational' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=20' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='study type observational'), '1', '72', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_2'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_2' AND `field`='study_type_other' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=20' AND `default`='' AND `language_help`='' AND `language_label`='study type other' AND `language_tag`=''), '1', '73', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');
 
 -- Add headings
UPDATE structure_formats SET `language_heading`='treatment' WHERE structure_id=(SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_2') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_2' AND `field`='chemo_treatment_status' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='disease status' WHERE structure_id=(SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_2') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_2' AND `field`='disease_status' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='transplant information' WHERE structure_id=(SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_2') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_2' AND `field`='hpct_status' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='other malignancy' WHERE structure_id=(SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_2') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_2' AND `field`='new_malignancy_status' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='participant status' WHERE structure_id=(SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_2') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_2' AND `field`='participant_vs_status' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='karnofsky performance status' WHERE structure_id=(SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_2') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_2' AND `field`='karnofsky_performance_3month' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='involvement in clinical trials' WHERE structure_id=(SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_2') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_2' AND `field`='study_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='study_trial_type') AND `flag_confidential`='0');

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
 ('followup start date', '2.1 Start date of follow-up period', ''),
 ('followup end date', '2.2 End date of follow-up period', ''),
 ('chemo treatment status', '2.3 Did participant receive chemotherapeutic or immunomodulatory treatment?', ''),
 ('radiation treatment status', '2.4 Did participant receive radiation treatment?', ''),
 ('transplant information', 'Transplant Information', ''),
 ('fu disease status', '2.5 Was disease status documented during follow-up period?', ''),
 ('hpct status', '2.6 Did participant receive autologous or HPCT?', ''),
 ('other malignancy', 'Other Malignancy', ''),
 ('new malignancy status', '2.7 Did participant develop new malignancy?', ''),
 ('new malignancy type', '2.8 Enter name of new malignancy', ''),
 ('dodx new malignancy', '2.9 Enter date of diagnosis of new malignancy', ''),
 ('tx for new malignancy', '2.10 Did participant receive treatment for new malignancy?', ''),
 ('participant status', 'Participant Status', ''),
 ('participant vs status', '2.11 Did participant die during follow-up period?', ''), 
 ('other study status', '2.13 Did participant take part in other study or trial?', ''),
 ('involvement in clinical trials', 'Involvement in Clinical Trials or Studies', ''), 
 ('study type', '2.14 Type of study or clinical trial', ''),
 ('study type observational', 'If observational and/or sample collection, specify', ''),
 ('study type other', 'If other study type specify', ''),
 ('investigational therapy status', '2.15 Did participant receive investigational therapy?', ''),  
 ('karnofsky performance status', 'Karnofsky Performance Status', ''),
 ('karnofsky performance 3month', '2.16 MONTH 3 KPS', ''),  
 ('karnofsky performance 6month', '2.18 MONTH 6 KPS', ''),
 ('karnofsky date 3month', '2.17 MONTH 3 Date of Karnofsky assessment', ''),  
 ('karnofsky date 6month', '2.19 MONTH 6 Date of Karnofsky assessment', ''),
 ('treatment of hematologic malignancy', 'Treatment of hematologic malignancy', ''),
 ('prevention of GVHD', 'Prevention of GVHD', ''),  
 ('treatment of GVHD', 'Treatment of GVHD', ''),
 ('infection prophylaxis', 'Infection prophylaxis', ''),  
 ('infection treatment', 'Infection treatment', ''),  
 ('observational sample collection', 'Observational and/or sample collection, specify', '');
 
 -- Eventum ID: 2891 EQ-5D Health Questionnaire
INSERT INTO `event_controls` (`disease_site`, `event_group`, `event_type`, `flag_active`, `detail_form_alias`, `detail_tablename`, `display_order`, `databrowser_label`, `flag_use_for_ccl`) VALUES ('tfri', 'study', ' EQ-5D Health Questionnaire', '1', 'ed_tfri_study_eq_5d_health', 'ed_tfri_study_eq_5d_health', '1', 'clinical|study|eq_5d', '0');
UPDATE `event_controls` SET `flag_active`='0' WHERE `detail_form_alias`='ed_all_study_research';

INSERT INTO `structures` (`alias`) VALUES ('ed_tfri_study_eq_5d_health');

CREATE TABLE `ed_tfri_study_eq_5d_health` (
  `method_of_completion` varchar(45) NULL DEFAULT NULL,
  `mobility` varchar(45) NULL DEFAULT NULL,
  `self-care` varchar(45) NULL DEFAULT NULL,
  `usual_activities` varchar(45) NULL DEFAULT NULL,
  `pain_discomfort` varchar(45) NULL DEFAULT NULL,
  `anxiety_depression` varchar(45) NULL DEFAULT NULL,
  `thermometer_rating` int NULL DEFAULT NULL,
  `event_master_id` int(11) NOT NULL,
  KEY `event_master_id` (`event_master_id`),
  CONSTRAINT `ed_tfri_study_eq_5d_health_ibfk_1` FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `ed_tfri_study_eq_5d_health_revs` (
  `method_of_completion` varchar(45) NULL DEFAULT NULL,
  `mobility` varchar(45) NULL DEFAULT NULL,
  `self-care` varchar(45) NULL DEFAULT NULL,
  `usual_activities` varchar(45) NULL DEFAULT NULL,
  `pain_discomfort` varchar(45) NULL DEFAULT NULL,
  `anxiety_depression` varchar(45) NULL DEFAULT NULL,
  `thermometer_rating` int NULL DEFAULT NULL,
  `event_master_id` int(11) NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`),
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Method of completion
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("method_of_completion", "", "", NULL);
INSERT INTO structure_permissible_values (value, language_alias) VALUES("in-person interview", "in-person interview");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="method_of_completion"), (SELECT id FROM structure_permissible_values WHERE value="in-person interview" AND language_alias="in-person interview"), "1", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("telephone interview", "telephone interview");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="method_of_completion"), (SELECT id FROM structure_permissible_values WHERE value="telephone interview" AND language_alias="telephone interview"), "2", "1");

-- Mobility
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("eq_5d_mobility", "", "", NULL);
INSERT INTO structure_permissible_values (value, language_alias) VALUES("i have no problems walking about", "i have no problems walking about");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="eq_5d_mobility"), (SELECT id FROM structure_permissible_values WHERE value="i have no problems walking about" AND language_alias="i have no problems walking about"), "1", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("i have some problems walking about", "i have some problems walking about");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="eq_5d_mobility"), (SELECT id FROM structure_permissible_values WHERE value="i have some problems walking about" AND language_alias="i have some problems walking about"), "2", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("i am confined to bed", "i am confined to bed");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="eq_5d_mobility"), (SELECT id FROM structure_permissible_values WHERE value="i am confined to bed" AND language_alias="i am confined to bed"), "3", "1");

-- Self care
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("eq_5d_self_care", "", "", NULL);
INSERT INTO structure_permissible_values (value, language_alias) VALUES("I have no problems with self-care", "I have no problems with self-care");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="eq_5d_self_care"), (SELECT id FROM structure_permissible_values WHERE value="I have no problems with self-care" AND language_alias="I have no problems with self-care"), "1", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("I have some problems washing or dressing myself", "I have some problems washing or dressing myself");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="eq_5d_self_care"), (SELECT id FROM structure_permissible_values WHERE value="I have some problems washing or dressing myself" AND language_alias="I have some problems washing or dressing myself"), "2", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("I am unable to wash or dress myself", "I am unable to wash or dress myself");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="eq_5d_self_care"), (SELECT id FROM structure_permissible_values WHERE value="I am unable to wash or dress myself" AND language_alias="I am unable to wash or dress myself"), "3", "1");

-- Usual activities
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("eq_5d_usual_activities", "", "", NULL);
INSERT INTO structure_permissible_values (value, language_alias) VALUES("I have no problems with performing my usual activities", "I have no problems with performing my usual activities");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="eq_5d_usual_activities"), (SELECT id FROM structure_permissible_values WHERE value="I have no problems with performing my usual activities" AND language_alias="I have no problems with performing my usual activities"), "1", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("I have some problems with performing my usual activities", "I have some problems with performing my usual activities");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="eq_5d_usual_activities"), (SELECT id FROM structure_permissible_values WHERE value="I have some problems with performing my usual activities" AND language_alias="I have some problems with performing my usual activities"), "2", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("I am unable to perform my usual activities", "I am unable to perform my usual activities");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="eq_5d_usual_activities"), (SELECT id FROM structure_permissible_values WHERE value="I am unable to perform my usual activities" AND language_alias="I am unable to perform my usual activities"), "3", "1");

-- Pain
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("eq_5d_pain", "", "", NULL);
INSERT INTO structure_permissible_values (value, language_alias) VALUES("I have no pain or discomfort", "I have no pain or discomfort");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="eq_5d_pain"), (SELECT id FROM structure_permissible_values WHERE value="I have no pain or discomfort" AND language_alias="I have no pain or discomfort"), "1", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("I have moderate pain or discomfort", "I have moderate pain or discomfort");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="eq_5d_pain"), (SELECT id FROM structure_permissible_values WHERE value="I have moderate pain or discomfort" AND language_alias="I have moderate pain or discomfort"), "2", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("I have extreme pain or discomfort", "I have extreme pain or discomfort");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="eq_5d_pain"), (SELECT id FROM structure_permissible_values WHERE value="I have extreme pain or discomfort" AND language_alias="I have extreme pain or discomfort"), "3", "1");

-- Anxiety
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("eq_5d_anxiety", "", "", NULL);
INSERT INTO structure_permissible_values (value, language_alias) VALUES("I am not anxious or depressed", "I am not anxious or depressed");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="eq_5d_anxiety"), (SELECT id FROM structure_permissible_values WHERE value="I am not anxious or depressed" AND language_alias="I am not anxious or depressed"), "1", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("I am moderately anxious or depressed", "I am moderately anxious or depressed");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="eq_5d_anxiety"), (SELECT id FROM structure_permissible_values WHERE value="I am moderately anxious or depressed" AND language_alias="I am moderately anxious or depressed"), "2", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("I am extremely anxious or depressed", "I am extremely anxious or depressed");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="eq_5d_anxiety"), (SELECT id FROM structure_permissible_values WHERE value="I am extremely anxious or depressed" AND language_alias="I am extremely anxious or depressed"), "3", "1");

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_study_eq_5d_health', 'method_of_completion', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='method_of_completion') , '0', '', '', '', 'method of completion', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_study_eq_5d_health', 'mobility', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='eq_5d_mobility') , '0', '', '', '', 'mobility', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_study_eq_5d_health', 'self-care', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='eq_5d_self_care') , '0', '', '', '', 'self-care', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_study_eq_5d_health', 'usual_activities', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='eq_5d_usual_activities') , '0', '', '', '', 'usual activities', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_study_eq_5d_health', 'pain_discomfort', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='eq_5d_pain') , '0', '', '', '', 'pain discomfort', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_study_eq_5d_health', 'anxiety_depression', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='eq_5d_anxiety') , '0', '', '', '', 'anxiety depression', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_study_eq_5d_health', 'thermometer_rating', 'integer',  NULL , '0', '', '', '', 'thermometer rating', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ed_tfri_study_eq_5d_health'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_study_eq_5d_health' AND `field`='method_of_completion' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='method_of_completion')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='method of completion' AND `language_tag`=''), '1', '5', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_study_eq_5d_health'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_study_eq_5d_health' AND `field`='mobility' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='eq_5d_mobility')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='mobility' AND `language_tag`=''), '1', '10', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_study_eq_5d_health'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_study_eq_5d_health' AND `field`='self-care' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='eq_5d_self_care')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='self-care' AND `language_tag`=''), '1', '15', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_study_eq_5d_health'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_study_eq_5d_health' AND `field`='usual_activities' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='eq_5d_usual_activities')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='usual activities' AND `language_tag`=''), '1', '20', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_study_eq_5d_health'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_study_eq_5d_health' AND `field`='pain_discomfort' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='eq_5d_pain')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='pain discomfort' AND `language_tag`=''), '1', '25', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_study_eq_5d_health'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_study_eq_5d_health' AND `field`='anxiety_depression' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='eq_5d_anxiety')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='anxiety depression' AND `language_tag`=''), '1', '30', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_study_eq_5d_health'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_study_eq_5d_health' AND `field`='thermometer_rating' AND `type`='integer' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='thermometer rating' AND `language_tag`=''), '1', '35', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
 ('EQ-5D Health Questionnaire', 'EQ-5D Health Questionnaire', ''),
 ('method of completion', 'Completed by', ''),
 ('mobility', 'Mobility', ''),
 ('self-care', 'Self-Care', ''),
 ('usual activities', 'Usual Activities', ''),
 ('pain discomfort', 'Pain Discomfort', ''),
 ('anxiety depression', 'Anxiety Depression', ''),
 ('thermometer rating', 'Category Rating Thermometer', ''),     
 ('in-person interview', 'In-person interview', ''),
 ('telephone interview', 'Telephone interview', ''),
 ('i have no problems walking about', 'I have no problems walking about', ''),
 ('i have some problems walking about', 'I have some problems walking about', ''),
 ('i am confined to bed', 'I am confined to bed', ''),
 ('I have no problems with self-care', 'I have no problems with self-care', ''),
 ('I have some problems washing or dressing myself', 'I have some problems washing or dressing myself', ''),
 ('I am unable to wash or dress myself', 'I am unable to wash or dress myself', ''),
 ('I am not anxious or depressed', 'I am not anxious or depressed', ''),  
 ('I am moderately anxious or depressed', 'I am moderately anxious or depressed', ''),  
 ('I am extremely anxious or depressed', 'I am extremely anxious or depressed', ''), 
 ('I have no pain or discomfort', 'I have no pain or discomfort', ''),  
 ('I have moderate pain or discomfort', 'I have moderate pain or discomfort', ''),  
 ('I have extreme pain or discomfort', 'I have extreme pain or discomfort', ''),
 ('I have no problems with performing my usual activities', 'I have no problems with performing my usual activities', ''),
 ('I have some problems with performing my usual activities', 'I have some problems with performing my usual activities', ''),
 ('I am unable to perform my usual activities', 'I am unable to perform my usual activities', '');           
 
/*
	Eventum Issue: #2900 - EQ5D Study Score Field
*/

ALTER TABLE `ed_tfri_study_eq_5d_health` 
ADD COLUMN `calculated_score` DECIMAL(5,3) NULL DEFAULT NULL AFTER `thermometer_rating`;

ALTER TABLE `ed_tfri_study_eq_5d_health_revs` 
ADD COLUMN `calculated_score` DECIMAL(5,3) NULL DEFAULT NULL AFTER `thermometer_rating`;

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_study_eq_5d_health', 'calculated_score', 'float',  NULL , '0', '', '', '', 'calculated score', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ed_tfri_study_eq_5d_health'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_study_eq_5d_health' AND `field`='calculated_score' AND `type`='float' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='calculated score' AND `language_tag`=''), '1', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '1', '1', '1', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='ed_tfri_study_eq_5d_health') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_study_eq_5d_health' AND `field`='method_of_completion' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='method_of_completion') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='ed_tfri_study_eq_5d_health') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_study_eq_5d_health' AND `field`='mobility' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='eq_5d_mobility') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='ed_tfri_study_eq_5d_health') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_study_eq_5d_health' AND `field`='self-care' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='eq_5d_self_care') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='ed_tfri_study_eq_5d_health') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_study_eq_5d_health' AND `field`='usual_activities' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='eq_5d_usual_activities') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='ed_tfri_study_eq_5d_health') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_study_eq_5d_health' AND `field`='pain_discomfort' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='eq_5d_pain') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='ed_tfri_study_eq_5d_health') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_study_eq_5d_health' AND `field`='anxiety_depression' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='eq_5d_anxiety') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='ed_tfri_study_eq_5d_health') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_study_eq_5d_health' AND `field`='thermometer_rating' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
 ('calculated score', 'Calculated Score', '');

/*
	Eventum Issue: #2896 - EQ5D Study Label Change
*/

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
 ('method of completion', 'Method of Completion', '');

/*
	Eventum Issue: #2894 - Thermometer Validation
*/
 
INSERT INTO `structure_validations` (`structure_field_id`, `rule`, `language_message`) VALUES ((SELECT `id` FROM `structure_fields` WHERE `field` = 'thermometer_rating' ), 'range,-1,101', 'tfri thermometer rating 0-100');
 
REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
 ('tfri thermometer rating 0-100', 'Thermometer rating must be an integer value between 0 - 100', '');
  
/*
	Eventum Issue: #2893 - Clinical Menu Study - Update name
*/

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
 ('clin_study', 'Questionnaires', ''); 

/*
	Eventum Issue: #2892 - Consent status - New value denied/NA
*/

INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("tfri_consent_status", "open", "", NULL);
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="tfri_consent_status"), (SELECT id FROM structure_permissible_values WHERE value="active" AND language_alias="active"), "1", "1");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="tfri_consent_status"), (SELECT id FROM structure_permissible_values WHERE value="withdrawn" AND language_alias="withdrawn"), "3", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("denied or n/a", "denied or n/a");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="tfri_consent_status"), (SELECT id FROM structure_permissible_values WHERE value="denied or n/a" AND language_alias="denied or n/a"), "2", "1");

UPDATE structure_fields SET  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='tfri_consent_status')  WHERE model='ConsentMaster' AND tablename='consent_masters' AND field='tfri_aml_local_consent_status' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='consent_status');
UPDATE structure_fields SET  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='tfri_consent_status')  WHERE model='ConsentMaster' AND tablename='consent_masters' AND field='tfri_other_research_status' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='consent_status');

UPDATE structure_fields SET  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='tfri_consent_status')  WHERE model='ConsentMaster' AND tablename='consent_masters' AND field='tfri_icr_consent_status' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='consent_status');

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
 ('denied or n/a', 'Denied or N/A', ''); 

/*
	Eventum Issue: #2903 - EQ5D Study - Add field for Followup Period
*/

ALTER TABLE `ed_tfri_study_eq_5d_health` 
ADD COLUMN `followup_period` VARCHAR(45) NULL DEFAULT NULL AFTER `method_of_completion`;

ALTER TABLE `ed_tfri_study_eq_5d_health_revs` 
ADD COLUMN `followup_period` VARCHAR(45) NULL DEFAULT NULL AFTER `method_of_completion`;

-- Value domain for followup period 
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("tfri_followup_period", "open", "", NULL);
INSERT INTO structure_permissible_values (value, language_alias) VALUES("baseline", "tfri baseline");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="tfri_followup_period"), (SELECT id FROM structure_permissible_values WHERE value="baseline" AND language_alias="tfri baseline"), "1", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("month 3", "tfri month 3");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="tfri_followup_period"), (SELECT id FROM structure_permissible_values WHERE value="month 3" AND language_alias="tfri month 3"), "2", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("month 6", "tfri month 6");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="tfri_followup_period"), (SELECT id FROM structure_permissible_values WHERE value="month 6" AND language_alias="tfri month 6"), "3", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("month 12", "tfri month 12");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="tfri_followup_period"), (SELECT id FROM structure_permissible_values WHERE value="month 12" AND language_alias="tfri month 12"), "4", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("month 18", "tfri month 18");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="tfri_followup_period"), (SELECT id FROM structure_permissible_values WHERE value="month 18" AND language_alias="tfri month 18"), "5", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("month 24", "tfri month 24");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="tfri_followup_period"), (SELECT id FROM structure_permissible_values WHERE value="month 24" AND language_alias="tfri month 24"), "6", "1"); 

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_study_eq_5d_health', 'followup_period', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='tfri_followup_period') , '0', '', '', '', 'followup period', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ed_tfri_study_eq_5d_health'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_study_eq_5d_health' AND `field`='followup_period' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tfri_followup_period')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='followup period' AND `language_tag`=''), '1', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
 ('tfri baseline', 'Baseline', ''),
 ('tfri month 3', 'Month 3', ''),
 ('tfri month 6', 'Month 6', ''),
 ('tfri month 12', 'Month 12', ''),
 ('tfri month 18', 'Month 18', ''),
 ('tfri month 24', 'Month 24', ''),
 ('followup period', 'Followup Period', '');

/*
	Eventum Issue: #2869 - Cell count - two decimal places
*/

ALTER TABLE `sd_spe_bloods` 
CHANGE COLUMN `collected_volume` `collected_volume` DECIMAL(10,2) NULL DEFAULT NULL ;

ALTER TABLE `sd_spe_bloods_revs` 
CHANGE COLUMN `collected_volume` `collected_volume` DECIMAL(10,2) NULL DEFAULT NULL ;

ALTER TABLE `sd_spe_bone_marrows` 
CHANGE COLUMN `collected_volume` `collected_volume` DECIMAL(10,2) NULL DEFAULT NULL ;

ALTER TABLE `sd_spe_bone_marrows_revs` 
CHANGE COLUMN `collected_volume` `collected_volume` DECIMAL(10,2) NULL DEFAULT NULL ;

/*
	Eventum Issue: #2899 - System fields for Clinical forms
*/

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventMaster', 'event_masters', 'created', 'datetime',  NULL , '0', '', '', '', 'created', ''), 
('ClinicalAnnotation', 'EventMaster', 'event_masters', 'modified', 'datetime',  NULL , '0', '', '', '', 'modified', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='eventmasters'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='created' AND `type`='datetime' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='created' AND `language_tag`=''), '1', '900', 'system information', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='eventmasters'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='modified' AND `type`='datetime' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='modified' AND `language_tag`=''), '1', '950', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
 ('system information', 'System Information', '');

/*
	Eventum Issue: #2895 - EQ5D Study - Dropdown to radio
*/
 
UPDATE structure_fields SET  `type`='radio',  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='eq_5d_mobility')  WHERE model='EventDetail' AND tablename='ed_tfri_study_eq_5d_health' AND field='mobility' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='eq_5d_mobility');
UPDATE structure_fields SET  `type`='radio',  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='eq_5d_self_care')  WHERE model='EventDetail' AND tablename='ed_tfri_study_eq_5d_health' AND field='self-care' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='eq_5d_self_care');
UPDATE structure_fields SET  `type`='radio',  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='eq_5d_usual_activities')  WHERE model='EventDetail' AND tablename='ed_tfri_study_eq_5d_health' AND field='usual_activities' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='eq_5d_usual_activities');
UPDATE structure_fields SET  `type`='radio',  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='eq_5d_pain')  WHERE model='EventDetail' AND tablename='ed_tfri_study_eq_5d_health' AND field='pain_discomfort' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='eq_5d_pain');
UPDATE structure_fields SET  `type`='radio',  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='eq_5d_anxiety')  WHERE model='EventDetail' AND tablename='ed_tfri_study_eq_5d_health' AND field='anxiety_depression' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='eq_5d_anxiety');
 
/*
	Eventum Issue: #2904 -  Baseline form version 1
*/ 

ALTER TABLE `ed_tfri_clinical_section_1` 
ADD COLUMN `karnofsky_performance_baseline` INT DEFAULT NULL AFTER `event_master_id`,
ADD COLUMN `karnofsky_date_baseline` DATE DEFAULT NULL AFTER `karnofsky_performance_baseline`,
ADD COLUMN `baseline_weight` DECIMAL (5,2) DEFAULT NULL AFTER `karnofsky_date_baseline`,
ADD COLUMN `baseline_height` INT DEFAULT NULL AFTER `baseline_weight`,

ADD COLUMN `med_history_autoimmune_disease` VARCHAR(10) DEFAULT NULL AFTER `baseline_height`,
ADD COLUMN `med_history_autoimmune_disease_type` VARCHAR(45) DEFAULT NULL AFTER `med_history_autoimmune_disease`,
ADD COLUMN `med_history_autoimmune_disease_other` VARCHAR(150) DEFAULT NULL AFTER `med_history_autoimmune_disease_type`,
ADD COLUMN `med_history_cardiovascular_disease` VARCHAR(10) DEFAULT NULL AFTER `med_history_autoimmune_disease_other`,
ADD COLUMN `med_history_cardiovascular_disease_type` VARCHAR(45) DEFAULT NULL AFTER `med_history_cardiovascular_disease`,
ADD COLUMN `med_history_cardiovascular_disease_other` VARCHAR(150) DEFAULT NULL AFTER `med_history_cardiovascular_disease_type`,

ADD COLUMN `med_history_chromosome_abnormality` VARCHAR(10) DEFAULT NULL AFTER `med_history_cardiovascular_disease_other`,
ADD COLUMN `med_history_chromosome_abnormality_type` VARCHAR(45) DEFAULT NULL AFTER `med_history_chromosome_abnormality`,
ADD COLUMN `med_history_chromosome_abnormality_other` VARCHAR(150) DEFAULT NULL AFTER `med_history_chromosome_abnormality_type`,
ADD COLUMN `med_history_cns_psychiatric` VARCHAR(10) DEFAULT NULL AFTER `med_history_chromosome_abnormality_other`,
ADD COLUMN `med_history_cns_psychiatric_type` VARCHAR(45) DEFAULT NULL AFTER `med_history_cns_psychiatric`,
ADD COLUMN `med_history_cns_psychiatric_other` VARCHAR(150) DEFAULT NULL AFTER `med_history_cns_psychiatric_type`,
ADD COLUMN `med_history_endocrine` VARCHAR(10) DEFAULT NULL AFTER `med_history_cns_psychiatric_other`,
ADD COLUMN `med_history_endocrine_type` VARCHAR(45) DEFAULT NULL AFTER `med_history_endocrine`,
ADD COLUMN `med_history_endocrine_other` VARCHAR(150) DEFAULT NULL AFTER `med_history_endocrine_type`,
ADD COLUMN `med_history_gastrointestinal` VARCHAR(10) DEFAULT NULL AFTER `med_history_endocrine_other`,
ADD COLUMN `med_history_gastrointestinal_type` VARCHAR(45) DEFAULT NULL AFTER `med_history_gastrointestinal`,
ADD COLUMN `med_history_gastrointestinal_other` VARCHAR(150) DEFAULT NULL AFTER `med_history_gastrointestinal_type`,
ADD COLUMN `med_history_genitourinary` VARCHAR(10) DEFAULT NULL AFTER `med_history_gastrointestinal_other`,
ADD COLUMN `med_history_genitourinary_type` VARCHAR(45) DEFAULT NULL AFTER `med_history_genitourinary`,
ADD COLUMN `med_history_genitourinary_other` VARCHAR(150) DEFAULT NULL AFTER `med_history_genitourinary_type`,
ADD COLUMN `med_history_hematologic` VARCHAR(10) DEFAULT NULL AFTER `med_history_genitourinary_other`,
ADD COLUMN `med_history_hematologic_type` VARCHAR(45) DEFAULT NULL AFTER `med_history_hematologic`,
ADD COLUMN `med_history_hematologic_other` VARCHAR(150) DEFAULT NULL AFTER `med_history_hematologic_type`,
ADD COLUMN `med_history_liver_disease` VARCHAR(10) DEFAULT NULL AFTER `med_history_hematologic_other`,
ADD COLUMN `med_history_liver_disease_type` VARCHAR(45) DEFAULT NULL AFTER `med_history_liver_disease`,
ADD COLUMN `med_history_liver_disease_other` VARCHAR(150) DEFAULT NULL AFTER `med_history_liver_disease_type`,
ADD COLUMN `med_history_pulmonary` VARCHAR(10) DEFAULT NULL AFTER `med_history_liver_disease_other`,
ADD COLUMN `med_history_pulmonary_type` VARCHAR(45) DEFAULT NULL AFTER `med_history_pulmonary`,
ADD COLUMN `med_history_pulmonary_other` VARCHAR(150) DEFAULT NULL AFTER `med_history_pulmonary_type`,
ADD COLUMN `med_history_infectious` VARCHAR(10) DEFAULT NULL AFTER `med_history_pulmonary_other`,
ADD COLUMN `med_history_infectious_type` VARCHAR(45) DEFAULT NULL AFTER `med_history_infectious`,
ADD COLUMN `med_history_infectious_other` VARCHAR(150) DEFAULT NULL AFTER `med_history_infectious_type`,
ADD COLUMN `med_history_co-existing` VARCHAR(10) DEFAULT NULL AFTER `med_history_infectious_other`,
ADD COLUMN `med_history_co-existing_other` VARCHAR(150) DEFAULT NULL AFTER `med_history_co-existing`,
ADD COLUMN `med_history_co-existing_other_two` VARCHAR(150) DEFAULT NULL AFTER `med_history_co-existing_other`,

ADD COLUMN `flt_status_at_dx` VARCHAR(75) DEFAULT NULL AFTER `med_history_co-existing_other`,
ADD COLUMN `flt_status` VARCHAR(45) DEFAULT NULL AFTER `flt_status_at_dx`,
ADD COLUMN `flt_date_collection` DATE DEFAULT NULL AFTER `flt_status`,
ADD COLUMN `flt_date_collection_status` VARCHAR(45) DEFAULT NULL AFTER `flt_date_collection`,
ADD COLUMN `npm_status_at_dx` VARCHAR(75) DEFAULT NULL AFTER `flt_date_collection_status`,
ADD COLUMN `npm_status` VARCHAR(45) DEFAULT NULL AFTER `npm_status_at_dx`,
ADD COLUMN `npm_date_of_collection` DATE DEFAULT NULL AFTER `npm_status`,
ADD COLUMN `npm_date_collection_status` VARCHAR(45) DEFAULT NULL AFTER `npm_date_of_collection`,
ADD COLUMN `cepba_status_at_dx` VARCHAR(75) DEFAULT NULL AFTER `npm_date_collection_status`,
ADD COLUMN `cepba_status` VARCHAR(45) DEFAULT NULL AFTER `cepba_status_at_dx`,
ADD COLUMN `cepba_date_of_collection` DATE DEFAULT NULL AFTER `cepba_status`,
ADD COLUMN `cepba_date_collection_status` VARCHAR(45) DEFAULT NULL AFTER `cepba_date_of_collection`,
ADD COLUMN `other_genetic_testing` TEXT DEFAULT NULL AFTER `cepba_date_collection_status`,

ADD COLUMN `ast_sgot` DECIMAL(5,2) DEFAULT NULL AFTER `other_genetic_testing`,
ADD COLUMN `ast_sgot_date_collection` DATE DEFAULT NULL AFTER `ast_sgot`,
ADD COLUMN `total_bilirubin` DECIMAL(5,2) DEFAULT NULL AFTER `ast_sgot_date_collection`,
ADD COLUMN `total_bilirubin_date_collection` DATE DEFAULT NULL AFTER `total_bilirubin`,
ADD COLUMN `creatinine` DECIMAL(5,2) DEFAULT NULL AFTER `total_bilirubin_date_collection`,
ADD COLUMN `creatinine_date_collection` DATE DEFAULT NULL AFTER `creatinine`,

ADD COLUMN `date_of_cbc` DATE DEFAULT NULL AFTER `creatinine_date_collection`,
ADD COLUMN `wbc` DECIMAL(5,2) DEFAULT NULL AFTER `date_of_cbc`,
ADD COLUMN `wbc_less_than_zero` VARCHAR(10) DEFAULT NULL AFTER `wbc`,
ADD COLUMN `neutrophils` DECIMAL(5,2) DEFAULT NULL AFTER `wbc_less_than_zero`,
ADD COLUMN `neutrophils_less_than_zero` VARCHAR(10) DEFAULT NULL AFTER `neutrophils`,
ADD COLUMN `lymphocytes` DECIMAL(5,2) DEFAULT NULL AFTER `neutrophils_less_than_zero`,
ADD COLUMN `lymphocytes_less_than_zero` VARCHAR(10) DEFAULT NULL AFTER `lymphocytes`,
ADD COLUMN `hemoglobin` DECIMAL(5,2) DEFAULT NULL AFTER `lymphocytes_less_than_zero`,
ADD COLUMN `hemoglobin_less_than_zero` VARCHAR(10) DEFAULT NULL AFTER `hemoglobin`,
ADD COLUMN `hematocrit` DECIMAL(5,2) DEFAULT NULL AFTER `hemoglobin_less_than_zero`,
ADD COLUMN `hematocrit_less_than_zero` VARCHAR(10) DEFAULT NULL AFTER `hematocrit`,
ADD COLUMN `platelets` DECIMAL(5,2) DEFAULT NULL AFTER `hematocrit_less_than_zero`,
ADD COLUMN `platelets_less_than_zero` VARCHAR(10) DEFAULT NULL AFTER `platelets`,
ADD COLUMN `blasts` DECIMAL(5,2) DEFAULT NULL AFTER `platelets_less_than_zero`,
ADD COLUMN `blasts_less_than_zero` VARCHAR(10) DEFAULT NULL AFTER `blasts`,

ADD COLUMN `rbc_transfusion_prior_cbc_test` VARCHAR(10) DEFAULT NULL AFTER `blasts_less_than_zero`,
ADD COLUMN `platelet_transfusion_prior_cbc_test` VARCHAR(10) DEFAULT NULL AFTER `rbc_transfusion_prior_cbc_test`,
ADD COLUMN `leukapheresis_prior_therapy` VARCHAR(10) DEFAULT NULL AFTER `platelet_transfusion_prior_cbc_test`,
ADD COLUMN `date_of_leukapheresis` DATE DEFAULT NULL AFTER `leukapheresis_prior_therapy`,
ADD COLUMN `hydroxyurea_prior_day_zero` VARCHAR(10) DEFAULT NULL AFTER `date_of_leukapheresis`,

ADD COLUMN `oth_malignancy_leukemia` VARCHAR(10) DEFAULT NULL AFTER `hydroxyurea_prior_day_zero`,
ADD COLUMN `oth_malignancy_leukemia_type` VARCHAR(45) DEFAULT NULL AFTER `oth_malignancy_leukemia`,
ADD COLUMN `oth_malignancy_leukemia_year` YEAR DEFAULT NULL AFTER `oth_malignancy_leukemia_type`,
ADD COLUMN `oth_malignancy_breast` VARCHAR(10) DEFAULT NULL AFTER `oth_malignancy_leukemia_year`,
ADD COLUMN `oth_malignancy_breast_year` YEAR DEFAULT NULL AFTER `oth_malignancy_breast`,
ADD COLUMN `oth_malignancy_cns` VARCHAR(10) DEFAULT NULL AFTER `oth_malignancy_breast_year`,
ADD COLUMN `oth_malignancy_cns_year` YEAR DEFAULT NULL AFTER `oth_malignancy_cns`,
ADD COLUMN `oth_malignancy_clonal_cytogenetic_abnormality` VARCHAR(10) DEFAULT NULL AFTER `oth_malignancy_cns_year`,
ADD COLUMN `oth_malignancy_clonal_cytogenetic_abnormality_year` YEAR DEFAULT NULL AFTER `oth_malignancy_clonal_cytogenetic_abnormality`,
ADD COLUMN `oth_malignancy_gastrointestinal` VARCHAR(10) DEFAULT NULL AFTER `oth_malignancy_clonal_cytogenetic_abnormality_year`,
ADD COLUMN `oth_malignancy_gastrointestinal_year` YEAR DEFAULT NULL AFTER `oth_malignancy_gastrointestinal`,
ADD COLUMN `oth_malignancy_genitourinary` VARCHAR(10) DEFAULT NULL AFTER `oth_malignancy_gastrointestinal_year`,
ADD COLUMN `oth_malignancy_genitourinary_year` YEAR DEFAULT NULL AFTER `oth_malignancy_genitourinary`,
ADD COLUMN `oth_malignancy_hodgkin` VARCHAR(10) DEFAULT NULL AFTER `oth_malignancy_genitourinary_year`,
ADD COLUMN `oth_malignancy_hodgkin_year` YEAR DEFAULT NULL AFTER `oth_malignancy_hodgkin`,
ADD COLUMN `oth_malignancy_lung` VARCHAR(10) DEFAULT NULL AFTER `oth_malignancy_hodgkin_year`,
ADD COLUMN `oth_malignancy_lung_year` YEAR DEFAULT NULL AFTER `oth_malignancy_lung`,
ADD COLUMN `oth_malignancy_lymphoma` VARCHAR(10) DEFAULT NULL AFTER `oth_malignancy_lung_year`,
ADD COLUMN `oth_malignancy_lymphoma_year` YEAR DEFAULT NULL AFTER `oth_malignancy_lymphoma`,
ADD COLUMN `oth_malignancy_melanoma` VARCHAR(10) DEFAULT NULL AFTER `oth_malignancy_lymphoma_year`,
ADD COLUMN `oth_malignancy_melanoma_year` YEAR DEFAULT NULL AFTER `oth_malignancy_melanoma`,
ADD COLUMN `oth_malignancy_other_skin` VARCHAR(10) DEFAULT NULL AFTER `oth_malignancy_melanoma_year`,
ADD COLUMN `oth_malignancy_other_skin_year` YEAR DEFAULT NULL AFTER `oth_malignancy_other_skin`,
ADD COLUMN `oth_malignancy_myelodysplasia` VARCHAR(10) DEFAULT NULL AFTER `oth_malignancy_other_skin_year`,
ADD COLUMN `oth_malignancy_myelodysplasia_year` YEAR DEFAULT NULL AFTER `oth_malignancy_myelodysplasia`,
ADD COLUMN `oth_malignancy_oropharyngeal` VARCHAR(10) DEFAULT NULL AFTER `oth_malignancy_myelodysplasia_year`,
ADD COLUMN `oth_malignancy_oropharyngeal_year` YEAR DEFAULT NULL AFTER `oth_malignancy_oropharyngeal`,
ADD COLUMN `oth_malignancy_sarcoma` VARCHAR(10) DEFAULT NULL AFTER `oth_malignancy_oropharyngeal_year`,
ADD COLUMN `oth_malignancy_sarcoma_year` YEAR DEFAULT NULL AFTER `oth_malignancy_sarcoma`,
ADD COLUMN `oth_malignancy_thyroid` VARCHAR(10) DEFAULT NULL AFTER `oth_malignancy_sarcoma_year`,
ADD COLUMN `oth_malignancy_thyroid_year` YEAR DEFAULT NULL AFTER `oth_malignancy_thyroid`,
ADD COLUMN `oth_malignancy_other_prior` VARCHAR(10) DEFAULT NULL AFTER `oth_malignancy_thyroid_year`,
ADD COLUMN `oth_malignancy_other_prior_type` VARCHAR(45) DEFAULT NULL AFTER `oth_malignancy_other_prior`,
ADD COLUMN `oth_malignancy_other_prior_year` YEAR DEFAULT NULL AFTER `oth_malignancy_other_prior_type`,

ADD COLUMN `smoking_history_status` VARCHAR(10) DEFAULT NULL AFTER `hydroxyurea_prior_day_zero`,
ADD COLUMN `smoked_previous_year` VARCHAR(10) DEFAULT NULL AFTER `smoking_history_status`,
ADD COLUMN `smoked_prior_previous_year` VARCHAR(10) DEFAULT NULL AFTER `smoked_previous_year`,
ADD COLUMN `years_smoked` INT(11) DEFAULT NULL AFTER `smoked_prior_previous_year`,
ADD COLUMN `years_smoked_unknown` VARCHAR(10) DEFAULT NULL AFTER `years_smoked`,
ADD COLUMN `alcohol_consumption_pattern` VARCHAR(50) DEFAULT NULL AFTER `years_smoked_unknown`,
ADD COLUMN `alcohol_consumption_greater_month` VARCHAR(10) DEFAULT NULL AFTER `alcohol_consumption_pattern`,

ADD COLUMN `exercise_pattern_previous_five_years` VARCHAR(150) DEFAULT NULL AFTER `alcohol_consumption_greater_month`,
ADD COLUMN `participant_job_or_lifestyle` VARCHAR(50) DEFAULT NULL AFTER `exercise_pattern_previous_five_years`,
ADD COLUMN `exp_acid_mists_inorganic` VARCHAR(10) DEFAULT NULL AFTER `participant_job_or_lifestyle`,
ADD COLUMN `exp_aluminum_production` VARCHAR(10) DEFAULT NULL AFTER `exp_acid_mists_inorganic`,
ADD COLUMN `exp_areca_nut` VARCHAR(10) DEFAULT NULL AFTER `exp_aluminum_production`,
ADD COLUMN `exp_arsenic` VARCHAR(10) DEFAULT NULL AFTER `exp_areca_nut`,
ADD COLUMN `exp_asbestos` VARCHAR(10) DEFAULT NULL AFTER `exp_arsenic`,
ADD COLUMN `exp_benzene` VARCHAR(10) DEFAULT NULL AFTER `exp_asbestos`,
ADD COLUMN `exp_coal_emission` VARCHAR(10) DEFAULT NULL AFTER `exp_benzene`,
ADD COLUMN `exp_diesel_engine_exhaust` VARCHAR(10) DEFAULT NULL AFTER `exp_coal_emission`,
ADD COLUMN `exp_estrogen_postmenopausal_therapy` VARCHAR(10) DEFAULT NULL AFTER `exp_diesel_engine_exhaust`,
ADD COLUMN `exp_estrogen_progesterone_oral_contraceptives` VARCHAR(10) DEFAULT NULL AFTER `exp_estrogen_postmenopausal_therapy`,
ADD COLUMN `exp_formaldehyde` VARCHAR(10) DEFAULT NULL AFTER `exp_estrogen_progesterone_oral_contraceptives`,
ADD COLUMN `exp_radiation` VARCHAR(10) DEFAULT NULL AFTER `exp_formaldehyde`,
ADD COLUMN `exp_second_hand_smoke` VARCHAR(10) DEFAULT NULL AFTER `exp_radiation`,
ADD COLUMN `other_exposure_history` TEXT DEFAULT NULL AFTER `exp_second_hand_smoke`;

ALTER TABLE `ed_tfri_clinical_section_1_revs` 
ADD COLUMN `karnofsky_performance_baseline` INT DEFAULT NULL AFTER `event_master_id`,
ADD COLUMN `karnofsky_date_baseline` DATE DEFAULT NULL AFTER `karnofsky_performance_baseline`,
ADD COLUMN `baseline_weight` DECIMAL (5,2) DEFAULT NULL AFTER `karnofsky_date_baseline`,
ADD COLUMN `baseline_height` INT DEFAULT NULL AFTER `baseline_weight`,

ADD COLUMN `med_history_autoimmune_disease` VARCHAR(10) DEFAULT NULL AFTER `baseline_height`,
ADD COLUMN `med_history_autoimmune_disease_type` VARCHAR(45) DEFAULT NULL AFTER `med_history_autoimmune_disease`,
ADD COLUMN `med_history_autoimmune_disease_other` VARCHAR(150) DEFAULT NULL AFTER `med_history_autoimmune_disease_type`,
ADD COLUMN `med_history_cardiovascular_disease` VARCHAR(10) DEFAULT NULL AFTER `med_history_autoimmune_disease_other`,
ADD COLUMN `med_history_cardiovascular_disease_type` VARCHAR(45) DEFAULT NULL AFTER `med_history_cardiovascular_disease`,
ADD COLUMN `med_history_cardiovascular_disease_other` VARCHAR(150) DEFAULT NULL AFTER `med_history_cardiovascular_disease_type`,

ADD COLUMN `med_history_chromosome_abnormality` VARCHAR(10) DEFAULT NULL AFTER `med_history_cardiovascular_disease_other`,
ADD COLUMN `med_history_chromosome_abnormality_type` VARCHAR(45) DEFAULT NULL AFTER `med_history_chromosome_abnormality`,
ADD COLUMN `med_history_chromosome_abnormality_other` VARCHAR(150) DEFAULT NULL AFTER `med_history_chromosome_abnormality_type`,
ADD COLUMN `med_history_cns_psychiatric` VARCHAR(10) DEFAULT NULL AFTER `med_history_chromosome_abnormality_other`,
ADD COLUMN `med_history_cns_psychiatric_type` VARCHAR(45) DEFAULT NULL AFTER `med_history_cns_psychiatric`,
ADD COLUMN `med_history_cns_psychiatric_other` VARCHAR(150) DEFAULT NULL AFTER `med_history_cns_psychiatric_type`,
ADD COLUMN `med_history_endocrine` VARCHAR(10) DEFAULT NULL AFTER `med_history_cns_psychiatric_other`,
ADD COLUMN `med_history_endocrine_type` VARCHAR(45) DEFAULT NULL AFTER `med_history_endocrine`,
ADD COLUMN `med_history_endocrine_other` VARCHAR(150) DEFAULT NULL AFTER `med_history_endocrine_type`,
ADD COLUMN `med_history_gastrointestinal` VARCHAR(10) DEFAULT NULL AFTER `med_history_endocrine_other`,
ADD COLUMN `med_history_gastrointestinal_type` VARCHAR(45) DEFAULT NULL AFTER `med_history_gastrointestinal`,
ADD COLUMN `med_history_gastrointestinal_other` VARCHAR(150) DEFAULT NULL AFTER `med_history_gastrointestinal_type`,
ADD COLUMN `med_history_genitourinary` VARCHAR(10) DEFAULT NULL AFTER `med_history_gastrointestinal_other`,
ADD COLUMN `med_history_genitourinary_type` VARCHAR(45) DEFAULT NULL AFTER `med_history_genitourinary`,
ADD COLUMN `med_history_genitourinary_other` VARCHAR(150) DEFAULT NULL AFTER `med_history_genitourinary_type`,
ADD COLUMN `med_history_hematologic` VARCHAR(10) DEFAULT NULL AFTER `med_history_genitourinary_other`,
ADD COLUMN `med_history_hematologic_type` VARCHAR(45) DEFAULT NULL AFTER `med_history_hematologic`,
ADD COLUMN `med_history_hematologic_other` VARCHAR(150) DEFAULT NULL AFTER `med_history_hematologic_type`,
ADD COLUMN `med_history_liver_disease` VARCHAR(10) DEFAULT NULL AFTER `med_history_hematologic_other`,
ADD COLUMN `med_history_liver_disease_type` VARCHAR(45) DEFAULT NULL AFTER `med_history_liver_disease`,
ADD COLUMN `med_history_liver_disease_other` VARCHAR(150) DEFAULT NULL AFTER `med_history_liver_disease_type`,
ADD COLUMN `med_history_pulmonary` VARCHAR(10) DEFAULT NULL AFTER `med_history_liver_disease_other`,
ADD COLUMN `med_history_pulmonary_type` VARCHAR(45) DEFAULT NULL AFTER `med_history_pulmonary`,
ADD COLUMN `med_history_pulmonary_other` VARCHAR(150) DEFAULT NULL AFTER `med_history_pulmonary_type`,
ADD COLUMN `med_history_infectious` VARCHAR(10) DEFAULT NULL AFTER `med_history_pulmonary_other`,
ADD COLUMN `med_history_infectious_type` VARCHAR(45) DEFAULT NULL AFTER `med_history_infectious`,
ADD COLUMN `med_history_infectious_other` VARCHAR(150) DEFAULT NULL AFTER `med_history_infectious_type`,
ADD COLUMN `med_history_co-existing` VARCHAR(10) DEFAULT NULL AFTER `med_history_infectious_other`,
ADD COLUMN `med_history_co-existing_other` VARCHAR(150) DEFAULT NULL AFTER `med_history_co-existing`,
ADD COLUMN `med_history_co-existing_other_two` VARCHAR(150) DEFAULT NULL AFTER `med_history_co-existing_other`,

ADD COLUMN `flt_status_at_dx` VARCHAR(75) DEFAULT NULL AFTER `med_history_co-existing_other`,
ADD COLUMN `flt_status` VARCHAR(45) DEFAULT NULL AFTER `flt_status_at_dx`,
ADD COLUMN `flt_date_collection` DATE DEFAULT NULL AFTER `flt_status`,
ADD COLUMN `flt_date_collection_status` VARCHAR(45) DEFAULT NULL AFTER `flt_date_collection`,
ADD COLUMN `npm_status_at_dx` VARCHAR(75) DEFAULT NULL AFTER `flt_date_collection_status`,
ADD COLUMN `npm_status` VARCHAR(45) DEFAULT NULL AFTER `npm_status_at_dx`,
ADD COLUMN `npm_date_of_collection` DATE DEFAULT NULL AFTER `npm_status`,
ADD COLUMN `npm_date_collection_status` VARCHAR(45) DEFAULT NULL AFTER `npm_date_of_collection`,
ADD COLUMN `cepba_status_at_dx` VARCHAR(75) DEFAULT NULL AFTER `npm_date_collection_status`,
ADD COLUMN `cepba_status` VARCHAR(45) DEFAULT NULL AFTER `cepba_status_at_dx`,
ADD COLUMN `cepba_date_of_collection` DATE DEFAULT NULL AFTER `cepba_status`,
ADD COLUMN `cepba_date_collection_status` VARCHAR(45) DEFAULT NULL AFTER `cepba_date_of_collection`,
ADD COLUMN `other_genetic_testing` TEXT DEFAULT NULL AFTER `cepba_date_collection_status`,

ADD COLUMN `ast_sgot` DECIMAL(5,2) DEFAULT NULL AFTER `other_genetic_testing`,
ADD COLUMN `ast_sgot_date_collection` DATE DEFAULT NULL AFTER `ast_sgot`,
ADD COLUMN `total_bilirubin` DECIMAL(5,2) DEFAULT NULL AFTER `ast_sgot_date_collection`,
ADD COLUMN `total_bilirubin_date_collection` DATE DEFAULT NULL AFTER `total_bilirubin`,
ADD COLUMN `creatinine` DECIMAL(5,2) DEFAULT NULL AFTER `total_bilirubin_date_collection`,
ADD COLUMN `creatinine_date_collection` DATE DEFAULT NULL AFTER `creatinine`,

ADD COLUMN `date_of_cbc` DATE DEFAULT NULL AFTER `creatinine_date_collection`,
ADD COLUMN `wbc` DECIMAL(5,2) DEFAULT NULL AFTER `date_of_cbc`,
ADD COLUMN `wbc_less_than_zero` VARCHAR(10) DEFAULT NULL AFTER `wbc`,
ADD COLUMN `neutrophils` DECIMAL(5,2) DEFAULT NULL AFTER `wbc_less_than_zero`,
ADD COLUMN `neutrophils_less_than_zero` VARCHAR(10) DEFAULT NULL AFTER `neutrophils`,
ADD COLUMN `lymphocytes` DECIMAL(5,2) DEFAULT NULL AFTER `neutrophils_less_than_zero`,
ADD COLUMN `lymphocytes_less_than_zero` VARCHAR(10) DEFAULT NULL AFTER `lymphocytes`,
ADD COLUMN `hemoglobin` DECIMAL(5,2) DEFAULT NULL AFTER `lymphocytes_less_than_zero`,
ADD COLUMN `hemoglobin_less_than_zero` VARCHAR(10) DEFAULT NULL AFTER `hemoglobin`,
ADD COLUMN `hematocrit` DECIMAL(5,2) DEFAULT NULL AFTER `hemoglobin_less_than_zero`,
ADD COLUMN `hematocrit_less_than_zero` VARCHAR(10) DEFAULT NULL AFTER `hematocrit`,
ADD COLUMN `platelets` DECIMAL(5,2) DEFAULT NULL AFTER `hematocrit_less_than_zero`,
ADD COLUMN `platelets_less_than_zero` VARCHAR(10) DEFAULT NULL AFTER `platelets`,
ADD COLUMN `blasts` DECIMAL(5,2) DEFAULT NULL AFTER `platelets_less_than_zero`,
ADD COLUMN `blasts_less_than_zero` VARCHAR(10) DEFAULT NULL AFTER `blasts`,

ADD COLUMN `rbc_transfusion_prior_cbc_test` VARCHAR(10) DEFAULT NULL AFTER `blasts_less_than_zero`,
ADD COLUMN `platelet_transfusion_prior_cbc_test` VARCHAR(10) DEFAULT NULL AFTER `rbc_transfusion_prior_cbc_test`,
ADD COLUMN `leukapheresis_prior_therapy` VARCHAR(10) DEFAULT NULL AFTER `platelet_transfusion_prior_cbc_test`,
ADD COLUMN `date_of_leukapheresis` DATE DEFAULT NULL AFTER `leukapheresis_prior_therapy`,
ADD COLUMN `hydroxyurea_prior_day_zero` VARCHAR(10) DEFAULT NULL AFTER `date_of_leukapheresis`,

ADD COLUMN `oth_malignancy_leukemia` VARCHAR(10) DEFAULT NULL AFTER `hydroxyurea_prior_day_zero`,
ADD COLUMN `oth_malignancy_leukemia_type` VARCHAR(45) DEFAULT NULL AFTER `oth_malignancy_leukemia`,
ADD COLUMN `oth_malignancy_leukemia_year` YEAR DEFAULT NULL AFTER `oth_malignancy_leukemia_type`,
ADD COLUMN `oth_malignancy_breast` VARCHAR(10) DEFAULT NULL AFTER `oth_malignancy_leukemia_year`,
ADD COLUMN `oth_malignancy_breast_year` YEAR DEFAULT NULL AFTER `oth_malignancy_breast`,
ADD COLUMN `oth_malignancy_cns` VARCHAR(10) DEFAULT NULL AFTER `oth_malignancy_breast_year`,
ADD COLUMN `oth_malignancy_cns_year` YEAR DEFAULT NULL AFTER `oth_malignancy_cns`,
ADD COLUMN `oth_malignancy_clonal_cytogenetic_abnormality` VARCHAR(10) DEFAULT NULL AFTER `oth_malignancy_cns_year`,
ADD COLUMN `oth_malignancy_clonal_cytogenetic_abnormality_year` YEAR DEFAULT NULL AFTER `oth_malignancy_clonal_cytogenetic_abnormality`,
ADD COLUMN `oth_malignancy_gastrointestinal` VARCHAR(10) DEFAULT NULL AFTER `oth_malignancy_clonal_cytogenetic_abnormality_year`,
ADD COLUMN `oth_malignancy_gastrointestinal_year` YEAR DEFAULT NULL AFTER `oth_malignancy_gastrointestinal`,
ADD COLUMN `oth_malignancy_genitourinary` VARCHAR(10) DEFAULT NULL AFTER `oth_malignancy_gastrointestinal_year`,
ADD COLUMN `oth_malignancy_genitourinary_year` YEAR DEFAULT NULL AFTER `oth_malignancy_genitourinary`,
ADD COLUMN `oth_malignancy_hodgkin` VARCHAR(10) DEFAULT NULL AFTER `oth_malignancy_genitourinary_year`,
ADD COLUMN `oth_malignancy_hodgkin_year` YEAR DEFAULT NULL AFTER `oth_malignancy_hodgkin`,
ADD COLUMN `oth_malignancy_lung` VARCHAR(10) DEFAULT NULL AFTER `oth_malignancy_hodgkin_year`,
ADD COLUMN `oth_malignancy_lung_year` YEAR DEFAULT NULL AFTER `oth_malignancy_lung`,
ADD COLUMN `oth_malignancy_lymphoma` VARCHAR(10) DEFAULT NULL AFTER `oth_malignancy_lung_year`,
ADD COLUMN `oth_malignancy_lymphoma_year` YEAR DEFAULT NULL AFTER `oth_malignancy_lymphoma`,
ADD COLUMN `oth_malignancy_melanoma` VARCHAR(10) DEFAULT NULL AFTER `oth_malignancy_lymphoma_year`,
ADD COLUMN `oth_malignancy_melanoma_year` YEAR DEFAULT NULL AFTER `oth_malignancy_melanoma`,
ADD COLUMN `oth_malignancy_other_skin` VARCHAR(10) DEFAULT NULL AFTER `oth_malignancy_melanoma_year`,
ADD COLUMN `oth_malignancy_other_skin_year` YEAR DEFAULT NULL AFTER `oth_malignancy_other_skin`,
ADD COLUMN `oth_malignancy_myelodysplasia` VARCHAR(10) DEFAULT NULL AFTER `oth_malignancy_other_skin_year`,
ADD COLUMN `oth_malignancy_myelodysplasia_year` YEAR DEFAULT NULL AFTER `oth_malignancy_myelodysplasia`,
ADD COLUMN `oth_malignancy_oropharyngeal` VARCHAR(10) DEFAULT NULL AFTER `oth_malignancy_myelodysplasia_year`,
ADD COLUMN `oth_malignancy_oropharyngeal_year` YEAR DEFAULT NULL AFTER `oth_malignancy_oropharyngeal`,
ADD COLUMN `oth_malignancy_sarcoma` VARCHAR(10) DEFAULT NULL AFTER `oth_malignancy_oropharyngeal_year`,
ADD COLUMN `oth_malignancy_sarcoma_year` YEAR DEFAULT NULL AFTER `oth_malignancy_sarcoma`,
ADD COLUMN `oth_malignancy_thyroid` VARCHAR(10) DEFAULT NULL AFTER `oth_malignancy_sarcoma_year`,
ADD COLUMN `oth_malignancy_thyroid_year` YEAR DEFAULT NULL AFTER `oth_malignancy_thyroid`,
ADD COLUMN `oth_malignancy_other_prior` VARCHAR(10) DEFAULT NULL AFTER `oth_malignancy_thyroid_year`,
ADD COLUMN `oth_malignancy_other_prior_type` VARCHAR(45) DEFAULT NULL AFTER `oth_malignancy_other_prior`,
ADD COLUMN `oth_malignancy_other_prior_year` YEAR DEFAULT NULL AFTER `oth_malignancy_other_prior_type`,

ADD COLUMN `smoking_history_status` VARCHAR(10) DEFAULT NULL AFTER `hydroxyurea_prior_day_zero`,
ADD COLUMN `smoked_previous_year` VARCHAR(10) DEFAULT NULL AFTER `smoking_history_status`,
ADD COLUMN `smoked_prior_previous_year` VARCHAR(10) DEFAULT NULL AFTER `smoked_previous_year`,
ADD COLUMN `years_smoked` INT(11) DEFAULT NULL AFTER `smoked_prior_previous_year`,
ADD COLUMN `years_smoked_unknown` VARCHAR(10) DEFAULT NULL AFTER `years_smoked`,
ADD COLUMN `alcohol_consumption_pattern` VARCHAR(50) DEFAULT NULL AFTER `years_smoked_unknown`,
ADD COLUMN `alcohol_consumption_greater_month` VARCHAR(10) DEFAULT NULL AFTER `alcohol_consumption_pattern`,

ADD COLUMN `exercise_pattern_previous_five_years` VARCHAR(150) DEFAULT NULL AFTER `alcohol_consumption_greater_month`,
ADD COLUMN `participant_job_or_lifestyle` VARCHAR(50) DEFAULT NULL AFTER `exercise_pattern_previous_five_years`,
ADD COLUMN `exp_acid_mists_inorganic` VARCHAR(10) DEFAULT NULL AFTER `participant_job_or_lifestyle`,
ADD COLUMN `exp_aluminum_production` VARCHAR(10) DEFAULT NULL AFTER `exp_acid_mists_inorganic`,
ADD COLUMN `exp_areca_nut` VARCHAR(10) DEFAULT NULL AFTER `exp_aluminum_production`,
ADD COLUMN `exp_arsenic` VARCHAR(10) DEFAULT NULL AFTER `exp_areca_nut`,
ADD COLUMN `exp_asbestos` VARCHAR(10) DEFAULT NULL AFTER `exp_arsenic`,
ADD COLUMN `exp_benzene` VARCHAR(10) DEFAULT NULL AFTER `exp_asbestos`,
ADD COLUMN `exp_coal_emission` VARCHAR(10) DEFAULT NULL AFTER `exp_benzene`,
ADD COLUMN `exp_diesel_engine_exhaust` VARCHAR(10) DEFAULT NULL AFTER `exp_coal_emission`,
ADD COLUMN `exp_estrogen_postmenopausal_therapy` VARCHAR(10) DEFAULT NULL AFTER `exp_diesel_engine_exhaust`,
ADD COLUMN `exp_estrogen_progesterone_oral_contraceptives` VARCHAR(10) DEFAULT NULL AFTER `exp_estrogen_postmenopausal_therapy`,
ADD COLUMN `exp_formaldehyde` VARCHAR(10) DEFAULT NULL AFTER `exp_estrogen_progesterone_oral_contraceptives`,
ADD COLUMN `exp_radiation` VARCHAR(10) DEFAULT NULL AFTER `exp_formaldehyde`,
ADD COLUMN `exp_second_hand_smoke` VARCHAR(10) DEFAULT NULL AFTER `exp_radiation`,
ADD COLUMN `other_exposure_history` TEXT DEFAULT NULL AFTER `exp_second_hand_smoke`;

-- Value Domain KPS Options
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("kps_options", "open", "", NULL);
INSERT INTO structure_permissible_values (value, language_alias) VALUES("100 normal, no complaints or evidence of disease", "100 normal, no complaints or evidence of disease");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="kps_options"), (SELECT id FROM structure_permissible_values WHERE value="100 normal, no complaints or evidence of disease" AND language_alias="100 normal, no complaints or evidence of disease"), "1", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("90 able to perform normal activity; minor signs and symptoms of disease", "90 able to perform normal activity; minor signs and symptoms of disease");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="kps_options"), (SELECT id FROM structure_permissible_values WHERE value="90 able to perform normal activity; minor signs and symptoms of disease" AND language_alias="90 able to perform normal activity; minor signs and symptoms of disease"), "2", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("80 able to perform normal activity with effort; some signs and symptoms of disease", "80 able to perform normal activity with effort; some signs and symptoms of disease");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="kps_options"), (SELECT id FROM structure_permissible_values WHERE value="80 able to perform normal activity with effort; some signs and symptoms of disease" AND language_alias="80 able to perform normal activity with effort; some signs and symptoms of disease"), "3", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("70 cares for self, unable to perform normal activity or to do active work", "70 cares for self, unable to perform normal activity or to do active work");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="kps_options"), (SELECT id FROM structure_permissible_values WHERE value="70 cares for self, unable to perform normal activity or to do active work" AND language_alias="70 cares for self, unable to perform normal activity or to do active work"), "4", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("60 requires occasional assistance but is able to care for most of own needs", "60 requires occasional assistance but is able to care for most of own needs");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="kps_options"), (SELECT id FROM structure_permissible_values WHERE value="60 requires occasional assistance but is able to care for most of own needs" AND language_alias="60 requires occasional assistance but is able to care for most of own needs"), "5", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("50 requires considerable assistance and frequent medical care", "50 requires considerable assistance and frequent medical care");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="kps_options"), (SELECT id FROM structure_permissible_values WHERE value="50 requires considerable assistance and frequent medical care" AND language_alias="50 requires considerable assistance and frequent medical care"), "6", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("40 requires special care and assistance; disabled", "40 requires special care and assistance; disabled");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="kps_options"), (SELECT id FROM structure_permissible_values WHERE value="40 requires special care and assistance; disabled" AND language_alias="40 requires special care and assistance; disabled"), "7", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("30 hospitalization indicated, although death not imminent; severely disabled", "30 hospitalization indicated, although death not imminent; severely disabled");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="kps_options"), (SELECT id FROM structure_permissible_values WHERE value="30 hospitalization indicated, although death not imminent; severely disabled" AND language_alias="30 hospitalization indicated, although death not imminent; severely disabled"), "8", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("20 hospitalization necessary; active supportive treatment required, very sick", "20 hospitalization necessary; active supportive treatment required, very sick");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="kps_options"), (SELECT id FROM structure_permissible_values WHERE value="20 hospitalization necessary; active supportive treatment required, very sick" AND language_alias="20 hospitalization necessary; active supportive treatment required, very sick"), "9", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("10 fatal processess progressing rapidly; moribund", "10 fatal processess progressing rapidly; moribund");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="kps_options"), (SELECT id FROM structure_permissible_values WHERE value="10 fatal processess progressing rapidly; moribund" AND language_alias="10 fatal processess progressing rapidly; moribund"), "10", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("0 dead", "0 dead");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="kps_options"), (SELECT id FROM structure_permissible_values WHERE value="0 dead" AND language_alias="0 dead"), "11", "1");

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
 ('100 normal, no complaints or evidence of disease', '100: Normal, no complaints or evidence of disease', ''),
 ('90 able to perform normal activity; minor signs and symptoms of disease', '90: Able to perform normal activity; minor signs and symptoms of disease', ''),
 ('80 able to perform normal activity with effort; some signs and symptoms of disease', '80: Able to perform normal activity with effort; some signs and symptoms of disease', ''),
 ('70 cares for self, unable to perform normal activity or to do active work', '70: Cares for self, unable to perform normal activity or to do active work', ''),
 ('60 requires occasional assistance but is able to care for most of own needs', '60: Requires occasional assistance but is able to care for most of own needs', ''),
 ('50 requires considerable assistance and frequent medical care', '50: Requires considerable assistance and frequent medical care', ''),
 ('40 requires special care and assistance; disabled', '40: Requires special care and assistance; disabled', ''),
 ('30 hospitalization indicated, although death not imminent; severely disabled', '30: Hospitalization indicated, although death not imminent; severely disabled', ''),
 ('20 hospitalization necessary; active supportive treatment required, very sick', '20: Hospitalization necessary; active supportive treatment required, very sick', ''),
 ('10 fatal processess progressing rapidly; moribund', '10: Fatal processess progressing rapidly; moribund', ''),
 ('0 dead', '0: Dead', '');

-- Value Domain KPS Options
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("autoimmune_options", "open", "", NULL);
INSERT INTO structure_permissible_values (value, language_alias) VALUES("multiple sclerosis", "multiple sclerosis");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="autoimmune_options"), (SELECT id FROM structure_permissible_values WHERE value="multiple sclerosis" AND language_alias="multiple sclerosis"), "1", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("polyarteritis nodosa", "polyarteritis nodosa");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="autoimmune_options"), (SELECT id FROM structure_permissible_values WHERE value="polyarteritis nodosa" AND language_alias="polyarteritis nodosa"), "2", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("psoriasis", "psoriasis");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="autoimmune_options"), (SELECT id FROM structure_permissible_values WHERE value="psoriasis" AND language_alias="psoriasis"), "3", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("rheumatoid arthritis", "rheumatoid arthritis");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="autoimmune_options"), (SELECT id FROM structure_permissible_values WHERE value="rheumatoid arthritis" AND language_alias="rheumatoid arthritis"), "4", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("lupus", "lupus");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="autoimmune_options"), (SELECT id FROM structure_permissible_values WHERE value="lupus" AND language_alias="lupus"), "5", "1");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="autoimmune_options"), (SELECT id FROM structure_permissible_values WHERE value="other" AND language_alias="other"), "6", "1");

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
 ('multiple sclerosis', 'multiple sclerosis', ''),
 ('polyarteritis nodosa', 'polyarteritis nodosa', ''),
 ('psoriasis', 'psoriasis', ''),
 ('rheumatoid arthritis', 'rheumatoid arthritis', ''),
 ('lupus', 'lupus', '');

-- Value Domain cardiovascular disease
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("cardiovascular_options", "open", "", NULL);
INSERT INTO structure_permissible_values (value, language_alias) VALUES("atrial fibrillation", "atrial fibrillation");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="cardiovascular_options"), (SELECT id FROM structure_permissible_values WHERE value="atrial fibrillation" AND language_alias="atrial fibrillation"), "1", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("other arhythmias", "other arhythmias");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="cardiovascular_options"), (SELECT id FROM structure_permissible_values WHERE value="other arhythmias" AND language_alias="other arhythmias"), "2", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("congestive heart failure", "congestive heart failure");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="cardiovascular_options"), (SELECT id FROM structure_permissible_values WHERE value="congestive heart failure" AND language_alias="congestive heart failure"), "3", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("coronary artery disease (no prior MI)", "coronary artery disease (no prior MI)");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="cardiovascular_options"), (SELECT id FROM structure_permissible_values WHERE value="coronary artery disease (no prior MI)" AND language_alias="coronary artery disease (no prior MI)"), "4", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("hypertension", "hypertension");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="cardiovascular_options"), (SELECT id FROM structure_permissible_values WHERE value="hypertension" AND language_alias="hypertension"), "5", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("myocardial infarction", "myocardial infarction");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="cardiovascular_options"), (SELECT id FROM structure_permissible_values WHERE value="myocardial infarction" AND language_alias="myocardial infarction"), "6", "1");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="cardiovascular_options"), (SELECT id FROM structure_permissible_values WHERE value="other" AND language_alias="other"), "7", "1");

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
 ('atrial fibrillation', 'atrial fibrillation', ''),
 ('other arhythmias', 'other arhythmias', ''),
 ('congestive heart failure', 'congestive heart failure', ''),
 ('coronary artery disease (no prior MI)', 'coronary artery disease (no prior MI)', ''),
 ('hypertension', 'hypertension', ''),
 ('myocardial infarction', 'myocardial infarction', '');

-- Value Domain chromosome_options
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("chromosome_options", "open", "", NULL);
INSERT INTO structure_permissible_values (value, language_alias) VALUES("down syndrome", "down syndrome");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="chromosome_options"), (SELECT id FROM structure_permissible_values WHERE value="down syndrome" AND language_alias="down syndrome"), "1", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("fanconi anemia", "fanconi anemia");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="chromosome_options"), (SELECT id FROM structure_permissible_values WHERE value="fanconi anemia" AND language_alias="fanconi anemia"), "2", "1");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="chromosome_options"), (SELECT id FROM structure_permissible_values WHERE value="other" AND language_alias="other"), "3", "1");

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
 ('down syndrome', 'down syndrome', ''),
 ('fanconi anemia', 'fanconi anemia', '');

-- Value Domain cns/psychiatric
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("cns_psychiatric_options", "open", "", NULL);
INSERT INTO structure_permissible_values (value, language_alias) VALUES("depression requiring treatment", "depression requiring treatment");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="cns_psychiatric_options"), (SELECT id FROM structure_permissible_values WHERE value="depression requiring treatment" AND language_alias="depression requiring treatment"), "1", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("paralysis", "paralysis");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="cns_psychiatric_options"), (SELECT id FROM structure_permissible_values WHERE value="paralysis" AND language_alias="paralysis"), "2", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("meningitis/encephalitis", "meningitis/encephalitis");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="cns_psychiatric_options"), (SELECT id FROM structure_permissible_values WHERE value="meningitis/encephalitis" AND language_alias="meningitis/encephalitis"), "3", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("seizure disorder", "seizure disorder");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="cns_psychiatric_options"), (SELECT id FROM structure_permissible_values WHERE value="seizure disorder" AND language_alias="seizure disorder"), "4", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("stroke/cerebrovascular accident", "stroke/cerebrovascular accident");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="cns_psychiatric_options"), (SELECT id FROM structure_permissible_values WHERE value="stroke/cerebrovascular accident" AND language_alias="stroke/cerebrovascular accident"), "5", "1");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="cns_psychiatric_options"), (SELECT id FROM structure_permissible_values WHERE value="other" AND language_alias="other"), "6", "1");

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
 ('depression requiring treatment', 'depression requiring treatment', ''),
 ('paralysis', 'paralysis', ''),
 ('meningitis/encephalitis', 'meningitis/encephalitis', ''),
 ('seizure disorder', 'seizure disorder', ''),
 ('stroke/cerebrovascular accident', 'stroke/cerebrovascular accident', '');
 
 
-- Value Domain endocrine
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("endocrine_options", "open", "", NULL);
INSERT INTO structure_permissible_values (value, language_alias) VALUES("adrenal insufficiency", "adrenal insufficiency");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="endocrine_options"), (SELECT id FROM structure_permissible_values WHERE value="adrenal insufficiency" AND language_alias="adrenal insufficiency"), "1", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("diabetes mellitus", "diabetes mellitus");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="endocrine_options"), (SELECT id FROM structure_permissible_values WHERE value="diabetes mellitus" AND language_alias="diabetes mellitus"), "2", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("osteoporosis", "osteoporosis");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="endocrine_options"), (SELECT id FROM structure_permissible_values WHERE value="osteoporosis" AND language_alias="osteoporosis"), "3", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("thyroid disease", "thyroid disease");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="endocrine_options"), (SELECT id FROM structure_permissible_values WHERE value="thyroid disease" AND language_alias="thyroid disease"), "4", "1");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="endocrine_options"), (SELECT id FROM structure_permissible_values WHERE value="other" AND language_alias="other"), "5", "1");

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
 ('adrenal insufficiency', 'adrenal insufficiency', ''),
 ('diabetes mellitus', 'diabetes mellitus', ''),
 ('osteoporosis', 'osteoporosis', ''),
 ('thyroid disease', 'thyroid disease', '');

-- Value Domain gastrointestinal
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("gastrointestinal_options", "open", "", NULL);
INSERT INTO structure_permissible_values (value, language_alias) VALUES("crohn\'s disease", "crohn\'s disease");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="gastrointestinal_options"), (SELECT id FROM structure_permissible_values WHERE value="crohn\'s disease" AND language_alias="crohn\'s disease"), "1", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("peptic ulcer", "peptic ulcer");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="gastrointestinal_options"), (SELECT id FROM structure_permissible_values WHERE value="peptic ulcer" AND language_alias="peptic ulcer"), "2", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("gastroesophageal reflux disease", "gastroesophageal reflux disease");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="gastrointestinal_options"), (SELECT id FROM structure_permissible_values WHERE value="gastroesophageal reflux disease" AND language_alias="gastroesophageal reflux disease"), "3", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("ulcerative colitis", "ulcerative colitis");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="gastrointestinal_options"), (SELECT id FROM structure_permissible_values WHERE value="ulcerative colitis" AND language_alias="ulcerative colitis"), "4", "1");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="gastrointestinal_options"), (SELECT id FROM structure_permissible_values WHERE value="other" AND language_alias="other"), "5", "1");

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
 ("crohn\'s disease", "crohn\'s disease", ''),
 ('peptic ulcer', 'peptic ulcer', ''),
 ('gastroesophageal reflux disease', 'gastroesophageal reflux disease', ''),
 ('ulcerative colitis', 'ulcerative colitis', '');

-- Value Domain genitourinary
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("genitourinary_options", "open", "", NULL);
INSERT INTO structure_permissible_values (value, language_alias) VALUES("renal failure requiring dialysis", "renal failure requiring dialysis");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="genitourinary_options"), (SELECT id FROM structure_permissible_values WHERE value="renal failure requiring dialysis" AND language_alias="renal failure requiring dialysis"), "1", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("renal insufficiency requiring medical attention", "renal insufficiency requiring medical attention");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="genitourinary_options"), (SELECT id FROM structure_permissible_values WHERE value="renal insufficiency requiring medical attention" AND language_alias="renal insufficiency requiring medical attention"), "2", "1");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="genitourinary_options"), (SELECT id FROM structure_permissible_values WHERE value="other" AND language_alias="other"), "3", "1");

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
 ('renal failure requiring dialysis', 'renal failure requiring dialysis', ''),
 ('renal insufficiency requiring medical attention', 'renal insufficiency requiring medical attention', '');

-- Value Domain hematologic
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("hematologic_options", "open", "", NULL);
INSERT INTO structure_permissible_values (value, language_alias) VALUES("deep vein thrombosis", "deep vein thrombosis");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="hematologic_options"), (SELECT id FROM structure_permissible_values WHERE value="deep vein thrombosis" AND language_alias="deep vein thrombosis"), "1", "1");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="hematologic_options"), (SELECT id FROM structure_permissible_values WHERE value="other" AND language_alias="other"), "2", "1");

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
 ('deep vein thrombosis', 'deep vein thrombosis', '');


-- Value Domain liver disease
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("liver_disease_options", "open", "", NULL);
INSERT INTO structure_permissible_values (value, language_alias) VALUES("drug toxicity", "drug toxicity");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="liver_disease_options"), (SELECT id FROM structure_permissible_values WHERE value="drug toxicity" AND language_alias="drug toxicity"), "1", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("hepatitis A virus", "hepatitis A virus");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="liver_disease_options"), (SELECT id FROM structure_permissible_values WHERE value="hepatitis A virus" AND language_alias="hepatitis A virus"), "2", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("hepatitis B virus", "hepatitis B virus");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="liver_disease_options"), (SELECT id FROM structure_permissible_values WHERE value="hepatitis B virus" AND language_alias="hepatitis B virus"), "3", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("hepatitis C virus", "hepatitis C virus");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="liver_disease_options"), (SELECT id FROM structure_permissible_values WHERE value="hepatitis C virus" AND language_alias="hepatitis C virus"), "4", "1");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="liver_disease_options"), (SELECT id FROM structure_permissible_values WHERE value="other" AND language_alias="other"), "5", "1");

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
 ('drug toxicity', 'drug toxicity', ''),
 ('hepatitis A virus', 'hepatitis A virus', ''),
 ('hepatitis B virus', 'hepatitis B virus', ''),
 ('hepatitis C virus', 'hepatitis C virus', '');

-- Value Domain pulmonary
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("pulmonary_options", "open", "", NULL);
INSERT INTO structure_permissible_values (value, language_alias) VALUES("asthma/reactive airway disease", "asthma/reactive airway disease");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="pulmonary_options"), (SELECT id FROM structure_permissible_values WHERE value="asthma/reactive airway disease" AND language_alias="asthma/reactive airway disease"), "1", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("restrictive lung disease", "restrictive lung disease");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="pulmonary_options"), (SELECT id FROM structure_permissible_values WHERE value="restrictive lung disease" AND language_alias="restrictive lung disease"), "2", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("COPD", "COPD");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="pulmonary_options"), (SELECT id FROM structure_permissible_values WHERE value="COPD" AND language_alias="COPD"), "3", "1");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="pulmonary_options"), (SELECT id FROM structure_permissible_values WHERE value="other" AND language_alias="other"), "4", "1");

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
 ('asthma/reactive airway disease', 'asthma/reactive airway disease', ''),
 ('restrictive lung disease', 'restrictive lung disease', ''),
 ('COPD', 'COPD', '');

-- Value Domain other significant infectious
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("other_significant_infectious_options", "open", "", NULL);
INSERT INTO structure_permissible_values (value, language_alias) VALUES("EBV positive", "EBV positive");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="other_significant_infectious_options"), (SELECT id FROM structure_permissible_values WHERE value="EBV positive" AND language_alias="EBV positive"), "1", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("HIV positive", "HIV positive");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="other_significant_infectious_options"), (SELECT id FROM structure_permissible_values WHERE value="HIV positive" AND language_alias="HIV positive"), "2", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("HTLV I/II", "HTLV I/II");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="other_significant_infectious_options"), (SELECT id FROM structure_permissible_values WHERE value="HTLV I/II" AND language_alias="HTLV I/II"), "3", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("helicobacter pylori", "helicobacter pylori");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="other_significant_infectious_options"), (SELECT id FROM structure_permissible_values WHERE value="helicobacter pylori" AND language_alias="helicobacter pylori"), "4", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("human papiloma virus (HPV)", "human papiloma virus (HPV)");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="other_significant_infectious_options"), (SELECT id FROM structure_permissible_values WHERE value="human papiloma virus (HPV)" AND language_alias="human papiloma virus (HPV)"), "5", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("opisthorchis viverrini (liver fluke)", "opisthorchis viverrini (liver fluke)");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="other_significant_infectious_options"), (SELECT id FROM structure_permissible_values WHERE value="opisthorchis viverrini (liver fluke)" AND language_alias="opisthorchis viverrini (liver fluke)"), "6", "1");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="other_significant_infectious_options"), (SELECT id FROM structure_permissible_values WHERE value="other" AND language_alias="other"), "7", "1");

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
 ('EBV positiv', 'EBV positiv', ''),
 ('HIV positive', 'HIV positive', ''),
 ('HTLV I/II', 'HTLV I/II', ''),
 ('helicobacter pylori', 'helicobacter pylori', ''),
 ('human papiloma virus (HPV)', 'human papiloma virus (HPV)', ''),
 ('opisthorchis viverrini (liver fluke)', 'opisthorchis viverrini (liver fluke)', '');  med_history_chromosome_abnormality_other

-- Baseline KPS and Past Medical History
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_1', 'karnofsky_performance_baseline', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='kps_options') , '0', '', '', '', 'karnofsky performance baseline', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_1', 'karnofsky_date_baseline', 'date',  NULL , '0', '', '', '', '', 'karnofsky date baseline'), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_1', 'baseline_weight', 'float',  NULL , '0', '', '', '', 'baseline weight', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_1', 'baseline_height', 'integer',  NULL , '0', '', '', '', 'baseline height', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_1', 'med_history_chromosome_abnormality', 'checkbox', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '0', '', '', '', 'med history chromosome abnormality', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_1', 'med_history_chromosome_abnormality_type', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='chromosome_options') , '0', '', '', '', '', 'med history chromosome abnormality type'), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_1', 'med_history_chromosome_abnormality_other', 'input',  NULL , '0', 'size=18', '', '', '', 'med history chromosome abnormality other'), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_1', 'med_history_autoimmune_disease', 'checkbox', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '0', '', '', '', 'med history autoimmune disease', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_1', 'med_history_autoimmune_disease_type', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='autoimmune_options') , '0', '', '', '', '', 'med history autoimmune disease type'), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_1', 'med_history_autoimmune_disease_other', 'input',  NULL , '0', 'size=18', '', '', '', 'med history autoimmune disease other'), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_1', 'med_history_cardiovascular_disease', 'checkbox', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '0', '', '', '', 'med history cardiovascular disease', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_1', 'med_history_cardiovascular_disease_type', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='cardiovascular_options') , '0', '', '', '', '', 'med history cardiovascular disease type'), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_1', 'med_history_cardiovascular_disease_other', 'input',  NULL , '0', 'size=18', '', '', '', 'med history cardiovascular disease other');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_1'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_1' AND `field`='karnofsky_performance_baseline' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='kps_options')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='karnofsky performance baseline' AND `language_tag`=''), '1', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_1'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_1' AND `field`='karnofsky_date_baseline' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='karnofsky date baseline'), '1', '6', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_1'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_1' AND `field`='baseline_weight' AND `type`='float' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='baseline weight' AND `language_tag`=''), '1', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_1'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_1' AND `field`='baseline_height' AND `type`='integer' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='baseline height' AND `language_tag`=''), '1', '15', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_1'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_1' AND `field`='med_history_chromosome_abnormality' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='med history chromosome abnormality' AND `language_tag`=''), '1', '30', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_1'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_1' AND `field`='med_history_chromosome_abnormality_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='chromosome_options')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='med history chromosome abnormality type'), '1', '31', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_1'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_1' AND `field`='med_history_chromosome_abnormality_other' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=18' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='med history chromosome abnormality other'), '1', '32', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_1'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_1' AND `field`='med_history_autoimmune_disease' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='med history autoimmune disease' AND `language_tag`=''), '1', '20', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_1'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_1' AND `field`='med_history_autoimmune_disease_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='autoimmune_options')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='med history autoimmune disease type'), '1', '21', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_1'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_1' AND `field`='med_history_autoimmune_disease_other' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=18' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='med history autoimmune disease other'), '1', '22', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_1'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_1' AND `field`='med_history_cardiovascular_disease' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='med history cardiovascular disease' AND `language_tag`=''), '1', '25', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_1'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_1' AND `field`='med_history_cardiovascular_disease_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='cardiovascular_options')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='med history cardiovascular disease type'), '1', '26', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_1'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_1' AND `field`='med_history_cardiovascular_disease_other' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=18' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='med history cardiovascular disease other'), '1', '27', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');
 
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_1', 'med_history_cns_psychiatric', 'checkbox', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '0', '', '', '', 'med history cns psychiatric', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_1', 'med_history_endocrine', 'checkbox', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '0', '', '', '', 'med history endocrine', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_1', 'med_history_gastrointestinal', 'checkbox', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '0', '', '', '', 'med history gastrointestinal', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_1', 'med_history_genitourinary', 'checkbox', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '0', '', '', '', 'med history genitourinary', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_1', 'med_history_hematologic', 'checkbox', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '0', '', '', '', 'med history hematologic', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_1', 'med_history_liver_disease', 'checkbox', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '0', '', '', '', 'med history liver disease', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_1', 'med_history_pulmonary', 'checkbox', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '0', '', '', '', 'med history pulmonary', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_1', 'med_history_infectious', 'checkbox', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '0', '', '', '', 'med history infectious', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_1', 'med_history_co-existing_other', 'input',  NULL , '0', 'size=18', '', '', '', 'med history co-existing other'), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_1', 'med_history_cns_psychiatric_type', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='cns_psychiatric_options') , '0', '', '', '', '', 'med history cns psychiatric type'), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_1', 'med_history_cns_psychiatric_other', 'input',  NULL , '0', 'size=18', '', '', '', 'med history cns psychiatric other'), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_1', 'med_history_endocrine_type', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='endocrine_options') , '0', '', '', '', '', 'med history endocrine type'), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_1', 'med_history_endocrine_other', 'input',  NULL , '0', 'size=18', '', '', '', 'med history endocrine other'), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_1', 'med_history_gastrointestinal_type', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='gastrointestinal_options') , '0', '', '', '', '', 'med history gastrointestinal type'), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_1', 'med_history_gastrointestinal_other', 'input',  NULL , '0', 'size=18', '', '', '', 'med history gastrointestinal other'), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_1', 'med_history_genitourinary_type', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='genitourinary_options') , '0', '', '', '', '', 'med history genitourinary type'), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_1', 'med_history_genitourinary_other', 'input',  NULL , '0', 'size=18', '', '', '', 'med history genitourinary other'), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_1', 'med_history_hematologic_type', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='hematologic_options') , '0', '', '', '', '', 'med history hematologic type'), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_1', 'med_history_hematologic_other', 'input',  NULL , '0', 'size=18', '', '', '', 'med history hematologic other'), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_1', 'med_history_liver_disease_type', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='liver_disease_options') , '0', '', '', '', '', 'med history liver disease type'), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_1', 'med_history_liver_disease_other', 'input',  NULL , '0', 'size=18', '', '', '', 'med history liver disease other');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_1'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_1' AND `field`='med_history_cns_psychiatric' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='med history cns psychiatric' AND `language_tag`=''), '1', '35', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_1'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_1' AND `field`='med_history_endocrine' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='med history endocrine' AND `language_tag`=''), '1', '40', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_1'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_1' AND `field`='med_history_gastrointestinal' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='med history gastrointestinal' AND `language_tag`=''), '1', '45', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_1'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_1' AND `field`='med_history_genitourinary' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='med history genitourinary' AND `language_tag`=''), '1', '50', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_1'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_1' AND `field`='med_history_hematologic' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='med history hematologic' AND `language_tag`=''), '1', '55', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_1'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_1' AND `field`='med_history_liver_disease' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='med history liver disease' AND `language_tag`=''), '1', '60', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_1'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_1' AND `field`='med_history_pulmonary' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='med history pulmonary' AND `language_tag`=''), '1', '65', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_1'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_1' AND `field`='med_history_infectious' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='med history infectious' AND `language_tag`=''), '1', '70', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_1'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_1' AND `field`='med_history_co-existing_other' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=18' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='med history co-existing other'), '1', '72', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_1'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_1' AND `field`='med_history_cns_psychiatric_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='cns_psychiatric_options')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='med history cns psychiatric type'), '1', '36', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_1'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_1' AND `field`='med_history_cns_psychiatric_other' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=18' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='med history cns psychiatric other'), '1', '37', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_1'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_1' AND `field`='med_history_endocrine_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='endocrine_options')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='med history endocrine type'), '1', '41', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_1'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_1' AND `field`='med_history_endocrine_other' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=18' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='med history endocrine other'), '1', '42', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_1'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_1' AND `field`='med_history_gastrointestinal_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='gastrointestinal_options')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='med history gastrointestinal type'), '1', '46', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_1'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_1' AND `field`='med_history_gastrointestinal_other' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=18' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='med history gastrointestinal other'), '1', '47', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_1'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_1' AND `field`='med_history_genitourinary_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='genitourinary_options')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='med history genitourinary type'), '1', '51', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_1'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_1' AND `field`='med_history_genitourinary_other' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=18' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='med history genitourinary other'), '1', '52', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_1'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_1' AND `field`='med_history_hematologic_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='hematologic_options')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='med history hematologic type'), '1', '56', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_1'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_1' AND `field`='med_history_hematologic_other' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=18' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='med history hematologic other'), '1', '57', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_1'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_1' AND `field`='med_history_liver_disease_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='liver_disease_options')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='med history liver disease type'), '1', '61', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_1'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_1' AND `field`='med_history_liver_disease_other' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=18' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='med history liver disease other'), '1', '62', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_1', 'med_history_pulmonary_type', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='pulmonary_options') , '0', '', '', '', '', 'med history pulmonary type'), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_1', 'med_history_pulmonary_other', 'input',  NULL , '0', 'size=18', '', '', '', 'med history pulmonary other'), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_1', 'med_history_infectious_type', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='other_significant_infectious_options') , '0', '', '', '', '', 'med history infectious type'), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_1', 'med_history_infectious_other', 'input',  NULL , '0', 'size=18', '', '', '', 'med history infectious other');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_1'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_1' AND `field`='med_history_pulmonary_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='pulmonary_options')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='med history pulmonary type'), '1', '66', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_1'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_1' AND `field`='med_history_pulmonary_other' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=18' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='med history pulmonary other'), '1', '67', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_1'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_1' AND `field`='med_history_infectious_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='other_significant_infectious_options')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='med history infectious type'), '1', '71', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_1'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_1' AND `field`='med_history_infectious_other' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=18' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='med history infectious other'), '1', '72', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_1', 'med_history_co-existing', 'checkbox', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '0', '', '', '', 'med history co-existing', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_1'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_1' AND `field`='med_history_co-existing' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='med history co-existing' AND `language_tag`=''), '1', '75', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');
UPDATE structure_formats SET `display_order`='76' WHERE structure_id=(SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_1') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_1' AND `field`='med_history_co-existing_other' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats SET `language_heading`='1.5 past medical history' WHERE structure_id=(SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_1') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_1' AND `field`='med_history_autoimmune_disease' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') AND `flag_confidential`='0');
 
REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
 ('1.5 past medical history', '1.5 Past medical history (check all that apply)', ''), 
 ('karnofsky performance baseline', '1.1 Karnofsky Performance Status (Baseline)', ''),
 ('karnofsky date baseline', '1.2 Date of KPS assessment', ''),
 ('baseline weight', '1.3 Weight', ''),
 ('baseline height', '1.4 Height', ''),
 ('med history chromosome abnormality', 'Chromosome abnormality', ''),
 ('med history chromosome abnormality type', 'Chromosome abnormality type', ''),
 ('med history autoimmune disease', 'Autoimmune disease', ''),
 ('med history autoimmune disease type', 'autoimmune disease type', ''),
 ('med history autoimmune disease other', 'autoimmune disease other', ''),
 ('med history cardiovascular disease', 'Cardiovascular disease', ''),
 ('med history cardiovascular disease type', 'cardiovascular disease type', ''),
 ('med history cardiovascular disease other', 'cardiovascular disease other', ''),
 ('med history chromosome abnormality other', 'chromosome abnormality other', ''),
 ('med history cns psychiatric', 'CNS/psychiatric', ''), 
 ('med history endocrine', 'Endocrine', ''),
 ('med history gastrointestinal', 'Gastrointestinal', ''),
 ('med history genitourinary', 'Genitourinary', ''),
 ('med history hematologic', 'Hematologic', ''),
 ('med history liver disease', 'Liver disease', ''),
 ('med history pulmonary', 'Pulmonary', ''),
 ('med history infectious', 'Other significant infectious history', ''), 
 ('med history cns psychiatric type', 'cns psychiatric type', ''),
 ('med history endocrine type', 'endocrine type', ''),
 ('med history gastrointestinal type', 'gastrointestinal type', ''),
 ('med history genitourinary type', 'genitourinary type', ''),
 ('med history hematologic type', 'hematologic type', ''),
 ('med history liver disease type', 'liver disease type', ''),
 ('med history liver disease other', 'liver disease other', ''), 
 ('med history pulmonary type', 'pulmonary type', ''),
 ('med history infectious type', 'infectious type', ''),
 ('med history pulmonary other', 'pulmonary other', ''),
 ('med history infectious other', 'infectious other', ''),
 ('med history co-existing', 'Other significant co-existing disease', '');
 
-- Genetic molecular testing
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_1', 'flt_status_at_dx', 'input',  NULL , '0', 'size=18', '', '', 'flt status at dx', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_1', 'flt_status', 'input',  NULL , '0', 'size=18', '', '', '', 'flt status'), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_1', 'flt_date_collection', 'date',  NULL , '0', '', '', '', 'flt date collection', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_1', 'flt_date_collection_status', 'input',  NULL , '0', 'size=18', '', '', '', 'flt date collection status'), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_1', 'npm_status_at_dx', 'input',  NULL , '0', 'size=18', '', '', 'npm status at dx', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_1', 'npm_status', 'input',  NULL , '0', 'size=18', '', '', '', 'npm status'), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_1', 'npm_date_of_collection', 'date',  NULL , '0', '', '', '', 'npm date of collection', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_1', 'npm_date_collection_status', 'input',  NULL , '0', 'size=18', '', '', '', 'npm date collection status');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_1'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_1' AND `field`='flt_status_at_dx' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=18' AND `default`='' AND `language_help`='' AND `language_label`='flt status at dx' AND `language_tag`=''), '1', '80', 'genetic/molecular testing', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_1'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_1' AND `field`='flt_status' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=18' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='flt status'), '1', '81', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_1'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_1' AND `field`='flt_date_collection' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='flt date collection' AND `language_tag`=''), '1', '82', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_1'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_1' AND `field`='flt_date_collection_status' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=18' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='flt date collection status'), '1', '83', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_1'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_1' AND `field`='npm_status_at_dx' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=18' AND `default`='' AND `language_help`='' AND `language_label`='npm status at dx' AND `language_tag`=''), '1', '85', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_1'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_1' AND `field`='npm_status' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=18' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='npm status'), '1', '86', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_1'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_1' AND `field`='npm_date_of_collection' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='npm date of collection' AND `language_tag`=''), '1', '87', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_1'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_1' AND `field`='npm_date_collection_status' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=18' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='npm date collection status'), '1', '88', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_1', 'cepba_status_at_dx', 'input',  NULL , '0', 'size=18', '', '', 'cepba status at dx', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_1', 'cepba_status', 'input',  NULL , '0', 'size=18', '', '', '', 'cepba status'), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_1', 'cepba_date_of_collection', 'date',  NULL , '0', '', '', '', 'cepba date of collection', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_1', 'cepba_date_collection_status', 'input',  NULL , '0', 'size=18', '', '', '', 'cepba date collection status'), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_1', 'other_genetic_testing', 'textarea',  NULL , '0', '', '', '', 'other genetic testing', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_1'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_1' AND `field`='cepba_status_at_dx' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=18' AND `default`='' AND `language_help`='' AND `language_label`='cepba status at dx' AND `language_tag`=''), '1', '90', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_1'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_1' AND `field`='cepba_status' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=18' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='cepba status'), '1', '91', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_1'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_1' AND `field`='cepba_date_of_collection' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='cepba date of collection' AND `language_tag`=''), '1', '92', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_1'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_1' AND `field`='cepba_date_collection_status' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=18' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='cepba date collection status'), '1', '93', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_1'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_1' AND `field`='other_genetic_testing' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='other genetic testing' AND `language_tag`=''), '1', '94', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES 
 ('flt status at dx', '1.6 FLT-3 status at diagnosis', ''), 
 ('flt status', 'flt status', ''),
 ('flt date collection', '1.7 FLT-3 Date of collection', ''),
 ('flt date collection status', 'flt date collection status', ''),
 ('npm status at dx', '1.8 NPM1 status at diagnosis', ''),
 ('npm status', 'NPM1 status', ''),
 ('npm date of collection', '1.9 NPM1 Date of collection', ''),
 ('npm date collection status', 'NPM1 date collection status', ''),
 ('cepba status at dx', '1.10 CEPBA status at diagnosis', ''), 
 ('cepba status', 'CEPBA status', ''),
 ('cepba date of collection', '1.11 CEPBA Date of collection', ''),
 ('cepba date collection status', 'CEPBA date collection status', ''),
 ('other genetic testing', '1.12 Other genetic testing', '');

-- Organ functioning
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_1', 'ast_sgot', 'float',  NULL , '0', '', '', '', 'ast sgot', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_1', 'ast_sgot_date_collection', 'date',  NULL , '0', '', '', '', '', 'ast sgot date collection'), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_1', 'total_bilirubin', 'float',  NULL , '0', '', '', '', 'total bilirubin', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_1', 'total_bilirubin_date_collection', 'date',  NULL , '0', '', '', '', '', 'total bilirubin date collection'), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_1', 'creatinine', 'float',  NULL , '0', '', '', '', 'creatinine', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_1', 'creatinine_date_collection', 'date',  NULL , '0', '', '', '', '', 'creatinine date collection');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_1'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_1' AND `field`='ast_sgot' AND `type`='float' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ast sgot' AND `language_tag`=''), '1', '100', 'organ function', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_1'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_1' AND `field`='ast_sgot_date_collection' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='ast sgot date collection'), '1', '101', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_1'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_1' AND `field`='total_bilirubin' AND `type`='float' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='total bilirubin' AND `language_tag`=''), '1', '102', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_1'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_1' AND `field`='total_bilirubin_date_collection' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='total bilirubin date collection'), '1', '103', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_1'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_1' AND `field`='creatinine' AND `type`='float' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='creatinine' AND `language_tag`=''), '1', '104', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_1'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_1' AND `field`='creatinine_date_collection' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='creatinine date collection'), '1', '105', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES 
 ('ast sgot', '1.13 AST(SGOT)', ''), 
 ('ast sgot date collection', '1.14 AST(SGOT) date collection', ''),
 ('total bilirubin', '1.15 Total bilirubin', ''),
 ('total bilirubin date collection', '1.16 Total bilirubin date collection', ''),
 ('creatinine', '1.17 Creatinine', ''),
 ('creatinine date collection', '1.18 creatinine date collection', '');
 
-- Hematologic findings
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_1', 'date_of_cbc', 'date',  NULL , '0', '', '', '', 'date of cbc', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_1', 'wbc', 'float',  NULL , '0', '', '', '', 'wbc', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_1', 'neutrophils', 'float',  NULL , '0', '', '', '', 'neutrophils', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_1', 'lymphocytes', 'float',  NULL , '0', '', '', '', 'lymphocytes', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_1', 'hemoglobin', 'float',  NULL , '0', '', '', '', 'hemoglobin', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_1', 'hematocrit', 'float',  NULL , '0', '', '', '', 'hematocrit', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_1', 'platelets', 'float',  NULL , '0', '', '', '', 'platelets', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_1', 'blasts', 'float',  NULL , '0', '', '', '', 'blasts', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_1'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_1' AND `field`='ast_sgot' AND `type`='float' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ast sgot' AND `language_tag`=''), '1', '100', 'organ function', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_1'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_1' AND `field`='ast_sgot_date_collection' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='ast sgot date collection'), '1', '101', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_1'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_1' AND `field`='total_bilirubin' AND `type`='float' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='total bilirubin' AND `language_tag`=''), '1', '102', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_1'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_1' AND `field`='total_bilirubin_date_collection' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='total bilirubin date collection'), '1', '103', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_1'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_1' AND `field`='creatinine' AND `type`='float' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='creatinine' AND `language_tag`=''), '1', '104', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_1'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_1' AND `field`='creatinine_date_collection' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='creatinine date collection'), '1', '105', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_1'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_1' AND `field`='date_of_cbc' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='date of cbc' AND `language_tag`=''), '1', '110', 'hematologic findings', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_1'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_1' AND `field`='wbc' AND `type`='float' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='wbc' AND `language_tag`=''), '1', '111', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_1'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_1' AND `field`='neutrophils' AND `type`='float' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='neutrophils' AND `language_tag`=''), '1', '115', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_1'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_1' AND `field`='lymphocytes' AND `type`='float' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='lymphocytes' AND `language_tag`=''), '1', '120', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_1'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_1' AND `field`='hemoglobin' AND `type`='float' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='hemoglobin' AND `language_tag`=''), '1', '125', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_1'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_1' AND `field`='hematocrit' AND `type`='float' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='hematocrit' AND `language_tag`=''), '1', '130', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_1'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_1' AND `field`='platelets' AND `type`='float' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='platelets' AND `language_tag`=''), '1', '135', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_1'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_1' AND `field`='blasts' AND `type`='float' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='blasts' AND `language_tag`=''), '1', '140', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES 
 ('date of cbc', '1.19 Date of CBC', ''), 
 ('wbc', '1.20 WBC', ''),
 ('neutrophils', '1.21 Neutrophils', ''),
 ('lymphocytes', '1.22 Lymphocytes', ''),
 ('hemoglobin', '1.23 Hemoglobin', ''),
 ('hematocrit', '1.24 Hematocrit', ''),
 ('platelets', '1.25 Platelets', ''),
 ('blasts', '1.26 Blasts', ''), 
 ('organ function', 'Organ function prior to start of definitive therapy', '');
 
-- Page 5 baseline continued  
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_1', 'rbc_transfusion_prior_cbc_test', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='yesno') , '0', '', '', '', 'rbc transfusion prior cbc test', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_1', 'platelet_transfusion_prior_cbc_test', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='yesno') , '0', '', '', '', 'platelet transfusion prior cbc test', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_1', 'leukapheresis_prior_therapy', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='yesno') , '0', '', '', '', 'leukapheresis prior therapy', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_1', 'date_of_leukapheresis', 'date',  NULL , '0', '', '', '', 'date of leukapheresis', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_1', 'hydroxyurea_prior_day_zero', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='yesno') , '0', '', '', '', 'hydroxyurea prior day zero', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_1'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_1' AND `field`='rbc_transfusion_prior_cbc_test' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yesno')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='rbc transfusion prior cbc test' AND `language_tag`=''), '1', '145', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_1'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_1' AND `field`='platelet_transfusion_prior_cbc_test' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yesno')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='platelet transfusion prior cbc test' AND `language_tag`=''), '1', '146', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_1'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_1' AND `field`='leukapheresis_prior_therapy' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yesno')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='leukapheresis prior therapy' AND `language_tag`=''), '1', '147', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_1'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_1' AND `field`='date_of_leukapheresis' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='date of leukapheresis' AND `language_tag`=''), '1', '148', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_1'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_1' AND `field`='hydroxyurea_prior_day_zero' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yesno')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='hydroxyurea prior day zero' AND `language_tag`=''), '1', '149', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES 
 ('rbc transfusion prior cbc test', '1.27 Did participant receive an RBC transfusion within 30 days prior to the CBC test?', ''), 
 ('platelet transfusion prior cbc test', '1.28 Did participant receive a platelet transfusion within 7 days prior CBC test?', ''),
 ('leukapheresis prior therapy', '1.29 Did patient undergo leukapheresis prior to the start of definitive therapy?', ''),
 ('date of leukapheresis', '1.30 Enter date of leukapheresis', ''),
 ('hydroxyurea prior day zero', '1.31 Did participant receive hydroxyurea prior Day 0', '');

-- Other malignancies
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_1', 'oth_malignancy_leukemia', 'checkbox', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '0', '', '', '', 'oth malignancy leukemia', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_1', 'oth_malignancy_leukemia_type', 'input',  NULL , '0', 'size=18', '', '', '', 'oth malignancy leukemia type'), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_1', 'oth_malignancy_leukemia_year', 'integer',  NULL , '0', '', '', '', '', 'oth malignancy leukemia year'), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_1', 'oth_malignancy_breast', 'checkbox', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '0', '', '', '', 'oth malignancy breast', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_1', 'oth_malignancy_breast_year', 'integer',  NULL , '0', '', '', '', '', 'oth malignancy breast year'), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_1', 'oth_malignancy_cns', 'checkbox', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '0', '', '', '', 'oth malignancy cns', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_1', 'oth_malignancy_cns_year', 'integer',  NULL , '0', '', '', '', '', 'oth malignancy cns year'), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_1', 'oth_malignancy_clonal_cytogenetic_abnormality', 'checkbox', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '0', '', '', '', 'oth malignancy clonal cytogenetic abnormality', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_1', 'oth_malignancy_clonal_cytogenetic_abnormality_year', 'integer',  NULL , '0', '', '', '', '', 'oth malignancy clonal cytogenetic abnormality year'), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_1', 'oth_malignancy_gastrointestinal', 'checkbox', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '0', '', '', '', 'oth malignancy gastrointestinal', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_1', 'oth_malignancy_gastrointestinal_year', 'integer',  NULL , '0', '', '', '', '', 'oth malignancy gastrointestinal year'), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_1', 'oth_malignancy_genitourinary', 'checkbox', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '0', '', '', '', 'oth malignancy genitourinary', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_1', 'oth_malignancy_genitourinary_year', 'integer',  NULL , '0', '', '', '', '', 'oth malignancy genitourinary year'), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_1', 'oth_malignancy_hodgkin', 'checkbox', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '0', '', '', '', 'oth malignancy hodgkin', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_1', 'oth_malignancy_hodgkin_year', 'integer',  NULL , '0', '', '', '', '', 'oth malignancy hodgkin year'), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_1', 'oth_malignancy_lung', 'checkbox', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '0', '', '', '', 'oth malignancy lung', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_1', 'oth_malignancy_lung_year', 'integer',  NULL , '0', '', '', '', '', 'oth malignancy lung year'), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_1', 'oth_malignancy_lymphoma', 'checkbox', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '0', '', '', '', 'oth malignancy lymphoma', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_1', 'oth_malignancy_lymphoma_year', 'integer',  NULL , '0', '', '', '', '', 'oth malignancy lymphoma year'), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_1', 'oth_malignancy_melanoma', 'checkbox', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '0', '', '', '', 'oth malignancy melanoma', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_1', 'oth_malignancy_melanoma_year', 'integer',  NULL , '0', '', '', '', '', 'oth malignancy melanoma year'), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_1', 'oth_malignancy_other_skin', 'checkbox', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '0', '', '', '', 'oth malignancy other skin', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_1', 'oth_malignancy_other_skin_year', 'integer',  NULL , '0', '', '', '', '', 'oth malignancy other skin year'), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_1', 'oth_malignancy_myelodysplasia', 'checkbox', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '0', '', '', '', 'oth malignancy myelodysplasia', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_1', 'oth_malignancy_myelodysplasia_year', 'integer',  NULL , '0', '', '', '', '', 'oth malignancy myelodysplasia year'), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_1', 'oth_malignancy_oropharyngeal', 'checkbox', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '0', '', '', '', 'oth malignancy oropharyngeal', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_1', 'oth_malignancy_oropharyngeal_year', 'integer',  NULL , '0', '', '', '', '', 'oth malignancy oropharyngeal year'), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_1', 'oth_malignancy_sarcoma', 'checkbox', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '0', '', '', '', 'oth malignancy sarcoma', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_1', 'oth_malignancy_sarcoma_year', 'integer',  NULL , '0', '', '', '', '', 'oth malignancy sarcoma year'), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_1', 'oth_malignancy_thyroid', 'checkbox', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '0', '', '', '', 'oth malignancy thyroid', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_1', 'oth_malignancy_thyroid_year', 'integer',  NULL , '0', '', '', '', '', 'oth malignancy thyroid year'), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_1', 'oth_malignancy_other_prior', 'checkbox', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '0', '', '', '', 'oth malignancy other prior', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_1', 'oth_malignancy_other_prior_type', 'input',  NULL , '0', 'size=18', '', '', '', 'oth malignancy other prior type'), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_1', 'oth_malignancy_other_prior_year', 'integer',  NULL , '0', '', '', '', '', 'oth malignancy other prior year');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_1'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_1' AND `field`='oth_malignancy_leukemia' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='oth malignancy leukemia' AND `language_tag`=''), '1', '155', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_1'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_1' AND `field`='oth_malignancy_leukemia_type' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=18' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='oth malignancy leukemia type'), '1', '156', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_1'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_1' AND `field`='oth_malignancy_leukemia_year' AND `type`='integer' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='oth malignancy leukemia year'), '1', '157', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_1'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_1' AND `field`='oth_malignancy_breast' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='oth malignancy breast' AND `language_tag`=''), '1', '160', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_1'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_1' AND `field`='oth_malignancy_breast_year' AND `type`='integer' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='oth malignancy breast year'), '1', '161', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_1'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_1' AND `field`='oth_malignancy_cns' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='oth malignancy cns' AND `language_tag`=''), '1', '162', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_1'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_1' AND `field`='oth_malignancy_cns_year' AND `type`='integer' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='oth malignancy cns year'), '1', '163', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_1'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_1' AND `field`='oth_malignancy_clonal_cytogenetic_abnormality' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='oth malignancy clonal cytogenetic abnormality' AND `language_tag`=''), '1', '165', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_1'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_1' AND `field`='oth_malignancy_clonal_cytogenetic_abnormality_year' AND `type`='integer' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='oth malignancy clonal cytogenetic abnormality year'), '1', '166', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_1'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_1' AND `field`='oth_malignancy_gastrointestinal' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='oth malignancy gastrointestinal' AND `language_tag`=''), '1', '167', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_1'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_1' AND `field`='oth_malignancy_gastrointestinal_year' AND `type`='integer' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='oth malignancy gastrointestinal year'), '1', '168', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_1'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_1' AND `field`='oth_malignancy_genitourinary' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='oth malignancy genitourinary' AND `language_tag`=''), '1', '169', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_1'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_1' AND `field`='oth_malignancy_genitourinary_year' AND `type`='integer' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='oth malignancy genitourinary year'), '1', '170', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_1'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_1' AND `field`='oth_malignancy_hodgkin' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='oth malignancy hodgkin' AND `language_tag`=''), '1', '171', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_1'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_1' AND `field`='oth_malignancy_hodgkin_year' AND `type`='integer' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='oth malignancy hodgkin year'), '1', '172', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_1'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_1' AND `field`='oth_malignancy_lung' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='oth malignancy lung' AND `language_tag`=''), '1', '173', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_1'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_1' AND `field`='oth_malignancy_lung_year' AND `type`='integer' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='oth malignancy lung year'), '1', '174', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_1'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_1' AND `field`='oth_malignancy_lymphoma' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='oth malignancy lymphoma' AND `language_tag`=''), '1', '175', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_1'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_1' AND `field`='oth_malignancy_lymphoma_year' AND `type`='integer' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='oth malignancy lymphoma year'), '1', '176', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_1'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_1' AND `field`='oth_malignancy_melanoma' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='oth malignancy melanoma' AND `language_tag`=''), '1', '177', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_1'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_1' AND `field`='oth_malignancy_melanoma_year' AND `type`='integer' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='oth malignancy melanoma year'), '1', '178', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_1'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_1' AND `field`='oth_malignancy_other_skin' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='oth malignancy other skin' AND `language_tag`=''), '1', '179', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_1'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_1' AND `field`='oth_malignancy_other_skin_year' AND `type`='integer' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='oth malignancy other skin year'), '1', '180', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_1'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_1' AND `field`='oth_malignancy_myelodysplasia' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='oth malignancy myelodysplasia' AND `language_tag`=''), '1', '181', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_1'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_1' AND `field`='oth_malignancy_myelodysplasia_year' AND `type`='integer' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='oth malignancy myelodysplasia year'), '1', '182', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_1'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_1' AND `field`='oth_malignancy_oropharyngeal' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='oth malignancy oropharyngeal' AND `language_tag`=''), '1', '183', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_1'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_1' AND `field`='oth_malignancy_oropharyngeal_year' AND `type`='integer' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='oth malignancy oropharyngeal year'), '1', '184', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_1'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_1' AND `field`='oth_malignancy_sarcoma' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='oth malignancy sarcoma' AND `language_tag`=''), '1', '185', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_1'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_1' AND `field`='oth_malignancy_sarcoma_year' AND `type`='integer' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='oth malignancy sarcoma year'), '1', '186', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_1'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_1' AND `field`='oth_malignancy_thyroid' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='oth malignancy thyroid' AND `language_tag`=''), '1', '187', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_1'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_1' AND `field`='oth_malignancy_thyroid_year' AND `type`='integer' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='oth malignancy thyroid year'), '1', '188', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_1'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_1' AND `field`='oth_malignancy_other_prior' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='oth malignancy other prior' AND `language_tag`=''), '1', '189', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_1'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_1' AND `field`='oth_malignancy_other_prior_type' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=18' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='oth malignancy other prior type'), '1', '190', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_1'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_1' AND `field`='oth_malignancy_other_prior_year' AND `type`='integer' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='oth malignancy other prior year'), '1', '191', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');


REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES 
 ('oth malignancy leukemia', 'Other leukemia', ''), 
 ('oth malignancy breast', 'Breast cancer', ''),
 ('oth malignancy cns', 'Central nervous system (CNS) malignancy (glioblastoma, astrocytoma)', ''),
 ('oth malignancy clonal cytogenetic abnormality', 'Clonal cytogenetic abnormality without leukemia or MDS', ''),
 ('oth malignancy gastrointestinal', 'Gastrointestinal malignancy (colon, rectum, stomach, pancreas, intestine)', ''),
 ('oth malignancy genitourinary', 'Genitourinary malignancy', ''),
 ('oth malignancy hodgkin', 'Hodgkin disease', ''),
 ('oth malignancy lung', 'Lung cancer', ''), 
 ('oth malignancy lymphoma', 'Lymphoma or lymphoproliferative disease', ''),
 ('oth malignancy melanoma', 'Melanoma', ''),
 ('oth malignancy other skin', 'Other skin malignancy (basal cell, squamous)', ''),
 ('oth malignancy myelodysplasia', 'Myelodysplasia (MDS)/myeloproliferative disorder', ''),
 ('oth malignancy oropharyngeal', 'Oropharyngeal cancer (tongue, buccal mucosa)', ''),
 ('oth malignancy sarcoma', 'Sarcoma', ''),
 ('oth malignancy thyroid', 'Thyroid cancer', ''),
 ('oth malignancy other prior', 'Other prior malignancy, specify', ''),
 ('oth malignancy leukemia type', '', ''),
 ('oth malignancy leukemia year', '', ''), 
 ('oth malignancy breast year', '', ''),
 ('oth malignancy cns year', '', ''),
 ('oth malignancy clonal cytogenetic abnormality year', '', ''),
 ('oth malignancy gastrointestinal year', '', ''),
 ('oth malignancy genitourinary year', '', ''),
 ('oth malignancy hodgkin year', '', ''),
 ('oth malignancy lung year', '', ''), 
 ('oth malignancy lymphoma year', '', ''),
 ('oth malignancy melanoma year', '', ''),
 ('oth malignancy other skin year', '', ''),
 ('oth malignancy myelodysplasia year', '', ''), 
 ('oth malignancy oropharyngeal year', '', ''),
 ('oth malignancy sarcoma year', '', ''),
 ('oth malignancy thyroid year', '', ''),
 ('oth malignancy other prior type', '', ''), 
 ('oth malignancy other prior year', '', ''); 


-- Other health history
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_1', 'smoking_history_status', 'checkbox', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '0', '', '', '', 'smoking history status', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_1', 'smoked_previous_year', 'checkbox', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '0', '', '', '', 'smoked previous year', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_1', 'smoked_prior_previous_year', 'checkbox', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '0', '', '', '', 'smoked prior previous year', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_1', 'years_smoked', 'integer',  NULL , '0', '', '', '', 'years smoked', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_1', 'years_smoked_unknown', 'input',  NULL , '0', '', '', '', '', 'years smoked unknown'), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_1', 'alcohol_consumption_greater_month', 'checkbox', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '0', '', '', '', 'alcohol consumption greater month', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_1'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_1' AND `field`='smoking_history_status' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='smoking history status' AND `language_tag`=''), '1', '200', 'other health history', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_1'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_1' AND `field`='smoked_previous_year' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='smoked previous year' AND `language_tag`=''), '1', '201', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_1'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_1' AND `field`='smoked_prior_previous_year' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='smoked prior previous year' AND `language_tag`=''), '1', '202', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_1'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_1' AND `field`='years_smoked' AND `type`='integer' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='years smoked' AND `language_tag`=''), '1', '203', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_1'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_1' AND `field`='years_smoked_unknown' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='years smoked unknown'), '1', '204', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_1'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_1' AND `field`='alcohol_consumption_greater_month' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='alcohol consumption greater month' AND `language_tag`=''), '1', '208', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES 
 ('other health history', 'Other Health History Items', ''), 
 ('smoking history status', '1.34 Does the participant have a history of smoking cigarettes', ''), 
 ('smoked previous year', '1.35 Has the participant smoked cigarettes within the past year?', ''),
 ('smoked prior previous year', '1.36 Has the participant smoked cigarettes prior to but not during the past year?', ''),
 ('years smoked', '1.37 Enter numbers of years of smoking', ''),
 ('years smoked unknown', '', ''),
 ('alcohol consumption greater month', '1.39 Has participant ever experienced a period of time one month or greater in which alcohol consumption averaged greater than 2 drinks per day?', '');

-- Value domain alcohol consumption
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("alcohol_consumption_pattern_options", "open", "", NULL);
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="alcohol_consumption_pattern_options"), (SELECT id FROM structure_permissible_values WHERE value="none" AND language_alias="none"), "1", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("less than one drink per week", "less than one drink per week");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="alcohol_consumption_pattern_options"), (SELECT id FROM structure_permissible_values WHERE value="less than one drink per week" AND language_alias="less than one drink per week"), "2", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("one drink every 2-7 days", "one drink every 2-7 days");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="alcohol_consumption_pattern_options"), (SELECT id FROM structure_permissible_values WHERE value="one drink every 2-7 days" AND language_alias="one drink every 2-7 days"), "3", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("one drink per day", "one drink per day");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="alcohol_consumption_pattern_options"), (SELECT id FROM structure_permissible_values WHERE value="one drink per day" AND language_alias="one drink per day"), "4", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("two drinks per day", "two drinks per day");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="alcohol_consumption_pattern_options"), (SELECT id FROM structure_permissible_values WHERE value="two drinks per day" AND language_alias="two drinks per day"), "5", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("more than two drinks per day", "more than two drinks per day");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="alcohol_consumption_pattern_options"), (SELECT id FROM structure_permissible_values WHERE value="more than two drinks per day" AND language_alias="more than two drinks per day"), "6", "1");

-- Exercise pattern
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("exercise_pattern_options", "open", "", NULL);
INSERT INTO structure_permissible_values (value, language_alias) VALUES("mostly sedentary", "mostly sedentary");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="exercise_pattern_options"), (SELECT id FROM structure_permissible_values WHERE value="mostly sedentary" AND language_alias="mostly sedentary"), "1", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("mostly sedentary", "mostly sedentary");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="exercise_pattern_options"), (SELECT id FROM structure_permissible_values WHERE value="mostly sedentary" AND language_alias="mostly sedentary"), "2", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("vigorous exercise for 20 minutes or more once per week", "vigorous exercise for 20 minutes or more once per week");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="exercise_pattern_options"), (SELECT id FROM structure_permissible_values WHERE value="vigorous exercise for 20 minutes or more once per week" AND language_alias="vigorous exercise for 20 minutes or more once per week"), "3", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("vigorous exercise for 20 minutes or more greater than once per week", "vigorous exercise for 20 minutes or more greater than once per week");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="exercise_pattern_options"), (SELECT id FROM structure_permissible_values WHERE value="vigorous exercise for 20 minutes or more greater than once per week" AND language_alias="vigorous exercise for 20 minutes or more greater than once per week"), "4", "1");

-- Participant job
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("participant_job_options", "open", "", NULL);
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="participant_job_options"), (SELECT id FROM structure_permissible_values WHERE value="mostly sedentary" AND language_alias="mostly sedentary"), "1", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("some activity", "some activity");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="participant_job_options"), (SELECT id FROM structure_permissible_values WHERE value="some activity" AND language_alias="some activity"), "2", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("mostly active", "mostly active");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="participant_job_options"), (SELECT id FROM structure_permissible_values WHERE value="mostly active" AND language_alias="mostly active"), "3", "1");

-- Yes, no, unknown
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("yes_no_unknown", "open", "", NULL);
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="yes_no_unknown"), (SELECT id FROM structure_permissible_values WHERE value="yes" AND language_alias="yes"), "1", "1");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="yes_no_unknown"), (SELECT id FROM structure_permissible_values WHERE value="no" AND language_alias="no"), "2", "1");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="yes_no_unknown"), (SELECT id FROM structure_permissible_values WHERE value="unknown" AND language_alias="unknown"), "3", "1");

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES 
 ('none', 'None', ''), 
 ('less than one drink per week', 'Less than one drink per week', ''),
 ('one drink every 2-7 days', 'One drink every 2-7 days', ''),
 ('one drink per day', 'One drink per day', ''),
 ('two drinks per day', 'Two drinks per day', ''),
 ('more than two drinks per day', 'More than two drinks per day', ''),
 ('mostly sedentary', 'Mostly sedentary', ''),
 ('vigorous exercise for 20 minutes or more once per week', 'Vigorous exercise for 20 minutes or more once per week', ''), 
 ('vigorous exercise for 20 minutes or more greater than once per week', 'Vigorous exercise for 20 minutes or more greater than once per week', ''),
 ('some activity', 'Some activity', ''),
 ('mostly active', 'Mostly active', '');


INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_1', 'alcohol_consumption_pattern', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='alcohol_consumption_pattern_options') , '0', '', '', '', 'alcohol consumption pattern', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_1', 'exercise_pattern_previous_five_years', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='exercise_pattern_options') , '0', '', '', '', 'exercise pattern previous five years', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_1', 'participant_job_or_lifestyle', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='participant_job_options') , '0', '', '', '', 'participant job or lifestyle', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_1'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_1' AND `field`='alcohol_consumption_pattern' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='alcohol_consumption_pattern_options')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='alcohol consumption pattern' AND `language_tag`=''), '1', '205', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_1'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_1' AND `field`='exercise_pattern_previous_five_years' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='exercise_pattern_options')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='exercise pattern previous five years' AND `language_tag`=''), '1', '210', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_1'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_1' AND `field`='participant_job_or_lifestyle' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='participant_job_options')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='participant job or lifestyle' AND `language_tag`=''), '1', '211', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES 
 ('alcohol consumption pattern', '1.38 Typical alcohol consumption pattern in the PREVIOUS YEAR (check one)', ''), 
 ('exercise pattern previous five years', '1.40 Exercise patter in general in the PREVIOUS FIVE YEARS (check one)', ''),
 ('participant job or lifestyle', '1.41 Participants job (or lifestyle if not working) is', '');

-- Exposure
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_1', 'exp_acid_mists_inorganic', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_unknown') , '0', '', '', '', 'exp acid mists inorganic', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_1', 'exp_aluminum_production', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_unknown') , '0', '', '', '', 'exp aluminum production', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_1', 'exp_areca_nut', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_unknown') , '0', '', '', '', 'exp areca nut', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_1', 'exp_arsenic', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_unknown') , '0', '', '', '', 'exp arsenic', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_1', 'exp_asbestos', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_unknown') , '0', '', '', '', 'exp asbestos', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_1', 'exp_benzene', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_unknown') , '0', '', '', '', 'exp benzene', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_1', 'exp_coal_emission', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_unknown') , '0', '', '', '', 'exp coal emission', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_1', 'exp_diesel_engine_exhaust', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_unknown') , '0', '', '', '', 'exp diesel engine exhaust', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_1', 'exp_estrogen_postmenopausal_therapy', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_unknown') , '0', '', '', '', 'exp estrogen postmenopausal therapy', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_1', 'exp_estrogen_progesterone_oral_contraceptives', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_unknown') , '0', '', '', '', 'exp estrogen progesterone oral contraceptives', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_1', 'exp_formaldehyde', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_unknown') , '0', '', '', '', 'exp formaldehyde', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_1', 'exp_radiation', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_unknown') , '0', '', '', '', 'exp radiation', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_1', 'exp_second_hand_smoke', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_unknown') , '0', '', '', '', 'exp second hand smoke', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_section_1', 'other_exposure_history', 'textarea',  NULL , '0', '', '', '', 'other exposure history', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_1'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_1' AND `field`='exp_acid_mists_inorganic' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_unknown')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='exp acid mists inorganic' AND `language_tag`=''), '1', '215', 'exposure substances', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_1'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_1' AND `field`='exp_aluminum_production' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_unknown')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='exp aluminum production' AND `language_tag`=''), '1', '216', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_1'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_1' AND `field`='exp_areca_nut' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_unknown')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='exp areca nut' AND `language_tag`=''), '1', '217', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_1'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_1' AND `field`='exp_arsenic' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_unknown')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='exp arsenic' AND `language_tag`=''), '1', '218', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_1'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_1' AND `field`='exp_asbestos' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_unknown')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='exp asbestos' AND `language_tag`=''), '1', '219', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_1'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_1' AND `field`='exp_benzene' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_unknown')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='exp benzene' AND `language_tag`=''), '1', '220', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_1'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_1' AND `field`='exp_coal_emission' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_unknown')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='exp coal emission' AND `language_tag`=''), '1', '221', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_1'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_1' AND `field`='exp_diesel_engine_exhaust' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_unknown')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='exp diesel engine exhaust' AND `language_tag`=''), '1', '222', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_1'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_1' AND `field`='exp_estrogen_postmenopausal_therapy' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_unknown')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='exp estrogen postmenopausal therapy' AND `language_tag`=''), '1', '223', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_1'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_1' AND `field`='exp_estrogen_progesterone_oral_contraceptives' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_unknown')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='exp estrogen progesterone oral contraceptives' AND `language_tag`=''), '1', '224', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_1'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_1' AND `field`='exp_formaldehyde' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_unknown')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='exp formaldehyde' AND `language_tag`=''), '1', '225', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_1'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_1' AND `field`='exp_radiation' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_unknown')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='exp radiation' AND `language_tag`=''), '1', '226', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_1'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_1' AND `field`='exp_second_hand_smoke' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_unknown')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='exp second hand smoke' AND `language_tag`=''), '1', '227', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_section_1'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_section_1' AND `field`='other_exposure_history' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='other exposure history' AND `language_tag`=''), '1', '230', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES 
 ('exp acid mists inorganic', 'Acid mists, strong inorganic', ''), 
 ('exp aluminum production', 'Aluminum production', ''),
 ('exp areca nut', 'Areca nut', ''),
 ('exp arsenic', 'Arsenic', ''),
 ('exp asbestos', 'Asbestos', ''),
 ('exp benzene', 'Benzene', ''),
 ('exp coal emission', 'Coal emission', ''),
 ('exp diesel engine exhaust', 'Diesel engine exhaust', ''), 
 ('exp estrogen postmenopausal therapy', 'Estrogen postmenopausal therapy', ''),
 ('exp estrogen progesterone oral contraceptives', 'Estrogen-progesterone oral contraceptives', ''),
 ('exp formaldehyde', 'Formaldehyde', ''),
 ('exp radiation', 'Radiation', ''),
 ('exp second hand smoke', 'Second hand tobacco smoke', ''),
 ('other exposure history', '1.43 Is there any other notable history regarding exposure to carcinogenic substances?', '');
 
REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES 
 ('genetic/molecular testing', 'Genetic/molecular testing (continued)', ''), 
 ('hematologic findings', 'Hematologic findings', ''),
 ('exposure substances', '1.42 Has this participant ever been exposed to any of the following substances?', '');
    
 
