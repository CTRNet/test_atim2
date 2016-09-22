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
WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'ViewAliquotUse') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'ViewAliquot');
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
UPDATE datamart_structure_functions SET flag_active = 0 WHERE datamart_structure_id = (SELECT id FROM datamart_structures WHERE model = 'ViewAliquotUse') AND label = 'number of elements per participant';
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
















Reports

Report	Status
All Derivatives Display	active
Bank Activity Report	active
Bank Activity Report (Per Period)	active
CTRNet catalogue	active
Initial Specimens Display	active
List all child storage entities	active
List all related diagnosis	active
Number of elements per participant	active
Participant Identifiers	active
Specimens Collection/Derivatives Creation	active
Structure Functions Summary





INSERT INTO `datamart_reports` (`name`, `description`, `form_alias_for_search`, `form_alias_for_results`, `form_type_for_results`, `function`, `flag_active`, `associated_datamart_structure_id`, limit_access_from_datamart_structrue_function, created_by, modified_by) VALUES
('number of elements per participant', 'number_of_elements_per_participant_description', '', 'number_of_elements_per_participant', 'index', 'countNumberOfElementsPerParticipants', 1, (SELECT id FROM datamart_structures WHERE model = 'Participant'), 1, '1', '1');
SET @control_id = (SELECT id FROM datamart_reports WHERE name = 'number of elements per participant');
INSERT INTO `` (`datamart_structure_id`, `label`, `link`, `flag_active`) 
(SELECT id, 'number of elements per participant', CONCAT('/Datamart/Reports/manageReport\/', @control_id), 1
FROM datamart_structures WHERE model IN ('MiscIdentifier',

UPDATE datamart_structure_functions SET flag_active = 0 WHERE datamart_structure_id = (SELECT id FROM datamart_structures WHERE model = '') AND label = '';


to inactive











































Faire un warning si deux blocs d'une meme bank ont le meme label



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



