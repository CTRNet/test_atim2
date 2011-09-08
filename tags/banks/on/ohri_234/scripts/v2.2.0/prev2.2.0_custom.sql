
-- GRADE FIX : AFTER PROD TO ADD 2/3 GRADE

ALTER TABLE diagnosis_masters
	ADD `ohri_two_tier_grade` varchar(10) NOT NULL DEFAULT '' AFTER `tumour_grade`;

ALTER TABLE diagnosis_masters_revs
	ADD `ohri_two_tier_grade` varchar(10) NOT NULL DEFAULT '' AFTER `tumour_grade`;
	
INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('ohri_two_tier_grade', '', '', NULL);
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES
("low", "low"),
('high', 'high');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) 
VALUES
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_two_tier_grade"),  
(SELECT id FROM structure_permissible_values WHERE value="low" AND language_alias="low"), "0", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ohri_two_tier_grade"),  
(SELECT id FROM structure_permissible_values WHERE value="high" AND language_alias="high"), "3", "1");
	
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`) VALUES
('Clinicalannotation', 'DiagnosisMaster', '', 'ohri_two_tier_grade', '', 'two-tier grade', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='ohri_two_tier_grade') , '');
SET @new_field_id = (SELECT id FROM structure_fields WHERE field = 'ohri_two_tier_grade');
SET @old_field_id = (SELECT id FROM structure_fields WHERE field = 'tumour_grade' and structure_value_domain = (SELECT id FROM structure_value_domains WHERE domain_name='ohri_tumour_grade'));
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, flag_add, flag_add_readonly ,flag_edit,flag_edit_readonly,flag_search,flag_search_readonly,flag_datagrid,flag_datagrid_readonly,flag_index,flag_detail)
(SELECT `structure_id`, @new_field_id, `display_column`, `display_order`, 
flag_add, flag_add_readonly ,flag_edit,flag_edit_readonly,flag_search,flag_search_readonly,flag_datagrid,flag_datagrid_readonly,flag_index,flag_detail FROM structure_formats WHERE structure_id = (SELECT id FROM structures WHERE alias='diagnosismasters')
AND structure_field_id = @old_field_id);

SET @new_field_id = (SELECT id FROM structure_fields WHERE field = 'ohri_two_tier_grade');
SET @old_field_id = (SELECT id FROM structure_fields WHERE field = 'tumour_grade' and structure_value_domain = (SELECT id FROM structure_value_domains WHERE domain_name='ohri_tumour_grade'));
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, flag_add, flag_add_readonly ,flag_edit,flag_edit_readonly,flag_search,flag_search_readonly,flag_datagrid,flag_datagrid_readonly,flag_index,flag_detail)
(SELECT `structure_id`, @new_field_id, `display_column`, `display_order`, 
flag_add, flag_add_readonly ,flag_edit,flag_edit_readonly,flag_search,flag_search_readonly,flag_datagrid,flag_datagrid_readonly,flag_index,flag_detail FROM structure_formats WHERE structure_id IN (SELECT id FROM structures WHERE alias LIKE 'ohri_dx_%')
AND structure_field_id = @old_field_id);

INSERT INTO i18n (id,en,fr) VALUES ('two-tier grade','-','-');

