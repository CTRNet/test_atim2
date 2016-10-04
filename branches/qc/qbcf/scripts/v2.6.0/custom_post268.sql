-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Study
-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='studysummaries') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='disease_site' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ctrnet_submission_disease_site') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='studysummaries') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='summary' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='1', `flag_edit`='1', `flag_index`='1', `flag_detail`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='studysummaries') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='path_to_file' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='1', `display_order`='20' WHERE structure_id=(SELECT id FROM structures WHERE alias='studysummaries') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='summary' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='2', `display_order`='300', `language_heading`='documents' WHERE structure_id=(SELECT id FROM structures WHERE alias='studysummaries') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='path_to_file' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_fields SET  `setting`='size=60' WHERE model='StudySummary' AND tablename='study_summaries' AND field='path_to_file' AND `type`='input' AND structure_value_domain  IS NULL ;

REPLACE INTO i18n (id,en,fr) VALUES ('study_title','Study/Biomarker Name','');

ALTER TABLE study_summaries
  ADD COLUMN qbcf_status VARCHAR(50) DEFAULT NULL,
  
  ADD COLUMN qbcf_sc_initial_review DATE DEFAULT NULL,
  ADD COLUMN qbcf_sc_initial_review_accuracy CHAR(1) NOT NULL DEFAULT '',
  ADD COLUMN qbcf_opt_tma_image_review DATE DEFAULT NULL,
  ADD COLUMN qbcf_opt_tma_image_review_accuracy CHAR(1) NOT NULL DEFAULT '',
  ADD COLUMN qbcf_sc_review_of_test_array_series_data DATE DEFAULT NULL,
  ADD COLUMN qbcf_sc_review_of_test_array_series_data_accuracy CHAR(1) NOT NULL DEFAULT '',
  ADD COLUMN qbcf_sc_review_of_inflammation_tma_series_data DATE DEFAULT NULL,
  ADD COLUMN qbcf_sc_review_of_inflammation_tma_series_data_accuracy CHAR(1) NOT NULL DEFAULT '',

  ADD COLUMN qbcf_pi VARCHAR(100) DEFAULT NULL,
  ADD COLUMN qbcf_pi_email VARCHAR(100) DEFAULT NULL,
  ADD COLUMN qbcf_contact_person VARCHAR(100) DEFAULT NULL,
  ADD COLUMN qbcf_contact_person_email VARCHAR(100) DEFAULT NULL,
  ADD COLUMN qbcf_location_shipping_address TEXT,

  ADD COLUMN qbcf_proposal_and_review_response CHAR(1) NOT NULL DEFAULT '',
  ADD COLUMN qbcf_erb_documents CHAR(1) NOT NULL DEFAULT '',
  ADD COLUMN qbcf_mta_documents CHAR(1) NOT NULL DEFAULT '',
  ADD COLUMN qbcf_publications CHAR(1) NOT NULL DEFAULT '';  
  
ALTER TABLE study_summaries_revs
  ADD COLUMN qbcf_status VARCHAR(50) DEFAULT NULL,
  
  ADD COLUMN qbcf_sc_initial_review DATE DEFAULT NULL,
  ADD COLUMN qbcf_sc_initial_review_accuracy CHAR(1) NOT NULL DEFAULT '',
  ADD COLUMN qbcf_opt_tma_image_review DATE DEFAULT NULL,
  ADD COLUMN qbcf_opt_tma_image_review_accuracy CHAR(1) NOT NULL DEFAULT '',
  ADD COLUMN qbcf_sc_review_of_test_array_series_data DATE DEFAULT NULL,
  ADD COLUMN qbcf_sc_review_of_test_array_series_data_accuracy CHAR(1) NOT NULL DEFAULT '',
  ADD COLUMN qbcf_sc_review_of_inflammation_tma_series_data DATE DEFAULT NULL,
  ADD COLUMN qbcf_sc_review_of_inflammation_tma_series_data_accuracy CHAR(1) NOT NULL DEFAULT '',

  ADD COLUMN qbcf_pi VARCHAR(100) DEFAULT NULL,
  ADD COLUMN qbcf_pi_email VARCHAR(100) DEFAULT NULL,
  ADD COLUMN qbcf_contact_person VARCHAR(100) DEFAULT NULL,
  ADD COLUMN qbcf_contact_person_email VARCHAR(100) DEFAULT NULL,
  ADD COLUMN qbcf_location_shipping_address TEXT,

  ADD COLUMN qbcf_proposal_and_review_response CHAR(1) NOT NULL DEFAULT '',
  ADD COLUMN qbcf_erb_documents CHAR(1) NOT NULL DEFAULT '',
  ADD COLUMN qbcf_mta_documents CHAR(1) NOT NULL DEFAULT '',
  ADD COLUMN qbcf_publications CHAR(1) NOT NULL DEFAULT '';  
  
INSERT INTO structure_value_domains (domain_name, source) 
VALUES 
('qbcf_study_status', "StructurePermissibleValuesCustom::getCustomDropdown('Study Status')");
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) 
VALUES 
('Study Status', 1, 50, 'study');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Study Status');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
('go to Opt-TMA', '',  '', '1', @control_id, NOW(), NOW(), 1, 1), 
('pending to Opt-TMA', '',  '', '1', @control_id, NOW(), NOW(), 1, 1), 
('no go to Opt-TMA', '',  '', '1', @control_id, NOW(), NOW(), 1, 1), 
('go to Test-TMA', '',  '', '1', @control_id, NOW(), NOW(), 1, 1), 
('pending to Test-TMA', '',  '', '1', @control_id, NOW(), NOW(), 1, 1), 
('no go to test-TMA', '',  '', '1', @control_id, NOW(), NOW(), 1, 1), 
('go to validation-TMA', '',  '', '1', @control_id, NOW(), NOW(), 1, 1), 
('pending to validation-TMA', '',  '', '1', @control_id, NOW(), NOW(), 1, 1), 
('no go to validation-TMA', '',  '', '1', @control_id, NOW(), NOW(), 1, 1);

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Study', 'StudySummary', 'study_summaries', 'qbcf_status', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qbcf_study_status') , '0', '', '', '', 'status', ''), 
('Study', 'StudySummary', 'study_summaries', 'qbcf_sc_initial_review', 'date',  NULL , '0', '', '', '', 'sc initial review', ''), 
('Study', 'StudySummary', 'study_summaries', 'qbcf_opt_tma_image_review', 'date',  NULL , '0', '', '', '', 'opt tma image review', ''), 
('Study', 'StudySummary', 'study_summaries', 'qbcf_sc_review_of_test_array_series_data', 'date',  NULL , '0', '', '', '', 'sc review of test array series data', ''), 
('Study', 'StudySummary', 'study_summaries', 'qbcf_pi', 'input',  NULL , '0', '', '', '', 'pi', ''), 
('Study', 'StudySummary', 'study_summaries', 'qbcf_pi_email', 'input',  NULL , '0', '', '', '', '', 'email'), 
('Study', 'StudySummary', 'study_summaries', 'qbcf_contact_person', 'input',  NULL , '0', '', '', '', 'contact person', ''), 
('Study', 'StudySummary', 'study_summaries', 'qbcf_contact_person_email', 'input',  NULL , '0', '', '', '', '', 'email'), 
('Study', 'StudySummary', 'study_summaries', 'qbcf_location_shipping_address', 'textarea',  NULL , '0', '', '', '', 'location shipping address', ''), 
('Study', 'StudySummary', 'study_summaries', 'qbcf_proposal_and_review_response', 'yes_no',  NULL , '0', '', '', '', 'proposal and review response', ''), 
('Study', 'StudySummary', 'study_summaries', 'qbcf_erb_documents', 'yes_no',  NULL , '0', '', '', '', 'erb documents', ''), 
('Study', 'StudySummary', 'study_summaries', 'qbcf_mta_documents', 'yes_no',  NULL , '0', '', '', '', 'mta documents', ''), 
('Study', 'StudySummary', 'study_summaries', 'qbcf_publications', 'yes_no',  NULL , '0', '', '', '', 'publications', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='studysummaries'), (SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='qbcf_status' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qbcf_study_status')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='status' AND `language_tag`=''), '1', '2', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='studysummaries'), (SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='qbcf_sc_initial_review' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='sc initial review' AND `language_tag`=''), '1', '100', 'approval/review', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='studysummaries'), (SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='qbcf_opt_tma_image_review' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='opt tma image review' AND `language_tag`=''), '1', '101', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='studysummaries'), (SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='qbcf_sc_review_of_test_array_series_data' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='sc review of test array series data' AND `language_tag`=''), '1', '102', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='studysummaries'), (SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='qbcf_pi' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='pi' AND `language_tag`=''), '2', '200', 'contacts', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='studysummaries'), (SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='qbcf_pi_email' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='email'), '2', '201', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='studysummaries'), (SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='qbcf_contact_person' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='contact person' AND `language_tag`=''), '2', '202', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='studysummaries'), (SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='qbcf_contact_person_email' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='email'), '2', '203', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='studysummaries'), (SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='qbcf_location_shipping_address' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='location shipping address' AND `language_tag`=''), '2', '204', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='studysummaries'), (SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='qbcf_proposal_and_review_response' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='proposal and review response' AND `language_tag`=''), '2', '300', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='studysummaries'), (SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='qbcf_erb_documents' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='erb documents' AND `language_tag`=''), '2', '301', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='studysummaries'), (SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='qbcf_mta_documents' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='mta documents' AND `language_tag`=''), '2', '302', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='studysummaries'), (SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='qbcf_publications' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='publications' AND `language_tag`=''), '2', '303', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');

INSERT IGNORE INTO i18n (id,en)
VALUES
('approval/review','Approval/Review'),
('sc initial review','Study Committee Initial review'), 	
('opt tma image review','Date of Opt-TMA Image Review'), 	
('sc review of test array series data','Date of Study Committee Review of Test-Array Series Data'),
('pi','PI'),
('contact person','Contact Person'),
('location shipping address','Location/Shipping Address'),		    
('documents','Documents'),
('proposal and review response','Proposal and Review Response'),
('erb documents','ERB Documents'),
('mta documents','MTA Documents'),
('publications','Publications');

ALTER TABLE study_summaries
  ADD COLUMN qbcf_publication_details TEXT;
ALTER TABLE study_summaries_revs
  ADD COLUMN qbcf_publication_details TEXT;
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Study', 'StudySummary', 'study_summaries', 'qbcf_publication_details', 'textarea',  NULL , '0', '', '', '', 'publications details', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='studysummaries'), (SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='qbcf_publication_details' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='publications details' AND `language_tag`=''), '2', '304', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT IGNORE INTO i18n (id,en)
VALUES
('publications details','Publications Details');

ALTER TABLE study_summaries
  ADD COLUMN qbcf_sc_response_evaluation DATE DEFAULT NULL,
  ADD COLUMN qbcf_sc_response_evaluation_accuracy CHAR(1) NOT NULL DEFAULT '';
ALTER TABLE study_summaries_revs
  ADD COLUMN qbcf_sc_response_evaluation DATE DEFAULT NULL,
  ADD COLUMN qbcf_sc_response_evaluation_accuracy CHAR(1) NOT NULL DEFAULT '';
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Study', 'StudySummary', 'study_summaries', 'qbcf_sc_response_evaluation', 'date',  NULL , '0', '', '', '', 'evaluation of the response to reviewer​​s', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='studysummaries'), (SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='qbcf_sc_response_evaluation' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`=''  AND `language_tag`=''), '1', '100', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');

REPLACE INTO i18n (id,en)
VALUES
('evaluation of the response to reviewer​​s','Evaluation of the response to reviewer​​');

ALTER TABLE study_summaries
  ADD COLUMN qbcf_sc_review_of_inflammation_array_series_data DATE DEFAULT NULL,
  ADD COLUMN qbcf_sc_review_of_inflammation_array_series_data_accuracy CHAR(1) NOT NULL DEFAULT '';
ALTER TABLE study_summaries_revs
  ADD COLUMN qbcf_sc_review_of_inflammation_array_series_data DATE DEFAULT NULL,
  ADD COLUMN qbcf_sc_review_of_inflammation_array_series_data_accuracy CHAR(1) NOT NULL DEFAULT '';
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Study', 'StudySummary', 'study_summaries', 'qbcf_sc_review_of_inflammation_array_series_data', 'date',  NULL , '0', '', '', '', 'sc review of inflammation array series data', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='studysummaries'), (SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='qbcf_sc_review_of_inflammation_array_series_data' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='sc review of inflammation array series data' AND `language_tag`=''), '1', '103', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT IGNORE INTO i18n (id,en)
VALUES
('sc review of inflammation array series data','Date of Study Committee Review of Inflammation-Array Series Data');

UPDATE structure_formats SET `flag_add`='1', `flag_edit`='1', `flag_search`='1', `flag_index`='1', `flag_detail`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='studysummaries') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='start_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='1', `flag_edit`='1', `flag_search`='1', `flag_index`='1', `flag_detail`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='studysummaries') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='end_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- TMA Block and Slide
-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Block

INSERT IGNORE INTO i18n (id,en) 
VALUES
('your search will be limited to your bank','Your search will be limited to your bank'),
('a bank has to be selected','A bank has to be selected'),
('tma block data','TMA Block Data'),
('storage data','Storage Data');

-- Slide

ALTER TABLE tma_slides
  ADD COLUMN `qbcf_slide_type` varchar(50) DEFAULT NULL,
  ADD COLUMN `qbcf_section_id` int(6) DEFAULT NULL,
  ADD COLUMN `qbcf_sectionning_date` date DEFAULT NULL,
  ADD COLUMN `qbcf_sectionning_date_accuracy` char(1) NOT NULL DEFAULT '',
  ADD COLUMN `qbcf_thickness` int(6) DEFAULT NULL,
  ADD COLUMN `qbcf_quality_assessment` varchar(50) DEFAULT NULL,
  ADD COLUMN `qbcf_paraffin_protection` char(1) NOT NULL DEFAULT '',
  ADD COLUMN `qbcf_shipping_date` date DEFAULT NULL,
  ADD COLUMN `qbcf_shipping_date_accuracy` char(1) NOT NULL DEFAULT '',
  ADD COLUMN `qbcf_image_id` varchar(100) DEFAULT NULL,
  ADD COLUMN `qbcf_image_location` varchar(50) DEFAULT NULL,
  ADD COLUMN `qbcf_scoring_results_reception_date` date DEFAULT NULL,
  ADD COLUMN `qbcf_scoring_results_reception_date_accuracy` char(1) NOT NULL DEFAULT '',
  ADD COLUMN `qbcf_clinical_data_version` date DEFAULT NULL,
  ADD COLUMN `qbcf_scoring_results_file_id` varchar(100) DEFAULT NULL,
  ADD COLUMN `qbcf_notes` text;
ALTER TABLE tma_slides_revs
  ADD COLUMN `qbcf_slide_type` varchar(50) DEFAULT NULL,
  ADD COLUMN `qbcf_section_id` int(6) DEFAULT NULL,
  ADD COLUMN `qbcf_sectionning_date` date DEFAULT NULL,
  ADD COLUMN `qbcf_sectionning_date_accuracy` char(1) NOT NULL DEFAULT '',
  ADD COLUMN `qbcf_thickness` int(6) DEFAULT NULL,
  ADD COLUMN `qbcf_quality_assessment` varchar(50) DEFAULT NULL,
  ADD COLUMN `qbcf_paraffin_protection` char(1) NOT NULL DEFAULT '',
  ADD COLUMN `qbcf_shipping_date` date DEFAULT NULL,
  ADD COLUMN `qbcf_shipping_date_accuracy` char(1) NOT NULL DEFAULT '',
  ADD COLUMN `qbcf_image_id` varchar(100) DEFAULT NULL,
  ADD COLUMN `qbcf_image_location` varchar(50) DEFAULT NULL,
  ADD COLUMN `qbcf_scoring_results_reception_date` date DEFAULT NULL,
  ADD COLUMN `qbcf_scoring_results_reception_date_accuracy` char(1) NOT NULL DEFAULT '',
  ADD COLUMN `qbcf_clinical_data_version` date DEFAULT NULL,
  ADD COLUMN `qbcf_scoring_results_file_id` varchar(100) DEFAULT NULL,
  ADD COLUMN `qbcf_notes` text;

INSERT INTO structure_value_domains (domain_name, source) 
VALUES 
('qbcf_tma_slide_quality_assessment', "StructurePermissibleValuesCustom::getCustomDropdown('TMA Slide : Quality Assessment')"),
('qbcf_tma_slide_image_location', "StructurePermissibleValuesCustom::getCustomDropdown('TMA Slide : Image Location')"),
('qbcf_tma_slide_type', "StructurePermissibleValuesCustom::getCustomDropdown('TMA Slide : Type')");
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
('StorageLayout', 'TmaSlide', 'tma_slides', 'qbcf_section_id', 'input',  NULL , '0', 'size=3', '', '', 'section id', ''), 
('StorageLayout', 'TmaSlide', 'tma_slides', 'qbcf_sectionning_date', 'date',  NULL , '0', '', '', '', 'sectionning date', ''), 
('StorageLayout', 'TmaSlide', 'tma_slides', 'qbcf_thickness', 'integer_positive',  NULL , '0', '', '', '', 'thickness (um)', ''), 
('StorageLayout', 'TmaSlide', 'tma_slides', 'qbcf_quality_assessment', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qbcf_tma_slide_quality_assessment') , '0', '', '', '', 'quality assessment', ''), 
('StorageLayout', 'TmaSlide', 'tma_slides', 'qbcf_paraffin_protection', 'yes_no',  NULL , '0', '', '', '', 'paraffin protection', ''), 
('StorageLayout', 'TmaSlide', 'tma_slides', 'qbcf_shipping_date', 'date',  NULL , '0', '', '', '', 'shipping date', ''), 
('StorageLayout', 'TmaSlide', 'tma_slides', 'qbcf_image_id', 'input',  NULL , '0', '', '', '', 'image id', ''), 
('StorageLayout', 'TmaSlide', 'tma_slides', 'qbcf_image_location', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qbcf_tma_slide_image_location') , '0', '', '', '', 'image location', ''), 
('StorageLayout', 'TmaSlide', 'tma_slides', 'qbcf_scoring_results_reception_date', 'date',  NULL , '0', '', '', '', 'date reception scoring results', ''), 
('StorageLayout', 'TmaSlide', 'tma_slides', 'qbcf_clinical_data_version', 'date',  NULL , '0', '', '', '', 'clinical data version', ''), 
('StorageLayout', 'TmaSlide', 'tma_slides', 'qbcf_scoring_results_file_id', 'input',  NULL , '0', '', '', '', 'scoring results file id', ''), 
('StorageLayout', 'TmaSlide', 'tma_slides', 'qbcf_notes', 'textarea',  NULL , '0', '', '', '', 'notes', ''), 
('StorageLayout', 'TmaSlide', 'tma_slides', 'qbcf_slide_type', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qbcf_tma_slide_type') , '0', '', '', '', 'type', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='tma_slides'), (SELECT id FROM structure_fields WHERE `model`='TmaSlide' AND `tablename`='tma_slides' AND `field`='qbcf_section_id'), '0', '1', 'slide', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='tma_slides'), (SELECT id FROM structure_fields WHERE `model`='TmaSlide' AND `tablename`='tma_slides' AND `field`='qbcf_sectionning_date'), '0', '10', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='tma_slides'), (SELECT id FROM structure_fields WHERE `model`='TmaSlide' AND `tablename`='tma_slides' AND `field`='qbcf_thickness'), '0', '11', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='tma_slides'), (SELECT id FROM structure_fields WHERE `model`='TmaSlide' AND `tablename`='tma_slides' AND `field`='qbcf_quality_assessment'), '0', '12', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='tma_slides'), (SELECT id FROM structure_fields WHERE `model`='TmaSlide' AND `tablename`='tma_slides' AND `field`='qbcf_paraffin_protection'), '0', '13', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='tma_slides'), (SELECT id FROM structure_fields WHERE `model`='TmaSlide' AND `tablename`='tma_slides' AND `field`='qbcf_shipping_date'), '1', '50', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='tma_slides'), (SELECT id FROM structure_fields WHERE `model`='TmaSlide' AND `tablename`='tma_slides' AND `field`='qbcf_image_id'), '1', '52', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='tma_slides'), (SELECT id FROM structure_fields WHERE `model`='TmaSlide' AND `tablename`='tma_slides' AND `field`='qbcf_image_location'), '1', '53', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='tma_slides'), (SELECT id FROM structure_fields WHERE `model`='TmaSlide' AND `tablename`='tma_slides' AND `field`='qbcf_scoring_results_reception_date'), '1', '54', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='tma_slides'), (SELECT id FROM structure_fields WHERE `model`='TmaSlide' AND `tablename`='tma_slides' AND `field`='qbcf_clinical_data_version' AND `type`='date'), '1', '50', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='tma_slides'), (SELECT id FROM structure_fields WHERE `model`='TmaSlide' AND `tablename`='tma_slides' AND `field`='qbcf_scoring_results_file_id' AND `type`='input'), '1', '56', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='tma_slides'), (SELECT id FROM structure_fields WHERE `model`='TmaSlide' AND `tablename`='tma_slides' AND `field`='qbcf_notes' AND `type`='textarea'), '1', '70', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='tma_slides'), (SELECT id FROM structure_fields WHERE `model`='TmaSlide' AND `tablename`='tma_slides' AND `field`='qbcf_slide_type' AND `type`='select'), '0', '2', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO structure_validations(structure_field_id, rule) VALUES
((SELECT id FROM structure_fields WHERE `model`='TmaSlide' AND `tablename`='tma_slides' AND `field`='qbcf_section_id'), 'notEmpty'),
((SELECT id FROM structure_fields WHERE `model`='TmaSlide' AND `tablename`='tma_slides' AND `field`='qbcf_slide_type'), 'notEmpty');

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

-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Update based on excel file
-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

INSERT IGNORE INTO structure_permissible_values (value, language_alias) 
VALUES
("deceased from other cause", "deceased from other cause"), 
("deceased from unknown cause (lost to f/u)", "deceased from unknown cause (lost to f/u)");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) 
VALUES 
((SELECT id FROM structure_value_domains WHERE domain_name="health_status"), (SELECT id FROM structure_permissible_values WHERE value="deceased from other cause" AND language_alias="deceased from other cause"), "4", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="health_status"), (SELECT id FROM structure_permissible_values WHERE value="deceased from unknown cause (lost to f/u)" AND language_alias="deceased from unknown cause (lost to f/u)"), "5", "1");
INSERT INTO i18n (id,en) VALUEs ("deceased from other cause", "Deceased from other cause"), ("deceased from unknown cause (lost to f/u)", "Deceased from unknown cause (lost to f/u)");

INSERT INTO structure_value_domains (domain_name, source) 
VALUES 
('qbcf_diagnosis_progression_labels', "StructurePermissibleValuesCustom::getCustomDropdown('DX : Progressions Labels')");
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) 
VALUES 
('DX : Progressions Labels', 1, 250, 'clinical - diagnosis');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'DX : Progressions Labels');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
('suspicious by Imaging', 'Suspicious by Imaging', '1', @control_id, NOW(), NOW(), 1, 1),
('confirmed by pathology', 'Confirmed by pathology', '1', @control_id, NOW(), NOW(), 1, 1),
('confirmed by other means', 'Confirmed by other means', '1', @control_id, NOW(), NOW(), 1, 1),
('uncertain if mets are from concomitant cancer', 'Uncertain if mets are from concomitant cancer', '1', @control_id, NOW(), NOW(), 1, 1);
ALTER TABLE qbcf_dx_breast_progressions ADD COLUMN label varchar(250) DEFAULT NULL;
ALTER TABLE qbcf_dx_breast_progressions_revs ADD COLUMN label varchar(250) DEFAULT NULL;
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'DiagnosisDetail', 'qbcf_dx_breast_progressions', 'label', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qbcf_diagnosis_progression_labels') , '0', '', '', '', 'label', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qbcf_dx_breast_progressions'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qbcf_dx_breast_progressions' AND `field`='label' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qbcf_diagnosis_progression_labels')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='label' AND `language_tag`=''), '1', '12', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0');

-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Move drug id from TreatmentExtendDetail to TreatmentExtendMaster
-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

ALTER TABLE qbcf_txe_chemos DROP FOREIGN KEY `FK_qbcf_txe_chemos_drugs`;
ALTER TABLE qbcf_txe_hormonos DROP FOREIGN KEY `FK_qbcf_txe_hormonos_drugs`;
ALTER TABLE qbcf_txe_immunos DROP FOREIGN KEY `FK_qbcf_txe_immunos_drugs`;
ALTER TABLE qbcf_txe_bone_specifics DROP FOREIGN KEY `FK_qbcf_txe_bone_specifics_drugs`;

ALTER TABLE qbcf_txe_chemos DROP COLUMN drug_id;
ALTER TABLE qbcf_txe_hormonos DROP COLUMN drug_id;
ALTER TABLE qbcf_txe_immunos DROP COLUMN drug_id;
ALTER TABLE qbcf_txe_bone_specifics DROP COLUMN drug_id;

ALTER TABLE qbcf_txe_chemos_revs  DROP COLUMN drug_id;
ALTER TABLE qbcf_txe_hormonos_revs  DROP COLUMN drug_id;
ALTER TABLE qbcf_txe_immunos_revs  DROP COLUMN drug_id;
ALTER TABLE qbcf_txe_bone_specifics_revs  DROP COLUMN drug_id;

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qbcf_txe_chemos'), (SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='autocomplete_treatment_drug_id' AND `type`='autocomplete' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='url=/Drug/Drugs/autocompleteDrug' AND `default`='' AND `language_help`='' AND `language_label`='drug' AND `language_tag`=''), '1', '1', 'drugs', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='qbcf_txe_chemos'), (SELECT id FROM structure_fields WHERE `model`='Drug' AND `tablename`='drugs' AND `field`='generic_name' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '1', 'drugs', '0', '1', 'drug', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='qbcf_txe_chemos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='TreatmentExtendDetail' AND `tablename`='qbcf_txe_chemos' AND `field`='drug_id' AND `language_label`='drug' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='qbcf_chemo_drug_list') AND `language_help`='help_drug_id' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_validations WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='TreatmentExtendDetail' AND `tablename`='qbcf_txe_chemos' AND `field`='drug_id' AND `language_label`='drug' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='qbcf_chemo_drug_list') AND `language_help`='help_drug_id' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0'));
DELETE FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='TreatmentExtendDetail' AND `tablename`='qbcf_txe_chemos' AND `field`='drug_id' AND `language_label`='drug' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='qbcf_chemo_drug_list') AND `language_help`='help_drug_id' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qbcf_txe_hormonos'), (SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='autocomplete_treatment_drug_id' AND `type`='autocomplete' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='url=/Drug/Drugs/autocompleteDrug' AND `default`='' AND `language_help`='' AND `language_label`='drug' AND `language_tag`=''), '1', '1', 'drugs', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='qbcf_txe_hormonos'), (SELECT id FROM structure_fields WHERE `model`='Drug' AND `tablename`='drugs' AND `field`='generic_name' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '1', 'drugs', '0', '1', 'drug', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='qbcf_txe_hormonos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='TreatmentExtendDetail' AND `tablename`='qbcf_txe_hormonos' AND `field`='drug_id' AND `language_label`='drug' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='qbcf_chemo_drug_list') AND `language_help`='help_drug_id' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_validations WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='TreatmentExtendDetail' AND `tablename`='qbcf_txe_hormonos' AND `field`='drug_id' AND `language_label`='drug' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='qbcf_chemo_drug_list') AND `language_help`='help_drug_id' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0'));
DELETE FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='TreatmentExtendDetail' AND `tablename`='qbcf_txe_hormonos' AND `field`='drug_id' AND `language_label`='drug' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='qbcf_chemo_drug_list') AND `language_help`='help_drug_id' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qbcf_txe_immunos'), (SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='autocomplete_treatment_drug_id' AND `type`='autocomplete' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='url=/Drug/Drugs/autocompleteDrug' AND `default`='' AND `language_help`='' AND `language_label`='drug' AND `language_tag`=''), '1', '1', 'drugs', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='qbcf_txe_immunos'), (SELECT id FROM structure_fields WHERE `model`='Drug' AND `tablename`='drugs' AND `field`='generic_name' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '1', 'drugs', '0', '1', 'drug', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='qbcf_txe_immunos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='TreatmentExtendDetail' AND `tablename`='qbcf_txe_immunos' AND `field`='drug_id' AND `language_label`='drug' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='qbcf_chemo_drug_list') AND `language_help`='help_drug_id' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_validations WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='TreatmentExtendDetail' AND `tablename`='qbcf_txe_immunos' AND `field`='drug_id' AND `language_label`='drug' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='qbcf_chemo_drug_list') AND `language_help`='help_drug_id' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0'));
DELETE FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='TreatmentExtendDetail' AND `tablename`='qbcf_txe_immunos' AND `field`='drug_id' AND `language_label`='drug' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='qbcf_chemo_drug_list') AND `language_help`='help_drug_id' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qbcf_txe_bone_specifics'), (SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='autocomplete_treatment_drug_id' AND `type`='autocomplete' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='url=/Drug/Drugs/autocompleteDrug' AND `default`='' AND `language_help`='' AND `language_label`='drug' AND `language_tag`=''), '1', '1', 'drugs', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='qbcf_txe_bone_specifics'), (SELECT id FROM structure_fields WHERE `model`='Drug' AND `tablename`='drugs' AND `field`='generic_name' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '1', 'drugs', '0', '1', 'drug', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='qbcf_txe_bone_specifics') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='TreatmentExtendDetail' AND `tablename`='qbcf_txe_bone_specifics' AND `field`='drug_id' AND `language_label`='drug' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='qbcf_chemo_drug_list') AND `language_help`='help_drug_id' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_validations WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='TreatmentExtendDetail' AND `tablename`='qbcf_txe_bone_specifics' AND `field`='drug_id' AND `language_label`='drug' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='qbcf_chemo_drug_list') AND `language_help`='help_drug_id' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0'));
DELETE FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='TreatmentExtendDetail' AND `tablename`='qbcf_txe_bone_specifics' AND `field`='drug_id' AND `language_label`='drug' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='qbcf_chemo_drug_list') AND `language_help`='help_drug_id' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');

ALTER TABLE qbcf_dx_other_cancers ADD COLUMN metastasis_development char(1) NOT NULL DEFAULT'';
ALTER TABLE qbcf_dx_other_cancers_revs ADD COLUMN metastasis_development char(1) NOT NULL DEFAULT'';
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'DiagnosisDetail', 'qbcf_dx_other_cancers', 'metastasis_development', 'yes_no',  NULL , '0', '', '', '', 'metastasis development', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qbcf_dx_other_cancers'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qbcf_dx_other_cancers' AND `field`='metastasis_development' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='metastasis development' AND `language_tag`=''), '1', '11', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO i18n (id,en) VALUES ('metastasis development', 'Metastasis Development');

INSERT INTO `diagnosis_controls` (`id`, `category`, `controls_type`, `flag_active`, `detail_form_alias`, `detail_tablename`, `display_order`, `databrowser_label`, `flag_compare_with_cap`) VALUES
(null, 'primary', 'other cancer progression', 1, 'qbcf_dx_other_cancer_progressions', 'qbcf_dx_other_cancer_progressions', 0, 'other cancer progression', 0);				
CREATE TABLE IF NOT EXISTS `qbcf_dx_other_cancer_progressions` (
  `primary_disease_site` varchar(250) DEFAULT NULL,
  `secondary_disease_site` varchar(250) DEFAULT NULL,
  `diagnosis_master_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE IF NOT EXISTS `qbcf_dx_other_cancer_progressions_revs` (
  `primary_disease_site` varchar(250) DEFAULT NULL,
  `secondary_disease_site` varchar(250) DEFAULT NULL,
  `diagnosis_master_id` int(11) NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;
ALTER TABLE `qbcf_dx_other_cancer_progressions`
  ADD CONSTRAINT `qbcf_dx_other_cancer_progressions_ibfk_1` FOREIGN KEY (`diagnosis_master_id`) REFERENCES `diagnosis_masters` (`id`);
INSERT INTO structure_value_domains (domain_name, source) 
VALUES 
('qbcf_other_cancer_progression_sites', "StructurePermissibleValuesCustom::getCustomDropdown('Other Cancer Progression Sites')");
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) 
VALUES 
('Other Cancer Progression Sites', 1, 250, 'Other Cancer Progression Sites');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Other Cancer Progression Sites');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
('ln', 'LN',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('soft tissue', 'Soft Tissue',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('bone', 'Bone',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('multiple sites', 'Multiple sites',  '', '1', @control_id, NOW(), NOW(), 1, 1);
INSERT INTO structures(`alias`) VALUES ('qbcf_dx_other_cancer_progressions');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'DiagnosisDetail', 'qbcf_dx_other_cancer_progressions', 'primary_disease_site', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ctrnet_submission_disease_site') , '0', '', '', '', 'primary site', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'qbcf_dx_other_cancer_progressions', 'secondary_disease_site', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qbcf_other_cancer_progression_sites') , '0', '', '', '', 'secondary site', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qbcf_dx_other_cancer_progressions'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qbcf_dx_other_cancer_progressions' AND `field`='primary_disease_site' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ctrnet_submission_disease_site')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='primary site' AND `language_tag`=''), '1', '10', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qbcf_dx_other_cancer_progressions'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qbcf_dx_other_cancer_progressions' AND `field`='secondary_disease_site' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qbcf_other_cancer_progression_sites')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='secondary site' AND `language_tag`=''), '1', '11', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO structure_validations(structure_field_id, rule, language_message) 
VALUES
((SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qbcf_dx_other_cancer_progressions' AND `field`='primary_disease_site'), 'notEmpty', ''),
((SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qbcf_dx_other_cancer_progressions' AND `field`='secondary_disease_site'), 'notEmpty', '');
INSERT INTO i18n (id,en)
VALUES 
('other cancer progression', 'Other Cancer Progression'),
('primary site', 'Primary Site'),
('secondary site', 'Secondary Site');

SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Tx : Other Cancer Treatment');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
('not treated', 'Not Treated',  '', '1', @control_id, NOW(), NOW(), 1, 1);

INSERT INTO i18n (id,en)
VALUES 
('label', 'Label');

UPDATE parent_to_derivative_sample_controls SET flag_active=false WHERE id IN(220);

UPDATE structure_formats SET `flag_add`='1', `flag_edit`='1', `flag_search`='1', `flag_index`='1', `flag_detail`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='specimens') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SpecimenDetail' AND `tablename`='specimen_details' AND `field`='reception_datetime' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- qbcf_generated_label_for_display

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'AliquotMaster', '', 'qbcf_generated_label_for_display', 'input',  NULL , '0', '', '', '', 'aliquot', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='aliquot_masters_for_storage_list_view'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='' AND `field`='qbcf_generated_label_for_display' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='aliquot' AND `language_tag`=''), '0', '3', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0');
UPDATE structure_formats SET `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters_for_storage_list_view') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='aliquot_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'AliquotMaster', '', 'qbcf_generated_label_for_display', 'input',  NULL , '0', '', '', '', 'aliquot label', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='aliquot_masters_for_storage_tree_view'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='' AND `field`='qbcf_generated_label_for_display' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='aliquot label' AND `language_tag`=''), '0', '5', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');
UPDATE structure_formats SET `flag_override_tag`='0', `language_tag`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters_for_storage_tree_view') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotControl' AND `tablename`='aliquot_controls' AND `field`='aliquot_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_type') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters_for_storage_tree_view') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='aliquot_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'AliquotMaster', '', 'qc_tf_generated_label_for_display', 'input',  NULL , '0', '', '', '', 'aliquot label', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='used_aliq_in_stock_details'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='' AND `field`='qc_tf_generated_label_for_display' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='aliquot label' AND `language_tag`=''), '0', '1', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '1', '0', '0', '0', '0', '1', '1', '0', '0', '1', '0', '0', '0');
UPDATE structure_formats SET `flag_edit`='0', `flag_edit_readonly`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='used_aliq_in_stock_details') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='aliquot_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

INSERT INTO i18n (id,en)
VALUES 
('you can not record section id [%s] twice', 'You can not record section id [%s] twice!'),
('the section id [%s] has already been recorded', 'The section id [%s] has already been recorded!');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'ViewCollection', '', 'qbcf_bank_participant_identifier', 'input',  NULL , '0', 'size=30', '', '', 'bank patient #', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='view_collection'), (SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='qbcf_bank_participant_identifier' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='' AND `language_label`='bank patient #' AND `language_tag`=''), '0', '3', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0');

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='specimens') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SpecimenDetail' AND `tablename`='specimen_details' AND `field`='reception_datetime' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

REPLACE INTO i18n (id,en)
VALUES
('collection datetime', 'Shipping/Reception Date');

UPDATE structure_formats SET `language_heading`='', `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='bank_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='banks') AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='collection' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='collection_datetime' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='clinicalcollectionlinks'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qbcf_dx_breasts' AND `field`='type_of_intervention' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qbcf_type_of_intervention')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='type of intervention' AND `language_tag`=''), '1', '131', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='collections_for_collection_tree_view'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qbcf_dx_breasts' AND `field`='type_of_intervention' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qbcf_type_of_intervention')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='type of intervention' AND `language_tag`=''), '1', '131', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');

DELETE FROM structure_formats WHERE structure_id = (SELECT id FROM structures WHERE alias='view_diagnosis') AND structure_field_id IN (SELECT id FROM structure_fields WHERE tablename LIKE 'qbcf_%');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'Generated', '', 'qbcf_dx_detail_for_tree_view', 'input',  NULL , '0', 'size=30', '', '', 'detail', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='view_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='Generated' AND `tablename`='' AND `field`='qbcf_dx_detail_for_tree_view' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='' AND `language_label`='detail' AND `language_tag`=''), '1', '21', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');

UPDATE structure_formats SET `display_order`='300', `flag_override_tag`='1', `language_tag`='#' WHERE structure_id=(SELECT id FROM structures WHERE alias='sample_masters_for_collection_tree_view') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='sample_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats SET `display_order`='5', `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters_for_collection_tree_view') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='in_stock' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_in_stock_values') AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_editgrid_readonly`='0', `flag_index`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='tma_slides') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TmaSlide' AND `tablename`='tma_slides' AND `field`='sop_master_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tma_slide_sop_list') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_editgrid_readonly`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='tma_slides') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='autocomplete_tma_slide_study_summary_id' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='0', `flag_index`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='tma_slides') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='title' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='tma_slides') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='StorageLayout' AND `model`='TmaSlide' AND `tablename`='tma_slides' AND `field`='qbcf_shipping_date' AND `language_label`='shipping date' AND `language_tag`='' AND `type`='date' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='tma_slides') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='StorageLayout' AND `model`='TmaSlide' AND `tablename`='tma_slides' AND `field`='qbcf_image_id' AND `language_label`='image id' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='tma_slides') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='StorageLayout' AND `model`='TmaSlide' AND `tablename`='tma_slides' AND `field`='qbcf_image_location' AND `language_label`='image location' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='qbcf_tma_slide_image_location') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='tma_slides') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='StorageLayout' AND `model`='TmaSlide' AND `tablename`='tma_slides' AND `field`='qbcf_clinical_data_version' AND `language_label`='clinical data version' AND `language_tag`='' AND `type`='date' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='tma_slides') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='StorageLayout' AND `model`='TmaSlide' AND `tablename`='tma_slides' AND `field`='qbcf_slide_type' AND `language_label`='type' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='qbcf_tma_slide_type') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_validations WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='StorageLayout' AND `model`='TmaSlide' AND `tablename`='tma_slides' AND `field`='qbcf_shipping_date' AND `language_label`='shipping date' AND `language_tag`='' AND `type`='date' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0') OR (
`public_identifier`='' AND `plugin`='StorageLayout' AND `model`='TmaSlide' AND `tablename`='tma_slides' AND `field`='qbcf_image_id' AND `language_label`='image id' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0') OR (
`public_identifier`='' AND `plugin`='StorageLayout' AND `model`='TmaSlide' AND `tablename`='tma_slides' AND `field`='qbcf_image_location' AND `language_label`='image location' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='qbcf_tma_slide_image_location') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0') OR (
`public_identifier`='' AND `plugin`='StorageLayout' AND `model`='TmaSlide' AND `tablename`='tma_slides' AND `field`='qbcf_clinical_data_version' AND `language_label`='clinical data version' AND `language_tag`='' AND `type`='date' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0') OR (
`public_identifier`='' AND `plugin`='StorageLayout' AND `model`='TmaSlide' AND `tablename`='tma_slides' AND `field`='qbcf_slide_type' AND `language_label`='type' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='qbcf_tma_slide_type') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0'));
DELETE FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='StorageLayout' AND `model`='TmaSlide' AND `tablename`='tma_slides' AND `field`='qbcf_shipping_date' AND `language_label`='shipping date' AND `language_tag`='' AND `type`='date' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0') OR (
`public_identifier`='' AND `plugin`='StorageLayout' AND `model`='TmaSlide' AND `tablename`='tma_slides' AND `field`='qbcf_image_id' AND `language_label`='image id' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0') OR (
`public_identifier`='' AND `plugin`='StorageLayout' AND `model`='TmaSlide' AND `tablename`='tma_slides' AND `field`='qbcf_image_location' AND `language_label`='image location' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='qbcf_tma_slide_image_location') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0') OR (
`public_identifier`='' AND `plugin`='StorageLayout' AND `model`='TmaSlide' AND `tablename`='tma_slides' AND `field`='qbcf_clinical_data_version' AND `language_label`='clinical data version' AND `language_tag`='' AND `type`='date' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0') OR (
`public_identifier`='' AND `plugin`='StorageLayout' AND `model`='TmaSlide' AND `tablename`='tma_slides' AND `field`='qbcf_slide_type' AND `language_label`='type' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='qbcf_tma_slide_type') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_value_domains WHERE domain_name IN ('qbcf_tma_slide_image_location', 'qbcf_tma_slide_type');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'TMA Slide : Type');
DELETE FROM `structure_permissible_values_customs` WHERE control_id = @control_id;
ALTER TABLE tma_slides 
  DROP COLUMN qbcf_image_id,
  DROP COLUMN qbcf_image_location,
  DROP COLUMN qbcf_clinical_data_version,
  DROP COLUMN qbcf_slide_type;
ALTER TABLE tma_slides_revs
  DROP COLUMN qbcf_image_id,
  DROP COLUMN qbcf_image_location,
  DROP COLUMN qbcf_clinical_data_version,
  DROP COLUMN qbcf_slide_type;
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='1', `flag_edit_readonly`='1', `flag_search`='1', `flag_addgrid`='0', `flag_editgrid`='1', `flag_editgrid_readonly`='1', `flag_index`='1', `flag_detail`='1', `flag_summary`='1' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='tma_slides') 
AND structure_field_id IN (SELECT id FROM structure_fields WHERE `model`='TmaSlide' AND `tablename`='tma_slides' AND `field`='barcode' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_fields SET language_label = 'slide system code' WHERE model = 'TmaSlide' AND field = 'barcode';
UPDATE structure_formats SET `display_column`='1', `display_order`='100', `language_heading`='system data' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='tma_slides') 
AND structure_field_id IN (SELECT id FROM structure_fields WHERE `model`='TmaSlide' AND `tablename`='tma_slides' AND `field`='barcode');
INSERT INTO i18n (id,en) VALUES ('slide system code', 'Slide System #');

INSERT IGNORE INTO i18n (id,en) 
VALUES
('scoring', 'Scoring');

INSERT IGNORE INTO i18n (id,en)
VALUES
('this bank is linked to at least one tissue and flagged as provider', 'This bank is linked to at least one tissue and flagged as provider'),
('at least one participant is linked to that bank', 'At least one participant is linked to that bank');

UPDATE datamart_browsing_controls
SET flag_active_1_to_2 = 0, flag_active_2_to_1 = 0
WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'ViewCollection') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'TreatmentMaster');

UPDATE datamart_browsing_controls
SET flag_active_1_to_2 = 0, flag_active_2_to_1 = 0
WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'ViewSample') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'ViewSample');
UPDATE datamart_browsing_controls
SET flag_active_1_to_2 = 0, flag_active_2_to_1 = 0
WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'ViewAliquotUse') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'StudySummary');
UPDATE datamart_browsing_controls
SET flag_active_1_to_2 = 0, flag_active_2_to_1 = 0
WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'TmaSlide') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'StudySummary');
UPDATE datamart_browsing_controls
SET flag_active_1_to_2 = 1, flag_active_2_to_1 = 1
WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'OrderItem') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'TmaSlide');
UPDATE datamart_browsing_controls
SET flag_active_1_to_2 = 1, flag_active_2_to_1 = 1
WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'ViewCollection') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'TreatmentMaster');

UPDATE datamart_structure_functions SET flag_active = 0 WHERE datamart_structure_id = (SELECT id FROM datamart_structures WHERE model = 'ViewTmaSlideUse') AND label = 'edit';
UPDATE datamart_structure_functions SET flag_active = 0 WHERE datamart_structure_id = (SELECT id FROM datamart_structures WHERE model = 'ViewTmaSlide') AND label = 'add tma slide use';
UPDATE datamart_structure_functions SET flag_active = 0 WHERE datamart_structure_id = (SELECT id FROM datamart_structures WHERE model = 'ViewSample') AND label = 'initial specimens display';
UPDATE datamart_structure_functions SET flag_active = 0 WHERE datamart_structure_id = (SELECT id FROM datamart_structures WHERE model = 'ViewSample') AND label = 'all derivatives display';
UPDATE datamart_structure_functions SET flag_active = 0 WHERE datamart_structure_id = (SELECT id FROM datamart_structures WHERE model = 'ViewSample') AND label = 'create quality control';
UPDATE datamart_structure_functions SET flag_active = 0 WHERE datamart_structure_id = (SELECT id FROM datamart_structures WHERE model = 'ViewSample') AND label = 'print barcodes';
UPDATE datamart_structure_functions SET flag_active = 0 WHERE datamart_structure_id = (SELECT id FROM datamart_structures WHERE model = 'ViewSample') AND label = 'create derivative';
UPDATE datamart_structure_functions SET flag_active = 0 WHERE datamart_structure_id = (SELECT id FROM datamart_structures WHERE model = 'ViewAliquot') AND label = 'create derivative';
UPDATE datamart_structure_functions SET flag_active = 0 WHERE datamart_structure_id = (SELECT id FROM datamart_structures WHERE model = 'ViewAliquot') AND label = 'create quality control';
UPDATE datamart_structure_functions SET flag_active = 0 WHERE datamart_structure_id = (SELECT id FROM datamart_structures WHERE model = 'ViewAliquot') AND label = 'create uses/events (aliquot specific)';
UPDATE datamart_structure_functions SET flag_active = 0 WHERE datamart_structure_id = (SELECT id FROM datamart_structures WHERE model = 'ViewAliquot') AND label = 'print barcodes';
UPDATE datamart_structure_functions SET flag_active = 0 WHERE datamart_structure_id = (SELECT id FROM datamart_structures WHERE model = 'ViewAliquot') AND label = 'create use/event (applied to all)';
UPDATE datamart_structure_functions SET flag_active = 0 WHERE datamart_structure_id = (SELECT id FROM datamart_structures WHERE model = 'ViewCollection') AND label = 'print barcodes';
UPDATE datamart_structure_functions SET flag_active = 0 WHERE datamart_structure_id = (SELECT id FROM datamart_structures WHERE model = 'NonTmaBlockStorage') AND label = 'list all children storages';
UPDATE datamart_structure_functions SET flag_active = 0 WHERE datamart_structure_id = (SELECT id FROM datamart_structures WHERE model = 'Participant') AND label = 'participant identifiers report';
UPDATE datamart_structure_functions SET flag_active = 0 WHERE datamart_structure_id = (SELECT id FROM datamart_structures WHERE model = 'Participant') AND label = 'list all related diagnosis';

UPDATE datamart_structure_functions SET flag_active = 0 WHERE datamart_structure_id = (SELECT id FROM datamart_structures WHERE model = 'TmaSlide') AND label = 'add tma slide use';
UPDATE datamart_structure_functions SET flag_active = 0 WHERE datamart_structure_id = (SELECT id FROM datamart_structures WHERE model = 'TmaSlideUse') AND label = 'edit';

UPDATE datamart_reports SET flag_active = 0 WHERE name != 'number of elements per participant';

UPDATE structure_formats SET `flag_editgrid`='1', `flag_editgrid_readonly`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='orderitems') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Generated' AND `tablename`='' AND `field`='type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='order_item_types') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='orderitems') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='OrderItem' AND `tablename`='order_items' AND `field`='id' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='orderitems') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Generated' AND `tablename`='' AND `field`='type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='order_item_types') AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_editgrid_readonly`='0', `flag_index`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='tma_slides') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TmaSlide' AND `tablename`='tma_slides' AND `field`='storage_datetime' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='scoring' WHERE structure_id=(SELECT id FROM structures WHERE alias='tma_slides') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TmaSlide' AND `tablename`='tma_slides' AND `field`='qbcf_scoring_results_reception_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_edit`='1', `flag_edit_readonly`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='orderitems') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Generated' AND `tablename`='' AND `field`='type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='order_item_types') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='orderitems') AND structure_field_id IN (SELECT id FROM structure_fields WHERE `model`='TmaSlide' AND `tablename`='tma_slides' AND `field`='barcode' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Order', 'Shipment', 'shipments', 'qbcf_clinical_data_version', 'date',  NULL , '0', '', '', '', 'clinical data version', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='shipments'), (SELECT id FROM structure_fields WHERE `model`='Shipment' AND `tablename`='shipments' AND `field`='qbcf_clinical_data_version' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='clinical data version' AND `language_tag`=''), '0', '40', 'data', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
ALTER TABLE shipments 
  ADD COLUMN qbcf_clinical_data_version date DEFAULT NULL,
  ADD COLUMN qbcf_clinical_data_version_accuracy char(1) DEFAULT '';
ALTER TABLE shipments_revs
  ADD COLUMN qbcf_clinical_data_version date DEFAULT NULL,
  ADD COLUMN qbcf_clinical_data_version_accuracy char(1) DEFAULT '';

UPDATE structure_formats SET `flag_addgrid`='1', `flag_addgrid_readonly`='1', `flag_editgrid`='1', `flag_editgrid_readonly`='1', `flag_index`='1', `flag_detail`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='shippeditems') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Generated' AND `tablename`='' AND `field`='type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='order_item_types') AND `flag_confidential`='0');

UPDATE structure_fields SET language_label = 'slide system code or aliquot barcode' WHERE `model`='Generated' AND `tablename`='' AND `field`='barcode' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND plugin = 'Order';
INSERT INTO i18n (id,en) VALUES ('slide system code or aliquot barcode', 'Slide System Code or Aliquot QBCF#');

-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Path Review
-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE aliquot_controls SET flag_active=true WHERE id IN(10);
UPDATE realiquoting_controls SET flag_active=true WHERE id IN(11);

UPDATE menus SET flag_active = 1 WHERE use_link LIKE '/InventoryManagement/SpecimenReviews%';

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='specimen_review_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SpecimenReviewMaster' AND `tablename`='specimen_review_masters' AND `field`='review_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='specimen_review_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SpecimenReviewMaster' AND `tablename`='specimen_review_masters' AND `field`='review_status' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='specimen_review_status') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='specimen_review_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SpecimenReviewMaster' AND `tablename`='specimen_review_masters' AND `field`='pathologist' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

ALTER TABLE specimen_review_masters ADD COLUMN qbcf_reviewer VARCHAR(50) DEFAULT NULL;
ALTER TABLE specimen_review_masters_revs ADD COLUMN qbcf_reviewer VARCHAR(50) DEFAULT NULL;

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'SpecimenReviewMaster', 'specimen_review_masters', 'qbcf_reviewer', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_staff') , '0', '', '', '', 'reviewer', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='specimen_review_masters'), (SELECT id FROM structure_fields WHERE `model`='SpecimenReviewMaster' AND `tablename`='specimen_review_masters' AND `field`='qbcf_reviewer' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_staff')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='reviewer' AND `language_tag`=''), '0', '8', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='specimen_review_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SpecimenReviewMaster' AND `tablename`='specimen_review_masters' AND `field`='review_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='specimen_review_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SpecimenReviewMaster' AND `tablename`='specimen_review_masters' AND `field`='review_status' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='specimen_review_status') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='specimen_review_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SpecimenReviewMaster' AND `tablename`='specimen_review_masters' AND `field`='pathologist' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Laboratory Staff');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
('Lucresse Fossouo', '',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('Louis-André Julien', '',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('Liliane Meunier', '',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('Monique Bernard', '',  '', '1', @control_id, NOW(), NOW(), 1, 1);
INSERT INTO i18n (id,en) VALUES ('reviewer','Reviewer'), ('tissue block review', 'Tissue Block Review');

INSERT INTO `aliquot_review_controls` (`id`, `review_type`, `flag_active`, `detail_form_alias`, `detail_tablename`, `aliquot_type_restriction`, `databrowser_label`) 
VALUES
(null, 'tissue block review', 1, 'qbcf_ar_tissue_blocks', 'qbcf_ar_tissue_blocks', 'block,slide', 'tissue block review');
INSERT INTO `specimen_review_controls` (`id`, `sample_control_id`, `aliquot_review_control_id`, `review_type`, `flag_active`, `detail_form_alias`, `detail_tablename`, `databrowser_label`) 
VALUES
(null, (SELECT id FROM sample_controls WHERE sample_type = 'tissue'), (SELECT id FROM aliquot_review_controls WHERE review_type = 'tissue block review'), 'tissue block review', 1, 'qbcf_spr_tissue_blocks', 'qbcf_spr_tissue_blocks', 'tissue block review');

CREATE TABLE IF NOT EXISTS `qbcf_spr_tissue_blocks` (
  `specimen_review_master_id` int(11) NOT NULL,
  KEY `FK_qbcf_spr_tissue_blocks_specimen_review_masters` (`specimen_review_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE IF NOT EXISTS `qbcf_spr_tissue_blocks_revs` (
  `specimen_review_master_id` int(11) NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;
ALTER TABLE `qbcf_spr_tissue_blocks`
  ADD CONSTRAINT `FK_qbcf_spr_tissue_blocks_specimen_review_masters` FOREIGN KEY (`specimen_review_master_id`) REFERENCES `specimen_review_masters` (`id`);

CREATE TABLE IF NOT EXISTS `qbcf_ar_tissue_blocks` (
  `aliquot_review_master_id` int(11) NOT NULL,
	histology varchar(100) DEFAULT NULL,	
	tubular_formation int(1) DEFAULT NULL,
	nuclear_atypia int(1) DEFAULT NULL,
	mitosis_count int(1) DEFAULT NULL,
	final_grade int(1) DEFAULT NULL,
	dcis_on_slide char(1) DEFAULT '',
	lcis_on_slide char(1) DEFAULT '',
	tils_pct int(3) DEFAULT NULL,
	lymphoid_aggregate_outside_of_the_tumor char(1) DEFAULT '',
	notes text,
  KEY `FK_qbcf_ar_tissue_blocks_aliquot_review_masters` (`aliquot_review_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE IF NOT EXISTS `qbcf_ar_tissue_blocks_revs` (
  `aliquot_review_master_id` int(11) NOT NULL,
 	histology varchar(100) DEFAULT NULL,	
	tubular_formation int(1) DEFAULT NULL,
	nuclear_atypia int(1) DEFAULT NULL,
	mitosis_count int(1) DEFAULT NULL,
	final_grade int(1) DEFAULT NULL,
	dcis_on_slide char(1) DEFAULT '',
	lcis_on_slide char(1) DEFAULT '',
	tils_pct int(3) DEFAULT NULL,
	lymphoid_aggregate_outside_of_the_tumor char(1) DEFAULT '',
	`notes` text,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;
ALTER TABLE `qbcf_ar_tissue_blocks`
  ADD CONSTRAINT `FK_qbcf_ar_tissue_blocks_aliquot_review_masters` FOREIGN KEY (`aliquot_review_master_id`) REFERENCES `aliquot_review_masters` (`id`);
UPDATE structure_formats SET `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_review_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotReviewMaster' AND `tablename`='aliquot_review_masters' AND `field`='review_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_review_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotReviewMaster' AND `tablename`='aliquot_review_masters' AND `field`='basis_of_specimen_review' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
INSERT INTO structure_validations(structure_field_id, rule) VALUES
((SELECT id FROM structure_fields WHERE `model`='AliquotReviewMaster' AND `tablename`='aliquot_review_masters' AND `field`='aliquot_master_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquots_list_for_review')), 'notEmpty');

INSERT INTO structures(`alias`) VALUES ('qbcf_ar_tissue_blocks');
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("qbcf_1_2_3", "open", "", NULL);
INSERT IGNORE INTO structure_permissible_values (value, language_alias) 
VALUES
("1", "1"),
("2", "2"),
("3", "3");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) 
VALUES 
((SELECT id FROM structure_value_domains WHERE domain_name="qbcf_1_2_3"), (SELECT id FROM structure_permissible_values WHERE value="1" AND language_alias="1"), "1", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qbcf_1_2_3"), (SELECT id FROM structure_permissible_values WHERE value="2" AND language_alias="2"), "2", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qbcf_1_2_3"), (SELECT id FROM structure_permissible_values WHERE value="3" AND language_alias="3"), "3", "1");
INSERT INTO structure_value_domains (domain_name, source) 
VALUES 
('qbcf_path_review_histology', "StructurePermissibleValuesCustom::getCustomDropdown('Path Review Histology')");
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) 
VALUES 
('Path Review Histology', 1, 100, 'Inventory - specimen review');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Path Review Histology');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
('non invasive carcinoma', 'Non Invasive carcinoma',  '', '1', @control_id, NOW(), NOW(), 1, 1), 
('invasive ductal carcinoma (no special type or not otherwise specified)', 'Invasive ductal carcinoma (no special type or not otherwise specified)',  '', '1', @control_id, NOW(), NOW(), 1, 1), 
('invasive lobular carcinoma', 'Invasive lobular carcinoma',  '', '1', @control_id, NOW(), NOW(), 1, 1), 
('invasive carcinoma with ductal and lobular features (mixed type carcinoma)', 'Invasive carcinoma with ductal and lobular features (mixed type carcinoma)',  '', '1', @control_id, NOW(), NOW(), 1, 1), 
('invasive mucinous carcinoma', 'Invasive mucinous carcinoma',  '', '1', @control_id, NOW(), NOW(), 1, 1), 
('invasive medullary carcinoma', 'Invasive medullary carcinoma',  '', '1', @control_id, NOW(), NOW(), 1, 1), 
('invasive papillary carcinoma', 'Invasive papillary carcinoma',  '', '1', @control_id, NOW(), NOW(), 1, 1), 
('invasive micropapillary carcinoma', 'Invasive micropapillary carcinoma',  '', '1', @control_id, NOW(), NOW(), 1, 1), 
('invasive tubular carcinoma', 'Invasive tubular carcinoma',  '', '1', @control_id, NOW(), NOW(), 1, 1), 
('invasive cribriform carcinoma', 'Invasive cribriform carcinoma',  '', '1', @control_id, NOW(), NOW(), 1, 1), 
('invasive carcinoma, type cannot be determined', 'Invasive carcinoma, type cannot be determined',  '', '1', @control_id, NOW(), NOW(), 1, 1), 
('invasive ductal carcinoma pleiomorphic', 'Invasive ductal carcinoma pleiomorphic',  '', '1', @control_id, NOW(), NOW(), 1, 1), 
('invasive ductal carcinoma apocrine', 'Invasive ductal carcinoma apocrine',  '', '1', @control_id, NOW(), NOW(), 1, 1);
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'AliquotReviewDetail', 'qbcf_ar_tissue_blocks', 'histology', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qbcf_path_review_histology') , '0', '', '', '', 'histology', ''), 
('InventoryManagement', 'AliquotReviewDetail', 'qbcf_ar_tissue_blocks', 'tubular_formation', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qbcf_1_2_3') , '0', '', '', '', 'tubular formation', ''), 
('InventoryManagement', 'AliquotReviewDetail', 'qbcf_ar_tissue_blocks', 'nuclear_atypia', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qbcf_1_2_3') , '0', '', '', '', 'nuclear atypia', ''), 
('InventoryManagement', 'AliquotReviewDetail', 'qbcf_ar_tissue_blocks', 'mitosis_count', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qbcf_1_2_3') , '0', '', '', '', 'mitosis count', ''), 
('InventoryManagement', 'AliquotReviewDetail', 'qbcf_ar_tissue_blocks', 'final_grade', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qbcf_1_2_3') , '0', '', '', '', 'final grade', ''), 
('InventoryManagement', 'AliquotReviewDetail', 'qbcf_ar_tissue_blocks', 'dcis_on_slide', 'yes_no',  NULL , '0', '', '', '', 'dcis on slide', ''), 
('InventoryManagement', 'AliquotReviewDetail', 'qbcf_ar_tissue_blocks', 'lcis_on_slide', 'yes_no',  NULL , '0', '', '', '', 'lcis on slide', ''), 
('InventoryManagement', 'AliquotReviewDetail', 'qbcf_ar_tissue_blocks', 'tils_pct', 'integer_positive',  NULL , '0', 'size=3', '', '', 'tils pct', ''), 
('InventoryManagement', 'AliquotReviewDetail', 'qbcf_ar_tissue_blocks', 'lymphoid_aggregate_outside_of_the_tumor', 'yes_no',  NULL , '0', '', '', '', 'lymphoid aggregate outside of the tumor', ''), 
('InventoryManagement', 'AliquotReviewDetail', 'qbcf_ar_tissue_blocks', 'notes', 'textarea',  NULL , '0', '', '', '', 'notes', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qbcf_ar_tissue_blocks'), (SELECT id FROM structure_fields WHERE `model`='AliquotReviewDetail' AND `tablename`='qbcf_ar_tissue_blocks' AND `field`='histology' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qbcf_path_review_histology')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='histology' AND `language_tag`=''), '0', '10', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='qbcf_ar_tissue_blocks'), (SELECT id FROM structure_fields WHERE `model`='AliquotReviewDetail' AND `tablename`='qbcf_ar_tissue_blocks' AND `field`='tubular_formation' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qbcf_1_2_3')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tubular formation' AND `language_tag`=''), '0', '11', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='qbcf_ar_tissue_blocks'), (SELECT id FROM structure_fields WHERE `model`='AliquotReviewDetail' AND `tablename`='qbcf_ar_tissue_blocks' AND `field`='nuclear_atypia' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qbcf_1_2_3')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='nuclear atypia' AND `language_tag`=''), '0', '12', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='qbcf_ar_tissue_blocks'), (SELECT id FROM structure_fields WHERE `model`='AliquotReviewDetail' AND `tablename`='qbcf_ar_tissue_blocks' AND `field`='mitosis_count' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qbcf_1_2_3')), '0', '13', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='qbcf_ar_tissue_blocks'), (SELECT id FROM structure_fields WHERE `model`='AliquotReviewDetail' AND `tablename`='qbcf_ar_tissue_blocks' AND `field`='final_grade' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qbcf_1_2_3')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='final grade' AND `language_tag`=''), '0', '14', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='qbcf_ar_tissue_blocks'), (SELECT id FROM structure_fields WHERE `model`='AliquotReviewDetail' AND `tablename`='qbcf_ar_tissue_blocks' AND `field`='dcis_on_slide' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='dcis on slide' AND `language_tag`=''), '0', '15', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='qbcf_ar_tissue_blocks'), (SELECT id FROM structure_fields WHERE `model`='AliquotReviewDetail' AND `tablename`='qbcf_ar_tissue_blocks' AND `field`='lcis_on_slide' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='lcis on slide' AND `language_tag`=''), '0', '16', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='qbcf_ar_tissue_blocks'), (SELECT id FROM structure_fields WHERE `model`='AliquotReviewDetail' AND `tablename`='qbcf_ar_tissue_blocks' AND `field`='tils_pct' AND `type`='integer_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=3' AND `default`='' AND `language_help`='' AND `language_label`='tils pct' AND `language_tag`=''), '0', '17', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='qbcf_ar_tissue_blocks'), (SELECT id FROM structure_fields WHERE `model`='AliquotReviewDetail' AND `tablename`='qbcf_ar_tissue_blocks' AND `field`='lymphoid_aggregate_outside_of_the_tumor' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='lymphoid aggregate outside of the tumor' AND `language_tag`=''), '0', '18', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='qbcf_ar_tissue_blocks'), (SELECT id FROM structure_fields WHERE `model`='AliquotReviewDetail' AND `tablename`='qbcf_ar_tissue_blocks' AND `field`='notes' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='notes' AND `language_tag`=''), '0', '19', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '0', '0', '0');
ALTER TABLE `qbcf_ar_tissue_blocks` ADD COLUMN large_tumor_zone char(1) DEFAULT '';
ALTER TABLE `qbcf_ar_tissue_blocks_revs` ADD COLUMN large_tumor_zone char(1) DEFAULT '';
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'AliquotReviewDetail', 'qbcf_ar_tissue_blocks', 'large_tumor_zone', 'yes_no',  NULL , '0', '', '', '', 'large tumor zone', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qbcf_ar_tissue_blocks'), (SELECT id FROM structure_fields WHERE `model`='AliquotReviewDetail' AND `tablename`='qbcf_ar_tissue_blocks' AND `field`='large_tumor_zone' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='large tumor zone' AND `language_tag`=''), '0', '19', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '0', '0', '0');
UPDATE structure_fields SET  `language_help`='qbcf_help_lymphoid_aggregate_outside_of_the_tumor' WHERE model='AliquotReviewDetail' AND tablename='qbcf_ar_tissue_blocks' AND field='lymphoid_aggregate_outside_of_the_tumor' AND `type`='yes_no' AND structure_value_domain  IS NULL ;
UPDATE structure_fields SET  `setting`='rows=1,cols=30' WHERE model='AliquotReviewDetail' AND tablename='qbcf_ar_tissue_blocks' AND field='notes' AND `type`='textarea' AND structure_value_domain  IS NULL ;
UPDATE structure_formats SET `display_order`='20', `flag_editgrid`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='qbcf_ar_tissue_blocks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotReviewDetail' AND `tablename`='qbcf_ar_tissue_blocks' AND `field`='notes' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_fields SET  `language_help`='qbcf_help_large_tumor_zone' WHERE model='AliquotReviewDetail' AND tablename='qbcf_ar_tissue_blocks' AND field='large_tumor_zone';
UPDATE structure_formats SET `flag_search`='0', `flag_editgrid`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qbcf_ar_tissue_blocks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotReviewDetail' AND `tablename`='qbcf_ar_tissue_blocks' AND `field`='notes' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
INSERT INTO i18n (id,en)
VALUES
('tubular formation', 'Tubular Formation'),
('nuclear atypia', 'Nuclear Atypia'),
('final grade', 'Final Grade (Nottingham)'),
('dcis on slide', 'DCIS on Slide'),
('lcis on slide', 'LCIS on Slide'),
('tils pct', 'Tumour Lymphocytes (TILs) %'),
('lymphoid aggregate outside of the tumor', 'Lymphoid Aggregate or Tertiary Lymhoid Structure'),
('qbcf_help_large_tumor_zone', 'Greater than 6 punches'),
('qbcf_help_lymphoid_aggregate_outside_of_the_tumor', 'Lymphoid Aggregate outside of the tumor (>1mm) or Tertiary Lymhoid Structure '),
('mitosis count', 'Mitosis Count'),
('large tumor zone', 'Large Tumor Zone');
REPLACE INTO i18n (id,en)
VALUES
('mitosis count', 'Mitosis Count');

UPDATE structure_formats SET `flag_float`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_spec_tiss_blocks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='aliquot_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_fields 
SET flag_confidential = '1' 
WHERE `plugin` = 'InventoryManagement' AND `tablename` = 'aliquot_masters' AND `field` = 'aliquot_label';

INSERT INTO i18n (id,en)
VALUES
('more than one block have the same aliquot label [%s] - please validate', 'More than one block have the same Aliquot Bank Label [%s]. Please validate.');

UPDATE structure_formats SET `flag_search`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_spec_tiss_blocks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='aliquot_label');

UPDATE structure_fields SET field = 'qbcf_generated_label_for_display' WHERE field = 'qc_tf_generated_label_for_display';

ALTER TABLE ad_tissue_slides ADD COLUMN qbcf_staining VARCHAR(50) DEFAULT NULL;
ALTER TABLE ad_tissue_slides_revs ADD COLUMN qbcf_staining VARCHAR(50) DEFAULT NULL;
INSERT INTO structure_value_domains (domain_name, source) 
VALUES 
('qbcf_slide_staining', "StructurePermissibleValuesCustom::getCustomDropdown('Slide Staining')");
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) 
VALUES 
('Slide Staining', 1, 50, 'study');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Slide Staining');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
('H&I', '',  '', '1', @control_id, NOW(), NOW(), 1, 1);
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'AliquotDetail', '', 'qbcf_staining', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qbcf_slide_staining') , '0', '', '', '', 'staining', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ad_spec_tiss_slides'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='' AND `field`='qbcf_staining' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qbcf_slide_staining')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='staining' AND `language_tag`=''), '1', '71', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '1', '0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_spec_tiss_slides') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='' AND `field`='immunochemistry' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
INSERT INTO i18n (id,en) VALUES ('staining', 'Staining');

INSERT INTO `storage_controls` (`id`, `storage_type`, `coord_x_title`, `coord_x_type`, `coord_x_size`, `coord_y_title`, `coord_y_type`, `coord_y_size`, `display_x_size`, `display_y_size`, `reverse_x_numbering`, `reverse_y_numbering`, `horizontal_increment`, `set_temperature`, `is_tma_block`, `flag_active`, `detail_form_alias`, `detail_tablename`, `databrowser_label`, `check_conflicts`) VALUES
(null, 'box100', 'position', 'integer', 100, NULL, NULL, NULL, 10, 10, 0, 0, 1, 0, 0, 0, '', 'std_boxs', 'custom#storage types#box100', 1);
UPDATE storage_controls SET flag_active = 1 WHERE storage_type = 'box100';
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Storage Types');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
('box100', 'Box100 1-100',  '', '1', @control_id, NOW(), NOW(), 1, 1);

UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='viewaliquotuses') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquotUse' AND `tablename`='view_aliquot_uses' AND `field`='use_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE menus SET flag_active = 0 WHERE use_link LIKE '/ClinicalAnnotation/MiscIdentifiers%';

SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Aliquot Use and Event Types');
DELETE FROM structure_permissible_values_customs WHERE control_id = @control_id;
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
('returned to bank', 'Returned to bank',  '', '1', @control_id, NOW(), NOW(), 1, 1);

UPDATE structure_formats SET `flag_edit`='0', `flag_batchedit`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='used_aliq_in_stock_details') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='in_stock_detail' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_in_stock_detail') AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquotinternaluses') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotInternalUse' AND `tablename`='aliquot_internal_uses' AND `field`='use_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquotinternaluses') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotInternalUse' AND `tablename`='aliquot_internal_uses' AND `field`='duration' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquotinternaluses') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotInternalUse' AND `tablename`='aliquot_internal_uses' AND `field`='duration_unit' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='duration_unit') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquotinternaluses') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='autocomplete_aliquot_internal_use_study_summary_id' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquotinternaluses') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='title' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_fields SET flag_confidential = '0' WHERE model like '%aliquot%' AND field = 'aliquot_label';

-- -----------------------------------------------------------------------------------------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE diagnosis_controls SET category = 'secondary - distant' WHERE detail_tablename = 'qbcf_dx_breast_progressions';
UPDATE diagnosis_controls SET category = 'secondary - distant' WHERE detail_tablename = 'qbcf_dx_other_cancer_progressions';

-- qbcf_dx_other_cancer_progressions

DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='qbcf_dx_other_cancer_progressions') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='qbcf_dx_other_cancer_progressions' AND `field`='primary_disease_site' AND `language_label`='primary site' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='ctrnet_submission_disease_site') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_validations WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='qbcf_dx_other_cancer_progressions' AND `field`='primary_disease_site' AND `language_label`='primary site' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='ctrnet_submission_disease_site') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0'));
DELETE FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='qbcf_dx_other_cancer_progressions' AND `field`='primary_disease_site' AND `language_label`='primary site' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='ctrnet_submission_disease_site') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
ALTER TABLE qbcf_dx_other_cancer_progressions DROP COLUMN primary_disease_site;
ALTER TABLE qbcf_dx_other_cancer_progressions_revs DROP COLUMN primary_disease_site;

-- qbcf_txd_other_cancers

DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='qbcf_txd_other_cancers') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='TreatmentDetail' AND `tablename`='qbcf_txd_other_cancers' AND `field`='cancer_site' AND `language_label`='cancer' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='ctrnet_submission_disease_site') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_validations WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='TreatmentDetail' AND `tablename`='qbcf_txd_other_cancers' AND `field`='cancer_site' AND `language_label`='cancer' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='ctrnet_submission_disease_site') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0'));
DELETE FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='TreatmentDetail' AND `tablename`='qbcf_txd_other_cancers' AND `field`='cancer_site' AND `language_label`='cancer' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='ctrnet_submission_disease_site') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
ALTER TABLE qbcf_txd_other_cancers DROP COLUMN cancer_site;
ALTER TABLE qbcf_txd_other_cancers_revs DROP COLUMN cancer_site;

-- qbcf_dx_breasts

DELETE FROM structure_formats 
WHERE structure_id=(SELECT id FROM structures WHERE alias='qbcf_dx_breasts') 
AND structure_field_id NOT IN (SELECT id FROM structure_fields WHERE field In ('age_at_dx', 'laterality'));
DROP TABLE qbcf_dx_breasts;
DROP TABLE qbcf_dx_breasts_revs;
CREATE TABLE IF NOT EXISTS `qbcf_dx_breasts` (
  `laterality` varchar(50) DEFAULT NULL,
  `diagnosis_master_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE IF NOT EXISTS `qbcf_dx_breasts_revs` (
  `laterality` varchar(50) DEFAULT NULL,
  `diagnosis_master_id` int(11) NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;
ALTER TABLE `qbcf_dx_breasts`
  ADD CONSTRAINT `qbcf_dx_breasts_ibfk_1` FOREIGN KEY (`diagnosis_master_id`) REFERENCES `diagnosis_masters` (`id`);

-- qbcf_tx_breast_diagnostic_events

CREATE TABLE IF NOT EXISTS `qbcf_tx_breast_diagnostic_events` (
  `age_at_dx` int(11) DEFAULT NULL,
  `morphology` varchar(250) DEFAULT NULL,
  `clinical_tstage` varchar(50) DEFAULT NULL,
  `clinical_nstage` varchar(50) DEFAULT NULL,
  `clinical_mstage` varchar(50) DEFAULT NULL,
  `clinical_stage_summary` varchar(50) DEFAULT NULL,
  `path_tstage` varchar(50) DEFAULT NULL,
  `path_nstage` varchar(50) DEFAULT NULL,
  `path_mstage` varchar(50) DEFAULT NULL,
  `path_stage_summary` varchar(50) DEFAULT NULL,
  `type_of_intervention` varchar(50) DEFAULT NULL,
  `laterality` varchar(50) DEFAULT NULL,
  `grade_notthingham_sbr_ee` varchar(50) DEFAULT NULL,
  `glandular_acinar_tubular_differentiation` varchar(50) DEFAULT NULL,
  `nuclear_pleomorphism` varchar(50) DEFAULT NULL,
  `mitotic_rate` varchar(50) DEFAULT NULL,
  `tumor_size` decimal(8,1) DEFAULT NULL,
  `margin_status` varchar(50) DEFAULT NULL,
  `number_of_positive_regional_ln` int(4) DEFAULT NULL,
  `number_of_positive_regional_ln_integer_unknown` char(1) DEFAULT '',
  `total_number_of_regional_ln_analysed` int(4) DEFAULT NULL,
  `total_number_of_regional_ln_analysed_integer_unknown` char(1) DEFAULT '',
  `number_of_positive_regional_ln_category` varchar(50) DEFAULT NULL,
  `number_of_positive_sentinel_ln` int(4) DEFAULT NULL,
  `number_of_positive_sentinel_ln_integer_unknown` char(1) DEFAULT '',
  `total_number_of_sentinel_ln_analysed` int(4) DEFAULT NULL,
  `total_number_of_sentinel_ln_analysed_integer_unknown` char(1) DEFAULT '',
  `number_of_positive_sentinel_ln_category` varchar(50) DEFAULT NULL,
  `er_overall` varchar(50) DEFAULT NULL,
  `er_intensity` varchar(50) DEFAULT NULL,
  `er_percent` decimal(4,1) DEFAULT NULL,
  `pr_overall` varchar(50) DEFAULT NULL,
  `pr_intensity` varchar(50) DEFAULT NULL,
  `pr_percent` decimal(4,1) DEFAULT NULL,
  `her2_ihc` varchar(50) DEFAULT NULL,
  `her2_fish` varchar(50) DEFAULT NULL,
  `her_2_status` varchar(50) DEFAULT NULL,
  `tnbc` varchar(50) DEFAULT NULL,
  `time_to_last_contact_months` int(5) DEFAULT NULL,
  `time_to_first_progression_months` int(5) DEFAULT NULL,
  `treatment_master_id` int(11) NOT NULL,
  KEY `qbcf_tx_breast_diagnostic_events_ibfk_1` (`treatment_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE IF NOT EXISTS `qbcf_tx_breast_diagnostic_events_revs` (
  `age_at_dx` int(11) DEFAULT NULL,
  `morphology` varchar(250) DEFAULT NULL,
  `clinical_tstage` varchar(50) DEFAULT NULL,
  `clinical_nstage` varchar(50) DEFAULT NULL,
  `clinical_mstage` varchar(50) DEFAULT NULL,
  `clinical_stage_summary` varchar(50) DEFAULT NULL,
  `path_tstage` varchar(50) DEFAULT NULL,
  `path_nstage` varchar(50) DEFAULT NULL,
  `path_mstage` varchar(50) DEFAULT NULL,
  `path_stage_summary` varchar(50) DEFAULT NULL,
  `type_of_intervention` varchar(50) DEFAULT NULL,
  `laterality` varchar(50) DEFAULT NULL,
  `grade_notthingham_sbr_ee` varchar(50) DEFAULT NULL,
  `glandular_acinar_tubular_differentiation` varchar(50) DEFAULT NULL,
  `nuclear_pleomorphism` varchar(50) DEFAULT NULL,
  `mitotic_rate` varchar(50) DEFAULT NULL,
  `tumor_size` decimal(8,1) DEFAULT NULL,
  `margin_status` varchar(50) DEFAULT NULL,
  `number_of_positive_regional_ln` int(4) DEFAULT NULL,
  `number_of_positive_regional_ln_integer_unknown` char(1) DEFAULT '',
  `total_number_of_regional_ln_analysed` int(4) DEFAULT NULL,
  `total_number_of_regional_ln_analysed_integer_unknown` char(1) DEFAULT '',
  `number_of_positive_regional_ln_category` varchar(50) DEFAULT NULL,
  `number_of_positive_sentinel_ln` int(4) DEFAULT NULL,
  `number_of_positive_sentinel_ln_integer_unknown` char(1) DEFAULT '',
  `total_number_of_sentinel_ln_analysed` int(4) DEFAULT NULL,
  `total_number_of_sentinel_ln_analysed_integer_unknown` char(1) DEFAULT '',
  `number_of_positive_sentinel_ln_category` varchar(50) DEFAULT NULL,
  `er_overall` varchar(50) DEFAULT NULL,
  `er_intensity` varchar(50) DEFAULT NULL,
  `er_percent` decimal(4,1) DEFAULT NULL,
  `pr_overall` varchar(50) DEFAULT NULL,
  `pr_intensity` varchar(50) DEFAULT NULL,
  `pr_percent` decimal(4,1) DEFAULT NULL,
  `her2_ihc` varchar(50) DEFAULT NULL,
  `her2_fish` varchar(50) DEFAULT NULL,
  `her_2_status` varchar(50) DEFAULT NULL,
  `tnbc` varchar(50) DEFAULT NULL,
  `time_to_last_contact_months` int(5) DEFAULT NULL,
  `time_to_first_progression_months` int(5) DEFAULT NULL,
  `treatment_master_id` int(11) NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;
ALTER TABLE `qbcf_tx_breast_diagnostic_events`
  ADD CONSTRAINT `qbcf_tx_breast_diagnostic_events_ibfk_1` FOREIGN KEY (`treatment_master_id`) REFERENCES `treatment_masters` (`id`);
INSERT INTO structures(`alias`) VALUES ('qbcf_tx_breast_diagnostic_events');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'TreatmentDetail', 'qbcf_tx_breast_diagnostic_events', 'age_at_dx', 'integer_positive',  NULL , '0', 'size=5', '', 'help_age at dx', 'age at time of intervention', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'qbcf_tx_breast_diagnostic_events', 'type_of_intervention', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qbcf_type_of_intervention') , '0', '', '', '', 'type of intervention', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'qbcf_tx_breast_diagnostic_events', 'laterality', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qbcf_laterality') , '0', '', '', '', 'laterality', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'qbcf_tx_breast_diagnostic_events', 'clinical_stage_summary', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qbcf_clinical_anatomic_stage') , '0', '', '', '', 'clinical stage', 'summary'), 
('ClinicalAnnotation', 'TreatmentDetail', 'qbcf_tx_breast_diagnostic_events', 'clinical_tstage', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qbcf_tnm_ct') , '0', '', '', '', '', 't stage'), 
('ClinicalAnnotation', 'TreatmentDetail', 'qbcf_tx_breast_diagnostic_events', 'clinical_nstage', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qbcf_tnm_cn') , '0', '', '', '', '', 'n stage'), 
('ClinicalAnnotation', 'TreatmentDetail', 'qbcf_tx_breast_diagnostic_events', 'clinical_mstage', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qbcf_tnm_cm') , '0', '', '', '', '', 'm stage'), 
('ClinicalAnnotation', 'TreatmentDetail', 'qbcf_tx_breast_diagnostic_events', 'path_stage_summary', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qbcf_pathological_anatomic_stage') , '0', '', '', '', 'pathological stage', 'summary'), 
('ClinicalAnnotation', 'TreatmentDetail', 'qbcf_tx_breast_diagnostic_events', 'path_tstage', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qbcf_tnm_pt') , '0', '', '', '', '', 't stage'), 
('ClinicalAnnotation', 'TreatmentDetail', 'qbcf_tx_breast_diagnostic_events', 'path_nstage', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qbcf_tnm_pn') , '0', '', '', '', '', 'n stage'), 
('ClinicalAnnotation', 'TreatmentDetail', 'qbcf_tx_breast_diagnostic_events', 'path_mstage', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qbcf_tnm_pm') , '0', '', '', '', '', 'm stage'), 
('ClinicalAnnotation', 'TreatmentDetail', 'qbcf_tx_breast_diagnostic_events', 'morphology', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qbcf_morphology') , '0', '', '', '', 'morphology', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'qbcf_tx_breast_diagnostic_events', 'grade_notthingham_sbr_ee', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qbcf_grade_notthingham_sbr_ee') , '0', '', '', '', 'grade notthingham / sbr-ee', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'qbcf_tx_breast_diagnostic_events', 'glandular_acinar_tubular_differentiation', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qbcf_glandular_acinar_tubular_differentiation') , '0', '', '', '', 'glandular (acinar)/ tubular differentiation', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'qbcf_tx_breast_diagnostic_events', 'nuclear_pleomorphism', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qbcf_nuclear_pleomorphism') , '0', '', '', '', 'nuclear pleomorphism', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'qbcf_tx_breast_diagnostic_events', 'mitotic_rate', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qbcf_mitotic_rate') , '0', '', '', '', 'mitotic rate', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'qbcf_tx_breast_diagnostic_events', 'tumor_size', 'float_positive',  NULL , '0', '', '', '', 'tumor size (mm)', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'qbcf_tx_breast_diagnostic_events', 'margin_status', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qbcf_margin_status') , '0', '', '', '', 'margin status', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'qbcf_tx_breast_diagnostic_events', 'number_of_positive_regional_ln', 'integer_positive',  NULL , '0', '', '', '', 'number of positive regional ln', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'qbcf_tx_breast_diagnostic_events', 'total_number_of_regional_ln_analysed', 'integer_positive',  NULL , '0', '', '', '', 'total number of regional ln analysed', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'qbcf_tx_breast_diagnostic_events', 'number_of_positive_regional_ln_category', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qbcf_number_of_positive_regional_ln_category') , '0', '', '', '', 'number of positive regional ln (category)', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'qbcf_tx_breast_diagnostic_events', 'number_of_positive_sentinel_ln', 'integer_positive',  NULL , '0', '', '', '', 'number of positive sentinel ln', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'qbcf_tx_breast_diagnostic_events', 'total_number_of_sentinel_ln_analysed', 'integer_positive',  NULL , '0', '', '', '', 'total number of sentinel ln analysed', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'qbcf_tx_breast_diagnostic_events', 'number_of_positive_sentinel_ln_category', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qbcf_number_of_positive_sentinel_ln_category') , '0', '', '', '', 'number of positive sentinel ln (category)', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'qbcf_tx_breast_diagnostic_events', 'er_overall', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qbcf_er_overall') , '0', '', '', '', 'er overall  (from path report)', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'qbcf_tx_breast_diagnostic_events', 'er_intensity', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qbcf_er_intensity') , '0', '', '', '', 'er intensity', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'qbcf_tx_breast_diagnostic_events', 'er_percent', 'float_positive',  NULL , '0', '', '', '', 'er percent', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'qbcf_tx_breast_diagnostic_events', 'pr_overall', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qbcf_pr_overall') , '0', '', '', '', 'pr overall (in path report)', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'qbcf_tx_breast_diagnostic_events', 'pr_intensity', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qbcf_pr_intensity') , '0', '', '', '', 'pr intensity', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'qbcf_tx_breast_diagnostic_events', 'pr_percent', 'float_positive',  NULL , '0', '', '', '', 'pr percent', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'qbcf_tx_breast_diagnostic_events', 'her2_ihc', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qbcf_her2_ihc') , '0', '', '', '', 'her2 ihc', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'qbcf_tx_breast_diagnostic_events', 'her2_fish', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qbcf_her2_fish') , '0', '', '', '', 'her2 fish', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'qbcf_tx_breast_diagnostic_events', 'her_2_status', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qbcf_her_2_status') , '0', '', '', '', 'her 2 status', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'qbcf_tx_breast_diagnostic_events', 'tnbc', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qbcf_tnbc') , '0', '', '', '', 'tnbc', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'qbcf_tx_breast_diagnostic_events', 'number_of_positive_regional_ln_integer_unknown', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qbcf_integer_unknown') , '0', '', '', '', '', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'qbcf_tx_breast_diagnostic_events', 'total_number_of_regional_ln_analysed_integer_unknown', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qbcf_integer_unknown') , '0', '', '', '', '', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'qbcf_tx_breast_diagnostic_events', 'number_of_positive_sentinel_ln_integer_unknown', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qbcf_integer_unknown') , '0', '', '', '', '', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'qbcf_tx_breast_diagnostic_events', 'total_number_of_sentinel_ln_analysed_integer_unknown', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qbcf_integer_unknown') , '0', '', '', '', '', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'qbcf_tx_breast_diagnostic_events', 'time_to_last_contact_months', 'integer_positive',  NULL , '0', 'size=3', '', '', 'time to last contact/death (months)', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'qbcf_tx_breast_diagnostic_events', 'time_to_first_progression_months', 'integer_positive',  NULL , '0', 'size=3', '', '', 'time to first progression (months)', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qbcf_tx_breast_diagnostic_events'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qbcf_tx_breast_diagnostic_events' AND `field`='age_at_dx' AND `type`='integer_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='help_age at dx' AND `language_label`='age at time of intervention' AND `language_tag`=''), '1', '9', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qbcf_tx_breast_diagnostic_events'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qbcf_tx_breast_diagnostic_events' AND `field`='type_of_intervention' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qbcf_type_of_intervention')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='type of intervention' AND `language_tag`=''), '1', '10', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qbcf_tx_breast_diagnostic_events'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qbcf_tx_breast_diagnostic_events' AND `field`='laterality' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qbcf_laterality')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='laterality' AND `language_tag`=''), '1', '12', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qbcf_tx_breast_diagnostic_events'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qbcf_tx_breast_diagnostic_events' AND `field`='clinical_stage_summary' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qbcf_clinical_anatomic_stage')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='clinical stage' AND `language_tag`='summary'), '1', '14', 'coding', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qbcf_tx_breast_diagnostic_events'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qbcf_tx_breast_diagnostic_events' AND `field`='clinical_tstage' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qbcf_tnm_ct')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='t stage'), '1', '15', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qbcf_tx_breast_diagnostic_events'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qbcf_tx_breast_diagnostic_events' AND `field`='clinical_nstage' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qbcf_tnm_cn')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='n stage'), '1', '16', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qbcf_tx_breast_diagnostic_events'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qbcf_tx_breast_diagnostic_events' AND `field`='clinical_mstage' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qbcf_tnm_cm')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='m stage'), '1', '17', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qbcf_tx_breast_diagnostic_events'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qbcf_tx_breast_diagnostic_events' AND `field`='path_stage_summary' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qbcf_pathological_anatomic_stage')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='pathological stage' AND `language_tag`='summary'), '1', '18', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qbcf_tx_breast_diagnostic_events'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qbcf_tx_breast_diagnostic_events' AND `field`='path_tstage' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qbcf_tnm_pt')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='t stage'), '1', '19', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qbcf_tx_breast_diagnostic_events'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qbcf_tx_breast_diagnostic_events' AND `field`='path_nstage' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qbcf_tnm_pn')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='n stage'), '1', '20', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qbcf_tx_breast_diagnostic_events'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qbcf_tx_breast_diagnostic_events' AND `field`='path_mstage' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qbcf_tnm_pm')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='m stage'), '1', '21', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qbcf_tx_breast_diagnostic_events'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qbcf_tx_breast_diagnostic_events' AND `field`='morphology' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qbcf_morphology')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='morphology' AND `language_tag`=''), '3', '22', 'morphology', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qbcf_tx_breast_diagnostic_events'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qbcf_tx_breast_diagnostic_events' AND `field`='grade_notthingham_sbr_ee' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qbcf_grade_notthingham_sbr_ee')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='grade notthingham / sbr-ee' AND `language_tag`=''), '3', '23', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qbcf_tx_breast_diagnostic_events'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qbcf_tx_breast_diagnostic_events' AND `field`='glandular_acinar_tubular_differentiation' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qbcf_glandular_acinar_tubular_differentiation')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='glandular (acinar)/ tubular differentiation' AND `language_tag`=''), '3', '24', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qbcf_tx_breast_diagnostic_events'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qbcf_tx_breast_diagnostic_events' AND `field`='nuclear_pleomorphism' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qbcf_nuclear_pleomorphism')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='nuclear pleomorphism' AND `language_tag`=''), '3', '25', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qbcf_tx_breast_diagnostic_events'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qbcf_tx_breast_diagnostic_events' AND `field`='mitotic_rate' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qbcf_mitotic_rate')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='mitotic rate' AND `language_tag`=''), '3', '26', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qbcf_tx_breast_diagnostic_events'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qbcf_tx_breast_diagnostic_events' AND `field`='tumor_size' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tumor size (mm)' AND `language_tag`=''), '3', '27', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qbcf_tx_breast_diagnostic_events'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qbcf_tx_breast_diagnostic_events' AND `field`='margin_status' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qbcf_margin_status')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='margin status' AND `language_tag`=''), '3', '28', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qbcf_tx_breast_diagnostic_events'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qbcf_tx_breast_diagnostic_events' AND `field`='number_of_positive_regional_ln' AND `type`='integer_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='number of positive regional ln' AND `language_tag`=''), '3', '29', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qbcf_tx_breast_diagnostic_events'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qbcf_tx_breast_diagnostic_events' AND `field`='total_number_of_regional_ln_analysed' AND `type`='integer_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='total number of regional ln analysed' AND `language_tag`=''), '3', '30', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qbcf_tx_breast_diagnostic_events'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qbcf_tx_breast_diagnostic_events' AND `field`='number_of_positive_regional_ln_category' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qbcf_number_of_positive_regional_ln_category')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='number of positive regional ln (category)' AND `language_tag`=''), '3', '31', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qbcf_tx_breast_diagnostic_events'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qbcf_tx_breast_diagnostic_events' AND `field`='number_of_positive_sentinel_ln' AND `type`='integer_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='number of positive sentinel ln' AND `language_tag`=''), '3', '32', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qbcf_tx_breast_diagnostic_events'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qbcf_tx_breast_diagnostic_events' AND `field`='total_number_of_sentinel_ln_analysed' AND `type`='integer_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='total number of sentinel ln analysed' AND `language_tag`=''), '3', '33', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qbcf_tx_breast_diagnostic_events'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qbcf_tx_breast_diagnostic_events' AND `field`='number_of_positive_sentinel_ln_category' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qbcf_number_of_positive_sentinel_ln_category')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='number of positive sentinel ln (category)' AND `language_tag`=''), '3', '34', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qbcf_tx_breast_diagnostic_events'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qbcf_tx_breast_diagnostic_events' AND `field`='er_overall' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qbcf_er_overall')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='er overall  (from path report)' AND `language_tag`=''), '4', '35', 'biomarkers', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qbcf_tx_breast_diagnostic_events'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qbcf_tx_breast_diagnostic_events' AND `field`='er_intensity' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qbcf_er_intensity')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='er intensity' AND `language_tag`=''), '4', '36', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qbcf_tx_breast_diagnostic_events'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qbcf_tx_breast_diagnostic_events' AND `field`='er_percent' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='er percent' AND `language_tag`=''), '4', '37', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qbcf_tx_breast_diagnostic_events'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qbcf_tx_breast_diagnostic_events' AND `field`='pr_overall' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qbcf_pr_overall')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='pr overall (in path report)' AND `language_tag`=''), '4', '38', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qbcf_tx_breast_diagnostic_events'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qbcf_tx_breast_diagnostic_events' AND `field`='pr_intensity' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qbcf_pr_intensity')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='pr intensity' AND `language_tag`=''), '4', '39', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qbcf_tx_breast_diagnostic_events'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qbcf_tx_breast_diagnostic_events' AND `field`='pr_percent' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='pr percent' AND `language_tag`=''), '4', '40', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qbcf_tx_breast_diagnostic_events'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qbcf_tx_breast_diagnostic_events' AND `field`='her2_ihc' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qbcf_her2_ihc')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='her2 ihc' AND `language_tag`=''), '4', '41', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qbcf_tx_breast_diagnostic_events'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qbcf_tx_breast_diagnostic_events' AND `field`='her2_fish' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qbcf_her2_fish')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='her2 fish' AND `language_tag`=''), '4', '42', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qbcf_tx_breast_diagnostic_events'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qbcf_tx_breast_diagnostic_events' AND `field`='her_2_status' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qbcf_her_2_status')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='her 2 status' AND `language_tag`=''), '4', '43', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qbcf_tx_breast_diagnostic_events'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qbcf_tx_breast_diagnostic_events' AND `field`='tnbc' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qbcf_tnbc')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tnbc' AND `language_tag`=''), '4', '44', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qbcf_tx_breast_diagnostic_events'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qbcf_tx_breast_diagnostic_events' AND `field`='number_of_positive_regional_ln_integer_unknown' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qbcf_integer_unknown')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`=''), '3', '29', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qbcf_tx_breast_diagnostic_events'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qbcf_tx_breast_diagnostic_events' AND `field`='total_number_of_regional_ln_analysed_integer_unknown' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qbcf_integer_unknown')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`=''), '3', '30', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qbcf_tx_breast_diagnostic_events'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qbcf_tx_breast_diagnostic_events' AND `field`='number_of_positive_sentinel_ln_integer_unknown' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qbcf_integer_unknown')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`=''), '3', '32', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qbcf_tx_breast_diagnostic_events'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qbcf_tx_breast_diagnostic_events' AND `field`='total_number_of_sentinel_ln_analysed_integer_unknown' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qbcf_integer_unknown')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`=''), '3', '33', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qbcf_tx_breast_diagnostic_events'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qbcf_tx_breast_diagnostic_events' AND `field`='time_to_last_contact_months' AND `type`='integer_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=3' AND `default`='' AND `language_help`='' AND `language_label`='time to last contact/death (months)' AND `language_tag`=''), '1', '13', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qbcf_tx_breast_diagnostic_events'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qbcf_tx_breast_diagnostic_events' AND `field`='time_to_first_progression_months' AND `type`='integer_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=3' AND `default`='' AND `language_help`='' AND `language_label`='time to first progression (months)' AND `language_tag`=''), '1', '13', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO `treatment_controls` (`id`, `tx_method`, `disease_site`, `flag_active`, `detail_tablename`, `detail_form_alias`, `display_order`, `applied_protocol_control_id`, `extended_data_import_process`, `databrowser_label`, `flag_use_for_ccl`, `treatment_extend_control_id`, `use_addgrid`, `use_detail_form_for_index`) VALUES
(null, 'breast diagnostic event', '', 1, 'qbcf_tx_breast_diagnostic_events', 'qbcf_tx_breast_diagnostic_events', 0, null, '', 'breast diagnostic event', 1, null, 0, 0);
INSERT INTO i18n (id,en,fr) VALUES ('breast diagnostic event', 'Breast diagnostic Event', 'Événement de diagnostic du sein');
INSERT INTO structure_validations(structure_field_id, rule) VALUES
((SELECT id FROM structure_fields WHERE `tablename`='qbcf_tx_breast_diagnostic_events' AND `field`='type_of_intervention'), 'notEmpty');

UPDATE structure_formats SET `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qbcf_tx_breast_diagnostic_events' AND `field`='type_of_intervention' AND `type`='select' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='qbcf_type_of_intervention') ) WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qbcf_dx_breasts' AND `field`='type_of_intervention' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qbcf_type_of_intervention') AND `flag_confidential`='0');
UPDATE structure_formats SET `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qbcf_tx_breast_diagnostic_events' AND `field`='type_of_intervention' AND `type`='select' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='qbcf_type_of_intervention')) WHERE structure_id=(SELECT id FROM structures WHERE alias='collections_for_collection_tree_view') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qbcf_dx_breasts' AND `field`='type_of_intervention' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qbcf_type_of_intervention') AND `flag_confidential`='0');
DELETE FROM structure_validations WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE (model='DiagnosisDetail' AND tablename='qbcf_dx_breasts'));
DELETE FROM structure_fields WHERE model='DiagnosisDetail' AND tablename='qbcf_dx_breasts' AND field NOT IN ('laterality');

DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='qbcf_dx_breasts') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='DE-90' AND `plugin`='ClinicalAnnotation' AND `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='age_at_dx' AND `language_label`='age_at_dx' AND `language_tag`='' AND `type`='integer_positive' AND `setting`='size=5' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='help_age at dx' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='locked' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='qbcf_dx_other_cancers') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='DE-90' AND `plugin`='ClinicalAnnotation' AND `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='age_at_dx' AND `language_label`='age_at_dx' AND `language_tag`='' AND `type`='integer_positive' AND `setting`='size=5' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='help_age at dx' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='locked' AND `flag_confidential`='0');

INSERT IGNORE INTO i18n (id,en)
VALUES
("at least one breast diagnostic event date is unknown - the 'time to' values cannot be calculated for 'un-dated' event","At least one breast diagnosis event date is unknown. The 'Time to' values cannot be calculated for 'un-dated' event.");

INSERT INTO structures(`alias`) VALUES ('chus_tx_for_dx_tree_view');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='chus_tx_for_dx_tree_view'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qbcf_tx_breast_diagnostic_events' AND `field`='type_of_intervention' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qbcf_type_of_intervention')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='type of intervention' AND `language_tag`=''), '1', '10', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0');

UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisControl' AND `tablename`='diagnosis_controls' AND `field`='controls_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='diagnosis_type') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='303' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qbcf_tx_breast_diagnostic_events' AND `field`='type_of_intervention' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qbcf_type_of_intervention') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentControl' AND `tablename`='treatment_controls' AND `field`='tx_method' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tx_method_site_list') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='start_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE datamart_browsing_controls
SET flag_active_1_to_2 = 0, flag_active_2_to_1 = 0
WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'ViewCollection') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'TreatmentMaster');






revoir Databrowser Relations Links Summary
ClinicalAnnotation/TreatmentMasters/detail/1/4/ no data for [Generated.qbcf_dx_detail_for_tree_view] lors affichage dx











claculer Time to Last Contact/Death (months) - Time to First Progression (months)	- Her 2 Status - TNBC
en gros un dx = diagnosis date + lateralité
On mais ensuite les tx, biospie, etc... 
Si deux cancer (dx) distant de + de un an warning mais deux cancers... on ajustera a siz mois au besoin





exit ici


update diagnosis_controls SET category = 'secondary - distant' WHERE controls_type IN ('breast progression', 'other cancer progression');

revoir les calculate time to...












créer des secondaire...
Dans le data importer creer des secondary pour la progression...
verifier affichage des aliquot labels des blocks car confidential...
verifier databrowser et reports

mysql -u root qbcf --default-character-set=utf8 < atim_v2.6.0_full_installation.sql
mysql -u root qbcf --default-character-set=utf8 < atim_v2.6.1_upgrade.sql
mysql -u root qbcf --default-character-set=utf8 < atim_v2.6.2_upgrade.sql
mysql -u root qbcf --default-character-set=utf8 < atim_v2.6.3_upgrade.sql
mysql -u root qbcf --default-character-set=utf8 < atim_v2.6.4_upgrade.sql
mysql -u root qbcf --default-character-set=utf8 < atim_v2.6.5_upgrade.sql
mysql -u root qbcf --default-character-set=utf8 < atim_v2.6.6_upgrade.sql
mysql -u root qbcf --default-character-set=utf8 < atim_v2.6.7_upgrade.sql
mysql -u root qbcf --default-character-set=utf8 < custom_post267.sql
mysql -u root qbcf --default-character-set=utf8 < atim_v2.6.8_upgrade.sql
mysql -u root qbcf --default-character-set=utf8 < custom_post268.sql



