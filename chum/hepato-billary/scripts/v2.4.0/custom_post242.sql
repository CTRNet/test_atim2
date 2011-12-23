UPDATE structure_permissible_values_customs SET fr = 'Hôpital Saint-Luc' WHERE value = 'saint-luc hospital';
UPDATE structure_permissible_values_customs_revs SET fr = 'Hôpital Saint-Luc' WHERE value = 'saint-luc hospital';

ALTER TABLE qc_hb_txe_surgery_complications
 DROP FOREIGN KEY FK_qc_hb_txe_surgery_complications_tx_masters,
 CHANGE tx_master_id treatment_master_id INT NOT NULL,
 ADD FOREIGN KEY (treatment_master_id) REFERENCES treatment_masters(id);
ALTER TABLE qc_hb_txe_surgery_complications_revs
 CHANGE tx_master_id treatment_master_id INT NOT NULL;

-- participant contact

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participantcontacts') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ParticipantContact' AND `tablename`='participant_contacts' AND `field`='contact_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_participant_contact_types') AND `flag_confidential`='0');

UPDATE participant_contacts SET relationship = 'common-law spouse', contact_type = '' WHERE contact_type = 'Conjointe';
UPDATE participant_contacts SET relationship = 'common-law spouse', contact_type = '' WHERE contact_type = 'conjoint';
UPDATE participant_contacts SET relationship = 'friend', contact_type = '' WHERE contact_type = 'compagnon';

UPDATE participant_contacts SET relationship = 'daughter', contact_type = '' WHERE contact_type = 'Fille';
UPDATE participant_contacts SET relationship = 'son', contact_type = '' WHERE contact_type = 'Fils';
UPDATE participant_contacts SET relationship = 'cousin', contact_type = '' WHERE contact_type = 'Cousine';
UPDATE participant_contacts SET relationship = 'father', contact_type = '' WHERE contact_type = 'père';
UPDATE participant_contacts SET relationship = 'brother', contact_type = '' WHERE contact_type = 'frère';
UPDATE participant_contacts SET relationship = 'sister', contact_type = '' WHERE contact_type = 'soeur';
UPDATE participant_contacts SET relationship = '', contact_type = '' WHERE contact_type = 'Résidentiel';
UPDATE participant_contacts SET relationship = 'wife', contact_type = '' WHERE contact_type = 'Épouse';
UPDATE participant_contacts SET relationship = 'the participant', contact_type = '' WHERE contact_type = 'Participant';

SELECT IF((SELECT COUNT(*) FROM participant_contacts WHERE contact_type IS NOT NULL AND contact_type NOT LIKE '') > 0, 'Not all contact types have been clean up', 'Contact ok') AS msg;

UPDATE participant_contacts_revs SET relationship = 'common-law spouse', contact_type = '' WHERE contact_type = 'Conjointe';
UPDATE participant_contacts_revs SET relationship = 'common-law spouse', contact_type = '' WHERE contact_type = 'conjoint';
UPDATE participant_contacts_revs SET relationship = 'friend', contact_type = '' WHERE contact_type = 'compagnon';

UPDATE participant_contacts_revs SET relationship = 'daughter', contact_type = '' WHERE contact_type = 'Fille';
UPDATE participant_contacts_revs SET relationship = 'son', contact_type = '' WHERE contact_type = 'Fils';
UPDATE participant_contacts_revs SET relationship = 'cousin', contact_type = '' WHERE contact_type = 'Cousine';
UPDATE participant_contacts_revs SET relationship = 'father', contact_type = '' WHERE contact_type = 'père';
UPDATE participant_contacts_revs SET relationship = 'brother', contact_type = '' WHERE contact_type = 'frère';
UPDATE participant_contacts_revs SET relationship = 'sister', contact_type = '' WHERE contact_type = 'soeur';
UPDATE participant_contacts_revs SET relationship = '', contact_type = '' WHERE contact_type = 'Résidentiel';
UPDATE participant_contacts_revs SET relationship = 'wife', contact_type = '' WHERE contact_type = 'Épouse';
UPDATE participant_contacts_revs SET relationship = 'the participant', contact_type = '' WHERE contact_type = 'Participant';

-- Tissue suspension 

INSERT INTO `structure_value_domains` (`id`, `domain_name`, `override`, `category`, `source`) VALUES (NULL, 'genhemacs_enzymatic_milieu', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(''genHeMACS enzymatic milieu'')');
INSERT INTO structure_permissible_values_custom_controls (name,flag_active,values_max_length) VALUES ('genHeMACS enzymatic milieu', '1', '50');
UPDATE structure_fields SET type = 'select', setting = '', structure_value_domain = (SELECT id FROM structure_value_domains WHERE domain_name="genhemacs_enzymatic_milieu") WHERE field = 'qc_hb_macs_enzymatic_milieu';

INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`) 
VALUES 
('collagenase + dornase', 'Collagenase + Dornase', 'Collagénase + Dornase', 1, (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'genHeMACS enzymatic milieu')),
('collagenase + dnase', 'Collagenase + DNase', 'Collagénase + DNase', 1, (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'genHeMACS enzymatic milieu')),
('rpmi + collagenase + dnase', 'rpmi + Collagenase + DNase', 'rpmi + Collagénase + DNase', 1, (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'genHeMACS enzymatic milieu'));

UPDATE sd_der_tiss_susps SET qc_hb_macs_enzymatic_milieu = 'collagenase + dornase' WHERE qc_hb_macs_enzymatic_milieu = 'collagénase+dornase';
UPDATE sd_der_tiss_susps SET qc_hb_macs_enzymatic_milieu = 'collagenase + dornase' WHERE qc_hb_macs_enzymatic_milieu = 'collagénase et dornase';
UPDATE sd_der_tiss_susps SET qc_hb_macs_enzymatic_milieu = 'rpmi + collagenase + dnase' WHERE qc_hb_macs_enzymatic_milieu = 'rpmi+collagénase+DNase';
UPDATE sd_der_tiss_susps SET qc_hb_macs_enzymatic_milieu = 'collagenase + dnase' WHERE qc_hb_macs_enzymatic_milieu = 'collagénase et DNase';

SELECT IF((SELECT COUNT(*) FROM sd_der_tiss_susps WHERE qc_hb_macs_enzymatic_milieu NOT IN ('rpmi + collagenase + dnase', 'collagenase + dnase', 'collagenase + dornase') AND qc_hb_macs_enzymatic_milieu IS NOT NULL AND qc_hb_macs_enzymatic_milieu NOT LIKE '') > 0, 'Not all genHeMACS enzymatic milieus have been clean up', 'GenHeMACS enzymatic milieu ok') AS msg;

UPDATE sd_der_tiss_susps_revs SET qc_hb_macs_enzymatic_milieu = 'collagenase + dornase' WHERE qc_hb_macs_enzymatic_milieu = 'collagénase+dornase';
UPDATE sd_der_tiss_susps_revs SET qc_hb_macs_enzymatic_milieu = 'collagenase + dornase' WHERE qc_hb_macs_enzymatic_milieu = 'collagénase et dornase';
UPDATE sd_der_tiss_susps_revs SET qc_hb_macs_enzymatic_milieu = 'rpmi + collagenase + dnase' WHERE qc_hb_macs_enzymatic_milieu = 'rpmi+collagénase+DNase';
UPDATE sd_der_tiss_susps_revs SET qc_hb_macs_enzymatic_milieu = 'collagenase + dnase' WHERE qc_hb_macs_enzymatic_milieu = 'collagénase et DNase';

-- No Labo

DELETE FROM i18n WHERE id = 'participant identifier';
INSERT INTO i18n (id,en,fr) VALUES ('participant identifier', 'Bank Nbr', 'No Banque');
UPDATE structure_formats SET flag_override_label = '0', language_label = '' WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE field = 'participant_identifier');

UPDATE structure_formats SET `display_column`='1', `display_order`='0', `flag_add`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='participant_identifier' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE participants SET participant_identifier = '-1';
UPDATE participants part, misc_identifiers ident SET part.participant_identifier = ident.identifier_value WHERE part.id = ident.participant_id AND ident.misc_identifier_control_id = 3;

SELECT IF((SELECT COUNT(*) FROM participants WHERE participant_identifier = '-1' OR participant_identifier IS NULL OR participant_identifier LIKE '') > 0, 'Not all No Labo have been clean up', 'No Labo  ok') AS msg;

UPDATE participants_revs rev, participants main SET rev.participant_identifier = main.participant_identifier WHERE rev.id = main.id;

DELETE FROM misc_identifiers WHERE misc_identifier_control_id = 3;
DELETE FROM misc_identifiers_revs WHERE misc_identifier_control_id = 3;
DELETE FROM misc_identifier_controls WHERE id = 3;

UPDATE structure_fields SET type = 'integer_positive', setting = 'size=10' WHERE field = 'participant_identifier';

ALTER TABLE participants MODIFY participant_identifier INT(7) NOT NULL;
ALTER TABLE participants_revs MODIFY participant_identifier INt(7) NOT NULL;

REPLACE INTO i18n (id,en,fr) VALUES 
('error_participant identifier required', 'The participant Bank Nbr is required!', 'Erreur - No Banque du participant est requis!'),
('error_participant identifier must be unique', 'Error - Participant Bank Nbr must be unique!', 'Erreur - No Banque du participant doit être unique!');

DROP VIEW view_collections;
CREATE VIEW `view_collections` AS select `col`.`id` AS `collection_id`,
`col`.`bank_id` AS `bank_id`,`col`.`sop_master_id` AS `sop_master_id`,
`link`.`participant_id` AS `participant_id`,
`link`.`diagnosis_master_id` AS `diagnosis_master_id`,
`link`.`consent_master_id` AS `consent_master_id`,
`part`.`participant_identifier` AS `participant_identifier`,
`col`.`acquisition_label` AS `acquisition_label`,
`col`.`collection_site` AS `collection_site`,
`col`.`collection_datetime` AS `collection_datetime`,
`col`.`collection_datetime_accuracy` AS `collection_datetime_accuracy`,
`col`.`collection_property` AS `collection_property`,
`col`.`collection_notes` AS `collection_notes`,
`col`.`deleted` AS `deleted`,
`banks`.`name` AS `bank_name`,
`col`.`created` AS `created`
from `collections` `col` 
left join `clinical_collection_links` `link` on `col`.`id` = `link`.`collection_id` and `link`.`deleted` <> 1 
left join `participants` `part` on `link`.`participant_id` = `part`.`id` and `part`.`deleted` <> 1
left join `banks` on `col`.`bank_id` = `banks`.`id` and `banks`.`deleted` <> 1
where `col`.`deleted` <> 1;

DELETE FROM structure_formats WHERE structure_field_id = (SELECT id FROM structure_fields WHERE field = 'hepato_bil_bank_participant_id' AND model = 'ViewCollection');
DELETE FROM structure_fields WHERE field = 'hepato_bil_bank_participant_id' AND model = 'ViewCollection';

UPDATE structure_formats SET `flag_search`='1', `flag_index`='1', `flag_detail`='1', `flag_summary`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='participant_identifier' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_sample_joined_to_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='' AND `field`='participant_identifier' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='participant_identifier' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- qc_hb_label

UPDATE aliquot_masters SET aliquot_label = qc_hb_label;
UPDATE aliquot_masters_revs SET aliquot_label = qc_hb_label;

ALTER TABLE aliquot_masters DROP COLUMN qc_hb_label;
ALTER TABLE aliquot_masters_revs DROP COLUMN qc_hb_label;

DELETE FROM structure_formats WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE field = 'qc_hb_label');
DELETE FROM structure_validations WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE field = 'qc_hb_label');
DELETE FROM structure_fields WHERE field = 'qc_hb_label';

UPDATE structure_formats SET flag_override_label = '', language_label = '' WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE field  ='aliquot_label');

-- bank_id

UPDATE structure_formats SET `flag_search`='0', `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_sample_joined_to_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='' AND `field`='bank_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='banks') AND `flag_confidential`='0');

-- View

UPDATE structure_formats SET `flag_search`='0', `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='bank_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='banks') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='2' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='barcode' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='2' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='aliquot_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_index`='1', `flag_summary`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters_for_collection_tree_view') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='aliquot_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='3' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters_for_collection_tree_view') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='aliquot_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- sop

UPDATE structure_formats SET flag_add='0',flag_add_readonly='0',flag_edit='0',flag_edit_readonly='0',flag_search='0',flag_search_readonly='0',flag_addgrid='0',flag_addgrid_readonly='0',flag_editgrid='0',flag_editgrid_readonly='0',flag_summary='0',flag_batchedit='0',flag_batchedit_readonly='0',flag_index='0',flag_detail='0'
WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE field = 'sop_master_id');

-- aliquot masters

UPDATE structure_formats SET `display_column`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='aliquot_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='' AND `field`='use_counter' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='notes' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats SET `language_heading`='system data' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='created' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`= '1202', `language_heading`='' WHERE structure_id = (SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id IN (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `field`='barcode');

-- plasma and tubes

UPDATE structure_formats SET display_column = '1' WHERE structure_id = (SELECT id FROM structures WHERE alias = 'ad_der_tubes_incl_ml_vol');
UPDATE structure_formats SET display_order = (display_order + 55) WHERE structure_id IN (SELECT id FROM structures WHERE alias = 'ad_der_tubes_incl_ml_vol') AND display_order < 20;

UPDATE structure_formats SET display_column = '0', display_order = '1001' WHERE structure_id = (SELECT id FROM structures WHERE alias = 'ad_der_tubes_incl_ml_vol') AND structure_field_id IN (SELECT id FROM structure_fields WHERE field = 'qc_hb_stored_by');

UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_der_tubes_incl_ml_vol') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='qc_hb_stored_by' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_staff') AND `flag_confidential`='0');

-- pbmc and tubes

UPDATE structure_formats SET `display_order`='451', `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_sd_der_pbmc') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_der_pbmcs' AND `field`='qc_hb_nb_cells' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='452', `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_sd_der_pbmc') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_der_pbmcs' AND `field`='qc_hb_nb_cell_unit' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_nb_cell_unit') AND `flag_confidential`='0');

UPDATE structure_formats SET display_column = '1' WHERE structure_id = (SELECT id FROM structures WHERE alias = 'ad_der_cell_tubes_incl_ml_vol');
UPDATE structure_formats SET display_order = (display_order + 55) WHERE structure_id IN (SELECT id FROM structures WHERE alias = 'ad_der_cell_tubes_incl_ml_vol') AND display_order < 20;
UPDATE structure_formats SET display_column = '0', display_order = '1001' WHERE structure_id = (SELECT id FROM structures WHERE alias = 'ad_der_cell_tubes_incl_ml_vol') AND structure_field_id IN (SELECT id FROM structure_fields WHERE field = 'qc_hb_stored_by');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_der_cell_tubes_incl_ml_vol') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='qc_hb_stored_by' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_staff') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_edit`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_der_cell_tubes_incl_ml_vol') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_tubes' AND `field`='qc_hb_milieu' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_milieu') AND `flag_confidential`='0');

-- serum and tube

UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_hemolysis') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_tubes' AND `field`='hemolysis_signs' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- TISSUE tube

UPDATE structure_formats SET display_column = '1' WHERE structure_id = (SELECT id FROM structures WHERE alias = 'ad_spec_tubes');
UPDATE structure_formats SET display_order = (display_order + 55) WHERE structure_id IN (SELECT id FROM structures WHERE alias = 'ad_spec_tubes') AND display_order < 20;
UPDATE structure_formats SET display_column = '0', display_order = '1001' WHERE structure_id = (SELECT id FROM structures WHERE alias = 'ad_spec_tubes') AND structure_field_id IN (SELECT id FROM structure_fields WHERE field = 'qc_hb_stored_by');

UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_spec_tubes') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='qc_hb_stored_by' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_staff') AND `flag_confidential`='0');

-- TISSUE block

UPDATE structure_formats SET display_column = '1' WHERE structure_id = (SELECT id FROM structures WHERE alias = 'ad_spec_tiss_blocks');
UPDATE structure_formats SET display_order = (display_order + 55) WHERE structure_id IN (SELECT id FROM structures WHERE alias = 'ad_spec_tiss_blocks') AND display_order < 20;
UPDATE structure_formats SET display_column = '0', display_order = '1001' WHERE structure_id = (SELECT id FROM structures WHERE alias = 'ad_spec_tiss_blocks') AND structure_field_id IN (SELECT id FROM structure_fields WHERE field = 'qc_hb_stored_by');

UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_spec_tiss_blocks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='qc_hb_stored_by' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_staff') AND `flag_confidential`='0');

-- TISSUE suspensio

DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_tissue_susp') AND structure_field_id IN (SELECT id FROM structure_fields WHERE `model` IN ('DerivativeDetail','SampleMaster') AND field IN ('creation_site','creation_datetime','parent_sample_type'));
UPDATE structure_formats SET display_order = (display_order + 400) WHERE structure_id IN (SELECT id FROM structures WHERE alias = 'sd_tissue_susp');

UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_tissue_susp') AND structure_field_id IN (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_der_tiss_susps' AND `field` IN ('qc_hb_overnight','qc_hb_nb_viable_cells','qc_hb_nb_viable_cells_unit'));

UPDATE menus set flag_active = 0 WHERE use_link like '%inventorymanagement/specimen_reviews%';
SET @str_id = (SELECT id FROM datamart_structures WHERE model = 'SpecimenReviewMaster');
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = 0, flag_active_2_to_1 = 0 WHERE id1 = @str_id OR id2 = @str_id;

UPDATE structure_formats SET `flag_addgrid`='1', `flag_editgrid`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='aliquot_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE aliquot_masters SET barcode = id;
UPDATE aliquot_masters_revs SET barcode = id;

INSERT INTO structure_validations (structure_field_id, rule, language_message) VALUES ((SELECT id FROM structure_fields WHERE model = 'AliquotMaster' AND field = 'aliquot_label'), 'notEmpty', ''); 


SELECT 'aliquot view avec label , todo' AS MSG;

-- ------------------------------------------------------------------------------------------------------------
-- DATAMART
-- ------------------------------------------------------------------------------------------------------------

UPDATE datamart_adhoc SET sql_query_for_results='
SELECT 
EventMaster.id,
Participant.id,
Participant.participant_identifier,
Participant.first_name,
Participant.last_name,

MiscIdentifier.identifier_value,

EventDetail.hepatic_artery,
EventDetail.coeliac_trunk ,
EventDetail.splenic_artery,
EventDetail.superior_mesenteric_artery,
EventDetail.portal_vein,
EventDetail.superior_mesenteric_vein,
EventDetail.splenic_vein,
EventDetail.metastatic_lymph_nodes

FROM event_controls AS ctrl
INNER JOIN event_masters AS EventMaster ON ctrl.id = EventMaster.event_control_id AND ctrl.form_alias LIKE "qc_hb_imaging_%pancreas%" AND EventMaster.deleted != 1
INNER JOIN qc_hb_ed_hepatobilary_medical_imagings AS EventDetail ON EventDetail.event_master_id = EventMaster.id
INNER JOIN participants AS Participant ON EventMaster.participant_id = Participant.id AND Participant.deleted != 1
LEFT JOIN misc_identifiers AS MiscIdentifier ON MiscIdentifier.participant_id = Participant.id AND MiscIdentifier.misc_identifier_control_id = "3" AND MiscIdentifier.deleted != 1

WHERE TRUE AND
Participant.participant_identifier = "@@Participant.participant_identifier@@"
AND MiscIdentifier.identifier_value = "@@MiscIdentifier.identifier_value@@"

AND EventDetail.hepatic_artery = "@@EventDetail.hepatic_artery@@"
AND EventDetail.coeliac_trunk = "@@EventDetail.coeliac_trunk@@"
AND EventDetail.splenic_artery = "@@EventDetail.splenic_artery@@"
AND EventDetail.superior_mesenteric_artery = "@@EventDetail.superior_mesenteric_artery@@"
AND EventDetail.portal_vein = "@@EventDetail.portal_vein@@"
AND EventDetail.superior_mesenteric_vein = "@@EventDetail.superior_mesenteric_vein@@"
AND EventDetail.splenic_vein = "@@EventDetail.splenic_vein@@"
AND EventDetail.metastatic_lymph_nodes = "@@EventDetail.metastatic_lymph_nodes@@";
' WHERE id=2;



UPDATE datamart_adhoc SET sql_query_for_results='
SELECT 
EventMaster.id,
Participant.id,
Participant.participant_identifier,
Participant.first_name,
Participant.last_name,

MiscIdentifier.identifier_value,

EventDetail.is_volumetry_post_pve,
EventDetail.total_liver_volume,
EventDetail.resected_liver_volume,
EventDetail.remnant_liver_volume,
EventDetail.tumoral_volume,
EventDetail.remnant_liver_percentage

FROM event_controls AS ctrl
INNER JOIN event_masters AS EventMaster ON ctrl.id = EventMaster.event_control_id AND ctrl.form_alias LIKE "qc_hb_imaging_%volumetry%" AND EventMaster.deleted != 1
INNER JOIN qc_hb_ed_hepatobilary_medical_imagings AS EventDetail ON EventDetail.event_master_id = EventMaster.id
INNER JOIN participants AS Participant ON EventMaster.participant_id = Participant.id AND Participant.deleted != 1
LEFT JOIN misc_identifiers AS MiscIdentifier ON MiscIdentifier.participant_id = Participant.id AND MiscIdentifier.misc_identifier_control_id = "3" AND MiscIdentifier.deleted != 1

WHERE TRUE AND
Participant.participant_identifier = "@@Participant.participant_identifier@@"
AND MiscIdentifier.identifier_value = "@@MiscIdentifier.identifier_value@@"

AND EventDetail.is_volumetry_post_pve = "@@EventDetail.is_volumetry_post_pve@@"

AND EventDetail.total_liver_volume >= "@@EventDetail.total_liver_volume_start@@" 
AND EventDetail.total_liver_volume <= "@@EventDetail.total_liver_volume_end@@" 

AND EventDetail.resected_liver_volume >= "@@EventDetail.resected_liver_volume_start@@" 
AND EventDetail.resected_liver_volume <= "@@EventDetail.resected_liver_volume_end@@" 

AND EventDetail.remnant_liver_volume >= "@@EventDetail.remnant_liver_volume_start@@" 
AND EventDetail.remnant_liver_volume <= "@@EventDetail.remnant_liver_volume_end@@" 

AND EventDetail.tumoral_volume >= "@@EventDetail.tumoral_volume_start@@" 
AND EventDetail.tumoral_volume <= "@@EventDetail.tumoral_volume_end@@" 

AND EventDetail.remnant_liver_percentage >= "@@EventDetail.remnant_liver_percentage_start@@" 
AND EventDetail.remnant_liver_percentage <= "@@EventDetail.remnant_liver_percentage_end@@" ;
' WHERE id=3;

UPDATE structure_fields SET  `type`='float_positive' WHERE model='EventDetail' AND tablename='qc_hb_ed_hepatobilary_medical_imagings' AND field='remnant_liver_percentage' AND `type`='number' AND structure_value_domain  IS NULL ;
UPDATE structure_fields SET  `type`='float_positive' WHERE model='EventDetail' AND tablename='qc_hb_ed_hepatobilary_medical_imagings' AND field='remnant_liver_volume' AND `type`='number' AND structure_value_domain  IS NULL ;




UPDATE datamart_adhoc SET sql_query_for_results='
SELECT 
EventMaster.id,
Participant.id,
Participant.participant_identifier,
Participant.first_name,
Participant.last_name,

MiscIdentifier.identifier_value,

EventDetail.lungs_number,
EventDetail.lungs_size,
EventDetail.lungs_laterality,
EventDetail.lymph_node_number,
EventDetail.lymph_node_size,
EventDetail.colon_number,
EventDetail.colon_size,
EventDetail.rectum_number,
EventDetail.rectum_size,
EventDetail.bones_number,
EventDetail.bones_size,
EventDetail.other_localisation_1,
EventDetail.other_localisation_1_number,
EventDetail.other_localisation_1_size,
EventDetail.other_localisation_2,
EventDetail.other_localisation_2_number,
EventDetail.other_localisation_2_size,
EventDetail.other_localisation_3,
EventDetail.other_localisation_3_number,
EventDetail.other_localisation_3_size

FROM event_controls AS ctrl
INNER JOIN event_masters AS EventMaster ON ctrl.id = EventMaster.event_control_id AND ctrl.form_alias LIKE "qc_hb_imaging_%other%" AND EventMaster.deleted != 1
INNER JOIN qc_hb_ed_hepatobilary_medical_imagings AS EventDetail ON EventDetail.event_master_id = EventMaster.id
INNER JOIN participants AS Participant ON EventMaster.participant_id = Participant.id AND Participant.deleted != 1
LEFT JOIN misc_identifiers AS MiscIdentifier ON MiscIdentifier.participant_id = Participant.id AND MiscIdentifier.misc_identifier_control_id = 3 AND MiscIdentifier.deleted != 1

WHERE TRUE AND
Participant.participant_identifier = "@@Participant.participant_identifier@@"
AND MiscIdentifier.identifier_value = "@@MiscIdentifier.identifier_value@@"

AND EventDetail.lungs_number >= "@@EventDetail.lungs_number_start@@" 
AND EventDetail.lungs_number <= "@@EventDetail.lungs_number_end@@"

AND EventDetail.lungs_size >= "@@EventDetail.lungs_size_start@@" 
AND EventDetail.lungs_size <= "@@EventDetail.lungs_size_end@@"

AND EventDetail.lungs_laterality = "@@EventDetail.lungs_laterality@@"

AND EventDetail.lymph_node_number >= "@@EventDetail.lymph_node_number_start@@" 
AND EventDetail.lymph_node_number <= "@@EventDetail.lymph_node_number_end@@"

AND EventDetail.lymph_node_size >= "@@EventDetail.lymph_node_size_start@@" 
AND EventDetail.lymph_node_size <= "@@EventDetail.lymph_node_size_end@@"

AND EventDetail.colon_number >= "@@EventDetail.colon_number_start@@" 
AND EventDetail.colon_number <= "@@EventDetail.colon_number_end@@"

AND EventDetail.colon_size >= "@@EventDetail.colon_size_start@@" 
AND EventDetail.colon_size <= "@@EventDetail.colon_size_end@@"

AND EventDetail.rectum_number >= "@@EventDetail.rectum_number_start@@" 
AND EventDetail.rectum_number <= "@@EventDetail.rectum_number_end@@"

AND EventDetail.rectum_size >= "@@EventDetail.rectum_size_start@@" 
AND EventDetail.rectum_size <= "@@EventDetail.rectum_size_end@@"

AND EventDetail.bones_number >= "@@EventDetail.bones_number_start@@" 
AND EventDetail.bones_number <= "@@EventDetail.bones_number_end@@"

AND EventDetail.bones_size >= "@@EventDetail.bones_size_start@@" 
AND EventDetail.bones_size <= "@@EventDetail.bones_size_end@@"

AND EventDetail.other_localisation_1 = "@@EventDetail.other_localisation_1@@"

AND EventDetail.other_localisation_1_number >= "@@EventDetail.other_localisation_1_number_start@@" 
AND EventDetail.other_localisation_1_number <= "@@EventDetail.other_localisation_1_number_end@@"

AND EventDetail.other_localisation_1_size >= "@@EventDetail.other_localisation_1_size_start@@" 
AND EventDetail.other_localisation_1_size <= "@@EventDetail.other_localisation_1_size_end@@"

AND EventDetail.other_localisation_2 = "@@EventDetail.other_localisation_2@@"

AND EventDetail.other_localisation_2_number >= "@@EventDetail.other_localisation_2_number_start@@" 
AND EventDetail.other_localisation_2_number <= "@@EventDetail.other_localisation_2_number_end@@"

AND EventDetail.other_localisation_2_size >= "@@EventDetail.other_localisation_2_size_start@@" 
AND EventDetail.other_localisation_2_size <= "@@EventDetail.other_localisation_2_size_end@@"

AND EventDetail.other_localisation_3 = "@@EventDetail.other_localisation_3@@"

AND EventDetail.other_localisation_3_number >= "@@EventDetail.other_localisation_3_number_start@@" 
AND EventDetail.other_localisation_3_number <= "@@EventDetail.other_localisation_3_number_end@@"

AND EventDetail.other_localisation_3_size >= "@@EventDetail.other_localisation_3_size_start@@" 
AND EventDetail.other_localisation_3_size <= "@@EventDetail.other_localisation_3_size_end@@"
' WHERE id=4;


UPDATE datamart_adhoc SET sql_query_for_results='
SELECT 
EventMaster.id,
Participant.id,
Participant.participant_identifier,
Participant.first_name,
Participant.last_name,

MiscIdentifier.identifier_value,

EventDetail.segment_1_number,
EventDetail.segment_1_size,
EventDetail.segment_2_number,
EventDetail.segment_2_size,
EventDetail.segment_3_number,
EventDetail.segment_3_size,
EventDetail.segment_4a_number,
EventDetail.segment_4a_size,
EventDetail.segment_4b_number,
EventDetail.segment_4b_size,
EventDetail.segment_5_number,
EventDetail.segment_5_size,
EventDetail.segment_6_number,
EventDetail.segment_6_size,
EventDetail.segment_7_number,
EventDetail.segment_7_size,
EventDetail.segment_8_number,
EventDetail.segment_8_size,
EventDetail.density,
EventDetail.type

FROM event_controls AS ctrl
INNER JOIN event_masters AS EventMaster ON ctrl.id = EventMaster.event_control_id AND ctrl.form_alias LIKE "qc_hb_imaging_%segment%" AND EventMaster.deleted != 1
INNER JOIN qc_hb_ed_hepatobilary_medical_imagings AS EventDetail ON EventDetail.event_master_id = EventMaster.id
INNER JOIN participants AS Participant ON EventMaster.participant_id = Participant.id AND Participant.deleted != 1
LEFT JOIN misc_identifiers AS MiscIdentifier ON MiscIdentifier.participant_id = Participant.id AND MiscIdentifier.misc_identifier_control_id = 3 AND MiscIdentifier.deleted != 1

WHERE TRUE AND
Participant.participant_identifier = "@@Participant.participant_identifier@@"
AND MiscIdentifier.identifier_value = "@@MiscIdentifier.identifier_value@@"

AND EventDetail.segment_1_number >= "@@EventDetail.segment_1_number_start@@" 
AND EventDetail.segment_1_number <= "@@EventDetail.segment_1_number_end@@" 

AND EventDetail.segment_1_size >= "@@EventDetail.segment_1_size_start@@" 
AND EventDetail.segment_1_size <= "@@EventDetail.segment_1_size_end@@" 

AND EventDetail.segment_2_number >= "@@EventDetail.segment_2_number_start@@" 
AND EventDetail.segment_2_number <= "@@EventDetail.segment_2_number_end@@" 

AND EventDetail.segment_2_size >= "@@EventDetail.segment_2_size_start@@" 
AND EventDetail.segment_2_size <= "@@EventDetail.segment_2_size_end@@" 

AND EventDetail.segment_3_number >= "@@EventDetail.segment_3_number_start@@" 
AND EventDetail.segment_3_number <= "@@EventDetail.segment_3_number_end@@" 

AND EventDetail.segment_3_size >= "@@EventDetail.segment_3_size_start@@" 
AND EventDetail.segment_3_size <= "@@EventDetail.segment_3_size_end@@" 

AND EventDetail.segment_4a_number >= "@@EventDetail.segment_4a_number_start@@" 
AND EventDetail.segment_4a_number <= "@@EventDetail.segment_4a_number_end@@" 

AND EventDetail.segment_4a_size >= "@@EventDetail.segment_4a_size_start@@" 
AND EventDetail.segment_4a_size <= "@@EventDetail.segment_4a_size_end@@" 

AND EventDetail.segment_4b_number >= "@@EventDetail.segment_4b_number_start@@" 
AND EventDetail.segment_4b_number <= "@@EventDetail.segment_4b_number_end@@" 

AND EventDetail.segment_4b_size >= "@@EventDetail.segment_4b_size_start@@" 
AND EventDetail.segment_4b_size <= "@@EventDetail.segment_4b_size_end@@" 

AND EventDetail.segment_5_number >= "@@EventDetail.segment_5_number_start@@" 
AND EventDetail.segment_5_number <= "@@EventDetail.segment_5_number_end@@" 

AND EventDetail.segment_5_size >= "@@EventDetail.segment_5_size_start@@" 
AND EventDetail.segment_5_size <= "@@EventDetail.segment_5_size_end@@" 

AND EventDetail.segment_6_number >= "@@EventDetail.segment_6_number_start@@" 
AND EventDetail.segment_6_number <= "@@EventDetail.segment_6_number_end@@" 

AND EventDetail.segment_6_size >= "@@EventDetail.segment_6_size_start@@" 
AND EventDetail.segment_6_size <= "@@EventDetail.segment_6_size_end@@" 

AND EventDetail.segment_7_number >= "@@EventDetail.segment_7_number_start@@" 
AND EventDetail.segment_7_number <= "@@EventDetail.segment_7_number_end@@" 

AND EventDetail.segment_7_size >= "@@EventDetail.segment_7_size_start@@" 
AND EventDetail.segment_7_size <= "@@EventDetail.segment_7_size_end@@" 

AND EventDetail.segment_8_number >= "@@EventDetail.segment_8_number_start@@" 
AND EventDetail.segment_8_number <= "@@EventDetail.segment_8_number_end@@" 

AND EventDetail.segment_8_size >= "@@EventDetail.segment_8_size_start@@" 
AND EventDetail.segment_8_size <= "@@EventDetail.segment_8_size_end@@" 

AND EventDetail.density >= "@@EventDetail.density_start@@" 
AND EventDetail.density <= "@@EventDetail.density_end@@" 

AND EventDetail.type = "@@EventDetail.type@@"
' WHERE id=1;