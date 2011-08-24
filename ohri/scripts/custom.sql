-- Run post 2.3.3.

DROP TABLE IF EXISTS view_collections;
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

col.acquisition_label AS acquisition_label,

col.collection_site AS collection_site,
col.collection_datetime AS collection_datetime,
col.collection_datetime_accuracy AS collection_datetime_accuracy,
col.collection_property AS collection_property,
col.collection_notes AS collection_notes,
col.deleted AS deleted,
banks.name AS bank_name,

idents.identifier_value AS ohri_bank_participant_id,
col.created AS created 

FROM collections col 
LEFT JOIN clinical_collection_links link on col.id = link.collection_id and link.deleted != 1
LEFT JOIN participants part on link.participant_id = part.id and part.deleted != 1
LEFT JOIN banks on col.bank_id = banks.id and banks.deleted != 1 
LEFT JOIN misc_identifiers AS idents ON idents.participant_id=link.participant_id AND idents.deleted != 1 AND idents.misc_identifier_control_id=2
WHERE col.deleted != 1;

DROP TABLE IF EXISTS view_samples;
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

col.acquisition_label, 

specimen.sample_type AS initial_specimen_sample_type,
specimen.sample_control_id AS initial_specimen_sample_control_id,
parent_samp.sample_type AS parent_sample_type,
parent_samp.sample_control_id AS parent_sample_control_id,
samp.sample_type,
samp.sample_control_id AS sample_control_id,
samp.sample_code,
samp.sample_category,
samp.deleted,

idents.identifier_value AS ohri_bank_participant_id 

FROM sample_masters as samp
INNER JOIN collections AS col ON col.id = samp.collection_id AND col.deleted != 1
LEFT JOIN sample_masters AS specimen ON samp.initial_specimen_sample_id = specimen.id AND specimen.deleted != 1
LEFT JOIN sample_masters as parent_samp ON samp.parent_id = parent_samp.id AND parent_samp.deleted != 1
LEFT JOIN clinical_collection_links AS link ON col.id = link.collection_id AND link.deleted != 1
LEFT JOIN participants AS part ON link.participant_id = part.id AND part.deleted != 1
LEFT JOIN misc_identifiers AS idents ON idents.participant_id=link.participant_id AND idents.deleted != 1 AND idents.misc_identifier_control_id=2
WHERE samp.deleted != 1;

INSERT INTO `structure_validations` (`id`, `structure_field_id`, `rule`, `on_action`, `language_message`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, (SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `field`='consent_status'), 'notEmpty', '', 'value is required', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0);

DELETE FROM structure_value_domains_permissible_values WHERE structure_value_domain_id = (SELECT id FROM structure_value_domains WHERE domain_name="ohri_tumour_site");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) 
VALUES
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="breast-breast" AND language_alias="breast-breast"), "1", "1"),

((SELECT id FROM structure_value_domains WHERE domain_name="ohri_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="central nervous system-brain" AND language_alias="central nervous system-brain"), "10", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="central nervous system-spinal cord" AND language_alias="central nervous system-spinal cord"), "11", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="central nervous system-other central nervous system" AND language_alias="central nervous system-other central nervous system"), "12", "1"),

((SELECT id FROM structure_value_domains WHERE domain_name="ohri_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="digestive-anal" AND language_alias="digestive-anal"), "21", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="digestive-appendix" AND language_alias="digestive-appendix"), "22", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="digestive-bile ducts" AND language_alias="digestive-bile ducts"), "23", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="digestive-colonic" AND language_alias="digestive-colonic"), "24", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="digestive-esophageal" AND language_alias="digestive-esophageal"), "25", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="digestive-gallbladder" AND language_alias="digestive-gallbladder"), "26", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="digestive-liver" AND language_alias="digestive-liver"), "27", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="digestive-pancreas" AND language_alias="digestive-pancreas"), "28", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="digestive-rectal" AND language_alias="digestive-rectal"), "29", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="digestive-small intestine" AND language_alias="digestive-small intestine"), "30", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="digestive-stomach" AND language_alias="digestive-stomach"), "31", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="digestive-other digestive" AND language_alias="digestive-other digestive"), "32", "1"),

((SELECT id FROM structure_value_domains WHERE domain_name="ohri_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="female genital-cervical" AND language_alias="female genital-cervical"), "40", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="female genital-endometrium" AND language_alias="female genital-endometrium"), "41", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="female genital-fallopian tube" AND language_alias="female genital-fallopian tube"), "42", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="female genital-gestational trophoblastic neoplasia" AND language_alias="female genital-gestational trophoblastic neoplasia"), "43", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="female genital-ovary" AND language_alias="female genital-ovary"), "44", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="female genital-peritoneal" AND language_alias="female genital-peritoneal"), "45", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="female genital-uterine" AND language_alias="female genital-uterine"), "46", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="female genital-vulva" AND language_alias="female genital-vulva"), "47", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="female genital-vagina" AND language_alias="female genital-vagina"), "48", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="female genital-other female genital" AND language_alias="female genital-other female genital"), "49", "1"),

((SELECT id FROM structure_value_domains WHERE domain_name="ohri_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="haematological-leukemia" AND language_alias="haematological-leukemia"), "60", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="haematological-lymphoma" AND language_alias="haematological-lymphoma"), "61", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="haematological-non-hodgkin's lymphomas" AND language_alias="haematological-non-hodgkin's lymphomas"), "62", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="haematological-hodgkin's disease" AND language_alias="haematological-hodgkin's disease"), "63", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="haematological-other haematological" AND language_alias="haematological-other haematological"), "64", "1"),

((SELECT id FROM structure_value_domains WHERE domain_name="ohri_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="head & neck-larynx" AND language_alias="head & neck-larynx"), "70", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="head & neck-lip and oral cavity" AND language_alias="head & neck-lip and oral cavity"), "71", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="head & neck-nasal cavity and sinuses" AND language_alias="head & neck-nasal cavity and sinuses"), "72", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="head & neck-pharynx" AND language_alias="head & neck-pharynx"), "73", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="head & neck-salivary glands" AND language_alias="head & neck-salivary glands"), "74", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="head & neck-thyroid" AND language_alias="head & neck-thyroid"), "75", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="head & neck-other head & neck" AND language_alias="head & neck-other head & neck"), "76", "1"),

((SELECT id FROM structure_value_domains WHERE domain_name="ohri_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="musculoskeletal sites-bone" AND language_alias="musculoskeletal sites-bone"), "80", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="musculoskeletal sites-soft tissue sarcoma" AND language_alias="musculoskeletal sites-soft tissue sarcoma"), "81", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="musculoskeletal sites-other bone" AND language_alias="musculoskeletal sites-other bone"), "82", "1"),

((SELECT id FROM structure_value_domains WHERE domain_name="ohri_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="ophthalmic-eye" AND language_alias="ophthalmic-eye"), "116", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="ophthalmic-other eye" AND language_alias="ophthalmic-other eye"), "117", "1"),

((SELECT id FROM structure_value_domains WHERE domain_name="ohri_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="skin-melanoma" AND language_alias="skin-melanoma"), "121", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="skin-non melanomas" AND language_alias="skin-non melanomas"), "122", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="skin-other skin" AND language_alias="skin-other skin"), "123", "1"),

((SELECT id FROM structure_value_domains WHERE domain_name="ohri_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="thoracic-lung" AND language_alias="thoracic-lung"), "133", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="thoracic-mesothelioma" AND language_alias="thoracic-mesothelioma"), "134", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="thoracic-other thoracic" AND language_alias="thoracic-other thoracic"), "135", "1"),

((SELECT id FROM structure_value_domains WHERE domain_name="ohri_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="urinary tract-bladder" AND language_alias="urinary tract-bladder"), "144", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="urinary tract-kidney" AND language_alias="urinary tract-kidney"), "145", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="urinary tract-renal pelvis and ureter" AND language_alias="urinary tract-renal pelvis and ureter"), "146", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="urinary tract-urethra" AND language_alias="urinary tract-urethra"), "147", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="urinary tract-other urinary tract" AND language_alias="urinary tract-other urinary tract"), "148", "1"),

((SELECT id FROM structure_value_domains WHERE domain_name="ohri_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="other-primary unknown" AND language_alias="other-primary unknown"), "255", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="other-gross metastatic disease" AND language_alias="other-gross metastatic disease"), "256", "1");

UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='ohri_dx_others') 
AND structure_field_id IN (SELECT id FROM structure_fields WHERE `field` IN ('dx_date','dx_method','survival_time_months',
'ohri_progression_free_interval_months', 'topography', 'morphology', 'laterality'));

UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='ohri_dx_ovaries') 
AND structure_field_id IN (SELECT id FROM structure_fields WHERE `field` IN ('dx_date','dx_method','survival_time_months',
'ohri_progression_free_interval_months', 'topography', 'morphology', 'laterality'));

UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='ohri_ed_clinical_followups') 
AND structure_field_id IN (SELECT id FROM structure_fields WHERE `field` IN ('disease_status','recurrence_status'));

UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='ohri_ed_lab_pathologies') 
AND structure_field_id IN (SELECT id FROM structure_fields WHERE `field` IN ('path_number','report_type'));

UPDATE realiquoting_controls SET flag_active=false WHERE id IN(13, 29);

UPDATE structure_formats 
SET `flag_add`='0',`flag_add_readonly`='0',`flag_edit`='0',`flag_edit_readonly`='0',`flag_search`='0',`flag_search_readonly`='0',`flag_addgrid`='0',`flag_addgrid_readonly`='0',`flag_editgrid`='0',`flag_editgrid_readonly`='0',`flag_summary`='0',`flag_batchedit`='0',`flag_batchedit_readonly`='0',`flag_index`='0',`flag_detail` = '0'
WHERE structure_field_id IN (SELECT id from structure_fields WHERE field = 'sop_master_id');

UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='specimens') 
AND structure_field_id IN (SELECT id FROM structure_fields WHERE `field` IN ('supplier_dept','reception_by'));

UPDATE structure_formats 
SET `flag_add`='0',`flag_add_readonly`='0',`flag_edit`='0',`flag_edit_readonly`='0',`flag_search`='0',`flag_search_readonly`='0',`flag_addgrid`='0',`flag_addgrid_readonly`='0',`flag_editgrid`='0',`flag_editgrid_readonly`='0',`flag_summary`='0',`flag_batchedit`='0',`flag_batchedit_readonly`='0',`flag_index`='0',`flag_detail` = '0'
WHERE structure_field_id IN (SELECT id from structure_fields WHERE field = 'aliquot_label');

UPDATE structure_fields sf, structure_validations sv
SET sv.language_message = 'label is required'
WHERE sf.id = sv.structure_field_id
AND sv.language_message = 'barcode is required'
AND sf.field = 'barcode' and sf.model = 'AliquotMaster';

UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') 
AND structure_field_id IN (SELECT id FROM structure_fields WHERE `field` IN ('in_stock_detail','storage_datetime','temperature','temp_unit'));

UPDATE structure_formats SET `flag_search`='0'
WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE `field` IN ('current_volume'));

UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_spec_tubes_incl_ml_vol') 
AND structure_field_id IN (SELECT id FROM structure_fields WHERE `field` IN ('study_summary_id'));

UPDATE realiquoting_controls SET flag_active=false WHERE id IN(30, 28, 31);

UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='derivatives') 
AND structure_field_id IN (SELECT id FROM structure_fields WHERE `field` IN ('creation_site','creation_by'));

UPDATE structure_formats SET `display_order`='501'
WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_der_cell_cultures') 
AND structure_field_id IN (SELECT id FROM structure_fields WHERE `field` IN ('culture_status'));
UPDATE structure_formats SET `display_order`='502'
WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_der_cell_cultures') 
AND structure_field_id IN (SELECT id FROM structure_fields WHERE `field` IN ('culture_status_reason'));
UPDATE structure_formats SET `display_order`='503'
WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_der_cell_cultures') 
AND structure_field_id IN (SELECT id FROM structure_fields WHERE `field` IN ('cell_passage_number'));

UPDATE structure_formats SET `display_order`='200'
WHERE structure_id IN (SELECT id FROM structures WHERE alias IN ('ad_spec_tubes_incl_ml_vol','ad_spec_tiss_blocks', 'ad_spec_tiss_slides', 'ad_spec_tubes')) 
AND structure_field_id IN (SELECT id FROM structure_fields WHERE `field` IN ('study_summary_id'));
 	
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_spec_tiss_blocks') 
AND structure_field_id IN (SELECT id FROM structure_fields WHERE `field` IN ('study_summary_id'));

UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_spec_tiss_slides') 
AND structure_field_id IN (SELECT id FROM structure_fields WHERE `field` IN ('study_summary_id'));

UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_spec_tubes') 
AND structure_field_id IN (SELECT id FROM structure_fields WHERE `field` IN ('study_summary_id'));

UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' ,`display_order`='200'
WHERE structure_id IN (SELECT id FROM structures WHERE alias IN ('ad_der_tubes_incl_ml_vol','ohri_ad_der_ascite_cells', 'ad_der_cell_tubes_incl_ml_vol')) 
AND structure_field_id IN (SELECT id FROM structure_fields WHERE `field` IN ('study_summary_id'));

DELETE FROM structure_formats WHERE structure_id IN (SELECT id FROM structures WHERE alias IN ('ohri_ad_der_ascite_cells'))
AND structure_field_id IN (SELECT id FROM structure_fields WHERE `field` IN ('created'));

SET @source_id = (SELECT id FROM structures WHERE alias = 'ad_der_tubes_incl_ml_vol');
SET @dest_id = (SELECT id FROM structures WHERE alias = 'ohri_ad_der_ascite_cells');
INSERT INTO structure_formats (`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_summary`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`)
(SELECT @dest_id, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_summary`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`
FROM structure_formats WHERE structure_id = @source_id AND structure_field_id IN (SELECT id FROM structure_fields WHERE `field` IN ('study_summary_id')));

DELETE FROM structure_formats
WHERE display_column = 0
AND structure_field_id IN (SELECT id FROM structure_fields WHERE `field` IN ('study_summary_id'))
AND structure_id = (SELECT id FROM structures WHERE alias = 'ohri_ad_der_ascite_cells');


