-- Add deleted and deleted_by columns to the correct tables

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

ALTER TABLE `study_fundings`
ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_date` datetime default NULL;

ALTER TABLE `study_investigators`
ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_date` datetime default NULL;

ALTER TABLE `study_related`
ADD COLUMN `deleted` int(11) default 0,
ADD COLUMN `deleted_date` datetime default NULL;

ALTER TABLE `study_results`
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