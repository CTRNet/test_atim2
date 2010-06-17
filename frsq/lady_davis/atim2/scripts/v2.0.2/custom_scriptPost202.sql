-- This script needs to be run right after 2.0.2. upgrade script

UPDATE structure_value_domains SET source=NULL WHERE domain_name='tissue_source_list';
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("ganglion", "ganglion");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="tissue_source_list"),  (SELECT id FROM structure_permissible_values WHERE value="ganglion" AND language_alias="ganglion"), "0", "1");