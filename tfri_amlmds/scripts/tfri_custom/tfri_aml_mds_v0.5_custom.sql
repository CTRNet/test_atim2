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

CREATE TABLE `ed_tfri_study_eq_5d_health` (
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
 
 
-- Eventum ID: 2884 WBC and Blast Count
 

-- Eventum ID: 2885 WBC and Blast Count Units 
 
