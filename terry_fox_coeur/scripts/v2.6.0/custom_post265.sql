
-- --------------------------------------------------------------------------------------------------------
-- SPENT TIME FIELDS REVIEW
-- --------------------------------------------------------------------------------------------------------

UPDATE structure_formats SET `flag_detail`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='specimens') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='view_samples' AND `field`='coll_to_rec_spent_time_msg' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0') AND language_label != 'collection to reception spent time (min)';

UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_tf_ad_spec_tiss_tubes') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='rec_to_stor_spent_time_msg' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_tf_ad_spec_tiss_tubes') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='coll_to_stor_spent_time_msg' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_tf_ad_spec_tiss_tubes'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='coll_to_stor_spent_time_msg'), '1', '60', '', '', '1', 'collection to storage spent time (min)', '0', '', '0', '', '1', 'integer_positive', '1', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_tf_ad_spec_tiss_tubes'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='rec_to_stor_spent_time_msg'), '1', '61', '', '', '1', 'reception to storage spent time (min)', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_tf_ad_dna_tubes'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='creat_to_stor_spent_time_msg' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '60', '', '', '1', 'creation to storage spent time (min)', '0', '', '1', '', '1', 'integer_positive', '1', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_tf_ad_dna_tubes'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='coll_to_stor_spent_time_msg' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '59', '', '', '1', 'collection to storage spent time (min)', '0', '', '1', '', '1', 'integer_positive', '1', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_tf_ad_dna_tubes') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='creat_to_stor_spent_time_msg' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0') AND flag_detail = '1';
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_tf_ad_dna_tubes') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='coll_to_stor_spent_time_msg' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0') AND flag_detail = '1';

-- --------------------------------------------------------------------------------------------------------
-- txe_radiations
-- --------------------------------------------------------------------------------------------------------

DROP TABLE txe_radiations;
DROP TABLE txe_radiations_revs;

-- --------------------------------------------------------------------------------------------------------
-- PARTICIPANT IDENTIFIER REPORT
-- --------------------------------------------------------------------------------------------------------

UPDATE datamart_reports SET flag_active = 0 WHERE name = 'participant identifiers';
UPDATE datamart_structure_functions SET flag_active = 0 WHERE link = (SELECT CONCAT('/Datamart/Reports/manageReport/',id) FROM datamart_reports WHERE name = 'participant identifiers');

-- --------------------------------------------------------------------------------------------------------
-- Database clean-up
-- --------------------------------------------------------------------------------------------------------

ALTER TABLE qc_tf_ed_ca125s MODIFY event_master_id int(11) NOT NULL;
ALTER TABLE qc_tf_ed_ca125s ADD CONSTRAINT FK_qc_tf_ed_ca125s_event_masters FOREIGN KEY (event_master_id) REFERENCES event_masters (id);
ALTER TABLE qc_tf_ed_ct_scans MODIFY event_master_id int(11) NOT NULL;
ALTER TABLE qc_tf_ed_ct_scans ADD CONSTRAINT FK_qc_tf_ed_ct_scans_event_masters FOREIGN KEY (event_master_id) REFERENCES event_masters (id);
ALTER TABLE qc_tf_ed_no_details MODIFY event_master_id int(11) NOT NULL;
ALTER TABLE qc_tf_ed_no_details ADD CONSTRAINT FK_qc_tf_ed_no_details_event_masters FOREIGN KEY (event_master_id) REFERENCES event_masters (id);

DROP TABLE tmp_bogus_primary_dx;

-- --------------------------------------------------------------------------------------------------------
-- Report and batch actions
-- --------------------------------------------------------------------------------------------------------

UPDATE datamart_browsing_controls SET flag_active_1_to_2 = 0, flag_active_2_to_1 = 0 WHERE id1 IN (SELECT id FROM datamart_structures WHERE model IN ('AliquotReviewMaster','SpecimenReviewMaster')) OR id2 IN (SELECT id FROM datamart_structures WHERE model IN ('AliquotReviewMaster','SpecimenReviewMaster'));

UPDATE datamart_structure_functions fct, datamart_structures str 
SET fct.flag_active = 0 
WHERE fct.datamart_structure_id = str.id AND str.model IN ('MiscIdentifier', 'ConsentMaster', 'FamilyHistory', 'ParticipantMessage', 'SpecimenReviewMaster', 'ParticipantContact', 'ReproductiveHistory', 'AliquotReviewMaster');

-- --------------------------------------------------------------------------------------------------------
-- structure_permissible_values_custom_controls
-- --------------------------------------------------------------------------------------------------------

UPDATE structure_permissible_values_custom_controls SET category = 'inventory' WHERE name = 'tissue source';

-- --------------------------------------------------------------------------------------------------------
-- inventory configuration
-- --------------------------------------------------------------------------------------------------------

UPDATE parent_to_derivative_sample_controls SET flag_active=false WHERE id IN(193, 200);
UPDATE parent_to_derivative_sample_controls SET flag_active=false WHERE id IN(196, 203, 188, 190, 189, 194);

-- --------------------------------------------------------------------------------------------------------
-- diagnosis review
-- --------------------------------------------------------------------------------------------------------

INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="laterality"), (SELECT id FROM structure_permissible_values WHERE value="bilateral" AND language_alias="bilateral"), "", "1");

-- --------------------------------------------------------------------------------------------------------
-- sample revision
-- --------------------------------------------------------------------------------------------------------

UPDATE structure_formats SET `flag_index`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='specimens') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='view_samples' AND `field`='coll_to_rec_spent_time_msg' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='specimens') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='view_samples' AND `field`='coll_to_rec_spent_time_msg' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE sd_spe_tissues SET tissue_laterality = 'not applicable' WHERE tissue_laterality = 'not applic';
UPDATE sd_spe_tissues_revs SET tissue_laterality = 'not applicable' WHERE tissue_laterality = 'not applic';

UPDATE structure_formats SET `flag_index`='0', `flag_detail`='0' WHERE structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='rec_to_stor_spent_time_msg' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='0' WHERE structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='rec_to_stor_spent_time_msg' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_index`='0', `flag_detail`='0', `flag_search`='0'  WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE `field` LIKE '%_to_%_spent_time_msg');

-- --------------------------------------------------------------------------------------------------------
-- Participant Control Flag
-- --------------------------------------------------------------------------------------------------------

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'Participant', 'participants', 'qc_tf_is_control', 'yes_no',  NULL , '0', '', 'n', '', 'control', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='qc_tf_is_control' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='n' AND `language_help`='' AND `language_label`='control' AND `language_tag`=''), '1', '2', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0');
ALTER TABLE participants ADD COLUMN qc_tf_is_control CHAR(1) DEFAULT 'n';
ALTER TABLE participants_revs ADD COLUMN qc_tf_is_control CHAR(1) DEFAULT 'n';
INSERT INTO i18n(id,en,fr) VALUES ('control', 'Control', '');
