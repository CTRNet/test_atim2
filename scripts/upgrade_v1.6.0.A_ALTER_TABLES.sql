-- Rename all occurances of `group` field

ALTER TABLE `coding_icd10` CHANGE `group` `icd_group` VARCHAR( 50 ) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL;
ALTER TABLE `tx_masters` CHANGE `group` `tx_group` VARCHAR( 50 ) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL;

UPDATE `structure_fields` SET `field` = 'tx_group',
`structure_value_domain` = '0' WHERE `old_id` = 'CAN-999-999-000-999-276' LIMIT 1 ;

-- Drop depricated table/field alias columns from tx_masters
ALTER TABLE `tx_masters` CHANGE `tx_control_id` `treatment_control_id` INT(11) NOT NULL DEFAULT 0;
ALTER TABLE `tx_masters` DROP COLUMN `detail_tablename`;
ALTER TABLE `tx_masters` DROP COLUMN `detail_form_alias`;
ALTER TABLE `tx_masters` DROP COLUMN `extend_tablename`;
ALTER TABLE `tx_masters` DROP COLUMN `extend_form_alias`;
ALTER TABLE `tx_controls` CHANGE `detail_form_alias` `form_alias` varchar(255) character set latin1 default NULL;

-- Add deleted and deleted_by columns to the correct tables

SET FOREIGN_KEY_CHECKS=0;

ALTER TABLE `ad_blocks`

ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_date` datetime default NULL;

ALTER TABLE `ad_cell_cores`

ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_date` datetime default NULL;

ALTER TABLE `ad_cell_slides`

ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_date` datetime default NULL;

ALTER TABLE `ad_cell_tubes`

ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_date` datetime default NULL;

ALTER TABLE `ad_gel_matrices`

ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_date` datetime default NULL;

ALTER TABLE `ad_tissue_cores`

ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_date` datetime default NULL;

ALTER TABLE `ad_tissue_slides`

ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_date` datetime default NULL;

ALTER TABLE `ad_tubes`

ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_date` datetime default NULL;

ALTER TABLE `ad_whatman_papers`

ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_date` datetime default NULL;

ALTER TABLE `aliquot_controls`

ADD COLUMN `display_order` int(11) NOT NULL default 0;

ALTER TABLE `aliquot_masters`

ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_date` datetime default NULL,
MODIFY COLUMN `aliquot_control_id` int(11) NOT NULL default 0;

ALTER TABLE `aliquot_uses`

ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_date` datetime default NULL;

ALTER TABLE `banks`

ADD COLUMN `created_by` int(11) default NULL AFTER `description`,
ADD COLUMN `modified_by` int(11) default NULL AFTER `created`,
ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_date` datetime default NULL;

ALTER TABLE `clinical_collection_links`
CHANGE `participant_id` `participant_id` INT( 11 ) NULL DEFAULT NULL,
CHANGE `diagnosis_id` `diagnosis_id` INT( 11 ) NULL DEFAULT NULL,
CHANGE `consent_id` `consent_id` INT( 11 ) NULL DEFAULT NULL,
ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_date` datetime default NULL;

UPDATE `clinical_collection_links`
SET `consent_id` = NULL
WHERE `consent_id` = '0';

UPDATE `clinical_collection_links`
SET `participant_id` = NULL
WHERE `participant_id` = '0';

UPDATE `clinical_collection_links`
SET `diagnosis_id` = NULL
WHERE `diagnosis_id` = '0';

ALTER TABLE `coding_adverse_events`

ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_date` datetime default NULL;

ALTER TABLE `coding_icd10`

ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_date` datetime default NULL;

ALTER TABLE `collections`

ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_date` datetime default NULL,
CHANGE COLUMN `bank` `bank_id` INT(11) default NULL;

ALTER TABLE `consents`

ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_date` datetime default NULL,
ADD COLUMN `recruit_route` VARCHAR(10) default NULL;

ALTER TABLE `derivative_details`

ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_date` datetime default NULL;

ALTER TABLE `diagnoses`

ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_date` datetime default NULL;

ALTER TABLE `drugs`

ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_date` datetime default NULL;

ALTER TABLE `ed_all_adverse_events_adverse_event`

ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_date` datetime default NULL;

ALTER TABLE `ed_all_clinical_followup`

ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_date` datetime default NULL;

ALTER TABLE `ed_all_clinical_presentation`

ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_date` datetime default NULL;

ALTER TABLE `ed_all_lifestyle_base`

ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_date` datetime default NULL;

ALTER TABLE `ed_all_protocol_followup`

ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_date` datetime default NULL;

ALTER TABLE `ed_all_study_research`

ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_date` datetime default NULL;

ALTER TABLE `ed_allsolid_lab_pathology`

ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_date` datetime default NULL;

ALTER TABLE `ed_breast_lab_pathology`

ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_date` datetime default NULL;

ALTER TABLE `ed_breast_screening_mammogram`

ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_date` datetime default NULL;

ALTER TABLE `event_controls`

ADD COLUMN `display_order` int(11) NOT NULL default 0;

ALTER TABLE `event_masters`

ADD COLUMN `event_control_id` int(11) NOT NULL default 0 AFTER `id`,
ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_date` datetime default NULL;

ALTER TABLE `family_histories`

ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_date` datetime default NULL;

ALTER TABLE `groups`

DROP COLUMN `level`,
DROP COLUMN `redirect`,
DROP COLUMN `perm_type`,
DROP COLUMN `created_by`,
DROP COLUMN `modified_by`;

ALTER TABLE `i18n`

ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_date` datetime default NULL;

ALTER TABLE `materials`

ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_date` datetime default NULL;

ALTER TABLE `misc_identifiers`

ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_date` datetime default NULL;

ALTER TABLE `order_items`

ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_date` datetime default NULL;

ALTER TABLE `order_lines`

ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_date` datetime default NULL;

ALTER TABLE `orders`

ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_date` datetime default NULL;

ALTER TABLE `participant_contacts`

ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_date` datetime default NULL;

ALTER TABLE `participant_messages`

ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_date` datetime default NULL;

ALTER TABLE `participants`

ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_date` datetime default NULL;

ALTER TABLE `path_collection_reviews`

ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_date` datetime default NULL;

ALTER TABLE `pd_chemos`

ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_date` datetime default NULL;

ALTER TABLE `pe_chemos`

ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_date` datetime default NULL;

ALTER TABLE `protocol_controls`

ADD `display_order` int(11) NOT NULL default 0;

ALTER TABLE `protocol_masters`

ADD COLUMN `protocol_control_id` int(11) NOT NULL default 0 AFTER `id`,
ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_date` datetime default NULL,
MODIFY COLUMN `type` VARCHAR(50) NOT NULL default '';

ALTER TABLE `qc_tested_aliquots`

ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_date` datetime default NULL;

ALTER TABLE `rd_blood_cells`

ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_date` datetime default NULL;

ALTER TABLE `rd_bloodcellcounts`

ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_date` datetime default NULL;

ALTER TABLE `rd_breast_cancers`

ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_date` datetime default NULL;

ALTER TABLE `rd_breastcancertypes`

ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_date` datetime default NULL;

ALTER TABLE `rd_coloncancertypes`

ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_date` datetime default NULL;

ALTER TABLE `rd_genericcancertypes`

ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_date` datetime default NULL;

ALTER TABLE `rd_ovarianuteruscancertypes`

ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_date` datetime default NULL;

ALTER TABLE `realiquotings`

ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_date` datetime default NULL;

ALTER TABLE `reproductive_histories`

ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_date` datetime default NULL;

ALTER TABLE `review_controls`

ADD COLUMN `display_order` int(11) NOT NULL default 0;

ALTER TABLE `review_masters`

ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_date` datetime default NULL,
MODIFY COLUMN `review_control_id` int(11) NOT NULL default 0;

ALTER TABLE `rtbforms`

ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_date` datetime default NULL;

ALTER TABLE `sample_controls`

ADD COLUMN `display_order` int(11) NOT NULL default 0;

ALTER TABLE `sample_masters`

ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_date` datetime default NULL,
MODIFY COLUMN `sample_control_id` int(11) NOT NULL default 0;

ALTER TABLE `sd_der_cell_cultures`

ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_date` datetime default NULL;

ALTER TABLE `sd_der_plasmas`

ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_date` datetime default NULL;

ALTER TABLE `sd_spe_ascites`

ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_date` datetime default NULL;

ALTER TABLE `sd_spe_bloods`

ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_date` datetime default NULL;

ALTER TABLE `sd_spe_cystic_fluids`

ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_date` datetime default NULL;

ALTER TABLE `sd_spe_other_fluids`

ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_date` datetime default NULL;

ALTER TABLE `sd_spe_peritoneal_washes`

ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_date` datetime default NULL;

ALTER TABLE `sd_spe_tissues`

ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_date` datetime default NULL;

ALTER TABLE `sd_spe_urines`

ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_date` datetime default NULL;

ALTER TABLE `shelves`

ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_date` datetime default NULL;

ALTER TABLE `shipments`

ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_date` datetime default NULL;

ALTER TABLE `sop_controls`

ADD COLUMN `display_order` int(11) NOT NULL default 0;

ALTER TABLE `sop_masters`

ADD COLUMN `sop_control_id` int(11) NOT NULL default 0 AFTER `id`,
ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_date` datetime default NULL;

ALTER TABLE `sopd_general_all`

ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_date` datetime default NULL;

ALTER TABLE `sope_general_all`

ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_date` datetime default NULL;

ALTER TABLE `source_aliquots`

ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_date` datetime default NULL;

ALTER TABLE `specimen_details`

ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_date` datetime default NULL;

ALTER TABLE `std_incubators`
ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_date` datetime default NULL;

ALTER TABLE `std_rooms`

ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_date` datetime default NULL;

ALTER TABLE `std_tma_blocks`

ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_date` datetime default NULL;

ALTER TABLE `storage_controls`

ADD COLUMN `display_order` int(11) NOT NULL default 0;

ALTER TABLE `storage_coordinates`

ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_date` datetime default NULL;

ALTER TABLE `storage_masters`

ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_date` datetime default NULL,
MODIFY COLUMN `storage_control_id` int(11) NOT NULL default 0;

ALTER TABLE `study_contacts`

ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_date` datetime default NULL;

ALTER TABLE `study_ethicsboards`

ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_date` datetime default NULL;
RENAME TABLE `study_ethicsboards` TO `study_ethics_boards`;

ALTER TABLE `study_fundings`

ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_date` datetime default NULL;

ALTER TABLE `study_investigators`

ADD COLUMN `email` varchar(45) default NULL AFTER `sort`,
ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_date` datetime default NULL;

ALTER TABLE `study_related`

ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_date` datetime default NULL;

ALTER TABLE `study_results`

ADD COLUMN `result_date` datetime default NULL after `future`,
ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_date` datetime default NULL;

ALTER TABLE `study_reviews`

ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_date` datetime default NULL;

ALTER TABLE `study_summaries`

ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_date` datetime default NULL;

ALTER TABLE `tma_slides`

ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_date` datetime default NULL;

ALTER TABLE `towers`

ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_date` datetime default NULL;

ALTER TABLE `tx_controls`

ADD COLUMN `display_order` int(11) NOT NULL default 0;

ALTER TABLE `tx_masters`

ADD COLUMN `tx_control_id` int(11) NOT NULL default 0 AFTER `id`,
ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_date` datetime default NULL;

ALTER TABLE `txd_chemos`

ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_date` datetime default NULL;

ALTER TABLE `txd_combos`

ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_date` datetime default NULL;

ALTER TABLE `txd_radiations`

ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_date` datetime default NULL;

ALTER TABLE `txd_surgeries`

ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_date` datetime default NULL;


-- Update the structure_fields plugin field

  -- StorageLayout
  UPDATE `structure_fields` SET `plugin` = 'StorageLayout' WHERE `model` = 'Shelf';
  UPDATE `structure_fields` SET `plugin` = 'StorageLayout' WHERE `model` = 'Tower';
  UPDATE `structure_fields` SET `plugin` = 'StorageLayout' WHERE `model` = 'Box';
  UPDATE `structure_fields` SET `plugin` = 'StorageLayout' WHERE `model` = 'Storage';
  UPDATE `structure_fields` SET `plugin` = 'StorageLayout' WHERE `model` = 'StorageMaster';
  UPDATE `structure_fields` SET `plugin` = 'StorageLayout' WHERE `model` = 'StorageCoordinate';

  -- Administrate
  UPDATE `structure_fields` SET `plugin` = 'Administrate' WHERE `model` = 'Bank';
  UPDATE `structure_fields` SET `plugin` = 'Administrate' WHERE `model` = 'Menu';
  UPDATE `structure_fields` SET `plugin` = 'Administrate' WHERE `model` = 'User';
  UPDATE `structure_fields` SET `plugin` = 'Administrate' WHERE `model` = 'UserLog';
  UPDATE `structure_fields` SET `plugin` = 'Administrate' WHERE `model` = 'Announcement';
  UPDATE `structure_fields` SET `plugin` = 'Administrate' WHERE `model` = 'Group';

  -- Rtbforms
  UPDATE `structure_fields` SET `plugin` = 'Rtbform' WHERE `model` = 'RtbForm';

  -- Drug
  UPDATE `structure_fields` SET `plugin` = 'Drug' WHERE `model` = 'Drug';

  -- Material
  UPDATE `structure_fields` SET `plugin` = 'Material' WHERE `model` = 'Model';

  -- Clinical Annotation
  UPDATE `structure_fields` SET `plugin` = 'ClinicalAnnotation' WHERE `model` = 'MiscIdentifier';
  UPDATE `structure_fields` SET `plugin` = 'ClinicalAnnotation' WHERE `model` = 'EventDetail';
  UPDATE `structure_fields` SET `plugin` = 'ClinicalAnnotation' WHERE `model` = 'ReproductiveHistory';
  UPDATE `structure_fields` SET `plugin` = 'ClinicalAnnotation' WHERE `model` = 'Consent';
  UPDATE `structure_fields` SET `plugin` = 'ClinicalAnnotation' WHERE `model` = 'Diagnosis';
  UPDATE `structure_fields` SET `plugin` = 'ClinicalAnnotation' WHERE `model` = 'Participant';
  UPDATE `structure_fields` SET `plugin` = 'ClinicalAnnotation' WHERE `model` = 'ParticipantMessage';
  UPDATE `structure_fields` SET `plugin` = 'ClinicalAnnotation' WHERE `model` = 'ClinicalCollectionLink';
  UPDATE `structure_fields` SET `plugin` = 'ClinicalAnnotation' WHERE `model` = 'EventMaster';
  UPDATE `structure_fields` SET `plugin` = 'ClinicalAnnotation' WHERE `model` = 'FamilyHistory';
  UPDATE `structure_fields` SET `plugin` = 'ClinicalAnnotation' WHERE `model` = 'TreatmentMaster';
  UPDATE `structure_fields` SET `plugin` = 'ClinicalAnnotation' WHERE `model` = 'TreatmentDetail';
  UPDATE `structure_fields` SET `plugin` = 'ClinicalAnnotation' WHERE `model` = 'TreatmentExtend';
  UPDATE `structure_fields` SET `plugin` = 'ClinicalAnnotation' WHERE `model` = 'ParticipantContact';

  -- Inventory Management
  UPDATE `structure_fields` SET `plugin` = 'InventoryManagement' WHERE `model` = 'Aliquot';
  UPDATE `structure_fields` SET `plugin` = 'InventoryManagement' WHERE `model` = 'ReviewMaster';
  UPDATE `structure_fields` SET `plugin` = 'InventoryManagement' WHERE `model` = 'ReviewDetail';
  UPDATE `structure_fields` SET `plugin` = 'InventoryManagement' WHERE `model` = 'Collection';
  UPDATE `structure_fields` SET `plugin` = 'InventoryManagement' WHERE `model` = 'SampleMaster';
  UPDATE `structure_fields` SET `plugin` = 'InventoryManagement' WHERE `model` = 'SpecimenDetail';
  UPDATE `structure_fields` SET `plugin` = 'InventoryManagement' WHERE `model` = 'SampleDetail';
  UPDATE `structure_fields` SET `plugin` = 'InventoryManagement' WHERE `model` = 'DerivativeDetail';
  UPDATE `structure_fields` SET `plugin` = 'InventoryManagement' WHERE `model` = 'AliquotMaster';
  UPDATE `structure_fields` SET `plugin` = 'InventoryManagement' WHERE `model` = 'SampleMaster';
  UPDATE `structure_fields` SET `plugin` = 'InventoryManagement' WHERE `model` = 'AliquotDetail';
  UPDATE `structure_fields` SET `plugin` = 'InventoryManagement' WHERE `model` = 'AliquotUse';
  UPDATE `structure_fields` SET `plugin` = 'InventoryManagement' WHERE `model` = 'PathCollectionReview';
  UPDATE `structure_fields` SET `plugin` = 'InventoryManagement' WHERE `model` = 'AliquotDetail';
  UPDATE `structure_fields` SET `plugin` = 'InventoryManagement' WHERE `model` = 'QualityControl';
  UPDATE `structure_fields` SET `plugin` = 'InventoryManagement' WHERE `model` = 'AliquotDetail';
  UPDATE `structure_fields` SET `plugin` = 'InventoryManagement' WHERE `model` = 'TmaSlide';
  UPDATE `structure_fields` SET `plugin` = 'InventoryManagement' WHERE `model` = 'Realiquoting';
  UPDATE `structure_fields` SET `plugin` = 'InventoryManagement' WHERE `model` = 'Sample';

  -- Order
  UPDATE `structure_fields` SET `plugin` = 'Order' WHERE `model` = 'OrderItem';
  UPDATE `structure_fields` SET `plugin` = 'Order' WHERE `model` = 'OrderLink';
  UPDATE `structure_fields` SET `plugin` = 'Order' WHERE `model` = 'Order';
  UPDATE `structure_fields` SET `plugin` = 'Order' WHERE `model` = 'Shipment';

  -- Study
  UPDATE `structure_fields` SET `plugin` = 'Study' WHERE `model` = 'StudySummary';
  UPDATE `structure_fields` SET `plugin` = 'Study' WHERE `model` = 'StudyContact';
  UPDATE `structure_fields` SET `plugin` = 'Study' WHERE `model` = 'StudyInvestigator';
  UPDATE `structure_fields` SET `plugin` = 'Study' WHERE `model` = 'StudyRelated';
  UPDATE `structure_fields` SET `plugin` = 'Study' WHERE `model` = 'StudyReview';
  UPDATE `structure_fields` SET `plugin` = 'Study' WHERE `model` = 'StudyEthicsBoard';
  UPDATE `structure_fields` SET `plugin` = 'Study' WHERE `model` = 'StudyFunding';

  -- Sop
  UPDATE `structure_fields` SET `plugin` = 'Sop' WHERE `model` = 'SopMaster';
  UPDATE `structure_fields` SET `plugin` = 'Sop' WHERE `model` = 'SopExtend';

  -- Protocol
  UPDATE `structure_fields` SET `plugin` = 'Protocol' WHERE `model` = 'ProtocolMaster';
  UPDATE `structure_fields` SET `plugin` = 'Protocol' WHERE `model` = 'ProtocolExtend';

  -- Datamart
  UPDATE `structure_fields` SET `plugin` = 'Datamart' WHERE `model` = 'Adhoc';
  UPDATE `structure_fields` SET `plugin` = 'Datamart' WHERE `model` = 'BatchSet';
  UPDATE `structure_fields` SET `plugin` = 'Datamart' WHERE `model` = 'AdhocSaved';

-- User structure changes

UPDATE `structure_fields` SET `field` = 'password' WHERE `old_id` = 'AAA-000-000-000-000-2';
UPDATE `structure_fields` SET `field` = 'name' WHERE `old_id` = 'AAA-000-000-000-000-34';
DELETE FROM `structure_fields` WHERE `old_id` = 'AAA-000-000-000-000-35';
DELETE FROM `structure_fields` WHERE `old_id` = 'AAA-000-000-000-000-37';
DELETE FROM `structure_fields` WHERE `old_id` = 'AAA-000-000-000-000-38';
DELETE FROM `structure_fields` WHERE `old_id` = 'AAA-000-000-000-000-39';
DELETE FROM `structure_fields` WHERE `old_id` = 'AAA-000-000-000-000-40';
DELETE FROM `structure_fields` WHERE `old_id` = 'AAA-000-000-000-000-43';
DELETE FROM `structure_fields` WHERE `old_id` = 'AAA-000-000-000-000-44';
DELETE FROM `structure_fields` WHERE `old_id` = 'AAA-000-000-000-000-45';
DELETE FROM `structure_fields` WHERE `old_id` = 'AAA-000-000-000-000-46';
DELETE FROM `structure_fields` WHERE `old_id` = 'AAA-000-000-000-000-47';
DELETE FROM `structure_fields` WHERE `old_id` = 'AAA-000-000-000-000-48';
DELETE FROM `structure_fields` WHERE `old_id` = 'AAA-000-000-000-000-49';
DELETE FROM `structure_formats` WHERE `structure_field_old_id` = 'AAA-000-000-000-000-35';
DELETE FROM `structure_formats` WHERE `structure_field_old_id` = 'AAA-000-000-000-000-37';
DELETE FROM `structure_formats` WHERE `structure_field_old_id` = 'AAA-000-000-000-000-38';
DELETE FROM `structure_formats` WHERE `structure_field_old_id` = 'AAA-000-000-000-000-39';
DELETE FROM `structure_formats` WHERE `structure_field_old_id` = 'AAA-000-000-000-000-40';
DELETE FROM `structure_formats` WHERE `structure_field_old_id` = 'AAA-000-000-000-000-43';
DELETE FROM `structure_formats` WHERE `structure_field_old_id` = 'AAA-000-000-000-000-44';
DELETE FROM `structure_formats` WHERE `structure_field_old_id` = 'AAA-000-000-000-000-45';
DELETE FROM `structure_formats` WHERE `structure_field_old_id` = 'AAA-000-000-000-000-46';
DELETE FROM `structure_formats` WHERE `structure_field_old_id` = 'AAA-000-000-000-000-47';
DELETE FROM `structure_formats` WHERE `structure_field_old_id` = 'AAA-000-000-000-000-48';
DELETE FROM `structure_formats` WHERE `structure_field_old_id` = 'AAA-000-000-000-000-49';

-- Structure changes

UPDATE `structures` SET `alias` = 'participantcontacts' WHERE `alias` = 'participant_contacts';
UPDATE `structures` SET `alias` = 'participantmessages' WHERE `alias` = 'participant_messages';
UPDATE `structures` SET `alias` = 'reproductivehistories' WHERE `alias` = 'reproductive_histories';
UPDATE `structures` SET `alias` = 'familyhistories' WHERE `alias` = 'family_histories';
UPDATE `structures` SET `alias` = 'miscidentifiers' WHERE `alias` = 'misc_identifiers';
UPDATE `structures` SET `alias` = 'studysummaries' WHERE `alias` = 'study_summaries';
UPDATE `structures` SET `alias` = 'pathcollectionreviews' WHERE `alias` = 'path_collection_reviews';
UPDATE `structures` SET `alias` = 'sopmasters' WHERE `alias` = 'sop_masters';
UPDATE `structures` SET `alias` = 'studycontacts' WHERE `alias` = 'study_contacts';
UPDATE `structures` SET `alias` = 'studyinvestigators' WHERE `alias` = 'study_investigators';
UPDATE `structures` SET `alias` = 'studyreviews' WHERE `alias` = 'study_reviews';
UPDATE `structures` SET `alias` = 'studyethicsboards' WHERE `alias` = 'study_ethicsboards';
UPDATE `structures` SET `alias` = 'studyfundings' WHERE `alias` = 'study_fundings';
UPDATE `structures` SET `alias` = 'studyresults' WHERE `alias` = 'study_results';
UPDATE `structures` SET `alias` = 'studyrelated' WHERE `alias` = 'study_related';
UPDATE `structures` SET `alias` = 'eventmasters' WHERE `alias` = 'event_masters';
UPDATE `structures` SET `language_title` = '' WHERE `old_id` = 'CAN-999-999-000-999-1024' AND `alias` = 'ad_spec_tubes_incl_ml_vol';

-- Bank field change

UPDATE `structure_fields` SET `field` = 'bank_id' WHERE `field` = 'bank' AND `model` = 'Collection';

-- Order Plugin changes

UPDATE `structure_fields` SET `field` = 'shipping_company', `language_label` = 'ord_shipping_company' WHERE `old_id` = 'CAN-999-999-000-999-510';

-- Drop unneeded diagnosis text area's
DELETE FROM `structure_formats`
WHERE `old_id` IN ('CAN-999-999-000-999-28_CAN-999-999-000-999-522',
				   'CAN-999-999-000-999-30_CAN-999-999-000-999-522',
				   'CAN-999-999-000-999-31_CAN-999-999-000-999-522', 
				   'CAN-999-999-000-999-42_CAN-999-999-000-999-522', 
				   'CAN-999-999-000-999-50_CAN-999-999-000-999-522',
				   'CAN-999-999-000-999-64_CAN-999-999-000-999-522');