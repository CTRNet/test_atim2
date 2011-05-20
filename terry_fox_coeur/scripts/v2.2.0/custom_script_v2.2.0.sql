-- run after 2.2.0.
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`) VALUES
('Clinicalannotation', 'DiagnosisDetail', 'qc_tf_dxd_eocs', 'date_of_ca125_progression', 'date of ca125 progression', '', 'date', '', '',  NULL , ''), 
('Clinicalannotation', 'DiagnosisDetail', 'qc_tf_dxd_eocs', 'date_of_ca125_progression_accu', '', 'accuracy', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='datetime_accuracy_indicator') , ''), 
('Clinicalannotation', 'DiagnosisDetail', 'qc_tf_dxd_eocs', 'ca125_progression_time_in_months', 'ca125 progression time in months', '', 'float_positive', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='datetime_accuracy_indicator') , '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='qc_tf_dx_eoc'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_tf_dxd_eocs' AND `field`='date_of_ca125_progression' AND `language_label`='date of ca125 progression' AND `language_tag`='' AND `type`='date' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '16', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='qc_tf_dx_eoc'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_tf_dxd_eocs' AND `field`='date_of_ca125_progression_accu' AND `language_label`='' AND `language_tag`='accuracy' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='datetime_accuracy_indicator')  AND `language_help`=''), '1', '16', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='qc_tf_dx_eoc'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_tf_dxd_eocs' AND `field`='ca125_progression_time_in_months' AND `language_label`='ca125 progression time in months' AND `language_tag`='' AND `type`='float_positive' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='datetime_accuracy_indicator')  AND `language_help`=''), '1', '17', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1');
UPDATE structure_formats SET `display_order`='18' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_tf_dx_eoc') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='DiagnosisDetail' AND tablename='qc_tf_dxd_eocs' AND field='follow_up_from_ovarectomy_in_months' AND type='float_positive' AND structure_value_domain  IS NULL );
UPDATE structure_formats SET `display_order`='19' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_tf_dx_eoc') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='DiagnosisDetail' AND tablename='qc_tf_dxd_eocs' AND field='survival_from_ovarectomy_in_months' AND type='float_positive' AND structure_value_domain  IS NULL );

UPDATE structure_fields SET  `model`='EventDetail',  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_eoc_event_type')  WHERE model='EventMaster' AND tablename='qc_tf_ed_eocs' AND field='m_event_type' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_eoc_event_type');

UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='Participant' AND tablename='participants' AND field='date_of_death' AND type='date' AND structure_value_domain  IS NULL );
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='Participant' AND tablename='participants' AND field='qc_tf_suspected_date_of_death' AND type='date' AND structure_value_domain  IS NULL );

INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('qc_tf_progression_status', '', '', NULL);
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("no", "no");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_progression_status"),  (SELECT id FROM structure_permissible_values WHERE value="no" AND language_alias="no"), "1", "1");

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("yes", "yes");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_progression_status"),  (SELECT id FROM structure_permissible_values WHERE value="yes" AND language_alias="yes"), "1", "1");

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("progressive disease", "progressive disease");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_progression_status"),  (SELECT id FROM structure_permissible_values WHERE value="progressive disease" AND language_alias="progressive disease"), "1", "1");

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("bouncer", "bouncer");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_progression_status"),  (SELECT id FROM structure_permissible_values WHERE value="bouncer" AND language_alias="bouncer"), "1", "1");

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("unknown", "unknown");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_progression_status"),  (SELECT id FROM structure_permissible_values WHERE value="unknown" AND language_alias="unknown"), "1", "1");




INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`) VALUES
('Clinicalannotation', 'DiagnosisDetail', 'qc_tf_dxd_eocs', 'progression_status', 'progression status', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_progression_status') , '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='qc_tf_dx_eoc'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_tf_dxd_eocs' AND `field`='progression_status' AND `language_label`='progression status' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_progression_status')  AND `language_help`=''), '1', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1');

-- db corrections reported by db validation
ALTER TABLE ad_blocks_revs
 ADD qc_tf_flash_frozen_volume VARCHAR(50) NOT NULL DEFAULT '',
 ADD qc_tf_flash_frozen_volume_unit enum('','gr','mm3') NOT NULL DEFAULT '';
 
ALTER TABLE aliquot_review_masters_revs
 CHANGE aliquot_masters_id aliquot_master_id INT DEFAULT NULL;
 
ALTER TABLE qc_tf_dxd_eocs_revs
 ADD date_of_ca125_progression DATE DEFAULT NULL,
 ADD date_of_ca125_progression_accu VARCHAR(1) DEFAULT '',
 ADD ca125_progression_time_in_months FLOAT UNSIGNED DEFAULT NULL;
 
ALTER TABLE qc_tf_ed_other_primary_cancers_revs
 ADD end_date DATE DEFAULT NULL,
 ADD end_date_accuracy VARCHAR(50) NOT NULL DEFAULT '';
 
INSERT INTO i18n (id, en, fr) VALUES
('core_installname', 'The Terry Fox Research Institute - C.O.E.U.R.', "L'Institut de recherche Terry Fox - C.O.E.U.R.");