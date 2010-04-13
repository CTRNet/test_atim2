-- Version: v2.0.2
-- Description: This SQL script is an upgrade for ATiM v2.0.1. to 2.0.2. and must be run against
-- an existing ATiM installation. Be sure to backup your database before running this script!

-- Update version information
UPDATE `versions` 
SET `version_number` = 'v2.0.2', `date_installed` = '2010-04-12', `build_number` = ''
WHERE `versions`.`id` =1;

-- Delete all structures without associated fields
DELETE FROM `structures` WHERE id NOT IN
(
	SELECT structure_id
	FROM structure_formats
);

-- Eventum 848
DELETE FROM i18n WHERE id IN ('1', '2', '3', '4', '5');

-- eventum 803 - active flags
ALTER TABLE `aliquot_controls` CHANGE `status` `status` VARCHAR( 20 ) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT 'inactive';
UPDATE aliquot_controls SET `status`='0' WHERE `status`!='active';
UPDATE aliquot_controls SET `status`='1' WHERE `status`!='0';
ALTER TABLE `aliquot_controls` CHANGE `status` `flag_active` BOOLEAN NOT NULL DEFAULT '1';

UPDATE consent_controls SET `status`='0' WHERE `status`!='active';
UPDATE consent_controls SET `status`='1' WHERE `status`!='0';
ALTER TABLE consent_controls CHANGE `status` flag_active BOOLEAN NOT NULL DEFAULT '1';

UPDATE diagnosis_controls SET `status`='0' WHERE `status`!='active';
UPDATE diagnosis_controls SET `status`='1' WHERE `status`!='0';
ALTER TABLE diagnosis_controls CHANGE `status` flag_active BOOLEAN NOT NULL DEFAULT '1';

UPDATE event_controls SET `status`='0' WHERE `status`!='active' && `status`!='yes';
UPDATE event_controls SET `status`='1' WHERE `status`!='0';
ALTER TABLE event_controls CHANGE `status` flag_active BOOLEAN NOT NULL DEFAULT '1';

UPDATE misc_identifier_controls SET `status`='0' WHERE `status`!='active';
UPDATE misc_identifier_controls SET `status`='1' WHERE `status`!='0';
ALTER TABLE misc_identifier_controls CHANGE `status` flag_active BOOLEAN NOT NULL DEFAULT '1';

UPDATE parent_to_derivative_sample_controls SET `status`='0' WHERE `status`!='active';
UPDATE parent_to_derivative_sample_controls SET `status`='1' WHERE `status`!='0';
ALTER TABLE parent_to_derivative_sample_controls CHANGE `status` flag_active BOOLEAN NOT NULL DEFAULT '1';

ALTER TABLE protocol_controls ADD flag_active BOOLEAN NOT NULL DEFAULT '1';

UPDATE realiquoting_controls SET `status`='0' WHERE `status`!='active';
UPDATE realiquoting_controls SET `status`='1' WHERE `status`!='0';
ALTER TABLE realiquoting_controls CHANGE `status` flag_active BOOLEAN NOT NULL DEFAULT '1';

UPDATE sample_controls SET `status`='0' WHERE `status`!='active';
UPDATE sample_controls SET `status`='1' WHERE `status`!='0';
ALTER TABLE sample_controls CHANGE `status` flag_active BOOLEAN NOT NULL DEFAULT '1';

UPDATE sample_to_aliquot_controls SET `status`='0' WHERE `status`!='active';
UPDATE sample_to_aliquot_controls SET `status`='1' WHERE `status`!='0';
ALTER TABLE sample_to_aliquot_controls CHANGE `status` flag_active BOOLEAN NOT NULL DEFAULT '1';

UPDATE storage_controls SET `status`='0' WHERE `status`!='active';
UPDATE storage_controls SET `status`='1' WHERE `status`!='0';
ALTER TABLE storage_controls CHANGE `status` flag_active BOOLEAN NOT NULL DEFAULT '1';

UPDATE tx_controls SET `status`='0' WHERE `status`!='active';
UPDATE tx_controls SET `status`='1' WHERE `status`!='0';
ALTER TABLE tx_controls CHANGE `status` flag_active BOOLEAN NOT NULL DEFAULT '1';

UPDATE structure_value_domains_permissible_values SET `active`='0' WHERE `active`!='yes';
UPDATE structure_value_domains_permissible_values SET `active`='1' WHERE `active`!='0';
ALTER TABLE structure_value_domains_permissible_values CHANGE `active` flag_active BOOLEAN NOT NULL DEFAULT '1'; 

UPDATE menus SET `active`='0' WHERE `active`!='active' AND `active`!='yes' AND `active`!='1';
UPDATE menus SET `active`='1' WHERE `active`!='0';
ALTER TABLE menus CHANGE `active` flag_active BOOLEAN NOT NULL DEFAULT '1';

CREATE TABLE missing_translations(
	id varchar(255) NOT NULL UNIQUE PRIMARY KEY 
)Engine=InnoDb;

 -- Eventum 785785.
ALTER TABLE `visuallizard_atim2`.`pages` ADD COLUMN `use_link` VARCHAR(255) NOT NULL  AFTER `language_body`;