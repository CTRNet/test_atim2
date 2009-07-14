-- Rename all occurances of `group` field

ALTER TABLE `coding_icd10` CHANGE `group` `icd_group` VARCHAR( 50 ) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL;
ALTER TABLE `tx_masters` CHANGE `group` `tx_group` VARCHAR( 50 ) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL;

UPDATE `structure_fields` SET `field` = 'tx_group',
`structure_value_domain` = '0' WHERE `old_id` = 'CAN-999-999-000-999-276' LIMIT 1 ;

-- Update structure validations structure_field_id

UPDATE `structure_validations` v, `structure_fields` f SET v.structure_field_id = f.id WHERE v.old_id LIKE f.old_id;

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
ADD COLUMN `deleted_date` datetime default NULL;

ALTER TABLE `aliquot_uses`

ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_date` datetime default NULL;

ALTER TABLE `banks`

ADD COLUMN `created_by` int(11) default NULL AFTER `description`,
ADD COLUMN `modified_by` int(11) default NULL AFTER `created`,
ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_date` datetime default NULL;

ALTER TABLE `clinical_collection_links`

ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_date` datetime default NULL;

ALTER TABLE `coding_adverse_events`

ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_date` datetime default NULL;

ALTER TABLE `coding_icd10`

ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_date` datetime default NULL;

ALTER TABLE `collections`

ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_date` datetime default NULL;

ALTER TABLE `consents`

ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_date` datetime default NULL;

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

ADD COLUMN `event_control_id` int(11) NOT NULL AFTER `id`,
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

ADD COLUMN `protocol_control_id` int(11) NOT NULL AFTER `id`,
ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_date` datetime default NULL;

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
ADD COLUMN `deleted_date` datetime default NULL;

ALTER TABLE `rtbforms`

ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_date` datetime default NULL;

ALTER TABLE `sample_controls`

ADD COLUMN `display_order` int(11) NOT NULL default 0;

ALTER TABLE `sample_masters`

ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_date` datetime default NULL;

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

ADD COLUMN `sop_control_id` int(11) NOT NULL AFTER `id`,
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
ADD COLUMN `deleted_date` datetime default NULL;

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

ADD COLUMN `tx_control_id` int(11) NOT NULL AFTER `id`,
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

-- Menu updates

UPDATE menus SET parent_id="0" WHERE parent_id="MAIN_MENU_1";
UPDATE menus SET parent_id="core_CAN_33" WHERE id="core_CAN_41";

UPDATE menus SET display_order="1" WHERE id="MAIN_MENU_1";
UPDATE menus SET display_order="2" WHERE id="clin_CAN_1";
UPDATE menus SET display_order="3" WHERE id="inv_CAN_00";
UPDATE menus SET display_order="4" WHERE id="qry-CAN-1";
UPDATE menus SET display_order="5" WHERE id="core_CAN_42";
UPDATE menus SET display_order="6" WHERE id="core_CAN_33";
UPDATE menus SET display_order="7" WHERE id="MAIN_MENU_2";


UPDATE  `menus` SET use_summary="Clinicalannotation.EventControl:summary"
WHERE id="clin_CAN_27"
OR id="clin_CAN_28"
OR id="clin_CAN_30"
OR id="clin_CAN_31"
OR id="clin_CAN_32"
OR id="clin_CAN_33"
OR id="clin_CAN_69";

UPDATE  `menus` SET  `parent_id` =  'clin_CAN_4',
`language_description` =  'screening',
`use_link` =  '/clinicalannotation/event_masters/listall/screening/%%Participant.id%%' WHERE CONVERT(  `id` USING utf8 ) =  'clin_CAN_27' LIMIT 1 ;

UPDATE  `menus` SET  `parent_id` =  'clin_CAN_4',
`language_description` =  'lab',
`use_link` =  '/clinicalannotation/event_masters/listall/lab/%%Participant.id%%' WHERE CONVERT(  `id` USING utf8 ) =  'clin_CAN_28' LIMIT 1 ;

UPDATE  `menus` SET  `parent_id` =  'clin_CAN_4',
`language_description` =  'lifestyle',
`use_link` =  '/clinicalannotation/event_masters/listall/lifestyle/%%Participant.id%%' WHERE CONVERT(  `id` USING utf8 ) =  'clin_CAN_30' LIMIT 1 ;

UPDATE  `menus` SET  `parent_id` =  'clin_CAN_4',
`language_description` =  'clinical',
`use_link` =  '/clinicalannotation/event_masters/listall/clinical/%%Participant.id%%' WHERE CONVERT(  `id` USING utf8 ) =  'clin_CAN_31' LIMIT 1 ;


UPDATE  `menus` SET  `parent_id` =  'clin_CAN_4',
`language_description` =  'adverse events',
`use_link` =  '/clinicalannotation/event_masters/listall/adverse_events/%%Participant.id%%' WHERE CONVERT(  `id` USING utf8 ) =  'clin_CAN_32' LIMIT 1 ;

UPDATE  `menus` SET  `parent_id` =  'clin_CAN_4',
`language_description` =  'clin_study',
`use_link` =  '/clinicalannotation/event_masters/listall/study/%%Participant.id%%' WHERE CONVERT(  `id` USING utf8 ) =  'clin_CAN_33' LIMIT 1 ;

UPDATE  `menus` SET  `parent_id` =  'clin_CAN_1',
`language_description` =  'annotation',
`use_link` =  '/clinicalannotation/event_masters/listall/adverse_events/%%Participant.id%%' WHERE CONVERT(  `id` USING utf8 ) =  'clin_CAN_4' LIMIT 1 ;

UPDATE  `menus` SET  `parent_id` =  'clin_CAN_4',
`language_description` =  'protocol',
`use_link` =  '/clinicalannotation/event_masters/listall/protocol/%%Participant.id%%' WHERE CONVERT(  `id` USING utf8 ) =  'clin_CAN_69' LIMIT 1 ;