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
UPDATE participant_contacts SET relationship = 'the participant', contact_type = '' WHERE contact_type = 'The participant';

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

-- ------- AFTER LOUISE REVISION

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participantcontacts') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ParticipantContact' AND `tablename`='participant_contacts' AND `field`='contact_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='contact_type') AND `flag_confidential`='0');

INSERT INTO `misc_identifier_controls` (`misc_identifier_name`, `flag_active`, `display_order`, `autoincrement_name`, `misc_identifier_format`, `flag_once_per_participant`, `flag_confidential`) VALUES
('notre_dame_hospital_nbr', 1, 1, '', '', 1, 1),('hotel_dieu_hospital_nbr', 1, 1, '', '', 1, 1);

INSERT INTO i18n (id,en,fr) VALUES
('notre_dame_hospital_nbr', 'Notre Dame Hospital Number', 'No Hôpital Notre Dame'), 
('hotel_dieu_hospital_nbr', 'Hôtel Dieu Hospital Number', 'No Hôpital Hôtel Dieu');

UPDATE clinical_collection_links link, consent_masters cst
SET link.consent_master_id = cst.id
WHERE link.collection_id IS NOT NULL
AND link.deleted != 1
AND link.participant_id = cst.participant_id
AND cst.deleted != 1;

UPDATE clinical_collection_links link, clinical_collection_links_revs revs
SET revs.consent_master_id = link.consent_master_id
WHERE revs.id = link.id;

UPDATE structure_fields SET language_tag = 'size (cm)' WHERE field LIKE '%_size' AND tablename = 'qc_hb_ed_hepatobilary_medical_imagings';
INSERT INTO i18n (id,en,fr) VALUES ('size (cm)', 'Size (cm)', 'Taille (cm)');

SELECT IF((SELECT COUNT(*) FROM diagnosis_masters) > 1, 'Diagnosis Warning', 'Diagnosis ok') AS msg;
UPDATE diagnosis_controls SET category = 'secondary', databrowser_label = 'secondary|liver metastasis' WHERE controls_type = 'liver metastasis';

SELECT 'RUN FOLLOWING SQL STATEMENTS' as msg;
SELECT CONCAT("UPDATE event_masters SET diagnosis_master_id = '2' WHERE id = ",id,";") as msg FROM event_masters WHERE diagnosis_master_id = 1;
SELECT CONCAT("UPDATE event_masters_revs SET diagnosis_master_id = '2' WHERE id = ",id,";") as msg FROM event_masters WHERE diagnosis_master_id = 1;

UPDATE event_masters SET diagnosis_master_id = null WHERE diagnosis_master_id = 1;
UPDATE event_masters_revs SET diagnosis_master_id = null WHERE diagnosis_master_id = 1;

TRUNCATE qc_hb_dxd_liver_metastases;
TRUNCATE qc_hb_dxd_liver_metastases_revs;
TRUNCATE diagnosis_masters_revs;
TRUNCATE diagnosis_masters;

INSERT INTO `versions` (version_number, date_installed, build_number) VALUES
('2.4.2', NOW(), '4017');

ALTER TABLE qc_hb_dxd_liver_metastases MODIFY viable_cells_perc VARCHAR(50);
ALTER TABLE qc_hb_dxd_liver_metastases_revs MODIFY viable_cells_perc VARCHAR(50);

-- ------------------------------------------------------------------------
-- Following lines executed on server on 2012-01-03 after migration
-- ------------------------------------------------------------------------

ALTER TABLE qc_hb_ed_hepatobilary_lab_report_biologies
  MODIFY `wbc` decimal(6, 2) DEFAULT NULL,
  MODIFY `rbc` decimal(6, 2) DEFAULT NULL,
  MODIFY `hb` decimal(6, 2) DEFAULT NULL,
  MODIFY `ht` decimal(6, 2) DEFAULT NULL,
  MODIFY `platelets` decimal(6, 2) DEFAULT NULL,
  MODIFY `ptt` decimal(6, 2) DEFAULT NULL,
  MODIFY `inr` decimal(6, 2) DEFAULT NULL,
  MODIFY `na` decimal(6, 2) DEFAULT NULL,
  MODIFY `k` decimal(6, 2) DEFAULT NULL,
  MODIFY `cl` decimal(6, 2) DEFAULT NULL,
  MODIFY `creatinine` decimal(6, 2) DEFAULT NULL,
  MODIFY `urea` decimal(6, 2) DEFAULT NULL,
  MODIFY `ca` decimal(6, 2) DEFAULT NULL,
  MODIFY `p` decimal(6, 2) DEFAULT NULL,
  MODIFY `mg` decimal(6, 2) DEFAULT NULL,
  MODIFY `protein` decimal(6, 2) DEFAULT NULL,
  MODIFY `uric_acid` decimal(6, 2) DEFAULT NULL,
  MODIFY `glycemia` decimal(6, 2) DEFAULT NULL,
  MODIFY `triglycerides` decimal(6, 2) DEFAULT NULL,
  MODIFY `cholesterol` decimal(6, 2) DEFAULT NULL,
  MODIFY `albumin` decimal(6, 2) DEFAULT NULL,
  MODIFY `total_bilirubin` decimal(6, 2) DEFAULT NULL,
  MODIFY `direct_bilirubin` decimal(6, 2) DEFAULT NULL,
  MODIFY `indirect_bilirubin` decimal(6, 2) DEFAULT NULL,
  MODIFY `ast` decimal(6, 2) DEFAULT NULL,
  MODIFY `alt` decimal(6, 2) DEFAULT NULL,
  MODIFY `alkaline_phosphatase` decimal(6, 2) DEFAULT NULL,
  MODIFY `amylase` decimal(6, 2) DEFAULT NULL,
  MODIFY `lipase` decimal(6, 2) DEFAULT NULL,
  MODIFY `a_fp` decimal(6, 2) DEFAULT NULL,
  MODIFY `cea` decimal(6, 2) DEFAULT NULL,
  MODIFY `ca_19_9` decimal(6, 2) DEFAULT NULL,
  MODIFY `chromogranine` decimal(6, 2) DEFAULT NULL,
  MODIFY `_5_HIAA` decimal(6, 2) DEFAULT NULL,
  MODIFY `ca_125` decimal(6, 2) DEFAULT NULL,
  MODIFY `ca_15_3` decimal(6, 2) DEFAULT NULL,
  MODIFY `b_hcg` decimal(6, 2) DEFAULT NULL,
  MODIFY `other_marker_1` decimal(6, 2) DEFAULT NULL,
  MODIFY `other_marker_2` decimal(6, 2) DEFAULT NULL;
ALTER TABLE qc_hb_ed_hepatobilary_lab_report_biologies_revs
  MODIFY `wbc` decimal(6, 2) DEFAULT NULL,
  MODIFY `rbc` decimal(6, 2) DEFAULT NULL,
  MODIFY `hb` decimal(6, 2) DEFAULT NULL,
  MODIFY `ht` decimal(6, 2) DEFAULT NULL,
  MODIFY `platelets` decimal(6, 2) DEFAULT NULL,
  MODIFY `ptt` decimal(6, 2) DEFAULT NULL,
  MODIFY `inr` decimal(6, 2) DEFAULT NULL,
  MODIFY `na` decimal(6, 2) DEFAULT NULL,
  MODIFY `k` decimal(6, 2) DEFAULT NULL,
  MODIFY `cl` decimal(6, 2) DEFAULT NULL,
  MODIFY `creatinine` decimal(6, 2) DEFAULT NULL,
  MODIFY `urea` decimal(6, 2) DEFAULT NULL,
  MODIFY `ca` decimal(6, 2) DEFAULT NULL,
  MODIFY `p` decimal(6, 2) DEFAULT NULL,
  MODIFY `mg` decimal(6, 2) DEFAULT NULL,
  MODIFY `protein` decimal(6, 2) DEFAULT NULL,
  MODIFY `uric_acid` decimal(6, 2) DEFAULT NULL,
  MODIFY `glycemia` decimal(6, 2) DEFAULT NULL,
  MODIFY `triglycerides` decimal(6, 2) DEFAULT NULL,
  MODIFY `cholesterol` decimal(6, 2) DEFAULT NULL,
  MODIFY `albumin` decimal(6, 2) DEFAULT NULL,
  MODIFY `total_bilirubin` decimal(6, 2) DEFAULT NULL,
  MODIFY `direct_bilirubin` decimal(6, 2) DEFAULT NULL,
  MODIFY `indirect_bilirubin` decimal(6, 2) DEFAULT NULL,
  MODIFY `ast` decimal(6, 2) DEFAULT NULL,
  MODIFY `alt` decimal(6, 2) DEFAULT NULL,
  MODIFY `alkaline_phosphatase` decimal(6, 2) DEFAULT NULL,
  MODIFY `amylase` decimal(6, 2) DEFAULT NULL,
  MODIFY `lipase` decimal(6, 2) DEFAULT NULL,
  MODIFY `a_fp` decimal(6, 2) DEFAULT NULL,
  MODIFY `cea` decimal(6, 2) DEFAULT NULL,
  MODIFY `ca_19_9` decimal(6, 2) DEFAULT NULL,
  MODIFY `chromogranine` decimal(6, 2) DEFAULT NULL,
  MODIFY `_5_HIAA` decimal(6, 2) DEFAULT NULL,
  MODIFY `ca_125` decimal(6, 2) DEFAULT NULL,
  MODIFY `ca_15_3` decimal(6, 2) DEFAULT NULL,
  MODIFY `b_hcg` decimal(6, 2) DEFAULT NULL,
  MODIFY `other_marker_1` decimal(6, 2) DEFAULT NULL,
  MODIFY `other_marker_2` decimal(6, 2) DEFAULT NULL;
UPDATE structure_fields SET type = 'float_positive' WHERE tablename = 'qc_hb_ed_hepatobilary_lab_report_biologies' AND field IN (
'wbc',
'rbc',
'hb',
'ht',
'platelets',
'ptt',
'inr',
'na',
'k',
'cl',
'creatinine',
'urea',
'ca',
'p',
'mg',
'protein',
'uric_acid',
'glycemia',
'triglycerides',
'cholesterol',
'albumin',
'total_bilirubin',
'direct_bilirubin',
'indirect_bilirubin',
'ast',
'alt',
'alkaline_phosphatase',
'amylase',
'lipase',
'a_fp',
'cea',
'ca_19_9',
'chromogranine',
'_5_HIAA',
'ca_125',
'ca_15_3',
'b_hcg',
'other_marker_1',
'other_marker_2');

ALTER TABLE qc_hb_ed_hepatobilary_lab_report_biologies
  ADD COLUMN `ca_total` decimal(6, 2) DEFAULT NULL AFTER ca;
ALTER TABLE qc_hb_ed_hepatobilary_lab_report_biologies_revs
  ADD COLUMN `ca_total` decimal(6, 2) DEFAULT NULL AFTER ca;
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_lab_report_biologies', 'ca_total', 'float',  NULL , '0', 'size=5', '', '', 'ca total', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='qc_hb_ed_hepatobilary_lab_report_biology'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_hb_ed_hepatobilary_lab_report_biologies' AND `field`='ca_total' AND `type`='float' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='ca total' AND `language_tag`=''), '1', '15', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');
UPDATE structure_fields SET language_label = 'ca2+' WHERE tablename = 'qc_hb_ed_hepatobilary_lab_report_biologies' AND field = 'ca';
INSERT INTO i18n (id,en) VALUEs ('ca2+','Ca2+'),('ca total','Ca Total');

UPDATE structure_formats SET flag_search = 1, flag_index = 1 WHERE structure_id = (SELECT id FROM structures WHERE alias='qc_hb_ed_hepatobilary_lab_report_biology')
AND structure_field_id IN (SELECT id FROM structure_fields WHERE tablename = 'qc_hb_ed_hepatobilary_lab_report_biologies' AND field IN (
'wbc',
'rbc',
'hb',
'ht',
'platelets',
'ptt',
'inr',
'na',
'k',
'cl',
'creatinine',
'urea',
'ca',
'p',
'mg',
'protein',
'uric_acid',
'glycemia',
'triglycerides',
'cholesterol',
'albumin',
'total_bilirubin',
'direct_bilirubin',
'indirect_bilirubin',
'ast',
'alt',
'alkaline_phosphatase',
'amylase',
'lipase',
'a_fp',
'cea',
'ca_19_9',
'chromogranine',
'_5_HIAA',
'ca_125',
'ca_15_3',
'b_hcg',
'other_marker_1',
'other_marker_2',
'other_marker_1_description','other_marker_2_description','post_surgery_report_type'));

-- ------------------------------------------------------------------------
-- Following lines executed on server on 2012-01-04 after migration
-- ------------------------------------------------------------------------

ALTER TABLE qc_hb_ed_hepatobilary_medical_imagings
  MODIFY `segment_1_size` decimal(6, 2) DEFAULT NULL,
  MODIFY `segment_2_size` decimal(6, 2) DEFAULT NULL,
  MODIFY `segment_3_size` decimal(6, 2) DEFAULT NULL,
  MODIFY `segment_4a_size` decimal(6, 2) DEFAULT NULL,
  MODIFY `segment_4b_size` decimal(6, 2) DEFAULT NULL,
  MODIFY `segment_5_size` decimal(6, 2) DEFAULT NULL,
  MODIFY `segment_6_size` decimal(6, 2) DEFAULT NULL,
  MODIFY `segment_7_size` decimal(6, 2) DEFAULT NULL,
  MODIFY `segment_8_size` decimal(6, 2) DEFAULT NULL,
  MODIFY `lungs_size` decimal(6, 2) DEFAULT NULL,
  MODIFY `lymph_node_size` decimal(6, 2) DEFAULT NULL,
  MODIFY `colon_size` decimal(6, 2) DEFAULT NULL,
  MODIFY `rectum_size` decimal(6, 2) DEFAULT NULL,
  MODIFY `bones_size` decimal(6, 2) DEFAULT NULL,
  MODIFY `other_localisation_1_size` decimal(6, 2) DEFAULT NULL,
  MODIFY `other_localisation_2_size` decimal(6, 2) DEFAULT NULL,
  MODIFY `other_localisation_3_size` decimal(6, 2) DEFAULT NULL,
  MODIFY `total_liver_volume` decimal(6, 2) DEFAULT NULL,
  MODIFY `resected_liver_volume` decimal(6, 2) DEFAULT NULL,
  MODIFY `remnant_liver_volume` decimal(6, 2) DEFAULT NULL,
  MODIFY `tumoral_volume` decimal(6, 2) DEFAULT NULL;
ALTER TABLE qc_hb_ed_hepatobilary_medical_imagings_revs
  MODIFY `segment_1_size` decimal(6, 2) DEFAULT NULL,
  MODIFY `segment_2_size` decimal(6, 2) DEFAULT NULL,
  MODIFY `segment_3_size` decimal(6, 2) DEFAULT NULL,
  MODIFY `segment_4a_size` decimal(6, 2) DEFAULT NULL,
  MODIFY `segment_4b_size` decimal(6, 2) DEFAULT NULL,
  MODIFY `segment_5_size` decimal(6, 2) DEFAULT NULL,
  MODIFY `segment_6_size` decimal(6, 2) DEFAULT NULL,
  MODIFY `segment_7_size` decimal(6, 2) DEFAULT NULL,
  MODIFY `segment_8_size` decimal(6, 2) DEFAULT NULL,
  MODIFY `lungs_size` decimal(6, 2) DEFAULT NULL,
  MODIFY `lymph_node_size` decimal(6, 2) DEFAULT NULL,
  MODIFY `colon_size` decimal(6, 2) DEFAULT NULL,
  MODIFY `rectum_size` decimal(6, 2) DEFAULT NULL,
  MODIFY `bones_size` decimal(6, 2) DEFAULT NULL,
  MODIFY `other_localisation_1_size` decimal(6, 2) DEFAULT NULL,
  MODIFY `other_localisation_2_size` decimal(6, 2) DEFAULT NULL,
  MODIFY `other_localisation_3_size` decimal(6, 2) DEFAULT NULL,
  MODIFY `total_liver_volume` decimal(6, 2) DEFAULT NULL,
  MODIFY `resected_liver_volume` decimal(6, 2) DEFAULT NULL,
  MODIFY `remnant_liver_volume` decimal(6, 2) DEFAULT NULL,
  MODIFY `tumoral_volume` decimal(6, 2) DEFAULT NULL; 
UPDATE structure_fields SET type = 'float_positive' WHERE tablename = 'qc_hb_ed_hepatobilary_medical_imagings' AND field IN (
'segment_1_size',
'segment_2_size',
'segment_3_size',
'segment_4a_size',
'segment_4b_size',
'segment_5_size',
'segment_6_size',
'segment_7_size',
'segment_8_size',
'lungs_size',
'lymph_node_size',
'colon_size',
'rectum_size',
'bones_size',
'other_localisation_1_size',
'other_localisation_2_size',
'other_localisation_3_size',
'total_liver_volume',
'resected_liver_volume',
'remnant_liver_volume',
'tumoral_volume');

-- ------------------------------------------------------------------------
-- Following lines executed on server on 2012-01-18 after migration
-- ------------------------------------------------------------------------

DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_ident_summary') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='' AND `model`='FunctionManagement' AND `tablename`='' AND `field`='hepato_bil_bank_participant_id' AND `language_label`='hepato_bil_bank_participant_id' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');

UPDATE aliquot_masters am, clinical_collection_links lk, participants par
SET am.aliquot_label = replace(am.aliquot_label, ' - n/a ', CONCAT(' - ',par.participant_identifier,' '))
WHERE lk.collection_id = am.collection_id AND par.id = lk.participant_id
AND am.aliquot_label LIKE '% - n/a%';

UPDATE aliquot_masters_revs rev, aliquot_masters src
SET rev.aliquot_label = src.aliquot_label
WHERE rev.id = src.id
AND rev.aliquot_label != src.aliquot_label

-- ------------------------------------------------------------------------
-- Following lines executed on server on 2012-02-10 after migration
-- ------------------------------------------------------------------------

ALTER TABLE qc_hb_ed_hepatobilary_medical_imagings
 ADD COLUMN `pancreas_number` smallint(5) unsigned DEFAULT NULL AFTER metastatic_lymph_nodes,
 ADD COLUMN `pancreas_size` decimal(6,2) DEFAULT NULL AFTER pancreas_number;
ALTER TABLE qc_hb_ed_hepatobilary_medical_imagings_revs
 ADD COLUMN `pancreas_number` smallint(5) unsigned DEFAULT NULL AFTER metastatic_lymph_nodes,
 ADD COLUMN `pancreas_size` decimal(6,2) DEFAULT NULL AFTER pancreas_number;

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_medical_imagings', 'pancreas_size', 'float_positive',  NULL , '0', 'size=5', '', '', 'size (cm)', ''),
('Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_medical_imagings', 'pancreas_number', 'integer_positive',  NULL , '0', 'size=5', '', '', 'number', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='qc_hb_pancreas'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_hb_ed_hepatobilary_medical_imagings' AND `field`='pancreas_number' AND `type`='integer_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5'), '2', '108', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '1'),
((SELECT id FROM structures WHERE alias='qc_hb_pancreas'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_hb_ed_hepatobilary_medical_imagings' AND `field`='pancreas_size' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5'), '2', '109', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '1');

REPLACE INTO i18n (id,en,fr) VALUES ('type of drain 1','Type of drain 1','Type de drain 1');

INSERT INTO `menus` (`id`, `parent_id`, `is_root`, `display_order`, `language_title`, `language_description`, `use_link`, `use_summary`, `flag_active`) VALUES
('clin_CAN_1_qc_hb_15', 'clin_CAN_4', 0, 2, 'medical imagery', NULL, '/clinicalannotation/event_masters/listall/imagery/%%Participant.id%%', 'Clinicalannotation.EventMaster::summary', 1),
('clin_CAN_1_qc_hb_16', 'clin_CAN_4', 0, 2, 'medical history', NULL, '/clinicalannotation/event_masters/listall/medical_history/%%Participant.id%%', 'Clinicalannotation.EventMaster::summary', 1);

UPDATE `event_controls` SET event_group = 'medical_history' WHERE `detail_tablename` LIKE 'qc_hb_ed_hepatobiliary_medical_past_histor%';
UPDATE `event_controls` SET event_group = 'imagery' WHERE `detail_tablename` LIKE 'qc_hb_ed_hepatobilary_medical_imagings';
UPDATE `event_controls` SET event_group = 'medical_history' WHERE `detail_tablename` LIKE 'qc_hb_ed_hepatobiliary_med_hist_record_summaries';
UPDATE `event_controls` SET event_group = 'imagery' WHERE `detail_tablename` LIKE 'qc_hb_ed_medical_imaging_record_summaries';
UPDATE event_controls SET databrowser_label = CONCAT(event_group ,'|',event_type);

INSERT IGNORE INTO i18n (id,en,fr) VALUES 
('hospitalization','Hospitalization','Hospitalisation'),
('medical_history','Medical History','Histoire Médicale'),
('medical history','Medical History','Histoire Médicale'),
('medical imagery','Imagery','Imagerie'),
('imagery','Imagery','Imagerie');

-- Diag & Metastase rebuild

UPDATE diagnosis_controls SET controls_type = 'other' WHERE category = 'secondary' AND controls_type = 'undetailed';
INSERT INTO `diagnosis_controls` (`id`, `category`, `controls_type`, `flag_active`, `form_alias`, `detail_tablename`, `display_order`, `databrowser_label`, `flag_compare_with_cap`) VALUES
(null, 'primary', 'tissue', 1, 'diagnosismasters,dx_primary,qc_hb_dx_tissues', 'dxd_tissues', 0, '', 1),
(null, 'primary', 'other', 1, 'diagnosismasters,dx_primary', 'dxd_primaries', 0, '', 1);
UPDATE diagnosis_controls SET databrowser_label = CONCAT(category ,'|',controls_type);

INSERT INTO structures(`alias`) VALUES ('qc_hb_dx_tissues');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='qc_hb_dx_tissues'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_tissues' AND `field`='laterality' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='laterality')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='dx_laterality' AND `language_label`='laterality' AND `language_tag`=''), '2', '99', 'tissue specific', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_hb_dx_tissues'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_nature' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='dx_nature')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_dx nature' AND `language_label`='dx nature' AND `language_tag`=''), '1', '8', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1');

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_primary') 
AND structure_field_id IN (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `field` IN ('topography', 'morphology', 'survival_time_months', 'information_source', 'dx_method'));

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_secondary') 
AND structure_field_id IN (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `field` IN ('topography', 'morphology', 'information_source', 'dx_method'));

INSERT INTO `event_controls` (`id`, `disease_site`, `event_group`, `event_type`, `flag_active`, `form_alias`, `detail_tablename`, `display_order`, `databrowser_label`) VALUES
(null, 'hepatobiliary', 'lab', 'lab report - liver metastases', 1, 'eventmasters,qc_hb_ed_lab_report_liver_metastases', 'qc_hb_ed_lab_report_liver_metastases', 0, 'lab|lab report - liver metastases');

DROP TABLE IF EXISTS `qc_hb_ed_lab_report_liver_metastases`;
CREATE TABLE IF NOT EXISTS `qc_hb_ed_lab_report_liver_metastases` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `event_master_id` int(11) NOT NULL,
  
  `histologic_type` varchar(100) DEFAULT NULL,
  `histologic_type_specify` varchar(250) DEFAULT NULL,  
  	`necrosis_perc` decimal(3,1) DEFAULT NULL,
  	`viable_cells_perc` varchar(50) DEFAULT NULL,  
  	`lesions_nbr` int(6) DEFAULT NULL,
  `additional_dimension_a` decimal(3,1) DEFAULT NULL,
  `additional_dimension_b` decimal(3,1) DEFAULT NULL,
  `tumor_size_cannot_be_determined` tinyint(1) DEFAULT '0',
  `tumor_size_greatest_dimension` decimal(3,1) DEFAULT NULL,  	
  	`other_lesion_size_greatest_dimension` decimal(3,1) DEFAULT NULL,
  	`other_lesion_size_additional_dimension_a` decimal(3,1) DEFAULT NULL,
  	`other_lesion_size_additional_dimension_b` decimal(3,1) DEFAULT NULL,
  	`other_lesion_size_cannot_be_determined` tinyint(1) DEFAULT '0', 
  `tumor_site` varchar(50) DEFAULT NULL,
  `tumor_site_specify` varchar(250) DEFAULT NULL,  
	  `surgical_resection_margin` varchar(10) DEFAULT NULL,
	  `distance_of_tumor_from_closest_surgical_resection_margin` decimal(3,1) DEFAULT NULL,
	  `distance_unit` char(2) DEFAULT NULL,
	  `specify_margin` varchar(250) DEFAULT NULL,
	  `adjacent_liver_parenchyma` varchar(100) DEFAULT NULL,
	  `adjacent_liver_parenchyma_specify` varchar(250) DEFAULT NULL, 
  `notes` text,
  PRIMARY KEY (`id`),
  KEY `diagnosis_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

DROP TABLE IF EXISTS `qc_hb_ed_lab_report_liver_metastases_revs`;
CREATE TABLE IF NOT EXISTS `qc_hb_ed_lab_report_liver_metastases_revs` (
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `id` int(11) NOT NULL,
  `event_master_id` int(11) NOT NULL,
  
  `histologic_type` varchar(100) DEFAULT NULL,
  `histologic_type_specify` varchar(250) DEFAULT NULL,  
  	`necrosis_perc` decimal(3,1) DEFAULT NULL,
  	`viable_cells_perc` varchar(50) DEFAULT NULL,  
  	`lesions_nbr` int(6) DEFAULT NULL,
  `additional_dimension_a` decimal(3,1) DEFAULT NULL,
  `additional_dimension_b` decimal(3,1) DEFAULT NULL,
  `tumor_size_cannot_be_determined` tinyint(1) DEFAULT '0',
  `tumor_size_greatest_dimension` decimal(3,1) DEFAULT NULL,  	
  	`other_lesion_size_greatest_dimension` decimal(3,1) DEFAULT NULL,
  	`other_lesion_size_additional_dimension_a` decimal(3,1) DEFAULT NULL,
  	`other_lesion_size_additional_dimension_b` decimal(3,1) DEFAULT NULL,
  	`other_lesion_size_cannot_be_determined` tinyint(1) DEFAULT '0', 
  `tumor_site` varchar(50) DEFAULT NULL,
  `tumor_site_specify` varchar(250) DEFAULT NULL,  
	  `surgical_resection_margin` varchar(10) DEFAULT NULL,
	  `distance_of_tumor_from_closest_surgical_resection_margin` decimal(3,1) DEFAULT NULL,
	  `distance_unit` char(2) DEFAULT NULL,
	  `specify_margin` varchar(250) DEFAULT NULL,
	  `adjacent_liver_parenchyma` varchar(100) DEFAULT NULL,
	  `adjacent_liver_parenchyma_specify` varchar(250) DEFAULT NULL, 
  `notes` text,
  PRIMARY KEY (`version_id`),
  KEY `diagnosis_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

ALTER TABLE `qc_hb_ed_lab_report_liver_metastases`
  ADD CONSTRAINT `qc_hb_ed_lab_report_liver_metastases_ibfk_1` FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`);

INSERT INTO structures(`alias`) VALUES ('qc_hb_ed_lab_report_liver_metastases');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'EventDetail', 'qc_hb_ed_lab_report_liver_metastases', 'histologic_type', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_liver_metastasis_hitologic_type') , '0', '', '', '', 'histologic type', ''), 
('Clinicalannotation', 'EventDetail', 'qc_hb_ed_lab_report_liver_metastases', 'histologic_type_specify', 'input',  NULL , '0', '', '', '', 'histologic type specify', ''), 
('Clinicalannotation', 'EventDetail', 'qc_hb_ed_lab_report_liver_metastases', 'necrosis_perc', 'float',  NULL , '0', '', '', '', 'necrosis percentage', ''), 
('Clinicalannotation', 'EventDetail', 'qc_hb_ed_lab_report_liver_metastases', 'viable_cells_perc', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_viable_cells_perc') , '0', '', '', '', 'viable cells percentage', ''), 
('Clinicalannotation', 'EventDetail', 'qc_hb_ed_lab_report_liver_metastases', 'lesions_nbr', 'integer',  NULL , '0', '', '', '', 'lesions nbr', ''), 
('Clinicalannotation', 'EventDetail', 'qc_hb_ed_lab_report_liver_metastases', 'other_lesion_size_greatest_dimension', 'float',  NULL , '0', '', '', '', 'other lesion greatest dimension', ''), 
('Clinicalannotation', 'EventDetail', 'qc_hb_ed_lab_report_liver_metastases', 'other_lesion_size_additional_dimension_a', 'float',  NULL , '0', '', '', '', 'other lesion additional dimension a', ''), 
('Clinicalannotation', 'EventDetail', 'qc_hb_ed_lab_report_liver_metastases', 'other_lesion_size_additional_dimension_b', 'float',  NULL , '0', '', '', '', '', 'additional dimension b'), 
('Clinicalannotation', 'EventDetail', 'qc_hb_ed_lab_report_liver_metastases', 'other_lesion_size_cannot_be_determined', 'checkbox', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '0', '', '', '', 'other lesion cannot be determined', ''), 
('Clinicalannotation', 'EventDetail', 'qc_hb_ed_lab_report_liver_metastases', 'tumor_site', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_liver_metastasis_tumor_site') , '0', '', '', '', 'tumor site', ''), 
('Clinicalannotation', 'EventDetail', 'qc_hb_ed_lab_report_liver_metastases', 'tumor_site_specify', 'input',  NULL , '0', '', '', '', 'tumor site specify', ''), 
('Clinicalannotation', 'EventDetail', 'qc_hb_ed_lab_report_liver_metastases', 'surgical_resection_margin', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_positive_negative') , '0', '', '', '', 'surgical resection margin', ''), 
('Clinicalannotation', 'EventDetail', 'qc_hb_ed_lab_report_liver_metastases', 'distance_of_tumor_from_closest_surgical_resection_margin', 'float',  NULL , '0', '', '', '', 'distance of tumor from closest surgical resection margin', ''), 
('Clinicalannotation', 'EventDetail', 'qc_hb_ed_lab_report_liver_metastases', 'distance_unit', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='distance_unit') , '0', '', '', '', '', ''), 
('Clinicalannotation', 'EventDetail', 'qc_hb_ed_lab_report_liver_metastases', 'specify_margin', 'input',  NULL , '0', '', '', '', '', 'specify margin'), 
('Clinicalannotation', 'EventDetail', 'qc_hb_ed_lab_report_liver_metastases', 'adjacent_liver_parenchyma', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_adjacent_liver_parenchyma') , '0', '', '', '', 'adjacent liver parenchyma', ''), 
('Clinicalannotation', 'EventDetail', 'qc_hb_ed_lab_report_liver_metastases', 'adjacent_liver_parenchyma_specify', 'input',  NULL , '0', '', '', '', 'adjacent liver parenchyma specify', ''); 
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='qc_hb_ed_lab_report_liver_metastases'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_hb_ed_lab_report_liver_metastases' AND `field`='histologic_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_liver_metastasis_hitologic_type')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='histologic type' AND `language_tag`=''), '1', '1', 'histology', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='qc_hb_ed_lab_report_liver_metastases'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_hb_ed_lab_report_liver_metastases' AND `field`='histologic_type_specify' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='histologic type specify' AND `language_tag`=''), '1', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_hb_ed_lab_report_liver_metastases'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_hb_ed_lab_report_liver_metastases' AND `field`='necrosis_perc' AND `type`='float' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='necrosis percentage' AND `language_tag`=''), '1', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_hb_ed_lab_report_liver_metastases'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_hb_ed_lab_report_liver_metastases' AND `field`='viable_cells_perc' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_viable_cells_perc')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='viable cells percentage' AND `language_tag`=''), '1', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_hb_ed_lab_report_liver_metastases'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_hb_ed_lab_report_liver_metastases' AND `field`='lesions_nbr' AND `type`='integer' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='lesions nbr' AND `language_tag`=''), '1', '5', 'lesions', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='qc_hb_ed_lab_report_liver_metastases'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='' AND `field`='tumor_size_greatest_dimension'), '1', '6', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_hb_ed_lab_report_liver_metastases'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='' AND `field`='additional_dimension_a'), '1', '7', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_hb_ed_lab_report_liver_metastases'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='' AND `field`='additional_dimension_b'), '1', '8', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_hb_ed_lab_report_liver_metastases'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='' AND `field`='tumor_size_cannot_be_determined'), '1', '9', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_hb_ed_lab_report_liver_metastases'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_hb_ed_lab_report_liver_metastases' AND `field`='other_lesion_size_greatest_dimension' AND `type`='float' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='other lesion greatest dimension' AND `language_tag`=''), '1', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_hb_ed_lab_report_liver_metastases'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_hb_ed_lab_report_liver_metastases' AND `field`='other_lesion_size_additional_dimension_a' AND `type`='float' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='other lesion additional dimension a' AND `language_tag`=''), '1', '11', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_hb_ed_lab_report_liver_metastases'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_hb_ed_lab_report_liver_metastases' AND `field`='other_lesion_size_additional_dimension_b' AND `type`='float' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='additional dimension b'), '1', '12', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_hb_ed_lab_report_liver_metastases'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_hb_ed_lab_report_liver_metastases' AND `field`='other_lesion_size_cannot_be_determined' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='other lesion cannot be determined' AND `language_tag`=''), '1', '13', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_hb_ed_lab_report_liver_metastases'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_hb_ed_lab_report_liver_metastases' AND `field`='tumor_site' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_liver_metastasis_tumor_site')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tumor site' AND `language_tag`=''), '1', '15', 'tumor site', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='qc_hb_ed_lab_report_liver_metastases'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_hb_ed_lab_report_liver_metastases' AND `field`='tumor_site_specify' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tumor site specify' AND `language_tag`=''), '1', '16', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_hb_ed_lab_report_liver_metastases'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_hb_ed_lab_report_liver_metastases' AND `field`='surgical_resection_margin' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_positive_negative')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='surgical resection margin' AND `language_tag`=''), '1', '25', 'margins', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='qc_hb_ed_lab_report_liver_metastases'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_hb_ed_lab_report_liver_metastases' AND `field`='distance_of_tumor_from_closest_surgical_resection_margin' AND `type`='float' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='distance of tumor from closest surgical resection margin' AND `language_tag`=''), '1', '26', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_hb_ed_lab_report_liver_metastases'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_hb_ed_lab_report_liver_metastases' AND `field`='distance_unit' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='distance_unit')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`=''), '1', '27', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_hb_ed_lab_report_liver_metastases'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_hb_ed_lab_report_liver_metastases' AND `field`='specify_margin' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='specify margin'), '1', '28', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_hb_ed_lab_report_liver_metastases'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_hb_ed_lab_report_liver_metastases' AND `field`='adjacent_liver_parenchyma' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_hb_adjacent_liver_parenchyma')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='adjacent liver parenchyma' AND `language_tag`=''), '1', '40', 'parenchyma', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='qc_hb_ed_lab_report_liver_metastases'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_hb_ed_lab_report_liver_metastases' AND `field`='adjacent_liver_parenchyma_specify' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='adjacent liver parenchyma specify' AND `language_tag`=''), '1', '41', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_hb_ed_lab_report_liver_metastases'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='' AND `field`='notes'), '1', '44', 'other', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');

REPLACE INTO i18n (id,en,fr) VALUES ('other lesion additional dimension a', 'Other Lesion - Additional Dimension', 'Dimension supplémentaire - Autre lésion');
REPLACE INTO i18n (id,en,fr) VALUES ('additional dimension b', 'x', 'x');

ALTER TABLE qc_hb_dxd_liver_metastases
	DROP COLUMN histologic_type,
	DROP COLUMN histologic_type_specify,
	DROP COLUMN lesions_nbr,
	DROP COLUMN other_lesion_size_greatest_dimension,
	DROP COLUMN other_lesion_size_additional_dimension_a,
	DROP COLUMN other_lesion_size_additional_dimension_b,
	DROP COLUMN other_lesion_size_cannot_be_determined,
	DROP COLUMN tumor_site,
	DROP COLUMN tumor_site_specify,
	DROP COLUMN necrosis_perc,
	DROP COLUMN viable_cells_perc,
	DROP COLUMN surgical_resection_margin,
	DROP COLUMN distance_of_tumor_from_closest_surgical_resection_margin,
	DROP COLUMN distance_unit,
	DROP COLUMN specify_margin,
	DROP COLUMN adjacent_liver_parenchyma,
	DROP COLUMN adjacent_liver_parenchyma_specify;
ALTER TABLE qc_hb_dxd_liver_metastases_revs
	DROP COLUMN histologic_type,
	DROP COLUMN histologic_type_specify,
	DROP COLUMN lesions_nbr,
	DROP COLUMN other_lesion_size_greatest_dimension,
	DROP COLUMN other_lesion_size_additional_dimension_a,
	DROP COLUMN other_lesion_size_additional_dimension_b,
	DROP COLUMN other_lesion_size_cannot_be_determined,
	DROP COLUMN tumor_site,
	DROP COLUMN tumor_site_specify,
	DROP COLUMN necrosis_perc,
	DROP COLUMN viable_cells_perc,
	DROP COLUMN surgical_resection_margin,
	DROP COLUMN distance_of_tumor_from_closest_surgical_resection_margin,
	DROP COLUMN distance_unit,
	DROP COLUMN specify_margin,
	DROP COLUMN adjacent_liver_parenchyma,
	DROP COLUMN adjacent_liver_parenchyma_specify;

UPDATE diagnosis_controls SET form_alias = 'diagnosismasters,dx_secondary' WHERE detail_tablename = 'qc_hb_dxd_liver_metastases'; 

ALTER TABLE qc_hb_ed_lab_report_liver_metastases
  ADD COLUMN `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0' AFTER notes;

INSERT INTO i18n (id,en,fr) VALUES ('lab report - liver metastases','Lab Report - Liver Metastases','Rapport Lab - Métastases hépatiques');
  
REPLACE INTO i18n (id,en,fr) VALUES 
('other lesion additional dimension a', 'Other Lesion - Additional Dimension (cm)', 'Autre lésion - Dimension supplémentaire (cm)');
('other lesion cannot be determined', 'Other Lesion - Cannot Be Determined', 'Autre lésion - Ne peut être déterminée');
('other lesion greatest dimension', 'Other Lesion - Tumor Size Greatest Dimension (cm)', 'Autre lésion - Plus grande dimension de la tumeur (cm)');

-- ------------------------------------------------------------------------
-- Following lines executed on server on 2012-03-19 after migration
-- ------------------------------------------------------------------------

ALTER TABLE qc_hb_ed_hepatobilary_medical_imagings
  ADD COLUMN normal_result char(1) NOT NULL DEFAULT '';
ALTER TABLE qc_hb_ed_hepatobilary_medical_imagings_revs
  ADD COLUMN normal_result char(1) NOT NULL DEFAULT '';  
  
INSERT INTO structures(`alias`) VALUES ('qc_hb_imaging_result');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobilary_medical_imagings', 'normal_result', 'yes_no',  NULL , '0', '', '', '', 'normal', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='qc_hb_imaging_result'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_hb_ed_hepatobilary_medical_imagings' AND `field`='normal_result' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='normal' AND `language_tag`=''), '1', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '1');

UPDATE event_controls SET form_alias = CONCAT (form_alias, ',qc_hb_imaging_result') 
WHERE event_group = 'imagery' AND detail_tablename = 'qc_hb_ed_hepatobilary_medical_imagings' 
AND event_type NOT IN ('medical imaging doppler ultrasound',
'medical imaging ERCP',
'medical imaging transhepatic cholangiography',
'medical imaging HIDA scan');

ALTER TABLE qc_hb_ed_hepatobiliary_lifestyles
  ADD COLUMN drugs text;
ALTER TABLE qc_hb_ed_hepatobiliary_lifestyles_revs
  ADD COLUMN drugs text; 

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'EventDetail', 'qc_hb_ed_hepatobiliary_lifestyles', 'drugs', 'textarea',  NULL , '0', '', '', '', 'drugs', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='qc_hb_ed_hepatobiliary_lifestyle'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_hb_ed_hepatobiliary_lifestyles' AND `field`='drugs' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='drugs' AND `language_tag`=''), '1', '12', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1');
UPDATE structure_fields SET  `setting`='cols=40,rows=6' WHERE model='EventDetail' AND tablename='qc_hb_ed_hepatobiliary_lifestyles' AND field='drugs' AND `type`='textarea' AND structure_value_domain  IS NULL ;

UPDATE diagnosis_controls SET flag_compare_with_cap = '0';

UPDATE structure_formats SET `flag_edit_readonly`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='pd_chemos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ProtocolMaster' AND `tablename`='protocol_masters' AND `field`='code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- ------------------------------------------------------------------------
-- Following lines executed on server on 2012-03-27 after migration
-- ------------------------------------------------------------------------

ALTER TABLE qc_hb_ed_hepatobiliary_lifestyles
	MODIFY drugs char(1) NOT NULL DEFAULT '';
ALTER TABLE qc_hb_ed_hepatobiliary_lifestyles_revs
	MODIFY drugs char(1) NOT NULL DEFAULT '';

UPDATE structure_fields SET type = 'yes_no',setting='' WHERE tablename = 'qc_hb_ed_hepatobiliary_lifestyles' AND field = 'drugs'; 










  