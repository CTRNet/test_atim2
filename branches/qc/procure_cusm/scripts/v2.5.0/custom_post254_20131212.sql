-- -------------------------------------------------------------------------------------------------------------------------------------------------------
-- First script to run to migrate PROCURE CUSM v254 (rev 5166) to v266.
-- -------------------------------------------------------------------------------------------------------------------------------------------------------

-- laparoscopy

UPDATE structure_permissible_values_customs SET `value` = 'laparoscopy', `en` = 'Laparoscopy', `fr` = 'Laparoscopie' WHERE `value` = 'laparascopy';

-- pellet aspect after centrifugation

INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES
("whitish", "whitish"),
("yellowish", "yellowish");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) 
VALUES 
((SELECT id FROM structure_value_domains WHERE domain_name="procure_pellet_aspect_after_centrifugation"), 
(SELECT id FROM structure_permissible_values WHERE value="whitish" AND language_alias="whitish"), "1", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="procure_pellet_aspect_after_centrifugation"), 
(SELECT id FROM structure_permissible_values WHERE value="yellowish" AND language_alias="yellowish"), "2", "1");
INSERT INTO i18n (id,en,fr)
VALUES
('whitish', 'Whitish', 'Blanchâtre'),
('yellowish', 'Yellowish', 'Jaunâtre');
SELECT IF(COUNT(*) > 0, 
"At least one sd_der_urine_cents.procure_pellet_aspect_after_centrifugation is equal to 'clear' or 'turbidity'. Please clean up before to run following query.", 
"No error. Following query can b executed") AS 'sd_der_urine_cents.procure_pellet_aspect_after_centrifugation clean up msg' 
FROM sd_der_urine_cents WHERE procure_pellet_aspect_after_centrifugation IN ('clear','turbidity')
UNION
SELECT "DELETE FROM structure_value_domains_permissible_values WHERE structure_value_domain_id = (SELECT id FROM structure_value_domains WHERE domain_name='procure_pellet_aspect_after_centrifugation') AND structure_permissible_value_id IN (SELECT id FROM structure_permissible_values WHERE value IN ('turbidity', 'clear'));" AS 'sd_der_urine_cents.procure_pellet_aspect_after_centrifugation clean up msg' 
UNION
SELECT "Be sure 'whitish' 'yellowish' values did not have been excluded from migration process checking migration summary" AS 'sd_der_urine_cents.procure_pellet_aspect_after_centrifugation clean up msg';
