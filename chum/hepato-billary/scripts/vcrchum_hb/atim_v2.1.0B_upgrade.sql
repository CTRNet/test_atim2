-- Fix bug 1275 : unable to set a pariticipant message due date 

ALTER TABLE participant_messages
 MODIFY `due_date` date  DEFAULT NULL;
ALTER TABLE participant_messages_revs
 MODIFY `due_date` date  DEFAULT NULL;
 
-- PT : Add peri-tumoral tissue type

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("PT", "PT");
DELETE FROM structure_value_domains_permissible_values WHERE structure_value_domain_id = (SELECT id FROM structure_value_domains WHERE domain_name="qc_hb_sample_tissue_type")
AND structure_permissible_value_id = (SELECT id FROM structure_permissible_values WHERE value="PT" AND language_alias="PT");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) 
VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="qc_hb_sample_tissue_type"),  
(SELECT id FROM structure_permissible_values WHERE value="PT" AND language_alias="PT"), "0", "1");
