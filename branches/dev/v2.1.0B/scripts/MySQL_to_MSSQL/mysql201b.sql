
SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;




CREATE TABLE acos (
  id int(10) NOT NULL AUTO_INCREMENT,
  parent_id int(10) DEFAULT NULL,
  model varchar(255) DEFAULT NULL,
  foreign_key int(10) DEFAULT NULL,
  alias varchar(255) DEFAULT NULL,
  lft int(10) DEFAULT NULL,
  rght int(10) DEFAULT NULL,
  PRIMARY KEY (id),
  KEY acos_idx1 (lft,rght),
  KEY acos_idx2 (alias),
  KEY acos_idx3 (model,foreign_key)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE ad_bags (
  id int(11) NOT NULL AUTO_INCREMENT,
  aliquot_master_id int(11) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (id),
  KEY FK_ad_bags_aliquot_masters (aliquot_master_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE ad_bags_revs (
  id int(11) NOT NULL,
  aliquot_master_id int(11) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE ad_blocks (
  id int(11) NOT NULL AUTO_INCREMENT,
  aliquot_master_id int(11) DEFAULT NULL,
  block_type varchar(30) DEFAULT NULL,
  patho_dpt_block_code varchar(30) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (id),
  KEY FK_ad_blocks_aliquot_masters (aliquot_master_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE ad_blocks_revs (
  id int(11) NOT NULL,
  aliquot_master_id int(11) DEFAULT NULL,
  block_type varchar(30) DEFAULT NULL,
  patho_dpt_block_code varchar(30) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE ad_cell_cores (
  id int(11) NOT NULL AUTO_INCREMENT,
  aliquot_master_id int(11) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (id),
  KEY FK_ad_cell_cores_aliquot_masters (aliquot_master_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE ad_cell_cores_revs (
  id int(11) NOT NULL,
  aliquot_master_id int(11) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE ad_cell_slides (
  id int(11) NOT NULL AUTO_INCREMENT,
  aliquot_master_id int(11) DEFAULT NULL,
  immunochemistry varchar(30) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (id),
  KEY FK_ad_cell_slides_aliquot_masters (aliquot_master_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE ad_cell_slides_revs (
  id int(11) NOT NULL,
  aliquot_master_id int(11) DEFAULT NULL,
  immunochemistry varchar(30) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE ad_gel_matrices (
  id int(11) NOT NULL AUTO_INCREMENT,
  aliquot_master_id int(11) DEFAULT NULL,
  cell_count decimal(10,2) DEFAULT NULL,
  cell_count_unit varchar(20) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (id),
  KEY FK_ad_gel_matrices_aliquot_masters (aliquot_master_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE ad_gel_matrices_revs (
  id int(11) NOT NULL,
  aliquot_master_id int(11) DEFAULT NULL,
  cell_count decimal(10,2) DEFAULT NULL,
  cell_count_unit varchar(20) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE ad_tissue_cores (
  id int(11) NOT NULL AUTO_INCREMENT,
  aliquot_master_id int(11) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (id),
  KEY FK_ad_tissue_cores_aliquot_masters (aliquot_master_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE ad_tissue_cores_revs (
  id int(11) NOT NULL,
  aliquot_master_id int(11) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE ad_tissue_slides (
  id int(11) NOT NULL AUTO_INCREMENT,
  aliquot_master_id int(11) DEFAULT NULL,
  immunochemistry varchar(30) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (id),
  KEY FK_ad_tissue_slides_aliquot_masters (aliquot_master_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE ad_tissue_slides_revs (
  id int(11) NOT NULL,
  aliquot_master_id int(11) DEFAULT NULL,
  immunochemistry varchar(30) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE ad_tubes (
  id int(11) NOT NULL AUTO_INCREMENT,
  aliquot_master_id int(11) DEFAULT NULL,
  lot_number varchar(30) DEFAULT NULL,
  concentration decimal(10,2) DEFAULT NULL,
  concentration_unit varchar(20) DEFAULT NULL,
  cell_count decimal(10,2) DEFAULT NULL,
  cell_count_unit varchar(20) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (id),
  KEY FK_ad_tubes_aliquot_masters (aliquot_master_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE ad_tubes_revs (
  id int(11) NOT NULL,
  aliquot_master_id int(11) DEFAULT NULL,
  lot_number varchar(30) DEFAULT NULL,
  concentration decimal(10,2) DEFAULT NULL,
  concentration_unit varchar(20) DEFAULT NULL,
  cell_count decimal(10,2) DEFAULT NULL,
  cell_count_unit varchar(20) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE ad_whatman_papers (
  id int(11) NOT NULL AUTO_INCREMENT,
  aliquot_master_id int(11) DEFAULT NULL,
  used_blood_volume decimal(10,5) DEFAULT NULL,
  used_blood_volume_unit varchar(20) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (id),
  KEY FK_ad_whatman_papers_aliquot_masters (aliquot_master_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE ad_whatman_papers_revs (
  id int(11) NOT NULL,
  aliquot_master_id int(11) DEFAULT NULL,
  used_blood_volume decimal(10,5) DEFAULT NULL,
  used_blood_volume_unit varchar(20) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE aliquot_controls (
  id int(11) NOT NULL AUTO_INCREMENT,
  aliquot_type enum('block','cell gel matrix','core','slide','tube','whatman paper') NOT NULL COMMENT 'Generic name.',
  aliquot_type_precision varchar(30) DEFAULT NULL COMMENT 'Use to differentiate two aliquot controls having the same aliquot_type in case they can be used for the same sample type. (Ex: tissue tube (5ml) and tissue tube (cryogenic)).',
  form_alias varchar(255) NOT NULL,
  detail_tablename varchar(255) NOT NULL,
  volume_unit varchar(20) DEFAULT NULL,
  `comment` varchar(255) DEFAULT NULL,
  display_order int(11) NOT NULL DEFAULT '0',
  databrowser_label varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (id)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=16 ;



CREATE TABLE aliquot_masters (
  id int(11) NOT NULL AUTO_INCREMENT,
  barcode varchar(60) NOT NULL DEFAULT '',
  aliquot_type varchar(30) NOT NULL DEFAULT '',
  aliquot_control_id int(11) NOT NULL DEFAULT '0',
  collection_id int(11) DEFAULT NULL,
  sample_master_id int(11) DEFAULT NULL,
  sop_master_id int(11) DEFAULT NULL,
  initial_volume decimal(10,5) DEFAULT NULL,
  current_volume decimal(10,5) DEFAULT NULL,
  aliquot_volume_unit varchar(20) DEFAULT NULL,
  in_stock varchar(30) DEFAULT NULL,
  in_stock_detail varchar(30) DEFAULT NULL,
  study_summary_id int(11) DEFAULT NULL,
  storage_datetime datetime DEFAULT NULL,
  storage_master_id int(11) DEFAULT NULL,
  storage_coord_x varchar(11) DEFAULT NULL,
  coord_x_order int(3) DEFAULT NULL,
  storage_coord_y varchar(11) DEFAULT NULL,
  coord_y_order int(3) DEFAULT NULL,
  product_code varchar(20) DEFAULT NULL,
  notes text,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (id),
  KEY barcode (barcode),
  KEY aliquot_type (aliquot_type),
  KEY FK_aliquot_masters_aliquot_controls (aliquot_control_id),
  KEY FK_aliquot_masters_collections (collection_id),
  KEY FK_aliquot_masters_sample_masters (sample_master_id),
  KEY FK_aliquot_masters_sops (sop_master_id),
  KEY FK_aliquot_masters_study_summaries (study_summary_id),
  KEY FK_aliquot_masters_storage_masters (storage_master_id),
  KEY barcode_2 (barcode)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE aliquot_masters_revs (
  id int(11) NOT NULL,
  barcode varchar(60) NOT NULL DEFAULT '',
  aliquot_type varchar(30) NOT NULL DEFAULT '',
  aliquot_control_id int(11) NOT NULL DEFAULT '0',
  collection_id int(11) DEFAULT NULL,
  sample_master_id int(11) DEFAULT NULL,
  sop_master_id int(11) DEFAULT NULL,
  initial_volume decimal(10,5) DEFAULT NULL,
  current_volume decimal(10,5) DEFAULT NULL,
  aliquot_volume_unit varchar(20) DEFAULT NULL,
  in_stock varchar(30) DEFAULT NULL,
  in_stock_detail varchar(30) DEFAULT NULL,
  study_summary_id int(11) DEFAULT NULL,
  storage_datetime datetime DEFAULT NULL,
  storage_master_id int(11) DEFAULT NULL,
  storage_coord_x varchar(11) DEFAULT NULL,
  coord_x_order int(3) DEFAULT NULL,
  storage_coord_y varchar(11) DEFAULT NULL,
  coord_y_order int(3) DEFAULT NULL,
  product_code varchar(20) DEFAULT NULL,
  notes text,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE aliquot_review_controls (
  id int(11) NOT NULL AUTO_INCREMENT,
  review_type varchar(100) NOT NULL,
  flag_active tinyint(1) NOT NULL DEFAULT '1',
  form_alias varchar(255) NOT NULL,
  detail_tablename varchar(255) NOT NULL,
  aliquot_type_restriction enum('all','block','cell gel matrix','core','slide','tube','whatman paper') NOT NULL DEFAULT 'all' COMMENT 'Allow to link specific aliquot type to the specimen review.',
  PRIMARY KEY (id),
  UNIQUE KEY review_type (review_type)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=2 ;



CREATE TABLE aliquot_review_masters (
  id int(11) NOT NULL AUTO_INCREMENT,
  aliquot_review_control_id int(11) NOT NULL DEFAULT '0',
  specimen_review_master_id int(11) DEFAULT NULL,
  aliquot_masters_id int(11) DEFAULT NULL,
  aliquot_use_id int(11) DEFAULT NULL,
  review_code varchar(100) NOT NULL,
  basis_of_specimen_review tinyint(1) NOT NULL DEFAULT '0',
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (id),
  KEY FK_aliquot_review_masters_specimen_review_masters (specimen_review_master_id),
  KEY FK_aliquot_review_masters_aliquot_masters (aliquot_masters_id),
  KEY FK_aliquot_review_masters_aliquot_review_controls (aliquot_review_control_id),
  KEY FK_aliquot_review_masters_aliquot_uses (aliquot_use_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE aliquot_review_masters_revs (
  id int(11) NOT NULL,
  aliquot_review_control_id int(11) NOT NULL DEFAULT '0',
  specimen_review_master_id int(11) DEFAULT NULL,
  aliquot_masters_id int(11) DEFAULT NULL,
  aliquot_use_id int(11) DEFAULT NULL,
  review_code varchar(100) NOT NULL,
  basis_of_specimen_review tinyint(1) NOT NULL DEFAULT '0',
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE aliquot_uses (
  id int(11) NOT NULL AUTO_INCREMENT,
  aliquot_master_id int(11) DEFAULT NULL,
  use_definition varchar(30) DEFAULT NULL,
  use_code varchar(50) DEFAULT NULL,
  use_details varchar(250) DEFAULT NULL,
  use_recorded_into_table varchar(40) DEFAULT NULL,
  used_volume decimal(10,5) DEFAULT NULL,
  use_datetime datetime DEFAULT NULL,
  used_by varchar(50) DEFAULT NULL,
  study_summary_id int(11) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (id),
  KEY FK_aliquot_uses_study_summaries (study_summary_id),
  KEY FK_aliquot_uses_aliquot_masters (aliquot_master_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE aliquot_uses_revs (
  id int(11) NOT NULL,
  aliquot_master_id int(11) DEFAULT NULL,
  use_definition varchar(30) DEFAULT NULL,
  use_code varchar(50) DEFAULT NULL,
  use_details varchar(250) DEFAULT NULL,
  use_recorded_into_table varchar(40) DEFAULT NULL,
  used_volume decimal(10,5) DEFAULT NULL,
  use_datetime datetime DEFAULT NULL,
  used_by varchar(50) DEFAULT NULL,
  study_summary_id int(11) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE announcements (
  id int(11) NOT NULL AUTO_INCREMENT,
  user_id int(11) DEFAULT NULL,
  group_id int(11) DEFAULT NULL,
  bank_id int(11) DEFAULT '0',
  `date` date NOT NULL DEFAULT '0000-00-00',
  title varchar(255) NOT NULL DEFAULT '',
  body text NOT NULL,
  date_start date NOT NULL DEFAULT '0000-00-00',
  date_end date NOT NULL DEFAULT '0000-00-00',
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  modified_by int(10) unsigned NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (id)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=2 ;



CREATE TABLE aros (
  id int(10) NOT NULL AUTO_INCREMENT,
  parent_id int(10) DEFAULT NULL,
  model varchar(255) DEFAULT NULL,
  foreign_key int(10) DEFAULT NULL,
  alias varchar(255) DEFAULT NULL,
  lft int(10) DEFAULT NULL,
  rght int(10) DEFAULT NULL,
  PRIMARY KEY (id),
  KEY aros_idx1 (lft,rght),
  KEY aros_idx2 (alias),
  KEY aros_idx3 (model,foreign_key)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=7 ;



CREATE TABLE aros_acos (
  id int(10) NOT NULL AUTO_INCREMENT,
  aro_id int(10) NOT NULL,
  aco_id int(10) NOT NULL,
  _create varchar(2) NOT NULL DEFAULT '0',
  _read varchar(2) NOT NULL DEFAULT '0',
  _update varchar(2) NOT NULL DEFAULT '0',
  _delete varchar(2) NOT NULL DEFAULT '0',
  PRIMARY KEY (id),
  UNIQUE KEY ARO_ACO_KEY (aro_id,aco_id)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=4 ;



CREATE TABLE ar_breast_tissue_slides (
  id int(11) NOT NULL AUTO_INCREMENT,
  aliquot_review_master_id int(11) DEFAULT NULL,
  `type` varchar(100) NOT NULL,
  length decimal(5,1) DEFAULT NULL,
  width decimal(5,1) DEFAULT NULL,
  invasive_percentage decimal(5,1) DEFAULT NULL,
  in_situ_percentage decimal(5,1) DEFAULT NULL,
  normal_percentage decimal(5,1) DEFAULT NULL,
  stroma_percentage decimal(5,1) DEFAULT NULL,
  necrosis_inv_percentage decimal(5,1) DEFAULT NULL,
  necrosis_is_percentage decimal(5,1) DEFAULT NULL,
  inflammation int(4) DEFAULT NULL,
  quality_score int(4) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (id),
  KEY FK_ar_breast_tissue_slides_aliquot_review_masters (aliquot_review_master_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE ar_breast_tissue_slides_revs (
  id int(11) NOT NULL,
  aliquot_review_master_id int(11) DEFAULT NULL,
  `type` varchar(100) NOT NULL,
  length decimal(5,1) DEFAULT NULL,
  width decimal(5,1) DEFAULT NULL,
  invasive_percentage decimal(5,1) DEFAULT NULL,
  in_situ_percentage decimal(5,1) DEFAULT NULL,
  normal_percentage decimal(5,1) DEFAULT NULL,
  stroma_percentage decimal(5,1) DEFAULT NULL,
  necrosis_inv_percentage decimal(5,1) DEFAULT NULL,
  necrosis_is_percentage decimal(5,1) DEFAULT NULL,
  inflammation int(4) DEFAULT NULL,
  quality_score int(4) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE atim_information (
  id int(11) NOT NULL AUTO_INCREMENT,
  tablename varchar(255) DEFAULT NULL,
  field varchar(255) DEFAULT NULL,
  data_element_identifier varchar(225) DEFAULT NULL,
  datatype varchar(255) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  modified_by int(10) unsigned NOT NULL,
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE banks (
  id int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL DEFAULT '',
  description text NOT NULL,
  created_by int(10) unsigned NOT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  modified_by int(10) unsigned NOT NULL,
  modified datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (id)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=2 ;



CREATE TABLE banks_revs (
  id int(11) NOT NULL,
  `name` varchar(255) NOT NULL DEFAULT '',
  description text NOT NULL,
  created_by int(10) unsigned NOT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  modified_by int(10) unsigned NOT NULL,
  modified datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE cake_sessions (
  id varchar(255) NOT NULL DEFAULT '',
  `data` text,
  expires int(11) DEFAULT NULL,
  PRIMARY KEY (id)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;



CREATE TABLE cd_nationals (
  id int(11) NOT NULL AUTO_INCREMENT,
  consent_master_id int(11) NOT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (id),
  KEY consent_master_id (consent_master_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE cd_nationals_revs (
  id int(11) NOT NULL,
  consent_master_id int(11) NOT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE clinical_collection_links (
  id int(11) NOT NULL AUTO_INCREMENT,
  participant_id int(11) DEFAULT NULL,
  collection_id int(11) DEFAULT NULL,
  diagnosis_master_id int(11) DEFAULT NULL,
  consent_master_id int(11) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  modified_by int(10) unsigned NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (id),
  KEY participant_id (participant_id),
  KEY collection_id (collection_id),
  KEY diagnosis_master_id (diagnosis_master_id),
  KEY consent_master_id (consent_master_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE clinical_collection_links_revs (
  id int(11) NOT NULL,
  participant_id int(11) DEFAULT NULL,
  collection_id int(11) DEFAULT NULL,
  diagnosis_master_id int(11) DEFAULT NULL,
  consent_master_id int(11) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  modified_by int(10) unsigned NOT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (version_id),
  KEY participant_id (participant_id),
  KEY collection_id (collection_id),
  KEY diagnosis_master_id (diagnosis_master_id),
  KEY consent_master_id (consent_master_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE coding_adverse_events (
  id int(11) NOT NULL AUTO_INCREMENT,
  category varchar(50) NOT NULL DEFAULT '',
  `supra-ordinate_term` varchar(255) NOT NULL DEFAULT '',
  select_ae varchar(255) DEFAULT NULL,
  grade int(11) NOT NULL DEFAULT '0',
  description text NOT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  modified_by int(10) unsigned NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE coding_adverse_events_revs (
  id int(11) NOT NULL,
  category varchar(50) NOT NULL DEFAULT '',
  `supra-ordinate_term` varchar(255) NOT NULL DEFAULT '',
  select_ae varchar(255) DEFAULT NULL,
  grade int(11) NOT NULL DEFAULT '0',
  description text NOT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  modified_by int(10) unsigned NOT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE coding_icd10_ca (
  id varchar(8) NOT NULL,
  en_title varchar(255) DEFAULT NULL,
  fr_title varchar(255) DEFAULT NULL,
  en_sub_title varchar(255) DEFAULT NULL,
  fr_sub_title varchar(255) DEFAULT NULL,
  en_description text,
  fr_description text,
  PRIMARY KEY (id),
  FULLTEXT KEY en_title (en_title),
  FULLTEXT KEY fr_title (fr_title),
  FULLTEXT KEY en_sub_title (en_sub_title),
  FULLTEXT KEY fr_sub_title (fr_sub_title),
  FULLTEXT KEY en_description (en_description),
  FULLTEXT KEY fr_description (fr_description)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;



CREATE TABLE coding_icd10_who (
  id varchar(8) NOT NULL,
  en_title varchar(255) DEFAULT NULL,
  fr_title varchar(255) DEFAULT NULL,
  en_sub_title varchar(255) DEFAULT NULL,
  fr_sub_title varchar(255) DEFAULT NULL,
  en_description text,
  fr_description text,
  PRIMARY KEY (id),
  FULLTEXT KEY en_title (en_title),
  FULLTEXT KEY fr_title (fr_title),
  FULLTEXT KEY en_sub_title (en_sub_title),
  FULLTEXT KEY fr_sub_title (fr_sub_title),
  FULLTEXT KEY en_description (en_description),
  FULLTEXT KEY fr_description (fr_description)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;



CREATE TABLE coding_icd_o_3_morphology (
  id int(11) NOT NULL,
  en_description text,
  fr_description text,
  PRIMARY KEY (id),
  FULLTEXT KEY en_description (en_description),
  FULLTEXT KEY fr_description (fr_description)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;



CREATE TABLE coding_icd_o_3_topography (
  id varchar(4) NOT NULL,
  en_title varchar(255) DEFAULT NULL,
  fr_title varchar(255) DEFAULT NULL,
  en_sub_title varchar(255) DEFAULT NULL,
  fr_sub_title varchar(255) DEFAULT NULL,
  en_description text,
  fr_description text,
  PRIMARY KEY (id),
  FULLTEXT KEY en_title (en_title),
  FULLTEXT KEY fr_title (fr_title),
  FULLTEXT KEY en_sub_title (en_sub_title),
  FULLTEXT KEY fr_sub_title (fr_sub_title),
  FULLTEXT KEY en_description (en_description),
  FULLTEXT KEY fr_description (fr_description)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;



CREATE TABLE collections (
  id int(11) NOT NULL AUTO_INCREMENT,
  acquisition_label varchar(50) NOT NULL DEFAULT '',
  bank_id int(11) DEFAULT NULL,
  collection_site varchar(30) DEFAULT NULL,
  collection_datetime datetime DEFAULT NULL,
  collection_datetime_accuracy varchar(4) DEFAULT NULL,
  sop_master_id int(11) DEFAULT NULL,
  collection_property varchar(50) DEFAULT NULL,
  collection_notes text,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (id),
  KEY acquisition_label (acquisition_label),
  KEY FK_collections_banks (bank_id),
  KEY FK_collections_sops (sop_master_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE collections_revs (
  id int(11) NOT NULL,
  acquisition_label varchar(50) NOT NULL DEFAULT '',
  bank_id int(11) DEFAULT NULL,
  collection_site varchar(30) DEFAULT NULL,
  collection_datetime datetime DEFAULT NULL,
  collection_datetime_accuracy varchar(4) DEFAULT NULL,
  sop_master_id int(11) DEFAULT NULL,
  collection_property varchar(50) DEFAULT NULL,
  collection_notes text,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE configs (
  id int(11) NOT NULL AUTO_INCREMENT,
  bank_id int(11) DEFAULT NULL,
  group_id int(11) DEFAULT NULL,
  user_id int(11) DEFAULT NULL,
  config_language varchar(255) NOT NULL DEFAULT 'eng',
  define_date_format varchar(255) NOT NULL DEFAULT 'MDY',
  define_time_format enum('12','24') NOT NULL DEFAULT '24',
  define_csv_separator varchar(255) NOT NULL DEFAULT ',',
  define_show_help varchar(255) NOT NULL DEFAULT '1',
  define_show_summary varchar(255) NOT NULL DEFAULT '1',
  define_pagination_amount varchar(255) NOT NULL DEFAULT '10',
  define_decimal_separator enum(',','.') NOT NULL DEFAULT '.',
  define_datetime_input_type enum('dropdown','textual') NOT NULL DEFAULT 'dropdown',
  define_show_advanced_controls varchar(255) NOT NULL DEFAULT '1',
  created datetime NOT NULL,
  created_by int(10) unsigned NOT NULL,
  modified datetime NOT NULL,
  modified_by int(10) unsigned NOT NULL,
  PRIMARY KEY (id)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=2 ;



CREATE TABLE consent_controls (
  id int(11) NOT NULL AUTO_INCREMENT,
  controls_type varchar(50) NOT NULL,
  flag_active tinyint(1) NOT NULL DEFAULT '1',
  form_alias varchar(255) NOT NULL,
  detail_tablename varchar(255) NOT NULL,
  display_order int(11) NOT NULL DEFAULT '0',
  databrowser_label varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (id)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=2 ;



CREATE TABLE consent_masters (
  id int(11) NOT NULL AUTO_INCREMENT,
  date_of_referral date DEFAULT NULL,
  route_of_referral varchar(50) DEFAULT NULL,
  date_first_contact date DEFAULT NULL,
  consent_signed_date date DEFAULT NULL,
  form_version varchar(50) DEFAULT NULL,
  reason_denied varchar(200) DEFAULT NULL,
  consent_status varchar(50) DEFAULT NULL,
  process_status varchar(50) DEFAULT NULL,
  status_date date DEFAULT NULL,
  surgeon varchar(50) DEFAULT NULL,
  operation_date datetime DEFAULT NULL,
  facility varchar(50) DEFAULT NULL,
  notes text,
  consent_method varchar(50) DEFAULT NULL,
  translator_indicator varchar(50) DEFAULT NULL,
  translator_signature varchar(50) DEFAULT NULL,
  consent_person varchar(50) DEFAULT NULL,
  facility_other varchar(50) DEFAULT NULL,
  consent_master_id int(11) DEFAULT NULL,
  acquisition_id varchar(10) DEFAULT NULL,
  participant_id int(11) NOT NULL DEFAULT '0',
  consent_control_id int(11) NOT NULL,
  `type` varchar(10) NOT NULL DEFAULT '',
  created datetime DEFAULT NULL,
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (id),
  KEY participant_id (participant_id),
  KEY consent_control_id (consent_control_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE consent_masters_revs (
  id int(11) NOT NULL,
  date_of_referral date DEFAULT NULL,
  route_of_referral varchar(50) DEFAULT NULL,
  date_first_contact date DEFAULT NULL,
  consent_signed_date date DEFAULT NULL,
  form_version varchar(50) DEFAULT NULL,
  reason_denied varchar(200) DEFAULT NULL,
  consent_status varchar(50) DEFAULT NULL,
  process_status varchar(50) DEFAULT NULL,
  status_date date DEFAULT NULL,
  surgeon varchar(50) DEFAULT NULL,
  operation_date datetime DEFAULT NULL,
  facility varchar(50) DEFAULT NULL,
  notes text,
  consent_method varchar(50) DEFAULT NULL,
  translator_indicator varchar(50) DEFAULT NULL,
  translator_signature varchar(50) DEFAULT NULL,
  consent_person varchar(50) DEFAULT NULL,
  facility_other varchar(50) DEFAULT NULL,
  consent_master_id int(11) DEFAULT NULL,
  acquisition_id varchar(10) DEFAULT NULL,
  participant_id int(11) NOT NULL DEFAULT '0',
  consent_control_id int(11) NOT NULL,
  `type` varchar(10) NOT NULL DEFAULT '',
  created datetime DEFAULT NULL,
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE datamart_adhoc (
  id int(11) NOT NULL AUTO_INCREMENT,
  title varchar(50) NOT NULL DEFAULT '',
  description text,
  `plugin` varchar(255) NOT NULL,
  model varchar(255) NOT NULL DEFAULT '',
  form_alias_for_search varchar(255) DEFAULT NULL,
  form_alias_for_results varchar(255) DEFAULT NULL,
  form_links_for_results varchar(255) DEFAULT NULL,
  sql_query_for_results text NOT NULL,
  flag_use_query_results tinyint(4) NOT NULL DEFAULT '0',
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  modified_by int(10) unsigned NOT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY title (title)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE datamart_adhoc_favourites (
  id int(11) NOT NULL AUTO_INCREMENT,
  adhoc_id int(11) DEFAULT NULL,
  user_id int(11) DEFAULT NULL,
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE datamart_adhoc_saved (
  id int(11) NOT NULL AUTO_INCREMENT,
  adhoc_id int(11) DEFAULT NULL,
  user_id int(11) DEFAULT NULL,
  search_params text NOT NULL,
  description text NOT NULL,
  created datetime NOT NULL,
  modified datetime NOT NULL,
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE datamart_batch_ids (
  id int(11) NOT NULL AUTO_INCREMENT,
  set_id int(11) DEFAULT NULL,
  lookup_id int(11) DEFAULT NULL,
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE datamart_batch_processes (
  id int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL DEFAULT '',
  `plugin` varchar(100) NOT NULL,
  model varchar(255) NOT NULL DEFAULT '',
  url varchar(255) NOT NULL DEFAULT '',
  flag_active tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (id)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=3 ;



CREATE TABLE datamart_batch_sets (
  id int(11) NOT NULL AUTO_INCREMENT,
  user_id int(11) DEFAULT NULL,
  group_id int(11) DEFAULT NULL,
  sharing_status varchar(50) DEFAULT 'user',
  title varchar(50) NOT NULL DEFAULT 'unknown',
  description text,
  `plugin` varchar(100) NOT NULL,
  model varchar(255) NOT NULL DEFAULT '',
  lookup_key_name varchar(50) NOT NULL DEFAULT 'id',
  form_alias_for_results varchar(255) NOT NULL,
  sql_query_for_results text NOT NULL,
  form_links_for_results text NOT NULL,
  flag_use_query_results tinyint(4) NOT NULL DEFAULT '0',
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  modified_by int(10) unsigned NOT NULL,
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE datamart_browsing_controls (
  id1 int(10) unsigned NOT NULL,
  id2 int(10) unsigned NOT NULL,
  flag_active_1_to_2 tinyint(1) NOT NULL DEFAULT '1',
  flag_active_2_to_1 tinyint(1) NOT NULL DEFAULT '1',
  use_field varchar(50) NOT NULL,
  UNIQUE KEY id1 (id1,id2),
  KEY id2 (id2)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



CREATE TABLE datamart_browsing_indexes (
  id int(10) unsigned NOT NULL AUTO_INCREMENT,
  root_node_id int(10) unsigned NOT NULL,
  notes text NOT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (id),
  KEY root_node_id (root_node_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE datamart_browsing_indexes_revs (
  id int(10) unsigned NOT NULL,
  root_node_id int(10) unsigned NOT NULL,
  notes text NOT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE datamart_browsing_results (
  id int(10) unsigned NOT NULL AUTO_INCREMENT,
  user_id int(10) unsigned NOT NULL,
  parent_node_id tinyint(3) unsigned DEFAULT NULL,
  browsing_structures_id int(10) unsigned DEFAULT NULL,
  browsing_structures_sub_id int(10) unsigned DEFAULT '0',
  raw tinyint(1) NOT NULL,
  serialized_search_params text NOT NULL,
  id_csv text NOT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE datamart_browsing_results_revs (
  id int(10) unsigned NOT NULL,
  user_id int(10) unsigned NOT NULL,
  parent_node_id tinyint(3) unsigned DEFAULT NULL,
  browsing_structures_id int(10) unsigned DEFAULT NULL,
  browsing_structures_sub_id int(10) unsigned DEFAULT '0',
  raw tinyint(1) NOT NULL,
  serialized_search_params text NOT NULL,
  id_csv text NOT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE datamart_reports (
  id int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL DEFAULT '',
  description text NOT NULL,
  form_alias_for_search varchar(255) DEFAULT NULL,
  form_alias_for_results varchar(255) DEFAULT NULL,
  form_type_for_results enum('detail','index') NOT NULL,
  `function` varchar(50) DEFAULT NULL,
  flag_active tinyint(1) NOT NULL DEFAULT '1',
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  PRIMARY KEY (id)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=6 ;



CREATE TABLE datamart_structures (
  id int(10) unsigned NOT NULL AUTO_INCREMENT,
  `plugin` varchar(50) NOT NULL,
  model varchar(50) NOT NULL,
  structure_id int(11) NOT NULL,
  display_name varchar(50) NOT NULL,
  use_key varchar(50) NOT NULL,
  control_model varchar(50) DEFAULT '',
  control_master_model varchar(50) DEFAULT '',
  control_field varchar(50) DEFAULT '',
  PRIMARY KEY (id),
  KEY structure_id (structure_id)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=16 ;



CREATE TABLE derivative_details (
  id int(11) NOT NULL AUTO_INCREMENT,
  sample_master_id int(11) DEFAULT NULL,
  creation_site varchar(30) DEFAULT NULL,
  creation_by varchar(50) DEFAULT NULL,
  creation_datetime datetime DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (id),
  KEY FK_detivative_details_sample_masters (sample_master_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE derivative_details_revs (
  id int(11) NOT NULL,
  sample_master_id int(11) DEFAULT NULL,
  creation_site varchar(30) DEFAULT NULL,
  creation_by varchar(50) DEFAULT NULL,
  creation_datetime datetime DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE diagnosis_controls (
  id int(11) NOT NULL AUTO_INCREMENT,
  controls_type varchar(50) NOT NULL,
  flag_active tinyint(1) NOT NULL DEFAULT '1',
  form_alias varchar(255) NOT NULL,
  detail_tablename varchar(255) NOT NULL,
  display_order int(11) NOT NULL DEFAULT '0',
  databrowser_label varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (id)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=14 ;



CREATE TABLE diagnosis_masters (
  id int(11) NOT NULL AUTO_INCREMENT,
  dx_identifier varchar(50) DEFAULT NULL,
  primary_number int(11) DEFAULT NULL,
  dx_method varchar(20) DEFAULT NULL,
  dx_nature varchar(50) DEFAULT NULL,
  dx_origin varchar(50) DEFAULT NULL,
  dx_date date DEFAULT NULL,
  dx_date_accuracy varchar(50) DEFAULT NULL,
  tumor_size_greatest_dimension decimal(3,1) DEFAULT NULL,
  additional_dimension_a decimal(3,1) DEFAULT NULL,
  additional_dimension_b decimal(3,1) DEFAULT NULL,
  tumor_size_cannot_be_determined tinyint(1) DEFAULT '0',
  primary_icd10_code varchar(10) DEFAULT NULL,
  previous_primary_code varchar(10) DEFAULT NULL,
  previous_primary_code_system varchar(50) DEFAULT NULL,
  morphology varchar(50) DEFAULT NULL,
  topography varchar(50) DEFAULT NULL,
  tumour_grade varchar(150) DEFAULT NULL,
  tumour_grade_specify varchar(250) DEFAULT NULL,
  age_at_dx int(11) DEFAULT NULL,
  age_at_dx_accuracy varchar(50) DEFAULT NULL,
  ajcc_edition varchar(50) DEFAULT NULL,
  collaborative_staged varchar(50) DEFAULT NULL,
  clinical_tstage varchar(5) DEFAULT NULL,
  clinical_nstage varchar(5) DEFAULT NULL,
  clinical_mstage varchar(5) DEFAULT NULL,
  clinical_stage_summary varchar(5) DEFAULT NULL,
  path_tnm_descriptor_m tinyint(1) DEFAULT '0',
  path_tnm_descriptor_r tinyint(1) DEFAULT '0',
  path_tnm_descriptor_y tinyint(1) DEFAULT '0',
  path_tstage varchar(5) DEFAULT NULL,
  path_nstage varchar(5) DEFAULT NULL,
  path_nstage_nbr_node_examined smallint(1) DEFAULT '0',
  path_nstage_nbr_node_involved smallint(1) DEFAULT '0',
  path_mstage varchar(15) DEFAULT NULL,
  path_mstage_metastasis_site_specify varchar(250) DEFAULT NULL,
  path_stage_summary varchar(5) DEFAULT NULL,
  survival_time_months int(11) DEFAULT NULL,
  information_source varchar(50) DEFAULT NULL,
  notes text,
  diagnosis_control_id int(11) NOT NULL DEFAULT '0',
  participant_id int(11) NOT NULL DEFAULT '0',
  created datetime DEFAULT NULL,
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (id),
  KEY participant_id (participant_id),
  KEY diagnosis_control_id (diagnosis_control_id),
  KEY FK_diagnosis_masters_icd10_code (primary_icd10_code)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE diagnosis_masters_revs (
  id int(11) NOT NULL,
  dx_identifier varchar(50) DEFAULT NULL,
  primary_number int(11) DEFAULT NULL,
  dx_method varchar(20) DEFAULT NULL,
  dx_nature varchar(50) DEFAULT NULL,
  dx_origin varchar(50) DEFAULT NULL,
  dx_date date DEFAULT NULL,
  dx_date_accuracy varchar(50) DEFAULT NULL,
  tumor_size_greatest_dimension decimal(3,1) DEFAULT NULL,
  additional_dimension_a decimal(3,1) DEFAULT NULL,
  additional_dimension_b decimal(3,1) DEFAULT NULL,
  tumor_size_cannot_be_determined tinyint(1) DEFAULT '0',
  primary_icd10_code varchar(10) DEFAULT NULL,
  previous_primary_code varchar(10) DEFAULT NULL,
  previous_primary_code_system varchar(50) DEFAULT NULL,
  morphology varchar(50) DEFAULT NULL,
  topography varchar(50) DEFAULT NULL,
  tumour_grade varchar(150) DEFAULT NULL,
  tumour_grade_specify varchar(250) DEFAULT NULL,
  age_at_dx int(11) DEFAULT NULL,
  age_at_dx_accuracy varchar(50) DEFAULT NULL,
  ajcc_edition varchar(50) DEFAULT NULL,
  collaborative_staged varchar(50) DEFAULT NULL,
  clinical_tstage varchar(5) DEFAULT NULL,
  clinical_nstage varchar(5) DEFAULT NULL,
  clinical_mstage varchar(5) DEFAULT NULL,
  clinical_stage_summary varchar(5) DEFAULT NULL,
  path_tnm_descriptor_m tinyint(1) DEFAULT '0',
  path_tnm_descriptor_r tinyint(1) DEFAULT '0',
  path_tnm_descriptor_y tinyint(1) DEFAULT '0',
  path_tstage varchar(5) DEFAULT NULL,
  path_nstage varchar(5) DEFAULT NULL,
  path_nstage_nbr_node_examined smallint(1) DEFAULT '0',
  path_nstage_nbr_node_involved smallint(1) DEFAULT '0',
  path_mstage varchar(15) DEFAULT NULL,
  path_mstage_metastasis_site_specify varchar(250) DEFAULT NULL,
  path_stage_summary varchar(5) DEFAULT NULL,
  survival_time_months int(11) DEFAULT NULL,
  information_source varchar(50) DEFAULT NULL,
  notes text,
  diagnosis_control_id int(11) NOT NULL DEFAULT '0',
  participant_id int(11) NOT NULL DEFAULT '0',
  created datetime DEFAULT NULL,
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE drugs (
  id int(11) NOT NULL AUTO_INCREMENT,
  generic_name varchar(50) NOT NULL DEFAULT '',
  trade_name varchar(50) NOT NULL DEFAULT '',
  `type` varchar(50) DEFAULT NULL,
  description text,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  modified_by int(10) unsigned NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE drugs_revs (
  id int(11) NOT NULL,
  generic_name varchar(50) NOT NULL DEFAULT '',
  trade_name varchar(50) NOT NULL DEFAULT '',
  `type` varchar(50) DEFAULT NULL,
  description text,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  modified_by int(10) unsigned NOT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE dxd_bloods (
  id int(11) NOT NULL AUTO_INCREMENT,
  diagnosis_master_id int(11) NOT NULL DEFAULT '0',
  text_field varchar(10) NOT NULL DEFAULT '',
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  modified_by int(10) unsigned NOT NULL,
  deleted int(11) NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (id),
  KEY diagnosis_master_id (diagnosis_master_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE dxd_bloods_revs (
  id int(11) NOT NULL,
  diagnosis_master_id int(11) NOT NULL DEFAULT '0',
  text_field varchar(10) NOT NULL DEFAULT '',
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  modified_by int(10) unsigned NOT NULL,
  deleted int(11) NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE dxd_cap_report_ampullas (
  id int(11) NOT NULL AUTO_INCREMENT,
  diagnosis_master_id int(11) DEFAULT '0',
  ampulla_of_vater tinyint(1) DEFAULT '0',
  stomach tinyint(1) DEFAULT '0',
  head_of_pancreas tinyint(1) DEFAULT '0',
  duodenum tinyint(1) DEFAULT '0',
  common_bile_duct tinyint(1) DEFAULT '0',
  gallbladder tinyint(1) DEFAULT '0',
  other_specimen tinyint(1) DEFAULT '0',
  other_specimen_specify varchar(250) DEFAULT NULL,
  specimen_not_specified tinyint(1) DEFAULT '0',
  `procedure` varchar(50) DEFAULT NULL,
  procedure_specify varchar(250) DEFAULT NULL,
  tumor_site varchar(50) DEFAULT NULL,
  tumor_site_other_specify varchar(250) DEFAULT NULL,
  histologic_type varchar(100) DEFAULT NULL,
  histologic_type_specify varchar(250) DEFAULT NULL,
  tumor_extension_cannot_be_assessed tinyint(1) DEFAULT '0',
  no_evidence_of_primary_tumor tinyint(1) DEFAULT '0',
  carcinoma_in_situ tinyint(1) DEFAULT '0',
  tumor_limited_to_ampulla_of_vater_or_sphincter_of_oddi tinyint(1) DEFAULT '0',
  tumor_invades_duodenal_wall tinyint(1) DEFAULT '0',
  tumor_invades_pancreas tinyint(1) DEFAULT '0',
  tumor_invades_peripancreatic_soft_tissues tinyint(1) DEFAULT '0',
  tumor_invades_extrapancreatic_common_bile_duct tinyint(1) DEFAULT '0',
  tumor_invades_other_adjacent_organ_or_structures tinyint(1) DEFAULT '0',
  tumor_invades_specify varchar(250) DEFAULT NULL,
  ampull_spec_margin_cannot_be_assessed tinyint(1) DEFAULT '0',
  ampull_spec_margins_uninvolved_by_invasive_carcinoma tinyint(1) DEFAULT '0',
  ampull_spec_distance_of_invasive_carcinoma_from_closest_margin decimal(3,1) DEFAULT NULL,
  ampull_spec_specify_margins_uninvolved varchar(250) DEFAULT NULL,
  ampull_spec_margins_involved_by_invasive_carcinoma tinyint(1) DEFAULT '0',
  ampull_spec_specify_margins_involved varchar(250) DEFAULT NULL,
  ampull_spec_margins_not_applicable tinyint(1) DEFAULT '0',
  proximal_mucosal_margin varchar(150) DEFAULT NULL,
  distal_margin varchar(150) DEFAULT NULL,
  pancreatic_retroperitoneal_margin varchar(150) DEFAULT NULL,
  bile_duct_margin varchar(50) DEFAULT NULL,
  distal_pancreatic_resection_margin varchar(50) DEFAULT NULL,
  pr_spec_distance_of_invasive_carcinoma_from_closest_margin decimal(3,1) DEFAULT NULL,
  pr_spec_distance_unit_of_inv_carc_from_clos_marg char(2) DEFAULT NULL,
  pr_spec_specify_inv_carc_from_clos_marg varchar(250) DEFAULT NULL,
  lymph_vascular_invasion varchar(50) DEFAULT NULL,
  perineural_invasion varchar(50) DEFAULT NULL,
  additional_path_none_identified tinyint(1) DEFAULT '0',
  dysplasia_adenoma tinyint(1) DEFAULT '0',
  additional_path_other tinyint(1) DEFAULT '0',
  additional_path_other_specify varchar(250) DEFAULT NULL,
  ancillary_studies_specify varchar(250) DEFAULT NULL,
  ancillary_studies_not_performed tinyint(1) DEFAULT '0',
  familial_adenomatous_polyposis_coli tinyint(1) DEFAULT '0',
  other_clinical_history tinyint(1) DEFAULT '0',
  other_clinical_history_specify varchar(250) DEFAULT NULL,
  clinical_history_not_known tinyint(1) DEFAULT '0',
  comments varchar(250) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  modified_by int(10) unsigned NOT NULL,
  deleted int(11) DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (id),
  KEY diagnosis_master_id (diagnosis_master_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE dxd_cap_report_ampullas_revs (
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  id int(11) NOT NULL,
  diagnosis_master_id int(11) DEFAULT '0',
  ampulla_of_vater tinyint(1) DEFAULT '0',
  stomach tinyint(1) DEFAULT '0',
  head_of_pancreas tinyint(1) DEFAULT '0',
  duodenum tinyint(1) DEFAULT '0',
  common_bile_duct tinyint(1) DEFAULT '0',
  gallbladder tinyint(1) DEFAULT '0',
  other_specimen tinyint(1) DEFAULT '0',
  other_specimen_specify varchar(250) DEFAULT NULL,
  specimen_not_specified tinyint(1) DEFAULT '0',
  `procedure` varchar(50) DEFAULT NULL,
  procedure_specify varchar(250) DEFAULT NULL,
  tumor_site varchar(50) DEFAULT NULL,
  tumor_site_other_specify varchar(250) DEFAULT NULL,
  histologic_type varchar(100) DEFAULT NULL,
  histologic_type_specify varchar(250) DEFAULT NULL,
  tumor_extension_cannot_be_assessed tinyint(1) DEFAULT '0',
  no_evidence_of_primary_tumor tinyint(1) DEFAULT '0',
  carcinoma_in_situ tinyint(1) DEFAULT '0',
  tumor_limited_to_ampulla_of_vater_or_sphincter_of_oddi tinyint(1) DEFAULT '0',
  tumor_invades_duodenal_wall tinyint(1) DEFAULT '0',
  tumor_invades_pancreas tinyint(1) DEFAULT '0',
  tumor_invades_peripancreatic_soft_tissues tinyint(1) DEFAULT '0',
  tumor_invades_extrapancreatic_common_bile_duct tinyint(1) DEFAULT '0',
  tumor_invades_other_adjacent_organ_or_structures tinyint(1) DEFAULT '0',
  tumor_invades_specify varchar(250) DEFAULT NULL,
  ampull_spec_margin_cannot_be_assessed tinyint(1) DEFAULT '0',
  ampull_spec_margins_uninvolved_by_invasive_carcinoma tinyint(1) DEFAULT '0',
  ampull_spec_distance_of_invasive_carcinoma_from_closest_margin decimal(3,1) DEFAULT NULL,
  ampull_spec_specify_margins_uninvolved varchar(250) DEFAULT NULL,
  ampull_spec_margins_involved_by_invasive_carcinoma tinyint(1) DEFAULT '0',
  ampull_spec_specify_margins_involved varchar(250) DEFAULT NULL,
  ampull_spec_margins_not_applicable tinyint(1) DEFAULT '0',
  proximal_mucosal_margin varchar(150) DEFAULT NULL,
  distal_margin varchar(150) DEFAULT NULL,
  pancreatic_retroperitoneal_margin varchar(150) DEFAULT NULL,
  bile_duct_margin varchar(50) DEFAULT NULL,
  distal_pancreatic_resection_margin varchar(50) DEFAULT NULL,
  pr_spec_distance_of_invasive_carcinoma_from_closest_margin decimal(3,1) DEFAULT NULL,
  pr_spec_distance_unit_of_inv_carc_from_clos_marg char(2) DEFAULT NULL,
  pr_spec_specify_inv_carc_from_clos_marg varchar(250) DEFAULT NULL,
  lymph_vascular_invasion varchar(50) DEFAULT NULL,
  perineural_invasion varchar(50) DEFAULT NULL,
  additional_path_none_identified tinyint(1) DEFAULT '0',
  dysplasia_adenoma tinyint(1) DEFAULT '0',
  additional_path_other tinyint(1) DEFAULT '0',
  additional_path_other_specify varchar(250) DEFAULT NULL,
  ancillary_studies_specify varchar(250) DEFAULT NULL,
  ancillary_studies_not_performed tinyint(1) DEFAULT '0',
  familial_adenomatous_polyposis_coli tinyint(1) DEFAULT '0',
  other_clinical_history tinyint(1) DEFAULT '0',
  other_clinical_history_specify varchar(250) DEFAULT NULL,
  clinical_history_not_known tinyint(1) DEFAULT '0',
  comments varchar(250) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  modified_by int(10) unsigned NOT NULL,
  deleted int(11) DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (version_id),
  KEY diagnosis_master_id (diagnosis_master_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE dxd_cap_report_colon_biopsies (
  id int(11) NOT NULL AUTO_INCREMENT,
  diagnosis_master_id int(11) DEFAULT '0',
  tumor_site varchar(50) DEFAULT NULL,
  tumor_site_specify varchar(250) DEFAULT NULL,
  intact tinyint(1) DEFAULT '0',
  fragmental tinyint(1) DEFAULT '0',
  polyp_size_greatest_dimension decimal(3,1) DEFAULT NULL,
  polyp_size_additional_dimension_a decimal(3,1) DEFAULT NULL,
  polyp_size_additional_dimension_b decimal(3,1) DEFAULT NULL,
  polyp_size_cannot_be_determined tinyint(1) DEFAULT '0',
  pedunculated_with_stalk tinyint(1) DEFAULT '0',
  stalk_length_cm decimal(3,1) DEFAULT NULL,
  sessile tinyint(1) DEFAULT '0',
  histologic_type varchar(100) DEFAULT NULL,
  histologic_type_specify varchar(250) DEFAULT NULL,
  microscopic_tumor_extension varchar(50) DEFAULT NULL,
  deep_margin varchar(50) DEFAULT NULL,
  distance_of_invasive_carcinoma_from_closest_margin_mm decimal(3,1) DEFAULT NULL,
  mucosal_lateral_margin varchar(50) DEFAULT NULL,
  lymph_vascular_invasion varchar(50) DEFAULT NULL,
  type_of_polyp_in_which_invasive_carcinoma_arose varchar(50) DEFAULT NULL,
  additional_path_none_identified tinyint(1) DEFAULT '0',
  inflammatory_bowel_disease tinyint(1) DEFAULT '0',
  active tinyint(1) DEFAULT '0',
  quiescent tinyint(1) DEFAULT '0',
  additional_path_other tinyint(1) DEFAULT '0',
  additional_path_other_specify varchar(250) DEFAULT NULL,
  ancillary_studies_specify varchar(250) DEFAULT NULL,
  ancillary_studies_not_performed tinyint(1) DEFAULT '0',
  comments varchar(250) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  modified_by int(10) unsigned NOT NULL,
  deleted int(11) DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (id),
  KEY diagnosis_master_id (diagnosis_master_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE dxd_cap_report_colon_biopsies_revs (
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  id int(11) NOT NULL,
  diagnosis_master_id int(11) DEFAULT '0',
  tumor_site varchar(50) DEFAULT NULL,
  tumor_site_specify varchar(250) DEFAULT NULL,
  intact tinyint(1) DEFAULT '0',
  fragmental tinyint(1) DEFAULT '0',
  polyp_size_greatest_dimension decimal(3,1) DEFAULT NULL,
  polyp_size_additional_dimension_a decimal(3,1) DEFAULT NULL,
  polyp_size_additional_dimension_b decimal(3,1) DEFAULT NULL,
  polyp_size_cannot_be_determined tinyint(1) DEFAULT '0',
  pedunculated_with_stalk tinyint(1) DEFAULT '0',
  stalk_length_cm decimal(3,1) DEFAULT NULL,
  sessile tinyint(1) DEFAULT '0',
  histologic_type varchar(100) DEFAULT NULL,
  histologic_type_specify varchar(250) DEFAULT NULL,
  microscopic_tumor_extension varchar(50) DEFAULT NULL,
  deep_margin varchar(50) DEFAULT NULL,
  distance_of_invasive_carcinoma_from_closest_margin_mm decimal(3,1) DEFAULT NULL,
  mucosal_lateral_margin varchar(50) DEFAULT NULL,
  lymph_vascular_invasion varchar(50) DEFAULT NULL,
  type_of_polyp_in_which_invasive_carcinoma_arose varchar(50) DEFAULT NULL,
  additional_path_none_identified tinyint(1) DEFAULT '0',
  inflammatory_bowel_disease tinyint(1) DEFAULT '0',
  active tinyint(1) DEFAULT '0',
  quiescent tinyint(1) DEFAULT '0',
  additional_path_other tinyint(1) DEFAULT '0',
  additional_path_other_specify varchar(250) DEFAULT NULL,
  ancillary_studies_specify varchar(250) DEFAULT NULL,
  ancillary_studies_not_performed tinyint(1) DEFAULT '0',
  comments varchar(250) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  modified_by int(10) unsigned NOT NULL,
  deleted int(11) DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (version_id),
  KEY diagnosis_master_id (diagnosis_master_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE dxd_cap_report_colon_rectum_resections (
  id int(11) NOT NULL AUTO_INCREMENT,
  diagnosis_master_id int(11) NOT NULL DEFAULT '0',
  terminal_ileum tinyint(1) DEFAULT '0',
  cecum tinyint(1) DEFAULT '0',
  appendix tinyint(1) DEFAULT '0',
  ascending_colon tinyint(1) DEFAULT '0',
  transverse_colon tinyint(1) DEFAULT '0',
  descending_colon tinyint(1) DEFAULT '0',
  sigmoid_colon tinyint(1) DEFAULT '0',
  rectum tinyint(1) DEFAULT '0',
  anus varchar(50) DEFAULT NULL,
  specimen_other tinyint(1) DEFAULT '0',
  specimen_other_specify varchar(250) DEFAULT NULL,
  specimen_not_specified tinyint(1) DEFAULT '0',
  `procedure` varchar(100) DEFAULT NULL,
  procedure_specify varchar(250) DEFAULT NULL,
  specimen_length_specify smallint(1) DEFAULT NULL,
  tumor_site_cecum tinyint(1) DEFAULT '0',
  tumor_site_ascending_colon tinyint(1) DEFAULT '0',
  tumor_site_hepatic_flexure tinyint(1) DEFAULT '0',
  tumor_site_transverse_colon tinyint(1) DEFAULT '0',
  tumor_site_splenic_flexure tinyint(1) DEFAULT '0',
  tumor_site_descending_colon varchar(250) DEFAULT NULL,
  tumor_site_sigmoid_colon varchar(250) DEFAULT NULL,
  tumor_site_rectosigmoid varchar(250) DEFAULT NULL,
  tumor_site_rectum varchar(250) DEFAULT NULL,
  tumor_site_colon_not_otherwise_specified tinyint(1) DEFAULT '0',
  tumor_site_cannot_be_determined tinyint(1) DEFAULT '0',
  macroscopic_tumor_perforation varchar(100) DEFAULT NULL,
  macroscopic_intactness_of_mesorectum varchar(100) DEFAULT NULL,
  histologic_type varchar(100) DEFAULT NULL,
  histologic_type_specify varchar(250) DEFAULT NULL,
  intratumoral_lymphocytic_response varchar(100) DEFAULT NULL,
  peritumor_lymphocytic_response varchar(100) DEFAULT NULL,
  mucinous_tumor_component tinyint(1) DEFAULT '0',
  specify_percentage smallint(1) DEFAULT '0',
  medullary_tumor_component tinyint(1) DEFAULT '0',
  high_histologic_grade tinyint(1) DEFAULT '0',
  microscopic_tumor_extension varchar(250) DEFAULT NULL,
  microscopic_tumor_extension_specify varchar(250) DEFAULT NULL,
  proximal_margin varchar(250) DEFAULT NULL,
  distal_margin varchar(250) DEFAULT NULL,
  circumferential_margin varchar(250) DEFAULT NULL,
  distance_of_invasive_carcinoma_from_closest_margin smallint(1) DEFAULT NULL,
  distance_unit char(2) DEFAULT NULL,
  specify_margin varchar(250) DEFAULT NULL,
  lateral_margin varchar(250) DEFAULT NULL,
  distance_of_invasive_carcinoma_from_closest_lateral_margin decimal(3,1) DEFAULT NULL,
  specify_location varchar(250) DEFAULT NULL,
  treatment_effect varchar(250) DEFAULT NULL,
  treatment_effect_precision varchar(250) DEFAULT NULL,
  lymph_vascular_invasion varchar(50) DEFAULT NULL,
  perineural_invasion varchar(50) DEFAULT NULL,
  tumor_deposits varchar(50) DEFAULT NULL,
  type_of_polyp_in_which_invasive_carcinoma_arose varchar(100) DEFAULT NULL,
  additional_path_none_identified tinyint(1) DEFAULT '0',
  adenoma tinyint(1) DEFAULT '0',
  chronic_ulcerative_proctocolitis tinyint(1) DEFAULT '0',
  crohn_disease tinyint(1) DEFAULT '0',
  dysplasia_arising_in_inflammatory_bowel_disease tinyint(1) DEFAULT '0',
  other_polyps tinyint(1) DEFAULT '0',
  other_polyps_type varchar(250) DEFAULT NULL,
  other tinyint(1) DEFAULT '0',
  other_specify varchar(250) DEFAULT NULL,
  microsatellite_instability tinyint(1) NOT NULL DEFAULT '0',
  microsatellite_instability_testing_method varchar(250) DEFAULT NULL,
  microsatellite_instability_grade varchar(10) DEFAULT NULL,
  MLH1 tinyint(1) NOT NULL DEFAULT '0',
  MLH1_result varchar(60) DEFAULT NULL,
  MLH1_specify varchar(250) DEFAULT NULL,
  MSH2 tinyint(1) NOT NULL DEFAULT '0',
  MSH2_result varchar(60) DEFAULT NULL,
  MSH2_specify varchar(250) DEFAULT NULL,
  MSH6 tinyint(1) NOT NULL DEFAULT '0',
  MSH6_result varchar(60) DEFAULT NULL,
  MSH6_specify varchar(250) DEFAULT NULL,
  PMS2 tinyint(1) NOT NULL DEFAULT '0',
  PMS2_result varchar(60) DEFAULT NULL,
  PMS2_specify varchar(250) DEFAULT NULL,
  BRAF tinyint(1) NOT NULL DEFAULT '0',
  BRAF_result varchar(60) DEFAULT NULL,
  BRAF_specify varchar(250) DEFAULT NULL,
  KRAS tinyint(1) NOT NULL DEFAULT '0',
  KRAS_result varchar(60) DEFAULT NULL,
  KRAS_specify varchar(250) DEFAULT NULL,
  ancillary_other_specify varchar(250) DEFAULT NULL,
  ancillary_not_performed tinyint(1) NOT NULL DEFAULT '0',
  comments varchar(250) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  modified_by int(10) unsigned NOT NULL,
  deleted int(11) NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (id),
  KEY diagnosis_master_id (diagnosis_master_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE dxd_cap_report_colon_rectum_resections_revs (
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  id int(11) NOT NULL,
  diagnosis_master_id int(11) NOT NULL DEFAULT '0',
  terminal_ileum tinyint(1) DEFAULT '0',
  cecum tinyint(1) DEFAULT '0',
  appendix tinyint(1) DEFAULT '0',
  ascending_colon tinyint(1) DEFAULT '0',
  transverse_colon tinyint(1) DEFAULT '0',
  descending_colon tinyint(1) DEFAULT '0',
  sigmoid_colon tinyint(1) DEFAULT '0',
  rectum tinyint(1) DEFAULT '0',
  anus varchar(50) DEFAULT NULL,
  specimen_other tinyint(1) DEFAULT '0',
  specimen_other_specify varchar(250) DEFAULT NULL,
  specimen_not_specified tinyint(1) DEFAULT '0',
  `procedure` varchar(100) DEFAULT NULL,
  procedure_specify varchar(250) DEFAULT NULL,
  specimen_length_specify smallint(1) DEFAULT NULL,
  tumor_site_cecum tinyint(1) DEFAULT '0',
  tumor_site_ascending_colon tinyint(1) DEFAULT '0',
  tumor_site_hepatic_flexure tinyint(1) DEFAULT '0',
  tumor_site_transverse_colon tinyint(1) DEFAULT '0',
  tumor_site_splenic_flexure tinyint(1) DEFAULT '0',
  tumor_site_descending_colon varchar(250) DEFAULT NULL,
  tumor_site_sigmoid_colon varchar(250) DEFAULT NULL,
  tumor_site_rectosigmoid varchar(250) DEFAULT NULL,
  tumor_site_rectum varchar(250) DEFAULT NULL,
  tumor_site_colon_not_otherwise_specified tinyint(1) DEFAULT '0',
  tumor_site_cannot_be_determined tinyint(1) DEFAULT '0',
  macroscopic_tumor_perforation varchar(100) DEFAULT NULL,
  macroscopic_intactness_of_mesorectum varchar(100) DEFAULT NULL,
  histologic_type varchar(100) DEFAULT NULL,
  histologic_type_specify varchar(250) DEFAULT NULL,
  intratumoral_lymphocytic_response varchar(100) DEFAULT NULL,
  peritumor_lymphocytic_response varchar(100) DEFAULT NULL,
  mucinous_tumor_component tinyint(1) DEFAULT '0',
  specify_percentage smallint(1) DEFAULT '0',
  medullary_tumor_component tinyint(1) DEFAULT '0',
  high_histologic_grade tinyint(1) DEFAULT '0',
  microscopic_tumor_extension varchar(250) DEFAULT NULL,
  microscopic_tumor_extension_specify varchar(250) DEFAULT NULL,
  proximal_margin varchar(250) DEFAULT NULL,
  distal_margin varchar(250) DEFAULT NULL,
  circumferential_margin varchar(250) DEFAULT NULL,
  distance_of_invasive_carcinoma_from_closest_margin smallint(1) DEFAULT NULL,
  distance_unit char(2) DEFAULT NULL,
  specify_margin varchar(250) DEFAULT NULL,
  lateral_margin varchar(250) DEFAULT NULL,
  distance_of_invasive_carcinoma_from_closest_lateral_margin decimal(3,1) DEFAULT NULL,
  specify_location varchar(250) DEFAULT NULL,
  treatment_effect varchar(250) DEFAULT NULL,
  treatment_effect_precision varchar(250) DEFAULT NULL,
  lymph_vascular_invasion varchar(50) DEFAULT NULL,
  perineural_invasion varchar(50) DEFAULT NULL,
  tumor_deposits varchar(50) DEFAULT NULL,
  type_of_polyp_in_which_invasive_carcinoma_arose varchar(100) DEFAULT NULL,
  additional_path_none_identified tinyint(1) DEFAULT '0',
  adenoma tinyint(1) DEFAULT '0',
  chronic_ulcerative_proctocolitis tinyint(1) DEFAULT '0',
  crohn_disease tinyint(1) DEFAULT '0',
  dysplasia_arising_in_inflammatory_bowel_disease tinyint(1) DEFAULT '0',
  other_polyps tinyint(1) DEFAULT '0',
  other_polyps_type varchar(250) DEFAULT NULL,
  other tinyint(1) DEFAULT '0',
  other_specify varchar(250) DEFAULT NULL,
  microsatellite_instability tinyint(1) NOT NULL DEFAULT '0',
  microsatellite_instability_testing_method varchar(250) DEFAULT NULL,
  microsatellite_instability_grade varchar(10) DEFAULT NULL,
  MLH1 tinyint(1) NOT NULL DEFAULT '0',
  MLH1_result varchar(60) DEFAULT NULL,
  MLH1_specify varchar(250) DEFAULT NULL,
  MSH2 tinyint(1) NOT NULL DEFAULT '0',
  MSH2_result varchar(60) DEFAULT NULL,
  MSH2_specify varchar(250) DEFAULT NULL,
  MSH6 tinyint(1) NOT NULL DEFAULT '0',
  MSH6_result varchar(60) DEFAULT NULL,
  MSH6_specify varchar(250) DEFAULT NULL,
  PMS2 tinyint(1) NOT NULL DEFAULT '0',
  PMS2_result varchar(60) DEFAULT NULL,
  PMS2_specify varchar(250) DEFAULT NULL,
  BRAF tinyint(1) NOT NULL DEFAULT '0',
  BRAF_result varchar(60) DEFAULT NULL,
  BRAF_specify varchar(250) DEFAULT NULL,
  KRAS tinyint(1) NOT NULL DEFAULT '0',
  KRAS_result varchar(60) DEFAULT NULL,
  KRAS_specify varchar(250) DEFAULT NULL,
  ancillary_other_specify varchar(250) DEFAULT NULL,
  ancillary_not_performed tinyint(1) NOT NULL DEFAULT '0',
  comments varchar(250) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  modified_by int(10) unsigned NOT NULL,
  deleted int(11) NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (version_id),
  KEY diagnosis_master_id (diagnosis_master_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE dxd_cap_report_distalexbileducts (
  id int(11) NOT NULL AUTO_INCREMENT,
  diagnosis_master_id int(11) DEFAULT '0',
  common_bile_duct tinyint(1) DEFAULT '0',
  right_hepatic_duct tinyint(1) DEFAULT '0',
  left_hepatic_duct tinyint(1) DEFAULT '0',
  junction_of_right_and_left_hepatic_ducts tinyint(1) DEFAULT '0',
  common_hepatic_duct tinyint(1) DEFAULT '0',
  cystic_duct tinyint(1) DEFAULT '0',
  specimen_not_specified tinyint(1) DEFAULT '0',
  stomach tinyint(1) DEFAULT '0',
  duodenum tinyint(1) DEFAULT '0',
  pancreas tinyint(1) DEFAULT '0',
  ampulla tinyint(1) DEFAULT '0',
  gallbladder tinyint(1) DEFAULT '0',
  other_organ_other tinyint(1) DEFAULT '0',
  other_organ_other_specify varchar(250) DEFAULT NULL,
  `procedure` varchar(50) DEFAULT NULL,
  procedure_specify varchar(250) DEFAULT NULL,
  tumor_site_common_bile_duct tinyint(1) DEFAULT '0',
  extrapancreatic tinyint(1) DEFAULT '0',
  intrapancreatic tinyint(1) DEFAULT '0',
  tumor_site_other tinyint(1) DEFAULT '0',
  tumor_site_other_specify varchar(250) DEFAULT NULL,
  tumor_site_not_specified tinyint(1) DEFAULT '0',
  histologic_type varchar(100) DEFAULT NULL,
  histologic_type_specify varchar(250) DEFAULT NULL,
  carcinoma_in_situ tinyint(1) DEFAULT '0',
  tumor_confined_to_the_bile_duct_histologically tinyint(1) DEFAULT '0',
  tumor_invades_beyond_the_wall_of_the_bile_duct tinyint(1) DEFAULT '0',
  tumor_invades_the_duodenum tinyint(1) DEFAULT '0',
  tumor_invades_the_pancreas tinyint(1) DEFAULT '0',
  tumor_invades_the_gallbladder tinyint(1) DEFAULT '0',
  tumor_invades_other_adjacent_structures tinyint(1) DEFAULT '0',
  tumor_invades_specify varchar(250) DEFAULT NULL,
  seg_res_margins_cannot_be_assessed tinyint(1) DEFAULT '0',
  seg_res_margins_uninvolved_by_invasive_carcinoma tinyint(1) DEFAULT '0',
  seg_res_distance_of_invasive_carcinoma_from_closest_margin_mm decimal(3,1) DEFAULT NULL,
  seg_res_specify_uninvolved_margin varchar(250) DEFAULT NULL,
  seg_res_margins_involved_by_invasive_carcinoma tinyint(1) DEFAULT '0',
  seg_res_proximal_bile_duct_margin tinyint(1) DEFAULT '0',
  seg_res_distal_bile_duct_margin tinyint(1) DEFAULT '0',
  seg_res_involved_margin_other tinyint(1) DEFAULT '0',
  seg_res_involved_margin_other_specify varchar(250) DEFAULT NULL,
  dysplasia_carcinoma_in_situ_not_identified_at_bile_duct_margin tinyint(1) DEFAULT '0',
  dysplasia_carcinoma_in_situ_present_at_bile_duct_margin tinyint(1) DEFAULT '0',
  proximal_margin varchar(50) DEFAULT NULL,
  distal_margin varchar(50) DEFAULT NULL,
  pancreatic_retroperitoneal_margin varchar(150) DEFAULT NULL,
  bile_duct_margin varchar(50) DEFAULT NULL,
  distal_pancreatic_margin varchar(50) DEFAULT NULL,
  other_margins_distance_of_invasive_carcinoma_from_closest_margin decimal(3,1) DEFAULT NULL,
  other_margins_distance_unit char(2) DEFAULT NULL,
  other_margins_specify varchar(250) DEFAULT NULL,
  lymph_vascular_invasion varchar(50) DEFAULT NULL,
  perineural_invasion varchar(50) DEFAULT NULL,
  additional_path_none_identified tinyint(1) DEFAULT '0',
  choledochal_cyst tinyint(1) DEFAULT '0',
  dysplasia tinyint(1) DEFAULT '0',
  primary_sclerosing_cholangitis tinyint(1) DEFAULT '0',
  stones tinyint(1) DEFAULT '0',
  additional_path_other tinyint(1) DEFAULT '0',
  additional_path_other_specify varchar(250) DEFAULT NULL,
  ancillary_studies_specify varchar(250) DEFAULT NULL,
  primary_sclerosing_cholangitis_PSC tinyint(1) DEFAULT '0',
  inflammatory_bowel_disease tinyint(1) DEFAULT '0',
  biliary_stones tinyint(1) DEFAULT '0',
  other_clinical_history tinyint(1) DEFAULT '0',
  other_clinical_history_specify varchar(250) DEFAULT NULL,
  comments varchar(250) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  modified_by int(10) unsigned NOT NULL,
  deleted int(11) DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (id),
  KEY diagnosis_master_id (diagnosis_master_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE dxd_cap_report_distalexbileducts_revs (
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  id int(11) NOT NULL,
  diagnosis_master_id int(11) DEFAULT '0',
  common_bile_duct tinyint(1) DEFAULT '0',
  right_hepatic_duct tinyint(1) DEFAULT '0',
  left_hepatic_duct tinyint(1) DEFAULT '0',
  junction_of_right_and_left_hepatic_ducts tinyint(1) DEFAULT '0',
  common_hepatic_duct tinyint(1) DEFAULT '0',
  cystic_duct tinyint(1) DEFAULT '0',
  specimen_not_specified tinyint(1) DEFAULT '0',
  stomach tinyint(1) DEFAULT '0',
  duodenum tinyint(1) DEFAULT '0',
  pancreas tinyint(1) DEFAULT '0',
  ampulla tinyint(1) DEFAULT '0',
  gallbladder tinyint(1) DEFAULT '0',
  other_organ_other tinyint(1) DEFAULT '0',
  other_organ_other_specify varchar(250) DEFAULT NULL,
  `procedure` varchar(50) DEFAULT NULL,
  procedure_specify varchar(250) DEFAULT NULL,
  tumor_site_common_bile_duct tinyint(1) DEFAULT '0',
  extrapancreatic tinyint(1) DEFAULT '0',
  intrapancreatic tinyint(1) DEFAULT '0',
  tumor_site_other tinyint(1) DEFAULT '0',
  tumor_site_other_specify varchar(250) DEFAULT NULL,
  tumor_site_not_specified tinyint(1) DEFAULT '0',
  histologic_type varchar(100) DEFAULT NULL,
  histologic_type_specify varchar(250) DEFAULT NULL,
  carcinoma_in_situ tinyint(1) DEFAULT '0',
  tumor_confined_to_the_bile_duct_histologically tinyint(1) DEFAULT '0',
  tumor_invades_beyond_the_wall_of_the_bile_duct tinyint(1) DEFAULT '0',
  tumor_invades_the_duodenum tinyint(1) DEFAULT '0',
  tumor_invades_the_pancreas tinyint(1) DEFAULT '0',
  tumor_invades_the_gallbladder tinyint(1) DEFAULT '0',
  tumor_invades_other_adjacent_structures tinyint(1) DEFAULT '0',
  tumor_invades_specify varchar(250) DEFAULT NULL,
  seg_res_margins_cannot_be_assessed tinyint(1) DEFAULT '0',
  seg_res_margins_uninvolved_by_invasive_carcinoma tinyint(1) DEFAULT '0',
  seg_res_distance_of_invasive_carcinoma_from_closest_margin_mm decimal(3,1) DEFAULT NULL,
  seg_res_specify_uninvolved_margin varchar(250) DEFAULT NULL,
  seg_res_margins_involved_by_invasive_carcinoma tinyint(1) DEFAULT '0',
  seg_res_proximal_bile_duct_margin tinyint(1) DEFAULT '0',
  seg_res_distal_bile_duct_margin tinyint(1) DEFAULT '0',
  seg_res_involved_margin_other tinyint(1) DEFAULT '0',
  seg_res_involved_margin_other_specify varchar(250) DEFAULT NULL,
  dysplasia_carcinoma_in_situ_not_identified_at_bile_duct_margin tinyint(1) DEFAULT '0',
  dysplasia_carcinoma_in_situ_present_at_bile_duct_margin tinyint(1) DEFAULT '0',
  proximal_margin varchar(50) DEFAULT NULL,
  distal_margin varchar(50) DEFAULT NULL,
  pancreatic_retroperitoneal_margin varchar(150) DEFAULT NULL,
  bile_duct_margin varchar(50) DEFAULT NULL,
  distal_pancreatic_margin varchar(50) DEFAULT NULL,
  other_margins_distance_of_invasive_carcinoma_from_closest_margin decimal(3,1) DEFAULT NULL,
  other_margins_distance_unit char(2) DEFAULT NULL,
  other_margins_specify varchar(250) DEFAULT NULL,
  lymph_vascular_invasion varchar(50) DEFAULT NULL,
  perineural_invasion varchar(50) DEFAULT NULL,
  additional_path_none_identified tinyint(1) DEFAULT '0',
  choledochal_cyst tinyint(1) DEFAULT '0',
  dysplasia tinyint(1) DEFAULT '0',
  primary_sclerosing_cholangitis tinyint(1) DEFAULT '0',
  stones tinyint(1) DEFAULT '0',
  additional_path_other tinyint(1) DEFAULT '0',
  additional_path_other_specify varchar(250) DEFAULT NULL,
  ancillary_studies_specify varchar(250) DEFAULT NULL,
  primary_sclerosing_cholangitis_PSC tinyint(1) DEFAULT '0',
  inflammatory_bowel_disease tinyint(1) DEFAULT '0',
  biliary_stones tinyint(1) DEFAULT '0',
  other_clinical_history tinyint(1) DEFAULT '0',
  other_clinical_history_specify varchar(250) DEFAULT NULL,
  comments varchar(250) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  modified_by int(10) unsigned NOT NULL,
  deleted int(11) DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (version_id),
  KEY diagnosis_master_id (diagnosis_master_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE dxd_cap_report_gallbladders (
  id int(11) NOT NULL AUTO_INCREMENT,
  diagnosis_master_id int(11) DEFAULT '0',
  gallbladder tinyint(1) DEFAULT '0',
  liver tinyint(1) DEFAULT '0',
  extrahepatic_bile_duct tinyint(1) DEFAULT '0',
  other_specimen tinyint(1) DEFAULT '0',
  other_specimen_specify varchar(250) DEFAULT NULL,
  specimen_not_specified tinyint(1) DEFAULT '0',
  `procedure` varchar(100) DEFAULT NULL,
  procedure_specify varchar(250) DEFAULT NULL,
  fundus tinyint(1) DEFAULT '0',
  body tinyint(1) DEFAULT '0',
  neck tinyint(1) DEFAULT '0',
  cystic_duct tinyint(1) DEFAULT '0',
  free_peritoneal_side_of_gallbladder tinyint(1) DEFAULT '0',
  hepatic_side_of_gallbladder tinyint(1) DEFAULT '0',
  tumor_site_cannot_be_determined tinyint(1) DEFAULT '0',
  tumor_site_other tinyint(1) DEFAULT '0',
  tumor_site_other_specify varchar(250) DEFAULT NULL,
  tumor_site_not_specified tinyint(1) DEFAULT '0',
  histologic_type varchar(100) DEFAULT NULL,
  histologic_type_specify varchar(250) DEFAULT NULL,
  microscopic_tumor_extension varchar(150) DEFAULT NULL,
  microscopic_tumor_extension_specify varchar(250) DEFAULT NULL,
  margin_cannot_be_assessed tinyint(1) DEFAULT '0',
  margin_uninvolved_by_invasive_carcinoma tinyint(1) DEFAULT '0',
  distance_of_invasive_carcinoma_from_closest_margin_mm decimal(3,1) DEFAULT NULL,
  specify_uninvolved_margin varchar(250) DEFAULT NULL,
  margin_involved_by_invasive_carcinoma tinyint(1) DEFAULT '0',
  specify_involved_margin varchar(250) DEFAULT NULL,
  cystic_duct_margin_uninvolved_by_intramucosal_carcinoma tinyint(1) DEFAULT '0',
  cystic_duct_margin_involved_by_intramucosal_carcinoma tinyint(1) DEFAULT '0',
  lymph_vascular_invasion varchar(50) DEFAULT NULL,
  perineural_invasion varchar(50) DEFAULT NULL,
  additional_path_none_identified tinyint(1) DEFAULT '0',
  dysplasia_adenoma tinyint(1) DEFAULT '0',
  cholelithiasis tinyint(1) DEFAULT '0',
  chronic_cholecystitis tinyint(1) DEFAULT '0',
  acute_cholecystitis tinyint(1) DEFAULT '0',
  intestinal_metaplasia tinyint(1) DEFAULT '0',
  diffuse_calcification_porcelain_gallbladder tinyint(1) DEFAULT '0',
  additional_path_other tinyint(1) DEFAULT '0',
  additional_path_other_specify varchar(250) DEFAULT NULL,
  ancillary_studies_specify varchar(250) DEFAULT NULL,
  ancillary_studies_not_performed tinyint(1) DEFAULT '0',
  clin_cholelithiasis tinyint(1) DEFAULT '0',
  primary_sclerosing_cholangitis tinyint(1) DEFAULT '0',
  other_clinical_history tinyint(1) DEFAULT '0',
  other_clinical_history_specify varchar(250) DEFAULT NULL,
  comments varchar(250) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  modified_by int(10) unsigned NOT NULL,
  deleted int(11) DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (id),
  KEY diagnosis_master_id (diagnosis_master_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE dxd_cap_report_gallbladders_revs (
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  id int(11) NOT NULL,
  diagnosis_master_id int(11) DEFAULT '0',
  gallbladder tinyint(1) DEFAULT '0',
  liver tinyint(1) DEFAULT '0',
  extrahepatic_bile_duct tinyint(1) DEFAULT '0',
  other_specimen tinyint(1) DEFAULT '0',
  other_specimen_specify varchar(250) DEFAULT NULL,
  specimen_not_specified tinyint(1) DEFAULT '0',
  `procedure` varchar(100) DEFAULT NULL,
  procedure_specify varchar(250) DEFAULT NULL,
  fundus tinyint(1) DEFAULT '0',
  body tinyint(1) DEFAULT '0',
  neck tinyint(1) DEFAULT '0',
  cystic_duct tinyint(1) DEFAULT '0',
  free_peritoneal_side_of_gallbladder tinyint(1) DEFAULT '0',
  hepatic_side_of_gallbladder tinyint(1) DEFAULT '0',
  tumor_site_cannot_be_determined tinyint(1) DEFAULT '0',
  tumor_site_other tinyint(1) DEFAULT '0',
  tumor_site_other_specify varchar(250) DEFAULT NULL,
  tumor_site_not_specified tinyint(1) DEFAULT '0',
  histologic_type varchar(100) DEFAULT NULL,
  histologic_type_specify varchar(250) DEFAULT NULL,
  microscopic_tumor_extension varchar(150) DEFAULT NULL,
  microscopic_tumor_extension_specify varchar(250) DEFAULT NULL,
  margin_cannot_be_assessed tinyint(1) DEFAULT '0',
  margin_uninvolved_by_invasive_carcinoma tinyint(1) DEFAULT '0',
  distance_of_invasive_carcinoma_from_closest_margin_mm decimal(3,1) DEFAULT NULL,
  specify_uninvolved_margin varchar(250) DEFAULT NULL,
  margin_involved_by_invasive_carcinoma tinyint(1) DEFAULT '0',
  specify_involved_margin varchar(250) DEFAULT NULL,
  cystic_duct_margin_uninvolved_by_intramucosal_carcinoma tinyint(1) DEFAULT '0',
  cystic_duct_margin_involved_by_intramucosal_carcinoma tinyint(1) DEFAULT '0',
  lymph_vascular_invasion varchar(50) DEFAULT NULL,
  perineural_invasion varchar(50) DEFAULT NULL,
  additional_path_none_identified tinyint(1) DEFAULT '0',
  dysplasia_adenoma tinyint(1) DEFAULT '0',
  cholelithiasis tinyint(1) DEFAULT '0',
  chronic_cholecystitis tinyint(1) DEFAULT '0',
  acute_cholecystitis tinyint(1) DEFAULT '0',
  intestinal_metaplasia tinyint(1) DEFAULT '0',
  diffuse_calcification_porcelain_gallbladder tinyint(1) DEFAULT '0',
  additional_path_other tinyint(1) DEFAULT '0',
  additional_path_other_specify varchar(250) DEFAULT NULL,
  ancillary_studies_specify varchar(250) DEFAULT NULL,
  ancillary_studies_not_performed tinyint(1) DEFAULT '0',
  clin_cholelithiasis tinyint(1) DEFAULT '0',
  primary_sclerosing_cholangitis tinyint(1) DEFAULT '0',
  other_clinical_history tinyint(1) DEFAULT '0',
  other_clinical_history_specify varchar(250) DEFAULT NULL,
  comments varchar(250) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  modified_by int(10) unsigned NOT NULL,
  deleted int(11) DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (version_id),
  KEY diagnosis_master_id (diagnosis_master_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE dxd_cap_report_hepatocellular_carcinomas (
  id int(11) NOT NULL AUTO_INCREMENT,
  diagnosis_master_id int(11) NOT NULL DEFAULT '0',
  liver tinyint(1) DEFAULT '0',
  gallbladder tinyint(1) DEFAULT '0',
  other_specimen tinyint(1) DEFAULT '0',
  other_specimen_specify varchar(250) DEFAULT NULL,
  specimen_not_specified tinyint(1) DEFAULT '0',
  wedge_resection tinyint(1) DEFAULT '0',
  partial_hepatectomy tinyint(1) DEFAULT '0',
  major_hepatectomy_3_segments_or_more tinyint(1) DEFAULT '0',
  minor_hepatectomy_less_than_3_segments tinyint(1) DEFAULT '0',
  total_hepatectomy tinyint(1) DEFAULT '0',
  procedure_other tinyint(1) DEFAULT '0',
  procedure_other_specify varchar(250) DEFAULT NULL,
  procedure_not_specified tinyint(1) DEFAULT '0',
  solitary_focality tinyint(1) DEFAULT '0',
  specify_solitary_focality_location varchar(250) DEFAULT NULL,
  multiple_focality tinyint(1) DEFAULT '0',
  specify_multiple_focality_location varchar(250) DEFAULT NULL,
  histologic_type varchar(100) DEFAULT NULL,
  histologic_type_specify varchar(250) DEFAULT NULL,
  tumor_confined_to_liver tinyint(1) DEFAULT '0',
  tumor_involves_a_major_branch_of_the_portal_vein tinyint(1) DEFAULT '0',
  tumor_involves_1_or_more_hepatic_veins tinyint(1) DEFAULT '0',
  tumor_involves_visceral_peritoneum tinyint(1) DEFAULT '0',
  tumor_directly_invades_gallbladder tinyint(1) DEFAULT '0',
  tumor_directly_invades_other_adjacent_organs tinyint(1) DEFAULT '0',
  other_adjacent_organs_specify varchar(250) DEFAULT NULL,
  parenchymal_margin varchar(50) DEFAULT NULL,
  distance_of_invasive_carcinoma_from_closest_margin_mm decimal(3,1) DEFAULT NULL,
  parenchymal_margin_specify varchar(250) DEFAULT NULL,
  other_margin_specify varchar(250) DEFAULT NULL,
  other_margin varchar(50) DEFAULT NULL,
  lymph_vascular_large_vessel_invasion varchar(50) DEFAULT NULL,
  lymph_vascular_small_vessel_invasion varchar(50) DEFAULT NULL,
  perineural_invasion varchar(50) DEFAULT NULL,
  cirrhosis_severe_fibrosis tinyint(1) NOT NULL DEFAULT '0',
  none_to_moderate_fibrosis tinyint(1) NOT NULL DEFAULT '0',
  hepatocellular_dysplasia tinyint(1) NOT NULL DEFAULT '0',
  low_grade_dysplastic_nodule tinyint(1) NOT NULL DEFAULT '0',
  high_grade_dysplastic_nodule tinyint(1) NOT NULL DEFAULT '0',
  steatosis tinyint(1) NOT NULL DEFAULT '0',
  iron_overload tinyint(1) NOT NULL DEFAULT '0',
  chronic_hepatitis tinyint(1) NOT NULL DEFAULT '0',
  specify_etiology varchar(250) DEFAULT NULL,
  additional_path_other tinyint(1) NOT NULL DEFAULT '0',
  additional_path_other_specify varchar(250) DEFAULT NULL,
  none_identified tinyint(1) NOT NULL DEFAULT '0',
  ancillary_studies_specify varchar(250) DEFAULT NULL,
  cirrhosis tinyint(1) NOT NULL DEFAULT '0',
  hepatitis_c_infection tinyint(1) NOT NULL DEFAULT '0',
  hepatitis_b_infection tinyint(1) NOT NULL DEFAULT '0',
  alcoholic_liver_disease tinyint(1) NOT NULL DEFAULT '0',
  obesity tinyint(1) NOT NULL DEFAULT '0',
  hereditary_hemochromatosis tinyint(1) NOT NULL DEFAULT '0',
  other_clinical_history tinyint(1) NOT NULL DEFAULT '0',
  other_clinical_history_specify varchar(250) DEFAULT NULL,
  clinical_history_not_known tinyint(1) NOT NULL DEFAULT '0',
  comments varchar(250) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  modified_by int(10) unsigned NOT NULL,
  deleted int(11) NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (id),
  KEY diagnosis_master_id (diagnosis_master_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE dxd_cap_report_hepatocellular_carcinomas_revs (
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  id int(11) NOT NULL,
  diagnosis_master_id int(11) NOT NULL DEFAULT '0',
  liver tinyint(1) DEFAULT '0',
  gallbladder tinyint(1) DEFAULT '0',
  other_specimen tinyint(1) DEFAULT '0',
  other_specimen_specify varchar(250) DEFAULT NULL,
  specimen_not_specified tinyint(1) DEFAULT '0',
  wedge_resection tinyint(1) DEFAULT '0',
  partial_hepatectomy tinyint(1) DEFAULT '0',
  major_hepatectomy_3_segments_or_more tinyint(1) DEFAULT '0',
  minor_hepatectomy_less_than_3_segments tinyint(1) DEFAULT '0',
  total_hepatectomy tinyint(1) DEFAULT '0',
  procedure_other tinyint(1) DEFAULT '0',
  procedure_other_specify varchar(250) DEFAULT NULL,
  procedure_not_specified tinyint(1) DEFAULT '0',
  solitary_focality tinyint(1) DEFAULT '0',
  specify_solitary_focality_location varchar(250) DEFAULT NULL,
  multiple_focality tinyint(1) DEFAULT '0',
  specify_multiple_focality_location varchar(250) DEFAULT NULL,
  histologic_type varchar(100) DEFAULT NULL,
  histologic_type_specify varchar(250) DEFAULT NULL,
  tumor_confined_to_liver tinyint(1) DEFAULT '0',
  tumor_involves_a_major_branch_of_the_portal_vein tinyint(1) DEFAULT '0',
  tumor_involves_1_or_more_hepatic_veins tinyint(1) DEFAULT '0',
  tumor_involves_visceral_peritoneum tinyint(1) DEFAULT '0',
  tumor_directly_invades_gallbladder tinyint(1) DEFAULT '0',
  tumor_directly_invades_other_adjacent_organs tinyint(1) DEFAULT '0',
  other_adjacent_organs_specify varchar(250) DEFAULT NULL,
  parenchymal_margin varchar(50) DEFAULT NULL,
  distance_of_invasive_carcinoma_from_closest_margin_mm decimal(3,1) DEFAULT NULL,
  parenchymal_margin_specify varchar(250) DEFAULT NULL,
  other_margin_specify varchar(250) DEFAULT NULL,
  other_margin varchar(50) DEFAULT NULL,
  lymph_vascular_large_vessel_invasion varchar(50) DEFAULT NULL,
  lymph_vascular_small_vessel_invasion varchar(50) DEFAULT NULL,
  perineural_invasion varchar(50) DEFAULT NULL,
  cirrhosis_severe_fibrosis tinyint(1) NOT NULL DEFAULT '0',
  none_to_moderate_fibrosis tinyint(1) NOT NULL DEFAULT '0',
  hepatocellular_dysplasia tinyint(1) NOT NULL DEFAULT '0',
  low_grade_dysplastic_nodule tinyint(1) NOT NULL DEFAULT '0',
  high_grade_dysplastic_nodule tinyint(1) NOT NULL DEFAULT '0',
  steatosis tinyint(1) NOT NULL DEFAULT '0',
  iron_overload tinyint(1) NOT NULL DEFAULT '0',
  chronic_hepatitis tinyint(1) NOT NULL DEFAULT '0',
  specify_etiology varchar(250) DEFAULT NULL,
  additional_path_other tinyint(1) NOT NULL DEFAULT '0',
  additional_path_other_specify varchar(250) DEFAULT NULL,
  none_identified tinyint(1) NOT NULL DEFAULT '0',
  ancillary_studies_specify varchar(250) DEFAULT NULL,
  cirrhosis tinyint(1) NOT NULL DEFAULT '0',
  hepatitis_c_infection tinyint(1) NOT NULL DEFAULT '0',
  hepatitis_b_infection tinyint(1) NOT NULL DEFAULT '0',
  alcoholic_liver_disease tinyint(1) NOT NULL DEFAULT '0',
  obesity tinyint(1) NOT NULL DEFAULT '0',
  hereditary_hemochromatosis tinyint(1) NOT NULL DEFAULT '0',
  other_clinical_history tinyint(1) NOT NULL DEFAULT '0',
  other_clinical_history_specify varchar(250) DEFAULT NULL,
  clinical_history_not_known tinyint(1) NOT NULL DEFAULT '0',
  comments varchar(250) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  modified_by int(10) unsigned NOT NULL,
  deleted int(11) NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (version_id),
  KEY diagnosis_master_id (diagnosis_master_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE dxd_cap_report_intrahepbileducts (
  id int(11) NOT NULL AUTO_INCREMENT,
  diagnosis_master_id int(11) NOT NULL DEFAULT '0',
  liver tinyint(1) DEFAULT '0',
  gallbladder tinyint(1) DEFAULT '0',
  other_specimen tinyint(1) DEFAULT '0',
  other_specimen_specify varchar(250) DEFAULT NULL,
  specimen_not_specified tinyint(1) DEFAULT '0',
  wedge_resection tinyint(1) DEFAULT '0',
  partial_hepatectomy tinyint(1) DEFAULT '0',
  major_hepatectomy_3_segments_or_more tinyint(1) DEFAULT '0',
  minor_hepatectomy_less_than_3_segments tinyint(1) DEFAULT '0',
  total_hepatectomy tinyint(1) DEFAULT '0',
  procedure_other tinyint(1) DEFAULT '0',
  procedure_other_specify varchar(250) DEFAULT NULL,
  procedure_not_specified tinyint(1) DEFAULT '0',
  tumor_focality varchar(50) DEFAULT NULL,
  specify_tumor_focality varchar(250) DEFAULT NULL,
  histologic_type varchar(100) DEFAULT NULL,
  histologic_type_specify varchar(250) DEFAULT NULL,
  tumor_growth_pattern varchar(50) DEFAULT NULL,
  tumor_extension_cannot_be_assessed tinyint(1) DEFAULT '0',
  no_evidence_of_primary_tumor tinyint(1) DEFAULT '0',
  tumor_confined_to_the_intrahepatic_bile_ducts_histologically tinyint(1) DEFAULT '0',
  tumor_confined_to_hepatic_parenchyma tinyint(1) DEFAULT '0',
  tumor_involves_visceral_peritoneal_surface tinyint(1) DEFAULT '0',
  tumor_directly_invades_gallbladder tinyint(1) DEFAULT '0',
  tumor_directly_invades_adjacent_organs_other_than_gallbladder tinyint(1) DEFAULT '0',
  tumor_extension_specify varchar(250) DEFAULT NULL,
  hepatic_parenchymal_margin varchar(50) DEFAULT NULL,
  distance_of_invasive_carcinoma_from_closest_margin_mm decimal(3,1) DEFAULT NULL,
  hp_specify_margin varchar(250) DEFAULT NULL,
  bile_duct_margin varchar(50) DEFAULT NULL,
  dysplasia_carcinoma_in_situ_data varchar(50) DEFAULT NULL,
  other_margin varchar(50) DEFAULT NULL,
  specify_other_margin varchar(250) DEFAULT NULL,
  lymph_vascular_major_vessel_invasion varchar(50) DEFAULT NULL,
  lymph_vascular_small_vessel_invasion varchar(50) DEFAULT NULL,
  perineural_invasion varchar(50) DEFAULT NULL,
  cirrhosis_severe_fibrosis tinyint(1) NOT NULL DEFAULT '0',
  primary_sclerosing_cholangitis tinyint(1) NOT NULL DEFAULT '0',
  biliary_stones tinyint(1) NOT NULL DEFAULT '0',
  chronic_hepatitis tinyint(1) NOT NULL DEFAULT '0',
  specify_type varchar(250) DEFAULT NULL,
  additional_path_other tinyint(1) NOT NULL DEFAULT '0',
  additional_path_other_specify varchar(250) DEFAULT NULL,
  none_identified tinyint(1) NOT NULL DEFAULT '0',
  ancillary_studies_specify varchar(250) DEFAULT NULL,
  cirrhosis tinyint(1) NOT NULL DEFAULT '0',
  cli_primary_sclerosing_cholangitis tinyint(1) NOT NULL DEFAULT '0',
  inflammatory_bowel_disease tinyint(1) NOT NULL DEFAULT '0',
  hepatitis_c_infection tinyint(1) NOT NULL DEFAULT '0',
  other_clinical_history tinyint(1) NOT NULL DEFAULT '0',
  other_clinical_history_specify varchar(250) DEFAULT NULL,
  not_known tinyint(1) NOT NULL DEFAULT '0',
  comments varchar(250) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  modified_by int(10) unsigned NOT NULL,
  deleted int(11) NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (id),
  KEY diagnosis_master_id (diagnosis_master_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE dxd_cap_report_intrahepbileducts_revs (
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  id int(11) NOT NULL,
  diagnosis_master_id int(11) NOT NULL DEFAULT '0',
  liver tinyint(1) DEFAULT '0',
  gallbladder tinyint(1) DEFAULT '0',
  other_specimen tinyint(1) DEFAULT '0',
  other_specimen_specify varchar(250) DEFAULT NULL,
  specimen_not_specified tinyint(1) DEFAULT '0',
  wedge_resection tinyint(1) DEFAULT '0',
  partial_hepatectomy tinyint(1) DEFAULT '0',
  major_hepatectomy_3_segments_or_more tinyint(1) DEFAULT '0',
  minor_hepatectomy_less_than_3_segments tinyint(1) DEFAULT '0',
  total_hepatectomy tinyint(1) DEFAULT '0',
  procedure_other tinyint(1) DEFAULT '0',
  procedure_other_specify varchar(250) DEFAULT NULL,
  procedure_not_specified tinyint(1) DEFAULT '0',
  tumor_focality varchar(50) DEFAULT NULL,
  specify_tumor_focality varchar(250) DEFAULT NULL,
  histologic_type varchar(100) DEFAULT NULL,
  histologic_type_specify varchar(250) DEFAULT NULL,
  tumor_growth_pattern varchar(50) DEFAULT NULL,
  tumor_extension_cannot_be_assessed tinyint(1) DEFAULT '0',
  no_evidence_of_primary_tumor tinyint(1) DEFAULT '0',
  tumor_confined_to_the_intrahepatic_bile_ducts_histologically tinyint(1) DEFAULT '0',
  tumor_confined_to_hepatic_parenchyma tinyint(1) DEFAULT '0',
  tumor_involves_visceral_peritoneal_surface tinyint(1) DEFAULT '0',
  tumor_directly_invades_gallbladder tinyint(1) DEFAULT '0',
  tumor_directly_invades_adjacent_organs_other_than_gallbladder tinyint(1) DEFAULT '0',
  tumor_extension_specify varchar(250) DEFAULT NULL,
  hepatic_parenchymal_margin varchar(50) DEFAULT NULL,
  distance_of_invasive_carcinoma_from_closest_margin_mm decimal(3,1) DEFAULT NULL,
  hp_specify_margin varchar(250) DEFAULT NULL,
  bile_duct_margin varchar(50) DEFAULT NULL,
  dysplasia_carcinoma_in_situ_data varchar(50) DEFAULT NULL,
  other_margin varchar(50) DEFAULT NULL,
  specify_other_margin varchar(250) DEFAULT NULL,
  lymph_vascular_major_vessel_invasion varchar(50) DEFAULT NULL,
  lymph_vascular_small_vessel_invasion varchar(50) DEFAULT NULL,
  perineural_invasion varchar(50) DEFAULT NULL,
  cirrhosis_severe_fibrosis tinyint(1) NOT NULL DEFAULT '0',
  primary_sclerosing_cholangitis tinyint(1) NOT NULL DEFAULT '0',
  biliary_stones tinyint(1) NOT NULL DEFAULT '0',
  chronic_hepatitis tinyint(1) NOT NULL DEFAULT '0',
  specify_type varchar(250) DEFAULT NULL,
  additional_path_other tinyint(1) NOT NULL DEFAULT '0',
  additional_path_other_specify varchar(250) DEFAULT NULL,
  none_identified tinyint(1) NOT NULL DEFAULT '0',
  ancillary_studies_specify varchar(250) DEFAULT NULL,
  cirrhosis tinyint(1) NOT NULL DEFAULT '0',
  cli_primary_sclerosing_cholangitis tinyint(1) NOT NULL DEFAULT '0',
  inflammatory_bowel_disease tinyint(1) NOT NULL DEFAULT '0',
  hepatitis_c_infection tinyint(1) NOT NULL DEFAULT '0',
  other_clinical_history tinyint(1) NOT NULL DEFAULT '0',
  other_clinical_history_specify varchar(250) DEFAULT NULL,
  not_known tinyint(1) NOT NULL DEFAULT '0',
  comments varchar(250) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  modified_by int(10) unsigned NOT NULL,
  deleted int(11) NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (version_id),
  KEY diagnosis_master_id (diagnosis_master_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE dxd_cap_report_pancreasendos (
  id int(11) NOT NULL AUTO_INCREMENT,
  diagnosis_master_id int(11) NOT NULL DEFAULT '0',
  head_of_pancreas tinyint(1) DEFAULT '0',
  body_of_pancreas tinyint(1) DEFAULT '0',
  tail_of_pancreas tinyint(1) DEFAULT '0',
  duodenum tinyint(1) DEFAULT '0',
  stomach tinyint(1) DEFAULT '0',
  common_bile_duct tinyint(1) DEFAULT '0',
  gallbladder tinyint(1) DEFAULT '0',
  spleen tinyint(1) DEFAULT '0',
  adjacent_large_vessels tinyint(1) DEFAULT '0',
  portal_vein tinyint(1) DEFAULT '0',
  superior_mesenteric_vein tinyint(1) DEFAULT '0',
  other_large_vessels tinyint(1) DEFAULT '0',
  other_large_vessels_specify varchar(50) DEFAULT NULL,
  other_specimen tinyint(1) DEFAULT '0',
  other_specimen_specify varchar(250) DEFAULT NULL,
  specimen_not_specified tinyint(1) DEFAULT '0',
  specimen_cannot_be_determined tinyint(1) DEFAULT '0',
  `procedure` varchar(100) DEFAULT NULL,
  procedure_specify varchar(250) DEFAULT NULL,
  tumor_site_pancreatic_head tinyint(1) DEFAULT '0',
  tumor_site_uncinate_process tinyint(1) DEFAULT '0',
  tumor_site_pancreatic_body tinyint(1) DEFAULT '0',
  tumor_site_pancreatic_tail tinyint(1) DEFAULT '0',
  tumor_site_other tinyint(1) DEFAULT '0',
  tumor_site_other_specify varchar(250) DEFAULT NULL,
  tumor_site_cannot_be_determined tinyint(1) DEFAULT '0',
  tumor_site_not_specified tinyint(1) DEFAULT '0',
  tumor_focality varchar(50) DEFAULT NULL,
  specify_number_of_tumors smallint(1) DEFAULT NULL,
  histologic_type varchar(100) DEFAULT NULL,
  carcinoma_precision varchar(50) DEFAULT NULL,
  histologic_type_specify varchar(250) DEFAULT NULL,
  world_health_organization_classification varchar(60) DEFAULT NULL,
  functional_type_cannot_be_assessed tinyint(1) DEFAULT '0',
  panc_endoc_tumor_functional tinyint(1) DEFAULT '0',
  insulin_producing tinyint(1) DEFAULT '0',
  glucagon_producing tinyint(1) DEFAULT '0',
  somatostatin_producing tinyint(1) DEFAULT '0',
  gastrin_producing tinyint(1) DEFAULT '0',
  VIP_producing tinyint(1) DEFAULT '0',
  functional_type_other tinyint(1) DEFAULT '0',
  functional_type_other_specify varchar(250) DEFAULT NULL,
  pancreatic_endocrine_tumor_nonfunctional tinyint(1) DEFAULT '0',
  panc_endoc_tumor_functional_status_unknown tinyint(1) DEFAULT '0',
  mitotic_not_applicable tinyint(1) DEFAULT '0',
  less_than_2_mitoses_10_high_power_fields tinyint(1) DEFAULT '0',
  less_than_2_mitoses_specify_per_10_HPF varchar(10) DEFAULT NULL,
  greater_than_or_equal_to_2_mitoses_10_HPF_to_10_mitoses_10_HPF tinyint(1) DEFAULT '0',
  greater_or_equal_to_2_mitoses_specify_per_10_HPF varchar(10) DEFAULT NULL,
  greater_than_10_mitoses_per_10_HPF tinyint(1) DEFAULT '0',
  mitotic_cannot_be_determined tinyint(1) DEFAULT '0',
  less_or_equal_2percent_Ki67_positive_cells tinyint(1) DEFAULT '0',
  3_to_20percent_Ki67_positive_cells tinyint(1) DEFAULT '0',
  great_than_20percent_Ki67_positive_cells tinyint(1) DEFAULT '0',
  tumor_necrosis varchar(30) DEFAULT NULL,
  microscopic_tumor_extension_cannot_be_determined tinyint(1) DEFAULT '0',
  no_evidence_of_primary_tumor tinyint(1) DEFAULT '0',
  tumor_is_confined_to_pancreas tinyint(1) DEFAULT '0',
  tumor_invades_ampulla_of_vater tinyint(1) DEFAULT '0',
  tumor_invades_common_bile_duct tinyint(1) DEFAULT '0',
  tumor_invades_duodenal_wall tinyint(1) DEFAULT '0',
  tumor_invades_peripancreatic_soft_tissues tinyint(1) DEFAULT '0',
  tumor_invades_other_adjacent_organs_or_structures tinyint(1) DEFAULT '0',
  tumor_invades_other_adjacent_organs_or_structures_specify varchar(250) DEFAULT NULL,
  margin_cannot_be_assessed tinyint(1) DEFAULT '0',
  margins_uninvolved_by_tumor tinyint(1) DEFAULT '0',
  distance_of_tumor_from_closest_margin_mm decimal(3,1) DEFAULT NULL,
  specify_margin_if_possible varchar(50) DEFAULT NULL,
  margins_involved_by_tumor tinyint(1) DEFAULT '0',
  uncinate_process_retroperitoneal_margin tinyint(1) DEFAULT '0',
  distal_pancreatic_margin tinyint(1) DEFAULT '0',
  common_bile_duct_margin tinyint(1) DEFAULT '0',
  promimal_pancreatic_margin tinyint(1) DEFAULT '0',
  margin_other tinyint(1) DEFAULT '0',
  margin_other_specify varchar(250) DEFAULT NULL,
  tumor_involves_posterior_retroperitoneal_surface_of_pancreas tinyint(1) DEFAULT '0',
  lymph_vascular_invasion varchar(50) DEFAULT NULL,
  perineural_invasion varchar(50) DEFAULT NULL,
  additional_path_none_identified tinyint(1) DEFAULT '0',
  chronic_pancreatitis tinyint(1) DEFAULT '0',
  acute_pancreatitis tinyint(1) DEFAULT '0',
  adenomatosis tinyint(1) DEFAULT '0',
  additional_path_other tinyint(1) DEFAULT '0',
  additional_path_other_specify varchar(250) DEFAULT NULL,
  ancillary_studies_specify varchar(250) DEFAULT NULL,
  `von_hippel-Lindau_disease` tinyint(1) DEFAULT '0',
  multiple_endocrine_neoplasia_type_1 tinyint(1) DEFAULT '0',
  familial_pancreatic_cancer_syndrome tinyint(1) DEFAULT '0',
  hypoglycemic_syndrome varchar(250) DEFAULT NULL,
  necrolytic_migratory_erythema tinyint(1) DEFAULT '0',
  watery_diarrhea tinyint(1) DEFAULT '0',
  hypergastrinemia tinyint(1) DEFAULT '0',
  `zollinger-Ellison_syndrome` tinyint(1) DEFAULT '0',
  other_clinical_history tinyint(1) DEFAULT '0',
  other_clinical_history_specify varchar(250) DEFAULT NULL,
  clinical_history_not_specified tinyint(1) DEFAULT '0',
  comments varchar(250) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  modified_by int(10) unsigned NOT NULL,
  deleted int(11) NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (id),
  KEY diagnosis_master_id (diagnosis_master_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE dxd_cap_report_pancreasendos_revs (
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  id int(11) NOT NULL,
  diagnosis_master_id int(11) NOT NULL DEFAULT '0',
  head_of_pancreas tinyint(1) DEFAULT '0',
  body_of_pancreas tinyint(1) DEFAULT '0',
  tail_of_pancreas tinyint(1) DEFAULT '0',
  duodenum tinyint(1) DEFAULT '0',
  stomach tinyint(1) DEFAULT '0',
  common_bile_duct tinyint(1) DEFAULT '0',
  gallbladder tinyint(1) DEFAULT '0',
  spleen tinyint(1) DEFAULT '0',
  adjacent_large_vessels tinyint(1) DEFAULT '0',
  portal_vein tinyint(1) DEFAULT '0',
  superior_mesenteric_vein tinyint(1) DEFAULT '0',
  other_large_vessels tinyint(1) DEFAULT '0',
  other_large_vessels_specify varchar(50) DEFAULT NULL,
  other_specimen tinyint(1) DEFAULT '0',
  other_specimen_specify varchar(250) DEFAULT NULL,
  specimen_not_specified tinyint(1) DEFAULT '0',
  specimen_cannot_be_determined tinyint(1) DEFAULT '0',
  `procedure` varchar(100) DEFAULT NULL,
  procedure_specify varchar(250) DEFAULT NULL,
  tumor_site_pancreatic_head tinyint(1) DEFAULT '0',
  tumor_site_uncinate_process tinyint(1) DEFAULT '0',
  tumor_site_pancreatic_body tinyint(1) DEFAULT '0',
  tumor_site_pancreatic_tail tinyint(1) DEFAULT '0',
  tumor_site_other tinyint(1) DEFAULT '0',
  tumor_site_other_specify varchar(250) DEFAULT NULL,
  tumor_site_cannot_be_determined tinyint(1) DEFAULT '0',
  tumor_site_not_specified tinyint(1) DEFAULT '0',
  tumor_focality varchar(50) DEFAULT NULL,
  specify_number_of_tumors smallint(1) DEFAULT NULL,
  histologic_type varchar(100) DEFAULT NULL,
  carcinoma_precision varchar(50) DEFAULT NULL,
  histologic_type_specify varchar(250) DEFAULT NULL,
  world_health_organization_classification varchar(60) DEFAULT NULL,
  functional_type_cannot_be_assessed tinyint(1) DEFAULT '0',
  panc_endoc_tumor_functional tinyint(1) DEFAULT '0',
  insulin_producing tinyint(1) DEFAULT '0',
  glucagon_producing tinyint(1) DEFAULT '0',
  somatostatin_producing tinyint(1) DEFAULT '0',
  gastrin_producing tinyint(1) DEFAULT '0',
  VIP_producing tinyint(1) DEFAULT '0',
  functional_type_other tinyint(1) DEFAULT '0',
  functional_type_other_specify varchar(250) DEFAULT NULL,
  pancreatic_endocrine_tumor_nonfunctional tinyint(1) DEFAULT '0',
  panc_endoc_tumor_functional_status_unknown tinyint(1) DEFAULT '0',
  mitotic_not_applicable tinyint(1) DEFAULT '0',
  less_than_2_mitoses_10_high_power_fields tinyint(1) DEFAULT '0',
  less_than_2_mitoses_specify_per_10_HPF varchar(10) DEFAULT NULL,
  greater_than_or_equal_to_2_mitoses_10_HPF_to_10_mitoses_10_HPF tinyint(1) DEFAULT '0',
  greater_or_equal_to_2_mitoses_specify_per_10_HPF varchar(10) DEFAULT NULL,
  greater_than_10_mitoses_per_10_HPF tinyint(1) DEFAULT '0',
  mitotic_cannot_be_determined tinyint(1) DEFAULT '0',
  less_or_equal_2percent_Ki67_positive_cells tinyint(1) DEFAULT '0',
  3_to_20percent_Ki67_positive_cells tinyint(1) DEFAULT '0',
  great_than_20percent_Ki67_positive_cells tinyint(1) DEFAULT '0',
  tumor_necrosis varchar(30) DEFAULT NULL,
  microscopic_tumor_extension_cannot_be_determined tinyint(1) DEFAULT '0',
  no_evidence_of_primary_tumor tinyint(1) DEFAULT '0',
  tumor_is_confined_to_pancreas tinyint(1) DEFAULT '0',
  tumor_invades_ampulla_of_vater tinyint(1) DEFAULT '0',
  tumor_invades_common_bile_duct tinyint(1) DEFAULT '0',
  tumor_invades_duodenal_wall tinyint(1) DEFAULT '0',
  tumor_invades_peripancreatic_soft_tissues tinyint(1) DEFAULT '0',
  tumor_invades_other_adjacent_organs_or_structures tinyint(1) DEFAULT '0',
  tumor_invades_other_adjacent_organs_or_structures_specify varchar(250) DEFAULT NULL,
  margin_cannot_be_assessed tinyint(1) DEFAULT '0',
  margins_uninvolved_by_tumor tinyint(1) DEFAULT '0',
  distance_of_tumor_from_closest_margin_mm decimal(3,1) DEFAULT NULL,
  specify_margin_if_possible varchar(50) DEFAULT NULL,
  margins_involved_by_tumor tinyint(1) DEFAULT '0',
  uncinate_process_retroperitoneal_margin tinyint(1) DEFAULT '0',
  distal_pancreatic_margin tinyint(1) DEFAULT '0',
  common_bile_duct_margin tinyint(1) DEFAULT '0',
  promimal_pancreatic_margin tinyint(1) DEFAULT '0',
  margin_other tinyint(1) DEFAULT '0',
  margin_other_specify varchar(250) DEFAULT NULL,
  tumor_involves_posterior_retroperitoneal_surface_of_pancreas tinyint(1) DEFAULT '0',
  lymph_vascular_invasion varchar(50) DEFAULT NULL,
  perineural_invasion varchar(50) DEFAULT NULL,
  additional_path_none_identified tinyint(1) DEFAULT '0',
  chronic_pancreatitis tinyint(1) DEFAULT '0',
  acute_pancreatitis tinyint(1) DEFAULT '0',
  adenomatosis tinyint(1) DEFAULT '0',
  additional_path_other tinyint(1) DEFAULT '0',
  additional_path_other_specify varchar(250) DEFAULT NULL,
  ancillary_studies_specify varchar(250) DEFAULT NULL,
  `von_hippel-Lindau_disease` tinyint(1) DEFAULT '0',
  multiple_endocrine_neoplasia_type_1 tinyint(1) DEFAULT '0',
  familial_pancreatic_cancer_syndrome tinyint(1) DEFAULT '0',
  hypoglycemic_syndrome varchar(250) DEFAULT NULL,
  necrolytic_migratory_erythema tinyint(1) DEFAULT '0',
  watery_diarrhea tinyint(1) DEFAULT '0',
  hypergastrinemia tinyint(1) DEFAULT '0',
  `zollinger-Ellison_syndrome` tinyint(1) DEFAULT '0',
  other_clinical_history tinyint(1) DEFAULT '0',
  other_clinical_history_specify varchar(250) DEFAULT NULL,
  clinical_history_not_specified tinyint(1) DEFAULT '0',
  comments varchar(250) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  modified_by int(10) unsigned NOT NULL,
  deleted int(11) NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (version_id),
  KEY diagnosis_master_id (diagnosis_master_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE dxd_cap_report_pancreasexos (
  id int(11) NOT NULL AUTO_INCREMENT,
  diagnosis_master_id int(11) NOT NULL DEFAULT '0',
  head_of_pancreas tinyint(1) DEFAULT '0',
  body_of_pancreas tinyint(1) DEFAULT '0',
  tail_of_pancreas tinyint(1) DEFAULT '0',
  duodenum tinyint(1) DEFAULT '0',
  stomach tinyint(1) DEFAULT '0',
  common_bile_duct tinyint(1) DEFAULT '0',
  gallbladder tinyint(1) DEFAULT '0',
  spleen tinyint(1) DEFAULT '0',
  adjacent_large_vessels tinyint(1) DEFAULT '0',
  portal_vein tinyint(1) DEFAULT '0',
  superior_mesenteric_vein tinyint(1) DEFAULT '0',
  other_large_vessels tinyint(1) DEFAULT '0',
  other_large_vessels_specify varchar(50) DEFAULT NULL,
  other_specimen tinyint(1) DEFAULT '0',
  other_specimen_specify varchar(250) DEFAULT NULL,
  specimen_not_specified tinyint(1) DEFAULT '0',
  specimen_cannot_be_determined tinyint(1) DEFAULT '0',
  `procedure` varchar(100) DEFAULT NULL,
  procedure_specify varchar(250) DEFAULT NULL,
  tumor_site_pancreatic_head tinyint(1) DEFAULT '0',
  tumor_site_uncinate_process tinyint(1) DEFAULT '0',
  tumor_site_pancreatic_body tinyint(1) DEFAULT '0',
  tumor_site_pancreatic_tail tinyint(1) DEFAULT '0',
  tumor_site_other tinyint(1) DEFAULT '0',
  tumor_site_other_specify varchar(250) DEFAULT NULL,
  tumor_site_cannot_be_determined tinyint(1) DEFAULT '0',
  tumor_site_not_specified tinyint(1) DEFAULT '0',
  ductal_adenocarcinoma tinyint(1) DEFAULT '0',
  mucinous_noncystic_carcinoma tinyint(1) DEFAULT '0',
  signet_ring_cell_carcinoma tinyint(1) DEFAULT '0',
  adenosquamous_carcinoma tinyint(1) DEFAULT '0',
  undifferentiated_anaplastic_carcinoma tinyint(1) DEFAULT '0',
  undifferentiated_carcinoma_with_osteoclast_like_giant_cells tinyint(1) DEFAULT '0',
  mixed_ductal_endocrine_carcinoma tinyint(1) DEFAULT '0',
  serous_cystadenocarcinoma tinyint(1) DEFAULT '0',
  mucinous_cystic_neoplasm tinyint(1) DEFAULT '0',
  muc_cys_neo_noninvasive tinyint(1) DEFAULT '0',
  muc_cys_neo_invasive tinyint(1) DEFAULT '0',
  intraductal_papillary_mucinous_carcinoma tinyint(1) DEFAULT '0',
  int_pap_muc_carc_noninvasive tinyint(1) DEFAULT '0',
  int_pap_muc_carc_invasive tinyint(1) DEFAULT '0',
  acinar_cell_carcinoma tinyint(1) DEFAULT '0',
  acinar_cell_cystadenocarcinoma tinyint(1) DEFAULT '0',
  mixed_acinar_endocrine_carcinoma tinyint(1) DEFAULT '0',
  histologic_type_other tinyint(1) DEFAULT '0',
  histologic_type_other_specify varchar(250) DEFAULT NULL,
  microscopic_tumor_extension_cannot_be_assessed tinyint(1) DEFAULT '0',
  no_evidence_of_primary_tumor tinyint(1) DEFAULT '0',
  carcinoma_in_situ tinyint(1) DEFAULT '0',
  tumor_is_confined_to_pancreas tinyint(1) DEFAULT '0',
  tumor_invades_ampulla_of_vater_or_sphincter_of_oddi tinyint(1) DEFAULT '0',
  tumor_invades_duodenal_wall tinyint(1) DEFAULT '0',
  tumor_invades_peripancreatic_soft_tissues tinyint(1) DEFAULT '0',
  tumor_invades_retroperitoneal_soft_tissue tinyint(1) DEFAULT '0',
  tumor_invades_mesenteric_adipose_tissue tinyint(1) DEFAULT '0',
  tumor_invades_mesocolon tinyint(1) DEFAULT '0',
  tumor_invades_other_peripancreatic_soft_tissue tinyint(1) DEFAULT '0',
  tumor_invades_other_peripancreatic_soft_tissue_specify varchar(250) DEFAULT NULL,
  tumor_invades_extrapancreatic_common_bile_duct tinyint(1) DEFAULT '0',
  tumor_invades_other_adjacent_organs_or_structures tinyint(1) DEFAULT '0',
  tumor_invades_other_adjacent_organs_or_structures_specify varchar(250) DEFAULT NULL,
  margin_cannot_be_assessed tinyint(1) DEFAULT '0',
  margins_uninvolved_by_invasive_carcinoma tinyint(1) DEFAULT '0',
  distance_of_invasive_carcinoma_from_closest_margin_mm decimal(3,1) DEFAULT NULL,
  margins_uninvolved_by_invasive_carcinoma_specify varchar(50) DEFAULT NULL,
  margins_uninvolved_by_carcinoma_in_situ tinyint(1) DEFAULT '0',
  margins_involved_by_carcinoma_in_situ tinyint(1) DEFAULT '0',
  carcinoma_in_situ_present_at_common_bile_duct_margin tinyint(1) DEFAULT '0',
  carcinoma_in_situ_present_at_pancreatic_parenchymal_margin tinyint(1) DEFAULT '0',
  margins_involved_by_invasive_carcinoma tinyint(1) DEFAULT '0',
  uncinate_process_margin tinyint(1) DEFAULT '0',
  distal_pancreatic_margin tinyint(1) DEFAULT '0',
  common_bile_duct_margin tinyint(1) DEFAULT '0',
  promimal_pancreatic_margin tinyint(1) DEFAULT '0',
  other_margins_involved_by_invas_carc tinyint(1) DEFAULT '0',
  other_margins_involved_by_invas_carc_specify varchar(250) DEFAULT NULL,
  invasive_carcinoma_involves_posterior_retroperitoneal_surface_of tinyint(1) DEFAULT '0',
  no_prior_treatment tinyint(1) DEFAULT '0',
  trt_effect_present tinyint(1) DEFAULT '0',
  no_residual_tumor_complete_response_grade_0 tinyint(1) DEFAULT '0',
  marked_response_grade_1_minimal_residual_cancer tinyint(1) DEFAULT '0',
  moderate_response_grade_2 tinyint(1) DEFAULT '0',
  no_definite_response_identified_grade_3_poor_or_no_response tinyint(1) DEFAULT '0',
  trt_effect_not_known tinyint(1) DEFAULT '0',
  lymph_vascular_invasion varchar(50) DEFAULT NULL,
  perineural_invasion varchar(50) DEFAULT NULL,
  additional_path_none_identified tinyint(1) DEFAULT '0',
  pancreatic_intraepithelial_neoplasia tinyint(1) DEFAULT '0',
  highest_grade_PanIN varchar(50) DEFAULT NULL,
  chronic_pancreatitis tinyint(1) DEFAULT '0',
  acute_pancreatitis tinyint(1) DEFAULT '0',
  additional_path_other tinyint(1) DEFAULT '0',
  additional_path_other_specify varchar(250) DEFAULT NULL,
  ancillary_studies_specify varchar(250) DEFAULT NULL,
  neoadjuvant_therapy tinyint(1) DEFAULT '0',
  familial_pancreatitis tinyint(1) DEFAULT '0',
  familial_pancreatic_cancer_syndrome tinyint(1) DEFAULT '0',
  other_clinical_history tinyint(1) DEFAULT '0',
  other_clinical_history_specify varchar(250) DEFAULT NULL,
  clinical_history_not_specified tinyint(1) DEFAULT '0',
  comments varchar(250) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  modified_by int(10) unsigned NOT NULL,
  deleted int(11) NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (id),
  KEY diagnosis_master_id (diagnosis_master_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE dxd_cap_report_pancreasexos_revs (
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  id int(11) NOT NULL,
  diagnosis_master_id int(11) NOT NULL DEFAULT '0',
  head_of_pancreas tinyint(1) DEFAULT '0',
  body_of_pancreas tinyint(1) DEFAULT '0',
  tail_of_pancreas tinyint(1) DEFAULT '0',
  duodenum tinyint(1) DEFAULT '0',
  stomach tinyint(1) DEFAULT '0',
  common_bile_duct tinyint(1) DEFAULT '0',
  gallbladder tinyint(1) DEFAULT '0',
  spleen tinyint(1) DEFAULT '0',
  adjacent_large_vessels tinyint(1) DEFAULT '0',
  portal_vein tinyint(1) DEFAULT '0',
  superior_mesenteric_vein tinyint(1) DEFAULT '0',
  other_large_vessels tinyint(1) DEFAULT '0',
  other_large_vessels_specify varchar(50) DEFAULT NULL,
  other_specimen tinyint(1) DEFAULT '0',
  other_specimen_specify varchar(250) DEFAULT NULL,
  specimen_not_specified tinyint(1) DEFAULT '0',
  specimen_cannot_be_determined tinyint(1) DEFAULT '0',
  `procedure` varchar(100) DEFAULT NULL,
  procedure_specify varchar(250) DEFAULT NULL,
  tumor_site_pancreatic_head tinyint(1) DEFAULT '0',
  tumor_site_uncinate_process tinyint(1) DEFAULT '0',
  tumor_site_pancreatic_body tinyint(1) DEFAULT '0',
  tumor_site_pancreatic_tail tinyint(1) DEFAULT '0',
  tumor_site_other tinyint(1) DEFAULT '0',
  tumor_site_other_specify varchar(250) DEFAULT NULL,
  tumor_site_cannot_be_determined tinyint(1) DEFAULT '0',
  tumor_site_not_specified tinyint(1) DEFAULT '0',
  ductal_adenocarcinoma tinyint(1) DEFAULT '0',
  mucinous_noncystic_carcinoma tinyint(1) DEFAULT '0',
  signet_ring_cell_carcinoma tinyint(1) DEFAULT '0',
  adenosquamous_carcinoma tinyint(1) DEFAULT '0',
  undifferentiated_anaplastic_carcinoma tinyint(1) DEFAULT '0',
  undifferentiated_carcinoma_with_osteoclast_like_giant_cells tinyint(1) DEFAULT '0',
  mixed_ductal_endocrine_carcinoma tinyint(1) DEFAULT '0',
  serous_cystadenocarcinoma tinyint(1) DEFAULT '0',
  mucinous_cystic_neoplasm tinyint(1) DEFAULT '0',
  muc_cys_neo_noninvasive tinyint(1) DEFAULT '0',
  muc_cys_neo_invasive tinyint(1) DEFAULT '0',
  intraductal_papillary_mucinous_carcinoma tinyint(1) DEFAULT '0',
  int_pap_muc_carc_noninvasive tinyint(1) DEFAULT '0',
  int_pap_muc_carc_invasive tinyint(1) DEFAULT '0',
  acinar_cell_carcinoma tinyint(1) DEFAULT '0',
  acinar_cell_cystadenocarcinoma tinyint(1) DEFAULT '0',
  mixed_acinar_endocrine_carcinoma tinyint(1) DEFAULT '0',
  histologic_type_other tinyint(1) DEFAULT '0',
  histologic_type_other_specify varchar(250) DEFAULT NULL,
  microscopic_tumor_extension_cannot_be_assessed tinyint(1) DEFAULT '0',
  no_evidence_of_primary_tumor tinyint(1) DEFAULT '0',
  carcinoma_in_situ tinyint(1) DEFAULT '0',
  tumor_is_confined_to_pancreas tinyint(1) DEFAULT '0',
  tumor_invades_ampulla_of_vater_or_sphincter_of_oddi tinyint(1) DEFAULT '0',
  tumor_invades_duodenal_wall tinyint(1) DEFAULT '0',
  tumor_invades_peripancreatic_soft_tissues tinyint(1) DEFAULT '0',
  tumor_invades_retroperitoneal_soft_tissue tinyint(1) DEFAULT '0',
  tumor_invades_mesenteric_adipose_tissue tinyint(1) DEFAULT '0',
  tumor_invades_mesocolon tinyint(1) DEFAULT '0',
  tumor_invades_other_peripancreatic_soft_tissue tinyint(1) DEFAULT '0',
  tumor_invades_other_peripancreatic_soft_tissue_specify varchar(250) DEFAULT NULL,
  tumor_invades_extrapancreatic_common_bile_duct tinyint(1) DEFAULT '0',
  tumor_invades_other_adjacent_organs_or_structures tinyint(1) DEFAULT '0',
  tumor_invades_other_adjacent_organs_or_structures_specify varchar(250) DEFAULT NULL,
  margin_cannot_be_assessed tinyint(1) DEFAULT '0',
  margins_uninvolved_by_invasive_carcinoma tinyint(1) DEFAULT '0',
  distance_of_invasive_carcinoma_from_closest_margin_mm decimal(3,1) DEFAULT NULL,
  margins_uninvolved_by_invasive_carcinoma_specify varchar(50) DEFAULT NULL,
  margins_uninvolved_by_carcinoma_in_situ tinyint(1) DEFAULT '0',
  margins_involved_by_carcinoma_in_situ tinyint(1) DEFAULT '0',
  carcinoma_in_situ_present_at_common_bile_duct_margin tinyint(1) DEFAULT '0',
  carcinoma_in_situ_present_at_pancreatic_parenchymal_margin tinyint(1) DEFAULT '0',
  margins_involved_by_invasive_carcinoma tinyint(1) DEFAULT '0',
  uncinate_process_margin tinyint(1) DEFAULT '0',
  distal_pancreatic_margin tinyint(1) DEFAULT '0',
  common_bile_duct_margin tinyint(1) DEFAULT '0',
  promimal_pancreatic_margin tinyint(1) DEFAULT '0',
  other_margins_involved_by_invas_carc tinyint(1) DEFAULT '0',
  other_margins_involved_by_invas_carc_specify varchar(250) DEFAULT NULL,
  invasive_carcinoma_involves_posterior_retroperitoneal_surface_of tinyint(1) DEFAULT '0',
  no_prior_treatment tinyint(1) DEFAULT '0',
  trt_effect_present tinyint(1) DEFAULT '0',
  no_residual_tumor_complete_response_grade_0 tinyint(1) DEFAULT '0',
  marked_response_grade_1_minimal_residual_cancer tinyint(1) DEFAULT '0',
  moderate_response_grade_2 tinyint(1) DEFAULT '0',
  no_definite_response_identified_grade_3_poor_or_no_response tinyint(1) DEFAULT '0',
  trt_effect_not_known tinyint(1) DEFAULT '0',
  lymph_vascular_invasion varchar(50) DEFAULT NULL,
  perineural_invasion varchar(50) DEFAULT NULL,
  additional_path_none_identified tinyint(1) DEFAULT '0',
  pancreatic_intraepithelial_neoplasia tinyint(1) DEFAULT '0',
  highest_grade_PanIN varchar(50) DEFAULT NULL,
  chronic_pancreatitis tinyint(1) DEFAULT '0',
  acute_pancreatitis tinyint(1) DEFAULT '0',
  additional_path_other tinyint(1) DEFAULT '0',
  additional_path_other_specify varchar(250) DEFAULT NULL,
  ancillary_studies_specify varchar(250) DEFAULT NULL,
  neoadjuvant_therapy tinyint(1) DEFAULT '0',
  familial_pancreatitis tinyint(1) DEFAULT '0',
  familial_pancreatic_cancer_syndrome tinyint(1) DEFAULT '0',
  other_clinical_history tinyint(1) DEFAULT '0',
  other_clinical_history_specify varchar(250) DEFAULT NULL,
  clinical_history_not_specified tinyint(1) DEFAULT '0',
  comments varchar(250) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  modified_by int(10) unsigned NOT NULL,
  deleted int(11) NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (version_id),
  KEY diagnosis_master_id (diagnosis_master_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE dxd_cap_report_perihilarbileducts (
  id int(11) NOT NULL AUTO_INCREMENT,
  diagnosis_master_id int(11) NOT NULL DEFAULT '0',
  common_bile_duct tinyint(1) DEFAULT '0',
  right_hepatic_duct tinyint(1) DEFAULT '0',
  left_hepatic_duct tinyint(1) DEFAULT '0',
  junction_of_right_and_left_hepatic_ducts tinyint(1) DEFAULT '0',
  common_hepatic_duct tinyint(1) DEFAULT '0',
  cystic_duct tinyint(1) DEFAULT '0',
  liver tinyint(1) DEFAULT '0',
  gallbladder tinyint(1) DEFAULT '0',
  other_specimen tinyint(1) DEFAULT '0',
  other_specimen_specify varchar(250) DEFAULT NULL,
  `procedure` varchar(50) DEFAULT NULL,
  procedure_specify varchar(250) DEFAULT NULL,
  tumor_site_right_hepatic_duct tinyint(1) DEFAULT '0',
  tumor_site_left_hepatic_duct tinyint(1) DEFAULT '0',
  tumor_site_junction_of_right_and_left_hepatic_ducts tinyint(1) DEFAULT '0',
  tumor_site_cystic_duct tinyint(1) DEFAULT '0',
  tumor_site_common_hepatic_duct tinyint(1) DEFAULT '0',
  tumor_site_common_bile_duct tinyint(1) DEFAULT '0',
  tumor_site_not_specified tinyint(1) DEFAULT '0',
  histologic_type varchar(100) DEFAULT NULL,
  histologic_type_specify varchar(250) DEFAULT NULL,
  carcinoma_in_situ tinyint(1) DEFAULT '0',
  tumor_confined_to_the_bile_duct_histologically tinyint(1) DEFAULT '0',
  tumor_invades_into_surrounding_connective_tissue tinyint(1) DEFAULT '0',
  tumor_invades_the_adjacent_liver_parenchyma tinyint(1) DEFAULT '0',
  tumor_invades_the_gallbladder tinyint(1) DEFAULT '0',
  tumor_invades_the_unilateral_branches_of_the_portal_vein tinyint(1) DEFAULT '0',
  tumor_invades_the_unilateral_branches_of_the_hepatic_artery tinyint(1) DEFAULT '0',
  tumor_invades_main_portal_vein_or_its_branches_bilaterally tinyint(1) DEFAULT '0',
  tumor_invades_common_hepatic_artery tinyint(1) DEFAULT '0',
  tumor_invades_second_order_biliary_radicals tinyint(1) DEFAULT '0',
  sec_ord_biliary_radical_unilateral tinyint(1) DEFAULT '0',
  sec_ord_biliary_radical_bilateral tinyint(1) DEFAULT '0',
  margin_cannot_be_assessed tinyint(1) DEFAULT '0',
  margins_uninvolved_by_invasive_carcinoma tinyint(1) DEFAULT '0',
  distance_of_invasive_carcinoma_from_closest_margin decimal(3,1) DEFAULT NULL,
  distance_unit char(2) DEFAULT NULL,
  specify_margin varchar(250) DEFAULT NULL,
  margins_involved_by_invasive_carcinoma tinyint(1) DEFAULT '0',
  proximal_bile_duct_margin tinyint(1) DEFAULT '0',
  distal_bile_duct_margin tinyint(1) DEFAULT '0',
  hepatic_parenchymal_margin tinyint(1) DEFAULT '0',
  margin_other tinyint(1) DEFAULT '0',
  margin_other_specify varchar(250) DEFAULT NULL,
  dysplasia_carcinoma_in_situ_not_identified_at_bile_duct_margin tinyint(1) DEFAULT '0',
  dysplasia_carcinoma_in_situ_present_at_bile_duct_margin tinyint(1) DEFAULT '0',
  lymph_vascular_invasion varchar(50) DEFAULT NULL,
  perineural_invasion varchar(50) DEFAULT NULL,
  additional_path_none_identified tinyint(1) NOT NULL DEFAULT '0',
  choledochal_cyst tinyint(1) NOT NULL DEFAULT '0',
  dysplasia tinyint(1) NOT NULL DEFAULT '0',
  primary_sclerosing_cholangitis_PSC tinyint(1) NOT NULL DEFAULT '0',
  biliary_stones tinyint(1) NOT NULL DEFAULT '0',
  additional_path_other tinyint(1) NOT NULL DEFAULT '0',
  additional_path_other_specify varchar(250) DEFAULT NULL,
  ancillary_studies_specify varchar(250) DEFAULT NULL,
  PSC tinyint(1) NOT NULL DEFAULT '0',
  inflammatory_bowel_disease tinyint(1) NOT NULL DEFAULT '0',
  other_clinical_biliary_stones tinyint(1) NOT NULL DEFAULT '0',
  other_clinical_history tinyint(1) NOT NULL DEFAULT '0',
  other_clinical_history_specify varchar(250) DEFAULT NULL,
  not_known tinyint(1) NOT NULL DEFAULT '0',
  comments varchar(250) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  modified_by int(10) unsigned NOT NULL,
  deleted int(11) NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (id),
  KEY diagnosis_master_id (diagnosis_master_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE dxd_cap_report_perihilarbileducts_revs (
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  id int(11) NOT NULL,
  diagnosis_master_id int(11) NOT NULL DEFAULT '0',
  common_bile_duct tinyint(1) DEFAULT '0',
  right_hepatic_duct tinyint(1) DEFAULT '0',
  left_hepatic_duct tinyint(1) DEFAULT '0',
  junction_of_right_and_left_hepatic_ducts tinyint(1) DEFAULT '0',
  common_hepatic_duct tinyint(1) DEFAULT '0',
  cystic_duct tinyint(1) DEFAULT '0',
  liver tinyint(1) DEFAULT '0',
  gallbladder tinyint(1) DEFAULT '0',
  other_specimen tinyint(1) DEFAULT '0',
  other_specimen_specify varchar(250) DEFAULT NULL,
  `procedure` varchar(50) DEFAULT NULL,
  procedure_specify varchar(250) DEFAULT NULL,
  tumor_site_right_hepatic_duct tinyint(1) DEFAULT '0',
  tumor_site_left_hepatic_duct tinyint(1) DEFAULT '0',
  tumor_site_junction_of_right_and_left_hepatic_ducts tinyint(1) DEFAULT '0',
  tumor_site_cystic_duct tinyint(1) DEFAULT '0',
  tumor_site_common_hepatic_duct tinyint(1) DEFAULT '0',
  tumor_site_common_bile_duct tinyint(1) DEFAULT '0',
  tumor_site_not_specified tinyint(1) DEFAULT '0',
  histologic_type varchar(100) DEFAULT NULL,
  histologic_type_specify varchar(250) DEFAULT NULL,
  carcinoma_in_situ tinyint(1) DEFAULT '0',
  tumor_confined_to_the_bile_duct_histologically tinyint(1) DEFAULT '0',
  tumor_invades_into_surrounding_connective_tissue tinyint(1) DEFAULT '0',
  tumor_invades_the_adjacent_liver_parenchyma tinyint(1) DEFAULT '0',
  tumor_invades_the_gallbladder tinyint(1) DEFAULT '0',
  tumor_invades_the_unilateral_branches_of_the_portal_vein tinyint(1) DEFAULT '0',
  tumor_invades_the_unilateral_branches_of_the_hepatic_artery tinyint(1) DEFAULT '0',
  tumor_invades_main_portal_vein_or_its_branches_bilaterally tinyint(1) DEFAULT '0',
  tumor_invades_common_hepatic_artery tinyint(1) DEFAULT '0',
  tumor_invades_second_order_biliary_radicals tinyint(1) DEFAULT '0',
  sec_ord_biliary_radical_unilateral tinyint(1) DEFAULT '0',
  sec_ord_biliary_radical_bilateral tinyint(1) DEFAULT '0',
  margin_cannot_be_assessed tinyint(1) DEFAULT '0',
  margins_uninvolved_by_invasive_carcinoma tinyint(1) DEFAULT '0',
  distance_of_invasive_carcinoma_from_closest_margin decimal(3,1) DEFAULT NULL,
  distance_unit char(2) DEFAULT NULL,
  specify_margin varchar(250) DEFAULT NULL,
  margins_involved_by_invasive_carcinoma tinyint(1) DEFAULT '0',
  proximal_bile_duct_margin tinyint(1) DEFAULT '0',
  distal_bile_duct_margin tinyint(1) DEFAULT '0',
  hepatic_parenchymal_margin tinyint(1) DEFAULT '0',
  margin_other tinyint(1) DEFAULT '0',
  margin_other_specify varchar(250) DEFAULT NULL,
  dysplasia_carcinoma_in_situ_not_identified_at_bile_duct_margin tinyint(1) DEFAULT '0',
  dysplasia_carcinoma_in_situ_present_at_bile_duct_margin tinyint(1) DEFAULT '0',
  lymph_vascular_invasion varchar(50) DEFAULT NULL,
  perineural_invasion varchar(50) DEFAULT NULL,
  additional_path_none_identified tinyint(1) NOT NULL DEFAULT '0',
  choledochal_cyst tinyint(1) NOT NULL DEFAULT '0',
  dysplasia tinyint(1) NOT NULL DEFAULT '0',
  primary_sclerosing_cholangitis_PSC tinyint(1) NOT NULL DEFAULT '0',
  biliary_stones tinyint(1) NOT NULL DEFAULT '0',
  additional_path_other tinyint(1) NOT NULL DEFAULT '0',
  additional_path_other_specify varchar(250) DEFAULT NULL,
  ancillary_studies_specify varchar(250) DEFAULT NULL,
  PSC tinyint(1) NOT NULL DEFAULT '0',
  inflammatory_bowel_disease tinyint(1) NOT NULL DEFAULT '0',
  other_clinical_biliary_stones tinyint(1) NOT NULL DEFAULT '0',
  other_clinical_history tinyint(1) NOT NULL DEFAULT '0',
  other_clinical_history_specify varchar(250) DEFAULT NULL,
  not_known tinyint(1) NOT NULL DEFAULT '0',
  comments varchar(250) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  modified_by int(10) unsigned NOT NULL,
  deleted int(11) NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (version_id),
  KEY diagnosis_master_id (diagnosis_master_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE dxd_cap_report_smintestines (
  id int(11) NOT NULL AUTO_INCREMENT,
  diagnosis_master_id int(11) NOT NULL DEFAULT '0',
  duodenum tinyint(1) DEFAULT '0',
  small_intestine_other_than_duodenum tinyint(1) DEFAULT '0',
  jejunum tinyint(1) DEFAULT '0',
  ileum tinyint(1) DEFAULT '0',
  stomach tinyint(1) DEFAULT '0',
  head_of_pancreas tinyint(1) DEFAULT '0',
  ampulla tinyint(1) DEFAULT '0',
  common_bile_duct tinyint(1) DEFAULT '0',
  gallbladder tinyint(1) DEFAULT '0',
  colon tinyint(1) DEFAULT '0',
  other_specimen tinyint(1) DEFAULT '0',
  other_specimen_specify varchar(250) DEFAULT NULL,
  specimen_not_specified tinyint(1) DEFAULT '0',
  `procedure` varchar(50) DEFAULT NULL,
  procedure_specify varchar(250) DEFAULT NULL,
  tumor_site varchar(50) DEFAULT NULL,
  tumor_site_specify varchar(250) DEFAULT NULL,
  macroscopic_tumor_perforation varchar(50) DEFAULT NULL,
  histologic_type varchar(100) DEFAULT NULL,
  histologic_type_specify varchar(250) DEFAULT NULL,
  microscopic_tumor_extension varchar(250) DEFAULT NULL,
  microscopic_tumor_extension_specify varchar(250) DEFAULT NULL,
  proximal_margin varchar(100) DEFAULT NULL,
  distal_margin varchar(100) DEFAULT NULL,
  radial_margin varchar(100) DEFAULT NULL,
  distance_of_invasive_carcinoma_from_closest_margin decimal(3,1) DEFAULT NULL,
  distance_unit_from_closest_margin char(2) DEFAULT NULL,
  specify_margin varchar(250) DEFAULT NULL,
  bile_duct_margin varchar(50) DEFAULT NULL,
  pancreatic_margin varchar(50) DEFAULT NULL,
  other_distance_of_invasive_carcinoma_from_closest_margin decimal(3,1) DEFAULT NULL,
  other_distance_unit_from_closest_margin char(2) DEFAULT NULL,
  specify_other_margin varchar(250) DEFAULT NULL,
  lymph_vascular_invasion varchar(50) DEFAULT NULL,
  additional_path_none_identified tinyint(1) NOT NULL DEFAULT '0',
  additional_path_adenoma tinyint(1) NOT NULL DEFAULT '0',
  additional_path_crohn tinyint(1) NOT NULL DEFAULT '0',
  additional_path_celiac tinyint(1) NOT NULL DEFAULT '0',
  additional_path_other_polyps tinyint(1) NOT NULL DEFAULT '0',
  additional_path_other_polyps_types varchar(250) DEFAULT NULL,
  additional_path_other tinyint(1) NOT NULL DEFAULT '0',
  additional_path_other_specify varchar(250) DEFAULT NULL,
  microsatellite_instability tinyint(1) NOT NULL DEFAULT '0',
  microsatellite_instability_testing_method varchar(250) DEFAULT NULL,
  microsatellite_instability_grade varchar(10) DEFAULT NULL,
  MLH1 tinyint(1) NOT NULL DEFAULT '0',
  MLH1_result varchar(60) DEFAULT NULL,
  MLH1_specify varchar(250) DEFAULT NULL,
  MSH2 tinyint(1) NOT NULL DEFAULT '0',
  MSH2_result varchar(60) DEFAULT NULL,
  MSH2_specify varchar(250) DEFAULT NULL,
  MSH6 tinyint(1) NOT NULL DEFAULT '0',
  MSH6_result varchar(60) DEFAULT NULL,
  MSH6_specify varchar(250) DEFAULT NULL,
  PMS2 tinyint(1) NOT NULL DEFAULT '0',
  PMS2_result varchar(60) DEFAULT NULL,
  PMS2_specify varchar(250) DEFAULT NULL,
  ancillary_other_specify varchar(250) DEFAULT NULL,
  familial_adenomatous_polyposis_coli tinyint(1) NOT NULL DEFAULT '0',
  hereditary_nonpolyposis_colon_cancer tinyint(1) NOT NULL DEFAULT '0',
  other_polyposis_syndrome tinyint(1) NOT NULL DEFAULT '0',
  other_polyposis_syndrome_specify varchar(250) DEFAULT NULL,
  crohn_disease tinyint(1) NOT NULL DEFAULT '0',
  celiac_disease tinyint(1) NOT NULL DEFAULT '0',
  other_clinical_history tinyint(1) NOT NULL DEFAULT '0',
  other_clinical_history_specify varchar(250) DEFAULT NULL,
  clinical_history_not_known tinyint(1) NOT NULL DEFAULT '0',
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  modified_by int(10) unsigned NOT NULL,
  deleted int(11) NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (id),
  KEY diagnosis_master_id (diagnosis_master_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE dxd_cap_report_smintestines_revs (
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  id int(11) NOT NULL,
  diagnosis_master_id int(11) NOT NULL DEFAULT '0',
  duodenum tinyint(1) DEFAULT '0',
  small_intestine_other_than_duodenum tinyint(1) DEFAULT '0',
  jejunum tinyint(1) DEFAULT '0',
  ileum tinyint(1) DEFAULT '0',
  stomach tinyint(1) DEFAULT '0',
  head_of_pancreas tinyint(1) DEFAULT '0',
  ampulla tinyint(1) DEFAULT '0',
  common_bile_duct tinyint(1) DEFAULT '0',
  gallbladder tinyint(1) DEFAULT '0',
  colon tinyint(1) DEFAULT '0',
  other_specimen tinyint(1) DEFAULT '0',
  other_specimen_specify varchar(250) DEFAULT NULL,
  specimen_not_specified tinyint(1) DEFAULT '0',
  `procedure` varchar(50) DEFAULT NULL,
  procedure_specify varchar(250) DEFAULT NULL,
  tumor_site varchar(50) DEFAULT NULL,
  tumor_site_specify varchar(250) DEFAULT NULL,
  macroscopic_tumor_perforation varchar(50) DEFAULT NULL,
  histologic_type varchar(100) DEFAULT NULL,
  histologic_type_specify varchar(250) DEFAULT NULL,
  microscopic_tumor_extension varchar(250) DEFAULT NULL,
  microscopic_tumor_extension_specify varchar(250) DEFAULT NULL,
  proximal_margin varchar(100) DEFAULT NULL,
  distal_margin varchar(100) DEFAULT NULL,
  radial_margin varchar(100) DEFAULT NULL,
  distance_of_invasive_carcinoma_from_closest_margin decimal(3,1) DEFAULT NULL,
  distance_unit_from_closest_margin char(2) DEFAULT NULL,
  specify_margin varchar(250) DEFAULT NULL,
  bile_duct_margin varchar(50) DEFAULT NULL,
  pancreatic_margin varchar(50) DEFAULT NULL,
  other_distance_of_invasive_carcinoma_from_closest_margin decimal(3,1) DEFAULT NULL,
  other_distance_unit_from_closest_margin char(2) DEFAULT NULL,
  specify_other_margin varchar(250) DEFAULT NULL,
  lymph_vascular_invasion varchar(50) DEFAULT NULL,
  additional_path_none_identified tinyint(1) NOT NULL DEFAULT '0',
  additional_path_adenoma tinyint(1) NOT NULL DEFAULT '0',
  additional_path_crohn tinyint(1) NOT NULL DEFAULT '0',
  additional_path_celiac tinyint(1) NOT NULL DEFAULT '0',
  additional_path_other_polyps tinyint(1) NOT NULL DEFAULT '0',
  additional_path_other_polyps_types varchar(250) DEFAULT NULL,
  additional_path_other tinyint(1) NOT NULL DEFAULT '0',
  additional_path_other_specify varchar(250) DEFAULT NULL,
  microsatellite_instability tinyint(1) NOT NULL DEFAULT '0',
  microsatellite_instability_testing_method varchar(250) DEFAULT NULL,
  microsatellite_instability_grade varchar(10) DEFAULT NULL,
  MLH1 tinyint(1) NOT NULL DEFAULT '0',
  MLH1_result varchar(60) DEFAULT NULL,
  MLH1_specify varchar(250) DEFAULT NULL,
  MSH2 tinyint(1) NOT NULL DEFAULT '0',
  MSH2_result varchar(60) DEFAULT NULL,
  MSH2_specify varchar(250) DEFAULT NULL,
  MSH6 tinyint(1) NOT NULL DEFAULT '0',
  MSH6_result varchar(60) DEFAULT NULL,
  MSH6_specify varchar(250) DEFAULT NULL,
  PMS2 tinyint(1) NOT NULL DEFAULT '0',
  PMS2_result varchar(60) DEFAULT NULL,
  PMS2_specify varchar(250) DEFAULT NULL,
  ancillary_other_specify varchar(250) DEFAULT NULL,
  familial_adenomatous_polyposis_coli tinyint(1) NOT NULL DEFAULT '0',
  hereditary_nonpolyposis_colon_cancer tinyint(1) NOT NULL DEFAULT '0',
  other_polyposis_syndrome tinyint(1) NOT NULL DEFAULT '0',
  other_polyposis_syndrome_specify varchar(250) DEFAULT NULL,
  crohn_disease tinyint(1) NOT NULL DEFAULT '0',
  celiac_disease tinyint(1) NOT NULL DEFAULT '0',
  other_clinical_history tinyint(1) NOT NULL DEFAULT '0',
  other_clinical_history_specify varchar(250) DEFAULT NULL,
  clinical_history_not_known tinyint(1) NOT NULL DEFAULT '0',
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  modified_by int(10) unsigned NOT NULL,
  deleted int(11) NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (version_id),
  KEY diagnosis_master_id (diagnosis_master_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE dxd_tissues (
  id int(11) NOT NULL AUTO_INCREMENT,
  diagnosis_master_id int(11) NOT NULL DEFAULT '0',
  laterality varchar(50) NOT NULL DEFAULT '',
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  modified_by int(10) unsigned NOT NULL,
  deleted int(11) NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (id),
  KEY diagnosis_master_id (diagnosis_master_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE dxd_tissues_revs (
  id int(11) NOT NULL,
  diagnosis_master_id int(11) NOT NULL DEFAULT '0',
  laterality varchar(50) NOT NULL DEFAULT '',
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  modified_by int(10) unsigned NOT NULL,
  deleted int(11) NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE ed_all_adverse_events_adverse_events (
  id int(11) NOT NULL AUTO_INCREMENT,
  supra_ordinate_term varchar(50) DEFAULT NULL,
  select_ae varchar(50) DEFAULT NULL,
  grade varchar(50) DEFAULT NULL,
  description varchar(50) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  modified_by int(10) unsigned NOT NULL,
  event_master_id int(11) DEFAULT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (id),
  KEY event_master_id (event_master_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE ed_all_adverse_events_adverse_events_revs (
  id int(11) NOT NULL,
  supra_ordinate_term varchar(50) DEFAULT NULL,
  select_ae varchar(50) DEFAULT NULL,
  grade varchar(50) DEFAULT NULL,
  description varchar(50) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  modified_by int(10) unsigned NOT NULL,
  event_master_id int(11) DEFAULT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (version_id),
  KEY event_master_id (event_master_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE ed_all_clinical_followups (
  id int(11) NOT NULL AUTO_INCREMENT,
  weight int(11) DEFAULT NULL,
  recurrence_status varchar(50) DEFAULT NULL,
  disease_status varchar(50) DEFAULT NULL,
  vital_status varchar(50) DEFAULT NULL,
  created datetime DEFAULT NULL,
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  event_master_id int(11) DEFAULT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (id),
  KEY event_master_id (event_master_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE ed_all_clinical_followups_revs (
  id int(11) NOT NULL,
  weight int(11) DEFAULT NULL,
  recurrence_status varchar(50) DEFAULT NULL,
  disease_status varchar(50) DEFAULT NULL,
  vital_status varchar(50) DEFAULT NULL,
  created datetime DEFAULT NULL,
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  event_master_id int(11) DEFAULT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (version_id),
  KEY event_master_id (event_master_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE ed_all_clinical_presentations (
  id int(11) NOT NULL AUTO_INCREMENT,
  weight decimal(10,2) DEFAULT NULL,
  height decimal(10,2) DEFAULT NULL,
  created datetime DEFAULT NULL,
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  event_master_id int(11) DEFAULT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (id),
  KEY event_master_id (event_master_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE ed_all_clinical_presentations_revs (
  id int(11) NOT NULL,
  weight decimal(10,2) DEFAULT NULL,
  height decimal(10,2) DEFAULT NULL,
  created datetime DEFAULT NULL,
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  event_master_id int(11) DEFAULT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (version_id),
  KEY event_master_id (event_master_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE ed_all_lifestyle_smokings (
  id int(11) NOT NULL AUTO_INCREMENT,
  smoking_history varchar(50) DEFAULT NULL,
  smoking_status varchar(50) DEFAULT NULL,
  pack_years int(11) DEFAULT NULL,
  product_used varchar(50) DEFAULT NULL,
  years_quit_smoking int(11) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  modified_by int(10) unsigned NOT NULL,
  event_master_id int(11) DEFAULT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (id),
  KEY event_master_id (event_master_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE ed_all_lifestyle_smokings_revs (
  id int(11) NOT NULL,
  smoking_history varchar(50) DEFAULT NULL,
  smoking_status varchar(50) DEFAULT NULL,
  pack_years int(11) DEFAULT NULL,
  product_used varchar(50) DEFAULT NULL,
  years_quit_smoking int(11) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  modified_by int(10) unsigned NOT NULL,
  event_master_id int(11) DEFAULT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (version_id),
  KEY event_master_id (event_master_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE ed_all_protocol_followups (
  id int(11) NOT NULL AUTO_INCREMENT,
  title varchar(50) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  modified_by int(10) unsigned NOT NULL,
  event_master_id int(11) DEFAULT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (id),
  KEY event_master_id (event_master_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE ed_all_protocol_followups_revs (
  id int(11) NOT NULL,
  title varchar(50) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  modified_by int(10) unsigned NOT NULL,
  event_master_id int(11) DEFAULT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (version_id),
  KEY event_master_id (event_master_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE ed_all_study_researches (
  id int(11) NOT NULL AUTO_INCREMENT,
  field_one varchar(50) DEFAULT NULL,
  field_two varchar(50) DEFAULT NULL,
  field_three varchar(50) DEFAULT NULL,
  event_master_id int(11) DEFAULT NULL,
  file_path varchar(255) NOT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  modified_by int(10) unsigned NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (id),
  KEY event_master_id (event_master_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE ed_all_study_researches_revs (
  id int(11) NOT NULL,
  field_one varchar(50) DEFAULT NULL,
  field_two varchar(50) DEFAULT NULL,
  field_three varchar(50) DEFAULT NULL,
  event_master_id int(11) DEFAULT NULL,
  file_path varchar(255) NOT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  modified_by int(10) unsigned NOT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (version_id),
  KEY event_master_id (event_master_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE ed_breast_lab_pathologies (
  id int(11) NOT NULL AUTO_INCREMENT,
  path_number varchar(50) DEFAULT NULL,
  report_type varchar(50) DEFAULT NULL,
  facility varchar(50) DEFAULT NULL,
  vascular_lymph_invasion varchar(50) DEFAULT NULL,
  extra_nodal_invasion varchar(50) DEFAULT NULL,
  blood_lymph varchar(50) DEFAULT NULL,
  tumour_type varchar(50) DEFAULT NULL,
  grade varchar(50) DEFAULT NULL,
  multifocal varchar(50) DEFAULT NULL,
  preneoplastic_changes varchar(50) DEFAULT NULL,
  spread_skin_nipple varchar(50) DEFAULT NULL,
  level_nodal_involvement varchar(50) DEFAULT NULL,
  frozen_section varchar(50) DEFAULT NULL,
  er_assay_ligand varchar(50) DEFAULT NULL,
  pr_assay_ligand varchar(50) DEFAULT NULL,
  progesterone varchar(50) DEFAULT NULL,
  estrogen varchar(50) DEFAULT NULL,
  number_resected varchar(50) DEFAULT NULL,
  number_positive varchar(50) DEFAULT NULL,
  nodal_status varchar(45) DEFAULT NULL,
  resection_margins varchar(50) DEFAULT NULL,
  tumour_size varchar(50) DEFAULT NULL,
  tumour_total_size varchar(45) DEFAULT NULL,
  sentinel_only varchar(50) DEFAULT NULL,
  in_situ_type varchar(50) DEFAULT NULL,
  her2_grade varchar(50) DEFAULT NULL,
  her2_method varchar(50) DEFAULT NULL,
  mb_collectionid varchar(45) DEFAULT NULL,
  created datetime DEFAULT NULL,
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  event_master_id int(11) DEFAULT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (id),
  KEY event_master_id (event_master_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE ed_breast_lab_pathologies_revs (
  id int(11) NOT NULL,
  path_number varchar(50) DEFAULT NULL,
  report_type varchar(50) DEFAULT NULL,
  facility varchar(50) DEFAULT NULL,
  vascular_lymph_invasion varchar(50) DEFAULT NULL,
  extra_nodal_invasion varchar(50) DEFAULT NULL,
  blood_lymph varchar(50) DEFAULT NULL,
  tumour_type varchar(50) DEFAULT NULL,
  grade varchar(50) DEFAULT NULL,
  multifocal varchar(50) DEFAULT NULL,
  preneoplastic_changes varchar(50) DEFAULT NULL,
  spread_skin_nipple varchar(50) DEFAULT NULL,
  level_nodal_involvement varchar(50) DEFAULT NULL,
  frozen_section varchar(50) DEFAULT NULL,
  er_assay_ligand varchar(50) DEFAULT NULL,
  pr_assay_ligand varchar(50) DEFAULT NULL,
  progesterone varchar(50) DEFAULT NULL,
  estrogen varchar(50) DEFAULT NULL,
  number_resected varchar(50) DEFAULT NULL,
  number_positive varchar(50) DEFAULT NULL,
  nodal_status varchar(45) DEFAULT NULL,
  resection_margins varchar(50) DEFAULT NULL,
  tumour_size varchar(50) DEFAULT NULL,
  tumour_total_size varchar(45) DEFAULT NULL,
  sentinel_only varchar(50) DEFAULT NULL,
  in_situ_type varchar(50) DEFAULT NULL,
  her2_grade varchar(50) DEFAULT NULL,
  her2_method varchar(50) DEFAULT NULL,
  mb_collectionid varchar(45) DEFAULT NULL,
  created datetime DEFAULT NULL,
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  event_master_id int(11) DEFAULT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE ed_breast_screening_mammograms (
  id int(11) NOT NULL AUTO_INCREMENT,
  result varchar(50) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  modified_by int(10) unsigned NOT NULL,
  event_master_id int(11) DEFAULT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (id),
  KEY event_master_id (event_master_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE ed_breast_screening_mammograms_revs (
  id int(11) NOT NULL,
  result varchar(50) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  modified_by int(10) unsigned NOT NULL,
  event_master_id int(11) DEFAULT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (version_id),
  KEY event_master_id (event_master_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE event_controls (
  id int(11) NOT NULL AUTO_INCREMENT,
  disease_site varchar(50) NOT NULL DEFAULT '',
  event_group varchar(50) NOT NULL DEFAULT '',
  event_type varchar(50) NOT NULL DEFAULT '',
  flag_active tinyint(1) NOT NULL DEFAULT '1',
  form_alias varchar(255) NOT NULL,
  detail_tablename varchar(255) NOT NULL,
  display_order int(11) NOT NULL DEFAULT '0',
  databrowser_label varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (id)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=35 ;



CREATE TABLE event_masters (
  id int(11) NOT NULL AUTO_INCREMENT,
  event_control_id int(11) NOT NULL DEFAULT '0',
  disease_site varchar(255) NOT NULL DEFAULT '',
  event_group varchar(50) NOT NULL DEFAULT '',
  event_type varchar(50) NOT NULL DEFAULT '',
  event_status varchar(50) DEFAULT NULL,
  event_summary text,
  event_date date DEFAULT NULL,
  information_source varchar(255) DEFAULT NULL,
  urgency varchar(50) DEFAULT NULL,
  date_required date DEFAULT NULL,
  date_requested date DEFAULT NULL,
  reference_number int(11) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  modified_by int(10) unsigned NOT NULL,
  participant_id int(11) DEFAULT NULL,
  diagnosis_master_id int(11) DEFAULT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (id),
  KEY participant_id (participant_id),
  KEY diagnosis_id (diagnosis_master_id),
  KEY event_control_id (event_control_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE event_masters_revs (
  id int(11) NOT NULL,
  event_control_id int(11) NOT NULL DEFAULT '0',
  disease_site varchar(255) NOT NULL DEFAULT '',
  event_group varchar(50) NOT NULL DEFAULT '',
  event_type varchar(50) NOT NULL DEFAULT '',
  event_status varchar(50) DEFAULT NULL,
  event_summary text,
  event_date date DEFAULT NULL,
  information_source varchar(255) DEFAULT NULL,
  urgency varchar(50) DEFAULT NULL,
  date_required date DEFAULT NULL,
  date_requested date DEFAULT NULL,
  reference_number int(11) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  modified_by int(10) unsigned NOT NULL,
  participant_id int(11) DEFAULT NULL,
  diagnosis_master_id int(11) DEFAULT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (version_id),
  KEY participant_id (participant_id),
  KEY diagnosis_id (diagnosis_master_id),
  KEY event_control_id (event_control_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE external_links (
  id int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  link text,
  PRIMARY KEY (id),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=2 ;



CREATE TABLE family_histories (
  id int(11) NOT NULL AUTO_INCREMENT,
  relation varchar(50) DEFAULT NULL,
  family_domain varchar(50) DEFAULT NULL,
  primary_icd10_code varchar(10) DEFAULT NULL,
  previous_primary_code varchar(10) DEFAULT NULL,
  previous_primary_code_system varchar(50) DEFAULT NULL,
  age_at_dx smallint(6) DEFAULT NULL,
  age_at_dx_accuracy varchar(100) DEFAULT NULL,
  participant_id int(11) DEFAULT NULL,
  created datetime DEFAULT NULL,
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (id),
  KEY participant_id (participant_id),
  KEY FK_family_histories_icd10_code (primary_icd10_code)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE family_histories_revs (
  id int(11) NOT NULL,
  relation varchar(50) DEFAULT NULL,
  family_domain varchar(50) DEFAULT NULL,
  primary_icd10_code varchar(10) DEFAULT NULL,
  previous_primary_code varchar(10) DEFAULT NULL,
  previous_primary_code_system varchar(50) DEFAULT NULL,
  age_at_dx smallint(6) DEFAULT NULL,
  age_at_dx_accuracy varchar(100) DEFAULT NULL,
  participant_id int(11) DEFAULT NULL,
  created datetime DEFAULT NULL,
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE groups (
  id int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  bank_id int(11) DEFAULT NULL,
  created datetime DEFAULT NULL,
  modified datetime DEFAULT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY `name` (`name`),
  KEY bank_id (bank_id)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=4 ;



CREATE TABLE i18n (
  id varchar(255) NOT NULL,
  page_id varchar(100) NOT NULL DEFAULT '',
  en text NOT NULL,
  fr text NOT NULL,
  PRIMARY KEY (id,page_id),
  KEY id (id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



CREATE TABLE key_increments (
  key_name varchar(50) NOT NULL,
  key_value int(11) NOT NULL,
  PRIMARY KEY (key_name)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



CREATE TABLE langs (
  id varchar(100) NOT NULL DEFAULT '',
  `name` varchar(100) NOT NULL DEFAULT '',
  meta varchar(100) NOT NULL DEFAULT '',
  error_text varchar(100) NOT NULL DEFAULT '',
  encoding varchar(100) NOT NULL DEFAULT '',
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



CREATE TABLE materials (
  id int(11) NOT NULL AUTO_INCREMENT,
  item_name varchar(50) NOT NULL,
  item_type varchar(50) DEFAULT NULL,
  description varchar(255) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  modified_by int(10) unsigned NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE materials_revs (
  id int(11) NOT NULL,
  item_name varchar(50) NOT NULL,
  item_type varchar(50) DEFAULT NULL,
  description varchar(255) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  modified_by int(10) unsigned NOT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE menus (
  id varchar(255) NOT NULL DEFAULT '',
  parent_id varchar(255) DEFAULT NULL,
  is_root int(11) NOT NULL DEFAULT '0',
  display_order int(11) NOT NULL DEFAULT '0',
  language_title text NOT NULL,
  language_description text,
  use_link varchar(255) NOT NULL DEFAULT '',
  use_params varchar(255) NOT NULL,
  use_summary varchar(255) NOT NULL,
  flag_active tinyint(1) NOT NULL DEFAULT '1',
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  modified_by int(10) unsigned NOT NULL,
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



CREATE TABLE misc_identifiers (
  id int(11) NOT NULL AUTO_INCREMENT,
  identifier_value varchar(40) DEFAULT NULL,
  misc_identifier_control_id int(11) NOT NULL DEFAULT '0',
  identifier_name varchar(50) DEFAULT NULL,
  identifier_abrv varchar(20) DEFAULT NULL,
  effective_date date DEFAULT NULL,
  expiry_date date DEFAULT NULL,
  notes varchar(100) DEFAULT NULL,
  participant_id int(11) DEFAULT NULL,
  created datetime DEFAULT NULL,
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (id),
  KEY participant_id (participant_id),
  KEY FK_misc_identifiers_misc_identifier_controls (misc_identifier_control_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE misc_identifiers_revs (
  id int(11) NOT NULL,
  identifier_value varchar(40) DEFAULT NULL,
  misc_identifier_control_id int(11) NOT NULL DEFAULT '0',
  identifier_name varchar(50) DEFAULT NULL,
  identifier_abrv varchar(20) DEFAULT NULL,
  effective_date date DEFAULT NULL,
  expiry_date date DEFAULT NULL,
  notes varchar(100) DEFAULT NULL,
  participant_id int(11) DEFAULT NULL,
  created datetime DEFAULT NULL,
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE misc_identifier_controls (
  id int(11) NOT NULL AUTO_INCREMENT,
  misc_identifier_name varchar(50) NOT NULL DEFAULT '',
  misc_identifier_name_abbrev varchar(50) NOT NULL DEFAULT '',
  flag_active tinyint(1) NOT NULL DEFAULT '1',
  display_order int(11) NOT NULL DEFAULT '0',
  autoincrement_name varchar(50) DEFAULT NULL,
  misc_identifier_format varchar(50) DEFAULT NULL,
  flag_once_per_participant tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (id),
  UNIQUE KEY unique_misc_identifier_name (misc_identifier_name)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE missing_translations (
  id varchar(255) NOT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY id (id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



CREATE TABLE orders (
  id int(11) NOT NULL AUTO_INCREMENT,
  order_number varchar(255) NOT NULL,
  short_title varchar(45) DEFAULT NULL,
  description varchar(255) DEFAULT NULL,
  date_order_placed date DEFAULT NULL,
  date_order_completed date DEFAULT NULL,
  processing_status varchar(45) DEFAULT NULL,
  comments varchar(255) DEFAULT NULL,
  created datetime DEFAULT NULL,
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  study_summary_id int(11) DEFAULT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (id),
  KEY order_number (order_number),
  KEY FK_orders_study_summaries (study_summary_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE orders_revs (
  id int(11) NOT NULL,
  order_number varchar(255) NOT NULL,
  short_title varchar(45) DEFAULT NULL,
  description varchar(255) DEFAULT NULL,
  date_order_placed date DEFAULT NULL,
  date_order_completed date DEFAULT NULL,
  processing_status varchar(45) DEFAULT NULL,
  comments varchar(255) DEFAULT NULL,
  created datetime DEFAULT NULL,
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  study_summary_id int(11) DEFAULT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE order_items (
  id int(11) NOT NULL AUTO_INCREMENT,
  date_added date DEFAULT NULL,
  added_by varchar(255) DEFAULT NULL,
  `status` varchar(255) DEFAULT NULL,
  created datetime DEFAULT NULL,
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  order_line_id int(11) DEFAULT NULL,
  shipment_id int(11) DEFAULT NULL,
  aliquot_master_id int(11) DEFAULT NULL,
  aliquot_use_id int(11) DEFAULT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (id),
  KEY FK_order_items_order_lines (order_line_id),
  KEY FK_order_items_shipments (shipment_id),
  KEY FK_order_items_aliquot_masters (aliquot_master_id),
  KEY FK_order_items_aliquot_uses (aliquot_use_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE order_items_revs (
  id int(11) NOT NULL,
  date_added date DEFAULT NULL,
  added_by varchar(255) DEFAULT NULL,
  `status` varchar(255) DEFAULT NULL,
  created datetime DEFAULT NULL,
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  order_line_id int(11) DEFAULT NULL,
  shipment_id int(11) DEFAULT NULL,
  aliquot_master_id int(11) DEFAULT NULL,
  aliquot_use_id int(11) DEFAULT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE order_lines (
  id int(11) NOT NULL AUTO_INCREMENT,
  quantity_ordered varchar(30) DEFAULT NULL,
  min_quantity_ordered varchar(30) DEFAULT NULL,
  quantity_unit varchar(10) DEFAULT NULL,
  date_required date DEFAULT NULL,
  `status` varchar(255) DEFAULT NULL,
  created datetime DEFAULT NULL,
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  product_code varchar(50) DEFAULT NULL,
  sample_control_id int(11) DEFAULT NULL,
  aliquot_control_id int(11) DEFAULT NULL,
  sample_aliquot_precision varchar(30) DEFAULT NULL,
  order_id int(11) NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (id),
  KEY FK_order_lines_orders (order_id),
  KEY FK_order_lines_sample_controls (sample_control_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE order_lines_revs (
  id int(11) NOT NULL,
  quantity_ordered varchar(30) DEFAULT NULL,
  min_quantity_ordered varchar(30) DEFAULT NULL,
  quantity_unit varchar(10) DEFAULT NULL,
  date_required date DEFAULT NULL,
  `status` varchar(255) DEFAULT NULL,
  created datetime DEFAULT NULL,
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  product_code varchar(50) DEFAULT NULL,
  sample_control_id int(11) DEFAULT NULL,
  aliquot_control_id int(11) DEFAULT NULL,
  sample_aliquot_precision varchar(30) DEFAULT NULL,
  order_id int(11) NOT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE pages (
  id varchar(100) NOT NULL DEFAULT '',
  error_flag tinyint(4) NOT NULL DEFAULT '0',
  language_title varchar(255) NOT NULL DEFAULT '',
  language_body text NOT NULL,
  use_link varchar(255) NOT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  modified_by int(10) unsigned NOT NULL,
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



CREATE TABLE parent_to_derivative_sample_controls (
  id int(11) NOT NULL AUTO_INCREMENT,
  parent_sample_control_id int(11) DEFAULT NULL,
  derivative_sample_control_id int(11) DEFAULT NULL,
  flag_active tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (id),
  UNIQUE KEY parent_to_derivative_sample (parent_sample_control_id,derivative_sample_control_id),
  KEY FK_parent_to_derivative_sample_controls_derivative (derivative_sample_control_id)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=152 ;



CREATE TABLE participants (
  id int(11) NOT NULL AUTO_INCREMENT,
  title varchar(10) DEFAULT NULL,
  first_name varchar(20) DEFAULT NULL,
  middle_name varchar(50) DEFAULT NULL,
  last_name varchar(20) DEFAULT NULL,
  date_of_birth date DEFAULT NULL,
  dob_date_accuracy varchar(50) DEFAULT NULL,
  marital_status varchar(50) DEFAULT NULL,
  language_preferred varchar(30) DEFAULT NULL,
  sex varchar(20) DEFAULT NULL,
  race varchar(50) DEFAULT NULL,
  vital_status varchar(50) DEFAULT NULL,
  notes text,
  date_of_death date DEFAULT NULL,
  dod_date_accuracy varchar(50) DEFAULT NULL,
  cod_icd10_code varchar(50) DEFAULT NULL,
  secondary_cod_icd10_code varchar(50) DEFAULT NULL,
  cod_confirmation_source varchar(50) DEFAULT NULL,
  participant_identifier varchar(50) DEFAULT NULL,
  last_chart_checked_date date DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  modified_by int(10) unsigned NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY unique_participant_identifier (participant_identifier),
  KEY participant_identifier (participant_identifier),
  KEY FK_participants_icd10_code (cod_icd10_code),
  KEY FK_participants_icd10_code_2 (secondary_cod_icd10_code)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE participants_revs (
  id int(11) NOT NULL,
  title varchar(10) DEFAULT NULL,
  first_name varchar(20) DEFAULT NULL,
  middle_name varchar(50) DEFAULT NULL,
  last_name varchar(20) DEFAULT NULL,
  date_of_birth date DEFAULT NULL,
  dob_date_accuracy varchar(50) DEFAULT NULL,
  marital_status varchar(50) DEFAULT NULL,
  language_preferred varchar(30) DEFAULT NULL,
  sex varchar(20) DEFAULT NULL,
  race varchar(50) DEFAULT NULL,
  vital_status varchar(50) DEFAULT NULL,
  notes text,
  date_of_death date DEFAULT NULL,
  dod_date_accuracy varchar(50) DEFAULT NULL,
  cod_icd10_code varchar(50) DEFAULT NULL,
  secondary_cod_icd10_code varchar(50) DEFAULT NULL,
  cod_confirmation_source varchar(50) DEFAULT NULL,
  participant_identifier varchar(50) DEFAULT NULL,
  last_chart_checked_date date DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  modified_by int(10) unsigned NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE participant_contacts (
  id int(11) NOT NULL AUTO_INCREMENT,
  contact_name varchar(50) NOT NULL DEFAULT '',
  contact_type varchar(50) NOT NULL DEFAULT '',
  other_contact_type varchar(100) DEFAULT NULL,
  effective_date date DEFAULT NULL,
  expiry_date date DEFAULT NULL,
  notes text,
  street varchar(50) DEFAULT NULL,
  locality varchar(50) NOT NULL DEFAULT '',
  region varchar(50) NOT NULL DEFAULT '',
  country varchar(50) NOT NULL DEFAULT '',
  mail_code varchar(10) NOT NULL DEFAULT '',
  phone varchar(15) NOT NULL DEFAULT '',
  phone_type varchar(15) NOT NULL DEFAULT '',
  phone_secondary varchar(15) NOT NULL DEFAULT '',
  phone_secondary_type varchar(15) NOT NULL DEFAULT '',
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  modified_by int(10) unsigned NOT NULL,
  participant_id int(11) DEFAULT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (id),
  KEY participant_id (participant_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE participant_contacts_revs (
  id int(11) NOT NULL,
  contact_name varchar(50) NOT NULL DEFAULT '',
  contact_type varchar(50) NOT NULL DEFAULT '',
  other_contact_type varchar(100) DEFAULT NULL,
  effective_date date DEFAULT NULL,
  expiry_date date DEFAULT NULL,
  notes text,
  street varchar(50) DEFAULT NULL,
  locality varchar(50) NOT NULL DEFAULT '',
  region varchar(50) NOT NULL DEFAULT '',
  country varchar(50) NOT NULL DEFAULT '',
  mail_code varchar(10) NOT NULL DEFAULT '',
  phone varchar(15) NOT NULL DEFAULT '',
  phone_type varchar(15) NOT NULL DEFAULT '',
  phone_secondary varchar(15) NOT NULL DEFAULT '',
  phone_secondary_type varchar(15) NOT NULL DEFAULT '',
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  modified_by int(10) unsigned NOT NULL,
  participant_id int(11) DEFAULT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE participant_messages (
  id int(11) NOT NULL AUTO_INCREMENT,
  date_requested date DEFAULT NULL,
  author varchar(50) DEFAULT NULL,
  message_type varchar(20) DEFAULT NULL,
  title varchar(50) DEFAULT NULL,
  description text,
  due_date date DEFAULT NULL,
  expiry_date date DEFAULT NULL,
  participant_id int(11) DEFAULT NULL,
  created datetime DEFAULT NULL,
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (id),
  KEY participant_id (participant_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE participant_messages_revs (
  id int(11) NOT NULL,
  date_requested date DEFAULT NULL,
  author varchar(50) DEFAULT NULL,
  message_type varchar(20) DEFAULT NULL,
  title varchar(50) DEFAULT NULL,
  description text,
  due_date date DEFAULT NULL,
  expiry_date date DEFAULT NULL,
  participant_id int(11) DEFAULT NULL,
  created datetime DEFAULT NULL,
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE pd_chemos (
  id int(11) NOT NULL AUTO_INCREMENT,
  created datetime DEFAULT NULL,
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  protocol_master_id int(11) DEFAULT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (id),
  KEY FK_pd_chemos_protocol_masters (protocol_master_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE pd_chemos_revs (
  id int(11) NOT NULL,
  created datetime DEFAULT NULL,
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  protocol_master_id int(11) DEFAULT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE pd_surgeries (
  id int(11) NOT NULL AUTO_INCREMENT,
  created datetime DEFAULT NULL,
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  protocol_master_id int(11) DEFAULT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (id),
  KEY FK_pd_chemos_protocol_masters (protocol_master_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE pd_surgeries_revs (
  id int(11) NOT NULL,
  created datetime DEFAULT NULL,
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  protocol_master_id int(11) DEFAULT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE pe_chemos (
  id int(11) NOT NULL AUTO_INCREMENT,
  method varchar(50) DEFAULT NULL,
  dose varchar(50) DEFAULT NULL,
  frequency varchar(50) DEFAULT NULL,
  created datetime DEFAULT NULL,
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  protocol_master_id int(11) DEFAULT NULL,
  drug_id int(11) DEFAULT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (id),
  KEY FK_pe_chemos_protocol_masters (protocol_master_id),
  KEY FK_pe_chemos_drugs (drug_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE pe_chemos_revs (
  id int(11) NOT NULL,
  method varchar(50) DEFAULT NULL,
  dose varchar(50) DEFAULT NULL,
  frequency varchar(50) DEFAULT NULL,
  created datetime DEFAULT NULL,
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  protocol_master_id int(11) DEFAULT NULL,
  drug_id int(11) DEFAULT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE protocol_controls (
  id int(11) NOT NULL AUTO_INCREMENT,
  tumour_group varchar(50) DEFAULT NULL,
  `type` varchar(50) DEFAULT NULL,
  detail_tablename varchar(255) NOT NULL,
  form_alias varchar(255) NOT NULL,
  extend_tablename varchar(255) DEFAULT NULL,
  extend_form_alias varchar(255) DEFAULT NULL,
  created datetime DEFAULT NULL,
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  flag_active tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (id)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=3 ;



CREATE TABLE protocol_masters (
  id int(11) NOT NULL AUTO_INCREMENT,
  protocol_control_id int(11) NOT NULL DEFAULT '0',
  `name` varchar(255) DEFAULT NULL,
  notes text,
  `code` varchar(50) DEFAULT NULL,
  arm varchar(50) DEFAULT NULL,
  tumour_group varchar(50) DEFAULT NULL,
  `type` varchar(50) NOT NULL DEFAULT '',
  `status` varchar(50) DEFAULT NULL,
  expiry date DEFAULT NULL,
  activated date DEFAULT NULL,
  created datetime DEFAULT NULL,
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  form_id int(11) DEFAULT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE protocol_masters_revs (
  id int(11) NOT NULL,
  protocol_control_id int(11) NOT NULL DEFAULT '0',
  `name` varchar(255) DEFAULT NULL,
  notes text,
  `code` varchar(50) DEFAULT NULL,
  arm varchar(50) DEFAULT NULL,
  tumour_group varchar(50) DEFAULT NULL,
  `type` varchar(50) NOT NULL DEFAULT '',
  `status` varchar(50) DEFAULT NULL,
  expiry date DEFAULT NULL,
  activated date DEFAULT NULL,
  created datetime DEFAULT NULL,
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  form_id int(11) DEFAULT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE providers (
  id int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(55) NOT NULL,
  `type` varchar(55) NOT NULL,
  date_effective datetime DEFAULT NULL,
  date_expiry datetime DEFAULT NULL,
  active varchar(55) NOT NULL DEFAULT 'yes',
  description text,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  modified_by int(10) unsigned NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE providers_revs (
  id int(11) NOT NULL,
  `name` varchar(55) NOT NULL,
  `type` varchar(55) NOT NULL,
  date_effective datetime DEFAULT NULL,
  date_expiry datetime DEFAULT NULL,
  active varchar(55) NOT NULL DEFAULT 'yes',
  description text,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  modified_by int(10) unsigned NOT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE quality_ctrls (
  id int(11) NOT NULL AUTO_INCREMENT,
  qc_code varchar(20) DEFAULT NULL,
  sample_master_id int(11) DEFAULT NULL,
  `type` varchar(30) DEFAULT NULL,
  tool varchar(30) DEFAULT NULL,
  run_id varchar(30) DEFAULT NULL,
  run_by varchar(50) DEFAULT NULL,
  `date` date DEFAULT NULL,
  score varchar(30) DEFAULT NULL,
  unit varchar(30) DEFAULT NULL,
  conclusion varchar(30) DEFAULT NULL,
  notes text,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY unique_qc_code (qc_code),
  KEY run_id (run_id),
  KEY FK_quality_ctrls_sample_masters (sample_master_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE quality_ctrls_revs (
  id int(11) NOT NULL,
  qc_code varchar(20) DEFAULT NULL,
  sample_master_id int(11) DEFAULT NULL,
  `type` varchar(30) DEFAULT NULL,
  tool varchar(30) DEFAULT NULL,
  run_id varchar(30) DEFAULT NULL,
  run_by varchar(50) DEFAULT NULL,
  `date` date DEFAULT NULL,
  score varchar(30) DEFAULT NULL,
  unit varchar(30) DEFAULT NULL,
  conclusion varchar(30) DEFAULT NULL,
  notes text,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE quality_ctrl_tested_aliquots (
  id int(11) NOT NULL AUTO_INCREMENT,
  quality_ctrl_id int(11) DEFAULT NULL,
  aliquot_master_id int(11) DEFAULT NULL,
  aliquot_use_id int(11) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (id),
  KEY FK_quality_ctrl_tested_aliquots_aliquot_masters (aliquot_master_id),
  KEY FK_quality_ctrl_tested_aliquots_aliquot_uses (aliquot_use_id),
  KEY FK_quality_ctrl_tested_aliquots_quality_ctrls (quality_ctrl_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE quality_ctrl_tested_aliquots_revs (
  id int(11) NOT NULL,
  quality_ctrl_id int(11) DEFAULT NULL,
  aliquot_master_id int(11) DEFAULT NULL,
  aliquot_use_id int(11) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE realiquotings (
  id int(11) NOT NULL AUTO_INCREMENT,
  parent_aliquot_master_id int(11) DEFAULT NULL,
  child_aliquot_master_id int(11) DEFAULT NULL,
  aliquot_use_id int(11) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (id),
  KEY FK_realiquotings_parent_aliquot_masters (parent_aliquot_master_id),
  KEY FK_realiquotings_child_aliquot_masters (child_aliquot_master_id),
  KEY FK_realiquotings_aliquot_uses (aliquot_use_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE realiquotings_revs (
  id int(11) NOT NULL,
  parent_aliquot_master_id int(11) DEFAULT NULL,
  child_aliquot_master_id int(11) DEFAULT NULL,
  aliquot_use_id int(11) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE realiquoting_controls (
  id int(11) NOT NULL AUTO_INCREMENT,
  parent_sample_to_aliquot_control_id int(11) DEFAULT NULL,
  child_sample_to_aliquot_control_id int(11) DEFAULT NULL,
  flag_active tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (id),
  UNIQUE KEY aliquot_to_aliquot (parent_sample_to_aliquot_control_id,child_sample_to_aliquot_control_id),
  KEY FK_child_realiquoting_control (child_sample_to_aliquot_control_id)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=43 ;



CREATE TABLE reproductive_histories (
  id int(11) NOT NULL AUTO_INCREMENT,
  date_captured date DEFAULT NULL,
  menopause_status varchar(50) DEFAULT NULL,
  menopause_onset_reason varchar(50) DEFAULT NULL,
  age_at_menopause int(11) DEFAULT NULL,
  menopause_age_accuracy varchar(50) DEFAULT NULL,
  age_at_menarche int(11) DEFAULT NULL,
  age_at_menarche_accuracy varchar(50) DEFAULT NULL,
  hrt_years_used int(11) DEFAULT NULL,
  hrt_use varchar(50) DEFAULT NULL,
  hysterectomy_age int(11) DEFAULT NULL,
  hysterectomy_age_accuracy varchar(50) DEFAULT NULL,
  hysterectomy varchar(50) DEFAULT NULL,
  ovary_removed_type varchar(50) DEFAULT NULL,
  gravida int(11) DEFAULT NULL,
  para int(11) DEFAULT NULL,
  age_at_first_parturition int(11) DEFAULT NULL,
  first_parturition_accuracy varchar(50) DEFAULT NULL,
  age_at_last_parturition int(11) DEFAULT NULL,
  last_parturition_accuracy varchar(50) DEFAULT NULL,
  hormonal_contraceptive_use varchar(50) DEFAULT NULL,
  years_on_hormonal_contraceptives int(11) DEFAULT NULL,
  lnmp_date date DEFAULT NULL,
  lnmp_accuracy varchar(50) DEFAULT NULL,
  participant_id int(11) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (id),
  KEY participant_id (participant_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE reproductive_histories_revs (
  id int(11) NOT NULL,
  date_captured date DEFAULT NULL,
  menopause_status varchar(50) DEFAULT NULL,
  menopause_onset_reason varchar(50) DEFAULT NULL,
  age_at_menopause int(11) DEFAULT NULL,
  menopause_age_accuracy varchar(50) DEFAULT NULL,
  age_at_menarche int(11) DEFAULT NULL,
  age_at_menarche_accuracy varchar(50) DEFAULT NULL,
  hrt_years_used int(11) DEFAULT NULL,
  hrt_use varchar(50) DEFAULT NULL,
  hysterectomy_age int(11) DEFAULT NULL,
  hysterectomy_age_accuracy varchar(50) DEFAULT NULL,
  hysterectomy varchar(50) DEFAULT NULL,
  ovary_removed_type varchar(50) DEFAULT NULL,
  gravida int(11) DEFAULT NULL,
  para int(11) DEFAULT NULL,
  age_at_first_parturition int(11) DEFAULT NULL,
  first_parturition_accuracy varchar(50) DEFAULT NULL,
  age_at_last_parturition int(11) DEFAULT NULL,
  last_parturition_accuracy varchar(50) DEFAULT NULL,
  hormonal_contraceptive_use varchar(50) DEFAULT NULL,
  years_on_hormonal_contraceptives int(11) DEFAULT NULL,
  lnmp_date date DEFAULT NULL,
  lnmp_accuracy varchar(50) DEFAULT NULL,
  participant_id int(11) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE rtbforms (
  id smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  frmTitle varchar(200) DEFAULT NULL,
  frmVersion varchar(255) DEFAULT NULL,
  frmCategory varchar(30) DEFAULT NULL,
  frmFileLocation blob,
  frmFileType varchar(40) DEFAULT NULL,
  frmFileViewer blob,
  frmStatus varchar(30) DEFAULT NULL,
  frmCreated date DEFAULT NULL,
  frmGroup varchar(50) DEFAULT NULL,
  created datetime DEFAULT NULL,
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE rtbforms_revs (
  id smallint(5) unsigned NOT NULL,
  frmTitle varchar(200) DEFAULT NULL,
  frmVersion varchar(255) DEFAULT NULL,
  frmCategory varchar(30) DEFAULT NULL,
  frmFileLocation blob,
  frmFileType varchar(40) DEFAULT NULL,
  frmFileViewer blob,
  frmStatus varchar(30) DEFAULT NULL,
  frmCreated date DEFAULT NULL,
  frmGroup varchar(50) DEFAULT NULL,
  created datetime DEFAULT NULL,
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE sample_controls (
  id int(11) NOT NULL AUTO_INCREMENT,
  sample_type varchar(30) NOT NULL DEFAULT '',
  sample_type_code varchar(10) NOT NULL DEFAULT '',
  sample_category enum('specimen','derivative') NOT NULL,
  form_alias varchar(255) NOT NULL,
  detail_tablename varchar(255) NOT NULL,
  display_order int(11) NOT NULL DEFAULT '0',
  databrowser_label varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (id),
  UNIQUE KEY sample_type (sample_type)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=120 ;



CREATE TABLE sample_masters (
  id int(11) NOT NULL AUTO_INCREMENT,
  sample_code varchar(30) NOT NULL DEFAULT '',
  sample_category varchar(30) NOT NULL DEFAULT '',
  sample_control_id int(11) NOT NULL DEFAULT '0',
  sample_type varchar(30) NOT NULL DEFAULT '',
  initial_specimen_sample_id int(11) DEFAULT NULL,
  initial_specimen_sample_type varchar(30) NOT NULL DEFAULT '',
  collection_id int(11) DEFAULT NULL,
  parent_id int(11) DEFAULT NULL,
  sop_master_id int(11) DEFAULT NULL,
  product_code varchar(20) DEFAULT NULL,
  is_problematic varchar(6) DEFAULT NULL,
  notes text,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY unique_sample_code (sample_code),
  KEY sample_code (sample_code),
  KEY FK_sample_masters_collections (collection_id),
  KEY FK_sample_masters_sample_controls (sample_control_id),
  KEY FK_sample_masters_sample_specimens (initial_specimen_sample_id),
  KEY FK_sample_masters_parent (parent_id),
  KEY FK_sample_masters_sops (sop_master_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE sample_masters_revs (
  id int(11) NOT NULL,
  sample_code varchar(30) NOT NULL DEFAULT '',
  sample_category varchar(30) NOT NULL DEFAULT '',
  sample_control_id int(11) NOT NULL DEFAULT '0',
  sample_type varchar(30) NOT NULL DEFAULT '',
  initial_specimen_sample_id int(11) DEFAULT NULL,
  initial_specimen_sample_type varchar(30) NOT NULL DEFAULT '',
  collection_id int(11) DEFAULT NULL,
  parent_id int(11) DEFAULT NULL,
  sop_master_id int(11) DEFAULT NULL,
  product_code varchar(20) DEFAULT NULL,
  is_problematic varchar(6) DEFAULT NULL,
  notes text,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE sample_to_aliquot_controls (
  id int(11) NOT NULL AUTO_INCREMENT,
  sample_control_id int(11) DEFAULT NULL,
  aliquot_control_id int(11) DEFAULT NULL,
  flag_active tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (id),
  UNIQUE KEY sample_to_aliquot (sample_control_id,aliquot_control_id),
  KEY FK_sample_to_aliquot_controls_aliquot_controls (aliquot_control_id)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=56 ;



CREATE TABLE sd_der_amp_rnas (
  id int(11) NOT NULL AUTO_INCREMENT,
  sample_master_id int(11) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (id),
  KEY FK_sd_der_amp_rnas_sample_masters (sample_master_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE sd_der_amp_rnas_revs (
  id int(11) NOT NULL,
  sample_master_id int(11) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE sd_der_ascite_cells (
  id int(11) NOT NULL AUTO_INCREMENT,
  sample_master_id int(11) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (id),
  KEY FK_sd_der_ascite_cells_sample_masters (sample_master_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE sd_der_ascite_cells_revs (
  id int(11) NOT NULL,
  sample_master_id int(11) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE sd_der_ascite_sups (
  id int(11) NOT NULL AUTO_INCREMENT,
  sample_master_id int(11) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (id),
  KEY FK_sd_der_ascite_sups_sample_masters (sample_master_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE sd_der_ascite_sups_revs (
  id int(11) NOT NULL,
  sample_master_id int(11) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE sd_der_blood_cells (
  id int(11) NOT NULL AUTO_INCREMENT,
  sample_master_id int(11) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (id),
  KEY FK_sd_der_blood_cells_sample_masters (sample_master_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE sd_der_blood_cells_revs (
  id int(11) NOT NULL,
  sample_master_id int(11) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE sd_der_b_cells (
  id int(11) NOT NULL AUTO_INCREMENT,
  sample_master_id int(11) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (id),
  KEY FK_sd_der_b_cells_sample_masters (sample_master_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE sd_der_b_cells_revs (
  id int(11) NOT NULL,
  sample_master_id int(11) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE sd_der_cdnas (
  id int(11) NOT NULL AUTO_INCREMENT,
  sample_master_id int(11) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (id),
  KEY FK_sd_der_cdnas_sample_masters (sample_master_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE sd_der_cdnas_revs (
  id int(11) NOT NULL,
  sample_master_id int(11) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE sd_der_cell_cultures (
  id int(11) NOT NULL AUTO_INCREMENT,
  sample_master_id int(11) DEFAULT NULL,
  culture_status varchar(30) DEFAULT NULL,
  culture_status_reason varchar(30) DEFAULT NULL,
  cell_passage_number int(6) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (id),
  KEY FK_sd_der_cell_cultures_sample_masters (sample_master_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE sd_der_cell_cultures_revs (
  id int(11) NOT NULL,
  sample_master_id int(11) DEFAULT NULL,
  culture_status varchar(30) DEFAULT NULL,
  culture_status_reason varchar(30) DEFAULT NULL,
  cell_passage_number int(6) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE sd_der_cell_lysates (
  id int(11) NOT NULL AUTO_INCREMENT,
  sample_master_id int(11) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE sd_der_cell_lysates_revs (
  id int(11) NOT NULL,
  sample_master_id int(11) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE sd_der_cystic_fl_cells (
  id int(11) NOT NULL AUTO_INCREMENT,
  sample_master_id int(11) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (id),
  KEY FK_sd_der_cystic_fl_cells_sample_masters (sample_master_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE sd_der_cystic_fl_cells_revs (
  id int(11) NOT NULL,
  sample_master_id int(11) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE sd_der_cystic_fl_sups (
  id int(11) NOT NULL AUTO_INCREMENT,
  sample_master_id int(11) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (id),
  KEY FK_sd_der_cystic_fl_sups_sample_masters (sample_master_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE sd_der_cystic_fl_sups_revs (
  id int(11) NOT NULL,
  sample_master_id int(11) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE sd_der_dnas (
  id int(11) NOT NULL AUTO_INCREMENT,
  sample_master_id int(11) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (id),
  KEY FK_sd_der_dnas_sample_masters (sample_master_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE sd_der_dnas_revs (
  id int(11) NOT NULL,
  sample_master_id int(11) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE sd_der_pbmcs (
  id int(11) NOT NULL AUTO_INCREMENT,
  sample_master_id int(11) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (id),
  KEY FK_sd_der_pbmcs_sample_masters (sample_master_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE sd_der_pbmcs_revs (
  id int(11) NOT NULL,
  sample_master_id int(11) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE sd_der_pericardial_fl_cells (
  id int(11) NOT NULL AUTO_INCREMENT,
  sample_master_id int(11) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (id),
  KEY FK_sd_der_pericardial_fl_cells_sample_masters (sample_master_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE sd_der_pericardial_fl_cells_revs (
  id int(11) NOT NULL,
  sample_master_id int(11) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE sd_der_pericardial_fl_sups (
  id int(11) NOT NULL AUTO_INCREMENT,
  sample_master_id int(11) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (id),
  KEY FK_sd_der_pericardial_fl_sups_sample_masters (sample_master_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE sd_der_pericardial_fl_sups_revs (
  id int(11) NOT NULL,
  sample_master_id int(11) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE sd_der_plasmas (
  id int(11) NOT NULL AUTO_INCREMENT,
  sample_master_id int(11) DEFAULT NULL,
  hemolysis_signs varchar(10) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (id),
  KEY FK_sd_der_plasmas_sample_masters (sample_master_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE sd_der_plasmas_revs (
  id int(11) NOT NULL,
  sample_master_id int(11) DEFAULT NULL,
  hemolysis_signs varchar(10) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE sd_der_pleural_fl_cells (
  id int(11) NOT NULL AUTO_INCREMENT,
  sample_master_id int(11) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (id),
  KEY FK_sd_der_pleural_fl_cells_sample_masters (sample_master_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE sd_der_pleural_fl_cells_revs (
  id int(11) NOT NULL,
  sample_master_id int(11) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE sd_der_pleural_fl_sups (
  id int(11) NOT NULL AUTO_INCREMENT,
  sample_master_id int(11) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (id),
  KEY FK_sd_der_pleural_fl_sups_sample_masters (sample_master_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE sd_der_pleural_fl_sups_revs (
  id int(11) NOT NULL,
  sample_master_id int(11) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE sd_der_proteins (
  id int(11) NOT NULL AUTO_INCREMENT,
  sample_master_id int(11) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (id),
  KEY FK_sd_der_amp_rnas_sample_masters (sample_master_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE sd_der_proteins_revs (
  id int(11) NOT NULL,
  sample_master_id int(11) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE sd_der_pw_cells (
  id int(11) NOT NULL AUTO_INCREMENT,
  sample_master_id int(11) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (id),
  KEY FK_sd_der_pw_cells_sample_masters (sample_master_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE sd_der_pw_cells_revs (
  id int(11) NOT NULL,
  sample_master_id int(11) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE sd_der_pw_sups (
  id int(11) NOT NULL AUTO_INCREMENT,
  sample_master_id int(11) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (id),
  KEY FK_sd_der_pw_sups_sample_masters (sample_master_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE sd_der_pw_sups_revs (
  id int(11) NOT NULL,
  sample_master_id int(11) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE sd_der_rnas (
  id int(11) NOT NULL AUTO_INCREMENT,
  sample_master_id int(11) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (id),
  KEY FK_sd_der_rnas_sample_masters (sample_master_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE sd_der_rnas_revs (
  id int(11) NOT NULL,
  sample_master_id int(11) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE sd_der_serums (
  id int(11) NOT NULL AUTO_INCREMENT,
  sample_master_id int(11) DEFAULT NULL,
  hemolysis_signs varchar(10) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (id),
  KEY FK_sd_der_serums_sample_masters (sample_master_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE sd_der_serums_revs (
  id int(11) NOT NULL,
  sample_master_id int(11) DEFAULT NULL,
  hemolysis_signs varchar(10) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE sd_der_tiss_lysates (
  id int(11) NOT NULL AUTO_INCREMENT,
  sample_master_id int(11) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (id),
  KEY FK_sd_der_tiss_lysates_sample_masters (sample_master_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE sd_der_tiss_lysates_revs (
  id int(11) NOT NULL,
  sample_master_id int(11) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE sd_der_tiss_susps (
  id int(11) NOT NULL AUTO_INCREMENT,
  sample_master_id int(11) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (id),
  KEY FK_sd_der_tiss_susps_sample_masters (sample_master_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE sd_der_tiss_susps_revs (
  id int(11) NOT NULL,
  sample_master_id int(11) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE sd_der_urine_cents (
  id int(11) NOT NULL AUTO_INCREMENT,
  sample_master_id int(11) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (id),
  KEY FK_sd_der_urine_cents_sample_masters (sample_master_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE sd_der_urine_cents_revs (
  id int(11) NOT NULL,
  sample_master_id int(11) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE sd_der_urine_cons (
  id int(11) NOT NULL AUTO_INCREMENT,
  sample_master_id int(11) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (id),
  KEY FK_sd_der_urine_cons_sample_masters (sample_master_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE sd_der_urine_cons_revs (
  id int(11) NOT NULL,
  sample_master_id int(11) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE sd_spe_ascites (
  id int(11) NOT NULL AUTO_INCREMENT,
  sample_master_id int(11) DEFAULT NULL,
  collected_volume decimal(10,5) DEFAULT NULL,
  collected_volume_unit varchar(20) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (id),
  KEY FK_sd_spe_ascites_sample_masters (sample_master_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE sd_spe_ascites_revs (
  id int(11) NOT NULL,
  sample_master_id int(11) DEFAULT NULL,
  collected_volume decimal(10,5) DEFAULT NULL,
  collected_volume_unit varchar(20) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE sd_spe_bloods (
  id int(11) NOT NULL AUTO_INCREMENT,
  sample_master_id int(11) DEFAULT NULL,
  blood_type varchar(30) DEFAULT NULL,
  collected_tube_nbr int(4) DEFAULT NULL,
  collected_volume decimal(10,5) DEFAULT NULL,
  collected_volume_unit varchar(20) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (id),
  KEY FK_sd_spe_bloods_sample_masters (sample_master_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE sd_spe_bloods_revs (
  id int(11) NOT NULL,
  sample_master_id int(11) DEFAULT NULL,
  blood_type varchar(30) DEFAULT NULL,
  collected_tube_nbr int(4) DEFAULT NULL,
  collected_volume decimal(10,5) DEFAULT NULL,
  collected_volume_unit varchar(20) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE sd_spe_cystic_fluids (
  id int(11) NOT NULL AUTO_INCREMENT,
  sample_master_id int(11) DEFAULT NULL,
  collected_volume decimal(10,5) DEFAULT NULL,
  collected_volume_unit varchar(20) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (id),
  KEY FK_sd_spe_cystic_fluids_sample_masters (sample_master_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE sd_spe_cystic_fluids_revs (
  id int(11) NOT NULL,
  sample_master_id int(11) DEFAULT NULL,
  collected_volume decimal(10,5) DEFAULT NULL,
  collected_volume_unit varchar(20) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE sd_spe_pericardial_fluids (
  id int(11) NOT NULL AUTO_INCREMENT,
  sample_master_id int(11) DEFAULT NULL,
  collected_volume decimal(10,5) DEFAULT NULL,
  collected_volume_unit varchar(20) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (id),
  KEY FK_sd_spe_pericardial_fluids_sample_masters (sample_master_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE sd_spe_pericardial_fluids_revs (
  id int(11) NOT NULL,
  sample_master_id int(11) DEFAULT NULL,
  collected_volume decimal(10,5) DEFAULT NULL,
  collected_volume_unit varchar(20) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE sd_spe_peritoneal_washes (
  id int(11) NOT NULL AUTO_INCREMENT,
  sample_master_id int(11) DEFAULT NULL,
  collected_volume decimal(10,5) DEFAULT NULL,
  collected_volume_unit varchar(20) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (id),
  KEY FK_sd_spe_peritoneal_washes_sample_masters (sample_master_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE sd_spe_peritoneal_washes_revs (
  id int(11) NOT NULL,
  sample_master_id int(11) DEFAULT NULL,
  collected_volume decimal(10,5) DEFAULT NULL,
  collected_volume_unit varchar(20) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE sd_spe_pleural_fluids (
  id int(11) NOT NULL AUTO_INCREMENT,
  sample_master_id int(11) DEFAULT NULL,
  collected_volume decimal(10,5) DEFAULT NULL,
  collected_volume_unit varchar(20) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (id),
  KEY FK_sd_spe_pleural_fluids_sample_masters (sample_master_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE sd_spe_pleural_fluids_revs (
  id int(11) NOT NULL,
  sample_master_id int(11) DEFAULT NULL,
  collected_volume decimal(10,5) DEFAULT NULL,
  collected_volume_unit varchar(20) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE sd_spe_tissues (
  id int(11) NOT NULL AUTO_INCREMENT,
  sample_master_id int(11) DEFAULT NULL,
  tissue_source varchar(50) DEFAULT NULL,
  tissue_nature varchar(15) DEFAULT NULL,
  tissue_laterality varchar(10) DEFAULT NULL,
  pathology_reception_datetime datetime DEFAULT NULL,
  tissue_size varchar(20) DEFAULT NULL,
  tissue_size_unit varchar(10) DEFAULT NULL,
  tissue_weight varchar(10) DEFAULT NULL,
  tissue_weight_unit varchar(10) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (id),
  KEY FK_sd_spe_tissues_sample_masters (sample_master_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE sd_spe_tissues_revs (
  id int(11) NOT NULL,
  sample_master_id int(11) DEFAULT NULL,
  tissue_source varchar(50) DEFAULT NULL,
  tissue_nature varchar(15) DEFAULT NULL,
  tissue_laterality varchar(10) DEFAULT NULL,
  pathology_reception_datetime datetime DEFAULT NULL,
  tissue_size varchar(20) DEFAULT NULL,
  tissue_size_unit varchar(10) DEFAULT NULL,
  tissue_weight varchar(10) DEFAULT NULL,
  tissue_weight_unit varchar(10) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE sd_spe_urines (
  id int(11) NOT NULL AUTO_INCREMENT,
  sample_master_id int(11) DEFAULT NULL,
  urine_aspect varchar(30) DEFAULT NULL,
  collected_volume decimal(10,5) DEFAULT NULL,
  collected_volume_unit varchar(20) DEFAULT NULL,
  pellet_signs varchar(10) DEFAULT NULL,
  pellet_volume decimal(10,5) DEFAULT NULL,
  pellet_volume_unit varchar(20) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (id),
  KEY FK_sd_spe_urines_sample_masters (sample_master_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE sd_spe_urines_revs (
  id int(11) NOT NULL,
  sample_master_id int(11) DEFAULT NULL,
  urine_aspect varchar(30) DEFAULT NULL,
  collected_volume decimal(10,5) DEFAULT NULL,
  collected_volume_unit varchar(20) DEFAULT NULL,
  pellet_signs varchar(10) DEFAULT NULL,
  pellet_volume decimal(10,5) DEFAULT NULL,
  pellet_volume_unit varchar(20) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE shelves (
  id int(11) NOT NULL AUTO_INCREMENT,
  storage_id int(11) DEFAULT NULL,
  description varchar(50) NOT NULL DEFAULT '',
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (id),
  KEY storage_id (storage_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE shelves_revs (
  id int(11) NOT NULL,
  storage_id int(11) DEFAULT NULL,
  description varchar(50) NOT NULL DEFAULT '',
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  version_id int(11) NOT NULL,
  version_created datetime NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (version_id),
  KEY storage_id (storage_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



CREATE TABLE shipments (
  id int(11) NOT NULL AUTO_INCREMENT,
  shipment_code varchar(255) NOT NULL DEFAULT 'No Code',
  recipient varchar(60) DEFAULT NULL,
  facility varchar(60) DEFAULT NULL,
  delivery_street_address varchar(255) DEFAULT NULL,
  delivery_city varchar(255) DEFAULT NULL,
  delivery_province varchar(255) DEFAULT NULL,
  delivery_postal_code varchar(255) DEFAULT NULL,
  delivery_country varchar(255) DEFAULT NULL,
  shipping_company varchar(255) DEFAULT NULL,
  shipping_account_nbr varchar(255) DEFAULT NULL,
  datetime_shipped datetime DEFAULT NULL,
  datetime_received datetime DEFAULT NULL,
  shipped_by varchar(255) DEFAULT NULL,
  created datetime DEFAULT NULL,
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  order_id int(11) DEFAULT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (id),
  KEY shipment_code (shipment_code),
  KEY recipient (recipient),
  KEY facility (facility),
  KEY FK_shipments_orders (order_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE shipments_revs (
  id int(11) NOT NULL,
  shipment_code varchar(255) NOT NULL DEFAULT 'No Code',
  recipient varchar(60) DEFAULT NULL,
  facility varchar(60) DEFAULT NULL,
  delivery_street_address varchar(255) DEFAULT NULL,
  delivery_city varchar(255) DEFAULT NULL,
  delivery_province varchar(255) DEFAULT NULL,
  delivery_postal_code varchar(255) DEFAULT NULL,
  delivery_country varchar(255) DEFAULT NULL,
  shipping_company varchar(255) DEFAULT NULL,
  shipping_account_nbr varchar(255) DEFAULT NULL,
  datetime_shipped datetime DEFAULT NULL,
  datetime_received datetime DEFAULT NULL,
  shipped_by varchar(255) DEFAULT NULL,
  created datetime DEFAULT NULL,
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  order_id int(11) DEFAULT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE sidebars (
  id int(11) NOT NULL AUTO_INCREMENT,
  alias varchar(255) NOT NULL DEFAULT '',
  language_title text NOT NULL,
  language_body text NOT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  modified_by int(10) unsigned NOT NULL,
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE sopd_general_alls (
  id int(11) NOT NULL AUTO_INCREMENT,
  `value` varchar(255) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  modified_by int(10) unsigned NOT NULL,
  sop_master_id int(11) DEFAULT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE sopd_general_alls_revs (
  id int(11) NOT NULL,
  `value` varchar(255) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  modified_by int(10) unsigned NOT NULL,
  sop_master_id int(11) DEFAULT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE sopd_inventory_alls (
  id int(11) NOT NULL AUTO_INCREMENT,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  modified_by int(10) unsigned NOT NULL,
  sop_master_id int(11) DEFAULT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE sopd_inventory_alls_revs (
  id int(11) NOT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  modified_by int(10) unsigned NOT NULL,
  sop_master_id int(11) DEFAULT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE sope_general_all (
  id int(11) NOT NULL AUTO_INCREMENT,
  site_specific varchar(50) DEFAULT NULL,
  created datetime DEFAULT NULL,
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  sop_master_id int(11) DEFAULT NULL,
  material_id int(11) DEFAULT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE sope_general_all_revs (
  id int(11) NOT NULL,
  site_specific varchar(50) DEFAULT NULL,
  created datetime DEFAULT NULL,
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  sop_master_id int(11) DEFAULT NULL,
  material_id int(11) DEFAULT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE sope_inventory_all (
  id int(11) NOT NULL AUTO_INCREMENT,
  created datetime DEFAULT NULL,
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  sop_master_id int(11) DEFAULT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE sope_inventory_all_revs (
  id int(11) NOT NULL,
  created datetime DEFAULT NULL,
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  sop_master_id int(11) DEFAULT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE sop_controls (
  id int(11) NOT NULL AUTO_INCREMENT,
  sop_group varchar(50) DEFAULT NULL,
  `type` varchar(50) DEFAULT NULL,
  detail_tablename varchar(255) NOT NULL,
  form_alias varchar(255) NOT NULL,
  extend_tablename varchar(255) NOT NULL,
  extend_form_alias varchar(255) NOT NULL,
  display_order int(11) NOT NULL DEFAULT '0',
  created datetime DEFAULT NULL,
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  PRIMARY KEY (id)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=3 ;



CREATE TABLE sop_masters (
  id int(11) NOT NULL AUTO_INCREMENT,
  sop_control_id int(11) NOT NULL DEFAULT '0',
  title varchar(255) DEFAULT NULL,
  notes text,
  `code` varchar(50) DEFAULT NULL,
  version varchar(50) DEFAULT NULL,
  sop_group varchar(50) DEFAULT NULL,
  `type` varchar(50) NOT NULL,
  `status` varchar(50) DEFAULT NULL,
  expiry_date date DEFAULT NULL,
  activated_date date DEFAULT NULL,
  scope text,
  purpose text,
  created datetime DEFAULT NULL,
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  form_id int(11) DEFAULT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE sop_masters_revs (
  id int(11) NOT NULL,
  sop_control_id int(11) NOT NULL DEFAULT '0',
  title varchar(255) DEFAULT NULL,
  notes text,
  `code` varchar(50) DEFAULT NULL,
  version varchar(50) DEFAULT NULL,
  sop_group varchar(50) DEFAULT NULL,
  `type` varchar(50) NOT NULL,
  `status` varchar(50) DEFAULT NULL,
  expiry_date date DEFAULT NULL,
  activated_date date DEFAULT NULL,
  scope text,
  purpose text,
  created datetime DEFAULT NULL,
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  form_id int(11) DEFAULT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE source_aliquots (
  id int(11) NOT NULL AUTO_INCREMENT,
  sample_master_id int(11) DEFAULT NULL,
  aliquot_master_id int(11) DEFAULT NULL,
  aliquot_use_id int(11) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (id),
  KEY FK_source_aliquots_aliquot_masters (aliquot_master_id),
  KEY FK_source_aliquots_aliquot_uses (aliquot_use_id),
  KEY FK_source_aliquots_sample_masters (sample_master_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE source_aliquots_revs (
  id int(11) NOT NULL,
  sample_master_id int(11) DEFAULT NULL,
  aliquot_master_id int(11) DEFAULT NULL,
  aliquot_use_id int(11) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE specimen_details (
  id int(11) NOT NULL AUTO_INCREMENT,
  sample_master_id int(11) DEFAULT NULL,
  supplier_dept varchar(40) DEFAULT NULL,
  reception_by varchar(50) DEFAULT NULL,
  reception_datetime datetime DEFAULT NULL,
  reception_datetime_accuracy varchar(4) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (id),
  KEY FK_specimen_details_sample_masters (sample_master_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE specimen_details_revs (
  id int(11) NOT NULL,
  sample_master_id int(11) DEFAULT NULL,
  supplier_dept varchar(40) DEFAULT NULL,
  reception_by varchar(50) DEFAULT NULL,
  reception_datetime datetime DEFAULT NULL,
  reception_datetime_accuracy varchar(4) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE specimen_review_controls (
  id int(11) NOT NULL AUTO_INCREMENT,
  sample_control_id int(11) NOT NULL,
  aliquot_review_control_id int(11) DEFAULT NULL,
  specimen_sample_type varchar(30) NOT NULL,
  review_type varchar(100) NOT NULL,
  flag_active tinyint(1) NOT NULL DEFAULT '1',
  form_alias varchar(255) NOT NULL,
  detail_tablename varchar(255) NOT NULL,
  databrowser_label varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (id),
  UNIQUE KEY review_type (sample_control_id,specimen_sample_type,review_type),
  KEY FK_specimen_review_controls_specimen_review_controls (aliquot_review_control_id)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=3 ;



CREATE TABLE specimen_review_masters (
  id int(11) NOT NULL AUTO_INCREMENT,
  specimen_review_control_id int(11) NOT NULL DEFAULT '0',
  specimen_sample_type varchar(30) NOT NULL,
  review_type varchar(100) NOT NULL,
  collection_id int(11) DEFAULT NULL,
  sample_master_id int(11) DEFAULT NULL,
  review_code varchar(100) NOT NULL,
  review_date date DEFAULT NULL,
  review_status varchar(20) DEFAULT NULL,
  pathologist varchar(50) DEFAULT NULL,
  notes text,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (id),
  KEY FK_specimen_review_masters_specimen_review_controls (specimen_review_control_id),
  KEY FK_specimen_review_masters_collections (collection_id),
  KEY FK_specimen_review_masters_sample_masters (sample_master_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE specimen_review_masters_revs (
  id int(11) NOT NULL,
  specimen_review_control_id int(11) NOT NULL DEFAULT '0',
  specimen_sample_type varchar(30) NOT NULL,
  review_type varchar(100) NOT NULL,
  collection_id int(11) DEFAULT NULL,
  sample_master_id int(11) DEFAULT NULL,
  review_code varchar(100) NOT NULL,
  review_date date DEFAULT NULL,
  review_status varchar(20) DEFAULT NULL,
  pathologist varchar(50) DEFAULT NULL,
  notes text,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE spr_breast_cancer_types (
  id int(11) NOT NULL AUTO_INCREMENT,
  specimen_review_master_id int(11) DEFAULT NULL,
  `type` varchar(100) DEFAULT NULL,
  other_type varchar(250) DEFAULT NULL,
  tumour_grade_score_tubules decimal(5,1) DEFAULT NULL,
  tumour_grade_score_nuclear decimal(5,1) DEFAULT NULL,
  tumour_grade_score_mitosis decimal(5,1) DEFAULT NULL,
  tumour_grade_score_total decimal(5,1) DEFAULT NULL,
  tumour_grade_category varchar(100) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (id),
  KEY FK_spr_breast_cancer_types_specimen_review_masters (specimen_review_master_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE spr_breast_cancer_types_revs (
  id int(11) NOT NULL,
  specimen_review_master_id int(11) DEFAULT NULL,
  `type` varchar(100) DEFAULT NULL,
  other_type varchar(250) DEFAULT NULL,
  tumour_grade_score_tubules decimal(5,1) DEFAULT NULL,
  tumour_grade_score_nuclear decimal(5,1) DEFAULT NULL,
  tumour_grade_score_mitosis decimal(5,1) DEFAULT NULL,
  tumour_grade_score_total decimal(5,1) DEFAULT NULL,
  tumour_grade_category varchar(100) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE std_boxs (
  id int(11) NOT NULL AUTO_INCREMENT,
  storage_master_id int(11) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (id),
  KEY FK_std_boxs_storage_masters (storage_master_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE std_boxs_revs (
  id int(11) NOT NULL,
  storage_master_id int(11) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE std_cupboards (
  id int(11) NOT NULL AUTO_INCREMENT,
  storage_master_id int(11) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (id),
  KEY FK_std_cupboards_storage_masters (storage_master_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE std_cupboards_revs (
  id int(11) NOT NULL,
  storage_master_id int(11) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE std_freezers (
  id int(11) NOT NULL AUTO_INCREMENT,
  storage_master_id int(11) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (id),
  KEY FK_std_freezers_storage_masters (storage_master_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE std_freezers_revs (
  id int(11) NOT NULL,
  storage_master_id int(11) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE std_fridges (
  id int(11) NOT NULL AUTO_INCREMENT,
  storage_master_id int(11) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (id),
  KEY FK_std_fridges_storage_masters (storage_master_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE std_fridges_revs (
  id int(11) NOT NULL,
  storage_master_id int(11) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE std_incubators (
  id int(11) NOT NULL AUTO_INCREMENT,
  storage_master_id int(11) DEFAULT NULL,
  oxygen_perc varchar(10) DEFAULT NULL,
  carbonic_gaz_perc varchar(10) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (id),
  KEY FK_std_incubators_storage_masters (storage_master_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE std_incubators_revs (
  id int(11) NOT NULL,
  storage_master_id int(11) DEFAULT NULL,
  oxygen_perc varchar(10) DEFAULT NULL,
  carbonic_gaz_perc varchar(10) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE std_nitro_locates (
  id int(11) NOT NULL AUTO_INCREMENT,
  storage_master_id int(11) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (id),
  KEY FK_std_nitro_locates_storage_masters (storage_master_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE std_nitro_locates_revs (
  id int(11) NOT NULL,
  storage_master_id int(11) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE std_racks (
  id int(11) NOT NULL AUTO_INCREMENT,
  storage_master_id int(11) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (id),
  KEY FK_std_racks_storage_masters (storage_master_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE std_racks_revs (
  id int(11) NOT NULL,
  storage_master_id int(11) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE std_rooms (
  id int(11) NOT NULL AUTO_INCREMENT,
  storage_master_id int(11) DEFAULT NULL,
  laboratory varchar(50) DEFAULT NULL,
  floor varchar(20) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (id),
  KEY FK_std_rooms_storage_masters (storage_master_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE std_rooms_revs (
  id int(11) NOT NULL,
  storage_master_id int(11) DEFAULT NULL,
  laboratory varchar(50) DEFAULT NULL,
  floor varchar(20) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE std_shelfs (
  id int(11) NOT NULL AUTO_INCREMENT,
  storage_master_id int(11) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (id),
  KEY FK_std_shelfs_storage_masters (storage_master_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE std_shelfs_revs (
  id int(11) NOT NULL,
  storage_master_id int(11) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE std_tma_blocks (
  id int(11) NOT NULL AUTO_INCREMENT,
  storage_master_id int(11) DEFAULT NULL,
  sop_master_id int(11) DEFAULT NULL,
  product_code varchar(20) DEFAULT NULL,
  creation_datetime datetime DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (id),
  KEY FK_std_tma_blocks_storage_masters (storage_master_id),
  KEY FK_std_tma_blocks_sop_masters (sop_master_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE std_tma_blocks_revs (
  id int(11) NOT NULL,
  storage_master_id int(11) DEFAULT NULL,
  sop_master_id int(11) DEFAULT NULL,
  product_code varchar(20) DEFAULT NULL,
  creation_datetime datetime DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE storage_controls (
  id int(11) NOT NULL AUTO_INCREMENT,
  storage_type varchar(30) NOT NULL DEFAULT '',
  storage_type_code varchar(10) NOT NULL DEFAULT '',
  coord_x_title varchar(30) DEFAULT NULL,
  coord_x_type enum('alphabetical','integer','list') DEFAULT NULL,
  coord_x_size int(4) DEFAULT NULL,
  coord_y_title varchar(30) DEFAULT NULL,
  coord_y_type enum('alphabetical','integer','list') DEFAULT NULL,
  coord_y_size int(4) DEFAULT NULL,
  display_x_size tinyint(3) unsigned NOT NULL DEFAULT '0',
  display_y_size tinyint(3) unsigned NOT NULL DEFAULT '0',
  reverse_x_numbering tinyint(1) NOT NULL DEFAULT '0',
  reverse_y_numbering tinyint(1) NOT NULL DEFAULT '0',
  horizontal_increment tinyint(1) NOT NULL DEFAULT '1',
  set_temperature varchar(7) DEFAULT NULL,
  is_tma_block varchar(5) DEFAULT NULL,
  flag_active tinyint(1) NOT NULL DEFAULT '1',
  form_alias varchar(255) NOT NULL,
  form_alias_for_children_pos varchar(50) DEFAULT NULL,
  detail_tablename varchar(255) NOT NULL,
  databrowser_label varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (id)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=21 ;



CREATE TABLE storage_coordinates (
  id int(11) NOT NULL AUTO_INCREMENT,
  storage_master_id int(11) DEFAULT NULL,
  dimension varchar(4) DEFAULT '',
  coordinate_value varchar(50) DEFAULT '',
  `order` int(4) DEFAULT '0',
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (id),
  KEY FK_storage_coordinates_storage_masters (storage_master_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE storage_coordinates_revs (
  id int(11) NOT NULL,
  storage_master_id int(11) DEFAULT NULL,
  dimension varchar(4) DEFAULT '',
  coordinate_value varchar(50) DEFAULT '',
  `order` int(4) DEFAULT '0',
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE storage_masters (
  id int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(30) NOT NULL DEFAULT '',
  storage_type varchar(30) NOT NULL DEFAULT '',
  storage_control_id int(11) NOT NULL DEFAULT '0',
  parent_id int(11) DEFAULT NULL,
  lft int(10) DEFAULT NULL,
  rght int(10) DEFAULT NULL,
  barcode varchar(60) DEFAULT NULL,
  short_label varchar(10) DEFAULT NULL,
  selection_label varchar(60) DEFAULT '',
  storage_status varchar(20) DEFAULT '',
  parent_storage_coord_x varchar(50) DEFAULT NULL,
  coord_x_order int(3) DEFAULT NULL,
  parent_storage_coord_y varchar(50) DEFAULT NULL,
  coord_y_order int(3) DEFAULT NULL,
  set_temperature varchar(7) DEFAULT NULL,
  temperature decimal(5,2) DEFAULT NULL,
  temp_unit varchar(20) DEFAULT NULL,
  notes text,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY unique_code (`code`),
  KEY `code` (`code`),
  KEY barcode (barcode),
  KEY short_label (short_label),
  KEY selection_label (selection_label),
  KEY FK_storage_masters_storage_controls (storage_control_id),
  KEY FK_storage_masters_parent (parent_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE storage_masters_revs (
  id int(11) NOT NULL,
  `code` varchar(30) NOT NULL DEFAULT '',
  storage_type varchar(30) NOT NULL DEFAULT '',
  storage_control_id int(11) NOT NULL DEFAULT '0',
  parent_id int(11) DEFAULT NULL,
  lft int(10) DEFAULT NULL,
  rght int(10) DEFAULT NULL,
  barcode varchar(60) DEFAULT NULL,
  short_label varchar(10) DEFAULT NULL,
  selection_label varchar(60) DEFAULT '',
  storage_status varchar(20) DEFAULT '',
  parent_storage_coord_x varchar(50) DEFAULT NULL,
  coord_x_order int(3) DEFAULT NULL,
  parent_storage_coord_y varchar(50) DEFAULT NULL,
  coord_y_order int(3) DEFAULT NULL,
  set_temperature varchar(7) DEFAULT NULL,
  temperature decimal(5,2) DEFAULT NULL,
  temp_unit varchar(20) DEFAULT NULL,
  notes text,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE structures (
  id int(11) NOT NULL AUTO_INCREMENT,
  alias varchar(255) NOT NULL,
  description text,
  language_title text NOT NULL,
  language_help text NOT NULL,
  flag_add_columns tinyint(1) NOT NULL DEFAULT '0',
  flag_edit_columns tinyint(1) NOT NULL DEFAULT '0',
  flag_search_columns tinyint(1) NOT NULL DEFAULT '0',
  flag_detail_columns tinyint(1) NOT NULL DEFAULT '0',
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  modified_by int(10) unsigned NOT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY unique_alias (alias)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=247 ;



CREATE TABLE structure_fields (
  id int(11) NOT NULL AUTO_INCREMENT,
  public_identifier varchar(50) NOT NULL,
  `plugin` varchar(150) NOT NULL DEFAULT '',
  model varchar(150) NOT NULL DEFAULT '',
  tablename varchar(150) NOT NULL DEFAULT '',
  field varchar(150) NOT NULL DEFAULT '',
  language_label text NOT NULL,
  language_tag text NOT NULL,
  `type` varchar(255) NOT NULL DEFAULT 'input',
  setting text NOT NULL,
  `default` varchar(255) NOT NULL,
  structure_value_domain int(11) DEFAULT NULL,
  language_help text NOT NULL,
  validation_control varchar(50) NOT NULL DEFAULT 'open',
  value_domain_control varchar(50) NOT NULL DEFAULT 'open',
  field_control varchar(50) NOT NULL DEFAULT 'open',
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  modified_by int(10) unsigned NOT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY unique_fields (field,`type`,model,tablename,structure_value_domain),
  KEY FK_structure_fields_structure_value_domains (structure_value_domain)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=1856 ;



CREATE TABLE structure_formats (
  id int(11) NOT NULL AUTO_INCREMENT,
  structure_id int(11) NOT NULL,
  structure_field_id int(11) NOT NULL,
  display_column int(11) NOT NULL DEFAULT '1',
  display_order int(11) NOT NULL DEFAULT '0',
  language_heading varchar(255) NOT NULL DEFAULT '',
  flag_override_label tinyint(1) NOT NULL DEFAULT '0',
  language_label text NOT NULL,
  flag_override_tag tinyint(1) NOT NULL DEFAULT '0',
  language_tag text NOT NULL,
  flag_override_help tinyint(1) NOT NULL DEFAULT '0',
  language_help text NOT NULL,
  flag_override_type tinyint(1) NOT NULL DEFAULT '0',
  `type` varchar(255) NOT NULL DEFAULT '',
  flag_override_setting tinyint(1) NOT NULL DEFAULT '0',
  setting varchar(255) NOT NULL DEFAULT '',
  flag_override_default tinyint(1) NOT NULL DEFAULT '0',
  `default` varchar(255) NOT NULL DEFAULT '',
  flag_add tinyint(1) NOT NULL DEFAULT '0',
  flag_add_readonly tinyint(1) NOT NULL DEFAULT '0',
  flag_edit tinyint(1) NOT NULL DEFAULT '0',
  flag_edit_readonly tinyint(1) NOT NULL DEFAULT '0',
  flag_search tinyint(1) NOT NULL DEFAULT '0',
  flag_search_readonly tinyint(1) NOT NULL DEFAULT '0',
  flag_datagrid tinyint(1) NOT NULL DEFAULT '0',
  flag_datagrid_readonly tinyint(1) NOT NULL DEFAULT '0',
  flag_index tinyint(1) NOT NULL DEFAULT '0',
  flag_detail tinyint(1) NOT NULL DEFAULT '0',
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  modified_by int(10) unsigned NOT NULL,
  PRIMARY KEY (id),
  KEY FK_structure_formats_structures (structure_id),
  KEY FK_structure_formats_structure_fields (structure_field_id)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=3597 ;



CREATE TABLE structure_permissible_values (
  id int(11) NOT NULL AUTO_INCREMENT,
  `value` varchar(255) NOT NULL,
  language_alias varchar(255) NOT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY `value` (`value`,language_alias)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=1311 ;



CREATE TABLE structure_permissible_values_customs (
  id int(10) unsigned NOT NULL AUTO_INCREMENT,
  control_id int(10) unsigned NOT NULL,
  `value` varchar(50) NOT NULL,
  en varchar(255) DEFAULT '',
  fr varchar(255) DEFAULT '',
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY control_id (control_id,`value`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=13 ;



CREATE TABLE structure_permissible_values_customs_revs (
  id int(10) unsigned NOT NULL,
  control_id int(10) unsigned NOT NULL,
  `value` varchar(50) NOT NULL,
  en varchar(255) DEFAULT '',
  fr varchar(255) DEFAULT '',
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=16 ;



CREATE TABLE structure_permissible_values_custom_controls (
  id int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  flag_active tinyint(1) NOT NULL DEFAULT '1',
  values_max_length tinyint(3) unsigned NOT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=6 ;



CREATE TABLE structure_validations (
  id int(11) NOT NULL AUTO_INCREMENT,
  structure_field_id int(11) NOT NULL,
  rule text NOT NULL,
  flag_empty tinyint(1) NOT NULL DEFAULT '0',
  flag_required tinyint(1) NOT NULL DEFAULT '0',
  on_action varchar(255) NOT NULL,
  language_message text NOT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  modified_by int(10) unsigned NOT NULL,
  PRIMARY KEY (id),
  KEY FK_structure_validations_structure_fields (structure_field_id)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=111 ;



CREATE TABLE structure_value_domains (
  id int(11) NOT NULL AUTO_INCREMENT,
  domain_name varchar(255) NOT NULL,
  override set('extend','locked','open') NOT NULL DEFAULT 'open',
  category varchar(255) NOT NULL,
  `source` varchar(255) DEFAULT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY domain_name (domain_name)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=329 ;



CREATE TABLE structure_value_domains_permissible_values (
  id int(11) NOT NULL AUTO_INCREMENT,
  structure_value_domain_id varchar(255) NOT NULL,
  structure_permissible_value_id int(11) NOT NULL,
  display_order int(11) NOT NULL DEFAULT '0',
  flag_active tinyint(1) NOT NULL DEFAULT '1',
  language_alias varchar(255) NOT NULL,
  PRIMARY KEY (id),
  KEY structure_permissible_value_id (structure_permissible_value_id)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=1599 ;



CREATE TABLE study_contacts (
  id int(11) NOT NULL AUTO_INCREMENT,
  sort int(11) DEFAULT NULL,
  prefix int(11) DEFAULT NULL,
  first_name varchar(255) DEFAULT NULL,
  middle_name varchar(255) DEFAULT NULL,
  last_name varchar(255) DEFAULT NULL,
  accreditation varchar(255) DEFAULT NULL,
  occupation varchar(255) DEFAULT NULL,
  department varchar(255) DEFAULT NULL,
  organization varchar(255) DEFAULT NULL,
  organization_type varchar(255) DEFAULT NULL,
  address_street varchar(255) DEFAULT NULL,
  address_city varchar(255) DEFAULT NULL,
  address_province varchar(255) DEFAULT NULL,
  address_country varchar(255) DEFAULT NULL,
  address_postal varchar(255) DEFAULT NULL,
  phone_number varchar(255) DEFAULT NULL,
  phone_extension int(11) DEFAULT NULL,
  phone2_number varchar(255) DEFAULT NULL,
  phone2_extension int(11) DEFAULT NULL,
  fax_number varchar(255) DEFAULT NULL,
  fax_extension int(11) DEFAULT NULL,
  email varchar(255) DEFAULT NULL,
  website varchar(255) DEFAULT NULL,
  created datetime DEFAULT NULL,
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  study_summary_id int(11) DEFAULT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (id),
  KEY FK_study_contacts_study_summaries (study_summary_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE study_contacts_revs (
  id int(11) NOT NULL,
  sort int(11) DEFAULT NULL,
  prefix int(11) DEFAULT NULL,
  first_name varchar(255) DEFAULT NULL,
  middle_name varchar(255) DEFAULT NULL,
  last_name varchar(255) DEFAULT NULL,
  accreditation varchar(255) DEFAULT NULL,
  occupation varchar(255) DEFAULT NULL,
  department varchar(255) DEFAULT NULL,
  organization varchar(255) DEFAULT NULL,
  organization_type varchar(255) DEFAULT NULL,
  address_street varchar(255) DEFAULT NULL,
  address_city varchar(255) DEFAULT NULL,
  address_province varchar(255) DEFAULT NULL,
  address_country varchar(255) DEFAULT NULL,
  address_postal varchar(255) DEFAULT NULL,
  phone_number varchar(255) DEFAULT NULL,
  phone_extension int(11) DEFAULT NULL,
  phone2_number varchar(255) DEFAULT NULL,
  phone2_extension int(11) DEFAULT NULL,
  fax_number varchar(255) DEFAULT NULL,
  fax_extension int(11) DEFAULT NULL,
  email varchar(255) DEFAULT NULL,
  website varchar(255) DEFAULT NULL,
  created datetime DEFAULT NULL,
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  study_summary_id int(11) DEFAULT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE study_ethics_boards (
  id int(11) NOT NULL AUTO_INCREMENT,
  ethics_board varchar(255) DEFAULT NULL,
  restrictions text,
  contact varchar(255) DEFAULT NULL,
  `date` date DEFAULT NULL,
  phone_number varchar(255) DEFAULT NULL,
  phone_extension varchar(255) DEFAULT NULL,
  fax_number varchar(255) DEFAULT NULL,
  fax_extension varchar(255) DEFAULT NULL,
  email varchar(255) DEFAULT NULL,
  `status` varchar(255) DEFAULT NULL,
  approval_number varchar(255) DEFAULT NULL,
  accrediation varchar(255) DEFAULT NULL,
  ohrp_registration_number varchar(255) DEFAULT NULL,
  ohrp_fwa_number varchar(255) DEFAULT NULL,
  path_to_file varchar(255) DEFAULT NULL,
  created datetime DEFAULT NULL,
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  study_summary_id int(11) DEFAULT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (id),
  KEY FK_study_ethics_boards_study_summaries (study_summary_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE study_ethics_boards_revs (
  id int(11) NOT NULL,
  ethics_board varchar(255) DEFAULT NULL,
  restrictions text,
  contact varchar(255) DEFAULT NULL,
  `date` date DEFAULT NULL,
  phone_number varchar(255) DEFAULT NULL,
  phone_extension varchar(255) DEFAULT NULL,
  fax_number varchar(255) DEFAULT NULL,
  fax_extension varchar(255) DEFAULT NULL,
  email varchar(255) DEFAULT NULL,
  `status` varchar(255) DEFAULT NULL,
  approval_number varchar(255) DEFAULT NULL,
  accrediation varchar(255) DEFAULT NULL,
  ohrp_registration_number varchar(255) DEFAULT NULL,
  ohrp_fwa_number varchar(255) DEFAULT NULL,
  path_to_file varchar(255) DEFAULT NULL,
  created datetime DEFAULT NULL,
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  study_summary_id int(11) DEFAULT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE study_fundings (
  id int(11) NOT NULL AUTO_INCREMENT,
  study_sponsor varchar(255) DEFAULT NULL,
  restrictions text,
  year_1 int(11) DEFAULT NULL,
  amount_year_1 decimal(10,2) DEFAULT NULL,
  year_2 int(11) DEFAULT NULL,
  amount_year_2 decimal(10,2) DEFAULT NULL,
  year_3 int(11) DEFAULT NULL,
  amount_year_3 decimal(10,2) DEFAULT NULL,
  year_4 int(11) DEFAULT NULL,
  amount_year_4 decimal(10,2) DEFAULT NULL,
  year_5 int(11) DEFAULT NULL,
  amount_year_5 decimal(10,2) DEFAULT NULL,
  contact varchar(255) DEFAULT NULL,
  phone_number varchar(255) DEFAULT NULL,
  phone_extension varchar(255) DEFAULT NULL,
  fax_number varchar(255) DEFAULT NULL,
  fax_extension varchar(255) DEFAULT NULL,
  email varchar(255) DEFAULT NULL,
  `status` varchar(255) DEFAULT NULL,
  `date` date DEFAULT NULL,
  created datetime DEFAULT NULL,
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  rtbform_id int(11) DEFAULT NULL,
  study_summary_id int(11) DEFAULT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (id),
  KEY FK_study_fundings_study_summaries (study_summary_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE study_fundings_revs (
  id int(11) NOT NULL,
  study_sponsor varchar(255) DEFAULT NULL,
  restrictions text,
  year_1 int(11) DEFAULT NULL,
  amount_year_1 decimal(10,2) DEFAULT NULL,
  year_2 int(11) DEFAULT NULL,
  amount_year_2 decimal(10,2) DEFAULT NULL,
  year_3 int(11) DEFAULT NULL,
  amount_year_3 decimal(10,2) DEFAULT NULL,
  year_4 int(11) DEFAULT NULL,
  amount_year_4 decimal(10,2) DEFAULT NULL,
  year_5 int(11) DEFAULT NULL,
  amount_year_5 decimal(10,2) DEFAULT NULL,
  contact varchar(255) DEFAULT NULL,
  phone_number varchar(255) DEFAULT NULL,
  phone_extension varchar(255) DEFAULT NULL,
  fax_number varchar(255) DEFAULT NULL,
  fax_extension varchar(255) DEFAULT NULL,
  email varchar(255) DEFAULT NULL,
  `status` varchar(255) DEFAULT NULL,
  `date` date DEFAULT NULL,
  created datetime DEFAULT NULL,
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  rtbform_id int(11) DEFAULT NULL,
  study_summary_id int(11) DEFAULT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE study_investigators (
  id int(11) NOT NULL AUTO_INCREMENT,
  first_name varchar(255) DEFAULT NULL,
  middle_name varchar(255) DEFAULT NULL,
  last_name varchar(255) DEFAULT NULL,
  accrediation varchar(255) DEFAULT NULL,
  occupation varchar(255) DEFAULT NULL,
  department varchar(255) DEFAULT NULL,
  organization varchar(255) DEFAULT NULL,
  address_street varchar(255) DEFAULT NULL,
  address_city varchar(255) DEFAULT NULL,
  address_province varchar(255) DEFAULT NULL,
  address_country varchar(255) DEFAULT NULL,
  sort int(11) DEFAULT NULL,
  email varchar(45) DEFAULT NULL,
  role varchar(255) DEFAULT NULL,
  brief text,
  participation_start_date date DEFAULT NULL,
  participation_end_date date DEFAULT NULL,
  created datetime DEFAULT NULL,
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  path_to_file text,
  study_summary_id int(11) DEFAULT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (id),
  KEY FK_study_investigators_study_summaries (study_summary_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE study_investigators_revs (
  id int(11) NOT NULL,
  first_name varchar(255) DEFAULT NULL,
  middle_name varchar(255) DEFAULT NULL,
  last_name varchar(255) DEFAULT NULL,
  accrediation varchar(255) DEFAULT NULL,
  occupation varchar(255) DEFAULT NULL,
  department varchar(255) DEFAULT NULL,
  organization varchar(255) DEFAULT NULL,
  address_street varchar(255) DEFAULT NULL,
  address_city varchar(255) DEFAULT NULL,
  address_province varchar(255) DEFAULT NULL,
  address_country varchar(255) DEFAULT NULL,
  sort int(11) DEFAULT NULL,
  email varchar(45) DEFAULT NULL,
  role varchar(255) DEFAULT NULL,
  brief text,
  participation_start_date date DEFAULT NULL,
  participation_end_date date DEFAULT NULL,
  created datetime DEFAULT NULL,
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  path_to_file text,
  study_summary_id int(11) DEFAULT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE study_related (
  id int(11) NOT NULL AUTO_INCREMENT,
  title varchar(255) DEFAULT NULL,
  principal_investigator varchar(255) DEFAULT NULL,
  journal varchar(255) DEFAULT NULL,
  issue varchar(255) DEFAULT NULL,
  url varchar(255) DEFAULT NULL,
  abstract text,
  relevance text,
  date_posted date DEFAULT NULL,
  created datetime DEFAULT NULL,
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  study_summary_id int(11) DEFAULT NULL,
  path_to_file varchar(255) DEFAULT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (id),
  KEY FK_study_related_study_summaries (study_summary_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE study_related_revs (
  id int(11) NOT NULL,
  title varchar(255) DEFAULT NULL,
  principal_investigator varchar(255) DEFAULT NULL,
  journal varchar(255) DEFAULT NULL,
  issue varchar(255) DEFAULT NULL,
  url varchar(255) DEFAULT NULL,
  abstract text,
  relevance text,
  date_posted date DEFAULT NULL,
  created datetime DEFAULT NULL,
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  study_summary_id int(11) DEFAULT NULL,
  path_to_file varchar(255) DEFAULT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE study_results (
  id int(11) NOT NULL AUTO_INCREMENT,
  abstract text,
  hypothesis text,
  conclusion text,
  comparison text,
  future text,
  result_date datetime DEFAULT NULL,
  created datetime DEFAULT NULL,
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  rtbform_id int(11) DEFAULT NULL,
  study_summary_id int(11) DEFAULT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (id),
  KEY FK_study_results_study_summaries (study_summary_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE study_results_revs (
  id int(11) NOT NULL,
  abstract text,
  hypothesis text,
  conclusion text,
  comparison text,
  future text,
  result_date datetime DEFAULT NULL,
  created datetime DEFAULT NULL,
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  rtbform_id int(11) DEFAULT NULL,
  study_summary_id int(11) DEFAULT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE study_reviews (
  id int(11) NOT NULL AUTO_INCREMENT,
  prefix int(11) DEFAULT NULL,
  first_name varchar(255) DEFAULT NULL,
  middle_name varchar(255) DEFAULT NULL,
  last_name varchar(255) DEFAULT NULL,
  accreditation varchar(255) DEFAULT NULL,
  committee varchar(255) DEFAULT NULL,
  institution varchar(255) DEFAULT NULL,
  phone_number varchar(255) DEFAULT NULL,
  phone_extension varchar(255) DEFAULT NULL,
  `status` varchar(255) DEFAULT NULL,
  `date` date DEFAULT NULL,
  created datetime DEFAULT NULL,
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  study_summary_id int(11) DEFAULT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (id),
  KEY FK_study_reviews_study_summaries (study_summary_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE study_reviews_revs (
  id int(11) NOT NULL,
  prefix int(11) DEFAULT NULL,
  first_name varchar(255) DEFAULT NULL,
  middle_name varchar(255) DEFAULT NULL,
  last_name varchar(255) DEFAULT NULL,
  accreditation varchar(255) DEFAULT NULL,
  committee varchar(255) DEFAULT NULL,
  institution varchar(255) DEFAULT NULL,
  phone_number varchar(255) DEFAULT NULL,
  phone_extension varchar(255) DEFAULT NULL,
  `status` varchar(255) DEFAULT NULL,
  `date` date DEFAULT NULL,
  created datetime DEFAULT NULL,
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  study_summary_id int(11) DEFAULT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE study_summaries (
  id int(11) NOT NULL AUTO_INCREMENT,
  disease_site varchar(50) DEFAULT NULL,
  study_type varchar(50) DEFAULT NULL,
  study_science varchar(50) DEFAULT NULL,
  study_use varchar(50) DEFAULT NULL,
  title varchar(45) DEFAULT NULL,
  start_date date DEFAULT NULL,
  end_date date DEFAULT NULL,
  summary text,
  abstract text,
  hypothesis text,
  approach text,
  analysis text,
  significance text,
  additional_clinical text,
  created datetime DEFAULT NULL,
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  path_to_file varchar(255) DEFAULT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE study_summaries_revs (
  id int(11) NOT NULL,
  disease_site varchar(50) DEFAULT NULL,
  study_type varchar(50) DEFAULT NULL,
  study_science varchar(50) DEFAULT NULL,
  study_use varchar(50) DEFAULT NULL,
  title varchar(45) DEFAULT NULL,
  start_date date DEFAULT NULL,
  end_date date DEFAULT NULL,
  summary text,
  abstract text,
  hypothesis text,
  approach text,
  analysis text,
  significance text,
  additional_clinical text,
  created datetime DEFAULT NULL,
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  path_to_file varchar(255) DEFAULT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE tma_slides (
  id int(11) NOT NULL AUTO_INCREMENT,
  tma_block_storage_master_id int(11) DEFAULT NULL,
  barcode varchar(30) NOT NULL DEFAULT '',
  product_code varchar(20) DEFAULT NULL,
  sop_master_id int(11) DEFAULT NULL,
  immunochemistry varchar(30) DEFAULT NULL,
  picture_path varchar(200) DEFAULT NULL,
  storage_datetime datetime DEFAULT NULL,
  storage_master_id int(11) DEFAULT NULL,
  storage_coord_x varchar(11) DEFAULT NULL,
  coord_x_order int(3) DEFAULT NULL,
  storage_coord_y varchar(11) DEFAULT NULL,
  coord_y_order int(3) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY unique_barcode (barcode),
  KEY barcode (barcode),
  KEY product_code (product_code),
  KEY FK_tma_slides_storage_masters (storage_master_id),
  KEY FK_tma_slides_sop_masters (sop_master_id),
  KEY FK_tma_slides_tma_blocks (tma_block_storage_master_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE tma_slides_revs (
  id int(11) NOT NULL,
  tma_block_storage_master_id int(11) DEFAULT NULL,
  barcode varchar(30) NOT NULL DEFAULT '',
  product_code varchar(20) DEFAULT NULL,
  sop_master_id int(11) DEFAULT NULL,
  immunochemistry varchar(30) DEFAULT NULL,
  picture_path varchar(200) DEFAULT NULL,
  storage_datetime datetime DEFAULT NULL,
  storage_master_id int(11) DEFAULT NULL,
  storage_coord_x varchar(11) DEFAULT NULL,
  coord_x_order int(3) DEFAULT NULL,
  storage_coord_y varchar(11) DEFAULT NULL,
  coord_y_order int(3) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime DEFAULT NULL,
  modified_by int(10) unsigned NOT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE txd_chemos (
  id int(11) NOT NULL AUTO_INCREMENT,
  chemo_completed varchar(50) DEFAULT NULL,
  response varchar(50) DEFAULT NULL,
  num_cycles int(11) DEFAULT NULL,
  length_cycles int(11) DEFAULT NULL,
  completed_cycles int(11) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  modified_by int(10) unsigned NOT NULL,
  tx_master_id int(11) DEFAULT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (id),
  KEY tx_master_id (tx_master_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE txd_chemos_revs (
  id int(11) NOT NULL,
  chemo_completed varchar(50) DEFAULT NULL,
  response varchar(50) DEFAULT NULL,
  num_cycles int(11) DEFAULT NULL,
  length_cycles int(11) DEFAULT NULL,
  completed_cycles int(11) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  modified_by int(10) unsigned NOT NULL,
  tx_master_id int(11) DEFAULT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE txd_radiations (
  id int(11) NOT NULL AUTO_INCREMENT,
  rad_completed varchar(50) DEFAULT NULL,
  tx_master_id int(11) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  modified_by int(10) unsigned NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (id),
  KEY tx_master_id (tx_master_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE txd_radiations_revs (
  id int(11) NOT NULL,
  rad_completed varchar(50) DEFAULT NULL,
  tx_master_id int(11) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  modified_by int(10) unsigned NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE txd_surgeries (
  id int(11) NOT NULL AUTO_INCREMENT,
  path_num varchar(50) DEFAULT NULL,
  `primary` varchar(50) DEFAULT NULL,
  tx_master_id int(11) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  modified_by int(10) unsigned NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (id),
  KEY tx_master_id (tx_master_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE txd_surgeries_revs (
  id int(11) NOT NULL,
  path_num varchar(50) DEFAULT NULL,
  `primary` varchar(50) DEFAULT NULL,
  tx_master_id int(11) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  modified_by int(10) unsigned NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE txe_chemos (
  id int(11) NOT NULL AUTO_INCREMENT,
  dose varchar(50) DEFAULT NULL,
  method varchar(50) DEFAULT NULL,
  drug_id int(11) DEFAULT NULL,
  tx_master_id int(11) NOT NULL DEFAULT '0',
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  modified_by int(10) unsigned NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (id),
  KEY FK_txe_chemos_drugs (drug_id),
  KEY FK_txe_chemos_tx_masters (tx_master_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE txe_chemos_revs (
  id int(11) NOT NULL,
  dose varchar(50) DEFAULT NULL,
  method varchar(50) DEFAULT NULL,
  drug_id int(11) DEFAULT NULL,
  tx_master_id int(11) NOT NULL DEFAULT '0',
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  modified_by int(10) unsigned NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE txe_radiations (
  id int(11) NOT NULL AUTO_INCREMENT,
  modaility varchar(50) DEFAULT NULL,
  technique varchar(50) DEFAULT NULL,
  fractions varchar(50) DEFAULT NULL,
  frequency varchar(50) DEFAULT NULL,
  total_time varchar(50) DEFAULT NULL,
  distance_sxd varchar(50) DEFAULT NULL,
  distance_cm varchar(50) DEFAULT NULL,
  dose_xd varchar(50) DEFAULT NULL,
  dose_cgy varchar(50) DEFAULT NULL,
  completed varchar(50) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  modified_by int(10) unsigned NOT NULL,
  tx_master_id int(11) DEFAULT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (id),
  KEY tx_master_id (tx_master_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE txe_radiations_revs (
  id int(11) NOT NULL,
  modaility varchar(50) DEFAULT NULL,
  technique varchar(50) DEFAULT NULL,
  fractions varchar(50) DEFAULT NULL,
  frequency varchar(50) DEFAULT NULL,
  total_time varchar(50) DEFAULT NULL,
  distance_sxd varchar(50) DEFAULT NULL,
  distance_cm varchar(50) DEFAULT NULL,
  dose_xd varchar(50) DEFAULT NULL,
  dose_cgy varchar(50) DEFAULT NULL,
  completed varchar(50) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  modified_by int(10) unsigned NOT NULL,
  tx_master_id int(11) DEFAULT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE txe_surgeries (
  id int(11) NOT NULL AUTO_INCREMENT,
  surgical_procedure varchar(50) DEFAULT NULL,
  tx_master_id int(11) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  modified_by int(10) unsigned NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (id),
  KEY tx_master_id (tx_master_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE txe_surgeries_revs (
  id int(11) NOT NULL,
  surgical_procedure varchar(50) DEFAULT NULL,
  tx_master_id int(11) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  modified_by int(10) unsigned NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE tx_controls (
  id int(11) NOT NULL AUTO_INCREMENT,
  tx_method varchar(50) DEFAULT NULL,
  disease_site varchar(50) DEFAULT NULL,
  flag_active tinyint(1) NOT NULL DEFAULT '1',
  detail_tablename varchar(255) NOT NULL,
  form_alias varchar(255) NOT NULL,
  extend_tablename varchar(255) DEFAULT NULL,
  extend_form_alias varchar(255) DEFAULT NULL,
  display_order int(11) NOT NULL DEFAULT '0',
  applied_protocol_control_id int(11) DEFAULT NULL,
  extended_data_import_process varchar(50) DEFAULT NULL,
  databrowser_label varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (id),
  KEY FK_tx_controls_protocol_controls (applied_protocol_control_id)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=5 ;



CREATE TABLE tx_masters (
  id int(11) NOT NULL AUTO_INCREMENT,
  tx_control_id int(11) NOT NULL DEFAULT '0',
  tx_method varchar(50) DEFAULT NULL,
  disease_site varchar(50) DEFAULT NULL,
  tx_intent varchar(50) DEFAULT NULL,
  target_site_icdo varchar(50) DEFAULT NULL,
  start_date date DEFAULT NULL,
  start_date_accuracy varchar(50) DEFAULT NULL,
  finish_date date DEFAULT NULL,
  finish_date_accuracy varchar(50) DEFAULT NULL,
  information_source varchar(50) DEFAULT NULL,
  facility varchar(50) DEFAULT NULL,
  notes text,
  protocol_master_id int(11) DEFAULT NULL,
  participant_id int(11) DEFAULT NULL,
  diagnosis_master_id int(11) DEFAULT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  modified_by int(10) unsigned NOT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  PRIMARY KEY (id),
  KEY participant_id (participant_id),
  KEY diagnosis_id (diagnosis_master_id),
  KEY treatment_control_id (tx_control_id),
  KEY FK_tx_masters_protocol_masters (protocol_master_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE tx_masters_revs (
  id int(11) NOT NULL,
  tx_control_id int(11) NOT NULL DEFAULT '0',
  tx_method varchar(50) DEFAULT NULL,
  disease_site varchar(50) DEFAULT NULL,
  tx_intent varchar(50) DEFAULT NULL,
  target_site_icdo varchar(50) DEFAULT NULL,
  start_date date DEFAULT NULL,
  start_date_accuracy varchar(50) DEFAULT NULL,
  finish_date date DEFAULT NULL,
  finish_date_accuracy varchar(50) DEFAULT NULL,
  information_source varchar(50) DEFAULT NULL,
  facility varchar(50) DEFAULT NULL,
  notes text,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  modified_by int(10) unsigned NOT NULL,
  protocol_master_id int(11) DEFAULT NULL,
  participant_id int(11) DEFAULT NULL,
  diagnosis_master_id int(11) DEFAULT NULL,
  deleted tinyint(3) unsigned NOT NULL DEFAULT '0',
  deleted_date datetime DEFAULT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE users (
  id int(11) NOT NULL AUTO_INCREMENT,
  username varchar(200) NOT NULL DEFAULT '',
  first_name varchar(50) DEFAULT NULL,
  last_name varchar(50) DEFAULT NULL,
  `password` varchar(255) NOT NULL DEFAULT '',
  email varchar(200) NOT NULL DEFAULT '',
  department varchar(50) DEFAULT NULL,
  job_title varchar(50) DEFAULT NULL,
  institution varchar(50) DEFAULT NULL,
  laboratory varchar(50) DEFAULT NULL,
  help_visible varchar(50) DEFAULT NULL,
  street varchar(50) DEFAULT NULL,
  city varchar(50) DEFAULT NULL,
  region varchar(50) DEFAULT NULL,
  country varchar(50) DEFAULT NULL,
  mail_code varchar(50) DEFAULT NULL,
  phone_work varchar(50) DEFAULT NULL,
  phone_home varchar(50) DEFAULT NULL,
  lang varchar(255) NOT NULL DEFAULT 'en',
  last_visit datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  group_id int(11) NOT NULL DEFAULT '0',
  flag_active tinyint(1) NOT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  modified datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (id),
  UNIQUE KEY unique_username (username)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=4 ;



CREATE TABLE user_login_attempts (
  id int(10) unsigned NOT NULL AUTO_INCREMENT,
  username varchar(50) NOT NULL DEFAULT '',
  ip_addr varchar(15) NOT NULL,
  succeed tinyint(1) NOT NULL,
  attempt_time timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE user_logs (
  id int(11) NOT NULL AUTO_INCREMENT,
  user_id int(11) DEFAULT NULL,
  url text NOT NULL,
  visited timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  allowed tinyint(4) NOT NULL DEFAULT '0',
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



CREATE TABLE versions (
  id int(11) NOT NULL AUTO_INCREMENT,
  version_number varchar(255) NOT NULL,
  date_installed timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  build_number varchar(45) NOT NULL,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_by int(10) unsigned NOT NULL,
  modified datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  modified_by int(10) unsigned NOT NULL,
  PRIMARY KEY (id)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=2 ;


CREATE TABLE `view_aliquots` (
`aliquot_master_id` int(11)
,`sample_master_id` int(11)
,`collection_id` int(11)
,`bank_id` int(11)
,`storage_master_id` int(11)
,`participant_id` int(11)
,`diagnosis_master_id` int(11)
,`consent_master_id` int(11)
,`participant_identifier` varchar(50)
,`acquisition_label` varchar(50)
,`initial_specimen_sample_type` varchar(30)
,`initial_specimen_sample_control_id` int(11)
,`parent_sample_type` varchar(30)
,`parent_sample_control_id` int(11)
,`sample_type` varchar(30)
,`sample_control_id` int(11)
,`barcode` varchar(60)
,`aliquot_type` varchar(30)
,`aliquot_control_id` int(11)
,`in_stock` varchar(30)
,`code` varchar(30)
,`selection_label` varchar(60)
,`storage_coord_x` varchar(11)
,`storage_coord_y` varchar(11)
,`temperature` decimal(5,2)
,`temp_unit` varchar(20)
,`created` datetime
,`deleted` tinyint(3) unsigned
);

CREATE TABLE `view_collections` (
`collection_id` int(11)
,`bank_id` int(11)
,`sop_master_id` int(11)
,`participant_id` int(11)
,`diagnosis_master_id` int(11)
,`consent_master_id` int(11)
,`participant_identifier` varchar(50)
,`acquisition_label` varchar(50)
,`collection_site` varchar(30)
,`collection_datetime` datetime
,`collection_datetime_accuracy` varchar(4)
,`collection_property` varchar(50)
,`collection_notes` text
,`deleted` tinyint(3) unsigned
,`bank_name` varchar(255)
,`created` datetime
);

CREATE TABLE `view_samples` (
`sample_master_id` int(11)
,`parent_sample_id` int(11)
,`initial_specimen_sample_id` int(11)
,`collection_id` int(11)
,`bank_id` int(11)
,`sop_master_id` int(11)
,`participant_id` int(11)
,`diagnosis_master_id` int(11)
,`consent_master_id` int(11)
,`participant_identifier` varchar(50)
,`acquisition_label` varchar(50)
,`initial_specimen_sample_type` varchar(30)
,`initial_specimen_sample_control_id` int(11)
,`parent_sample_type` varchar(30)
,`parent_sample_control_id` int(11)
,`sample_type` varchar(30)
,`sample_control_id` int(11)
,`sample_code` varchar(30)
,`sample_category` varchar(30)
,`deleted` tinyint(3) unsigned
);

CREATE TABLE `view_structures` (
`alias` varchar(255)
,`plugin` varchar(150)
,`model` varchar(150)
,`tablename` varchar(150)
,`field` varchar(150)
,`structure_value_domain` varchar(255)
,`display_column` int(11)
,`display_order` int(11)
,`add` varbinary(9)
,`edit` varbinary(9)
,`search` varbinary(9)
,`datagrid` varbinary(9)
,`index` tinyint(1)
,`detail` tinyint(1)
,`language_heading` varchar(255)
,`language_label` text
,`override_language_label` longblob
,`language_tag` text
,`override_tag` longblob
,`type` varchar(255)
,`override_stype` varbinary(261)
,`setting` text
,`override_setting` varbinary(261)
,`default` varchar(255)
,`override_default` varbinary(261)
,`language_help` text
,`override_help` longblob
);

DROP TABLE IF EXISTS `view_aliquots`;

CREATE ALGORITHM=UNDEFINED DEFINER=root@localhost SQL SECURITY DEFINER VIEW v210b.view_aliquots AS select al.id AS aliquot_master_id,al.sample_master_id AS sample_master_id,al.collection_id AS collection_id,col.bank_id AS bank_id,al.storage_master_id AS storage_master_id,link.participant_id AS participant_id,link.diagnosis_master_id AS diagnosis_master_id,link.consent_master_id AS consent_master_id,part.participant_identifier AS participant_identifier,col.acquisition_label AS acquisition_label,specimen.sample_type AS initial_specimen_sample_type,specimen.sample_control_id AS initial_specimen_sample_control_id,parent_samp.sample_type AS parent_sample_type,parent_samp.sample_control_id AS parent_sample_control_id,samp.sample_type AS sample_type,samp.sample_control_id AS sample_control_id,al.barcode AS barcode,al.aliquot_type AS aliquot_type,al.aliquot_control_id AS aliquot_control_id,al.in_stock AS in_stock,stor.`code` AS `code`,stor.selection_label AS selection_label,al.storage_coord_x AS storage_coord_x,al.storage_coord_y AS storage_coord_y,stor.temperature AS temperature,stor.temp_unit AS temp_unit,al.created AS created,al.deleted AS deleted from (((((((v210b.aliquot_masters al join v210b.sample_masters samp on(((samp.id = al.sample_master_id) and (samp.deleted <> 1)))) join v210b.collections col on(((col.id = samp.collection_id) and (col.deleted <> 1)))) left join v210b.sample_masters specimen on(((samp.initial_specimen_sample_id = specimen.id) and (specimen.deleted <> 1)))) left join v210b.sample_masters parent_samp on(((samp.parent_id = parent_samp.id) and (parent_samp.deleted <> 1)))) left join v210b.clinical_collection_links link on(((col.id = link.collection_id) and (link.deleted <> 1)))) left join v210b.participants part on(((link.participant_id = part.id) and (part.deleted <> 1)))) left join v210b.storage_masters stor on(((stor.id = al.storage_master_id) and (stor.deleted <> 1)))) where (al.deleted <> 1);


DROP TABLE IF EXISTS `view_collections`;

CREATE ALGORITHM=UNDEFINED DEFINER=root@localhost SQL SECURITY DEFINER VIEW v210b.view_collections AS select col.id AS collection_id,col.bank_id AS bank_id,col.sop_master_id AS sop_master_id,link.participant_id AS participant_id,link.diagnosis_master_id AS diagnosis_master_id,link.consent_master_id AS consent_master_id,part.participant_identifier AS participant_identifier,col.acquisition_label AS acquisition_label,col.collection_site AS collection_site,col.collection_datetime AS collection_datetime,col.collection_datetime_accuracy AS collection_datetime_accuracy,col.collection_property AS collection_property,col.collection_notes AS collection_notes,col.deleted AS deleted,v210b.banks.`name` AS bank_name,col.created AS created from (((v210b.collections col left join v210b.clinical_collection_links link on(((col.id = link.collection_id) and (link.deleted <> 1)))) left join v210b.participants part on(((link.participant_id = part.id) and (part.deleted <> 1)))) left join v210b.banks on(((col.bank_id = v210b.banks.id) and (v210b.banks.deleted <> 1)))) where (col.deleted <> 1);


DROP TABLE IF EXISTS `view_samples`;

CREATE ALGORITHM=UNDEFINED DEFINER=root@localhost SQL SECURITY DEFINER VIEW v210b.view_samples AS select samp.id AS sample_master_id,samp.parent_id AS parent_sample_id,samp.initial_specimen_sample_id AS initial_specimen_sample_id,samp.collection_id AS collection_id,col.bank_id AS bank_id,col.sop_master_id AS sop_master_id,link.participant_id AS participant_id,link.diagnosis_master_id AS diagnosis_master_id,link.consent_master_id AS consent_master_id,part.participant_identifier AS participant_identifier,col.acquisition_label AS acquisition_label,specimen.sample_type AS initial_specimen_sample_type,specimen.sample_control_id AS initial_specimen_sample_control_id,parent_samp.sample_type AS parent_sample_type,parent_samp.sample_control_id AS parent_sample_control_id,samp.sample_type AS sample_type,samp.sample_control_id AS sample_control_id,samp.sample_code AS sample_code,samp.sample_category AS sample_category,samp.deleted AS deleted from (((((v210b.sample_masters samp join v210b.collections col on(((col.id = samp.collection_id) and (col.deleted <> 1)))) left join v210b.sample_masters specimen on(((samp.initial_specimen_sample_id = specimen.id) and (specimen.deleted <> 1)))) left join v210b.sample_masters parent_samp on(((samp.parent_id = parent_samp.id) and (parent_samp.deleted <> 1)))) left join v210b.clinical_collection_links link on(((col.id = link.collection_id) and (link.deleted <> 1)))) left join v210b.participants part on(((link.participant_id = part.id) and (part.deleted <> 1)))) where (samp.deleted <> 1);


DROP TABLE IF EXISTS `view_structures`;

CREATE ALGORITHM=UNDEFINED DEFINER=root@localhost SQL SECURITY DEFINER VIEW v210b.view_structures AS select strct.alias AS alias,field.`plugin` AS `plugin`,field.model AS model,field.tablename AS tablename,field.field AS field,domain.domain_name AS structure_value_domain,format.display_column AS display_column,format.display_order AS display_order,concat(format.flag_add,concat('|',format.flag_add_readonly)) AS `add`,concat(format.flag_edit,concat('|',format.flag_edit_readonly)) AS edit,concat(format.flag_search,concat('|',format.flag_search_readonly)) AS search,concat(format.flag_datagrid,concat('|',format.flag_datagrid_readonly)) AS datagrid,format.flag_index AS `index`,format.flag_detail AS detail,format.language_heading AS language_heading,field.language_label AS language_label,concat(format.flag_override_label,'->',format.language_label) AS override_language_label,field.language_tag AS language_tag,concat(format.flag_override_tag,'->',format.language_tag) AS override_tag,field.`type` AS `type`,concat(format.flag_override_type,'->',format.`type`) AS override_stype,field.setting AS setting,concat(format.flag_override_setting,'->',format.setting) AS override_setting,field.`default` AS `default`,concat(format.flag_override_default,'->',format.`default`) AS override_default,field.language_help AS language_help,concat(format.flag_override_help,'->',format.language_help) AS override_help from (((v210b.structures strct left join v210b.structure_formats format on((format.structure_id = strct.id))) left join v210b.structure_fields field on((field.id = format.structure_field_id))) left join v210b.structure_value_domains domain on((domain.id = field.structure_value_domain))) order by strct.alias,format.display_column,format.display_order;


ALTER TABLE `ad_bags`
  ADD CONSTRAINT FK_ad_bags_aliquot_masters FOREIGN KEY (aliquot_master_id) REFERENCES aliquot_masters (id);

ALTER TABLE `ad_blocks`
  ADD CONSTRAINT FK_ad_blocks_aliquot_masters FOREIGN KEY (aliquot_master_id) REFERENCES aliquot_masters (id);

ALTER TABLE `ad_cell_cores`
  ADD CONSTRAINT FK_ad_cell_cores_aliquot_masters FOREIGN KEY (aliquot_master_id) REFERENCES aliquot_masters (id);

ALTER TABLE `ad_cell_slides`
  ADD CONSTRAINT FK_ad_cell_slides_aliquot_masters FOREIGN KEY (aliquot_master_id) REFERENCES aliquot_masters (id);

ALTER TABLE `ad_gel_matrices`
  ADD CONSTRAINT FK_ad_gel_matrices_aliquot_masters FOREIGN KEY (aliquot_master_id) REFERENCES aliquot_masters (id);

ALTER TABLE `ad_tissue_cores`
  ADD CONSTRAINT FK_ad_tissue_cores_aliquot_masters FOREIGN KEY (aliquot_master_id) REFERENCES aliquot_masters (id);

ALTER TABLE `ad_tissue_slides`
  ADD CONSTRAINT FK_ad_tissue_slides_aliquot_masters FOREIGN KEY (aliquot_master_id) REFERENCES aliquot_masters (id);

ALTER TABLE `ad_tubes`
  ADD CONSTRAINT FK_ad_tubes_aliquot_masters FOREIGN KEY (aliquot_master_id) REFERENCES aliquot_masters (id);

ALTER TABLE `ad_whatman_papers`
  ADD CONSTRAINT FK_ad_whatman_papers_aliquot_masters FOREIGN KEY (aliquot_master_id) REFERENCES aliquot_masters (id);

ALTER TABLE `aliquot_masters`
  ADD CONSTRAINT FK_aliquot_masters_aliquot_controls FOREIGN KEY (aliquot_control_id) REFERENCES aliquot_controls (id),
  ADD CONSTRAINT FK_aliquot_masters_collections FOREIGN KEY (collection_id) REFERENCES collections (id),
  ADD CONSTRAINT FK_aliquot_masters_sample_masters FOREIGN KEY (sample_master_id) REFERENCES sample_masters (id),
  ADD CONSTRAINT FK_aliquot_masters_sops FOREIGN KEY (sop_master_id) REFERENCES sop_masters (id),
  ADD CONSTRAINT FK_aliquot_masters_storage_masters FOREIGN KEY (storage_master_id) REFERENCES storage_masters (id),
  ADD CONSTRAINT FK_aliquot_masters_study_summaries FOREIGN KEY (study_summary_id) REFERENCES study_summaries (id);

ALTER TABLE `aliquot_review_masters`
  ADD CONSTRAINT FK_aliquot_review_masters_aliquot_masters FOREIGN KEY (aliquot_masters_id) REFERENCES aliquot_masters (id),
  ADD CONSTRAINT FK_aliquot_review_masters_aliquot_review_controls FOREIGN KEY (aliquot_review_control_id) REFERENCES aliquot_review_controls (id),
  ADD CONSTRAINT FK_aliquot_review_masters_aliquot_uses FOREIGN KEY (aliquot_use_id) REFERENCES aliquot_uses (id),
  ADD CONSTRAINT FK_aliquot_review_masters_specimen_review_masters FOREIGN KEY (specimen_review_master_id) REFERENCES specimen_review_masters (id);

ALTER TABLE `aliquot_uses`
  ADD CONSTRAINT FK_aliquot_uses_aliquot_masters FOREIGN KEY (aliquot_master_id) REFERENCES aliquot_masters (id),
  ADD CONSTRAINT FK_aliquot_uses_study_summaries FOREIGN KEY (study_summary_id) REFERENCES study_summaries (id);

ALTER TABLE `ar_breast_tissue_slides`
  ADD CONSTRAINT FK_ar_breast_tissue_slides_aliquot_review_masters FOREIGN KEY (aliquot_review_master_id) REFERENCES aliquot_review_masters (id);

ALTER TABLE `cd_nationals`
  ADD CONSTRAINT cd_nationals_ibfk_1 FOREIGN KEY (consent_master_id) REFERENCES consent_masters (id);

ALTER TABLE `clinical_collection_links`
  ADD CONSTRAINT FK_clinical_collection_links_collections FOREIGN KEY (collection_id) REFERENCES collections (id),
  ADD CONSTRAINT FK_clinical_collection_links_consent_masters FOREIGN KEY (consent_master_id) REFERENCES consent_masters (id),
  ADD CONSTRAINT FK_clinical_collection_links_diagnosis_masters FOREIGN KEY (diagnosis_master_id) REFERENCES diagnosis_masters (id),
  ADD CONSTRAINT FK_clinical_collection_links_participant FOREIGN KEY (participant_id) REFERENCES participants (id);

ALTER TABLE `collections`
  ADD CONSTRAINT FK_collections_banks FOREIGN KEY (bank_id) REFERENCES banks (id),
  ADD CONSTRAINT FK_collections_sops FOREIGN KEY (sop_master_id) REFERENCES sop_masters (id);

ALTER TABLE `consent_masters`
  ADD CONSTRAINT FK_consent_masters_consent_controls FOREIGN KEY (consent_control_id) REFERENCES consent_controls (id),
  ADD CONSTRAINT FK_consent_masters_participant FOREIGN KEY (participant_id) REFERENCES participants (id);

ALTER TABLE `datamart_browsing_controls`
  ADD CONSTRAINT datamart_browsing_controls_ibfk_1 FOREIGN KEY (id1) REFERENCES datamart_structures (id),
  ADD CONSTRAINT datamart_browsing_controls_ibfk_2 FOREIGN KEY (id2) REFERENCES datamart_structures (id);

ALTER TABLE `datamart_browsing_indexes`
  ADD CONSTRAINT datamart_browsing_indexes_ibfk_1 FOREIGN KEY (root_node_id) REFERENCES datamart_browsing_results (id);

ALTER TABLE `datamart_structures`
  ADD CONSTRAINT datamart_structures_ibfk_1 FOREIGN KEY (structure_id) REFERENCES structures (id);

ALTER TABLE `derivative_details`
  ADD CONSTRAINT FK_detivative_details_sample_masters FOREIGN KEY (sample_master_id) REFERENCES sample_masters (id);

ALTER TABLE `diagnosis_masters`
  ADD CONSTRAINT FK_diagnosis_masters_diagnosis_controls FOREIGN KEY (diagnosis_control_id) REFERENCES diagnosis_controls (id),
  ADD CONSTRAINT FK_diagnosis_masters_participant FOREIGN KEY (participant_id) REFERENCES participants (id);

ALTER TABLE `dxd_cap_report_ampullas`
  ADD CONSTRAINT FK_dxd_cap_report_ampullas_diagnosis_masters FOREIGN KEY (diagnosis_master_id) REFERENCES diagnosis_masters (id);

ALTER TABLE `dxd_cap_report_colon_biopsies`
  ADD CONSTRAINT FK_dxd_cap_report_colons_diagnosis_masters FOREIGN KEY (diagnosis_master_id) REFERENCES diagnosis_masters (id);

ALTER TABLE `dxd_cap_report_colon_rectum_resections`
  ADD CONSTRAINT FK_dxd_cap_report_colon_rectum_resections_diagnosis_masters FOREIGN KEY (diagnosis_master_id) REFERENCES diagnosis_masters (id);

ALTER TABLE `dxd_cap_report_distalexbileducts`
  ADD CONSTRAINT FK_dxd_cap_report_distalexbileducts_diagnosis_masters FOREIGN KEY (diagnosis_master_id) REFERENCES diagnosis_masters (id);

ALTER TABLE `dxd_cap_report_gallbladders`
  ADD CONSTRAINT FK_dxd_cap_report_gallbladders_diagnosis_masters FOREIGN KEY (diagnosis_master_id) REFERENCES diagnosis_masters (id);

ALTER TABLE `dxd_cap_report_hepatocellular_carcinomas`
  ADD CONSTRAINT FK_dxd_cap_report_hepatocellulars_diagnosis_masters FOREIGN KEY (diagnosis_master_id) REFERENCES diagnosis_masters (id);

ALTER TABLE `dxd_cap_report_intrahepbileducts`
  ADD CONSTRAINT FK_dxd_cap_report_intrahepbileducts_diagnosis_masters FOREIGN KEY (diagnosis_master_id) REFERENCES diagnosis_masters (id);

ALTER TABLE `dxd_cap_report_pancreasendos`
  ADD CONSTRAINT FK_dxd_cap_report_pancreasendos_diagnosis_masters FOREIGN KEY (diagnosis_master_id) REFERENCES diagnosis_masters (id);

ALTER TABLE `dxd_cap_report_pancreasexos`
  ADD CONSTRAINT FK_dxd_cap_report_pancreasexos_diagnosis_masters FOREIGN KEY (diagnosis_master_id) REFERENCES diagnosis_masters (id);

ALTER TABLE `dxd_cap_report_perihilarbileducts`
  ADD CONSTRAINT FK_dxd_cap_report_perihilarbileducts_diagnosis_masters FOREIGN KEY (diagnosis_master_id) REFERENCES diagnosis_masters (id);

ALTER TABLE `dxd_cap_report_smintestines`
  ADD CONSTRAINT FK_dxd_cap_report_smintestines_diagnosis_masters FOREIGN KEY (diagnosis_master_id) REFERENCES diagnosis_masters (id);

ALTER TABLE `ed_all_adverse_events_adverse_events`
  ADD CONSTRAINT ed_all_adverse_events_adverse_events_ibfk_1 FOREIGN KEY (event_master_id) REFERENCES event_masters (id);

ALTER TABLE `ed_all_clinical_followups`
  ADD CONSTRAINT ed_all_clinical_followups_ibfk_1 FOREIGN KEY (event_master_id) REFERENCES event_masters (id);

ALTER TABLE `ed_all_clinical_presentations`
  ADD CONSTRAINT ed_all_clinical_presentations_ibfk_1 FOREIGN KEY (event_master_id) REFERENCES event_masters (id);

ALTER TABLE `ed_all_lifestyle_smokings`
  ADD CONSTRAINT ed_all_lifestyle_smokings_ibfk_1 FOREIGN KEY (event_master_id) REFERENCES event_masters (id);

ALTER TABLE `ed_all_protocol_followups`
  ADD CONSTRAINT ed_all_protocol_followups_ibfk_1 FOREIGN KEY (event_master_id) REFERENCES event_masters (id);

ALTER TABLE `ed_all_study_researches`
  ADD CONSTRAINT ed_all_study_researches_ibfk_1 FOREIGN KEY (event_master_id) REFERENCES event_masters (id);

ALTER TABLE `ed_breast_lab_pathologies`
  ADD CONSTRAINT ed_breast_lab_pathologies_ibfk_1 FOREIGN KEY (event_master_id) REFERENCES event_masters (id);

ALTER TABLE `ed_breast_screening_mammograms`
  ADD CONSTRAINT ed_breast_screening_mammograms_ibfk_1 FOREIGN KEY (event_master_id) REFERENCES event_masters (id);

ALTER TABLE `event_masters`
  ADD CONSTRAINT FK_event_masters_diagnosis_masters FOREIGN KEY (diagnosis_master_id) REFERENCES diagnosis_masters (id),
  ADD CONSTRAINT FK_event_masters_event_controls FOREIGN KEY (event_control_id) REFERENCES event_controls (id),
  ADD CONSTRAINT FK_event_masters_participant FOREIGN KEY (participant_id) REFERENCES participants (id);

ALTER TABLE `family_histories`
  ADD CONSTRAINT FK_family_histories_participant FOREIGN KEY (participant_id) REFERENCES participants (id);

ALTER TABLE `groups`
  ADD CONSTRAINT groups_ibfk_1 FOREIGN KEY (bank_id) REFERENCES banks (id);

ALTER TABLE `misc_identifiers`
  ADD CONSTRAINT FK_misc_identifiers_misc_identifier_controls FOREIGN KEY (misc_identifier_control_id) REFERENCES misc_identifier_controls (id),
  ADD CONSTRAINT FK_misc_identifiers_participant FOREIGN KEY (participant_id) REFERENCES participants (id);

ALTER TABLE `orders`
  ADD CONSTRAINT FK_orders_study_summaries FOREIGN KEY (study_summary_id) REFERENCES study_summaries (id);

ALTER TABLE `order_items`
  ADD CONSTRAINT FK_order_items_aliquot_masters FOREIGN KEY (aliquot_master_id) REFERENCES aliquot_masters (id),
  ADD CONSTRAINT FK_order_items_aliquot_uses FOREIGN KEY (aliquot_use_id) REFERENCES aliquot_uses (id),
  ADD CONSTRAINT FK_order_items_order_lines FOREIGN KEY (order_line_id) REFERENCES order_lines (id),
  ADD CONSTRAINT FK_order_items_shipments FOREIGN KEY (shipment_id) REFERENCES shipments (id);

ALTER TABLE `order_lines`
  ADD CONSTRAINT FK_order_lines_orders FOREIGN KEY (order_id) REFERENCES orders (id),
  ADD CONSTRAINT FK_order_lines_sample_controls FOREIGN KEY (sample_control_id) REFERENCES sample_controls (id);

ALTER TABLE `parent_to_derivative_sample_controls`
  ADD CONSTRAINT FK_parent_to_derivative_sample_controls_derivative FOREIGN KEY (derivative_sample_control_id) REFERENCES sample_controls (id),
  ADD CONSTRAINT FK_parent_to_derivative_sample_controls_parent FOREIGN KEY (parent_sample_control_id) REFERENCES sample_controls (id);

ALTER TABLE `participant_contacts`
  ADD CONSTRAINT FK_participant_contacts_participant FOREIGN KEY (participant_id) REFERENCES participants (id);

ALTER TABLE `participant_messages`
  ADD CONSTRAINT FK_participant_messages_participant FOREIGN KEY (participant_id) REFERENCES participants (id);

ALTER TABLE `pd_chemos`
  ADD CONSTRAINT FK_pd_chemos_protocol_masters FOREIGN KEY (protocol_master_id) REFERENCES protocol_masters (id);

ALTER TABLE `pd_surgeries`
  ADD CONSTRAINT FK_pd_surgeries_protocol_masters FOREIGN KEY (protocol_master_id) REFERENCES protocol_masters (id);

ALTER TABLE `pe_chemos`
  ADD CONSTRAINT FK_pe_chemos_drugs FOREIGN KEY (drug_id) REFERENCES drugs (id),
  ADD CONSTRAINT FK_pe_chemos_protocol_masters FOREIGN KEY (protocol_master_id) REFERENCES protocol_masters (id);

ALTER TABLE `quality_ctrls`
  ADD CONSTRAINT FK_quality_ctrls_sample_masters FOREIGN KEY (sample_master_id) REFERENCES sample_masters (id);

ALTER TABLE `quality_ctrl_tested_aliquots`
  ADD CONSTRAINT FK_quality_ctrl_tested_aliquots_aliquot_masters FOREIGN KEY (aliquot_master_id) REFERENCES aliquot_masters (id),
  ADD CONSTRAINT FK_quality_ctrl_tested_aliquots_aliquot_uses FOREIGN KEY (aliquot_use_id) REFERENCES aliquot_uses (id),
  ADD CONSTRAINT FK_quality_ctrl_tested_aliquots_quality_ctrls FOREIGN KEY (quality_ctrl_id) REFERENCES quality_ctrls (id);

ALTER TABLE `realiquotings`
  ADD CONSTRAINT FK_realiquotings_aliquot_uses FOREIGN KEY (aliquot_use_id) REFERENCES aliquot_uses (id),
  ADD CONSTRAINT FK_realiquotings_child_aliquot_masters FOREIGN KEY (child_aliquot_master_id) REFERENCES aliquot_masters (id),
  ADD CONSTRAINT FK_realiquotings_parent_aliquot_masters FOREIGN KEY (parent_aliquot_master_id) REFERENCES aliquot_masters (id);

ALTER TABLE `realiquoting_controls`
  ADD CONSTRAINT FK_child_realiquoting_control FOREIGN KEY (child_sample_to_aliquot_control_id) REFERENCES sample_to_aliquot_controls (id),
  ADD CONSTRAINT FK_parent_realiquoting_control FOREIGN KEY (parent_sample_to_aliquot_control_id) REFERENCES sample_to_aliquot_controls (id);

ALTER TABLE `reproductive_histories`
  ADD CONSTRAINT FK_reproductive_histories_participant FOREIGN KEY (participant_id) REFERENCES participants (id);

ALTER TABLE `sample_masters`
  ADD CONSTRAINT FK_sample_masters_collections FOREIGN KEY (collection_id) REFERENCES collections (id),
  ADD CONSTRAINT FK_sample_masters_parent FOREIGN KEY (parent_id) REFERENCES sample_masters (id),
  ADD CONSTRAINT FK_sample_masters_sample_controls FOREIGN KEY (sample_control_id) REFERENCES sample_controls (id),
  ADD CONSTRAINT FK_sample_masters_sample_specimens FOREIGN KEY (initial_specimen_sample_id) REFERENCES sample_masters (id),
  ADD CONSTRAINT FK_sample_masters_sops FOREIGN KEY (sop_master_id) REFERENCES sop_masters (id);

ALTER TABLE `sample_to_aliquot_controls`
  ADD CONSTRAINT FK_sample_to_aliquot_controls_aliquot_controls FOREIGN KEY (aliquot_control_id) REFERENCES aliquot_controls (id),
  ADD CONSTRAINT FK_sample_to_aliquot_controls_sample_controls FOREIGN KEY (sample_control_id) REFERENCES sample_controls (id);

ALTER TABLE `sd_der_amp_rnas`
  ADD CONSTRAINT FK_sd_der_amp_rnas_sample_masters FOREIGN KEY (sample_master_id) REFERENCES sample_masters (id);

ALTER TABLE `sd_der_ascite_cells`
  ADD CONSTRAINT FK_sd_der_ascite_cells_sample_masters FOREIGN KEY (sample_master_id) REFERENCES sample_masters (id);

ALTER TABLE `sd_der_ascite_sups`
  ADD CONSTRAINT FK_sd_der_ascite_sups_sample_masters FOREIGN KEY (sample_master_id) REFERENCES sample_masters (id);

ALTER TABLE `sd_der_blood_cells`
  ADD CONSTRAINT FK_sd_der_blood_cells_sample_masters FOREIGN KEY (sample_master_id) REFERENCES sample_masters (id);

ALTER TABLE `sd_der_b_cells`
  ADD CONSTRAINT FK_sd_der_b_cells_sample_masters FOREIGN KEY (sample_master_id) REFERENCES sample_masters (id);

ALTER TABLE `sd_der_cdnas`
  ADD CONSTRAINT FK_sd_der_cdnas_sample_masters FOREIGN KEY (sample_master_id) REFERENCES sample_masters (id);

ALTER TABLE `sd_der_cell_cultures`
  ADD CONSTRAINT FK_sd_der_cell_cultures_sample_masters FOREIGN KEY (sample_master_id) REFERENCES sample_masters (id);

ALTER TABLE `sd_der_cystic_fl_cells`
  ADD CONSTRAINT FK_sd_der_cystic_fl_cells_sample_masters FOREIGN KEY (sample_master_id) REFERENCES sample_masters (id);

ALTER TABLE `sd_der_cystic_fl_sups`
  ADD CONSTRAINT FK_sd_der_cystic_fl_sups_sample_masters FOREIGN KEY (sample_master_id) REFERENCES sample_masters (id);

ALTER TABLE `sd_der_dnas`
  ADD CONSTRAINT FK_sd_der_dnas_sample_masters FOREIGN KEY (sample_master_id) REFERENCES sample_masters (id);

ALTER TABLE `sd_der_pbmcs`
  ADD CONSTRAINT FK_sd_der_pbmcs_sample_masters FOREIGN KEY (sample_master_id) REFERENCES sample_masters (id);

ALTER TABLE `sd_der_pericardial_fl_cells`
  ADD CONSTRAINT FK_sd_der_pericardial_fl_cells_sample_masters FOREIGN KEY (sample_master_id) REFERENCES sample_masters (id);

ALTER TABLE `sd_der_pericardial_fl_sups`
  ADD CONSTRAINT FK_sd_der_pericardial_fl_sups_sample_masters FOREIGN KEY (sample_master_id) REFERENCES sample_masters (id);

ALTER TABLE `sd_der_plasmas`
  ADD CONSTRAINT FK_sd_der_plasmas_sample_masters FOREIGN KEY (sample_master_id) REFERENCES sample_masters (id);

ALTER TABLE `sd_der_pleural_fl_cells`
  ADD CONSTRAINT FK_sd_der_pleural_fl_cells_sample_masters FOREIGN KEY (sample_master_id) REFERENCES sample_masters (id);

ALTER TABLE `sd_der_pleural_fl_sups`
  ADD CONSTRAINT FK_sd_der_pleural_fl_sups_sample_masters FOREIGN KEY (sample_master_id) REFERENCES sample_masters (id);

ALTER TABLE `sd_der_proteins`
  ADD CONSTRAINT sd_der_proteins_ibfk_1 FOREIGN KEY (sample_master_id) REFERENCES sample_masters (id);

ALTER TABLE `sd_der_pw_cells`
  ADD CONSTRAINT FK_sd_der_pw_cells_sample_masters FOREIGN KEY (sample_master_id) REFERENCES sample_masters (id);

ALTER TABLE `sd_der_pw_sups`
  ADD CONSTRAINT FK_sd_der_pw_sups_sample_masters FOREIGN KEY (sample_master_id) REFERENCES sample_masters (id);

ALTER TABLE `sd_der_rnas`
  ADD CONSTRAINT FK_sd_der_rnas_sample_masters FOREIGN KEY (sample_master_id) REFERENCES sample_masters (id);

ALTER TABLE `sd_der_serums`
  ADD CONSTRAINT FK_sd_der_serums_sample_masters FOREIGN KEY (sample_master_id) REFERENCES sample_masters (id);

ALTER TABLE `sd_der_tiss_lysates`
  ADD CONSTRAINT FK_sd_der_tiss_lysates_sample_masters FOREIGN KEY (sample_master_id) REFERENCES sample_masters (id);

ALTER TABLE `sd_der_tiss_susps`
  ADD CONSTRAINT FK_sd_der_tiss_susps_sample_masters FOREIGN KEY (sample_master_id) REFERENCES sample_masters (id);

ALTER TABLE `sd_der_urine_cents`
  ADD CONSTRAINT FK_sd_der_urine_cents_sample_masters FOREIGN KEY (sample_master_id) REFERENCES sample_masters (id);

ALTER TABLE `sd_der_urine_cons`
  ADD CONSTRAINT FK_sd_der_urine_cons_sample_masters FOREIGN KEY (sample_master_id) REFERENCES sample_masters (id);

ALTER TABLE `sd_spe_ascites`
  ADD CONSTRAINT FK_sd_spe_ascites_sample_masters FOREIGN KEY (sample_master_id) REFERENCES sample_masters (id);

ALTER TABLE `sd_spe_bloods`
  ADD CONSTRAINT FK_sd_spe_bloods_sample_masters FOREIGN KEY (sample_master_id) REFERENCES sample_masters (id);

ALTER TABLE `sd_spe_cystic_fluids`
  ADD CONSTRAINT FK_sd_spe_cystic_fluids_sample_masters FOREIGN KEY (sample_master_id) REFERENCES sample_masters (id);

ALTER TABLE `sd_spe_pericardial_fluids`
  ADD CONSTRAINT FK_sd_spe_pericardial_fluids_sample_masters FOREIGN KEY (sample_master_id) REFERENCES sample_masters (id);

ALTER TABLE `sd_spe_peritoneal_washes`
  ADD CONSTRAINT FK_sd_spe_peritoneal_washes_sample_masters FOREIGN KEY (sample_master_id) REFERENCES sample_masters (id);

ALTER TABLE `sd_spe_pleural_fluids`
  ADD CONSTRAINT FK_sd_spe_pleural_fluids_sample_masters FOREIGN KEY (sample_master_id) REFERENCES sample_masters (id);

ALTER TABLE `sd_spe_tissues`
  ADD CONSTRAINT FK_sd_spe_tissues_sample_masters FOREIGN KEY (sample_master_id) REFERENCES sample_masters (id);

ALTER TABLE `sd_spe_urines`
  ADD CONSTRAINT FK_sd_spe_urines_sample_masters FOREIGN KEY (sample_master_id) REFERENCES sample_masters (id);

ALTER TABLE `shipments`
  ADD CONSTRAINT FK_shipments_orders FOREIGN KEY (order_id) REFERENCES orders (id);

ALTER TABLE `source_aliquots`
  ADD CONSTRAINT FK_source_aliquots_aliquot_masters FOREIGN KEY (aliquot_master_id) REFERENCES aliquot_masters (id),
  ADD CONSTRAINT FK_source_aliquots_aliquot_uses FOREIGN KEY (aliquot_use_id) REFERENCES aliquot_uses (id),
  ADD CONSTRAINT FK_source_aliquots_sample_masters FOREIGN KEY (sample_master_id) REFERENCES sample_masters (id);

ALTER TABLE `specimen_details`
  ADD CONSTRAINT FK_specimen_details_sample_masters FOREIGN KEY (sample_master_id) REFERENCES sample_masters (id);

ALTER TABLE `specimen_review_controls`
  ADD CONSTRAINT FK_specimen_review_controls_sample_controls FOREIGN KEY (sample_control_id) REFERENCES sample_controls (id),
  ADD CONSTRAINT FK_specimen_review_controls_specimen_review_controls FOREIGN KEY (aliquot_review_control_id) REFERENCES specimen_review_controls (id);

ALTER TABLE `specimen_review_masters`
  ADD CONSTRAINT FK_specimen_review_masters_sample_masters FOREIGN KEY (sample_master_id) REFERENCES sample_masters (id),
  ADD CONSTRAINT FK_specimen_review_masters_collections FOREIGN KEY (collection_id) REFERENCES collections (id),
  ADD CONSTRAINT FK_specimen_review_masters_specimen_review_controls FOREIGN KEY (specimen_review_control_id) REFERENCES specimen_review_controls (id);

ALTER TABLE `spr_breast_cancer_types`
  ADD CONSTRAINT FK_spr_breast_cancer_types_specimen_review_masters FOREIGN KEY (specimen_review_master_id) REFERENCES specimen_review_masters (id);

ALTER TABLE `std_boxs`
  ADD CONSTRAINT FK_std_boxs_storage_masters FOREIGN KEY (storage_master_id) REFERENCES storage_masters (id);

ALTER TABLE `std_cupboards`
  ADD CONSTRAINT FK_std_cupboards_storage_masters FOREIGN KEY (storage_master_id) REFERENCES storage_masters (id);

ALTER TABLE `std_freezers`
  ADD CONSTRAINT FK_std_freezers_storage_masters FOREIGN KEY (storage_master_id) REFERENCES storage_masters (id);

ALTER TABLE `std_fridges`
  ADD CONSTRAINT FK_std_fridges_storage_masters FOREIGN KEY (storage_master_id) REFERENCES storage_masters (id);

ALTER TABLE `std_incubators`
  ADD CONSTRAINT FK_std_incubators_storage_masters FOREIGN KEY (storage_master_id) REFERENCES storage_masters (id);

ALTER TABLE `std_nitro_locates`
  ADD CONSTRAINT FK_std_nitro_locates_storage_masters FOREIGN KEY (storage_master_id) REFERENCES storage_masters (id);

ALTER TABLE `std_racks`
  ADD CONSTRAINT FK_std_racks_storage_masters FOREIGN KEY (storage_master_id) REFERENCES storage_masters (id);

ALTER TABLE `std_rooms`
  ADD CONSTRAINT FK_std_rooms_storage_masters FOREIGN KEY (storage_master_id) REFERENCES storage_masters (id);

ALTER TABLE `std_shelfs`
  ADD CONSTRAINT FK_std_shelfs_storage_masters FOREIGN KEY (storage_master_id) REFERENCES storage_masters (id);

ALTER TABLE `std_tma_blocks`
  ADD CONSTRAINT FK_std_tma_blocks_sop_masters FOREIGN KEY (sop_master_id) REFERENCES sop_masters (id),
  ADD CONSTRAINT FK_std_tma_blocks_storage_masters FOREIGN KEY (storage_master_id) REFERENCES storage_masters (id);

ALTER TABLE `storage_coordinates`
  ADD CONSTRAINT FK_storage_coordinates_storage_masters FOREIGN KEY (storage_master_id) REFERENCES storage_masters (id);

ALTER TABLE `storage_masters`
  ADD CONSTRAINT FK_storage_masters_parent FOREIGN KEY (parent_id) REFERENCES storage_masters (id),
  ADD CONSTRAINT FK_storage_masters_storage_controls FOREIGN KEY (storage_control_id) REFERENCES storage_controls (id);

ALTER TABLE `structure_fields`
  ADD CONSTRAINT FK_structure_fields_structure_value_domains FOREIGN KEY (structure_value_domain) REFERENCES structure_value_domains (id);

ALTER TABLE `structure_formats`
  ADD CONSTRAINT FK_structure_formats_structures FOREIGN KEY (structure_id) REFERENCES structures (id),
  ADD CONSTRAINT FK_structure_formats_structure_fields FOREIGN KEY (structure_field_id) REFERENCES structure_fields (id);

ALTER TABLE `structure_permissible_values_customs`
  ADD CONSTRAINT structure_permissible_values_customs_ibfk_1 FOREIGN KEY (control_id) REFERENCES structure_permissible_values_custom_controls (id);

ALTER TABLE `structure_validations`
  ADD CONSTRAINT FK_structure_validations_structure_fields FOREIGN KEY (structure_field_id) REFERENCES structure_fields (id);

ALTER TABLE `structure_value_domains_permissible_values`
  ADD CONSTRAINT structure_value_domains_permissible_values_ibfk_1 FOREIGN KEY (structure_permissible_value_id) REFERENCES structure_permissible_values (id);

ALTER TABLE `study_contacts`
  ADD CONSTRAINT FK_study_contacts_study_summaries FOREIGN KEY (study_summary_id) REFERENCES study_summaries (id);

ALTER TABLE `study_ethics_boards`
  ADD CONSTRAINT FK_study_ethics_boards_study_summaries FOREIGN KEY (study_summary_id) REFERENCES study_summaries (id);

ALTER TABLE `study_fundings`
  ADD CONSTRAINT FK_study_fundings_study_summaries FOREIGN KEY (study_summary_id) REFERENCES study_summaries (id);

ALTER TABLE `study_investigators`
  ADD CONSTRAINT FK_study_investigators_study_summaries FOREIGN KEY (study_summary_id) REFERENCES study_summaries (id);

ALTER TABLE `study_related`
  ADD CONSTRAINT FK_study_related_study_summaries FOREIGN KEY (study_summary_id) REFERENCES study_summaries (id);

ALTER TABLE `study_results`
  ADD CONSTRAINT FK_study_results_study_summaries FOREIGN KEY (study_summary_id) REFERENCES study_summaries (id);

ALTER TABLE `study_reviews`
  ADD CONSTRAINT FK_study_reviews_study_summaries FOREIGN KEY (study_summary_id) REFERENCES study_summaries (id);

ALTER TABLE `tma_slides`
  ADD CONSTRAINT FK_tma_slides_sop_masters FOREIGN KEY (sop_master_id) REFERENCES sop_masters (id),
  ADD CONSTRAINT FK_tma_slides_storage_masters FOREIGN KEY (storage_master_id) REFERENCES storage_masters (id),
  ADD CONSTRAINT FK_tma_slides_tma_blocks FOREIGN KEY (tma_block_storage_master_id) REFERENCES storage_masters (id);

ALTER TABLE `txd_chemos`
  ADD CONSTRAINT FK_txd_chemos_tx_masters FOREIGN KEY (tx_master_id) REFERENCES tx_masters (id);

ALTER TABLE `txd_radiations`
  ADD CONSTRAINT FK_txd_radiations_tx_masters FOREIGN KEY (tx_master_id) REFERENCES tx_masters (id);

ALTER TABLE `txd_surgeries`
  ADD CONSTRAINT FK_txd_surgeries_tx_masters FOREIGN KEY (tx_master_id) REFERENCES tx_masters (id);

ALTER TABLE `txe_chemos`
  ADD CONSTRAINT FK_txe_chemos_tx_masters FOREIGN KEY (tx_master_id) REFERENCES tx_masters (id),
  ADD CONSTRAINT FK_txe_chemos_drugs FOREIGN KEY (drug_id) REFERENCES drugs (id);

ALTER TABLE `txe_radiations`
  ADD CONSTRAINT FK_txe_radiations_tx_masters FOREIGN KEY (tx_master_id) REFERENCES tx_masters (id);

ALTER TABLE `txe_surgeries`
  ADD CONSTRAINT FK_txe_surgeries_tx_masters FOREIGN KEY (tx_master_id) REFERENCES tx_masters (id);

ALTER TABLE `tx_controls`
  ADD CONSTRAINT FK_tx_controls_protocol_controls FOREIGN KEY (applied_protocol_control_id) REFERENCES protocol_controls (id);

ALTER TABLE `tx_masters`
  ADD CONSTRAINT FK_tx_masters_tx_controls FOREIGN KEY (tx_control_id) REFERENCES tx_controls (id),
  ADD CONSTRAINT FK_tx_masters_diagnosis_masters FOREIGN KEY (diagnosis_master_id) REFERENCES diagnosis_masters (id),
  ADD CONSTRAINT FK_tx_masters_participant FOREIGN KEY (participant_id) REFERENCES participants (id),
  ADD CONSTRAINT FK_tx_masters_protocol_masters FOREIGN KEY (protocol_master_id) REFERENCES protocol_masters (id);
