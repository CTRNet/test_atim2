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
				   
-- Storage Management Plugin changes

-- DELETE storage position into
DELETE FROM `structure_formats` WHERE `structure_formats`.`old_id` IN ('CAN-999-999-000-999-1045_CAN-999-999-000-999-1204', 'CAN-999-999-000-999-1046_CAN-999-999-000-999-1204');

-- Coord X

UPDATE `structure_fields` SET `language_label` = 'position', `language_help` = 'define storage position description' WHERE `structure_fields`.`old_id` = 'CAN-999-999-000-999-1206' ;

-- Delete duplicated form field: StorageMaster.barcode

UPDATE `structure_formats` 
SET `structure_field_id` = (SELECT `id` FROM `structure_fields` WHERE `old_id` LIKE 'CAN-999-999-000-999-1183'),
`structure_field_old_id` = 'CAN-999-999-000-999-1183',
`old_id` = 'CAN-999-999-000-999-1060_CAN-999-999-000-999-1183'
WHERE `structure_old_id` = 'CAN-999-999-000-999-1060'
AND `structure_field_old_id` = 'CAN-999-999-000-999-1182';

DELETE FROM `structure_formats` WHERE `structure_field_old_id` = 'CAN-999-999-000-999-1182';

UPDATE `structure_formats`
SET `flag_add` = '1',
`flag_add_readonly` = '0',
`flag_edit` = '1',
`flag_edit_readonly` = '1',
`flag_search` = '1',
`flag_search_readonly` = '0',
`flag_datagrid` = '1',
`flag_datagrid_readonly` = '1',
`flag_index` = '1',
`flag_detail` = '1'
WHERE `structure_old_id` IN ('CAN-999-999-000-999-1041', 'CAN-999-999-000-999-1042', 'CAN-999-999-000-999-1043', 
'CAN-999-999-000-999-1044', 'CAN-999-999-000-999-1058')
AND `structure_field_old_id` = 'CAN-999-999-000-999-1183';

DELETE FROM `structure_validations` WHERE `structure_field_old_id` IN ('CAN-999-999-000-999-1182');

DELETE FROM `structure_fields` WHERE `old_id` IN ('CAN-999-999-000-999-1182');

DELETE FROM `structure_validations` WHERE `structure_field_old_id` IN ('CAN-999-999-000-999-1183');

INSERT INTO `structure_validations` 
(`id`, `old_id`, `structure_field_id`, `structure_field_old_id`, `rule`, `flag_empty`, `flag_required`, `on_action`, `language_message`, `created`, `created_by`, `modified`, `modifed_by`) 
VALUES
(null, '0', (SELECT `id` FROM `structure_fields` WHERE `old_id` LIKE 'CAN-999-999-000-999-1183'), 'CAN-999-999-000-999-1183', 'maxLength,30', '1', '0', '', 'barcode size is limited', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

INSERT INTO `structure_validations` 
(`id`, `old_id`, `structure_field_id`, `structure_field_old_id`, `rule`, `flag_empty`, `flag_required`, `on_action`, `language_message`, `created`, `created_by`, `modified`, `modifed_by`) 
VALUES
(null, '0', (SELECT `id` FROM `structure_fields` WHERE `old_id` LIKE 'CAN-999-999-000-999-1183'), 'CAN-999-999-000-999-1183', 'notEmpty', '1', '0', '', 'barcode is required', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');


-- Delete duplicated form field: StorageMaster.code

UPDATE `structure_formats` 
SET `structure_field_id` = (SELECT `id` FROM `structure_fields` WHERE `old_id` LIKE 'CAN-999-999-000-999-1180'),
`structure_field_old_id` = 'CAN-999-999-000-999-1180',
`flag_override_label` = '1',
`language_label` = '',
`flag_override_tag` = '1',
`language_tag` = 'code'
WHERE `structure_field_old_id` = 'CAN-999-999-000-999-1117';

DELETE FROM `structure_validations` WHERE `structure_field_old_id` IN ('CAN-999-999-000-999-1117');

DELETE FROM `structure_fields` WHERE `old_id` IN ('CAN-999-999-000-999-1117');

-- Delete duplicated form field: StorageMaster.selection_label 

UPDATE `structure_formats` 
SET `structure_field_id` = (SELECT `id` FROM `structure_fields` WHERE `old_id` LIKE 'CAN-999-999-000-999-1217'),
`structure_field_old_id` = 'CAN-999-999-000-999-1217',
`flag_override_label` = '1',
`language_label` = 'storage selection label'
WHERE `structure_field_old_id` = 'CAN-999-999-000-999-1184';

DELETE FROM `structure_validations` WHERE `structure_field_old_id` IN ('CAN-999-999-000-999-1184');

DELETE FROM `structure_fields` WHERE `old_id` IN ('CAN-999-999-000-999-1184');

-- Delete duplicated form field: StorageMaster.temperature 

UPDATE `structure_formats` 
SET `structure_field_id` = (SELECT `id` FROM `structure_fields` WHERE `old_id` LIKE 'CAN-999-999-000-999-1110'),
`structure_field_old_id` = 'CAN-999-999-000-999-1110',
`flag_override_label` = '1',
`language_label` = 'temperature'
WHERE `structure_field_old_id` = 'CAN-999-999-000-999-1192';

DELETE FROM `structure_validations` WHERE `structure_field_old_id` IN ('CAN-999-999-000-999-1192');

DELETE FROM `structure_fields` WHERE `old_id` IN ('CAN-999-999-000-999-1192');

UPDATE `structure_formats` 
SET `structure_field_id` = (SELECT `id` FROM `structure_fields` WHERE `old_id` LIKE 'CAN-999-999-000-999-1110'),
`structure_field_old_id` = 'CAN-999-999-000-999-1110',
`flag_override_label` = '1',
`language_label` = 'temperature'
WHERE `structure_field_old_id` = 'CAN-999-999-000-999-1193';

DELETE FROM `structure_validations` WHERE `structure_field_old_id` IN ('CAN-999-999-000-999-1193');

DELETE FROM `structure_fields` WHERE `old_id` IN ('CAN-999-999-000-999-1193');

DELETE FROM `structure_validations` WHERE `structure_field_old_id` IN ('CAN-999-999-000-999-1110');

INSERT INTO `structure_validations` 
(`id`, `old_id`, `structure_field_id`, `structure_field_old_id`, `rule`, `flag_empty`, `flag_required`, `on_action`, `language_message`, `created`, `created_by`, `modified`, `modifed_by`) VALUES
(null, '0', (SELECT `id` FROM `structure_fields` WHERE `old_id` LIKE 'CAN-999-999-000-999-1110'), 'CAN-999-999-000-999-1110', 'numeric', '1', '0', '', 'temperature should be a decimal', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- Add storage deletion message

DELETE FROM `i18n` WHERE `id` IN ('children storage exists within the deleted storage', 'aliquot exists within the deleted storage', 'slide exists for the deleted tma', 'slide exists within the deleted storage');

INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('children storage exists within the deleted storage', 'global', 'Your data cannot be deleted! <br>Children storage exists within the deleted storage.', 'Vos donn&eacute;es ne peuvent &ecirc;tre supprim&eacute;es! Des sous-entreposages existent dans votre entreposage.'),
('aliquot exists within the deleted storage', 'global', 'Your data cannot be deleted! <br>Aliquot exists within the deleted storage.', 'Vos donn&eacute;es ne peuvent &ecirc;tre supprim&eacute;es! Des aliquots existent dans votre entreposage.'),
('slide exists for the deleted tma', 'global', 'Your data cannot be deleted! <br>Slide exists for the deleted TMA.', 'Vos donn&eacute;es ne peuvent &ecirc;tre supprim&eacute;es! Des lames existent pour votre entreposage.'),
('slide exists within the deleted storage', 'global', 'Your data cannot be deleted! <br>TMA slide exists within the deleted storage.', 'Vos donn&eacute;es ne peuvent &ecirc;tre supprim&eacute;es! Des lames de TMA existent dans votre entreposage.');

-- Add surrounding temperature
	
UPDATE `structure_formats` 
SET `flag_override_label` = '1',
`language_label` = 'surrounding temperature'
WHERE `structure_old_id` LIKE 'CAN-999-999-000-999-1042'
AND `structure_field_old_id` LIKE 'CAN-999-999-000-999-1110';
	
-- Add storage coordinate deletion message

DELETE FROM `i18n` WHERE `id` IN ('children storage is stored within the storage at this position', 'aliquot is stored within the storage at this position');

INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('children storage is stored within the storage at this position', 'global', 'Your data cannot be deleted! <br>Children storage is stored within the storage at this position.', 'Vos donn&eacute;es ne peuvent &ecirc;tre supprim&eacute;es! Des sous-entreposages sont plac&eacute;s &agrave; cette position dans votre entreposage.'),
('aliquot is stored within the storage at this position', 'global', 'Your data cannot be deleted! <br>Aliquot exists within the deleted storage.', 'Vos donn&eacute;es ne peuvent &ecirc;tre supprim&eacute;es! Des aliquots sont plac&eacute;s &agrave; cette position dans votre entreposage.');

-- Coordinate error

UPDATE `structure_validations` SET `language_message` = 'coordinate value is required' 
WHERE `structure_field_old_id` = 'CAN-999-999-000-999-1210';

DELETE FROM `i18n` WHERE `id` IN ('coordinate value is required', 'coordinate value must be unique');

INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('coordinate value is required', 'global', 'The coordinate value is required!', 'La valeur est requise!'),
('coordinate value must be unique', 'global', 'The coordinate value must be unique!', 'Le valeur doit &ecirc;tre unique!');

-- Add following error

DELETE FROM `i18n` WHERE `id` IN ('the defined storage is a tma');

INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) 
VALUES
('the defined storage is a tma', 'global', 'The defined storage is a TMA', 'L''entreposage d&eacute;fini est un TMA!');

-- Update tma slide barcode validation

UPDATE `structure_validations` 
SET `language_message` = 'barcode is required' WHERE `structure_field_old_id` = 'CAN-999-999-000-999-1232' 
AND `rule` = 'notEmpty';

DELETE FROM `structure_validations` WHERE `structure_field_old_id` IN ('CAN-999-999-000-999-1232')
AND `rule` = 'maxLength,30';

INSERT INTO `structure_validations` 
(`id`, `old_id`, `structure_field_id`, `structure_field_old_id`, `rule`, `flag_empty`, `flag_required`, `on_action`, `language_message`, `created`, `created_by`, `modified`, `modifed_by`) VALUES
(null, '0', (SELECT `id` FROM `structure_fields` WHERE `old_id` LIKE 'CAN-999-999-000-999-1232'), 'CAN-999-999-000-999-1232', 'maxLength,30', '1', '0', '', 'barcode size is limited', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

DELETE FROM `i18n` WHERE `id` IN ('barcode is required', 'barcode must be unique', 'barcode size is limited');

INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('barcode is required', 'global', 'The barcode is required!', 'Le barcode est requis!'),
('barcode must be unique', 'global', 'The barcode must be unique!', 'Le barcode doit &ecirc;tre unique!'),
('barcode size is limited', 'global', 'The barcode size is limited!', 'La taille du barcode est limit&eacute;e!');

-- 'storage layout'

DELETE FROM `i18n` WHERE `id` IN ('storage content tree view', 'storage content', 'stored aliquots');

INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('storage content tree view', 'global', 'Tree View', 'Vu hi&eacute;rarchique'),
('storage content', 'global', 'Storage Content', 'Contenu de l''entreposage'),
('stored aliquots', 'global', 'Aliquots', 'Aliquots');

-- Storage selection label hidde for edit mode

UPDATE `structure_formats` 
SET `flag_edit` = '0',
`flag_edit_readonly` = '0' 
WHERE `structure_old_id` = 'CAN-999-999-000-999-1044' 
AND `structure_field_old_id` = 'CAN-999-999-000-999-1217';

