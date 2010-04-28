# This script was generated with mysqldiff. The other files are based on that one


#
# MySQLDiff 1.5.0
#
# http://www.mysqldiff.org
# (c) 2001-2004, Lippe-Net Online-Service
#
# Create time: 08.02.2010 09:25
#
# --------------------------------------------------------
# Source info
# Host: localhost
# Database: atim_old
# --------------------------------------------------------
# Target info
# Host: localhost
# Database: atim_new
# --------------------------------------------------------
#

SET FOREIGN_KEY_CHECKS = 0;

#
# DDL START
#
CREATE TABLE acos (
    id int(10) NOT NULL COMMENT '' auto_increment,
    parent_id int(10) NULL DEFAULT NULL COMMENT '',
    model varchar(255) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    foreign_key int(10) NULL DEFAULT NULL COMMENT '',
    alias varchar(255) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    lft int(10) NULL DEFAULT NULL COMMENT '',
    rght int(10) NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (id),
    INDEX acos_idx1 (lft, rght),
    INDEX acos_idx2 (alias),
    INDEX acos_idx3 (model, foreign_key)
)Engine=InnoDB CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE ad_bags (
    id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    aliquot_master_id int(11) NULL DEFAULT NULL COMMENT '',
    created datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    created_by varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NULL DEFAULT NULL COMMENT '',
    modified_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (id),
    INDEX FK_ad_bags_aliquot_masters (aliquot_master_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE ad_bags_revs (
    id int(11) NOT NULL DEFAULT 0 COMMENT '',
    aliquot_master_id int(11) NULL DEFAULT NULL COMMENT '',
    created datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    created_by varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NULL DEFAULT NULL COMMENT '',
    modified_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    version_id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    version_created datetime NOT NULL DEFAULT 0000-00-00 00:00:00 COMMENT '',
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (version_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE ad_blocks_revs (
    id int(11) NOT NULL DEFAULT 0 COMMENT '',
    aliquot_master_id int(11) NULL DEFAULT NULL COMMENT '',
    block_type varchar(30) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    patho_dpt_block_code varchar(30) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    created datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    created_by varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NULL DEFAULT NULL COMMENT '',
    modified_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    version_id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    version_created datetime NOT NULL DEFAULT 0000-00-00 00:00:00 COMMENT '',
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (version_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE ad_cell_cores_revs (
    id int(11) NOT NULL DEFAULT 0 COMMENT '',
    aliquot_master_id int(11) NULL DEFAULT NULL COMMENT '',
    gel_matrix_aliquot_master_id int(11) NULL DEFAULT NULL COMMENT '',
    created datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    created_by varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NULL DEFAULT NULL COMMENT '',
    modified_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    version_id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    version_created datetime NOT NULL DEFAULT 0000-00-00 00:00:00 COMMENT '',
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (version_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE ad_cell_slides_revs (
    id int(11) NOT NULL DEFAULT 0 COMMENT '',
    aliquot_master_id int(11) NULL DEFAULT NULL COMMENT '',
    immunochemistry varchar(30) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    created datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    created_by varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NULL DEFAULT NULL COMMENT '',
    modified_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    version_id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    version_created datetime NOT NULL DEFAULT 0000-00-00 00:00:00 COMMENT '',
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (version_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE ad_gel_matrices_revs (
    id int(11) NOT NULL DEFAULT 0 COMMENT '',
    aliquot_master_id int(11) NULL DEFAULT NULL COMMENT '',
    cell_count decimal(10,2) NULL DEFAULT NULL COMMENT '',
    cell_count_unit varchar(20) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    created datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    created_by varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NULL DEFAULT NULL COMMENT '',
    modified_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    version_id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    version_created datetime NOT NULL DEFAULT 0000-00-00 00:00:00 COMMENT '',
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (version_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE ad_tissue_cores_revs (
    id int(11) NOT NULL DEFAULT 0 COMMENT '',
    aliquot_master_id int(11) NULL DEFAULT NULL COMMENT '',
    block_aliquot_master_id int(11) NULL DEFAULT NULL COMMENT '',
    created datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    created_by varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NULL DEFAULT NULL COMMENT '',
    modified_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    version_id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    version_created datetime NOT NULL DEFAULT 0000-00-00 00:00:00 COMMENT '',
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (version_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE ad_tissue_slides_revs (
    id int(11) NOT NULL DEFAULT 0 COMMENT '',
    aliquot_master_id int(11) NULL DEFAULT NULL COMMENT '',
    immunochemistry varchar(30) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    block_aliquot_master_id int(11) NULL DEFAULT NULL COMMENT '',
    created datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    created_by varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NULL DEFAULT NULL COMMENT '',
    modified_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    version_id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    version_created datetime NOT NULL DEFAULT 0000-00-00 00:00:00 COMMENT '',
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (version_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE ad_tubes_revs (
    id int(11) NOT NULL DEFAULT 0 COMMENT '',
    aliquot_master_id int(11) NULL DEFAULT NULL COMMENT '',
    lot_number varchar(30) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    concentration decimal(10,2) NULL DEFAULT NULL COMMENT '',
    concentration_unit varchar(20) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    cell_count decimal(10,2) NULL DEFAULT NULL COMMENT '',
    cell_count_unit varchar(20) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    created datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    created_by varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NULL DEFAULT NULL COMMENT '',
    modified_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    version_id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    version_created datetime NOT NULL DEFAULT 0000-00-00 00:00:00 COMMENT '',
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (version_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE ad_whatman_papers_revs (
    id int(11) NOT NULL DEFAULT 0 COMMENT '',
    aliquot_master_id int(11) NULL DEFAULT NULL COMMENT '',
    used_blood_volume decimal(10,5) NULL DEFAULT NULL COMMENT '',
    used_blood_volume_unit varchar(20) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    created datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    created_by varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NULL DEFAULT NULL COMMENT '',
    modified_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    version_id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    version_created datetime NOT NULL DEFAULT 0000-00-00 00:00:00 COMMENT '',
    PRIMARY KEY (version_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE aliquot_masters_revs (
    id int(11) NOT NULL DEFAULT 0 COMMENT '',
    barcode varchar(60) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    aliquot_type varchar(30) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    aliquot_control_id int(11) NOT NULL DEFAULT '0' COMMENT '',
    collection_id int(11) NULL DEFAULT NULL COMMENT '',
    sample_master_id int(11) NULL DEFAULT NULL COMMENT '',
    sop_master_id int(11) NULL DEFAULT NULL COMMENT '',
    initial_volume decimal(10,5) NULL DEFAULT NULL COMMENT '',
    current_volume decimal(10,5) NULL DEFAULT NULL COMMENT '',
    aliquot_volume_unit varchar(20) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    in_stock varchar(30) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    in_stock_detail varchar(30) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    study_summary_id int(11) NULL DEFAULT NULL COMMENT '',
    storage_datetime datetime NULL DEFAULT NULL COMMENT '',
    storage_master_id int(11) NULL DEFAULT NULL COMMENT '',
    storage_coord_x varchar(11) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    coord_x_order int(3) NULL DEFAULT NULL COMMENT '',
    storage_coord_y varchar(11) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    coord_y_order int(3) NULL DEFAULT NULL COMMENT '',
    product_code varchar(20) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    notes text NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    created datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    created_by varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NULL DEFAULT NULL COMMENT '',
    modified_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    version_id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    version_created datetime NOT NULL DEFAULT 0000-00-00 00:00:00 COMMENT '',
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (version_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE aliquot_uses_revs (
    id int(11) NOT NULL DEFAULT 0 COMMENT '',
    aliquot_master_id int(11) NULL DEFAULT NULL COMMENT '',
    use_definition varchar(30) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    use_code varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    use_details varchar(250) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    use_recorded_into_table varchar(40) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    used_volume decimal(10,5) NULL DEFAULT NULL COMMENT '',
    use_datetime datetime NULL DEFAULT NULL COMMENT '',
    used_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    study_summary_id int(11) NULL DEFAULT NULL COMMENT '',
    created datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    created_by varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NULL DEFAULT NULL COMMENT '',
    modified_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    version_id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    version_created datetime NOT NULL DEFAULT 0000-00-00 00:00:00 COMMENT '',
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (version_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE aros (
    id int(10) NOT NULL COMMENT '' auto_increment,
    parent_id int(10) NULL DEFAULT NULL COMMENT '',
    model varchar(255) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    foreign_key int(10) NULL DEFAULT NULL COMMENT '',
    alias varchar(255) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    lft int(10) NULL DEFAULT NULL COMMENT '',
    rght int(10) NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (id),
    INDEX aros_idx1 (lft, rght),
    INDEX aros_idx2 (alias),
    INDEX aros_idx3 (model, foreign_key)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE aros_acos (
    id int(10) NOT NULL COMMENT '' auto_increment,
    aro_id int(10) NOT NULL DEFAULT 0 COMMENT '',
    aco_id int(10) NOT NULL DEFAULT 0 COMMENT '',
    _create varchar(2) NOT NULL DEFAULT '0' COMMENT '' COLLATE latin1_swedish_ci,
    _read varchar(2) NOT NULL DEFAULT '0' COMMENT '' COLLATE latin1_swedish_ci,
    _update varchar(2) NOT NULL DEFAULT '0' COMMENT '' COLLATE latin1_swedish_ci,
    _delete varchar(2) NOT NULL DEFAULT '0' COMMENT '' COLLATE latin1_swedish_ci,
    PRIMARY KEY (id),
    UNIQUE ARO_ACO_KEY (aro_id, aco_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE atim_information (
    id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    tablename varchar(255) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    field varchar(255) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    data_element_identifier varchar(225) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    datatype varchar(255) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    created datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    created_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    modified_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    PRIMARY KEY (id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE banks_revs (
    id int(11) NOT NULL DEFAULT 0 COMMENT '',
    name varchar(255) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    description text NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    created_by int(11) NOT NULL DEFAULT 0 COMMENT '',
    created datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    modified_by int(11) NOT NULL DEFAULT 0 COMMENT '',
    modified datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    version_id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    version_created datetime NOT NULL DEFAULT 0000-00-00 00:00:00 COMMENT '',
    PRIMARY KEY (version_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE cd_nationals (
    id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    consent_master_id int(11) NOT NULL DEFAULT 0 COMMENT '',
    created datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    created_by varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NULL DEFAULT NULL COMMENT '',
    modified_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (id),
    INDEX consent_master_id (consent_master_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE cd_nationals_revs (
    id int(11) NOT NULL DEFAULT 0 COMMENT '',
    consent_master_id int(11) NOT NULL DEFAULT 0 COMMENT '',
    created datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    created_by varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NULL DEFAULT NULL COMMENT '',
    modified_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    version_id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    version_created datetime NOT NULL DEFAULT 0000-00-00 00:00:00 COMMENT '',
    PRIMARY KEY (version_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE clinical_collection_links_revs (
    id int(11) NOT NULL DEFAULT 0 COMMENT '',
    participant_id int(11) NULL DEFAULT NULL COMMENT '',
    collection_id int(11) NULL DEFAULT NULL COMMENT '',
    diagnosis_master_id int(11) NULL DEFAULT NULL COMMENT '',
    consent_master_id int(11) NULL DEFAULT NULL COMMENT '',
    created datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    created_by varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    modified_by varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    version_id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    version_created datetime NOT NULL DEFAULT 0000-00-00 00:00:00 COMMENT '',
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (version_id),
    INDEX participant_id (participant_id),
    INDEX collection_id (collection_id),
    INDEX diagnosis_master_id (diagnosis_master_id),
    INDEX consent_master_id (consent_master_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE coding_adverse_events_revs (
    id int(11) NOT NULL DEFAULT 0 COMMENT '',
    category varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    `supra-ordinate_term` varchar(255) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    select_ae varchar(255) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    grade int(11) NOT NULL DEFAULT '0' COMMENT '',
    description text NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    created datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    created_by varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    modified_by varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    version_id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    version_created datetime NOT NULL DEFAULT 0000-00-00 00:00:00 COMMENT '',
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (version_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE collections_revs (
    id int(11) NOT NULL DEFAULT 0 COMMENT '',
    acquisition_label varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    bank_id int(11) NULL DEFAULT NULL COMMENT '',
    collection_site varchar(30) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    collection_datetime datetime NULL DEFAULT NULL COMMENT '',
    collection_datetime_accuracy varchar(4) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    sop_master_id int(11) NULL DEFAULT NULL COMMENT '',
    collection_property varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    collection_notes text NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    created datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    created_by varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NULL DEFAULT NULL COMMENT '',
    modified_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    version_id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    version_created datetime NOT NULL DEFAULT 0000-00-00 00:00:00 COMMENT '',
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (version_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE configs (
    id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    bank_id int(11) NULL DEFAULT NULL COMMENT '',
    group_id int(11) NULL DEFAULT NULL COMMENT '',
    user_id int(11) NULL DEFAULT NULL COMMENT '',
    config_debug varchar(255) NOT NULL DEFAULT '0' COMMENT '' COLLATE latin1_swedish_ci,
    config_language varchar(255) NOT NULL DEFAULT 'eng' COMMENT '' COLLATE latin1_swedish_ci,
    define_date_format varchar(255) NOT NULL DEFAULT 'MDY' COMMENT '' COLLATE latin1_swedish_ci,
    define_csv_separator varchar(255) NOT NULL DEFAULT ',' COMMENT '' COLLATE latin1_swedish_ci,
    define_show_help varchar(255) NOT NULL DEFAULT '1' COMMENT '' COLLATE latin1_swedish_ci,
    define_show_summary varchar(255) NOT NULL DEFAULT '1' COMMENT '' COLLATE latin1_swedish_ci,
    define_pagination_amount varchar(255) NOT NULL DEFAULT '10' COMMENT '' COLLATE latin1_swedish_ci,
    created datetime NOT NULL DEFAULT 0000-00-00 00:00:00 COMMENT '',
    created_by int(11) NOT NULL DEFAULT 0 COMMENT '',
    modified datetime NOT NULL DEFAULT 0000-00-00 00:00:00 COMMENT '',
    modified_by int(11) NOT NULL DEFAULT 0 COMMENT '',
    PRIMARY KEY (id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE consent_controls (
    id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    controls_type varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    status varchar(50) NOT NULL DEFAULT 'active' COMMENT '' COLLATE latin1_swedish_ci,
    form_alias varchar(255) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    detail_tablename varchar(255) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    display_order int(11) NOT NULL DEFAULT '0' COMMENT '',
    PRIMARY KEY (id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;


CREATE TABLE consent_masters_revs (
    id int(11) NOT NULL DEFAULT 0 COMMENT '',
    date_of_referral date NULL DEFAULT NULL COMMENT '',
    route_of_referral varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    date_first_contact date NULL DEFAULT NULL COMMENT '',
    consent_signed_date date NULL DEFAULT NULL COMMENT '',
    form_version varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    reason_denied varchar(200) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    consent_status varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    process_status varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    status_date date NULL DEFAULT NULL COMMENT '',
    surgeon varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    operation_date datetime NULL DEFAULT NULL COMMENT '',
    facility varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    notes text NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    consent_method varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    translator_indicator varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    translator_signature varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    consent_person varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    facility_other varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    consent_master_id int(11) NULL DEFAULT NULL COMMENT '',
    acquisition_id varchar(10) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    participant_id int(11) NOT NULL DEFAULT '0' COMMENT '',
    consent_control_id int(11) NOT NULL DEFAULT 0 COMMENT '',
    type varchar(10) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    created datetime NULL DEFAULT NULL COMMENT '',
    created_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NULL DEFAULT NULL COMMENT '',
    modified_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    version_id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    version_created datetime NOT NULL DEFAULT 0000-00-00 00:00:00 COMMENT '',
    PRIMARY KEY (version_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE derivative_details_revs (
    id int(11) NOT NULL DEFAULT 0 COMMENT '',
    sample_master_id int(11) NULL DEFAULT NULL COMMENT '',
    creation_site varchar(30) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    creation_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    creation_datetime datetime NULL DEFAULT NULL COMMENT '',
    created datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    created_by varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NULL DEFAULT NULL COMMENT '',
    modified_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    version_id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    version_created datetime NOT NULL DEFAULT 0000-00-00 00:00:00 COMMENT '',
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (version_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE diagnosis_controls (
    id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    controls_type varchar(6) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    status varchar(50) NOT NULL DEFAULT 'active' COMMENT '' COLLATE latin1_swedish_ci,
    form_alias varchar(255) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    detail_tablename varchar(255) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    display_order int(11) NOT NULL DEFAULT '0' COMMENT '',
    PRIMARY KEY (id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE diagnosis_masters_revs (
    id int(11) NOT NULL DEFAULT 0 COMMENT '',
    dx_identifier varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    primary_number int(11) NULL DEFAULT NULL COMMENT '',
    dx_method varchar(20) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    dx_nature varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    dx_origin varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    dx_date date NULL DEFAULT NULL COMMENT '',
    dx_date_accuracy varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    primary_icd10_code varchar(10) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    previous_primary_code varchar(10) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    previous_primary_code_system varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    morphology varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    topography varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    tumour_grade varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    age_at_dx int(11) NULL DEFAULT NULL COMMENT '',
    age_at_dx_accuracy varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    ajcc_edition varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    collaborative_staged varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    clinical_tstage varchar(5) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    clinical_nstage varchar(5) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    clinical_mstage varchar(5) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    clinical_stage_summary varchar(5) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    path_tstage varchar(5) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    path_nstage varchar(5) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    path_mstage varchar(5) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    path_stage_summary varchar(5) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    survival_time_months int(11) NULL DEFAULT NULL COMMENT '',
    information_source varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    notes text NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    diagnosis_control_id int(11) NOT NULL DEFAULT '0' COMMENT '',
    participant_id int(11) NOT NULL DEFAULT '0' COMMENT '',
    created datetime NULL DEFAULT NULL COMMENT '',
    created_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NULL DEFAULT NULL COMMENT '',
    modified_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    version_id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    version_created datetime NOT NULL DEFAULT 0000-00-00 00:00:00 COMMENT '',
    PRIMARY KEY (version_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE drugs_revs (
    id int(11) NOT NULL DEFAULT 0 COMMENT '',
    generic_name varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    trade_name varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    type varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    description text NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    created datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    created_by int(11) NOT NULL DEFAULT '0' COMMENT '',
    modified datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    modified_by int(11) NOT NULL DEFAULT '0' COMMENT '',
    version_id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    version_created datetime NOT NULL DEFAULT 0000-00-00 00:00:00 COMMENT '',
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (version_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE dxd_bloods (
    id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    diagnosis_master_id int(11) NOT NULL DEFAULT '0' COMMENT '',
    text_field varchar(10) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    created datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    created_by varchar(255) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    modified_by varchar(255) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    deleted int(11) NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (id),
    INDEX diagnosis_master_id (diagnosis_master_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE dxd_bloods_revs (
    id int(11) NOT NULL DEFAULT 0 COMMENT '',
    diagnosis_master_id int(11) NOT NULL DEFAULT '0' COMMENT '',
    text_field varchar(10) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    created datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    created_by varchar(255) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    modified_by varchar(255) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    deleted int(11) NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    version_id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    version_created datetime NOT NULL DEFAULT 0000-00-00 00:00:00 COMMENT '',
    PRIMARY KEY (version_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE dxd_tissues (
    id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    diagnosis_master_id int(11) NOT NULL DEFAULT '0' COMMENT '',
    text_field varchar(10) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    created datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    created_by varchar(255) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    modified_by varchar(255) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    deleted int(11) NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (id),
    INDEX diagnosis_master_id (diagnosis_master_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE dxd_tissues_revs (
    id int(11) NOT NULL DEFAULT 0 COMMENT '',
    diagnosis_master_id int(11) NOT NULL DEFAULT '0' COMMENT '',
    text_field varchar(10) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    created datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    created_by varchar(255) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    modified_by varchar(255) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    deleted int(11) NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    version_id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    version_created datetime NOT NULL DEFAULT 0000-00-00 00:00:00 COMMENT '',
    PRIMARY KEY (version_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE ed_all_adverse_events_adverse_event_revs (
    id int(11) NOT NULL DEFAULT 0 COMMENT '',
    supra_ordinate_term varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    select_ae varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    grade varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    description varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    created datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    created_by varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    modified_by varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    event_master_id int(11) NULL DEFAULT NULL COMMENT '',
    version_id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    version_created datetime NOT NULL DEFAULT 0000-00-00 00:00:00 COMMENT '',
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (version_id),
    INDEX event_master_id (event_master_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE ed_all_clinical_followup_revs (
    id int(11) NOT NULL DEFAULT 0 COMMENT '',
    weight int(11) NULL DEFAULT NULL COMMENT '',
    recurrence_status varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    disease_status varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    vital_status varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    created date NOT NULL DEFAULT '0000-00-00' COMMENT '',
    created_by varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    modified date NOT NULL DEFAULT '0000-00-00' COMMENT '',
    modified_by varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    event_master_id int(11) NULL DEFAULT NULL COMMENT '',
    version_id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    version_created datetime NOT NULL DEFAULT 0000-00-00 00:00:00 COMMENT '',
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (version_id),
    INDEX event_master_id (event_master_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE ed_all_clinical_presentation_revs (
    id int(11) NOT NULL DEFAULT 0 COMMENT '',
    weight int(11) NULL DEFAULT NULL COMMENT '',
    height int(11) NULL DEFAULT NULL COMMENT '',
    created date NULL DEFAULT NULL COMMENT '',
    created_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    modified date NULL DEFAULT NULL COMMENT '',
    modified_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    event_master_id int(11) NULL DEFAULT NULL COMMENT '',
    version_id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    version_created datetime NOT NULL DEFAULT 0000-00-00 00:00:00 COMMENT '',
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (version_id),
    INDEX event_master_id (event_master_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE ed_all_lifestyle_base_revs (
    id int(11) NOT NULL DEFAULT 0 COMMENT '',
    smoking_history varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    smoking_status varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    pack_years date NULL DEFAULT NULL COMMENT '',
    product_used varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    years_quit_smoking int(11) NULL DEFAULT NULL COMMENT '',
    alcohol_history varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    weight_loss float NULL DEFAULT NULL COMMENT '',
    created datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    created_by varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    modified_by varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    event_master_id int(11) NULL DEFAULT NULL COMMENT '',
    version_id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    version_created datetime NOT NULL DEFAULT 0000-00-00 00:00:00 COMMENT '',
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (version_id),
    INDEX event_master_id (event_master_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE ed_all_protocol_followup_revs (
    id int(11) NOT NULL DEFAULT 0 COMMENT '',
    title varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    created datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    created_by varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    modified_by varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    event_master_id int(11) NULL DEFAULT NULL COMMENT '',
    version_id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    version_created datetime NOT NULL DEFAULT 0000-00-00 00:00:00 COMMENT '',
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (version_id),
    INDEX event_master_id (event_master_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE ed_all_study_research_revs (
    id int(11) NOT NULL DEFAULT 0 COMMENT '',
    field_one varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    field_two varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    field_three varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    event_master_id int(11) NULL DEFAULT NULL COMMENT '',
    created datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    created_by varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    modified_by varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    version_id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    version_created datetime NOT NULL DEFAULT 0000-00-00 00:00:00 COMMENT '',
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (version_id),
    INDEX event_master_id (event_master_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE ed_allsolid_lab_pathology_revs (
    id int(11) NOT NULL DEFAULT 0 COMMENT '',
    tumour_type varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    resection_margin varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    extra_nodal_invasion varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    lymphatic_vascular_invasion varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    in_situ_component varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    fine_needle_aspirate varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    trucut_core_biopsy varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    open_biopsy varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    frozen_section varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    breast_tumour_size varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    nodes_removed varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    nodes_positive varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    created date NOT NULL DEFAULT '0000-00-00' COMMENT '',
    created_by varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    modified date NOT NULL DEFAULT '0000-00-00' COMMENT '',
    modified_by varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    event_master_id int(11) NULL DEFAULT NULL COMMENT '',
    version_id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    version_created datetime NOT NULL DEFAULT 0000-00-00 00:00:00 COMMENT '',
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (version_id),
    INDEX event_master_id (event_master_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE ed_breast_lab_pathology_revs (
    id int(11) NOT NULL DEFAULT 0 COMMENT '',
    path_number varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    report_type varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    facility varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    vascular_lymph_invasion varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    extra_nodal_invasion varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    blood_lymph varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    tumour_type varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    grade varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    multifocal varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    preneoplastic_changes varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    spread_skin_nipple varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    level_nodal_involvement varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    frozen_section varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    er_assay_ligand varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    pr_assay_ligand varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    progesterone varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    estrogen varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    number_resected varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    number_positive varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    nodal_status varchar(45) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    resection_margins varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    tumour_size varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    tumour_total_size varchar(45) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    sentinel_only varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    in_situ_type varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    her2_grade varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    her2_method varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    mb_collectionid varchar(45) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    created date NOT NULL DEFAULT '0000-00-00' COMMENT '',
    created_by varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    modified date NOT NULL DEFAULT '0000-00-00' COMMENT '',
    modified_by varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    event_master_id int(11) NULL DEFAULT NULL COMMENT '',
    version_id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    version_created datetime NOT NULL DEFAULT 0000-00-00 00:00:00 COMMENT '',
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (version_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE ed_breast_screening_mammogram_revs (
    id int(11) NOT NULL DEFAULT 0 COMMENT '',
    result varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    created datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    created_by varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    modified_by varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    event_master_id int(11) NULL DEFAULT NULL COMMENT '',
    version_id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    version_created datetime NOT NULL DEFAULT 0000-00-00 00:00:00 COMMENT '',
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (version_id),
    INDEX event_master_id (event_master_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE event_masters_revs (
    id int(11) NOT NULL DEFAULT 0 COMMENT '',
    event_control_id int(11) NOT NULL DEFAULT '0' COMMENT '',
    disease_site varchar(255) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    event_group varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    event_type varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    event_status varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    event_summary text NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    event_date date NULL DEFAULT NULL COMMENT '',
    information_source varchar(255) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    urgency varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    date_required date NULL DEFAULT NULL COMMENT '',
    date_requested date NULL DEFAULT NULL COMMENT '',
    reference_number int(11) NULL DEFAULT NULL COMMENT '',
    created datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    created_by varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    modified_by varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    participant_id int(11) NULL DEFAULT NULL COMMENT '',
    diagnosis_master_id int(11) NULL DEFAULT NULL COMMENT '',
    version_id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    version_created datetime NOT NULL DEFAULT 0000-00-00 00:00:00 COMMENT '',
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (version_id),
    INDEX participant_id (participant_id),
    INDEX diagnosis_id (diagnosis_master_id),
    INDEX event_control_id (event_control_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE family_histories_revs (
    id int(11) NOT NULL DEFAULT 0 COMMENT '',
    relation varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    family_domain varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    primary_icd10_code varchar(10) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    previous_primary_code varchar(10) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    previous_primary_code_system varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    age_at_dx smallint(6) NULL DEFAULT NULL COMMENT '',
    age_at_dx_accuracy varchar(100) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    participant_id int(11) NULL DEFAULT NULL COMMENT '',
    created datetime NULL DEFAULT NULL COMMENT '',
    created_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NULL DEFAULT NULL COMMENT '',
    modified_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    version_id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    version_created datetime NOT NULL DEFAULT 0000-00-00 00:00:00 COMMENT '',
    PRIMARY KEY (version_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE materials_revs (
    id int(11) NOT NULL DEFAULT 0 COMMENT '',
    item_name varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    item_type varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    description varchar(255) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    created datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    created_by varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    modified_by varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    version_id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    version_created datetime NOT NULL DEFAULT 0000-00-00 00:00:00 COMMENT '',
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (version_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE misc_identifier_controls (
    id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    misc_identifier_name varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    misc_identifier_name_abbrev varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    status varchar(50) NOT NULL DEFAULT 'active' COMMENT '' COLLATE latin1_swedish_ci,
    autoincrement_name varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    display_order int(11) NOT NULL DEFAULT '0' COMMENT '',
    misc_identifier_value varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    PRIMARY KEY (id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE misc_identifiers_revs (
    id int(11) NOT NULL DEFAULT 0 COMMENT '',
    identifier_value varchar(40) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    identifier_name varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    identifier_abrv varchar(20) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    effective_date date NULL DEFAULT NULL COMMENT '',
    expiry_date date NULL DEFAULT NULL COMMENT '',
    notes varchar(100) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    participant_id int(11) NULL DEFAULT NULL COMMENT '',
    created datetime NULL DEFAULT NULL COMMENT '',
    created_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NULL DEFAULT NULL COMMENT '',
    modified_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    version_id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    version_created datetime NOT NULL DEFAULT 0000-00-00 00:00:00 COMMENT '',
    PRIMARY KEY (version_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE order_items_revs (
    id int(11) NOT NULL DEFAULT 0 COMMENT '',
    date_added date NULL DEFAULT NULL COMMENT '',
    added_by varchar(255) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    status varchar(255) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    created date NULL DEFAULT NULL COMMENT '',
    created_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    modified date NULL DEFAULT NULL COMMENT '',
    modified_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    order_line_id int(11) NULL DEFAULT NULL COMMENT '',
    shipment_id int(11) NULL DEFAULT NULL COMMENT '',
    aliquot_master_id int(11) NULL DEFAULT NULL COMMENT '',
    aliquot_use_id int(11) NULL DEFAULT NULL COMMENT '',
    version_id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    version_created datetime NOT NULL DEFAULT 0000-00-00 00:00:00 COMMENT '',
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (version_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE order_lines_revs (
    id int(11) NOT NULL DEFAULT 0 COMMENT '',
    quantity_ordered varchar(30) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    min_quantity_ordered varchar(30) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    quantity_unit varchar(10) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    date_required date NULL DEFAULT NULL COMMENT '',
    status varchar(255) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    created datetime NULL DEFAULT NULL COMMENT '',
    created_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NULL DEFAULT NULL COMMENT '',
    modified_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    product_code varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    sample_control_id int(11) NULL DEFAULT NULL COMMENT '',
    aliquot_control_id int(11) NULL DEFAULT NULL COMMENT '',
    sample_aliquot_precision varchar(30) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    order_id int(11) NOT NULL DEFAULT 0 COMMENT '',
    version_id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    version_created datetime NOT NULL DEFAULT 0000-00-00 00:00:00 COMMENT '',
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (version_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE orders_revs (
    id int(11) NOT NULL DEFAULT 0 COMMENT '',
    order_number varchar(255) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    short_title varchar(45) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    description varchar(255) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    date_order_placed date NULL DEFAULT NULL COMMENT '',
    date_order_completed date NULL DEFAULT NULL COMMENT '',
    processing_status varchar(45) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    comments varchar(255) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    created datetime NULL DEFAULT NULL COMMENT '',
    created_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NULL DEFAULT NULL COMMENT '',
    modified_by varchar(45) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    study_summary_id int(11) NULL DEFAULT NULL COMMENT '',
    version_id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    version_created datetime NOT NULL DEFAULT 0000-00-00 00:00:00 COMMENT '',
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (version_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE parent_to_derivative_sample_controls (
    id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    parent_sample_control_id int(11) NULL DEFAULT NULL COMMENT '',
    derivative_sample_control_id int(11) NULL DEFAULT NULL COMMENT '',
    status varchar(20) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    PRIMARY KEY (id),
    UNIQUE parent_to_derivative_sample (parent_sample_control_id, derivative_sample_control_id),
    INDEX FK_parent_to_derivative_sample_controls_derivative (derivative_sample_control_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE participant_contacts_revs (
    id int(11) NOT NULL DEFAULT 0 COMMENT '',
    contact_name varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    contact_type varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    other_contact_type varchar(100) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    effective_date date NULL DEFAULT NULL COMMENT '',
    expiry_date date NULL DEFAULT NULL COMMENT '',
    notes text NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    street varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    locality varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    region varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    country varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    mail_code varchar(10) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    phone varchar(15) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    phone_type varchar(15) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    phone_secondary varchar(15) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    phone_secondary_type varchar(15) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    created datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    created_by varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    modified_by varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    participant_id int(11) NULL DEFAULT NULL COMMENT '',
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    version_id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    version_created datetime NOT NULL DEFAULT 0000-00-00 00:00:00 COMMENT '',
    PRIMARY KEY (version_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE participant_messages_revs (
    id int(11) NOT NULL DEFAULT 0 COMMENT '',
    date_requested date NULL DEFAULT NULL COMMENT '',
    author varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    message_type varchar(20) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    title varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    description text NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    due_date datetime NULL DEFAULT NULL COMMENT '',
    expiry_date date NULL DEFAULT NULL COMMENT '',
    participant_id int(11) NULL DEFAULT NULL COMMENT '',
    created datetime NULL DEFAULT NULL COMMENT '',
    created_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NULL DEFAULT NULL COMMENT '',
    modified_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    version_id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    version_created datetime NOT NULL DEFAULT 0000-00-00 00:00:00 COMMENT '',
    PRIMARY KEY (version_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE participants_revs (
    id int(11) NOT NULL DEFAULT 0 COMMENT '',
    title varchar(10) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    first_name varchar(20) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    middle_name varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    last_name varchar(20) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    date_of_birth date NULL DEFAULT NULL COMMENT '',
    dob_date_accuracy varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    marital_status varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    language_preferred varchar(30) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    sex varchar(20) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    race varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    vital_status varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    notes text NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    date_of_death date NULL DEFAULT NULL COMMENT '',
    dod_date_accuracy varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    cod_icd10_code varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    secondary_cod_icd10_code varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    cod_confirmation_source varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    participant_identifier varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    last_chart_checked_date date NULL DEFAULT NULL COMMENT '',
    created datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    created_by varchar(255) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    modified_by varchar(255) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    version_id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    version_created datetime NOT NULL DEFAULT 0000-00-00 00:00:00 COMMENT '',
    PRIMARY KEY (version_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE path_collection_reviews_revs (
    id int(11) NOT NULL DEFAULT 0 COMMENT '',
    path_coll_rev_code varchar(20) NOT NULL DEFAULT '0' COMMENT '' COLLATE latin1_swedish_ci,
    collection_id int(11) NULL DEFAULT NULL COMMENT '',
    sample_master_id int(11) NULL DEFAULT NULL COMMENT '',
    aliquot_master_id int(11) NULL DEFAULT NULL COMMENT '',
    review_date date NOT NULL DEFAULT '0000-00-00' COMMENT '',
    review_status varchar(20) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    pathologist varchar(30) NULL DEFAULT '0' COMMENT '' COLLATE latin1_swedish_ci,
    tumour_type varchar(50) NULL DEFAULT '0' COMMENT '' COLLATE latin1_swedish_ci,
    comments text NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    tumour_gradecategory varchar(10) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    tumour_grade_based_on_sample_master_id int(11) NULL DEFAULT '0' COMMENT '',
    tumour_grade_score_tubules decimal(5,1) NULL DEFAULT NULL COMMENT '',
    tumour_grade_score_nuclei decimal(5,1) NULL DEFAULT NULL COMMENT '',
    tumour_grade_score_nuclear decimal(5,1) NULL DEFAULT NULL COMMENT '',
    tumour_grade_score_mitosis decimal(5,1) NULL DEFAULT NULL COMMENT '',
    tumour_grade_score_architecture decimal(5,1) NULL DEFAULT NULL COMMENT '',
    tumour_grade_score_total decimal(5,1) NULL DEFAULT '0.0' COMMENT '',
    created datetime NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    created_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NULL DEFAULT NULL COMMENT '',
    modified_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    version_id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    version_created datetime NOT NULL DEFAULT 0000-00-00 00:00:00 COMMENT '',
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (version_id),
    INDEX collection_id (collection_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE pd_chemos_revs (
    id int(11) NOT NULL DEFAULT 0 COMMENT '',
    created date NOT NULL DEFAULT '0000-00-00' COMMENT '',
    created_by varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    modified date NOT NULL DEFAULT '0000-00-00' COMMENT '',
    modified_by varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    protocol_master_id int(11) NULL DEFAULT NULL COMMENT '',
    version_id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    version_created datetime NOT NULL DEFAULT 0000-00-00 00:00:00 COMMENT '',
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (version_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE pe_chemos_revs (
    id int(11) NOT NULL DEFAULT 0 COMMENT '',
    method varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    dose varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    frequency varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    created datetime NULL DEFAULT NULL COMMENT '',
    created_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NULL DEFAULT NULL COMMENT '',
    modified_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    protocol_master_id int(11) NULL DEFAULT NULL COMMENT '',
    drug_id int(11) NULL DEFAULT NULL COMMENT '',
    version_id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    version_created datetime NOT NULL DEFAULT 0000-00-00 00:00:00 COMMENT '',
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (version_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE protocol_masters_revs (
    id int(11) NOT NULL DEFAULT 0 COMMENT '',
    protocol_control_id int(11) NOT NULL DEFAULT '0' COMMENT '',
    name varchar(255) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    notes text NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    code varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    arm varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    tumour_group varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    type varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    status varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    expiry date NULL DEFAULT NULL COMMENT '',
    activated date NULL DEFAULT NULL COMMENT '',
    created date NULL DEFAULT NULL COMMENT '',
    created_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    modified date NULL DEFAULT NULL COMMENT '',
    modified_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    form_id int(11) NULL DEFAULT NULL COMMENT '',
    version_id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    version_created datetime NOT NULL DEFAULT 0000-00-00 00:00:00 COMMENT '',
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (version_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE providers (
    id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    name varchar(55) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    type varchar(55) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    date_effective datetime NULL DEFAULT NULL COMMENT '',
    date_expiry datetime NULL DEFAULT NULL COMMENT '',
    active varchar(55) NOT NULL DEFAULT 'yes' COMMENT '' COLLATE latin1_swedish_ci,
    description text NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    created datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    created_by varchar(255) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    modified_by varchar(255) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE providers_revs (
    id int(11) NOT NULL DEFAULT 0 COMMENT '',
    name varchar(55) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    type varchar(55) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    date_effective datetime NULL DEFAULT NULL COMMENT '',
    date_expiry datetime NULL DEFAULT NULL COMMENT '',
    active varchar(55) NOT NULL DEFAULT 'yes' COMMENT '' COLLATE latin1_swedish_ci,
    description text NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    created datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    created_by varchar(255) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    modified_by varchar(255) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    version_id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    version_created datetime NOT NULL DEFAULT 0000-00-00 00:00:00 COMMENT '',
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (version_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE quality_ctrl_tested_aliquots_revs (
    id int(11) NOT NULL DEFAULT 0 COMMENT '',
    quality_ctrl_id int(11) NULL DEFAULT NULL COMMENT '',
    aliquot_master_id int(11) NULL DEFAULT NULL COMMENT '',
    aliquot_use_id int(11) NULL DEFAULT NULL COMMENT '',
    created datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    created_by varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NULL DEFAULT NULL COMMENT '',
    modified_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    version_id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    version_created datetime NOT NULL DEFAULT 0000-00-00 00:00:00 COMMENT '',
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (version_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE quality_ctrls_revs (
    id int(11) NOT NULL DEFAULT 0 COMMENT '',
    qc_code varchar(20) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    sample_master_id int(11) NULL DEFAULT NULL COMMENT '',
    type varchar(30) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    tool varchar(30) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    run_id varchar(30) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    run_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    `date` date NULL DEFAULT NULL COMMENT '',
    score varchar(30) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    unit varchar(30) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    conclusion varchar(30) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    notes text NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    created datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    created_by varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NULL DEFAULT NULL COMMENT '',
    modified_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    version_id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    version_created datetime NOT NULL DEFAULT 0000-00-00 00:00:00 COMMENT '',
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (version_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE rd_blood_cells_revs (
    id int(11) NOT NULL DEFAULT 0 COMMENT '',
    review_master_id int(11) NULL DEFAULT NULL COMMENT '',
    mmt varchar(10) NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    fish decimal(6,2) NULL DEFAULT NULL COMMENT '',
    zap70 decimal(6,2) NULL DEFAULT NULL COMMENT '',
    nq01 varchar(10) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    cd38 decimal(6,2) NULL DEFAULT NULL COMMENT '',
    created datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    created_by varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    modified_by varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    version_id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    version_created datetime NOT NULL DEFAULT 0000-00-00 00:00:00 COMMENT '',
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (version_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE rd_bloodcellcounts_revs (
    id int(11) NOT NULL DEFAULT 0 COMMENT '',
    review_master_id int(11) NULL DEFAULT NULL COMMENT '',
    count_start_time time NULL DEFAULT NULL COMMENT '',
    wbc_tl_square int(5) NULL DEFAULT NULL COMMENT '',
    wbc_tr_square int(5) NULL DEFAULT NULL COMMENT '',
    wbc_bl_square int(5) NULL DEFAULT NULL COMMENT '',
    wbc_br_square int(5) NULL DEFAULT NULL COMMENT '',
    rbc_tl_square int(5) NULL DEFAULT NULL COMMENT '',
    rbc_tr_square int(5) NULL DEFAULT NULL COMMENT '',
    rbc_bl_square int(5) NULL DEFAULT NULL COMMENT '',
    rbc_br_square int(5) NULL DEFAULT NULL COMMENT '',
    rbc_mid_square int(5) NULL DEFAULT NULL COMMENT '',
    created datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    created_by varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NULL DEFAULT NULL COMMENT '',
    modified_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    version_id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    version_created datetime NOT NULL DEFAULT 0000-00-00 00:00:00 COMMENT '',
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (version_id),
    INDEX review_master_id (review_master_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE rd_breast_cancers_revs (
    id int(11) NOT NULL DEFAULT 0 COMMENT '',
    review_master_id int(11) NULL DEFAULT NULL COMMENT '',
    tumour_type_id int(11) NULL DEFAULT NULL COMMENT '',
    invasive_percentage decimal(5,1) NOT NULL DEFAULT '0.0' COMMENT '',
    in_situ_percentage decimal(5,1) NOT NULL DEFAULT '0.0' COMMENT '',
    normal_percentage decimal(5,1) NOT NULL DEFAULT '0.0' COMMENT '',
    stroma_percentage decimal(5,1) NOT NULL DEFAULT '0.0' COMMENT '',
    necrosis_inv_percentage decimal(5,1) NOT NULL DEFAULT '0.0' COMMENT '',
    necrosis_is_percentage decimal(5,1) NOT NULL DEFAULT '0.0' COMMENT '',
    fat_percentage decimal(5,1) NOT NULL DEFAULT '0.0' COMMENT '',
    inflammation tinyint(4) NOT NULL DEFAULT '0' COMMENT '',
    quality_score tinyint(4) NOT NULL DEFAULT '0' COMMENT '',
    created datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    created_by varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    modified_by varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    version_id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    version_created datetime NOT NULL DEFAULT 0000-00-00 00:00:00 COMMENT '',
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (version_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE rd_breastcancertypes_revs (
    id int(11) NOT NULL DEFAULT 0 COMMENT '',
    review_master_id int(11) NULL DEFAULT NULL COMMENT '',
    invasive_percentage decimal(5,1) NULL DEFAULT NULL COMMENT '',
    in_situ_percentage decimal(5,1) NULL DEFAULT NULL COMMENT '',
    normal_percentage decimal(5,1) NULL DEFAULT NULL COMMENT '',
    stroma_percentage decimal(5,1) NULL DEFAULT NULL COMMENT '',
    necrosis_inv_percentage decimal(5,1) NULL DEFAULT NULL COMMENT '',
    necrosis_is_percentage decimal(5,1) NULL DEFAULT NULL COMMENT '',
    inflammation tinyint(4) NULL DEFAULT NULL COMMENT '',
    quality_score tinyint(4) NULL DEFAULT NULL COMMENT '',
    created datetime NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    created_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NULL DEFAULT NULL COMMENT '',
    modified_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    version_id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    version_created datetime NOT NULL DEFAULT 0000-00-00 00:00:00 COMMENT '',
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (version_id),
    INDEX review_master_id (review_master_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE rd_coloncancertypes_revs (
    id int(11) NOT NULL DEFAULT 0 COMMENT '',
    review_master_id int(11) NULL DEFAULT NULL COMMENT '',
    invasive_percentage decimal(5,1) NULL DEFAULT NULL COMMENT '',
    in_situ_percentage decimal(5,1) NULL DEFAULT NULL COMMENT '',
    normal_percentage decimal(5,1) NULL DEFAULT NULL COMMENT '',
    stroma_percentage decimal(5,1) NULL DEFAULT NULL COMMENT '',
    necrosis_percentage decimal(5,1) NULL DEFAULT NULL COMMENT '',
    inflammation tinyint(4) NULL DEFAULT NULL COMMENT '',
    quality_score tinyint(4) NULL DEFAULT NULL COMMENT '',
    created datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    created_by varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NULL DEFAULT NULL COMMENT '',
    modified_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    version_id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    version_created datetime NOT NULL DEFAULT 0000-00-00 00:00:00 COMMENT '',
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (version_id),
    INDEX review_master_id (review_master_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE rd_genericcancertypes_revs (
    id int(11) NOT NULL DEFAULT 0 COMMENT '',
    review_master_id int(11) NULL DEFAULT NULL COMMENT '',
    invasive_percentage decimal(5,1) NULL DEFAULT NULL COMMENT '',
    in_situ_percentage decimal(5,1) NULL DEFAULT NULL COMMENT '',
    normal_percentage decimal(5,1) NULL DEFAULT NULL COMMENT '',
    stroma_percentage decimal(5,1) NULL DEFAULT NULL COMMENT '',
    necrosis_percentage decimal(5,1) NULL DEFAULT NULL COMMENT '',
    inflammation tinyint(4) NULL DEFAULT NULL COMMENT '',
    quality_score tinyint(4) NULL DEFAULT NULL COMMENT '',
    created datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    created_by varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NULL DEFAULT NULL COMMENT '',
    modified_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    version_id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    version_created datetime NOT NULL DEFAULT 0000-00-00 00:00:00 COMMENT '',
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (version_id),
    INDEX review_master_id (review_master_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE rd_ovarianuteruscancertypes_revs (
    id int(11) NOT NULL DEFAULT 0 COMMENT '',
    review_master_id int(11) NULL DEFAULT NULL COMMENT '',
    invasive_percentage decimal(5,1) NULL DEFAULT NULL COMMENT '',
    normal_percentage decimal(5,1) NULL DEFAULT NULL COMMENT '',
    stroma_percentage decimal(5,1) NULL DEFAULT NULL COMMENT '',
    necrosis_percentage decimal(5,1) NULL DEFAULT NULL COMMENT '',
    inflammation tinyint(4) NULL DEFAULT NULL COMMENT '',
    quality_score tinyint(4) NULL DEFAULT NULL COMMENT '',
    created datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    created_by varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NULL DEFAULT NULL COMMENT '',
    modified_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    version_id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    version_created datetime NOT NULL DEFAULT 0000-00-00 00:00:00 COMMENT '',
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (version_id),
    INDEX review_master_id (review_master_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE realiquotings_revs (
    id int(11) NOT NULL DEFAULT 0 COMMENT '',
    parent_aliquot_master_id int(11) NULL DEFAULT NULL COMMENT '',
    child_aliquot_master_id int(11) NULL DEFAULT NULL COMMENT '',
    aliquot_use_id int(11) NULL DEFAULT NULL COMMENT '',
    created datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    created_by varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NULL DEFAULT NULL COMMENT '',
    modified_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    version_id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    version_created datetime NOT NULL DEFAULT 0000-00-00 00:00:00 COMMENT '',
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (version_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE reproductive_histories_revs (
    id int(11) NOT NULL DEFAULT 0 COMMENT '',
    date_captured date NULL DEFAULT NULL COMMENT '',
    menopause_status varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    menopause_onset_reason varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    age_at_menopause int(11) NULL DEFAULT NULL COMMENT '',
    menopause_age_accuracy varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    age_at_menarche int(11) NULL DEFAULT NULL COMMENT '',
    age_at_menarche_accuracy varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    hrt_years_used int(11) NULL DEFAULT NULL COMMENT '',
    hrt_use varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    hysterectomy_age int(11) NULL DEFAULT NULL COMMENT '',
    hysterectomy_age_accuracy varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    hysterectomy varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    ovary_removed_type varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    gravida int(11) NULL DEFAULT NULL COMMENT '',
    para int(11) NULL DEFAULT NULL COMMENT '',
    age_at_first_parturition int(11) NULL DEFAULT NULL COMMENT '',
    first_parturition_accuracy varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    age_at_last_parturition int(11) NULL DEFAULT NULL COMMENT '',
    last_parturition_accuracy varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    hormonal_contraceptive_use varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    years_on_hormonal_contraceptives int(11) NULL DEFAULT NULL COMMENT '',
    lnmp_date date NULL DEFAULT NULL COMMENT '',
    lnmp_accuracy varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    participant_id int(11) NULL DEFAULT NULL COMMENT '',
    created datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    created_by varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NULL DEFAULT NULL COMMENT '',
    modified_by varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    version_id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    version_created datetime NOT NULL DEFAULT 0000-00-00 00:00:00 COMMENT '',
    PRIMARY KEY (version_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE review_masters_revs (
    id int(11) NOT NULL DEFAULT 0 COMMENT '',
    review_control_id int(11) NOT NULL DEFAULT '0' COMMENT '',
    collection_id int(11) NULL DEFAULT NULL COMMENT '',
    sample_master_id int(11) NULL DEFAULT NULL COMMENT '',
    review_type varchar(30) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    review_sample_group varchar(30) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    review_date date NOT NULL DEFAULT '0000-00-00' COMMENT '',
    review_status varchar(20) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    pathologist varchar(50) NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    comments text NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    created datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    created_by varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NULL DEFAULT NULL COMMENT '',
    modified_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    version_id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    version_created datetime NOT NULL DEFAULT 0000-00-00 00:00:00 COMMENT '',
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (version_id),
    UNIQUE version_id (version_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE rtbforms_revs (
    id smallint(5) unsigned NOT NULL DEFAULT '' COMMENT '',
    frmTitle varchar(200) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    frmVersion float NOT NULL DEFAULT '0' COMMENT '',
    frmCategory varchar(30) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    frmFileLocation blob NULL DEFAULT NULL COMMENT '',
    frmFileType varchar(40) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    frmFileViewer blob NULL DEFAULT NULL COMMENT '',
    frmStatus varchar(30) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    frmCreated date NULL DEFAULT NULL COMMENT '',
    frmGroup varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    created datetime NULL DEFAULT NULL COMMENT '',
    created_by int(11) NULL DEFAULT NULL COMMENT '',
    modified datetime NULL DEFAULT NULL COMMENT '',
    modified_by int(11) NULL DEFAULT NULL COMMENT '',
    version_id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    version_created datetime NOT NULL DEFAULT 0000-00-00 00:00:00 COMMENT '',
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (version_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE sample_masters_revs (
    id int(11) NOT NULL DEFAULT 0 COMMENT '',
    sample_code varchar(30) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    sample_category varchar(30) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    sample_control_id int(11) NOT NULL DEFAULT '0' COMMENT '',
    sample_type varchar(30) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    initial_specimen_sample_id int(11) NULL DEFAULT NULL COMMENT '',
    initial_specimen_sample_type varchar(30) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    collection_id int(11) NULL DEFAULT NULL COMMENT '',
    parent_id int(11) NULL DEFAULT NULL COMMENT '',
    sop_master_id int(11) NULL DEFAULT NULL COMMENT '',
    product_code varchar(20) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    is_problematic varchar(6) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    notes text NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    created datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    created_by varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NULL DEFAULT NULL COMMENT '',
    modified_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    version_id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    version_created datetime NOT NULL DEFAULT 0000-00-00 00:00:00 COMMENT '',
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (version_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE sample_to_aliquot_controls (
    id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    sample_control_id int(11) NULL DEFAULT NULL COMMENT '',
    aliquot_control_id int(11) NULL DEFAULT NULL COMMENT '',
    status enum('inactive','active') NULL DEFAULT 'inactive' COMMENT '' COLLATE latin1_swedish_ci,
    PRIMARY KEY (id),
    UNIQUE sample_to_aliquot (sample_control_id, aliquot_control_id),
    INDEX FK_sample_to_aliquot_controls_aliquot_controls (aliquot_control_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE sd_der_amp_rnas_revs (
    id int(11) NOT NULL DEFAULT 0 COMMENT '',
    sample_master_id int(11) NULL DEFAULT NULL COMMENT '',
    created datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    created_by varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NULL DEFAULT NULL COMMENT '',
    modified_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    version_id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    version_created datetime NOT NULL DEFAULT 0000-00-00 00:00:00 COMMENT '',
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (version_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE sd_der_ascite_cells (
    id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    sample_master_id int(11) NULL DEFAULT NULL COMMENT '',
    created datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    created_by varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NULL DEFAULT NULL COMMENT '',
    modified_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (id),
    INDEX FK_sd_der_ascite_cells_sample_masters (sample_master_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE sd_der_ascite_cells_revs (
    id int(11) NOT NULL DEFAULT 0 COMMENT '',
    sample_master_id int(11) NULL DEFAULT NULL COMMENT '',
    created datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    created_by varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NULL DEFAULT NULL COMMENT '',
    modified_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    version_id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    version_created datetime NOT NULL DEFAULT 0000-00-00 00:00:00 COMMENT '',
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (version_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE sd_der_ascite_sups (
    id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    sample_master_id int(11) NULL DEFAULT NULL COMMENT '',
    created datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    created_by varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NULL DEFAULT NULL COMMENT '',
    modified_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (id),
    INDEX FK_sd_der_ascite_sups_sample_masters (sample_master_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE sd_der_ascite_sups_revs (
    id int(11) NOT NULL DEFAULT 0 COMMENT '',
    sample_master_id int(11) NULL DEFAULT NULL COMMENT '',
    created datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    created_by varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NULL DEFAULT NULL COMMENT '',
    modified_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    version_id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    version_created datetime NOT NULL DEFAULT 0000-00-00 00:00:00 COMMENT '',
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (version_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE sd_der_b_cells (
    id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    sample_master_id int(11) NULL DEFAULT NULL COMMENT '',
    created datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    created_by varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NULL DEFAULT NULL COMMENT '',
    modified_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (id),
    INDEX FK_sd_der_b_cells_sample_masters (sample_master_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE sd_der_b_cells_revs (
    id int(11) NOT NULL DEFAULT 0 COMMENT '',
    sample_master_id int(11) NULL DEFAULT NULL COMMENT '',
    created datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    created_by varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NULL DEFAULT NULL COMMENT '',
    modified_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    version_id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    version_created datetime NOT NULL DEFAULT 0000-00-00 00:00:00 COMMENT '',
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (version_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE sd_der_blood_cells_revs (
    id int(11) NOT NULL DEFAULT 0 COMMENT '',
    sample_master_id int(11) NULL DEFAULT NULL COMMENT '',
    created datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    created_by varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NULL DEFAULT NULL COMMENT '',
    modified_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    version_id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    version_created datetime NOT NULL DEFAULT 0000-00-00 00:00:00 COMMENT '',
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (version_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE sd_der_cell_cultures_revs (
    id int(11) NOT NULL DEFAULT 0 COMMENT '',
    sample_master_id int(11) NULL DEFAULT NULL COMMENT '',
    culture_status varchar(30) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    culture_status_reason varchar(30) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    cell_passage_number int(6) NULL DEFAULT NULL COMMENT '',
    created datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    created_by varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NULL DEFAULT NULL COMMENT '',
    modified_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    version_id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    version_created datetime NOT NULL DEFAULT 0000-00-00 00:00:00 COMMENT '',
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (version_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE sd_der_cystic_fl_cells (
    id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    sample_master_id int(11) NULL DEFAULT NULL COMMENT '',
    created datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    created_by varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NULL DEFAULT NULL COMMENT '',
    modified_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (id),
    INDEX FK_sd_der_cystic_fl_cells_sample_masters (sample_master_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE sd_der_cystic_fl_cells_revs (
    id int(11) NOT NULL DEFAULT 0 COMMENT '',
    sample_master_id int(11) NULL DEFAULT NULL COMMENT '',
    created datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    created_by varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NULL DEFAULT NULL COMMENT '',
    modified_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    version_id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    version_created datetime NOT NULL DEFAULT 0000-00-00 00:00:00 COMMENT '',
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (version_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE sd_der_cystic_fl_sups (
    id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    sample_master_id int(11) NULL DEFAULT NULL COMMENT '',
    created datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    created_by varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NULL DEFAULT NULL COMMENT '',
    modified_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (id),
    INDEX FK_sd_der_cystic_fl_sups_sample_masters (sample_master_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE sd_der_cystic_fl_sups_revs (
    id int(11) NOT NULL DEFAULT 0 COMMENT '',
    sample_master_id int(11) NULL DEFAULT NULL COMMENT '',
    created datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    created_by varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NULL DEFAULT NULL COMMENT '',
    modified_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    version_id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    version_created datetime NOT NULL DEFAULT 0000-00-00 00:00:00 COMMENT '',
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (version_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE sd_der_dnas_revs (
    id int(11) NOT NULL DEFAULT 0 COMMENT '',
    sample_master_id int(11) NULL DEFAULT NULL COMMENT '',
    created datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    created_by varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NULL DEFAULT NULL COMMENT '',
    modified_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    version_id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    version_created datetime NOT NULL DEFAULT 0000-00-00 00:00:00 COMMENT '',
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (version_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE sd_der_pbmcs_revs (
    id int(11) NOT NULL DEFAULT 0 COMMENT '',
    sample_master_id int(11) NULL DEFAULT NULL COMMENT '',
    created datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    created_by varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NULL DEFAULT NULL COMMENT '',
    modified_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    version_id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    version_created datetime NOT NULL DEFAULT 0000-00-00 00:00:00 COMMENT '',
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (version_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE sd_der_pericardial_fl_cells (
    id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    sample_master_id int(11) NULL DEFAULT NULL COMMENT '',
    created datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    created_by varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NULL DEFAULT NULL COMMENT '',
    modified_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (id),
    INDEX FK_sd_der_pericardial_fl_cells_sample_masters (sample_master_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE sd_der_pericardial_fl_cells_revs (
    id int(11) NOT NULL DEFAULT 0 COMMENT '',
    sample_master_id int(11) NULL DEFAULT NULL COMMENT '',
    created datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    created_by varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NULL DEFAULT NULL COMMENT '',
    modified_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    version_id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    version_created datetime NOT NULL DEFAULT 0000-00-00 00:00:00 COMMENT '',
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (version_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE sd_der_pericardial_fl_sups (
    id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    sample_master_id int(11) NULL DEFAULT NULL COMMENT '',
    created datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    created_by varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NULL DEFAULT NULL COMMENT '',
    modified_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (id),
    INDEX FK_sd_der_pericardial_fl_sups_sample_masters (sample_master_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE sd_der_pericardial_fl_sups_revs (
    id int(11) NOT NULL DEFAULT 0 COMMENT '',
    sample_master_id int(11) NULL DEFAULT NULL COMMENT '',
    created datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    created_by varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NULL DEFAULT NULL COMMENT '',
    modified_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    version_id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    version_created datetime NOT NULL DEFAULT 0000-00-00 00:00:00 COMMENT '',
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (version_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE sd_der_plasmas_revs (
    id int(11) NOT NULL DEFAULT 0 COMMENT '',
    sample_master_id int(11) NULL DEFAULT NULL COMMENT '',
    hemolyze_signs varchar(10) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    created datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    created_by varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NULL DEFAULT NULL COMMENT '',
    modified_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    version_id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    version_created datetime NOT NULL DEFAULT 0000-00-00 00:00:00 COMMENT '',
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (version_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE sd_der_pleural_fl_cells (
    id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    sample_master_id int(11) NULL DEFAULT NULL COMMENT '',
    created datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    created_by varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NULL DEFAULT NULL COMMENT '',
    modified_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (id),
    INDEX FK_sd_der_pleural_fl_cells_sample_masters (sample_master_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE sd_der_pleural_fl_cells_revs (
    id int(11) NOT NULL DEFAULT 0 COMMENT '',
    sample_master_id int(11) NULL DEFAULT NULL COMMENT '',
    created datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    created_by varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NULL DEFAULT NULL COMMENT '',
    modified_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    version_id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    version_created datetime NOT NULL DEFAULT 0000-00-00 00:00:00 COMMENT '',
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (version_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE sd_der_pleural_fl_sups (
    id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    sample_master_id int(11) NULL DEFAULT NULL COMMENT '',
    created datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    created_by varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NULL DEFAULT NULL COMMENT '',
    modified_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (id),
    INDEX FK_sd_der_pleural_fl_sups_sample_masters (sample_master_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE sd_der_pleural_fl_sups_revs (
    id int(11) NOT NULL DEFAULT 0 COMMENT '',
    sample_master_id int(11) NULL DEFAULT NULL COMMENT '',
    created datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    created_by varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NULL DEFAULT NULL COMMENT '',
    modified_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    version_id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    version_created datetime NOT NULL DEFAULT 0000-00-00 00:00:00 COMMENT '',
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (version_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE sd_der_pw_cells (
    id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    sample_master_id int(11) NULL DEFAULT NULL COMMENT '',
    created datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    created_by varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NULL DEFAULT NULL COMMENT '',
    modified_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (id),
    INDEX FK_sd_der_pw_cells_sample_masters (sample_master_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE sd_der_pw_cells_revs (
    id int(11) NOT NULL DEFAULT 0 COMMENT '',
    sample_master_id int(11) NULL DEFAULT NULL COMMENT '',
    created datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    created_by varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NULL DEFAULT NULL COMMENT '',
    modified_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    version_id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    version_created datetime NOT NULL DEFAULT 0000-00-00 00:00:00 COMMENT '',
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (version_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE sd_der_pw_sups (
    id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    sample_master_id int(11) NULL DEFAULT NULL COMMENT '',
    created datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    created_by varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NULL DEFAULT NULL COMMENT '',
    modified_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (id),
    INDEX FK_sd_der_pw_sups_sample_masters (sample_master_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE sd_der_pw_sups_revs (
    id int(11) NOT NULL DEFAULT 0 COMMENT '',
    sample_master_id int(11) NULL DEFAULT NULL COMMENT '',
    created datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    created_by varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NULL DEFAULT NULL COMMENT '',
    modified_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    version_id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    version_created datetime NOT NULL DEFAULT 0000-00-00 00:00:00 COMMENT '',
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (version_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE sd_der_rnas_revs (
    id int(11) NOT NULL DEFAULT 0 COMMENT '',
    sample_master_id int(11) NULL DEFAULT NULL COMMENT '',
    created datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    created_by varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NULL DEFAULT NULL COMMENT '',
    modified_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    version_id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    version_created datetime NOT NULL DEFAULT 0000-00-00 00:00:00 COMMENT '',
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (version_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE sd_der_serums_revs (
    id int(11) NOT NULL DEFAULT 0 COMMENT '',
    sample_master_id int(11) NULL DEFAULT NULL COMMENT '',
    hemolyze_signs varchar(10) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    created datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    created_by varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NULL DEFAULT NULL COMMENT '',
    modified_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    version_id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    version_created datetime NOT NULL DEFAULT 0000-00-00 00:00:00 COMMENT '',
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (version_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE sd_der_tiss_lysates (
    id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    sample_master_id int(11) NULL DEFAULT NULL COMMENT '',
    created datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    created_by varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NULL DEFAULT NULL COMMENT '',
    modified_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (id),
    INDEX FK_sd_der_tiss_lysates_sample_masters (sample_master_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE sd_der_tiss_lysates_revs (
    id int(11) NOT NULL DEFAULT 0 COMMENT '',
    sample_master_id int(11) NULL DEFAULT NULL COMMENT '',
    created datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    created_by varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NULL DEFAULT NULL COMMENT '',
    modified_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    version_id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    version_created datetime NOT NULL DEFAULT 0000-00-00 00:00:00 COMMENT '',
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (version_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE sd_der_tiss_susps (
    id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    sample_master_id int(11) NULL DEFAULT NULL COMMENT '',
    created datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    created_by varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NULL DEFAULT NULL COMMENT '',
    modified_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (id),
    INDEX FK_sd_der_tiss_susps_sample_masters (sample_master_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE sd_der_tiss_susps_revs (
    id int(11) NOT NULL DEFAULT 0 COMMENT '',
    sample_master_id int(11) NULL DEFAULT NULL COMMENT '',
    created datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    created_by varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NULL DEFAULT NULL COMMENT '',
    modified_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    version_id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    version_created datetime NOT NULL DEFAULT 0000-00-00 00:00:00 COMMENT '',
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (version_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE sd_der_urine_cents (
    id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    sample_master_id int(11) NULL DEFAULT NULL COMMENT '',
    created datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    created_by varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NULL DEFAULT NULL COMMENT '',
    modified_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (id),
    INDEX FK_sd_der_urine_cents_sample_masters (sample_master_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE sd_der_urine_cents_revs (
    id int(11) NOT NULL DEFAULT 0 COMMENT '',
    sample_master_id int(11) NULL DEFAULT NULL COMMENT '',
    created datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    created_by varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NULL DEFAULT NULL COMMENT '',
    modified_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    version_id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    version_created datetime NOT NULL DEFAULT 0000-00-00 00:00:00 COMMENT '',
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (version_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE sd_der_urine_cons (
    id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    sample_master_id int(11) NULL DEFAULT NULL COMMENT '',
    created datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    created_by varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NULL DEFAULT NULL COMMENT '',
    modified_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (id),
    INDEX FK_sd_der_urine_cons_sample_masters (sample_master_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE sd_der_urine_cons_revs (
    id int(11) NOT NULL DEFAULT 0 COMMENT '',
    sample_master_id int(11) NULL DEFAULT NULL COMMENT '',
    created datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    created_by varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NULL DEFAULT NULL COMMENT '',
    modified_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    version_id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    version_created datetime NOT NULL DEFAULT 0000-00-00 00:00:00 COMMENT '',
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (version_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE sd_spe_ascites_revs (
    id int(11) NOT NULL DEFAULT 0 COMMENT '',
    sample_master_id int(11) NULL DEFAULT NULL COMMENT '',
    collected_volume decimal(10,5) NULL DEFAULT NULL COMMENT '',
    collected_volume_unit varchar(20) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    created datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    created_by varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NULL DEFAULT NULL COMMENT '',
    modified_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    version_id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    version_created datetime NOT NULL DEFAULT 0000-00-00 00:00:00 COMMENT '',
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (version_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE sd_spe_bloods_revs (
    id int(11) NOT NULL DEFAULT 0 COMMENT '',
    sample_master_id int(11) NULL DEFAULT NULL COMMENT '',
    blood_type varchar(30) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    collected_tube_nbr int(4) NULL DEFAULT NULL COMMENT '',
    collected_volume decimal(10,5) NULL DEFAULT NULL COMMENT '',
    collected_volume_unit varchar(20) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    created datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    created_by varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NULL DEFAULT NULL COMMENT '',
    modified_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    version_id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    version_created datetime NOT NULL DEFAULT 0000-00-00 00:00:00 COMMENT '',
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (version_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE sd_spe_cystic_fluids_revs (
    id int(11) NOT NULL DEFAULT 0 COMMENT '',
    sample_master_id int(11) NULL DEFAULT NULL COMMENT '',
    collected_volume decimal(10,5) NULL DEFAULT NULL COMMENT '',
    collected_volume_unit varchar(20) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    created datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    created_by varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NULL DEFAULT NULL COMMENT '',
    modified_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    version_id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    version_created datetime NOT NULL DEFAULT 0000-00-00 00:00:00 COMMENT '',
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (version_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE sd_spe_pericardial_fluids (
    id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    sample_master_id int(11) NULL DEFAULT NULL COMMENT '',
    collected_volume decimal(10,5) NULL DEFAULT NULL COMMENT '',
    collected_volume_unit varchar(20) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    created datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    created_by varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NULL DEFAULT NULL COMMENT '',
    modified_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (id),
    INDEX FK_sd_spe_pericardial_fluids_sample_masters (sample_master_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE sd_spe_pericardial_fluids_revs (
    id int(11) NOT NULL DEFAULT 0 COMMENT '',
    sample_master_id int(11) NULL DEFAULT NULL COMMENT '',
    collected_volume decimal(10,5) NULL DEFAULT NULL COMMENT '',
    collected_volume_unit varchar(20) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    created datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    created_by varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NULL DEFAULT NULL COMMENT '',
    modified_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    version_id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    version_created datetime NOT NULL DEFAULT 0000-00-00 00:00:00 COMMENT '',
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (version_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE sd_spe_peritoneal_washes_revs (
    id int(11) NOT NULL DEFAULT 0 COMMENT '',
    sample_master_id int(11) NULL DEFAULT NULL COMMENT '',
    collected_volume decimal(10,5) NULL DEFAULT NULL COMMENT '',
    collected_volume_unit varchar(20) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    created datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    created_by varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NULL DEFAULT NULL COMMENT '',
    modified_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    version_id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    version_created datetime NOT NULL DEFAULT 0000-00-00 00:00:00 COMMENT '',
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (version_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE sd_spe_pleural_fluids (
    id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    sample_master_id int(11) NULL DEFAULT NULL COMMENT '',
    collected_volume decimal(10,5) NULL DEFAULT NULL COMMENT '',
    collected_volume_unit varchar(20) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    created datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    created_by varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NULL DEFAULT NULL COMMENT '',
    modified_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (id),
    INDEX FK_sd_spe_pleural_fluids_sample_masters (sample_master_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE sd_spe_pleural_fluids_revs (
    id int(11) NOT NULL DEFAULT 0 COMMENT '',
    sample_master_id int(11) NULL DEFAULT NULL COMMENT '',
    collected_volume decimal(10,5) NULL DEFAULT NULL COMMENT '',
    collected_volume_unit varchar(20) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    created datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    created_by varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NULL DEFAULT NULL COMMENT '',
    modified_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    version_id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    version_created datetime NOT NULL DEFAULT 0000-00-00 00:00:00 COMMENT '',
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (version_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE sd_spe_tissues_revs (
    id int(11) NOT NULL DEFAULT 0 COMMENT '',
    sample_master_id int(11) NULL DEFAULT NULL COMMENT '',
    tissue_source varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    tissue_nature varchar(15) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    tissue_laterality varchar(10) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    pathology_reception_datetime datetime NULL DEFAULT NULL COMMENT '',
    tissue_size varchar(20) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    tissue_size_unit varchar(10) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    created datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    created_by varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NULL DEFAULT NULL COMMENT '',
    modified_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    version_id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    version_created datetime NOT NULL DEFAULT 0000-00-00 00:00:00 COMMENT '',
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (version_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE sd_spe_urines_revs (
    id int(11) NOT NULL DEFAULT 0 COMMENT '',
    sample_master_id int(11) NULL DEFAULT NULL COMMENT '',
    urine_aspect varchar(30) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    collected_volume decimal(10,5) NULL DEFAULT NULL COMMENT '',
    collected_volume_unit varchar(20) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    pellet_signs varchar(10) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    pellet_volume decimal(10,5) NULL DEFAULT NULL COMMENT '',
    pellet_volume_unit varchar(20) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    created datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    created_by varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NULL DEFAULT NULL COMMENT '',
    modified_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    version_id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    version_created datetime NOT NULL DEFAULT 0000-00-00 00:00:00 COMMENT '',
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (version_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE shelves_revs (
    id int(11) NOT NULL DEFAULT 0 COMMENT '',
    storage_id int(11) NULL DEFAULT NULL COMMENT '',
    description varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    created datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    created_by varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NULL DEFAULT NULL COMMENT '',
    modified_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    version_id int(11) NOT NULL DEFAULT 0 COMMENT '',
    version_created datetime NOT NULL DEFAULT 0000-00-00 00:00:00 COMMENT '',
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (version_id),
    INDEX storage_id (storage_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE shipments_revs (
    id int(11) NOT NULL DEFAULT 0 COMMENT '',
    shipment_code varchar(255) NOT NULL DEFAULT 'No Code' COMMENT '' COLLATE latin1_swedish_ci,
    recipient varchar(60) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    facility varchar(60) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    delivery_street_address varchar(255) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    delivery_city varchar(255) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    delivery_province varchar(255) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    delivery_postal_code varchar(255) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    delivery_country varchar(255) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    shipping_company varchar(255) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    shipping_account_nbr varchar(255) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    datetime_shipped datetime NULL DEFAULT NULL COMMENT '',
    datetime_received datetime NULL DEFAULT NULL COMMENT '',
    shipped_by varchar(255) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    created datetime NULL DEFAULT NULL COMMENT '',
    created_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NULL DEFAULT NULL COMMENT '',
    modified_by varchar(45) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    order_id int(11) NULL DEFAULT NULL COMMENT '',
    version_id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    version_created datetime NOT NULL DEFAULT 0000-00-00 00:00:00 COMMENT '',
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (version_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE sop_masters_revs (
    id int(11) NOT NULL DEFAULT 0 COMMENT '',
    sop_control_id int(11) NOT NULL DEFAULT '0' COMMENT '',
    title varchar(255) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    notes text NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    code varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    version varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    sop_group varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    type varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    status varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    expiry_date date NULL DEFAULT NULL COMMENT '',
    activated_date date NULL DEFAULT NULL COMMENT '',
    scope text NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    purpose text NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    created datetime NULL DEFAULT NULL COMMENT '',
    created_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NULL DEFAULT NULL COMMENT '',
    modified_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    form_id int(11) NULL DEFAULT NULL COMMENT '',
    version_id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    version_created datetime NOT NULL DEFAULT 0000-00-00 00:00:00 COMMENT '',
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (version_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE sopd_general_all_revs (
    id int(11) NOT NULL DEFAULT 0 COMMENT '',
    value varchar(255) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    created datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    created_by varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    modified_by varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    sop_master_id int(11) NULL DEFAULT NULL COMMENT '',
    version_id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    version_created datetime NOT NULL DEFAULT 0000-00-00 00:00:00 COMMENT '',
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (version_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE sopd_inventory_all (
    id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    created datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    created_by varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    modified_by varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    sop_master_id int(11) NULL DEFAULT NULL COMMENT '',
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE sopd_inventory_all_revs (
    id int(11) NOT NULL DEFAULT 0 COMMENT '',
    created datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    created_by varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    modified_by varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    sop_master_id int(11) NULL DEFAULT NULL COMMENT '',
    version_id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    version_created datetime NOT NULL DEFAULT 0000-00-00 00:00:00 COMMENT '',
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (version_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE sope_general_all_revs (
    id int(11) NOT NULL DEFAULT 0 COMMENT '',
    site_specific varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    created datetime NULL DEFAULT NULL COMMENT '',
    created_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NULL DEFAULT NULL COMMENT '',
    modified_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    sop_master_id int(11) NULL DEFAULT NULL COMMENT '',
    material_id int(11) NULL DEFAULT NULL COMMENT '',
    version_id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    version_created datetime NOT NULL DEFAULT 0000-00-00 00:00:00 COMMENT '',
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (version_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE sope_inventory_all (
    id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    created datetime NULL DEFAULT NULL COMMENT '',
    created_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NULL DEFAULT NULL COMMENT '',
    modified_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    sop_master_id int(11) NULL DEFAULT NULL COMMENT '',
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE sope_inventory_all_revs (
    id int(11) NOT NULL DEFAULT 0 COMMENT '',
    created datetime NULL DEFAULT NULL COMMENT '',
    created_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NULL DEFAULT NULL COMMENT '',
    modified_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    sop_master_id int(11) NULL DEFAULT NULL COMMENT '',
    version_id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    version_created datetime NOT NULL DEFAULT 0000-00-00 00:00:00 COMMENT '',
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (version_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE source_aliquots_revs (
    id int(11) NOT NULL DEFAULT 0 COMMENT '',
    sample_master_id int(11) NULL DEFAULT NULL COMMENT '',
    aliquot_master_id int(11) NULL DEFAULT NULL COMMENT '',
    aliquot_use_id int(11) NULL DEFAULT NULL COMMENT '',
    created datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    created_by varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NULL DEFAULT NULL COMMENT '',
    modified_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    version_id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    version_created datetime NOT NULL DEFAULT 0000-00-00 00:00:00 COMMENT '',
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (version_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE specimen_details_revs (
    id int(11) NOT NULL DEFAULT 0 COMMENT '',
    sample_master_id int(11) NULL DEFAULT NULL COMMENT '',
    supplier_dept varchar(40) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    reception_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    reception_datetime datetime NULL DEFAULT NULL COMMENT '',
    reception_datetime_accuracy varchar(4) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    created datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    created_by varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NULL DEFAULT NULL COMMENT '',
    modified_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    version_id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    version_created datetime NOT NULL DEFAULT 0000-00-00 00:00:00 COMMENT '',
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (version_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE std_boxs (
    id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    storage_master_id int(11) NULL DEFAULT NULL COMMENT '',
    created datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    created_by varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NULL DEFAULT NULL COMMENT '',
    modified_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (id),
    INDEX FK_std_boxs_storage_masters (storage_master_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE std_boxs_revs (
    id int(11) NOT NULL DEFAULT 0 COMMENT '',
    storage_master_id int(11) NULL DEFAULT NULL COMMENT '',
    created datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    created_by varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NULL DEFAULT NULL COMMENT '',
    modified_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    version_id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    version_created datetime NOT NULL DEFAULT 0000-00-00 00:00:00 COMMENT '',
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (version_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE std_cupboards (
    id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    storage_master_id int(11) NULL DEFAULT NULL COMMENT '',
    created datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    created_by varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NULL DEFAULT NULL COMMENT '',
    modified_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (id),
    INDEX FK_std_cupboards_storage_masters (storage_master_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE std_cupboards_revs (
    id int(11) NOT NULL DEFAULT 0 COMMENT '',
    storage_master_id int(11) NULL DEFAULT NULL COMMENT '',
    created datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    created_by varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NULL DEFAULT NULL COMMENT '',
    modified_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    version_id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    version_created datetime NOT NULL DEFAULT 0000-00-00 00:00:00 COMMENT '',
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (version_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE std_freezers (
    id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    storage_master_id int(11) NULL DEFAULT NULL COMMENT '',
    created datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    created_by varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NULL DEFAULT NULL COMMENT '',
    modified_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (id),
    INDEX FK_std_freezers_storage_masters (storage_master_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE std_freezers_revs (
    id int(11) NOT NULL DEFAULT 0 COMMENT '',
    storage_master_id int(11) NULL DEFAULT NULL COMMENT '',
    created datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    created_by varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NULL DEFAULT NULL COMMENT '',
    modified_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    version_id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    version_created datetime NOT NULL DEFAULT 0000-00-00 00:00:00 COMMENT '',
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (version_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE std_fridges (
    id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    storage_master_id int(11) NULL DEFAULT NULL COMMENT '',
    created datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    created_by varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NULL DEFAULT NULL COMMENT '',
    modified_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (id),
    INDEX FK_std_fridges_storage_masters (storage_master_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE std_fridges_revs (
    id int(11) NOT NULL DEFAULT 0 COMMENT '',
    storage_master_id int(11) NULL DEFAULT NULL COMMENT '',
    created datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    created_by varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NULL DEFAULT NULL COMMENT '',
    modified_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    version_id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    version_created datetime NOT NULL DEFAULT 0000-00-00 00:00:00 COMMENT '',
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (version_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE std_incubators_revs (
    id int(11) NOT NULL DEFAULT 0 COMMENT '',
    storage_master_id int(11) NULL DEFAULT NULL COMMENT '',
    oxygen_perc varchar(10) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    carbonic_gaz_perc varchar(10) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    created datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    created_by varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NULL DEFAULT NULL COMMENT '',
    modified_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    version_id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    version_created datetime NOT NULL DEFAULT 0000-00-00 00:00:00 COMMENT '',
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (version_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE std_nitro_locates (
    id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    storage_master_id int(11) NULL DEFAULT NULL COMMENT '',
    created datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    created_by varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NULL DEFAULT NULL COMMENT '',
    modified_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (id),
    INDEX FK_std_nitro_locates_storage_masters (storage_master_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE std_nitro_locates_revs (
    id int(11) NOT NULL DEFAULT 0 COMMENT '',
    storage_master_id int(11) NULL DEFAULT NULL COMMENT '',
    created datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    created_by varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NULL DEFAULT NULL COMMENT '',
    modified_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    version_id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    version_created datetime NOT NULL DEFAULT 0000-00-00 00:00:00 COMMENT '',
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (version_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE std_racks (
    id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    storage_master_id int(11) NULL DEFAULT NULL COMMENT '',
    created datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    created_by varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NULL DEFAULT NULL COMMENT '',
    modified_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (id),
    INDEX FK_std_racks_storage_masters (storage_master_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE std_racks_revs (
    id int(11) NOT NULL DEFAULT 0 COMMENT '',
    storage_master_id int(11) NULL DEFAULT NULL COMMENT '',
    created datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    created_by varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NULL DEFAULT NULL COMMENT '',
    modified_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    version_id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    version_created datetime NOT NULL DEFAULT 0000-00-00 00:00:00 COMMENT '',
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (version_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE std_rooms_revs (
    id int(11) NOT NULL DEFAULT 0 COMMENT '',
    storage_master_id int(11) NULL DEFAULT NULL COMMENT '',
    laboratory varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    floor varchar(20) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    created datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    created_by varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NULL DEFAULT NULL COMMENT '',
    modified_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    version_id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    version_created datetime NOT NULL DEFAULT 0000-00-00 00:00:00 COMMENT '',
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (version_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE std_shelfs (
    id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    storage_master_id int(11) NULL DEFAULT NULL COMMENT '',
    created datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    created_by varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NULL DEFAULT NULL COMMENT '',
    modified_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (id),
    INDEX FK_std_shelfs_storage_masters (storage_master_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE std_shelfs_revs (
    id int(11) NOT NULL DEFAULT 0 COMMENT '',
    storage_master_id int(11) NULL DEFAULT NULL COMMENT '',
    created datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    created_by varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NULL DEFAULT NULL COMMENT '',
    modified_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    version_id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    version_created datetime NOT NULL DEFAULT 0000-00-00 00:00:00 COMMENT '',
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (version_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE std_tma_blocks_revs (
    id int(11) NOT NULL DEFAULT 0 COMMENT '',
    storage_master_id int(11) NULL DEFAULT NULL COMMENT '',
    sop_master_id int(11) NULL DEFAULT NULL COMMENT '',
    product_code varchar(20) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    creation_datetime datetime NULL DEFAULT NULL COMMENT '',
    created datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    created_by varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NULL DEFAULT NULL COMMENT '',
    modified_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    version_id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    version_created datetime NOT NULL DEFAULT 0000-00-00 00:00:00 COMMENT '',
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (version_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE storage_coordinates_revs (
    id int(11) NOT NULL DEFAULT 0 COMMENT '',
    storage_master_id int(11) NULL DEFAULT NULL COMMENT '',
    dimension varchar(4) NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    coordinate_value varchar(50) NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    `order` int(4) NULL DEFAULT '0' COMMENT '',
    created datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    created_by varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NULL DEFAULT NULL COMMENT '',
    modified_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    version_id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    version_created datetime NOT NULL DEFAULT 0000-00-00 00:00:00 COMMENT '',
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (version_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE storage_masters_revs (
    id int(11) NOT NULL DEFAULT 0 COMMENT '',
    code varchar(30) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    storage_type varchar(30) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    storage_control_id int(11) NOT NULL DEFAULT '0' COMMENT '',
    parent_id int(11) NULL DEFAULT NULL COMMENT '',
    lft int(10) NULL DEFAULT NULL COMMENT '',
    rght int(10) NULL DEFAULT NULL COMMENT '',
    barcode varchar(60) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    short_label varchar(10) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    selection_label varchar(60) NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    storage_status varchar(20) NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    parent_storage_coord_x varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    coord_x_order int(3) NULL DEFAULT NULL COMMENT '',
    parent_storage_coord_y varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    coord_y_order int(3) NULL DEFAULT NULL COMMENT '',
    set_temperature varchar(7) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    temperature decimal(5,2) NULL DEFAULT NULL COMMENT '',
    temp_unit varchar(20) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    notes text NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    created datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    created_by varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NULL DEFAULT NULL COMMENT '',
    modified_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    version_id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    version_created datetime NOT NULL DEFAULT 0000-00-00 00:00:00 COMMENT '',
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (version_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE structure_fields (
    id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    public_identifier varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    old_id varchar(255) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    plugin varchar(255) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    model varchar(255) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    tablename varchar(255) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    field varchar(255) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    language_label text NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    language_tag text NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    type varchar(255) NOT NULL DEFAULT 'input' COMMENT '' COLLATE latin1_swedish_ci,
    setting text NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    `default` varchar(255) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    structure_value_domain int(11) NULL DEFAULT NULL COMMENT '',
    language_help text NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    validation_control varchar(50) NOT NULL DEFAULT 'open' COMMENT '' COLLATE latin1_swedish_ci,
    value_domain_control varchar(50) NOT NULL DEFAULT 'open' COMMENT '' COLLATE latin1_swedish_ci,
    field_control varchar(50) NOT NULL DEFAULT 'open' COMMENT '' COLLATE latin1_swedish_ci,
    created datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    created_by varchar(255) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    modified_by varchar(255) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    PRIMARY KEY (id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE structure_formats (
    id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    old_id varchar(255) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    structure_id int(11) NULL DEFAULT NULL COMMENT '',
    structure_old_id varchar(255) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    structure_field_id int(11) NULL DEFAULT NULL COMMENT '',
    structure_field_old_id varchar(255) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    display_column int(11) NOT NULL DEFAULT '1' COMMENT '',
    display_order int(11) NOT NULL DEFAULT '0' COMMENT '',
    language_heading varchar(255) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    flag_override_label set('0','1') NOT NULL DEFAULT '0' COMMENT '' COLLATE latin1_swedish_ci,
    language_label text NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    flag_override_tag set('0','1') NOT NULL DEFAULT '0' COMMENT '' COLLATE latin1_swedish_ci,
    language_tag text NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    flag_override_help set('0','1') NOT NULL DEFAULT '0' COMMENT '' COLLATE latin1_swedish_ci,
    language_help text NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    flag_override_type set('0','1') NOT NULL DEFAULT '0' COMMENT '' COLLATE latin1_swedish_ci,
    type varchar(255) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    flag_override_setting set('0','1') NOT NULL DEFAULT '0' COMMENT '' COLLATE latin1_swedish_ci,
    setting varchar(255) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    flag_override_default set('0','1') NOT NULL DEFAULT '0' COMMENT '' COLLATE latin1_swedish_ci,
    `default` varchar(255) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    flag_add set('0','1') NOT NULL DEFAULT '0' COMMENT '' COLLATE latin1_swedish_ci,
    flag_add_readonly set('0','1') NOT NULL DEFAULT '0' COMMENT '' COLLATE latin1_swedish_ci,
    flag_edit set('0','1') NOT NULL DEFAULT '0' COMMENT '' COLLATE latin1_swedish_ci,
    flag_edit_readonly set('0','1') NOT NULL DEFAULT '0' COMMENT '' COLLATE latin1_swedish_ci,
    flag_search set('0','1') NOT NULL DEFAULT '0' COMMENT '' COLLATE latin1_swedish_ci,
    flag_search_readonly set('0','1') NOT NULL DEFAULT '0' COMMENT '' COLLATE latin1_swedish_ci,
    flag_datagrid set('0','1') NOT NULL DEFAULT '0' COMMENT '' COLLATE latin1_swedish_ci,
    flag_datagrid_readonly set('0','1') NOT NULL DEFAULT '0' COMMENT '' COLLATE latin1_swedish_ci,
    flag_index set('0','1') NOT NULL DEFAULT '0' COMMENT '' COLLATE latin1_swedish_ci,
    flag_detail set('0','1') NOT NULL DEFAULT '0' COMMENT '' COLLATE latin1_swedish_ci,
    created datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    created_by varchar(255) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    modified_by varchar(255) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    PRIMARY KEY (id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE structure_options (
    id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    alias varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    section varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    subsection varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    value varchar(100) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    language_choice varchar(100) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    display_order int(11) NULL DEFAULT NULL COMMENT '',
    active varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    created datetime NULL DEFAULT NULL COMMENT '',
    created_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NULL DEFAULT NULL COMMENT '',
    modified_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    PRIMARY KEY (id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE structure_permissible_values (
    id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    value varchar(255) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    language_alias varchar(255) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    PRIMARY KEY (id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE structure_validations (
    id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    old_id varchar(255) NOT NULL DEFAULT '0' COMMENT '' COLLATE latin1_swedish_ci,
    structure_field_id int(11) NOT NULL DEFAULT '0' COMMENT '',
    structure_field_old_id varchar(255) NOT NULL DEFAULT '0' COMMENT '' COLLATE latin1_swedish_ci,
    rule text NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    flag_empty set('0','1') NOT NULL DEFAULT '0' COMMENT '' COLLATE latin1_swedish_ci,
    flag_required set('0','1') NOT NULL DEFAULT '0' COMMENT '' COLLATE latin1_swedish_ci,
    on_action varchar(255) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    language_message text NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    created datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    created_by varchar(255) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    modified_by varchar(255) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    PRIMARY KEY (id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE structure_value_domains (
    id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    domain_name varchar(255) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    override set('extend','locked','open') NOT NULL DEFAULT 'open' COMMENT '' COLLATE latin1_swedish_ci,
    category varchar(255) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    PRIMARY KEY (id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE structure_value_domains_permissible_values (
    id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    structure_value_domain_id varchar(255) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    structure_permissible_value_id varchar(255) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    display_order int(11) NOT NULL DEFAULT '0' COMMENT '',
    active set('yes','no') NOT NULL DEFAULT 'yes' COMMENT '' COLLATE latin1_swedish_ci,
    language_alias varchar(255) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    PRIMARY KEY (id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE structures (
    id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    old_id varchar(255) NOT NULL DEFAULT '0' COMMENT '' COLLATE latin1_swedish_ci,
    alias varchar(255) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    language_title text NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    language_help text NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    flag_add_columns set('0','1') NOT NULL DEFAULT '0' COMMENT '' COLLATE latin1_swedish_ci,
    flag_edit_columns set('0','1') NOT NULL DEFAULT '0' COMMENT '' COLLATE latin1_swedish_ci,
    flag_search_columns set('0','1') NOT NULL DEFAULT '0' COMMENT '' COLLATE latin1_swedish_ci,
    flag_detail_columns set('0','1') NOT NULL DEFAULT '0' COMMENT '' COLLATE latin1_swedish_ci,
    created datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    created_by varchar(255) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    modified_by varchar(255) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    PRIMARY KEY (id),
    UNIQUE unique_alias (alias)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE study_contacts_revs (
    id int(11) NOT NULL DEFAULT 0 COMMENT '',
    sort int(11) NULL DEFAULT NULL COMMENT '',
    prefix int(11) NULL DEFAULT NULL COMMENT '',
    first_name varchar(255) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    middle_name varchar(255) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    last_name varchar(255) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    accreditation varchar(255) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    occupation varchar(255) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    department varchar(255) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    organization varchar(255) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    organization_type varchar(255) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    address_street varchar(255) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    address_city varchar(255) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    address_province varchar(255) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    address_country varchar(255) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    address_postal varchar(255) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    phone_number varchar(255) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    phone_extension int(11) NULL DEFAULT NULL COMMENT '',
    phone2_number varchar(255) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    phone2_extension int(11) NULL DEFAULT NULL COMMENT '',
    fax_number varchar(255) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    fax_extension int(11) NULL DEFAULT NULL COMMENT '',
    email varchar(255) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    website varchar(255) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    created datetime NULL DEFAULT NULL COMMENT '',
    created_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NULL DEFAULT NULL COMMENT '',
    modified_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    study_summary_id int(11) NULL DEFAULT NULL COMMENT '',
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    version_id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    version_created datetime NOT NULL DEFAULT 0000-00-00 00:00:00 COMMENT '',
    PRIMARY KEY (version_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE study_ethics_boards (
    id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    ethics_board varchar(255) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    restrictions text NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    contact varchar(255) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    `date` date NULL DEFAULT NULL COMMENT '',
    phone_number varchar(255) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    phone_extension varchar(255) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    fax_number varchar(255) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    fax_extension varchar(255) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    email varchar(255) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    status varchar(255) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    approval_number varchar(255) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    accrediation varchar(255) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    ohrp_registration_number varchar(255) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    ohrp_fwa_number varchar(255) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    path_to_file varchar(255) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    created datetime NULL DEFAULT NULL COMMENT '',
    created_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NULL DEFAULT NULL COMMENT '',
    modified_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    study_summary_id int(11) NULL DEFAULT NULL COMMENT '',
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (id),
    INDEX FK_study_ethics_boards_study_summaries (study_summary_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE study_ethics_boards_revs (
    id int(11) NOT NULL DEFAULT 0 COMMENT '',
    ethics_board varchar(255) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    restrictions text NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    contact varchar(255) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    `date` date NULL DEFAULT NULL COMMENT '',
    phone_number varchar(255) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    phone_extension varchar(255) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    fax_number varchar(255) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    fax_extension varchar(255) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    email varchar(255) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    status varchar(255) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    approval_number varchar(255) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    accrediation varchar(255) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    ohrp_registration_number varchar(255) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    ohrp_fwa_number varchar(255) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    path_to_file varchar(255) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    created datetime NULL DEFAULT NULL COMMENT '',
    created_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NULL DEFAULT NULL COMMENT '',
    modified_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    study_summary_id int(11) NULL DEFAULT NULL COMMENT '',
    version_id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    version_created datetime NOT NULL DEFAULT 0000-00-00 00:00:00 COMMENT '',
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (version_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE study_fundings_revs (
    id int(11) NOT NULL DEFAULT 0 COMMENT '',
    study_sponsor varchar(255) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    restrictions text NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    year_1 int(11) NULL DEFAULT NULL COMMENT '',
    amount_year_1 decimal(10,2) NULL DEFAULT NULL COMMENT '',
    year_2 int(11) NULL DEFAULT NULL COMMENT '',
    amount_year_2 decimal(10,2) NULL DEFAULT NULL COMMENT '',
    year_3 int(11) NULL DEFAULT NULL COMMENT '',
    amount_year_3 decimal(10,2) NULL DEFAULT NULL COMMENT '',
    year_4 int(11) NULL DEFAULT NULL COMMENT '',
    amount_year_4 decimal(10,2) NULL DEFAULT NULL COMMENT '',
    year_5 int(11) NULL DEFAULT NULL COMMENT '',
    amount_year_5 decimal(10,2) NULL DEFAULT NULL COMMENT '',
    contact varchar(255) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    phone_number varchar(255) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    phone_extension varchar(255) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    fax_number varchar(255) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    fax_extension varchar(255) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    email varchar(255) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    status varchar(255) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    `date` date NULL DEFAULT NULL COMMENT '',
    created datetime NULL DEFAULT NULL COMMENT '',
    created_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NULL DEFAULT NULL COMMENT '',
    modified_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    rtbform_id int(11) NULL DEFAULT NULL COMMENT '',
    study_summary_id int(11) NULL DEFAULT NULL COMMENT '',
    version_id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    version_created datetime NOT NULL DEFAULT 0000-00-00 00:00:00 COMMENT '',
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (version_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE study_investigators_revs (
    id int(11) NOT NULL DEFAULT 0 COMMENT '',
    first_name varchar(255) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    middle_name varchar(255) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    last_name varchar(255) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    accrediation varchar(255) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    occupation varchar(255) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    department varchar(255) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    organization varchar(255) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    address_street varchar(255) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    address_city varchar(255) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    address_province varchar(255) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    address_country varchar(255) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    sort int(11) NULL DEFAULT NULL COMMENT '',
    email varchar(45) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    role varchar(255) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    brief text NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    participation_start_date date NULL DEFAULT NULL COMMENT '',
    participation_end_date date NULL DEFAULT NULL COMMENT '',
    created datetime NULL DEFAULT NULL COMMENT '',
    created_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NULL DEFAULT NULL COMMENT '',
    modified_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    path_to_file text NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    study_summary_id int(11) NULL DEFAULT NULL COMMENT '',
    version_id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    version_created datetime NOT NULL DEFAULT 0000-00-00 00:00:00 COMMENT '',
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (version_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE study_related_revs (
    id int(11) NOT NULL DEFAULT 0 COMMENT '',
    title varchar(255) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    principal_investigator varchar(255) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    journal varchar(255) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    issue varchar(255) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    url varchar(255) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    abstract text NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    relevance text NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    date_posted date NULL DEFAULT NULL COMMENT '',
    created datetime NULL DEFAULT NULL COMMENT '',
    created_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NULL DEFAULT NULL COMMENT '',
    modified_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    study_summary_id int(11) NULL DEFAULT NULL COMMENT '',
    path_to_file varchar(255) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    version_id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    version_created datetime NOT NULL DEFAULT 0000-00-00 00:00:00 COMMENT '',
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (version_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE study_results_revs (
    id int(11) NOT NULL DEFAULT 0 COMMENT '',
    abstract text NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    hypothesis text NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    conclusion text NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    comparison text NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    future text NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    result_date datetime NULL DEFAULT NULL COMMENT '',
    created datetime NULL DEFAULT NULL COMMENT '',
    created_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NULL DEFAULT NULL COMMENT '',
    modified_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    rtbform_id int(11) NULL DEFAULT NULL COMMENT '',
    study_summary_id int(11) NULL DEFAULT NULL COMMENT '',
    version_id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    version_created datetime NOT NULL DEFAULT 0000-00-00 00:00:00 COMMENT '',
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (version_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE study_reviews_revs (
    id int(11) NOT NULL DEFAULT 0 COMMENT '',
    prefix int(11) NULL DEFAULT NULL COMMENT '',
    first_name varchar(255) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    middle_name varchar(255) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    last_name varchar(255) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    accreditation varchar(255) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    committee varchar(255) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    institution varchar(255) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    phone_number varchar(255) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    phone_extension varchar(255) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    status varchar(255) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    `date` date NULL DEFAULT NULL COMMENT '',
    created datetime NULL DEFAULT NULL COMMENT '',
    created_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NULL DEFAULT NULL COMMENT '',
    modified_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    study_summary_id int(11) NULL DEFAULT NULL COMMENT '',
    version_id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    version_created datetime NOT NULL DEFAULT 0000-00-00 00:00:00 COMMENT '',
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (version_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE study_summaries_revs (
    id int(11) NOT NULL DEFAULT 0 COMMENT '',
    disease_site varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    study_type varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    study_science varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    study_use varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    title varchar(45) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    start_date date NULL DEFAULT NULL COMMENT '',
    end_date date NULL DEFAULT NULL COMMENT '',
    summary text NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    abstract text NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    hypothesis text NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    approach text NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    analysis text NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    significance text NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    additional_clinical text NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    created datetime NULL DEFAULT NULL COMMENT '',
    created_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NULL DEFAULT NULL COMMENT '',
    modified_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    path_to_file varchar(255) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    version_id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    version_created datetime NOT NULL DEFAULT 0000-00-00 00:00:00 COMMENT '',
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (version_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE tma_slides_revs (
    id int(11) NOT NULL DEFAULT 0 COMMENT '',
    tma_block_storage_master_id int(11) NULL DEFAULT NULL COMMENT '',
    barcode varchar(30) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    product_code varchar(20) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    sop_master_id int(11) NULL DEFAULT NULL COMMENT '',
    immunochemistry varchar(30) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    picture_path varchar(200) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    storage_datetime datetime NULL DEFAULT NULL COMMENT '',
    storage_master_id int(11) NULL DEFAULT NULL COMMENT '',
    storage_coord_x varchar(11) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    coord_x_order int(3) NULL DEFAULT NULL COMMENT '',
    storage_coord_y varchar(11) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    coord_y_order int(3) NULL DEFAULT NULL COMMENT '',
    created datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    created_by varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NULL DEFAULT NULL COMMENT '',
    modified_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    version_id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    version_created datetime NOT NULL DEFAULT 0000-00-00 00:00:00 COMMENT '',
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (version_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE tx_masters_revs (
    id int(11) NOT NULL DEFAULT 0 COMMENT '',
    treatment_control_id int(11) NOT NULL DEFAULT '0' COMMENT '',
    tx_method varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    disease_site varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    tx_intent varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    target_site_icdo varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    start_date date NULL DEFAULT NULL COMMENT '',
    start_date_accuracy varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    finish_date date NULL DEFAULT NULL COMMENT '',
    finish_date_accuracy varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    information_source varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    facility varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    notes text NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    created datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    created_by varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    modified_by varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    protocol_id int(11) NULL DEFAULT NULL COMMENT '',
    participant_id int(11) NULL DEFAULT NULL COMMENT '',
    diagnosis_master_id int(11) NULL DEFAULT NULL COMMENT '',
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    version_id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    version_created datetime NOT NULL DEFAULT 0000-00-00 00:00:00 COMMENT '',
    PRIMARY KEY (version_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE txd_chemos_revs (
    id int(11) NOT NULL DEFAULT 0 COMMENT '',
    chemo_completed varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    response varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    num_cycles int(11) NULL DEFAULT NULL COMMENT '',
    length_cycles int(11) NULL DEFAULT NULL COMMENT '',
    completed_cycles int(11) NULL DEFAULT NULL COMMENT '',
    created datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    created_by varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    modified_by varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    tx_master_id int(11) NULL DEFAULT NULL COMMENT '',
    version_id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    version_created datetime NOT NULL DEFAULT 0000-00-00 00:00:00 COMMENT '',
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (version_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE txd_radiations_revs (
    id int(11) NOT NULL DEFAULT 0 COMMENT '',
    rad_completed varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    tx_master_id int(11) NULL DEFAULT NULL COMMENT '',
    created datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    created_by varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    modified_by varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    version_id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    version_created datetime NOT NULL DEFAULT 0000-00-00 00:00:00 COMMENT '',
    PRIMARY KEY (version_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE txd_surgeries_revs (
    id int(11) NOT NULL DEFAULT 0 COMMENT '',
    path_num varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    `primary` varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    tx_master_id int(11) NULL DEFAULT NULL COMMENT '',
    created datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    created_by varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    modified_by varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    version_id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    version_created datetime NOT NULL DEFAULT 0000-00-00 00:00:00 COMMENT '',
    PRIMARY KEY (version_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE txe_chemos_revs (
    id int(11) NOT NULL DEFAULT 0 COMMENT '',
    dose varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    method varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    drug_id int(11) NULL DEFAULT NULL COMMENT '',
    tx_master_id int(11) NOT NULL DEFAULT '0' COMMENT '',
    created datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    created_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    modified_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    version_id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    version_created datetime NOT NULL DEFAULT 0000-00-00 00:00:00 COMMENT '',
    PRIMARY KEY (version_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE txe_radiations_revs (
    id int(11) NOT NULL DEFAULT 0 COMMENT '',
    modaility varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    technique varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    fractions varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    frequency varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    total_time varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    distance_sxd varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    distance_cm varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    dose_xd varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    dose_cgy varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    completed varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    created datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    created_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    modified_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    tx_master_id int(11) NULL DEFAULT NULL COMMENT '',
    version_id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    version_created datetime NOT NULL DEFAULT 0000-00-00 00:00:00 COMMENT '',
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    PRIMARY KEY (version_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE txe_surgeries_revs (
    id int(11) NOT NULL DEFAULT 0 COMMENT '',
    surgical_procedure varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    tx_master_id int(11) NULL DEFAULT NULL COMMENT '',
    created datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    created_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    modified_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    deleted_date datetime NULL DEFAULT NULL COMMENT '',
    version_id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    version_created datetime NOT NULL DEFAULT 0000-00-00 00:00:00 COMMENT '',
    PRIMARY KEY (version_id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE versions (
    id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment,
    version_number varchar(255) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    date_installed timestamp NOT NULL DEFAULT 'CURRENT_TIMESTAMP' COMMENT '',
    build_number varchar(45) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    created datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    created_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    modified datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    modified_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    PRIMARY KEY (id)
) DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;





#TODO check dropped fields
ALTER TABLE ad_blocks
    ADD block_type varchar(30) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci AFTER aliquot_master_id,
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    MODIFY aliquot_master_id int(11) NULL DEFAULT NULL COMMENT '',
    #DROP type,
    #DROP sample_position_code,
    ADD INDEX FK_ad_blocks_aliquot_masters (aliquot_master_id);
#
#  Fieldformat of
#    ad_blocks.aliquot_master_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#  Possibly data modifications needed!
#

ALTER TABLE ad_cell_cores
    CHANGE ad_gel_matrix_id gel_matrix_aliquot_master_id int(11) NULL DEFAULT NULL COMMENT '' AFTER aliquot_master_id,
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    MODIFY aliquot_master_id int(11) NULL DEFAULT NULL COMMENT '',
    ADD INDEX FK_ad_cell_cores_aliquot_masters (aliquot_master_id),
    ADD INDEX FK_ad_cell_cores_gel_matrices (gel_matrix_aliquot_master_id);
#
#  Fieldformat of
#    ad_cell_cores.aliquot_master_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#  Possibly data modifications needed!
#

#TODO validate dropped table
#DROP TABLE ad_cell_culture_tubes;

ALTER TABLE ad_cell_slides
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    MODIFY aliquot_master_id int(11) NULL DEFAULT NULL COMMENT '',
    ADD INDEX FK_ad_cell_slides_aliquot_masters (aliquot_master_id);
#
#  Fieldformat of
#    ad_cell_slides.aliquot_master_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#  Possibly data modifications needed!
#

#TODO validate dropped table
#DROP TABLE ad_cell_tubes;

ALTER TABLE ad_gel_matrices
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    MODIFY aliquot_master_id int(11) NULL DEFAULT NULL COMMENT '',
    ADD INDEX FK_ad_gel_matrices_aliquot_masters (aliquot_master_id);
#
#  Fieldformat of
#    ad_gel_matrices.aliquot_master_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#  Possibly data modifications needed!
#

#TODO validate dropped table
#DROP TABLE ad_tissue_bags;

ALTER TABLE ad_tissue_cores
    CHANGE ad_block_id block_aliquot_master_id int(11) NULL DEFAULT NULL COMMENT '' AFTER aliquot_master_id,
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    MODIFY aliquot_master_id int(11) NULL DEFAULT NULL COMMENT '',
    ADD INDEX FK_ad_tissue_cores_aliquot_masters (aliquot_master_id),
    ADD INDEX FK_ad_tissue_cores_blocks (block_aliquot_master_id);
#
#  Fieldformat of
#    ad_tissue_cores.aliquot_master_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#  Possibly data modifications needed!
#

ALTER TABLE ad_tissue_slides
    CHANGE ad_block_id block_aliquot_master_id int(11) NULL DEFAULT NULL COMMENT '' AFTER immunochemistry,
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    MODIFY aliquot_master_id int(11) NULL DEFAULT NULL COMMENT '',
    ADD INDEX FK_ad_tissue_slides_aliquot_masters (aliquot_master_id),
    ADD INDEX FK_ad_tissue_slides_aliquot_ad_cell_coress (block_aliquot_master_id);
#
#  Fieldformat of
#    ad_tissue_slides.aliquot_master_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#  Possibly data modifications needed!
#

#TODO validate dropped table
#DROP TABLE ad_tissue_tubes;

ALTER TABLE ad_tubes
    ADD cell_count decimal(10,2) NULL DEFAULT NULL COMMENT '' AFTER concentration_unit,
    ADD cell_count_unit varchar(20) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci AFTER cell_count,
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    MODIFY aliquot_master_id int(11) NULL DEFAULT NULL COMMENT '',
    ADD INDEX FK_ad_tubes_aliquot_masters (aliquot_master_id);
#
#  Fieldformat of
#    ad_tubes.aliquot_master_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#  Possibly data modifications needed!
#

ALTER TABLE ad_whatman_papers
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    DROP INDEX aliquot_master_id,
    ADD INDEX FK_ad_whatman_papers_aliquot_masters (aliquot_master_id);
#
#  Fieldformat of
#    ad_whatman_papers.aliquot_master_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#  Possibly data modifications needed!
#

ALTER TABLE aliquot_controls
    ADD display_order int(11) NOT NULL DEFAULT '0' COMMENT '' AFTER comment,
    MODIFY form_alias varchar(255) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    MODIFY detail_tablename varchar(255) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci;
#
#  Fieldformats of
#    aliquot_controls.form_alias changed from varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci to varchar(255) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci.
#    aliquot_controls.detail_tablename changed from varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci to varchar(255) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci.
#  Possibly data modifications needed!
#

#TODO validate dropped fields
ALTER TABLE aliquot_masters
    CHANGE status in_stock varchar(30) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci AFTER aliquot_volume_unit,
    CHANGE status_reason in_stock_detail varchar(30) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci AFTER in_stock,
    ADD coord_x_order int(3) NULL DEFAULT NULL COMMENT '' AFTER storage_coord_x,
    ADD coord_y_order int(3) NULL DEFAULT NULL COMMENT '' AFTER storage_coord_y,
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    DROP aliquot_label,
    MODIFY collection_id int(11) NULL DEFAULT NULL COMMENT '',
    MODIFY sample_master_id int(11) NULL DEFAULT NULL COMMENT '',
    DROP stored_by,
    DROP received,#ok drop
    DROP received_datetime,#ok drop
    DROP received_from,#ok drop
    DROP received_id,#ok drop
    DROP INDEX aliquot_control_id,
    DROP INDEX collection_id,
    DROP INDEX sample_master_id,
    DROP INDEX sop_master_id,
    DROP INDEX study_summary_id,
    DROP INDEX storage_master_id,
    ADD UNIQUE unique_barcode (barcode),
    ADD INDEX barcode (barcode),
    ADD INDEX aliquot_type (aliquot_type),
    ADD INDEX FK_aliquot_masters_aliquot_controls (aliquot_control_id),
    ADD INDEX FK_aliquot_masters_collections (collection_id),
    ADD INDEX FK_aliquot_masters_sample_masters (sample_master_id),
    ADD INDEX FK_aliquot_masters_sops (sop_master_id),
    ADD INDEX FK_aliquot_masters_study_summaries (study_summary_id),
    ADD INDEX FK_aliquot_masters_storage_masters (storage_master_id);
#
#  Fieldformats of
#    aliquot_masters.collection_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#    aliquot_masters.sample_master_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#  Possibly data modifications needed!
#

ALTER TABLE aliquot_uses
    ADD use_code varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci AFTER use_definition,
    ADD used_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci AFTER use_datetime,
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    MODIFY aliquot_master_id int(11) NULL DEFAULT NULL COMMENT '',
    DROP INDEX aliquot_master_id,
    DROP INDEX study_summary_id,
    ADD INDEX FK_aliquot_uses_study_summaries (study_summary_id),
    ADD INDEX FK_aliquot_uses_aliquot_masters (aliquot_master_id);
#
#  Fieldformat of
#    aliquot_uses.aliquot_master_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#  Possibly data modifications needed!
#

ALTER TABLE announcements
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    MODIFY user_id int(11) NULL DEFAULT NULL COMMENT '',
    MODIFY group_id int(11) NULL DEFAULT NULL COMMENT '',
    MODIFY bank_id int(11) NULL DEFAULT '0' COMMENT '';
#
#  Fieldformats of
#    announcements.user_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#    announcements.group_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#    announcements.bank_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT '0' COMMENT ''.
#  Possibly data modifications needed!
#

ALTER TABLE banks
    ADD created_by int(11) NOT NULL DEFAULT 0 COMMENT '' AFTER description,
    ADD modified_by int(11) NOT NULL DEFAULT 0 COMMENT '' AFTER created,
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted;


ALTER TABLE clinical_collection_links
    CHANGE diagnosis_id diagnosis_master_id int(11) NULL DEFAULT NULL COMMENT '' AFTER collection_id,
    CHANGE consent_id consent_master_id int(11) NULL DEFAULT NULL COMMENT '' AFTER diagnosis_master_id,
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    MODIFY participant_id int(11) NULL DEFAULT NULL COMMENT '',
    MODIFY collection_id int(11) NULL DEFAULT NULL COMMENT '',
    ADD INDEX participant_id (participant_id),
    ADD INDEX collection_id (collection_id),
    ADD INDEX diagnosis_master_id (diagnosis_master_id),
    ADD INDEX consent_master_id (consent_master_id);
#
#  Fieldformats of
#    clinical_collection_links.participant_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#    clinical_collection_links.collection_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#  Possibly data modifications needed!
#

ALTER TABLE coding_adverse_events
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted;


ALTER TABLE coding_icd10
    CHANGE group icd_group varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci AFTER category,
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted;

#TODO bank to bank_id + validate dropped fields
ALTER TABLE collections
    ADD bank_id int(11) NULL DEFAULT NULL COMMENT '' AFTER acquisition_label,
    ADD collection_datetime_accuracy varchar(4) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci AFTER collection_datetime,
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    DROP bank,
    DROP bank_participant_identifier,
    DROP visit_label,
    DROP reception_by,
    DROP reception_datetime,
    MODIFY collection_property varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    DROP INDEX sop_master_id,
    ADD INDEX acquisition_label (acquisition_label),
    ADD INDEX FK_collections_banks (bank_id),
    ADD INDEX FK_collections_sops (sop_master_id);
#
#  Fieldformat of
#    collections.collection_property changed from varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci to varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci.
#  Possibly data modifications needed!
#

#TODO validate drops
RENAME TABLE consents TO consent_masters;
ALTER TABLE consent_masters
	CHANGE date date_of_referral date NULL DEFAULT NULL COMMENT '',
    ADD COLUMN route_of_referral varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    ADD COLUMN date_first_contact date NULL DEFAULT NULL COMMENT '',
    ADD COLUMN consent_signed_date date NULL DEFAULT NULL COMMENT '',
    ADD COLUMN process_status varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    CHANGE memo notes text NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    ADD COLUMN consent_method varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    ADD COLUMN translator_indicator varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    ADD COLUMN translator_signature varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    ADD COLUMN consent_person varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    ADD COLUMN consent_master_id int(11) NULL DEFAULT NULL COMMENT '',
    ADD COLUMN consent_control_id int(11) NOT NULL DEFAULT 0 COMMENT '',
    CHANGE consent_type type varchar(10) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    ADD COLUMN deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    ADD COLUMN deleted_date datetime NULL DEFAULT NULL COMMENT '',
    DROP use_of_blood,
    DROP use_of_urine,
    DROP urine_blood_use_for_followup,
    DROP stop_followup,
    DROP stop_followup_date,
    DROP contact_for_additional_data,
    DROP allow_questionaire,
    DROP stop_questionnaire,
    DROP stop_questionaire_date,
    DROP research_other_disease,
    DROP inform_discovery_on_other_disease,
    DROP inform_significant_discovery;
    

ALTER TABLE datamart_adhoc
    ADD plugin varchar(255) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci AFTER description;


ALTER TABLE datamart_adhoc_favourites
    ADD id int(11) NOT NULL DEFAULT 0 COMMENT '' auto_increment FIRST,
    MODIFY adhoc_id int(11) NULL DEFAULT NULL COMMENT '',
    MODIFY user_id int(11) NULL DEFAULT NULL COMMENT '',
    ADD PRIMARY KEY (id);
#
#  Fieldformats of
#    datamart_adhoc_favourites.adhoc_id changed from int(11) NOT NULL DEFAULT 0 COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#    datamart_adhoc_favourites.user_id changed from int(11) NOT NULL DEFAULT 0 COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#  Possibly data modifications needed!
#

ALTER TABLE datamart_adhoc_saved
    MODIFY adhoc_id int(11) NULL DEFAULT NULL COMMENT '',
    MODIFY user_id int(11) NULL DEFAULT NULL COMMENT '';
#
#  Fieldformats of
#    datamart_adhoc_saved.adhoc_id changed from int(11) NOT NULL DEFAULT 0 COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#    datamart_adhoc_saved.user_id changed from int(11) NOT NULL DEFAULT 0 COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#  Possibly data modifications needed!
#

ALTER TABLE datamart_batch_ids
    MODIFY set_id int(11) NULL DEFAULT NULL COMMENT '',
    MODIFY lookup_id int(11) NULL DEFAULT NULL COMMENT '';
#
#  Fieldformats of
#    datamart_batch_ids.set_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#    datamart_batch_ids.lookup_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#  Possibly data modifications needed!
#

ALTER TABLE datamart_batch_processes
    ADD plugin varchar(100) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci AFTER name;


ALTER TABLE datamart_batch_sets
    ADD plugin varchar(100) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci AFTER description,
    MODIFY user_id int(11) NULL DEFAULT NULL COMMENT '',
    MODIFY group_id int(11) NULL DEFAULT NULL COMMENT '';
#
#  Fieldformats of
#    datamart_batch_sets.user_id changed from int(11) NOT NULL DEFAULT 0 COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#    datamart_batch_sets.group_id changed from int(11) NOT NULL DEFAULT 0 COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#  Possibly data modifications needed!
#

ALTER TABLE derivative_details
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    MODIFY sample_master_id int(11) NULL DEFAULT NULL COMMENT '',
    DROP INDEX sample_master_id,
    ADD INDEX FK_detivative_details_sample_masters (sample_master_id);
#
#  Fieldformat of
#    derivative_details.sample_master_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#  Possibly data modifications needed!
#

#TODO validate drop
DROP TABLE derived_sample_links;

#TODO validate big table
RENAME TABLE diagnoses TO diagnosis_masters;
ALTER TABLE diagnosis_masters
    ADD dx_identifier varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    ADD primary_number int(11) NULL DEFAULT NULL COMMENT '',
    MODIFY dx_method varchar(20) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    MODIFY dx_nature varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    MODIFY dx_origin varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    ADD dx_date_accuracy varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    CHANGE icd10_id primary_icd10_code varchar(10) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    ADD previous_primary_code varchar(10) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    ADD previous_primary_code_system varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    ADD topography varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    ADD tumour_grade varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    ADD age_at_dx int(11) NULL DEFAULT NULL COMMENT '',
    ADD age_at_dx_accuracy varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    ADD ajcc_edition varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    CHANGE collaborative_stage collaborative_staged varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    CHANGE clinical_stage_grouping clinical_stage_summary varchar(5) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    CHANGE path_stage_grouping path_stage_summary varchar(5) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    ADD survival_time_months int(11) NULL DEFAULT NULL COMMENT '',
    ADD information_source varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    ADD notes text NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    ADD diagnosis_control_id int(11) NOT NULL DEFAULT '0' COMMENT '',
    MODIFY participant_id int(11) NOT NULL DEFAULT '0' COMMENT '',
    MODIFY created datetime NULL DEFAULT NULL COMMENT '',
    MODIFY created_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    MODIFY modified datetime NULL DEFAULT NULL COMMENT '',
    MODIFY modified_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '';


ALTER TABLE drugs
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    MODIFY description text NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    MODIFY created datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    MODIFY created_by int(11) NOT NULL DEFAULT '0' COMMENT '',
    MODIFY modified datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    MODIFY modified_by int(11) NOT NULL DEFAULT '0' COMMENT '';
#
#  Fieldformats of
#    drugs.description changed from varchar(255) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci to text NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci.
#    drugs.created changed from date NOT NULL DEFAULT '0000-00-00' COMMENT '' to datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT ''.
#    drugs.created_by changed from varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci to int(11) NOT NULL DEFAULT '0' COMMENT ''.
#    drugs.modified changed from date NOT NULL DEFAULT '0000-00-00' COMMENT '' to datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT ''.
#    drugs.modified_by changed from varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci to int(11) NOT NULL DEFAULT '0' COMMENT ''.
#  Possibly data modifications needed!
#

ALTER TABLE ed_all_adverse_events_adverse_event
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER event_master_id,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    MODIFY event_master_id int(11) NULL DEFAULT NULL COMMENT '';
#
#  Fieldformat of
#    ed_all_adverse_events_adverse_event.event_master_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#  Possibly data modifications needed!
#

ALTER TABLE ed_all_clinical_followup
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER event_master_id,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    MODIFY event_master_id int(11) NULL DEFAULT NULL COMMENT '';
#
#  Fieldformat of
#    ed_all_clinical_followup.event_master_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#  Possibly data modifications needed!
#

ALTER TABLE ed_all_clinical_presentation
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER event_master_id,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    MODIFY weight int(11) NULL DEFAULT NULL COMMENT '',
    MODIFY event_master_id int(11) NULL DEFAULT NULL COMMENT '';
#
#  Fieldformats of
#    ed_all_clinical_presentation.weight changed from decimal(10,2) NULL DEFAULT NULL COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#    ed_all_clinical_presentation.event_master_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#  Possibly data modifications needed!
#

ALTER TABLE ed_all_lifestyle_base
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER event_master_id,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    MODIFY event_master_id int(11) NULL DEFAULT NULL COMMENT '';
#
#  Fieldformat of
#    ed_all_lifestyle_base.event_master_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#  Possibly data modifications needed!
#

#TODO this table is in use
#DROP TABLE ed_all_procure_lifestyle;

ALTER TABLE ed_all_protocol_followup
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER event_master_id,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    MODIFY event_master_id int(11) NULL DEFAULT NULL COMMENT '';
#
#  Fieldformat of
#    ed_all_protocol_followup.event_master_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#  Possibly data modifications needed!
#

ALTER TABLE ed_all_study_research
    ADD file_path varchar(255) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci AFTER event_master_id,
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    MODIFY event_master_id int(11) NULL DEFAULT NULL COMMENT '';
#
#  Fieldformat of
#    ed_all_study_research.event_master_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#  Possibly data modifications needed!
#

ALTER TABLE ed_allsolid_lab_pathology
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER event_master_id,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    MODIFY event_master_id int(11) NULL DEFAULT NULL COMMENT '';
#
#  Fieldformat of
#    ed_allsolid_lab_pathology.event_master_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#  Possibly data modifications needed!
#

#TODO this table is in use
#DROP TABLE ed_biopsy_clin_event;

ALTER TABLE ed_breast_lab_pathology
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER event_master_id,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    MODIFY event_master_id int(11) NULL DEFAULT NULL COMMENT '',
    ADD INDEX event_master_id (event_master_id);
#
#  Fieldformat of
#    ed_breast_lab_pathology.event_master_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#  Possibly data modifications needed!
#

ALTER TABLE ed_breast_screening_mammogram
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER event_master_id,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    MODIFY event_master_id int(11) NULL DEFAULT NULL COMMENT '';
#
#  Fieldformat of
#    ed_breast_screening_mammogram.event_master_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#  Possibly data modifications needed!
#

#TODO this table is in use
#DROP TABLE ed_coll_for_cyto_clin_event;

#TODO this table is in use
#DROP TABLE ed_examination_clin_event;

#TODO this table is in use
#DROP TABLE ed_lab_blood_report;

#TODO this table is in use
#DROP TABLE ed_lab_path_report;

#TODO this table is in use
#DROP TABLE ed_lab_revision_report;

#TODO this table is in use
#DROP TABLE ed_medical_imaging_clin_event;

ALTER TABLE event_controls
    ADD display_order int(11) NOT NULL DEFAULT '0' COMMENT '' AFTER detail_tablename;

#TODO validate/move dropped fields
ALTER TABLE event_masters
    ADD event_control_id int(11) NOT NULL DEFAULT '0' COMMENT '' AFTER id,
    CHANGE diagnosis_id diagnosis_master_id int(11) NULL DEFAULT NULL COMMENT '' AFTER participant_id,
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER diagnosis_master_id,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    #DROP approximative_event_date,
    #DROP result,
    #DROP therapeutic_goal,
    #DROP linked_path_report_id,
    #DROP sardo_record_id,
    #DROP sardo_record_source,
    #DROP last_sardo_import_date,
    DROP form_alias,
    DROP detail_tablename,
    MODIFY participant_id int(11) NULL DEFAULT NULL COMMENT '',
    DROP INDEX diagnosis_id,
    ADD INDEX diagnosis_id (diagnosis_master_id),
    DROP INDEX linked_path_report_id,
    ADD INDEX event_control_id (event_control_id);
#
#  Fieldformat of
#    event_masters.participant_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#  Possibly data modifications needed!
#

#TODO convert approximative yes/no to range
ALTER TABLE family_histories
    CHANGE domain family_domain varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    CHANGE icd10_id primary_icd10_code varchar(10) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci AFTER family_domain,
    ADD previous_primary_code varchar(10) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci AFTER primary_icd10_code,
    ADD previous_primary_code_system varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci AFTER previous_primary_code,
    ADD age_at_dx_accuracy varchar(100) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci AFTER age_at_dx,
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    MODIFY relation varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    DROP dx_date, #does not exist anymore
    DROP approximative_dx_date,
    DROP dx_date_status,#always null
    DROP age_at_dx_status,#always null
    #--do not drop custom column DROP sardo_diagnosis_id,
    #--do not drop custom column DROP last_sardo_import_date,
    ADD INDEX FK_family_histories_icd10_code (primary_icd10_code);
#
#  Fieldformat of
#    family_histories.relation changed from varchar(20) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci to varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci.
#  Possibly data modifications needed!
#

DROP TABLE form_fields;

DROP TABLE form_fields_global_lookups;

DROP TABLE form_formats;

DROP TABLE form_validations;

DROP TABLE forms;

DROP TABLE global_lookups;

#TODO validate
ALTER TABLE groups
    MODIFY bank_id int(11) NULL DEFAULT NULL COMMENT '',
    MODIFY name varchar(100) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    DROP level,
    DROP redirect,
    DROP perm_type,
    MODIFY created datetime NULL DEFAULT NULL COMMENT '',
    DROP created_by,
    MODIFY modified datetime NULL DEFAULT NULL COMMENT '',
    DROP modified_by;
#
#  Fieldformats of
#    groups.bank_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#    groups.name changed from varchar(255) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci to varchar(100) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci.
#    groups.created changed from datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '' to datetime NULL DEFAULT NULL COMMENT ''.
#    groups.modified changed from datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '' to datetime NULL DEFAULT NULL COMMENT ''.
#  Possibly data modifications needed!
#

#TODO validate
DROP TABLE groups_permissions;

ALTER TABLE i18n
    ALTER page_id SET DEFAULT '';

#TODO - what are those tables?
DROP TABLE install_disease_sites;

DROP TABLE install_locations;

DROP TABLE install_studies;

DROP TABLE lab_type_laterality_match;

ALTER TABLE materials
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted;

#menus is rebuilt from scratch
DROP TABLE menus;

ALTER TABLE misc_identifiers
    CHANGE name identifier_name varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci AFTER identifier_value,
    CHANGE memo notes varchar(100) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci AFTER expiry_date,
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted;

#TODO order_items clean up
ALTER TABLE order_items
    ADD order_line_id int(11) NULL DEFAULT NULL COMMENT '' AFTER modified_by,
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER aliquot_use_id,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    #DROP barcode,
    #DROP shipping_name,
    #DROP base_price,
    #DROP datetime_scanned_out,
    #DROP orderline_id,
    MODIFY aliquot_use_id int(11) NULL DEFAULT NULL COMMENT '',
    ADD INDEX FK_order_items_order_lines (order_line_id),
    ADD INDEX FK_order_items_shipments (shipment_id),
    ADD INDEX FK_order_items_aliquot_masters (aliquot_master_id),
    ADD INDEX FK_order_items_aliquot_uses (aliquot_use_id);
#
#  Fieldformat of
#    order_items.aliquot_use_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#  Possibly data modifications needed!
#

#TODO clean
ALTER TABLE order_lines
    CHANGE min_qty_ordered min_quantity_ordered varchar(30) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci AFTER quantity_ordered,
    ADD quantity_unit varchar(10) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci AFTER min_quantity_ordered,
    ADD product_code varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci AFTER modified_by,
    ADD aliquot_control_id int(11) NULL DEFAULT NULL COMMENT '' AFTER sample_control_id,
    ADD sample_aliquot_precision varchar(30) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci AFTER aliquot_control_id,
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER order_id,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    DROP cancer_type,
    MODIFY quantity_ordered varchar(30) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    #DROP quantity_UM,
    #DROP min_qty_UM,
    #DROP base_price,
    #DROP quantity_shipped,
    #DROP discount_id,
    #DROP product_id,
    ADD INDEX FK_order_lines_orders (order_id),
    ADD INDEX FK_order_lines_sample_controls (sample_control_id);
#
#  Fieldformat of
#    order_lines.quantity_ordered changed from int(255) NULL DEFAULT NULL COMMENT '' to varchar(30) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci.
#  Possibly data modifications needed!
#

#TODO clean
ALTER TABLE orders
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER study_summary_id,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    #DROP type,
    #DROP microarray_chip,
    ADD INDEX order_number (order_number),
    ADD INDEX FK_orders_study_summaries (study_summary_id);


ALTER TABLE part_bank_nbr_counters
	CHANGE bank_ident_title keyname varchar(50) NOT NULL,
	CHANGE last_nbr key_value int(11) NOT NULL;
RENAME TABLE part_bank_nbr_counters TO key_increments;
UPDATE key_increments SET key_value=key_value + 1; #the old system had the previous value rather than the next one

#TODO validate
ALTER TABLE participant_contacts
    CHANGE name contact_name varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci AFTER id,
    CHANGE memo notes text NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci AFTER expiry_date,
    ADD locality varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci AFTER street,
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER participant_id,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    #DROP facility,
    #DROP type_precision,
    #DROP street_nbr,
    #DROP city,
    MODIFY phone varchar(15) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    MODIFY phone_secondary varchar(15) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    MODIFY participant_id int(11) NULL DEFAULT NULL COMMENT '';
#
#  Fieldformats of
#    participant_contacts.phone changed from varchar(30) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci to varchar(15) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci.
#    participant_contacts.phone_secondary changed from varchar(30) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci to varchar(15) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci.
#    participant_contacts.participant_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#  Possibly data modifications needed!
#

#TODO validate
ALTER TABLE participant_messages
    CHANGE type message_type varchar(20) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci AFTER author,
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    #DROP status,
    MODIFY participant_id int(11) NULL DEFAULT NULL COMMENT '';
    #--do not drop custom field DROP sardo_note_id,
    #--do not drop custom field DROP last_sardo_import_date;
#
#  Fieldformat of
#    participant_messages.participant_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#  Possibly data modifications needed!
#

#TODO validate
ALTER TABLE participants
    ADD dob_date_accuracy varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci AFTER date_of_birth,
    CHANGE memo notes text NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci AFTER vital_status,
    ADD dod_date_accuracy varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci AFTER date_of_death,
    CHANGE icd10_id cod_icd10_code varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci AFTER dod_date_accuracy,
    ADD secondary_cod_icd10_code varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci AFTER cod_icd10_code,
    ADD cod_confirmation_source varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci AFTER secondary_cod_icd10_code,
    ADD participant_identifier varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci AFTER cod_confirmation_source,
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    MODIFY title varchar(10) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    MODIFY first_name varchar(20) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    MODIFY last_name varchar(20) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    #DROP approximative_date_of_birth,
    #DROP date_status,
    MODIFY sex varchar(20) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    MODIFY race varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    #DROP ethnicity,
    #DROP status,
    #DROP approximative_date_of_death,
    #DROP death_certificate_ident,
    #DROP confirmation_source,
    #DROP tb_number,
    #DROP last_visit_date,
    #DROP approximative_last_visit_date,
    #--do not drop custom column DROP sardo_participant_id,
    #--do not drop custom column DROP sardo_numero_dossier,
    #--do not drop custom column DROP last_sardo_import_date,
    MODIFY created datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    MODIFY created_by varchar(255) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    MODIFY modified datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    MODIFY modified_by varchar(255) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    ADD UNIQUE unique_participant_identifier (participant_identifier),
    ADD INDEX participant_identifier (participant_identifier),
    ADD INDEX FK_participants_icd10_code (cod_icd10_code),
    ADD INDEX FK_participants_icd10_code_2 (secondary_cod_icd10_code);
#
#  Fieldformats of
#    participants.title changed from varchar(10) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci to varchar(10) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci.
#    participants.first_name changed from varchar(20) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci to varchar(20) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci.
#    participants.last_name changed from varchar(20) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci to varchar(20) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci.
#    participants.sex changed from char(1) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci to varchar(20) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci.
#    participants.race changed from varchar(30) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci to varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci.
#    participants.created changed from datetime NULL DEFAULT NULL COMMENT '' to datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT ''.
#    participants.created_by changed from varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci to varchar(255) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci.
#    participants.modified changed from datetime NULL DEFAULT NULL COMMENT '' to datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT ''.
#    participants.modified_by changed from varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci to varchar(255) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci.
#  Possibly data modifications needed!
#

ALTER TABLE path_collection_reviews
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    MODIFY collection_id int(11) NULL DEFAULT NULL COMMENT '',
    MODIFY sample_master_id int(11) NULL DEFAULT NULL COMMENT '',
    MODIFY aliquot_master_id int(11) NULL DEFAULT NULL COMMENT '';
#
#  Fieldformats of
#    path_collection_reviews.collection_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#    path_collection_reviews.sample_master_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#    path_collection_reviews.aliquot_master_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#  Possibly data modifications needed!
#

#TODO validate - doesn't seem right
ALTER TABLE pd_chemos
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER protocol_master_id,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    #DROP num_cycles,
    #DROP length_cycles,
    MODIFY protocol_master_id int(11) NULL DEFAULT NULL COMMENT '';
#
#  Fieldformat of
#    pd_chemos.protocol_master_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#  Possibly data modifications needed!
#

#this table is in use. where do the data go?
#DROP TABLE pd_undetailled_protocols;

ALTER TABLE pe_chemos
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER drug_id,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted;

#ok, empty table
DROP TABLE pe_undetailled_protocols;

#TODO validate, looks useless
DROP TABLE permissions;

ALTER TABLE protocol_controls
    CHANGE detail_form_alias form_alias varchar(255) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci AFTER detail_tablename;

UPDATE protocol_controls SET detail_tablename='pd_chemos', form_alias='pd_chemos', extend_tablename='pd_chemos' WHERE id=1;


ALTER TABLE protocol_masters
    ADD protocol_control_id int(11) NOT NULL DEFAULT '0' COMMENT '' AFTER id,
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER form_id,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    DROP detail_tablename,
    DROP detail_form_alias,
    DROP extend_tablename,
    DROP extend_form_alias;


RENAME qc_tested_aliquots TO quality_ctrl_tested_aliquots;

ALTER TABLE quality_ctrl_tested_aliquots
    ADD COLUMN deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    ADD COLUMN deleted_date datetime NULL DEFAULT NULL COMMENT '';

#TODO validate drop column chip_model
RENAME TABLE quality_controls TO quality_ctrls;
ALTER TABLE quality_ctrls
    ADD COLUMN qc_code varchar(20) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    ADD COLUMN run_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    ADD COLUMN deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    ADD COLUMN deleted_date datetime NULL DEFAULT NULL COMMENT '',
    #DROP COLUMN chip_model
    ;

ALTER TABLE rd_blood_cells
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    MODIFY review_master_id int(11) NULL DEFAULT NULL COMMENT '';
#
#  Fieldformat of
#    rd_blood_cells.review_master_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#  Possibly data modifications needed!
#

ALTER TABLE rd_bloodcellcounts
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    MODIFY review_master_id int(11) NULL DEFAULT NULL COMMENT '';
#
#  Fieldformat of
#    rd_bloodcellcounts.review_master_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#  Possibly data modifications needed!
#

ALTER TABLE rd_breast_cancers
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    MODIFY review_master_id int(11) NULL DEFAULT NULL COMMENT '',
    MODIFY tumour_type_id int(11) NULL DEFAULT NULL COMMENT '';
#
#  Fieldformats of
#    rd_breast_cancers.review_master_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#    rd_breast_cancers.tumour_type_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#  Possibly data modifications needed!
#

ALTER TABLE rd_breastcancertypes
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    MODIFY review_master_id int(11) NULL DEFAULT NULL COMMENT '';
#
#  Fieldformat of
#    rd_breastcancertypes.review_master_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#  Possibly data modifications needed!
#

ALTER TABLE rd_coloncancertypes
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    MODIFY review_master_id int(11) NULL DEFAULT NULL COMMENT '';
#
#  Fieldformat of
#    rd_coloncancertypes.review_master_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#  Possibly data modifications needed!
#

ALTER TABLE rd_genericcancertypes
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    MODIFY review_master_id int(11) NULL DEFAULT NULL COMMENT '';
#
#  Fieldformat of
#    rd_genericcancertypes.review_master_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#  Possibly data modifications needed!
#

ALTER TABLE rd_ovarianuteruscancertypes
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    MODIFY review_master_id int(11) NULL DEFAULT NULL COMMENT '';
#
#  Fieldformat of
#    rd_ovarianuteruscancertypes.review_master_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#  Possibly data modifications needed!
#

#TODO validate dropped columns
ALTER TABLE realiquotings
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    MODIFY parent_aliquot_master_id int(11) NULL DEFAULT NULL COMMENT '',
    MODIFY child_aliquot_master_id int(11) NULL DEFAULT NULL COMMENT '',
    MODIFY aliquot_use_id int(11) NULL DEFAULT NULL COMMENT '',
    #DROP realiquoted_by,
    #DROP realiquoted_datetime,
    DROP INDEX parent_aliquot_master_id,
    DROP INDEX child_aliquot_master_id,
    DROP INDEX aliquot_use_id,
    ADD INDEX FK_realiquotings_parent_aliquot_masters (parent_aliquot_master_id),
    ADD INDEX FK_realiquotings_child_aliquot_masters (child_aliquot_master_id),
    ADD INDEX FK_realiquotings_aliquot_uses (aliquot_use_id);
#
#  Fieldformats of
#    realiquotings.parent_aliquot_master_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#    realiquotings.child_aliquot_master_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#    realiquotings.aliquot_use_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#  Possibly data modifications needed!
#

#TODO looks like a major refactoring
ALTER TABLE reproductive_histories
    ADD menopause_onset_reason varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci AFTER menopause_status,
    ADD menopause_age_accuracy varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci AFTER age_at_menopause,
    ADD age_at_menarche_accuracy varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci AFTER age_at_menarche,
    ADD hrt_years_used int(11) NULL DEFAULT NULL COMMENT '' AFTER age_at_menarche_accuracy,
    ADD hysterectomy_age_accuracy varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci AFTER hysterectomy_age,
    ADD ovary_removed_type varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci AFTER hysterectomy,
    ADD first_parturition_accuracy varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci AFTER age_at_first_parturition,
    ADD last_parturition_accuracy varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci AFTER age_at_last_parturition,
    ADD hormonal_contraceptive_use varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci AFTER last_parturition_accuracy,
    ADD years_on_hormonal_contraceptives int(11) NULL DEFAULT NULL COMMENT '' AFTER hormonal_contraceptive_use,
    ADD lnmp_accuracy varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci AFTER lnmp_date,
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    MODIFY menopause_status varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    #DROP menopause_age_certainty,
    #DROP hrt_years_on,
    #DROP hysterectomy_age_certainty,
    #DROP first_ovary_out_age,
    #DROP first_ovary_certainty,
    #DROP second_ovary_out_age,
    #DROP second_ovary_certainty,
    #DROP first_ovary_out,
    #DROP second_ovary_out,
    #DROP aborta,
    #DROP first_parturition_certainty,
    #DROP last_parturition_certainty,
    #DROP age_at_menarche_certainty,
    #DROP oralcontraceptive_use,
    #DROP years_on_oralcontraceptives,
    #DROP lnmp_certainty,
    MODIFY created datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    MODIFY modified datetime NULL DEFAULT NULL COMMENT '',
    MODIFY participant_id int(11) NULL DEFAULT NULL COMMENT '',
    ADD INDEX participant_id (participant_id);
#
#  Fieldformats of
#    reproductive_histories.menopause_status changed from varchar(20) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci to varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci.
#    reproductive_histories.created changed from date NOT NULL DEFAULT '0000-00-00' COMMENT '' to datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT ''.
#    reproductive_histories.modified changed from date NOT NULL DEFAULT '0000-00-00' COMMENT '' to datetime NULL DEFAULT NULL COMMENT ''.
#    reproductive_histories.participant_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#  Possibly data modifications needed!
#

ALTER TABLE review_controls
    ADD display_order int(11) NOT NULL DEFAULT '0' COMMENT '' AFTER detail_tablename,
    MODIFY form_alias varchar(255) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    MODIFY detail_tablename varchar(255) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci;
#
#  Fieldformats of
#    review_controls.form_alias changed from varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci to varchar(255) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci.
#    review_controls.detail_tablename changed from varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci to varchar(255) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci.
#  Possibly data modifications needed!
#

ALTER TABLE review_masters
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    MODIFY collection_id int(11) NULL DEFAULT NULL COMMENT '',
    MODIFY sample_master_id int(11) NULL DEFAULT NULL COMMENT '';
#
#  Fieldformats of
#    review_masters.collection_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#    review_masters.sample_master_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#  Possibly data modifications needed!
#

ALTER TABLE rtbforms
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    MODIFY created_by int(11) NULL DEFAULT NULL COMMENT '',
    MODIFY modified_by int(11) NULL DEFAULT NULL COMMENT '';
#
#  Fieldformats of
#    rtbforms.created_by changed from varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci to int(11) NULL DEFAULT NULL COMMENT ''.
#    rtbforms.modified_by changed from varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci to int(11) NULL DEFAULT NULL COMMENT ''.
#  Possibly data modifications needed!
#

DROP TABLE sample_aliquot_control_links;

ALTER TABLE sample_controls
    ADD display_order int(11) NOT NULL DEFAULT '0' COMMENT '' AFTER detail_tablename,
    MODIFY form_alias varchar(255) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    MODIFY detail_tablename varchar(255) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci;
#
#  Fieldformats of
#    sample_controls.form_alias changed from varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci to varchar(255) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci.
#    sample_controls.detail_tablename changed from varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci to varchar(255) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci.
#  Possibly data modifications needed!
#

ALTER TABLE sample_masters
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    MODIFY collection_id int(11) NULL DEFAULT NULL COMMENT '',
    DROP sample_label,
    DROP INDEX sample_control_id,
    DROP INDEX initial_specimen_sample_id,
    DROP INDEX parent_id,
    DROP INDEX collection_id,
    DROP INDEX sop_master_id,
    ADD UNIQUE unique_sample_code (sample_code),
    ADD INDEX sample_code (sample_code),
    ADD INDEX FK_sample_masters_collections (collection_id),
    ADD INDEX FK_sample_masters_sample_controls (sample_control_id),
    ADD INDEX FK_sample_masters_sample_specimens (initial_specimen_sample_id),
    ADD INDEX FK_sample_masters_parent (parent_id),
    ADD INDEX FK_sample_masters_sops (sop_master_id);
#
#  Fieldformat of
#    sample_masters.collection_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#  Possibly data modifications needed!
#

RENAME TABLE sd_der_amplified_rnas TO sd_der_amp_rnas;
    ADD COLUMN deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    ADD COLUMN deleted_date datetime NULL DEFAULT NULL COMMENT '';

ALTER TABLE sd_der_blood_cells
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    MODIFY sample_master_id int(11) NULL DEFAULT NULL COMMENT '',
    DROP INDEX sample_master_id,
    ADD INDEX FK_sd_der_blood_cells_sample_masters (sample_master_id);
#
#  Fieldformat of
#    sd_der_blood_cells.sample_master_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#  Possibly data modifications needed!
#

ALTER TABLE sd_der_cell_cultures
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    MODIFY sample_master_id int(11) NULL DEFAULT NULL COMMENT '',
    MODIFY cell_passage_number int(6) NULL DEFAULT NULL COMMENT '',
    DROP INDEX sample_master_id,
    ADD INDEX FK_sd_der_cell_cultures_sample_masters (sample_master_id);
#
#  Fieldformats of
#    sd_der_cell_cultures.sample_master_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#    sd_der_cell_cultures.cell_passage_number changed from varchar(10) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci to int(6) NULL DEFAULT NULL COMMENT ''.
#  Possibly data modifications needed!
#

ALTER TABLE sd_der_dnas
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    MODIFY sample_master_id int(11) NULL DEFAULT NULL COMMENT '',
    #DROP source_cell_passage_number,
    #DROP source_temperature,
    #DROP source_temp_unit,
    DROP INDEX sample_master_id,
    ADD INDEX FK_sd_der_dnas_sample_masters (sample_master_id);
#
#  Fieldformat of
#    sd_der_dnas.sample_master_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#  Possibly data modifications needed!
#

ALTER TABLE sd_der_pbmcs
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    MODIFY sample_master_id int(11) NULL DEFAULT NULL COMMENT '',
    DROP INDEX sample_master_id,
    ADD INDEX FK_sd_der_pbmcs_sample_masters (sample_master_id);
#
#  Fieldformat of
#    sd_der_pbmcs.sample_master_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#  Possibly data modifications needed!
#

ALTER TABLE sd_der_plasmas
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    MODIFY sample_master_id int(11) NULL DEFAULT NULL COMMENT '',
    DROP INDEX sample_master_id,
    ADD INDEX FK_sd_der_plasmas_sample_masters (sample_master_id);
#
#  Fieldformat of
#    sd_der_plasmas.sample_master_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#  Possibly data modifications needed!
#

#TODO validate dropped columns
ALTER TABLE sd_der_rnas
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    MODIFY sample_master_id int(11) NULL DEFAULT NULL COMMENT '',
    #DROP source_cell_passage_number,
    #DROP source_temperature,
    #DROP source_temp_unit,
    DROP INDEX sample_master_id,
    ADD INDEX FK_sd_der_rnas_sample_masters (sample_master_id);
#
#  Fieldformat of
#    sd_der_rnas.sample_master_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#  Possibly data modifications needed!
#

ALTER TABLE sd_der_serums
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    MODIFY sample_master_id int(11) NULL DEFAULT NULL COMMENT '',
    DROP INDEX sample_master_id,
    ADD INDEX FK_sd_der_serums_sample_masters (sample_master_id);
#
#  Fieldformat of
#    sd_der_serums.sample_master_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#  Possibly data modifications needed!
#

ALTER TABLE sd_spe_ascites
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    MODIFY sample_master_id int(11) NULL DEFAULT NULL COMMENT '',
    DROP INDEX sample_master_id,
    ADD INDEX FK_sd_spe_ascites_sample_masters (sample_master_id);
#
#  Fieldformat of
#    sd_spe_ascites.sample_master_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#  Possibly data modifications needed!
#

ALTER TABLE sd_spe_bloods
    CHANGE type blood_type varchar(30) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci AFTER sample_master_id,
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    MODIFY sample_master_id int(11) NULL DEFAULT NULL COMMENT '',
    DROP INDEX sample_master_id,
    ADD INDEX FK_sd_spe_bloods_sample_masters (sample_master_id);
#
#  Fieldformat of
#    sd_spe_bloods.sample_master_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#  Possibly data modifications needed!
#

ALTER TABLE sd_spe_cystic_fluids
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    MODIFY sample_master_id int(11) NULL DEFAULT NULL COMMENT '',
    DROP INDEX sample_master_id,
    ADD INDEX FK_sd_spe_cystic_fluids_sample_masters (sample_master_id);
#
#  Fieldformat of
#    sd_spe_cystic_fluids.sample_master_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#  Possibly data modifications needed!
#

DROP TABLE sd_spe_other_fluids;

ALTER TABLE sd_spe_peritoneal_washes
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    MODIFY sample_master_id int(11) NULL DEFAULT NULL COMMENT '',
    DROP INDEX sample_master_id,
    ADD INDEX FK_sd_spe_peritoneal_washes_sample_masters (sample_master_id);
#
#  Fieldformat of
#    sd_spe_peritoneal_washes.sample_master_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#  Possibly data modifications needed!
#

ALTER TABLE sd_spe_tissues
    CHANGE nature tissue_nature varchar(15) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci AFTER tissue_source,
    CHANGE laterality tissue_laterality varchar(10) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci AFTER tissue_nature,
    CHANGE size tissue_size varchar(20) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci AFTER pathology_reception_datetime,
    ADD tissue_size_unit varchar(10) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci AFTER tissue_size,
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    MODIFY sample_master_id int(11) NULL DEFAULT NULL COMMENT '',
    MODIFY tissue_source varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    #--do not drop custom field DROP labo_laterality,
    DROP INDEX sample_master_id,
    ADD INDEX FK_sd_spe_tissues_sample_masters (sample_master_id);
#
#  Fieldformats of
#    sd_spe_tissues.sample_master_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#    sd_spe_tissues.tissue_source changed from varchar(20) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci to varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci.
#  Possibly data modifications needed!
#

#TODO validate dropped fields
ALTER TABLE sd_spe_urines
    CHANGE aspect urine_aspect varchar(30) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci AFTER sample_master_id,
    CHANGE pellet pellet_signs varchar(10) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci AFTER collected_volume_unit,
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    MODIFY sample_master_id int(11) NULL DEFAULT NULL COMMENT '',
    #DROP received_volume,
    #DROP received_volume_unit,
    DROP INDEX sample_master_id,
    ADD INDEX FK_sd_spe_urines_sample_masters (sample_master_id);
#
#  Fieldformat of
#    sd_spe_urines.sample_master_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#  Possibly data modifications needed!
#

ALTER TABLE shelves
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    MODIFY storage_id int(11) NULL DEFAULT NULL COMMENT '';
#
#  Fieldformat of
#    shelves.storage_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#  Possibly data modifications needed!
#

ALTER TABLE shipments
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER order_id,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    ADD INDEX shipment_code (shipment_code),
    ADD INDEX recipient (recipient),
    ADD INDEX facility (facility),
    ADD INDEX FK_shipments_orders (order_id);


ALTER TABLE sop_controls
    CHANGE detail_form_alias form_alias varchar(255) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci AFTER detail_tablename,
    ADD display_order int(11) NOT NULL DEFAULT '0' COMMENT '' AFTER extend_form_alias;


ALTER TABLE sop_masters
    ADD sop_control_id int(11) NOT NULL DEFAULT '0' COMMENT '' AFTER id,
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER form_id,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    DROP detail_tablename,
    DROP detail_form_alias,
    DROP extend_tablename,
    DROP extend_form_alias;


ALTER TABLE sopd_general_all
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER sop_master_id,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    MODIFY sop_master_id int(11) NULL DEFAULT NULL COMMENT '';
#
#  Fieldformat of
#    sopd_general_all.sop_master_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#  Possibly data modifications needed!
#

ALTER TABLE sope_general_all
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER material_id,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted;


ALTER TABLE source_aliquots
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    MODIFY sample_master_id int(11) NULL DEFAULT NULL COMMENT '',
    MODIFY aliquot_master_id int(11) NULL DEFAULT NULL COMMENT '',
    MODIFY aliquot_use_id int(11) NULL DEFAULT NULL COMMENT '',
    DROP INDEX aliquot_master_id,
    DROP INDEX aliquot_use_id,
    DROP INDEX sample_master_id,
    ADD INDEX FK_source_aliquots_aliquot_masters (aliquot_master_id),
    ADD INDEX FK_source_aliquots_aliquot_uses (aliquot_use_id),
    ADD INDEX FK_source_aliquots_sample_masters (sample_master_id);
#
#  Fieldformats of
#    source_aliquots.sample_master_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#    source_aliquots.aliquot_master_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#    source_aliquots.aliquot_use_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#  Possibly data modifications needed!
#

#TODO validate dropped columns
ALTER TABLE specimen_details
    ADD reception_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci AFTER supplier_dept,
    ADD reception_datetime datetime NULL DEFAULT NULL COMMENT '' AFTER reception_by,
    ADD reception_datetime_accuracy varchar(4) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci AFTER reception_datetime,
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    MODIFY sample_master_id int(11) NULL DEFAULT NULL COMMENT '',
    #DROP type_code,
    #DROP sequence_number,
    DROP INDEX sample_master_id,
    ADD INDEX FK_specimen_details_sample_masters (sample_master_id);
#
#  Fieldformat of
#    specimen_details.sample_master_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#  Possibly data modifications needed!
#

ALTER TABLE std_incubators
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    MODIFY storage_master_id int(11) NULL DEFAULT NULL COMMENT '',
    DROP INDEX storage_master_id,
    ADD INDEX FK_std_incubators_storage_masters (storage_master_id);
#
#  Fieldformat of
#    std_incubators.storage_master_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#  Possibly data modifications needed!
#

ALTER TABLE std_rooms
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    MODIFY storage_master_id int(11) NULL DEFAULT NULL COMMENT '',
    DROP INDEX storage_master_id,
    ADD INDEX FK_std_rooms_storage_masters (storage_master_id);
#
#  Fieldformat of
#    std_rooms.storage_master_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#  Possibly data modifications needed!
#

ALTER TABLE std_tma_blocks
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    MODIFY storage_master_id int(11) NULL DEFAULT NULL COMMENT '',
    DROP INDEX storage_master_id,
    DROP INDEX sop_master_id,
    ADD INDEX FK_std_tma_blocks_storage_masters (storage_master_id),
    ADD INDEX FK_std_tma_blocks_sop_masters (sop_master_id);
#
#  Fieldformat of
#    std_tma_blocks.storage_master_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#  Possibly data modifications needed!
#

ALTER TABLE storage_controls
    ADD square_box tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT 'This field is used if the storage only has one dimension size specified' AFTER coord_y_size,
    ADD horizontal_display tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT 'used on 1 dimension controls when y = 1' AFTER square_box,
    MODIFY form_alias varchar(255) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    MODIFY detail_tablename varchar(255) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci;
#
#  Fieldformats of
#    storage_controls.form_alias changed from varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci to varchar(255) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci.
#    storage_controls.detail_tablename changed from varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci to varchar(255) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci.
#  Possibly data modifications needed!
#

ALTER TABLE storage_coordinates
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    MODIFY storage_master_id int(11) NULL DEFAULT NULL COMMENT '',
    MODIFY coordinate_value varchar(50) NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    DROP INDEX storage_master_id,
    ADD INDEX FK_storage_coordinates_storage_masters (storage_master_id);
#
#  Fieldformats of
#    storage_coordinates.storage_master_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#    storage_coordinates.coordinate_value changed from varchar(30) NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci to varchar(50) NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci.
#  Possibly data modifications needed!
#

ALTER TABLE storage_masters
    ADD lft int(10) NULL DEFAULT NULL COMMENT '' AFTER parent_id,
    ADD rght int(10) NULL DEFAULT NULL COMMENT '' AFTER lft,
    ADD coord_x_order int(3) NULL DEFAULT NULL COMMENT '' AFTER parent_storage_coord_x,
    ADD coord_y_order int(3) NULL DEFAULT NULL COMMENT '' AFTER parent_storage_coord_y,
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    MODIFY barcode varchar(60) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    MODIFY short_label varchar(10) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    MODIFY selection_label varchar(60) NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    MODIFY parent_storage_coord_x varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    MODIFY parent_storage_coord_y varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    DROP INDEX storage_control_id,
    DROP INDEX parent_id,
    ADD UNIQUE unique_code (code),
    ADD INDEX code (code),
    ADD INDEX barcode (barcode),
    ADD INDEX short_label (short_label),
    ADD INDEX selection_label (selection_label),
    ADD INDEX FK_storage_masters_storage_controls (storage_control_id),
    ADD INDEX FK_storage_masters_parent (parent_id);
#
#  Fieldformats of
#    storage_masters.barcode changed from varchar(30) NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci to varchar(60) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci.
#    storage_masters.short_label changed from varchar(10) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci to varchar(10) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci.
#    storage_masters.selection_label changed from varchar(60) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci to varchar(60) NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci.
#    storage_masters.parent_storage_coord_x changed from varchar(11) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci to varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci.
#    storage_masters.parent_storage_coord_y changed from varchar(11) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci to varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci.
#  Possibly data modifications needed!
#

ALTER TABLE study_contacts
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER study_summary_id,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    DROP phone_country,
    DROP phone_area,
    MODIFY phone_number varchar(255) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    DROP phone2_country,
    DROP phone2_area,
    MODIFY phone2_number varchar(255) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    DROP fax_country,
    DROP fax_area,
    MODIFY fax_number varchar(255) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    MODIFY created datetime NULL DEFAULT NULL COMMENT '',
    MODIFY modified datetime NULL DEFAULT NULL COMMENT '',
    MODIFY study_summary_id int(11) NULL DEFAULT NULL COMMENT '',
    ADD INDEX FK_study_contacts_study_summaries (study_summary_id);
#
#  Fieldformats of
#    study_contacts.phone_number changed from int(11) NULL DEFAULT NULL COMMENT '' to varchar(255) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci.
#    study_contacts.phone2_number changed from int(11) NULL DEFAULT NULL COMMENT '' to varchar(255) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci.
#    study_contacts.fax_number changed from int(11) NULL DEFAULT NULL COMMENT '' to varchar(255) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci.
#    study_contacts.created changed from date NULL DEFAULT NULL COMMENT '' to datetime NULL DEFAULT NULL COMMENT ''.
#    study_contacts.modified changed from date NULL DEFAULT NULL COMMENT '' to datetime NULL DEFAULT NULL COMMENT ''.
#    study_contacts.study_summary_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#  Possibly data modifications needed!
#

#empty table
DROP TABLE study_ethicsboards;

ALTER TABLE study_fundings
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER study_summary_id,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    DROP phone_country,
    DROP phone_area,
    DROP fax_country,
    DROP fax_area,
    MODIFY created datetime NULL DEFAULT NULL COMMENT '',
    MODIFY modified datetime NULL DEFAULT NULL COMMENT '',
    MODIFY study_summary_id int(11) NULL DEFAULT NULL COMMENT '',
    ADD INDEX FK_study_fundings_study_summaries (study_summary_id);
#
#  Fieldformats of
#    study_fundings.created changed from date NULL DEFAULT NULL COMMENT '' to datetime NULL DEFAULT NULL COMMENT ''.
#    study_fundings.modified changed from date NULL DEFAULT NULL COMMENT '' to datetime NULL DEFAULT NULL COMMENT ''.
#    study_fundings.study_summary_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#  Possibly data modifications needed!
#

ALTER TABLE study_investigators
    ADD email varchar(45) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci AFTER sort,
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER study_summary_id,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    MODIFY created datetime NULL DEFAULT NULL COMMENT '',
    MODIFY modified datetime NULL DEFAULT NULL COMMENT '',
    MODIFY study_summary_id int(11) NULL DEFAULT NULL COMMENT '',
    ADD INDEX FK_study_investigators_study_summaries (study_summary_id);
#
#  Fieldformats of
#    study_investigators.created changed from date NULL DEFAULT NULL COMMENT '' to datetime NULL DEFAULT NULL COMMENT ''.
#    study_investigators.modified changed from date NULL DEFAULT NULL COMMENT '' to datetime NULL DEFAULT NULL COMMENT ''.
#    study_investigators.study_summary_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#  Possibly data modifications needed!
#

ALTER TABLE study_related
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER path_to_file,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    MODIFY created datetime NULL DEFAULT NULL COMMENT '',
    MODIFY modified datetime NULL DEFAULT NULL COMMENT '',
    MODIFY study_summary_id int(11) NULL DEFAULT NULL COMMENT '',
    ADD INDEX FK_study_related_study_summaries (study_summary_id);
#
#  Fieldformats of
#    study_related.created changed from date NULL DEFAULT NULL COMMENT '' to datetime NULL DEFAULT NULL COMMENT ''.
#    study_related.modified changed from date NULL DEFAULT NULL COMMENT '' to datetime NULL DEFAULT NULL COMMENT ''.
#    study_related.study_summary_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#  Possibly data modifications needed!
#

ALTER TABLE study_results
    ADD result_date datetime NULL DEFAULT NULL COMMENT '' AFTER future,
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER study_summary_id,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    MODIFY created datetime NULL DEFAULT NULL COMMENT '',
    MODIFY modified datetime NULL DEFAULT NULL COMMENT '',
    MODIFY study_summary_id int(11) NULL DEFAULT NULL COMMENT '',
    ADD INDEX FK_study_results_study_summaries (study_summary_id);
#
#  Fieldformats of
#    study_results.created changed from date NULL DEFAULT NULL COMMENT '' to datetime NULL DEFAULT NULL COMMENT ''.
#    study_results.modified changed from date NULL DEFAULT NULL COMMENT '' to datetime NULL DEFAULT NULL COMMENT ''.
#    study_results.study_summary_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#  Possibly data modifications needed!
#

ALTER TABLE study_reviews
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER study_summary_id,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    DROP phone_country,
    DROP phone_area,
    MODIFY created datetime NULL DEFAULT NULL COMMENT '',
    MODIFY modified datetime NULL DEFAULT NULL COMMENT '',
    MODIFY study_summary_id int(11) NULL DEFAULT NULL COMMENT '',
    ADD INDEX FK_study_reviews_study_summaries (study_summary_id);
#
#  Fieldformats of
#    study_reviews.created changed from date NULL DEFAULT NULL COMMENT '' to datetime NULL DEFAULT NULL COMMENT ''.
#    study_reviews.modified changed from date NULL DEFAULT NULL COMMENT '' to datetime NULL DEFAULT NULL COMMENT ''.
#    study_reviews.study_summary_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#  Possibly data modifications needed!
#

ALTER TABLE study_summaries
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER path_to_file,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    MODIFY created datetime NULL DEFAULT NULL COMMENT '',
    MODIFY modified datetime NULL DEFAULT NULL COMMENT '';
#
#  Fieldformats of
#    study_summaries.created changed from date NULL DEFAULT NULL COMMENT '' to datetime NULL DEFAULT NULL COMMENT ''.
#    study_summaries.modified changed from date NULL DEFAULT NULL COMMENT '' to datetime NULL DEFAULT NULL COMMENT ''.
#  Possibly data modifications needed!
#

ALTER TABLE tma_slides
    CHANGE std_tma_block_id tma_block_storage_master_id int(11) NULL DEFAULT NULL COMMENT '' AFTER id,
    ADD coord_x_order int(3) NULL DEFAULT NULL COMMENT '' AFTER storage_coord_x,
    ADD coord_y_order int(3) NULL DEFAULT NULL COMMENT '' AFTER storage_coord_y,
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    DROP INDEX storage_master_id,
    DROP INDEX sop_master_id,
    DROP INDEX std_tma_block_id,
    ADD UNIQUE unique_barcode (barcode),
    ADD INDEX barcode (barcode),
    ADD INDEX product_code (product_code),
    ADD INDEX FK_tma_slides_storage_masters (storage_master_id),
    ADD INDEX FK_tma_slides_sop_masters (sop_master_id),
    ADD INDEX FK_tma_slides_tma_blocks (tma_block_storage_master_id);

#empty table
DROP TABLE towers;

DROP TABLE tx_controls;
CREATE TABLE `tx_controls` (
  `id` int(11) NOT NULL auto_increment,
  `tx_method` varchar(50) default NULL,
  `disease_site` varchar(50) default NULL,
  `status` varchar(50) NOT NULL default '',
  `detail_tablename` varchar(255) NOT NULL,
  `form_alias` varchar(255) NOT NULL,
  `extend_tablename` varchar(255) NOT NULL default '',
  `extend_form_alias` varchar(255) NOT NULL default '',
  `display_order` int(11) NOT NULL default 0,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;
ALTER TABLE `tx_masters`
  ADD CONSTRAINT `FK_tx_masters_tx_controls`
  FOREIGN KEY (`treatment_control_id`) REFERENCES `tx_controls` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT;
INSERT INTO `tx_controls` (`id`, `tx_method`, `disease_site`, `status`, `detail_tablename`, `form_alias`, `extend_tablename`, `extend_form_alias`, `display_order`) VALUES
(1, 'chemotherapy', 'all', 'active', 'txd_chemos', 'txd_chemos', 'txe_chemos', 'txe_chemos', 0),
(2, 'radiation', 'all', 'active', 'txd_radiations', 'txd_radiations', 'txe_radiations', 'txe_radiations', 0),
(3, 'surgery', 'all', 'active', 'txd_surgeries', 'txd_surgeries', 'txe_surgeries', 'txe_surgeries', 0);

#
#  Fieldformat of
#    tx_controls.detail_tablename changed from varchar(255) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci to varchar(255) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci.
#  Possibly data modifications needed!
#

#TODO validate drops
ALTER TABLE tx_masters
    ADD treatment_control_id int(11) NOT NULL DEFAULT '0' COMMENT '' AFTER id,
    ADD tx_method varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci AFTER treatment_control_id,
    ADD target_site_icdo varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci AFTER tx_intent,
    ADD start_date_accuracy varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci AFTER start_date,
    ADD finish_date_accuracy varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci AFTER finish_date,
    CHANGE source information_source varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci AFTER finish_date_accuracy,
    CHANGE summary notes text NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci AFTER facility,
    CHANGE diagnosis_id diagnosis_master_id int(11) NULL DEFAULT NULL COMMENT '' AFTER participant_id,
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    #DROP `group`,
    MODIFY disease_site varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    DROP approximative_tx_date,
    #DROP result,
    #DROP therapeutic_goal,
    #--do not drop custom column DROP sardo_treatment_id,
    #--do not drop custom column DROP last_sardo_import_date,
    MODIFY participant_id int(11) NULL DEFAULT NULL COMMENT '',
    DROP INDEX diagnosis_id,
    ADD INDEX diagnosis_id (diagnosis_master_id),
    ADD INDEX treatment_control_id (treatment_control_id);
#
#  Fieldformats of
#    tx_masters.disease_site changed from varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci to varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci.
#    tx_masters.participant_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#  Possibly data modifications needed!
#

ALTER TABLE txd_chemos
    ADD chemo_completed varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci AFTER id,
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER tx_master_id,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    DROP completed,#always null
    MODIFY tx_master_id int(11) NULL DEFAULT NULL COMMENT '';
#
#  Fieldformat of
#    txd_chemos.tx_master_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#  Possibly data modifications needed!
#

#empty table
DROP TABLE txd_combos;

#TODO where shall this data go?
#DROP TABLE txd_drugs;

#TODO validate radiation_type
ALTER TABLE txd_radiations
    ADD rad_completed varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci AFTER id,
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    #DROP radiation_type,
    DROP source,#ok drop
    DROP mould,#ok drop
    MODIFY tx_master_id int(11) NULL DEFAULT NULL COMMENT '';
#
#  Fieldformat of
#    txd_radiations.tx_master_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#  Possibly data modifications needed!
#

#TODO validate drops
ALTER TABLE txd_surgeries
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    #DROP surgery_type,
    #DROP linked_path_report_id,
    DROP surgeon,#ok drop
    MODIFY tx_master_id int(11) NULL DEFAULT NULL COMMENT '',
    DROP INDEX linked_path_report_id;
#
#  Fieldformat of
#    txd_surgeries.tx_master_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#  Possibly data modifications needed!
#

#empty table
ALTER TABLE txe_chemos
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    DROP source,
    DROP frequency,
    DROP reduction,
    DROP cycle_number,
    DROP completed_cycles,
    DROP start_date,
    DROP end_date,
    MODIFY tx_master_id int(11) NOT NULL DEFAULT '0' COMMENT '',
    MODIFY drug_id int(11) NULL DEFAULT NULL COMMENT '';
#
#  Fieldformats of
#    txe_chemos.tx_master_id changed from int(11) NULL DEFAULT NULL COMMENT '' to int(11) NOT NULL DEFAULT '0' COMMENT ''.
#    txe_chemos.drug_id changed from varchar(50) NULL DEFAULT '0' COMMENT '' COLLATE latin1_swedish_ci to int(11) NULL DEFAULT NULL COMMENT ''.
#  Possibly data modifications needed!
#

ALTER TABLE txe_radiations
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER tx_master_id,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted;


ALTER TABLE txe_surgeries
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted;


ALTER TABLE user_logs
    MODIFY user_id int(11) NULL DEFAULT NULL COMMENT '';
#
#  Fieldformat of
#    user_logs.user_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#  Possibly data modifications needed!
#

ALTER TABLE users
    CHANGE passwd password varchar(255) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci AFTER last_name,
    ALTER help_visible DROP DEFAULT;

#
# DDL END
#

CREATE TABLE IF NOT EXISTS `menus` (
  `id` varchar(255) NOT NULL DEFAULT '',
  `parent_id` varchar(255) DEFAULT NULL,
  `is_root` int(11) NOT NULL DEFAULT '0',
  `display_order` int(11) NOT NULL DEFAULT '0',
  `language_title` text NOT NULL,
  `language_description` text,
  `use_link` varchar(255) NOT NULL DEFAULT '',
  `use_params` varchar(255) NOT NULL,
  `use_summary` varchar(255) NOT NULL,
  `active` varchar(255) NOT NULL DEFAULT 'yes',
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` varchar(255) NOT NULL DEFAULT '',
  `modified` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `modified_by` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `menus` (`id`, `parent_id`, `is_root`, `display_order`, `language_title`, `language_description`, `use_link`, `use_params`, `use_summary`, `active`, `created`, `created_by`, `modified`, `modified_by`) VALUES
('15', '3', 0, 5, 'path_collection_reviews', 'path_collection_reviews', '/unknown/', '', '', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('20', '11', 0, 99, 'consent', 'consent', '/under_development/', '', '', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('23', '3', 0, 3, 'review', 'review', '/unknow/', '', '', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('44', '18', 0, 1, 'aliquot detail', 'aliquot detail', '/inventorymanagement/aliquots/detail/', '', '', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('53', '18', 0, 10, 'aliquot annotation', 'aliquot annotation', '/under_development/', '', '', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('56', '3', 0, 10, 'participant', 'participant', '/under_development/', '', '', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('70', '55', 0, 0, 'storage', 'storage', '/underdev/', '', '', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('71', '55', 0, 0, 'shelf', 'shelf', '/inventorymanagement/shelves/listall/', '', '', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('72', '55', 0, 0, 'tower', 'tower', '/inventorymanagement/towers/listall/', '', '', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('73', '55', 0, 0, 'box', 'box', '/inventorymanagement/boxes/listall/', '', '', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('74', '70', 0, 0, 'storage detail', 'storage detail', '/underdev/', '', '', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('clin_CAN_1', 'MAIN_MENU_1', 1, 2, 'clinical annotation', 'clinical annotation description', '/clinicalannotation/participants/index/', '', '', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('clin_CAN_10', 'clin_CAN_1', 0, 5, 'family history', 'family history', '/clinicalannotation/family_histories/listall/%%Participant.id%%', '', 'Clinicalannotation.Participant::summary', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('clin_CAN_24', 'clin_CAN_1', 0, 6, 'identification', 'identification', '/clinicalannotation/misc_identifiers/listall/%%Participant.id%%', '', 'Clinicalannotation.Participant::summary', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('clin_CAN_25', 'clin_CAN_1', 0, 8, 'message', 'message', '/clinicalannotation/participant_messages/listall/%%Participant.id%%', '', 'Clinicalannotation.Participant::summary', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('clin_CAN_26', 'clin_CAN_1', 0, 3, 'contact', 'contact', '/clinicalannotation/participant_contacts/listall/%%Participant.id%%', '', 'Clinicalannotation.Participant::summary', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('clin_CAN_27', 'clin_CAN_4', 0, 6, 'screening', 'screening', '/clinicalannotation/event_masters/listall/screening/%%Participant.id%%', '', 'Clinicalannotation.EventControl::summary', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('clin_CAN_28', 'clin_CAN_4', 0, 3, 'lab', 'lab', '/clinicalannotation/event_masters/listall/lab/%%Participant.id%%', '', 'Clinicalannotation.EventControl::summary', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('clin_CAN_30', 'clin_CAN_4', 0, 4, 'lifestyle', 'lifestyle', '/clinicalannotation/event_masters/listall/lifestyle/%%Participant.id%%', '', 'Clinicalannotation.EventControl::summary', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('clin_CAN_31', 'clin_CAN_4', 0, 2, 'clinical', 'clinical', '/clinicalannotation/event_masters/listall/clinical/%%Participant.id%%', '', 'Clinicalannotation.EventControl::summary', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('clin_CAN_32', 'clin_CAN_4', 0, 1, 'adverse events', 'adverse events', '/clinicalannotation/event_masters/listall/adverse_events/%%Participant.id%%', '', 'Clinicalannotation.EventControl::summary', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('clin_CAN_33', 'clin_CAN_4', 0, 7, 'clin_study', 'clin_study', '/clinicalannotation/event_masters/listall/study/%%Participant.id%%', '', 'Clinicalannotation.EventControl::summary', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('clin_CAN_34', 'MAIN_MENU_1', 1, 7, 'batch entry', 'batch entry', '/underdevelopment/', '', '', 'no', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('clin_CAN_4', 'clin_CAN_1', 0, 1, 'annotation', 'annotation', '/clinicalannotation/event_masters/listall/adverse_events/%%Participant.id%%', '', 'Clinicalannotation.Participant::summary', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('clin_CAN_5', 'clin_CAN_1', 0, 4, 'diagnosis', 'diagnosis', '/clinicalannotation/diagnosis_masters/listall/%%Participant.id%%', '', 'Clinicalannotation.Participant::summary', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('clin_CAN_57', 'clin_CAN_1', 0, 11, 'products', 'products', '/clinicalannotation/product_masters/productsTreeView/%%Participant.id%%', '', 'Clinicalannotation.Participant::summary', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('clin_CAN_571', 'clin_CAN_57', 0, 1, 'tree view', NULL, '/clinicalannotation/product_masters/productsTreeView/%%Participant.id%%', '', 'Clinicalannotation.ClinicalCollectionLink::productFilterSummary', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('clin_CAN_572', 'clin_CAN_57', 0, 2, 'listall participant samples', NULL, '/underdevelopment/', '', '', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('clin_CAN_573', 'clin_CAN_57', 0, 3, 'listall participant aliquots', NULL, '/underdevelopment/', '', '', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('clin_CAN_5_1', 'clin_CAN_5', 0, 1, 'Details', 'Details', '/clinicalannotation/diagnosis_masters/detail/%%Participant.id%%/%%DiagnosisMaster.id%%/%%DiagnosisMaster.diagnosis_control_id%%', '', 'Clinicalannotation.DiagnosisMaster::summary', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('clin_CAN_5_2', 'clin_CAN_5', 0, 2, 'Comorbidity', 'Comorbidity', 'dev', '', '', 'no', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('clin_CAN_6', 'clin_CAN_1', 0, 9, 'profile', 'profile', '/clinicalannotation/participants/profile/%%Participant.id%%', '', 'Clinicalannotation.Participant::summary', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('clin_CAN_67', 'clin_CAN_1', 0, 7, 'link to collection', 'link to collection', '/clinicalannotation/clinical_collection_links/listall/%%Participant.id%%', '', 'Clinicalannotation.Participant::summary', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('clin_CAN_68', 'clin_CAN_1', 0, 10, 'reproductive history', 'reproductive history', '/clinicalannotation/reproductive_histories/listall/%%Participant.id%%', '', 'Clinicalannotation.Participant::summary', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('clin_CAN_69', 'clin_CAN_4', 0, 5, 'protocol', 'protocol', '/clinicalannotation/event_masters/listall/protocol/%%Participant.id%%', '', 'Clinicalannotation.EventControl::summary', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('clin_CAN_75', 'clin_CAN_1', 0, 12, 'treatment', 'treatment', '/clinicalannotation/treatment_masters/listall/%%Participant.id%%', '', 'Clinicalannotation.Participant::summary', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('clin_CAN_79', 'clin_CAN_75', 0, 1, 'treatment detail', 'treatment detail', '/clinicalannotation/treatment_masters/detail/%%Participant.id%%/%%TreatmentMaster.id%%', '', 'Clinicalannotation.TreatmentMaster::summary', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('clin_CAN_80', 'clin_CAN_75', 0, 2, 'administration', 'administration', '/clinicalannotation/treatment_extends/listall/%%Participant.id%%/%%TreatmentMaster.id%%', '', 'Clinicalannotation.TreatmentMaster::summary', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('clin_CAN_9', 'clin_CAN_1', 0, 2, 'consent', 'consent', '/clinicalannotation/consent_masters/listall/%%Participant.id%%', '', 'Clinicalannotation.Participant::summary', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('core_CAN_33', 'MAIN_MENU_1', 1, 6, 'core_tools', 'core_tools description', '/menus/tools/', '', '', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('core_CAN_41', 'core_CAN_33', 1, 1, 'core_administrate', 'core_administrate', '/administrate/banks', '', '', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('core_CAN_42', '0', 1, 5, 'core_customize', 'core_customize', '/customize/profiles/index/', '', '', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('core_CAN_70', 'core_CAN_41', 0, 1, 'atim version', 'atim version', '/administrate/versions/detail/', '', '', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('core_CAN_71', 'core_CAN_41', 0, 2, 'xMenus', 'xMenus', '/administrate/menus/index/', '', '', 'no', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('core_CAN_72', 'core_CAN_41', 0, 3, 'xForms', 'xForms', '/administrate/structures/index/', '', '', 'no', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('core_CAN_73', 'core_CAN_41', 0, 4, 'xBanks', 'xBanks', '/administrate/banks/index', '', '', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('core_CAN_74', 'core_CAN_73', 0, 1, 'core_detail', 'core_detail', '/administrate/banks/detail/%%Bank.id%%', '', 'Bank::summary', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('core_CAN_75', 'core_CAN_72', 0, 0, 'core_detail', 'core_detail', '/administrate/structures/detail/%%Structure.id%%', '', 'Structure::summary', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('core_CAN_76', 'core_CAN_72', 0, 1, 'xFields', 'xFields', '/administrate/structure_formats/listall/%%Structure.id%%', '', 'Structure::summary', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('core_CAN_84', 'core_CAN_42', 0, 3, 'core_myprofile', 'core_myprofile', '/customize/profiles/index/', '', '', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('core_CAN_85', 'core_CAN_42', 0, 4, 'core_myprefs', 'core_myprefs', '/customize/preferences/index/', '', '', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('core_CAN_86', 'core_CAN_73', 0, 2, 'core_groups', 'core_groups', '/administrate/groups/index/%%Bank.id%%', '', 'Bank::summary', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('core_CAN_87', 'core_CAN_86', 0, 1, 'core_detail', 'core_detail', '/administrate/groups/detail/%%Bank.id%%/%%Group.id%%', '', 'Group::summary', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('core_CAN_88', 'core_CAN_86', 0, 1, 'core_permissions', 'core_permissions', '/administrate/permissions/listall/%%Bank.id%%/%%Group.id%%', '', 'Group::summary', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('core_CAN_89', 'core_CAN_86', 0, 1, 'core_users', 'core_users', '/administrate/users/listall/%%Bank.id%%/%%Group.id%%', '', 'Group::summary', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('core_CAN_90', 'core_CAN_89', 0, 1, 'core_prefs', 'core_prefs', '/administrate/preferences/index/%%Bank.id%%/%%Group.id%%/%%User.id%%', '', 'User::summary', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('core_CAN_91', 'core_CAN_89', 0, 0, 'core_profile', 'core_profile', '/administrate/users/detail/%%Bank.id%%/%%Group.id%%/%%User.id%%', '', 'User::summary', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('core_CAN_93', 'core_CAN_42', 0, 5, 'core_mypasswd', 'core_mypasswd', '/customize/passwords/index/', '', '', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('core_CAN_94', 'core_CAN_89', 0, 2, 'core_passwd', 'core_passwd', '/administrate/passwords/index/%%Bank.id%%/%%Group.id%%/%%User.id%%', '', 'User::summary', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('core_CAN_95', 'core_CAN_89', 0, 3, 'core_userlogs', 'core_userlogs', '/administrate/user_logs/index/%%Bank.id%%/%%Group.id%%/%%User.id%%', '', 'User::summary', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('core_CAN_96', 'core_CAN_73', 0, 3, 'core_announcements', 'core_announcements', '/administrate/announcements/index/%%Bank.id%%', '', 'Bank::summary', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('core_CAN_97', 'core_CAN_42', 0, 1, 'core_announcements', 'core_announcements', '/customize/announcements/index/', '', '', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('core_CAN_98', 'core_CAN_86', 0, 1, 'core_announcements', 'core_announcements', '/administrate/announcements/index/%%Bank.id%%/%%Group.id%%', '', 'Group::summary', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('core_CAN_99', 'core_CAN_89', 0, 5, 'core_messages', 'core_messages', '/administrate/announcements/index/%%Bank.id%%/%%Group.id%%/%%User.id%%', '', 'User::summary', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('drug_CAN_96', 'core_CAN_33', 1, 2, 'drug administration', 'drug administration', '/drug/drugs/index/', '', '', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('drug_CAN_97', 'drug_CAN_96', 0, 1, 'details', 'details', '/drug/drugs/detail/', '', 'Drug.Drug::summary', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('inv_CAN', 'MAIN_MENU_1', 1, 3, 'inventory management', 'inventory management description', '/inventorymanagement/collections/index', '', '', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('inv_CAN_1', 'inv_CAN', 0, 1, 'collection details', NULL, '/inventorymanagement/collections/detail/%%Collection.id%%', '', 'Inventorymanagement.Collection::summary', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('inv_CAN_2', 'inv_CAN', 0, 2, 'listall collection content', NULL, '/inventorymanagement/sample_masters/contentTreeView/%%Collection.id%%', '', 'Inventorymanagement.Collection::summary', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('inv_CAN_21', 'inv_CAN_2', 0, 1, 'tree view', NULL, '/inventorymanagement/sample_masters/contentTreeView/%%Collection.id%%', '', 'Inventorymanagement.Collection::contentFilterSummary', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('inv_CAN_22', 'inv_CAN_2', 0, 2, 'listall collection samples', NULL, '/inventorymanagement/sample_masters/listAll/%%Collection.id%%/-1', '', 'Inventorymanagement.Collection::contentFilterSummary', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('inv_CAN_221', 'inv_CAN_22', 0, 1, 'details', NULL, '/inventorymanagement/sample_masters/detail/%%Collection.id%%/%%SampleMaster.initial_specimen_sample_id%%', '', 'Inventorymanagement.SampleMaster::specimenSummary', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('inv_CAN_222', 'inv_CAN_22', 0, 2, 'listall derivatives', NULL, '/inventorymanagement/sample_masters/listAll/%%Collection.id%%/%%SampleMaster.initial_specimen_sample_id%%', '', 'Inventorymanagement.SampleMaster::specimenSummary', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('inv_CAN_2221', 'inv_CAN_222', 0, 1, 'details', NULL, '/inventorymanagement/sample_masters/detail/%%Collection.id%%/%%SampleMaster.id%%', '', 'Inventorymanagement.SampleMaster::derivativeSummary', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('inv_CAN_2222', 'inv_CAN_222', 0, 2, 'listall source aliquots', NULL, '/inventorymanagement/aliquot_masters/listAllSourceAliquots/%%Collection.id%%/%%SampleMaster.id%%', '', 'Inventorymanagement.SampleMaster::derivativeSummary', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('inv_CAN_2223', 'inv_CAN_222', 0, 3, 'listall aliquots', NULL, '/inventorymanagement/aliquot_masters/listAll/%%Collection.id%%/%%SampleMaster.id%%', '', 'Inventorymanagement.SampleMaster::derivativeSummary', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('inv_CAN_22231', 'inv_CAN_2223', 0, 1, 'details', NULL, '/inventorymanagement/aliquot_masters/detail/%%Collection.id%%/%%SampleMaster.id%%/%%AliquotMaster.id%%', '', 'Inventorymanagement.AliquotMaster::summary', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('inv_CAN_22233', 'inv_CAN_2223', 0, 3, 'realiquoted parent', NULL, '/inventorymanagement/aliquot_masters/listAllRealiquotedParents/%%Collection.id%%/%%SampleMaster.id%%/%%AliquotMaster.id%%/', '', 'Inventorymanagement.AliquotMaster::summary', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('inv_CAN_2224', 'inv_CAN_222', 0, 4, 'quality controls', NULL, '/inventorymanagement/quality_ctrls/listAll/%%Collection.id%%/%%SampleMaster.id%%', '', 'Inventorymanagement.SampleMaster::derivativeSummary', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('inv_CAN_22241', 'inv_CAN_2224', 0, 1, 'details', NULL, '/inventorymanagement/quality_ctrls/detail/%%Collection.id%%/%%SampleMaster.id%%/%%QualityCtrl.id%%', '', 'Inventorymanagement.QualityCtrl::summary', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('inv_CAN_223', 'inv_CAN_22', 0, 3, 'listall aliquots', NULL, '/inventorymanagement/aliquot_masters/listAll/%%Collection.id%%/%%SampleMaster.initial_specimen_sample_id%%', '', 'Inventorymanagement.SampleMaster::specimenSummary', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('inv_CAN_2231', 'inv_CAN_223', 0, 1, 'details', NULL, '/inventorymanagement/aliquot_masters/detail/%%Collection.id%%/%%SampleMaster.initial_specimen_sample_id%%/%%AliquotMaster.id%%', '', 'Inventorymanagement.AliquotMaster::summary', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('inv_CAN_2233', 'inv_CAN_223', 0, 3, 'realiquoted parent', NULL, '/inventorymanagement/aliquot_masters/listAllRealiquotedParents/%%Collection.id%%/%%SampleMaster.initial_specimen_sample_id%%/%%AliquotMaster.id%%', '', 'Inventorymanagement.AliquotMaster::summary', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('inv_CAN_224', 'inv_CAN_22', 0, 4, 'quality controls', NULL, '/inventorymanagement/quality_ctrls/listAll/%%Collection.id%%/%%SampleMaster.initial_specimen_sample_id%%', '', 'Inventorymanagement.SampleMaster::specimenSummary', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('inv_CAN_2241', 'inv_CAN_224', 0, 1, 'details', NULL, '/inventorymanagement/quality_ctrls/detail/%%Collection.id%%/%%SampleMaster.initial_specimen_sample_id%%/%%QualityCtrl.id%%', '', 'Inventorymanagement.QualityCtrl::summary', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('inv_CAN_23', 'inv_CAN_2', 0, 3, 'listall collection aliquots', NULL, '/inventorymanagement/aliquot_masters/listAll/%%Collection.id%%/-1', '', 'Inventorymanagement.Collection::contentFilterSummary', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('inv_CAN_3', 'inv_CAN', 0, 3, 'listall collection path reviews', NULL, '/underdevelopment/', '', '', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('MAIN_MENU_1', '0', 1, 1, 'core_menu_main', 'core_menu_main', '/menus', '', '', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('MAIN_MENU_2', '0', 1, 7, 'logout', 'logout', '/users/logout', '', '', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('mat_CAN_01', 'core_CAN_33', 1, 6, 'sop_materials and equipment', 'sop_materials and equipment', '/material/materials/index/', '', '', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('mat_CAN_02', 'mat_CAN_01', 0, 1, 'detail', 'detail', '/material/materials/detail/', '', '', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('ord_CAN_101', 'core_CAN_33', 1, 4, 'order_order management', 'order_order management', '/order/orders/index/', '', '', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('ord_CAN_113', 'ord_CAN_101', 0, 1, 'details', 'order', '/order/orders/detail/%%Order.id%%/', '', 'Order.Order::summary', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('ord_CAN_114', 'ord_CAN_101', 0, 2, 'order_order lines', 'order_order lines', '/order/order_lines/listall/%%Order.id%%/', '', 'Order.Order::summary', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('ord_CAN_115', 'ord_CAN_114', 0, 1, 'order_order line detail', 'order_order line detail', '/order/order_lines/detail/%%Order.id%%/%%OrderLine.id%%/', '', 'Order.OrderLine::summary', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('ord_CAN_116', 'ord_CAN_101', 0, 3, 'order_shipments', 'order_shipments', '/order/shipments/listall/%%Order.id%%/', '', 'Order.Order::summary', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('ord_CAN_117', 'ord_CAN_114', 0, 2, 'order_order items', 'order_order items', '/order/order_items/listall/%%Order.id%%/%%OrderLine.id%%/', '', 'Order.OrderLine::summary', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('ord_CAN_118', 'ord_CAN_117', 0, 1, 'order_order item detail', 'order_order item detail', '/order/order_items/detail/%%Order.id%%/%%OrderLine.id%%/%%OrderItem.id%%/', '', '', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('ord_CAN_119', 'ord_CAN_116', 0, 1, 'order_shipment detail', 'order_shipment detail', '/order/shipments/detail/%%Order.id%%/%%Shipment.id%%/', '', 'Order.Shipment::summary', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('proto_CAN_37', 'core_CAN_33', 1, 5, 'protocols', 'protocols', '/protocol/protocol_masters/index/', '', '', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('proto_CAN_82', 'proto_CAN_37', 0, 1, 'protocol detail', 'protocol detail', '/protocol/protocol_masters/detail/%%ProtocolMaster.id%%', '', 'Protocol.ProtocolMaster::summary', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('proto_CAN_83', 'proto_CAN_37', 0, 2, 'protocol extend', 'protocol extend', '/protocol/protocol_extends/listall/%%ProtocolMaster.id%%', '', 'Protocol.ProtocolMaster::summary', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('prov_CAN_10', 'tool_CAN_43', 0, 1, 'provider detail', 'provider detail', '/provider/providers/detail/%%Provider.id%%/', '', '', 'no', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('qry-CAN-1', 'MAIN_MENU_1', 1, 4, 'query tool', 'query tool description', '/datamart/adhocs/index/', '', '', '1', '0000-00-00 00:00:00', '', '2007-12-20 05:32:27', '1'),
('qry-CAN-2', 'qry-CAN-1', 0, 0, 'adhoc', 'adhoc', '/datamart/adhocs/index/', '', 'Datamart.Adhoc::summary', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('qry-CAN-3', 'qry-CAN-1', 0, 0, 'batch sets', 'batch sets', '/datamart/batch_sets/index/', '', 'Datamart.BatchSet::summary', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('rtbf_CAN_01', 'core_CAN_33', 1, 3, 'forms_menu', 'forms', '/rtbform/rtbforms/index/', '', '', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('rtbf_CAN_02', 'rtbf_CAN_01', 0, 1, 'rtbform_detail', '', '/rtbform/rtbforms/profile/%%Rtbform.id%%', '', '', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('sop_CAN_01', 'core_CAN_33', 1, 7, 'sop_standard operating procedures', '', '/sop/sop_masters/listall/', '', '', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('sop_CAN_03', 'sop_CAN_01', 0, 1, 'sop_detail', '', '/sop/sop_masters/detail/%%SopMaster.id%%/', '', '', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('sop_CAN_04', 'sop_CAN_01', 0, 2, 'sop_extend', '', '/sop/sop_extends/listall/%%SopMaster.id%%/', '', '', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('sto_CAN_01', 'core_CAN_33', 1, 8, 'storage layout management', 'storage layout management', '/storagelayout/storage_masters/index/', '', '', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('sto_CAN_02', 'sto_CAN_01', 0, 1, 'storage detail', NULL, '/storagelayout/storage_masters/detail/%%StorageMaster.id%%', '', 'Storagelayout.StorageMaster::summary', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('sto_CAN_05', 'sto_CAN_09', 0, 2, 'storage layout', NULL, '/storagelayout/storage_masters/storageLayout/%%StorageMaster.id%%', '', '', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('sto_CAN_06', 'sto_CAN_01', 0, 2, 'storage coordinates', NULL, '/storagelayout/storage_coordinates/listAll/%%StorageMaster.id%%', '', 'Storagelayout.StorageMaster::summary', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('sto_CAN_07', 'sto_CAN_02', 0, 1, 'tma block', NULL, '/storagelayout/storage_masters/detail/%%StorageMaster.id%%/0/TMA', '', '', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('sto_CAN_08', 'sto_CAN_02', 0, 2, 'slides list', NULL, '/storagelayout/tma_slides/listAll/%%StorageMaster.id%%', '', '', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('sto_CAN_09', 'sto_CAN_01', 0, 3, 'storage content', NULL, '/storagelayout/storage_masters/contentTreeView/%%StorageMaster.id%%', '', 'Storagelayout.StorageMaster::summary', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('sto_CAN_10', 'sto_CAN_09', 0, 1, 'storage content tree view', NULL, '/storagelayout/storage_masters/contentTreeView/%%StorageMaster.id%%', '', '', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('tool_CAN_100', 'core_CAN_33', 1, 9, 'tool_study', 'tool_study', '/study/study_summaries/listall/', '', '', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('tool_CAN_104', 'tool_CAN_100', 0, 1, 'tool_summary', 'tool_summary', '/study/study_summaries/detail/%%StudySummary.id%%/', '', 'Study.StudySummary::summary', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('tool_CAN_105', 'tool_CAN_100', 0, 2, 'tool_contact', 'tool_contact', '/study/study_contacts/listall/%%StudySummary.id%%/', '', 'Study.StudySummary::summary', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('tool_CAN_106', 'tool_CAN_100', 0, 3, 'tool_investigator', 'tool_investigator', '/study/study_investigators/listall/%%StudySummary.id%%/', '', 'Study.StudySummary::summary', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('tool_CAN_107', 'tool_CAN_100', 0, 4, 'tool_reviews', 'tool_reviews', '/study/study_reviews/listall/%%StudySummary.id%%/', '', 'Study.StudySummary::summary', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('tool_CAN_108', 'tool_CAN_100', 0, 5, 'tool_ethics', 'tool_ethics', '/study/study_ethics_boards/listall/%%StudySummary.id%%/', '', 'Study.StudySummary::summary', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('tool_CAN_109', 'tool_CAN_100', 0, 6, 'tool_funding', 'tool_funding', '/study/study_fundings/listall/%%StudySummary.id%%/', '', 'Study.StudySummary::summary', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('tool_CAN_110', 'tool_CAN_100', 0, 7, 'tool_result', 'tool_result', '/study/study_results/listall/%%StudySummary.id%%/', '', 'Study.StudySummary::summary', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('tool_CAN_112', 'tool_CAN_100', 0, 9, 'tool_related studies', 'tool_related studies', '/study/study_related/listall/%%StudySummary.id%%/', '', 'Study.StudySummary::summary', 'yes', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('tool_CAN_38', 'core_CAN_33', 1, 101, 'pricing', 'pricing', '/under_development/', '', '', 'no', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('tool_CAN_43', 'core_CAN_33', 1, 102, 'provider', 'provider', '/provider/providers/index/', '', '', 'no', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('tool_CAN_48', 'core_CAN_33', 1, 100, 'collection kit', 'collection kit', '/under_development/', '', '', 'no', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');






SET FOREIGN_KEY_CHECKS = 1;