
ALTER TABLE `dxd_tissues` CHANGE `text_field` `laterality` VARCHAR( 50 ) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL DEFAULT '';
ALTER TABLE `dxd_tissues_revs` CHANGE `text_field` `laterality` VARCHAR( 50 ) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL DEFAULT '';

ALTER TABLE `ed_all_study_research` ADD `file_path` VARCHAR( 255 ) NOT NULL AFTER `event_master_id`  ;
ALTER TABLE `ed_all_study_research_revs` ADD `file_path` VARCHAR( 255 ) NOT NULL AFTER `event_master_id`  ;

ALTER TABLE misc_identifier_controls
	MODIFY `autoincrement_name` varchar(50) default NULL,
	CHANGE misc_identifier_value misc_identifier_format varchar(50) default NULL,
	ADD UNIQUE KEY `unique_misc_identifier_name` (`misc_identifier_name`);

ALTER TABLE `misc_identifiers` ADD `misc_identifier_control_id`  INT( 11 ) NOT NULL DEFAULT '0' AFTER `identifier_value` ; 
ALTER TABLE `misc_identifiers_revs` ADD `misc_identifier_control_id`  INT( 11 ) NOT NULL DEFAULT '0' AFTER `identifier_value` ;

UPDATE misc_identifiers ident, misc_identifier_controls ctrl
SET ident.misc_identifier_control_id = ctrl.id
WHERE ident.identifier_name = ctrl.misc_identifier_name;

ALTER TABLE `misc_identifiers`
  ADD CONSTRAINT `FK_misc_identifiers_misc_identifier_controls`
  FOREIGN KEY (`misc_identifier_control_id`) REFERENCES `misc_identifier_controls` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT;

DROP TABLE IF EXISTS `ed_allsolid_lab_pathology`;
DROP TABLE IF EXISTS `ed_allsolid_lab_pathology_revs`;  

ALTER TABLE `ed_all_clinical_followup` CHANGE `created` `created` DATETIME NULL ,
CHANGE `modified` `modified` DATETIME NULL; 
ALTER TABLE `ed_all_clinical_followup_revs` CHANGE `created` `created` DATETIME NULL ,
CHANGE `modified` `modified` DATETIME NULL; 

ALTER TABLE `ed_all_clinical_presentation` CHANGE `created` `created` DATETIME NULL ,
CHANGE `modified` `modified` DATETIME NULL; 
ALTER TABLE `ed_all_clinical_presentation_revs` CHANGE `created` `created` DATETIME NULL ,
CHANGE `modified` `modified` DATETIME NULL;

ALTER TABLE `ed_breast_lab_pathology` CHANGE `created` `created` DATETIME NULL ,
CHANGE `modified` `modified` DATETIME NULL; 
ALTER TABLE `ed_breast_lab_pathology_revs` CHANGE `created` `created` DATETIME NULL ,
CHANGE `modified` `modified` DATETIME NULL;

ALTER TABLE `order_items` CHANGE `created` `created` DATETIME NULL ,
CHANGE `modified` `modified` DATETIME NULL; 
ALTER TABLE `order_items_revs` CHANGE `created` `created` DATETIME NULL ,
CHANGE `modified` `modified` DATETIME NULL;

ALTER TABLE `pd_chemos` CHANGE `created` `created` DATETIME NULL ,
CHANGE `modified` `modified` DATETIME NULL; 
ALTER TABLE `pd_chemos_revs` CHANGE `created` `created` DATETIME NULL ,
CHANGE `modified` `modified` DATETIME NULL;

ALTER TABLE `protocol_controls` CHANGE `created` `created` DATETIME NULL ,
CHANGE `modified` `modified` DATETIME NULL; 

ALTER TABLE `protocol_masters` CHANGE `created` `created` DATETIME NULL ,
CHANGE `modified` `modified` DATETIME NULL; 
ALTER TABLE `protocol_masters_revs` CHANGE `created` `created` DATETIME NULL ,
CHANGE `modified` `modified` DATETIME NULL;

ALTER TABLE `ed_all_lifestyle_base`
  DROP `alcohol_history`,
  DROP `weight_loss`;

ALTER TABLE `ed_all_lifestyle_base_revs`
  DROP `alcohol_history`,
  DROP `weight_loss`;

RENAME TABLE `ed_all_lifestyle_base`  TO `ed_all_lifestyle_smoking`  ;
RENAME TABLE `ed_all_lifestyle_base_revs`  TO `ed_all_lifestyle_smoking_revs`  ;

ALTER TABLE `ed_all_lifestyle_smoking` CHANGE `pack_years` `pack_years` INT NULL DEFAULT NULL;
ALTER TABLE `ed_all_lifestyle_smoking_revs` CHANGE `pack_years` `pack_years` INT NULL DEFAULT NULL;

ALTER TABLE `structures` 
CHANGE `old_id` `old_id` VARCHAR( 255 ) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL;

ALTER TABLE `structures` ADD UNIQUE (`old_id`);

ALTER TABLE `structure_fields` ADD UNIQUE (`old_id`);

ALTER TABLE `structure_formats` ADD UNIQUE (`old_id`);

ALTER TABLE `structure_formats` 
CHANGE `structure_id` `structure_id` INT( 11 ) NOT NULL ,
CHANGE `structure_field_id` `structure_field_id` INT( 11 ) NOT NULL;

ALTER TABLE `structure_validations`
  ADD CONSTRAINT `FK_structure_validations_structure_fields`
  FOREIGN KEY (`structure_field_id`) REFERENCES `structure_fields` (`id`);
  
ALTER TABLE `structure_formats`
  ADD CONSTRAINT `FK_structure_formats_structures`
  FOREIGN KEY (`structure_id`) REFERENCES `structures` (`id`); 
  
ALTER TABLE `structure_formats`
  ADD CONSTRAINT `FK_structure_formats_structure_fields`
  FOREIGN KEY (`structure_field_id`) REFERENCES `structure_fields` (`id`); 

ALTER TABLE `structure_fields`
  ADD CONSTRAINT `FK_structure_fields_structure_value_domains`
  FOREIGN KEY (`structure_value_domain`) REFERENCES `structure_value_domains` (`id`); 
  
ALTER TABLE `structure_validations` 
CHANGE `old_id` `old_id` VARCHAR( 255 ) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL ,
CHANGE `structure_field_id` `structure_field_id` INT( 11 ) NOT NULL ,
CHANGE `structure_field_old_id` `structure_field_old_id` VARCHAR( 255 ) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL ;

ALTER TABLE `structures` 
CHANGE `alias` `alias` VARCHAR( 255 ) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL ;

ALTER TABLE `structure_validations` ADD UNIQUE (`old_id`);

DROP TABLE `structure_options`;
ALTER TABLE `ed_all_clinical_presentation` CHANGE `height` `height` DECIMAL( 10, 2 ) NULL DEFAULT NULL,
CHANGE `weight` `weight` DECIMAL( 10, 2 ) NULL DEFAULT NULL;
ALTER TABLE `ed_all_clinical_presentation_revs` CHANGE `height` `height` DECIMAL( 10, 2 ) NULL DEFAULT NULL,
CHANGE `weight` `weight` DECIMAL( 10, 2 ) NULL DEFAULT NULL;

CREATE VIEW view_collections AS 
SELECT 
col.id AS collection_id, 
col.bank_id, 
col.sop_master_id, 
link.participant_id, 
link.diagnosis_master_id, 
link.consent_master_id, 

part.participant_identifier, 

col.acquisition_label, 
col.collection_site, 
col.collection_datetime, 
col.collection_datetime_accuracy, 
col.collection_property, 
col.collection_notes, 
col.deleted,

banks.name AS bank_name

FROM collections AS col
LEFT JOIN clinical_collection_links AS link ON col.id = link.collection_id AND link.deleted != 1
LEFT JOIN participants AS part ON link.participant_id = part.id AND part.deleted != 1
LEFT JOIN banks ON col.bank_id = banks.id AND banks.deleted != 1
WHERE col.deleted != 1;

CREATE TABLE `sd_der_cell_lysates` (
  `id` int(11) NOT NULL auto_increment,
  `sample_master_id` int(11) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime default NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ; 

CREATE TABLE `sd_der_cell_lysates_revs` (
  `id` int(11) NOT NULL,
  `sample_master_id` int(11) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime default NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ; 
ALTER TABLE structure_permissible_values ADD UNIQUE KEY(value, language_alias);

INSERT INTO `sample_controls` (`id`, `sample_type`, `sample_type_code`, `sample_category`, `status`, `form_alias`, `detail_tablename`, `display_order`)
VALUES (NULL , 'cell lysate', 'C-LYSATE', 'derivative', 'inactive', 'sd_undetailed_derivatives', 'sd_der_cell_lysates', '0');

SET @last_id = LAST_INSERT_ID();

INSERT INTO `parent_to_derivative_sample_controls` (`id` ,`parent_sample_control_id` ,`derivative_sample_control_id` ,`status`) VALUES 
(NULL , '3', @last_id, 'inactive'),#tissue
(NULL , '11', @last_id, 'inactive'),#cell culture
(NULL , '8', @last_id, 'inactive');#pbmc

CREATE TABLE `sd_der_proteins` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sample_master_id` int(11) DEFAULT NULL,
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL DEFAULT '',
  `modified` datetime DEFAULT NULL,
  `modified_by` varchar(50) DEFAULT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_sd_der_amp_rnas_sample_masters` (`sample_master_id`),
  FOREIGN KEY (`sample_master_id`) REFERENCES `sample_masters` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `sd_der_proteins_revs` (
  `id` int(11) NOT NULL,
  `sample_master_id` int(11) DEFAULT NULL,
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL DEFAULT '',
  `modified` datetime DEFAULT NULL,
  `modified_by` varchar(50) DEFAULT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `sample_controls` (`id`, `sample_type`, `sample_type_code`, `sample_category`, `status`, `form_alias`, `detail_tablename`, `display_order`)
VALUES (NULL , 'protein', 'PROT', 'derivative', 'inactive', 'sd_undetailed_derivatives', 'sd_der_proteins', '0');

INSERT INTO parent_to_derivative_sample_controls (`parent_sample_control_id`, `derivative_sample_control_id`, `status`) VALUES
((SELECT id FROM sample_controls WHERE sample_type='cell lysate'), (SELECT id FROM sample_controls WHERE sample_type='dna'), 'inactive'),
((SELECT id FROM sample_controls WHERE sample_type='cell lysate'), (SELECT id FROM sample_controls WHERE sample_type='rna'), 'inactive'),
((SELECT id FROM sample_controls WHERE sample_type='cell lysate'), (SELECT id FROM sample_controls WHERE sample_type='protein'), 'inactive');

INSERT INTO sample_to_aliquot_controls (`sample_control_id`, `aliquot_control_id`, `status`) VALUES
((SELECT id FROM sample_controls WHERE sample_type='cell lysate'), (SELECT id FROM aliquot_controls WHERE aliquot_type='tube' AND form_alias='ad_der_tubes_incl_ml_vol'), 'inactive'),
((SELECT id FROM sample_controls WHERE sample_type='protein'), (SELECT id FROM aliquot_controls WHERE aliquot_type='tube' AND form_alias='ad_der_tubes_incl_ml_vol'), 'inactive');

ALTER TABLE structure_value_domains ADD UNIQUE KEY(`domain_name`);
ALTER TABLE `structures` ADD `description` VARCHAR( 250 ) NULL AFTER `alias` ;

CREATE VIEW view_samples AS 
SELECT 
samp.id AS sample_master_id,
samp.parent_id AS parent_sample_id,
samp.initial_specimen_sample_id,
col.id AS collection_id, 
col.bank_id, 
col.sop_master_id, 
link.participant_id, 
link.diagnosis_master_id, 
link.consent_master_id,

part.participant_identifier, 

col.acquisition_label, 

samp.initial_specimen_sample_type, 	
parent_samp.sample_type AS parent_sample_type,
samp.sample_type,
samp.sample_code,
samp.sample_category,
samp.deleted

FROM sample_masters as samp
INNER JOIN collections AS col ON col.id = samp.collection_id AND col.deleted != 1
LEFT JOIN sample_masters as parent_samp ON samp.parent_id = parent_samp.id AND parent_samp.deleted != 1
LEFT JOIN clinical_collection_links AS link ON col.id = link.collection_id AND link.deleted != 1
LEFT JOIN participants AS part ON link.participant_id = part.id AND part.deleted != 1
WHERE samp.deleted != 1;

CREATE VIEW view_aliquots AS 
SELECT 
al.id AS aliquot_master_id,
samp.id AS sample_master_id,
col.id AS collection_id, 
col.bank_id, 
stor.id AS storage_master_id,
link.participant_id, 
link.diagnosis_master_id, 
link.consent_master_id,

part.participant_identifier, 

col.acquisition_label, 

samp.initial_specimen_sample_type, 	
parent_samp.sample_type AS parent_sample_type,
samp.sample_type,

al.barcode,
al.aliquot_type,
al.in_stock,

stor.code,
stor.selection_label,
al.storage_coord_x,
al.storage_coord_y,

stor.temperature,
stor.temp_unit,

COUNT(al_use.id) as aliquot_use_counter,

al.deleted

FROM aliquot_masters as al
INNER JOIN sample_masters as samp ON samp.id = al.sample_master_id AND samp.deleted != 1
INNER JOIN collections AS col ON col.id = samp.collection_id AND col.deleted != 1
LEFT JOIN aliquot_uses AS al_use ON al_use.aliquot_master_id = al.id AND al_use.deleted != 1
LEFT JOIN sample_masters as parent_samp ON samp.parent_id = parent_samp.id AND parent_samp.deleted != 1
LEFT JOIN clinical_collection_links AS link ON col.id = link.collection_id AND link.deleted != 1
LEFT JOIN participants AS part ON link.participant_id = part.id AND part.deleted != 1
LEFT JOIN storage_masters AS stor ON stor.id = al.storage_master_id AND stor.deleted != 1
WHERE al.deleted != 1
GROUP BY al.id;

ALTER TABLE `structures` CHANGE `description` `description` TEXT CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL; 

ALTER TABLE storage_controls
	MODIFY display_x_size tinyint unsigned not null default 0 AFTER coord_y_size,
	MODIFY display_y_size tinyint unsigned not null default 0 AFTER display_x_size,
	MODIFY reverse_x_numbering boolean not null default false AFTER display_y_size,
	MODIFY reverse_y_numbering boolean not null default false AFTER reverse_x_numbering;

ALTER TABLE i18n
	MODIFY id varchar(255) NOT NULL,
	MODIFY en varchar(255) NOT NULL,
	MODIFY fr varchar(255) NOT NULL;
	
ALTER TABLE `sd_spe_tissues` 
	ADD `tissue_weight` VARCHAR( 10 ) NULL AFTER `tissue_size_unit`,
	ADD `tissue_weight_unit` VARCHAR( 10 ) NULL AFTER `tissue_weight`  ;

ALTER TABLE `sd_spe_tissues_revs` 
	ADD `tissue_weight` VARCHAR( 10 ) NULL AFTER `tissue_size_unit`,
	ADD `tissue_weight_unit` VARCHAR( 10 ) NULL AFTER `tissue_weight`  ;

ALTER TABLE `diagnosis_controls` CHANGE `controls_type` `controls_type` VARCHAR( 50 ) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL ;

ALTER TABLE users 
	ADD UNIQUE unique_username (username);

ALTER TABLE  `structure_value_domains` ADD  `source` VARCHAR( 255 ) NULL;

ALTER TABLE ad_bags MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE ad_bags_revs MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE ad_blocks MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE ad_blocks_revs MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE ad_cell_cores MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE ad_cell_cores_revs MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE ad_cell_slides MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE ad_cell_slides_revs MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE ad_gel_matrices MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE ad_gel_matrices_revs MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE ad_tissue_cores MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE ad_tissue_cores_revs MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE ad_tissue_slides MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE ad_tissue_slides_revs MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE ad_tubes MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE ad_tubes_revs MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE ad_whatman_papers MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE ad_whatman_papers_revs MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE aliquot_masters MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE aliquot_masters_revs MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE aliquot_uses MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE aliquot_uses_revs MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE announcements MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE atim_information MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE banks MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE banks_revs MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE cd_nationals MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE cd_nationals_revs MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE clinical_collection_links MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE clinical_collection_links_revs MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE coding_adverse_events MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE coding_adverse_events_revs MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE coding_icd10 MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE collections MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE collections_revs MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE configs MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE consent_masters MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE consent_masters_revs MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE datamart_adhoc MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE datamart_batch_sets MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE derivative_details MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE derivative_details_revs MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE diagnosis_masters MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE diagnosis_masters_revs MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE drugs MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE drugs_revs MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE dxd_bloods MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE dxd_bloods_revs MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE dxd_tissues MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE dxd_tissues_revs MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE ed_all_adverse_events_adverse_event MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE ed_all_adverse_events_adverse_event_revs MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE ed_all_clinical_followup MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE ed_all_clinical_followup_revs MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE ed_all_clinical_presentation MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE ed_all_clinical_presentation_revs MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE ed_all_lifestyle_smoking MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE ed_all_lifestyle_smoking_revs MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE ed_all_protocol_followup MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE ed_all_protocol_followup_revs MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE ed_all_study_research MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE ed_all_study_research_revs MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE ed_breast_lab_pathology MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE ed_breast_lab_pathology_revs MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE ed_breast_screening_mammogram MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE ed_breast_screening_mammogram_revs MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE event_masters MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE event_masters_revs MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE family_histories MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE family_histories_revs MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE materials MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE materials_revs MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE menus MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE misc_identifiers MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE misc_identifiers_revs MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE order_items MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE order_items_revs MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE order_lines MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE order_lines_revs MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE orders MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE orders_revs MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE pages MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE participant_contacts MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE participant_contacts_revs MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE participant_messages MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE participant_messages_revs MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE participants MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE participants_revs MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE path_collection_reviews MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE path_collection_reviews_revs MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE pd_chemos MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE pd_chemos_revs MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE pe_chemos MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE pe_chemos_revs MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE protocol_controls MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE protocol_masters MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE protocol_masters_revs MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE providers MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE providers_revs MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE quality_ctrl_tested_aliquots MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE quality_ctrl_tested_aliquots_revs MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE quality_ctrls MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE quality_ctrls_revs MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE rd_blood_cells MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE rd_blood_cells_revs MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE rd_bloodcellcounts MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE rd_bloodcellcounts_revs MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE rd_breast_cancers MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE rd_breast_cancers_revs MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE rd_breastcancertypes MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE rd_breastcancertypes_revs MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE rd_coloncancertypes MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE rd_coloncancertypes_revs MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE rd_genericcancertypes MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE rd_genericcancertypes_revs MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE rd_ovarianuteruscancertypes MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE rd_ovarianuteruscancertypes_revs MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE realiquotings MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE realiquotings_revs MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE reproductive_histories MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE reproductive_histories_revs MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE review_masters MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE review_masters_revs MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE rtbforms MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE rtbforms_revs MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE sample_masters MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE sample_masters_revs MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE sd_der_amp_rnas MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE sd_der_amp_rnas_revs MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE sd_der_ascite_cells MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE sd_der_ascite_cells_revs MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE sd_der_ascite_sups MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE sd_der_ascite_sups_revs MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE sd_der_b_cells MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE sd_der_b_cells_revs MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE sd_der_blood_cells MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE sd_der_blood_cells_revs MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE sd_der_cell_cultures MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE sd_der_cell_cultures_revs MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE sd_der_cell_lysates MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE sd_der_cell_lysates_revs MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE sd_der_cystic_fl_cells MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE sd_der_cystic_fl_cells_revs MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE sd_der_cystic_fl_sups MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE sd_der_cystic_fl_sups_revs MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE sd_der_dnas MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE sd_der_dnas_revs MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE sd_der_pbmcs MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE sd_der_pbmcs_revs MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE sd_der_pericardial_fl_cells MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE sd_der_pericardial_fl_cells_revs MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE sd_der_pericardial_fl_sups MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE sd_der_pericardial_fl_sups_revs MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE sd_der_plasmas MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE sd_der_plasmas_revs MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE sd_der_pleural_fl_cells MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE sd_der_pleural_fl_cells_revs MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE sd_der_pleural_fl_sups MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE sd_der_pleural_fl_sups_revs MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE sd_der_proteins MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE sd_der_proteins_revs MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE sd_der_pw_cells MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE sd_der_pw_cells_revs MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE sd_der_pw_sups MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE sd_der_pw_sups_revs MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE sd_der_rnas MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE sd_der_rnas_revs MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE sd_der_serums MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE sd_der_serums_revs MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE sd_der_tiss_lysates MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE sd_der_tiss_lysates_revs MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE sd_der_tiss_susps MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE sd_der_tiss_susps_revs MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE sd_der_urine_cents MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE sd_der_urine_cents_revs MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE sd_der_urine_cons MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE sd_der_urine_cons_revs MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE sd_spe_ascites MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE sd_spe_ascites_revs MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE sd_spe_bloods MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE sd_spe_bloods_revs MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE sd_spe_cystic_fluids MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE sd_spe_cystic_fluids_revs MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE sd_spe_pericardial_fluids MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE sd_spe_pericardial_fluids_revs MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE sd_spe_peritoneal_washes MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE sd_spe_peritoneal_washes_revs MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE sd_spe_pleural_fluids MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE sd_spe_pleural_fluids_revs MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE sd_spe_tissues MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE sd_spe_tissues_revs MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE sd_spe_urines MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE sd_spe_urines_revs MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE shelves MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE shelves_revs MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE shipments MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE shipments_revs MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE sidebars MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE sop_controls MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE sop_masters MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE sop_masters_revs MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE sopd_general_all MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE sopd_general_all_revs MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE sopd_inventory_all MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE sopd_inventory_all_revs MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE sope_general_all MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE sope_general_all_revs MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE sope_inventory_all MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE sope_inventory_all_revs MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE source_aliquots MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE source_aliquots_revs MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE specimen_details MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE specimen_details_revs MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE std_boxs MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE std_boxs_revs MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE std_cupboards MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE std_cupboards_revs MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE std_freezers MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE std_freezers_revs MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE std_fridges MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE std_fridges_revs MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE std_incubators MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE std_incubators_revs MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE std_nitro_locates MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE std_nitro_locates_revs MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE std_racks MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE std_racks_revs MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE std_rooms MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE std_rooms_revs MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE std_shelfs MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE std_shelfs_revs MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE std_tma_blocks MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE std_tma_blocks_revs MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE storage_coordinates MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE storage_coordinates_revs MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE storage_masters MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE storage_masters_revs MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE structure_fields MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE structure_formats MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE structure_validations MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE structures MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE study_contacts MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE study_contacts_revs MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE study_ethics_boards MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE study_ethics_boards_revs MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE study_fundings MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE study_fundings_revs MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE study_investigators MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE study_investigators_revs MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE study_related MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE study_related_revs MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE study_results MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE study_results_revs MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE study_reviews MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE study_reviews_revs MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE study_summaries MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE study_summaries_revs MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE tma_slides MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE tma_slides_revs MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE tx_masters MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE tx_masters_revs MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE txd_chemos MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE txd_chemos_revs MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE txd_radiations MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE txd_radiations_revs MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE txd_surgeries MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE txd_surgeries_revs MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE txe_chemos MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE txe_chemos_revs MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE txe_radiations MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE txe_radiations_revs MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE txe_surgeries MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE txe_surgeries_revs MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE versions MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;

ALTER TABLE cd_icm_generics MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE cd_icm_generics_revs MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;

ALTER TABLE dxd_sardos MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE dxd_sardos_revs MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;

ALTER TABLE ed_all_procure_lifestyle MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE ed_all_procure_lifestyle_revs MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;

ALTER TABLE lab_type_laterality_match MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;

ALTER TABLE sd_der_of_cells MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE sd_der_of_cells_revs MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;

ALTER TABLE sd_der_of_sups MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE sd_der_of_sups_revs MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;

ALTER TABLE sd_spe_other_fluids MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;
ALTER TABLE sd_spe_other_fluids_revs MODIFY created_by INT UNSIGNED NOT NULL, MODIFY modified_by INT UNSIGNED NOT NULL;

ALTER TABLE `sd_der_plasmas` CHANGE `hemolyze_signs` 
`hemolysis_signs` VARCHAR( 10 ) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL ;

ALTER TABLE `sd_der_plasmas_revs` CHANGE `hemolyze_signs` 
`hemolysis_signs` VARCHAR( 10 ) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL ;

ALTER TABLE `sd_der_serums` CHANGE `hemolyze_signs` 
`hemolysis_signs` VARCHAR( 10 ) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL ;

ALTER TABLE `sd_der_serums_revs` CHANGE `hemolyze_signs` 
`hemolysis_signs` VARCHAR( 10 ) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL ;

DROP TABLE IF EXISTS `ad_cell_cores` , `ad_cell_cores_revs`;

CREATE TABLE IF NOT EXISTS `ad_cell_cores` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `aliquot_master_id` int(11) DEFAULT NULL,
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime DEFAULT NULL,
  `modified_by` int(10) unsigned NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE IF NOT EXISTS `ad_cell_cores_revs` (
  `id` int(11) NOT NULL,
  `aliquot_master_id` int(11) DEFAULT NULL,
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime DEFAULT NULL,
  `modified_by` int(10) unsigned NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

ALTER TABLE `ad_cell_cores` 
	ADD CONSTRAINT `FK_ad_cell_cores_aliquot_masters` FOREIGN KEY (`aliquot_master_id`) REFERENCES `aliquot_masters` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT; 

DROP TABLE IF EXISTS `ad_tissue_cores` , `ad_tissue_cores_revs`;

CREATE TABLE IF NOT EXISTS `ad_tissue_cores` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `aliquot_master_id` int(11) DEFAULT NULL,
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime DEFAULT NULL,
  `modified_by` int(10) unsigned NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE IF NOT EXISTS `ad_tissue_cores_revs` (
  `id` int(11) NOT NULL,
  `aliquot_master_id` int(11) DEFAULT NULL,
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime DEFAULT NULL,
  `modified_by` int(10) unsigned NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

ALTER TABLE `ad_tissue_cores` 
	ADD CONSTRAINT `FK_ad_tissue_cores_aliquot_masters` FOREIGN KEY (`aliquot_master_id`) REFERENCES `aliquot_masters` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT; 

CREATE TABLE IF NOT EXISTS `realiquoting_controls` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `parent_sample_to_aliquot_control_id` int(11) DEFAULT NULL,
  `child_sample_to_aliquot_control_id` int(11) DEFAULT NULL,
  `status` enum('inactive','active') DEFAULT 'inactive',
  PRIMARY KEY (`id`),
  UNIQUE KEY `aliquot_to_aliquot` (`parent_sample_to_aliquot_control_id`,`child_sample_to_aliquot_control_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

ALTER TABLE `realiquoting_controls`
  ADD CONSTRAINT `FK_parent_realiquoting_control` FOREIGN KEY (`parent_sample_to_aliquot_control_id`) REFERENCES `sample_to_aliquot_controls` (`id`),
  ADD CONSTRAINT `FK_child_realiquoting_control` FOREIGN KEY (`child_sample_to_aliquot_control_id`) REFERENCES `sample_to_aliquot_controls` (`id`);

 	
-- --------------- ici --------------------------------------


SELECT sample_category,sample_type,sample_controls.status as sample_status, 
sample_to_aliquot_controls.status as link_status,
aliquot_type, aliquot_controls.form_alias as aliquot_form, aliquot_controls.status as aliquot_status
FROM `sample_controls` 
INNER JOIN 	sample_to_aliquot_controls ON sample_to_aliquot_controls.sample_control_id = sample_controls.id
INNER JOIN aliquot_controls on sample_to_aliquot_controls.aliquot_control_id = aliquot_controls.id
ORDER BY sample_category DESC,sample_type ASC, aliquot_type ASC;

 
  
  
ALTER TABLE `ad_tissue_slides`
	DROP `block_aliquot_master_id`;
ALTER TABLE `ad_tissue_slides_revs`
	DROP `block_aliquot_master_id`;
  
  
INSERT INTO `realiquoting_controls` (`parent_sample_to_aliquot_control_id`, `child_sample_to_aliquot_control_id`, `status`) 
VALUES
-- *** ascite ***
((SELECT sta_ctrl.id FROM sample_controls AS samp INNER JOIN sample_to_aliquot_controls AS sta_ctrl ON samp.id = sta_ctrl.sample_control_id INNER JOIN aliquot_controls AS al ON sta_ctrl.aliquot_control_id = al.id
WHERE samp.sample_type = 'ascite' AND al.aliquot_type = 'tube'),
(SELECT sta_ctrl.id FROM sample_controls AS samp INNER JOIN sample_to_aliquot_controls AS sta_ctrl ON samp.id = sta_ctrl.sample_control_id INNER JOIN aliquot_controls AS al ON sta_ctrl.aliquot_control_id = al.id
WHERE samp.sample_type = 'ascite' AND al.aliquot_type = 'tube'),
'active'),
-- *** blood ***
((SELECT sta_ctrl.id FROM sample_controls AS samp INNER JOIN sample_to_aliquot_controls AS sta_ctrl ON samp.id = sta_ctrl.sample_control_id INNER JOIN aliquot_controls AS al ON sta_ctrl.aliquot_control_id = al.id
WHERE samp.sample_type = 'blood' AND al.aliquot_type = 'tube'),
(SELECT sta_ctrl.id FROM sample_controls AS samp INNER JOIN sample_to_aliquot_controls AS sta_ctrl ON samp.id = sta_ctrl.sample_control_id INNER JOIN aliquot_controls AS al ON sta_ctrl.aliquot_control_id = al.id
WHERE samp.sample_type = 'blood' AND al.aliquot_type = 'tube'),
'active'),
((SELECT sta_ctrl.id FROM sample_controls AS samp INNER JOIN sample_to_aliquot_controls AS sta_ctrl ON samp.id = sta_ctrl.sample_control_id INNER JOIN aliquot_controls AS al ON sta_ctrl.aliquot_control_id = al.id
WHERE samp.sample_type = 'blood' AND al.aliquot_type = 'tube'),
(SELECT sta_ctrl.id FROM sample_controls AS samp INNER JOIN sample_to_aliquot_controls AS sta_ctrl ON samp.id = sta_ctrl.sample_control_id INNER JOIN aliquot_controls AS al ON sta_ctrl.aliquot_control_id = al.id
WHERE samp.sample_type = 'blood' AND al.aliquot_type = 'whatman paper'),
'active'),

-- *** tissue ***
((SELECT sta_ctrl.id FROM sample_controls AS samp INNER JOIN sample_to_aliquot_controls AS sta_ctrl ON samp.id = sta_ctrl.sample_control_id INNER JOIN aliquot_controls AS al ON sta_ctrl.aliquot_control_id = al.id
WHERE samp.sample_type = 'tissue' AND al.aliquot_type = 'tube' AND sta_ctrl.status = 'active'),
(SELECT sta_ctrl.id FROM sample_controls AS samp INNER JOIN sample_to_aliquot_controls AS sta_ctrl ON samp.id = sta_ctrl.sample_control_id INNER JOIN aliquot_controls AS al ON sta_ctrl.aliquot_control_id = al.id
WHERE samp.sample_type = 'tissue' AND al.aliquot_type = 'tube' AND sta_ctrl.status = 'active'),
'active'),
((SELECT sta_ctrl.id FROM sample_controls AS samp INNER JOIN sample_to_aliquot_controls AS sta_ctrl ON samp.id = sta_ctrl.sample_control_id INNER JOIN aliquot_controls AS al ON sta_ctrl.aliquot_control_id = al.id
WHERE samp.sample_type = 'tissue' AND al.aliquot_type = 'tube' AND sta_ctrl.status = 'active'),
(SELECT sta_ctrl.id FROM sample_controls AS samp INNER JOIN sample_to_aliquot_controls AS sta_ctrl ON samp.id = sta_ctrl.sample_control_id INNER JOIN aliquot_controls AS al ON sta_ctrl.aliquot_control_id = al.id
WHERE samp.sample_type = 'tissue' AND al.aliquot_type = 'slide'),
'active'),
((SELECT sta_ctrl.id FROM sample_controls AS samp INNER JOIN sample_to_aliquot_controls AS sta_ctrl ON samp.id = sta_ctrl.sample_control_id INNER JOIN aliquot_controls AS al ON sta_ctrl.aliquot_control_id = al.id
WHERE samp.sample_type = 'tissue' AND al.aliquot_type = 'tube' AND sta_ctrl.status = 'active'),
(SELECT sta_ctrl.id FROM sample_controls AS samp INNER JOIN sample_to_aliquot_controls AS sta_ctrl ON samp.id = sta_ctrl.sample_control_id INNER JOIN aliquot_controls AS al ON sta_ctrl.aliquot_control_id = al.id
WHERE samp.sample_type = 'tissue' AND al.aliquot_type = 'block'),
'active'),
((SELECT sta_ctrl.id FROM sample_controls AS samp INNER JOIN sample_to_aliquot_controls AS sta_ctrl ON samp.id = sta_ctrl.sample_control_id INNER JOIN aliquot_controls AS al ON sta_ctrl.aliquot_control_id = al.id
WHERE samp.sample_type = 'tissue' AND al.aliquot_type = 'block'),
(SELECT sta_ctrl.id FROM sample_controls AS samp INNER JOIN sample_to_aliquot_controls AS sta_ctrl ON samp.id = sta_ctrl.sample_control_id INNER JOIN aliquot_controls AS al ON sta_ctrl.aliquot_control_id = al.id
WHERE samp.sample_type = 'tissue' AND al.aliquot_type = 'slide'),
'active'),
((SELECT sta_ctrl.id FROM sample_controls AS samp INNER JOIN sample_to_aliquot_controls AS sta_ctrl ON samp.id = sta_ctrl.sample_control_id INNER JOIN aliquot_controls AS al ON sta_ctrl.aliquot_control_id = al.id
WHERE samp.sample_type = 'tissue' AND al.aliquot_type = 'block'),
(SELECT sta_ctrl.id FROM sample_controls AS samp INNER JOIN sample_to_aliquot_controls AS sta_ctrl ON samp.id = sta_ctrl.sample_control_id INNER JOIN aliquot_controls AS al ON sta_ctrl.aliquot_control_id = al.id
WHERE samp.sample_type = 'tissue' AND al.aliquot_type = 'core'),
'active'),

-- *** urine ***
((SELECT sta_ctrl.id FROM sample_controls AS samp INNER JOIN sample_to_aliquot_controls AS sta_ctrl ON samp.id = sta_ctrl.sample_control_id INNER JOIN aliquot_controls AS al ON sta_ctrl.aliquot_control_id = al.id
WHERE samp.sample_type = 'urine' AND al.aliquot_type = 'tube'),
(SELECT sta_ctrl.id FROM sample_controls AS samp INNER JOIN sample_to_aliquot_controls AS sta_ctrl ON samp.id = sta_ctrl.sample_control_id INNER JOIN aliquot_controls AS al ON sta_ctrl.aliquot_control_id = al.id
WHERE samp.sample_type = 'urine' AND al.aliquot_type = 'tube'),
'active'),



-- *** ascite cell ***
((SELECT sta_ctrl.id FROM sample_controls AS samp INNER JOIN sample_to_aliquot_controls AS sta_ctrl ON samp.id = sta_ctrl.sample_control_id INNER JOIN aliquot_controls AS al ON sta_ctrl.aliquot_control_id = al.id
WHERE samp.sample_type = 'ascite cell' AND al.aliquot_type = 'tube'),
(SELECT sta_ctrl.id FROM sample_controls AS samp INNER JOIN sample_to_aliquot_controls AS sta_ctrl ON samp.id = sta_ctrl.sample_control_id INNER JOIN aliquot_controls AS al ON sta_ctrl.aliquot_control_id = al.id
WHERE samp.sample_type = 'ascite cell' AND al.aliquot_type = 'tube'),
'active'),
-- *** ascite supernatant ***
((SELECT sta_ctrl.id FROM sample_controls AS samp INNER JOIN sample_to_aliquot_controls AS sta_ctrl ON samp.id = sta_ctrl.sample_control_id INNER JOIN aliquot_controls AS al ON sta_ctrl.aliquot_control_id = al.id
WHERE samp.sample_type = 'ascite supernatant' AND al.aliquot_type = 'tube'),
(SELECT sta_ctrl.id FROM sample_controls AS samp INNER JOIN sample_to_aliquot_controls AS sta_ctrl ON samp.id = sta_ctrl.sample_control_id INNER JOIN aliquot_controls AS al ON sta_ctrl.aliquot_control_id = al.id
WHERE samp.sample_type = 'ascite supernatant' AND al.aliquot_type = 'tube'),
'active'),
-- *** blood cell ***
((SELECT sta_ctrl.id FROM sample_controls AS samp INNER JOIN sample_to_aliquot_controls AS sta_ctrl ON samp.id = sta_ctrl.sample_control_id INNER JOIN aliquot_controls AS al ON sta_ctrl.aliquot_control_id = al.id
WHERE samp.sample_type = 'blood cell' AND al.aliquot_type = 'tube'),
(SELECT sta_ctrl.id FROM sample_controls AS samp INNER JOIN sample_to_aliquot_controls AS sta_ctrl ON samp.id = sta_ctrl.sample_control_id INNER JOIN aliquot_controls AS al ON sta_ctrl.aliquot_control_id = al.id
WHERE samp.sample_type = 'blood cell' AND al.aliquot_type = 'tube'),
'active'),
-- *** pbmc ***
((SELECT sta_ctrl.id FROM sample_controls AS samp INNER JOIN sample_to_aliquot_controls AS sta_ctrl ON samp.id = sta_ctrl.sample_control_id INNER JOIN aliquot_controls AS al ON sta_ctrl.aliquot_control_id = al.id
WHERE samp.sample_type = 'pbmc' AND al.aliquot_type = 'tube'),
(SELECT sta_ctrl.id FROM sample_controls AS samp INNER JOIN sample_to_aliquot_controls AS sta_ctrl ON samp.id = sta_ctrl.sample_control_id INNER JOIN aliquot_controls AS al ON sta_ctrl.aliquot_control_id = al.id
WHERE samp.sample_type = 'pbmc' AND al.aliquot_type = 'tube'),
'active'),
-- *** plasma ***
((SELECT sta_ctrl.id FROM sample_controls AS samp INNER JOIN sample_to_aliquot_controls AS sta_ctrl ON samp.id = sta_ctrl.sample_control_id INNER JOIN aliquot_controls AS al ON sta_ctrl.aliquot_control_id = al.id
WHERE samp.sample_type = 'plasma' AND al.aliquot_type = 'tube'),
(SELECT sta_ctrl.id FROM sample_controls AS samp INNER JOIN sample_to_aliquot_controls AS sta_ctrl ON samp.id = sta_ctrl.sample_control_id INNER JOIN aliquot_controls AS al ON sta_ctrl.aliquot_control_id = al.id
WHERE samp.sample_type = 'plasma' AND al.aliquot_type = 'tube'),
'active'),
-- *** serum ***
((SELECT sta_ctrl.id FROM sample_controls AS samp INNER JOIN sample_to_aliquot_controls AS sta_ctrl ON samp.id = sta_ctrl.sample_control_id INNER JOIN aliquot_controls AS al ON sta_ctrl.aliquot_control_id = al.id
WHERE samp.sample_type = 'serum' AND al.aliquot_type = 'tube'),
(SELECT sta_ctrl.id FROM sample_controls AS samp INNER JOIN sample_to_aliquot_controls AS sta_ctrl ON samp.id = sta_ctrl.sample_control_id INNER JOIN aliquot_controls AS al ON sta_ctrl.aliquot_control_id = al.id
WHERE samp.sample_type = 'serum' AND al.aliquot_type = 'tube'),
'active'),
-- *** cell culture ***
((SELECT sta_ctrl.id FROM sample_controls AS samp INNER JOIN sample_to_aliquot_controls AS sta_ctrl ON samp.id = sta_ctrl.sample_control_id INNER JOIN aliquot_controls AS al ON sta_ctrl.aliquot_control_id = al.id
WHERE samp.sample_type = 'cell culture' AND al.aliquot_type = 'tube'),
(SELECT sta_ctrl.id FROM sample_controls AS samp INNER JOIN sample_to_aliquot_controls AS sta_ctrl ON samp.id = sta_ctrl.sample_control_id INNER JOIN aliquot_controls AS al ON sta_ctrl.aliquot_control_id = al.id
WHERE samp.sample_type = 'cell culture' AND al.aliquot_type = 'tube'),
'active'),
((SELECT sta_ctrl.id FROM sample_controls AS samp INNER JOIN sample_to_aliquot_controls AS sta_ctrl ON samp.id = sta_ctrl.sample_control_id INNER JOIN aliquot_controls AS al ON sta_ctrl.aliquot_control_id = al.id
WHERE samp.sample_type = 'cell culture' AND al.aliquot_type = 'tube'),
(SELECT sta_ctrl.id FROM sample_controls AS samp INNER JOIN sample_to_aliquot_controls AS sta_ctrl ON samp.id = sta_ctrl.sample_control_id INNER JOIN aliquot_controls AS al ON sta_ctrl.aliquot_control_id = al.id
WHERE samp.sample_type = 'cell culture' AND al.aliquot_type = 'slide'),
'active'),
-- *** dna ***
((SELECT sta_ctrl.id FROM sample_controls AS samp INNER JOIN sample_to_aliquot_controls AS sta_ctrl ON samp.id = sta_ctrl.sample_control_id INNER JOIN aliquot_controls AS al ON sta_ctrl.aliquot_control_id = al.id
WHERE samp.sample_type = 'dna' AND al.aliquot_type = 'tube'),
(SELECT sta_ctrl.id FROM sample_controls AS samp INNER JOIN sample_to_aliquot_controls AS sta_ctrl ON samp.id = sta_ctrl.sample_control_id INNER JOIN aliquot_controls AS al ON sta_ctrl.aliquot_control_id = al.id
WHERE samp.sample_type = 'dna' AND al.aliquot_type = 'tube'),
'active'),
-- *** rna ***
((SELECT sta_ctrl.id FROM sample_controls AS samp INNER JOIN sample_to_aliquot_controls AS sta_ctrl ON samp.id = sta_ctrl.sample_control_id INNER JOIN aliquot_controls AS al ON sta_ctrl.aliquot_control_id = al.id
WHERE samp.sample_type = 'rna' AND al.aliquot_type = 'tube'),
(SELECT sta_ctrl.id FROM sample_controls AS samp INNER JOIN sample_to_aliquot_controls AS sta_ctrl ON samp.id = sta_ctrl.sample_control_id INNER JOIN aliquot_controls AS al ON sta_ctrl.aliquot_control_id = al.id
WHERE samp.sample_type = 'rna' AND al.aliquot_type = 'tube'),
'active'),
-- *** concentrated urine ***
((SELECT sta_ctrl.id FROM sample_controls AS samp INNER JOIN sample_to_aliquot_controls AS sta_ctrl ON samp.id = sta_ctrl.sample_control_id INNER JOIN aliquot_controls AS al ON sta_ctrl.aliquot_control_id = al.id
WHERE samp.sample_type = 'concentrated urine' AND al.aliquot_type = 'tube'),
(SELECT sta_ctrl.id FROM sample_controls AS samp INNER JOIN sample_to_aliquot_controls AS sta_ctrl ON samp.id = sta_ctrl.sample_control_id INNER JOIN aliquot_controls AS al ON sta_ctrl.aliquot_control_id = al.id
WHERE samp.sample_type = 'concentrated urine' AND al.aliquot_type = 'tube'),
'active'),
-- *** centrifuged urine ***
((SELECT sta_ctrl.id FROM sample_controls AS samp INNER JOIN sample_to_aliquot_controls AS sta_ctrl ON samp.id = sta_ctrl.sample_control_id INNER JOIN aliquot_controls AS al ON sta_ctrl.aliquot_control_id = al.id
WHERE samp.sample_type = 'centrifuged urine' AND al.aliquot_type = 'tube'),
(SELECT sta_ctrl.id FROM sample_controls AS samp INNER JOIN sample_to_aliquot_controls AS sta_ctrl ON samp.id = sta_ctrl.sample_control_id INNER JOIN aliquot_controls AS al ON sta_ctrl.aliquot_control_id = al.id
WHERE samp.sample_type = 'centrifuged urine' AND al.aliquot_type = 'tube'),
'active'),
-- *** amplified rna ***
((SELECT sta_ctrl.id FROM sample_controls AS samp INNER JOIN sample_to_aliquot_controls AS sta_ctrl ON samp.id = sta_ctrl.sample_control_id INNER JOIN aliquot_controls AS al ON sta_ctrl.aliquot_control_id = al.id
WHERE samp.sample_type = 'amplified rna' AND al.aliquot_type = 'tube'),
(SELECT sta_ctrl.id FROM sample_controls AS samp INNER JOIN sample_to_aliquot_controls AS sta_ctrl ON samp.id = sta_ctrl.sample_control_id INNER JOIN aliquot_controls AS al ON sta_ctrl.aliquot_control_id = al.id
WHERE samp.sample_type = 'amplified rna' AND al.aliquot_type = 'tube'),
'active'),
-- *** b cell ***
((SELECT sta_ctrl.id FROM sample_controls AS samp INNER JOIN sample_to_aliquot_controls AS sta_ctrl ON samp.id = sta_ctrl.sample_control_id INNER JOIN aliquot_controls AS al ON sta_ctrl.aliquot_control_id = al.id
WHERE samp.sample_type = 'b cell' AND al.aliquot_type = 'tube'),
(SELECT sta_ctrl.id FROM sample_controls AS samp INNER JOIN sample_to_aliquot_controls AS sta_ctrl ON samp.id = sta_ctrl.sample_control_id INNER JOIN aliquot_controls AS al ON sta_ctrl.aliquot_control_id = al.id
WHERE samp.sample_type = 'b cell' AND al.aliquot_type = 'tube'),
'active'),
((SELECT sta_ctrl.id FROM sample_controls AS samp INNER JOIN sample_to_aliquot_controls AS sta_ctrl ON samp.id = sta_ctrl.sample_control_id INNER JOIN aliquot_controls AS al ON sta_ctrl.aliquot_control_id = al.id
WHERE samp.sample_type = 'b cell' AND al.aliquot_type = 'tube'),
(SELECT sta_ctrl.id FROM sample_controls AS samp INNER JOIN sample_to_aliquot_controls AS sta_ctrl ON samp.id = sta_ctrl.sample_control_id INNER JOIN aliquot_controls AS al ON sta_ctrl.aliquot_control_id = al.id
WHERE samp.sample_type = 'b cell' AND al.aliquot_type = 'cell gel matrix'),
'active'),
((SELECT sta_ctrl.id FROM sample_controls AS samp INNER JOIN sample_to_aliquot_controls AS sta_ctrl ON samp.id = sta_ctrl.sample_control_id INNER JOIN aliquot_controls AS al ON sta_ctrl.aliquot_control_id = al.id
WHERE samp.sample_type = 'b cell' AND al.aliquot_type = 'cell gel matrix'),
(SELECT sta_ctrl.id FROM sample_controls AS samp INNER JOIN sample_to_aliquot_controls AS sta_ctrl ON samp.id = sta_ctrl.sample_control_id INNER JOIN aliquot_controls AS al ON sta_ctrl.aliquot_control_id = al.id
WHERE samp.sample_type = 'b cell' AND al.aliquot_type = 'core'),
'active'),
-- *** tissue lysate ***
((SELECT sta_ctrl.id FROM sample_controls AS samp INNER JOIN sample_to_aliquot_controls AS sta_ctrl ON samp.id = sta_ctrl.sample_control_id INNER JOIN aliquot_controls AS al ON sta_ctrl.aliquot_control_id = al.id
WHERE samp.sample_type = 'tissue lysate' AND al.aliquot_type = 'tube'),
(SELECT sta_ctrl.id FROM sample_controls AS samp INNER JOIN sample_to_aliquot_controls AS sta_ctrl ON samp.id = sta_ctrl.sample_control_id INNER JOIN aliquot_controls AS al ON sta_ctrl.aliquot_control_id = al.id
WHERE samp.sample_type = 'tissue lysate' AND al.aliquot_type = 'tube'),
'active'),
-- *** tissue suspension ***
((SELECT sta_ctrl.id FROM sample_controls AS samp INNER JOIN sample_to_aliquot_controls AS sta_ctrl ON samp.id = sta_ctrl.sample_control_id INNER JOIN aliquot_controls AS al ON sta_ctrl.aliquot_control_id = al.id
WHERE samp.sample_type = 'tissue suspension' AND al.aliquot_type = 'tube'),
(SELECT sta_ctrl.id FROM sample_controls AS samp INNER JOIN sample_to_aliquot_controls AS sta_ctrl ON samp.id = sta_ctrl.sample_control_id INNER JOIN aliquot_controls AS al ON sta_ctrl.aliquot_control_id = al.id
WHERE samp.sample_type = 'tissue suspension' AND al.aliquot_type = 'tube'),
'active'),
-- *** peritoneal wash ***
((SELECT sta_ctrl.id FROM sample_controls AS samp INNER JOIN sample_to_aliquot_controls AS sta_ctrl ON samp.id = sta_ctrl.sample_control_id INNER JOIN aliquot_controls AS al ON sta_ctrl.aliquot_control_id = al.id
WHERE samp.sample_type = 'peritoneal wash' AND al.aliquot_type = 'tube'),
(SELECT sta_ctrl.id FROM sample_controls AS samp INNER JOIN sample_to_aliquot_controls AS sta_ctrl ON samp.id = sta_ctrl.sample_control_id INNER JOIN aliquot_controls AS al ON sta_ctrl.aliquot_control_id = al.id
WHERE samp.sample_type = 'peritoneal wash' AND al.aliquot_type = 'tube'),
'active'),
-- *** cystic fluid ***
((SELECT sta_ctrl.id FROM sample_controls AS samp INNER JOIN sample_to_aliquot_controls AS sta_ctrl ON samp.id = sta_ctrl.sample_control_id INNER JOIN aliquot_controls AS al ON sta_ctrl.aliquot_control_id = al.id
WHERE samp.sample_type = 'cystic fluid' AND al.aliquot_type = 'tube'),
(SELECT sta_ctrl.id FROM sample_controls AS samp INNER JOIN sample_to_aliquot_controls AS sta_ctrl ON samp.id = sta_ctrl.sample_control_id INNER JOIN aliquot_controls AS al ON sta_ctrl.aliquot_control_id = al.id
WHERE samp.sample_type = 'cystic fluid' AND al.aliquot_type = 'tube'),
'active'),
-- *** peritoneal wash cell ***
((SELECT sta_ctrl.id FROM sample_controls AS samp INNER JOIN sample_to_aliquot_controls AS sta_ctrl ON samp.id = sta_ctrl.sample_control_id INNER JOIN aliquot_controls AS al ON sta_ctrl.aliquot_control_id = al.id
WHERE samp.sample_type = 'peritoneal wash cell' AND al.aliquot_type = 'tube'),
(SELECT sta_ctrl.id FROM sample_controls AS samp INNER JOIN sample_to_aliquot_controls AS sta_ctrl ON samp.id = sta_ctrl.sample_control_id INNER JOIN aliquot_controls AS al ON sta_ctrl.aliquot_control_id = al.id
WHERE samp.sample_type = 'peritoneal wash cell' AND al.aliquot_type = 'tube'),
'active'),
-- *** peritoneal wash supernatant ***
((SELECT sta_ctrl.id FROM sample_controls AS samp INNER JOIN sample_to_aliquot_controls AS sta_ctrl ON samp.id = sta_ctrl.sample_control_id INNER JOIN aliquot_controls AS al ON sta_ctrl.aliquot_control_id = al.id
WHERE samp.sample_type = 'peritoneal wash supernatant' AND al.aliquot_type = 'tube'),
(SELECT sta_ctrl.id FROM sample_controls AS samp INNER JOIN sample_to_aliquot_controls AS sta_ctrl ON samp.id = sta_ctrl.sample_control_id INNER JOIN aliquot_controls AS al ON sta_ctrl.aliquot_control_id = al.id
WHERE samp.sample_type = 'peritoneal wash supernatant' AND al.aliquot_type = 'tube'),
'active'),
-- *** cystic fluid cell ***
((SELECT sta_ctrl.id FROM sample_controls AS samp INNER JOIN sample_to_aliquot_controls AS sta_ctrl ON samp.id = sta_ctrl.sample_control_id INNER JOIN aliquot_controls AS al ON sta_ctrl.aliquot_control_id = al.id
WHERE samp.sample_type = 'cystic fluid cell' AND al.aliquot_type = 'tube'),
(SELECT sta_ctrl.id FROM sample_controls AS samp INNER JOIN sample_to_aliquot_controls AS sta_ctrl ON samp.id = sta_ctrl.sample_control_id INNER JOIN aliquot_controls AS al ON sta_ctrl.aliquot_control_id = al.id
WHERE samp.sample_type = 'cystic fluid cell' AND al.aliquot_type = 'tube'),
'active'),
-- *** cystic fluid supernatant ***
((SELECT sta_ctrl.id FROM sample_controls AS samp INNER JOIN sample_to_aliquot_controls AS sta_ctrl ON samp.id = sta_ctrl.sample_control_id INNER JOIN aliquot_controls AS al ON sta_ctrl.aliquot_control_id = al.id
WHERE samp.sample_type = 'cystic fluid supernatant' AND al.aliquot_type = 'tube'),
(SELECT sta_ctrl.id FROM sample_controls AS samp INNER JOIN sample_to_aliquot_controls AS sta_ctrl ON samp.id = sta_ctrl.sample_control_id INNER JOIN aliquot_controls AS al ON sta_ctrl.aliquot_control_id = al.id
WHERE samp.sample_type = 'cystic fluid supernatant' AND al.aliquot_type = 'tube'),
'active'),
-- *** pericardial fluid ***
((SELECT sta_ctrl.id FROM sample_controls AS samp INNER JOIN sample_to_aliquot_controls AS sta_ctrl ON samp.id = sta_ctrl.sample_control_id INNER JOIN aliquot_controls AS al ON sta_ctrl.aliquot_control_id = al.id
WHERE samp.sample_type = 'pericardial fluid' AND al.aliquot_type = 'tube'),
(SELECT sta_ctrl.id FROM sample_controls AS samp INNER JOIN sample_to_aliquot_controls AS sta_ctrl ON samp.id = sta_ctrl.sample_control_id INNER JOIN aliquot_controls AS al ON sta_ctrl.aliquot_control_id = al.id
WHERE samp.sample_type = 'pericardial fluid' AND al.aliquot_type = 'tube'),
'active'),
-- *** pleural fluid ***
((SELECT sta_ctrl.id FROM sample_controls AS samp INNER JOIN sample_to_aliquot_controls AS sta_ctrl ON samp.id = sta_ctrl.sample_control_id INNER JOIN aliquot_controls AS al ON sta_ctrl.aliquot_control_id = al.id
WHERE samp.sample_type = 'pleural fluid' AND al.aliquot_type = 'tube'),
(SELECT sta_ctrl.id FROM sample_controls AS samp INNER JOIN sample_to_aliquot_controls AS sta_ctrl ON samp.id = sta_ctrl.sample_control_id INNER JOIN aliquot_controls AS al ON sta_ctrl.aliquot_control_id = al.id
WHERE samp.sample_type = 'pleural fluid' AND al.aliquot_type = 'tube'),
'active'),
-- *** pericardial fluid cell ***
((SELECT sta_ctrl.id FROM sample_controls AS samp INNER JOIN sample_to_aliquot_controls AS sta_ctrl ON samp.id = sta_ctrl.sample_control_id INNER JOIN aliquot_controls AS al ON sta_ctrl.aliquot_control_id = al.id
WHERE samp.sample_type = 'pericardial fluid cell' AND al.aliquot_type = 'tube'),
(SELECT sta_ctrl.id FROM sample_controls AS samp INNER JOIN sample_to_aliquot_controls AS sta_ctrl ON samp.id = sta_ctrl.sample_control_id INNER JOIN aliquot_controls AS al ON sta_ctrl.aliquot_control_id = al.id
WHERE samp.sample_type = 'pericardial fluid cell' AND al.aliquot_type = 'tube'),
'active'),
-- *** pericardial fluid supernatant ***
((SELECT sta_ctrl.id FROM sample_controls AS samp INNER JOIN sample_to_aliquot_controls AS sta_ctrl ON samp.id = sta_ctrl.sample_control_id INNER JOIN aliquot_controls AS al ON sta_ctrl.aliquot_control_id = al.id
WHERE samp.sample_type = 'pericardial fluid supernatant' AND al.aliquot_type = 'tube'),
(SELECT sta_ctrl.id FROM sample_controls AS samp INNER JOIN sample_to_aliquot_controls AS sta_ctrl ON samp.id = sta_ctrl.sample_control_id INNER JOIN aliquot_controls AS al ON sta_ctrl.aliquot_control_id = al.id
WHERE samp.sample_type = 'pericardial fluid supernatant' AND al.aliquot_type = 'tube'),
'active'),
-- *** pleural fluid cell ***
((SELECT sta_ctrl.id FROM sample_controls AS samp INNER JOIN sample_to_aliquot_controls AS sta_ctrl ON samp.id = sta_ctrl.sample_control_id INNER JOIN aliquot_controls AS al ON sta_ctrl.aliquot_control_id = al.id
WHERE samp.sample_type = 'pleural fluid cell' AND al.aliquot_type = 'tube'),
(SELECT sta_ctrl.id FROM sample_controls AS samp INNER JOIN sample_to_aliquot_controls AS sta_ctrl ON samp.id = sta_ctrl.sample_control_id INNER JOIN aliquot_controls AS al ON sta_ctrl.aliquot_control_id = al.id
WHERE samp.sample_type = 'pleural fluid cell' AND al.aliquot_type = 'tube'),
'active'),
-- *** pleural fluid supernatant ***
((SELECT sta_ctrl.id FROM sample_controls AS samp INNER JOIN sample_to_aliquot_controls AS sta_ctrl ON samp.id = sta_ctrl.sample_control_id INNER JOIN aliquot_controls AS al ON sta_ctrl.aliquot_control_id = al.id
WHERE samp.sample_type = 'pleural fluid supernatant' AND al.aliquot_type = 'tube'),
(SELECT sta_ctrl.id FROM sample_controls AS samp INNER JOIN sample_to_aliquot_controls AS sta_ctrl ON samp.id = sta_ctrl.sample_control_id INNER JOIN aliquot_controls AS al ON sta_ctrl.aliquot_control_id = al.id
WHERE samp.sample_type = 'pleural fluid supernatant' AND al.aliquot_type = 'tube'),
'active'),
-- *** cell lysate ***
((SELECT sta_ctrl.id FROM sample_controls AS samp INNER JOIN sample_to_aliquot_controls AS sta_ctrl ON samp.id = sta_ctrl.sample_control_id INNER JOIN aliquot_controls AS al ON sta_ctrl.aliquot_control_id = al.id
WHERE samp.sample_type = 'cell lysate' AND al.aliquot_type = 'tube'),
(SELECT sta_ctrl.id FROM sample_controls AS samp INNER JOIN sample_to_aliquot_controls AS sta_ctrl ON samp.id = sta_ctrl.sample_control_id INNER JOIN aliquot_controls AS al ON sta_ctrl.aliquot_control_id = al.id
WHERE samp.sample_type = 'cell lysate' AND al.aliquot_type = 'tube'),
'active'),
-- *** protein ***
((SELECT sta_ctrl.id FROM sample_controls AS samp INNER JOIN sample_to_aliquot_controls AS sta_ctrl ON samp.id = sta_ctrl.sample_control_id INNER JOIN aliquot_controls AS al ON sta_ctrl.aliquot_control_id = al.id
WHERE samp.sample_type = 'protein' AND al.aliquot_type = 'tube'),
(SELECT sta_ctrl.id FROM sample_controls AS samp INNER JOIN sample_to_aliquot_controls AS sta_ctrl ON samp.id = sta_ctrl.sample_control_id INNER JOIN aliquot_controls AS al ON sta_ctrl.aliquot_control_id = al.id
WHERE samp.sample_type = 'protein' AND al.aliquot_type = 'tube'),
'active');

tableau a comparer avec celui de CTRNet


ALTER TABLE `structures` DROP `old_id`;

ALTER TABLE `structure_fields` DROP `old_id` ;
ALTER TABLE `structure_formats`
  DROP `old_id`,
  DROP `structure_old_id`,
  DROP `structure_field_old_id`;

-- Unique constraint for fields, move to end of script
ALTER TABLE `structure_fields`
	ADD UNIQUE `unique_fields` (`plugin`, `model`, `tablename`, `field`);
	ALTER TABLE  `configs` DROP  `config_debug`;
	
	
	
	
	


UPDATE storage_controls SET display_x_size=sqrt(IFNULL(coord_x_size, 1)), display_y_size=sqrt(IFNULL(coord_x_size, 1)) WHERE square_box=1;




