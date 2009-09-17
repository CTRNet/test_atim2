-- ------------------------------------------------------------------------------------------------------------
-- CLINICAL ANNOTATION MODULE
-- ------------------------------------------------------------------------------------------------------------

-- Clinical Annotation Test Data

DELETE FROM `participants`;
INSERT INTO `participants` (`id`, `title`, `first_name`, `last_name`, `middle_name`, `date_of_birth`, `date_status`, `marital_status`, `language_preferred`, `sex`, `race`, `ethnicity`, `vital_status`, `memo`, `status`, `date_of_death`, `death_certificate_ident`, `icd10_id`, `confirmation_source`, `tb_number`, `last_chart_checked_date`, `created`, `created_by`, `modified`, `modified_by`, `deleted`, `deleted_date`) VALUES
(1, '', 'Joe', 'Test', '', '2029-01-01', NULL, 'married', '', 'male', '', NULL, '', '', NULL, '2029-01-01', '', '', '', '', '2029-01-01', '2009-05-14 16:07:13', '1', '2009-05-14 16:07:13', '1', 0, '0000-00-00 00:00:00'),
(2, '', 'Jane', 'Doe', '', '1987-05-01', NULL, 'single', '', 'female', '', NULL, '', '', NULL, '2029-01-01', '', '', '', '', '2009-03-01', '2009-05-14 16:07:13', '1', '2009-05-14 16:07:13', '1', 0, '0000-00-00 00:00:00');

DELETE FROM `participant_contacts`;
INSERT INTO `participant_contacts` (`id`, `name`, `facility`, `contact_type`, `other_contact_type`, `effective_date`, `expiry_date`, `memo`, `street`, `city`, `region`, `country`, `mail_code`, `phone`, `phone_type`, `phone_secondary`, `phone_secondary_type`, `created`, `created_by`, `modified`, `modified_by`, `participant_id`) VALUES 
(2, '', NULL, 'home', NULL, '2008-03-18', '2008-03-18', NULL, NULL, '', '', '', '', '', '', '', '', '2008-03-18 15:04:29', '1', '2008-03-18 15:04:29', '1', 1);

DELETE FROM `participant_messages`;
INSERT INTO `participant_messages` (`id`, `date_requested`, `author`, `type`, `title`, `description`, `due_date`, `expiry_date`, `created`, `created_by`, `modified`, `modified_by`, `participant_id`) VALUES
(1, '2009-05-19', 'Test', 'memo', 'Test', 'Test', '2009-05-19 00:00:00', '2009-05-19', '2009-05-19 12:42:07', '1', '2009-05-19 12:42:07', '1', 1);

DELETE FROM `diagnoses`;
INSERT INTO `diagnoses` (`id`, `dx_number`, `dx_method`, `dx_nature`, `dx_origin`, `dx_date`, `icd10_id`, `morphology`, `laterality`, `information_source`, `age_at_dx`, `age_at_dx_status`, `case_number`, `clinical_stage`, `collaborative_stage`, `tstage`, `nstage`, `mstage`, `stage_grouping`, `clinical_tstage`, `clinical_nstage`, `clinical_mstage`, `clinical_stage_grouping`, `path_tstage`, `path_nstage`, `path_mstage`, `path_stage_grouping`, `created`, `created_by`, `modified`, `modified_by`, `participant_id`) VALUES 
(2, NULL, 'biopsy', 'malignant', 'primary', '2004-03-18', 'C50.9', '', 'right', '', 50, 'known', 1, NULL, '', '', '', '', '', '', '', '', '', '', '', '', '', '2008-03-18 10:17:32', '1', '2008-03-18 10:18:22', '1', 1);

DELETE FROM `consents`;
INSERT INTO `consents` (`id`, `date`, `form_version`, `reason_denied`, `consent_status`, `status_date`, `surgeon`, `contact_method`, `operation_date`, `facility`, `memo`, `biological_material_use`, `use_of_tissue`, `contact_future_research`, `access_medical_information`, `use_of_blood`, `use_of_urine`, `research_other_disease`, `inform_significant_discovery`, `facility_other`, `created`, `created_by`, `modified`, `modified_by`, `consent_id`, `acquisition_id`, `participant_id`, `diagnosis_id`) VALUES 
(1, '1901-01-02', NULL, NULL, 'sent', '1900-02-02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2008-10-07 20:44:59', '1', '2008-10-07 20:44:59', '1', '', '', 1, 2);

DELETE FROM `family_histories`;
INSERT INTO `family_histories` (`id`, `relation`, `domain`, `icd10_id`, `dx_date`, `dx_date_status`, `age_at_dx`, `age_at_dx_status`, `created`, `created_by`, `modified`, `modified_by`, `participant_id`) VALUES 
(1, 'aunt', 'maternal', 'C50.9', '1990-03-18', 'c', 12, '', '2008-03-18 15:01:18', '1', '2008-04-10 14:57:07', '1', 1);

DELETE FROM `misc_identifiers`;
INSERT INTO `misc_identifiers` (`id`, `identifier_value`, `name`, `identifier_abrv`, `effective_date`, `expiry_date`, `memo`, `created`, `created_by`, `modified`, `modified_by`, `participant_id`) VALUES 
(2, '123456', 'Care Card', NULL, NULL, NULL, NULL, '2008-03-18 21:48:14', '1', '2008-03-18 21:48:14', '1', 1);

DELETE FROM `reproductive_histories`;
INSERT INTO `reproductive_histories` (`id`, `date_captured`, `menopause_status`, `age_at_menopause`, `menopause_age_certainty`, `hrt_years_on`, `hrt_use`, `hysterectomy_age`, `hysterectomy_age_certainty`, `hysterectomy`, `first_ovary_out_age`, `first_ovary_certainty`, `second_ovary_out_age`, `second_ovary_certainty`, `first_ovary_out`, `second_ovary_out`, `gravida`, `para`, `age_at_first_parturition`, `first_parturition_certainty`, `age_at_last_parturition`, `last_parturition_certainty`, `age_at_menarche`, `age_at_menarche_certainty`, `oralcontraceptive_use`, `years_on_oralcontraceptives`, `lnmp_date`, `lnmp_certainty`, `created`, `created_by`, `modified`, `modified_by`, `participant_id`) VALUES
(1, NULL, NULL, NULL, 'uncertain by more than 10 years', NULL, NULL, NULL, NULL, NULL, 15, NULL, 12, 'known', 'no', 'yes', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2008-08-28', '1', '2008-08-28', '1', 1);

-- Event Masters and Event Details Test Data

DELETE FROM `event_masters`;
INSERT INTO `event_masters` (`id`, `event_control_id`, `disease_site`, `event_group`, `event_type`, `event_status`, `event_summary`, `event_date`, `information_source`, `urgency`, `date_required`, `date_requested`, `reference_number`, `created`, `created_by`, `modified`, `modified_by`, `form_alias`, `detail_tablename`, `participant_id`, `diagnosis_id`) VALUES
(1, 32,'breast', 'screening', 'mammogram', 'active', NULL, '2008-05-05', NULL, NULL, NULL, NULL, NULL, '0000-00-00 00:00:00', '', '2009-06-01 16:59:27', '', 'ed_breast_screening_mammogram', 'ed_breast_screening_mammogram', 1, NULL),
(3, 18,'breast', 'lab', 'pathology', 'active', '', '1990-10-10', NULL, NULL, NULL, NULL, NULL, '0000-00-00 00:00:00', '', '2009-06-03 14:15:28', '1', 'ed_breast_lab_pathology', 'ed_breast_lab_pathology', 1, NULL),
(4, 22,'all', 'clinical', 'presentation', 'active', NULL, '2002-01-02', NULL, NULL, NULL, NULL, NULL, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '', 'ed_all_clinical_presentation', 'ed_all_clinical_presentation', 1, NULL),
(5, 32,'breast', 'screening', 'mammogram', 'active', NULL, '2005-02-02', NULL, NULL, NULL, NULL, NULL, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '', 'ed_breast_screening_mammogram', 'ed_breast_screening_mammogram', 1, NULL),
(6, 18,'breast', 'lab', 'pathology', 'active', NULL, '1962-01-01', NULL, NULL, NULL, NULL, NULL, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '', 'ed_breast_lab_pathology', 'ed_breast_lab_pathology', 1, NULL),
(7, 18,'breast', 'lab', 'pathology', 'active', NULL, '1998-04-02', NULL, NULL, NULL, NULL, NULL, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '', 'ed_breast_lab_pathology', 'ed_breast_lab_pathology', 1, NULL),
(8, 19,'allsolid', 'lab', 'pathology', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '', 'ed_allsolid_lab_pathology', 'ed_allsolid_lab_pathology', 1, NULL),
(9, 19,'allsolid', 'lab', 'pathology', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '', 'ed_allsolid_lab_pathology', 'ed_allsolid_lab_pathology', 1, NULL),
(10, 32,'breast', 'screening', 'mammogram', NULL, 'test', '2009-06-23', NULL, NULL, NULL, NULL, NULL, '2009-06-23 09:14:30', '1', '2009-06-23 09:14:30', '1', 'ed_breast_screening_mammogram', 'ed_breast_screening_mammogram', 1, 1),
(11, 18,'breast', 'lab', 'pathology', NULL, NULL, '2009-06-23', NULL, NULL, NULL, NULL, NULL, '2009-06-23 09:37:08', '1', '2009-06-23 09:37:08', '1', 'ed_breast_lab_pathology', 'ed_breast_lab_pathology', 1, 1),
(12, 20,'all', 'clinical', 'follow up', NULL, 'Test follow-up', '2009-06-24', NULL, NULL, NULL, NULL, NULL, '2009-06-24 11:17:18', '1', '2009-06-24 11:17:18', '1', 'ed_all_clinical_followup', 'ed_all_clinical_followup', 1, 1),
(13, 30,'all', 'lifestyle', 'base', NULL, 'Heavy Smoker', '2009-06-24', NULL, NULL, NULL, NULL, NULL, '2009-06-24 11:20:00', '1', '2009-06-24 11:20:00', '1', 'ed_all_lifestyle_base', 'ed_all_lifestyle_base', 1, 1),
(14, 31,'all', 'adverse_events', 'adverse_event', NULL, 'Test', '2009-06-24', NULL, NULL, NULL, NULL, NULL, '2009-06-24 11:22:28', '1', '2009-06-24 11:22:28', '1', 'ed_all_adverse_events_adverse_event', 'ed_all_adverse_events_adverse_event', 1, 1),
(15, 33,'all', 'protocol', 'followup', NULL, 'Not Test', '2009-06-24', NULL, NULL, NULL, NULL, NULL, '2009-06-24 11:23:23', '1', '2009-06-24 11:23:23', '1', 'ed_all_protocol_followup', 'ed_all_protocol_followup', 1, 1),
(16, 34,'all', 'study', 'research', NULL, 'The is the 1, 2, 3 test', '2009-06-24', NULL, NULL, NULL, NULL, NULL, '2009-06-24 11:24:10', '1', '2009-06-24 11:24:10', '1', 'ed_all_study_research', 'ed_all_study_research', 1, 1);

DELETE FROM `ed_breast_lab_pathology`;
INSERT INTO `ed_breast_lab_pathology` (`id`, `path_number`, `report_type`, `facility`, `vascular_lymph_invasion`, `extra_nodal_invasion`, `blood_lymph`, `tumour_type`, `grade`, `multifocal`, `preneoplastic_changes`, `spread_skin_nipple`, `level_nodal_involvement`, `frozen_section`, `er_assay_ligand`, `pr_assay_ligand`, `progesterone`, `estrogen`, `number_resected`, `number_positive`, `nodal_status`, `resection_margins`, `tumour_size`, `tumour_total_size`, `sentinel_only`, `in_situ_type`, `her2_grade`, `her2_method`, `mb_collectionid`, `created`, `created_by`, `modified`, `modified_by`, `event_master_id`, `deleted`, `deleted_date`) VALUES
(3, '1', '', 'manitoba', '', '', NULL, '', '', '', '', '', '', '', 'bbbb', 'cccc', 'aaaa', '', '', '', NULL, 'h', '12.4', NULL, '', '', '', '', NULL, '0000-00-00', '', '2009-06-03', '', 3, 0, '0000-00-00 00:00:00'),
(6, '123', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '23.4', NULL, NULL, NULL, NULL, NULL, NULL, '0000-00-00', '', '0000-00-00', '', 6, 0, NULL),
(7, '3453', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2.6', NULL, NULL, NULL, NULL, NULL, NULL, '0000-00-00', '', '0000-00-00', '', 7, 0, NULL);

DELETE FROM `ed_breast_screening_mammogram`;
INSERT INTO `ed_breast_screening_mammogram` (`id`, `result`, `created`, `created_by`, `modified`, `modified_by`, `event_master_id`, `deleted`, `deleted_date`) VALUES
(1, 'asdadsads', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '', 1, 0, '0000-00-00 00:00:00'),
(5, 'atypical', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '', 5, 0, NULL);

DELETE FROM `ed_all_clinical_presentation`;
INSERT INTO `ed_all_clinical_presentation` ( `id` , `weight` , `height` , `created` , `created_by` , `modified` , `modified_by` , `event_master_id` , `deleted` , `deleted_date` ) VALUES
('4', '105', '98', NULL , NULL , NULL , NULL , '4', '0', NULL);

DELETE FROM `ed_allsolid_lab_pathology`;
INSERT INTO `ed_allsolid_lab_pathology` ( `id` , `tumour_type` , `resection_margin` , `extra_nodal_invasion` , `lymphatic_vascular_invasion` , `in_situ_component` , `fine_needle_aspirate` , `trucut_core_biopsy` , `open_biopsy` , `frozen_section` , `breast_tumour_size` , `nodes_removed` , `nodes_positive` , `created` , `created_by` , `modified` , `modified_by` , `event_master_id` , `deleted` , `deleted_date` ) VALUES
('8', NULL , 'et', 'est', 'asdf', 'sadf', 'sdf', 'sdf', 'yest', NULL , NULL , '45', '21', '0000-00-00', '', '0000-00-00', '', '8', '0', NULL),
('9', 'mroe test', NULL , NULL , NULL , NULL , NULL , NULL , NULL , NULL , NULL , '23423', '234', '0000-00-00', '', '0000-00-00', '', '9', '0', NULL);

DELETE FROM `ed_all_clinical_followup`;
INSERT INTO `ed_all_clinical_followup` (`id`, `weight`, `recurrence_status`, `disease_status`, `vital_status`, `created`, `created_by`, `modified`, `modified_by`, `event_master_id`) VALUES
(12, 45, 'Ya', 'Benign', 'alive and well with disease', '2009-06-24', '1', '2009-06-24', '1', 12);

DELETE FROM `ed_all_lifestyle_base`;
INSERT INTO `ed_all_lifestyle_base` (`id`, `smoking_history`, `smoking_status`, `pack_years`, `product_used`, `years_quit_smoking`, `alcohol_history`, `weight_loss`, `created`, `created_by`, `modified`, `modified_by`, `event_master_id`) VALUES
(13, 'yes', 'smoker', '2004-06-24', 'cigarettes', 2, NULL, NULL, '2009-06-24 11:20:00', '1', '2009-06-24 11:20:00', '1', 13);

DELETE FROM `ed_all_adverse_events_adverse_event`;
INSERT INTO `ed_all_adverse_events_adverse_event` (`id`, `supra_ordinate_term`, `select_ae`, `grade`, `description`, `created`, `created_by`, `modified`, `modified_by`, `event_master_id`) VALUES 
(14, NULL, NULL, '3', NULL, '2009-06-24 11:22:28', '1', '2009-06-24 11:22:28', '1', 14);

DELETE FROM `ed_all_protocol_followup`;
INSERT INTO `ed_all_protocol_followup` (`id`, `title`, `created`, `created_by`, `modified`, `modified_by`, `event_master_id`) VALUES 
(15, 'Test', '2009-06-24 11:23:23', '1', '2009-06-24 11:23:23', '1', 15);

DELETE FROM `ed_all_study_research`;
INSERT INTO `ed_all_study_research` (`id`, `field_one`, `field_two`, `field_three`, `event_master_id`, `created`, `created_by`, `modified`, `modified_by`) VALUES 
(16, 'Test 1', 'Test 2', 'Test 3', 16, '2009-06-24 11:24:10', '1', '2009-06-24 11:24:10', '1');

-- Treatment Masters, Treatment Details, and Treatment Extends Test Data

DELETE FROM `tx_masters`;
INSERT INTO `tx_masters` ( `id`, `treatment_control_id`, `tx_group`, `participant_id` ) VALUES
(101, 1, 'chemotherapy', 1),
(102, 2, 'radiation', 1),
(103, 3, 'surgery', 1);

DELETE FROM `txd_chemos`;
INSERT INTO `txd_chemos` ( `id`, `completed`, `response`, `tx_master_id` ) VALUES
(101, 'yes', 'completed', 101);

DELETE FROM `txd_radiations`;
INSERT INTO `txd_radiations` ( `id`, `source`, `mould`, `tx_master_id` ) VALUES
(102, 'plutonium', 'asdf', 102);

DELETE FROM `txd_surgeries`;
INSERT INTO `txd_surgeries` ( `id`, `path_num`, `primary`, `surgeon`, `tx_master_id` ) VALUES
(103, 2456, 'block', 'dr. death', 103);

DELETE FROM `txe_chemos`;
INSERT INTO `txe_chemos` (`id`, `source`, `frequency`, `dose`, `method`, `reduction`, `cycle_number`, `completed_cycles`, `start_date`, `end_date`, `created`, `created_by`, `modified`, `modified_by`, `tx_master_id`, `drug_id`) VALUES 
(1, NULL, NULL, '45', 'iv push', NULL, NULL, NULL, NULL, NULL, '2009-06-23 10:05:38', '1', '2009-06-23 10:05:38', '1', 2, '4');

-- ------------------------------------------------------------------------------------------------------------
-- TOOLS
-- ------------------------------------------------------------------------------------------------------------

-- Protocol Masters, Protocol Details, and Protocol Extends Test Data

DELETE FROM `protocol_masters`;
INSERT INTO `protocol_masters` ( `id`, `protocol_control_id`, `name`, `notes`, `code`, `detail_tablename`, `detail_form_alias`, `extend_tablename`, `extend_form_alias` ) VALUES
(101, 1,'test', 'test', '34.5C', 'pd_chemos', 'pd_chemos', 'pe_chemos', 'pe_chemos');

DELETE FROM `pd_chemos`;
INSERT INTO `pd_chemos` ( `id`, `num_cycles`, `length_cycles`, `protocol_master_id` ) VALUES
(101, 45, 45, 101);

DELETE FROM `pe_chemos`;
INSERT INTO `pe_chemos` ( `id`, `dose`, `frequency`, `protocol_master_id`, `drug_id` ) VALUES
(1,  '45ml', '5 hours', 101, 1);

-- Materials Test data

DELETE FROM `materials`;
INSERT INTO `materials` ( `id`, `item_name`, `item_type`, `description` ) VALUES
(1, 'Test Material', 'Box', 'This is a test material' );

-- Drugs Test Data

DELETE FROM `drugs`;
INSERT INTO `drugs` ( `id`, `generic_name`, `trade_name`, `type`, `description`) VALUES
(1, 'asprin', 'acetylsalicylic acid', 'pain killer', 'Cures headaches');

-- SOP Masters, Sop Details, and Sop Extends Test Data

DELETE FROM `sop_masters`;
INSERT INTO `sop_masters` ( `id`, `title`, `detail_tablename`, `detail_form_alias`, `extend_tablename`, `extend_form_alias`) VALUES
(1, 'test', 'sopd_general_all', 'sopd_general_all', 'sope_general_all', 'sope_general_all');

DELETE FROM `sopd_general_all`;
INSERT INTO `sopd_general_all` ( `id`, `value`, `sop_master_id` ) VALUES
(1, 'test value', 1);

DELETE FROM `sope_general_all`;
INSERT INTO `sope_general_all` ( `id`, `site_specific`, `sop_master_id`, `material_id` ) VALUES
(1, 'test site specific', 1, 1);

-- RTBform Test Data

DELETE FROM `rtbforms`;
INSERT INTO `rtbforms` (`id`, `frmTitle`, `frmVersion`, `frmCategory`, `frmFileLocation`, `frmFileType`, `frmFileViewer`, `frmStatus`, `frmCreated`, `frmGroup`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(1, 'cde', 2, 'consent', 0x633a, 'doc', NULL, NULL, '2009-05-19', 'abc', '2009-05-19 11:14:45', '1', '2009-05-19 11:14:45', '1');

-- Study Test Data

DELETE FROM `study_summaries`;
INSERT INTO `study_summaries` (`id`, `disease_site`, `study_type`, `study_science`, `study_use`, `title`, `start_date`, `end_date`, `summary`, `abstract`, `hypothesis`, `approach`, `analysis`, `significance`, `additional_clinical`, `created`, `created_by`, `modified`, `modified_by`, `path_to_file`) VALUES 
(1, 'endocrine', 'prospective', 'basic', 'academic', 'Teststudy', '2009-04-21', '2009-04-21', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2009-04-21', '1', '2009-04-21', '1', NULL);

DELETE FROM `study_contacts`;
INSERT INTO `study_contacts` (`id`, `sort`, `prefix`, `first_name`, `middle_name`, `last_name`, `accreditation`, `occupation`, `department`, `organization`, `organization_type`, `address_street`, `address_city`, `address_province`, `address_country`, `address_postal`, `phone_country`, `phone_area`, `phone_number`, `phone_extension`, `phone2_country`, `phone2_area`, `phone2_number`, `phone2_extension`, `fax_country`, `fax_area`, `fax_number`, `fax_extension`, `email`, `website`, `created`, `created_by`, `modified`, `modified_by`, `study_summary_id`) VALUES 
(1, NULL, NULL, 'Fred', 'Jimmy', 'Henderson', 'Nobody', 'Doctor', 'General Hospital', 'University of Manitoba', NULL, '675 McDermot Ave', 'Smallsville', 'Manitoba', 'Canada', 'W2E4R1', 1, 204, 787, 4000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'hospital@gh.com', 'www.gh.com', '2009-06-24', '1', '2009-06-24', '1', 1);

DELETE FROM `study_ethics_boards`;
INSERT INTO `study_ethics_boards` (`id`, `ethics_board`, `restrictions`, `contact`, `date`, `phone_country`, `phone_area`, `phone_number`, `phone_extension`, `fax_country`, `fax_area`, `fax_number`, `fax_extension`, `email`, `status`, `approval_number`, `accrediation`, `ohrp_registration_number`, `ohrp_fwa_number`, `path_to_file`, `created`, `created_by`, `modified`, `modified_by`, `study_summary_id`) VALUES
(1, 'Chino Ethicsboard', 'All of them', 'Phone', '2008-07-28', '1', '226', '3388546', NULL, NULL, NULL, NULL, NULL, 'chino@chinomail.com', 'pending', '43E-45S2', NULL, NULL, NULL, 'C:/Program Files/wamp/www', '2009-06-24', '1', '2009-06-24', '1', 1);

DELETE FROM `study_fundings`;
INSERT INTO `study_fundings` (`id`, `study_sponsor`, `restrictions`, `year_1`, `amount_year_1`, `year_2`, `amount_year_2`, `year_3`, `amount_year_3`, `year_4`, `amount_year_4`, `year_5`, `amount_year_5`, `contact`, `phone_country`, `phone_area`, `phone_number`, `phone_extension`, `fax_country`, `fax_area`, `fax_number`, `fax_extension`, `email`, `status`, `date`, `created`, `created_by`, `modified`, `modified_by`, `rtbform_id`, `study_summary_id`) VALUES
(1, 'Microsoft', 'Everything cause we are evil', 2003, 1.00, 2004, 25.00, 2005, 145.00, NULL, NULL, NULL, NULL, 'Phone', '1', '866', '2424609', '233', NULL, NULL, NULL, NULL, 'microsoft@microsoft.com', 'completed', '2005-10-13', '2009-06-24', '1', '2009-06-24', '1', NULL, 0);

DELETE FROM `study_investigators`;
INSERT INTO `study_investigators` (`id`, `first_name`, `middle_name`, `last_name`, `accrediation`, `occupation`, `department`, `organization`, `address_street`, `address_city`, `address_province`, `address_country`, `sort`, `role`, `brief`, `participation_start_date`, `participation_end_date`, `created`, `created_by`, `modified`, `modified_by`, `path_to_file`, `study_summary_id`) VALUES 
(1, 'Fred', NULL, 'Dawson', NULL, 'Researcher', 'MICB', 'University of Manitoba', '123 Notre-Dame', 'Winnipeg', 'Manitoba', 'Canada', NULL, 'principle_investigator', 'Some guy we made up for testing', '2005-06-24', '0000-00-00', '2009-06-24', '1', '2009-06-24', '1', NULL, 1);

DELETE FROM `study_related`;
INSERT INTO `study_related` (`id`, `title`, `principal_investigator`, `journal`, `issue`, `url`, `abstract`, `relevance`, `date_posted`, `created`, `created_by`, `modified`, `modified_by`, `study_summary_id`, `path_to_file`) VALUES 
(1, 'Test Related', 'Dr. Greenthumb', 'digg', '23', 'www.digg.com', 'This is the test data', 'None what so ever', '1992-03-21', '2009-06-24', '1', '2009-06-24', '1', 1, 'C:/Program Files/ Warcraft3/');

DELETE FROM `study_results`;
INSERT INTO `study_results` (`id`, `abstract`, `hypothesis`, `conclusion`, `comparison`, `future`, `created`, `created_by`, `modified`, `modified_by`, `rtbform_id`, `study_summary_id`) VALUES 
(1, 'Eat', 'Some', 'test', 'Data', 'To', '2009-06-24', '1', '2009-06-24', '1', NULL, 0);

DELETE FROM `study_reviews`;
INSERT INTO `study_reviews` (`id`, `prefix`, `first_name`, `middle_name`, `last_name`, `accreditation`, `committee`, `institution`, `phone_country`, `phone_area`, `phone_number`, `phone_extension`, `status`, `date`, `created`, `created_by`, `modified`, `modified_by`, `study_summary_id`) VALUES 
(1, NULL, 'James', 'Henry', 'Harrison', 'None', 'The Stone Comittee', 'University of British Columbia', '1', '604', '8222211', '123', 'pending', '2007-05-15', '2009-06-24', '1', '2009-06-24', '1', 1);

-- Orders Test Data

DELETE FROM `orders`;
INSERT INTO `orders` (`id`, `order_number`, `short_title`, `description`, `date_order_placed`, `date_order_completed`, `processing_status`, `comments`, `created`, `created_by`, `modified`, `modified_by`, `study_summary_id`) VALUES 
(1, '545', 'Test Order', 'Test Order 545', '2009-05-06', '2009-08-19', 'completed', 'This is a test', '2009-05-06 16:14:00', '1', '2009-05-06 16:14:00', '1', 1);

DELETE FROM `order_lines`;
INSERT INTO `order_lines` (`id`, `cancer_type`, `quantity_ordered`, `quantity_UM`, `min_qty_ordered`, `min_qty_UM`, `base_price`, `date_required`, `quantity_shipped`, `status`, `created`, `created_by`, `modified`, `modified_by`, `discount_id`, `product_id`, `sample_control_id`, `order_id`) VALUES
(1, 'bone', 45, '65', 34, '23', '$1,500,650', '2009-06-24', 40, 'shipped', '2009-06-24 14:02:42', '1', '2009-06-24 14:02:42', '1', 0, 0, 1, 1);

DELETE FROM `shipments`;
INSERT INTO `shipments` (`id`, `shipment_code`, `recipient`, `facility`, `delivery_street_address`, `delivery_city`, `delivery_province`, `delivery_postal_code`, `delivery_country`, `shipping_company`, `shipping_account_nbr`, `datetime_shipped`, `datetime_received`, `shipped_by`, `created`, `created_by`, `modified`, `modified_by`, `order_id`) VALUES
(1, 'testc', 'sdfsfg', 'adsfgdag', 'sdfaw', 'dafgdg', 'ebhrfnsf', '234', 'sdgs', NULL, 'xcv', '2009-05-19 11:11:00', '2009-05-19 11:11:00', NULL, '2009-05-19 11:11:40', '1', '2009-05-19 11:11:40', '1', 1);

DELETE FROM `order_items`;
INSERT INTO `order_items` ( `id`, `barcode`, `status`, `orderline_id`, `shipment_id` ) VALUES
(1, '34532', 'Test', 1, 1);

-- Storage Masters, and Storage Details Test Data

DELETE FROM `storage_masters`;
INSERT INTO `storage_masters` (`id`, `code`, `storage_type`, `storage_control_id`, `parent_id`, `lft`, `rght`, `barcode`, `short_label`, `selection_label`, `storage_status`, `parent_storage_coord_x`, `coord_x_order`, `parent_storage_coord_y`, `coord_y_order`, `set_temperature`, `temperature`, `temp_unit`, `notes`, `created`, `created_by`, `modified`, `modified_by`, `deleted`, `deleted_date`) VALUES
(1, 'R - 1', 'room', 1, NULL, 1, 20, 'Y-909', 'y1', 'y1', '', NULL, NULL, NULL, NULL, 'TRUE', '23.00', 'celsius', '', '2009-09-17 15:02:09', '1', '2009-09-17 15:02:10', '1', 0, NULL),
(2, 'INC - 2', 'incubator', 4, 1, 2, 9, 'bc_inc_y11', 'inc1', 'y1-inc1', '', NULL, NULL, NULL, NULL, 'TRUE', '37.00', 'celsius', '', '2009-09-17 15:02:54', '1', '2009-09-17 15:02:54', '1', 0, NULL),
(3, 'R2D16 - 3', 'rack16', 11, 2, 3, 4, 'bcr1', 'r1', 'y1-inc1-r1', '', 'shelf_middl', 2, NULL, NULL, 'FALSE', '37.00', 'celsius', '', '2009-09-17 15:05:06', '1', '2009-09-17 15:05:16', '1', 0, NULL),
(4, 'R9 - 4', 'rack9', 16, 2, 5, 8, 'bcr2', 'r2', 'y1-inc1-r2', '', 'shelf_top', 1, NULL, NULL, 'FALSE', '37.00', 'celsius', '', '2009-09-17 15:05:43', '1', '2009-09-17 15:05:53', '1', 0, NULL),
(5, 'B25 - 5', 'box25', 17, 4, 6, 7, 'bc_b1', 'b1', 'y1-inc1-r2-b1', '', '7', 6, NULL, NULL, 'FALSE', '37.00', 'celsius', '', '2009-09-17 15:06:16', '1', '2009-09-17 15:06:27', '1', 0, NULL),
(6, 'FRI - 6', 'fridge', 5, 1, 10, 17, 'bcfr1', 'fr1', 'y1-fr1', '', NULL, NULL, NULL, NULL, 'TRUE', '5.00', 'celsius', '', '2009-09-17 15:08:11', '1', '2009-09-17 15:08:12', '1', 0, NULL),
(7, 'SH - 7', 'shelf', 14, 6, 11, 12, 'sh1', 'sh1', 'y1-fr1-sh1', '', NULL, NULL, NULL, NULL, 'FALSE', '5.00', 'celsius', '', '2009-09-17 15:08:37', '1', '2009-09-17 15:08:37', '1', 0, NULL),
(8, 'SH - 8', 'shelf', 14, 6, 13, 16, 'bcsh2', 'sh2', 'y1-fr1-sh2', '', NULL, NULL, NULL, NULL, 'FALSE', '5.00', 'celsius', '', '2009-09-17 15:09:09', '1', '2009-09-17 15:09:09', '1', 0, NULL),
(9, 'B25 - 9', 'box25', 17, 8, 14, 15, 'bc_b5', 'b6', 'y1-fr1-sh2-b6', '', NULL, NULL, NULL, NULL, 'FALSE', '5.00', 'celsius', '', '2009-09-17 15:09:36', '1', '2009-09-17 15:09:36', '1', 0, NULL),
(10, 'TMA345 - 10', 'TMA-blc 23X15', 19, 1, 18, 19, 'tma1', 'tma1', 'y1-tma1', '', NULL, NULL, NULL, NULL, 'FALSE', '23.00', 'celsius', '', '2009-09-17 15:10:22', '1', '2009-09-17 15:10:22', '1', 0, NULL);

DELETE FROM `storage_masters_revs`;
INSERT INTO `storage_masters_revs` (`id`, `code`, `storage_type`, `storage_control_id`, `parent_id`, `lft`, `rght`, `barcode`, `short_label`, `selection_label`, `storage_status`, `parent_storage_coord_x`, `coord_x_order`, `parent_storage_coord_y`, `coord_y_order`, `set_temperature`, `temperature`, `temp_unit`, `notes`, `created`, `created_by`, `modified`, `modified_by`, `version_id`, `version_created`, `deleted`, `deleted_date`) VALUES
(1, '', 'room', 1, NULL, 1, 2, 'Y-909', 'y1', 'y1', '', NULL, NULL, NULL, NULL, 'TRUE', '23.00', 'celsius', '', '2009-09-17 15:02:09', '1', '2009-09-17 15:02:09', '1', 1, '2009-09-17 15:02:10', 0, NULL),
(1, 'R - 1', 'room', 1, NULL, 1, 2, 'Y-909', 'y1', 'y1', '', NULL, NULL, NULL, NULL, 'TRUE', '23.00', 'celsius', '', '2009-09-17 15:02:09', '1', '2009-09-17 15:02:10', '1', 2, '2009-09-17 15:02:10', 0, NULL),
(2, '', 'incubator', 4, 1, 0, 0, 'bc_inc_y11', 'inc1', 'y1-inc1', '', NULL, NULL, NULL, NULL, 'TRUE', '37.00', 'celsius', '', '2009-09-17 15:02:54', '1', '2009-09-17 15:02:54', '1', 3, '2009-09-17 15:02:54', 0, NULL),
(2, 'INC - 2', 'incubator', 4, 1, 2, 3, 'bc_inc_y11', 'inc1', 'y1-inc1', '', NULL, NULL, NULL, NULL, 'TRUE', '37.00', 'celsius', '', '2009-09-17 15:02:54', '1', '2009-09-17 15:02:54', '1', 4, '2009-09-17 15:02:54', 0, NULL),
(3, '', 'rack16', 11, 2, 0, 0, 'bcr1', 'r1', 'y1-inc1-r1', '', NULL, NULL, NULL, NULL, 'FALSE', '37.00', 'celsius', '', '2009-09-17 15:05:06', '1', '2009-09-17 15:05:06', '1', 5, '2009-09-17 15:05:06', 0, NULL),
(3, 'R2D16 - 3', 'rack16', 11, 2, 3, 4, 'bcr1', 'r1', 'y1-inc1-r1', '', NULL, NULL, NULL, NULL, 'FALSE', '37.00', 'celsius', '', '2009-09-17 15:05:06', '1', '2009-09-17 15:05:06', '1', 6, '2009-09-17 15:05:06', 0, NULL),
(3, 'R2D16 - 3', 'rack16', 11, 2, 3, 4, 'bcr1', 'r1', 'y1-inc1-r1', '', 'shelf_middl', 2, NULL, NULL, 'FALSE', '37.00', 'celsius', '', '2009-09-17 15:05:06', '1', '2009-09-17 15:05:16', '1', 7, '2009-09-17 15:05:16', 0, NULL),
(4, '', 'rack9', 16, 2, 0, 0, 'bcr2', 'r2', 'y1-inc1-r2', '', NULL, NULL, NULL, NULL, 'FALSE', '37.00', 'celsius', '', '2009-09-17 15:05:43', '1', '2009-09-17 15:05:43', '1', 8, '2009-09-17 15:05:43', 0, NULL),
(4, 'R9 - 4', 'rack9', 16, 2, 5, 6, 'bcr2', 'r2', 'y1-inc1-r2', '', NULL, NULL, NULL, NULL, 'FALSE', '37.00', 'celsius', '', '2009-09-17 15:05:43', '1', '2009-09-17 15:05:43', '1', 9, '2009-09-17 15:05:43', 0, NULL),
(4, 'R9 - 4', 'rack9', 16, 2, 5, 6, 'bcr2', 'r2', 'y1-inc1-r2', '', 'shelf_top', 1, NULL, NULL, 'FALSE', '37.00', 'celsius', '', '2009-09-17 15:05:43', '1', '2009-09-17 15:05:53', '1', 10, '2009-09-17 15:05:53', 0, NULL),
(5, '', 'box25', 17, 4, 0, 0, 'bc_b1', 'b1', 'y1-inc1-r2-b1', '', NULL, NULL, NULL, NULL, 'FALSE', '37.00', 'celsius', '', '2009-09-17 15:06:16', '1', '2009-09-17 15:06:16', '1', 11, '2009-09-17 15:06:16', 0, NULL),
(5, 'B25 - 5', 'box25', 17, 4, 6, 7, 'bc_b1', 'b1', 'y1-inc1-r2-b1', '', NULL, NULL, NULL, NULL, 'FALSE', '37.00', 'celsius', '', '2009-09-17 15:06:16', '1', '2009-09-17 15:06:16', '1', 12, '2009-09-17 15:06:16', 0, NULL),
(5, 'B25 - 5', 'box25', 17, 4, 6, 7, 'bc_b1', 'b1', 'y1-inc1-r2-b1', '', '7', 6, NULL, NULL, 'FALSE', '37.00', 'celsius', '', '2009-09-17 15:06:16', '1', '2009-09-17 15:06:27', '1', 13, '2009-09-17 15:06:27', 0, NULL),
(6, '', 'fridge', 5, 1, 0, 0, 'bcfr1', 'fr1', 'y1-fr1', '', NULL, NULL, NULL, NULL, 'TRUE', '5.00', 'celsius', '', '2009-09-17 15:08:11', '1', '2009-09-17 15:08:11', '1', 14, '2009-09-17 15:08:12', 0, NULL),
(6, 'FRI - 6', 'fridge', 5, 1, 10, 11, 'bcfr1', 'fr1', 'y1-fr1', '', NULL, NULL, NULL, NULL, 'TRUE', '5.00', 'celsius', '', '2009-09-17 15:08:11', '1', '2009-09-17 15:08:12', '1', 15, '2009-09-17 15:08:12', 0, NULL),
(7, '', 'shelf', 14, 6, 0, 0, 'sh1', 'sh1', 'y1-fr1-sh1', '', NULL, NULL, NULL, NULL, 'FALSE', '5.00', 'celsius', '', '2009-09-17 15:08:37', '1', '2009-09-17 15:08:37', '1', 16, '2009-09-17 15:08:37', 0, NULL),
(7, 'SH - 7', 'shelf', 14, 6, 11, 12, 'sh1', 'sh1', 'y1-fr1-sh1', '', NULL, NULL, NULL, NULL, 'FALSE', '5.00', 'celsius', '', '2009-09-17 15:08:37', '1', '2009-09-17 15:08:37', '1', 17, '2009-09-17 15:08:37', 0, NULL),
(8, '', 'shelf', 14, 6, 0, 0, 'bcsh2', 'sh2', 'y1-fr1-sh2', '', NULL, NULL, NULL, NULL, 'FALSE', '5.00', 'celsius', '', '2009-09-17 15:09:09', '1', '2009-09-17 15:09:09', '1', 18, '2009-09-17 15:09:09', 0, NULL),
(8, 'SH - 8', 'shelf', 14, 6, 13, 14, 'bcsh2', 'sh2', 'y1-fr1-sh2', '', NULL, NULL, NULL, NULL, 'FALSE', '5.00', 'celsius', '', '2009-09-17 15:09:09', '1', '2009-09-17 15:09:09', '1', 19, '2009-09-17 15:09:09', 0, NULL),
(9, '', 'box25', 17, 8, 0, 0, 'bc_b5', 'b6', 'y1-fr1-sh2-b6', '', NULL, NULL, NULL, NULL, 'FALSE', '5.00', 'celsius', '', '2009-09-17 15:09:36', '1', '2009-09-17 15:09:36', '1', 20, '2009-09-17 15:09:36', 0, NULL),
(9, 'B25 - 9', 'box25', 17, 8, 14, 15, 'bc_b5', 'b6', 'y1-fr1-sh2-b6', '', NULL, NULL, NULL, NULL, 'FALSE', '5.00', 'celsius', '', '2009-09-17 15:09:36', '1', '2009-09-17 15:09:36', '1', 21, '2009-09-17 15:09:36', 0, NULL),
(10, '', 'TMA-blc 23X15', 19, 1, 0, 0, 'tma1', 'tma1', 'y1-tma1', '', NULL, NULL, NULL, NULL, 'FALSE', '23.00', 'celsius', '', '2009-09-17 15:10:22', '1', '2009-09-17 15:10:22', '1', 22, '2009-09-17 15:10:22', 0, NULL),
(10, 'TMA345 - 10', 'TMA-blc 23X15', 19, 1, 18, 19, 'tma1', 'tma1', 'y1-tma1', '', NULL, NULL, NULL, NULL, 'FALSE', '23.00', 'celsius', '', '2009-09-17 15:10:22', '1', '2009-09-17 15:10:22', '1', 23, '2009-09-17 15:10:22', 0, NULL);

DELETE FROM `std_box25s`;
INSERT INTO `std_box25s` (`id`, `storage_master_id`, `created`, `created_by`, `modified`, `modified_by`, `deleted`, `deleted_date`) VALUES
(1, 5, '2009-09-17 15:06:16', '', '2009-09-17 15:06:27', NULL, 0, NULL),
(2, 9, '2009-09-17 15:09:36', '', '2009-09-17 15:09:36', NULL, 0, NULL);

DELETE FROM `std_fridges`;
INSERT INTO `std_fridges` (`id`, `storage_master_id`, `created`, `created_by`, `modified`, `modified_by`, `deleted`, `deleted_date`) VALUES
(1, 6, '2009-09-17 15:08:11', '', '2009-09-17 15:08:12', NULL, 0, NULL);

DELETE FROM `std_incubators`;
INSERT INTO `std_incubators` (`id`, `storage_master_id`, `oxygen_perc`, `carbonic_gaz_perc`, `created`, `created_by`, `modified`, `modified_by`, `deleted`, `deleted_date`) VALUES
(1, 2, '', '', '2009-09-17 15:02:54', '', '2009-09-17 15:02:54', NULL, 0, NULL);

DELETE FROM `std_rack9s`;
INSERT INTO `std_rack9s` (`id`, `storage_master_id`, `created`, `created_by`, `modified`, `modified_by`, `deleted`, `deleted_date`) VALUES
(1, 4, '2009-09-17 15:05:43', '', '2009-09-17 15:05:53', NULL, 0, NULL);

DELETE FROM `std_rack16s`;
INSERT INTO `std_rack16s` (`id`, `storage_master_id`, `created`, `created_by`, `modified`, `modified_by`, `deleted`, `deleted_date`) VALUES
(1, 3, '2009-09-17 15:05:06', '', '2009-09-17 15:05:16', NULL, 0, NULL);

DELETE FROM `std_rooms`;
INSERT INTO `std_rooms` (`id`, `storage_master_id`, `laboratory`, `floor`, `created`, `created_by`, `modified`, `modified_by`, `deleted`, `deleted_date`) VALUES
(1, 1, 'CTRNet', '4', '2009-09-17 15:02:10', '', '2009-09-17 15:02:10', NULL, 0, NULL);

DELETE FROM `std_shelfs`;
INSERT INTO `std_shelfs` (`id`, `storage_master_id`, `created`, `created_by`, `modified`, `modified_by`, `deleted`, `deleted_date`) VALUES
(1, 7, '2009-09-17 15:08:37', '', '2009-09-17 15:08:37', NULL, 0, NULL),
(2, 8, '2009-09-17 15:09:09', '', '2009-09-17 15:09:09', NULL, 0, NULL);

DELETE FROM `std_tma_blocks`;
INSERT INTO `std_tma_blocks` (`id`, `storage_master_id`, `sop_master_id`, `product_code`, `creation_datetime`, `created`, `created_by`, `modified`, `modified_by`, `deleted`, `deleted_date`) VALUES
(1, 10, NULL, '', '2009-09-17 15:09:00', '2009-09-17 15:10:22', '', '2009-09-17 15:10:22', NULL, 0, NULL);

DELETE FROM `storage_coordinates`;
INSERT INTO `storage_coordinates` (`id`, `storage_master_id`, `dimension`, `coordinate_value`, `order`, `created`, `created_by`, `modified`, `modified_by`, `deleted`, `deleted_date`) VALUES
(1, 2, 'x', 'shelf_top', 1, '2009-09-17 15:03:33', '1', '2009-09-17 15:03:33', '1', 0, NULL),
(2, 2, 'x', 'shelf_middle', 2, '2009-09-17 15:04:00', '1', '2009-09-17 15:04:00', '1', 0, NULL),
(3, 2, 'x', 'shelf_ground', 3, '2009-09-17 15:04:16', '1', '2009-09-17 15:04:16', '1', 0, NULL);

DELETE FROM `storage_coordinates_revs`;
INSERT INTO `storage_coordinates_revs` (`id`, `storage_master_id`, `dimension`, `coordinate_value`, `order`, `created`, `created_by`, `modified`, `modified_by`, `version_id`, `version_created`, `deleted`, `deleted_date`) VALUES
(1, 2, 'x', 'shelf_top', 1, '2009-09-17 15:03:33', '1', '2009-09-17 15:03:33', '1', 1, '2009-09-17 15:03:33', 0, NULL),
(2, 2, 'x', 'shelf_middle', 2, '2009-09-17 15:04:00', '1', '2009-09-17 15:04:00', '1', 2, '2009-09-17 15:04:00', 0, NULL),
(3, 2, 'x', 'shelf_ground', 3, '2009-09-17 15:04:16', '1', '2009-09-17 15:04:16', '1', 3, '2009-09-17 15:04:16', 0, NULL);

DELETE FROM `tma_slides`;
INSERT INTO `tma_slides` (`id`, `std_tma_block_id`, `barcode`, `product_code`, `sop_master_id`, `immunochemistry`, `picture_path`, `storage_datetime`, `storage_master_id`, `storage_coord_x`, `coord_x_order`, `storage_coord_y`, `coord_y_order`, `created`, `created_by`, `modified`, `modified_by`, `deleted`, `deleted_date`) VALUES
(1, 10, 'TMA1', '', NULL, '', '', '2009-09-17 15:10:00', 9, '3', 2, '', NULL, '2009-09-17 15:11:10', '1', '2009-09-17 15:11:10', '1', 0, NULL),
(2, 10, 'TMA2', '', NULL, '', '', '2009-09-17 15:11:00', 9, '1', 0, '', NULL, '2009-09-17 15:11:32', '1', '2009-09-17 15:11:32', '1', 0, NULL);

DELETE FROM `tma_slides_revs`;
INSERT INTO `tma_slides_revs` (`id`, `std_tma_block_id`, `barcode`, `product_code`, `sop_master_id`, `immunochemistry`, `picture_path`, `storage_datetime`, `storage_master_id`, `storage_coord_x`, `coord_x_order`, `storage_coord_y`, `coord_y_order`, `created`, `created_by`, `modified`, `modified_by`, `version_id`, `version_created`, `deleted`, `deleted_date`) VALUES
(1, 10, 'TMA1', '', NULL, '', '', '2009-09-17 15:10:00', 9, '3', 2, '', NULL, '2009-09-17 15:11:10', '1', '2009-09-17 15:11:10', '1', 1, '2009-09-17 15:11:10', 0, NULL),
(2, 10, 'TMA2', '', NULL, '', '', '2009-09-17 15:11:00', 9, '1', 0, '', NULL, '2009-09-17 15:11:32', '1', '2009-09-17 15:11:32', '1', 2, '2009-09-17 15:11:32', 0, NULL);

-- ------------------------------------------------------------------------------------------------------------
-- INVENTORY MODULE
-- ------------------------------------------------------------------------------------------------------------

-- Collections Test Data

DELETE FROM `collections`;
INSERT INTO `collections` (`id`, `acquisition_label`, `bank_id`, `collection_site`, `collection_datetime`, `reception_by`, `reception_datetime`, `sop_master_id`, `collection_property`, `collection_notes`, `created`, `created_by`, `modified`, `modified_by`) VALUES (1, 'test', NULL, NULL, '2008-12-08 09:53:00', NULL, '2008-12-08 09:53:00', NULL, 'participant collection', NULL, '2008-12-08 09:53:48', '1', '2008-12-08 09:53:48', '1'),
(2, '123', NULL, NULL, NULL, 'Joe', NULL, NULL, 'participant collection', NULL, '2009-01-15 12:08:27', '1', '2009-01-15 12:08:27', '1'),
(3, 'MB0309-01', NULL, NULL, '2009-03-12 15:42:00', 'Brenda', '2009-03-12 15:42:00', NULL, 'participant collection', NULL, '2009-03-12 15:42:48', '1', '2009-03-12 15:42:48', '1'),
(4, 'as', NULL, NULL, '0000-00-00 00:00:00', NULL, '2009-05-20 10:28:00', NULL, 'participant collection', NULL, '2009-05-20 10:28:43', '1', '2009-05-20 10:28:43', '1'),
(5, 'H03-4647', NULL, NULL, '2009-05-26 09:56:00', 'Mai', '2003-06-06 09:56:00', NULL, 'participant collection', NULL, '2009-05-26 09:56:07', '1', '2009-05-26 09:56:07', '1'),
(6, '476457', NULL, NULL, '2009-05-28 09:39:00', 'Dr. John Doe', '2009-05-28 09:39:00', NULL, 'participant collection', NULL, '2009-05-28 09:39:17', '1', '2009-05-28 09:39:17', '1');

DELETE FROM `sample_masters`;
INSERT INTO `sample_masters` (`id`, `sample_code`, `sample_category`, `sample_control_id`, `sample_type`, `initial_specimen_sample_id`, `initial_specimen_sample_type`, `collection_id`, `parent_id`, `sop_master_id`, `product_code`, `is_problematic`, `notes`, `created`, `created_by`, `modified`, `modified_by`, `deleted`, `deleted_date`) VALUES (1, 'PW - 1', 'specimen', 103, 'peritoneal wash', 1, 'peritoneal wash', 1, NULL, NULL, '12456', 'yes', '', '2009-05-06 16:04:16', '1', '2009-05-06 16:04:16', '1', 0, NULL),
(3, 'B - 3', 'specimen', 2, 'blood', 3, 'blood', 1, NULL, NULL, '546', 'no', '', '2007-05-06 16:37:06', '1', '2009-05-06 16:37:06', '1', 0, NULL),
(4, 'U - 4', 'specimen', 4, 'urine', 4, 'urine', 1, NULL, NULL, '6657445765', 'no', '', '2006-05-07 04:20:05', '1', '2009-05-07 04:20:05', '1', 0, NULL),
(5, 'U - 5', 'specimen', 4, 'urine', 5, 'urine', 1, NULL, NULL, '6657445765', 'no', '', '2005-05-07 04:20:05', '1', '2009-05-07 04:20:05', '1', 0, NULL),
(6, 'B - 6', 'specimen', 2, 'blood', 6, 'blood', 2, NULL, NULL, 'blutprobe', 'no', '', '2009-05-07 09:49:29', '1', '2009-05-07 09:49:29', '1', 0, NULL),
(7, 'A - 7', 'specimen', 1, 'ascite', 7, 'ascite', 3, NULL, NULL, '55467', 'yes', 'This test sample is very problematic', '2008-05-13 09:48:09', '1', '2009-05-13 09:48:09', '1', 0, NULL),
(8, 'T - 8', 'specimen', 3, 'tissue', 8, 'tissue', 3, NULL, NULL, '45623', 'no', 'Not a problematic test', '2007-05-13 10:00:01', '1', '2009-05-13 10:00:01', '1', 0, NULL),
(9, 'U - 9', 'specimen', 4, 'urine', 9, 'urine', 3, NULL, NULL, '456', 'no', 'Test another sample', '2006-05-13 10:01:55', '1', '2009-05-13 10:01:55', '1', 0, NULL),
(10, 'U - 10', 'specimen', 4, 'urine', 10, 'urine', 3, NULL, NULL, '456', 'no', 'Test another sample', '2005-05-13 10:01:55', '1', '2009-05-13 10:01:55', '1', 0, NULL),
(13, 'C-CULT - 13', 'derivative', 11, 'cell culture', 8, 'tissue', 3, 8, NULL, '777', 'yes', 'Test more data', '2007-05-13 10:05:47', '1', '2009-05-13 10:05:47', '1', 0, NULL),
(15, 'T - 15', 'specimen', 3, 'tissue', 15, 'tissue', 1, NULL, NULL, '2342', 'no', 'sdxcv', '2005-05-19 11:28:30', '1', '2009-05-19 11:28:30', '1', 0, NULL),
(16, 'C-CULT - 16', 'derivative', 11, 'cell culture', 15, 'tissue', 1, 15, NULL, '455345', 'yes', 'fdgbgb', '2009-05-19 11:29:20', '1', '2009-05-19 11:29:20', '1', 0, NULL),
(17, 'A - 17', 'specimen', 1, 'ascite', 17, 'ascite', 1, NULL, NULL, '647', 'no', '5r6', '2008-05-19 11:30:44', '1', '2009-05-19 11:30:44', '1', 0, NULL),
(18, 'B - 18', 'specimen', 2, 'blood', 18, 'blood', 4, NULL, NULL, 'neu', 'no', '', '2007-05-19 12:48:19', '1', '2009-05-19 12:48:19', '1', 0, NULL),
(19, 'B - 19', 'specimen', 2, 'blood', 19, 'blood', 5, NULL, NULL, '', 'no', '', '2006-05-28 01:09:14', '1', '2009-05-28 01:09:14', '1', 0, NULL),
(21, 'A - 21', 'specimen', 1, 'ascite', 21, 'ascite', 1, NULL, NULL, '1121E-D3', 'no', 'Nothing in here', '2009-07-08 10:11:30', '1', '2009-07-08 10:11:30', '1', 0, NULL),
(23, 'B - 23', 'specimen', 2, 'blood', 23, 'blood', 1, NULL, NULL, '34445-B52', 'no', 'K', '2007-07-08 10:12:37', '1', '2009-07-08 10:12:37', '1', 0, NULL),
(27, 'PW - 27', 'specimen', 103, 'peritoneal wash', 27, 'peritoneal wash', 1, NULL, NULL, '', 'no', '', '2008-07-08 10:22:15', '1', '2009-07-08 10:22:15', '1', 0, NULL),
(29, 'PW - 29', 'specimen', 103, 'peritoneal wash', 29, 'peritoneal wash', 1, NULL, NULL, '', 'no', '', '2006-07-08 10:22:54', '1', '2009-07-08 10:22:54', '1', 0, NULL),
(31, 'CF - 31', 'specimen', 104, 'cystic fluid', 31, 'cystic fluid', 1, NULL, NULL, '', 'no', '', '2009-07-08 10:23:34', '1', '2009-07-08 10:23:34', '1', 0, NULL),
(34, 'CF - 34', 'specimen', 104, 'cystic fluid', 34, 'cystic fluid', 1, NULL, NULL, '', 'no', '', '2006-07-08 10:24:32', '1', '2009-07-08 10:24:32', '1', 0, NULL),
(36, 'CF - 36', 'specimen', 104, 'cystic fluid', 36, 'cystic fluid', 1, NULL, NULL, '', 'no', '', '2009-07-08 10:25:16', '1', '2009-07-08 10:25:16', '1', 0, NULL),
(41, 'T - 41', 'specimen', 3, 'tissue', 41, 'tissue', 1, NULL, NULL, '', 'no', '', '2009-07-08 10:31:22', '1', '2009-07-08 10:31:22', '1', 0, NULL),
(43, 'T - 43', 'specimen', 3, 'tissue', 43, 'tissue', 1, NULL, NULL, '', 'no', '', '2007-07-08 10:32:03', '1', '2009-07-08 10:32:03', '1', 0, NULL),
(46, 'T - 46', 'specimen', 3, 'tissue', 46, 'tissue', 1, NULL, NULL, '', 'no', '', '2009-07-08 10:32:51', '1', '2009-07-08 10:32:51', '1', 0, NULL),
(48, 'T - 48', 'specimen', 3, 'tissue', 48, 'tissue', 1, NULL, NULL, '', 'no', '', '2007-07-08 10:33:23', '1', '2009-07-08 10:33:23', '1', 0, NULL),
(51, 'OF - 51', 'specimen', 105, 'other fluid', 51, 'other fluid', 1, NULL, NULL, '', 'no', '', '2009-07-08 10:34:11', '1', '2009-07-08 10:34:11', '1', 0, NULL),
(53, 'C-CULT - 53', 'derivative', 11, 'cell culture', 51, 'other fluid', 1, 52, NULL, '', 'no', '', '2007-07-08 10:34:43', '1', '2009-07-08 10:34:43', '1', 0, NULL),
(54, 'C-CULT - 54', 'derivative', 11, 'cell culture', 51, 'other fluid', 1, 53, NULL, '', 'no', '', '2006-07-08 10:34:56', '1', '2009-07-08 10:34:56', '1', 0, NULL),
(55, 'C-CULT - 55', 'derivative', 11, 'cell culture', 51, 'other fluid', 1, 54, NULL, '', 'no', '', '2005-07-08 10:35:10', '1', '2009-07-08 10:35:10', '1', 0, NULL),
(56, 'C-CULT - 56', 'derivative', 11, 'cell culture', 51, 'other fluid', 1, 55, NULL, '', 'no', '', '2009-07-08 10:35:24', '1', '2009-07-08 10:35:24', '1', 0, NULL),
(57, 'U - 57', 'specimen', 4, 'urine', 57, 'urine', 1, NULL, NULL, '', 'no', '', '2008-07-08 10:35:47', '1', '2009-07-08 10:35:47', '1', 0, NULL),
(59, 'U - 59', 'specimen', 4, 'urine', 59, 'urine', 1, NULL, NULL, '', 'no', '', '2006-07-08 10:36:30', '1', '2009-07-08 10:36:30', '1', 0, NULL),
(61, 'A - 61', 'specimen', 1, 'ascite', 61, 'ascite', 1, NULL, NULL, '', 'no', '', '2009-07-08 10:37:12', '1', '2009-07-08 10:37:12', '1', 0, NULL);

DELETE FROM `sd_der_cell_cultures`;
INSERT INTO `sd_der_cell_cultures` (`id`, `sample_master_id`, `culture_status`, `culture_status_reason`, `cell_passage_number`, `created`, `created_by`, `modified`, `modified_by`, `deleted`, `deleted_date`) VALUES (13, 13, 'stopped', 'cell dead', 2, '2009-05-13 10:05:47', '1', '2009-05-13 10:05:47', '1', 0, NULL),
(16, 16, 'unknown', 'cell dead', 43, '2009-05-19 11:29:20', '1', '2009-05-19 11:29:20', '1', 0, NULL),
(53, 53, NULL, NULL, NULL, '2009-07-08 10:34:43', '1', '2009-07-08 10:34:43', '1', 0, NULL),
(54, 54, NULL, NULL, NULL, '2009-07-08 10:34:56', '1', '2009-07-08 10:34:56', '1', 0, NULL),
(55, 55, NULL, NULL, 43, '2009-07-08 10:35:10', '1', '2009-07-08 10:35:10', '1', 0, NULL),
(56, 56, NULL, NULL, NULL, '2009-07-08 10:35:24', '1', '2009-07-08 10:35:24', '1', 0, NULL);

DELETE FROM `sd_der_serums`;
INSERT INTO `sd_der_serums` (`id`, `sample_master_id`, `hemolyze_signs`, `created`, `created_by`, `modified`, `modified_by`, `deleted`, `deleted_date`) VALUES (25, 25, 'yes', '2009-07-08 10:15:31', '1', '2009-07-08 10:15:31', '1', 0, NULL);

DELETE FROM `sd_spe_ascites`;
INSERT INTO `sd_spe_ascites` (`id`, `sample_master_id`, `collected_volume`, `collected_volume_unit`, `created`, `created_by`, `modified`, `modified_by`, `deleted`, `deleted_date`) VALUES (7, 7, 560.00000, 'ml', '2009-05-13 09:48:09', '1', '2009-05-13 09:48:09', '1', 0, NULL),
(17, 17, 587.00000, 'ml', '2009-05-19 11:30:44', '1', '2009-05-19 11:30:44', '1', 0, NULL),
(21, 21, 45.00000, 'ul', '2009-07-08 10:11:30', '1', '2009-07-08 10:11:30', '1', 0, NULL),
(61, 61, 21.00000, NULL, '2009-07-08 10:37:12', '1', '2009-07-08 10:37:12', '1', 0, NULL);

DELETE FROM `sd_spe_bloods`;
INSERT INTO `sd_spe_bloods` (`id`, `sample_master_id`, `type`, `collected_tube_nbr`, `collected_volume`, `collected_volume_unit`, `created`, `created_by`, `modified`, `modified_by`, `deleted`, `deleted_date`) VALUES (3, 3, 'unknown', 2, 33.00000, 'ul', '2009-05-06 16:37:06', '1', '2009-05-06 16:37:06', '1', 0, NULL),
(6, 6, 'paxgene', 234, 50.00000, 'ml', '2009-05-07 09:49:29', '1', '2009-05-07 09:49:29', '1', 0, NULL),
(18, 18, NULL, 8798, 33.00000, 'ml', '2009-05-19 12:48:19', '1', '2009-05-19 12:48:19', '1', 0, NULL),
(19, 19, NULL, 43535, 50.00000, 'ml', '2009-05-28 01:09:14', '1', '2009-05-28 01:09:14', '1', 0, NULL),
(23, 23, 'gel CSA', 43, 3.00000, 'ml', '2009-07-08 10:12:37', '1', '2009-07-08 10:12:37', '1', 0, NULL);

DELETE FROM `sd_spe_cystic_fluids`;
INSERT INTO `sd_spe_cystic_fluids` (`id`, `sample_master_id`, `collected_volume`, `collected_volume_unit`, `created`, `created_by`, `modified`, `modified_by`, `deleted`, `deleted_date`) VALUES (31, 31, 54.00000, NULL, '2009-07-08 10:23:34', '1', '2009-07-08 10:23:34', '1', 0, NULL),
(34, 34, 54.00000, 'ul', '2009-07-08 10:24:32', '1', '2009-07-08 10:24:32', '1', 0, NULL),
(36, 36, 34.00000, 'ul', '2009-07-08 10:25:16', '1', '2009-07-08 10:25:16', '1', 0, NULL);

DELETE FROM `sd_spe_other_fluids`;
INSERT INTO `sd_spe_other_fluids` (`id`, `sample_master_id`, `collected_volume`, `collected_volume_unit`, `created`, `created_by`, `modified`, `modified_by`, `deleted`, `deleted_date`) VALUES (51, 51, 32.00000, 'ml', '2009-07-08 10:34:11', '1', '2009-07-08 10:34:11', '1', 0, NULL);

DELETE FROM `sd_spe_peritoneal_washes`;
INSERT INTO `sd_spe_peritoneal_washes` (`id`, `sample_master_id`, `collected_volume`, `collected_volume_unit`, `created`, `created_by`, `modified`, `modified_by`, `deleted`, `deleted_date`) VALUES (1, 1, 75.00000, 'ml', '2009-05-06 16:04:16', '1', '2009-05-06 16:04:16', '1', 0, NULL),
(27, 27, 45.00000, 'ml', '2009-07-08 10:22:15', '1', '2009-07-08 10:22:15', '1', 0, NULL),
(29, 29, 43.00000, 'ul', '2009-07-08 10:22:54', '1', '2009-07-08 10:22:54', '1', 0, NULL);

DELETE FROM `sd_spe_tissues`;
INSERT INTO `sd_spe_tissues` (`id`, `sample_master_id`, `tissue_source`, `nature`, `laterality`, `pathology_reception_datetime`, `size`, `created`, `created_by`, `modified`, `modified_by`, `deleted`, `deleted_date`) VALUES (8, 8, 'lung', 'malignant', 'right', '2009-05-13 10:00:00', '45', '2009-05-13 10:00:01', '1', '2009-05-13 10:00:01', '1', 0, NULL),
(15, 15, 'breast', 'benign', 'left', '2009-05-19 11:28:00', '24', '2009-05-19 11:28:30', '1', '2009-05-19 11:28:30', '1', 0, NULL),
(41, 41, NULL, NULL, NULL, '2009-07-08 10:31:00', NULL, '2009-07-08 10:31:22', '1', '2009-07-08 10:31:22', '1', 0, NULL),
(43, 43, NULL, NULL, NULL, '2009-07-08 10:32:00', NULL, '2009-07-08 10:32:03', '1', '2009-07-08 10:32:03', '1', 0, NULL),
(46, 46, NULL, NULL, NULL, '2009-07-08 10:32:00', NULL, '2009-07-08 10:32:51', '1', '2009-07-08 10:32:51', '1', 0, NULL),
(48, 48, NULL, NULL, NULL, '2009-07-08 10:33:00', NULL, '2009-07-08 10:33:23', '1', '2009-07-08 10:33:23', '1', 0, NULL);

-- Sample Masters, Sample Details, Sample Extends, Aliquot Masters and Aliquot Details  Test Data




