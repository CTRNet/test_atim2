-- TFRI AML/MDS Custom Script
-- Version: v0.9
-- ATiM Version: v2.6.0

-- Update bank name for version tracking during customization
REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('core_installname', 'TFRI MDS/AML Biobank v0.9 DEV', '');


/*
	Queries to fix issues from v2.6 upgrade
	
*/
-- v2.6 Update - Result 1
/*
Result 1 
'----------------------------------------------------------------------------------------------------------'
'Structures & Spent Time Fields to Review'
'Spent time field properties should be consistant with the following example (see array below)'
'\n+--------------------------+-------------+------------------------------+------------------+----------------------------------------+-------------+------------+-------------+----------+-----------+--------------+---------------+----------------+--------------+\n| structure_alias          | model       | field                        | type             | language_label                         | flag_search | flag_index | flag_detail | flag_add | flag_edit | flag_addgrid | flag_editgrid | flag_batchedit | flag_summary |\n+--------------------------+-------------+------------------------------+------------------+----------------------------------------+-------------+------------+-------------+----------+-----------+--------------+---------------+----------------+--------------+\n| ad_der_tubes_incl_ml_vol | ViewAliquot | coll_to_stor_spent_time_msg  | input            | collection to storage spent time       |           0 |          1 |           1 |        0 |         0 |            0 |             0 |              0 |            0 |\n| ad_der_tubes_incl_ml_vol | ViewAliquot | coll_to_stor_spent_time_msg  | integer_positive | collection to storage spent time (min) |           1 |          0 |           0 |        0 |         0 |            0 |             0 |              0 |            0 |\n| ad_der_tubes_incl_ml_vol | ViewAliquot | creat_to_stor_spent_time_msg | input            | creation to storage spent time         |           0 |          1 |           1 |        0 |         0 |            0 |             0 |              0 |            0 |\n| ad_der_tubes_incl_ml_vol | ViewAliquot | creat_to_stor_spent_time_msg | integer_positive | creation to storage spent time (min)   |           1 |          0 |           0 |        0 |         0 |            0 |             0 |              0 |            0 |\n| ad_spec_tubes            | ViewAliquot | coll_to_stor_spent_time_msg  | input            | collection to storage spent time       |           0 |          1 |           1 |        0 |         0 |            0 |             0 |              0 |            0 |\n| ad_spec_tubes            | ViewAliquot | coll_to_stor_spent_time_msg  | integer_positive | collection to storage spent time (min) |           1 |          0 |           0 |        0 |         0 |            0 |             0 |              0 |            0 |\n| ad_spec_tubes            | ViewAliquot | rec_to_stor_spent_time_msg   | input            | reception to storage spent time        |           0 |          1 |           1 |        0 |         0 |            0 |             0 |              0 |            0 |\n| ad_spec_tubes            | ViewAliquot | rec_to_stor_spent_time_msg   | integer_positive | reception to storage spent time (min)  |           1 |          0 |           0 |        0 |         0 |            0 |             0 |              0 |            0 |\n+--------------------------+-------------+------------------------------+------------------+----------------------------------------+-------------+------------+-------------+----------+-----------+--------------+---------------+----------------+--------------+\n'
'Nothing to do if no result in following section'
'----------------------------------------------------------------------------------------------------------'
'specimens.coll_to_rec_spent_time_msg => error = search field issue'
'specimens.coll_to_rec_spent_time_msg => error = search field issue'
'ad_spec_tubes_incl_ml_vol.coll_to_stor_spent_time_msg => error = search field issue'
'ad_spec_tubes_incl_ml_vol.coll_to_stor_spent_time_msg => error = result field issue'
'ad_spec_tubes_incl_ml_vol.rec_to_stor_spent_time_msg => error = search field issue'
'ad_spec_tubes_incl_ml_vol.rec_to_stor_spent_time_msg => error = result field issue'
'----------------------------------------------------------------------------------------------------------'
'Query to use for control if section above is not empty'
'----------------------------------------------------------------------------------------------------------'
SELECT structure_alias, model, field, type, language_label , flag_search, flag_index, flag_detail, flag_add, flag_edit, flag_addgrid, flag_editgrid, flag_batchedit, flag_summary FROM view_structure_formats_simplified WHERE field LIKE '%spent_time_msg' ORDER BY structure_alias, field;

*/

-- v2.6 Update - Result 2 (Disable report for participant identifers)
UPDATE datamart_reports SET flag_active = 0 WHERE name = 'participant identifiers';
UPDATE `datamart_structure_functions` SET `flag_active` = 0 WHERE `link` = (SELECT CONCAT('/Datamart/Reports/manageReport/',id) FROM `datamart_reports` WHERE `name` = 'participant identifiers');


-- v2.6 Update - Result 9: Added new relationsips into databrowser
/*
-- Please flag inactive relationsips if required (see queries below). Don't forget Collection to Annotation, Treatment,Consent, etc if not requried.
SELECT str1.model AS model_1, str2.model AS model_2, use_field FROM datamart_browsing_controls ctrl, datamart_structures str1, datamart_structures str2 WHERE str1.id = ctrl.id1 AND str2.id = ctrl.id2 AND (ctrl.flag_active_1_to_2 = 1 OR ctrl.flag_active_2_to_1 = 1);

UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = 0 WHERE fct.datamart_structure_id = str.id AND/OR str.model IN ('Model1', 'Model2', 'Model...');

-- Please flag inactive datamart structure functions if required (see queries below).
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = 0, flag_active_2_to_1 = 0 WHERE id1 IN (SELECT id FROM datamart_structures WHERE model IN ('Model1', 'Model2', 'Model...')) OR id2 IN (SELECT id FROM datamart_structures WHERE model IN ('Model1', 'Model2', 'Model...'));

-- Please change datamart_structures_relationships_en(and fr).png in appwebrootimgdataBrowser

*/

-- ----------------------------------------------------------------------
-- Eventum ID:3008 S8 Transplant 8.8 and 8.7 
-- ----------------------------------------------------------------------

ALTER TABLE `ed_tfri_clinical_transplant` 
CHANGE COLUMN `graft_manipulation` `graft_manip_not_done` VARCHAR(45) NULL DEFAULT NULL ,
ADD COLUMN `graft_manip_if_other` VARCHAR(100) NULL DEFAULT NULL AFTER `graft_manipulation_other`,
ADD COLUMN `graft_manip_if_tcell` VARCHAR(100) NULL DEFAULT NULL AFTER `graft_manipulation_tcell_other`,
ADD COLUMN `graft_manip_red_cell` VARCHAR(45) NULL DEFAULT NULL AFTER `graft_manip_if_tcell`,
ADD COLUMN `graft_manip_plasma_cell` VARCHAR(45) NULL DEFAULT NULL AFTER `graft_manip_red_cell`,
ADD COLUMN `graft_manip_cryopreserved` VARCHAR(45) NULL DEFAULT NULL AFTER `graft_manip_plasma_cell`;

ALTER TABLE `ed_tfri_clinical_transplant_revs` 
CHANGE COLUMN `graft_manipulation` `graft_manip_not_done` VARCHAR(45) NULL DEFAULT NULL ,
ADD COLUMN `graft_manip_if_other` VARCHAR(100) NULL DEFAULT NULL AFTER `graft_manipulation_other`,
ADD COLUMN `graft_manip_if_tcell` VARCHAR(100) NULL DEFAULT NULL AFTER `graft_manipulation_tcell_other`,
ADD COLUMN `graft_manip_red_cell` VARCHAR(45) NULL DEFAULT NULL AFTER `graft_manip_if_tcell`,
ADD COLUMN `graft_manip_plasma_cell` VARCHAR(45) NULL DEFAULT NULL AFTER `graft_manip_red_cell`,
ADD COLUMN `graft_manip_cryopreserved` VARCHAR(45) NULL DEFAULT NULL AFTER `graft_manip_plasma_cell`;

ALTER TABLE `ed_tfri_clinical_transplant` 
CHANGE COLUMN `agents_received` `agents_received_not_done` VARCHAR(45) NULL DEFAULT NULL ,
ADD COLUMN `agents_received_if_other` VARCHAR(100) NULL DEFAULT NULL AFTER `agents_received_other`,
ADD COLUMN `agents_received_g-csf` VARCHAR(45) NULL DEFAULT NULL AFTER `agents_received_if_other`,
ADD COLUMN `agents_received_mozibil` VARCHAR(45) NULL DEFAULT NULL AFTER `agents_received_g-csf`;

ALTER TABLE `ed_tfri_clinical_transplant_revs` 
CHANGE COLUMN `agents_received` `agents_received_not_done` VARCHAR(45) NULL DEFAULT NULL ,
ADD COLUMN `agents_received_if_other` VARCHAR(100) NULL DEFAULT NULL AFTER `agents_received_other`,
ADD COLUMN `agents_received_g-csf` VARCHAR(45) NULL DEFAULT NULL AFTER `agents_received_if_other`,
ADD COLUMN `agents_received_mozibil` VARCHAR(45) NULL DEFAULT NULL AFTER `agents_received_g-csf`;

-- Fix field name for changed DB field name
UPDATE `structure_fields` SET `field`='graft_manip_not_done' WHERE `field`= 'graft_manipulation';
UPDATE `structure_fields` SET `field`='agents_received_not_done' WHERE `field`= 'agents_received';

-- Reorganize section and change to checkbox
UPDATE structure_fields SET  `type`='checkbox',  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  WHERE model='EventDetail' AND tablename='ed_tfri_clinical_transplant' AND field='graft_manip_not_done' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='tfri_graft_manipulated');
UPDATE structure_fields SET  `type`='checkbox',  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  WHERE model='EventDetail' AND tablename='ed_tfri_clinical_transplant' AND field='agents_received_not_done' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='tfri_agents_received');
UPDATE structure_fields SET  `structure_value_domain`= NULL  WHERE model='EventDetail' AND tablename='ed_tfri_clinical_transplant' AND field='agents_received_other' AND `type`='input' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='tfri_agents_received');
UPDATE structure_fields SET  `structure_value_domain`= NULL  WHERE model='EventDetail' AND tablename='ed_tfri_clinical_transplant' AND field='graft_manipulation_tcell_other' AND `type`='input' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='tfri_agents_received');
UPDATE structure_fields SET  `structure_value_domain`= NULL  WHERE model='EventDetail' AND tablename='ed_tfri_clinical_transplant' AND field='graft_manipulation_other' AND `type`='input' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='tfri_agents_received');

UPDATE structure_formats SET `language_heading`='8.7 graft manipulation' WHERE structure_id=(SELECT id FROM structures WHERE alias='ed_tfri_clinical_transplant') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_transplant' AND `field`='graft_manip_not_done' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='40', `language_heading`='8.8 agents received' WHERE structure_id=(SELECT id FROM structures WHERE alias='ed_tfri_clinical_transplant') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_transplant' AND `field`='agents_received_not_done' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') AND `flag_confidential`='0');

UPDATE structure_fields SET  `type`='checkbox',  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') ,  `setting`='',  `language_label`='agents received other',  `language_tag`='' WHERE model='EventDetail' AND tablename='ed_tfri_clinical_transplant' AND field='agents_received_other' AND `type`='input' AND structure_value_domain  IS NULL ;
UPDATE structure_fields SET  `type`='checkbox',  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') ,  `setting`='',  `language_label`='graft manipulation tcell other',  `language_tag`='' WHERE model='EventDetail' AND tablename='ed_tfri_clinical_transplant' AND field='graft_manipulation_tcell_other' AND `type`='input' AND structure_value_domain  IS NULL ;
UPDATE structure_fields SET  `type`='checkbox',  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') ,  `setting`='',  `language_label`='graft manipulation other',  `language_tag`='' WHERE model='EventDetail' AND tablename='ed_tfri_clinical_transplant' AND field='graft_manipulation_other' AND `type`='input' AND structure_value_domain  IS NULL ;
UPDATE structure_formats SET `display_order`='45' WHERE structure_id=(SELECT id FROM structures WHERE alias='ed_tfri_clinical_transplant') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_transplant' AND `field`='agents_received_other' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='34' WHERE structure_id=(SELECT id FROM structures WHERE alias='ed_tfri_clinical_transplant') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_transplant' AND `field`='graft_manipulation_tcell_other' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='37' WHERE structure_id=(SELECT id FROM structures WHERE alias='ed_tfri_clinical_transplant') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_transplant' AND `field`='graft_manipulation_other' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');


INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_transplant', 'graft_manip_if_tcell', 'input',  NULL , '0', 'size=20', '', '', '', 'graft manip if tcell'), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_transplant', 'graft_manip_if_other', 'input',  NULL , '0', 'size=20', '', '', '', 'graft manip if other');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_transplant'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_transplant' AND `field`='graft_manip_if_tcell' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=20' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='graft manip if tcell'), '1', '35', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_transplant'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_transplant' AND `field`='graft_manip_if_other' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=20' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='graft manip if other'), '1', '38', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
UPDATE structure_formats SET `display_order`='45' WHERE structure_id=(SELECT id FROM structures WHERE alias='ed_tfri_clinical_transplant') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_transplant' AND `field`='agents_received_other' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='34' WHERE structure_id=(SELECT id FROM structures WHERE alias='ed_tfri_clinical_transplant') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_transplant' AND `field`='graft_manipulation_tcell_other' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='37' WHERE structure_id=(SELECT id FROM structures WHERE alias='ed_tfri_clinical_transplant') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_transplant' AND `field`='graft_manipulation_other' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') AND `flag_confidential`='0');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_transplant', 'graft_manip_red_cell', 'checkbox', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '0', '', '', '', 'graft manip red cell', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_transplant', 'graft_manip_plasma_cell', 'checkbox', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '0', '', '', '', 'graft manip plasma cell', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_transplant', 'graft_manip_cryopreserved', 'checkbox', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '0', '', '', '', 'graft manip cryopreserved', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_transplant'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_transplant' AND `field`='graft_manip_red_cell' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='graft manip red cell' AND `language_tag`=''), '1', '31', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_transplant'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_transplant' AND `field`='graft_manip_plasma_cell' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='graft manip plasma cell' AND `language_tag`=''), '1', '32', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_transplant'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_transplant' AND `field`='graft_manip_cryopreserved' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='graft manip cryopreserved' AND `language_tag`=''), '1', '36', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_transplant', 'agents_received_g-csf', 'checkbox', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '0', '', '', '', 'agents received g-csf', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_clinical_transplant', 'agents_received_mozibil', 'checkbox', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '0', '', '', '', 'agents received mozibil', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_transplant'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_transplant' AND `field`='agents_received_g-csf' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='agents received g-csf' AND `language_tag`=''), '1', '41', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_clinical_transplant'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_clinical_transplant' AND `field`='agents_received_mozibil' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='agents received mozibil' AND `language_tag`=''), '1', '42', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
 ('8.7 graft manipulation', '8.7 Was the graft product manipulated?', ''),
 ('8.8 agents received', '8.8 Did the donor receive any agents as part of the donation process?', ''),
 ('graft manipulation', 'Graft manipulation: Not done', ''),
 ('agents received', 'Agents received: None', ''),
 ('graft manipulation other', 'Graft manipulation: Other', ''),
 ('agents received other', 'Agents received: Other', ''),
 ('graft manipulation tcell other', 'Graft manipulation: T-cell depleted', ''),
 ('graft manip if tcell', 'T-cell method', ''),
 ('graft manip if other', 'Graft manipulation, specify other', ''),
 ('graft manip red cell', 'Graft manipulation: Red cell depleted', ''), 
 ('graft manip plasma cell', 'Graft manipulation: Plasma cell depleted', ''), 
 ('graft manip cryopreserved', 'Graft manipulation: Cryopreserved', ''),
 ('agents received g-csf', 'Agents received: G-CSF', ''), 
 ('agents received mozibil', 'Agents received: Mozibil', '');
 
-- ----------------------------------------------------------------------
-- Eventum ID:2885 WBC and Blast Count Units
-- ----------------------------------------------------------------------
 
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("wbc cell count units", "", "", NULL);
INSERT INTO structure_permissible_values (value, language_alias) VALUES("10^9/L", "10^9/L");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="wbc cell count units"), (SELECT id FROM structure_permissible_values WHERE value="10^9/L" AND language_alias="10^9/L"), "1", "1");

INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("blast count units", "", "", NULL);
INSERT INTO structure_permissible_values (value, language_alias) VALUES("10^6/ml", "10^6/ml");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="blast count units"), (SELECT id FROM structure_permissible_values WHERE value="10^6/ml" AND language_alias="10^6/ml"), "1", "1");

UPDATE structure_fields SET  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='wbc cell count units') ,  `default`='10^9/L' WHERE model='SampleDetail' AND tablename='sd_spe_bloods' AND field='tfri_wbc_units' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='tfri cell count');
UPDATE structure_fields SET  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='blast count units') ,  `default`='10^6/ml' WHERE model='SampleDetail' AND tablename='sd_spe_bloods' AND field='tfri_blast_units' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='tfri cell count');

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
 ('10^9/L', '10^9/L', ''),
 ('10^6/ml', '10^6/ml', '');

-- ----------------------------------------------------------------------
-- Eventum ID:3028 Disease Status - MDS
-- ----------------------------------------------------------------------

INSERT INTO `diagnosis_controls` (`category`, `controls_type`, `flag_active`, `detail_form_alias`, `detail_tablename`, `display_order`, `databrowser_label`, `flag_compare_with_cap`) VALUES ('progression', 'disease status mds', '1', 'dx_disease_status_mds', 'dxd_disease_status_mds', '4', 'disease status|mds', '0');

-- Disable all related dx events
UPDATE `diagnosis_controls` SET `flag_active`='0' WHERE `id`='16';
UPDATE `diagnosis_controls` SET `flag_active`='0' WHERE `id`='17';
UPDATE `diagnosis_controls` SET `flag_active`='0' WHERE `id`='18';
UPDATE `diagnosis_controls` SET `flag_active`='0' WHERE `id`='19';

-- Create table and structure
INSERT INTO `structures` (`alias`) VALUES ('dx_disease_status_mds');

CREATE TABLE `dxd_disease_status_mds` (
  `diagnosis_master_id` INT(11) NOT NULL,
  `mds_disease_status` VARCHAR(100) NULL DEFAULT NULL,
  `method_doc_bone_marrow` VARCHAR(45) NULL DEFAULT NULL,
  `method_doc_flow_cytometry` VARCHAR(45) NULL DEFAULT NULL,
  `method_doc_molecular_test` VARCHAR(45) NULL DEFAULT NULL,
  `method_doc_peripheral_cbc` VARCHAR(45) NULL DEFAULT NULL,
  `method_doc_fish` VARCHAR(45) NULL DEFAULT NULL,
  `method_doc_cytogenetics` VARCHAR(45) NULL DEFAULT NULL,
  `method_doc_other` VARCHAR(45) NULL DEFAULT NULL,
  `method_doc_if_other` VARCHAR(100) NULL DEFAULT NULL,    
  `cytogenic_response` VARCHAR(100) NULL DEFAULT NULL,
  INDEX `dxd_status_mds_ibfk_1_idx` (`diagnosis_master_id` ASC),
  CONSTRAINT `dxd_status_mds_ibfk_1`
    FOREIGN KEY (`diagnosis_master_id`)
    REFERENCES `diagnosis_masters` (`id`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT);

CREATE TABLE `dxd_disease_status_mds_revs` (
  `diagnosis_master_id` int(11) NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `mds_disease_status` VARCHAR(100) NULL DEFAULT NULL,
  `method_doc_bone_marrow` VARCHAR(45) NULL DEFAULT NULL,
  `method_doc_flow_cytometry` VARCHAR(45) NULL DEFAULT NULL,
  `method_doc_molecular_test` VARCHAR(45) NULL DEFAULT NULL,
  `method_doc_peripheral_cbc` VARCHAR(45) NULL DEFAULT NULL,
  `method_doc_fish` VARCHAR(45) NULL DEFAULT NULL,
  `method_doc_cytogenetics` VARCHAR(45) NULL DEFAULT NULL,
  `method_doc_other` VARCHAR(45) NULL DEFAULT NULL,
  `method_doc_if_other` VARCHAR(100) NULL DEFAULT NULL,
  `cytogenic_response` VARCHAR(100) NULL DEFAULT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Value domain - MDS disease status options
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("mds_dx_status_options", "", "", NULL);
INSERT INTO structure_permissible_values (value, language_alias) VALUES("persistent disease", "persistent disease");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="mds_dx_status_options"), (SELECT id FROM structure_permissible_values WHERE value="persistent disease" AND language_alias="persistent disease"), "1", "1");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="mds_dx_status_options"), (SELECT id FROM structure_permissible_values WHERE value="stable disease" AND language_alias="stable disease"), "2", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("new complete remission", "new complete remission");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="mds_dx_status_options"), (SELECT id FROM structure_permissible_values WHERE value="new complete remission" AND language_alias="new complete remission"), "3", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("failure", "failure");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="mds_dx_status_options"), (SELECT id FROM structure_permissible_values WHERE value="failure" AND language_alias="failure"), "4", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("ongoing complete remission", "ongoing complete remission");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="mds_dx_status_options"), (SELECT id FROM structure_permissible_values WHERE value="ongoing complete remission" AND language_alias="ongoing complete remission"), "5", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("new relapse after CR or PR", "new relapse after CR or PR");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="mds_dx_status_options"), (SELECT id FROM structure_permissible_values WHERE value="new relapse after CR or PR" AND language_alias="new relapse after CR or PR"), "6", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("new partial remission", "new partial remission");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="mds_dx_status_options"), (SELECT id FROM structure_permissible_values WHERE value="new partial remission" AND language_alias="new partial remission"), "7", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("ongoing relapse (following CR or PR)", "ongoing relapse (following CR or PR)");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="mds_dx_status_options"), (SELECT id FROM structure_permissible_values WHERE value="ongoing relapse (following CR or PR)" AND language_alias="ongoing relapse (following CR or PR)"), "8", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("confirmation of ongoing partial remission", "confirmation of ongoing partial remission");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="mds_dx_status_options"), (SELECT id FROM structure_permissible_values WHERE value="confirmation of ongoing partial remission" AND language_alias="confirmation of ongoing partial remission"), "9", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("disease progression after treatment", "disease progression after treatment");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="mds_dx_status_options"), (SELECT id FROM structure_permissible_values WHERE value="disease progression after treatment" AND language_alias="disease progression after treatment"), "10", "1");

-- Value domain - Cytogenic response
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("mds_cytogenetic_options", "", "", NULL);
INSERT INTO structure_permissible_values (value, language_alias) VALUES("not applicable (no treatment)", "not applicable (no treatment)");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="mds_cytogenetic_options"), (SELECT id FROM structure_permissible_values WHERE value="not applicable (no treatment)" AND language_alias="not applicable (no treatment)"), "1", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("loss of cytogenetic response (following treatment)", "loss of cytogenetic response (following treatment)");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="mds_cytogenetic_options"), (SELECT id FROM structure_permissible_values WHERE value="loss of cytogenetic response (following treatment)" AND language_alias="loss of cytogenetic response (following treatment)"), "2", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("complete response (following treatment)", "complete response (following treatment)");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="mds_cytogenetic_options"), (SELECT id FROM structure_permissible_values WHERE value="complete response (following treatment)" AND language_alias="complete response (following treatment)"), "3", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("additional cytogenetic abnormalities", "additional cytogenetic abnormalities");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="mds_cytogenetic_options"), (SELECT id FROM structure_permissible_values WHERE value="additional cytogenetic abnormalities" AND language_alias="additional cytogenetic abnormalities"), "4", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("partial response (following treatment)", "partial response (following treatment)");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="mds_cytogenetic_options"), (SELECT id FROM structure_permissible_values WHERE value="partial response (following treatment)" AND language_alias="partial response (following treatment)"), "5", "1");



-- ----------------------------------------------------------------------
-- Eventum ID:3027 Disease Status - AML
-- ----------------------------------------------------------------------

INSERT INTO `diagnosis_controls` (`category`, `controls_type`, `flag_active`, `detail_form_alias`, `detail_tablename`, `display_order`, `databrowser_label`, `flag_compare_with_cap`) VALUES ('progression', 'disease status aml', '1', 'dx_disease_status_aml', 'dxd_disease_status_aml', '5', 'disease status|aml', '0');

-- Create table and structure
INSERT INTO `structures` (`alias`) VALUES ('dx_disease_status_aml');

CREATE TABLE `dxd_disease_status_aml` (
  `diagnosis_master_id` INT(11) NOT NULL,
  `aml_disease_status` VARCHAR(100) NULL DEFAULT NULL,
  `method_doc_bone_marrow` VARCHAR(45) NULL DEFAULT NULL,
  `method_doc_fish` VARCHAR(45) NULL DEFAULT NULL,
  `method_doc_molecular_test` VARCHAR(45) NULL DEFAULT NULL,  
  `method_doc_cytogenetics` VARCHAR(45) NULL DEFAULT NULL,  
  `method_doc_flow_cytometry` VARCHAR(45) NULL DEFAULT NULL,  
  `method_doc_peripheral_blood_cbc` VARCHAR(45) NULL DEFAULT NULL,
  `method_doc_other` VARCHAR(45) NULL DEFAULT NULL,  
  `method_doc_if_other` VARCHAR(100) NULL DEFAULT NULL,                  
  `clones_present` VARCHAR(45) NULL DEFAULT NULL,
  INDEX `dxd_status_aml_ibfk_1_idx` (`diagnosis_master_id` ASC),
  CONSTRAINT `dxd_status_aml_ibfk_1`
    FOREIGN KEY (`diagnosis_master_id`)
    REFERENCES `diagnosis_masters` (`id`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT);
    
CREATE TABLE `dxd_disease_status_aml_revs` (
  `diagnosis_master_id` int(11) NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `aml_disease_status` VARCHAR(100) NULL DEFAULT NULL,
  `method_doc_bone_marrow` VARCHAR(45) NULL DEFAULT NULL,
  `method_doc_fish` VARCHAR(45) NULL DEFAULT NULL,
  `method_doc_molecular_test` VARCHAR(45) NULL DEFAULT NULL,  
  `method_doc_cytogenetics` VARCHAR(45) NULL DEFAULT NULL,  
  `method_doc_flow_cytometry` VARCHAR(45) NULL DEFAULT NULL,  
  `method_doc_peripheral_blood_cbc` VARCHAR(45) NULL DEFAULT NULL,
  `method_doc_other` VARCHAR(45) NULL DEFAULT NULL,  
  `method_doc_if_other` VARCHAR(100) NULL DEFAULT NULL,    
  `clones_present` VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;   

-- Value domain - Abnormal clones
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("abnormal_clone_options", "", "", NULL);
INSERT INTO structure_permissible_values (value, language_alias) VALUES("abnormal clone(s) present", "abnormal clone(s) present");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="abnormal_clone_options"), (SELECT id FROM structure_permissible_values WHERE value="abnormal clone(s) present" AND language_alias="abnormal clone(s) present"), "1", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("abnormal closes NOT present", "abnormal closes NOT present");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="abnormal_clone_options"), (SELECT id FROM structure_permissible_values WHERE value="abnormal closes NOT present" AND language_alias="abnormal closes NOT present"), "2", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("not tested on this date", "not tested on this date");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="abnormal_clone_options"), (SELECT id FROM structure_permissible_values WHERE value="not tested on this date" AND language_alias="not tested on this date"), "3", "1");

-- Value domain - AML disease status
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("aml_dx_status_options", "", "", NULL);
INSERT INTO structure_permissible_values (value, language_alias) VALUES("treatment failure", "treatment failure");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="aml_dx_status_options"), (SELECT id FROM structure_permissible_values WHERE value="treatment failure" AND language_alias="treatment failure"), "1", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("new relapse", "new relapse");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="aml_dx_status_options"), (SELECT id FROM structure_permissible_values WHERE value="new relapse" AND language_alias="new relapse"), "2", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("new complete remission (CR)", "new complete remission (CR)");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="aml_dx_status_options"), (SELECT id FROM structure_permissible_values WHERE value="new complete remission (CR)" AND language_alias="new complete remission (CR)"), "3", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("confirmation of ongoing relapse", "confirmation of ongoing relapse");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="aml_dx_status_options"), (SELECT id FROM structure_permissible_values WHERE value="confirmation of ongoing relapse" AND language_alias="confirmation of ongoing relapse"), "4", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("confirmation of ongoing complete remission (CR)", "confirmation of ongoing complete remission (CR)");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="aml_dx_status_options"), (SELECT id FROM structure_permissible_values WHERE value="confirmation of ongoing complete remission (CR)" AND language_alias="confirmation of ongoing complete remission (CR)"), "5", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("persistent disease", "persistent disease");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="aml_dx_status_options"), (SELECT id FROM structure_permissible_values WHERE value="persistent disease" AND language_alias="persistent disease"), "6", "1");


 