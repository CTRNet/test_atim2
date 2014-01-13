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
 
 
 
