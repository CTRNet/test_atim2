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
('storage data','Storage Data'),
('TMA label site','TMA Label-Bank'),('tma name central','TMA Name-Central');

INSERT INTO structure_validations(structure_field_id, rule, language_message) 
VALUES
((SELECT id FROM structure_fields WHERE `field`='qbcf_tma_name' AND model = 'StorageMaster'), 'notEmpty', '');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('StorageLayout', 'ViewStorageMaster', '', 'qbcf_tma_name', 'input',  NULL , '0', 'size=20', '', '', 'tma name central', ''), 
('StorageLayout', 'ViewStorageMaster', '', 'qbcf_tma_label_site', 'input',  NULL , '0', 'size=20', '', '', 'TMA label site', ''), 
('StorageLayout', 'ViewStorageMaster', '', 'qbcf_bank_id', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='banks') , '0', '', '', '', 'bank', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='view_storage_masters'), (SELECT id FROM structure_fields WHERE `model`='ViewStorageMaster' AND `tablename`='' AND `field`='qbcf_tma_name' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=20' AND `default`='' AND `language_help`='' AND `language_label`='tma name central' AND `language_tag`=''), '0', '5', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='view_storage_masters'), (SELECT id FROM structure_fields WHERE `model`='ViewStorageMaster' AND `tablename`='' AND `field`='qbcf_tma_label_site' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=20' AND `default`='' AND `language_help`='' AND `language_label`='TMA label site' AND `language_tag`=''), '0', '5', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='view_storage_masters'), (SELECT id FROM structure_fields WHERE `model`='ViewStorageMaster' AND `tablename`='' AND `field`='qbcf_bank_id' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='banks')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='bank' AND `language_tag`=''), '0', '4', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0');

UPDATE structure_formats SET `language_heading`='tma block data' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_storage_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewStorageMaster' AND `tablename`='' AND `field`='qbcf_bank_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='banks') AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='storage data' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_storage_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewStorageMaster' AND `tablename`='view_storage_masters' AND `field`='short_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

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






la version a été loadé vendredi soir... pas de modif depuis



la partie clinique a été validée
il faut valier la partie inventaire. comparer avec les fichier de données...
Checker generated_label_for_display tous les champs.
Faire la migartion.

gérer qbcf_generated_label_for_display
, 
((SELECT id FROM structures WHERE alias='tma_slides'), (SELECT id FROM structure_fields WHERE `model`='Block' AND `tablename`='' AND `field`='qbcf_generated_label_for_display'), '0', '0', 'block', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0')





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



