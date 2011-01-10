DROP VIEW IF EXISTS view_collections;
CREATE VIEW view_collections AS 
SELECT 
col.id AS collection_id,
col.bank_id AS bank_id,
col.sop_master_id AS sop_master_id,
link.participant_id AS participant_id,
link.diagnosis_master_id AS diagnosis_master_id,
link.consent_master_id AS consent_master_id,

part.participant_identifier AS participant_identifier,
ident.identifier_name AS identifier_name,
ident.identifier_value AS identifier_value,

col.acquisition_label AS acquisition_label,
col.collection_site AS collection_site,
col.visit_label AS visit_label, 
col.collection_datetime AS collection_datetime,
col.collection_datetime_accuracy AS collection_datetime_accuracy,
col.collection_property AS collection_property,
col.collection_notes AS collection_notes,
col.deleted AS deleted,
banks.name AS bank_name,
col.created AS created 

FROM collections AS col 
LEFT JOIN clinical_collection_links AS link ON col.id = link.collection_id AND link.deleted != 1
LEFT JOIN participants AS part ON link.participant_id = part.id AND part.deleted != 1
LEFT JOIN banks ON col.bank_id = banks.id AND banks.deleted != 1
LEFT JOIN misc_identifiers AS ident ON ident.misc_identifier_control_id = banks.misc_identifier_control_id AND ident.participant_id = part.id AND ident.deleted != 1
WHERE col.deleted != 1;

DROP VIEW IF EXISTS view_samples;
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
ident.identifier_name AS identifier_name,
ident.identifier_value AS identifier_value,

col.acquisition_label,
col.visit_label AS visit_label,

specimen.sample_type AS initial_specimen_sample_type,
specimen.sample_control_id AS initial_specimen_sample_control_id,
parent_samp.sample_type AS parent_sample_type,
parent_samp.sample_control_id AS parent_sample_control_id,
samp.sample_type,
samp.sample_control_id,
samp.sample_code,
samp.sample_label AS sample_label,
samp.sample_category,
samp.deleted

FROM sample_masters as samp
INNER JOIN collections AS col ON col.id = samp.collection_id AND col.deleted != 1
LEFT JOIN sample_masters as specimen ON samp.initial_specimen_sample_id = specimen.id AND specimen.deleted != 1
LEFT JOIN sample_masters as parent_samp ON samp.parent_id = parent_samp.id AND parent_samp.deleted != 1
LEFT JOIN clinical_collection_links AS link ON col.id = link.collection_id AND link.deleted != 1
LEFT JOIN participants AS part ON link.participant_id = part.id AND part.deleted != 1
LEFT JOIN banks ON col.bank_id = banks.id AND banks.deleted != 1
LEFT JOIN misc_identifiers AS ident ON ident.misc_identifier_control_id = banks.misc_identifier_control_id AND ident.participant_id = part.id AND ident.deleted != 1
WHERE samp.deleted != 1;

DROP VIEW IF EXISTS view_aliquots;
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
ident.identifier_name AS identifier_name,
ident.identifier_value AS identifier_value,

col.acquisition_label, 
col.visit_label AS visit_label,

specimen.sample_type AS initial_specimen_sample_type,
specimen.sample_control_id AS initial_specimen_sample_control_id,
parent_samp.sample_type AS parent_sample_type,
parent_samp.sample_control_id AS parent_sample_control_id,
samp.sample_type,
samp.sample_control_id,
samp.sample_label AS sample_label,

al.barcode,
al.aliquot_label AS aliquot_label,
al.aliquot_type,
al.aliquot_control_id,
al.in_stock,

stor.code,
stor.selection_label,
al.storage_coord_x,
al.storage_coord_y,

stor.temperature,
stor.temp_unit,

tubes.tmp_storage_solution AS storage_solution,
tubes.tmp_storage_method AS storage_method,

al.created,
al.deleted

FROM aliquot_masters as al
INNER JOIN sample_masters as samp ON samp.id = al.sample_master_id AND samp.deleted != 1
LEFT JOIN sample_masters as specimen ON samp.initial_specimen_sample_id = specimen.id AND specimen.deleted != 1
LEFT JOIN sample_masters as parent_samp ON samp.parent_id = parent_samp.id AND parent_samp.deleted != 1
INNER JOIN collections AS col ON col.id = samp.collection_id AND col.deleted != 1
LEFT JOIN clinical_collection_links AS link ON col.id = link.collection_id AND link.deleted != 1
LEFT JOIN participants AS part ON link.participant_id = part.id AND part.deleted != 1
LEFT JOIN storage_masters AS stor ON stor.id = al.storage_master_id AND stor.deleted != 1
LEFT JOIN banks ON col.bank_id = banks.id AND banks.deleted != 1
LEFT JOIN misc_identifiers AS ident ON ident.misc_identifier_control_id = banks.misc_identifier_control_id AND ident.participant_id = part.id AND ident.deleted != 1
LEFT JOIN ad_tubes AS tubes ON tubes.aliquot_master_id=al.id
WHERE al.deleted != 1;

UPDATE users SET flag_active = '1';

UPDATE tx_controls SET flag_active = '0';
UPDATE protocol_controls SET flag_active = '0';

UPDATE users SET password = 'b23665e49d6bbc824143ba6c09490c781cb94370' WHERE username LIKE 'Liliane';

UPDATE users SET flag_active=true;

UPDATE i18n SET en = 'ATiM - Advanced Tissue Management - v.ICM (Test)', fr = 'ATiM - Application de gestion avancée des tissus - v.ICM (Test)' WHERE id = 'core_appname';

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_add = '0', sfo.flag_add_readonly = '0', 
sfo.flag_edit = '0', sfo.flag_edit_readonly = '0',
sfo.flag_datagrid = '0',sfo.flag_datagrid_readonly = '0',
sfo.flag_search = '0', sfo.flag_search_readonly = '0',
sfo.flag_index = '0', sfo.flag_detail = '0'
WHERE sfi.field IN ('identifier_abrv') 
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("unknown", "unknown");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="qc_consent_type"),  (SELECT id FROM structure_permissible_values WHERE value="unknown" AND language_alias="unknown"), "5", "1");

SET @id_to_delete = (SELECT id FROM structure_formats
WHERE structure_id = (SELECT id FROM structures WHERE alias = 'participants')
AND structure_field_id = (SELECT id FROM structure_fields WHERE field = 'created' AND model = 'Participant') LIMIT 0,1);

DELETE FROM structure_formats WHERE id = @id_to_delete;

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.display_column = '4', sfo.display_order = '15'
WHERE sfi.field IN ('created') 
AND str.alias = 'participants'
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

UPDATE structure_permissible_values_customs SET en = 'Cecile Grange', fr = 'Cecile Grange' WHERE value = 'cecile grange';
UPDATE structure_permissible_values_customs SET en = 'Aurore Pierrard', fr = 'Aurore Pierrard' WHERE value = 'aurore pierrard';
UPDATE structure_permissible_values_customs SET en = 'Chantale Auger', fr = 'Chantale Auger' WHERE value = 'chantale auger';
UPDATE structure_permissible_values_customs SET en = 'Christine Abaji', fr = 'Christine Abaji' WHERE value = 'christine abaji';
UPDATE structure_permissible_values_customs SET en = 'Emilio, Johanne et Phil', fr = 'émilio, Johanne et Phil' WHERE value = 'emilio, johanne et phil';
UPDATE structure_permissible_values_customs SET en = 'Hafida Lounis', fr = 'Hafida Lounis' WHERE value = 'hafida lounis';
UPDATE structure_permissible_values_customs SET en = 'Isabelle Létourneau', fr = 'Isabelle Létourneau' WHERE value = 'isabelle letourneau';
UPDATE structure_permissible_values_customs SET en = 'Jason Madore', fr = 'Jason Madore' WHERE value = 'jason madore';
UPDATE structure_permissible_values_customs SET en = 'Jennifer Kendall Dupont', fr = 'Jennifer Kendall Dupont' WHERE value = 'jennifer kendall dupont';
UPDATE structure_permissible_values_customs SET en = 'Jessica Godin Ethier', fr = 'Jessica Godin Ethier' WHERE value = 'jessica godin ethier';
UPDATE structure_permissible_values_customs SET en = 'Josh Levin', fr = 'Josh Levin' WHERE value = 'josh levin';
UPDATE structure_permissible_values_customs SET en = 'Julie Desgagnés', fr = 'Julie Desgagnés' WHERE value = 'julie desgagnes';
UPDATE structure_permissible_values_customs SET en = 'Karine Normandin', fr = 'Karine Normandin' WHERE value = 'karine normandin';
UPDATE structure_permissible_values_customs SET en = 'Kevin Gu', fr = 'Kevin Gu' WHERE value = 'kevin gu';
UPDATE structure_permissible_values_customs SET en = 'Labo externe', fr = 'Labo externe' WHERE value = 'labo externe';
UPDATE structure_permissible_values_customs SET en = 'Liliane Meunier', fr = 'Liliane Meunier' WHERE value = 'liliane meunier';
UPDATE structure_permissible_values_customs SET en = 'Lise Portelance', fr = 'Lise Portelance' WHERE value = 'lise portelance';
UPDATE structure_permissible_values_customs SET en = 'Louise Champoux', fr = 'Louise Champoux' WHERE value = 'louise champoux';
UPDATE structure_permissible_values_customs SET en = 'Magdalena Zietarska', fr = 'Magdalena Zietarska' WHERE value = 'magdalena zietarska';
UPDATE structure_permissible_values_customs SET en = 'Manon de Ladurantaye', fr = 'Manon de Ladurantaye' WHERE value = 'manon de ladurantaye';
UPDATE structure_permissible_values_customs SET en = 'Marie-Andrée Forget', fr = 'Marie-Andrée Forget' WHERE value = 'marie-andree forget';
UPDATE structure_permissible_values_customs SET en = 'Marie-Josée Milot', fr = 'Marie-Josée Milot' WHERE value = 'marie-josee milot';
UPDATE structure_permissible_values_customs SET en = 'Marie-Line Puiffe', fr = 'Marie-Line Puiffe' WHERE value = 'marie-line puiffe';
UPDATE structure_permissible_values_customs SET en = 'Marise Roy', fr = 'Marise Roy' WHERE value = 'marise roy';
UPDATE structure_permissible_values_customs SET en = 'Matthew Starek', fr = 'Matthew Starek' WHERE value = 'matthew starek';
UPDATE structure_permissible_values_customs SET en = 'Mona Alam', fr = 'Mona Alam' WHERE value = 'mona alam';
UPDATE structure_permissible_values_customs SET en = 'Nathalie Delvoye', fr = 'Nathalie Delvoye' WHERE value = 'nathalie delvoye';
UPDATE structure_permissible_values_customs SET en = 'Pathologie', fr = 'Pathologie' WHERE value = 'pathologie';
UPDATE structure_permissible_values_customs SET en = 'Patrick Kibangou Bondza', fr = 'Patrick Kibangou Bondza' WHERE value = 'patrick kibangou bondza';
UPDATE structure_permissible_values_customs SET en = 'Stéphanie Lepage', fr = 'Stéphanie Lepage' WHERE value = 'stephanie lepage';
UPDATE structure_permissible_values_customs SET en = 'Urszula Krzemien', fr = 'Urszula Krzemien' WHERE value = 'urszula krzemien';
UPDATE structure_permissible_values_customs SET en = 'Valérie Forest', fr = 'Valérie Forest' WHERE value = 'valerie forest';
UPDATE structure_permissible_values_customs SET en = 'Véronique Barrès', fr = 'Véronique Barrès' WHERE value = 'veronique barres';
UPDATE structure_permissible_values_customs SET en = 'Véronique Ouellet', fr = 'Véronique Ouellet' WHERE value = 'veronique ouellet';
UPDATE structure_permissible_values_customs SET en = 'Yuan Chang', fr = 'Yuan Chang' WHERE value = 'yuan chang';
UPDATE structure_permissible_values_customs SET en = 'Other', fr = 'Autre' WHERE value = 'autre';
UPDATE structure_permissible_values_customs SET en = 'Other', fr = 'Autre' WHERE value = 'other';
UPDATE structure_permissible_values_customs SET en = 'Unknown', fr = 'Inconnue' WHERE value = 'inconnue';
UPDATE structure_permissible_values_customs SET en = 'Unknown', fr = 'Inconnue' WHERE value = 'unknown';
UPDATE structure_permissible_values_customs SET en = 'Guillaume Cardin', fr = 'Guillaume Cardin' WHERE value = 'guillaume cardin';
UPDATE structure_permissible_values_customs SET en = 'Teodora Yaneva', fr = 'Teodora Yaneva' WHERE value = 'teodora yaneva';
UPDATE structure_permissible_values_customs SET en = 'Katia Caceres', fr = 'Katia Caceres' WHERE value = 'katia caceres';
UPDATE structure_permissible_values_customs SET en = 'Carl-Frédéric Duchatellier', fr = 'Carl-Frédéric Duchatellier' WHERE value = 'carl-frederic duchatellier';
UPDATE structure_permissible_values_customs SET en = 'Michael Quinn', fr = 'Michael Quinn' WHERE value = 'michael quinn';
UPDATE structure_permissible_values_customs SET en = 'Michael Quinn', fr = 'Michael Quinn' WHERE value = 'michael quinn';
UPDATE structure_permissible_values_customs SET en = 'Louis Cyr', fr = 'Louis Cyr' WHERE value = 'louis cyr';
UPDATE structure_permissible_values_customs SET en = 'Rayane El Masri', fr = 'Rayane El Masri' WHERE value = 'rayane el masri';

UPDATE structure_permissible_values_customs SET en = 'Labo Christopoulos', fr = 'Labo Christopoulos' WHERE value = 'Labo Christopoulos';
UPDATE structure_permissible_values_customs SET en = 'Labo Dr Maugard', fr = 'Labo Dr Maugard' WHERE value = 'Labo Dr Maugard';
UPDATE structure_permissible_values_customs SET en = 'Labo Dr Mes-Masson', fr = 'Labo Dr Mes-Masson' WHERE value = 'Labo Dr Mes-Masson';
UPDATE structure_permissible_values_customs SET en = 'Labo Dr Santos', fr = 'Labo Dr Santos' WHERE value = 'Labo Dr Santos';
UPDATE structure_permissible_values_customs SET en = 'Labo Dr Tonin', fr = 'Labo Dr Tonin' WHERE value = 'Labo Dr Tonin';
UPDATE structure_permissible_values_customs SET en = 'Labo Sein', fr = 'Labo Sein' WHERE value = 'Labo Sein';

UPDATE structure_permissible_values_customs SET en = 'CHUQ', fr = 'CHUQ' WHERE value = 'CHUQ';
UPDATE structure_permissible_values_customs SET en = 'CHUS', fr = 'CHUS' WHERE value = 'CHUS';
UPDATE structure_permissible_values_customs SET en = 'FIDES - External Clinic', fr = 'FIDES - Clinique externe' WHERE value = 'FIDES external clinic';
UPDATE structure_permissible_values_customs SET en = 'Hotel Dieu Hospital', fr = 'Hôpital Hotel Dieu' WHERE value = 'hotel dieu hospital';
UPDATE structure_permissible_values_customs SET en = 'Notre Dame Hospital', fr = 'Hôpital Notre Dame' WHERE value = 'notre dame hospital';
UPDATE structure_permissible_values_customs SET en = 'Saint Luc hospital', fr = 'Hôpital Saint Luc' WHERE value = 'saint luc hospital';

UPDATE structure_permissible_values_customs SET en = 'Biological Sample Taking Center', fr = 'Centre de prélèvement' WHERE value = 'biological sample taking center';
UPDATE structure_permissible_values_customs SET en = 'Breast Clinic', fr = 'Clinique du Sein' WHERE value = 'breast clinic';
UPDATE structure_permissible_values_customs SET en = 'Clinic', fr = 'Clinique' WHERE value = 'clinic';
UPDATE structure_permissible_values_customs SET en = 'External Clinic', fr = 'Clinique externe' WHERE value = 'external clinic';
UPDATE structure_permissible_values_customs SET en = 'Family Cancer Center', fr = 'Centre des cancers familiaux' WHERE value = 'family cancer center';
UPDATE structure_permissible_values_customs SET en = 'Gynaecology/Oncology Clinic', fr = 'Clinique Gyneco/Onco' WHERE value = 'gynaecology/oncology clinic';
UPDATE structure_permissible_values_customs SET en = 'Operating Room', fr = 'Chambre opératoire' WHERE value = 'operating room';
UPDATE structure_permissible_values_customs SET en = 'Pathology Dept', fr = 'Dept. Patho.' WHERE value = 'pathology dept';
UPDATE structure_permissible_values_customs SET en = 'Preoperative Checkup', fr = 'Bilan pré-opératoire' WHERE value = 'preoperative checkup';

DELETE FROM structure_value_domains_permissible_values WHERE structure_value_domain_id = (SELECT id FROM structure_value_domains WHERE domain_name LIKE 'qc_global_consent_version');
UPDATE structure_value_domains SET source = 'StructurePermissibleValuesCustom::getCustomDropdown(''qc consent version'')' WHERE domain_name = 'qc_global_consent_version';

INSERT INTO `structure_permissible_values_custom_controls` (`id`, `name`, `flag_active`, `values_max_length`) VALUES
(null, 'qc consent version', 1, 20);

SET @last_insert_id = (SELECT id FROM structure_permissible_values_custom_controls where name LIKE 'qc consent version');
INSERT INTO `structure_permissible_values_customs` (`id`, `control_id`, `value`, `en`, `fr`, `created`, `created_by`, `modified`, `modified_by`, `deleted`, `deleted_date`) 
VALUES
(null, @last_insert_id, '2008-10-02','2008-10-02','2008-10-02', '0000-00-00 00:00:00', 0, NULL, 0, 0, NULL),
(null, @last_insert_id, '2008-09-24','2008-09-24','2008-09-24', '0000-00-00 00:00:00', 0, NULL, 0, 0, NULL),
(null, @last_insert_id, '2008-06-26','2008-06-26','2008-06-26', '0000-00-00 00:00:00', 0, NULL, 0, 0, NULL),
(null, @last_insert_id, '2008-06-23','2008-06-23','2008-06-23', '0000-00-00 00:00:00', 0, NULL, 0, 0, NULL),
(null, @last_insert_id, '2008-03-23','2008-03-23','2008-03-23', '0000-00-00 00:00:00', 0, NULL, 0, 0, NULL),
(null, @last_insert_id, '2008-05-04','2008-05-04','2008-05-04', '0000-00-00 00:00:00', 0, NULL, 0, 0, NULL),
(null, @last_insert_id, '2008-04-05','2008-04-05','2008-04-05', '0000-00-00 00:00:00', 0, NULL, 0, 0, NULL),
(null, @last_insert_id, '2008-03-26','2008-03-26','2008-03-26', '0000-00-00 00:00:00', 0, NULL, 0, 0, NULL),
(null, @last_insert_id, '2007-10-25','2007-10-25','2007-10-25', '0000-00-00 00:00:00', 0, NULL, 0, 0, NULL),
(null, @last_insert_id, '2007-06-05','2007-06-05','2007-06-05', '0000-00-00 00:00:00', 0, NULL, 0, 0, NULL),
(null, @last_insert_id, '2007-05-23','2007-05-23','2007-05-23', '0000-00-00 00:00:00', 0, NULL, 0, 0, NULL),
(null, @last_insert_id, '2007-05-15','2007-05-15','2007-05-15', '0000-00-00 00:00:00', 0, NULL, 0, 0, NULL),
(null, @last_insert_id, '2007-05-05','2007-05-05','2007-05-05', '0000-00-00 00:00:00', 0, NULL, 0, 0, NULL),
(null, @last_insert_id, '2007-05-04','2007-05-04','2007-05-04', '0000-00-00 00:00:00', 0, NULL, 0, 0, NULL),
(null, @last_insert_id, '2007-04-04','2007-04-04','2007-04-04', '0000-00-00 00:00:00', 0, NULL, 0, 0, NULL),
(null, @last_insert_id, '2007-03-12','2007-03-12','2007-03-12', '0000-00-00 00:00:00', 0, NULL, 0, 0, NULL),
(null, @last_insert_id, '2006-08-05','2006-08-05','2006-08-05', '0000-00-00 00:00:00', 0, NULL, 0, 0, NULL),
(null, @last_insert_id, '2006-06-09','2006-06-09','2006-06-09', '0000-00-00 00:00:00', 0, NULL, 0, 0, NULL),
(null, @last_insert_id, '2006-05-26','2006-05-26','2006-05-26', '0000-00-00 00:00:00', 0, NULL, 0, 0, NULL),
(null, @last_insert_id, '2006-05-08','2006-05-08','2006-05-08', '0000-00-00 00:00:00', 0, NULL, 0, 0, NULL),
(null, @last_insert_id, '2006-05-07','2006-05-07','2006-05-07', '0000-00-00 00:00:00', 0, NULL, 0, 0, NULL),
(null, @last_insert_id, '2006-05-06','2006-05-06','2006-05-06', '0000-00-00 00:00:00', 0, NULL, 0, 0, NULL),
(null, @last_insert_id, '2006-02-26','2006-02-26','2006-02-26', '0000-00-00 00:00:00', 0, NULL, 0, 0, NULL),
(null, @last_insert_id, '2006-02-09','2006-02-09','2006-02-09', '0000-00-00 00:00:00', 0, NULL, 0, 0, NULL),
(null, @last_insert_id, '2006-02-01','2006-02-01','2006-02-01', '0000-00-00 00:00:00', 0, NULL, 0, 0, NULL),
(null, @last_insert_id, '2006-01-10','2006-01-10','2006-01-10', '0000-00-00 00:00:00', 0, NULL, 0, 0, NULL),
(null, @last_insert_id, '2005-10-27','2005-10-27','2005-10-27', '0000-00-00 00:00:00', 0, NULL, 0, 0, NULL),
(null, @last_insert_id, '2005-10-25','2005-10-25','2005-10-25', '0000-00-00 00:00:00', 0, NULL, 0, 0, NULL),
(null, @last_insert_id, '2005-07-27','2005-07-27','2005-07-27', '0000-00-00 00:00:00', 0, NULL, 0, 0, NULL),
(null, @last_insert_id, '2005-06-26','2005-06-26','2005-06-26', '0000-00-00 00:00:00', 0, NULL, 0, 0, NULL),
(null, @last_insert_id, '2005-05-26','2005-05-26','2005-05-26', '0000-00-00 00:00:00', 0, NULL, 0, 0, NULL),
(null, @last_insert_id, '2005-03-26','2005-03-26','2005-03-26', '0000-00-00 00:00:00', 0, NULL, 0, 0, NULL),
(null, @last_insert_id, '2005-01-26','2005-01-26','2005-01-26', '0000-00-00 00:00:00', 0, NULL, 0, 0, NULL),
(null, @last_insert_id, '2005-01-05','2005-01-05','2005-01-05', '0000-00-00 00:00:00', 0, NULL, 0, 0, NULL),
(null, @last_insert_id, '2004-12-14','2004-12-14','2004-12-14', '0000-00-00 00:00:00', 0, NULL, 0, 0, NULL),
(null, @last_insert_id, '2004-09-14','2004-09-14','2004-09-14', '0000-00-00 00:00:00', 0, NULL, 0, 0, NULL),
(null, @last_insert_id, '2004-07-15','2004-07-15','2004-07-15', '0000-00-00 00:00:00', 0, NULL, 0, 0, NULL),
(null, @last_insert_id, '2004-03-01','2004-03-01','2004-03-01', '0000-00-00 00:00:00', 0, NULL, 0, 0, NULL),
(null, @last_insert_id, '2003-12-03','2003-12-03','2003-12-03', '0000-00-00 00:00:00', 0, NULL, 0, 0, NULL),
(null, @last_insert_id, '2002-09-13','2002-09-13','2002-09-13', '0000-00-00 00:00:00', 0, NULL, 0, 0, NULL),
(null, @last_insert_id, '2002-04-08','2002-04-08','2002-04-08', '0000-00-00 00:00:00', 0, NULL, 0, 0, NULL),
(null, @last_insert_id, '2001-03-30','2001-03-30','2001-03-30', '0000-00-00 00:00:00', 0, NULL, 0, 0, NULL),
(null, @last_insert_id, '2000-04-20','2000-04-20','2000-04-20', '0000-00-00 00:00:00', 0, NULL, 0, 0, NULL),
(null, @last_insert_id, '2009-11-04','2009-11-04','2009-11-04', '0000-00-00 00:00:00', 0, NULL, 0, 0, NULL),
(null, @last_insert_id, '2010-03-04','2010-03-04','2010-03-04', '0000-00-00 00:00:00', 0, NULL, 0, 0, NULL),
(null, @last_insert_id, '2010-09-01','2010-09-01','2010-09-01', '0000-00-00 00:00:00', 0, NULL, 0, 0, NULL),
(null, @last_insert_id, '2007-09-01','2007-09-01','2007-09-01', '0000-00-00 00:00:00', 0, NULL, 0, 0, NULL);

DELETE FROM structure_value_domains_permissible_values WHERE structure_value_domain_id = (SELECT id FROM structure_value_domains WHERE domain_name LIKE 'qc_visit_label');
UPDATE structure_value_domains SET source = 'StructurePermissibleValuesCustom::getCustomDropdown(''qc visit label'')' WHERE domain_name = 'qc_visit_label';

INSERT INTO `structure_permissible_values_custom_controls` (`id`, `name`, `flag_active`, `values_max_length`) VALUES
(null, 'qc visit label', 1, 20);

SET @last_insert_id = (SELECT id FROM structure_permissible_values_custom_controls where name LIKE 'qc visit label');
INSERT INTO `structure_permissible_values_customs` (`id`, `control_id`, `value`, `en`, `fr`, `created`, `created_by`, `modified`, `modified_by`, `deleted`, `deleted_date`) 
VALUES
(null, @last_insert_id, 'V01','V01','V01', '0000-00-00 00:00:00', 0, NULL, 0, 0, NULL),
(null, @last_insert_id, 'V02','V02','V02', '0000-00-00 00:00:00', 0, NULL, 0, 0, NULL),
(null, @last_insert_id, 'V03','V03','V03', '0000-00-00 00:00:00', 0, NULL, 0, 0, NULL),
(null, @last_insert_id, 'V04','V04','V04', '0000-00-00 00:00:00', 0, NULL, 0, 0, NULL),
(null, @last_insert_id, 'V05','V05','V05', '0000-00-00 00:00:00', 0, NULL, 0, 0, NULL);

DELETE FROM structure_formats WHERE structure_field_id = (SELECT id FROM structure_fields WHERE field = 'consent_type');
DELETE FROM structure_fields WHERE field = 'consent_type';
DELETE FROM structure_value_domains_permissible_values WHERE structure_value_domain_id = (SELECT id FROM structure_value_domains WHERE domain_name LIKE 'qc_consent_type');
DELETE FROM structure_value_domains WHERE domain_name LIKE 'qc_consent_type';

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.language_heading = 'consent version'
WHERE sfi.field IN ('consent_version_date') 
AND str.alias = 'cd_icm_generics'
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

ALTER TABLE consent_masters DROP COLUMN consent_type;
ALTER TABLE consent_masters_revs DROP COLUMN consent_type;

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_search = '0', sfo.flag_index = '0'
WHERE str.alias = 'cd_icm_generics'
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_search = '1', sfo.flag_index = '1'
WHERE sfi.field IN ('consent_version_date', 'consent_status', 'status_date', 'consent_signed_date' ,'biological_material_use', 'use_of_urine','use_of_blood', 'urine_blood_use_for_followup','allow_questionnaire')
AND str.alias = 'cd_icm_generics'
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_search = '0', sfo.flag_index = '0'
WHERE str.alias = 'consent_masters'
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_search = '1', sfo.flag_index = '1'
WHERE sfi.field IN ('consent_control_id', 'consent_status', 'consent_signed_date')
AND str.alias = 'consent_masters'
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

UPDATE aliquot_review_controls set flag_active = '0';
UPDATE specimen_review_controls set flag_active = '0';

TRUNCATE dxd_sardos;
DROP TABLE dxd_sardos, dxd_sardos_revs;
UPDATE clinical_collection_links SET diagnosis_master_id = NULL;
UPDATE event_masters SET diagnosis_master_id = NULL;
UPDATE tx_masters SET diagnosis_master_id = NULL;
TRUNCATE diagnosis_masters;
UPDATE diagnosis_controls SET flag_active = '0';
DELETE FROM diagnosis_controls WHERE controls_type = 'sardo diagnosis';
DELETE FROM structure_formats WHERE structure_id = (SELECT id FROM structures WHERE alias = 'dxd_sardos');
DELETE FROM structures WHERE alias = 'dxd_sardos';
UPDATE menus SET flag_active = '0' WHERE use_link LIKE '/clinicalannotation/diagnosis_masters%';
UPDATE menus SET flag_active = '0' WHERE use_link LIKE '/clinicalannotation/treatment_masters%';

TRUNCATE family_histories;
UPDATE menus SET flag_active = '0' WHERE use_link LIKE '/clinicalannotation/family_histories%';

UPDATE event_controls SET detail_tablename = 'ed_all_procure_lifestyles' WHERE detail_tablename = 'ed_all_procure_lifestyle';
ALTER TABLE ed_all_procure_lifestyle RENAME TO ed_all_procure_lifestyles;
ALTER TABLE ed_all_procure_lifestyle_revs RENAME TO ed_all_procure_lifestyles_revs;

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_add = '0', sfo.flag_add_readonly = '0', 
sfo.flag_edit = '0', sfo.flag_edit_readonly = '0',
sfo.flag_datagrid = '0',sfo.flag_datagrid_readonly = '0',
sfo.flag_search = '0', sfo.flag_search_readonly = '0',
sfo.flag_index = '0', sfo.flag_detail = '0'
WHERE sfi.field IN ('expiry_date', 'effective_date') 
AND sfi.model = 'MiscIdentifier'
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_add = '0', sfo.flag_add_readonly = '0', 
sfo.flag_edit = '0', sfo.flag_edit_readonly = '0',
sfo.flag_datagrid = '0',sfo.flag_datagrid_readonly = '0',
sfo.flag_search = '0', sfo.flag_search_readonly = '0',
sfo.flag_index = '0', sfo.flag_detail = '0'
WHERE str.alias IN ('clinicalcollectionlinks') 
AND sfi.model = 'DiagnosisMaster'
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_add = '0', sfo.flag_add_readonly = '0', 
sfo.flag_edit = '0', sfo.flag_edit_readonly = '0',
sfo.flag_datagrid = '0',sfo.flag_datagrid_readonly = '0',
sfo.flag_search = '0', sfo.flag_search_readonly = '0',
sfo.flag_index = '0', sfo.flag_detail = '0'
WHERE str.alias IN ('clinicalcollectionlinks') 
AND sfi.model = 'ConsentMaster'
AND sfi.field NOT IN ('consent_status')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='clinicalcollectionlinks'), 
(SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='consent_control_id'), 
'2', '1', 'consent', '1', 'consent type', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='clinicalcollectionlinks'), 
(SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='consent_signed_date'), 
'2', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1'); 

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.display_column = '1'
WHERE str.alias IN ('clinicalcollectionlinks') 
AND sfi.model = 'Collection'
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

UPDATE datamart_browsing_controls 
SET flag_active_1_to_2 = '0', flag_active_2_to_1 = '0' 
WHERE id1 IN (
	SELECT id FROM datamart_structures 
	WHERE (plugin = 'Clinicalannotation' AND model IN ('TreatmentMaster', 'FamilyHistory', 'DiagnosisMaster')) 
	OR (plugin = 'Inventorymanagement' AND model IN ('SpecimenReviewMaster'))
)
OR id2 IN (
	SELECT id FROM datamart_structures 
	WHERE (plugin = 'Clinicalannotation' AND model IN ('TreatmentMaster', 'FamilyHistory', 'DiagnosisMaster')) 
	OR (plugin = 'Inventorymanagement' AND model IN ('SpecimenReviewMaster'))
);

UPDATE menus SET use_link = '/datamart/browser/index' WHERE use_link LIKE '/datamart/%' AND is_root = '1';

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_search = sfo.flag_index
WHERE str.alias IN ('ed_all_procure_lifestyle') 
AND sfi.field NOT IN ('notes')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_search = '0', sfo.flag_index  = '0'
WHERE str.alias IN ('ed_all_procure_lifestyle') 
AND sfi.field IN ('disease_site','event_type')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_search = '1'
WHERE str.alias IN ('miscidentifiers') 
AND sfi.field IN ('identifier_name','identifier_value')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

UPDATE datamart_structures
SET structure_id = (SELECT id FROM structures WHERE alias = 'miscidentifiers')
WHERE model = 'MiscIdentifier';

UPDATE parent_to_derivative_sample_controls SET flag_active=true WHERE id IN(25);
UPDATE sample_to_aliquot_controls SET flag_active=false WHERE id IN(43, 42);

UPDATE sample_masters samp, aliquot_masters aliq
SET samp.sample_control_id = (SELECT id FROM sample_controls WHERE sample_type = 'b cell'),
samp.sample_type = 'b cell'
WHERE samp.id = aliq.sample_master_id 
AND aliq.aliquot_label LIKE 'LB-PBMC%';

DELETE FROM sd_der_pbmcs WHERE sample_master_id IN (SELECT sample_master_id FROM aliquot_masters WHERE aliquot_label LIKE 'LB-PBMC%');

INSERT INTO sd_der_b_cells (id, sample_master_id,created,created_by,modified,modified_by,deleted,deleted_date)
SELECT id,id,created,created_by,modified,modified_by,deleted,deleted_date FROM sample_masters WHERE sample_type = 'b cell';

UPDATE sample_controls SET sample_type_code = 'LB' WHERE sample_type = 'b cell';

UPDATE sample_masters parent, sample_masters lb
SET lb.sample_code = CONCAT('LB - ',lb.id),
lb.sample_label = CONCAT('LB ',parent.sample_label)
WHERE lb.sample_type = 'b cell'
AND lb.parent_id = parent.id;

UPDATE aliquot_masters al, sample_masters sm
SET al.aliquot_label = REPLACE(al.aliquot_label, 'LB-PBMC', 'LB')
WHERE sm.id = al.sample_master_id
AND sm.sample_type = 'b cell';

UPDATE aliquot_masters al, sample_masters sm
SET al.aliquot_label = REPLACE(al.aliquot_label, 'PBMC', 'LB')
WHERE sm.id = al.sample_master_id
AND sm.sample_type = 'b cell';

UPDATE consent_masters SET consent_status = 'pending' WHERE consent_status = 'sent';
UPDATE i18n SET fr = 'Memo' WHERE id = 'memo';
UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_search = '0'
WHERE str.alias IN ('miscidentifiers_for_participant_search', 'participants') 
AND sfi.field IN ('is_anonymous')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES
('', 'Clinicalannotation', 'Participant', 'participants', 'is_anonymous', 'is anonymous', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '', 'open', 'open', 'open');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='is_anonymous' AND `type`='select'), '4', '1', 'anonymous data', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0');

-- sd_spe_ascites

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_search = '0', sfo.flag_index  = '0'
WHERE str.alias IN ('sd_spe_ascites') 
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_search = '1', sfo.flag_index  = '1'
WHERE str.alias IN ('sd_spe_ascites') 
AND sfi.field IN ('sample_code','sample_label',
'supplier_dept','reception_by','reception_datetime',
'type_code', 'sequence_number')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

-- sd_undetailed_derivatives

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_search = '0', sfo.flag_index  = '0'
WHERE str.alias IN ('sd_undetailed_derivatives') 
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_search = '1', sfo.flag_index  = '1'
WHERE str.alias IN ('sd_undetailed_derivatives') 
AND sfi.field IN ('initial_specimen_sample_type', 'sample_label', 'sample_code',
'creation_datetime', 'creation_by', 'creation_site')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

-- ad_ascite_cell_tubes

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_search = '0', sfo.flag_index  = '0'
WHERE str.alias IN ('ad_ascite_cell_tubes') 
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_search = '1'
WHERE str.alias IN ('ad_ascite_cell_tubes') 
AND sfi.field IN ('aliquot_label', 'barcode', 'in_stock', 'in_stock_detail',
'selection_label', 'code', 'storage_datetime', 'temperature', 'temp_unit','study_summary_id', 
'tmp_storage_method', 'tmp_storage_solution')
AND sfi.model NOT IN ('GeneratedParentSample')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_index  = '1'
WHERE str.alias IN ('ad_ascite_cell_tubes') 
AND (sfi.field IN ('initial_specimen_sample_type', 'sample_type', 'aliquot_label', 'barcode', 'in_stock', 'in_stock_detail',
'selection_label', 'storage_coord_x', 'storage_coord_y', 'storage_datetime', 'temperature', 'temp_unit','study_summary_id', 
'tmp_storage_method', 'tmp_storage_solution', 'current_volume') 
OR (sfi.field IN ('aliquot_volume_unit') AND sfo.display_order = '72'))
AND sfi.model NOT IN ('GeneratedParentSample')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

-- ad_der_tubes_incl_ml_vol

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_search = '0', sfo.flag_index  = '0'
WHERE str.alias IN ('ad_der_tubes_incl_ml_vol') 
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_search = '1'
WHERE str.alias IN ('ad_der_tubes_incl_ml_vol') 
AND sfi.field IN ('aliquot_label', 'barcode', 'in_stock', 'in_stock_detail',
'selection_label', 'code', 'storage_datetime', 'temperature', 'temp_unit','study_summary_id')
AND sfi.model NOT IN ('GeneratedParentSample')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_index  = '1'
WHERE str.alias IN ('ad_der_tubes_incl_ml_vol') 
AND (sfi.field IN ('initial_specimen_sample_type', 'sample_type', 'aliquot_label', 'barcode', 'in_stock', 'in_stock_detail',
'selection_label', 'storage_coord_x', 'storage_coord_y', 'storage_datetime', 'temperature', 'temp_unit','study_summary_id',
'current_volume')
OR (sfi.field IN ('aliquot_volume_unit') AND sfo.display_order = '72'))
AND sfi.model NOT IN ('GeneratedParentSample')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

-- sd_der_cell_cultures

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_search = '0', sfo.flag_index  = '0'
WHERE str.alias IN ('sd_der_cell_cultures') 
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_search = '1', sfo.flag_index  = '1'
WHERE str.alias IN ('sd_der_cell_cultures') 
AND sfi.field IN ('initial_specimen_sample_type', 'sample_label', 'sample_code',
'creation_datetime', 'creation_by', 'creation_site',
'culture_status', 'culture_status_reason', 'cell_passage_number', 'tmp_collection_method', 'tmp_hormon', 'tmp_solution', 'tmp_percentage_of_oxygen', 'tmp_percentage_of_serum')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

-- ad_der_cell_slides

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_search = '0', sfo.flag_index  = '0'
WHERE str.alias IN ('ad_der_cell_slides') 
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_search = '1'
WHERE str.alias IN ('ad_der_cell_slides') 
AND sfi.field IN ('aliquot_label', 'barcode', 'in_stock', 'in_stock_detail',
'selection_label', 'code', 'storage_datetime', 'temperature', 'temp_unit','study_summary_id', 
'immunochemistry')
AND sfi.model NOT IN ('GeneratedParentSample')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_index  = '1'
WHERE str.alias IN ('ad_der_cell_slides') 
AND sfi.field IN ('initial_specimen_sample_type', 'sample_type', 'aliquot_label', 'barcode', 'in_stock', 'in_stock_detail',
'selection_label', 'storage_coord_x', 'storage_coord_y', 'storage_datetime', 'temperature', 'temp_unit','study_summary_id',
'immunochemistry')
AND sfi.model NOT IN ('GeneratedParentSample')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

-- ad_cell_culture_tubes

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_search = '0', sfo.flag_index  = '0'
WHERE str.alias IN ('ad_cell_culture_tubes') 
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_search = '1'
WHERE str.alias IN ('ad_cell_culture_tubes') 
AND sfi.field IN ('aliquot_label', 'barcode', 'in_stock', 'in_stock_detail',
'selection_label', 'code', 'storage_datetime', 'temperature', 'temp_unit','study_summary_id', 
'cell_passage_number', 'tmp_storage_solution')
AND sfi.model NOT IN ('GeneratedParentSample')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_index  = '1'
WHERE str.alias IN ('ad_cell_culture_tubes') 
AND (sfi.field IN ('initial_specimen_sample_type', 'sample_type', 'aliquot_label', 'barcode', 'in_stock', 'in_stock_detail',
'selection_label', 'storage_coord_x', 'storage_coord_y', 'storage_datetime', 'temperature', 'temp_unit','study_summary_id',
'cell_passage_number', 'tmp_storage_solution', 'current_volume')
OR (sfi.field IN ('aliquot_volume_unit') AND sfo.display_order = '72'))
AND sfi.model NOT IN ('GeneratedParentSample')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

DELETE FROM i18n WHERE id = 'cell passage number';
INSERT INTO i18n (id,en,fr) VALUES ('cell passage number', 'Cell Passage Number', 'Nbr de passages cellulaire');

-- sd_der_dnas
-- sd_der_rnas

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_search = '0', sfo.flag_index  = '0'
WHERE str.alias IN ('sd_der_dnas', 'sd_der_rnas') 
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_search = '1', sfo.flag_index  = '1'
WHERE str.alias IN ('sd_der_dnas', 'sd_der_rnas') 
AND sfi.field IN ('initial_specimen_sample_type', 'sample_label', 'sample_code',
'creation_datetime', 'creation_by', 'creation_site',
'source_cell_passage_number', 'tmp_source_milieu', 'tmp_source_storage_method', 'tmp_extraction_method')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

-- sd_der_amplified_rnas

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_search = '0', sfo.flag_index  = '0'
WHERE str.alias IN ('sd_der_amplified_rnas') 
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_search = '1', sfo.flag_index  = '1'
WHERE str.alias IN ('sd_der_amplified_rnas') 
AND sfi.field IN ('initial_specimen_sample_type', 'sample_label', 'sample_code',
'creation_datetime', 'creation_by', 'creation_site',
'tmp_amplification_method', 'tmp_amplification_number')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

-- ad_der_tubes_incl_ul_vol_and_conc

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_search = '0', sfo.flag_index  = '0'
WHERE str.alias IN ('ad_der_tubes_incl_ul_vol_and_conc') 
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_search = '1'
WHERE str.alias IN ('ad_der_tubes_incl_ul_vol_and_conc') 
AND sfi.field IN ('aliquot_label', 'barcode', 'in_stock', 'in_stock_detail',
'selection_label', 'code', 'storage_datetime', 'temperature', 'temp_unit','study_summary_id', 
'concentration', 'concentration_unit', 'tmp_storage_solution')
AND sfi.model NOT IN ('GeneratedParentSample')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_index  = '1'
WHERE str.alias IN ('ad_der_tubes_incl_ul_vol_and_conc') 
AND (sfi.field IN ('initial_specimen_sample_type', 'sample_type', 'aliquot_label', 'barcode', 'in_stock', 'in_stock_detail',
'selection_label', 'storage_coord_x', 'storage_coord_y', 'storage_datetime', 'temperature', 'temp_unit','study_summary_id',
'concentration', 'concentration_unit', 'tmp_storage_solution', 'current_volume')
OR (sfi.field IN ('aliquot_volume_unit') AND sfo.display_order = '72'))
AND sfi.model NOT IN ('GeneratedParentSample')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

-- sd_spe_bloods

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_search = '0', sfo.flag_index  = '0'
WHERE str.alias IN ('sd_spe_bloods') 
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_search = '1', sfo.flag_index  = '1'
WHERE str.alias IN ('sd_spe_bloods') 
AND sfi.field IN ('sample_code','sample_label',
'supplier_dept','reception_by','reception_datetime',
'type_code', 'sequence_number', 'blood_type')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

-- sd_spe_cystic_fluids, sd_spe_other_fluids, sd_spe_pericardial_fluids, sd_spe_peritoneal_washes, sd_spe_pleural_fluids

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_search = '0', sfo.flag_index  = '0'
WHERE str.alias IN ('sd_spe_cystic_fluids', 'sd_spe_other_fluids', 'sd_spe_pericardial_fluids', 'sd_spe_peritoneal_washes', 'sd_spe_pleural_fluids') 
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_search = '1', sfo.flag_index  = '1'
WHERE str.alias IN ('sd_spe_cystic_fluids', 'sd_spe_other_fluids', 'sd_spe_pericardial_fluids', 'sd_spe_peritoneal_washes', 'sd_spe_pleural_fluids') 
AND sfi.field IN ('sample_code','sample_label',
'supplier_dept','reception_by','reception_datetime',
'type_code', 'sequence_number')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

-- sd_spe_tissues

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_search = '0', sfo.flag_index  = '0'
WHERE str.alias IN ('sd_spe_tissues') 
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_search = '1', sfo.flag_index  = '1'
WHERE str.alias IN ('sd_spe_tissues') 
AND sfi.field IN ('sample_code','sample_label',
'supplier_dept','reception_by','reception_datetime',
'type_code', 'sequence_number',
'tissue_source', 'tissue_nature', 'tissue_laterality')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

-- sd_spe_urines

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_search = '0', sfo.flag_index  = '0'
WHERE str.alias IN ('sd_spe_urines') 
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_search = '1', sfo.flag_index  = '1'
WHERE str.alias IN ('sd_spe_urines') 
AND sfi.field IN ('sample_code','sample_label',
'supplier_dept','reception_by','reception_datetime',
'type_code', 'sequence_number',
'urine_aspect', 'pellet_signs')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

-- sd_der_blood_cells

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_search = '0', sfo.flag_index  = '0'
WHERE str.alias IN ('sd_der_blood_cells') 
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_search = '1', sfo.flag_index  = '1'
WHERE str.alias IN ('sd_der_blood_cells') 
AND sfi.field IN ('initial_specimen_sample_type', 'sample_label', 'sample_code',
'creation_datetime', 'creation_by', 'creation_site',
'tmp_solution')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

-- sd_der_pbmcs

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_search = '0', sfo.flag_index  = '0'
WHERE str.alias IN ('sd_der_pbmcs') 
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_search = '1', sfo.flag_index  = '1'
WHERE str.alias IN ('sd_der_pbmcs') 
AND sfi.field IN ('initial_specimen_sample_type', 'sample_label', 'sample_code',
'creation_datetime', 'creation_by', 'creation_site',
'tmp_solution')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

-- sd_der_plasmas

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_search = '0', sfo.flag_index  = '0'
WHERE str.alias IN ('sd_der_plasmas') 
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_search = '1', sfo.flag_index  = '1'
WHERE str.alias IN ('sd_der_plasmas') 
AND sfi.field IN ('initial_specimen_sample_type', 'sample_label', 'sample_code',
'creation_datetime', 'creation_by', 'creation_site',
'hemolysis_signs')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

-- sd_der_serums

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_search = '0', sfo.flag_index  = '0'
WHERE str.alias IN ('sd_der_serums') 
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_search = '1', sfo.flag_index  = '1'
WHERE str.alias IN ('sd_der_serums') 
AND sfi.field IN ('initial_specimen_sample_type', 'sample_label', 'sample_code',
'creation_datetime', 'creation_by', 'creation_site',
'hemolysis_signs')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

-- ad_spec_tiss_blocks
 
UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_search = '0', sfo.flag_index  = '0'
WHERE str.alias IN ('ad_spec_tiss_blocks') 
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_search = '1'
WHERE str.alias IN ('ad_spec_tiss_blocks') 
AND sfi.field IN ('aliquot_label', 'barcode', 'in_stock', 'in_stock_detail',
'selection_label', 'code', 'storage_datetime', 'temperature', 'temp_unit','study_summary_id', 
'block_type', 'patho_dpt_block_code', 'sample_position_code', 'path_report_code', 'tmp_gleason_primary_grade', 'tmp_gleason_secondary_grade', 'tmp_tissue_primary_desc', 'tmp_tissue_secondary_desc')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_index  = '1'
WHERE str.alias IN ('ad_spec_tiss_blocks') 
AND sfi.field IN ('sample_type', 'aliquot_label', 'barcode', 'in_stock', 'in_stock_detail',
'selection_label', 'storage_coord_x', 'storage_coord_y', 'storage_datetime', 'temperature', 'temp_unit','study_summary_id',
'block_type', 'patho_dpt_block_code', 'sample_position_code', 'path_report_code', 'tmp_gleason_primary_grade', 'tmp_gleason_secondary_grade', 'tmp_tissue_primary_desc', 'tmp_tissue_secondary_desc')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

-- ad_spec_tiss_cores

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_search = '0', sfo.flag_index  = '0'
WHERE str.alias IN ('ad_spec_tiss_cores') 
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_search = '1'
WHERE str.alias IN ('ad_spec_tiss_cores') 
AND sfi.field IN ('aliquot_label', 'barcode', 'in_stock', 'in_stock_detail',
'selection_label', 'code', 'storage_datetime', 'temperature', 'temp_unit','study_summary_id')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_index  = '1'
WHERE str.alias IN ('ad_spec_tiss_cores') 
AND sfi.field IN ('sample_type', 'aliquot_label', 'barcode', 'in_stock', 'in_stock_detail',
'selection_label', 'storage_coord_x', 'storage_coord_y', 'storage_datetime', 'temperature', 'temp_unit','study_summary_id')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

-- ad_spec_tiss_slides

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_search = '0', sfo.flag_index  = '0'
WHERE str.alias IN ('ad_spec_tiss_slides') 
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_search = '1'
WHERE str.alias IN ('ad_spec_tiss_slides') 
AND sfi.field IN ('aliquot_label', 'barcode', 'in_stock', 'in_stock_detail',
'selection_label', 'code', 'storage_datetime', 'temperature', 'temp_unit','study_summary_id', 
'immunochemistry')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_index  = '1'
WHERE str.alias IN ('ad_spec_tiss_slides') 
AND sfi.field IN ('sample_type', 'aliquot_label', 'barcode', 'in_stock', 'in_stock_detail',
'selection_label', 'storage_coord_x', 'storage_coord_y', 'storage_datetime', 'temperature', 'temp_unit','study_summary_id',
'immunochemistry')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

-- ad_spec_tubes_incl_ml_vol

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_search = '0', sfo.flag_index  = '0'
WHERE str.alias IN ('ad_spec_tubes_incl_ml_vol') 
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_search = '1'
WHERE str.alias IN ('ad_spec_tubes_incl_ml_vol') 
AND sfi.field IN ('aliquot_label', 'barcode', 'in_stock', 'in_stock_detail',
'selection_label', 'code', 'storage_datetime', 'temperature', 'temp_unit','study_summary_id')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_index  = '1'
WHERE str.alias IN ('ad_spec_tubes_incl_ml_vol') 
AND (sfi.field IN ('sample_type', 'aliquot_label', 'barcode', 'in_stock', 'in_stock_detail',
'selection_label', 'storage_coord_x', 'storage_coord_y', 'storage_datetime', 'temperature', 'temp_unit','study_summary_id',
'current_volume')
OR (sfi.field IN ('aliquot_volume_unit') AND sfo.display_order = '72'))
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

-- ad_spec_whatman_papers

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_search = '0', sfo.flag_index  = '0'
WHERE str.alias IN ('ad_spec_whatman_papers') 
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_search = '1'
WHERE str.alias IN ('ad_spec_whatman_papers') 
AND sfi.field IN ('aliquot_label', 'barcode', 'in_stock', 'in_stock_detail',
'selection_label', 'code', 'storage_datetime', 'temperature', 'temp_unit','study_summary_id')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_index  = '1'
WHERE str.alias IN ('ad_spec_whatman_papers') 
AND sfi.field IN ('sample_type', 'aliquot_label', 'barcode', 'in_stock', 'in_stock_detail',
'selection_label', 'storage_coord_x', 'storage_coord_y', 'storage_datetime', 'temperature', 'temp_unit','study_summary_id')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;
	
-- ad_der_cell_tubes_incl_ml_vol

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_search = '0', sfo.flag_index  = '0'
WHERE str.alias IN ('ad_der_cell_tubes_incl_ml_vol') 
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_search = '1'
WHERE str.alias IN ('ad_der_cell_tubes_incl_ml_vol') 
AND sfi.field IN ('aliquot_label', 'barcode', 'in_stock', 'in_stock_detail',
'selection_label', 'code', 'storage_datetime', 'temperature', 'temp_unit','study_summary_id', 
'concentration', 'concentration_unit', 'cell_count', 'cell_count_unit')
AND sfi.model NOT IN ('GeneratedParentSample')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_index  = '1'
WHERE str.alias IN ('ad_der_cell_tubes_incl_ml_vol') 
AND (sfi.field IN ('initial_specimen_sample_type', 'sample_type', 'aliquot_label', 'barcode', 'in_stock', 'in_stock_detail',
'selection_label', 'storage_coord_x', 'storage_coord_y', 'storage_datetime', 'temperature', 'temp_unit','study_summary_id',
'concentration', 'concentration_unit', 'cell_count', 'cell_count_unit')
OR (sfi.field IN ('aliquot_volume_unit') AND sfo.display_order = '72'))
AND sfi.model NOT IN ('GeneratedParentSample')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;
	
-- ad_spec_tissue_tubes

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_search = '0', sfo.flag_index  = '0'
WHERE str.alias IN ('ad_spec_tissue_tubes') 
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_search = '1'
WHERE str.alias IN ('ad_spec_tissue_tubes') 
AND sfi.field IN ('aliquot_label', 'barcode', 'in_stock', 'in_stock_detail',
'selection_label', 'code', 'storage_datetime', 'temperature', 'temp_unit','study_summary_id', 
'tmp_storage_method', 'tmp_storage_solution')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_index  = '1'
WHERE str.alias IN ('ad_spec_tissue_tubes') 
AND sfi.field IN ('sample_type', 'aliquot_label', 'barcode', 'in_stock', 'in_stock_detail',
'selection_label', 'storage_coord_x', 'storage_coord_y', 'storage_datetime', 'temperature', 'temp_unit','study_summary_id',
'tmp_storage_method', 'tmp_storage_solution')
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;

-- DB validation

ALTER TABLE ad_tubes_revs
  ADD `cell_passage_number` varchar(10) DEFAULT NULL AFTER `cell_count_unit`,
  ADD `tmp_storage_solution` varchar(30) DEFAULT NULL AFTER `cell_passage_number`,
  ADD `tmp_storage_method` varchar(30) DEFAULT NULL AFTER `tmp_storage_solution`;
    
ALTER TABLE banks_revs
  ADD  `misc_identifier_control_id` int(11) DEFAULT NULL AFTER `description`;  

ALTER TABLE `ed_all_procure_lifestyles`
  ADD `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0' AFTER `event_master_id`,
  ADD `deleted_date` datetime DEFAULT NULL AFTER `deleted`;

ALTER TABLE ed_all_procure_lifestyles
  MODIFY `event_master_id` int(11) DEFAULT NULL;
  
DELETE FROM aliquot_uses WHERE use_definition IS NULL;
UPDATE aliquot_masters SET notes = '' WHERE `notes` LIKE '%utilisation actuellement.%Peut pas le supprimer%';

DELETE FROM i18n WHERE id = 'kidney';
INSERT INTO i18n (id,en,fr) VALUES ('kidney', 'Kidney', 'Rein');

UPDATE users set flag_active = '1';

DELETE from aros_acos WHERE aco_id NOT IN (SELECT id FROM acos WHERE alias = 'controllers');