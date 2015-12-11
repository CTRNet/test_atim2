
-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Inactivate some functions
-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE datamart_structure_functions SET flag_active = 0
WHERE label = 'number of elements per participant'
AND datamart_structure_id IN (SELECT id FROM datamart_structures WHERE model IN ('ViewAliquotUse'));
UPDATE datamart_structure_functions SET flag_active = 0
WHERE label = 'create aliquots'
AND datamart_structure_id IN (SELECT id FROM datamart_structures WHERE model IN ('ViewSample'));

-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Study
-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE menus SET flag_active = 1 WHERE use_link LIKE '/Study/StudySummaries%';

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='studysummaries') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='disease_site' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ctrnet_submission_disease_site') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='studysummaries') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='summary' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='1', `flag_edit`='1', `flag_index`='1', `flag_detail`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='studysummaries') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='path_to_file' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='1', `display_order`='20' WHERE structure_id=(SELECT id FROM structures WHERE alias='studysummaries') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='summary' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='2', `display_order`='300', `language_heading`='documents' WHERE structure_id=(SELECT id FROM structures WHERE alias='studysummaries') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='path_to_file' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_fields SET  `setting`='size=60' WHERE model='StudySummary' AND tablename='study_summaries' AND field='path_to_file' AND `type`='input' AND structure_value_domain  IS NULL ;

REPLACE INTO i18n (id,en,fr) VALUES ('study_title','Study/Biomarker Name','');

ALTER TABLE study_summaries
  ADD COLUMN qc_tf_cpcbn_status VARCHAR(50) DEFAULT NULL,
  
  ADD COLUMN qc_tf_cpcbn_sc_initial_review DATE DEFAULT NULL,
  ADD COLUMN qc_tf_cpcbn_sc_initial_review_accuracy CHAR(1) NOT NULL DEFAULT '',
  ADD COLUMN qc_tf_cpcbn_opt_tma_image_review DATE DEFAULT NULL,
  ADD COLUMN qc_tf_cpcbn_opt_tma_image_review_accuracy CHAR(1) NOT NULL DEFAULT '',
  ADD COLUMN qc_tf_cpcbn_sc_review_of_test_array_series_data DATE DEFAULT NULL,
  ADD COLUMN qc_tf_cpcbn_sc_review_of_test_array_series_data_accuracy CHAR(1) NOT NULL DEFAULT '',
  ADD COLUMN qc_tf_cpcbn_sc_review_of_whole_rp_tma_series_data DATE DEFAULT NULL,
  ADD COLUMN qc_tf_cpcbn_sc_review_of_whole_rp_tma_series_data_accuracy CHAR(1) NOT NULL DEFAULT '',
  ADD COLUMN qc_tf_cpcbn_sc_review_of_rt_tma_access DATE DEFAULT NULL,
  ADD COLUMN qc_tf_cpcbn_sc_review_of_rt_tma_access_accuracy CHAR(1) NOT NULL DEFAULT '',
  ADD COLUMN qc_tf_cpcbn_sc_approval_to_access_profiling_data DATE DEFAULT NULL,
  ADD COLUMN qc_tf_cpcbn_sc_approval_to_access_profiling_data_accuracy CHAR(1) NOT NULL DEFAULT '',
  ADD COLUMN qc_tf_cpcbn_sc_approval_to_access_copy_number_variation DATE DEFAULT NULL,
  ADD COLUMN qc_tf_cpcbn_sc_approval_to_access_copy_number_variation_accuracy CHAR(1) NOT NULL DEFAULT '',

  ADD COLUMN qc_tf_cpcbn_pi VARCHAR(100) DEFAULT NULL,
  ADD COLUMN qc_tf_cpcbn_pi_email VARCHAR(100) DEFAULT NULL,
  ADD COLUMN qc_tf_cpcbn_contact_person VARCHAR(100) DEFAULT NULL,
  ADD COLUMN qc_tf_cpcbn_contact_person_email VARCHAR(100) DEFAULT NULL,
  ADD COLUMN qc_tf_cpcbn_location_shipping_address TEXT,

  ADD COLUMN qc_tf_cpcbn_proposal_and_review_response CHAR(1) NOT NULL DEFAULT '',
  ADD COLUMN qc_tf_cpcbn_erb_documents CHAR(1) NOT NULL DEFAULT '',
  ADD COLUMN qc_tf_cpcbn_mta_documents CHAR(1) NOT NULL DEFAULT '',
  ADD COLUMN qc_tf_cpcbn_publications CHAR(1) NOT NULL DEFAULT '';
  
ALTER TABLE study_summaries_revs
  ADD COLUMN qc_tf_cpcbn_status VARCHAR(50) DEFAULT NULL,
  
  ADD COLUMN qc_tf_cpcbn_sc_initial_review DATE DEFAULT NULL,
  ADD COLUMN qc_tf_cpcbn_sc_initial_review_accuracy CHAR(1) NOT NULL DEFAULT '',
  ADD COLUMN qc_tf_cpcbn_opt_tma_image_review DATE DEFAULT NULL,
  ADD COLUMN qc_tf_cpcbn_opt_tma_image_review_accuracy CHAR(1) NOT NULL DEFAULT '',
  ADD COLUMN qc_tf_cpcbn_sc_review_of_test_array_series_data DATE DEFAULT NULL,
  ADD COLUMN qc_tf_cpcbn_sc_review_of_test_array_series_data_accuracy CHAR(1) NOT NULL DEFAULT '',
  ADD COLUMN qc_tf_cpcbn_sc_review_of_whole_rp_tma_series_data DATE DEFAULT NULL,
  ADD COLUMN qc_tf_cpcbn_sc_review_of_whole_rp_tma_series_data_accuracy CHAR(1) NOT NULL DEFAULT '',
  ADD COLUMN qc_tf_cpcbn_sc_review_of_rt_tma_access DATE DEFAULT NULL,
  ADD COLUMN qc_tf_cpcbn_sc_review_of_rt_tma_access_accuracy CHAR(1) NOT NULL DEFAULT '',
  ADD COLUMN qc_tf_cpcbn_sc_approval_to_access_profiling_data DATE DEFAULT NULL,
  ADD COLUMN qc_tf_cpcbn_sc_approval_to_access_profiling_data_accuracy CHAR(1) NOT NULL DEFAULT '',
  ADD COLUMN qc_tf_cpcbn_sc_approval_to_access_copy_number_variation DATE DEFAULT NULL,
  ADD COLUMN qc_tf_cpcbn_sc_approval_to_access_copy_number_variation_accuracy CHAR(1) NOT NULL DEFAULT '',

  ADD COLUMN qc_tf_cpcbn_pi VARCHAR(100) DEFAULT NULL,
  ADD COLUMN qc_tf_cpcbn_pi_email VARCHAR(100) DEFAULT NULL,
  ADD COLUMN qc_tf_cpcbn_contact_person VARCHAR(100) DEFAULT NULL,
  ADD COLUMN qc_tf_cpcbn_contact_person_email VARCHAR(100) DEFAULT NULL,
  ADD COLUMN qc_tf_cpcbn_location_shipping_address TEXT,

  ADD COLUMN qc_tf_cpcbn_proposal_and_review_response CHAR(1) NOT NULL DEFAULT '',
  ADD COLUMN qc_tf_cpcbn_erb_documents CHAR(1) NOT NULL DEFAULT '',
  ADD COLUMN qc_tf_cpcbn_mta_documents CHAR(1) NOT NULL DEFAULT '',
  ADD COLUMN qc_tf_cpcbn_publications CHAR(1) NOT NULL DEFAULT '';  
  
INSERT INTO structure_value_domains (domain_name, source) 
VALUES 
('qc_tf_cpcbn_study_status', "StructurePermissibleValuesCustom::getCustomDropdown('Study Status')");
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) 
VALUES 
('Study Status', 1, 50, 'storage');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Study Status');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
('go to Opt-TMA', '',  '', '1', @control_id, NOW(), NOW(), 1, 1), 
('pending to Opt-TMA', '',  '', '1', @control_id, NOW(), NOW(), 1, 1), 
('no go to Opt-TMA', '',  '', '1', @control_id, NOW(), NOW(), 1, 1), 
('go to Test-TMA', '',  '', '1', @control_id, NOW(), NOW(), 1, 1), 
('pending to Test-TMA', '',  '', '1', @control_id, NOW(), NOW(), 1, 1), 
('no go to test-TMA', '',  '', '1', @control_id, NOW(), NOW(), 1, 1), 
('go to whole-TMA', '',  '', '1', @control_id, NOW(), NOW(), 1, 1), 
('pending to whole-TMA', '',  '', '1', @control_id, NOW(), NOW(), 1, 1), 
('no go to whole-TMA', '',  '', '1', @control_id, NOW(), NOW(), 1, 1), 
('go to access data', '',  '', '1', @control_id, NOW(), NOW(), 1, 1), 
('pending to access data', '',  '', '1', @control_id, NOW(), NOW(), 1, 1), 
('no go to access data', '',  '', '1', @control_id, NOW(), NOW(), 1, 1);

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Study', 'StudySummary', 'study_summaries', 'qc_tf_cpcbn_status', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_cpcbn_study_status') , '0', '', '', '', 'status', ''), 
('Study', 'StudySummary', 'study_summaries', 'qc_tf_cpcbn_sc_initial_review', 'date',  NULL , '0', '', '', '', 'sc initial review', ''), 
('Study', 'StudySummary', 'study_summaries', 'qc_tf_cpcbn_opt_tma_image_review', 'date',  NULL , '0', '', '', '', 'opt tma image review', ''), 
('Study', 'StudySummary', 'study_summaries', 'qc_tf_cpcbn_sc_review_of_test_array_series_data', 'date',  NULL , '0', '', '', '', 'sc review of test array series data', ''), 
('Study', 'StudySummary', 'study_summaries', 'qc_tf_cpcbn_sc_review_of_whole_rp_tma_series_data', 'date',  NULL , '0', '', '', '', 'sc review of whole rp tma series data', ''), 
('Study', 'StudySummary', 'study_summaries', 'qc_tf_cpcbn_sc_review_of_rt_tma_access', 'date',  NULL , '0', '', '', '', 'sc review of rt tma access', ''), 
('Study', 'StudySummary', 'study_summaries', 'qc_tf_cpcbn_sc_approval_to_access_profiling_data', 'date',  NULL , '0', '', '', '', 'sc approval to access profiling data', ''), 
('Study', 'StudySummary', 'study_summaries', 'qc_tf_cpcbn_sc_approval_to_access_copy_number_variation', 'date',  NULL , '0', '', '', '', 'sc approval to access copy number variation', ''), 
('Study', 'StudySummary', 'study_summaries', 'qc_tf_cpcbn_pi', 'input',  NULL , '0', '', '', '', 'pi', ''), 
('Study', 'StudySummary', 'study_summaries', 'qc_tf_cpcbn_pi_email', 'input',  NULL , '0', '', '', '', '', 'email'), 
('Study', 'StudySummary', 'study_summaries', 'qc_tf_cpcbn_contact_person', 'input',  NULL , '0', '', '', '', 'contact person', ''), 
('Study', 'StudySummary', 'study_summaries', 'qc_tf_cpcbn_contact_person_email', 'input',  NULL , '0', '', '', '', '', 'email'), 
('Study', 'StudySummary', 'study_summaries', 'qc_tf_cpcbn_location_shipping_address', 'textarea',  NULL , '0', '', '', '', 'location shipping address', ''), 
('Study', 'StudySummary', 'study_summaries', 'qc_tf_cpcbn_proposal_and_review_response', 'yes_no',  NULL , '0', '', '', '', 'proposal and review response', ''), 
('Study', 'StudySummary', 'study_summaries', 'qc_tf_cpcbn_erb_documents', 'yes_no',  NULL , '0', '', '', '', 'erb documents', ''), 
('Study', 'StudySummary', 'study_summaries', 'qc_tf_cpcbn_mta_documents', 'yes_no',  NULL , '0', '', '', '', 'mta documents', ''), 
('Study', 'StudySummary', 'study_summaries', 'qc_tf_cpcbn_publications', 'yes_no',  NULL , '0', '', '', '', 'publications', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='studysummaries'), (SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='qc_tf_cpcbn_status' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_cpcbn_study_status')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='status' AND `language_tag`=''), '1', '2', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='studysummaries'), (SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='qc_tf_cpcbn_sc_initial_review' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='sc initial review' AND `language_tag`=''), '1', '100', 'approval/review', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='studysummaries'), (SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='qc_tf_cpcbn_opt_tma_image_review' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='opt tma image review' AND `language_tag`=''), '1', '101', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='studysummaries'), (SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='qc_tf_cpcbn_sc_review_of_test_array_series_data' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='sc review of test array series data' AND `language_tag`=''), '1', '102', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='studysummaries'), (SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='qc_tf_cpcbn_sc_review_of_whole_rp_tma_series_data' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='sc review of whole rp tma series data' AND `language_tag`=''), '1', '103', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='studysummaries'), (SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='qc_tf_cpcbn_sc_review_of_rt_tma_access' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='sc review of rt tma access' AND `language_tag`=''), '1', '104', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='studysummaries'), (SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='qc_tf_cpcbn_sc_approval_to_access_profiling_data' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='sc approval to access profiling data' AND `language_tag`=''), '1', '105', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='studysummaries'), (SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='qc_tf_cpcbn_sc_approval_to_access_copy_number_variation' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='sc approval to access copy number variation' AND `language_tag`=''), '1', '106', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='studysummaries'), (SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='qc_tf_cpcbn_pi' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='pi' AND `language_tag`=''), '2', '200', 'contacts', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='studysummaries'), (SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='qc_tf_cpcbn_pi_email' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='email'), '2', '201', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='studysummaries'), (SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='qc_tf_cpcbn_contact_person' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='contact person' AND `language_tag`=''), '2', '202', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='studysummaries'), (SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='qc_tf_cpcbn_contact_person_email' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='email'), '2', '203', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='studysummaries'), (SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='qc_tf_cpcbn_location_shipping_address' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='location shipping address' AND `language_tag`=''), '2', '204', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='studysummaries'), (SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='qc_tf_cpcbn_proposal_and_review_response' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='proposal and review response' AND `language_tag`=''), '2', '300', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='studysummaries'), (SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='qc_tf_cpcbn_erb_documents' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='erb documents' AND `language_tag`=''), '2', '301', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='studysummaries'), (SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='qc_tf_cpcbn_mta_documents' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='mta documents' AND `language_tag`=''), '2', '302', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='studysummaries'), (SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='qc_tf_cpcbn_publications' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='publications' AND `language_tag`=''), '2', '303', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');

INSERT IGNORE INTO i18n (id,en)
VALUES
('approval/review','Approval/Review'),
('sc initial review','Study Committee Initial review'), 	
('opt tma image review','Date of Opt-TMA Image Review'), 	
('sc review of test array series data','Date of Study Committee Review of Test-Array Series Data'), 	
('sc review of whole rp tma series data','Date of Study Committee Review of Whole RP TMA Series Data'), 	
('sc review of rt tma access','Date of Study Committee Review for RT-TMA Access'), 	
('sc approval to access profiling data','Date of Study Committee Approval to Access Profiling Data'), 	
('sc approval to access copy number variation','Date of Study Committee Approval to Access Copy Number Variation Data'), 
('pi','PI'),
('contact person','Contact Person'),
('location shipping address','Location/Shipping Address'),		    
('documents','Documents'),
('proposal and review response','Proposal and Review Response'),
('erb documents','ERB Documents'),
('mta documents','MTA Documents'),
('publications','Publications');

ALTER TABLE study_summaries
  ADD COLUMN qc_tf_cpcbn_publication_details TEXT;
ALTER TABLE study_summaries_revs
  ADD COLUMN qc_tf_cpcbn_publication_details TEXT;
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Study', 'StudySummary', 'study_summaries', 'qc_tf_cpcbn_publication_details', 'textarea',  NULL , '0', '', '', '', 'publications details', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='studysummaries'), (SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='qc_tf_cpcbn_publication_details' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='publications details' AND `language_tag`=''), '2', '304', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT IGNORE INTO i18n (id,en)
VALUES
('publications details','Publications Details');

INSERT INTO `datamart_structures` (`id`, `plugin`, `model`, `structure_id`, `adv_search_structure_alias`, `display_name`, `control_master_model`, `index_link`, `batch_edit_link`) VALUES
(null, 'Study', 'StudySummary', (SELECT id FROM structures WHERE alias='studysummaries'), NULL, 'study', '', '/Study/StudySummaries/detail/%%StudySummary.id%%/', '');
INSERT INTO `datamart_browsing_controls` (`id1`, `id2`, `flag_active_1_to_2`, `flag_active_2_to_1`, `use_field`) VALUES
((SELECT id FROM datamart_structures WHERE model = 'TmaSlide'), (SELECT id FROM datamart_structures WHERE model='StudySummary'), 1, 1, 'study_summary_id');

-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- TMA Slide
-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  
UPDATE structure_fields SET  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='study_list') ,  `language_label`='study / marker' WHERE model='TmaSlide' AND tablename='tma_slides' AND field='study_summary_id' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='study_list');
UPDATE structure_formats SET `language_heading`='system data', `flag_add`='0', `flag_addgrid_readonly`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='tma_slides') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TmaSlide' AND `tablename`='tma_slides' AND `field`='barcode' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='tma_slides') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TmaSlide' AND `tablename`='tma_slides' AND `field`='immunochemistry' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='100', `language_heading`='storage' WHERE structure_id=(SELECT id FROM structures WHERE alias='tma_slides') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='recorded_storage_selection_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='100', `language_heading`='storage' WHERE structure_id=(SELECT id FROM structures WHERE alias='tma_slides') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StorageMaster' AND `tablename`='storage_masters' AND `field`='selection_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='101' WHERE structure_id=(SELECT id FROM structures WHERE alias='tma_slides') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TmaSlide' AND `tablename`='tma_slides' AND `field`='storage_coord_x' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='102' WHERE structure_id=(SELECT id FROM structures WHERE alias='tma_slides') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TmaSlide' AND `tablename`='tma_slides' AND `field`='storage_coord_y' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='103', `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='tma_slides') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TmaSlide' AND `tablename`='tma_slides' AND `field`='storage_datetime' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='1', `display_order`='1000' WHERE structure_id=(SELECT id FROM structures WHERE alias='tma_slides') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TmaSlide' AND `tablename`='tma_slides' AND `field`='barcode' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_addgrid`='0', `flag_addgrid_readonly`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='tma_slides') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TmaSlide' AND `tablename`='tma_slides' AND `field`='barcode' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='tma_slides') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TmaSlide' AND `tablename`='tma_slides' AND `field`='picture_path' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

ALTER TABLE tma_slides
  ADD COLUMN qc_tf_cpcbn_slide_type VARCHAR(50) DEFAULT NULL,
  ADD COLUMN qc_tf_cpcbn_section_id INT(6) DEFAULT NULL,
  ADD COLUMN qc_tf_cpcbn_sectionning_date DATE DEFAULT NULL,
  ADD COLUMN qc_tf_cpcbn_sectionning_date_accuracy CHAR(1) NOT NULL DEFAULT '',  
  ADD COLUMN qc_tf_cpcbn_thickness INT(6) DEFAULT NULL,
  ADD COLUMN qc_tf_cpcbn_quality_assessment VARCHAR(50) DEFAULT NULL,
  ADD COLUMN qc_tf_cpcbn_paraffin_protection CHAR(1) NOT NULL DEFAULT '',
  ADD COLUMN qc_tf_cpcbn_shipping_date DATE DEFAULT NULL,
  ADD COLUMN qc_tf_cpcbn_shipping_date_accuracy CHAR(1) NOT NULL DEFAULT '',
  ADD COLUMN qc_tf_cpcbn_image_id VARCHAR(100) DEFAULT NULL,
  ADD COLUMN qc_tf_cpcbn_image_location VARCHAR(50) DEFAULT NULL,
  ADD COLUMN qc_tf_cpcbn_scoring_results_reception_date DATE DEFAULT NULL,
  ADD COLUMN qc_tf_cpcbn_scoring_results_reception_date_accuracy CHAR(1) NOT NULL DEFAULT '',
  ADD COLUMN qc_tf_cpcbn_clinical_data_version DATE DEFAULT NULL,
  ADD COLUMN qc_tf_cpcbn_scoring_results_file_id VARCHAR(100) DEFAULT NULL,
  ADD COLUMN qc_tf_cpcbn_notes TEXT;
ALTER TABLE tma_slides_revs
  ADD COLUMN qc_tf_cpcbn_slide_type VARCHAR(50) DEFAULT NULL,
  ADD COLUMN qc_tf_cpcbn_section_id INT(6) DEFAULT NULL,
  ADD COLUMN qc_tf_cpcbn_sectionning_date DATE DEFAULT NULL,
  ADD COLUMN qc_tf_cpcbn_sectionning_date_accuracy CHAR(1) NOT NULL DEFAULT '',  
  ADD COLUMN qc_tf_cpcbn_thickness INT(6) DEFAULT NULL,
  ADD COLUMN qc_tf_cpcbn_quality_assessment VARCHAR(50) DEFAULT NULL,
  ADD COLUMN qc_tf_cpcbn_paraffin_protection CHAR(1) NOT NULL DEFAULT '',
  ADD COLUMN qc_tf_cpcbn_shipping_date DATE DEFAULT NULL,
  ADD COLUMN qc_tf_cpcbn_shipping_date_accuracy CHAR(1) NOT NULL DEFAULT '',
  ADD COLUMN qc_tf_cpcbn_image_id VARCHAR(100) DEFAULT NULL,
  ADD COLUMN qc_tf_cpcbn_image_location VARCHAR(50) DEFAULT NULL,
  ADD COLUMN qc_tf_cpcbn_scoring_results_reception_date DATE DEFAULT NULL,
  ADD COLUMN qc_tf_cpcbn_scoring_results_reception_date_accuracy CHAR(1) NOT NULL DEFAULT '',
  ADD COLUMN qc_tf_cpcbn_clinical_data_version DATE DEFAULT NULL,
  ADD COLUMN qc_tf_cpcbn_scoring_results_file_id VARCHAR(100) DEFAULT NULL,
  ADD COLUMN qc_tf_cpcbn_notes TEXT;

INSERT INTO structure_value_domains (domain_name, source) 
VALUES 
('qc_tf_tma_slide_quality_assessment', "StructurePermissibleValuesCustom::getCustomDropdown('TMA Slide : Quality Assessment')"),
('qc_tf_tma_slide_image_location', "StructurePermissibleValuesCustom::getCustomDropdown('TMA Slide : Image Location')"),
('qc_tf_cpcbn_tma_slide_type', "StructurePermissibleValuesCustom::getCustomDropdown('TMA Slide : Type')");
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) 
VALUES 
('TMA Slide : Quality Assessment', 1, 50, 'storage'),
('TMA Slide : Image Location', 1, 50, 'storage'),
('TMA Slide : Type', 1, 50, 'storage');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'TMA Slide : Quality Assessment');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
('<10 cores missing', 'a. <10 cores missing',  '', '1', @control_id, NOW(), NOW(), 1, 1), 
('10 to 20 cores missing', 'b. 10 to 20 cores missing',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('>20 cores missing', 'c. >20 cores missing',  '', '1', @control_id, NOW(), NOW(), 1, 1);  
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'TMA Slide : Image Location');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
('MUHC', '',  '', '1', @control_id, NOW(), NOW(), 1, 1), 
('CHUM', '',  '', '1', @control_id, NOW(), NOW(), 1, 1), 
('CHUM & MUHC', '',  '', '1', @control_id, NOW(), NOW(), 1, 1);  
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'TMA Slide : Type');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
('opt-tma', 'Opt-TMA',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('test-tma series', 'Test-TMA Series',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('whole rp-tma series', 'Whole RP-TMA Series',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('rt-tmas series', 'RT-TMAs Series',  '', '1', @control_id, NOW(), NOW(), 1, 1);

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('StorageLayout', 'TmaSlide', 'tma_slides', 'qc_tf_cpcbn_section_id', 'integer_positive',  NULL , '0', '', '', '', 'section id', ''), 
('StorageLayout', 'TmaSlide', 'tma_slides', 'qc_tf_cpcbn_sectionning_date', 'date',  NULL , '0', '', '', '', 'sectionning date', ''), 
('StorageLayout', 'TmaSlide', 'tma_slides', 'qc_tf_cpcbn_thickness', 'integer_positive',  NULL , '0', '', '', '', 'thickness (um)', ''), 
('StorageLayout', 'TmaSlide', 'tma_slides', 'qc_tf_cpcbn_quality_assessment', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_tma_slide_quality_assessment') , '0', '', '', '', 'quality assessment', ''), 
('StorageLayout', 'TmaSlide', 'tma_slides', 'qc_tf_cpcbn_paraffin_protection', 'yes_no',  NULL , '0', '', '', '', 'paraffin protection', ''), 
('StorageLayout', 'TmaSlide', 'tma_slides', 'qc_tf_cpcbn_shipping_date', 'date',  NULL , '0', '', '', '', 'shipping date', ''), 
('StorageLayout', 'TmaSlide', 'tma_slides', 'qc_tf_cpcbn_image_id', 'input',  NULL , '0', '', '', '', 'image id', ''), 
('StorageLayout', 'TmaSlide', 'tma_slides', 'qc_tf_cpcbn_image_location', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_tma_slide_image_location') , '0', '', '', '', 'image location', ''), 
('StorageLayout', 'TmaSlide', 'tma_slides', 'qc_tf_cpcbn_scoring_results_reception_date', 'date',  NULL , '0', '', '', '', 'date reception scoring results', ''), 
('StorageLayout', 'TmaSlide', 'tma_slides', 'qc_tf_cpcbn_clinical_data_version', 'date',  NULL , '0', '', '', '', 'clinical data version', ''), 
('StorageLayout', 'TmaSlide', 'tma_slides', 'qc_tf_cpcbn_scoring_results_file_id', 'input',  NULL , '0', '', '', '', 'scoring results file id', ''), 
('StorageLayout', 'TmaSlide', 'tma_slides', 'qc_tf_cpcbn_notes', 'textarea',  NULL , '0', '', '', '', 'notes', ''), 
('StorageLayout', 'TmaSlide', 'tma_slides', 'qc_tf_cpcbn_slide_type', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_cpcbn_tma_slide_type') , '0', '', '', '', 'type', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='tma_slides'), (SELECT id FROM structure_fields WHERE `model`='TmaSlide' AND `tablename`='tma_slides' AND `field`='qc_tf_cpcbn_section_id' AND `type`='integer_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='section id' AND `language_tag`=''), '0', '2', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='tma_slides'), (SELECT id FROM structure_fields WHERE `model`='TmaSlide' AND `tablename`='tma_slides' AND `field`='qc_tf_cpcbn_sectionning_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='sectionning date' AND `language_tag`=''), '0', '10', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='tma_slides'), (SELECT id FROM structure_fields WHERE `model`='TmaSlide' AND `tablename`='tma_slides' AND `field`='qc_tf_cpcbn_thickness' AND `type`='integer_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='thickness (um)' AND `language_tag`=''), '0', '11', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='tma_slides'), (SELECT id FROM structure_fields WHERE `model`='TmaSlide' AND `tablename`='tma_slides' AND `field`='qc_tf_cpcbn_quality_assessment' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_tma_slide_quality_assessment')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='quality assessment' AND `language_tag`=''), '0', '12', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='tma_slides'), (SELECT id FROM structure_fields WHERE `model`='TmaSlide' AND `tablename`='tma_slides' AND `field`='qc_tf_cpcbn_paraffin_protection' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='paraffin protection' AND `language_tag`=''), '0', '13', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='tma_slides'), (SELECT id FROM structure_fields WHERE `model`='TmaSlide' AND `tablename`='tma_slides' AND `field`='qc_tf_cpcbn_shipping_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='shipping date' AND `language_tag`=''), '1', '50', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='tma_slides'), (SELECT id FROM structure_fields WHERE `model`='TmaSlide' AND `tablename`='tma_slides' AND `field`='qc_tf_cpcbn_image_id' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='image id' AND `language_tag`=''), '1', '52', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='tma_slides'), (SELECT id FROM structure_fields WHERE `model`='TmaSlide' AND `tablename`='tma_slides' AND `field`='qc_tf_cpcbn_image_location' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_tma_slide_image_location')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='image location' AND `language_tag`=''), '1', '53', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='tma_slides'), (SELECT id FROM structure_fields WHERE `model`='TmaSlide' AND `tablename`='tma_slides' AND `field`='qc_tf_cpcbn_scoring_results_reception_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='date reception scoring results' AND `language_tag`=''), '1', '54', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='tma_slides'), (SELECT id FROM structure_fields WHERE `model`='TmaSlide' AND `tablename`='tma_slides' AND `field`='qc_tf_cpcbn_clinical_data_version' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='clinical data version' AND `language_tag`=''), '1', '55', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='tma_slides'), (SELECT id FROM structure_fields WHERE `model`='TmaSlide' AND `tablename`='tma_slides' AND `field`='qc_tf_cpcbn_scoring_results_file_id' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='scoring results file id' AND `language_tag`=''), '1', '56', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='tma_slides'), (SELECT id FROM structure_fields WHERE `model`='TmaSlide' AND `tablename`='tma_slides' AND `field`='qc_tf_cpcbn_notes' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='notes' AND `language_tag`=''), '1', '70', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='tma_slides'), (SELECT id FROM structure_fields WHERE `model`='TmaSlide' AND `tablename`='tma_slides' AND `field`='qc_tf_cpcbn_slide_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_cpcbn_tma_slide_type')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='type' AND `language_tag`=''), '0', '1', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO structure_validations(structure_field_id, rule) VALUES
((SELECT id FROM structure_fields WHERE `model`='TmaSlide' AND `tablename`='tma_slides' AND `field`='qc_tf_cpcbn_section_id'), 'notEmpty'),
((SELECT id FROM structure_fields WHERE `model`='TmaSlide' AND `tablename`='tma_slides' AND `field`='qc_tf_cpcbn_slide_type'), 'notEmpty');

INSERT IGNORE INTO i18n (id,en)
VALUES
('section id', 'Section ID'),
('sectionning date','Sectionning Date'),
('thickness (um)', 'Thickness (um)'),
('quality assessment','Quality Assessment'),
('paraffin protection','Paraffin Protection'),
('shipping date','Shipping Date'),
('image id', 'Image ID '),
('image location','Image Location'),
('date reception scoring results','Date reception Scoring Results'),
('clinical data version','Clinical Data Version'),
('study / marker','Study/Marker'),
('scoring results file id','Scoring Results File ID');
REPLACE INTO i18n (id,en)
VALUES
('shipping date','Shipping Date'); 
  
UPDATE structure_formats SET `flag_addgrid`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='tma_slides') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TmaSlide' AND `tablename`='tma_slides' AND `field`='qc_tf_cpcbn_shipping_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_addgrid`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='tma_slides') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TmaSlide' AND `tablename`='tma_slides' AND `field`='qc_tf_cpcbn_image_id' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_addgrid`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='tma_slides') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TmaSlide' AND `tablename`='tma_slides' AND `field`='qc_tf_cpcbn_image_location' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_tma_slide_image_location') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_addgrid`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='tma_slides') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TmaSlide' AND `tablename`='tma_slides' AND `field`='qc_tf_cpcbn_scoring_results_reception_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_addgrid`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='tma_slides') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TmaSlide' AND `tablename`='tma_slides' AND `field`='qc_tf_cpcbn_clinical_data_version' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_addgrid`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='tma_slides') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TmaSlide' AND `tablename`='tma_slides' AND `field`='qc_tf_cpcbn_scoring_results_file_id' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='20', `flag_addgrid`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='tma_slides') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TmaSlide' AND `tablename`='tma_slides' AND `field`='study_summary_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='study_list') AND `flag_confidential`='0');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='tma_slides'), (SELECT id FROM structure_fields WHERE `model`='Block' AND `tablename`='storage_masters' AND `field`='short_label' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=6' AND `default`='' AND `language_help`='stor_short_label_defintion' AND `language_label`='storage short label' AND `language_tag`=''), '0', '1', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0', '0', '0', '0', '0');
UPDATE structure_formats SET `flag_override_label`='1', `language_label`='block', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='tma_slides') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Block' AND `tablename`='storage_masters' AND `field`='short_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='tma_slides') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TmaSlide' AND `tablename`='tma_slides' AND `field`='qc_tf_cpcbn_slide_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_cpcbn_tma_slide_type') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='2' WHERE structure_id=(SELECT id FROM structures WHERE alias='tma_slides') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TmaSlide' AND `tablename`='tma_slides' AND `field`='qc_tf_cpcbn_slide_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_cpcbn_tma_slide_type') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='tma_slides') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Block' AND `tablename`='storage_masters' AND `field`='short_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='tma_slides') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TmaSlide' AND `tablename`='tma_slides' AND `field`='qc_tf_cpcbn_section_id' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='50' WHERE structure_id=(SELECT id FROM structures WHERE alias='tma_slides') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TmaSlide' AND `tablename`='tma_slides' AND `field`='qc_tf_cpcbn_clinical_data_version' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_fields SET  `type`='input',  `setting`='size=3' WHERE model='TmaSlide' AND tablename='tma_slides' AND field='qc_tf_cpcbn_section_id' AND `type`='integer_positive' AND structure_value_domain  IS NULL ;
INSERT INTO structure_validations(structure_field_id, rule,language_message) 
VALUES
((SELECT id FROM structure_fields WHERE model='TmaSlide' AND tablename='tma_slides' AND field='qc_tf_cpcbn_section_id'), 'custom,/[0-9]+/', 'error_must_be_positive_integer');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('StorageLayout', 'Block', 'storage_masters', 'qc_tf_tma_name', 'input',  NULL , '0', 'size=20', '', '', 'tma name central', ''), 
('StorageLayout', 'Block', 'storage_masters', 'qc_tf_tma_label_site', 'input',  NULL , '0', 'size=20', '', '', 'TMA label site', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='tma_slides'), (SELECT id FROM structure_fields WHERE `model`='Block' AND `tablename`='storage_masters' AND `field`='qc_tf_tma_name' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=20' AND `default`='' AND `language_help`='' AND `language_label`='tma name central' AND `language_tag`=''), '0', '-2', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='tma_slides'), (SELECT id FROM structure_fields WHERE `model`='Block' AND `tablename`='storage_masters' AND `field`='qc_tf_tma_label_site' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=20' AND `default`='' AND `language_help`='' AND `language_label`='TMA label site' AND `language_tag`=''), '0', '0', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0', '1', '0', '0', '0');
UPDATE structure_formats SET `display_order`='-1' WHERE structure_id=(SELECT id FROM structures WHERE alias='tma_slides') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Block' AND `tablename`='storage_masters' AND `field`='short_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats SET `display_order`='0', `flag_override_label`='0', `language_label`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='tma_slides') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Block' AND `tablename`='storage_masters' AND `field`='short_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='-1' WHERE structure_id=(SELECT id FROM structures WHERE alias='tma_slides') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Block' AND `tablename`='storage_masters' AND `field`='qc_tf_tma_label_site' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='block' WHERE structure_id=(SELECT id FROM structures WHERE alias='tma_slides') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Block' AND `tablename`='storage_masters' AND `field`='qc_tf_tma_name' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='slide' WHERE structure_id=(SELECT id FROM structures WHERE alias='tma_slides') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TmaSlide' AND `tablename`='tma_slides' AND `field`='qc_tf_cpcbn_section_id' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
INSERT INTO i18n (id,en)
VALUES 
('you can not record section id [%s] twice', 'You can not record section id [%s] twice!'),
('the section id [%s] has already been recorded', 'The section id [%s] has already been recorded!');

-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- TMA Slide Box
-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

INSERT INTO `storage_controls` (`id`, `storage_type`, `coord_x_title`, `coord_x_type`, `coord_x_size`, `coord_y_title`, `coord_y_type`, `coord_y_size`, 
`display_x_size`, `display_y_size`, `reverse_x_numbering`, `reverse_y_numbering`, `horizontal_increment`, `set_temperature`, `is_tma_block`, `flag_active`, `detail_form_alias`, `detail_tablename`, `databrowser_label`, `check_conflicts`) VALUES
(null, 'box-tma-slide', 'position', 'integer', 100, NULL, NULL, NULL, 
2, 50, 0, 0, 0, 0, 0, 1, '', 'std_boxs', 'custom#storage types#box-tma-slide', 1);

SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Storage Types');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
('box-tma-slide', 'Box (Slides)',  '', '1', @control_id, NOW(), NOW(), 1, 1);

DELETE FROM structure_formats WHERE structure_id = (SELECT id FROM structures WHERE alias='storagemasters') AND structure_field_id IN (SELECT id FROM structure_fields WHERE `model`='StorageMaster' AND `tablename`='storage_masters' AND `field` LIKE 'qc_tf_%');
DELETE FROM structure_formats WHERE structure_id = (SELECT id FROM structures WHERE alias='std_tma_blocks') AND structure_field_id IN (SELECT id FROM structure_fields WHERE `model`='StorageMaster' AND `tablename`='storage_masters' AND `field` LIKE 'qc_tf_%');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='std_tma_blocks'), (SELECT id FROM structure_fields WHERE `model`='StorageMaster' AND `tablename`='storage_masters' AND `field`='qc_tf_tma_name' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '0', '5', '', '0', '1', 'tma name central', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='std_tma_blocks'), (SELECT id FROM structure_fields WHERE `model`='StorageMaster' AND `tablename`='storage_masters' AND `field`='qc_tf_tma_label_site' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=20' AND `default`='' AND `language_help`='' AND `language_label`='TMA label site' AND `language_tag`=''), '0', '4', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='std_tma_blocks'), (SELECT id FROM structure_fields WHERE `model`='StorageMaster' AND `tablename`='storage_masters' AND `field`='qc_tf_bank_id' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='banks')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='bank' AND `language_tag`=''), '0', '3', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
UPDATE structure_formats SET `language_heading`='tma block data' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_storage_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewStorageMaster' AND `tablename`='' AND `field`='qc_tf_bank_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='banks') AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='storage data' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_storage_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewStorageMaster' AND `tablename`='view_storage_masters' AND `field`='short_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
INSERT INTO i18n (id,en) 
VALUES
('tma block data', 'TMA Block Data'),
('storage data', 'Storage Data');
UPDATE structure_formats SET `display_order`='4' WHERE structure_id=(SELECT id FROM structures WHERE alias='std_tma_blocks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StorageMaster' AND `tablename`='storage_masters' AND `field`='qc_tf_bank_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='banks') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='5' WHERE structure_id=(SELECT id FROM structures WHERE alias='std_tma_blocks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StorageMaster' AND `tablename`='storage_masters' AND `field`='qc_tf_tma_label_site' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='6' WHERE structure_id=(SELECT id FROM structures WHERE alias='std_tma_blocks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StorageMaster' AND `tablename`='storage_masters' AND `field`='qc_tf_tma_name' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='std_tma_blocks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StorageMaster' AND `tablename`='storage_masters' AND `field`='qc_tf_tma_name' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='std_tma_blocks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StorageMaster' AND `tablename`='storage_masters' AND `field`='qc_tf_tma_label_site' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='std_tma_blocks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StorageMaster' AND `tablename`='storage_masters' AND `field`='qc_tf_bank_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='banks') AND `flag_confidential`='0');

-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE versions SET branch_build_number = '6318' WHERE version_number = '2.6.6';

-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Add study field : Evaluation of the ​Response to Reviewer​​s
-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

ALTER TABLE study_summaries
  ADD COLUMN qc_tf_cpcbn_sc_response_evaluation DATE DEFAULT NULL,
  ADD COLUMN qc_tf_cpcbn_sc_response_evaluation_accuracy CHAR(1) NOT NULL DEFAULT '';
ALTER TABLE study_summaries_revs
  ADD COLUMN qc_tf_cpcbn_sc_response_evaluation DATE DEFAULT NULL,
  ADD COLUMN qc_tf_cpcbn_sc_response_evaluation_accuracy CHAR(1) NOT NULL DEFAULT '';
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Study', 'StudySummary', 'study_summaries', 'qc_tf_cpcbn_sc_response_evaluation', 'date',  NULL , '0', '', '', '', 'evaluation of the ​response to reviewer​​s', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='studysummaries'), (SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='qc_tf_cpcbn_sc_response_evaluation' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='evaluation of the ​response to reviewer​​s' AND `language_tag`=''), '1', '100', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');

REPLACE INTO i18n (id,en)
VALUES
('evaluation of the response to reviewers','Evaluation of the Response to Reviewers');

UPDATE versions SET branch_build_number = '6355' WHERE version_number = '2.6.6';

-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Add reviewed grades to summary
-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

INSERT INTO structures(`alias`) VALUES ('qc_tf_cpcbn_summary_participant_reviewed_grades');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Datamart', 'Generated', '', 'qc_tf_participant_reviewed_grades', 'input',  NULL , '0', '', '', '', 'participant reviewed grades', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_tf_cpcbn_summary_participant_reviewed_grades'), (SELECT id FROM structure_fields WHERE `model`='Generated' AND `tablename`='' AND `field`='qc_tf_participant_reviewed_grades' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='participant reviewed grades' AND `language_tag`=''), '0', '1051', 'revisions', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');
UPDATE datamart_reports SET form_alias_for_results = CONCAT(form_alias_for_results,',qc_tf_cpcbn_summary_participant_reviewed_grades') WHERE name = 'CPCBN Summary - Level1';
INSERT IGNORE INTO i18n (id,en) VALUES ('revisions', 'Revisions'),('participant reviewed grades','Reviewed Grades');
UPDATE versions SET branch_build_number = '6360' WHERE version_number = '2.6.6';
