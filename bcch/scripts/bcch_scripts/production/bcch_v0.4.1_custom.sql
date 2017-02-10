-- BCCH Customization Script
-- Version 0.4.1
-- ATiM Version: 2.6.5

-- Update bank name for version tracking during customization
REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('core_installname', "BCCH Biobank - BCCH v0.4.1", '');

--  =========================================================================
--	Eventum ID: #XXXX
--  BB-115: ADD CARDIO secondary identifier
--	=========================================================================


INSERT INTO misc_identifier_controls (`misc_identifier_name`, `flag_active`, `display_order`, `flag_once_per_participant`, `flag_unique`, `pad_to_length`, `flag_link_to_study`)
VALUES
('CARDIO ID', 1, 12, 1, 1, 0, 1);

REPLACE INTO i18n (`id`, `en`)
VALUES
('CARDIO ID', 'CARDIO ID'),
('ccbr CARDIO ID validation error', 'CARDIO ID must start with 4 letters, follow by a dash, then two numbers');


--  =========================================================================
--	Eventum ID: #XXXX
--  BB-116: Adding more tissue source for tissue sample type
--	=========================================================================

INSERT INTO structure_permissible_values (`value`, `language_alias`) 
VALUES
('tonsils', 'tonsils'),
('adenoids', 'adenoids'),
('kidney', 'kidney'),
('liver', 'liver'),
('spleen', 'spleen'),
('muscle', 'muscle'),
('lymph node', 'lymph node'),
('stomach', 'stomach'),
('gi tract', 'gi tract'),
('colon', 'colon'),
('bowel', 'bowel');

INSERT INTO structure_value_domains_permissible_values 
(`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`, `use_as_input`)
VALUES
((SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'tissue_source_list'), (SELECT `id` FROM structure_permissible_values WHERE `value` = 'brain' AND `language_alias`='brain'), 0, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'tissue_source_list'), (SELECT `id` FROM structure_permissible_values WHERE `value` = 'tonsils' AND `language_alias`='tonsils'), 0, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'tissue_source_list'), (SELECT `id` FROM structure_permissible_values WHERE `value` = 'adenoids' AND `language_alias`='adenoids'), 0, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'tissue_source_list'), (SELECT `id` FROM structure_permissible_values WHERE `value` = 'lung' AND `language_alias`='lung'), 0, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'tissue_source_list'), (SELECT `id` FROM structure_permissible_values WHERE `value` = 'kidney' AND `language_alias`='kidney'), 0, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'tissue_source_list'), (SELECT `id` FROM structure_permissible_values WHERE `value` = 'liver' AND `language_alias`='liver'), 0, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'tissue_source_list'), (SELECT `id` FROM structure_permissible_values WHERE `value` = 'breast' AND `language_alias`='breast'), 0, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'tissue_source_list'), (SELECT `id` FROM structure_permissible_values WHERE `value` = 'spleen' AND `language_alias`='spleen'), 0, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'tissue_source_list'), (SELECT `id` FROM structure_permissible_values WHERE `value` = 'skin' AND `language_alias`='skin'), 0, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'tissue_source_list'), (SELECT `id` FROM structure_permissible_values WHERE `value` = 'bone' AND `language_alias`='bone'), 0, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'tissue_source_list'), (SELECT `id` FROM structure_permissible_values WHERE `value` = 'muscle' AND `language_alias`='muscle'), 0, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'tissue_source_list'), (SELECT `id` FROM structure_permissible_values WHERE `value` = 'lymph node' AND `language_alias`='lymph node'), 0, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'tissue_source_list'), (SELECT `id` FROM structure_permissible_values WHERE `value` = 'eye' AND `language_alias`='eye'), 0, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'tissue_source_list'), (SELECT `id` FROM structure_permissible_values WHERE `value` = 'stomach' AND `language_alias`='stomach'), 0, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'tissue_source_list'), (SELECT `id` FROM structure_permissible_values WHERE `value` = 'gi tract' AND `language_alias`='gi tract'), 0, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'tissue_source_list'), (SELECT `id` FROM structure_permissible_values WHERE `value` = 'colon' AND `language_alias`='colon'), 0, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'tissue_source_list'), (SELECT `id` FROM structure_permissible_values WHERE `value` = 'bowel' AND `language_alias`='bowel'), 0, 1, 1);

-- set the order of the current value to zero
UPDATE structure_value_domains_permissible_values
SET `display_order` = 0 
WHERE 
`structure_value_domain_id` = (SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'tissue_source_list')
AND
`structure_permissible_value_id` = (SELECT `id` FROM structure_permissible_values WHERE `value` = 'placenta' AND `language_alias`='placenta');

UPDATE structure_value_domains_permissible_values
SET `display_order` = 0 
WHERE 
`structure_value_domain_id` = (SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'tissue_source_list')
AND
`structure_permissible_value_id` = (SELECT `id` FROM structure_permissible_values WHERE `value` = 'other' AND `language_alias`='other');

REPLACE INTO i18n (`id`, `en`)
VALUES
('brain', 'Brain'),
('tonsils', 'Tonsils'),
('adenoids', 'Adenoids'),
('lung', 'Lung'),
('kidney', 'Kidney'),
('liver', 'Liver'),
('breast', 'Breast'),
('spleen', 'Spleen'),
('skin', 'Skin'),
('bone', 'Bone'),
('muscle', 'Muscle'),
('lymph node', 'Lymph Node'),
('eye', 'Eye'),
('stomach', 'Stomach'),
('gi tract', 'GI Tract'),
('colon', 'Colon'),
('bowel', 'Bowel'),
('placenta', 'Placenta'),
('other', 'Other');

