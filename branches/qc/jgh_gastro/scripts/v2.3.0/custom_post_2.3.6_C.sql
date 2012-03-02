#run after 2.3.6_B
ALTER TABLE qc_gastro_cd_consents
 ADD COLUMN ok_to_recontact CHAR(1) NOT NULL DEFAULT '' AFTER qc_gastro_saliva_col;
ALTER TABLE qc_gastro_cd_consents_revs
 ADD COLUMN ok_to_recontact CHAR(1) NOT NULL DEFAULT '' AFTER qc_gastro_saliva_col;
 
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'ConsentDetail', 'qc_gastro_cd_consents', 'ok_to_recontact', 'yes_no',  NULL , '0', '', '', '', 'ok to recontact', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='qc_gastro_cd_consents'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='qc_gastro_cd_consents' AND `field`='ok_to_recontact' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ok to recontact' AND `language_tag`=''), '2', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0');

REPLACE into i18n (id, en, fr) VALUES
("ok to recontact", "Ok to recontact", "Ok de recontacter");