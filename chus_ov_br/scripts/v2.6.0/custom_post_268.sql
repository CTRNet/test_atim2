
UPDATE parent_to_derivative_sample_controls SET flag_active=false WHERE id IN(193, 200, 203, 188);

ALTER TABLE chus_ed_clinical_ctscans_revs DROP INDEX event_master_id;
ALTER TABLE chus_ed_clinical_followups_revs DROP INDEX event_master_id;
ALTER TABLE chus_ed_lab_breast_ca153_tests_revs DROP INDEX event_master_id;
ALTER TABLE chus_ed_lab_breast_immunos_revs DROP INDEX event_master_id;
ALTER TABLE chus_ed_lab_ovary_ca125_tests_revs DROP INDEX event_master_id;
ALTER TABLE chus_ed_lab_ovary_immunos_revs DROP INDEX event_master_id;
ALTER TABLE chus_ed_past_histories_revs DROP INDEX event_master_id;

UPDATE groups SET name = 'System' WHERE id = 2;
UPDATE users SET username = 'system', password = 'b107855e5f2e997dfe016223f54eae9eefd5690b', first_name = 'System' WHERE id = 2;

ALTER TABLE dxd_primaries ADD COLUMN chus_tumor_sites varchar(50) DEFAULT NULL;
ALTER TABLE dxd_primaries_revs ADD COLUMN chus_tumor_sites varchar(50) DEFAULT NULL;
INSERT INTO structure_value_domains (domain_name, source) 
VALUES 
('chus_other_primary_diagnosis_tumor_sites', "StructurePermissibleValuesCustom::getCustomDropdown('Other Primary Diagnosis Tumor Sites')");
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) 
VALUES 
('Other Primary Diagnosis Tumor Sites', 1, 50, 'clinical - diagnosis');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Other Primary Diagnosis Tumor Sites');
INSERT INTO `structure_permissible_values_customs` (`value`, en,fr,`use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
(SELECT controls_type,en,fr, '1', @control_id, '2', NOW(),'2', NOW() 
FROM diagnosis_controls 
LEFT JOIN i18n ON i18n.id = controls_type
WHERE flag_active = 1
AND category = 'primary'
AND controls_type NOT IN ('primary diagnosis unknown', 'ovary', 'breast'));
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'DiagnosisDetail', 'dxd_primaries', 'chus_tumor_sites', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='chus_other_primary_diagnosis_tumor_sites') , '0', '', '', '', 'tumor site', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='chus_dx_undetailled_primary'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_primaries' AND `field`='chus_tumor_sites' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='chus_other_primary_diagnosis_tumor_sites')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tumor site' AND `language_tag`=''), '1', '10', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0');
UPDATE structure_formats SET `display_order`='8' WHERE structure_id=(SELECT id FROM structures WHERE alias='chus_dx_undetailled_primary') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_primaries' AND `field`='chus_tumor_sites' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='chus_other_primary_diagnosis_tumor_sites') AND `flag_confidential`='0');
INSERT INTO structure_validations(structure_field_id, rule, language_message) VALUES
((SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_primaries' AND `field`='chus_tumor_sites'), 'notEmpty', '');
DELETE FROM diagnosis_controls 
WHERE flag_active = 1
AND category = 'primary'
AND controls_type NOT IN ('primary diagnosis unknown', 'undetailed', 'ovary', 'breast');
UPDATE diagnosis_controls SET controls_type = 'other' WHERE flag_active = 1 AND category = 'primary' AND controls_type = 'undetailed';

ALTER TABLE dxd_secondaries ADD COLUMN chus_tumor_sites varchar(50) DEFAULT NULL;
ALTER TABLE dxd_secondaries_revs ADD COLUMN chus_tumor_sites varchar(50) DEFAULT NULL;
INSERT INTO structure_value_domains (domain_name, source) 
VALUES 
('chus_other_secondary_diagnosis_tumor_sites', "StructurePermissibleValuesCustom::getCustomDropdown('Other Secondary Diagnosis Tumor Sites')");
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) 
VALUES 
('Other Secondary Diagnosis Tumor Sites', 1, 50, 'clinical - diagnosis');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Other Secondary Diagnosis Tumor Sites');
INSERT INTO `structure_permissible_values_customs` (`value`, en,fr,`use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
(SELECT controls_type,en,fr, '1', @control_id, '2', NOW(),'2', NOW() 
FROM diagnosis_controls 
LEFT JOIN i18n ON i18n.id = controls_type
WHERE flag_active = 1
AND category = 'secondary - distant'
AND controls_type NOT IN ('ovary', 'breast'));
UPDATE diagnosis_controls SET controls_type = 'other', detail_form_alias = 'dx_secondary,chus_dx_undetailled_secondary' 
WHERE flag_active = 1
AND category = 'secondary - distant'
AND controls_type = 'peritoneum';
DELETE FROM diagnosis_controls 
WHERE flag_active = 1
AND category = 'secondary - distant'
AND controls_type NOT IN ('other', 'ovary', 'breast');
UPDATE diagnosis_controls SET databrowser_label = CONCAT(category, '|', controls_type);
INSERT INTO structures(`alias`) VALUES ('chus_dx_undetailled_secondary');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'DiagnosisDetail', 'dxd_secondaries', 'chus_tumor_sites', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='chus_other_secondary_diagnosis_tumor_sites') , '0', '', '', '', 'tumor site', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='chus_dx_undetailled_secondary'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_secondaries' AND `field`='chus_tumor_sites' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='chus_other_secondary_diagnosis_tumor_sites')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tumor site' AND `language_tag`=''), '1', '8', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0');
INSERT INTO structure_validations(structure_field_id, rule, language_message) VALUES
((SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_secondaries' AND `field`='chus_tumor_sites'), 'notEmpty', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='view_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_primaries' AND `field`='chus_tumor_sites' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='chus_other_primary_diagnosis_tumor_sites')), '1', '2', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='view_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_secondaries' AND `field`='chus_tumor_sites' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='chus_other_secondary_diagnosis_tumor_sites')), '1', '2', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');

ALTER TABLE dxd_primaries CHANGE chus_tumor_sites chus_primary_tumor_sites varchar(50) DEFAULT NULL;
ALTER TABLE dxd_primaries_revs CHANGE chus_tumor_sites chus_primary_tumor_sites varchar(50) DEFAULT NULL;
UPDATE structure_fields SET field = 'chus_primary_tumor_sites' WHERE `tablename`='dxd_primaries' AND `field`='chus_tumor_sites';
ALTER TABLE dxd_secondaries CHANGE chus_tumor_sites chus_secondary_tumor_sites varchar(50) DEFAULT NULL;
ALTER TABLE dxd_secondaries_revs CHANGE chus_tumor_sites chus_secondary_tumor_sites varchar(50) DEFAULT NULL;
UPDATE structure_fields SET field = 'chus_secondary_tumor_sites' WHERE `tablename`='dxd_secondaries' AND `field`='chus_tumor_sites';
UPDATE structure_formats 
SET `display_order`='3' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='view_diagnosis') 
AND structure_field_id IN (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `field` LIKE 'chus_%_tumor_sites');
UPDATE structure_formats 
SET `display_order`='3', flag_override_label = '1', language_label = ''
WHERE structure_id=(SELECT id FROM structures WHERE alias='view_diagnosis') 
AND structure_field_id IN (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `field` LIKE 'chus_%_tumor_sites');

UPDATE structure_formats SET `display_column`='2' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_primary') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='icd10_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

ALTER TABLE `ed_all_lifestyle_smokings` ADD COLUMN `chus_years_quit_smoking` float unsigned DEFAULT NULL;
ALTER TABLE `ed_all_lifestyle_smokings_revs` ADD COLUMN `chus_years_quit_smoking` float unsigned DEFAULT NULL;
UPDATE structure_fields SET field = 'chus_years_quit_smoking' WHERE field = 'years_quit_smoking' AND tablename = 'ed_all_lifestyle_smokings';


















Pour le sein :
Colonne I : BRCFT Frais peut être supprimé, il y en a peu et je les ajouterai à la main.
Colonne AA : Une nouvelle classification de l'OMS pour les carcinome canalaire infiltrant. Devra être édité dans le script existant.
Colonne BT : Ki67 : Nouveau marqueur d'IHC (comme ER, PR, HER2, svp ajouter au script).

Pour le même fichier des cas d'ovaire :
Les colonnes AV et CB ont été ajouté depuis la création du script (de mémoire). 

La colonne CS (Ganglion) peut comporter une fraction de ganglions métastatiques sur le nombre total prélevé.
Si c'est problématique je les éditerai à la main.

Colonne DZ : Je n'ai pas le souvenir si cette colonne a été ajouté avant ou après le script que tu as créé. 
La colonne ED : je peux ajouter ces infos à la main par la suite si le nouveau Atim a une section pour inscrire la réponse à la chimio pré op.

Voilà si tu as des questions n'hésite pas.












Databrowser Relations Links Summary

Model 1	Model 2	Used Field	Status
ViewAliquot	ViewCollection	collection_id	active
ViewAliquot	NonTmaBlockStorage	storage_master_id	active
ViewAliquot	ViewSample	sample_master_id	active
ViewAliquot	TmaBlock	storage_master_id	active
ViewAliquot	StudySummary	study_summary_id	active
ViewCollection	Participant	participant_id	active
ViewCollection	ConsentMaster	consent_master_id	active
ViewCollection	DiagnosisMaster	diagnosis_master_id	active
ViewCollection	TreatmentMaster	treatment_master_id	active
ViewCollection	EventMaster	event_master_id	active
ViewSample	ViewCollection	collection_id	active
ViewSample	ViewSample	parent_id	active
MiscIdentifier	Participant	participant_id	active
ViewAliquotUse	ViewAliquot	aliquot_master_id	active
ViewAliquotUse	StudySummary	study_summary_id	active
ConsentMaster	Participant	participant_id	active
DiagnosisMaster	Participant	participant_id	active
DiagnosisMaster	DiagnosisMaster	parent_id	active
TreatmentMaster	Participant	participant_id	active
TreatmentMaster	DiagnosisMaster	diagnosis_master_id	active
FamilyHistory	Participant	participant_id	active
ParticipantMessage	Participant	participant_id	active
QualityCtrl	ViewAliquot	aliquot_master_id	active
EventMaster	Participant	participant_id	active
EventMaster	DiagnosisMaster	diagnosis_master_id	active
OrderItem	ViewAliquot	aliquot_master_id	active
OrderItem	Shipment	shipment_id	active
OrderItem	Order	order_id	active
Shipment	Order	order_id	active
ParticipantContact	Participant	participant_id	active
ReproductiveHistory	Participant	participant_id	active
TreatmentExtendMaster	TreatmentMaster	treatment_master_id	active
AliquotReviewMaster	ViewAliquot	aliquot_master_id	active
AliquotReviewMaster	SpecimenReviewMaster	specimen_review_master_id	active
Order	StudySummary	default_study_summary_id	active
TmaSlide	NonTmaBlockStorage	storage_master_id	active
TmaSlide	TmaBlock	tma_block_storage_master_id	active
TmaSlide	StudySummary	study_summary_id	active
TmaBlock	NonTmaBlockStorage	parent_id	active
MiscIdentifier	StudySummary	study_summary_id	disable
ConsentMaster	StudySummary	study_summary_id	disable
QualityCtrl	ViewSample	sample_master_id	disable
SpecimenReviewMaster	ViewSample	sample_master_id	disable
OrderItem	TmaSlide	tma_slide_id	disable
OrderItem	OrderLine	order_line_id	disable
OrderLine	Order	order_id	disable
OrderLine	StudySummary	study_summary_id	disable
TmaSlideUse	TmaSlide	tma_slide_id	disable
TmaSlideUse	StudySummary	study_summary_id	disable
Reports

Report	Status
All Derivatives Display	active
Bank Activity Report	active
Bank Activity Report (Per Period)	active
CTRNet catalogue	active
Initial Specimens Display	active
List all child storage entities	active
List all related diagnosis	active
Number of elements per participant	active
Participant Identifiers	active
Specimens Collection/Derivatives Creation	active
Structure Functions Summary

Model	Function	Used Field	Status
ViewAliquot	define realiquoted children	active
ViewAliquot	realiquot	active
ViewAliquot	add to order	active
ViewAliquot	create derivative	active
ViewAliquot	create uses/events (aliquot specific)	active
ViewAliquot	edit	active
ViewAliquot	print barcodes	active
ViewAliquot	create use/event (applied to all)	active
ViewAliquot	number of elements per participant (Report 'Number of elements per participant')	active
ViewCollection	print barcodes	active
ViewCollection	number of elements per participant (Report 'Number of elements per participant')	active
NonTmaBlockStorage	list all children storages (Report 'List all child storage entities')	active
Participant	participant identifiers report (Report 'Participant Identifiers')	active
Participant	list all related diagnosis (Report 'List all related diagnosis')	active
ViewSample	create derivative	active
ViewSample	create aliquots	active
ViewSample	print barcodes	active
ViewSample	initial specimens display (Report 'Initial Specimens Display')	active
ViewSample	all derivatives display (Report 'All Derivatives Display')	active
ViewSample	number of elements per participant (Report 'Number of elements per participant')	active
MiscIdentifier	number of elements per participant (Report 'Number of elements per participant')	active
ViewAliquotUse	number of elements per participant (Report 'Number of elements per participant')	active
ConsentMaster	number of elements per participant (Report 'Number of elements per participant')	active
DiagnosisMaster	list all related diagnosis (Report 'List all related diagnosis')	active
DiagnosisMaster	number of elements per participant (Report 'Number of elements per participant')	active
TreatmentMaster	number of elements per participant (Report 'Number of elements per participant')	active
FamilyHistory	number of elements per participant (Report 'Number of elements per participant')	active
ParticipantMessage	number of elements per participant (Report 'Number of elements per participant')	active
QualityCtrl	number of elements per participant (Report 'Number of elements per participant')	active
EventMaster	number of elements per participant (Report 'Number of elements per participant')	active
SpecimenReviewMaster	number of elements per participant (Report 'Number of elements per participant')	active
OrderItem	defined as returned	active
OrderItem	edit	active
ParticipantContact	number of elements per participant (Report 'Number of elements per participant')	active
ReproductiveHistory	number of elements per participant (Report 'Number of elements per participant')	active
TreatmentExtendMaster	number of elements per participant (Report 'Number of elements per participant')	active
AliquotReviewMaster	number of elements per participant (Report 'Number of elements per participant')	active
TmaSlide	edit	active
TmaSlide	add tma slide use	active
TmaSlide	add to order	active
TmaBlock	create tma slide	active
TmaSlideUse	edit	active
ViewAliquot	create quality control	disable
Participant	edit	disable
Participant	create participant message (applied to all)	disable
ViewSample	create quality control	disable
