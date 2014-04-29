-- EXECUTE AFTER custom_post253.sql

ALTER TABLE procure_ed_lab_pathologies 
  ADD COLUMN  cusm_e_p_ext_apex_right_anterior tinyint(1) DEFAULT '0' AFTER extra_prostatic_extension_apex,
  ADD COLUMN  cusm_e_p_ext_apex_left_anterior tinyint(1) DEFAULT '0' AFTER cusm_e_p_ext_apex_right_anterior,
  ADD COLUMN  cusm_e_p_ext_apex_right_posterior tinyint(1) DEFAULT '0' AFTER cusm_e_p_ext_apex_left_anterior,
  ADD COLUMN  cusm_e_p_ext_apex_left_posterior tinyint(1) DEFAULT '0' AFTER cusm_e_p_ext_apex_right_posterior,

  ADD COLUMN  cusm_e_p_ext_base_right_anterior tinyint(1) DEFAULT '0' AFTER extra_prostatic_extension_base,
  ADD COLUMN  cusm_e_p_ext_base_left_anterior tinyint(1) DEFAULT '0' AFTER cusm_e_p_ext_base_right_anterior,
  ADD COLUMN  cusm_e_p_ext_base_right_posterior tinyint(1) DEFAULT '0' AFTER cusm_e_p_ext_base_left_anterior,
  ADD COLUMN  cusm_e_p_ext_base_left_posterior tinyint(1) DEFAULT '0' AFTER cusm_e_p_ext_base_right_posterior,    

  ADD COLUMN  cusm_e_p_ext_seminal_vesicles_right tinyint(1) DEFAULT '0' AFTER extra_prostatic_extension_seminal_vesicles,
  ADD COLUMN  cusm_e_p_ext_seminal_vesicles_left tinyint(1) DEFAULT '0' AFTER cusm_e_p_ext_seminal_vesicles_right;

ALTER TABLE procure_ed_lab_pathologies_revs 
  ADD COLUMN  cusm_e_p_ext_apex_right_anterior tinyint(1) DEFAULT '0' AFTER extra_prostatic_extension_apex,
  ADD COLUMN  cusm_e_p_ext_apex_left_anterior tinyint(1) DEFAULT '0' AFTER cusm_e_p_ext_apex_right_anterior,
  ADD COLUMN  cusm_e_p_ext_apex_right_posterior tinyint(1) DEFAULT '0' AFTER cusm_e_p_ext_apex_left_anterior,
  ADD COLUMN  cusm_e_p_ext_apex_left_posterior tinyint(1) DEFAULT '0' AFTER cusm_e_p_ext_apex_right_posterior,

  ADD COLUMN  cusm_e_p_ext_base_right_anterior tinyint(1) DEFAULT '0' AFTER extra_prostatic_extension_base,
  ADD COLUMN  cusm_e_p_ext_base_left_anterior tinyint(1) DEFAULT '0' AFTER cusm_e_p_ext_base_right_anterior,
  ADD COLUMN  cusm_e_p_ext_base_right_posterior tinyint(1) DEFAULT '0' AFTER cusm_e_p_ext_base_left_anterior,
  ADD COLUMN  cusm_e_p_ext_base_left_posterior tinyint(1) DEFAULT '0' AFTER cusm_e_p_ext_base_right_posterior,    

  ADD COLUMN  cusm_e_p_ext_seminal_vesicles_right tinyint(1) DEFAULT '0' AFTER extra_prostatic_extension_seminal_vesicles,
  ADD COLUMN  cusm_e_p_ext_seminal_vesicles_left tinyint(1) DEFAULT '0' AFTER cusm_e_p_ext_seminal_vesicles_right;

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', 'procure_ed_lab_pathologies', 'cusm_e_p_ext_apex_left_anterior', 'checkbox',  NULL , '0', '', '', '', 'apex anterior', 'left'), 
('ClinicalAnnotation', 'EventDetail', 'procure_ed_lab_pathologies', 'cusm_e_p_ext_apex_right_anterior', 'checkbox',  NULL , '0', '', '', '', '', 'right'), 
('ClinicalAnnotation', 'EventDetail', 'procure_ed_lab_pathologies', 'cusm_e_p_ext_apex_left_posterior', 'checkbox',  NULL , '0', '', '', '', 'apex posterior', 'left'), 
('ClinicalAnnotation', 'EventDetail', 'procure_ed_lab_pathologies', 'cusm_e_p_ext_apex_right_posterior', 'checkbox',  NULL , '0', '', '', '', '', 'right');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES  
((SELECT id FROM structures WHERE alias='procure_ed_pathology'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_lab_pathologies' AND `field`='cusm_e_p_ext_apex_left_anterior'), '3', '106', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_ed_pathology'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_lab_pathologies' AND `field`='cusm_e_p_ext_apex_right_anterior'), '3', '106', '', '1', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_ed_pathology'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_lab_pathologies' AND `field`='cusm_e_p_ext_apex_left_posterior'), '3', '106', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_ed_pathology'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_lab_pathologies' AND `field`='cusm_e_p_ext_apex_right_posterior'), '3', '106', '', '1', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', 'procure_ed_lab_pathologies', 'cusm_e_p_ext_base_left_anterior', 'checkbox',  NULL , '0', '', '', '', 'base anterior', 'left'), 
('ClinicalAnnotation', 'EventDetail', 'procure_ed_lab_pathologies', 'cusm_e_p_ext_base_right_anterior', 'checkbox',  NULL , '0', '', '', '', '', 'right'), 
('ClinicalAnnotation', 'EventDetail', 'procure_ed_lab_pathologies', 'cusm_e_p_ext_base_left_posterior', 'checkbox',  NULL , '0', '', '', '', 'base posterior', 'left'), 
('ClinicalAnnotation', 'EventDetail', 'procure_ed_lab_pathologies', 'cusm_e_p_ext_base_right_posterior', 'checkbox',  NULL , '0', '', '', '', '', 'right');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='procure_ed_pathology'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_lab_pathologies' AND `field`='cusm_e_p_ext_base_left_anterior'), '3', '107', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_ed_pathology'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_lab_pathologies' AND `field`='cusm_e_p_ext_base_right_anterior'), '3', '107', '', '1', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_ed_pathology'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_lab_pathologies' AND `field`='cusm_e_p_ext_base_left_posterior'), '3', '107', '','0',  '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_ed_pathology'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_lab_pathologies' AND `field`='cusm_e_p_ext_base_right_posterior'), '3', '107', '', '1', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'); 

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', 'procure_ed_lab_pathologies', 'usm_e_p_ext_seminal_vesicles_left', 'checkbox',  NULL , '0', '', '', '', '', 'left'),
('ClinicalAnnotation', 'EventDetail', 'procure_ed_lab_pathologies', 'usm_e_p_ext_seminal_vesicles_right', 'checkbox',  NULL , '0', '', '', '', '', 'right'); 
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES
((SELECT id FROM structures WHERE alias='procure_ed_pathology'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_lab_pathologies' AND `field`='usm_e_p_ext_seminal_vesicles_left' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='left'), '3', '109', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0') ,
((SELECT id FROM structures WHERE alias='procure_ed_pathology'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_lab_pathologies' AND `field`='usm_e_p_ext_seminal_vesicles_right' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='right'), '3', '109', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'); 
UPDATE structure_fields SET field = 'cusm_e_p_ext_seminal_vesicles_right' WHERE field = 'usm_e_p_ext_seminal_vesicles_right';
UPDATE structure_fields SET field = 'cusm_e_p_ext_seminal_vesicles_left' WHERE field = 'usm_e_p_ext_seminal_vesicles_left';

INSERT INTO i18n (id,en,fr) VALUES
("apex anterior","Apex Anterior","Apex Antérieur"),
("apex posterior","Apex Posterior","Apex Postérieur"),
("base anterior","Base Anterior","Base Antérieur"),
("base posterior","Base Posterior","Base Postérieur");

ALTER TABLE procure_ed_lab_pathologies 
  ADD COLUMN  cusm_marg_ext_seminal_vesicles_right tinyint(1) DEFAULT '0' AFTER margins_extensive_base,
  ADD COLUMN  cusm_marg_ext_seminal_vesicles_left tinyint(1) DEFAULT '0' AFTER cusm_marg_ext_seminal_vesicles_right;
ALTER TABLE procure_ed_lab_pathologies_revs
  ADD COLUMN  cusm_marg_ext_seminal_vesicles_right tinyint(1) DEFAULT '0' AFTER margins_extensive_base,
  ADD COLUMN  cusm_marg_ext_seminal_vesicles_left tinyint(1) DEFAULT '0' AFTER cusm_marg_ext_seminal_vesicles_right;
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', 'procure_ed_lab_pathologies', 'cusm_marg_ext_seminal_vesicles_left', 'checkbox',  NULL , '0', '', '', '', 'seminal vesicles', 'left'),
('ClinicalAnnotation', 'EventDetail', 'procure_ed_lab_pathologies', 'cusm_marg_ext_seminal_vesicles_right', 'checkbox',  NULL , '0', '', '', '', '', 'right'); 
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='procure_ed_pathology'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_lab_pathologies' AND `field`='cusm_marg_ext_seminal_vesicles_left'), '3', '90', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_ed_pathology'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_lab_pathologies' AND `field`='cusm_marg_ext_seminal_vesicles_right'), '3', '90', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'); 

SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'laboratory staff');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) 
VALUES 
('jin song chen', 'Jin Song Chen', 'Jin Song Chen', '1', @control_id, NOW(), NOW(), 1, 1),
('lucie hamel', 'Lucie Hamel', 'Lucie Hamel', '1', @control_id, NOW(), NOW(), 1, 1),
('eleonora scarlat', ' Eleonora Scarlata', ' Eleonora Scarlata', '1', @control_id, NOW(), NOW(), 1, 1);
