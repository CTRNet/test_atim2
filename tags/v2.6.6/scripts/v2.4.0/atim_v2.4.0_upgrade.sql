-- Run against a 2.3.6 installation
-- Read the printed messages carefully

-- Update version information
INSERT INTO `versions` (version_number, date_installed, build_number, created, created_by, modified, modified_by) VALUES('2.4.0', NOW(), '3853', NOW(), 1, NOW(), 1);

REPLACE INTO i18n(id, en, fr) VALUES
('core_app_version', '2.4.0', '2.4.0'),
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
("secondary phone number", "Secondary phone number", "Numéro de téléphone secondaire"),
("collection template", "Collection Template", "Modèle de collection"),
("collection_template_description", 
 "Collections templates allow to quickly create collection content without the need to browse the menus after the creation of each element.",
 "Les modèles de collections permettent de créer rapidement le contenu d'une collection sans devoir naviguer les menus après la création de chaque élément."),
("this field must be unique", "This field must be unique", "Ce champ doit être unique"),
("you cannot resume a search that was made in a previous session", 
 "You cannot resume a search that was made in a previous session.",
 "Vous ne pouvez pas reprendre une recherche qui a été faite dans une session antérieure."),
("you are not allowed to use the generic version of that batch set.",
 "You are not allowed to use the generic version of that batch set.",
 "Vous n'êtes pas autorisés à utiliser la version générique de cet ensemble de données."),
("the current diagnosis date is before the parent diagnosis date",
 "The current diagnosis date is before the parent diagnosis date.",
 "L'actuelle date de diagnostic est avant la date du diagnostic parent."),
("detailed results", "Detailed results", "Résultats détaillés"),
("the diagnosis value for %s does not match the cap report value",
 "The diagnosis value for %s does not match the cap report value",
 "La valeur du diagnostic pour %s ne correspond pas à la valeur du rapport cap"),
("auto submit", "Auto submit", "Envoi automatique"),
("there are no unused parent items", "There are no unused parent items", "Il n'y a pas d'éléments parents non utilisés"),
("unused parents", "Unused parents", "Parents non utilisés"),
("full export as CSV file", "Full export as CSV file", "Export complet comme fichier CSV"),
('copy for new collection', 'Copy for New coll.', "Copier pour nouvelle coll."),
("user", "User", "Utilisateur"),
("owner", "Owner", "Propriétaire"),
("visibility", "Visibility", "Visibilité"),
("visibility reduced to owner level", "Visibility reduced to owner level", "Visibilité réduite au niveau du propriétaire"),
("empty template", "Empty Template", "Modèle vide"),
("redirecting to samples & aliquots", "Redirecting to samples & aliquots", "Redirection vers échantillons & aliquots"),
("the results contain various data types, so the details are not displayed",
 "The results contain various data types, so the details are not displayed.",
 "Les résultats contiennent différents types de données, alors les détails ne sont pas affichés."),
("pick a storage to drag and drop to", "Pick a storage to drag and drop to", "Sélectionnez un entreposage vers lequel glisser déposer"),
("the storage you are already working on has been removed from the results",
 "The storage you are already working on has been removed from the results",
 "L'entreposage sur lequel vous travaillez a été retiré des résultats"),
("storages without layout have been removed from the results",
 "Storages without layout have been removed from the results",
 "Les entreposages sans disposition ont été retirés des résultats"),
("help_storage_layout_remove",
 "Items in this cell will be removed from the storage.",
 "Les items dans cette cellule seront retirés de l'entreposage."),
("help_storage_layout_unclassified",
 "Items in this cell are in the storage but do not have a position.",
 "Les items dans cette cellule font partie de l'entreposage mais n'ont pas de position d'assignée."),
("help_storage_layout_storage",
 "The cells above are a representation of the positions of the storage.",
 "Les cellules ci-dessous sont une représentation des positions de votre entrposage."),
("nothing", "Nothing", "Rien"),
("participant only", "Participant only", "Participant seulement"),
("participant and diagnosis", "Participant and diagnosis", "Participant et diagnostic"),
("participant and consent", "Participant and consent", "Participant et consentement"),
("participant, consent and diagnosis", "Participant, consent and diagnosis", "Participant, consentement et diagnostic"),
("copy linking (if it exists) to", "Copy linking (if it exists) to", "Copier les liens (s'ils existent) à"),
("delivery city", "Delivery city", "Ville de livraison"),
("delivery country", "Delivery country", "Pays de livraison"),
("delivery postal code", "Delivery postal code", "Code postal de livraison"),
("delivery province", "Delivery province", "Province de livraison"),
("delivery street address", "Delivery street address", "Adresse de livraison"),
("copy options", "Copy options", "Options de copie"),
("and %d more", "And %d more", "Et %d de plus"),
("surgery without extension", "Surgery without extension", "Chirurgie sans extension"),
("information about the diagnosis module is available %s here",
 "Information about the diagnosis module is available <a href='%s' target='blank'>here</a>.",
 "L'information à propos du module de diagnostic est disponible <a href='%s' target='blank'>ici</a>. (Anglais)"),
("trying to put storage [%s] within itself failed", 
 "Trying to put storage [%s] within itself failed",
 "La tentative de mettre l'entreposage [%s] à l'intérieur de lui-même a échouée."),
("storage parent defined to none", "Storage parent defined to none.", "Le parent de l'entreposage a été défini à aucun."),
("number of matching participants", "Number of matching participants", "Nombre de participants correspondants"),
("report_4_desc", 
 "The samples count within collections created within specified time frame and bank. The results are grouped by samples type. The count of matching participants is also displayed.",
 "Le compte des échantillons à l'intérieur des collections créées dans l'intervalle de temps et la banque spécifiés. Les résultats sont groupés par types d'échantillons. Le compte des participants correspondants est aussi affiché."),
("define realiquoted children", "Define realiquoted children", "Définir des enfants réaliquotés"),
("when defining a temperature, the temperature unit is required",
 "When defining a temperature, the temperature unit is required.",
 "Quand une température est définie, l'unité de température est requise."),
("conflict detected in storage [%s] at position [%s, %s]", 
 "Conflict detected in storage [%s] at position [%s, %s].",
 "Conflit détecté dans l'entreposate [%s] à la position [%s, %s]."),
("unclassifying additional items", "Unclassifying additional items.", "Déclassification des éléments supplémentaires."),
("validation error", "Validation error", "Erreur de validation"),
("storage_conflict_msg", "You cannot put more than one element in a cell space. See cells in red.", "Vous ne pouvez pas mettre plus d'un élément par cellule. Vérifier les cellules rouges."),
("to begin, click submit", "To begin, click submit.", "Pour commencer, cliquez sur envoyer."),
("csv encoding", "CSV encoding", "Encodage CSV"),
("help_csv_encoding",
 "Defines the character encoding for CSV files. Unless you're having characters problems, ISO-8859-1 is recommended. Otherwise switch to UTF-8. However note that Microsoft Excel hardly works with UTF-8.",
 "Défini l'encodage des caractères pour les fichiers CSV. À moins que vous n'ayez des problèmes, ISO-8859-1 est recommandé. Sinon, passez à UTF-8. Notez toutefois que Microsoft Excel fonctionne difficilement avec UTF-8."),
("UTF-8", "UTF-8", "UTF-8"),
("ISO-8859-1", "ISO-8859-1", "ISO-8859-1"),
("links were not copied since the destination is an independant collection",
 "Links were not copied since the destination is an independant collection.",
 "Les liens n'ont pas été copiés puisque la destination est une collection indépendante."),
("manage recipients", "Manage recipients", "Administrer les destinataires"),
('study start', 'Study Start', "Début de l'Étude"),
('study end', 'Study End', "Fin de l'Étude");

UPDATE i18n SET id='the aliquot with barcode [%s] has reached a volume bellow 0', en='The aliquot with barcode [%s] has reached a volume below 0.' WHERE id='the aliquot with barcode [%s] has reached a volume bellow 0';
UPDATE i18n SET id='cap report - perihilar bile duct' WHERE id='cap peport - perihilar bile duct';

-- drop clutter
ALTER TABLE structures
 DROP COLUMN language_help,
 DROP COLUMN language_title,
 DROP COLUMN created,
 DROP COLUMN created_by,
 DROP COLUMN modified,
 DROP COLUMN modified_by;
ALTER TABLE structure_formats
 DROP COLUMN created,
 DROP COLUMN created_by,
 DROP COLUMN modified,
 DROP COLUMN modified_by;
ALTER TABLE structure_fields
 MODIFY public_identifier varchar(50) NOT NULL DEFAULT '',
 DROP COLUMN created,
 DROP COLUMN created_by,
 DROP COLUMN modified,
 DROP COLUMN modified_by;
ALTER TABLE structure_validations
 DROP COLUMN created,
 DROP COLUMN created_by,
 DROP COLUMN modified,
 DROP COLUMN modified_by;
ALTER TABLE versions
 DROP COLUMN created,
 DROP COLUMN created_by,
 DROP COLUMN modified,
 DROP COLUMN modified_by;
 
-- fix non strict fields
UPDATE aliquot_internal_uses SET created='2001-01-01 00:00:00' WHERE created='0000-00-00 00:00:00';
UPDATE aliquot_masters SET created='2001-01-01 00:00:00' WHERE created='0000-00-00 00:00:00';
UPDATE aliquot_review_masters SET created='2001-01-01 00:00:00' WHERE created='0000-00-00 00:00:00';
UPDATE announcements SET created='2001-01-01 00:00:00' WHERE created='0000-00-00 00:00:00';
UPDATE ar_breast_tissue_slides SET created='2001-01-01 00:00:00' WHERE created='0000-00-00 00:00:00';
UPDATE atim_information SET created='2001-01-01 00:00:00' WHERE created='0000-00-00 00:00:00';
UPDATE banks SET created='2001-01-01 00:00:00' WHERE created='0000-00-00 00:00:00';
UPDATE clinical_collection_links SET created='2001-01-01 00:00:00' WHERE created='0000-00-00 00:00:00';
UPDATE coding_adverse_events SET created='2001-01-01 00:00:00' WHERE created='0000-00-00 00:00:00';
UPDATE collections SET created='2001-01-01 00:00:00' WHERE created='0000-00-00 00:00:00';
UPDATE datamart_adhoc SET created='2001-01-01 00:00:00' WHERE created='0000-00-00 00:00:00';
UPDATE datamart_batch_sets SET created='2001-01-01 00:00:00' WHERE created='0000-00-00 00:00:00';
UPDATE datamart_browsing_indexes SET created='2001-01-01 00:00:00' WHERE created='0000-00-00 00:00:00';
UPDATE datamart_browsing_results SET created='2001-01-01 00:00:00' WHERE created='0000-00-00 00:00:00';
UPDATE datamart_reports SET created='2001-01-01 00:00:00' WHERE created='0000-00-00 00:00:00';
UPDATE derivative_details SET created='2001-01-01 00:00:00' WHERE created='0000-00-00 00:00:00';
UPDATE drugs SET created='2001-01-01 00:00:00' WHERE created='0000-00-00 00:00:00';
UPDATE event_masters SET created='2001-01-01 00:00:00' WHERE created='0000-00-00 00:00:00';
UPDATE lab_book_masters SET created='2001-01-01 00:00:00' WHERE created='0000-00-00 00:00:00';
UPDATE materials SET created='2001-01-01 00:00:00' WHERE created='0000-00-00 00:00:00';
UPDATE menus SET created='2001-01-01 00:00:00' WHERE created='0000-00-00 00:00:00';
UPDATE menus SET modified='2001-01-01 00:00:00' WHERE modified='0000-00-00 00:00:00';
UPDATE pages SET created='2001-01-01 00:00:00' WHERE created='0000-00-00 00:00:00';
UPDATE pages SET modified='2001-01-01 00:00:00' WHERE modified='0000-00-00 00:00:00';
UPDATE participant_contacts SET created='2001-01-01 00:00:00' WHERE created='0000-00-00 00:00:00';
UPDATE participants SET created='2001-01-01 00:00:00' WHERE created='0000-00-00 00:00:00';
UPDATE quality_ctrls SET created='2001-01-01 00:00:00' WHERE created='0000-00-00 00:00:00';
UPDATE realiquotings SET created='2001-01-01 00:00:00' WHERE created='0000-00-00 00:00:00';
UPDATE reproductive_histories SET created='2001-01-01 00:00:00' WHERE created='0000-00-00 00:00:00';
UPDATE sample_masters SET created='2001-01-01 00:00:00' WHERE created='0000-00-00 00:00:00';
UPDATE shelves SET created='2001-01-01 00:00:00' WHERE created='0000-00-00 00:00:00';
UPDATE source_aliquots SET created='2001-01-01 00:00:00' WHERE created='0000-00-00 00:00:00';
UPDATE specimen_details SET created='2001-01-01 00:00:00' WHERE created='0000-00-00 00:00:00';
UPDATE specimen_review_masters SET created='2001-01-01 00:00:00' WHERE created='0000-00-00 00:00:00';
UPDATE spr_breast_cancer_types SET created='2001-01-01 00:00:00' WHERE created='0000-00-00 00:00:00';
UPDATE storage_coordinates SET created='2001-01-01 00:00:00' WHERE created='0000-00-00 00:00:00';
UPDATE storage_masters SET created='2001-01-01 00:00:00' WHERE created='0000-00-00 00:00:00';
UPDATE structure_permissible_values_customs SET created='2001-01-01 00:00:00' WHERE created='0000-00-00 00:00:00';
UPDATE tma_slides SET created='2001-01-01 00:00:00' WHERE created='0000-00-00 00:00:00';
UPDATE tx_masters SET created='2001-01-01 00:00:00' WHERE created='0000-00-00 00:00:00';
UPDATE txe_chemos SET created='2001-01-01 00:00:00' WHERE created='0000-00-00 00:00:00';
UPDATE txe_radiations SET created='2001-01-01 00:00:00' WHERE created='0000-00-00 00:00:00';
UPDATE txe_surgeries SET created='2001-01-01 00:00:00' WHERE created='0000-00-00 00:00:00';
UPDATE users SET created='2001-01-01 00:00:00' WHERE created='0000-00-00 00:00:00';



ALTER TABLE aliquot_internal_uses MODIFY COLUMN created DATETIME DEFAULT NULL;
ALTER TABLE aliquot_masters MODIFY COLUMN created DATETIME DEFAULT NULL;
ALTER TABLE aliquot_review_masters MODIFY COLUMN created DATETIME DEFAULT NULL;
ALTER TABLE announcements MODIFY COLUMN created DATETIME DEFAULT NULL, MODIFY COLUMN modified DATETIME DEFAULT NULL, MODIFY COLUMN `date` DATETIME DEFAULT NULL, MODIFY COLUMN `date_start` DATETIME DEFAULT NULL, MODIFY COLUMN `date_end` DATETIME DEFAULT NULL;
ALTER TABLE ar_breast_tissue_slides MODIFY COLUMN created DATETIME DEFAULT NULL;
ALTER TABLE atim_information MODIFY COLUMN created DATETIME DEFAULT NULL, MODIFY COLUMN modified DATETIME DEFAULT NULL;
ALTER TABLE banks MODIFY COLUMN created DATETIME DEFAULT NULL, MODIFY COLUMN modified DATETIME DEFAULT NULL;
ALTER TABLE clinical_collection_links MODIFY COLUMN created DATETIME DEFAULT NULL, MODIFY COLUMN modified DATETIME DEFAULT NULL;
ALTER TABLE coding_adverse_events MODIFY COLUMN created DATETIME DEFAULT NULL, MODIFY COLUMN modified DATETIME DEFAULT NULL;
ALTER TABLE collections MODIFY COLUMN created DATETIME DEFAULT NULL;
ALTER TABLE datamart_adhoc MODIFY COLUMN created DATETIME DEFAULT NULL, MODIFY COLUMN modified DATETIME DEFAULT NULL;
ALTER TABLE datamart_batch_sets MODIFY COLUMN created DATETIME DEFAULT NULL, MODIFY COLUMN modified DATETIME DEFAULT NULL;
ALTER TABLE datamart_browsing_indexes MODIFY COLUMN created DATETIME DEFAULT NULL;
ALTER TABLE datamart_browsing_results MODIFY COLUMN created DATETIME DEFAULT NULL;
ALTER TABLE datamart_reports MODIFY COLUMN created DATETIME DEFAULT NULL;
ALTER TABLE derivative_details MODIFY COLUMN created DATETIME DEFAULT NULL;
ALTER TABLE drugs MODIFY COLUMN created DATETIME DEFAULT NULL, MODIFY COLUMN modified DATETIME DEFAULT NULL;
ALTER TABLE event_masters MODIFY COLUMN created DATETIME DEFAULT NULL, MODIFY COLUMN modified DATETIME DEFAULT NULL;
ALTER TABLE lab_book_masters MODIFY COLUMN created DATETIME DEFAULT NULL;
ALTER TABLE materials MODIFY COLUMN created DATETIME DEFAULT NULL, MODIFY COLUMN modified DATETIME DEFAULT NULL;
ALTER TABLE menus MODIFY COLUMN created DATETIME DEFAULT NULL, MODIFY COLUMN modified DATETIME DEFAULT NULL;
ALTER TABLE pages MODIFY COLUMN created DATETIME DEFAULT NULL, MODIFY COLUMN modified DATETIME DEFAULT NULL;
ALTER TABLE participant_contacts MODIFY COLUMN created DATETIME DEFAULT NULL, MODIFY COLUMN modified DATETIME DEFAULT NULL;
ALTER TABLE participants MODIFY COLUMN created DATETIME DEFAULT NULL, MODIFY COLUMN modified DATETIME DEFAULT NULL;
ALTER TABLE quality_ctrls MODIFY COLUMN created DATETIME DEFAULT NULL;
ALTER TABLE realiquotings MODIFY COLUMN created DATETIME DEFAULT NULL;
ALTER TABLE reproductive_histories MODIFY COLUMN created DATETIME DEFAULT NULL;
ALTER TABLE sample_masters MODIFY COLUMN created DATETIME DEFAULT NULL;
ALTER TABLE shelves MODIFY COLUMN created DATETIME DEFAULT NULL;
ALTER TABLE source_aliquots MODIFY COLUMN created DATETIME DEFAULT NULL;
ALTER TABLE specimen_details MODIFY COLUMN created DATETIME DEFAULT NULL;
ALTER TABLE specimen_review_masters MODIFY COLUMN created DATETIME DEFAULT NULL;
ALTER TABLE spr_breast_cancer_types MODIFY COLUMN created DATETIME DEFAULT NULL;
ALTER TABLE storage_coordinates MODIFY COLUMN created DATETIME DEFAULT NULL;
ALTER TABLE storage_masters MODIFY COLUMN created DATETIME DEFAULT NULL;
ALTER TABLE structure_permissible_values_customs MODIFY COLUMN created DATETIME DEFAULT NULL;
ALTER TABLE tma_slides MODIFY COLUMN created DATETIME DEFAULT NULL;
ALTER TABLE tx_masters MODIFY COLUMN created DATETIME DEFAULT NULL, MODIFY COLUMN modified DATETIME DEFAULT NULL;
ALTER TABLE txe_chemos MODIFY COLUMN created DATETIME DEFAULT NULL, MODIFY COLUMN modified DATETIME DEFAULT NULL;
ALTER TABLE txe_radiations MODIFY COLUMN created DATETIME DEFAULT NULL, MODIFY COLUMN modified DATETIME DEFAULT NULL;
ALTER TABLE txe_surgeries MODIFY COLUMN created DATETIME DEFAULT NULL, MODIFY COLUMN modified DATETIME DEFAULT NULL;
ALTER TABLE users MODIFY COLUMN created DATETIME DEFAULT NULL, MODIFY COLUMN modified DATETIME DEFAULT NULL;

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

ALTER TABLE menus
 DROP COLUMN use_params,
 MODIFY use_summary VARCHAR(255) NOT NULL DEFAULT '',
 MODIFY created_by INT UNSIGNED NOT NULL DEFAULT 1,
 MODIFY modified_by INT UNSIGNED NOT NULL DEFAULT 1;

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
 description TEXT DEFAULT NULL,
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
 description TEXT DEFAULT NULL,
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

al.created

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
sampc.sample_category

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

INSERT INTO menus (id, parent_id, is_root, display_order, language_title, language_description, use_link, use_summary, flag_active, created, created_by, modified, modified_by) VALUES
('core_CAN_41_5', 'core_CAN_41', 0, 4, 'search for users', '', '/administrate/users/search/', '', 1, NOW(), 1, NOW(), 1); 

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

SELECT '****************' as msg_1
UNION
SELECT 'Looking for bogus primary dx' AS msg_1;

CREATE TABLE tmp_bogus_primary_dx (SELECT participant_id, primary_number, 'more than one primary' AS issue, COUNT(*) AS c FROM diagnosis_masters WHERE dx_origin='primary' GROUP BY participant_id, primary_number HAVING c > 1);
INSERT INTO tmp_bogus_primary_dx (participant_id, primary_number, issue) (SELECT dm1.participant_id, dm1.primary_number, 'no primary' AS issue FROM diagnosis_masters AS dm1 
LEFT OUTER JOIN diagnosis_masters AS dm2 ON dm1.primary_number=dm2.primary_number AND dm1.participant_id=dm2.participant_id AND dm2.dx_origin='primary'
WHERE dm1.primary_number IS NOT NULL AND dm2.id IS NULL
GROUP BY dm1.primary_number);
ALTER TABLE tmp_bogus_primary_dx 
 ADD INDEX (`participant_id`),
 ADD INDEX (`primary_number`);
 
SELECT IF(COUNT(*) > 0, 'See table tmp_bogus_primary_dx to manually fix the bogus primary dx and their children', 'All dx are ok. You can drop table tmp_bogus_primary_dx') AS msg_1 FROM tmp_bogus_primary_dx
UNION
SELECT 'Check the release notes to know how to fit your existing diagnosis to version 2.4.x' AS msg_1
UNION ALL
SELECT '****************' as msg_1; 

CREATE TABLE dxd_primaries(
 id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
 diagnosis_master_id INT NOT NULL,
 `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
 FOREIGN KEY (diagnosis_master_id) REFERENCES diagnosis_masters(id)
)Engine=InnoDb;
CREATE TABLE dxd_primaries_revs(
 id INT UNSIGNED NOT NULL,
 diagnosis_master_id INT NOT NULL,
 `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
 `version_id` int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `version_created` datetime NOT NULL
)Engine=InnoDb;
CREATE TABLE dxd_unknown(
 id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
 diagnosis_master_id INT NOT NULL,
 `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
 FOREIGN KEY (diagnosis_master_id) REFERENCES diagnosis_masters(id)
)Engine=InnoDb;
CREATE TABLE dxd_unknown_revs(
 id INT UNSIGNED NOT NULL,
 diagnosis_master_id INT NOT NULL,
 `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
 `version_id` int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `version_created` datetime NOT NULL
)Engine=InnoDb;
CREATE TABLE dxd_secondaries(
 id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
 diagnosis_master_id INT NOT NULL,
 `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
 FOREIGN KEY (diagnosis_master_id) REFERENCES diagnosis_masters(id)
)Engine=InnoDb;
CREATE TABLE dxd_secondaries_revs(
 id INT UNSIGNED NOT NULL,
 diagnosis_master_id INT NOT NULL,
 `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
 `version_id` int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `version_created` datetime NOT NULL
)Engine=InnoDb;
CREATE TABLE dxd_progressions(
 id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
 diagnosis_master_id INT NOT NULL,
 `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
 FOREIGN KEY (diagnosis_master_id) REFERENCES diagnosis_masters(id)
)Engine=InnoDb;
CREATE TABLE dxd_progressions_revs(
 id INT UNSIGNED NOT NULL,
 diagnosis_master_id INT NOT NULL,
 `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
 `version_id` int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `version_created` datetime NOT NULL
)Engine=InnoDb;
CREATE TABLE dxd_recurrences(
 id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
 diagnosis_master_id INT NOT NULL,
 `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
 FOREIGN KEY (diagnosis_master_id) REFERENCES diagnosis_masters(id)
)Engine=InnoDb;
CREATE TABLE dxd_recurrences_revs(
 id INT UNSIGNED NOT NULL,
 diagnosis_master_id INT NOT NULL,
 `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
 `version_id` int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `version_created` datetime NOT NULL
)Engine=InnoDb;
CREATE TABLE dxd_remissions(
 id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
 diagnosis_master_id INT NOT NULL,
 `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
 FOREIGN KEY (diagnosis_master_id) REFERENCES diagnosis_masters(id)
)Engine=InnoDb;
CREATE TABLE dxd_remissions_revs(
 id INT UNSIGNED NOT NULL,
 diagnosis_master_id INT NOT NULL,
 `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
 `version_id` int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `version_created` datetime NOT NULL
)Engine=InnoDb;

INSERT INTO structures(alias) VALUES
('dx_master'),
('dx_primary'),
('dx_unknown'),
('dx_secondary'),
('dx_remission'),
('dx_progression');

UPDATE diagnosis_controls SET flag_active = 0 WHERE controls_type LIKE 'cap report - %'; /* disable old dx_controls */

INSERT INTO diagnosis_controls(controls_type, flag_primary, flag_secondary, flag_active, form_alias, detail_tablename, display_order, databrowser_label) VALUES
('primary', 1, 0, 1, 'dx_master,dx_primary', 'dxd_primaries', 0, 'primary'),
('unknown', 1, 0, 1, 'dx_master,dx_unknown', 'dxd_unknown', 0, 'unknown'),
('secondary', 0, 1, 1, 'dx_master,dx_secondary', 'dxd_secondaries', 0, 'secondary'),
('remission', 0, 1, 1, 'dx_master,dx_remission', 'dxd_remissions', 0, 'remission'),
('progression', 0, 1, 1, 'dx_master,dx_progression', 'dxd_progressions', 0, 'progression'),
('recurrence', 0, 1, 1, 'dx_master,dx_recurrence', 'dxd_recurrences', 0, 'recurrence');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='dx_master'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '1', '', '1', 'date', '0', '', '1', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='dx_master'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='age_at_dx' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '2', '', '1', 'age at dx', '0', '', '1', '', '0', '', '1', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='dx_master'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='age_at_dx_precision' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='age_accuracy')  AND `flag_confidential`='0'), '1', '3', '', '0', '', '1', 'precision', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');

UPDATE diagnosis_masters AS dm
LEFT JOIN diagnosis_masters AS dm_parent ON dm.participant_id=dm_parent.participant_id AND (dm.dx_origin!='primary' OR dm.dx_origin IS NULL) AND dm_parent.dx_origin='primary' AND dm.primary_number=dm_parent.primary_number AND dm_parent.primary_number IS NOT NULL 
LEFT JOIN tmp_bogus_primary_dx AS bogus_dx ON dm.participant_id=bogus_dx.participant_id AND dm.primary_number=bogus_dx.primary_number
SET dm.parent_id=dm_parent.id
WHERE dm_parent.id IS NOT NULL AND bogus_dx.participant_id IS NULL;

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

SELECT '****************' as msg_2
UNION
SELECT IF(COUNT(*) > 0, 
 'Not all batch set have a datamart_structure_id or a datamart_adhoc_id. Update your batchsets to give them either a datamart_structure_id or a datamart_adhoc_id before running the following update query.', 
 'All batchsets have either a datamart_structure_id or a datamart_adhoc_id. You can run the following query.') AS msg_2 FROM datamart_batch_sets WHERE datamart_structure_id IS NULL AND datamart_adhoc_id IS NULL
UNION
SELECT "ALTER TABLE datamart_batch_sets
 DROP COLUMN form_alias_for_results,
 DROP COLUMN sql_query_for_results,
 DROP COLUMN form_links_for_results,
 DROP COLUMN flag_use_query_results,
 DROP COLUMN plugin,
 DROP COLUMN model;" AS msg_2
 UNION ALL
 SELECT '****************' as msg_2;
 
UPDATE structure_fields SET  `language_label`='primary phone number',  `language_tag`='' WHERE model='ParticipantContact' AND tablename='participant_contacts' AND field='phone' AND `type`='input' AND structure_value_domain  IS NULL ;
UPDATE structure_fields SET  `language_label`='secondary phone number',  `language_tag`='' WHERE model='ParticipantContact' AND tablename='participant_contacts' AND field='phone_secondary' AND `type`='input' AND structure_value_domain  IS NULL ;
UPDATE structure_fields SET  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='phone_type') ,  `language_help`='',  `language_label`='',  `language_tag`='type' WHERE model='ParticipantContact' AND tablename='participant_contacts' AND field='phone_secondary_type' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='phone_type');
UPDATE structure_fields SET  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='phone_type') ,  `language_help`='',  `language_label`='',  `language_tag`='type' WHERE model='ParticipantContact' AND tablename='participant_contacts' AND field='phone_type' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='phone_type');
UPDATE structure_formats SET `display_order`='20' WHERE structure_id=(SELECT id FROM structures WHERE alias='participantcontacts') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ParticipantContact' AND `tablename`='participant_contacts' AND `field`='phone' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='22' WHERE structure_id=(SELECT id FROM structures WHERE alias='participantcontacts') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ParticipantContact' AND `tablename`='participant_contacts' AND `field`='phone_secondary' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='23' WHERE structure_id=(SELECT id FROM structures WHERE alias='participantcontacts') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ParticipantContact' AND `tablename`='participant_contacts' AND `field`='phone_secondary_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='phone_type') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='21' WHERE structure_id=(SELECT id FROM structures WHERE alias='participantcontacts') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ParticipantContact' AND `tablename`='participant_contacts' AND `field`='phone_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='phone_type') AND `flag_confidential`='0');

CREATE TABLE templates(
 id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
 flag_system BOOLEAN DEFAULT false COMMENT 'if true, cannot be edited in ATiM',
 name VARCHAR(50) NOT NULL DEFAULT '',
 UNIQUE(name)
)Engine=InnoDb;

CREATE TABLE template_nodes(
 id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
 parent_id INT UNSIGNED DEFAULT NULL,
 template_id INT UNSIGNED NOT NULL,
 datamart_structure_id INT UNSIGNED NOT NULL,
 control_id TINYINT UNSIGNED DEFAULT 0,
 FOREIGN KEY (`parent_id`) REFERENCES template_nodes(`id`),
 FOREIGN KEY (`template_id`) REFERENCES templates(id),
 FOREIGN KEY (datamart_structure_id) REFERENCES datamart_structures(id)
)Engine=InnoDb;

ALTER TABLE structure_validations
 MODIFY on_action VARCHAR(255) NOT NULL DEFAULT '';

INSERT INTO structures(`alias`) VALUES ('template');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Tool', 'Template', 'templates', 'name', 'input',  NULL , '0', '', '', '', 'name', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='template'), (SELECT id FROM structure_fields WHERE `model`='Template' AND `tablename`='templates' AND `field`='name' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='name' AND `language_tag`=''), '1', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');
INSERT INTO structure_validations (structure_field_id, rule, language_message) VALUES
((SELECT id FROM structure_fields WHERE `model`='Template' AND `tablename`='templates' AND `field`='name' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='name' AND `language_tag`=''), 'isUnique', ''), 
((SELECT id FROM structure_fields WHERE `model`='Template' AND `tablename`='templates' AND `field`='name' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='name' AND `language_tag`=''), 'notEmpty', ''); 

INSERT INTO menus (id, parent_id, is_root, display_order, language_title, language_description, use_link) VALUES
('collection_template', 'core_CAN_33', 1, 10, 'collection template', 'collection_template_description', '/tools/Template/index');

CREATE TABLE datamart_adhoc_permissions(
 id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
 group_id INT NOT NULL,
 datamart_adhoc_id INT NOT NULL,
 FOREIGN KEY (group_id) REFERENCES groups(id),
 FOREIGN KEY (datamart_adhoc_id) REFERENCES datamart_adhoc(id)
)Engine=InnoDb;

INSERT INTO datamart_adhoc_permissions (group_id, datamart_adhoc_id) 
(SELECT groups.id, datamart_adhoc.id FROM groups INNER JOIN datamart_adhoc);

-- cap reports refactoring
UPDATE diagnosis_controls SET controls_type=REPLACE(controls_type, 'cap peport - ', 'cap report - '), databrowser_label=REPLACE(databrowser_label, 'cap peport - ', 'cap report - ');

ALTER TABLE dxd_cap_report_smintestines
 ADD COLUMN additional_dimension_a decimal(3,1) DEFAULT NULL,
 ADD COLUMN additional_dimension_b decimal(3,1) DEFAULT NULL,
 ADD COLUMN notes TEXT,
 ADD COLUMN path_mstage varchar(15) NOT NULL DEFAULT '',
 ADD COLUMN path_mstage_metastasis_site_specify varchar(250),
 ADD COLUMN path_nstage varchar(5) NOT NULL DEFAULT '',
 ADD COLUMN path_nstage_nbr_node_examined SMALLINT(1) DEFAULT NULL,
 ADD COLUMN path_nstage_nbr_node_involved SMALLINT(1) DEFAULT NULL,
 ADD COLUMN path_tnm_descriptor_m char(1) NOT NULL DEFAULT '',
 ADD COLUMN path_tnm_descriptor_r char(1) NOT NULL DEFAULT '',
 ADD COLUMN path_tnm_descriptor_y char(1) NOT NULL DEFAULT '',
 ADD COLUMN path_tstage varchar(5) NOT NULL DEFAULT '',
 ADD COLUMN tumor_size_cannot_be_determined tinyint(1) DEFAULT 0,
 ADD COLUMN tumor_size_greatest_dimension decimal(3, 1) DEFAULT NULL,
 ADD COLUMN tumour_grade varchar(150) NOT NULL DEFAULT '',
 ADD COLUMN tumour_grade_specify varchar(250) NOT NULL DEFAULT '';

ALTER TABLE dxd_cap_report_perihilarbileducts
 ADD COLUMN additional_dimension_a decimal(3,1) DEFAULT NULL,
 ADD COLUMN additional_dimension_b decimal(3,1) DEFAULT NULL,
 ADD COLUMN notes TEXT,
 ADD COLUMN path_mstage varchar(15) NOT NULL DEFAULT '',
 ADD COLUMN path_mstage_metastasis_site_specify varchar(250),
 ADD COLUMN path_nstage varchar(5) NOT NULL DEFAULT '',
 ADD COLUMN path_nstage_nbr_node_examined SMALLINT(1) DEFAULT NULL,
 ADD COLUMN path_nstage_nbr_node_involved SMALLINT(1) DEFAULT NULL,
 ADD COLUMN path_tnm_descriptor_m char(1) NOT NULL DEFAULT '',
 ADD COLUMN path_tnm_descriptor_r char(1) NOT NULL DEFAULT '',
 ADD COLUMN path_tnm_descriptor_y char(1) NOT NULL DEFAULT '',
 ADD COLUMN path_tstage varchar(5) NOT NULL DEFAULT '',
 ADD COLUMN tumor_size_cannot_be_determined tinyint(1) DEFAULT 0,
 ADD COLUMN tumor_size_greatest_dimension decimal(3, 1) DEFAULT NULL,
 ADD COLUMN tumour_grade varchar(150) NOT NULL DEFAULT '',
 ADD COLUMN tumour_grade_specify varchar(250) NOT NULL DEFAULT '';

ALTER TABLE dxd_cap_report_pancreasexos
 ADD COLUMN additional_dimension_a decimal(3,1) DEFAULT NULL,
 ADD COLUMN additional_dimension_b decimal(3,1) DEFAULT NULL,
 ADD COLUMN notes TEXT,
 ADD COLUMN path_mstage varchar(15) NOT NULL DEFAULT '',
 ADD COLUMN path_mstage_metastasis_site_specify varchar(250),
 ADD COLUMN path_nstage varchar(5) NOT NULL DEFAULT '',
 ADD COLUMN path_nstage_nbr_node_examined SMALLINT(1) DEFAULT NULL,
 ADD COLUMN path_nstage_nbr_node_involved SMALLINT(1) DEFAULT NULL,
 ADD COLUMN path_tnm_descriptor_m char(1) NOT NULL DEFAULT '',
 ADD COLUMN path_tnm_descriptor_r char(1) NOT NULL DEFAULT '',
 ADD COLUMN path_tnm_descriptor_y char(1) NOT NULL DEFAULT '',
 ADD COLUMN path_tstage varchar(5) NOT NULL DEFAULT '',
 ADD COLUMN tumor_size_cannot_be_determined tinyint(1) DEFAULT 0,
 ADD COLUMN tumor_size_greatest_dimension decimal(3, 1) DEFAULT NULL,
 ADD COLUMN tumour_grade varchar(150) NOT NULL DEFAULT '',
 ADD COLUMN tumour_grade_specify varchar(250) NOT NULL DEFAULT '';

ALTER TABLE dxd_cap_report_intrahepbileducts
 ADD COLUMN additional_dimension_a decimal(3,1) DEFAULT NULL,
 ADD COLUMN additional_dimension_b decimal(3,1) DEFAULT NULL,
 ADD COLUMN notes TEXT,
 ADD COLUMN path_mstage varchar(15) NOT NULL DEFAULT '',
 ADD COLUMN path_mstage_metastasis_site_specify varchar(250),
 ADD COLUMN path_nstage varchar(5) NOT NULL DEFAULT '',
 ADD COLUMN path_nstage_nbr_node_examined SMALLINT(1) DEFAULT NULL,
 ADD COLUMN path_nstage_nbr_node_involved SMALLINT(1) DEFAULT NULL,
 ADD COLUMN path_tnm_descriptor_m char(1) NOT NULL DEFAULT '',
 ADD COLUMN path_tnm_descriptor_r char(1) NOT NULL DEFAULT '',
 ADD COLUMN path_tnm_descriptor_y char(1) NOT NULL DEFAULT '',
 ADD COLUMN path_tstage varchar(5) NOT NULL DEFAULT '',
 ADD COLUMN tumor_size_cannot_be_determined tinyint(1) DEFAULT 0,
 ADD COLUMN tumor_size_greatest_dimension decimal(3, 1) DEFAULT NULL,
 ADD COLUMN tumour_grade varchar(150) NOT NULL DEFAULT '',
 ADD COLUMN tumour_grade_specify varchar(250) NOT NULL DEFAULT '';

ALTER TABLE dxd_cap_report_hepatocellular_carcinomas
 ADD COLUMN additional_dimension_a decimal(3,1) DEFAULT NULL,
 ADD COLUMN additional_dimension_b decimal(3,1) DEFAULT NULL,
 ADD COLUMN notes TEXT,
 ADD COLUMN path_mstage varchar(15) NOT NULL DEFAULT '',
 ADD COLUMN path_mstage_metastasis_site_specify varchar(250),
 ADD COLUMN path_nstage varchar(5) NOT NULL DEFAULT '',
 ADD COLUMN path_nstage_nbr_node_examined SMALLINT(1) DEFAULT NULL,
 ADD COLUMN path_nstage_nbr_node_involved SMALLINT(1) DEFAULT NULL,
 ADD COLUMN path_tnm_descriptor_m char(1) NOT NULL DEFAULT '',
 ADD COLUMN path_tnm_descriptor_r char(1) NOT NULL DEFAULT '',
 ADD COLUMN path_tnm_descriptor_y char(1) NOT NULL DEFAULT '',
 ADD COLUMN path_tstage varchar(5) NOT NULL DEFAULT '',
 ADD COLUMN tumor_size_cannot_be_determined tinyint(1) DEFAULT 0,
 ADD COLUMN tumor_size_greatest_dimension decimal(3, 1) DEFAULT NULL,
 ADD COLUMN tumour_grade varchar(150) NOT NULL DEFAULT '',
 ADD COLUMN tumour_grade_specify varchar(250) NOT NULL DEFAULT '';

ALTER TABLE dxd_cap_report_gallbladders
 ADD COLUMN additional_dimension_a decimal(3,1) DEFAULT NULL,
 ADD COLUMN additional_dimension_b decimal(3,1) DEFAULT NULL,
 ADD COLUMN notes TEXT,
 ADD COLUMN path_mstage varchar(15) NOT NULL DEFAULT '',
 ADD COLUMN path_mstage_metastasis_site_specify varchar(250),
 ADD COLUMN path_nstage varchar(5) NOT NULL DEFAULT '',
 ADD COLUMN path_nstage_nbr_node_examined SMALLINT(1) DEFAULT NULL,
 ADD COLUMN path_nstage_nbr_node_involved SMALLINT(1) DEFAULT NULL,
 ADD COLUMN path_tnm_descriptor_m char(1) NOT NULL DEFAULT '',
 ADD COLUMN path_tnm_descriptor_r char(1) NOT NULL DEFAULT '',
 ADD COLUMN path_tnm_descriptor_y char(1) NOT NULL DEFAULT '',
 ADD COLUMN path_tstage varchar(5) NOT NULL DEFAULT '',
 ADD COLUMN tumor_size_cannot_be_determined tinyint(1) DEFAULT 0,
 ADD COLUMN tumor_size_greatest_dimension decimal(3, 1) DEFAULT NULL,
 ADD COLUMN tumour_grade varchar(150) NOT NULL DEFAULT '',
 ADD COLUMN tumour_grade_specify varchar(250) NOT NULL DEFAULT '';

ALTER TABLE dxd_cap_report_distalexbileducts
 ADD COLUMN additional_dimension_a decimal(3,1) DEFAULT NULL,
 ADD COLUMN additional_dimension_b decimal(3,1) DEFAULT NULL,
 ADD COLUMN notes TEXT,
 ADD COLUMN path_mstage varchar(15) NOT NULL DEFAULT '',
 ADD COLUMN path_mstage_metastasis_site_specify varchar(250),
 ADD COLUMN path_nstage varchar(5) NOT NULL DEFAULT '',
 ADD COLUMN path_nstage_nbr_node_examined SMALLINT(1) DEFAULT NULL,
 ADD COLUMN path_nstage_nbr_node_involved SMALLINT(1) DEFAULT NULL,
 ADD COLUMN path_tnm_descriptor_m char(1) NOT NULL DEFAULT '',
 ADD COLUMN path_tnm_descriptor_r char(1) NOT NULL DEFAULT '',
 ADD COLUMN path_tnm_descriptor_y char(1) NOT NULL DEFAULT '',
 ADD COLUMN path_tstage varchar(5) NOT NULL DEFAULT '',
 ADD COLUMN tumor_size_cannot_be_determined tinyint(1) DEFAULT 0,
 ADD COLUMN tumor_size_greatest_dimension decimal(3, 1) DEFAULT NULL,
 ADD COLUMN tumour_grade varchar(150) NOT NULL DEFAULT '',
 ADD COLUMN tumour_grade_specify varchar(250) NOT NULL DEFAULT '';

ALTER TABLE dxd_cap_report_colon_biopsies
 ADD COLUMN additional_dimension_a decimal(3,1) DEFAULT NULL,
 ADD COLUMN additional_dimension_b decimal(3,1) DEFAULT NULL,
 ADD COLUMN notes TEXT,
 ADD COLUMN path_mstage varchar(15) NOT NULL DEFAULT '',
 ADD COLUMN path_mstage_metastasis_site_specify varchar(250),
 ADD COLUMN path_nstage varchar(5) NOT NULL DEFAULT '',
 ADD COLUMN path_nstage_nbr_node_examined SMALLINT(1) DEFAULT NULL,
 ADD COLUMN path_nstage_nbr_node_involved SMALLINT(1) DEFAULT NULL,
 ADD COLUMN path_tnm_descriptor_m char(1) NOT NULL DEFAULT '',
 ADD COLUMN path_tnm_descriptor_r char(1) NOT NULL DEFAULT '',
 ADD COLUMN path_tnm_descriptor_y char(1) NOT NULL DEFAULT '',
 ADD COLUMN path_tstage varchar(5) NOT NULL DEFAULT '',
 ADD COLUMN tumor_size_cannot_be_determined tinyint(1) DEFAULT 0,
 ADD COLUMN tumor_size_greatest_dimension decimal(3, 1) DEFAULT NULL,
 ADD COLUMN tumour_grade varchar(150) NOT NULL DEFAULT '',
 ADD COLUMN tumour_grade_specify varchar(250) NOT NULL DEFAULT '';

ALTER TABLE dxd_cap_report_ampullas
 ADD COLUMN additional_dimension_a decimal(3,1) DEFAULT NULL,
 ADD COLUMN additional_dimension_b decimal(3,1) DEFAULT NULL,
 ADD COLUMN notes TEXT,
 ADD COLUMN path_mstage varchar(15) NOT NULL DEFAULT '',
 ADD COLUMN path_mstage_metastasis_site_specify varchar(250),
 ADD COLUMN path_nstage varchar(5) NOT NULL DEFAULT '',
 ADD COLUMN path_nstage_nbr_node_examined SMALLINT(1) DEFAULT NULL,
 ADD COLUMN path_nstage_nbr_node_involved SMALLINT(1) DEFAULT NULL,
 ADD COLUMN path_tnm_descriptor_m char(1) NOT NULL DEFAULT '',
 ADD COLUMN path_tnm_descriptor_r char(1) NOT NULL DEFAULT '',
 ADD COLUMN path_tnm_descriptor_y char(1) NOT NULL DEFAULT '',
 ADD COLUMN path_tstage varchar(5) NOT NULL DEFAULT '',
 ADD COLUMN tumor_size_cannot_be_determined tinyint(1) DEFAULT 0,
 ADD COLUMN tumor_size_greatest_dimension decimal(3, 1) DEFAULT NULL,
 ADD COLUMN tumour_grade varchar(150) NOT NULL DEFAULT '',
 ADD COLUMN tumour_grade_specify varchar(250) NOT NULL DEFAULT '';

ALTER TABLE dxd_cap_report_colon_rectum_resections
 ADD COLUMN additional_dimension_a decimal(3,1) DEFAULT NULL,
 ADD COLUMN additional_dimension_b decimal(3,1) DEFAULT NULL,
 ADD COLUMN notes TEXT,
 ADD COLUMN path_mstage varchar(15) NOT NULL DEFAULT '',
 ADD COLUMN path_mstage_metastasis_site_specify varchar(250),
 ADD COLUMN path_nstage varchar(5) NOT NULL DEFAULT '',
 ADD COLUMN path_nstage_nbr_node_examined SMALLINT(1) DEFAULT NULL,
 ADD COLUMN path_nstage_nbr_node_involved SMALLINT(1) DEFAULT NULL,
 ADD COLUMN path_tnm_descriptor_m char(1) NOT NULL DEFAULT '',
 ADD COLUMN path_tnm_descriptor_r char(1) NOT NULL DEFAULT '',
 ADD COLUMN path_tnm_descriptor_y char(1) NOT NULL DEFAULT '',
 ADD COLUMN path_tstage varchar(5) NOT NULL DEFAULT '',
 ADD COLUMN tumor_size_cannot_be_determined tinyint(1) DEFAULT 0,
 ADD COLUMN tumor_size_greatest_dimension decimal(3, 1) DEFAULT NULL,
 ADD COLUMN tumour_grade varchar(150) NOT NULL DEFAULT '',
 ADD COLUMN tumour_grade_specify varchar(250) NOT NULL DEFAULT '';

ALTER TABLE dxd_cap_report_pancreasendos
 ADD COLUMN additional_dimension_a decimal(3,1) DEFAULT NULL,
 ADD COLUMN additional_dimension_b decimal(3,1) DEFAULT NULL,
 ADD COLUMN notes TEXT,
 ADD COLUMN path_mstage varchar(15) NOT NULL DEFAULT '',
 ADD COLUMN path_mstage_metastasis_site_specify varchar(250),
 ADD COLUMN path_nstage varchar(5) NOT NULL DEFAULT '',
 ADD COLUMN path_nstage_nbr_node_examined SMALLINT(1) DEFAULT NULL,
 ADD COLUMN path_nstage_nbr_node_involved SMALLINT(1) DEFAULT NULL,
 ADD COLUMN path_tnm_descriptor_m char(1) NOT NULL DEFAULT '',
 ADD COLUMN path_tnm_descriptor_r char(1) NOT NULL DEFAULT '',
 ADD COLUMN path_tnm_descriptor_y char(1) NOT NULL DEFAULT '',
 ADD COLUMN path_tstage varchar(5) NOT NULL DEFAULT '',
 ADD COLUMN tumor_size_cannot_be_determined tinyint(1) DEFAULT 0,
 ADD COLUMN tumor_size_greatest_dimension decimal(3, 1) DEFAULT NULL,
 ADD COLUMN tumour_grade varchar(150) NOT NULL DEFAULT '',
 ADD COLUMN tumour_grade_specify varchar(250) NOT NULL DEFAULT '';
 
ALTER TABLE dxd_cap_report_smintestines_revs
 ADD COLUMN additional_dimension_a decimal(3,1) DEFAULT NULL,
 ADD COLUMN additional_dimension_b decimal(3,1) DEFAULT NULL,
 ADD COLUMN notes TEXT,
 ADD COLUMN path_mstage varchar(15) NOT NULL DEFAULT '',
 ADD COLUMN path_mstage_metastasis_site_specify varchar(250),
 ADD COLUMN path_nstage varchar(5) NOT NULL DEFAULT '',
 ADD COLUMN path_nstage_nbr_node_examined SMALLINT(1) DEFAULT NULL,
 ADD COLUMN path_nstage_nbr_node_involved SMALLINT(1) DEFAULT NULL,
 ADD COLUMN path_tnm_descriptor_m char(1) NOT NULL DEFAULT '',
 ADD COLUMN path_tnm_descriptor_r char(1) NOT NULL DEFAULT '',
 ADD COLUMN path_tnm_descriptor_y char(1) NOT NULL DEFAULT '',
 ADD COLUMN path_tstage varchar(5) NOT NULL DEFAULT '',
 ADD COLUMN tumor_size_cannot_be_determined tinyint(1) DEFAULT 0,
 ADD COLUMN tumor_size_greatest_dimension decimal(3, 1) DEFAULT NULL,
 ADD COLUMN tumour_grade varchar(150) NOT NULL DEFAULT '',
 ADD COLUMN tumour_grade_specify varchar(250) NOT NULL DEFAULT '';

ALTER TABLE dxd_cap_report_perihilarbileducts_revs
 ADD COLUMN additional_dimension_a decimal(3,1) DEFAULT NULL,
 ADD COLUMN additional_dimension_b decimal(3,1) DEFAULT NULL,
 ADD COLUMN notes TEXT,
 ADD COLUMN path_mstage varchar(15) NOT NULL DEFAULT '',
 ADD COLUMN path_mstage_metastasis_site_specify varchar(250),
 ADD COLUMN path_nstage varchar(5) NOT NULL DEFAULT '',
 ADD COLUMN path_nstage_nbr_node_examined SMALLINT(1) DEFAULT NULL,
 ADD COLUMN path_nstage_nbr_node_involved SMALLINT(1) DEFAULT NULL,
 ADD COLUMN path_tnm_descriptor_m char(1) NOT NULL DEFAULT '',
 ADD COLUMN path_tnm_descriptor_r char(1) NOT NULL DEFAULT '',
 ADD COLUMN path_tnm_descriptor_y char(1) NOT NULL DEFAULT '',
 ADD COLUMN path_tstage varchar(5) NOT NULL DEFAULT '',
 ADD COLUMN tumor_size_cannot_be_determined tinyint(1) DEFAULT 0,
 ADD COLUMN tumor_size_greatest_dimension decimal(3, 1) DEFAULT NULL,
 ADD COLUMN tumour_grade varchar(150) NOT NULL DEFAULT '',
 ADD COLUMN tumour_grade_specify varchar(250) NOT NULL DEFAULT '';

ALTER TABLE dxd_cap_report_pancreasexos_revs
 ADD COLUMN additional_dimension_a decimal(3,1) DEFAULT NULL,
 ADD COLUMN additional_dimension_b decimal(3,1) DEFAULT NULL,
 ADD COLUMN notes TEXT,
 ADD COLUMN path_mstage varchar(15) NOT NULL DEFAULT '',
 ADD COLUMN path_mstage_metastasis_site_specify varchar(250),
 ADD COLUMN path_nstage varchar(5) NOT NULL DEFAULT '',
 ADD COLUMN path_nstage_nbr_node_examined SMALLINT(1) DEFAULT NULL,
 ADD COLUMN path_nstage_nbr_node_involved SMALLINT(1) DEFAULT NULL,
 ADD COLUMN path_tnm_descriptor_m char(1) NOT NULL DEFAULT '',
 ADD COLUMN path_tnm_descriptor_r char(1) NOT NULL DEFAULT '',
 ADD COLUMN path_tnm_descriptor_y char(1) NOT NULL DEFAULT '',
 ADD COLUMN path_tstage varchar(5) NOT NULL DEFAULT '',
 ADD COLUMN tumor_size_cannot_be_determined tinyint(1) DEFAULT 0,
 ADD COLUMN tumor_size_greatest_dimension decimal(3, 1) DEFAULT NULL,
 ADD COLUMN tumour_grade varchar(150) NOT NULL DEFAULT '',
 ADD COLUMN tumour_grade_specify varchar(250) NOT NULL DEFAULT '';

ALTER TABLE dxd_cap_report_intrahepbileducts_revs
 ADD COLUMN additional_dimension_a decimal(3,1) DEFAULT NULL,
 ADD COLUMN additional_dimension_b decimal(3,1) DEFAULT NULL,
 ADD COLUMN notes TEXT,
 ADD COLUMN path_mstage varchar(15) NOT NULL DEFAULT '',
 ADD COLUMN path_mstage_metastasis_site_specify varchar(250),
 ADD COLUMN path_nstage varchar(5) NOT NULL DEFAULT '',
 ADD COLUMN path_nstage_nbr_node_examined SMALLINT(1) DEFAULT NULL,
 ADD COLUMN path_nstage_nbr_node_involved SMALLINT(1) DEFAULT NULL,
 ADD COLUMN path_tnm_descriptor_m char(1) NOT NULL DEFAULT '',
 ADD COLUMN path_tnm_descriptor_r char(1) NOT NULL DEFAULT '',
 ADD COLUMN path_tnm_descriptor_y char(1) NOT NULL DEFAULT '',
 ADD COLUMN path_tstage varchar(5) NOT NULL DEFAULT '',
 ADD COLUMN tumor_size_cannot_be_determined tinyint(1) DEFAULT 0,
 ADD COLUMN tumor_size_greatest_dimension decimal(3, 1) DEFAULT NULL,
 ADD COLUMN tumour_grade varchar(150) NOT NULL DEFAULT '',
 ADD COLUMN tumour_grade_specify varchar(250) NOT NULL DEFAULT '';

ALTER TABLE dxd_cap_report_hepatocellular_carcinomas_revs
 ADD COLUMN additional_dimension_a decimal(3,1) DEFAULT NULL,
 ADD COLUMN additional_dimension_b decimal(3,1) DEFAULT NULL,
 ADD COLUMN notes TEXT,
 ADD COLUMN path_mstage varchar(15) NOT NULL DEFAULT '',
 ADD COLUMN path_mstage_metastasis_site_specify varchar(250),
 ADD COLUMN path_nstage varchar(5) NOT NULL DEFAULT '',
 ADD COLUMN path_nstage_nbr_node_examined SMALLINT(1) DEFAULT NULL,
 ADD COLUMN path_nstage_nbr_node_involved SMALLINT(1) DEFAULT NULL,
 ADD COLUMN path_tnm_descriptor_m char(1) NOT NULL DEFAULT '',
 ADD COLUMN path_tnm_descriptor_r char(1) NOT NULL DEFAULT '',
 ADD COLUMN path_tnm_descriptor_y char(1) NOT NULL DEFAULT '',
 ADD COLUMN path_tstage varchar(5) NOT NULL DEFAULT '',
 ADD COLUMN tumor_size_cannot_be_determined tinyint(1) DEFAULT 0,
 ADD COLUMN tumor_size_greatest_dimension decimal(3, 1) DEFAULT NULL,
 ADD COLUMN tumour_grade varchar(150) NOT NULL DEFAULT '',
 ADD COLUMN tumour_grade_specify varchar(250) NOT NULL DEFAULT '';

ALTER TABLE dxd_cap_report_gallbladders_revs
 ADD COLUMN additional_dimension_a decimal(3,1) DEFAULT NULL,
 ADD COLUMN additional_dimension_b decimal(3,1) DEFAULT NULL,
 ADD COLUMN notes TEXT,
 ADD COLUMN path_mstage varchar(15) NOT NULL DEFAULT '',
 ADD COLUMN path_mstage_metastasis_site_specify varchar(250),
 ADD COLUMN path_nstage varchar(5) NOT NULL DEFAULT '',
 ADD COLUMN path_nstage_nbr_node_examined SMALLINT(1) DEFAULT NULL,
 ADD COLUMN path_nstage_nbr_node_involved SMALLINT(1) DEFAULT NULL,
 ADD COLUMN path_tnm_descriptor_m char(1) NOT NULL DEFAULT '',
 ADD COLUMN path_tnm_descriptor_r char(1) NOT NULL DEFAULT '',
 ADD COLUMN path_tnm_descriptor_y char(1) NOT NULL DEFAULT '',
 ADD COLUMN path_tstage varchar(5) NOT NULL DEFAULT '',
 ADD COLUMN tumor_size_cannot_be_determined tinyint(1) DEFAULT 0,
 ADD COLUMN tumor_size_greatest_dimension decimal(3, 1) DEFAULT NULL,
 ADD COLUMN tumour_grade varchar(150) NOT NULL DEFAULT '',
 ADD COLUMN tumour_grade_specify varchar(250) NOT NULL DEFAULT '';

ALTER TABLE dxd_cap_report_distalexbileducts_revs
 ADD COLUMN additional_dimension_a decimal(3,1) DEFAULT NULL,
 ADD COLUMN additional_dimension_b decimal(3,1) DEFAULT NULL,
 ADD COLUMN notes TEXT,
 ADD COLUMN path_mstage varchar(15) NOT NULL DEFAULT '',
 ADD COLUMN path_mstage_metastasis_site_specify varchar(250),
 ADD COLUMN path_nstage varchar(5) NOT NULL DEFAULT '',
 ADD COLUMN path_nstage_nbr_node_examined SMALLINT(1) DEFAULT NULL,
 ADD COLUMN path_nstage_nbr_node_involved SMALLINT(1) DEFAULT NULL,
 ADD COLUMN path_tnm_descriptor_m char(1) NOT NULL DEFAULT '',
 ADD COLUMN path_tnm_descriptor_r char(1) NOT NULL DEFAULT '',
 ADD COLUMN path_tnm_descriptor_y char(1) NOT NULL DEFAULT '',
 ADD COLUMN path_tstage varchar(5) NOT NULL DEFAULT '',
 ADD COLUMN tumor_size_cannot_be_determined tinyint(1) DEFAULT 0,
 ADD COLUMN tumor_size_greatest_dimension decimal(3, 1) DEFAULT NULL,
 ADD COLUMN tumour_grade varchar(150) NOT NULL DEFAULT '',
 ADD COLUMN tumour_grade_specify varchar(250) NOT NULL DEFAULT '';

ALTER TABLE dxd_cap_report_colon_biopsies_revs
 ADD COLUMN additional_dimension_a decimal(3,1) DEFAULT NULL,
 ADD COLUMN additional_dimension_b decimal(3,1) DEFAULT NULL,
 ADD COLUMN notes TEXT,
 ADD COLUMN path_mstage varchar(15) NOT NULL DEFAULT '',
 ADD COLUMN path_mstage_metastasis_site_specify varchar(250),
 ADD COLUMN path_nstage varchar(5) NOT NULL DEFAULT '',
 ADD COLUMN path_nstage_nbr_node_examined SMALLINT(1) DEFAULT NULL,
 ADD COLUMN path_nstage_nbr_node_involved SMALLINT(1) DEFAULT NULL,
 ADD COLUMN path_tnm_descriptor_m char(1) NOT NULL DEFAULT '',
 ADD COLUMN path_tnm_descriptor_r char(1) NOT NULL DEFAULT '',
 ADD COLUMN path_tnm_descriptor_y char(1) NOT NULL DEFAULT '',
 ADD COLUMN path_tstage varchar(5) NOT NULL DEFAULT '',
 ADD COLUMN tumor_size_cannot_be_determined tinyint(1) DEFAULT 0,
 ADD COLUMN tumor_size_greatest_dimension decimal(3, 1) DEFAULT NULL,
 ADD COLUMN tumour_grade varchar(150) NOT NULL DEFAULT '',
 ADD COLUMN tumour_grade_specify varchar(250) NOT NULL DEFAULT '';

ALTER TABLE dxd_cap_report_ampullas_revs
 ADD COLUMN additional_dimension_a decimal(3,1) DEFAULT NULL,
 ADD COLUMN additional_dimension_b decimal(3,1) DEFAULT NULL,
 ADD COLUMN notes TEXT,
 ADD COLUMN path_mstage varchar(15) NOT NULL DEFAULT '',
 ADD COLUMN path_mstage_metastasis_site_specify varchar(250),
 ADD COLUMN path_nstage varchar(5) NOT NULL DEFAULT '',
 ADD COLUMN path_nstage_nbr_node_examined SMALLINT(1) DEFAULT NULL,
 ADD COLUMN path_nstage_nbr_node_involved SMALLINT(1) DEFAULT NULL,
 ADD COLUMN path_tnm_descriptor_m char(1) NOT NULL DEFAULT '',
 ADD COLUMN path_tnm_descriptor_r char(1) NOT NULL DEFAULT '',
 ADD COLUMN path_tnm_descriptor_y char(1) NOT NULL DEFAULT '',
 ADD COLUMN path_tstage varchar(5) NOT NULL DEFAULT '',
 ADD COLUMN tumor_size_cannot_be_determined tinyint(1) DEFAULT 0,
 ADD COLUMN tumor_size_greatest_dimension decimal(3, 1) DEFAULT NULL,
 ADD COLUMN tumour_grade varchar(150) NOT NULL DEFAULT '',
 ADD COLUMN tumour_grade_specify varchar(250) NOT NULL DEFAULT '';

ALTER TABLE dxd_cap_report_colon_rectum_resections_revs
 ADD COLUMN additional_dimension_a decimal(3,1) DEFAULT NULL,
 ADD COLUMN additional_dimension_b decimal(3,1) DEFAULT NULL,
 ADD COLUMN notes TEXT,
 ADD COLUMN path_mstage varchar(15) NOT NULL DEFAULT '',
 ADD COLUMN path_mstage_metastasis_site_specify varchar(250),
 ADD COLUMN path_nstage varchar(5) NOT NULL DEFAULT '',
 ADD COLUMN path_nstage_nbr_node_examined SMALLINT(1) DEFAULT NULL,
 ADD COLUMN path_nstage_nbr_node_involved SMALLINT(1) DEFAULT NULL,
 ADD COLUMN path_tnm_descriptor_m char(1) NOT NULL DEFAULT '',
 ADD COLUMN path_tnm_descriptor_r char(1) NOT NULL DEFAULT '',
 ADD COLUMN path_tnm_descriptor_y char(1) NOT NULL DEFAULT '',
 ADD COLUMN path_tstage varchar(5) NOT NULL DEFAULT '',
 ADD COLUMN tumor_size_cannot_be_determined tinyint(1) DEFAULT 0,
 ADD COLUMN tumor_size_greatest_dimension decimal(3, 1) DEFAULT NULL,
 ADD COLUMN tumour_grade varchar(150) NOT NULL DEFAULT '',
 ADD COLUMN tumour_grade_specify varchar(250) NOT NULL DEFAULT '';

ALTER TABLE dxd_cap_report_pancreasendos_revs
 ADD COLUMN additional_dimension_a decimal(3,1) DEFAULT NULL,
 ADD COLUMN additional_dimension_b decimal(3,1) DEFAULT NULL,
 ADD COLUMN notes TEXT,
 ADD COLUMN path_mstage varchar(15) NOT NULL DEFAULT '',
 ADD COLUMN path_mstage_metastasis_site_specify varchar(250),
 ADD COLUMN path_nstage varchar(5) NOT NULL DEFAULT '',
 ADD COLUMN path_nstage_nbr_node_examined SMALLINT(1) DEFAULT NULL,
 ADD COLUMN path_nstage_nbr_node_involved SMALLINT(1) DEFAULT NULL,
 ADD COLUMN path_tnm_descriptor_m char(1) NOT NULL DEFAULT '',
 ADD COLUMN path_tnm_descriptor_r char(1) NOT NULL DEFAULT '',
 ADD COLUMN path_tnm_descriptor_y char(1) NOT NULL DEFAULT '',
 ADD COLUMN path_tstage varchar(5) NOT NULL DEFAULT '',
 ADD COLUMN tumor_size_cannot_be_determined tinyint(1) DEFAULT 0,
 ADD COLUMN tumor_size_greatest_dimension decimal(3, 1) DEFAULT NULL,
 ADD COLUMN tumour_grade varchar(150) NOT NULL DEFAULT '',
 ADD COLUMN tumour_grade_specify varchar(250) NOT NULL DEFAULT '';

UPDATE dxd_cap_report_smintestines AS cap INNER JOIN diagnosis_masters AS dx ON cap.diagnosis_master_id=dx.id SET cap.additional_dimension_a = dx.additional_dimension_a, cap.additional_dimension_b = dx.additional_dimension_b, cap.notes = dx.notes, cap.path_mstage = dx.path_mstage, cap.path_mstage_metastasis_site_specify = dx.path_mstage_metastasis_site_specify, cap.path_nstage = dx.path_nstage, cap.path_nstage_nbr_node_examined = dx.path_nstage_nbr_node_examined, cap.path_nstage_nbr_node_involved = dx.path_nstage_nbr_node_involved, cap.path_tnm_descriptor_m = dx.path_tnm_descriptor_m, cap.path_tnm_descriptor_r = dx.path_tnm_descriptor_r, cap.path_tnm_descriptor_y = dx.path_tnm_descriptor_y, cap.path_tstage = dx.path_tstage, cap.tumor_size_cannot_be_determined = dx.tumor_size_cannot_be_determined, cap.tumor_size_greatest_dimension = dx.tumor_size_greatest_dimension, cap.tumour_grade = dx.tumour_grade, cap.tumour_grade_specify = dx.tumour_grade_specify;
UPDATE dxd_cap_report_perihilarbileducts AS cap INNER JOIN diagnosis_masters AS dx ON cap.diagnosis_master_id=dx.id SET cap.additional_dimension_a = dx.additional_dimension_a, cap.additional_dimension_b = dx.additional_dimension_b, cap.notes = dx.notes, cap.path_mstage = dx.path_mstage, cap.path_mstage_metastasis_site_specify = dx.path_mstage_metastasis_site_specify, cap.path_nstage = dx.path_nstage, cap.path_nstage_nbr_node_examined = dx.path_nstage_nbr_node_examined, cap.path_nstage_nbr_node_involved = dx.path_nstage_nbr_node_involved, cap.path_tnm_descriptor_m = dx.path_tnm_descriptor_m, cap.path_tnm_descriptor_r = dx.path_tnm_descriptor_r, cap.path_tnm_descriptor_y = dx.path_tnm_descriptor_y, cap.path_tstage = dx.path_tstage, cap.tumor_size_cannot_be_determined = dx.tumor_size_cannot_be_determined, cap.tumor_size_greatest_dimension = dx.tumor_size_greatest_dimension, cap.tumour_grade = dx.tumour_grade, cap.tumour_grade_specify = dx.tumour_grade_specify;
UPDATE dxd_cap_report_pancreasexos AS cap INNER JOIN diagnosis_masters AS dx ON cap.diagnosis_master_id=dx.id SET cap.additional_dimension_a = dx.additional_dimension_a, cap.additional_dimension_b = dx.additional_dimension_b, cap.notes = dx.notes, cap.path_mstage = dx.path_mstage, cap.path_mstage_metastasis_site_specify = dx.path_mstage_metastasis_site_specify, cap.path_nstage = dx.path_nstage, cap.path_nstage_nbr_node_examined = dx.path_nstage_nbr_node_examined, cap.path_nstage_nbr_node_involved = dx.path_nstage_nbr_node_involved, cap.path_tnm_descriptor_m = dx.path_tnm_descriptor_m, cap.path_tnm_descriptor_r = dx.path_tnm_descriptor_r, cap.path_tnm_descriptor_y = dx.path_tnm_descriptor_y, cap.path_tstage = dx.path_tstage, cap.tumor_size_cannot_be_determined = dx.tumor_size_cannot_be_determined, cap.tumor_size_greatest_dimension = dx.tumor_size_greatest_dimension, cap.tumour_grade = dx.tumour_grade, cap.tumour_grade_specify = dx.tumour_grade_specify;
UPDATE dxd_cap_report_intrahepbileducts AS cap INNER JOIN diagnosis_masters AS dx ON cap.diagnosis_master_id=dx.id SET cap.additional_dimension_a = dx.additional_dimension_a, cap.additional_dimension_b = dx.additional_dimension_b, cap.notes = dx.notes, cap.path_mstage = dx.path_mstage, cap.path_mstage_metastasis_site_specify = dx.path_mstage_metastasis_site_specify, cap.path_nstage = dx.path_nstage, cap.path_nstage_nbr_node_examined = dx.path_nstage_nbr_node_examined, cap.path_nstage_nbr_node_involved = dx.path_nstage_nbr_node_involved, cap.path_tnm_descriptor_m = dx.path_tnm_descriptor_m, cap.path_tnm_descriptor_r = dx.path_tnm_descriptor_r, cap.path_tnm_descriptor_y = dx.path_tnm_descriptor_y, cap.path_tstage = dx.path_tstage, cap.tumor_size_cannot_be_determined = dx.tumor_size_cannot_be_determined, cap.tumor_size_greatest_dimension = dx.tumor_size_greatest_dimension, cap.tumour_grade = dx.tumour_grade, cap.tumour_grade_specify = dx.tumour_grade_specify;
UPDATE dxd_cap_report_hepatocellular_carcinomas AS cap INNER JOIN diagnosis_masters AS dx ON cap.diagnosis_master_id=dx.id SET cap.additional_dimension_a = dx.additional_dimension_a, cap.additional_dimension_b = dx.additional_dimension_b, cap.notes = dx.notes, cap.path_mstage = dx.path_mstage, cap.path_mstage_metastasis_site_specify = dx.path_mstage_metastasis_site_specify, cap.path_nstage = dx.path_nstage, cap.path_nstage_nbr_node_examined = dx.path_nstage_nbr_node_examined, cap.path_nstage_nbr_node_involved = dx.path_nstage_nbr_node_involved, cap.path_tnm_descriptor_m = dx.path_tnm_descriptor_m, cap.path_tnm_descriptor_r = dx.path_tnm_descriptor_r, cap.path_tnm_descriptor_y = dx.path_tnm_descriptor_y, cap.path_tstage = dx.path_tstage, cap.tumor_size_cannot_be_determined = dx.tumor_size_cannot_be_determined, cap.tumor_size_greatest_dimension = dx.tumor_size_greatest_dimension, cap.tumour_grade = dx.tumour_grade, cap.tumour_grade_specify = dx.tumour_grade_specify;
UPDATE dxd_cap_report_gallbladders AS cap INNER JOIN diagnosis_masters AS dx ON cap.diagnosis_master_id=dx.id SET cap.additional_dimension_a = dx.additional_dimension_a, cap.additional_dimension_b = dx.additional_dimension_b, cap.notes = dx.notes, cap.path_mstage = dx.path_mstage, cap.path_mstage_metastasis_site_specify = dx.path_mstage_metastasis_site_specify, cap.path_nstage = dx.path_nstage, cap.path_nstage_nbr_node_examined = dx.path_nstage_nbr_node_examined, cap.path_nstage_nbr_node_involved = dx.path_nstage_nbr_node_involved, cap.path_tnm_descriptor_m = dx.path_tnm_descriptor_m, cap.path_tnm_descriptor_r = dx.path_tnm_descriptor_r, cap.path_tnm_descriptor_y = dx.path_tnm_descriptor_y, cap.path_tstage = dx.path_tstage, cap.tumor_size_cannot_be_determined = dx.tumor_size_cannot_be_determined, cap.tumor_size_greatest_dimension = dx.tumor_size_greatest_dimension, cap.tumour_grade = dx.tumour_grade, cap.tumour_grade_specify = dx.tumour_grade_specify;
UPDATE dxd_cap_report_distalexbileducts AS cap INNER JOIN diagnosis_masters AS dx ON cap.diagnosis_master_id=dx.id SET cap.additional_dimension_a = dx.additional_dimension_a, cap.additional_dimension_b = dx.additional_dimension_b, cap.notes = dx.notes, cap.path_mstage = dx.path_mstage, cap.path_mstage_metastasis_site_specify = dx.path_mstage_metastasis_site_specify, cap.path_nstage = dx.path_nstage, cap.path_nstage_nbr_node_examined = dx.path_nstage_nbr_node_examined, cap.path_nstage_nbr_node_involved = dx.path_nstage_nbr_node_involved, cap.path_tnm_descriptor_m = dx.path_tnm_descriptor_m, cap.path_tnm_descriptor_r = dx.path_tnm_descriptor_r, cap.path_tnm_descriptor_y = dx.path_tnm_descriptor_y, cap.path_tstage = dx.path_tstage, cap.tumor_size_cannot_be_determined = dx.tumor_size_cannot_be_determined, cap.tumor_size_greatest_dimension = dx.tumor_size_greatest_dimension, cap.tumour_grade = dx.tumour_grade, cap.tumour_grade_specify = dx.tumour_grade_specify;
UPDATE dxd_cap_report_colon_biopsies AS cap INNER JOIN diagnosis_masters AS dx ON cap.diagnosis_master_id=dx.id SET cap.additional_dimension_a = dx.additional_dimension_a, cap.additional_dimension_b = dx.additional_dimension_b, cap.notes = dx.notes, cap.path_mstage = dx.path_mstage, cap.path_mstage_metastasis_site_specify = dx.path_mstage_metastasis_site_specify, cap.path_nstage = dx.path_nstage, cap.path_nstage_nbr_node_examined = dx.path_nstage_nbr_node_examined, cap.path_nstage_nbr_node_involved = dx.path_nstage_nbr_node_involved, cap.path_tnm_descriptor_m = dx.path_tnm_descriptor_m, cap.path_tnm_descriptor_r = dx.path_tnm_descriptor_r, cap.path_tnm_descriptor_y = dx.path_tnm_descriptor_y, cap.path_tstage = dx.path_tstage, cap.tumor_size_cannot_be_determined = dx.tumor_size_cannot_be_determined, cap.tumor_size_greatest_dimension = dx.tumor_size_greatest_dimension, cap.tumour_grade = dx.tumour_grade, cap.tumour_grade_specify = dx.tumour_grade_specify;
UPDATE dxd_cap_report_ampullas AS cap INNER JOIN diagnosis_masters AS dx ON cap.diagnosis_master_id=dx.id SET cap.additional_dimension_a = dx.additional_dimension_a, cap.additional_dimension_b = dx.additional_dimension_b, cap.notes = dx.notes, cap.path_mstage = dx.path_mstage, cap.path_mstage_metastasis_site_specify = dx.path_mstage_metastasis_site_specify, cap.path_nstage = dx.path_nstage, cap.path_nstage_nbr_node_examined = dx.path_nstage_nbr_node_examined, cap.path_nstage_nbr_node_involved = dx.path_nstage_nbr_node_involved, cap.path_tnm_descriptor_m = dx.path_tnm_descriptor_m, cap.path_tnm_descriptor_r = dx.path_tnm_descriptor_r, cap.path_tnm_descriptor_y = dx.path_tnm_descriptor_y, cap.path_tstage = dx.path_tstage, cap.tumor_size_cannot_be_determined = dx.tumor_size_cannot_be_determined, cap.tumor_size_greatest_dimension = dx.tumor_size_greatest_dimension, cap.tumour_grade = dx.tumour_grade, cap.tumour_grade_specify = dx.tumour_grade_specify;
UPDATE dxd_cap_report_colon_rectum_resections AS cap INNER JOIN diagnosis_masters AS dx ON cap.diagnosis_master_id=dx.id SET cap.additional_dimension_a = dx.additional_dimension_a, cap.additional_dimension_b = dx.additional_dimension_b, cap.notes = dx.notes, cap.path_mstage = dx.path_mstage, cap.path_mstage_metastasis_site_specify = dx.path_mstage_metastasis_site_specify, cap.path_nstage = dx.path_nstage, cap.path_nstage_nbr_node_examined = dx.path_nstage_nbr_node_examined, cap.path_nstage_nbr_node_involved = dx.path_nstage_nbr_node_involved, cap.path_tnm_descriptor_m = dx.path_tnm_descriptor_m, cap.path_tnm_descriptor_r = dx.path_tnm_descriptor_r, cap.path_tnm_descriptor_y = dx.path_tnm_descriptor_y, cap.path_tstage = dx.path_tstage, cap.tumor_size_cannot_be_determined = dx.tumor_size_cannot_be_determined, cap.tumor_size_greatest_dimension = dx.tumor_size_greatest_dimension, cap.tumour_grade = dx.tumour_grade, cap.tumour_grade_specify = dx.tumour_grade_specify;
UPDATE dxd_cap_report_pancreasendos AS cap INNER JOIN diagnosis_masters AS dx ON cap.diagnosis_master_id=dx.id SET cap.additional_dimension_a = dx.additional_dimension_a, cap.additional_dimension_b = dx.additional_dimension_b, cap.notes = dx.notes, cap.path_mstage = dx.path_mstage, cap.path_mstage_metastasis_site_specify = dx.path_mstage_metastasis_site_specify, cap.path_nstage = dx.path_nstage, cap.path_nstage_nbr_node_examined = dx.path_nstage_nbr_node_examined, cap.path_nstage_nbr_node_involved = dx.path_nstage_nbr_node_involved, cap.path_tnm_descriptor_m = dx.path_tnm_descriptor_m, cap.path_tnm_descriptor_r = dx.path_tnm_descriptor_r, cap.path_tnm_descriptor_y = dx.path_tnm_descriptor_y, cap.path_tstage = dx.path_tstage, cap.tumor_size_cannot_be_determined = dx.tumor_size_cannot_be_determined, cap.tumor_size_greatest_dimension = dx.tumor_size_greatest_dimension, cap.tumour_grade = dx.tumour_grade, cap.tumour_grade_specify = dx.tumour_grade_specify;

UPDATE dxd_cap_report_smintestines_revs AS cap_rev INNER JOIN dxd_cap_report_smintestines AS cap ON cap_rev.id=cap.id SET cap_rev.additional_dimension_a = cap.additional_dimension_a, cap_rev.additional_dimension_b = cap.additional_dimension_b, cap_rev.notes = cap.notes, cap_rev.path_mstage = cap.path_mstage, cap_rev.path_mstage_metastasis_site_specify = cap.path_mstage_metastasis_site_specify, cap_rev.path_nstage = cap.path_nstage, cap_rev.path_nstage_nbr_node_examined = cap.path_nstage_nbr_node_examined, cap_rev.path_nstage_nbr_node_involved = cap.path_nstage_nbr_node_involved, cap_rev.path_tnm_descriptor_m = cap.path_tnm_descriptor_m, cap_rev.path_tnm_descriptor_r = cap.path_tnm_descriptor_r, cap_rev.path_tnm_descriptor_y = cap.path_tnm_descriptor_y, cap_rev.path_tstage = cap.path_tstage, cap_rev.tumor_size_cannot_be_determined = cap.tumor_size_cannot_be_determined, cap_rev.tumor_size_greatest_dimension = cap.tumor_size_greatest_dimension, cap_rev.tumour_grade = cap.tumour_grade, cap_rev.tumour_grade_specify = cap.tumour_grade_specify;
UPDATE dxd_cap_report_perihilarbileducts_revs AS cap_rev INNER JOIN dxd_cap_report_perihilarbileducts AS cap ON cap_rev.id=cap.id SET cap_rev.additional_dimension_a = cap.additional_dimension_a, cap_rev.additional_dimension_b = cap.additional_dimension_b, cap_rev.notes = cap.notes, cap_rev.path_mstage = cap.path_mstage, cap_rev.path_mstage_metastasis_site_specify = cap.path_mstage_metastasis_site_specify, cap_rev.path_nstage = cap.path_nstage, cap_rev.path_nstage_nbr_node_examined = cap.path_nstage_nbr_node_examined, cap_rev.path_nstage_nbr_node_involved = cap.path_nstage_nbr_node_involved, cap_rev.path_tnm_descriptor_m = cap.path_tnm_descriptor_m, cap_rev.path_tnm_descriptor_r = cap.path_tnm_descriptor_r, cap_rev.path_tnm_descriptor_y = cap.path_tnm_descriptor_y, cap_rev.path_tstage = cap.path_tstage, cap_rev.tumor_size_cannot_be_determined = cap.tumor_size_cannot_be_determined, cap_rev.tumor_size_greatest_dimension = cap.tumor_size_greatest_dimension, cap_rev.tumour_grade = cap.tumour_grade, cap_rev.tumour_grade_specify = cap.tumour_grade_specify;
UPDATE dxd_cap_report_pancreasexos_revs AS cap_rev INNER JOIN dxd_cap_report_pancreasexos AS cap ON cap_rev.id=cap.id SET cap_rev.additional_dimension_a = cap.additional_dimension_a, cap_rev.additional_dimension_b = cap.additional_dimension_b, cap_rev.notes = cap.notes, cap_rev.path_mstage = cap.path_mstage, cap_rev.path_mstage_metastasis_site_specify = cap.path_mstage_metastasis_site_specify, cap_rev.path_nstage = cap.path_nstage, cap_rev.path_nstage_nbr_node_examined = cap.path_nstage_nbr_node_examined, cap_rev.path_nstage_nbr_node_involved = cap.path_nstage_nbr_node_involved, cap_rev.path_tnm_descriptor_m = cap.path_tnm_descriptor_m, cap_rev.path_tnm_descriptor_r = cap.path_tnm_descriptor_r, cap_rev.path_tnm_descriptor_y = cap.path_tnm_descriptor_y, cap_rev.path_tstage = cap.path_tstage, cap_rev.tumor_size_cannot_be_determined = cap.tumor_size_cannot_be_determined, cap_rev.tumor_size_greatest_dimension = cap.tumor_size_greatest_dimension, cap_rev.tumour_grade = cap.tumour_grade, cap_rev.tumour_grade_specify = cap.tumour_grade_specify;
UPDATE dxd_cap_report_intrahepbileducts_revs AS cap_rev INNER JOIN dxd_cap_report_intrahepbileducts AS cap ON cap_rev.id=cap.id SET cap_rev.additional_dimension_a = cap.additional_dimension_a, cap_rev.additional_dimension_b = cap.additional_dimension_b, cap_rev.notes = cap.notes, cap_rev.path_mstage = cap.path_mstage, cap_rev.path_mstage_metastasis_site_specify = cap.path_mstage_metastasis_site_specify, cap_rev.path_nstage = cap.path_nstage, cap_rev.path_nstage_nbr_node_examined = cap.path_nstage_nbr_node_examined, cap_rev.path_nstage_nbr_node_involved = cap.path_nstage_nbr_node_involved, cap_rev.path_tnm_descriptor_m = cap.path_tnm_descriptor_m, cap_rev.path_tnm_descriptor_r = cap.path_tnm_descriptor_r, cap_rev.path_tnm_descriptor_y = cap.path_tnm_descriptor_y, cap_rev.path_tstage = cap.path_tstage, cap_rev.tumor_size_cannot_be_determined = cap.tumor_size_cannot_be_determined, cap_rev.tumor_size_greatest_dimension = cap.tumor_size_greatest_dimension, cap_rev.tumour_grade = cap.tumour_grade, cap_rev.tumour_grade_specify = cap.tumour_grade_specify;
UPDATE dxd_cap_report_hepatocellular_carcinomas_revs AS cap_rev INNER JOIN dxd_cap_report_hepatocellular_carcinomas AS cap ON cap_rev.id=cap.id SET cap_rev.additional_dimension_a = cap.additional_dimension_a, cap_rev.additional_dimension_b = cap.additional_dimension_b, cap_rev.notes = cap.notes, cap_rev.path_mstage = cap.path_mstage, cap_rev.path_mstage_metastasis_site_specify = cap.path_mstage_metastasis_site_specify, cap_rev.path_nstage = cap.path_nstage, cap_rev.path_nstage_nbr_node_examined = cap.path_nstage_nbr_node_examined, cap_rev.path_nstage_nbr_node_involved = cap.path_nstage_nbr_node_involved, cap_rev.path_tnm_descriptor_m = cap.path_tnm_descriptor_m, cap_rev.path_tnm_descriptor_r = cap.path_tnm_descriptor_r, cap_rev.path_tnm_descriptor_y = cap.path_tnm_descriptor_y, cap_rev.path_tstage = cap.path_tstage, cap_rev.tumor_size_cannot_be_determined = cap.tumor_size_cannot_be_determined, cap_rev.tumor_size_greatest_dimension = cap.tumor_size_greatest_dimension, cap_rev.tumour_grade = cap.tumour_grade, cap_rev.tumour_grade_specify = cap.tumour_grade_specify;
UPDATE dxd_cap_report_gallbladders_revs AS cap_rev INNER JOIN dxd_cap_report_gallbladders AS cap ON cap_rev.id=cap.id SET cap_rev.additional_dimension_a = cap.additional_dimension_a, cap_rev.additional_dimension_b = cap.additional_dimension_b, cap_rev.notes = cap.notes, cap_rev.path_mstage = cap.path_mstage, cap_rev.path_mstage_metastasis_site_specify = cap.path_mstage_metastasis_site_specify, cap_rev.path_nstage = cap.path_nstage, cap_rev.path_nstage_nbr_node_examined = cap.path_nstage_nbr_node_examined, cap_rev.path_nstage_nbr_node_involved = cap.path_nstage_nbr_node_involved, cap_rev.path_tnm_descriptor_m = cap.path_tnm_descriptor_m, cap_rev.path_tnm_descriptor_r = cap.path_tnm_descriptor_r, cap_rev.path_tnm_descriptor_y = cap.path_tnm_descriptor_y, cap_rev.path_tstage = cap.path_tstage, cap_rev.tumor_size_cannot_be_determined = cap.tumor_size_cannot_be_determined, cap_rev.tumor_size_greatest_dimension = cap.tumor_size_greatest_dimension, cap_rev.tumour_grade = cap.tumour_grade, cap_rev.tumour_grade_specify = cap.tumour_grade_specify;
UPDATE dxd_cap_report_distalexbileducts_revs AS cap_rev INNER JOIN dxd_cap_report_distalexbileducts AS cap ON cap_rev.id=cap.id SET cap_rev.additional_dimension_a = cap.additional_dimension_a, cap_rev.additional_dimension_b = cap.additional_dimension_b, cap_rev.notes = cap.notes, cap_rev.path_mstage = cap.path_mstage, cap_rev.path_mstage_metastasis_site_specify = cap.path_mstage_metastasis_site_specify, cap_rev.path_nstage = cap.path_nstage, cap_rev.path_nstage_nbr_node_examined = cap.path_nstage_nbr_node_examined, cap_rev.path_nstage_nbr_node_involved = cap.path_nstage_nbr_node_involved, cap_rev.path_tnm_descriptor_m = cap.path_tnm_descriptor_m, cap_rev.path_tnm_descriptor_r = cap.path_tnm_descriptor_r, cap_rev.path_tnm_descriptor_y = cap.path_tnm_descriptor_y, cap_rev.path_tstage = cap.path_tstage, cap_rev.tumor_size_cannot_be_determined = cap.tumor_size_cannot_be_determined, cap_rev.tumor_size_greatest_dimension = cap.tumor_size_greatest_dimension, cap_rev.tumour_grade = cap.tumour_grade, cap_rev.tumour_grade_specify = cap.tumour_grade_specify;
UPDATE dxd_cap_report_colon_biopsies_revs AS cap_rev INNER JOIN dxd_cap_report_colon_biopsies AS cap ON cap_rev.id=cap.id SET cap_rev.additional_dimension_a = cap.additional_dimension_a, cap_rev.additional_dimension_b = cap.additional_dimension_b, cap_rev.notes = cap.notes, cap_rev.path_mstage = cap.path_mstage, cap_rev.path_mstage_metastasis_site_specify = cap.path_mstage_metastasis_site_specify, cap_rev.path_nstage = cap.path_nstage, cap_rev.path_nstage_nbr_node_examined = cap.path_nstage_nbr_node_examined, cap_rev.path_nstage_nbr_node_involved = cap.path_nstage_nbr_node_involved, cap_rev.path_tnm_descriptor_m = cap.path_tnm_descriptor_m, cap_rev.path_tnm_descriptor_r = cap.path_tnm_descriptor_r, cap_rev.path_tnm_descriptor_y = cap.path_tnm_descriptor_y, cap_rev.path_tstage = cap.path_tstage, cap_rev.tumor_size_cannot_be_determined = cap.tumor_size_cannot_be_determined, cap_rev.tumor_size_greatest_dimension = cap.tumor_size_greatest_dimension, cap_rev.tumour_grade = cap.tumour_grade, cap_rev.tumour_grade_specify = cap.tumour_grade_specify;
UPDATE dxd_cap_report_ampullas_revs AS cap_rev INNER JOIN dxd_cap_report_ampullas AS cap ON cap_rev.id=cap.id SET cap_rev.additional_dimension_a = cap.additional_dimension_a, cap_rev.additional_dimension_b = cap.additional_dimension_b, cap_rev.notes = cap.notes, cap_rev.path_mstage = cap.path_mstage, cap_rev.path_mstage_metastasis_site_specify = cap.path_mstage_metastasis_site_specify, cap_rev.path_nstage = cap.path_nstage, cap_rev.path_nstage_nbr_node_examined = cap.path_nstage_nbr_node_examined, cap_rev.path_nstage_nbr_node_involved = cap.path_nstage_nbr_node_involved, cap_rev.path_tnm_descriptor_m = cap.path_tnm_descriptor_m, cap_rev.path_tnm_descriptor_r = cap.path_tnm_descriptor_r, cap_rev.path_tnm_descriptor_y = cap.path_tnm_descriptor_y, cap_rev.path_tstage = cap.path_tstage, cap_rev.tumor_size_cannot_be_determined = cap.tumor_size_cannot_be_determined, cap_rev.tumor_size_greatest_dimension = cap.tumor_size_greatest_dimension, cap_rev.tumour_grade = cap.tumour_grade, cap_rev.tumour_grade_specify = cap.tumour_grade_specify;
UPDATE dxd_cap_report_colon_rectum_resections_revs AS cap_rev INNER JOIN dxd_cap_report_colon_rectum_resections AS cap ON cap_rev.id=cap.id SET cap_rev.additional_dimension_a = cap.additional_dimension_a, cap_rev.additional_dimension_b = cap.additional_dimension_b, cap_rev.notes = cap.notes, cap_rev.path_mstage = cap.path_mstage, cap_rev.path_mstage_metastasis_site_specify = cap.path_mstage_metastasis_site_specify, cap_rev.path_nstage = cap.path_nstage, cap_rev.path_nstage_nbr_node_examined = cap.path_nstage_nbr_node_examined, cap_rev.path_nstage_nbr_node_involved = cap.path_nstage_nbr_node_involved, cap_rev.path_tnm_descriptor_m = cap.path_tnm_descriptor_m, cap_rev.path_tnm_descriptor_r = cap.path_tnm_descriptor_r, cap_rev.path_tnm_descriptor_y = cap.path_tnm_descriptor_y, cap_rev.path_tstage = cap.path_tstage, cap_rev.tumor_size_cannot_be_determined = cap.tumor_size_cannot_be_determined, cap_rev.tumor_size_greatest_dimension = cap.tumor_size_greatest_dimension, cap_rev.tumour_grade = cap.tumour_grade, cap_rev.tumour_grade_specify = cap.tumour_grade_specify;
UPDATE dxd_cap_report_pancreasendos_revs AS cap_rev INNER JOIN dxd_cap_report_pancreasendos AS cap ON cap_rev.id=cap.id SET cap_rev.additional_dimension_a = cap.additional_dimension_a, cap_rev.additional_dimension_b = cap.additional_dimension_b, cap_rev.notes = cap.notes, cap_rev.path_mstage = cap.path_mstage, cap_rev.path_mstage_metastasis_site_specify = cap.path_mstage_metastasis_site_specify, cap_rev.path_nstage = cap.path_nstage, cap_rev.path_nstage_nbr_node_examined = cap.path_nstage_nbr_node_examined, cap_rev.path_nstage_nbr_node_involved = cap.path_nstage_nbr_node_involved, cap_rev.path_tnm_descriptor_m = cap.path_tnm_descriptor_m, cap_rev.path_tnm_descriptor_r = cap.path_tnm_descriptor_r, cap_rev.path_tnm_descriptor_y = cap.path_tnm_descriptor_y, cap_rev.path_tstage = cap.path_tstage, cap_rev.tumor_size_cannot_be_determined = cap.tumor_size_cannot_be_determined, cap_rev.tumor_size_greatest_dimension = cap.tumor_size_greatest_dimension, cap_rev.tumour_grade = cap.tumour_grade, cap_rev.tumour_grade_specify = cap.tumour_grade_specify;

ALTER TABLE dxd_cap_report_smintestines_revs
 CHANGE COLUMN diagnosis_master_id event_master_id INT NOT NULL;
ALTER TABLE dxd_cap_report_perihilarbileducts_revs
 CHANGE COLUMN diagnosis_master_id event_master_id INT NOT NULL;
ALTER TABLE dxd_cap_report_pancreasexos_revs
 CHANGE COLUMN diagnosis_master_id event_master_id INT NOT NULL;
ALTER TABLE dxd_cap_report_intrahepbileducts_revs
 CHANGE COLUMN diagnosis_master_id event_master_id INT NOT NULL;
ALTER TABLE dxd_cap_report_hepatocellular_carcinomas_revs
 CHANGE COLUMN diagnosis_master_id event_master_id INT NOT NULL;
ALTER TABLE dxd_cap_report_gallbladders_revs
 CHANGE COLUMN diagnosis_master_id event_master_id INT NOT NULL;
ALTER TABLE dxd_cap_report_distalexbileducts_revs
 CHANGE COLUMN diagnosis_master_id event_master_id INT NOT NULL;
ALTER TABLE dxd_cap_report_colon_biopsies_revs
 CHANGE COLUMN diagnosis_master_id event_master_id INT NOT NULL;
ALTER TABLE dxd_cap_report_ampullas_revs
 CHANGE COLUMN diagnosis_master_id event_master_id INT NOT NULL;
ALTER TABLE dxd_cap_report_colon_rectum_resections_revs
 CHANGE COLUMN diagnosis_master_id event_master_id INT NOT NULL;
ALTER TABLE dxd_cap_report_pancreasendos_revs
 CHANGE COLUMN diagnosis_master_id event_master_id INT NOT NULL;
 
INSERT INTO event_controls (disease_site, event_group, event_type, flag_active, form_alias, detail_tablename, display_order, databrowser_label)
(SELECT 'all', 'lab', controls_type, 1, REPLACE(form_alias, 'dx_cap_report', 'ed_cap_report'), REPLACE(detail_tablename, 'dxd_cap_report', 'ed_cap_report'), 0, databrowser_label FROM diagnosis_controls WHERE controls_type LIKE 'cap report - %');
ALTER TABLE dxd_cap_report_smintestines
 CHANGE COLUMN diagnosis_master_id event_master_id INT NOT NULL,
 DROP FOREIGN KEY FK_dxd_cap_report_smintestines_diagnosis_masters;
ALTER TABLE dxd_cap_report_perihilarbileducts
 CHANGE COLUMN diagnosis_master_id event_master_id INT NOT NULL,
 DROP FOREIGN KEY FK_dxd_cap_report_perihilarbileducts_diagnosis_masters;
ALTER TABLE dxd_cap_report_pancreasexos
 CHANGE COLUMN diagnosis_master_id event_master_id INT NOT NULL,
 DROP FOREIGN KEY FK_dxd_cap_report_pancreasexos_diagnosis_masters;
ALTER TABLE dxd_cap_report_intrahepbileducts
 CHANGE COLUMN diagnosis_master_id event_master_id INT NOT NULL,
 DROP FOREIGN KEY FK_dxd_cap_report_intrahepbileducts_diagnosis_masters;
ALTER TABLE dxd_cap_report_hepatocellular_carcinomas
 CHANGE COLUMN diagnosis_master_id event_master_id INT NOT NULL,
 DROP FOREIGN KEY FK_dxd_cap_report_hepatocellulars_diagnosis_masters;
ALTER TABLE dxd_cap_report_gallbladders
 CHANGE COLUMN diagnosis_master_id event_master_id INT NOT NULL,
 DROP FOREIGN KEY FK_dxd_cap_report_gallbladders_diagnosis_masters;
ALTER TABLE dxd_cap_report_distalexbileducts
 CHANGE COLUMN diagnosis_master_id event_master_id INT NOT NULL,
 DROP FOREIGN KEY FK_dxd_cap_report_distalexbileducts_diagnosis_masters;
ALTER TABLE dxd_cap_report_colon_biopsies
 CHANGE COLUMN diagnosis_master_id event_master_id INT NOT NULL,
 DROP FOREIGN KEY FK_dxd_cap_report_colons_diagnosis_masters;
ALTER TABLE dxd_cap_report_ampullas
 CHANGE COLUMN diagnosis_master_id event_master_id INT NOT NULL,
 DROP FOREIGN KEY FK_dxd_cap_report_ampullas_diagnosis_masters;
ALTER TABLE dxd_cap_report_colon_rectum_resections
 CHANGE COLUMN diagnosis_master_id event_master_id INT NOT NULL,
 DROP FOREIGN KEY FK_dxd_cap_report_colon_rectum_resections_diagnosis_masters;
ALTER TABLE dxd_cap_report_pancreasendos
 CHANGE COLUMN diagnosis_master_id event_master_id INT NOT NULL,
 DROP FOREIGN KEY FK_dxd_cap_report_pancreasendos_diagnosis_masters;
 
#create an intermediary table to update the ctrl id
CREATE TABLE event_masters_tmp
(SELECT diagnosis_control_id AS control_id, dx_date, dx_date_accuracy, created, created_by, modified, modified_by, participant_id, parent_id, deleted, id AS old_dx_id FROM diagnosis_masters WHERE diagnosis_control_id IN(SELECT id FROM diagnosis_controls WHERE controls_type LIKE 'cap report - %'));
UPDATE event_masters_tmp AS em
INNER JOIN diagnosis_controls AS dc ON em.control_id=dc.id
INNER JOIN event_controls AS ec ON dc.controls_type=ec.event_type
SET em.control_id=ec.id; 

ALTER TABLE event_masters
 ADD COLUMN tmp_old_dx_id INT DEFAULT NULL;
ALTER TABLE event_masters_revs
 ADD COLUMN tmp_old_dx_id INT DEFAULT NULL;

INSERT INTO event_masters (event_control_id, event_date, event_date_accuracy, created, created_by, modified, modified_by, participant_id, diagnosis_master_id, deleted, tmp_old_dx_id)
(SELECT control_id, dx_date, dx_date_accuracy, created, created_by, modified, modified_by, participant_id, parent_id, deleted, old_dx_id FROM event_masters_tmp);
INSERT INTO event_masters_revs (id, event_control_id, event_date, event_date_accuracy, participant_id, diagnosis_master_id, tmp_old_dx_id, version_created, modified_by)
(SELECT 0, diagnosis_control_id, dx_date, dx_date_accuracy, participant_id, parent_id, id, version_created, modified_by FROM diagnosis_masters_revs WHERE diagnosis_control_id IN(SELECT id FROM diagnosis_controls WHERE controls_type LIKE 'cap report - %'));

UPDATE event_masters_revs AS rev
INNER JOIN event_masters AS em ON rev.tmp_old_dx_id=em.tmp_old_dx_id
SET rev.id=em.id, rev.event_control_id=em.event_control_id
WHERE rev.tmp_old_dx_id IS NOT NULL;


UPDATE dxd_cap_report_smintestines AS cap INNER JOIN event_masters AS em ON cap.event_master_id=em.tmp_old_dx_id SET cap.event_master_id=em.id;
UPDATE dxd_cap_report_perihilarbileducts AS cap INNER JOIN event_masters AS em ON cap.event_master_id=em.tmp_old_dx_id SET cap.event_master_id=em.id;
UPDATE dxd_cap_report_pancreasexos AS cap INNER JOIN event_masters AS em ON cap.event_master_id=em.tmp_old_dx_id SET cap.event_master_id=em.id;
UPDATE dxd_cap_report_intrahepbileducts AS cap INNER JOIN event_masters AS em ON cap.event_master_id=em.tmp_old_dx_id SET cap.event_master_id=em.id;
UPDATE dxd_cap_report_hepatocellular_carcinomas AS cap INNER JOIN event_masters AS em ON cap.event_master_id=em.tmp_old_dx_id SET cap.event_master_id=em.id;
UPDATE dxd_cap_report_gallbladders AS cap INNER JOIN event_masters AS em ON cap.event_master_id=em.tmp_old_dx_id SET cap.event_master_id=em.id;
UPDATE dxd_cap_report_distalexbileducts AS cap INNER JOIN event_masters AS em ON cap.event_master_id=em.tmp_old_dx_id SET cap.event_master_id=em.id;
UPDATE dxd_cap_report_colon_biopsies AS cap INNER JOIN event_masters AS em ON cap.event_master_id=em.tmp_old_dx_id SET cap.event_master_id=em.id;
UPDATE dxd_cap_report_ampullas AS cap INNER JOIN event_masters AS em ON cap.event_master_id=em.tmp_old_dx_id SET cap.event_master_id=em.id;
UPDATE dxd_cap_report_colon_rectum_resections AS cap INNER JOIN event_masters AS em ON cap.event_master_id=em.tmp_old_dx_id SET cap.event_master_id=em.id;
UPDATE dxd_cap_report_pancreasendos AS cap INNER JOIN event_masters AS em ON cap.event_master_id=em.tmp_old_dx_id SET cap.event_master_id=em.id;

UPDATE dxd_cap_report_smintestines_revs AS cap INNER JOIN event_masters AS em ON cap.event_master_id=em.tmp_old_dx_id SET cap.event_master_id=em.id;
UPDATE dxd_cap_report_perihilarbileducts_revs AS cap INNER JOIN event_masters AS em ON cap.event_master_id=em.tmp_old_dx_id SET cap.event_master_id=em.id;
UPDATE dxd_cap_report_pancreasexos_revs AS cap INNER JOIN event_masters AS em ON cap.event_master_id=em.tmp_old_dx_id SET cap.event_master_id=em.id;
UPDATE dxd_cap_report_intrahepbileducts_revs AS cap INNER JOIN event_masters AS em ON cap.event_master_id=em.tmp_old_dx_id SET cap.event_master_id=em.id;
UPDATE dxd_cap_report_hepatocellular_carcinomas_revs AS cap INNER JOIN event_masters AS em ON cap.event_master_id=em.tmp_old_dx_id SET cap.event_master_id=em.id;
UPDATE dxd_cap_report_gallbladders_revs AS cap INNER JOIN event_masters AS em ON cap.event_master_id=em.tmp_old_dx_id SET cap.event_master_id=em.id;
UPDATE dxd_cap_report_distalexbileducts_revs AS cap INNER JOIN event_masters AS em ON cap.event_master_id=em.tmp_old_dx_id SET cap.event_master_id=em.id;
UPDATE dxd_cap_report_colon_biopsies_revs AS cap INNER JOIN event_masters AS em ON cap.event_master_id=em.tmp_old_dx_id SET cap.event_master_id=em.id;
UPDATE dxd_cap_report_ampullas_revs AS cap INNER JOIN event_masters AS em ON cap.event_master_id=em.tmp_old_dx_id SET cap.event_master_id=em.id;
UPDATE dxd_cap_report_colon_rectum_resections_revs AS cap INNER JOIN event_masters AS em ON cap.event_master_id=em.tmp_old_dx_id SET cap.event_master_id=em.id;
UPDATE dxd_cap_report_pancreasendos_revs AS cap INNER JOIN event_masters AS em ON cap.event_master_id=em.tmp_old_dx_id SET cap.event_master_id=em.id; 

DELETE FROM diagnosis_masters WHERE id IN(SELECT old_dx_id FROM event_masters_tmp); 
DELETE FROM diagnosis_masters_revs WHERE id IN(SELECT old_dx_id FROM event_masters_tmp); 

DROP TABLE event_masters_tmp;
ALTER TABLE event_masters
 DROP COLUMN tmp_old_dx_id;
ALTER TABLE event_masters_revs
 DROP COLUMN tmp_old_dx_id;

ALTER TABLE dxd_cap_report_smintestines
 ADD FOREIGN KEY (event_master_id) REFERENCES event_masters(id);
ALTER TABLE dxd_cap_report_perihilarbileducts
 ADD FOREIGN KEY (event_master_id) REFERENCES event_masters(id);
ALTER TABLE dxd_cap_report_pancreasexos
 ADD FOREIGN KEY (event_master_id) REFERENCES event_masters(id);
ALTER TABLE dxd_cap_report_intrahepbileducts
 ADD FOREIGN KEY (event_master_id) REFERENCES event_masters(id);
ALTER TABLE dxd_cap_report_hepatocellular_carcinomas
 ADD FOREIGN KEY (event_master_id) REFERENCES event_masters(id);
ALTER TABLE dxd_cap_report_gallbladders
 ADD FOREIGN KEY (event_master_id) REFERENCES event_masters(id);
ALTER TABLE dxd_cap_report_distalexbileducts
 ADD FOREIGN KEY (event_master_id) REFERENCES event_masters(id);
ALTER TABLE dxd_cap_report_colon_biopsies
 ADD FOREIGN KEY (event_master_id) REFERENCES event_masters(id);
ALTER TABLE dxd_cap_report_ampullas
 ADD FOREIGN KEY (event_master_id) REFERENCES event_masters(id);
ALTER TABLE dxd_cap_report_colon_rectum_resections
 ADD FOREIGN KEY (event_master_id) REFERENCES event_masters(id);
ALTER TABLE dxd_cap_report_pancreasendos
 ADD FOREIGN KEY (event_master_id) REFERENCES event_masters(id);


RENAME TABLE dxd_cap_report_smintestines TO ed_cap_report_smintestines;
RENAME TABLE dxd_cap_report_perihilarbileducts TO ed_cap_report_perihilarbileducts;
RENAME TABLE dxd_cap_report_pancreasexos TO ed_cap_report_pancreasexos;
RENAME TABLE dxd_cap_report_intrahepbileducts TO ed_cap_report_intrahepbileducts;
RENAME TABLE dxd_cap_report_hepatocellular_carcinomas TO ed_cap_report_hepatocellular_carcinomas;
RENAME TABLE dxd_cap_report_gallbladders TO ed_cap_report_gallbladders;
RENAME TABLE dxd_cap_report_distalexbileducts TO ed_cap_report_distalexbileducts;
RENAME TABLE dxd_cap_report_colon_biopsies TO ed_cap_report_colon_biopsies;
RENAME TABLE dxd_cap_report_ampullas TO ed_cap_report_ampullas;
RENAME TABLE dxd_cap_report_colon_rectum_resections TO ed_cap_report_colon_rectum_resections;
RENAME TABLE dxd_cap_report_pancreasendos TO ed_cap_report_pancreasendos;

RENAME TABLE dxd_cap_report_smintestines_revs TO ed_cap_report_smintestines_revs;
RENAME TABLE dxd_cap_report_perihilarbileducts_revs TO ed_cap_report_perihilarbileducts_revs;
RENAME TABLE dxd_cap_report_pancreasexos_revs TO ed_cap_report_pancreasexos_revs;
RENAME TABLE dxd_cap_report_intrahepbileducts_revs TO ed_cap_report_intrahepbileducts_revs;
RENAME TABLE dxd_cap_report_hepatocellular_carcinomas_revs TO ed_cap_report_hepatocellular_carcinomas_revs;
RENAME TABLE dxd_cap_report_gallbladders_revs TO ed_cap_report_gallbladders_revs;
RENAME TABLE dxd_cap_report_distalexbileducts_revs TO ed_cap_report_distalexbileducts_revs;
RENAME TABLE dxd_cap_report_colon_biopsies_revs TO ed_cap_report_colon_biopsies_revs;
RENAME TABLE dxd_cap_report_ampullas_revs TO ed_cap_report_ampullas_revs;
RENAME TABLE dxd_cap_report_colon_rectum_resections_revs TO ed_cap_report_colon_rectum_resections_revs;
RENAME TABLE dxd_cap_report_pancreasendos_revs TO ed_cap_report_pancreasendos_revs;

UPDATE structure_fields SET model='EventDetail', tablename=REPLACE(tablename, 'dxd_cap_', 'ed_cap_') WHERE tablename='dxd_cap_report_smintestines';
UPDATE structure_fields SET model='EventDetail', tablename=REPLACE(tablename, 'dxd_cap_', 'ed_cap_') WHERE tablename='dxd_cap_report_perihilarbileducts';
UPDATE structure_fields SET model='EventDetail', tablename=REPLACE(tablename, 'dxd_cap_', 'ed_cap_') WHERE tablename='dxd_cap_report_pancreasexos';
UPDATE structure_fields SET model='EventDetail', tablename=REPLACE(tablename, 'dxd_cap_', 'ed_cap_') WHERE tablename='dxd_cap_report_intrahepbileducts';
UPDATE structure_fields SET model='EventDetail', tablename=REPLACE(tablename, 'dxd_cap_', 'ed_cap_') WHERE tablename='dxd_cap_report_hepatocellular_carcinomas';
UPDATE structure_fields SET model='EventDetail', tablename=REPLACE(tablename, 'dxd_cap_', 'ed_cap_') WHERE tablename='dxd_cap_report_gallbladders';
UPDATE structure_fields SET model='EventDetail', tablename=REPLACE(tablename, 'dxd_cap_', 'ed_cap_') WHERE tablename='dxd_cap_report_distalexbileducts';
UPDATE structure_fields SET model='EventDetail', tablename=REPLACE(tablename, 'dxd_cap_', 'ed_cap_') WHERE tablename='dxd_cap_report_colon_biopsies';
UPDATE structure_fields SET model='EventDetail', tablename=REPLACE(tablename, 'dxd_cap_', 'ed_cap_') WHERE tablename='dxd_cap_report_ampullas';
UPDATE structure_fields SET model='EventDetail', tablename=REPLACE(tablename, 'dxd_cap_', 'ed_cap_') WHERE tablename='dxd_cap_report_colon_rectum_resections';
UPDATE structure_fields SET model='EventDetail', tablename=REPLACE(tablename, 'dxd_cap_', 'ed_cap_') WHERE tablename='dxd_cap_report_pancreasendos';

UPDATE structures SET alias=REPLACE(alias, 'dx_cap_', 'ed_cap_') WHERE alias='dx_cap_report_smintestines';
UPDATE structures SET alias=REPLACE(alias, 'dx_cap_', 'ed_cap_') WHERE alias='dx_cap_report_perihilarbileducts';
UPDATE structures SET alias=REPLACE(alias, 'dx_cap_', 'ed_cap_') WHERE alias='dx_cap_report_pancreasexos';
UPDATE structures SET alias=REPLACE(alias, 'dx_cap_', 'ed_cap_') WHERE alias='dx_cap_report_intrahepbileducts';
UPDATE structures SET alias=REPLACE(alias, 'dx_cap_', 'ed_cap_') WHERE alias='dx_cap_report_hepatocellular_carcinomas';
UPDATE structures SET alias=REPLACE(alias, 'dx_cap_', 'ed_cap_') WHERE alias='dx_cap_report_gallbladders';
UPDATE structures SET alias=REPLACE(alias, 'dx_cap_', 'ed_cap_') WHERE alias='dx_cap_report_distalexbileducts';
UPDATE structures SET alias=REPLACE(alias, 'dx_cap_', 'ed_cap_') WHERE alias='dx_cap_report_colon_biopsies';
UPDATE structures SET alias=REPLACE(alias, 'dx_cap_', 'ed_cap_') WHERE alias='dx_cap_report_ampullas';
UPDATE structures SET alias=REPLACE(alias, 'dx_cap_', 'ed_cap_') WHERE alias='dx_cap_report_colon_rectum_resections';
UPDATE structures SET alias=REPLACE(alias, 'dx_cap_', 'ed_cap_') WHERE alias='dx_cap_report_pancreasendos';

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'EventDetail', '', 'tumor_size_greatest_dimension', 'float', NULL, 0, '', '', '', 'tumor size greatest dimension (cm)', ''), 
('Clinicalannotation', 'EventDetail', '', 'additional_dimension_a', 'float', NULL, 0, '', '', '', 'additional dimension (cm)', ''), 
('Clinicalannotation', 'EventDetail', '', 'additional_dimension_b', 'float', NULL, 0, '', '', '', '', 'x'), 
('Clinicalannotation', 'EventDetail', '', 'tumor_size_cannot_be_determined', 'checkbox', NULL, 0, '', '', '', 'cannot be determined', ''), 
('Clinicalannotation', 'EventDetail', '', 'notes', 'textarea', NULL, 0, 'cols=40, rows=6', '', '', 'notes', ''), 
('Clinicalannotation', 'EventDetail', '', 'tumour_grade', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='histologic_grade_c'), 0, '', '', '', 'histologic grade', ''),
('Clinicalannotation', 'EventDetail', '', 'tumour_grade_specify', 'input', NULL, 0, '', '', '', 'histologic grade specify', ''), 
('Clinicalannotation', 'EventDetail', '', 'path_tnm_descriptor_m', 'yes_no', NULL, 0, '', '', '', 'tnm descriptors', 'multiple primary tumors'), 
('Clinicalannotation', 'EventDetail', '', 'path_tnm_descriptor_r', 'yes_no', NULL, 0, '', '', '', '', 'recurrent'), 
('Clinicalannotation', 'EventDetail', '', 'path_tnm_descriptor_y', 'yes_no', NULL, 0, '', '', '', '', 'post treatment'), 
('Clinicalannotation', 'EventDetail', '', 'path_tstage', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='path_tstage_sm'), 0, '', '', '', 'path tstage', ''), 
('Clinicalannotation', 'EventDetail', '', 'path_nstage', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='path_nstage_sm'), 0, '', '', '', 'path nstage', ''), 
('Clinicalannotation', 'EventDetail', '', 'path_nstage_nbr_node_examined', 'integer', NULL, 0, '', '', '', 'number node examined', ''), 
('Clinicalannotation', 'EventDetail', '', 'path_nstage_nbr_node_involved', 'integer', NULL, 0, '', '', '', 'number node involved', ''), 
('Clinicalannotation', 'EventDetail', '', 'path_mstage', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='path_mstage_sm'), 0, '', '', '', 'path mstage', ''), 
('Clinicalannotation', 'EventDetail', '', 'path_mstage_metastasis_site_specify', 'input', NULL, 0, '', '', '', 'metastasis site specify', ''); 

UPDATE structure_formats SET structure_field_id=(SELECT id FROM structure_fields WHERE model="EventDetail" AND field="additional_dimension_a") WHERE structure_field_id=(SELECT id FROM structure_fields WHERE model="DiagnosisMaster" AND field="additional_dimension_a") AND structure_id IN(SELECT id FROM structures WHERE alias IN("ed_cap_report_smintestines", "ed_cap_report_perihilarbileducts", "ed_cap_report_pancreasexos", "ed_cap_report_intrahepbileducts", "ed_cap_report_hepatocellular_carcinomas", "ed_cap_report_gallbladders", "ed_cap_report_distalexbileducts", "ed_cap_report_colon_biopsies", "ed_cap_report_ampullas", "ed_cap_report_colon_rectum_resections", "ed_cap_report_pancreasendos"));
UPDATE structure_formats SET structure_field_id=(SELECT id FROM structure_fields WHERE model="EventDetail" AND field="additional_dimension_b") WHERE structure_field_id=(SELECT id FROM structure_fields WHERE model="DiagnosisMaster" AND field="additional_dimension_b") AND structure_id IN(SELECT id FROM structures WHERE alias IN("ed_cap_report_smintestines", "ed_cap_report_perihilarbileducts", "ed_cap_report_pancreasexos", "ed_cap_report_intrahepbileducts", "ed_cap_report_hepatocellular_carcinomas", "ed_cap_report_gallbladders", "ed_cap_report_distalexbileducts", "ed_cap_report_colon_biopsies", "ed_cap_report_ampullas", "ed_cap_report_colon_rectum_resections", "ed_cap_report_pancreasendos"));
UPDATE structure_formats SET structure_field_id=(SELECT id FROM structure_fields WHERE model="EventDetail" AND field="notes") WHERE structure_field_id=(SELECT id FROM structure_fields WHERE model="DiagnosisMaster" AND field="notes") AND structure_id IN(SELECT id FROM structures WHERE alias IN("ed_cap_report_smintestines", "ed_cap_report_perihilarbileducts", "ed_cap_report_pancreasexos", "ed_cap_report_intrahepbileducts", "ed_cap_report_hepatocellular_carcinomas", "ed_cap_report_gallbladders", "ed_cap_report_distalexbileducts", "ed_cap_report_colon_biopsies", "ed_cap_report_ampullas", "ed_cap_report_colon_rectum_resections", "ed_cap_report_pancreasendos"));
UPDATE structure_formats SET structure_field_id=(SELECT id FROM structure_fields WHERE model="EventDetail" AND field="path_mstage") WHERE structure_field_id IN(SELECT id FROM structure_fields WHERE model="DiagnosisMaster" AND field="path_mstage") AND structure_id IN(SELECT id FROM structures WHERE alias IN("ed_cap_report_smintestines", "ed_cap_report_perihilarbileducts", "ed_cap_report_pancreasexos", "ed_cap_report_intrahepbileducts", "ed_cap_report_hepatocellular_carcinomas", "ed_cap_report_gallbladders", "ed_cap_report_distalexbileducts", "ed_cap_report_colon_biopsies", "ed_cap_report_ampullas", "ed_cap_report_colon_rectum_resections", "ed_cap_report_pancreasendos"));
UPDATE structure_formats SET structure_field_id=(SELECT id FROM structure_fields WHERE model="EventDetail" AND field="path_mstage_metastasis_site_specify") WHERE structure_field_id=(SELECT id FROM structure_fields WHERE model="DiagnosisMaster" AND field="path_mstage_metastasis_site_specify") AND structure_id IN(SELECT id FROM structures WHERE alias IN("ed_cap_report_smintestines", "ed_cap_report_perihilarbileducts", "ed_cap_report_pancreasexos", "ed_cap_report_intrahepbileducts", "ed_cap_report_hepatocellular_carcinomas", "ed_cap_report_gallbladders", "ed_cap_report_distalexbileducts", "ed_cap_report_colon_biopsies", "ed_cap_report_ampullas", "ed_cap_report_colon_rectum_resections", "ed_cap_report_pancreasendos"));
UPDATE structure_formats SET structure_field_id=(SELECT id FROM structure_fields WHERE model="EventDetail" AND field="path_nstage") WHERE structure_field_id IN(SELECT id FROM structure_fields WHERE model="DiagnosisMaster" AND field="path_nstage") AND structure_id IN(SELECT id FROM structures WHERE alias IN("ed_cap_report_smintestines", "ed_cap_report_perihilarbileducts", "ed_cap_report_pancreasexos", "ed_cap_report_intrahepbileducts", "ed_cap_report_hepatocellular_carcinomas", "ed_cap_report_gallbladders", "ed_cap_report_distalexbileducts", "ed_cap_report_colon_biopsies", "ed_cap_report_ampullas", "ed_cap_report_colon_rectum_resections", "ed_cap_report_pancreasendos"));
UPDATE structure_formats SET structure_field_id=(SELECT id FROM structure_fields WHERE model="EventDetail" AND field="path_nstage_nbr_node_examined") WHERE structure_field_id IN(SELECT id FROM structure_fields WHERE model="DiagnosisMaster" AND field="path_nstage_nbr_node_examined") AND structure_id IN(SELECT id FROM structures WHERE alias IN("ed_cap_report_smintestines", "ed_cap_report_perihilarbileducts", "ed_cap_report_pancreasexos", "ed_cap_report_intrahepbileducts", "ed_cap_report_hepatocellular_carcinomas", "ed_cap_report_gallbladders", "ed_cap_report_distalexbileducts", "ed_cap_report_colon_biopsies", "ed_cap_report_ampullas", "ed_cap_report_colon_rectum_resections", "ed_cap_report_pancreasendos"));
UPDATE structure_formats SET structure_field_id=(SELECT id FROM structure_fields WHERE model="EventDetail" AND field="path_nstage_nbr_node_involved") WHERE structure_field_id IN(SELECT id FROM structure_fields WHERE model="DiagnosisMaster" AND field="path_nstage_nbr_node_involved") AND structure_id IN(SELECT id FROM structures WHERE alias IN("ed_cap_report_smintestines", "ed_cap_report_perihilarbileducts", "ed_cap_report_pancreasexos", "ed_cap_report_intrahepbileducts", "ed_cap_report_hepatocellular_carcinomas", "ed_cap_report_gallbladders", "ed_cap_report_distalexbileducts", "ed_cap_report_colon_biopsies", "ed_cap_report_ampullas", "ed_cap_report_colon_rectum_resections", "ed_cap_report_pancreasendos"));
UPDATE structure_formats SET structure_field_id=(SELECT id FROM structure_fields WHERE model="EventDetail" AND field="path_tnm_descriptor_m") WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE model="DiagnosisMaster" AND field="path_tnm_descriptor_m") AND structure_id IN(SELECT id FROM structures WHERE alias IN("ed_cap_report_smintestines", "ed_cap_report_perihilarbileducts", "ed_cap_report_pancreasexos", "ed_cap_report_intrahepbileducts", "ed_cap_report_hepatocellular_carcinomas", "ed_cap_report_gallbladders", "ed_cap_report_distalexbileducts", "ed_cap_report_colon_biopsies", "ed_cap_report_ampullas", "ed_cap_report_colon_rectum_resections", "ed_cap_report_pancreasendos"));
UPDATE structure_formats SET structure_field_id=(SELECT id FROM structure_fields WHERE model="EventDetail" AND field="path_tnm_descriptor_r") WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE model="DiagnosisMaster" AND field="path_tnm_descriptor_r") AND structure_id IN(SELECT id FROM structures WHERE alias IN("ed_cap_report_smintestines", "ed_cap_report_perihilarbileducts", "ed_cap_report_pancreasexos", "ed_cap_report_intrahepbileducts", "ed_cap_report_hepatocellular_carcinomas", "ed_cap_report_gallbladders", "ed_cap_report_distalexbileducts", "ed_cap_report_colon_biopsies", "ed_cap_report_ampullas", "ed_cap_report_colon_rectum_resections", "ed_cap_report_pancreasendos"));
UPDATE structure_formats SET structure_field_id=(SELECT id FROM structure_fields WHERE model="EventDetail" AND field="path_tnm_descriptor_y") WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE model="DiagnosisMaster" AND field="path_tnm_descriptor_y") AND structure_id IN(SELECT id FROM structures WHERE alias IN("ed_cap_report_smintestines", "ed_cap_report_perihilarbileducts", "ed_cap_report_pancreasexos", "ed_cap_report_intrahepbileducts", "ed_cap_report_hepatocellular_carcinomas", "ed_cap_report_gallbladders", "ed_cap_report_distalexbileducts", "ed_cap_report_colon_biopsies", "ed_cap_report_ampullas", "ed_cap_report_colon_rectum_resections", "ed_cap_report_pancreasendos"));
UPDATE structure_formats SET structure_field_id=(SELECT id FROM structure_fields WHERE model="EventDetail" AND field="path_tstage") WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE model="DiagnosisMaster" AND field="path_tstage") AND structure_id IN(SELECT id FROM structures WHERE alias IN("ed_cap_report_smintestines", "ed_cap_report_perihilarbileducts", "ed_cap_report_pancreasexos", "ed_cap_report_intrahepbileducts", "ed_cap_report_hepatocellular_carcinomas", "ed_cap_report_gallbladders", "ed_cap_report_distalexbileducts", "ed_cap_report_colon_biopsies", "ed_cap_report_ampullas", "ed_cap_report_colon_rectum_resections", "ed_cap_report_pancreasendos"));
UPDATE structure_formats SET structure_field_id=(SELECT id FROM structure_fields WHERE model="EventDetail" AND field="tumor_size_cannot_be_determined") WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE model="DiagnosisMaster" AND field="tumor_size_cannot_be_determined") AND structure_id IN(SELECT id FROM structures WHERE alias IN("ed_cap_report_smintestines", "ed_cap_report_perihilarbileducts", "ed_cap_report_pancreasexos", "ed_cap_report_intrahepbileducts", "ed_cap_report_hepatocellular_carcinomas", "ed_cap_report_gallbladders", "ed_cap_report_distalexbileducts", "ed_cap_report_colon_biopsies", "ed_cap_report_ampullas", "ed_cap_report_colon_rectum_resections", "ed_cap_report_pancreasendos"));
UPDATE structure_formats SET structure_field_id=(SELECT id FROM structure_fields WHERE model="EventDetail" AND field="tumor_size_greatest_dimension") WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE model="DiagnosisMaster" AND field="tumor_size_greatest_dimension") AND structure_id IN(SELECT id FROM structures WHERE alias IN("ed_cap_report_smintestines", "ed_cap_report_perihilarbileducts", "ed_cap_report_pancreasexos", "ed_cap_report_intrahepbileducts", "ed_cap_report_hepatocellular_carcinomas", "ed_cap_report_gallbladders", "ed_cap_report_distalexbileducts", "ed_cap_report_colon_biopsies", "ed_cap_report_ampullas", "ed_cap_report_colon_rectum_resections", "ed_cap_report_pancreasendos"));
UPDATE structure_formats SET structure_field_id=(SELECT id FROM structure_fields WHERE model="EventDetail" AND field="tumour_grade") WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE model="DiagnosisMaster" AND field="tumour_grade") AND structure_id IN(SELECT id FROM structures WHERE alias IN("ed_cap_report_smintestines", "ed_cap_report_perihilarbileducts", "ed_cap_report_pancreasexos", "ed_cap_report_intrahepbileducts", "ed_cap_report_hepatocellular_carcinomas", "ed_cap_report_gallbladders", "ed_cap_report_distalexbileducts", "ed_cap_report_colon_biopsies", "ed_cap_report_ampullas", "ed_cap_report_colon_rectum_resections", "ed_cap_report_pancreasendos"));
UPDATE structure_formats SET structure_field_id=(SELECT id FROM structure_fields WHERE model="EventDetail" AND field="tumour_grade_specify") WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE model="DiagnosisMaster" AND field="tumour_grade_specify") AND structure_id IN(SELECT id FROM structures WHERE alias IN("ed_cap_report_smintestines", "ed_cap_report_perihilarbileducts", "ed_cap_report_pancreasexos", "ed_cap_report_intrahepbileducts", "ed_cap_report_hepatocellular_carcinomas", "ed_cap_report_gallbladders", "ed_cap_report_distalexbileducts", "ed_cap_report_colon_biopsies", "ed_cap_report_ampullas", "ed_cap_report_colon_rectum_resections", "ed_cap_report_pancreasendos"));
UPDATE structure_formats SET structure_field_id=(SELECT id FROM structure_fields WHERE model="EventMaster" AND field="event_date") WHERE structure_field_id=(SELECT id FROM structure_fields WHERE model="DiagnosisMaster" AND field="dx_date") AND structure_id IN(SELECT id FROM structures WHERE alias IN("ed_cap_report_smintestines", "ed_cap_report_perihilarbileducts", "ed_cap_report_pancreasexos", "ed_cap_report_intrahepbileducts", "ed_cap_report_hepatocellular_carcinomas", "ed_cap_report_gallbladders", "ed_cap_report_distalexbileducts", "ed_cap_report_colon_biopsies", "ed_cap_report_ampullas", "ed_cap_report_colon_rectum_resections", "ed_cap_report_pancreasendos"));
#fields to validate: path_mstage, path_nstage, path_tstage, tumour_grade

UPDATE menus SET flag_active=0 WHERE id='inv_CAN_22';
UPDATE menus SET flag_active=0 WHERE id='inv_CAN_23';

UPDATE menus SET use_link='/clinicalannotation/participants/search/' WHERE id='clin_CAN_1';
UPDATE menus SET use_link='/storagelayout/storage_masters/search/' WHERE id='sto_CAN_01';
UPDATE menus SET use_link='/order/orders/search/' WHERE id='ord_CAN_101';
UPDATE menus SET use_link='/protocol/protocol_masters/search/' WHERE id='proto_CAN_37';
UPDATE menus SET use_link='/drug/drugs/search/' WHERE id='drug_CAN_96';
UPDATE menus SET use_link='/inventorymanagement/collections/search' WHERE id='inv_CAN';
UPDATE menus SET use_link='/labbook/lab_book_masters/search/' WHERE id='procd_CAN_01';

DELETE FROM menus WHERE use_link IN ('/inventorymanagement/aliquots/detail/', '/inventorymanagement/boxes/listall/', '/inventorymanagement/shelves/listall/', '/inventorymanagement/towers/listall/');

ALTER TABLE specimen_review_controls
 DROP COLUMN specimen_sample_type;
 
UPDATE structure_fields SET field = 'sample_control_id' WHERE model = 'SpecimenReviewControl' AND field = 'specimen_sample_type';

UPDATE `menus` SET `flag_active` = '0' WHERE `menus`.`id` = 'inv_CAN_223' LIMIT 1 ;
UPDATE `menus` SET `flag_active` = '0' WHERE `menus`.`id` = 'inv_CAN_2223' LIMIT 1 ;
UPDATE menus SET parent_id = 'inv_CAN_221' WHERE id IN ('inv_CAN_2231', 'inv_CAN_2233');
UPDATE menus SET parent_id = 'inv_CAN_2221' WHERE id IN ('inv_CAN_22233', 'inv_CAN_22231');

DELETE FROM menus WHERE id IN ('inv_CAN_223', 'inv_CAN_2223', 'inv_CAN_22', 'inv_CAN_23');

UPDATE menus SET language_title = 'collection content - tree view' WHERE id = 'inv_CAN_21';
UPDATE menus SET language_title = 'specimen details and aliquots' WHERE id = 'inv_CAN_221';
UPDATE menus SET language_title = 'derivative details and aliquots' WHERE id = 'inv_CAN_2221';

REPLACE INTO i18n (id,en,fr) VALUES
('collection content - tree view', 'Samples & Aliquots', 'Échantillons & Aliquots'),
('specimen details and aliquots', 'Details & Aliquots', 'Détails & Aliquots'),
('derivative details and aliquots', 'Details & Aliquots', 'Détails & Aliquots');

UPDATE structure_formats SET `flag_add`='1', `flag_edit`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='template') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Template' AND `tablename`='templates' AND `field`='name' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

ALTER TABLE template_nodes
 ADD COLUMN quantity TINYINT UNSIGNED NOT NULL DEFAULT 1;

ALTER TABLE templates
 ADD COLUMN owner VARCHAR(10) NOT NULL DEFAULT 'user',
 ADD COLUMN visibility VARCHAR(10) NOT NULL DEFAULT 'user',
 ADD COLUMN flag_active BOOLEAN NOT NULL DEFAULT true,
 ADD COLUMN owning_entity_id INT UNSIGNED DEFAULT NULL;
ALTER TABLE templates  
 ADD COLUMN visible_entity_id INT UNSIGNED DEFAULT NULL; 
 
INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('sharing', '', '', null);
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("user", "user");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="sharing"),  (SELECT id FROM structure_permissible_values WHERE value="user" AND language_alias="user"), "1", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("bank", "bank");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="sharing"),  (SELECT id FROM structure_permissible_values WHERE value="bank" AND language_alias="bank"), "2", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("all", "all");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="sharing"),  (SELECT id FROM structure_permissible_values WHERE value="all" AND language_alias="all"), "3", "1");

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Tool', 'Template', 'templates', 'owner', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='sharing') , '0', '', 'user', '', 'owner', ''), 
('Tool', 'Template', 'templates', 'visibility', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='sharing') , '0', '', 'user', '', 'visibility', ''), 
('Tool', 'Template', 'templates', 'flag_active', 'checkbox',  NULL , '0', '', '1', '', 'active', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='template'), (SELECT id FROM structure_fields WHERE `model`='Template' AND `tablename`='templates' AND `field`='owner' ), '1', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='template'), (SELECT id FROM structure_fields WHERE `model`='Template' AND `tablename`='templates' AND `field`='visibility'), '1', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='template'), (SELECT id FROM structure_fields WHERE `model`='Template' AND `tablename`='templates' AND `field`='flag_active'), '1', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');

INSERT INTO structure_validations
(structure_field_id, rule, on_action, language_message) VALUES
((SELECT id FROM structure_fields WHERE `model`='Template' AND `tablename`='templates' AND `field`='owner'), 'notEmpty', '', ''),
((SELECT id FROM structure_fields WHERE `model`='Template' AND `tablename`='templates' AND `field`='visibility'), 'notEmpty', '', '');

REPLACE INTO i18n (id,en,fr) VALUES 
('default values', 'Default Values', 'Valeurs par défaut'),
('samples and aliquots creation from template','Samples and Aliquots Creation from Template', 'Création échantillons et aliquots selon modèle'),
('add from template', 'Add From Template', 'Créer selon modèle'),
('participant data', 'Participant Data', 'Données participant');

REPLACE INTO i18n (id,en,fr) VALUES 
('specimen details and aliquots', 'Specimen Details & Aliquots', 'Détails spécimen & Aliquots'),
('derivative details and aliquots', 'Derivative Details & Aliquots', 'Détails dérivé & Aliquots');

UPDATE storage_controls SET set_temperature = '1' WHERE set_temperature = 'TRUE';
UPDATE storage_controls SET set_temperature = '0' WHERE set_temperature != '1';

UPDATE storage_controls SET is_tma_block = '1' WHERE is_tma_block = 'TRUE';
UPDATE storage_controls SET is_tma_block = '0' WHERE is_tma_block != '1';

ALTER TABLE storage_controls
  MODIFY `is_tma_block` tinyint(1) NOT NULL DEFAULT '0',
  MODIFY `set_temperature` tinyint(1) NOT NULL DEFAULT '0';
  
INSERT INTO structures(`alias`) VALUES ('used_aliq_in_stock_details');
INSERT INTO structures(`alias`) VALUES ('used_aliq_in_stock_detail_volume');

DELETE FROM structure_formats WHERE structure_id = (SELECT id FROM structures WHERE alias='used_aliq_in_stock_details');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='used_aliq_in_stock_details'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='barcode' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='' AND `language_label`='barcode' AND `language_tag`=''), '0', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='used_aliq_in_stock_details'), (SELECT id FROM structure_fields WHERE `model`='AliquotControl' AND `tablename`='aliquot_controls' AND `field`='aliquot_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_type')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='aliquot type' AND `language_tag`=''), '0', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='used_aliq_in_stock_details'), (SELECT id FROM structure_fields WHERE `model`='StorageMaster' AND `tablename`='storage_masters' AND `field`='selection_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '0', '3', '', '0', '', '0', '', '1', '', '0', '', '1', '', '0', '', '0', '0', '1', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='used_aliq_in_stock_details'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='storage_coord_x' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '0', '4', '', '1', '', '1', 'position', '0', '', '0', '', '1', '', '0', '', '0', '0', '1', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='used_aliq_in_stock_details'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='storage_coord_y' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '0', '5', '', '0', '', '1', '-', '0', '', '0', '', '1', '', '0', '', '0', '0', '1', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='used_aliq_in_stock_details'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='in_stock' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_in_stock_values')  AND `flag_confidential`='0'), '1', '14', '', '1', 'new in stock value', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='used_aliq_in_stock_details'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='in_stock_detail' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_in_stock_detail')  AND `flag_confidential`='0'), '1', '15', '', '1', 'new in stock reason', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='used_aliq_in_stock_details'), (SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='remove_from_storage' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='remove_from_storage_help' AND `language_label`='remove' AND `language_tag`=''), '1', '17', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='used_aliq_in_stock_details'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='aliquot_label' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='aliquot label' AND `language_tag`=''), '0', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='used_aliq_in_stock_details'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='collection_id' AND `type`='hidden' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`=''), '0', '9000', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='used_aliq_in_stock_details'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='sample_master_id' AND `type`='hidden' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`=''), '0', '9000', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');

DELETE FROM structure_formats WHERE structure_id = (SELECT id FROM structures WHERE alias='used_aliq_in_stock_detail_volume');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='used_aliq_in_stock_detail_volume'), (SELECT id FROM structure_fields WHERE `model`='AliquotControl' AND `tablename`='aliquot_controls' AND `field`='volume_unit' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_volume_unit')  AND `flag_confidential`='0'), '0', '11', '', '1', 'volume unit', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='used_aliq_in_stock_detail_volume'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='current_volume' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '0', '10', '', '0', '', '0', '', '0', '', '0', '', '1', '', '0', '', '0', '0', '1', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');

UPDATE structure_formats SET `display_order`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='realiquotedparent') AND structure_field_id IN (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='aliquot_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='sourcealiquots') AND structure_field_id IN (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='aliquot_label');
UPDATE structure_formats SET `flag_override_label`='0', `language_label`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='sourcealiquots_volume') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotControl' AND `tablename`='aliquot_controls' AND `field`='volume_unit');
UPDATE structure_formats SET `display_order`='11' WHERE structure_id=(SELECT id FROM structures WHERE alias='sourcealiquots') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='use' );
UPDATE structure_formats SET `display_order`='12' WHERE structure_id=(SELECT id FROM structures WHERE alias='sourcealiquots_volume') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SourceAliquot' AND `tablename`='source_aliquots' AND `field`='used_volume');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='sourcealiquots_volume'), (SELECT id FROM structure_fields WHERE `model`='AliquotControl' AND `tablename`='aliquot_controls' AND `field`='volume_unit' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_volume_unit')  AND `flag_confidential`='0'), '0', '13', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '1', '0', '0', '1', '1', '1', '1', '0', '0', '1', '0', '1');

UPDATE structure_formats SET `flag_override_label`='1', `language_label`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='viewaliquotuses') AND structure_field_id IN (SELECT id FROM structure_fields WHERE `field`='aliquot_volume_unit');

UPDATE structure_formats SET `display_order`='1000' WHERE structure_id=(SELECT id FROM structures WHERE alias='sourcealiquots') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='id' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sourcealiquots') AND structure_field_id IN (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='barcode' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats SET `display_order`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='used_aliq_in_stock_details') AND structure_field_id IN (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='barcode' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='used_aliq_in_stock_details') AND structure_field_id IN (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='aliquot_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='used_aliq_in_stock_details') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='in_stock' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_in_stock_values') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='used_aliq_in_stock_details') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='in_stock_detail' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_in_stock_detail') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='used_aliq_in_stock_details') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='remove_from_storage' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_override_label`='0', `language_label`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='used_aliq_in_stock_detail_volume') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotControl' AND `tablename`='aliquot_controls' AND `field`='volume_unit' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_volume_unit') AND `flag_confidential`='0');

UPDATE structure_formats SET `display_order` = (`display_order` + 1000) WHERE structure_id=(SELECT id FROM structures WHERE alias='realiquot_without_vol');
UPDATE structure_formats SET `display_order` = (`display_order` + 1000) WHERE structure_id=(SELECT id FROM structures WHERE alias='realiquot_with_vol');

REPLACE INTO i18n (id,en,fr) VALUES 
('created children aliquot(s)', 'Children Aliquot(s)', 'Aliquot(s) ''enfant'''),
('parent aliquot (for update)', 'Parent Aliquot (For update)', 'Aliquot ''parent'' (pour mise à jour)');

UPDATE structure_fields SET language_help = 'parent_used_volume_help' WHERE field = 'parent_used_volume';

REPLACE INTO i18n (id,en,fr) VALUES ('parent_used_volume_help', 'Volume of the parent aliquot used to create the children aliquot.', 'Volume de l''aliquot ''parent'' utilisé pour créer l''aliquot ''enfant''.');

UPDATE structure_formats SET `display_order`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='children_aliquots_selection') AND structure_field_id IN (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='barcode' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='children_aliquots_selection') AND structure_field_id IN (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='aliquot_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

REPLACE INTO i18n (id,en,fr) VALUES 
('selected children aliquot(s)', 'Children Aliquot(s)', 'Aliquot(s) ''enfant''');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='children_aliquots_selection'), (SELECT id FROM structure_fields WHERE `model`='StorageMaster' AND `tablename`='storage_masters' AND `field`='selection_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '5', '', '0', '', '0', '', '1', '', '0', '', '1', '', '0', '', 
'0', '0', '0', '0', '0', '0', '1', '1', '1', '1', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='children_aliquots_selection'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='storage_coord_x' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '6', '', '1', '', '1', 'position', '0', '', '0', '', '1', '', '0', '', 
'0', '0', '0', '0', '0', '0', '1', '1', '1', '1', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='children_aliquots_selection'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='storage_coord_y' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '7', '', '0', '', '1', '-', '0', '', '0', '', '1', '', '0', '', 
'0', '0', '0', '0', '0', '0', '1', '1', '1', '1', '0', '0', '0', '0', '0'); 

UPDATE structure_formats SET `flag_override_label`='1', `language_label`='define as source' WHERE structure_id=(SELECT id FROM structures WHERE alias='sourcealiquots') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='use' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') AND `flag_confidential`='0');

REPLACE INTO i18n (id,en,fr) VALUES 
('define as source', 'Define as Source', 'Définir comme source'),
('aliquot internal use code', 'Use Defintion', 'Définition de l''utilisation'), 
('aliquot used volume', 'Used Volume', 'Volume utilisé'),
('used aliquot (for update)', 'Used Aliquot (For update)', 'Aliquot utilisé (pour mise à jour)'),
('internal use creation', 'Internal Use Creation', 'Création utilisation interne');

UPDATE structure_formats SET `display_order`='3' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquotinternaluses_volume') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotInternalUse' AND `tablename`='aliquot_internal_uses' AND `field`='used_volume' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='aliquotinternaluses_volume'), (SELECT id FROM structure_fields WHERE `model`='AliquotControl' AND `tablename`='aliquot_controls' AND `field`='volume_unit' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_volume_unit')  AND `flag_confidential`='0'), '0', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '1', '1', '1', '0', '0', '1', '1', '1', '1', '0', '0', '1', '0', '1');

UPDATE structure_formats SET `flag_detail`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquotinternaluses_volume') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotControl' AND `tablename`='aliquot_controls' AND `field`='volume_unit' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_volume_unit') AND `flag_confidential`='0');

DELETE FROM i18n WHERE id IN ('children creation', 'children selection', 'at least one child has to be defined');
REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
('children creation', 'Children Creation', 'Création des enfants'),
('children selection', 'Children Selection', 'Sélection des enfants'),
('at least one child has to be defined', 'At least one child has not been defined!', 'Au moins un enfant doit être défini!'),
('at least one child has to be created', 'At least one child aliquot has to be created!', 'Au moins un aliquot enfant doit être créé!'),
('define realiquoted children', 'Define Realiquoted Children', 'Définir aliquots enfants'),
('no aliquot has been defined as realiquoted child', 'No aliquot has been defined as realiquoted child!', 'Aucun aliquot n''a été défini comme aliquot enfant!'),
('no new aliquot could be actually defined as realiquoted child for the following parent aliquot(s)', 'No new aliquot could be actually defined as realiquoted child for the following parent aliquot(s)', 'Aucun nouvel aliquot ne peut actuellement être défini comme aliquot enfant pour les aliquots parents suivants'),
('no new sample aliquot could be actually defined as realiquoted child', 'No new sample aliquot could be actually defined as realiquoted child!', 'Aucun nouvel aliquot de l''échantillon ne peut actuellement être défini comme aliquot ré-aliquoté (enfant)!'),
('parent/child', 'Parent/Child', 'Parent/Enfant'),
('parent_used_volume_help', 'Volume of the parent aliquot used to create the children aliquot.', 'Volume de l''aliquot parent utilisé pour créer l''aliquot enfant.'),
('realiquoted children selection', 'Realiquoted Children Selection', 'Sélection des aliquots enfant'),
('select children aliquot type', 'Children Aliquot Type', 'Type de l''aliquot enfant'),
('selected children aliquot(s)', 'Children Aliquot(s)', 'Aliquot(s) enfant');

UPDATE structure_formats SET `display_order`='15' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquotinternaluses') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotInternalUse' AND `tablename`='aliquot_internal_uses' AND `field`='use_details' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='21' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquotinternaluses') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotInternalUse' AND `tablename`='aliquot_internal_uses' AND `field`='created' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats SET `display_order`='13' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquotinternaluses_volume') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotInternalUse' AND `tablename`='aliquot_internal_uses' AND `field`='used_volume' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='14' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquotinternaluses_volume') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotControl' AND `tablename`='aliquot_controls' AND `field`='volume_unit' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_volume_unit') AND `flag_confidential`='0');

DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquotinternaluses') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Inventorymanagement' AND `model`='AliquotInternalUse' AND `tablename`='aliquot_internal_uses' AND `field`='used_volume');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquotinternaluses') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Inventorymanagement' AND `model`='AliquotControl' AND `tablename`='aliquot_controls' AND `field`='volume_unit' );

UPDATE structure_formats SET `flag_detail`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquotinternaluses_volume') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotControl' AND `tablename`='aliquot_controls' AND `field`='volume_unit' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_volume_unit') AND `flag_confidential`='0');

REPLACE INTO i18n (id,en,fr) VALUES 
('aliquot source (for update)', 'Aliquot Source (For update)', 'Aliquot source (pour mise à jour)'),
('derivatives', 'Derivatives', 'Dérivés');

UPDATE structures SET alias = 'sourcealiquots_volume_for_batchderivative' WHERE alias = 'source_aliquots_volume';
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='sourcealiquots_volume_for_batchderivative'), (SELECT id FROM structure_fields WHERE `model`='AliquotControl' AND `tablename`='aliquot_controls' AND `field`='volume_unit' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_volume_unit')  AND `flag_confidential`='0'), '0', '8000', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0', '0', '0', '0', '0', '0');
UPDATE structure_formats SET `display_order`='7999' WHERE structure_id=(SELECT id FROM structures WHERE alias='sourcealiquots_volume_for_batchderivative') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SourceAliquot' AND `tablename`='source_aliquots' AND `field`='used_volume' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='1', `display_order`='9990' WHERE structure_id=(SELECT id FROM structures WHERE alias='sourcealiquots_volume_for_batchderivative') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SourceAliquot' AND `tablename`='source_aliquots' AND `field`='used_volume' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='1', `display_order`='9991' WHERE structure_id=(SELECT id FROM structures WHERE alias='sourcealiquots_volume_for_batchderivative') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotControl' AND `tablename`='aliquot_controls' AND `field`='volume_unit' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_volume_unit') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_override_label`='1', `language_label`='source aliquot used volume' WHERE structure_id=(SELECT id FROM structures WHERE alias='sourcealiquots_volume_for_batchderivative') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SourceAliquot' AND `tablename`='source_aliquots' AND `field`='used_volume' );

INSERT IGNORE INTO i18n (id,en,fr) VALUES 
('source aliquot used volume','Used Volume','Volume utilisé'),
('source_used_volume_help', 'Volume of the source aliquot to create the new derivative sample.', 'Volume de l''aliquot source utilisé pour créer l''échantillon dérivé.');

UPDATE structure_formats SET `flag_override_label`='1', `language_label`='aliquot used volume', `flag_override_help`='1', `language_help`='source_used_volume_help' WHERE structure_id=(SELECT id FROM structures WHERE alias='sourcealiquots_volume_for_batchderivative') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SourceAliquot' AND `tablename`='source_aliquots' AND `field`='used_volume' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='aliquotmasters_volume'), (SELECT id FROM structure_fields WHERE `model`='ALiquotMaster' AND `tablename`='aliquot_masters' AND `field`='current_volume' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '0', '29', '', '0', '', '0', '', '0', '', '0', '', '1', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');
UPDATE structure_formats SET `flag_override_label`='0', `language_label`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquotmasters_volume') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotControl' AND `tablename`='aliquot_controls' AND `field`='volume_unit' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_volume_unit') AND `flag_confidential`='0');

INSERT IGNORE INTO i18n (id,en,fr) VALUES 
('tested aliquot selection','Tested Aliquot Selection','Sélection aliquot testé'),
('unspecified','Unspecified', 'Non spécifié');

UPDATE structure_formats SET `display_order`='40' WHERE structure_id=(SELECT id FROM structures WHERE alias='qualityctrls') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='QualityCtrl' AND `tablename`='quality_ctrls' AND `field`='notes' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='qualityctrls_volume'), (SELECT id FROM structure_fields WHERE `model`='AliquotControl' AND `tablename`='aliquot_controls' AND `field`='volume_unit' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_volume_unit')  AND `flag_confidential`='0'), '0', '26', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '1', '1', '1', '0', '0', '0', '0', '0');
UPDATE structure_formats SET `display_order`='25', `flag_override_label`='1', `language_label`='tested aliquot used volume', `flag_override_help`='1', `language_help`='tested_aliquot_volume_help' WHERE structure_id=(SELECT id FROM structures WHERE alias='qualityctrls_volume') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='QualityCtrl' AND `tablename`='quality_ctrls' AND `field`='used_volume' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

INSERT IGNORE INTO i18n (id,en,fr) VALUES 
('tested aliquot used volume','Used Volume','Volume utilisé'),
('tested_aliquot_volume_help', 'Volume of the aliquot used for the quality control.', 'Volume de l''aliquot utilisé pour le contrôle de qualité.');

UPDATE structure_fields SET  `setting`='size=5' WHERE model='QualityCtrl' AND tablename='quality_ctrls' AND field='score' AND `type`='input' AND structure_value_domain  IS NULL ;

UPDATE structure_fields SET  `language_label`='qc code', language_help = 'qc_code_help' WHERE model='QualityCtrl' AND tablename='quality_ctrls' AND field='qc_code' AND `type`='input' AND structure_value_domain  IS NULL ;
UPDATE structure_formats SET `display_order`='100', `language_heading`='system data' WHERE structure_id=(SELECT id FROM structures WHERE alias='qualityctrls') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='QualityCtrl' AND `tablename`='quality_ctrls' AND `field`='qc_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_fields SET  `language_label`='qc run id', language_help = 'qc_run_id_help' WHERE model='QualityCtrl' AND tablename='quality_ctrls' AND field='run_id' AND `type`='input' AND structure_value_domain  IS NULL ;
UPDATE structure_formats SET `language_heading`='quality control' WHERE structure_id=(SELECT id FROM structures WHERE alias='qualityctrls') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='QualityCtrl' AND `tablename`='quality_ctrls' AND `field`='run_id');

DELETE FROM i18n WHERE id IN ('qc run id', 'qc code');
REPLACE INTO i18n (id,en,fr) VALUES 
('qc run id', 'QC #', 'QC #'),
('qc code', 'QC System Code', 'QC Code système'),
('system data' ,'System Data', 'Données système'),
('qc_run_id_help','Number or identifier assigned to your test.','Numéro ou identifiant attribué à votre test.'),
('qc_code_help', 'Unique code generated by the system.', 'Code unique généré par le système.');

UPDATE structure_formats SET `display_column`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qualityctrls') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='QualityCtrl' AND `tablename`='quality_ctrls' AND `field`='qc_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_override_label`='1', `language_label`='used aliquot barcode' WHERE structure_id = (SELECT id FROM structures WHERE alias='qualityctrls') AND structure_field_id IN(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='barcode' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='qualityctrls'), 
(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `field`='aliquot_label'), '1', '31', '', '1', 'used aliquot label', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');

UPDATE structure_formats SET `display_order`='32', `flag_override_label`='1', `language_label`='used aliquot type' WHERE structure_id=(SELECT id FROM structures WHERE alias='qualityctrls') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotControl' AND `tablename`='aliquot_controls' AND `field`='aliquot_type' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
REPLACE INTO i18n (id,en,fr) VALUES 
('used aliquot barcode', 'Used Aliquot Barcode', 'Barcode de l''aliquot testé'),
('used aliquot type', 'Type', 'Type'),
('used aliquot label', 'Label', 'Étiquette');

UPDATE structure_formats SET `display_column`='1', `language_heading`='used aliquot' WHERE structure_id=(SELECT id FROM structures WHERE alias='qualityctrls') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='QualityCtrl' AND `tablename`='quality_ctrls' AND `field`='used_volume' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='qualityctrls'), (SELECT id FROM structure_fields WHERE `model`='AliquotControl' AND `field`='volume_unit'), '1', '26', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');

UPDATE menus SET use_link = '/inventorymanagement/sample_masters/listAllDerivatives/%%Collection.id%%/%%SampleMaster.initial_specimen_sample_id%%' WHERE use_link = '/inventorymanagement/sample_masters/listAll/%%Collection.id%%/%%SampleMaster.initial_specimen_sample_id%%';

UPDATE structure_formats SET flag_search = 0 WHERE structure_id IN (SELECT id FROM structures WHERE alias like 'ad_%') AND structure_field_id IN (SELECT id FROM structure_fields WHERE field = 'current_volume');
UPDATE structure_formats SET display_order = (display_order + 400) WHERE structure_id IN (SELECT id FROM structures WHERE alias like 'sd_der%');

REPLACE INTO i18n (id,en,fr) VALUES 
('at least one quality control has to be created for each item','At least one quality control has to be created for each item!','Au moins un contrôle de qualité doit être créé par item.'),
('error: unable to define date','Error: Unable to define date.','Erreur: Impossible de définir la date.'),
('password is required','Password is required.','Le mot de passe est requis.'),
('password must have a minimal length of 6 characters','Password must have a minimal length of 6 characters.','Le mot de passe doit comporter au moins 6 caractères.'),
('you must define at least one use for each aliquot','You must define at least one use for each aliquot.','Vous devez définir au moins une utilisation pour chaque aliquot.');

UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qualityctrls') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='QualityCtrl' AND `tablename`='quality_ctrls' AND `field`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sourcealiquots_volume') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='current_volume' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sourcealiquots') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StorageMaster' AND `tablename`='storage_masters' AND `field`='selection_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sourcealiquots') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='storage_coord_x' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sourcealiquots') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='storage_coord_y' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

SET @position = (SELECT display_order FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='sourcealiquots_volume') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='used_volume' ));
UPDATE structure_formats SET `flag_index`='1' WHERE display_order > @position AND structure_id=(SELECT id FROM structures WHERE alias='sourcealiquots_volume') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotControl' AND `tablename`='aliquot_controls' AND `field`='volume_unit' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_volume_unit') AND `flag_confidential`='0');

REPLACE INTO i18n (id,en,fr) VALUES 
('sample code', 'Sample System Code', 'Échantillon - Code système');
UPDATE structure_fields SET  language_help = 'sample_code_help', language_label = 'sample code' WHERE field='sample_code';
REPLACE INTO i18n (id,en,fr) VALUES ('sample_code_help', 'Unique code generated by the system.', 'Code unique généré par le système.');
UPDATE structure_formats SET language_label = '', flag_override_label = '0' WHERE language_label = 'code' AND structure_field_id IN (SELECT id FROM structure_fields WHERE field = 'sample_code');
REPLACE INTO i18n (id,en,fr) VALUES ('storage code', 'Storage System Code', 'Entreposage - Code système');
UPDATE structure_formats SET language_tag = 'storage code' WHERE language_tag = 'code' AND structure_field_id IN (SELECT id FROM structure_fields WHERE field = 'code' AND model = 'StorageMaster');
UPDATE structure_fields SET  language_help = 'storage_code_help' WHERE field='code' AND model = 'StorageMaster';
REPLACE INTO i18n (id,en,fr) VALUES ('storage_code_help', 'Unique code generated by the system.', 'Code unique généré par le système.');

SELECT '****************' as msg_3
UNION
SELECT IF((SELECT ((SELECT COUNT(*) FROM derivative_details WHERE lab_book_master_id IS NOT NULL) 
+ (SELECT COUNT(*) FROM realiquotings WHERE lab_book_master_id IS NOT NULL) 
+ (SELECT COUNT(*) FROM lab_book_masters))as SCORE) > 0, 
'Looks like your users are using lab book. Lab book functionality works but has been deactivated on this version. Please set variables [skip_lab_book_selection_step] to false and [display_lab_book_url] to true in code to reactivate it and don''t run following queries.', 
'Looks like your users are not using lab book. Finalize lab book functionality deactivation running following queries. ') AS msg_3
UNION 
SELECT "
UPDATE lab_book_controls SET flag_active = 0;
UPDATE realiquoting_controls SET lab_book_control_id = NULL;
UPDATE parent_to_derivative_sample_controls SET lab_book_control_id = NULL; 
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='realiquotedparent') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Realiquoting' AND `tablename`='realiquotings' AND `field`='lab_book_master_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='lab_book_code_from_id') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='realiquotedparent') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Realiquoting' AND `tablename`='realiquotings' AND `field`='sync_with_lab_book' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE menus SET FLAG_ACTIVE = 0 WHERE use_link like '/labbook%';
" AS msg_3
UNION ALL
SELECT '****************' as msg_3;

ALTER TABLE structure_value_domains
 MODIFY category VARCHAR(255) NOT NULL DEFAULT '';

INSERT INTO structure_value_domains(`domain_name`) VALUES ('ctrnet_submission_disease_site');
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES
('breast - breast', 'breast - breast'),
('central nervous system - brain', 'central nervous system - brain'),
('central nervous system - spinal cord', 'central nervous system - spinal cord'),
('central nervous system - other central nervous system', 'central nervous system - other central nervous system'),
('digestive - anal', 'digestive - anal'),
('digestive - appendix', 'digestive - appendix'),
('digestive - bile ducts', 'digestive - bile ducts'),
('digestive - colorectal', 'digestive - colorectal'),
('digestive - esophageal', 'digestive - esophageal'),
('digestive - gallbladder', 'digestive - gallbladder'),
('digestive - liver', 'digestive - liver'),
('digestive - pancreas', 'digestive - pancreas'),
('digestive - small intestine', 'digestive - small intestine'),
('digestive - stomach', 'digestive - stomach'),
('digestive - other digestive', 'digestive - other digestive'),
('female genital - cervical', 'female genital - cervical'),
('female genital - endometrium', 'female genital - endometrium'),
('female genital - fallopian tube', 'female genital - fallopian tube'),
('female genital - gestational trophoblastic neoplasia', 'female genital - gestational trophoblastic neoplasia'),
('female genital - ovary', 'female genital - ovary'),
('female genital - peritoneal', 'female genital - peritoneal'),
('female genital - uterine', 'female genital - uterine'),
('female genital - vulva', 'female genital - vulva'),
('female genital - vagina', 'female genital - vagina'),
('female genital - other female genital', 'female genital - other female genital'),
('haematological - leukemia', 'haematological - leukemia'),
('haematological - lymphoma', 'haematological - lymphoma'),
('haematological - hodgkin''s disease', 'haematological - hodgkin''s disease'),
('haematological - non-hodgkin''s lymphomas', 'haematological - non-hodgkin''s lymphomas'),
('haematological - other haematological', 'haematological - other haematological'),
('head & neck - larynx', 'head & neck - larynx'),
('head & neck - nasal cavity and sinuses', 'head & neck - nasal cavity and sinuses'),
('head & neck - lip and oral cavity', 'head & neck - lip and oral cavity'),
('head & neck - pharynx', 'head & neck - pharynx'),
('head & neck - thyroid', 'head & neck - thyroid'),
('head & neck - salivary glands', 'head & neck - salivary glands'),
('head & neck - other head & neck', 'head & neck - other head & neck'),
('male genital - penis', 'male genital - penis'),
('male genital - prostate', 'male genital - prostate'),
('male genital - testis', 'male genital - testis'),
('male genital - other male genital', 'male genital - other male genital'),
('musculoskeletal sites - soft tissue sarcoma', 'musculoskeletal sites - soft tissue sarcoma'),
('musculoskeletal sites - bone', 'musculoskeletal sites - bone'),
('musculoskeletal sites - other bone', 'musculoskeletal sites - other bone'),
('ophthalmic - eye', 'ophthalmic - eye'),
('ophthalmic - other eye', 'ophthalmic - other eye'),
('skin - melanoma', 'skin - melanoma'),
('skin - non melanomas', 'skin - non melanomas'),
('skin - other skin', 'skin - other skin'),
('thoracic - lung', 'thoracic - lung'),
('thoracic - mesothelioma', 'thoracic - mesothelioma'),
('thoracic - other thoracic', 'thoracic - other thoracic'),
('urinary tract - bladder', 'urinary tract - bladder'),
('urinary tract - renal pelvis and ureter', 'urinary tract - renal pelvis and ureter'),
('urinary tract - kidney', 'urinary tract - kidney'),
('urinary tract - urethra', 'urinary tract - urethra'),
('urinary tract - other urinary tract', 'urinary tract - other urinary tract'),
('other - primary unknown', 'other - primary unknown'),
('other - gross metastatic disease', 'other - gross metastatic disease');

INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `flag_active`) 
VALUES
((SELECT id FROM structure_value_domains WHERE domain_name="ctrnet_submission_disease_site"),  (SELECT id FROM structure_permissible_values WHERE value="breast - breast" AND language_alias="breast - breast"), "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ctrnet_submission_disease_site"),  (SELECT id FROM structure_permissible_values WHERE value="central nervous system - brain" AND language_alias="central nervous system - brain"), "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ctrnet_submission_disease_site"),  (SELECT id FROM structure_permissible_values WHERE value="central nervous system - spinal cord" AND language_alias="central nervous system - spinal cord"), "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ctrnet_submission_disease_site"),  (SELECT id FROM structure_permissible_values WHERE value="central nervous system - other central nervous system" AND language_alias="central nervous system - other central nervous system"), "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ctrnet_submission_disease_site"),  (SELECT id FROM structure_permissible_values WHERE value="digestive - anal" AND language_alias="digestive - anal"), "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ctrnet_submission_disease_site"),  (SELECT id FROM structure_permissible_values WHERE value="digestive - appendix" AND language_alias="digestive - appendix"), "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ctrnet_submission_disease_site"),  (SELECT id FROM structure_permissible_values WHERE value="digestive - bile ducts" AND language_alias="digestive - bile ducts"), "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ctrnet_submission_disease_site"),  (SELECT id FROM structure_permissible_values WHERE value="digestive - colorectal" AND language_alias="digestive - colorectal"), "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ctrnet_submission_disease_site"),  (SELECT id FROM structure_permissible_values WHERE value="digestive - esophageal" AND language_alias="digestive - esophageal"), "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ctrnet_submission_disease_site"),  (SELECT id FROM structure_permissible_values WHERE value="digestive - gallbladder" AND language_alias="digestive - gallbladder"), "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ctrnet_submission_disease_site"),  (SELECT id FROM structure_permissible_values WHERE value="digestive - liver" AND language_alias="digestive - liver"), "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ctrnet_submission_disease_site"),  (SELECT id FROM structure_permissible_values WHERE value="digestive - pancreas" AND language_alias="digestive - pancreas"), "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ctrnet_submission_disease_site"),  (SELECT id FROM structure_permissible_values WHERE value="digestive - small intestine" AND language_alias="digestive - small intestine"), "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ctrnet_submission_disease_site"),  (SELECT id FROM structure_permissible_values WHERE value="digestive - stomach" AND language_alias="digestive - stomach"), "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ctrnet_submission_disease_site"),  (SELECT id FROM structure_permissible_values WHERE value="digestive - other digestive" AND language_alias="digestive - other digestive"), "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ctrnet_submission_disease_site"),  (SELECT id FROM structure_permissible_values WHERE value="female genital - cervical" AND language_alias="female genital - cervical"), "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ctrnet_submission_disease_site"),  (SELECT id FROM structure_permissible_values WHERE value="female genital - endometrium" AND language_alias="female genital - endometrium"), "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ctrnet_submission_disease_site"),  (SELECT id FROM structure_permissible_values WHERE value="female genital - fallopian tube" AND language_alias="female genital - fallopian tube"), "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ctrnet_submission_disease_site"),  (SELECT id FROM structure_permissible_values WHERE value="female genital - gestational trophoblastic neoplasia" AND language_alias="female genital - gestational trophoblastic neoplasia"), "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ctrnet_submission_disease_site"),  (SELECT id FROM structure_permissible_values WHERE value="female genital - ovary" AND language_alias="female genital - ovary"), "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ctrnet_submission_disease_site"),  (SELECT id FROM structure_permissible_values WHERE value="female genital - peritoneal" AND language_alias="female genital - peritoneal"), "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ctrnet_submission_disease_site"),  (SELECT id FROM structure_permissible_values WHERE value="female genital - uterine" AND language_alias="female genital - uterine"), "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ctrnet_submission_disease_site"),  (SELECT id FROM structure_permissible_values WHERE value="female genital - vulva" AND language_alias="female genital - vulva"), "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ctrnet_submission_disease_site"),  (SELECT id FROM structure_permissible_values WHERE value="female genital - vagina" AND language_alias="female genital - vagina"), "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ctrnet_submission_disease_site"),  (SELECT id FROM structure_permissible_values WHERE value="female genital - other female genital" AND language_alias="female genital - other female genital"), "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ctrnet_submission_disease_site"),  (SELECT id FROM structure_permissible_values WHERE value="haematological - leukemia" AND language_alias="haematological - leukemia"), "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ctrnet_submission_disease_site"),  (SELECT id FROM structure_permissible_values WHERE value="haematological - lymphoma" AND language_alias="haematological - lymphoma"), "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ctrnet_submission_disease_site"),  (SELECT id FROM structure_permissible_values WHERE value="haematological - hodgkin's disease" AND language_alias="haematological - hodgkin's disease"), "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ctrnet_submission_disease_site"),  (SELECT id FROM structure_permissible_values WHERE value="haematological - non-hodgkin's lymphomas" AND language_alias="haematological - non-hodgkin's lymphomas"), "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ctrnet_submission_disease_site"),  (SELECT id FROM structure_permissible_values WHERE value="haematological - other haematological" AND language_alias="haematological - other haematological"), "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ctrnet_submission_disease_site"),  (SELECT id FROM structure_permissible_values WHERE value="head & neck - larynx" AND language_alias="head & neck - larynx"), "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ctrnet_submission_disease_site"),  (SELECT id FROM structure_permissible_values WHERE value="head & neck - nasal cavity and sinuses" AND language_alias="head & neck - nasal cavity and sinuses"), "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ctrnet_submission_disease_site"),  (SELECT id FROM structure_permissible_values WHERE value="head & neck - lip and oral cavity" AND language_alias="head & neck - lip and oral cavity"), "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ctrnet_submission_disease_site"),  (SELECT id FROM structure_permissible_values WHERE value="head & neck - pharynx" AND language_alias="head & neck - pharynx"), "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ctrnet_submission_disease_site"),  (SELECT id FROM structure_permissible_values WHERE value="head & neck - thyroid" AND language_alias="head & neck - thyroid"), "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ctrnet_submission_disease_site"),  (SELECT id FROM structure_permissible_values WHERE value="head & neck - salivary glands" AND language_alias="head & neck - salivary glands"), "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ctrnet_submission_disease_site"),  (SELECT id FROM structure_permissible_values WHERE value="head & neck - other head & neck" AND language_alias="head & neck - other head & neck"), "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ctrnet_submission_disease_site"),  (SELECT id FROM structure_permissible_values WHERE value="male genital - penis" AND language_alias="male genital - penis"), "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ctrnet_submission_disease_site"),  (SELECT id FROM structure_permissible_values WHERE value="male genital - prostate" AND language_alias="male genital - prostate"), "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ctrnet_submission_disease_site"),  (SELECT id FROM structure_permissible_values WHERE value="male genital - testis" AND language_alias="male genital - testis"), "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ctrnet_submission_disease_site"),  (SELECT id FROM structure_permissible_values WHERE value="male genital - other male genital" AND language_alias="male genital - other male genital"), "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ctrnet_submission_disease_site"),  (SELECT id FROM structure_permissible_values WHERE value="musculoskeletal sites - soft tissue sarcoma" AND language_alias="musculoskeletal sites - soft tissue sarcoma"), "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ctrnet_submission_disease_site"),  (SELECT id FROM structure_permissible_values WHERE value="musculoskeletal sites - bone" AND language_alias="musculoskeletal sites - bone"), "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ctrnet_submission_disease_site"),  (SELECT id FROM structure_permissible_values WHERE value="musculoskeletal sites - other bone" AND language_alias="musculoskeletal sites - other bone"), "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ctrnet_submission_disease_site"),  (SELECT id FROM structure_permissible_values WHERE value="ophthalmic - eye" AND language_alias="ophthalmic - eye"), "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ctrnet_submission_disease_site"),  (SELECT id FROM structure_permissible_values WHERE value="ophthalmic - other eye" AND language_alias="ophthalmic - other eye"), "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ctrnet_submission_disease_site"),  (SELECT id FROM structure_permissible_values WHERE value="skin - melanoma" AND language_alias="skin - melanoma"), "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ctrnet_submission_disease_site"),  (SELECT id FROM structure_permissible_values WHERE value="skin - non melanomas" AND language_alias="skin - non melanomas"), "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ctrnet_submission_disease_site"),  (SELECT id FROM structure_permissible_values WHERE value="skin - other skin" AND language_alias="skin - other skin"), "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ctrnet_submission_disease_site"),  (SELECT id FROM structure_permissible_values WHERE value="thoracic - lung" AND language_alias="thoracic - lung"), "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ctrnet_submission_disease_site"),  (SELECT id FROM structure_permissible_values WHERE value="thoracic - mesothelioma" AND language_alias="thoracic - mesothelioma"), "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ctrnet_submission_disease_site"),  (SELECT id FROM structure_permissible_values WHERE value="thoracic - other thoracic" AND language_alias="thoracic - other thoracic"), "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ctrnet_submission_disease_site"),  (SELECT id FROM structure_permissible_values WHERE value="urinary tract - bladder" AND language_alias="urinary tract - bladder"), "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ctrnet_submission_disease_site"),  (SELECT id FROM structure_permissible_values WHERE value="urinary tract - renal pelvis and ureter" AND language_alias="urinary tract - renal pelvis and ureter"), "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ctrnet_submission_disease_site"),  (SELECT id FROM structure_permissible_values WHERE value="urinary tract - kidney" AND language_alias="urinary tract - kidney"), "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ctrnet_submission_disease_site"),  (SELECT id FROM structure_permissible_values WHERE value="urinary tract - urethra" AND language_alias="urinary tract - urethra"), "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ctrnet_submission_disease_site"),  (SELECT id FROM structure_permissible_values WHERE value="urinary tract - other urinary tract" AND language_alias="urinary tract - other urinary tract"), "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ctrnet_submission_disease_site"),  (SELECT id FROM structure_permissible_values WHERE value="other - primary unknown" AND language_alias="other - primary unknown"), "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ctrnet_submission_disease_site"),  (SELECT id FROM structure_permissible_values WHERE value="other - gross metastatic disease" AND language_alias="other - gross metastatic disease"), "1");

REPLACE INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('breast - breast', '', 'Breast - Breast', 'Sein - Sein'),

('central nervous system - brain', '', 'Central Nervous System - Brain', 'Système Nerveux Central - Cerveau'),
('central nervous system - other central nervous system', '', 'Central Nervous System - Other', 'Système Nerveux Central - Autre'),
('central nervous system - spinal cord', '', 'Central Nervous System - Spinal Cord', 'Système Nerveux Central - Moelle épinière'),

('digestive - anal', '', 'Digestive - Anal', 'Appareil digestif - Anal'),
('digestive - appendix', '', 'Digestive - Appendix', 'Appareil digestif - Appendice'),
('digestive - bile ducts', '', 'Digestive - Bile Ducts', 'Appareil digestif - Voies biliaires'),
('digestive - colorectal', '', 'Digestive - Colorectal', 'Appareil digestif - Colorectal'),
('digestive - esophageal', '', 'Digestive - Esophageal', 'Appareil digestif - Oesophage'),
('digestive - gallbladder', '', 'Digestive - Gallbladder', 'Appareil digestif - Vésicule biliaire'),
('digestive - liver', '', 'Digestive - Liver', 'Appareil digestif - Foie'),
('digestive - other digestive', '', 'Digestive - Other', 'Appareil digestif - Autre'),
('digestive - pancreas', '', 'Digestive - Pancreas', 'Appareil digestif - Pancréas'),
('digestive - small intestine', '', 'Digestive - Small Intestine', 'Appareil digestif - Intestin grêle'),
('digestive - stomach', '', 'Digestive - Stomach', 'Appareil digestif - Estomac'),

('female genital - cervical', '', 'Female Genital - Cervical', 'Appareil génital féminin - Col de l''utérus'),
('female genital - endometrium', '', 'Female Genital - Endometrium', 'Appareil génital féminin - Endomètre'),
('female genital - fallopian tube', '', 'Female Genital - Fallopian Tube', 'Appareil génital féminin - Trompes de Fallope'),
('female genital - gestational trophoblastic neoplasia', '', 'Female Genital - Gestational Trophoblastic Neoplasia', 'Appareil génital féminin - Néoplasie trophoblastique gestationnelle'),
('female genital - other female genital', '', 'Female Genital - Other', 'Appareil génital féminin - Autre'),
('female genital - ovary', '', 'Female Genital - Ovary', 'Appareil génital féminin - Ovaire'),
('female genital - peritoneal', '', 'Female Genital - Peritoneal', 'Appareil génital féminin - Péritoine'),
('female genital - uterine', '', 'Female Genital - Uterine', 'Appareil génital féminin - Utérin'),
('female genital - vagina', '', 'Female Genital - Vagina', 'Appareil génital féminin - Vagin'),
('female genital - vulva', '', 'Female Genital - Vulva', 'Appareil génital féminin - Vulve'),

('haematological - hodgkin''s disease', '', 'Haematological - Hodgkin''s Disease', 'Hématologie - Maladie de Hodgkin'),
('haematological - leukemia', '', 'Haematological - Leukemia', 'Hématologie - Leucémie'),
('haematological - lymphoma', '', 'Haematological - Lymphoma', 'Hématologie - Lymphome'),
('haematological - non-hodgkin''s lymphomas', '', 'Haematological - Non-Hodgkin''s Lymphomas', 'Hématologie - Lymphome Non-hodgkinien'),
('haematological - other haematological', '', 'Haematological - Other', 'Hématologie - Autre'),

('head & neck - larynx', '', 'Head & Neck - Larynx', 'Tête & Cou - Larynx'),
('head & neck - lip and oral cavity', '', 'Head & Neck - Lip and Oral Cavity', 'Tête & Cou - Lèvres et la cavité buccale'),
('head & neck - nasal cavity and sinuses', '', 'Head & Neck - Nasal Cavity and Sinuses', 'Tête & Cou - Cavité nasale et sinus'),
('head & neck - other head & neck', '', 'Head & Neck - Other', 'Tête & Cou - Autre'),
('head & neck - pharynx', '', 'Head & Neck - Pharynx', 'Tête & Cou - Pharynx'),
('head & neck - salivary glands', '', 'Head & Neck - Salivary Glands', 'Tête & Cou - Glandes salivaires'),
('head & neck - thyroid', '', 'Head & Neck - Thyroid', 'Tête & Cou - Thyroïde'),

('male genital - other male genital', '', 'Male Genital - Other', 'Appareil génital masculin - Autre'),
('male genital - penis', '', 'Male Genital - Penis', 'Appareil génital masculin - Pénis'),
('male genital - prostate', '', 'Male Genital - Prostate', 'Appareil génital masculin - Prostate'),
('male genital - testis', '', 'Male Genital - Testis', 'Appareil génital masculin - Testicule'),

('musculoskeletal sites - bone', '', 'Musculoskeletal Sites - Bone', 'Sites musculo-squelettiques - Os'),
('musculoskeletal sites - other bone', '', 'Musculoskeletal Sites - Other Bone', 'Sites musculo-squelettiques - Autre'),
('musculoskeletal sites - soft tissue sarcoma', '', 'Musculoskeletal Sites - Soft Tissue Sarcoma', 'Sites musculo-squelettiques - Sarcome des tissus mous'),

('ophthalmic - eye', '', 'Ophthalmic - Eye', 'Ophtalmique - Yeux'),
('ophthalmic - other eye', '', 'Ophthalmic - Other', 'Ophtalmique - Autre'),

('other - gross metastatic disease', '', 'Other - Gross Metastatic Disease', ''),
('other - primary unknown', '', 'Other - Primary Unknown', 'Autre - Primaire inconnu'),

('skin - melanoma', '', 'Skin - Melanoma', 'Peau - Melanome'),
('skin - non melanomas', '', 'Skin - Non Melanomas', 'Peau - Autre que Melanome'),
('skin - other skin', '', 'Skin - Other', 'Peau - Autre'),

('thoracic - lung', '', 'Thoracic - Lung', 'Thoracique - Poumon'),
('thoracic - mesothelioma', '', 'Thoracic - Mesothelioma', 'Thoracique - Mésothéliome'),
('thoracic - other thoracic', '', 'Thoracic - Other', 'Thoracique - Autre'),

('urinary tract - bladder', '', 'Urinary Tract - Bladder', 'Voies urinaires - Vessie'),
('urinary tract - kidney', '', 'Urinary Tract - Kidney', 'Voies urinaires - Rein'),
('urinary tract - other urinary tract', '', 'Urinary Tract - Other', 'Voies urinaires - Autre'),
('urinary tract - renal pelvis and ureter', '', 'Urinary Tract - Renal Pelvis and Ureter', 'Voies urinaires - Bassinet et uretère'),
('urinary tract - urethra', '', 'Urinary Tract - Urethra', 'Voies urinaires - Urètre');					

DELETE FROM structure_formats WHERE structure_id = (SELECT id FROM structures WHERE alias = 'sopd_general_all');		
INSERT INTO structures (alias) VALUES ('sopd_inventory_all');
UPDATE structure_formats SET `flag_search`='1', `flag_addgrid`='0', `flag_editgrid`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sopmasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SopMaster' AND `tablename`='sop_masters' AND `field`='title' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_addgrid`='0', `flag_editgrid`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sopmasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SopMaster' AND `tablename`='sop_masters' AND `field`='code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='sopmasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SopMaster' AND `tablename`='sop_masters' AND `field`='version' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_addgrid`='0', `flag_editgrid`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sopmasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SopControl' AND `tablename`='sop_controls' AND `field`='sop_group' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_addgrid`='0', `flag_editgrid`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sopmasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SopControl' AND `tablename`='sop_controls' AND `field`='type' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='sopmasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SopMaster' AND `tablename`='sop_masters' AND `field`='activated_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='sopmasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SopMaster' AND `tablename`='sop_masters' AND `field`='status' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sopmasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SopMaster' AND `tablename`='sop_masters' AND `field`='scope' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sopmasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SopMaster' AND `tablename`='sop_masters' AND `field`='purpose' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE sop_controls SET extend_tablename = '', extend_form_alias = '';
UPDATE sop_controls SET form_alias = CONCAT('sopmasters,',form_alias);
ALTER TABLE sop_controls ADD column `flag_active` tinyint(1) NOT NULL DEFAULT '1';

UPDATE menus SET use_summary = 'Sop.SopMaster::summary' WHERE id = 'sop_CAN_03';
UPDATE menus SET flag_active = '0' WHERE id = 'sop_CAN_04';

INSERT INTO structure_value_domains (domain_name, source) VALUES ('sop_types', 'Sop.SopControl::getTypePermissibleValues'),('sop_groups','Sop.SopControl::getGroupPermissibleValues');	
UPDATE structure_fields SET  `type`='select',  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='sop_types') ,  `setting`='' WHERE model='SopControl' AND tablename='sop_controls' AND field='type' ;	
UPDATE structure_fields SET  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='sop_groups')  WHERE model='SopControl' AND tablename='sop_controls' AND field='sop_group' AND `type`='select' AND structure_value_domain  IS NULL ;			

ALTER TABLE diagnosis_controls
  ADD COLUMN `category` enum('primary','secondary','progression','remission','recurrence') NOT NULL DEFAULT 'primary' AFTER id;

UPDATE diagnosis_controls SET flag_active = 0 WHERE controls_type = 'cap report - perihilar bile duct';

UPDATE diagnosis_controls SET controls_type = 'basic primary' WHERE controls_type = 'primary';
UPDATE diagnosis_controls SET controls_type = 'primary diagnosis unknown' WHERE controls_type = 'unknown';

UPDATE diagnosis_controls SET category = 'secondary', controls_type = 'basic secondary' WHERE controls_type = 'secondary';
UPDATE diagnosis_controls SET category = 'remission', controls_type = 'basic remission' WHERE controls_type = 'remission';
UPDATE diagnosis_controls SET category = 'progression', controls_type = 'basic progression' WHERE controls_type = 'progression';
UPDATE diagnosis_controls SET category = 'recurrence', controls_type = 'basic recurrence' WHERE controls_type = 'recurrence';

ALTER TABLE diagnosis_controls
  DROP COLUMN flag_primary, DROP COLUMN flag_secondary;
  
UPDATE diagnosis_controls SET databrowser_label = concat(category,'|',controls_type) WHERE controls_type IN ('blood', 'tissue', 'basic recurrence', 'basic progression', 'basic remission', 'basic secondary', 'primary diagnosis unknown', 'basic primary');

SELECT '****************' as msg_4
UNION
SELECT 'Run following queries after diagnosis data migration' AS msg_4
UNION SELECT "
ALTER TABLE diagnosis_masters 
	DROP COLUMN dx_identifier,
	DROP COLUMN primary_number,
	DROP COLUMN dx_origin;
ALTER TABLE diagnosis_masters_revs
	DROP COLUMN dx_identifier,
	DROP COLUMN primary_number,
	DROP COLUMN dx_origin;	
DELETE FROM structure_formats WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE field IN ('primary_number', 'dx_origin', 'dx_identifier'));
DELETE FROM structure_fields WHERE field IN ('primary_number', 'dx_origin', 'dx_identifier');
" AS msg_4
UNION ALL
SELECT '****************' as msg_4;

INSERT INTO structure_value_domains (domain_name, source) VALUES ('diagnosis_type', 'Cinicalannotation.DiagnosisControl::getTypePermissibleValues'),('diagnosis_category','Cinicalannotation.DiagnosisControl::getCategoryPermissibleValues');	
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'DiagnosisControl', 'diagnosis_controls', 'controls_type', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='diagnosis_type') , '0', '', '', '', 'controls type', ''), 
('Clinicalannotation', 'DiagnosisControl', 'diagnosis_controls', 'category', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='diagnosis_category') , '0', '', '', '', 'category', '');
DELETE FROM structure_formats WHERE structure_id IN (SELECT id FROM structures WHERE alias IN ('diagnosismasters'));
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='diagnosismasters'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='diagnosismasters'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisControl' AND `tablename`='diagnosis_controls' AND `field`='controls_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='diagnosis_type')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='controls type' AND `language_tag`=''), '1', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '1'), 
((SELECT id FROM structures WHERE alias='diagnosismasters'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisControl' AND `tablename`='diagnosis_controls' AND `field`='category' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='diagnosis_category')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='category' AND `language_tag`=''), '1', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '1');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='diagnosismasters'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='notes' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '13', '', '0', '', '0', '', '1', 'help_memo', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_tissues') AND structure_field_id=(SELECT id FROM structure_fields WHERE `plugin`='Clinicalannotation' AND `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='notes');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_tissues') AND structure_field_id=(SELECT id FROM structure_fields WHERE `plugin`='Clinicalannotation' AND `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_date');
UPDATE diagnosis_controls SET form_alias = CONCAT('diagnosismasters,dx_primary,dx_tissues') WHERE controls_type = 'tissue';
ALTER TABLE diagnosis_masters 
	ADD COLUMN `primary_id` int(11) DEFAULT NULL AFTER id;
ALTER TABLE diagnosis_masters_revs
	ADD COLUMN `primary_id` int(11) DEFAULT NULL AFTER id;	
ALTER TABLE `diagnosis_masters`
  ADD CONSTRAINT `diagnosis_masters_ibfk_2` FOREIGN KEY (`primary_id`) REFERENCES `diagnosis_masters` (`id`);
UPDATE diagnosis_controls SET form_alias = CONCAT('diagnosismasters,dx_primary,dx_bloods') WHERE form_alias LIKE '%dx_bloods%';
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_bloods') AND structure_field_id=(SELECT id FROM structure_fields WHERE `plugin`='Clinicalannotation' AND `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='notes');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_bloods') AND structure_field_id=(SELECT id FROM structure_fields WHERE `plugin`='Clinicalannotation' AND `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_date');
UPDATE diagnosis_controls SET form_alias = CONCAT('diagnosismasters,dx_primary'), detail_tablename = 'dxd_primaries' WHERE controls_type = 'primary diagnosis unknown';
DROP TABLE dxd_unknown;
DROP TABLE dxd_unknown_revs;

DELETE FROM diagnosis_controls WHERE controls_type = 'basic primary';

DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_master');
DELETE FROM structures WHERE alias='dx_master';

UPDATE diagnosis_controls SET form_alias = CONCAT('diagnosismasters,dx_secondary') WHERE controls_type LIKE '%basic secondary%';

DELETE FROM structures WHERE alias IN ('dx_unknown');

UPDATE diagnosis_controls SET form_alias = CONCAT('diagnosismasters,dx_progression ') WHERE controls_type LIKE 'basic progression';
UPDATE diagnosis_controls SET form_alias = CONCAT('diagnosismasters,dx_remission ') WHERE controls_type LIKE 'basic remission';
UPDATE diagnosis_controls SET form_alias = CONCAT('diagnosismasters,dx_recurrence ') WHERE controls_type LIKE 'basic recurrence';

INSERT IGNORE INTO i18n (`id`, `en`, `fr`) VALUES 
('error_fk_diagnosis_primary_id', 'Your data cannot be deleted! This diagnosis/progression/etc is linked to a primary or secondary diagnostic.', 'Vos données ne peuvent être supprimées! Ce diagnostic/progression/etc est attaché à un diagnostic primaire ou secondaire.'),
('error_fk_diagnosis_parent_id', 'Your data cannot be deleted! This diagnosis/progression/etc is linked to a primary  or secondary diagnostic.', 'Vos données ne peuvent être supprimées! Ce diagnostic/progression/etc est attaché à un diagnostic primaire ou secondaire.'),

('sop is assigned to a slide', 'Your data cannot be deleted! This sop is linked to slide creation.', 'Vos données ne peuvent être supprimées! Ce SOP est attaché à une création de lame.'),
('sop is assigned to a block', 'Your data cannot be deleted! This sop is linked to block creation.', 'Vos données ne peuvent être supprimées! Ce SOP est attaché à une création de bloc.'),
('sop is assigned to a sample', 'Your data cannot be deleted! This sop is linked to sample creation.', 'Vos données ne peuvent être supprimées! Ce SOP est attaché à une création d''un échantillon.'),
('sop is assigned to a collection', 'Your data cannot be deleted! This sop is linked to collection creation.', 'Vos données ne peuvent être supprimées! Ce SOP est attaché à une création de collection.'),
('sop is assigned to a aliquot', 'Your data cannot be deleted! This sop is linked to aliquot creation.', 'Vos données ne peuvent être supprimées! Ce SOP est attaché à une création d''aliquot.');

UPDATE structure_fields SET language_label = 'diagnosis control type' WHERE field = 'controls_type' AND model = 'DiagnosisControl';

INSERT IGNORE INTO i18n (`id`, `en`, `fr`) VALUES 
('add primary', 'Add Primary', 'Ajouter Primaire'),
('primary diagnosis unknown', 'Unknown', 'Inconnu'),

('new primary', 'New Primary', 'Nouveau primaire'),
('new secondary', 'New Secondary', 'Nouveau secondaire'),
('new progression', 'New Progression', 'Nouvelle progression'),
('new remission', 'New Remission', 'Nouvelle rémission'),
('new recurrence', 'New Recurrence', 'Nouveau récurrence'),

('progression', 'Progression', 'Progression'),
('remission', 'Remission', 'Rémission'),
('recurrence', 'Recurrence', 'Récurrence'),

('basic secondary', 'Undetailed', 'Non détaillé'),
('basic progression', 'Undetailed', 'Non détaillé'),
('basic remission', 'Undetailed', 'Non détaillé'),
('basic recurrence', 'Undetailed', 'Non détaillé'),

('diagnosis control type', 'Type', 'Type');

UPDATE menus SET use_link = '/clinicalannotation/diagnosis_masters/detail/%%Participant.id%%/%%DiagnosisMaster.primary_id%%', `use_summary` = 'Clinicalannotation.DiagnosisMaster::primarySummary', `language_title` = 'detail', `language_description` = NULL WHERE id = 'clin_CAN_5_1';
INSERT INTO `menus` (`id`, `parent_id`, `is_root`, `display_order`, `language_title`, `language_description`, `use_link`, `use_summary`, `flag_active`, `created`, `created_by`, `modified`, `modified_by`) VALUES
('clin_CAN_5_1.1', 'clin_CAN_5_1', 0, 1, 'detail', NULL, '/clinicalannotation/diagnosis_masters/detail/%%Participant.id%%/%%DiagnosisMaster.progression_1_id%%', 'Clinicalannotation.DiagnosisMaster::progression1Summary', 1, now(), 0, now(), 0),
('clin_CAN_5_1.2', 'clin_CAN_5_1.1', 0, 1, 'detail', NULL, '/clinicalannotation/diagnosis_masters/detail/%%Participant.id%%/%%DiagnosisMaster.progression_2_id%%', 'Clinicalannotation.DiagnosisMaster::progression2Summary', 1, now(), 0, now(), 0);

UPDATE structure_formats SET `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='diagnosismasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisControl' AND `tablename`='diagnosis_controls' AND `field`='category' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='diagnosis_category') AND `flag_confidential`='0');

INSERT IGNORE INTO i18n (id,en,fr) VALUES 
('unknown primary has been redefined. complete primary data.', 'Unknown primary has been redefined. Please complete new data.', 'Le diagnostic primaire ''Inconnu'' a été re-défini. Veuillez mettre à jour les données.'),
('redefine unknown primary', 'Redefine Prim. Diag.', 'Re-définir Diag. Prim.');

REPLACE INTO i18n (id,en,fr) VALUES 
('related diagnosis','Related Diagnosis Event','Évenement du diagnostic connexe'),
('diagnosis history','History','Historic'), 
('diagnosis event', 'Event', 'Évenement');

INSERT INTO structure_validations (structure_field_id, rule, language_message) VALUES
((SELECT id FROM structure_fields WHERE `model`='SopMaster' AND `field`='code'), 'isUnique', ''), 
((SELECT id FROM structure_fields WHERE `model`='SopMaster' AND `field`='code'), 'notEmpty', '');

INSERT INTO `structure_permissible_values_custom_controls` VALUES (null,'sop versions',1,50);
INSERT INTO `structure_value_domains` VALUES 
(null,'custom_sop_verisons','open','','StructurePermissibleValuesCustom::getCustomDropdown(\'sop versions\')');
INSERT INTO `structure_value_domains` VALUES 
(null,'sop_status','open','',NULL);
UPDATE structure_fields SET type='select', structure_value_domain = (SELECT id FROM structure_value_domains WHERE domain_name = 'custom_sop_verisons'), setting = '' WHERE field = 'version' and model = 'SopMaster';
UPDATE structure_fields SET type='select', structure_value_domain = (SELECT id FROM structure_value_domains WHERE domain_name = 'sop_status') WHERE field = 'status' and model = 'SopMaster';

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) 
VALUES
("in development", "in development"),('activated','activated'),("expired","expired"),('deactivated','deactivated');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES
((SELECT id FROM structure_value_domains WHERE domain_name="sop_status"),  
(SELECT id FROM structure_permissible_values WHERE value="in development" AND language_alias="in development"), "1", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="sop_status"),  
(SELECT id FROM structure_permissible_values WHERE value="activated" AND language_alias="activated"), "2", "1");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES
((SELECT id FROM structure_value_domains WHERE domain_name="sop_status"),  
(SELECT id FROM structure_permissible_values WHERE value="expired" AND language_alias="expired"), "3", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="sop_status"),  
(SELECT id FROM structure_permissible_values WHERE value="deactivated" AND language_alias="deactivated"), "4", "1");

INSERT IGNORE INTO i18n (id,en,fr) VALUES 
('in development', 'In Development', 'En développement'),('activated', 'Activated', 'Activé'),('expired', 'Expired', 'Expiré'),('deactivated', 'deactivated', 'Désactivé');

UPDATE structure_formats 
SET `flag_add`='0', `flag_add_readonly`='0', `flag_edit`='0', `flag_edit_readonly`='0', `flag_search`='0', `flag_search_readonly`='0', `flag_addgrid`='0', `flag_addgrid_readonly`='0', `flag_editgrid`='0', `flag_editgrid_readonly`='0', `flag_batchedit`='0', `flag_batchedit_readonly`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='studysummaries') 
AND structure_field_id NOT IN (SELECT id FROM structure_fields WHERE field IN ('title', 'disease_site', 'start_date', 'end_date', 'summary'));

INSERT INTO structure_validations (structure_field_id, rule, language_message) VALUES
((SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `field`='title'), 'isUnique', ''), 
((SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `field`='title'), 'notEmpty', '');

UPDATE structure_fields SET structure_value_domain = (SELECT id FROM structure_value_domains WHERE domain_name = 'ctrnet_submission_disease_site')
WHERE field = 'disease_site' and model = 'StudySummary';

ALTER TABLE study_summaries
  MODIFY `disease_site` varchar(255) NOT NULL DEFAULT '';
ALTER TABLE study_summaries_revs
  MODIFY `disease_site` varchar(255) NOT NULL DEFAULT '';

UPDATE menus set language_title = 'study and project' WHERE id = 'tool_CAN_100';

REPLACE INTO i18n (id,en,fr) VALUES 
('study and project', 'Study & Project', 'Étude & Projet');

UPDATE structure_fields SET language_label = 'study / project' WHERE field = 'study_summary_id';
UPDATE structure_fields SET language_label = 'default study / project' WHERE field = 'default_study_summary_id';

REPLACE INTO i18n (id,en,fr) VALUES ('study / project', 'Study/Project', 'Étude/Projet'), ('default study / project', 'Default Study/Project', 'Étude/Projet (par défaut)');

UPDATE structure_formats SET `flag_search`='1', `flag_index`='1', `flag_summary`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='studysummaries') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='disease_site' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ctrnet_submission_disease_site') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='studysummaries') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='title' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1', `flag_summary`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='studysummaries') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='start_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1', `flag_summary`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='studysummaries') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='end_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

REPLACE INTO i18n (id,en,fr) VALUES 
('study/project is assigned to an aliquot', 
'Your data cannot be deleted! This study/project is linked to aliquot creation.', 
'Vos données ne peuvent être supprimées! Ce(tte) étude/projet est attaché(e) à une création d''aliquot.'),
('study/project is assigned to an order', 
'Your data cannot be deleted! This study/project is linked to an order.', 
'Vos données ne peuvent être supprimées! Ce(tte) étude/projet est attaché(e) à une commande.'),
('study/project is assigned to an order line', 
'Your data cannot be deleted! This study/project is linked to an order line.', 
'Vos données ne peuvent être supprimées! Ce(tte) étude/projet est attaché(e) à une ligne de commande.');

ALTER TABLE diagnosis_controls
 ADD COLUMN flag_compare_with_cap BOOLEAN DEFAULT true;
 
REPLACE INTO i18n (id,en,fr) VALUES ('reserved for study','Reserved For Study/Projetc', 'Réservé pour une Étude/Projet');

DELETE FROM structure_formats WHERE structure_id = (SELECT id FROM structures WHERE alias = 'aliquotmasters');
DELETE FROM structures WHERE alias = 'aliquotmasters';

UPDATE structure_formats SET `flag_summary`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id IN (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='barcode' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_summary`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotControl' AND `tablename`='aliquot_controls' AND `field`='aliquot_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_type') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_summary`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='in_stock' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_in_stock_values') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_summary`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='storage_coord_x' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_summary`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='storage_coord_y' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_summary`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StorageMaster' AND `tablename`='storage_masters' AND `field`='selection_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_summary`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='aliquot_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='aliquot_masters'), 
(select id from structure_fields where field = 'study_summary_id' AND model = 'AliquotMaster'), '0', '1180', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '0', '0', '0', '0', '1', '0');

UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='storage_datetime' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StorageMaster' AND `tablename`='storage_masters' AND `field`='temperature' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StorageMaster' AND `tablename`='storage_masters' AND `field`='temp_unit' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='temperature_unit_code') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='study_summary_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='study_list') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='sop_master_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_sop_list') AND `flag_confidential`='0');

DELETE FROM structure_formats 
WHERE structure_id IN (SELECT id FROM structures WHERE alias LIKE 'ad_spec%' OR alias LIKE 'ad_der%')
AND structure_field_id IN (SELECT id FROM structure_fields WHERE field = 'study_summary_id' AND model = 'AliquotMaster');

UPDATE structure_formats SET `display_column`='2' WHERE structure_id=(SELECT id FROM structures WHERE alias='orders') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Order' AND `tablename`='orders' AND `field`='description' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='2' WHERE structure_id=(SELECT id FROM structures WHERE alias='orders') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Order' AND `tablename`='orders' AND `field`='comments' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_fields SET model = 'ProtocolControl', tablename = 'protocol_controls' WHERE tablename = 'protocol_masters' AND field = 'type';

-- ------------------------------------------------------------------------------------------------------------
-- DIAGNOSIS UPGRADE
-- ------------------------------------------------------------------------------------------------------------

SELECT '****************' as msg_5
UNION
SELECT 'Run following queries to delete CAP report from diagnosis_controls' AS msg_5
UNION SELECT "
DELETE FROM diagnosis_controls WHERE form_alias LIKE 'dx_cap_%';
" AS msg_5
UNION ALL
SELECT '****************' as msg_5;

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='dx_primary'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='morphology' AND `type`='autocomplete' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=10,url=/codingicd/CodingIcdo3s/autocomplete/morpho,tool=/codingicd/CodingIcdo3s/tool/morpho' AND `default`='' AND `language_help`='help_morphology' AND `language_label`='morphology' AND `language_tag`=''), '2', '7', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='dx_primary'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_method' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='dx_method')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_dx method' AND `language_label`='dx_method' AND `language_tag`=''), '1', '9', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_primary'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='primary_icd10_code' AND `type`='autocomplete' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=10,url=/codingicd/CodingIcd10s/autocomplete,tool=/codingicd/CodingIcd10s/tool/who' AND `default`='' AND `language_help`='help_primary code' AND `language_label`='primary disease code' AND `language_tag`=''), '2', '1', 'coding', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_primary'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='information_source' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='information_source')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_information_source' AND `language_label`='information_source' AND `language_tag`=''), '1', '12', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='dx_primary'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='topography' AND `type`='autocomplete' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=10,url=/codingicd/CodingIcdo3s/autocomplete/topo,tool=/codingicd/CodingIcdo3s/tool/topo' AND `default`='' AND `language_help`='help_topography' AND `language_label`='topography' AND `language_tag`=''), '2', '6', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='dx_primary'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='survival_time_months' AND `type`='integer_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='help_survival time' AND `language_label`='survival time months' AND `language_tag`=''), '1', '11', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0');

DELETE FROM structure_formats 
WHERE structure_id IN (SELECT id FROM structures WHERE alias IN ('dx_bloods', 'dx_tissues')) 
AND structure_field_id IN (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND field IN ('morphology', 'dx_method', 'primary_icd10_code', 'information_source', 'topography', 'survival_time_months'));

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='dx_secondary'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='morphology' AND `type`='autocomplete' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=10,url=/codingicd/CodingIcdo3s/autocomplete/morpho,tool=/codingicd/CodingIcdo3s/tool/morpho' AND `default`='' AND `language_help`='help_morphology' AND `language_label`='morphology' AND `language_tag`=''), '2', '7', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='dx_secondary'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_method' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='dx_method')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_dx method' AND `language_label`='dx_method' AND `language_tag`=''), '1', '9', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_secondary'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='primary_icd10_code' AND `type`='autocomplete' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=10,url=/codingicd/CodingIcd10s/autocomplete,tool=/codingicd/CodingIcd10s/tool/who' AND `default`='' AND `language_help`='help_primary code' AND `language_label`='primary disease code' AND `language_tag`=''), '2', '1', 'coding', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_secondary'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='information_source' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='information_source')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_information_source' AND `language_label`='information_source' AND `language_tag`=''), '1', '12', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='dx_secondary'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='topography' AND `type`='autocomplete' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=10,url=/codingicd/CodingIcdo3s/autocomplete/topo,tool=/codingicd/CodingIcdo3s/tool/topo' AND `default`='' AND `language_help`='help_topography' AND `language_label`='topography' AND `language_tag`=''), '2', '6', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0');

UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_bloods') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='tumour_grade' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tumour grade') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_bloods') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='clinical_stage_summary' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_bloods') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_stage_summary' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_bloods') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='previous_primary_code_system' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_bloods') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='previous_primary_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_tissues') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_tissues' AND `field`='laterality' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='laterality') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_tissues') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='collaborative_staged' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yesno') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_tissues') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='tumour_grade' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tumour grade') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_tissues') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='clinical_stage_summary' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_tissues') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_stage_summary' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_tissues') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='previous_primary_code_system' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_tissues') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='previous_primary_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_bloods') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='collaborative_staged' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yesno') AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_detail`='0' WHERE structure_id IN (SELECT id FROM structures WHERE alias IN ('dx_bloods', 'dx_tissues')) AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='previous_primary_code_system' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_detail`='0' WHERE structure_id IN (SELECT id FROM structures WHERE alias IN ('dx_bloods', 'dx_tissues')) AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='previous_primary_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_fields 
SET setting = 'size=10,url=/codingicd/CodingIcd10s/autocomplete/who,tool=/codingicd/CodingIcd10s/tool/who', 
`language_label` = 'disease code',
`field` = 'icd10_code'
WHERE model = 'DiagnosisMaster' AND field  = 'primary_icd10_code';

ALTER TABLE diagnosis_masters 
  CHANGE primary_icd10_code icd10_code varchar(10) DEFAULT NULL;
ALTER TABLE diagnosis_masters_revs
  CHANGE primary_icd10_code icd10_code varchar(10) DEFAULT NULL;

INSERT INTO structures(`alias`) VALUES ('dx_unknown_primary');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='dx_unknown_primary'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='icd10_code' AND `type`='autocomplete' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=10,url=/codingicd/CodingIcd10s/autocomplete/who,tool=/codingicd/CodingIcd10s/tool/who' AND `default`='' AND `language_help`='help_primary code' AND `language_label`='disease code' AND `language_tag`=''), '2', '1', 'coding', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1');

UPDATE diagnosis_controls SET form_alias = 'diagnosismasters,dx_unknown_primary' WHERE controls_type = 'primary diagnosis unknown';

INSERT IGNORE INTO i18n (id,en,fr) VALUES 
('disease code','Disease Code','Code de maladie'),
('add diagnosis', 'Add', 'Ajouter'),
('see diagnosis summary', 'Diagnosis', 'Diagnostique'),
('see event summary', 'Annotation', 'Annotation'),
('see treatment summary', 'Treatment', 'Traitement'),
('category & diagnosis control type', 'Cat. & Type', 'Cat. & Type');

INSERT INTO structures(`alias`) VALUES ('view_diagnosis');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='view_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisControl' AND `tablename`='diagnosis_controls' AND `field`='category' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='diagnosis_category')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='category' AND `language_tag`=''), '1', '1', '', '1', 'category & diagnosis control type', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='view_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisControl' AND `tablename`='diagnosis_controls' AND `field`='controls_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='diagnosis_type')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='diagnosis control type' AND `language_tag`=''), '1', '2', '', '1', '', '1', '-', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='view_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_dx date' AND `language_label`='dx_date' AND `language_tag`=''), '1', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='view_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='icd10_code' AND `type`='autocomplete' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=10,url=/codingicd/CodingIcd10s/autocomplete/who,tool=/codingicd/CodingIcd10s/tool/who' AND `default`='' AND `language_help`='help_primary code' AND `language_label`='disease code' AND `language_tag`=''), '1', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='view_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='topography' AND `type`='autocomplete' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=10,url=/codingicd/CodingIcdo3s/autocomplete/topo,tool=/codingicd/CodingIcdo3s/tool/topo' AND `default`='' AND `language_help`='help_topography' AND `language_label`='topography' AND `language_tag`=''), '1', '20', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');

UPDATE structure_formats SET `flag_summary`='1' WHERE structure_id IN (SELECT id FROM structures WHERE alias IN ('dx_primary','dx_secondary')) AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='morphology' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_summary`='1' WHERE structure_id IN (SELECT id FROM structures WHERE alias IN ('dx_primary','dx_secondary')) AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='topography' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

INSERT INTO structure_value_domains(`domain_name`) VALUES ('diagnosis_event_relation_type');
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("diagnosis history", "diagnosis history"),("diagnosis event", "diagnosis event");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) 
VALUES
((SELECT id FROM structure_value_domains WHERE domain_name="diagnosis_event_relation_type"),  
(SELECT id FROM structure_permissible_values WHERE value="diagnosis history" AND language_alias="diagnosis history"), "1", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="diagnosis_event_relation_type"),  
(SELECT id FROM structure_permissible_values WHERE value="diagnosis event" AND language_alias="diagnosis event"), "1", "1");

INSERT INTO structures(`alias`) VALUES ('diagnosis_event_relation_type');
INSERT INTO `structure_fields` (`id`, `public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `flag_confidential`) VALUES
(null, '', 'Clinicalannotation', 'Generated', '', 'diagnosis_event_relation_type', 'diagnosis event relation type', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='diagnosis_event_relation_type'), 'diagnosis_event_relation_type_help', 'open', 'open', 'open', 0);
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='diagnosis_event_relation_type'), 
(SELECT id FROM structure_fields WHERE `model`='Generated' AND `field`='diagnosis_event_relation_type' AND `type`='select'), '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');

INSERT IGNORE INTO i18n (id,en,fr) VALUES 
('diagnosis event relation type', 'Relation To Data', 'Lien aux données'),
('diagnosis_event_relation_type_help', 
'Allow to define the type of relation existing between the studied data (treatment, annotation) and the displayed diagnosis. Diagnosis flagged as ''Event'' has been specifically linked to the studied data.',
'Permet de définir le type de relation existant entre les données étudiées (traitement, annotation) et les diagnostices affichés. Le diagnostic marqué comme ''Événement'' a été spécifiquement liée aux données étudiées.');

REPLACE INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('clinical annotation description', '', 'Capture demographics, diagnosis, paths reports, treatment information, outcome and manage consents.', 'Enregistrer la démographie, les diagnostices, les rapports pathologiques, l''information sur les traitements, les résultats et administrer les consentements.'),
('diagnosis', '', 'Diagnosis', 'Diagnostic'),
('see diagnosis summary', '', 'Diagnosis', 'Diagnostic');


-- -----------------------------------------------------------------------------------------------------------


INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('col_copy_binding_opt', '', '', NULL);
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("1", "nothing");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="col_copy_binding_opt"),  (SELECT id FROM structure_permissible_values WHERE value="1" AND language_alias="nothing"), "1", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("2", "participant only");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="col_copy_binding_opt"),  (SELECT id FROM structure_permissible_values WHERE value="2" AND language_alias="participant only"), "2", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("3", "participant and diagnosis");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="col_copy_binding_opt"),  (SELECT id FROM structure_permissible_values WHERE value="3" AND language_alias="participant and diagnosis"), "3", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("4", "participant and consent");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="col_copy_binding_opt"),  (SELECT id FROM structure_permissible_values WHERE value="4" AND language_alias="participant and consent"), "3", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("5", "participant, consent and diagnosis");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="col_copy_binding_opt"),  (SELECT id FROM structure_permissible_values WHERE value="5" AND language_alias="participant, consent and diagnosis"), "4", "1");

INSERT INTO structures(`alias`) VALUES ('col_copy_binding_opt');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('', 'FunctionManagement', '', 'col_copy_binding_opt', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='col_copy_binding_opt') , '0', '', '5', '', 'copy linking (if it exists) to', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='col_copy_binding_opt'), (SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='col_copy_binding_opt' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='col_copy_binding_opt')  AND `flag_confidential`='0' AND `setting`='' AND `default`='5' AND `language_help`='' AND `language_label`='copy linking (if it exists) to' AND `language_tag`=''), '0', '20', 'copy options', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');

INSERT INTO structure_validations (structure_field_id, rule, language_message) VALUES
((SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='col_copy_binding_opt' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='col_copy_binding_opt')  AND `flag_confidential`='0' AND `setting`='' AND `default`='5' AND `language_help`='' AND `language_label`='copy linking (if it exists) to' AND `language_tag`=''), 'notEmpty', '');

UPDATE structure_fields SET `default`='participant collection' WHERE `model`='Collection' AND `tablename`='collections' AND `field`='collection_property' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='collection_property') AND `flag_confidential`='0';

ALTER TABLE datamart_browsing_indexes
 MODIFY notes text DEFAULT NULL;
ALTER TABLE datamart_browsing_indexes_revs
 MODIFY notes text DEFAULT NULL;
 
DELETE FROM structure_formats WHERE structure_id = (SELECT id FROM structures WHERE alias = 'consent_masters'); 
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='consent_masters'), (SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='consent_control_id' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='consent_type_list')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='type' AND `language_tag`=''), '1', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '1'),
((SELECT id FROM structures WHERE alias='consent_masters'), (SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='form_version' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=10' AND `default`='' AND `language_help`='help_form_version' AND `language_label`='form_version' AND `language_tag`=''), '1', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='consent_masters'), (SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='consent_status' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='consent_status')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_consent_status' AND `language_label`='consent status' AND `language_tag`=''), '1', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='consent_masters'), (SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='status_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='NULL' AND `language_help`='help_status_date' AND `language_label`='status date' AND `language_tag`=''), '1', '15', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='consent_masters'), (SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='consent_signed_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_consent_signed_date' AND `language_label`='consent signed date' AND `language_tag`=''), '1', '20', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='consent_masters'), (SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='reason_denied' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='cols=35,rows=6' AND `default`='' AND `language_help`='help_reason_denied' AND `language_label`='reason denied or withdrawn' AND `language_tag`=''), '1', '25', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='consent_masters'), (SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='notes' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='rows=3,cols=30' AND `default`='' AND `language_help`='help_notes' AND `language_label`='notes' AND `language_tag`=''), '1', '50', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');
  
DELETE FROM structure_formats WHERE structure_id = (SELECT id FROM structures WHERE alias = 'cd_nationals');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='cd_nationals'), (SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='date_of_referral' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_date_of_referral' AND `language_label`='referral date' AND `language_tag`=''), '2', '101', 'contact', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'),
((SELECT id FROM structures WHERE alias='cd_nationals'), (SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='route_of_referral' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='recruit_route')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_route_of_referral' AND `language_label`='' AND `language_tag`='route of referral'), '2', '102', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='cd_nationals'), (SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='date_first_contact' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='NULL' AND `language_help`='help_date_first_contact' AND `language_label`='first contact' AND `language_tag`=''), '2', '103', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='cd_nationals'), (SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='consent_person' AND `type`='select' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='person handling consent'), '2', '104', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='cd_nationals'), (SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='consent_method' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='consent_method')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_consent_method' AND `language_label`='consent method' AND `language_tag`=''), '2', '105', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='cd_nationals'), (SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='process_status' AND `type`='select' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_process_status' AND `language_label`='process status' AND `language_tag`=''), '2', '107', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='cd_nationals'), (SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='translator_indicator' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_translator_indicator' AND `language_label`='translator used' AND `language_tag`=''), '2', '111', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='cd_nationals'), (SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='translator_signature' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_translator_signature' AND `language_label`='' AND `language_tag`='translator signature captured'), '2', '212', '', '0', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
 
((SELECT id FROM structures WHERE alias='cd_nationals'), (SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='facility_other' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=25' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='other'), '2', '304', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='cd_nationals'), (SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='surgeon' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=20' AND `default`='' AND `language_help`='help_surgeon' AND `language_label`='surgeon' AND `language_tag`=''), '2', '301', 'surgery', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='cd_nationals'), (SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='operation_date' AND `type`='datetime' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='NULL' AND `language_help`='help_operation_date' AND `language_label`='operation date' AND `language_tag`='date/time'), '2', '302', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='cd_nationals'), (SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='facility' AND `type`='select' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_facility' AND `language_label`='facility' AND `language_tag`=''), '2', '303', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'); 

UPDATE consent_controls SET form_alias = 'consent_masters,cd_nationals' WHERE form_alias = 'cd_nationals'; 

UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='cd_nationals') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='process_status' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='cd_nationals') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='surgeon' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='cd_nationals') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='operation_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

INSERT INTO `structure_permissible_values_custom_controls` VALUES (null,'consent form versions',1,50);
INSERT INTO `structure_value_domains` VALUES 
(null,'custom_consent_from_verisons','open','','StructurePermissibleValuesCustom::getCustomDropdown(\'consent form versions\')');
UPDATE structure_fields SET type='select', structure_value_domain = (SELECT id FROM structure_value_domains WHERE domain_name = 'custom_consent_from_verisons'), setting = '' WHERE field = 'form_version' and model = 'ConsentMaster';

DELETE FROM structure_formats WHERE structure_id = (SELECT id FROM structures WHERE alias = 'clinicalcollectionlinks');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='clinicalcollectionlinks'), (SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='acquisition_label' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=20' AND `default`='' AND `language_help`='inv_acquisition_label_defintion' AND `language_label`='acquisition_label' AND `language_tag`=''), '0', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='clinicalcollectionlinks'), (SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='bank_id' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='banks')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='inv_collection_bank_defintion' AND `language_label`='collection bank' AND `language_tag`=''), '0', '20', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='clinicalcollectionlinks'), (SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='collection_site' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_collection_site')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='collection site' AND `language_tag`=''), '0', '30', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='clinicalcollectionlinks'), (SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='collection_datetime' AND `type`='datetime' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='inv_collection_datetime_defintion' AND `language_label`='collection datetime' AND `language_tag`=''), '0', '40', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 

((SELECT id FROM structures WHERE alias='clinicalcollectionlinks'), (SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='consent_control_id' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='consent_type_list')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='type' AND `language_tag`=''), '2', '210', '', '1', 'consent', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='clinicalcollectionlinks'), (SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='consent_status' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='consent_status')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_consent_status' AND `language_label`='consent status' AND `language_tag`=''), '2', '230', '', '1', '', '1', 'status', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='clinicalcollectionlinks'), (SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='consent_signed_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_consent_signed_date' AND `language_label`='consent signed date' AND `language_tag`=''), '2', '240', '', '1', '', '1', 'date signed', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 

((SELECT id FROM structures WHERE alias='clinicalcollectionlinks'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisControl' AND `tablename`='diagnosis_controls' AND `field`='category' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='diagnosis_category')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='category' AND `language_tag`=''), '1', '110', '', '1', 'diagnosis', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='clinicalcollectionlinks'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisControl' AND `tablename`='diagnosis_controls' AND `field`='controls_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='diagnosis_type')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='diagnosis control type' AND `language_tag`=''), '1', '120', '', '1', '', '1', '-', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='clinicalcollectionlinks'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_dx date' AND `language_label`='dx_date' AND `language_tag`=''), '1', '130', '', '1', '', '1', 'date', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='clinicalcollectionlinks'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='icd10_code' AND `type`='autocomplete' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=10,url=/codingicd/CodingIcd10s/autocomplete/who,tool=/codingicd/CodingIcd10s/tool/who' AND `default`='' AND `language_help`='help_primary code' AND `language_label`='disease code' AND `language_tag`=''), '1', '140', '', '1', '', '1', 'disease_code_short_label', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='clinicalcollectionlinks'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='topography' AND `type`='autocomplete' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=10,url=/codingicd/CodingIcdo3s/autocomplete/topo,tool=/codingicd/CodingIcdo3s/tool/topo' AND `default`='' AND `language_help`='help_topography' AND `language_label`='topography' AND `language_tag`=''), '1', '150', '', '1', '', '1', 'topography_short_label', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
('disease_code_short_label', 'Code', 'Code'),
('topography_short_label', 'Topo', 'Topo'),
('date signed', 'Signed', 'Signé');

ALTER TABLE datamart_browsing_results
 MODIFY serialized_search_params text DEFAULT NULL;
ALTER TABLE datamart_browsing_results_revs
 MODIFY serialized_search_params text DEFAULT NULL;
 
UPDATE `menus` SET `use_summary` = 'Clinicalannotation.ClinicalCollectionLink::summary' WHERE `menus`.`id` = 'clin_CAN_67' LIMIT 1 ;
UPDATE structure_formats SET `flag_summary`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='acquisition_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_summary`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='bank_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='banks') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_summary`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='collection_datetime' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- Rename existing ICD-O-3 table to ICD-O-2
ALTER TABLE `coding_icd_o_3_morphology` RENAME TO `coding_icd_o_2_morphology` ;

-- Create new table for ICD-O-3 codes. 
-- Translated flag (yes=valid french translation, no=english used as substitute)
CREATE TABLE `coding_icd_o_3_morphology` (
  `id` INT(11) UNSIGNED NOT NULL ,
  `en_description` VARCHAR(255) NOT NULL ,
  `fr_description` VARCHAR(255) NOT NULL ,
  `translated` TINYINT(1)  NOT NULL ,
  PRIMARY KEY (`id`) )
ENGINE = MyISAM
DEFAULT CHARACTER SET = latin1
COLLATE = latin1_swedish_ci;

ALTER TABLE `coding_icd_o_3_morphology` 
ADD FULLTEXT INDEX `en_description` (`en_description` ASC) 
, ADD FULLTEXT INDEX `fr_description` (`fr_description` ASC) ;

-- Insert all ICD-O-3 codes
INSERT INTO `coding_icd_o_3_morphology` VALUES (80000,'Neoplasm, benign','Tumeur bénigne',1),(80001,'Neoplasm, uncertain whether benign or malignant','Tumeur, type non déterminé (bénin ou malin)',1),(80003,'Neoplasm, malignant','Tumeur maligne',1),(80006,'Neoplasm, metastatic','Tumeur métastatique',1),(80009,'Neoplasm, malignant, uncertain whether primary or metastatic','Neoplasm, malignant, uncertain whether primary or metastatic',0),(80010,'Tumor cells, benign','Tumor cells, benign',0),(80011,'Tumor cells, uncertain whether benign or malignant','Tumor cells, uncertain whether benign or malignant',0),(80013,'Tumor cells, malignant','Tumor cells, malignant',0),(80023,'Malignant tumor, small cell type','Malignant tumor, small cell type',0),(80033,'Malignant tumor, giant cell type','Malignant tumor, giant cell type',0),(80043,'Malignant tumor, spindle cell type','Malignant tumor, spindle cell type',0),(80050,'Clear cell tumor, NOS','Clear cell tumor, NOS',0),(80053,'Malignant tumor, clear cell type','Malignant tumor, clear cell type',0),(80100,'Epithelial tumor, benign','Epithelial tumor, benign',0),(80102,'Carcinoma in situ, NOS','Carcinoma in situ, NOS',0),(80103,'Carcinoma, NOS','Carcinoma, NOS',0),(80106,'Carcinoma, metastatic, NOS','Carcinoma, metastatic, NOS',0),(80109,'Carcinomatosis','Carcinomatosis',0),(80110,'Epithelioma, benign','Épithélioma bénin',1),(80113,'Epithelioma, malignant','Épithélioma malin',1),(80123,'Large cell carcinoma, NOS','Large cell carcinoma, NOS',0),(80133,'Large cell neuroendocrine carcinoma','Large cell neuroendocrine carcinoma',0),(80143,'Large cell carcinoma with rhabdoid phenotype','Large cell carcinoma with rhabdoid phenotype',0),(80153,'Glassy cell carcinoma','Glassy cell carcinoma',0),(80203,'Carcinoma, undifferentiated, NOS','Carcinoma, undifferentiated, NOS',0),(80213,'Carcinoma, anaplastic, NOS','Carcinoma, anaplastic, NOS',0),(80223,'Pleomorphic carcinoma','Carcinome pléomorphe',1),(80303,'Giant cell and spindle cell carcinoma','Carcinome à cellules géantes et à cellules fusiformes',1),(80313,'Giant cell carcinoma','Carcinome à cellules géantes',1),(80323,'Spindle cell carcinoma, NOS','Spindle cell carcinoma, NOS',0),(80333,'Pseudosarcomatous carcinoma','Carcinome pseudosarcomateux',1),(80343,'Polygonal cell carcinoma','Carcinome à cellules polygonales',1),(80353,'Carcinoma with osteoclast-like giant cells','Carcinoma with osteoclast-like giant cells',0),(80400,'Tumorlet, benign','Tumorlet, benign',0),(80401,'Tumorlet, NOS','Tumorlet, NOS',0),(80413,'Small cell carcinoma, NOS','Small cell carcinoma, NOS',0),(80423,'Oat cell carcinoma','Carcinome à cellules en grain d\'avoine',1),(80433,'Small cell carcinoma, fusiform cell','Carcinome à petites cellules (anaplasique), type fusiforme',1),(80443,'Small cell carcinoma, intermediate cell','Small cell carcinoma, intermediate cell',0),(80453,'Combined small cell carcinoma','Combined small cell carcinoma',0),(80463,'Non-small cell carcinoma','Non-small cell carcinoma',0),(80500,'Papilloma, NOS','Papilloma, NOS',0),(80502,'Papillary carcinoma in situ','Carcinome papillaire in situ',1),(80503,'Papillary carcinoma, NOS','Papillary carcinoma, NOS',0),(80510,'Verrucous papilloma','Papillome verruqueux',1),(80513,'Verrucous carcinoma, NOS','Verrucous carcinoma, NOS',0),(80520,'Squamous cell papilloma, NOS','Squamous cell papilloma, NOS',0),(80522,'Papillary squamous cell carcinoma,  non-invasive','Papillary squamous cell carcinoma,  non-invasive',0),(80523,'Papillary squamous cell carcinoma','Carcinome épidermoïde papillaire',1),(80530,'Squamous cell papilloma, inverted','Squamous cell papilloma, inverted',0),(80600,'Squamous papillomatosis','Squamous papillomatosis',0),(80702,'Squamous cell carcinoma in situ, NOS','Squamous cell carcinoma in situ, NOS',0),(80703,'Squamous cell carcinoma, NOS','Squamous cell carcinoma, NOS',0),(80706,'Squamous cell carcinoma, metastatic, NOS','Squamous cell carcinoma, metastatic, NOS',0),(80713,'Squamous cell carcinoma, keratinizing, NOS','Squamous cell carcinoma, keratinizing, NOS',0),(80723,'Squamous cell carcinoma, large cell, nonkeratinizing, NOS','Squamous cell carcinoma, large cell, nonkeratinizing, NOS',0),(80733,'Squamous cell carcinoma, small cell, nonkeratinizing','Carcinome épidermoïde, à petites cellules, non kératinisant',1),(80743,'Squamous cell carcinoma, spindle cell','Carcinome épidermoïde, à cellules fusiformes',1),(80753,'Squamous cell carcinoma, adenoid','Squamous cell carcinoma, adenoid',0),(80762,'Squamous cell carcinoma in situ with questionable stromal invasion','Carcinome épidermoïde in situ avec envahissement stromal discutable',1),(80763,'Squamous cell carcinoma, microinvasive','Carcinome épidermoïde micro-invasif',1),(80772,'Squamous intraepithelial neoplasia, grade III','Squamous intraepithelial neoplasia, grade III',0),(80783,'Squamous cell carcinoma with horn formation','Squamous cell carcinoma with horn formation',0),(80802,'Queyrat erythroplasia','Queyrat erythroplasia',0),(80812,'Bowen disease','Bowen disease',0),(80823,'Lymphoepithelial carcinoma','Carcinome lympho-épithélial',1),(80833,'Basaloid squamous cell carcinoma','Basaloid squamous cell carcinoma',0),(80843,'Squamous cell carcinoma, clear cell type','Squamous cell carcinoma, clear cell type',0),(80901,'Basal cell tumor','Basal cell tumor',0),(80903,'Basal cell carcinoma, NOS','Basal cell carcinoma, NOS',0),(80913,'Multifocal superficial basal cell carcinoma','Multifocal superficial basal cell carcinoma',0),(80923,'Infiltrating basal cell carcinoma, NOS','Infiltrating basal cell carcinoma, NOS',0),(80933,'Basal cell carcinoma, fibroepithelial','Carcinome basocellulaire (pigmenté), type fibro-épithélial',1),(80943,'Basosquamous carcinoma','Carcinome baso-spinocellulaire, mixte',1),(80953,'Metatypical carcinoma','Carcinome métatypique',1),(80960,'Intraepidermal epithelioma of Jadassohn','Épithélioma intra-épidermique de Jadassohn',1),(80973,'Basal cell carcinoma, nodular','Basal cell carcinoma, nodular',0),(80983,'Adenoid basal carcinoma','Adenoid basal carcinoma',0),(81000,'Trichoepithelioma','Tricho-épithéliome',1),(81010,'Trichofolliculoma','Trichofolliculome',1),(81020,'Trichilemmoma','Trichilemmoma',0),(81023,'Trichilemmocarcinoma','Trichilemmocarcinoma',0),(81030,'Pilar tumor','Pilar tumor',0),(81100,'Pilomatrixoma, NOS','Pilomatrixoma, NOS',0),(81103,'Pilomatrix carcinoma','Carcinome pilomatrix',1),(81200,'Transitional cell papilloma, benign','Transitional cell papilloma, benign',0),(81201,'Urothelial papilloma, NOS','Urothelial papilloma, NOS',0),(81202,'Transitional cell carcinoma in situ','Carcinome in situ à cellules transitionnelles',1),(81203,'Transitional cell carcinoma, NOS','Transitional cell carcinoma, NOS',0),(81210,'Schneiderian papilloma, NOS','Schneiderian papilloma, NOS',0),(81211,'Transitional cell papilloma, inverted, NOS','Transitional cell papilloma, inverted, NOS',0),(81213,'Schneiderian carcinoma','Carcinome schneidérien',1),(81223,'Transitional cell carcinoma, spindle cell','Carcinome à cellules transitionnelles, type fusiforme',1),(81233,'Basaloid carcinoma','Carcinome basaloïde',1),(81243,'Cloacogenic carcinoma','Carcinome cloacogénique',1),(81301,'Papillary transitional cell neoplasm of low malignant potential','Papillary transitional cell neoplasm of low malignant potential',0),(81302,'Papillary transitional cell carcinoma,  non-invasive','Papillary transitional cell carcinoma,  non-invasive',0),(81303,'Papillary transitional cell carcinoma','Carcinome papillaire, à cellules transitionnelles',1),(81313,'Transitional cell carcinoma, micropapillary','Transitional cell carcinoma, micropapillary',0),(81400,'Adenoma, NOS','Adenoma, NOS',0),(81401,'Atypical adenoma','Atypical adenoma',0),(81402,'Adenocarcinoma in situ, NOS','Adenocarcinoma in situ, NOS',0),(81403,'Adenocarcinoma, NOS','Adenocarcinoma, NOS',0),(81406,'Adenocarcinoma, metastatic, NOS','Adenocarcinoma, metastatic, NOS',0),(81413,'Scirrhous adenocarcinoma','Adénocarcinome squirrheux',1),(81423,'Linitis plastica','Linite plastique',1),(81433,'Superficial spreading adenocarcinoma','Adénocarcinome à diffusion superficielle',1),(81443,'Adenocarcinoma, intestinal type','Adénocarcinome, type intestinal',1),(81453,'Carcinoma, diffuse type','Carcinome, type diffus',1),(81460,'Monomorphic adenoma','Adénome monomorphe',1),(81470,'Basal cell adenoma','Adénome basocellulaire',1),(81473,'Basal cell adenocarcinoma','Adénocarcinome basocellulaire',1),(81482,'Glandular intraepithelial neoplasia, grade III','Glandular intraepithelial neoplasia, grade III',0),(81490,'Canalicular adenoma','Canalicular adenoma',0),(81500,'Islet cell adenoma','Adénome insulaire (actif)',1),(81501,'Islet cell tumor, NOS','Islet cell tumor, NOS',0),(81503,'Islet cell carcinoma','Carcinome insulaire',1),(81510,'Insulinoma, NOS','Insulinoma, NOS',0),(81513,'Insulinoma, malignant','Insulinome malin',1),(81521,'Glucagonoma, NOS','Glucagonoma, NOS',0),(81523,'Glucagonoma, malignant','Glucagonome malin',1),(81531,'Gastrinoma, NOS','Gastrinoma, NOS',0),(81533,'Gastrinoma, malignant','Gastrinome malin',1),(81543,'Mixed islet cell and exocrine adenocarcinoma','Adénocarcinome insulaire et exocrine, mixte',1),(81551,'Vipoma, NOS','Vipoma, NOS',0),(81553,'Vipoma, malignant','Vipoma, malignant',0),(81561,'Somatostatinoma, NOS','Somatostatinoma, NOS',0),(81563,'Somatostatinoma, malignant','Somatostatinoma, malignant',0),(81571,'Enteroglucagonoma, NOS','Enteroglucagonoma, NOS',0),(81573,'Enteroglucagonoma, malignant','Enteroglucagonoma, malignant',0),(81600,'Bile duct adenoma','Adénome des voies biliaires',1),(81603,'Cholangiocarcinoma','Cholangiocarcinome',1),(81610,'Bile duct cystadenoma','Cystadénome biliaire',1),(81613,'Bile duct cystadenocarcinoma','Cystadénocarcinome biliaire',1),(81623,'Klatskin tumor','Klatskin tumor',0),(81700,'Liver cell adenoma','Adénome à cellules hépatiques',1),(81703,'Hepatocellular carcinoma, NOS','Hepatocellular carcinoma, NOS',0),(81713,'Hepatocellular carcinoma, fibrolamellar','Carcinome hépatocellulaire, type fibrolamellaire',1),(81723,'Hepatocellular carcinoma, scirrhous','Hepatocellular carcinoma, scirrhous',0),(81733,'Hepatocellular carcinoma, spindle cell variant','Hepatocellular carcinoma, spindle cell variant',0),(81743,'Hepatocellular carcinoma, clear cell type','Hepatocellular carcinoma, clear cell type',0),(81753,'Hepatocellular carcinoma, pleomorphic type','Hepatocellular carcinoma, pleomorphic type',0),(81803,'Combined hepatocellular carcinoma and cholangiocarcinoma','Combined hepatocellular carcinoma and cholangiocarcinoma',0),(81900,'Trabecular adenoma','Adénome trabéculaire',1),(81903,'Trabecular adenocarcinoma','Adénocarcinome trabéculaire',1),(81910,'Embryonal adenoma','Adénome embryonnaire',1),(82000,'Eccrine dermal cylindroma','Cylindrome eccrine dermique',1),(82003,'Adenoid cystic carcinoma','Carcinome adénoïde kystique',1),(82012,'Cribriform carcinoma in situ','Cribriform carcinoma in situ',0),(82013,'Cribriform carcinoma, NOS','Cribriform carcinoma, NOS',0),(82020,'Microcystic adenoma','Adénome microkystique',1),(82040,'Lactating adenoma','Lactating adenoma',0),(82100,'Adenomatous polyp, NOS','Adenomatous polyp, NOS',0),(82102,'Adenocarcinoma in situ in adenomatous polyp','Adénocarcinome in situ sur polype adénomateux',1),(82103,'Adenocarcinoma in adenomatous polyp','Adénocarcinome sur polype adénomateux',1),(82110,'Tubular adenoma, NOS','Tubular adenoma, NOS',0),(82113,'Tubular adenocarcinoma','Adénocarcinome tubuleux',1),(82120,'Flat adenoma','Flat adenoma',0),(82130,'Serrated adenoma','Serrated adenoma',0),(82143,'Parietal cell carcinoma','Parietal cell carcinoma',0),(82153,'Adenocarcinoma of anal glands','Adenocarcinoma of anal glands',0),(82200,'Adenomatous polyposis coli','Polypose adénomateuse du côlon',1),(82203,'Adenocarcinoma in adenomatous polyposis coli','Adénocarcinome sur polypose adénomateuse du côlon',1),(82210,'Multiple adenomatous polyps','Polypes adénomateux multiples',1),(82213,'Adenocarcinoma in multiple adenomatous polyps','Adénocarcinome sur polypes adénomateux multiples',1),(82302,'Ductal carcinoma in situ, solid type','Ductal carcinoma in situ, solid type',0),(82303,'Solid carcinoma, NOS','Solid carcinoma, NOS',0),(82313,'Carcinoma simplex','Carcinome simplex',1),(82401,'Carcinoid tumor of uncertain malignant potential','Carcinoid tumor of uncertain malignant potential',0),(82403,'Carcinoid tumor, NOS','Carcinoid tumor, NOS',0),(82413,'Enterochromaffin cell carcinoid','Enterochromaffin cell carcinoid',0),(82421,'Enterochromaffin-like cell carcinoid, NOS','Enterochromaffin-like cell carcinoid, NOS',0),(82423,'Enterochromaffin-like cell tumor, malignant','Enterochromaffin-like cell tumor, malignant',0),(82433,'Goblet cell carcinoid','Carcinoïde à cellules caliciformes',1),(82443,'Composite carcinoid','Carcinoïde composite',1),(82451,'Tubular carcinoid','Tubular carcinoid',0),(82453,'Adenocarcinoid tumor','Adenocarcinoid tumor',0),(82463,'Neuroendocrine carcinoma, NOS','Neuroendocrine carcinoma, NOS',0),(82473,'Merkel cell carcinoma','Carcinome à cellules de Merkel',1),(82481,'Apudoma','Apudome',1),(82493,'Atypical carcinoid tumor','Atypical carcinoid tumor',0),(82501,'Pulmonary adenomatosis','Adénomatose pulmonaire',1),(82503,'Bronchiolo-alveolar adenocarcinoma, NOS','Bronchiolo-alveolar adenocarcinoma, NOS',0),(82510,'Alveolar adenoma','Adénome alvéolaire',1),(82513,'Alveolar adenocarcinoma','Adénocarcinome alvéolaire',1),(82523,'Bronchiolo-alveolar carcinoma, non- mucinous','Bronchiolo-alveolar carcinoma, non- mucinous',0),(82533,'Bronchiolo-alveolar carcinoma, mucinous','Bronchiolo-alveolar carcinoma, mucinous',0),(82543,'Bronchiolo-alveolar carcinoma, mixed mucinous and non-mucinous','Bronchiolo-alveolar carcinoma, mixed mucinous and non-mucinous',0),(82553,'Adenocarcinoma with mixed subtypes','Adenocarcinoma with mixed subtypes',0),(82600,'Papillary adenoma, NOS','Papillary adenoma, NOS',0),(82603,'Papillary adenocarcinoma, NOS','Papillary adenocarcinoma, NOS',0),(82610,'Villous adenoma, NOS','Villous adenoma, NOS',0),(82612,'Adenocarcinoma in situ in villous adenoma','Adenocarcinoma in situ in villous adenoma',0),(82613,'Adenocarcinoma in villous adenoma','Adénocarcinome sur adénome villeux',1),(82623,'Villous adenocarcinoma','Adénocarcinome villeux',1),(82630,'Tubulovillous adenoma, NOS','Tubulovillous adenoma, NOS',0),(82632,'Adenocarcinoma in situ in tubulovillous adenoma','Adénocarcinome in situ sur adénome tubulovilleux',1),(82633,'Adenocarcinoma in tubulovillous adenoma','Adénocarcinome sur adénome tubulovilleux',1),(82640,'Papillomatosis, glandular','Papillomatosis, glandular',0),(82700,'Chromophobe adenoma','Adénome chromophobe',1),(82703,'Chromophobe carcinoma','Carcinome chromophobe',1),(82710,'Prolactinoma','Prolactinome',1),(82720,'Pituitary adenoma, NOS','Pituitary adenoma, NOS',0),(82723,'Pituitary carcinoma, NOS','Pituitary carcinoma, NOS',0),(82800,'Acidophil adenoma','Adénome acidophile',1),(82803,'Acidophil carcinoma','Carcinome acidophile',1),(82810,'Mixed acidophil-basophil adenoma','Adénome acidophile et basophile, mixte',1),(82813,'Mixed acidophil-basophil carcinoma','Carcinome acidophile et basophile, mixte',1),(82900,'Oxyphilic adenoma','Adénome oxyphile',1),(82903,'Oxyphilic adenocarcinoma','Adénocarcinome oxyphile',1),(83000,'Basophil adenoma','Adénome basophile',1),(83003,'Basophil carcinoma','Carcinome basophile',1),(83100,'Clear cell adenoma','Adénome à cellules claires',1),(83103,'Clear cell adenocarcinoma, NOS','Clear cell adenocarcinoma, NOS',0),(83111,'Hypernephroid tumor','Hypernephroid tumor',0),(83123,'Renal cell carcinoma, NOS','Renal cell carcinoma, NOS',0),(83130,'Clear cell adenofibroma','Adénofibrome à cellules claires',1),(83131,'Clear cell adenofibroma of borderline malignancy','Clear cell adenofibroma of borderline malignancy',0),(83133,'Clear cell adenocarcinofibroma','Clear cell adenocarcinofibroma',0),(83143,'Lipid-rich carcinoma','Carcinome riche en lipides',1),(83153,'Glycogen-rich carcinoma','Carcinome riche en glycogène',1),(83163,'Cyst-associated renal cell carcinoma','Cyst-associated renal cell carcinoma',0),(83173,'Renal cell carcinoma, chromophobe type','Renal cell carcinoma, chromophobe type',0),(83183,'Renal cell carcinoma, sarcomatoid','Renal cell carcinoma, sarcomatoid',0),(83193,'Collecting duct carcinoma','Collecting duct carcinoma',0),(83203,'Granular cell carcinoma','Carcinome à cellules granuleuses',1),(83210,'Chief cell adenoma','Adénome à cellules principales',1),(83220,'Water-clear cell adenoma','Adénome à cellules eau de roche',1),(83223,'Water-clear cell adenocarcinoma','Adénocarcinome à cellules eau de roche',1),(83230,'Mixed cell adenoma','Adénome à cellules mixtes (à cellules principales et à cellules eau de roche)',1),(83233,'Mixed cell adenocarcinoma','Adénocarcinome à cellules mixtes',1),(83240,'Lipoadenoma','Lipo-adénome',1),(83250,'Metanephric adenoma','Metanephric adenoma',0),(83300,'Follicular adenoma','Adénome folliculaire',1),(83301,'Atypical follicular adenoma','Atypical follicular adenoma',0),(83303,'Follicular adenocarcinoma, NOS','Follicular adenocarcinoma, NOS',0),(83313,'Follicular adenocarcinoma, well differentiated','Adénocarcinome vésiculaire, bien différencié',1),(83323,'Follicular adenocarcinoma, trabecular','Adénocarcinome vésiculaire, type trabéculaire',1),(83330,'Microfollicular adenoma, NOS','Microfollicular adenoma, NOS',0),(83333,'Fetal adenocarcinoma','Fetal adenocarcinoma',0),(83340,'Macrofollicular adenoma','Adénome macrovésiculaire',1),(83353,'Follicular carcinoma, minimally invasive','Follicular carcinoma, minimally invasive',0),(83360,'Hyalinizing trabecular adenoma','Hyalinizing trabecular adenoma',0),(83373,'Insular carcinoma','Insular carcinoma',0),(83403,'Papillary carcinoma, follicular variant','Carcinome papillaire, à variante vésiculaire',1),(83413,'Papillary microcarcinoma','Papillary microcarcinoma',0),(83423,'Papillary carcinoma, oxyphilic cell','Papillary carcinoma, oxyphilic cell',0),(83433,'Papillary carcinoma, encapsulated','Papillary carcinoma, encapsulated',0),(83443,'Papillary carcinoma, columnar cell','Papillary carcinoma, columnar cell',0),(83453,'Medullary carcinoma with amyloid stroma','Carcinome médullaire à stroma amyloïde',1),(83463,'Mixed medullary-follicular carcinoma','Mixed medullary-follicular carcinoma',0),(83473,'Mixed medullary-papillary carcinoma','Mixed medullary-papillary carcinoma',0),(83503,'Nonencapsulated sclerosing carcinoma','Carcinome sclérosant non encapsulé',1),(83601,'Multiple endocrine adenomas','Adénome endocrinien multiple',1),(83610,'Juxtaglomerular tumor','Juxtaglomerular tumor',0),(83700,'Adrenal cortical adenoma, NOS','Adrenal cortical adenoma, NOS',0),(83703,'Adrenal cortical carcinoma','Carcinome corticosurrénalien',1),(83710,'Adrenal cortical adenoma, compact cell','Adrenal cortical adenoma, compact cell',0),(83720,'Adrenal cortical adenoma, pigmented','Adrenal cortical adenoma, pigmented',0),(83730,'Adrenal cortical adenoma, clear cell','Adénome corticosurrénalien, à cellules claires',1),(83740,'Adrenal cortical adenoma, glomerulosa cell','Adénome corticosurrénalien, à cellules glomérulaires',1),(83750,'Adrenal cortical adenoma, mixed cell','Adénome corticosurrénalien, à cellules mixtes',1),(83800,'Endometrioid adenoma, NOS','Endometrioid adenoma, NOS',0),(83801,'Endometrioid adenoma, borderline malignancy','Adénome endométrioïde, à la limite de la malignité',1),(83803,'Endometrioid adenocarcinoma, NOS','Endometrioid adenocarcinoma, NOS',0),(83810,'Endometrioid adenofibroma, NOS','Endometrioid adenofibroma, NOS',0),(83811,'Endometrioid adenofibroma, borderline malignancy','Adénofibrome endométrioïde, à la limite de la malignité',1),(83813,'Endometrioid adenofibroma, malignant','Adénofibrome endométrioïde, malin',1),(83823,'Endometrioid adenocarcinoma, secretory variant','Endometrioid adenocarcinoma, secretory variant',0),(83833,'Endometrioid adenocarcinoma, ciliated cell variant','Endometrioid adenocarcinoma, ciliated cell variant',0),(83843,'Adenocarcinoma, endocervical type','Adenocarcinoma, endocervical type',0),(83900,'Skin appendage adenoma','Adénome des annexes cutanées',1),(83903,'Skin appendage carcinoma','Carcinome des annexes cutanées',1),(83910,'Follicular fibroma','Follicular fibroma',0),(83920,'Syringofibroadenoma','Syringofibroadenoma',0),(84000,'Sweat gland adenoma','Adénome des glandes sudoripares',1),(84001,'Sweat gland tumor, NOS','Sweat gland tumor, NOS',0),(84003,'Sweat gland adenocarcinoma','Adénocarcinome des glandes sudoripares',1),(84010,'Apocrine adenoma','Adénome apocrine',1),(84013,'Apocrine adenocarcinoma','Adénocarcinome apocrine',1),(84020,'Nodular hidradenoma','Nodular hidradenoma',0),(84023,'Nodular hidradenoma, malignant','Nodular hidradenoma, malignant',0),(84030,'Eccrine spiradenoma','Spiradénome eccrine',1),(84033,'Malignant eccrine spiradenoma','Malignant eccrine spiradenoma',0),(84040,'Hidrocystoma','Hidrocystome',1),(84050,'Papillary hidradenoma','Hidradénome papillaire',1),(84060,'Papillary syringadenoma','Syringo-adénome papillaire',1),(84070,'Syringoma, NOS','Syringoma, NOS',0),(84073,'Sclerosing sweat duct carcinoma','Sclerosing sweat duct carcinoma',0),(84080,'Eccrine papillary adenoma','Adénome eccrine papillaire',1),(84081,'Aggressive digital papillary adenoma','Aggressive digital papillary adenoma',0),(84083,'Eccrine papillary adenocarcinoma','Eccrine papillary adenocarcinoma',0),(84090,'Eccrine poroma','Eccrine poroma',0),(84093,'Eccrine poroma, malignant','Eccrine poroma, malignant',0),(84100,'Sebaceous adenoma','Adénome sébacé',1),(84103,'Sebaceous adenocarcinoma','Adénocarcinome sébacé',1),(84133,'Eccrine adenocarcinoma','Eccrine adenocarcinoma',0),(84200,'Ceruminous adenoma','Adénome cérumineux',1),(84203,'Ceruminous adenocarcinoma','Adénocarcinome cérumineux',1),(84301,'Mucoepidermoid tumor','Mucoepidermoid tumor',0),(84303,'Mucoepidermoid carcinoma','Carcinome muco-épidermoïde',1),(84400,'Cystadenoma, NOS','Cystadenoma, NOS',0),(84403,'Cystadenocarcinoma, NOS','Cystadenocarcinoma, NOS',0),(84410,'Serous cystadenoma, NOS','Serous cystadenoma, NOS',0),(84413,'Serous cystadenocarcinoma, NOS','Serous cystadenocarcinoma, NOS',0),(84421,'Serous cystadenoma, borderline malignancy','Cystadénome séreux, à la limite de la malignité',1),(84430,'Clear cell cystadenoma','Clear cell cystadenoma',0),(84441,'Clear cell cystic tumor of borderline malignancy','Clear cell cystic tumor of borderline malignancy',0),(84500,'Papillary cystadenoma, NOS','Papillary cystadenoma, NOS',0),(84503,'Papillary cystadenocarcinoma, NOS','Papillary cystadenocarcinoma, NOS',0),(84511,'Papillary cystadenoma, borderline malignancy','Papillary cystadenoma, borderline malignancy',0),(84521,'Solid pseudopapillary tumor','Solid pseudopapillary tumor',0),(84523,'Solid pseudopapillary carcinoma','Solid pseudopapillary carcinoma',0),(84530,'Intraductal papillary-mucinous adenoma','Intraductal papillary-mucinous adenoma',0),(84531,'Intraductal papillary-mucinous tumor with moderate dysplasia','Intraductal papillary-mucinous tumor with moderate dysplasia',0),(84532,'Intraductal papillary-mucinous carcinoma, non-invasive','Intraductal papillary-mucinous carcinoma, non-invasive',0),(84533,'Intraductal papillary-mucinous carcinoma, invasive','Intraductal papillary-mucinous carcinoma, invasive',0),(84540,'Cystic tumor of atrio-ventricular node','Cystic tumor of atrio-ventricular node',0),(84600,'Papillary serous cystadenoma, NOS','Papillary serous cystadenoma, NOS',0),(84603,'Papillary serous cystadenocarcinoma','Cystadénocarcinome papillaire séreux',1),(84610,'Serous surface papilloma','Papillome séreux de surface',1),(84613,'Serous surface papillary carcinoma','Carcinome papillaire séreux de surface',1),(84621,'Serous papillary cystic tumor of borderline malignancy','Serous papillary cystic tumor of borderline malignancy',0),(84631,'Serous surface papillary tumor of borderline malignancy','Serous surface papillary tumor of borderline malignancy',0),(84700,'Mucinous cystadenoma, NOS','Mucinous cystadenoma, NOS',0),(84701,'Mucinous cystic tumor with moderate dysplasia','Mucinous cystic tumor with moderate dysplasia',0),(84702,'Mucinous cystadenocarcinoma, non-invasive','Mucinous cystadenocarcinoma, non-invasive',0),(84703,'Mucinous cystadenocarcinoma, NOS','Mucinous cystadenocarcinoma, NOS',0),(84710,'Papillary mucinous cystadenoma, NOS','Papillary mucinous cystadenoma, NOS',0),(84713,'Papillary mucinous cystadenocarcinoma','Cystadénocarcinome papillaire mucineux',1),(84721,'Mucinous cystic tumor of borderline malignancy','Mucinous cystic tumor of borderline malignancy',0),(84731,'Papillary mucinous cystadenoma, borderline malignancy','Cystadénome papillaire mucineux, à faible potentiel malin',1),(84800,'Mucinous adenoma','Adénome mucineux',1),(84803,'Mucinous adenocarcinoma','Adénocarcinome mucineux',1),(84806,'Pseudomyxoma peritonei','Pseudomyxoma peritonei',0),(84813,'Mucin-producing adenocarcinoma','Adénocarcinome mucosécrétant',1),(84823,'Mucinous adenocarcinoma, endocervical type','Mucinous adenocarcinoma, endocervical type',0),(84903,'Signet ring cell carcinoma','Carcinome à cellules en bague à chaton',1),(84906,'Metastatic signet ring cell carcinoma','Carcinome à cellules en bague à chaton, métastatique',1),(85002,'Intraductal carcinoma, noninfiltrating, NOS','Intraductal carcinoma, noninfiltrating, NOS',0),(85003,'Infiltrating duct carcinoma, NOS','Infiltrating duct carcinoma, NOS',0),(85012,'Comedocarcinoma, noninfiltrating','Comédocarcinome, non infiltrant',1),(85013,'Comedocarcinoma, NOS','Comedocarcinoma, NOS',0),(85023,'Secretory carcinoma of breast','Secretory carcinoma of breast',0),(85030,'Intraductal papilloma','Papillome intracanalaire',1),(85032,'Noninfiltrating intraductal papillary adenocarcinoma','Adénocarcinome intracanalaire, non infiltrant, papillaire',1),(85033,'Intraductal papillary adenocarcinoma with invasion','Adénocarcinome intracanalaire, papillaire, invasif',1),(85040,'Intracystic papillary adenoma','Adénome intrakystique papillaire',1),(85042,'Noninfiltrating intracystic carcinoma','Carcinome intrakystique non infiltrant',1),(85043,'Intracystic carcinoma, NOS','Intracystic carcinoma, NOS',0),(85050,'Intraductal papillomatosis, NOS','Intraductal papillomatosis, NOS',0),(85060,'Adenoma of nipple','Adénome du mamelon',1),(85072,'Intraductal micropapillary carcinoma','Intraductal micropapillary carcinoma',0),(85083,'Cystic hypersecretory carcinoma','Cystic hypersecretory carcinoma',0),(85103,'Medullary carcinoma, NOS','Medullary carcinoma, NOS',0),(85123,'Medullary carcinoma with lymphoid stroma','Medullary carcinoma with lymphoid stroma',0),(85133,'Atypical medullary carcinoma','Atypical medullary carcinoma',0),(85143,'Duct carcinoma, desmoplastic type','Duct carcinoma, desmoplastic type',0),(85202,'Lobular carcinoma in situ, NOS','Lobular carcinoma in situ, NOS',0),(85203,'Lobular carcinoma, NOS','Lobular carcinoma, NOS',0),(88510,'Fibrolipoma','Fibrolipome',1),(88513,'Liposarcoma, well differentiated','Liposarcome bien différencié',1),(88520,'Fibromyxolipoma','Fibromyxolipome',1),(88523,'Myxoid liposarcoma','Liposarcome myxoïde',1),(88533,'Round cell liposarcoma','Liposarcome à cellules rondes',1),(88540,'Pleomorphic lipoma','Lipome polymorphe',1),(88543,'Pleomorphic liposarcoma','Liposarcome polymorphe',1),(88553,'Mixed liposarcoma','Liposarcome à cellularité mixte',1),(88560,'Intramuscular lipoma','Lipome intramusculaire',1),(88570,'Spindle cell lipoma','Lipome à cellules fusiformes',1),(88573,'Fibroblastic liposarcoma','Fibroblastic liposarcoma',0),(88583,'Dedifferentiated liposarcoma','Liposarcome dédifférencié',1),(88600,'Angiomyolipoma','Angiomyolipome',1),(88610,'Angiolipoma, NOS','Angiolipoma, NOS',0),(88620,'Chondroid lipoma','Chondroid lipoma',0),(88700,'Myelolipoma','Myélolipome',1),(88800,'Hibernoma','Hibernome',1),(88810,'Lipoblastomatosis','Lipoblastomatose',1),(88900,'Leiomyoma, NOS','Leiomyoma, NOS',0),(88901,'Leiomyomatosis, NOS','Leiomyomatosis, NOS',0),(88903,'Leiomyosarcoma, NOS','Leiomyosarcoma, NOS',0),(88910,'Epithelioid leiomyoma','Léiomyome épithélioïde',1),(88913,'Epithelioid leiomyosarcoma','Léiomyosarcome épithélioïde',1),(88920,'Cellular leiomyoma','Léiomyome cellulaire',1),(88930,'Bizarre leiomyoma','Léiomyome bizarre',1),(88940,'Angiomyoma','Angiomyome',1),(88943,'Angiomyosarcoma','Angiomyosarcome',1),(88950,'Myoma','Myome',1),(88953,'Myosarcoma','Myosarcome',1),(88963,'Myxoid leiomyosarcoma','Léiomyosarcome myxoïde',1),(88971,'Smooth muscle tumor of uncertain malignant potential','Smooth muscle tumor of uncertain malignant potential',0),(88981,'Metastasizing leiomyoma','Metastasizing leiomyoma',0),(89000,'Rhabdomyoma, NOS','Rhabdomyoma, NOS',0),(89003,'Rhabdomyosarcoma, NOS','Rhabdomyosarcoma, NOS',0),(89013,'Pleomorphic rhabdomyosarcoma, adult type','Pleomorphic rhabdomyosarcoma, adult type',0),(89023,'Mixed type rhabdomyosarcoma','Rhabdomyosarcome à cellularité mixte',1),(89030,'Fetal rhabdomyoma','Rhabdomyome foetal',1),(89040,'Adult rhabdomyoma','Rhabdomyome adulte',1),(89050,'Genital rhabdomyoma','Genital rhabdomyoma',0),(89103,'Embryonal rhabdomyosarcoma, NOS','Embryonal rhabdomyosarcoma, NOS',0),(89123,'Spindle cell rhabdomyosarcoma','Spindle cell rhabdomyosarcoma',0),(89203,'Alveolar rhabdomyosarcoma','Rhabdomyosarcome alvéolaire',1),(89213,'Rhabdomyosarcoma with ganglionic differentiation','Rhabdomyosarcoma with ganglionic differentiation',0),(89300,'Endometrial stromal nodule','Nodule du chorion cytogène',1),(89303,'Endometrial stromal sarcoma, NOS','Endometrial stromal sarcoma, NOS',0),(89313,'Endometrial stromal sarcoma, low grade','Endometrial stromal sarcoma, low grade',0),(89320,'Adenomyoma','Adénomyome',1),(89333,'Adenosarcoma','Adénosarcome',1),(89343,'Carcinofibroma','Carcinofibroma',0),(89350,'Stromal tumor, benign','Stromal tumor, benign',0),(89351,'Stromal tumor, NOS','Stromal tumor, NOS',0),(89353,'Stromal sarcoma, NOS','Stromal sarcoma, NOS',0),(93000,'Adenomatoid odontogenic tumor','Adenomatoid odontogenic tumor',0),(93010,'Calcifying odontogenic cyst','Kyste odontogénique calcifiant',1),(93020,'Odontogenic ghost cell tumor','Odontogenic ghost cell tumor',0),(93100,'Ameloblastoma, NOS','Ameloblastoma, NOS',0),(93103,'Ameloblastoma, malignant','Améloblastome malin',1),(93110,'Odontoameloblastoma','Odonto-améloblastome',1),(93120,'Squamous odontogenic tumor','Squamous odontogenic tumor',0),(93200,'Odontogenic myxoma','Myxome odontogène',1),(93210,'Central odontogenic fibroma','Fibrome odontogène central',1),(93220,'Peripheral odontogenic fibroma','Fibrome odontogène périphérique',1),(93300,'Ameloblastic fibroma','Fibrome améloblastique',1),(93303,'Ameloblastic fibrosarcoma','Fibrosarcome améloblastique',1),(93400,'Calcifying epithelial odontogenic tumor','Calcifying epithelial odontogenic tumor',0),(93411,'Clear cell odontogenic tumor','Clear cell odontogenic tumor',0),(93423,'Odontogenic carcinosarcoma','Odontogenic carcinosarcoma',0),(93501,'Craniopharyngioma','Craniopharyngiome',1),(93511,'Craniopharyngioma, adamantinomatous','Craniopharyngioma, adamantinomatous',0),(93521,'Craniopharyngioma, papillary','Craniopharyngioma, papillary',0),(93601,'Pinealoma','Pinéalome',1),(93611,'Pineocytoma','Pinéocytome',1),(93623,'Pineoblastoma','Pinéoblastome',1),(93630,'Melanotic neuroectodermal tumor','Melanotic neuroectodermal tumor',0),(93643,'Peripheral neuroectodermal tumor','Peripheral neuroectodermal tumor',0),(93653,'Askin tumor','Askin tumor',0),(93703,'Chordoma, NOS','Chordoma, NOS',0),(93713,'Chondroid chordoma','Chondroid chordoma',0),(93723,'Dedifferentiated chordoma','Dedifferentiated chordoma',0),(93730,'Parachordoma','Parachordoma',0),(93803,'Glioma, malignant','Gliome malin',1),(93813,'Gliomatosis cerebri','Gliomatose du cerveau',1),(93823,'Mixed glioma','Gliome mixte',1),(93831,'Subependymoma','Subependymoma',0),(93841,'Subependymal giant cell astrocytoma','Astrocytome sous-épendymaire à cellules géantes',1),(93900,'Choroid plexus papilloma, NOS','Choroid plexus papilloma, NOS',0),(93901,'Atypical choroid plexus papilloma','Atypical choroid plexus papilloma',0),(93903,'Choroid plexus carcinoma','Choroid plexus carcinoma',0),(93913,'Ependymoma, NOS','Ependymoma, NOS',0),(85213,'Infiltrating ductular carcinoma','Carcinome canaliculaire, infiltrant',1),(85222,'Intraductal carcinoma and lobular carcinoma in situ','Intraductal carcinoma and lobular carcinoma in situ',0),(85223,'Infiltrating duct and lobular carcinoma','Carcinome canalaire infiltrant avec carcinome lobulaire (in situ)',1),(85233,'Infiltrating duct mixed with other types of carcinoma','Infiltrating duct mixed with other types of carcinoma',0),(85243,'Infiltrating lobular mixed with other types of carcinoma','Infiltrating lobular mixed with other types of carcinoma',0),(85253,'Polymorphous low grade adenocarcinoma','Polymorphous low grade adenocarcinoma',0),(85303,'Inflammatory carcinoma','Carcinome inflammatoire',1),(85403,'Paget disease, mammary','Paget disease, mammary',0),(85413,'Paget disease and infiltrating duct carcinoma of breast','Paget disease and infiltrating duct carcinoma of breast',0),(85423,'Paget disease, extramammary','Paget disease, extramammary',0),(85433,'Paget disease and intraductal carcinoma of breast','Paget disease and intraductal carcinoma of breast',0),(85500,'Acinar cell adenoma','Adénome à cellules acineuses',1),(85501,'Acinar cell tumor','Acinar cell tumor',0),(85503,'Acinar cell carcinoma','Carcinome à cellules acineuses',1),(85513,'Acinar cell cystadenocarcinoma','Acinar cell cystadenocarcinoma',0),(85600,'Mixed squamous cell and glandular papilloma','Mixed squamous cell and glandular papilloma',0),(85603,'Adenosquamous carcinoma','Carcinome adénosquameux',1),(85610,'Adenolymphoma','Adénolymphome',1),(85623,'Epithelial-myoepithelial carcinoma','Carcinome épithélial et myoépithélial',1),(85703,'Adenocarcinoma with squamous metaplasia','Adéno-acanthome',1),(85713,'Adenocarcinoma with cartilaginous and osseous metaplasia','Adenocarcinoma with cartilaginous and osseous metaplasia',0),(85723,'Adenocarcinoma with spindle cell metaplasia','Adénocarcinome avec métaplasie fusocellulaire',1),(85733,'Adenocarcinoma with apocrine metaplasia','Adénocarcinome avec métaplasie apocrine',1),(85743,'Adenocarcinoma with neuroendocrine differentiation','Adenocarcinoma with neuroendocrine differentiation',0),(85753,'Metaplastic carcinoma, NOS','Metaplastic carcinoma, NOS',0),(85763,'Hepatoid adenocarcinoma','Hepatoid adenocarcinoma',0),(85800,'Thymoma, benign','Thymome bénin',1),(85801,'Thymoma, NOS','Thymoma, NOS',0),(85803,'Thymoma, malignant, NOS','Thymoma, malignant, NOS',0),(85811,'Thymoma, type A, NOS','Thymoma, type A, NOS',0),(85813,'Thymoma, type A, malignant','Thymoma, type A, malignant',0),(85821,'Thymoma, type AB, NOS','Thymoma, type AB, NOS',0),(85823,'Thymoma, type AB, malignant','Thymoma, type AB, malignant',0),(85831,'Thymoma, type B1, NOS','Thymoma, type B1, NOS',0),(85833,'Thymoma, type B1, malignant','Thymoma, type B1, malignant',0),(85841,'Thymoma, type B2, NOS','Thymoma, type B2, NOS',0),(85843,'Thymoma, type B2, malignant','Thymoma, type B2, malignant',0),(85851,'Thymoma, type B3, NOS','Thymoma, type B3, NOS',0),(85853,'Thymoma, type B3, malignant','Thymoma, type B3, malignant',0),(85863,'Thymic carcinoma, NOS','Thymic carcinoma, NOS',0),(85870,'Ectopic hamartomatous thymoma','Ectopic hamartomatous thymoma',0),(85883,'Spindle epithelial tumor with thymus-like element','Spindle epithelial tumor with thymus-like element',0),(85893,'Carcinoma showing thymus-like element','Carcinoma showing thymus-like element',0),(85901,'Sex cord-gonadal stromal tumor, NOS','Sex cord-gonadal stromal tumor, NOS',0),(85911,'Sex cord-gonadal stromal tumor, incompletely differentiated','Sex cord-gonadal stromal tumor, incompletely differentiated',0),(85921,'Sex cord-gonadal stromal tumor, mixed forms','Sex cord-gonadal stromal tumor, mixed forms',0),(85931,'Stromal tumor with minor sex cord elements','Stromal tumor with minor sex cord elements',0),(86000,'Thecoma, NOS','Thecoma, NOS',0),(86003,'Thecoma, malignant','Thécome malin',1),(86010,'Thecoma, luteinized','Thécome lutéinisé',1),(86020,'Sclerosing stromal tumor','Sclerosing stromal tumor',0),(86100,'Luteoma, NOS','Luteoma, NOS',0),(86201,'Granulosa cell tumor, adult type','Granulosa cell tumor, adult type',0),(86203,'Granulosa cell tumor, malignant','Granulosa cell tumor, malignant',0),(86211,'Granulosa cell-theca cell tumor','Granulosa cell-theca cell tumor',0),(86221,'Granulosa cell tumor, juvenile','Granulosa cell tumor, juvenile',0),(86231,'Sex cord tumor with annular tubules','Sex cord tumor with annular tubules',0),(86300,'Androblastoma, benign','Androblastome bénin',1),(86301,'Androblastoma, NOS','Androblastoma, NOS',0),(86303,'Androblastoma, malignant','Androblastome malin',1),(86310,'Sertoli-Leydig cell tumor, well differentiated','Sertoli-Leydig cell tumor, well differentiated',0),(86311,'Sertoli-Leydig cell tumor of intermediate differentiation','Sertoli-Leydig cell tumor of intermediate differentiation',0),(86313,'Sertoli-Leydig cell tumor, poorly differentiated','Sertoli-Leydig cell tumor, poorly differentiated',0),(86321,'Gynandroblastoma','Gynandroblastome',1),(86331,'Sertoli-Leydig cell tumor, retiform','Sertoli-Leydig cell tumor, retiform',0),(86341,'Sertoli-Leydig cell tumor, intermediate differentiation, with heterologous elements','Sertoli-Leydig cell tumor, intermediate differentiation, with heterologous elements',0),(86343,'Sertoli-Leydig cell tumor, poorly differentiated, with heterologous elements','Sertoli-Leydig cell tumor, poorly differentiated, with heterologous elements',0),(86401,'Sertoli cell tumor, NOS','Sertoli cell tumor, NOS',0),(86403,'Sertoli cell carcinoma','Carcinome à cellules de Sertoli',1),(86410,'Sertoli cell tumor with lipid storage','Sertoli cell tumor with lipid storage',0),(86421,'Large cell calcifying Sertoli cell tumor','Large cell calcifying Sertoli cell tumor',0),(86500,'Leydig cell tumor, benign','Leydig cell tumor, benign',0),(86501,'Leydig cell tumor, NOS','Leydig cell tumor, NOS',0),(86503,'Leydig cell tumor, malignant','Leydig cell tumor, malignant',0),(86600,'Hilus cell tumor','Hilus cell tumor',0),(86700,'Lipid cell tumor of ovary','Lipid cell tumor of ovary',0),(86703,'Steroid cell tumor, malignant','Steroid cell tumor, malignant',0),(86710,'Adrenal rest tumor','Adrenal rest tumor',0),(86800,'Paraganglioma, benign','Paraganglioma, benign',0),(86801,'Paraganglioma, NOS','Paraganglioma, NOS',0),(86803,'Paraganglioma, malignant','Paragangliome malin',1),(86811,'Sympathetic paraganglioma','Paragangliome sympathique',1),(86821,'Parasympathetic paraganglioma','Paragangliome parasympathique',1),(86830,'Gangliocytic paraganglioma','Paragangliome gangliocytaire',1),(86901,'Glomus jugulare tumor, NOS','Glomus jugulare tumor, NOS',0),(86911,'Aortic body tumor','Aortic body tumor',0),(86921,'Carotid body tumor','Carotid body tumor',0),(86931,'Extra-adrenal paraganglioma, NOS','Extra-adrenal paraganglioma, NOS',0),(86933,'Extra-adrenal paraganglioma, malignant','Paragangliome extrasurrénalien malin',1),(87000,'Pheochromocytoma, NOS','Pheochromocytoma, NOS',0),(87003,'Pheochromocytoma, malignant','Pheochromocytoma, malignant',0),(87103,'Glomangiosarcoma','Glomangiosarcome',1),(87110,'Glomus tumor, NOS','Glomus tumor, NOS',0),(87113,'Glomus tumor, malignant','Glomus tumor, malignant',0),(87120,'Glomangioma','Glomangiome',1),(87130,'Glomangiomyoma','Glomangiomyome',1),(87200,'Pigmented nevus, NOS','Pigmented nevus, NOS',0),(87202,'Melanoma in situ','Mélanome in situ',1),(87203,'Malignant melanoma, NOS','Malignant melanoma, NOS',0),(87213,'Nodular melanoma','Mélanome nodulaire',1),(87220,'Balloon cell nevus','Balloon cell nevus',0),(87223,'Balloon cell melanoma','Mélanome à cellules ballonnisantes, ballonnisées',1),(87230,'Halo nevus','Halo nevus',0),(87233,'Malignant melanoma, regressing','Mélanome malin en voie de régression',1),(87250,'Neuronevus','Neuronevus',0),(87260,'Magnocellular nevus','Magnocellular nevus',0),(87270,'Dysplastic nevus','Dysplastic nevus',0),(87280,'Diffuse melanocytosis','Diffuse melanocytosis',0),(87281,'Meningeal melanocytoma','Meningeal melanocytoma',0),(87283,'Meningeal melanomatosis','Meningeal melanomatosis',0),(87300,'Nonpigmented nevus','Nonpigmented nevus',0),(87303,'Amelanotic melanoma','Mélanome achromique',1),(87400,'Junctional nevus, NOS','Junctional nevus, NOS',0),(87403,'Malignant melanoma in junctional nevus','Malignant melanoma in junctional nevus',0),(87412,'Precancerous melanosis, NOS','Precancerous melanosis, NOS',0),(87413,'Malignant melanoma in precancerous melanosis','Malignant melanoma in precancerous melanosis',0),(87422,'Lentigo maligna','Lentigo maligna',0),(87423,'Lentigo maligna melanoma','Lentigo maligna melanoma',0),(87433,'Superficial spreading melanoma','Mélanome à extension superficielle',1),(87443,'Acral lentiginous melanoma, malignant','Mélanome lentigineux malin des extrémités',1),(87453,'Desmoplastic melanoma, malignant','Mélanome desmoplasique, malin',1),(87463,'Mucosal lentiginous melanoma','Mucosal lentiginous melanoma',0),(87500,'Intradermal nevus','Intradermal nevus',0),(87600,'Compound nevus','Compound nevus',0),(87610,'Small congenital nevus','Small congenital nevus',0),(87611,'Giant pigmented nevus, NOS','Giant pigmented nevus, NOS',0),(87613,'Malignant melanoma in giant pigmented nevus','Malignant melanoma in giant pigmented nevus',0),(87621,'Proliferative dermal lesion in congenital nevus','Proliferative dermal lesion in congenital nevus',0),(87700,'Epithelioid and spindle cell nevus','Epithelioid and spindle cell nevus',0),(87703,'Mixed epithelioid and spindle cell melanoma','Mixed epithelioid and spindle cell melanoma',0),(87710,'Epithelioid cell nevus','Epithelioid cell nevus',0),(87713,'Epithelioid cell melanoma','Mélanome à cellules épithélioïdes',1),(87720,'Spindle cell nevus, NOS','Spindle cell nevus, NOS',0),(87723,'Spindle cell melanoma, NOS','Spindle cell melanoma, NOS',0),(87733,'Spindle cell melanoma, type A','Mélanome à cellules fusiformes, type A',1),(87743,'Spindle cell melanoma, type B','Mélanome à cellules fusiformes, type B',1),(87800,'Blue nevus, NOS','Blue nevus, NOS',0),(87803,'Blue nevus, malignant','Blue nevus, malignant',0),(87900,'Cellular blue nevus','Cellular blue nevus',0),(88000,'Soft tissue tumor, benign','Soft tissue tumor, benign',0),(88003,'Sarcoma, NOS','Sarcoma, NOS',0),(88009,'Sarcomatosis, NOS','Sarcomatosis, NOS',0),(88013,'Spindle cell sarcoma','Sarcome à cellules fusiformes',1),(88023,'Giant cell sarcoma','Sarcome à cellules géantes (à l\'exception de l\'os)',1),(88033,'Small cell sarcoma','Sarcome à petites cellules',1),(88043,'Epithelioid sarcoma','Sarcome à cellules épithélioïdes',1),(88053,'Undifferentiated sarcoma','Undifferentiated sarcoma',0),(88063,'Desmoplastic small round cell tumor','Desmoplastic small round cell tumor',0),(88100,'Fibroma, NOS','Fibroma, NOS',0),(88101,'Cellular fibroma','Cellular fibroma',0),(88103,'Fibrosarcoma, NOS','Fibrosarcoma, NOS',0),(88110,'Fibromyxoma','Fibromyxome',1),(88113,'Fibromyxosarcoma','Fibromyxosarcome',1),(88120,'Periosteal fibroma','Fibrome périostéal',1),(88123,'Periosteal fibrosarcoma','Fibrosarcome périostéal',1),(88130,'Fascial fibroma','Fibrome aponévrotique',1),(88133,'Fascial fibrosarcoma','Fibrosarcome aponévrotique',1),(88143,'Infantile fibrosarcoma','Fibrosarcome infantile',1),(88150,'Solitary fibrous tumor','Solitary fibrous tumor',0),(88153,'Solitary fibrous tumor, malignant','Solitary fibrous tumor, malignant',0),(88200,'Elastofibroma','Élastofibrome',1),(88211,'Aggressive fibromatosis','Fibromatose agressive',1),(88221,'Abdominal fibromatosis','Fibromatose abdominale',1),(88230,'Desmoplastic fibroma','Fibrome desmoplasique',1),(88240,'Myofibroma','Myofibroma',0),(88241,'Myofibromatosis','Myofibromatose',1),(88250,'Myofibroblastoma','Myofibroblastoma',0),(88251,'Myofibroblastic tumor, NOS','Myofibroblastic tumor, NOS',0),(88260,'Angiomyofibroblastoma','Angiomyofibroblastoma',0),(88271,'Myofibroblastic tumor, peribronchial','Myofibroblastic tumor, peribronchial',0),(88300,'Benign fibrous histiocytoma','Benign fibrous histiocytoma',0),(88301,'Atypical fibrous histiocytoma','Histiocytome fibreux atypique',1),(88303,'Malignant fibrous histiocytoma','Malignant fibrous histiocytoma',0),(88310,'Histiocytoma, NOS','Histiocytoma, NOS',0),(88320,'Dermatofibroma, NOS','Dermatofibroma, NOS',0),(88323,'Dermatofibrosarcoma, NOS','Dermatofibrosarcoma, NOS',0),(88333,'Pigmented dermatofibrosarcoma protuberans','Dermatofibrosarcome protubérant pigmenté',1),(88341,'Giant cell fibroblastoma','Giant cell fibroblastoma',0),(88351,'Plexiform fibrohistiocytic tumor','Plexiform fibrohistiocytic tumor',0),(88361,'Angiomatoid fibrous histiocytoma','Angiomatoid fibrous histiocytoma',0),(88400,'Myxoma, NOS','Myxoma, NOS',0),(88403,'Myxosarcoma','Myxosarcome',1),(88411,'Angiomyxoma','Angiomyxome',1),(88420,'Ossifying fibromyxoid tumor','Ossifying fibromyxoid tumor',0),(88500,'Lipoma, NOS','Lipoma, NOS',0),(88501,'Atypical lipoma/j','Atypical lipoma/j',0),(88503,'Liposarcoma, NOS','Liposarcoma, NOS',0),(89360,'Gastrointestinal stromal tumor, benign','Gastrointestinal stromal tumor, benign',0),(89361,'Gastrointestinal stromal tumor, NOS','Gastrointestinal stromal tumor, NOS',0),(89363,'Gastrointestinal stromal sarcoma','Gastrointestinal stromal sarcoma',0),(89400,'Pleomorphic adenoma','Adénome pléomorphe',1),(89403,'Mixed tumor, malignant, NOS','Mixed tumor, malignant, NOS',0),(89413,'Carcinoma in pleomorphic adenoma','Carcinome sur adénome pléomorphe',1),(89503,'Mullerian mixed tumor','Mullerian mixed tumor',0),(89513,'Mesodermal mixed tumor','Mesodermal mixed tumor',0),(89590,'Benign cystic nephroma','Benign cystic nephroma',0),(89591,'Cystic partially differentiated nephroblastoma','Cystic partially differentiated nephroblastoma',0),(89593,'Malignant cystic nephroma','Malignant cystic nephroma',0),(89601,'Mesoblastic nephroma','Néphrome mésoblastique',1),(89603,'Nephroblastoma, NOS','Nephroblastoma, NOS',0),(89633,'Malignant rhabdoid tumor','Malignant rhabdoid tumor',0),(89643,'Clear cell sarcoma of kidney','Sarcome à cellules claires du rein',1),(89650,'Nephrogenic adenofibroma','Nephrogenic adenofibroma',0),(89660,'Renomedullary interstitial cell tumor','Renomedullary interstitial cell tumor',0),(89670,'Ossifying renal tumor','Ossifying renal tumor',0),(89703,'Hepatoblastoma','Hépatoblastome',1),(89713,'Pancreatoblastoma','Pancréatoblastome',1),(89723,'Pulmonary blastoma','Blastome pulmonaire',1),(89733,'Pleuropulmonary blastoma','Pleuropulmonary blastoma',0),(89741,'Sialoblastoma','Sialoblastoma',0),(89803,'Carcinosarcoma, NOS','Carcinosarcoma, NOS',0),(89813,'Carcinosarcoma, embryonal','Carcinosarcome embryonnaire',1),(89820,'Myoepithelioma','Myo-épithéliome',1),(89823,'Malignant myoepithelioma','Malignant myoepithelioma',0),(89830,'Adenomyoepithelioma','Adenomyoepithelioma',0),(89900,'Mesenchymoma, benign','Mésenchymome bénin',1),(89901,'Mesenchymoma, NOS','Mesenchymoma, NOS',0),(89903,'Mesenchymoma, malignant','Mésenchymome malin',1),(89913,'Embryonal sarcoma','Sarcome embryonnaire',1),(90000,'Brenner tumor, NOS','Brenner tumor, NOS',0),(90001,'Brenner tumor, borderline malignancy','Brenner tumor, borderline malignancy',0),(90003,'Brenner tumor, malignant','Brenner tumor, malignant',0),(90100,'Fibroadenoma, NOS','Fibroadenoma, NOS',0),(90110,'Intracanalicular fibroadenoma','Fibroadénome intracanaliculaire',1),(90120,'Pericanalicular fibroadenoma','Fibroadénome péricanaliculaire',1),(90130,'Adenofibroma, NOS','Adenofibroma, NOS',0),(90140,'Serous adenofibroma, NOS','Serous adenofibroma, NOS',0),(90141,'Serous adenofibroma of borderline malignancy','Serous adenofibroma of borderline malignancy',0),(90143,'Serous adenocarcinofibroma','Serous adenocarcinofibroma',0),(90150,'Mucinous adenofibroma, NOS','Mucinous adenofibroma, NOS',0),(90151,'Mucinous adenofibroma of borderline malignancy','Mucinous adenofibroma of borderline malignancy',0),(90153,'Mucinous adenocarcinofibroma','Mucinous adenocarcinofibroma',0),(90160,'Giant fibroadenoma','Fibro-adénome géant',1),(90200,'Phyllodes tumor, benign','Phyllodes tumor, benign',0),(90201,'Phyllodes tumor, borderline','Phyllodes tumor, borderline',0),(90203,'Phyllodes tumor, malignant','Phyllodes tumor, malignant',0),(90300,'Juvenile fibroadenoma','Fibro-adénome juvénile',1),(90400,'Synovioma, benign','Synoviome bénin',1),(90403,'Synovial sarcoma, NOS','Synovial sarcoma, NOS',0),(90413,'Synovial sarcoma, spindle cell','Sarcome synovial, à cellules fusiformes',1),(90423,'Synovial sarcoma, epithelioid cell','Sarcome synovial, à cellules épithélioïdes',1),(90433,'Synovial sarcoma, biphasic','Sarcome synovial, de type biphasique',1),(90443,'Clear cell sarcoma, NOS','Clear cell sarcoma, NOS',0),(90500,'Mesothelioma, benign','Mésothéliome bénin',1),(90503,'Mesothelioma, malignant','Mésothéliome malin',1),(90510,'Fibrous mesothelioma, benign','Mésothéliome fibreux bénin',1),(90513,'Fibrous mesothelioma, malignant','Mésothéliome fibreux malin',1),(90520,'Epithelioid mesothelioma, benign','Mésothéliome épithélioïde bénin',1),(90523,'Epithelioid mesothelioma, malignant','Mésothéliome épithélioïde malin',1),(90533,'Mesothelioma, biphasic, malignant','Mésothéliome biphasique malin',1),(90540,'Adenomatoid tumor, NOS','Adenomatoid tumor, NOS',0),(90550,'Multicystic mesothelioma, benign','Multicystic mesothelioma, benign',0),(90551,'Cystic mesothelioma, NOS','Cystic mesothelioma, NOS',0),(90603,'Dysgerminoma','Dysgerminome',1),(90613,'Seminoma, NOS','Seminoma, NOS',0),(90623,'Seminoma, anaplastic','Séminome anaplasique',1),(90633,'Spermatocytic seminoma','Séminome spermatocytaire',1),(90642,'Intratubular malignant germ cells','Intratubular malignant germ cells',0),(90643,'Germinoma','Germinome',1),(90653,'Germ cell tumor, nonseminomatous','Germ cell tumor, nonseminomatous',0),(90703,'Embryonal carcinoma, NOS','Embryonal carcinoma, NOS',0),(90713,'Yolk sac tumor','Yolk sac tumor',0),(90723,'Polyembryoma','Polyembryome',1),(90731,'Gonadoblastoma','Gonadoblastome',1),(90800,'Teratoma, benign','Tératome bénin',1),(90801,'Teratoma, NOS','Teratoma, NOS',0),(90803,'Teratoma, malignant, NOS','Teratoma, malignant, NOS',0),(90813,'Teratocarcinoma','Tératocarcinome',1),(90823,'Malignant teratoma, undifferentiated','Tératome malin de type indifférencié',1),(90833,'Malignant teratoma, intermediate','Tératome malin de type intermédiaire',1),(90840,'Dermoid cyst, NOS','Dermoid cyst, NOS',0),(90843,'Teratoma with malignant transformation','Tératome avec transformation maligne',1),(90853,'Mixed germ cell tumor','Mixed germ cell tumor',0),(90900,'Struma ovarii, NOS','Struma ovarii, NOS',0),(90903,'Struma ovarii, malignant','Goitre ovarien malin',1),(90911,'Strumal carcinoid','Carcinoïde ovarien',1),(91000,'Hydatidiform mole, NOS','Hydatidiform mole, NOS',0),(91001,'Invasive hydatidiform mole','Môle hydatidiforme invasive',1),(91003,'Choriocarcinoma, NOS','Choriocarcinoma, NOS',0),(91013,'Choriocarcinoma combined with other germ cell elements','Choriocarcinome associé à d\'autres éléments à cellules germinales',1),(91023,'Malignant teratoma, trophoblastic','Tératome malin trophoblastique',1),(91030,'Partial hydatidiform mole','Môle hydatidiforme partielle',1),(91041,'Placental site trophoblastic tumor','Placental site trophoblastic tumor',0),(91053,'Trophoblastic tumor, epithelioid','Trophoblastic tumor, epithelioid',0),(91100,'Mesonephroma, benign','Mésonéphrome bénin',1),(91101,'Mesonephric tumor, NOS','Mesonephric tumor, NOS',0),(91103,'Mesonephroma, malignant','Mésonéphrome malin',1),(91200,'Hemangioma, NOS','Hemangioma, NOS',0),(91203,'Hemangiosarcoma','Hemangiosarcoma',0),(91210,'Cavernous hemangioma','Cavernous hemangioma',0),(91220,'Venous hemangioma','Venous hemangioma',0),(91230,'Racemose hemangioma','Racemose hemangioma',0),(91243,'Kupffer cell sarcoma','Sarcome des cellules de Kupffer',1),(91250,'Epithelioid hemangioma','Epithelioid hemangioma',0),(91300,'Hemangioendothelioma, benign','Hemangioendothelioma, benign',0),(91301,'Hemangioendothelioma, NOS','Hemangioendothelioma, NOS',0),(91303,'Hemangioendothelioma, malignant','Hemangioendothelioma, malignant',0),(91310,'Capillary hemangioma','Capillary hemangioma',0),(91320,'Intramuscular hemangioma','Intramuscular hemangioma',0),(91331,'Epithelioid hemangioendothelioma, NOS','Epithelioid hemangioendothelioma, NOS',0),(91333,'Epithelioid hemangioendothelioma, malignant','Epithelioid hemangioendothelioma, malignant',0),(91351,'Endovascular papillary angioendothelioma','Endovascular papillary angioendothelioma',0),(91361,'Spindle cell hemangioendothelioma','Spindle cell hemangioendothelioma',0),(91403,'Kaposi sarcoma','Kaposi sarcoma',0),(91410,'Angiokeratoma','Angiokératome',1),(91420,'Verrucous keratotic hemangioma','Verrucous keratotic hemangioma',0),(91500,'Hemangiopericytoma, benign','Hemangiopericytoma, benign',0),(91501,'Hemangiopericytoma, NOS','Hemangiopericytoma, NOS',0),(91503,'Hemangiopericytoma, malignant','Hemangiopericytoma, malignant',0),(91600,'Angiofibroma, NOS','Angiofibroma, NOS',0),(91610,'Acquired tufted hemangioma','Acquired tufted hemangioma',0),(91611,'Hemangioblastoma','Hemangioblastoma',0),(91700,'Lymphangioma, NOS','Lymphangioma, NOS',0),(91703,'Lymphangiosarcoma','Lymphangiosarcome',1),(91710,'Capillary lymphangioma','Lymphangiome capillaire',1),(91720,'Cavernous lymphangioma','Lymphangiome caverneux',1),(91730,'Cystic lymphangioma','Lymphangiome kystique',1),(91740,'Lymphangiomyoma','Lymphangiomyome',1),(91741,'Lymphangiomyomatosis','Lymphangiomyomatose',1),(91750,'Hemolymphangioma','Hemolymphangioma',0),(91800,'Osteoma, NOS','Osteoma, NOS',0),(91803,'Osteosarcoma, NOS','Osteosarcoma, NOS',0),(91813,'Chondroblastic osteosarcoma','Ostéosarcome chondroblastique',1),(91823,'Fibroblastic osteosarcoma','Ostéosarcome fibroblastique',1),(91833,'Telangiectatic osteosarcoma','Ostéosarcome télangiectasique',1),(91843,'Osteosarcoma in Paget disease of bone','Osteosarcoma in Paget disease of bone',0),(91853,'Small cell osteosarcoma','Ostéosarcome à petites cellules',1),(91863,'Central osteosarcoma','Central osteosarcoma',0),(91873,'Intraosseous well differentiated osteosarcoma','Intraosseous well differentiated osteosarcoma',0),(91910,'Osteoid osteoma, NOS','Osteoid osteoma, NOS',0),(91923,'Parosteal osteosarcoma','Parosteal osteosarcoma',0),(91933,'Periosteal osteosarcoma','Periosteal osteosarcoma',0),(91943,'High grade surface osteosarcoma','High grade surface osteosarcoma',0),(91953,'Intracortical osteosarcoma','Intracortical osteosarcoma',0),(92000,'Osteoblastoma, NOS','Osteoblastoma, NOS',0),(92001,'Aggressive osteoblastoma','Ostéoblastome agressif',1),(92100,'Osteochondroma','Ostéochondrome',1),(92101,'Osteochondromatosis, NOS','Osteochondromatosis, NOS',0),(92200,'Chondroma, NOS','Chondroma, NOS',0),(92201,'Chondromatosis, NOS','Chondromatosis, NOS',0),(92203,'Chondrosarcoma, NOS','Chondrosarcoma, NOS',0),(92210,'Juxtacortical chondroma','Chondrome juxtacortical',1),(92213,'Juxtacortical chondrosarcoma','Chondrosarcome juxtacortical',1),(92300,'Chondroblastoma, NOS','Chondroblastoma, NOS',0),(92303,'Chondroblastoma, malignant','Chondroblastome malin',1),(92313,'Myxoid chondrosarcoma','Chondrosarcome myxoïde',1),(92403,'Mesenchymal chondrosarcoma','Chondrosarcome mésenchymateux',1),(92410,'Chondromyxoid fibroma','Fibrome chondromyxoïde',1),(92423,'Clear cell chondrosarcoma','Clear cell chondrosarcoma',0),(92433,'Dedifferentiated chondrosarcoma','Dedifferentiated chondrosarcoma',0),(92501,'Giant cell tumor of bone, NOS','Giant cell tumor of bone, NOS',0),(92503,'Giant cell tumor of bone, malignant','Giant cell tumor of bone, malignant',0),(92511,'Giant cell tumor of soft parts, NOS','Giant cell tumor of soft parts, NOS',0),(92513,'Malignant giant cell tumor of soft parts','Malignant giant cell tumor of soft parts',0),(92520,'Tenosynovial giant cell tumor','Tenosynovial giant cell tumor',0),(92523,'Malignant tenosynovial giant cell tumor','Malignant tenosynovial giant cell tumor',0),(92603,'Ewing sarcoma','Ewing sarcoma',0),(92613,'Adamantinoma of long bones','Adamantinome des os longs',1),(92620,'Ossifying fibroma','Fibrome ossifiant',1),(92700,'Odontogenic tumor, benign','Odontogenic tumor, benign',0),(92701,'Odontogenic tumor, NOS','Odontogenic tumor, NOS',0),(92703,'Odontogenic tumor, malignant','Odontogenic tumor, malignant',0),(92710,'Ameloblastic fibrodentinoma','Ameloblastic fibrodentinoma',0),(92720,'Cementoma, NOS','Cementoma, NOS',0),(92730,'Cementoblastoma, benign','Cémentoblastome bénin',1),(92740,'Cementifying fibroma','Fibrome cémentifiant',1),(92750,'Gigantiform cementoma','Cémentome géant',1),(92800,'Odontoma, NOS','Odontoma, NOS',0),(92810,'Compound odontoma','Odontome composé',1),(92820,'Complex odontoma','Odontome complexe',1),(92900,'Ameloblastic fibro-odontoma','Fibro-odontome améloblastique',1),(92903,'Ameloblastic odontosarcoma','Odontosarcome améloblastique',1),(93923,'Ependymoma, anaplastic','Épendymome anaplasique',1),(93933,'Papillary ependymoma','Épendymome papillaire',1),(93941,'Myxopapillary ependymoma','Épendymome myxopapillaire',1),(94003,'Astrocytoma, NOS','Astrocytoma, NOS',0),(94013,'Astrocytoma, anaplastic','Astrocytome anaplasique',1),(94103,'Protoplasmic astrocytoma','Astrocytome protoplasmique',1),(94113,'Gemistocytic astrocytoma','Astrocytome gémistocytique',1),(94121,'Desmoplastic infantile astrocytoma','Desmoplastic infantile astrocytoma',0),(94130,'Dysembryoplastic neuroepithelial tumor','Dysembryoplastic neuroepithelial tumor',0),(94203,'Fibrillary astrocytoma','Astrocytome fibrillaire',1),(94211,'Pilocytic astrocytoma','Astrocytome pilocytique',1),(94233,'Polar spongioblastoma','Polar spongioblastoma',0),(94243,'Pleomorphic xanthoastrocytoma','Xanthoastrocytome pléomorphe',1),(94303,'Astroblastoma','Astroblastome',1),(94403,'Glioblastoma, NOS','Glioblastoma, NOS',0),(94413,'Giant cell glioblastoma','Glioblastome à cellules géantes',1),(94421,'Gliofibroma','Gliofibroma',0),(94423,'Gliosarcoma','Gliosarcome',1),(94441,'Chordoid glioma','Chordoid glioma',0),(94503,'Oligodendroglioma, NOS','Oligodendroglioma, NOS',0),(94513,'Oligodendroglioma, anaplastic','Oligodendrogliome anaplasique',1),(94603,'Oligodendroblastoma','Oligodendroblastome',1),(94703,'Medulloblastoma, NOS','Medulloblastoma, NOS',0),(94713,'Desmoplastic nodular medulloblastoma','Desmoplastic nodular medulloblastoma',0),(94723,'Medullomyoblastoma','Médullomyoblastome',1),(94733,'Primitive neuroectodermal tumor, NOS','Primitive neuroectodermal tumor, NOS',0),(94743,'Large cell medulloblastoma','Large cell medulloblastoma',0),(94803,'Cerebellar sarcoma, NOS','Cerebellar sarcoma, NOS',0),(94900,'Ganglioneuroma','Ganglioneurome',1),(94903,'Ganglioneuroblastoma','Ganglioneuroblastome',1),(94910,'Ganglioneuromatosis','Ganglioneuromatose',1),(94920,'Gangliocytoma','Gangliocytoma',0),(94930,'Dysplastic gangliocytoma of cerebellum (Lhermitte-Duclos)','Dysplastic gangliocytoma of cerebellum (Lhermitte-Duclos)',0),(95003,'Neuroblastoma, NOS','Neuroblastoma, NOS',0),(95010,'Medulloepithelioma, benign','Medulloepithelioma, benign',0),(95013,'Medulloepithelioma, NOS','Medulloepithelioma, NOS',0),(95020,'Teratoid medulloepithelioma, benign','Teratoid medulloepithelioma, benign',0),(95023,'Teratoid medulloepithelioma','Médullo-épithéliome tératoïde',1),(95033,'Neuroepithelioma, NOS','Neuroepithelioma, NOS',0),(95043,'Spongioneuroblastoma','Spongioneuroblastome',1),(95051,'Ganglioglioma, NOS','Ganglioglioma, NOS',0),(95053,'Ganglioglioma, anaplastic','Ganglioglioma, anaplastic',0),(95061,'Central neurocytoma','Central neurocytoma',0),(95070,'Pacinian tumor','Pacinian tumor',0),(95083,'Atypical teratoid/rhabdoid tumor','Atypical teratoid/rhabdoid tumor',0),(95100,'Retinocytoma','Retinocytoma',0),(95103,'Retinoblastoma, NOS','Retinoblastoma, NOS',0),(95113,'Retinoblastoma, differentiated','Rétinoblastome différencié',1),(95123,'Retinoblastoma, undifferentiated','Rétinoblastome indifférencié',1),(95133,'Retinoblastoma, diffuse','Retinoblastoma, diffuse',0),(95141,'Retinoblastoma, spontaneously regressed','Retinoblastoma, spontaneously regressed',0),(95203,'Olfactory neurogenic tumor','Olfactory neurogenic tumor',0),(95213,'Olfactory neurocytoma','Olfactory neurocytoma',0),(95223,'Olfactory neuroblastoma','Olfactory neuroblastoma',0),(95233,'Olfactory neuroepithelioma','Olfactory neuroepithelioma',0),(95300,'Meningioma, NOS','Meningioma, NOS',0),(95301,'Meningiomatosis, NOS','Meningiomatosis, NOS',0),(95303,'Meningioma, malignant','Méningiome malin',1),(95310,'Meningothelial meningioma','Meningothelial meningioma',0),(95320,'Fibrous meningioma','Méningiome fibreux',1),(95330,'Psammomatous meningioma','Méningiome psammomateux',1),(95340,'Angiomatous meningioma','Méningiome angiomateux',1),(95350,'Hemangioblastic meningioma','Hemangioblastic meningioma',0),(95370,'Transitional meningioma','Méningiome transitionnel',1),(95381,'Clear cell meningioma','Clear cell meningioma',0),(95383,'Papillary meningioma','Méningiome papillaire',1),(95391,'Atypical meningioma','Atypical meningioma',0),(95393,'Meningeal sarcomatosis','Sarcomatose méningée',1),(95400,'Neurofibroma, NOS','Neurofibroma, NOS',0),(95401,'Neurofibromatosis, NOS','Neurofibromatosis, NOS',0),(95403,'Malignant peripheral nerve sheath tumor','Malignant peripheral nerve sheath tumor',0),(95410,'Melanotic neurofibroma','Neurofibrome mélanique',1),(95500,'Plexiform neurofibroma','Neurofibrome plexiforme',1),(95600,'Neurilemoma, NOS','Neurilemoma, NOS',0),(95601,'Neurinomatosis','Neurinomatose',1),(95603,'Neurilemoma, malignant','Neurilemoma, malignant',0),(95613,'Malignant peripheral nerve sheath tumor with rhabdomyoblastic differentiation','Malignant peripheral nerve sheath tumor with rhabdomyoblastic differentiation',0),(95620,'Neurothekeoma','Neurothécome',1),(95700,'Neuroma, NOS','Neuroma, NOS',0),(95710,'Perineurioma, NOS','Perineurioma, NOS',0),(95713,'Perineurioma, malignant','Perineurioma, malignant',0),(95800,'Granular cell tumor, NOS','Granular cell tumor, NOS',0),(95803,'Granular cell tumor, malignant','Granular cell tumor, malignant',0),(95813,'Alveolar soft part sarcoma','Sarcome alvéolaire des tissus mous',1),(95820,'Granular cell tumor of the sellar region','Granular cell tumor of the sellar region',0),(95903,'Malignant lymphoma, NOS','Malignant lymphoma, NOS',0),(95913,'Malignant lymphoma, non-Hodgkin, NOS','Malignant lymphoma, non-Hodgkin, NOS',0),(95963,'Composite Hodgkin and non-Hodgkin lymphoma','Composite Hodgkin and non-Hodgkin lymphoma',0),(96503,'Hodgkin lymphoma, NOS','Hodgkin lymphoma, NOS',0),(96513,'Hodgkin lymphoma, lymphocyte-rich','Hodgkin lymphoma, lymphocyte-rich',0),(96523,'Hodgkin lymphoma, mixed cellularity, NOS','Hodgkin lymphoma, mixed cellularity, NOS',0),(96533,'Hodgkin lymphoma, lymphocyte depletion, NOS','Hodgkin lymphoma, lymphocyte depletion, NOS',0),(96543,'Hodgkin lymphoma, lymphocyte depletion, diffuse fibrosis','Hodgkin lymphoma, lymphocyte depletion, diffuse fibrosis',0),(96553,'Hodgkin lymphoma, lymphocyte depletion, reticular','Hodgkin lymphoma, lymphocyte depletion, reticular',0),(96593,'Hodgkin lymphoma, nodular lymphocyte predominance','Hodgkin lymphoma, nodular lymphocyte predominance',0),(96613,'Hodgkin granuloma','Hodgkin granuloma',0),(96623,'Hodgkin sarcoma','Hodgkin sarcoma',0),(96633,'Hodgkin lymphoma, nodular sclerosis, NOS','Hodgkin lymphoma, nodular sclerosis, NOS',0),(96643,'Hodgkin lymphoma, nodular sclerosis, cellular phase','Hodgkin lymphoma, nodular sclerosis, cellular phase',0),(96653,'Hodgkin lymphoma, nodular sclerosis,  grade 1','Hodgkin lymphoma, nodular sclerosis,  grade 1',0),(96673,'Hodgkin lymphoma, nodular sclerosis,  grade 2','Hodgkin lymphoma, nodular sclerosis,  grade 2',0),(96703,'Malignant lymphoma, small B lymphocytic, NOS','Malignant lymphoma, small B lymphocytic, NOS',0),(96713,'Malignant lymphoma, lymphoplasmacytic','Lymphome malin, lymphoplasmocytaire',1),(96733,'Mantle cell lymphoma','Mantle cell lymphoma',0),(96753,'Malignant lymphoma, mixed small and large cell, diffuse','Lymphome malin, mixte, à petites cellules et grandes cellules, diffus',1),(96783,'Primary effusion lymphoma','Primary effusion lymphoma',0),(96793,'Mediastinal large B-cell lymphoma','Mediastinal large B-cell lymphoma',0),(96803,'Malignant lymphoma, large B-cell, diffuse, NOS','Malignant lymphoma, large B-cell, diffuse, NOS',0),(96843,'Malignant lymphoma, large B-cell, diffuse, immunoblastic, NOS','Malignant lymphoma, large B-cell, diffuse, immunoblastic, NOS',0),(96873,'Burkitt lymphoma, NOS','Burkitt lymphoma, NOS',0),(96893,'Splenic marginal zone B-cell lymphoma','Splenic marginal zone B-cell lymphoma',0),(96903,'Follicular lymphoma, NOS','Follicular lymphoma, NOS',0),(96913,'Follicular lymphoma, grade 2','Follicular lymphoma, grade 2',0),(96953,'Follicular lymphoma, grade 1','Follicular lymphoma, grade 1',0),(96983,'Follicular lymphoma, grade 3','Follicular lymphoma, grade 3',0),(96993,'Marginal zone B-cell lymphoma, NOS','Marginal zone B-cell lymphoma, NOS',0),(97003,'Mycosis fungoides','Mycosis fongoïde',1),(97013,'Sezary syndrome','Sezary syndrome',0),(97023,'Mature T-cell lymphoma, NOS','Mature T-cell lymphoma, NOS',0),(97053,'Angioimmunoblastic T-cell lymphoma','Angioimmunoblastic T-cell lymphoma',0),(97083,'Subcutaneous panniculitis-like T-cell lymphoma','Subcutaneous panniculitis-like T-cell lymphoma',0),(97093,'Cutaneous T-cell lymphoma, NOS','Cutaneous T-cell lymphoma, NOS',0),(97143,'Anaplastic large cell lymphoma, T cell and Null cell type','Anaplastic large cell lymphoma, T cell and Null cell type',0),(97163,'Hepatosplenic  (gamma-delta) cell lymphoma','Hepatosplenic  (gamma-delta) cell lymphoma',0),(97173,'Intestinal T-cell lymphoma','Intestinal T-cell lymphoma',0),(97183,'Primary cutaneous CD30+ T-cell lymphoproliferative disorder','Primary cutaneous CD30+ T-cell lymphoproliferative disorder',0),(97193,'NK/T-cell lymphoma, nasal and nasal-type','NK/T-cell lymphoma, nasal and nasal-type',0),(97273,'Precursor cell lymphoblastic lymphoma, NOS','Precursor cell lymphoblastic lymphoma, NOS',0),(97283,'Precursor B-cell lymphoblastic lymphoma','Precursor B-cell lymphoblastic lymphoma',0),(97293,'Precursor T-cell lymphoblastic lymphoma','Precursor T-cell lymphoblastic lymphoma',0),(97313,'Plasmacytoma, NOS','Plasmacytoma, NOS',0),(97323,'Multiple myeloma','Myélome multiple',1),(97333,'Plasma cell leukemia','Plasma cell leukemia',0),(97343,'Plasmacytoma, extramedullary (not occurring in bone)','Plasmacytoma, extramedullary (not occurring in bone)',0),(97401,'Mastocytoma, NOS','Mastocytoma, NOS',0),(97403,'Mast cell sarcoma','Sarcome à mastocytes',1),(97413,'Malignant mastocytosis','Mastocytose maligne',1),(97423,'Mast cell leukemia','Mast cell leukemia',0),(97503,'Malignant histiocytosis','Histiocytose maligne',1),(97511,'Langerhans cell histiocytosis, NOS','Langerhans cell histiocytosis, NOS',0),(97521,'Langerhans cell histiocytosis, unifocal','Langerhans cell histiocytosis, unifocal',0),(97531,'Langerhans cell histiocytosis, multifocal','Langerhans cell histiocytosis, multifocal',0),(97543,'Langerhans cell histiocytosis, disseminated','Langerhans cell histiocytosis, disseminated',0),(97553,'Histiocytic sarcoma','Histiocytic sarcoma',0),(97563,'Langerhans cell sarcoma','Langerhans cell sarcoma',0),(97573,'Interdigitating dendritic cell sarcoma','Interdigitating dendritic cell sarcoma',0),(97583,'Follicular dendritic cell sarcoma','Follicular dendritic cell sarcoma',0),(97603,'Immunoproliferative disease, NOS','Immunoproliferative disease, NOS',0),(97613,'Waldenstrom macroglobulinemia','Waldenstrom macroglobulinemia',0),(97623,'Heavy chain disease, NOS','Heavy chain disease, NOS',0),(97643,'Immunoproliferative small intestinal  disease','Immunoproliferative small intestinal  disease',0),(97651,'Monoclonal gammopathy of undetermined significance','Monoclonal gammopathy of undetermined significance',0),(97661,'Angiocentric immunoproliferative lesion','Lésion immunoproliférative angiocentrique',1),(97671,'Angioimmunoblastic lymphadenopathy (AIC)','Angioimmunoblastic lymphadenopathy (AIC)',0),(97681,'T-gamma lymphoproliferative disease','Maladie lymphoproliférative, type T-gamma',1),(97691,'Immunoglobulin deposition disease','Immunoglobulin deposition disease',0),(98003,'Leukemia, NOS','Leukemia, NOS',0),(98013,'Acute leukemia, NOS','Acute leukemia, NOS',0),(98053,'Acute biphenotypic leukemia','Acute biphenotypic leukemia',0),(98203,'Lymphoid leukemia, NOS','Lymphoid leukemia, NOS',0),(98233,'B-cell chronic lymphocytic leukemia/small lymphocytic lymphoma','B-cell chronic lymphocytic leukemia/small lymphocytic lymphoma',0),(98263,'Burkitt cell leukemia','Burkitt cell leukemia',0),(98273,'Adult T-cell leukemia/lymphoma (HTLV-1 positive)','Adult T-cell leukemia/lymphoma (HTLV-1 positive)',0),(98311,'T-cell large granular lymphocytic leukemia','T-cell large granular lymphocytic leukemia',0),(98323,'Prolymphocytic leukemia, NOS','Prolymphocytic leukemia, NOS',0),(98333,'Prolymphocytic leukemia, B-cell type','Prolymphocytic leukemia, B-cell type',0),(98343,'Prolymphocytic leukemia, T-cell type','Prolymphocytic leukemia, T-cell type',0),(98353,'Precursor cell lymphoblastic leukemia, NOS','Precursor cell lymphoblastic leukemia, NOS',0),(98363,'Precursor B-cell lymphoblastic leukemia','Precursor B-cell lymphoblastic leukemia',0),(98373,'Precursor T-cell lymphoblastic leukemia','Precursor T-cell lymphoblastic leukemia',0),(98403,'Acute myeloid leukemia, M6 type','Acute myeloid leukemia, M6 type',0),(98603,'Myeloid leukemia, NOS','Myeloid leukemia, NOS',0),(98613,'Acute myeloid leukemia, NOS','Acute myeloid leukemia, NOS',0),(98633,'Chronic myeloid leukemia, NOS','Chronic myeloid leukemia, NOS',0),(98663,'Acute promyelocytic leukemia','Acute promyelocytic leukemia',0),(98673,'Acute myelomonocytic leukemia','Acute myelomonocytic leukemia',0),(98703,'Acute basophilic leukemia','Acute basophilic leukemia',0),(98713,'Acute myeloid leukemia with abnormal marrow eosinophils','Acute myeloid leukemia with abnormal marrow eosinophils',0),(98723,'Acute myeloid leukemia, minimal differentiation','Acute myeloid leukemia, minimal differentiation',0),(98733,'Acute myeloid leukemia without maturation','Acute myeloid leukemia without maturation',0),(98743,'Acute myeloid leukemia with maturation','Acute myeloid leukemia with maturation',0),(98753,'Chronic myelogenous leukemia, BCR/ABL  positive','Chronic myelogenous leukemia, BCR/ABL  positive',0),(98763,'Atypical chronic myeloid leukemia, BCR/ABL negative','Atypical chronic myeloid leukemia, BCR/ABL negative',0),(98913,'Acute monocytic leukemia','Acute monocytic leukemia',0),(98953,'Acute myeloid leukemia with multilineage dysplasia','Acute myeloid leukemia with multilineage dysplasia',0),(98963,'Acute myeloid leukemia, t(8','Acute myeloid leukemia, t(8',0),(98973,'Acute myeloid leukemia, 11q23 abnormalities','Acute myeloid leukemia, 11q23 abnormalities',0),(99103,'Acute megakaryoblastic leukemia','Acute megakaryoblastic leukemia',0),(99203,'Therapy-related acute myeloid leukemia, NOS','Therapy-related acute myeloid leukemia, NOS',0),(99303,'Myeloid sarcoma','Sarcome myéloïde',1),(99313,'Acute panmyelosis with myelofibrosis','Acute panmyelosis with myelofibrosis',0),(99403,'Hairy cell leukemia','Hairy cell leukemia',0),(99453,'Chronic myelomonocytic leukemia, NOS','Chronic myelomonocytic leukemia, NOS',0),(99463,'Juvenile myelomonocytic leukemia','Juvenile myelomonocytic leukemia',0),(99483,'Aggressive NK-cell leukemia','Aggressive NK-cell leukemia',0),(99503,'Polycythemia vera','Polycythemia vera',0),(99603,'Chronic myeloproliferative disease, NOS','Chronic myeloproliferative disease, NOS',0),(99613,'Myelosclerosis with myeloid metaplasia','Myélosclérose avec métaplasie myéloïde',1),(99623,'Essential thrombocythemia','Essential thrombocythemia',0),(99633,'Chronic neutrophilic leukemia','Chronic neutrophilic leukemia',0),(99643,'Hypereosinophilic syndrome','Hypereosinophilic syndrome',0),(99701,'Lymphoproliferative disorder, NOS','Lymphoproliferative disorder, NOS',0),(99751,'Myeloproliferative disease, NOS','Myeloproliferative disease, NOS',0),(99803,'Refractory anemia','Refractory anemia',0),(99823,'Refractory anemia with sideroblasts','Refractory anemia with sideroblasts',0),(99833,'Refractory anemia with excess blasts','Refractory anemia with excess blasts',0),(99843,'Refractory anemia with excess blasts in transformation','Refractory anemia with excess blasts in transformation',0),(99853,'Refractory cytopenia with multilineage dysplasia','Refractory cytopenia with multilineage dysplasia',0),(99863,'Myelodysplastic syndrome with 5q deletion (5q-) syndrome','Myelodysplastic syndrome with 5q deletion (5q-) syndrome',0),(99873,'Therapy-related myelodysplastic syndrome, NOS','Therapy-related myelodysplastic syndrome, NOS',0),(99893,'Myelodysplastic syndrome, NOS','Myelodysplastic syndrome, NOS',0);

ALTER TABLE misc_identifier_controls
  DROP COLUMN misc_identifier_name_abbrev; 
DELETE FROM structure_formats WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE field = 'misc_identifier_name_abbrev');
DELETE FROM structure_fields WHERE field = 'misc_identifier_name_abbrev';

UPDATE structure_formats SET `display_order`='12' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_spent_times_report') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Generated' AND `tablename`='' AND `field`='coll_to_stor_spent_time_msg' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='13' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_spent_times_report') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Generated' AND `tablename`='' AND `field`='rec_to_stor_spent_time_msg' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='14' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_spent_times_report') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Generated' AND `tablename`='' AND `field`='creat_to_stor_spent_time_msg' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats SET `display_order`='530' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquotmasters_volume') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotControl' AND `tablename`='aliquot_controls' AND `field`='volume_unit' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_volume_unit') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='529' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquotmasters_volume') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='current_volume' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_override_setting`='1', `setting`='size=30,class=range file' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='barcode' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_override_label`='1', `language_label`='date' WHERE structure_id=(SELECT id FROM structures WHERE alias='txd_surgeries') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='tx_masters' AND `field`='start_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
-- delete structure_formats
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='txd_surgeries') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='DE-47' AND `plugin`='Clinicalannotation' AND `model`='TreatmentMaster' AND `tablename`='tx_masters' AND `field`='finish_date' AND `language_label`='finish date' AND `language_tag`='' AND `type`='date' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='help_finish_date' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='locked' AND `flag_confidential`='0');

UPDATE tx_controls SET tx_method='surgery without extension', databrowser_label='all|surgery without extension' WHERE id=4;

INSERT INTO external_links (name, link) VALUES
('diagnosis_module_wiki', 'http://www.ctrnet.ca/mediawiki/index.php/Use_the_diagnosis_section');

UPDATE structure_formats 
SET `flag_add`='0', `flag_add_readonly`='0', `flag_edit`='0', `flag_edit_readonly`='0', `flag_search`='0', `flag_search_readonly`='0', `flag_addgrid`='0', `flag_addgrid_readonly`='0', `flag_editgrid`='0', `flag_editgrid_readonly`='0', `flag_batchedit`='0', `flag_batchedit_readonly`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' 
WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE field = 'barcode' AND `model` = 'StorageMaster');

DELETE FROM structure_formats 
WHERE structure_id=(SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection') 
AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `field`='aliquot_control_id');
DELETE FROM structure_fields WHERE `model`='ViewAliquot' AND `field`='aliquot_control_id';

SET @structure_format_id = (SELECT id FROM structure_formats 
WHERE structure_id=(SELECT id FROM structures WHERE alias='sourcealiquots_volume') 
AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotControl' AND `tablename`='aliquot_controls' AND `field`='volume_unit' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_volume_unit') AND `flag_confidential`='0')
ORDER BY display_order ASC LIMIT 0,1);
UPDATE structure_formats SET `flag_index`='0' WHERE id = @structure_format_id;

DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_undetailed_specimens');
DELETE FROM structures WHERE alias='sd_undetailed_specimens';

DELETE FROM structure_fields WHERE id NOT IN (SELECT structure_field_id FROM structure_formats);

UPDATE structure_fields SET language_help = 'inv_creation_datetime_defintion' WHERE field = 'creation_datetime' AND model = 'DerivativeDetail';
UPDATE structure_fields SET language_help = 'inv_reception_datetime_defintion' WHERE field = 'reception_datetime' AND model = 'SpecimenDetail';

REPLACE INTO i18n (id,en,fr) VALUES ('inv_creation_datetime_defintion', 'Date of the samples creation (extraction, centrifugation, etc.).', 'Date de la création des échantillons (extraction, centrifugation, etc.).');

ALTER TABLE specimen_details
	ADD COLUMN time_at_room_temp_mn INT DEFAULT NULL AFTER supplier_dept;
ALTER TABLE specimen_details_revs
	ADD COLUMN time_at_room_temp_mn INT DEFAULT NULL AFTER supplier_dept;
	
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Inventorymanagement', 'SpecimenDetail', 'specimen_details', 'time_at_room_temp_mn', 'integer',  NULL , '0', 'size=3', '', 'time_at_room_temp_mn_help', 'time at room temp (mn)', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='specimens'), 
(SELECT id FROM structure_fields WHERE `model`='SpecimenDetail' AND `tablename`='specimen_details' AND `field`='time_at_room_temp_mn'), '1', '405', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0');

REPLACE INTO i18n (id,en,fr) VALUES 
('time at room temp (mn)', 'Time at room temperature (min)', 'Temps à température ambiante (min)'),
('time_at_room_temp_mn_help', 
"Time spent between the collection time and the initial specimen storage time at low temperature (minutes). Ex.: Time between blood sampling and blood storage by the nurse.", 
"Temps écoulé entre l'heure de collection et l'heure ou les spécimens ont été placés à basse température (minutes). Ex.: Temps entre une prise de sang et l'entreposage du sang par l'infirmère.");

UPDATE structure_formats SET `language_heading`='shipping data' WHERE structure_id=(SELECT id FROM structures WHERE alias='shipments') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Shipment' AND `tablename`='shipments' AND `field`='shipment_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='recipient data' WHERE structure_id=(SELECT id FROM structures WHERE alias='shipments') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Shipment' AND `tablename`='shipments' AND `field`='recipient' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

REPLACE INTO i18n (id,en,fr) VALUES 
('shipping data','Shipping Data','Données d''expédition'),
('recipient data','Recipient','Destinataire'),
('select recipient','Select Recipient','Sélectionner le destinataire'),
('save recipient','Save Recipient Data','Enregistrer données du destinataire');

DROP TABLE datamart_browsing_results_revs;

DELETE FROM structure_formats WHERE structure_id IN (SELECT id FROM structures WHERE alias like 'qry_%_search' OR alias like 'qry_%_results');
DELETE FROM structures WHERE alias like 'qry_%_search' OR alias like 'qry_%_results';

DELETE FROM structure_formats WHERE structure_id IN (SELECT id FROM structures WHERE alias like 'basic_aliquot_search%');
DELETE FROM structures WHERE alias like 'basic_aliquot_search%';

UPDATE structure_formats 
SET flag_index = '1'
WHERE flag_index = '0' AND flag_search = '1'
AND structure_id IN (SELECT id FROM structures WHERE alias IN ('shipments', 'specimens', 'derivatives'))
AND structure_field_id IN (SELECT id FROM structure_fields WHERE model IN ('Shipment', 'SpecimenDetail','DerivativeDetail') 
AND field IN ('facility','time_at_room_temp_mn', 'reception_by','shipped_by','shipping_account_nbr','creation_site','creation_by', 'supplier_dept', 'recipient'));

UPDATE structure_formats 
SET flag_index = '0',flag_search = '0'
WHERE flag_index = '0' AND flag_search = '1'
AND structure_id IN (SELECT id FROM structures WHERE alias IN ('sd_spe_tissues', 'familyhistories','participants'))
AND structure_field_id IN (SELECT id FROM structure_fields WHERE model IN ('SampleDetail', 'FamilyHistory','Participant') 
AND field IN ('pathology_reception_datetime', 'previous_primary_code_system','race'));

UPDATE structure_formats 
SET flag_index = '1'
WHERE flag_index = '0' AND flag_search = '1'
AND structure_id IN (SELECT id FROM structures WHERE alias IN ('aliquot_masters', 'participants', 'participantmessages'))
AND structure_field_id IN (SELECT id FROM structure_fields WHERE model IN ('AliquotMaster', 'ParticipantMessage','Participant') 
AND field IN ('sex','expiry_date', 'in_stock_detail'));

DELETE FROM structure_formats WHERE structure_id IN (SELECT id from structures WHERE alias = 'storagemasters');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='storagemasters'), (SELECT id FROM structure_fields WHERE `model`='StorageMaster' AND `tablename`='storage_masters' AND `field`='code' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='storage_code_help' AND `language_label`='storage code' AND `language_tag`=''), '0', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '1', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='storagemasters'), (SELECT id FROM structure_fields WHERE `model`='StorageMaster' AND `tablename`='storage_masters' AND `field`='storage_control_id' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='storage_type')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='storage type' AND `language_tag`=''), '0', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '1', '1', '1', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='storagemasters'), (SELECT id FROM structure_fields WHERE `model`='StorageMaster' AND `tablename`='' AND `field`='layout_description' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='rows=2,cols=60' AND `default`='' AND `language_help`='' AND `language_label`='storage layout description' AND `language_tag`=''), '0', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '1', '1', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='storagemasters'), (SELECT id FROM structure_fields WHERE `model`='StorageMaster' AND `tablename`='storage_masters' AND `field`='barcode' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='' AND `language_label`='barcode' AND `language_tag`=''), '0', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='storagemasters'), (SELECT id FROM structure_fields WHERE `model`='StorageMaster' AND `tablename`='storage_masters' AND `field`='short_label' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=6' AND `default`='' AND `language_help`='stor_short_label_defintion' AND `language_label`='storage short label' AND `language_tag`=''), '0', '6', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='storagemasters'), (SELECT id FROM structure_fields WHERE `model`='StorageMaster' AND `tablename`='storage_masters' AND `field`='selection_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '0', '8', '', '1', 'storage selection label', '0', '', '0', '', '0', '', '1', 'size=20,url=/storagelayout/storage_masters/autoComplete/', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='storagemasters'), (SELECT id FROM structure_fields WHERE `model`='Generated' AND `tablename`='' AND `field`='path' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='' AND `language_label`='storage path' AND `language_tag`=''), '0', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='storagemasters'), (SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='recorded_storage_selection_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '0', '12', '', '1', 'parent storage', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='storagemasters'), (SELECT id FROM structure_fields WHERE `model`='StorageMaster' AND `tablename`='storage_masters' AND `field`='parent_storage_coord_x' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=4' AND `default`='' AND `language_help`='' AND `language_label`='position into parent storage' AND `language_tag`=''), '0', '13', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='storagemasters'), (SELECT id FROM structure_fields WHERE `model`='StorageMaster' AND `tablename`='storage_masters' AND `field`='parent_storage_coord_y' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=4' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`=''), '0', '14', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='storagemasters'), (SELECT id FROM structure_fields WHERE `model`='StorageMaster' AND `tablename`='storage_masters' AND `field`='temperature' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '0', '20', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='storagemasters'), (SELECT id FROM structure_fields WHERE `model`='StorageMaster' AND `tablename`='storage_masters' AND `field`='temp_unit' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='temperature_unit_code')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`=''), '0', '21', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='storagemasters'), (SELECT id FROM structure_fields WHERE `model`='StorageMaster' AND `tablename`='storage_masters' AND `field`='notes' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='rows=3,cols=30' AND `default`='' AND `language_help`='' AND `language_label`='notes' AND `language_tag`=''), '0', '25', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');

UPDATE storage_controls SET form_alias = 'storagemasters' WHERE form_alias LIKE '%std_undetail_stg_with_surr_tmp%';
DELETE FROM structure_formats WHERE structure_id IN (SELECT id from structures WHERE alias = 'std_undetail_stg_with_surr_tmp');
DELETE FROM structures WHERE alias = 'std_undetail_stg_with_surr_tmp';

DELETE FROM structure_formats
WHERE structure_id IN (SELECT id from structures WHERE alias IN ('std_rooms', 'std_undetail_stg_with_tmp', 'std_incubators', 'std_tma_blocks'))
AND structure_field_id IN (SELECT id FROM structure_fields WHERE model IN ('StorageMaster', 'Generated', 'FunctionManagement') 
AND field IN ('code', 'layout_description' ,'storage_control_id', 'barcode', 'short_label', 'selection_label', 'path', 
'recorded_storage_selection_label', 'parent_storage_coord_x', 'parent_storage_coord_y', 'notes'));

UPDATE structure_formats SET `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='std_undetail_stg_with_tmp') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StorageMaster' AND `tablename`='storage_masters' AND `field`='temperature' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='std_undetail_stg_with_tmp') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StorageMaster' AND `tablename`='storage_masters' AND `field`='temp_unit' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='temperature_unit_code') AND `flag_confidential`='0');

UPDATE structures SET alias = 'storage_temperature' WHERE alias = 'std_undetail_stg_with_tmp';

UPDATE storage_controls SET form_alias = 'storagemasters,storage_temperature' WHERE form_alias = 'std_undetail_stg_with_tmp';

DELETE FROM structure_formats 
WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE `model`='StorageMaster' AND `field` IN ('temperature', 'temp_unit'))
AND structure_id IN (SELECT id FROM structures WHERE alias IN ('std_tma_blocks', 'std_incubators', 'std_rooms')) ;

UPDATE storage_controls SET form_alias = 'storagemasters,storage_temperature,std_incubators' WHERE form_alias = 'std_incubators';
UPDATE storage_controls SET form_alias = 'storagemasters,storage_temperature,std_rooms' WHERE form_alias = 'std_rooms';

INSERT INTO `datamart_structures` (`id`, `plugin`, `model`, `structure_id`, `display_name`, `use_key`, `control_model`, `control_master_model`, `control_field`, `index_link`, `batch_edit_link`) VALUES
(null, 'Order', 'OrderItem', (SELECT id FROM structures WHERE alias = 'orderitems'), 'order items', 'id', '', '', '', '/order/order_items/listall/%%OrderItem.order_id%%/%%OrderItem.order_line_id%%/', '');
INSERT into datamart_browsing_controls (id1,id2,flag_active_1_to_2,flag_active_2_to_1,use_field)
VALUES
((SELECT id FROM datamart_structures WHERE model = 'OrderItem'), (SELECT id FROM datamart_structures WHERE model = 'ViewAliquot'), 1, 1, 'OrderItem.aliquot_master_id');

INSERT INTO `datamart_structures` (`id`, `plugin`, `model`, `structure_id`, `display_name`, `use_key`, `control_model`, `control_master_model`, `control_field`, `index_link`, `batch_edit_link`) VALUES
(null, 'Order', 'Shipment', (SELECT id FROM structures WHERE alias = 'shipments'), 'shipments', 'id', '', '', '', '/order/shipments/detail/%%Shipment.order_id%%/%%Sshipment.id%%/', '');
INSERT into datamart_browsing_controls (id1,id2,flag_active_1_to_2,flag_active_2_to_1,use_field)
VALUES
((SELECT id FROM datamart_structures WHERE model = 'OrderItem'), (SELECT id FROM datamart_structures WHERE model = 'Shipment'), 1, 1, 'OrderItem.shipment_id');

REPLACE INTO i18n (id,en,fr) VALUES ('shipments', 'Shipments', 'Envois'), ('order items', 'Order Items', 'Articles de Commande');

UPDATE datamart_structures SET index_link = '/order/shipments/detail/%%Shipment.order_id%%/%%Shipment.id%%/' WHERE display_name = 'shipments';
UPDATE datamart_structures SET index_link = '/order/order_items/listall/%%OrderLine.order_id%%/%%OrderLine.id%%/' WHERE display_name = 'order items';

UPDATE structure_formats SET `language_heading`='system data' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='created' );

UPDATE structure_fields SET `language_tag`='' WHERE model='SampleDetail' AND tablename='' AND field='tissue_size_unit' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='tissue_size_unit');
UPDATE structure_fields SET `language_tag`='' WHERE model='SampleDetail' AND tablename='' AND field='tissue_weight_unit' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='tissue_weight_unit');
UPDATE structure_fields SET `language_tag`='' WHERE model='SampleDetail' AND `field`='collected_volume_unit' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='sample_volume_unit');
UPDATE structure_fields SET `language_tag`='' WHERE model='SampleDetail' AND tablename='' AND field='pellet_volume_unit';
UPDATE structure_fields SET `language_tag`='' WHERE model='AliquotDetail' AND tablename='' AND field='used_blood_volume_unit';

ALTER TABLE structure_formats
 ADD COLUMN flag_override_label2 BOOLEAN NOT NULL DEFAULT FALSE AFTER flag_override_label,
 ADD COLUMN flag_override_tag2 BOOLEAN NOT NULL DEFAULT FALSE AFTER flag_override_tag,
 ADD COLUMN flag_override_help2 BOOLEAN NOT NULL DEFAULT FALSE AFTER flag_override_help,
 ADD COLUMN flag_override_type2 BOOLEAN NOT NULL DEFAULT FALSE AFTER flag_override_type,
 ADD COLUMN flag_override_setting2 BOOLEAN NOT NULL DEFAULT FALSE AFTER flag_override_setting,
 ADD COLUMN flag_override_default2 BOOLEAN NOT NULL DEFAULT FALSE AFTER flag_override_default,
 ADD COLUMN flag_add2 BOOLEAN NOT NULL DEFAULT FALSE AFTER flag_add,
 ADD COLUMN flag_add_readonly2 BOOLEAN NOT NULL DEFAULT FALSE AFTER flag_add_readonly,
 ADD COLUMN flag_edit2 BOOLEAN NOT NULL DEFAULT FALSE AFTER flag_edit,
 ADD COLUMN flag_edit_readonly2 BOOLEAN NOT NULL DEFAULT FALSE AFTER flag_edit_readonly,
 ADD COLUMN flag_search2 BOOLEAN NOT NULL DEFAULT FALSE AFTER flag_search,
 ADD COLUMN flag_search_readonly2 BOOLEAN NOT NULL DEFAULT FALSE AFTER flag_search_readonly,
 ADD COLUMN flag_addgrid2 BOOLEAN NOT NULL DEFAULT FALSE AFTER flag_addgrid,
 ADD COLUMN flag_addgrid_readonly2 BOOLEAN NOT NULL DEFAULT FALSE AFTER flag_addgrid_readonly,
 ADD COLUMN flag_editgrid2 BOOLEAN NOT NULL DEFAULT FALSE AFTER flag_editgrid,
 ADD COLUMN flag_editgrid_readonly2 BOOLEAN NOT NULL DEFAULT FALSE AFTER flag_editgrid_readonly,
 ADD COLUMN flag_summary2 BOOLEAN NOT NULL DEFAULT FALSE AFTER flag_summary,
 ADD COLUMN flag_batchedit2 BOOLEAN NOT NULL DEFAULT FALSE AFTER flag_batchedit,
 ADD COLUMN flag_batchedit_readonly2 BOOLEAN NOT NULL DEFAULT FALSE AFTER flag_batchedit_readonly,
 ADD COLUMN flag_index2 BOOLEAN NOT NULL DEFAULT FALSE AFTER flag_index,
 ADD COLUMN flag_detail2 BOOLEAN NOT NULL DEFAULT FALSE AFTER flag_detail;
 
UPDATE structure_formats SET
 flag_override_label2=flag_override_label='1',
 flag_override_tag2=flag_override_tag='1',
 flag_override_help2=flag_override_help='1',
 flag_override_type2=flag_override_type='1',
 flag_override_setting2=flag_override_setting='1',
 flag_override_default2=flag_override_default='1',
 flag_add2=flag_add='1' ,
 flag_add_readonly2=flag_add_readonly='1' ,
 flag_edit2=flag_edit='1' ,
 flag_edit_readonly2=flag_edit_readonly='1' ,
 flag_search2=flag_search='1' ,
 flag_search_readonly2=flag_search_readonly='1' ,
 flag_addgrid2=flag_addgrid='1' ,
 flag_addgrid_readonly2=flag_addgrid_readonly='1' ,
 flag_editgrid2=flag_editgrid='1' ,
 flag_editgrid_readonly2=flag_editgrid_readonly='1' ,
 flag_summary2=flag_summary='1' ,
 flag_batchedit2=flag_batchedit='1' ,
 flag_batchedit_readonly2=flag_batchedit_readonly='1' ,
 flag_index2=flag_index='1' ,
 flag_detail2=flag_detail='1';

ALTER TABLE structure_formats
 DROP COLUMN flag_override_label,
 DROP COLUMN flag_override_tag,
 DROP COLUMN flag_override_help,
 DROP COLUMN flag_override_type,
 DROP COLUMN flag_override_setting,
 DROP COLUMN flag_override_default,
 DROP COLUMN flag_add,
 DROP COLUMN flag_add_readonly,
 DROP COLUMN flag_edit,
 DROP COLUMN flag_edit_readonly,
 DROP COLUMN flag_search,
 DROP COLUMN flag_search_readonly,
 DROP COLUMN flag_addgrid,
 DROP COLUMN flag_addgrid_readonly,
 DROP COLUMN flag_editgrid,
 DROP COLUMN flag_editgrid_readonly,
 DROP COLUMN flag_summary,
 DROP COLUMN flag_batchedit,
 DROP COLUMN flag_batchedit_readonly,
 DROP COLUMN flag_index,
 DROP COLUMN flag_detail;

ALTER TABLE structure_formats
 CHANGE COLUMN flag_override_label2 flag_override_label BOOLEAN NOT NULL DEFAULT FALSE,
 CHANGE COLUMN flag_override_tag2 flag_override_tag BOOLEAN NOT NULL DEFAULT FALSE,
 CHANGE COLUMN flag_override_help2 flag_override_help BOOLEAN NOT NULL DEFAULT FALSE,
 CHANGE COLUMN flag_override_type2 flag_override_type BOOLEAN NOT NULL DEFAULT FALSE,
 CHANGE COLUMN flag_override_setting2 flag_override_setting BOOLEAN NOT NULL DEFAULT FALSE,
 CHANGE COLUMN flag_override_default2 flag_override_default BOOLEAN NOT NULL DEFAULT FALSE,
 CHANGE COLUMN flag_add2 flag_add BOOLEAN NOT NULL DEFAULT FALSE,
 CHANGE COLUMN flag_add_readonly2 flag_add_readonly BOOLEAN NOT NULL DEFAULT FALSE,
 CHANGE COLUMN flag_edit2 flag_edit BOOLEAN NOT NULL DEFAULT FALSE,
 CHANGE COLUMN flag_edit_readonly2 flag_edit_readonly BOOLEAN NOT NULL DEFAULT FALSE,
 CHANGE COLUMN flag_search2 flag_search BOOLEAN NOT NULL DEFAULT FALSE,
 CHANGE COLUMN flag_search_readonly2 flag_search_readonly BOOLEAN NOT NULL DEFAULT FALSE,
 CHANGE COLUMN flag_addgrid2 flag_addgrid BOOLEAN NOT NULL DEFAULT FALSE,
 CHANGE COLUMN flag_addgrid_readonly2 flag_addgrid_readonly BOOLEAN NOT NULL DEFAULT FALSE,
 CHANGE COLUMN flag_editgrid2 flag_editgrid BOOLEAN NOT NULL DEFAULT FALSE,
 CHANGE COLUMN flag_editgrid_readonly2 flag_editgrid_readonly BOOLEAN NOT NULL DEFAULT FALSE,
 CHANGE COLUMN flag_summary2 flag_summary BOOLEAN NOT NULL DEFAULT FALSE,
 CHANGE COLUMN flag_batchedit2 flag_batchedit BOOLEAN NOT NULL DEFAULT FALSE,
 CHANGE COLUMN flag_batchedit_readonly2 flag_batchedit_readonly BOOLEAN NOT NULL DEFAULT FALSE,
 CHANGE COLUMN flag_index2 flag_index BOOLEAN NOT NULL DEFAULT FALSE,
 CHANGE COLUMN flag_detail2 flag_detail BOOLEAN NOT NULL DEFAULT FALSE;
 
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_der_tubes_incl_ul_vol_and_conc') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Inventorymanagement' AND `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='initial_specimen_sample_type' AND `language_label`='initial specimen type' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='specimen_sample_type') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_der_tubes_incl_ul_vol_and_conc') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Inventorymanagement' AND `model`='SampleMaster' AND `tablename`='' AND `field`='parent_sample_type' AND `language_label`='parent sample type' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='sample_type') AND `language_help`='generated_parent_sample_sample_type_help' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');

DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_der_tubes_incl_ml_vol') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Inventorymanagement' AND `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='initial_specimen_sample_type' AND `language_label`='initial specimen type' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='specimen_sample_type') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_der_tubes_incl_ml_vol') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Inventorymanagement' AND `model`='SampleMaster' AND `tablename`='' AND `field`='parent_sample_type' AND `language_label`='parent sample type' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='sample_type') AND `language_help`='generated_parent_sample_sample_type_help' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');

DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_der_cell_slides') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Inventorymanagement' AND `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='initial_specimen_sample_type' AND `language_label`='initial specimen type' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='specimen_sample_type') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_der_cell_slides') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Inventorymanagement' AND `model`='SampleMaster' AND `tablename`='' AND `field`='parent_sample_type' AND `language_label`='parent sample type' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='sample_type') AND `language_help`='generated_parent_sample_sample_type_help' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');

DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_der_cell_cores') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Inventorymanagement' AND `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='initial_specimen_sample_type' AND `language_label`='initial specimen type' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='specimen_sample_type') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_der_cell_cores') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Inventorymanagement' AND `model`='SampleMaster' AND `tablename`='' AND `field`='parent_sample_type' AND `language_label`='parent sample type' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='sample_type') AND `language_help`='generated_parent_sample_sample_type_help' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');

DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_der_cell_tubes_incl_ml_vol') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Inventorymanagement' AND `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='initial_specimen_sample_type' AND `language_label`='initial specimen type' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='specimen_sample_type') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_der_cell_tubes_incl_ml_vol') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Inventorymanagement' AND `model`='SampleMaster' AND `tablename`='' AND `field`='parent_sample_type' AND `language_label`='parent sample type' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='sample_type') AND `language_help`='generated_parent_sample_sample_type_help' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');

ALTER TABLE datamart_batch_sets
 ADD COLUMN flag_tmp BOOLEAN NOT NULL DEFAULT FALSE AFTER locked;

UPDATE structure_fields SET  `language_label`='number of matching participants' WHERE model='0' AND tablename='' AND field='matching_participant_number' AND `type`='input' AND structure_value_domain  IS NULL ;


UPDATE datamart_reports
 SET description='report_4_desc' WHERE id='4';
 
UPDATE menus SET flag_active=false WHERE id IN('core_CAN_41_1_3_5');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Inventorymanagement', 'ViewAliquot', 'view_aliquots', 'temperature', 'float',  NULL , '0', '', '', '', 'temperature', ''), 
('Inventorymanagement', 'ViewAliquot', 'view_aliquots', 'temp_unit', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='temperature_unit_code') , '0', '', '', '', '', 'unit');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='temperature' AND `type`='float' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='temperature' AND `language_tag`=''), '0', '25', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '1'), 
((SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='temp_unit' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='temperature_unit_code')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='unit'), '0', '26', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '1');
UPDATE structure_formats SET `display_order`='27' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='created' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats SET `display_column`='1', `display_order`='100', `language_heading`='system data' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='storagemasters') 
AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StorageMaster' AND `tablename`='storage_masters' AND `field`='code');

ALTER TABLE storage_controls
	DROP COLUMN storage_type_code;

UPDATE storage_masters SET code = id;
UPDATE storage_masters_revs SET code = id;

UPDATE structure_formats SET `display_order`='610', `language_heading`='system data', `flag_override_label`='0', `language_label`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='sample_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='sample_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='20', `language_heading`='system data' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_sample_joined_to_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='' AND `field`='sample_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

ALTER TABLE sample_controls
	DROP COLUMN sample_type_code;

UPDATE sample_masters SET sample_code = id;
UPDATE sample_masters_revs SET sample_code = id;	


ALTER TABLE storage_controls
 CHANGE check_conficts check_conflicts TINYINT UNSIGNED NOT NULL DEFAULT '1' COMMENT '0=no, 1=warn, anything else=error';
 
ALTER TABLE participants
 DROP KEY unique_participant_identifier;
 
ALTER TABLE configs
 ADD COLUMN define_csv_encoding VARCHAR(15) NOT NULL DEFAULT 'ISO-8859-1' AFTER define_csv_separator;
 
INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('csv_encoding', '', '', NULL);
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("ISO-8859-1", "ISO-8859-1");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="csv_encoding"),  (SELECT id FROM structure_permissible_values WHERE value="ISO-8859-1" AND language_alias="ISO-8859-1"), "1", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("UTF-8", "UTF-8");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="csv_encoding"),  (SELECT id FROM structure_permissible_values WHERE value="UTF-8" AND language_alias="UTF-8"), "1", "1");

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Administrate', 'Config', 'configs', 'define_csv_encoding', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='csv_encoding') , '0', '', '', 'help_csv_encoding', 'csv encoding', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='preferences'), (SELECT id FROM structure_fields WHERE `model`='Config' AND `tablename`='configs' AND `field`='define_csv_encoding' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='csv_encoding')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_csv_encoding' AND `language_label`='csv encoding' AND `language_tag`=''), '1', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0');
UPDATE structure_formats SET `display_order`='2' WHERE structure_id=(SELECT id FROM structures WHERE alias='preferences') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Config' AND `tablename`='configs' AND `field`='define_date_format' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='define_date_format') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='3' WHERE structure_id=(SELECT id FROM structures WHERE alias='preferences') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Config' AND `tablename`='configs' AND `field`='define_time_format' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='time_format') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='2' WHERE structure_id=(SELECT id FROM structures WHERE alias='preferences') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Config' AND `tablename`='configs' AND `field`='define_show_summary' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') AND `flag_confidential`='0');

INSERT INTO structure_validations (structure_field_id, rule, language_message) VALUES
((SELECT id FROM structure_fields WHERE `model`='Config' AND `tablename`='configs' AND `field`='define_csv_encoding' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='csv_encoding')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_csv_encoding' AND `language_label`='csv encoding' AND `language_tag`=''), 'notEmpty', '');

DELETE FROM structure_formats WHERE structure_id = (SELECT id FROM structures WHERE alias = 'view_sample_joined_to_parent');
DELETE FROM structures WHERE alias = 'view_sample_joined_to_parent';

SELECT '****************' as msg_6
UNION
SELECT 'The structure sample_masters_for_search_result has to be deleted and replaced by sample_masters in SampleMaster.Summary()' as msg_6
UNION
SELECT IF((SELECT (
SELECT COUNT(*)
FROM structure_formats 
WHERE structure_field_id IN (SELECT structure_field_id FROM structure_formats WHERE structure_id = (SELECT id FROM structures WHERE alias = 'sample_masters_for_search_result') AND flag_summary = '1')
AND structure_id = (SELECT id FROM structures WHERE alias = 'sample_masters_for_search_result')
AND structure_field_id NOT IN (SELECT structure_field_id FROM structure_formats WHERE structure_id = (SELECT id FROM structures WHERE alias = 'sample_masters'))
AND structure_field_id NOT IN (SELECT id FROM structure_fields WHERE field = 'acquisition_label')
)as SCORE) > 0, 
'Please run following queries and update manually sample_masters structrues to add fields that will miss into summary.', 
'Please run following queries.') AS msg_6
UNION 
SELECT "
UPDATE structure_formats SET flag_summary = 0 WHERE structure_id = (SELECT id FROM structures WHERE alias = 'sample_masters');
UPDATE structure_formats sf_sm, structure_formats sf_old
SET sf_sm.flag_summary = 1 
WHERE sf_sm.structure_id = (SELECT id FROM structures WHERE alias = 'sample_masters')
AND sf_sm.structure_field_id = sf_old.structure_field_id 
AND sf_old.structure_id = (SELECT id FROM structures WHERE alias = 'sample_masters_for_search_result') 
AND sf_old.flag_summary = '1';
DELETE from structure_formats WHERE structure_id = (SELECT id FROM structures WHERE alias = 'sample_masters_for_search_result');
DELETE from structures WHERE alias = 'sample_masters_for_search_result';
" AS msg_6
UNION ALL
SELECT '****************' as msg_6;

UPDATE menus SET use_link='/study/study_summaries/search/' WHERE id='tool_CAN_100';
UPDATE structure_fields SET  `language_tag`='study_tooo' WHERE model='StudySummary' AND tablename='study_summaries' AND field='end_date' AND `type`='date' AND structure_value_domain  IS NULL ;
UPDATE structure_fields SET  `language_label`='study start' WHERE model='StudySummary' AND tablename='study_summaries' AND field='start_date' AND `type`='date' AND structure_value_domain  IS NULL ;
UPDATE structure_fields SET  `language_label`='study end',  `language_tag`='' WHERE model='StudySummary' AND tablename='study_summaries' AND field='end_date' AND `type`='date' AND structure_value_domain  IS NULL ;

UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='date_of_birth' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

DELETE FROM structure_formats
WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE model LIKE 'Event%' AND field IN ('disease_site', 'event_group', 'event_type'))
AND `flag_add`='0' AND `flag_add_readonly`='0' AND `flag_edit`='0' AND `flag_edit_readonly`='0' AND `flag_search`='0' AND `flag_search_readonly`='0' AND `flag_addgrid`='0' AND `flag_addgrid_readonly`='0' AND `flag_editgrid`='0' AND `flag_editgrid_readonly`='0' AND `flag_summary`='0' AND `flag_batchedit`='0' AND `flag_batchedit_readonly`='0' AND `flag_index`='0' AND `flag_detail` = '0';
UPDATE structure_fields SET tablename = 'event_controls' WHERE model = 'EventControl';
DELETE FROM structure_formats WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE model LIKE 'Event%' AND field IN ('disease_site', 'event_group', 'event_type') AND type = 'input');
DELETE FROM structure_fields WHERE model LIKE 'Event%' AND field IN ('disease_site', 'event_group', 'event_type') AND type = 'input';
DELETE FROM structures WHERE alias = 'event_summary';
INSERT INTO `structure_value_domains` (`id`, `domain_name`, `override`, `category`, `source`) VALUES (null, 'event_group_list', 'open', '', 'Clinicalannotation.EventControl::getEventGroupPermissibleValues');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'EventControl', 'event_controls', 'event_group', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='event_group_list') , '0', '', '', '', 'event group', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='eventmasters'), (SELECT id FROM structure_fields WHERE `model`='EventControl' AND `tablename`='event_controls' AND `field`='event_group' AND `type`='select' ), '2', '-5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1');
UPDATE structure_formats SET `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='eventmasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_summary' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='eventmasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_fields SET language_label = 'event_group' WHERE language_label = 'event group'; 

