-- Update version information
INSERT INTO `versions` (version_number, date_installed, build_number) VALUES('2.4.0', NOW(), '> 3250');

REPLACE INTO i18n(id, en, fr) VALUES
('core_app_version', '2.4.0 dev', '2.4.0 dev'),
('previous versions', 'Previous versions', 'Versions précédentes'),
('add to order', 'Add To Order', 'Ajouter aux commandes'),
('temporary browsing', 'Temporary browsing', 'Navigation temporaire'),
('unsaved browsing trees that are automatically deleted when there are more than x', 
 'Unsaved browsing trees that are automatically deleted when there are more than 5.',
 "Arbres de navigation non enregistrés qui sont supprimés automatiquement lorsqu'il y en a plus de 5."),
('saved browsing', 'Saved browsing', 'Navigation enregistrée'),
('saved browsing trees', 'Saved browsing trees', 'Arbres de navigation enregistrés'),
('adding notes to a temporary browsing automatically moves it towards the saved browsing list',
 'Adding notes to a temporary browsing automatically moves it towards the saved browsing list.',
 "Ajouter des notes à une navigation temporaire la déplace automatiquement vers la liste des navigations enregistrées."),
("STR_NAVIGATE_UNSAVED_DATA",
 "You have unsaved modifications. Are you sure you want to leave this page?",
 "Vous avez des modifications non enregistrées. Êtes-vous certain de vouloir quitter cette page?"),
("the participant", "The participant", "Le participant"),
("friend", "Friend", "Ami(e)"),
("relationship", "Relationship", "Relation"),
("brother-in-law", "Brother-in-law", "Beau frère"),
("common-law spouse", "Common law spouse", "Conjoint de fait"),
("sister-in-law", "Sister-in-law", "Belle soeur"),
("father-in-law", "Father-in-law", "Beau père"),
("mother-in-law", "Mother-in-law", "Belle mère"),
("husband", "Husband", "Mari"),
("wife", "Wife", "Femme (mariée)"),
("household", "Household", "Ménage"),
("other family member", "Other family member", "Autre membre de la famille"),
('misc_identifier_reuse', 
 'Deleted identifiers can be reused. Do you want to create a <u>new</u> identifier or select one to <u>reuse</u>?',
 'Des identifiants peuvent être réutilisés Souhaitez-vous en créer un <u>nouveau</u> ou en choisir un à <u>réutiliser</u>?'),
('reuse', 'Reuse', 'Réutiliser'),
('select an identifier to assign to the current participant',
 'Select an identifier to assign to the current participant.',
 "Sélectionner un identifiant à assigner au participant actuel."),
('identifier value', 'Identifier value', "Valeur de l'identifiant"),
("you need to select an identifier value", "You need to select an identifier value.", "Vous devez sélectionner une valeur d'identifiant."),
("there are no unused identifiers left to reuse. hit cancel to return to the identifiers list.",
 "There are no unused identifiers left to reuse. Hit cancel to return to the identifiers list.",
 "Il n'y a plus d'identifiants non utilisés. Appuyez sur annuler pour retourner à la liste des identifiants."),
("by the time you submited your selection, the identifier was either used or removed from the system",
 "By the time you submited your selection, the identifier was either used or removed from the system.",
 "Pendant que vous choisissiez un identifiant, votre choix a été utilisé ou retiré du système."),
("manage reusable identifiers", "Manage reusable identifiers", "Gérer les identifiants réutilisables"),
("there are no unused identifiers of the current type",
 "There are no unused identifiers of the current type.",
 "Il n'y a pas d'identifiants du type actuel non utilisés."),
("identifier value", "Identifier value", "Valeur de l'identifiant"),
("select the identifiers you wish to delete permanently",
 "Select the identifiers you wish to delete permanently",
 "Sélectionnez les identifiants que vous souhaitez supprimer de façon permanente"),
("ok", "Ok", "Ok"),
("unused count", "Unused count", "Nombre d'inutilisés"),
("this name already exists", "This name already exists.", "Ce nom existe déjà."),
("select a new one or check the overwrite option", "Select a new one or check the overwrite option.", "Sélectionnez-en un nouveau ou cochez l'option pour écraser."),
("atim_preset_readonly",
 "All functions names containing add, batch, edit, define, delete, realiquot, remove, or save will de denied of access.",
 "Toutes les fonctions dont le nom contient add, batch, edit, define, delete, realiquot, remove, ou save seront refusées d'accès."),
("atim_preset_reset",
 "The master node is defined as \"Allow\" and all other nodes are cleared.",
 "Le noeud principal est défini comme \"Permettre\" et tous les autres noeuds sont effacés."),
("overwrite if it exists", "Overwrite if it exists", "Écraser s'il existe"),
("readonly", "Readonly", "Lecture seulement"),
("save preset", "Save preset", "Enregistrer une configuration prédéfinie"),
("saved presets", "Saved presets", "Configurations prédéfinies enregistrées"),
("atim presets", "ATiM presets", "Configurations prédéfinies d'ATiM"),
("search for users", "Search for users", "Chercher des utilisateurs"),
("not done participant messages having reached their due date",
 "Not done participant message(s) having reached their due date.",
 "Message(s) des participants pas faits ayant atteint leur date d'échéance."),
("manage contacts", "Manage contacts", "Gérer les contacts"),
("save contact", "Save contact", "Enregistrer un contact"),
("delete in batch", "Delete in batch", "Supprimer en lot"),
("primary phone number", "Primary phone number", "Numéro de téléphone primaire"),
("secondary phone number", "Secondary phone number", "Numéro de téléphone secondaire");

UPDATE i18n SET id='the aliquot with barcode [%s] has reached a volume bellow 0', en='The aliquot with barcode [%s] has reached a volume below 0.' WHERE id='the aliquot with barcode [%s] has reached a volume bellow 0';

ALTER TABLE datamart_browsing_indexes
 ADD COLUMN temporary BOOLEAN NOT NULL DEFAULT true AFTER notes;
ALTER TABLE datamart_browsing_indexes_revs
 ADD COLUMN temporary BOOLEAN NOT NULL DEFAULT true AFTER notes;
 
UPDATE datamart_browsing_indexes SET temporary=false;
UPDATE datamart_browsing_indexes_revs SET temporary=false;

-- Participant contact
ALTER TABLE participant_contacts
 ADD COLUMN relationship VARCHAR(50) NOT NULL DEFAULT '' AFTER phone_secondary_type;
ALTER TABLE participant_contacts_revs
 ADD COLUMN relationship VARCHAR(50) NOT NULL DEFAULT '' AFTER phone_secondary_type;
 
 
 
INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('participant_contact_relationship', '', '', null);
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="participant_contact_relationship"),  (SELECT id FROM structure_permissible_values WHERE value="aunt" AND language_alias="aunt"), "2", "1");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="participant_contact_relationship"),  (SELECT id FROM structure_permissible_values WHERE value="cousin" AND language_alias="cousin"), "2", "1");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="participant_contact_relationship"),  (SELECT id FROM structure_permissible_values WHERE value="mother" AND language_alias="mother"), "2", "1");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="participant_contact_relationship"),  (SELECT id FROM structure_permissible_values WHERE value="grandfather" AND language_alias="grandfather"), "2", "1");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="participant_contact_relationship"),  (SELECT id FROM structure_permissible_values WHERE value="other" AND language_alias="other"), "2", "1");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="participant_contact_relationship"),  (SELECT id FROM structure_permissible_values WHERE value="father" AND language_alias="father"), "2", "1");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="participant_contact_relationship"),  (SELECT id FROM structure_permissible_values WHERE value="grandmother" AND language_alias="grandmother"), "2", "1");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="participant_contact_relationship"),  (SELECT id FROM structure_permissible_values WHERE value="nephew" AND language_alias="nephew"), "2", "1");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="participant_contact_relationship"),  (SELECT id FROM structure_permissible_values WHERE value="brother" AND language_alias="brother"), "2", "1");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="participant_contact_relationship"),  (SELECT id FROM structure_permissible_values WHERE value="son" AND language_alias="son"), "2", "1");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="participant_contact_relationship"),  (SELECT id FROM structure_permissible_values WHERE value="niece" AND language_alias="niece"), "2", "1");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="participant_contact_relationship"),  (SELECT id FROM structure_permissible_values WHERE value="sister" AND language_alias="sister"), "2", "1");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="participant_contact_relationship"),  (SELECT id FROM structure_permissible_values WHERE value="daughter" AND language_alias="daughter"), "2", "1");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="participant_contact_relationship"),  (SELECT id FROM structure_permissible_values WHERE value="uncle" AND language_alias="uncle"), "2", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("friend", "friend");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="participant_contact_relationship"),  (SELECT id FROM structure_permissible_values WHERE value="friend" AND language_alias="friend"), "2", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("the participant", "the participant");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="participant_contact_relationship"),  (SELECT id FROM structure_permissible_values WHERE value="the participant" AND language_alias="the participant"), "1", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("other", "other");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="participant_contact_relationship"),  (SELECT id FROM structure_permissible_values WHERE value="other" AND language_alias="other"), "3", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("husband", "husband");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="participant_contact_relationship"),  (SELECT id FROM structure_permissible_values WHERE value="husband" AND language_alias="husband"), "2", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("wife", "wife");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="participant_contact_relationship"),  (SELECT id FROM structure_permissible_values WHERE value="wife" AND language_alias="wife"), "2", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("common-law spouse", "common-law spouse");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="participant_contact_relationship"),  (SELECT id FROM structure_permissible_values WHERE value="common-law spouse" AND language_alias="common-law spouse"), "2", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("father-in-law", "father-in-law");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="participant_contact_relationship"),  (SELECT id FROM structure_permissible_values WHERE value="father-in-law" AND language_alias="father-in-law"), "2", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("mother-in-law", "mother-in-law");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="participant_contact_relationship"),  (SELECT id FROM structure_permissible_values WHERE value="mother-in-law" AND language_alias="mother-in-law"), "2", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("brother-in-law", "brother-in-law");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="participant_contact_relationship"),  (SELECT id FROM structure_permissible_values WHERE value="brother-in-law" AND language_alias="brother-in-law"), "2", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("sister-in-law", "sister-in-law");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="participant_contact_relationship"),  (SELECT id FROM structure_permissible_values WHERE value="sister-in-law" AND language_alias="sister-in-law"), "2", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("household", "household");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="participant_contact_relationship"),  (SELECT id FROM structure_permissible_values WHERE value="household" AND language_alias="household"), "3", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("other family member", "other family member");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="participant_contact_relationship"),  (SELECT id FROM structure_permissible_values WHERE value="other family member" AND language_alias="other family member"), "3", "1");



INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'ParticipantContact', 'participant_contacts', 'relationship', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='participant_contact_relationship') , '0', '', '', '', 'relationship', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='participantcontacts'), (SELECT id FROM structure_fields WHERE `model`='ParticipantContact' AND `tablename`='participant_contacts' AND `field`='relationship' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='participant_contact_relationship')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='relationship' AND `language_tag`=''), '1', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1');
-- end of participant contact

ALTER TABLE misc_identifiers
 ADD COLUMN tmp_deleted BOOLEAN NOT NULL DEFAULT false;
ALTER TABLE misc_identifiers_revs
 ADD COLUMN tmp_deleted BOOLEAN NOT NULL DEFAULT false;
 
INSERT INTO structures(`alias`) VALUES ('misc_identifier_value');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'MiscIdentifier', 'misc_identifiers', 'identifier_value', 'input',  NULL , '0', '', '', '', 'identifier value', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='misc_identifier_value'), (SELECT id FROM structure_fields WHERE `model`='MiscIdentifier' AND `tablename`='misc_identifiers' AND `field`='identifier_value' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='identifier value' AND `language_tag`=''), '1', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');

INSERT INTO menus (id, parent_id, is_root, display_order, language_title, language_description, use_link) VALUES
('core_CAN_41_4', 'core_CAN_41', 0, 4, 'manage reusable identifiers', '', '/administrate/misc_identifiers/index'); 

UPDATE misc_identifier_controls SET autoincrement_name='' WHERE autoincrement_name IS NULL;
ALTER TABLE misc_identifier_controls MODIFY autoincrement_name VARCHAR(50) NOT NULL DEFAULT '';

INSERT INTO structures(`alias`) VALUES ('misc_identifier_manage');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('', '0', '', 'count', 'integer',  NULL , '0', '', '', '', 'unused count', ''), 
('Clinicalannotation', 'MiscIdentifierControl', 'misc_identifier_controls', 'misc_identifier_name', 'input',  NULL , '0', '', '', '', 'identifier name', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='misc_identifier_manage'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='count' AND `type`='integer' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='unused count' AND `language_tag`=''), '1', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='misc_identifier_manage'), (SELECT id FROM structure_fields WHERE `model`='MiscIdentifierControl' AND `tablename`='misc_identifier_controls' AND `field`='misc_identifier_name' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='identifier name' AND `language_tag`=''), '1', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');

INSERT INTO structures(`alias`) VALUES ('permission_save_preset');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Administrate', '0', '', 'overwrite', 'checkbox',  NULL , '0', '', '', '', 'overwrite if it exists', ''), 
('Administrate', 'PermissionsPreset', '', 'name', 'input',  NULL , '0', '', '', '', 'name', ''),
('Administrate', 'PermissionsPreset', '', 'description', 'textarea',  NULL , '0', '', '', '', 'description', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='permission_save_preset'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='overwrite' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='overwrite if it exists' AND `language_tag`=''), '1', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='permission_save_preset'), (SELECT id FROM structure_fields WHERE `model`='PermissionsPreset' AND `tablename`='' AND `field`='name' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='name' AND `language_tag`=''), '1', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='permission_save_preset'), (SELECT id FROM structure_fields WHERE `model`='PermissionsPreset' AND `tablename`='' AND `field`='description' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='description' AND `language_tag`=''), '1', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');


ALTER TABLE sample_masters
 MODIFY `collection_id` int(11) NOT NULL;
ALTER TABLE sample_masters_revs
 MODIFY `collection_id` int(11) NOT NULL;
 
ALTER TABLE aliquot_masters
 MODIFY `collection_id` int(11) NOT NULL,
 MODIFY sample_master_id int(11) NOT NULL;
ALTER TABLE aliquot_masters_revs
 MODIFY `collection_id` int(11) NOT NULL,
 MODIFY sample_master_id int(11) NOT NULL;
 
CREATE TABLE permissions_presets(
 id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
 name VARCHAR(50) NOT NULL UNIQUE,
 description TEXT NOT NULL DEFAULT '',
 serialized_data TEXT NOT NULL,
 `created` datetime NOT NULL,
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime NOT NULL,
  `modified_by` int(10) unsigned NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0'
)Engine=InnoDb;
CREATE TABLE permissions_presets_revs(
 id INT UNSIGNED NOT NULL,
 name VARCHAR(50) NOT NULL UNIQUE,
 description TEXT NOT NULL DEFAULT '',
 serialized_data TEXT NOT NULL,
 `modified_by` int(10) unsigned NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
)Engine=InnoDb;


ALTER TABLE aliquot_masters
 DROP COLUMN aliquot_type,
 DROP COLUMN aliquot_volume_unit;
ALTER TABLE aliquot_masters_revs
 DROP COLUMN aliquot_type,
 DROP COLUMN aliquot_volume_unit;

UPDATE structure_fields SET model='AliquotControl', tablename='aliquot_controls' WHERE model='AliquotMaster' AND field='aliquot_type';
UPDATE structure_formats SET structure_field_id=(SELECT id FROM structure_fields WHERE model='AliquotControl' AND field='volume_unit') WHERE structure_field_id = (SELECT id FROM structure_fields WHERE model='AliquotMaster' AND field='aliquot_volume_unit');

ALTER TABLE protocol_masters
 DROP COLUMN tumour_group;
ALTER TABLE protocol_masters_revs
 DROP COLUMN tumour_group;

UPDATE structure_fields SET model='ProtocolControl', tablename='protocol_controls' WHERE model='ProtocolMaster' AND field='tumour_group';

ALTER TABLE sample_masters
 DROP COLUMN sample_type,
 DROP COLUMN sample_category; 
ALTER TABLE sample_masters_revs
 DROP COLUMN sample_type,
 DROP COLUMN sample_category;
 
UPDATE structure_fields SET model='SampleControl', tablename='sample_controls' WHERE field='sample_type' AND model='SampleMaster'; 
UPDATE structure_fields SET model='SampleControl', tablename='sample_controls' WHERE field='sample_category' AND model='SampleMaster'; 
 
ALTER TABLE sop_masters
 DROP COLUMN sop_group,
 DROP COLUMN type; 
ALTER TABLE sop_masters_revs
 DROP COLUMN sop_group,
 DROP COLUMN type; 
 
UPDATE structure_fields SET model='SopControl', tablename='sop_controls' WHERE field='sop_group' AND model='SopMaster';
UPDATE structure_fields SET model='SopControl', tablename='sop_controls' WHERE field='type' AND model='SopMaster';

ALTER TABLE specimen_review_masters
 DROP COLUMN specimen_sample_type,
 DROP COLUMN review_type; 
ALTER TABLE specimen_review_masters_revs
 DROP COLUMN specimen_sample_type,
 DROP COLUMN review_type; 
 
UPDATE structure_fields SET model='SpecimenReviewControl', tablename='specimen_review_controls' WHERE field='specimen_sample_type' AND model='SpecimenReviewMaster';
UPDATE structure_fields SET model='SpecimenReviewControl', tablename='specimen_review_controls' WHERE field='review_type' AND model='SpecimenReviewMaster';

ALTER TABLE storage_masters
 DROP COLUMN storage_type,
 DROP COLUMN set_temperature;
ALTER TABLE storage_masters_revs
 DROP COLUMN storage_type,
 DROP COLUMN set_temperature;

ALTER TABLE tx_masters
 DROP COLUMN tx_method,
 DROP COLUMN disease_site;
ALTER TABLE tx_masters_revs
 DROP COLUMN tx_method,
 DROP COLUMN disease_site;
 
UPDATE structure_fields SET model='TreatmentControl', tablename='tx_controls' WHERE field='tx_method' AND model='TreatmentMaster';
UPDATE structure_fields SET model='TreatmentControl', tablename='tx_controls' WHERE field='disease_site' AND model='TreatmentMaster';
 
DELETE FROM structure_validations WHERE structure_field_id NOT IN (SELECT structure_field_id FROM structure_formats);
DELETE FROM structure_fields WHERE id NOT IN (SELECT structure_field_id FROM structure_formats);
 

DROP VIEW view_aliquots;
CREATE VIEW view_aliquots AS 
SELECT 
al.id AS aliquot_master_id,
al.sample_master_id AS sample_master_id,
al.collection_id AS collection_id, 
col.bank_id, 
al.storage_master_id AS storage_master_id,
link.participant_id, 
link.diagnosis_master_id, 
link.consent_master_id,

part.participant_identifier, 

col.acquisition_label, 

specimenc.sample_type AS initial_specimen_sample_type,
specimen.sample_control_id AS initial_specimen_sample_control_id,
parent_sampc.sample_type AS parent_sample_type,
parent_samp.sample_control_id AS parent_sample_control_id,
sampc.sample_type,
samp.sample_control_id,

al.barcode,
al.aliquot_label,
alc.aliquot_type,
al.aliquot_control_id,
al.in_stock,

stor.code,
stor.selection_label,
al.storage_coord_x,
al.storage_coord_y,

stor.temperature,
stor.temp_unit,

al.created,
al.deleted

FROM aliquot_masters AS al
INNER JOIN aliquot_controls AS alc ON al.aliquot_control_id = alc.id
INNER JOIN sample_masters AS samp ON samp.id = al.sample_master_id AND samp.deleted != 1
INNER JOIN sample_controls AS sampc ON samp.sample_control_id = sampc.id
INNER JOIN collections AS col ON col.id = samp.collection_id AND col.deleted != 1
LEFT JOIN sample_masters AS specimen ON samp.initial_specimen_sample_id = specimen.id AND specimen.deleted != 1
LEFT JOIN sample_controls AS specimenc ON specimen.sample_control_id = specimenc.id
LEFT JOIN sample_masters AS parent_samp ON samp.parent_id = parent_samp.id AND parent_samp.deleted != 1
LEFT JOIN sample_controls AS parent_sampc ON parent_samp.sample_control_id=parent_sampc.id
LEFT JOIN clinical_collection_links AS link ON col.id = link.collection_id AND link.deleted != 1
LEFT JOIN participants AS part ON link.participant_id = part.id AND part.deleted != 1
LEFT JOIN storage_masters AS stor ON stor.id = al.storage_master_id AND stor.deleted != 1
WHERE al.deleted != 1;

DROP VIEW view_samples;
CREATE VIEW view_samples AS 
SELECT 
samp.id AS sample_master_id,
samp.parent_id AS parent_sample_id,
samp.initial_specimen_sample_id,
samp.collection_id AS collection_id,

col.bank_id, 
col.sop_master_id, 
link.participant_id, 
link.diagnosis_master_id, 
link.consent_master_id,

part.participant_identifier, 

col.acquisition_label, 

specimenc.sample_type AS initial_specimen_sample_type,
specimen.sample_control_id AS initial_specimen_sample_control_id,
parent_sampc.sample_type AS parent_sample_type,
parent_samp.sample_control_id AS parent_sample_control_id,
sampc.sample_type,
samp.sample_control_id,
samp.sample_code,
sampc.sample_category,
samp.deleted

FROM sample_masters as samp
INNER JOIN sample_controls as sampc ON samp.sample_control_id=sampc.id
INNER JOIN collections AS col ON col.id = samp.collection_id AND col.deleted != 1
LEFT JOIN sample_masters AS specimen ON samp.initial_specimen_sample_id = specimen.id AND specimen.deleted != 1
LEFT JOIN sample_controls AS specimenc ON specimen.sample_control_id = specimenc.id
LEFT JOIN sample_masters AS parent_samp ON samp.parent_id = parent_samp.id AND parent_samp.deleted != 1
LEFT JOIN sample_controls AS parent_sampc ON parent_samp.sample_control_id = parent_sampc.id
LEFT JOIN clinical_collection_links AS link ON col.id = link.collection_id AND link.deleted != 1
LEFT JOIN participants AS part ON link.participant_id = part.id AND part.deleted != 1
WHERE samp.deleted != 1;


DROP VIEW view_aliquot_uses;
CREATE VIEW view_aliquot_uses AS 

SELECT 
CONCAT(source.id, 1) AS id,
aliq.id AS aliquot_master_id,
'sample derivative creation' AS use_definition, 
samp.sample_code AS use_code,
'' AS use_details,
source.used_volume,
aliqc.volume_unit AS aliquot_volume_unit,
der.creation_datetime AS use_datetime,
der.creation_datetime_accuracy AS use_datetime_accuracy,
der.creation_by AS used_by,
source.created,
CONCAT('|inventorymanagement|aliquot_masters|listAllSourceAliquots|',samp.collection_id ,'|',samp.id) AS detail_url,
samp2.id AS sample_master_id,
samp2.collection_id AS collection_id
FROM source_aliquots AS source
INNER JOIN sample_masters AS samp ON samp.id = source.sample_master_id  AND samp.deleted != 1
INNER JOIN derivative_details AS der ON samp.id = der.sample_master_id  AND der.deleted != 1
INNER JOIN aliquot_masters AS aliq ON aliq.id = source.aliquot_master_id AND aliq.deleted != 1
INNER JOIN aliquot_controls AS aliqc ON aliq.aliquot_control_id = aliqc.id
INNER JOIN sample_masters AS samp2 ON samp2.id = aliq.sample_master_id  AND samp.deleted != 1
WHERE source.deleted != 1

UNION ALL

SELECT 
CONCAT(realiq.id, 2) AS id,
aliq.id AS aliquot_master_id,
'realiquoted to' AS use_definition, 
child.barcode AS use_code,
'' AS use_details,
realiq.parent_used_volume AS used_volume,
aliqc.volume_unit AS aliquot_volume_unit,
realiq.realiquoting_datetime AS use_datetime,
realiq.realiquoting_datetime_accuracy AS use_datetime_accuracy,
realiq.realiquoted_by AS used_by,
realiq.created,
CONCAT('|inventorymanagement|aliquot_masters|listAllRealiquotedParents|',child.collection_id,'|',child.sample_master_id,'|',child.id) AS detail_url,
samp.id AS sample_master_id,
samp.collection_id AS collection_id
FROM realiquotings AS realiq
INNER JOIN aliquot_masters AS aliq ON aliq.id = realiq.parent_aliquot_master_id AND aliq.deleted != 1
INNER JOIN aliquot_controls AS aliqc ON aliq.aliquot_control_id = aliqc.id
INNER JOIN aliquot_masters AS child ON child.id = realiq.child_aliquot_master_id AND child.deleted != 1
INNER JOIN sample_masters AS samp ON samp.id = aliq.sample_master_id  AND samp.deleted != 1
WHERE realiq.deleted != 1

UNION ALL

SELECT 
CONCAT(qc.id, 3) AS id,
aliq.id AS aliquot_master_id,
'quality control' AS use_definition, 
qc.qc_code AS use_code,
'' AS use_details,
qc.used_volume,
aliqc.volume_unit AS aliquot_volume_unit,
qc.date AS use_datetime,
qc.date_accuracy AS use_datetime_accuracy,
qc.run_by AS used_by,
qc.created,
CONCAT('|inventorymanagement|quality_ctrls|detail|',aliq.collection_id,'|',aliq.sample_master_id,'|',qc.id) AS detail_url,
samp.id AS sample_master_id,
samp.collection_id AS collection_id
FROM quality_ctrls AS qc
INNER JOIN aliquot_masters AS aliq ON aliq.id = qc.aliquot_master_id AND aliq.deleted != 1
INNER JOIN aliquot_controls AS aliqc ON aliq.aliquot_control_id = aliqc.id
INNER JOIN sample_masters AS samp ON samp.id = aliq.sample_master_id  AND samp.deleted != 1
WHERE qc.deleted != 1

UNION ALL

SELECT 
CONCAT(item.id, 4) AS id,
aliq.id AS aliquot_master_id,
'aliquot shipment' AS use_definition, 
sh.shipment_code AS use_code,
'' AS use_details,
'' AS used_volume,
'' AS aliquot_volume_unit,
sh.datetime_shipped AS use_datetime,
sh.datetime_shipped_accuracy AS use_datetime_accuracy,
sh.shipped_by AS used_by,
sh.created,
CONCAT('|order|shipments|detail|',sh.order_id,'|',sh.id) AS detail_url,
samp.id AS sample_master_id,
samp.collection_id AS collection_id
FROM order_items AS item
INNER JOIN aliquot_masters AS aliq ON aliq.id = item.aliquot_master_id AND aliq.deleted != 1
INNER JOIN shipments AS sh ON sh.id = item.shipment_id AND sh.deleted != 1
INNER JOIN sample_masters AS samp ON samp.id = aliq.sample_master_id  AND samp.deleted != 1
WHERE item.deleted != 1

UNION ALL

SELECT 
CONCAT(alr.id, 5) AS id,
aliq.id AS aliquot_master_id,
'specimen review' AS use_definition, 
spr.review_code AS use_code,
'' AS use_details,
'' AS used_volume,
'' AS aliquot_volume_unit,
spr.review_date AS use_datetime,
spr.review_date_accuracy AS use_datetime_accuracy,
'' AS used_by,
alr.created,
CONCAT('|inventorymanagement|specimen_reviews|detail|',aliq.collection_id,'|',aliq.sample_master_id,'|',spr.id) AS detail_url,
samp.id AS sample_master_id,
samp.collection_id AS collection_id
FROM aliquot_review_masters AS alr
INNER JOIN aliquot_masters AS aliq ON aliq.id = alr.aliquot_master_id AND aliq.deleted != 1
INNER JOIN specimen_review_masters AS spr ON spr.id = alr.specimen_review_master_id AND spr.deleted != 1
INNER JOIN sample_masters AS samp ON samp.id = aliq.sample_master_id  AND samp.deleted != 1
WHERE alr.deleted != 1

UNION ALL

SELECT 
CONCAT(aluse.id, 6) AS id,
aliq.id AS aliquot_master_id,
'internal use' AS use_definition, 
aluse.use_code,
aluse.use_details,
aluse.used_volume,
aliqc.volume_unit AS aliquot_volume_unit,
aluse.use_datetime,
aluse.use_datetime_accuracy,
aluse.used_by,
aluse.created,
CONCAT('|inventorymanagement|aliquot_masters|detailAliquotInternalUse|',aliq.id,'|',aluse.id) AS detail_url,
samp.id AS sample_master_id,
samp.collection_id AS collection_id
FROM aliquot_internal_uses AS aluse
INNER JOIN aliquot_masters AS aliq ON aliq.id = aluse.aliquot_master_id AND aliq.deleted != 1
INNER JOIN aliquot_controls AS aliqc ON aliq.aliquot_control_id = aliqc.id
INNER JOIN sample_masters AS samp ON samp.id = aliq.sample_master_id  AND samp.deleted != 1
WHERE aluse.deleted != 1;

UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='users') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='User' AND `tablename`='users' AND `field`='first_name' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='users') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='User' AND `tablename`='users' AND `field`='last_name' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='users') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='User' AND `tablename`='users' AND `field`='email' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='users') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='User' AND `tablename`='users' AND `field`='department' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

INSERT INTO menus (id, parent_id, is_root, display_order, language_title, language_description, use_link, use_params, use_summary, flag_active, created, created_by, modified, modified_by) VALUES
('core_CAN_41_5', 'core_CAN_41', 0, 4, 'search for users', '', '/administrate/users/search/', '', '', 1, NOW(), 1, NOW(), 1); 

ALTER TABLE participant_messages
 ADD COLUMN done TINYINT UNSIGNED DEFAULT 0 AFTER `participant_id`;
ALTER TABLE participant_messages_revs
 ADD COLUMN done TINYINT UNSIGNED DEFAULT 0 AFTER `participant_id`;
 
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'ParticipantMessage', 'participant_messages', 'done', 'checkbox',  NULL , '0', '', '', '', 'done', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='participantmessages'), (SELECT id FROM structure_fields WHERE `model`='ParticipantMessage' AND `tablename`='participant_messages' AND `field`='done' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='done' AND `language_tag`=''), '1', '7', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '1');
UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participantmessages') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ParticipantMessage' AND `tablename`='participant_messages' AND `field`='expiry_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

CREATE TABLE shipment_contacts(
 id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
 recipient VARCHAR(60) NOT NULL DEFAULT '',
 facility VARCHAR(60) NOT NULL DEFAULT '',
 delivery_street_address VARCHAR(2550) NOT NULL DEFAULT '',
 delivery_city VARCHAR(2550) NOT NULL DEFAULT '',
 delivery_province VARCHAR(2550) NOT NULL DEFAULT '',
 delivery_postal_code VARCHAR(2550) NOT NULL DEFAULT '',
 delivery_country VARCHAR(2550) NOT NULL DEFAULT '',
 `created` datetime NOT NULL,
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime NOT NULL,
  `modified_by` int(10) unsigned NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0'
)Engine=InnoDb;
CREATE TABLE shipment_contacts_revs(
 id INT UNSIGNED NOT NULL,
 recipient VARCHAR(60) NOT NULL DEFAULT '',
 facility VARCHAR(60) NOT NULL DEFAULT '',
 delivery_street_address VARCHAR(2550) NOT NULL DEFAULT '',
 delivery_city VARCHAR(2550) NOT NULL DEFAULT '',
 delivery_province VARCHAR(2550) NOT NULL DEFAULT '',
 delivery_postal_code VARCHAR(2550) NOT NULL DEFAULT '',
 delivery_country VARCHAR(2550) NOT NULL DEFAULT '',
`modified_by` int(10) unsigned NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
)Engine=InnoDb;

INSERT INTO structures(`alias`) VALUES ('shipment_recipients');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Order', 'ShipmentContact', 'shipments_contacts', 'recipient', 'input',  NULL , '0', '', '', '', 'recipient', ''), 
('Order', 'ShipmentContact', 'shipments_contacts', 'facility', 'input',  NULL , '0', '', '', '', 'facility', ''), 
('Order', 'ShipmentContact', 'shipments_contacts', 'delivery_street_address', 'input',  NULL , '0', '', '', '', 'delivery street address', ''), 
('Order', 'ShipmentContact', 'shipments_contacts', 'delivery_city', 'input',  NULL , '0', '', '', '', 'delivery city', ''), 
('Order', 'ShipmentContact', 'shipments_contacts', 'delivery_province', 'input',  NULL , '0', '', '', '', 'delivery province', ''), 
('Order', 'ShipmentContact', 'shipments_contacts', 'delivery_postal_code', 'input',  NULL , '0', '', '', '', 'delivery postal code', ''), 
('Order', 'ShipmentContact', 'shipments_contacts', 'delivery_country', 'input',  NULL , '0', '', '', '', 'delivery country', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='shipment_recipients'), (SELECT id FROM structure_fields WHERE `model`='ShipmentContact' AND `tablename`='shipments_contacts' AND `field`='recipient' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='recipient' AND `language_tag`=''), '1', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='shipment_recipients'), (SELECT id FROM structure_fields WHERE `model`='ShipmentContact' AND `tablename`='shipments_contacts' AND `field`='facility' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='facility' AND `language_tag`=''), '1', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='shipment_recipients'), (SELECT id FROM structure_fields WHERE `model`='ShipmentContact' AND `tablename`='shipments_contacts' AND `field`='delivery_street_address' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='delivery street address' AND `language_tag`=''), '1', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='shipment_recipients'), (SELECT id FROM structure_fields WHERE `model`='ShipmentContact' AND `tablename`='shipments_contacts' AND `field`='delivery_city' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='delivery city' AND `language_tag`=''), '1', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='shipment_recipients'), (SELECT id FROM structure_fields WHERE `model`='ShipmentContact' AND `tablename`='shipments_contacts' AND `field`='delivery_province' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='delivery province' AND `language_tag`=''), '1', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='shipment_recipients'), (SELECT id FROM structure_fields WHERE `model`='ShipmentContact' AND `tablename`='shipments_contacts' AND `field`='delivery_postal_code' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='delivery postal code' AND `language_tag`=''), '1', '6', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='shipment_recipients'), (SELECT id FROM structure_fields WHERE `model`='ShipmentContact' AND `tablename`='shipments_contacts' AND `field`='delivery_country' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='delivery country' AND `language_tag`=''), '1', '7', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1');

ALTER TABLE diagnosis_masters
 ADD COLUMN parent_id INT DEFAULT NULL AFTER id,
 ADD FOREIGN KEY(parent_id) REFERENCES `diagnosis_masters`(`id`);
ALTER TABLE diagnosis_masters_revs
 ADD COLUMN parent_id INT DEFAULT NULL AFTER id;

ALTER TABLE diagnosis_controls
 ADD COLUMN flag_primary BOOLEAN NOT NULL,
 ADD COLUMN flag_secondary BOOLEAN NOT NULL;
 
UPDATE diagnosis_controls SET flag_primary=true WHERE controls_type NOT LIKE 'cap%';
UPDATE diagnosis_controls SET flag_secondary=true;

UPDATE structure_formats SET `flag_add_readonly`='1', `flag_edit_readonly`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_bloods') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_origin' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='origin') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add_readonly`='1', `flag_edit_readonly`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_tissues') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_origin' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='origin') AND `flag_confidential`='0');

SELECT '--Looking for bogus primary dx--' AS msg;
CREATE TABLE tmp_bogus_primary_dx (SELECT participant_id, primary_number, COUNT(*) AS c FROM diagnosis_masters WHERE dx_origin='primary' GROUP BY participant_id, primary_number HAVING c > 1);
ALTER TABLE tmp_bogus_primary_dx 
 ADD INDEX (`participant_id`),
 ADD INDEX (`primary_number`);
SELECT IF(COUNT(*) > 0, 'See table tmp_bogus_primary_dx to manually fix the bogus primary dx and their children', 'All dx are ok. You can drop table tmp_bogus_primary_dx') AS msg FROM tmp_bogus_primary_dx
UNION
SELECT 'Once done you may drop diagnosis_masters.primary_number as well as diagnosis_masters_revs.primary_number' AS msg; 

UPDATE diagnosis_masters AS dm
LEFT JOIN diagnosis_masters AS dm_parent ON dm.participant_id=dm_parent.participant_id AND dm.dx_origin!='primary' AND dm_parent.dx_origin='primary' AND dm.primary_number=dm_parent.primary_number
LEFT JOIN tmp_bogus_primary_dx AS bogus_dx ON dm.participant_id=bogus_dx.participant_id AND dm.primary_number=bogus_dx.primary_number
SET dm.parent_id=dm_parent.id
WHERE dm_parent.id IS NOT NULL AND bogus_dx.participant_id IS NULL;

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("recurrence", "recurrence");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="origin"),  (SELECT id FROM structure_permissible_values WHERE value="recurrence" AND language_alias="recurrence"), "2", "1");

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("progression", "progression");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="origin"),  (SELECT id FROM structure_permissible_values WHERE value="progression" AND language_alias="progression"), "2", "1");

INSERT INTO structures(`alias`) VALUES ('dx_origin_primary');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='dx_origin_primary'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_origin' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='origin')  AND `flag_confidential`='0'), '1', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', 'primary', '1', '1', '1', '1', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1');

INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('origin_wo_primary', '', '', NULL);
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("secondary", "secondary");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="origin_wo_primary"),  (SELECT id FROM structure_permissible_values WHERE value="secondary" AND language_alias="secondary"), "2", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("recurrence", "recurrence");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="origin_wo_primary"),  (SELECT id FROM structure_permissible_values WHERE value="recurrence" AND language_alias="recurrence"), "2", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("progression", "progression");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="origin_wo_primary"),  (SELECT id FROM structure_permissible_values WHERE value="progression" AND language_alias="progression"), "2", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("unknown", "unknown");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="origin_wo_primary"),  (SELECT id FROM structure_permissible_values WHERE value="unknown" AND language_alias="unknown"), "2", "1");

INSERT INTO structures(`alias`) VALUES ('dx_origin_wo_primary');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'DiagnosisMaster', 'diagnosis_masters', 'dx_origin', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='origin_wo_primary') , '0', '', '', 'help_dx origin', 'origin', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='dx_origin_wo_primary'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_origin' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='origin_wo_primary')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_dx origin' AND `language_label`='origin' AND `language_tag`=''), '1', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1');

UPDATE structure_formats SET `flag_add`='0', `flag_add_readonly`='0', `flag_edit`='0', `flag_edit_readonly`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_bloods') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_origin' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='origin') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_add_readonly`='0', `flag_edit`='0', `flag_edit_readonly`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_tissues') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_origin' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='origin') AND `flag_confidential`='0');

INSERT INTO structure_validations (structure_field_id, rule, on_action, language_message) VALUES
((SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_origin' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='origin_wo_primary')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_dx origin' AND `language_label`='origin' AND `language_tag`=''), 'notEmpty', '', '');

DELETE FROM structure_formats WHERE structure_field_id=(SELECT id FROM structure_fields WHERE plugin='Clinicalannotation' AND model='DiagnosisMaster' AND tablename='diagnosis_masters' AND field='primary_number');
DELETE FROM structure_fields WHERE plugin='Clinicalannotation' AND model='DiagnosisMaster' AND tablename='diagnosis_masters' AND field='primary_number';

ALTER TABLE datamart_adhoc
 ADD COLUMN function_for_results VARCHAR(50) NOT NULL DEFAULT '' AFTER sql_query_for_results,
 CHANGE flag_use_query_results flag_use_control_for_results TINYINT UNSIGNED NOT NULL DEFAULT 0;

ALTER TABLE datamart_batch_sets
 ADD COLUMN datamart_adhoc_id INT DEFAULT NULL AFTER `datamart_structure_id`,
 DROP COLUMN lookup_key_name,
 ADD FOREIGN KEY (`datamart_adhoc_id`) REFERENCES `datamart_adhoc`(`id`);
 
UPDATE datamart_batch_sets AS dbs
LEFT JOIN datamart_adhoc AS da ON dbs.form_alias_for_results=da.form_alias_for_results AND dbs.sql_query_for_results=da.sql_query_for_results 
 AND dbs.form_links_for_results=da.form_links_for_results AND dbs.flag_use_query_results=da.flag_use_control_for_results
SET dbs.datamart_adhoc_id=da.id;
SELECT IF(COUNT(*) > 0, 
 'Not all batch set have a datamart_structure_id or a datamart_adhoc_id. Update your batchsets to give them either a datamart_structure_id or a datamart_adhoc_id before running the following update query.', 
 'All batchsets have either a datamart_structure_id or a datamart_adhoc_id. You can run the following query.') AS msg FROM datamart_batch_sets WHERE datamart_structure_id IS NULL AND datamart_adhoc_id IS NULL
UNION
SELECT 'ALTER TABLE datamart_batch_sets
 DROP COLUMN form_alias_for_results,
 DROP COLUMN sql_query_for_results,
 DROP COLUMN form_links_for_results,
 DROP COLUMN flag_use_query_results,
 DROP COLUMN plugin,
 DROP COLUMN model' AS msg;
 
UPDATE structure_fields SET  `language_label`='primary phone number',  `language_tag`='' WHERE model='ParticipantContact' AND tablename='participant_contacts' AND field='phone' AND `type`='input' AND structure_value_domain  IS NULL ;
UPDATE structure_fields SET  `language_label`='secondary phone number',  `language_tag`='' WHERE model='ParticipantContact' AND tablename='participant_contacts' AND field='phone_secondary' AND `type`='input' AND structure_value_domain  IS NULL ;
UPDATE structure_fields SET  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='phone_type') ,  `language_help`='',  `language_label`='',  `language_tag`='type' WHERE model='ParticipantContact' AND tablename='participant_contacts' AND field='phone_secondary_type' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='phone_type');
UPDATE structure_fields SET  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='phone_type') ,  `language_help`='',  `language_label`='',  `language_tag`='type' WHERE model='ParticipantContact' AND tablename='participant_contacts' AND field='phone_type' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='phone_type');
UPDATE structure_formats SET `display_order`='20' WHERE structure_id=(SELECT id FROM structures WHERE alias='participantcontacts') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ParticipantContact' AND `tablename`='participant_contacts' AND `field`='phone' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='22' WHERE structure_id=(SELECT id FROM structures WHERE alias='participantcontacts') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ParticipantContact' AND `tablename`='participant_contacts' AND `field`='phone_secondary' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='23' WHERE structure_id=(SELECT id FROM structures WHERE alias='participantcontacts') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ParticipantContact' AND `tablename`='participant_contacts' AND `field`='phone_secondary_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='phone_type') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='21' WHERE structure_id=(SELECT id FROM structures WHERE alias='participantcontacts') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ParticipantContact' AND `tablename`='participant_contacts' AND `field`='phone_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='phone_type') AND `flag_confidential`='0');

CREATE TABLE wizards(
 id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
 description text
)Engine=InnoDb;

CREATE TABLE wizard_nodes(
 id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
 parent_id INT UNSIGNED DEFAULT NULL,
 wizard_id INT UNSIGNED NOT NULL,
 datamart_structure_id INT UNSIGNED NOT NULL,
 control_id TINYINT UNSIGNED DEFAULT 0,
 FOREIGN KEY (`parent_id`) REFERENCES wizard_nodes(`id`),
 FOREIGN KEY (`wizard_id`) REFERENCES wizards(id),
 FOREIGN KEY (datamart_structure_id) REFERENCES datamart_structures(id)
)Engine=InnoDb;

INSERT INTO structures(`alias`) VALUES ('wizard');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Tool', 'Wizard', 'wizards', 'description', 'input',  NULL , '0', '', '', '', 'description', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='wizard'), (SELECT id FROM structure_fields WHERE `model`='Wizard' AND `tablename`='wizards' AND `field`='description' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='description' AND `language_tag`=''), '1', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');

