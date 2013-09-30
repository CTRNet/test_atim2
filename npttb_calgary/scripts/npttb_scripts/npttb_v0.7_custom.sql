-- NPTTB Custom Script
-- Version: v0.7
-- ATiM Version: v2.5.2

-- Update bank name for version tracking during customization
REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('core_installname', 'Clark H. Smith NPTTB - v0.7 DEV', '');


/*
	------------------------------------------------------------
	Eventum ID: 2719 - Diagnosis - TTB Diagnosis 
	------------------------------------------------------------
*/

INSERT INTO structure_permissible_values (value, language_alias) VALUES("Gliosarcoma", "npttb Gliosarcoma");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_final_diagnosis"), (SELECT id FROM structure_permissible_values WHERE value="Gliosarcoma" AND language_alias="npttb Gliosarcoma"), "28", "1");
