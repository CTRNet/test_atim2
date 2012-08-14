INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Datamart', '0', '', 'include_tissue_storage_details', 'checkbox', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '0', '', '', '', 'include tissue storage details in the count', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ctrnet_calatogue_submission_file_params'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='include_tissue_storage_details' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='include tissue storage details in the count' AND `language_tag`=''), '0', '6', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');

INSERT IGNORE INTO i18n (id,en,fr) VALUES 
('include tissue storage details in the count','Include tissue storage details in the count','Inclure les détails d''entreposage des tissus dans le décompte'),
('frozen tissue tube','Frozen Tissue Tube','Tube de tissu cogelé');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Datamart', '0', '', 'display_tissue_derivative_count_split_per_nature', 'checkbox', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '0', '', '', '', 'display tissue derivative count split per nature', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ctrnet_calatogue_submission_file_params'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='display_tissue_derivative_count_split_per_nature' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='display tissue derivative count split per nature' AND `language_tag`=''), '0', '7', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');

INSERT IGNORE INTO i18n (id,en,fr) VALUES 
('display tissue derivative count split per nature', 'Display tissue derivatives count split per nature', 'Afficher le décompte des dérivés de tissu par nature');

REPLACE INTO i18n (id,en,fr) VALUES 
('tissue dna','Tissu DNA','ADN de tissu'),
('tissue rna','Tissu RNA','ARN de tissu'),
('tissue cell culture','Tissu Cell Culture','Culture céllulaire de tissu');

UPDATE structure_formats SET `flag_float`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='sample_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='qc_nd_sample_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats SET flag_add= 0,flag_add_readonly= 0,flag_edit= 0,flag_edit_readonly= 0,flag_search= 0,flag_search_readonly= 0,flag_addgrid= 0,flag_addgrid_readonly= 0,flag_editgrid= 0,flag_editgrid_readonly= 0,flag_batchedit= 0,flag_batchedit_readonly= 0,flag_index= 0,flag_detail= 0,flag_summary= 0,flag_float= 0 WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE field = 'sop_master_id');

UPDATE i18n SET fr=en WHERE id like '%trizol%' AND fr = '';
UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='orderitems') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='OrderItem' AND `tablename`='order_items' AND `field`='shipping_name' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
