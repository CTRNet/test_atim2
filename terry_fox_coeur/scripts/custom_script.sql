-- run after v2.2.2
INSERT INTO banks(`name`, `description`, `created_by`, `created`, `modified_by`, `modified`) VALUES
('OHRI-COEUR', '', 1, NOW(), 1, NOW());
INSERT INTO misc_identifier_controls (misc_identifier_name, misc_identifier_name_abbrev, flag_once_per_participant) VALUES
('OHRI-COEUR', 'OHRI-COEUR', 1);

ALTER TABLE banks
 ADD COLUMN misc_identifier_control_id INT DEFAULT NULL AFTER description;
ALTER TABLE banks_revs
 ADD COLUMN misc_identifier_control_id INT DEFAULT NULL AFTER description;
 
UPDATE banks SET misc_identifier_control_id=id;