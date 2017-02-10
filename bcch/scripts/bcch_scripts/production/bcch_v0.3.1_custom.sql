-- BCCH Customization Script
-- Version 0.3.1
-- ATiM Version: 2.6.3

-- Update bank name for version tracking during customization
REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('core_installname', "BCCH Biobank - BCCH v0.3.1", '');

--  =========================================================================
--	Eventum ID: #3242- Allow numbers for the study title
--  BB-60
--	=========================================================================

UPDATE structure_validations
SET `rule`='custom,/^[A-Za-z0-9]+$/'
WHERE `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `plugin`='Study' AND `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='title' AND `language_label`='study_title')
AND `rule`='custom,/^[A-Za-z]+$/';

UPDATE structure_fields
SET `language_help`='study_title_help'
WHERE `plugin`='Study' AND `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='title' AND `language_label`='study_title';

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES 
('ccbr study title must be letters only', 'Study title must be numbers or letters only.', ''),
('study_title_help', '5 characters long maximum study title. Must be letters or numbers only.', '');

