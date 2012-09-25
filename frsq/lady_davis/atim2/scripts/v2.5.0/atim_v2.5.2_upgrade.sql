INSERT INTO i18n (id,en,fr) VALUES ('a user name can not be changed', 'A user name can not be modified', 'Un nom d''utilisateur ne peut pas être modifié');

ALTER TABLE users DROP index unique_username;
ALTER TABLE groups DROP index name;

INSERT INTO `structure_validations` (`structure_field_id`, `rule`, `language_message`) VALUES ((SELECT id FROM structure_fields WHERE model = 'Group' AND field = 'name'), 'isUnique', "this name is already in use");
INSERT INTO `structure_validations` (`structure_field_id`, `rule`, `language_message`) VALUES ((SELECT id FROM structure_fields WHERE model = 'Group' AND field = 'name'), 'notEmpty', "");
INSERT INTO `structure_validations` (`structure_field_id`, `rule`, `language_message`) VALUES ((SELECT id FROM structure_fields WHERE model = 'User' AND field = 'username'), 'isUnique', "this name is already in use");
INSERT INTO `structure_validations` (`structure_field_id`, `rule`, `language_message`) VALUES ((SELECT id FROM structure_fields WHERE model = 'Bank' AND field = 'name'), 'isUnique', "this name is already in use");
INSERT INTO `structure_validations` (`structure_field_id`, `rule`, `language_message`) VALUES ((SELECT id FROM structure_fields WHERE model = 'Bank' AND field = 'name'), 'notEmpty', "");

UPDATE menus SET use_link = '/Material/Materials/detail/%%Material.id%%' WHERE use_link = '/Material/materials/detail/%%Material.id%%';
UPDATE menus SET use_link = '/Material/Materials/index/' WHERE use_link = '/Material/materials/index/';

INSERT INTO `versions` (version_number, date_installed, build_number) VALUES
('2.5.2', NOW(), '4882');
