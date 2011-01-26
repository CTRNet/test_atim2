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

