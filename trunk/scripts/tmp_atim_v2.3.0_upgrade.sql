-- Update version information
INSERT INTO `versions` (version_number, date_installed, build_number) VALUES('2.3.0 alpha', NOW(), '> 2840');

ALTER TABLE structure_permissible_values_customs
 ADD COLUMN display_order TINYINT UNSIGNED DEFAULT 0 AFTER fr;
ALTER TABLE structure_permissible_values_customs_revs
 ADD COLUMN display_order TINYINT UNSIGNED DEFAULT 0 AFTER fr;
 
REPLACE INTO i18n (id, en, fr) VALUES
("you cannot configure an empty list", "You cannot configure an empty list", "Vous ne pouvez pas configurer une liste vide"),
("alphabetical ordering", "Alphabetical ordering", "Ordonnancement alphabétique"),
("dropdown_config_desc", 
 "To have the list ordered alphabetically with the displayed values, check the \"Alphabetcical ordering\" option. Otherwise, uncheck it and use the cursor to drag the lines in the order you want the options to be displayed.",
 "Pour que la liste soit ordinnée alphabétiquement par les valeurs affichées, cochez l'option \"Ordonnancement alphabétique\". Sinon, décochez la et utilisez le curseur pour déplacer les lignes dans l'ordre d'affichage que vous voulez."),
("configure", "Configure", "Configurer"),
("server_client_time_discrepency", 
 "There is a time discrapency between the server and your computer. Verify that your computer time and date are accurate. It they are, contact the administrator.",
 "Il y a un écart entre l'heure et la date de votre serveur et de votre ordinateur. Vérifiez que votre heure et votre date sont correctement définis. S'ils le sont, contactez l'administrateur."),
("initiate browsing", "Initiate browsing", "Initier la navigation"),
("from batchset", "From batchset", "À partir d'un lot de données");

DROP TABLE datamart_batch_processes;

-- Updating some ATiM core fields from checkbox to yes_no type
UPDATE structure_fields SET type='yes_no' WHERE plugin='Inventorymanagement' AND model='SampleMaster' AND field='is_problematic';
UPDATE structure_fields SET type='yes_no' WHERE plugin='Inventorymanagement' AND model='AliquotReviewMaster' AND field='basis_of_specimen_review';
UPDATE structure_fields SET type='yes_no' WHERE plugin='Clinicalannotation' AND model='DiagnosisMaster' AND field='path_tnm_descriptor_m';
UPDATE structure_fields SET type='yes_no' WHERE plugin='Clinicalannotation' AND model='DiagnosisMaster' AND field='path_tnm_descriptor_r';
UPDATE structure_fields SET type='yes_no' WHERE plugin='Clinicalannotation' AND model='DiagnosisMaster' AND field='path_tnm_descriptor_y';

ALTER TABLE sample_masters
 MODIFY is_problematic CHAR(1) DEFAULT '';
UPDATE sample_masters SET is_problematic='' WHERE is_problematic='0';
UPDATE sample_masters SET is_problematic='y' WHERE is_problematic='1';
ALTER TABLE sample_masters_revs
 MODIFY is_problematic CHAR(1) DEFAULT '';
UPDATE sample_masters_revs SET is_problematic='' WHERE is_problematic='0';
UPDATE sample_masters_revs SET is_problematic='y' WHERE is_problematic='1';

ALTER TABLE aliquot_review_masters
 MODIFY basis_of_specimen_review CHAR(1) DEFAULT '';
UPDATE aliquot_review_masters SET basis_of_specimen_review='' WHERE basis_of_specimen_review='0';  
UPDATE aliquot_review_masters SET basis_of_specimen_review='y' WHERE basis_of_specimen_review='1';  
ALTER TABLE aliquot_review_masters_revs
 MODIFY basis_of_specimen_review CHAR(1) DEFAULT '';
UPDATE aliquot_review_masters_revs SET basis_of_specimen_review='' WHERE basis_of_specimen_review='0';  
UPDATE aliquot_review_masters_revs SET basis_of_specimen_review='y' WHERE basis_of_specimen_review='1';

ALTER TABLE diagnosis_masters
 MODIFY path_tnm_descriptor_m CHAR(1) DEFAULT '',
 MODIFY path_tnm_descriptor_r CHAR(1) DEFAULT '',
 MODIFY path_tnm_descriptor_y CHAR(1) DEFAULT '';
UPDATE diagnosis_masters SET path_tnm_descriptor_m='' WHERE path_tnm_descriptor_m='0';
UPDATE diagnosis_masters SET path_tnm_descriptor_m='y' WHERE path_tnm_descriptor_m='1';
UPDATE diagnosis_masters SET path_tnm_descriptor_r='' WHERE path_tnm_descriptor_r='0';
UPDATE diagnosis_masters SET path_tnm_descriptor_r='y' WHERE path_tnm_descriptor_r='1';
UPDATE diagnosis_masters SET path_tnm_descriptor_y='' WHERE path_tnm_descriptor_y='0';
UPDATE diagnosis_masters SET path_tnm_descriptor_y='y' WHERE path_tnm_descriptor_y='1';
ALTER TABLE diagnosis_masters_revs
 MODIFY path_tnm_descriptor_m CHAR(1) DEFAULT '',
 MODIFY path_tnm_descriptor_r CHAR(1) DEFAULT '',
 MODIFY path_tnm_descriptor_y CHAR(1) DEFAULT '';
UPDATE diagnosis_masters_revs SET path_tnm_descriptor_m='' WHERE path_tnm_descriptor_m='0';
UPDATE diagnosis_masters_revs SET path_tnm_descriptor_m='y' WHERE path_tnm_descriptor_m='1';
UPDATE diagnosis_masters_revs SET path_tnm_descriptor_r='' WHERE path_tnm_descriptor_r='0';
UPDATE diagnosis_masters_revs SET path_tnm_descriptor_r='y' WHERE path_tnm_descriptor_r='1';
UPDATE diagnosis_masters_revs SET path_tnm_descriptor_y='' WHERE path_tnm_descriptor_y='0';
UPDATE diagnosis_masters_revs SET path_tnm_descriptor_y='y' WHERE path_tnm_descriptor_y='1';

REPLACE INTO i18n(id, en, fr) VALUES
('credits_title', 'Credits', 'Auteurs'),
('online wiki', 'Online Wiki', "Wiki en ligne (en anglais)"),
('core_customize', 'Customize', 'Personnaliser');