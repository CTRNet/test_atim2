
-- Demonliazation

-- Participant Table --

-- First Name --

UPDATE `participants` SET `first_name` = cast(SHA1(`first_name`) AS CHAR(20) CHARACTER SET utf8);

-- Middle Name --

UPDATE `participants` SET `middle_name` = cast(SHA1(`middle_name`) AS CHAR(20) CHARACTER SET utf8);

-- Last Name --

UPDATE `participants` SET `last_name` = cast(SHA1(`last_name`) AS CHAR(20) CHARACTER SET utf8);

-- Date of Birth --

UPDATE `participants` SET `date_of_birth` = DATE_ADD(`date_of_birth`, INTERVAL FLOOR(1000*RAND()) DAY);

-- Parent or Guardian Name --

UPDATE `participants` SET `ccbr_parent_guardian_name` = cast(SHA1(`ccbr_parent_guardian_name`) AS CHAR(20) CHARACTER SET utf8);

-- Participant log tables --

UPDATE `participants`, `participants_revs`
SET `participants_revs`.`first_name` = `participants`.`first_name`,
`participants_revs`.`middle_name` = `participants`.`middle_name`,
`participants_revs`.`last_name` = `participants`.`last_name`,
`participants_revs`.`date_of_birth` = `participants`.`date_of_birth`,
`participants_revs`.`ccbr_parent_guardian_name` = `participants`.`ccbr_parent_guardian_name`
WHERE `participants`.`id` = `participants_revs`.`id`;

-- Identifiers Table --

-- COG --

UPDATE `misc_identifiers` SET `identifier_value` = CAST(SHA1(`identifier_value`) AS CHAR(6) CHARACTER SET UTF8)
WHERE `misc_identifier_control_id` = (SELECT `id` FROM `misc_identifier_controls` WHERE `misc_identifier_name` = 'COG Registration');

-- MRN --

UPDATE `misc_identifiers` SET `identifier_value` = FLOOR(10000000*RAND())
WHERE `misc_identifier_control_id` = (SELECT `id` FROM misc_identifier_controls WHERE `misc_identifier_name` = 'MRN');

-- PHN --

UPDATE `misc_identifiers` SET `identifier_value` = CONCAT(FLOOR(1000*RAND()), ' ', FLOOR(1000*RAND()), ' ', FLOOR(10000*RAND()))
WHERE `misc_identifier_control_id` = (SELECT `id` FROM misc_identifier_controls WHERE `misc_identifier_name` = 'PHN');

UPDATE `misc_identifiers` SET `identifier_value` = CONCAT(FLOOR(10*RAND()), FLOOR(10*RAND()), FLOOR(10*RAND()), FLOOR(10*RAND()), ' ', FLOOR(10*RAND()), FLOOR(10*RAND()), FLOOR(10*RAND()), ' ', FLOOR(10*RAND()), FLOOR(10*RAND()), FLOOR(10*RAND()))
WHERE `misc_identifier_control_id` = (SELECT `id` FROM misc_identifier_controls WHERE `misc_identifier_name` = 'PHN');

-- Identifiers Revs Table --

UPDATE `misc_identifiers`, `misc_identifiers_revs`
SET `misc_identifiers_revs`.`identifier_value` = `misc_identifiers`.`identifier_value`
WHERE `misc_identifiers`.`id` = `misc_identifiers_revs`.`id`;

-- Participants Contact Information --

-- Contact Name


UPDATE `participant_contacts` SET `contact_name` = cast(SHA1(`contact_name`) AS CHAR(50) CHARACTER SET utf8);


-- Email Address

UPDATE `participant_contacts` SET `ccbr_email` = cast(SHA1(`ccbr_email`) AS CHAR(45) CHARACTER SET utf8);


-- Street

UPDATE `participant_contacts` SET `street` = cast(SHA1(`street`) AS CHAR(50) CHARACTER SET utf8);

-- City

UPDATE `participant_contacts` SET `locality` = cast(SHA1(`locality`) AS CHAR(50) CHARACTER SET utf8);

-- Postal Code

UPDATE `participant_contacts` SET `mail_code` = cast(SHA1(`mail_code`) AS CHAR(10) CHARACTER SET utf8);

-- Primary Phone Number

UPDATE `participant_contacts` SET `phone` = cast(SHA1(`phone`) AS CHAR(15) CHARACTER SET utf8);

-- Secondary Phone Number

UPDATE `participant_contacts` SET `phone_secondary` = cast(SHA1(`phone_secondary`) AS CHAR(30) CHARACTER SET utf8);

-- Participants Contact Log Table --

UPDATE `participant_contacts`, `participant_contacts_revs`
SET `participant_contacts_revs`.`contact_name` = `participant_contacts`.`contact_name`,
`participant_contacts_revs`.`ccbr_email` = `participant_contacts`.`ccbr_email`,
`participant_contacts_revs`.`street` = `participant_contacts`.`street`,
`participant_contacts_revs`.`locality` = `participant_contacts`.`locality`,
`participant_contacts_revs`.`mail_code` = `participant_contacts`.`mail_code`,
`participant_contacts_revs`.`phone` = `participant_contacts`.`phone`,
`participant_contacts_revs`.`phone_secondary` = `participant_contacts`.`phone_secondary`
WHERE `participant_contacts_revs`.`id` = `participant_contacts`.`id`;    