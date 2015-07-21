-- BCCH Customization Script
-- Version 0.3.2
-- ATiM Version: 2.6.3

-- Update bank name for version tracking during customization
REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('core_installname', "BCCH Biobank - BCCH v0.3.2", '');

--  =========================================================================
--	Eventum ID: #XXXX- Allow numbers for the study title
--  BB-86
--	=========================================================================

INSERT INTO misc_identifier_controls (`misc_identifier_name`, `flag_active`, `display_order`, `flag_once_per_participant`, `flag_unique`)
VALUES
('CAUSES ID', 1, 11, 1, 1);

INSERT INTO i18n (`id`, `en`)
VALUES
('CAUSES ID', 'CAUSES ID');

-- Change project ID from 5 characters to 6 characters
-- Update the error and help messages. 

UPDATE structure_validations
SET `rule`='between,1,6', `language_message`='ccbr study title must be between 1 to 6 letters'
WHERE `rule`='between,1,5' AND `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `plugin`='Study' AND `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='title');

UPDATE structure_validations
SET `language_message`='ccbr study title must be letters and numbers only'
WHERE `rule`='custom,/^[A-Za-z0-9]+$/' AND `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `plugin`='Study' AND `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='title');

UPDATE structure_validations
SET `language_message`='ccbr study title cannot be empty'
WHERE `rule`='notEmpty' AND `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `plugin`='Study' AND `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='title');

UPDATE structure_validations
SET `language_message`='ccbr study title must be unique'
WHERE `rule`='isUnique' AND `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `plugin`='Study' AND `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='title');

DELETE FROM `i18n` WHERE `id`='ccbr study title must be 5 characters' OR `id`='ccbr study title must be letters only';

REPLACE INTO `i18n` (`id`, `en`) VALUES 
('ccbr study title must be between 1 to 6 letters', 'Study title must be between 1 to 6 letters'),
('ccbr study title must be letters and numbers only', 'Study title must be letters and numbers only'),
('ccbr study title cannot be empty', 'Study title cannot be empty'),
('ccbr study title must be unique', 'Study title must be unique'),
('study_title_help', '6 characters long maximum study title. Letters or numbers only');


