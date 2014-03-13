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
  `cytogenetic_response` VARCHAR(100) NULL DEFAULT NULL,
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
  `cytogenetic_response` VARCHAR(100) NULL DEFAULT NULL,
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

-- Add fields to form
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'DiagnosisDetail', 'dxd_disease_status_mds', 'mds_disease_status', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='mds_dx_status_options') , '0', '', '', '', 'mds disease status', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'dxd_disease_status_mds', 'cytogenetic_response', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='mds_cytogenetic_options') , '0', '', '', '', 'cytogenetic response', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='dx_disease_status_mds'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_disease_status_mds' AND `field`='mds_disease_status' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='mds_dx_status_options')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='mds disease status' AND `language_tag`=''), '1', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='dx_disease_status_mds'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_disease_status_mds' AND `field`='cytogenetic_response' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='mds_cytogenetic_options')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='cytogenetic response' AND `language_tag`=''), '1', '20', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'DiagnosisDetail', 'dxd_disease_status_mds', 'method_doc_bone_marrow', 'checkbox', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '0', '', '', '', 'method doc bone marrow', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'dxd_disease_status_mds', 'method_doc_flow_cytometry', 'checkbox', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '0', '', '', '', 'method doc flow cytometry', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'dxd_disease_status_mds', 'method_doc_peripheral_cbc', 'checkbox', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '0', '', '', '', 'method doc peripheral cbc', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'dxd_disease_status_mds', 'method_doc_molecular_test', 'checkbox', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '0', '', '', '', 'method doc molecular test', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'dxd_disease_status_mds', 'method_doc_fish', 'checkbox', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '0', '', '', '', 'method doc fish', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'dxd_disease_status_mds', 'method_doc_cytogenetics', 'checkbox', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '0', '', '', '', 'method doc cytogenetics', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'dxd_disease_status_mds', 'method_doc_other', 'checkbox', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '0', '', '', '', 'method doc other', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'dxd_disease_status_mds', 'method_doc_if_other', 'input',  NULL , '0', 'size=25', '', '', '', 'method doc if other');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='dx_disease_status_mds'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_disease_status_mds' AND `field`='method_doc_bone_marrow' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='method doc bone marrow' AND `language_tag`=''), '1', '7', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='dx_disease_status_mds'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_disease_status_mds' AND `field`='method_doc_flow_cytometry' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='method doc flow cytometry' AND `language_tag`=''), '1', '8', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='dx_disease_status_mds'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_disease_status_mds' AND `field`='method_doc_peripheral_cbc' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='method doc peripheral cbc' AND `language_tag`=''), '1', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='dx_disease_status_mds'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_disease_status_mds' AND `field`='method_doc_molecular_test' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='method doc molecular test' AND `language_tag`=''), '1', '11', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='dx_disease_status_mds'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_disease_status_mds' AND `field`='method_doc_fish' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='method doc fish' AND `language_tag`=''), '1', '12', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='dx_disease_status_mds'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_disease_status_mds' AND `field`='method_doc_cytogenetics' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='method doc cytogenetics' AND `language_tag`=''), '1', '13', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='dx_disease_status_mds'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_disease_status_mds' AND `field`='method_doc_other' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='method doc other' AND `language_tag`=''), '1', '14', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='dx_disease_status_mds'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_disease_status_mds' AND `field`='method_doc_if_other' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=25' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='method doc if other'), '1', '15', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');

UPDATE structure_formats SET `language_heading`='12.4 method documentation' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_disease_status_mds') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_disease_status_mds' AND `field`='method_doc_bone_marrow' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') AND `flag_confidential`='0');

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
 ('mds disease status', '12.3 Indicate disease status finding', ''),
 ('method doc bone marrow', 'Bone marrow aspirate & biopsy', ''),
 ('method doc flow cytometry', 'Flow cytometry', ''),
 ('method doc peripheral cbc', 'Peripheral blood (blast count)', ''),
 ('method doc molecular test', 'Molecular test (TP53, FLt-3, etc)', ''),
 ('method doc fish', 'FISH', ''),
 ('method doc cytogenetics', 'Cytogenetics', ''),
 ('method doc other', 'Other method of documentation', ''),
 ('cytogenetic response', '12.5 Indicate status regarding cytogenetic response', ''),
 ('method doc if other', 'Documentation method, if other', ''),
 ('persistent disease', 'Persistent disease', ''),
 ('new complete remission', 'New complete remission', ''),
 ('ongoing complete remission', 'Ongoing complete remission', ''),
 ('new relapse after CR or PR', 'New relapse after CR or PR', ''),
 ('new partial remission', 'New partial remission', ''),
 ('ongoing relapse (following CR or PR)', 'Ongoing relapse (following CR or PR)', ''),
 ('confirmation of ongoing partial remission', 'Confirmation of ongoing partial remission', ''),
 ('disease progression after treatment', 'Disease progression after treatment', ''),
 ('not applicable (no treatment)', 'Not applicable (no treatment)', ''),
 ('loss of cytogenetic response (following treatment)', 'Loss of cytogenetic response (following treatment)', ''),
 ('complete response (following treatment)', 'Complete response (following treatment)', ''),
 ('additional cytogenetic abnormalities', 'Additional cytogenetic abnormalities', ''),
 ('partial response (following treatment)', 'Partial response (following treatment)', ''),
 ('12.4 method documentation', '12.4 Indicate method of documentation', ''),
 ('progression', 'Section 12', ''),
 ('failure', 'Failure', ''),
 ('disease status mds', 'Disease Status (MDS)', '');        


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
-- INSERT INTO structure_permissible_values (value, language_alias) VALUES("persistent disease", "persistent disease");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="aml_dx_status_options"), (SELECT id FROM structure_permissible_values WHERE value="persistent disease" AND language_alias="persistent disease"), "6", "1");

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'DiagnosisDetail', 'dxd_disease_status_aml', 'aml_disease_status', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='aml_dx_status_options') , '0', '', '', '', 'aml disease status', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'dxd_disease_status_aml', 'method_doc_bone_marrow', 'checkbox', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '0', '', '', '', 'method doc bone marrow', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'dxd_disease_status_aml', 'method_doc_fish', 'checkbox', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '0', '', '', '', 'method doc fish', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'dxd_disease_status_aml', 'method_doc_molecular_test', 'checkbox', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '0', '', '', '', 'method doc molecular test', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'dxd_disease_status_aml', 'method_doc_flow_cytometry', 'checkbox', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '0', '', '', '', 'method doc flow cytometry', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'dxd_disease_status_aml', 'method_doc_cytogenetics', 'checkbox', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '0', '', '', '', 'method doc cytogenetics', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'dxd_disease_status_aml', 'method_doc_peripheral_blood_cbc', 'checkbox', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '0', '', '', '', 'method doc peripheral blood cbc', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'dxd_disease_status_aml', 'method_doc_other', 'checkbox', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '0', '', '', '', 'method doc other', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'dxd_disease_status_aml', 'method_doc_if_other', 'input',  NULL , '0', 'size=25', '', '', '', 'method doc if other'), 
('ClinicalAnnotation', 'DiagnosisDetail', 'dxd_disease_status_aml', 'clones_present', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='abnormal_clone_options') , '0', '', '', '', 'clones present', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='dx_disease_status_aml'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_disease_status_aml' AND `field`='aml_disease_status' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aml_dx_status_options')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='aml disease status' AND `language_tag`=''), '1', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='dx_disease_status_aml'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_disease_status_aml' AND `field`='method_doc_bone_marrow' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='method doc bone marrow' AND `language_tag`=''), '1', '7', '11.4 method documentation', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='dx_disease_status_aml'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_disease_status_aml' AND `field`='method_doc_fish' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='method doc fish' AND `language_tag`=''), '1', '8', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='dx_disease_status_aml'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_disease_status_aml' AND `field`='method_doc_molecular_test' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='method doc molecular test' AND `language_tag`=''), '1', '9', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='dx_disease_status_aml'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_disease_status_aml' AND `field`='method_doc_flow_cytometry' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='method doc flow cytometry' AND `language_tag`=''), '1', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='dx_disease_status_aml'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_disease_status_aml' AND `field`='method_doc_cytogenetics' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='method doc cytogenetics' AND `language_tag`=''), '1', '11', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='dx_disease_status_aml'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_disease_status_aml' AND `field`='method_doc_peripheral_blood_cbc' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='method doc peripheral blood cbc' AND `language_tag`=''), '1', '12', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='dx_disease_status_aml'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_disease_status_aml' AND `field`='method_doc_other' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='method doc other' AND `language_tag`=''), '1', '13', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='dx_disease_status_aml'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_disease_status_aml' AND `field`='method_doc_if_other' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=25' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='method doc if other'), '1', '14', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='dx_disease_status_aml'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_disease_status_aml' AND `field`='clones_present' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='abnormal_clone_options')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='clones present' AND `language_tag`=''), '1', '15', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
 ('abnormal clone(s) present', 'Abnormal clone(s) present', ''),
 ('abnormal closes NOT present', 'Abnormal closes NOT present', ''),
 ('not tested on this date', 'Not tested on this date', ''),
 ('treatment failure', 'Treatment failure', ''), 
 ('new relapse', 'New relapse', ''),
 ('new complete remission (CR)', 'New complete remission (CR)', ''), 
 ('confirmation of ongoing relapse', 'Confirmation of ongoing relapse', ''),
 ('confirmation of ongoing complete remission (CR)', 'Confirmation of ongoing complete remission (CR)', ''), 
 ('disease status aml', 'Disease Status (AML)', ''),
 ('aml disease status', '11.3 Indicate disease status finding', ''),
 ('11.4 method documentation', '11.4 Indicate method of documentation', ''),
 ('clones present', '11.5 Were abnormal clones present?', ''),
 ('method doc peripheral blood cbc', 'Peripheral blood CBC', '');
 
-- ----------------------------------------------------------------------
-- Eventum ID:3032 Profile - Reduce size of other fields
-- ---------------------------------------------------------------------- 
UPDATE structure_fields SET `setting`='size=25' WHERE model='Participant' AND tablename='participants' AND field='tfri_aml_other_diagnosis' AND `type`='input' AND structure_value_domain  IS NULL ;
UPDATE structure_fields SET `setting`='size=25' WHERE model='Participant' AND tablename='participants' AND field='tfri_cause_of_death_other' AND `type`='input' AND structure_value_domain  IS NULL ; 

 
-- ----------------------------------------------------------------------
-- Eventum ID:3029 PROFILE - ID validation error
-- ----------------------------------------------------------------------
UPDATE `structure_validations` SET `rule`='range,999,1601' WHERE `structure_field_id`=(SELECT `id` FROM `structure_fields` WHERE `field` = 'participant_identifier' AND `model` = 'Participant') AND `rule` = 'range,999,1600';


-- ----------------------------------------------------------------------
-- Eventum ID:3030 PROFILE - Age at registration validation
-- ----------------------------------------------------------------------
INSERT INTO `structure_validations` (`structure_field_id`, `rule`, `language_message`) VALUES ((SELECT `id` FROM `structure_fields` WHERE `field` = 'tfri_age_at_registration'), 'range,-1,101', 'tfri error age range');

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
 ('tfri error age range', 'Age at registration must be an integer between 0 and 100', '');

 
-- ----------------------------------------------------------------------
-- Eventum ID:3031 Profile - Date changes
-- ---------------------------------------------------------------------- 

-- Change date of acknowledgement to date of enrolment
ALTER TABLE `participants` 
CHANGE COLUMN `tfri_aml_date_acknowledgement` `tfri_aml_date_enrolment_part_2` DATE NULL DEFAULT NULL ;
ALTER TABLE `participants_revs` 
CHANGE COLUMN `tfri_aml_date_acknowledgement` `tfri_aml_date_enrolment_part_2` DATE NULL DEFAULT NULL ;

UPDATE `structure_fields` SET `field`='tfri_aml_date_enrolment_part_2', `language_label`='tfri_aml_date_enrolment_part_2' WHERE `field`='tfri_aml_date_acknowledgement';

UPDATE structure_formats SET `display_column`='2', `display_order`='20', `language_heading`='tfri study acknowledgement' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='tfri_aml_date_registration' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='25' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='tfri_aml_date_day_zero' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='30', `language_heading`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='tfri_aml_date_enrolment_part_2' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
 ('tfri_aml_date_enrolment_part_2', 'Date of Enrolment Part II', ''),    
 ('tfri aml date registration', 'Date of Registration (Enrolment Part I)', '');
 
 
-- ----------------------------------------------------------------------
-- Eventum ID:3035 Study Form FACT-Leu Version 1
-- ----------------------------------------------------------------------

-- Add control rows
INSERT INTO `event_controls` (`disease_site`, `event_group`, `event_type`, `flag_active`, `detail_form_alias`, `detail_tablename`, `display_order`, `databrowser_label`, `flag_use_for_ccl`, `use_addgrid`, `use_detail_form_for_index`) VALUES ('tfri', 'study', 'FACT-Leu', '1', 'ed_tfri_study_fact_leu', 'ed_tfri_study_fact_leu', '2', 'clinical|study|FACT-Leu', '0', '0', '0');
UPDATE `event_controls` SET `event_type`='EQ-5D Health Questionnaire' WHERE `detail_form_alias`='ed_tfri_study_eq_5d_health';

-- Create table
CREATE TABLE `ed_tfri_study_fact_leu` (
  `followup_period` INT(11) DEFAULT NULL,
  `date_completion` DATE DEFAULT NULL,
  `method_of_completion` VARCHAR(50) DEFAULT NULL,
  `phy_lack_energy` INT(11) DEFAULT NULL,
  `phy_nausea` INT(11) DEFAULT NULL,
  `phy_family_needs` INT(11) DEFAULT NULL,
  `phy_pain` INT(11) DEFAULT NULL,
  `phy_bothered_side_effects` INT(11) DEFAULT NULL,
  `phy_ill` INT(11) DEFAULT NULL,
  `phy_forced_bed` INT(11) DEFAULT NULL,
  `well_being_close_friend` INT(11) DEFAULT NULL,
  `well_being_emotional_support` INT(11) DEFAULT NULL,
  `well_being_family_accepted` INT(11) DEFAULT NULL,
  `well_being_family_communication` INT(11) DEFAULT NULL,
  `well_being_partner_closeness` INT(11) DEFAULT NULL,
  `well_being_sex_life_indicator` INT(11) DEFAULT NULL,
  `well_being_satisfied_sex` INT(11) DEFAULT NULL,
  `emotional_feel_sad` INT(11) DEFAULT NULL,
  `emotional_coping` INT(11) DEFAULT NULL,
  `emotional_losing_hope` INT(11) DEFAULT NULL,
  `emotional_nervous` INT(11) DEFAULT NULL,
  `emotional_worry_dying` INT(11) DEFAULT NULL,
  `emotional_condition_worse` INT(11) DEFAULT NULL,
  `functional_able_work` INT(11) DEFAULT NULL,
  `functional_work_fulfilling` INT(11) DEFAULT NULL,
  `functional_enjoy_life` INT(11) DEFAULT NULL,
  `functional_accepted_illness`INT(11) DEFAULT NULL,
  `functional_sleeping_well` INT(11) DEFAULT NULL,
  `functional_enjoy_things_fun` INT(11) DEFAULT NULL,
  `functional_content_life` INT(11) DEFAULT NULL,
  `additional_bothered_fevers` INT(11) DEFAULT NULL,
  `additional_pain_certain_areas` INT(11) DEFAULT NULL,
  `additional_bothered_chills` INT(11) DEFAULT NULL,
  `additional_night_sweats` INT(11) DEFAULT NULL,
  `additional_lumps_swelling` INT(11) DEFAULT NULL,
  `additional_bleed_easily` INT(11) DEFAULT NULL,
  `additional_bruise_easily` INT(11) DEFAULT NULL,
  `additional_weak_all_over` INT(11) DEFAULT NULL,
  `additional_tired_easily` INT(11) DEFAULT NULL,
  `additional_losing_weight` INT(11) DEFAULT NULL,
  `additional_good_appetite` INT(11) DEFAULT NULL,
  `additional_usual_activities` INT(11) DEFAULT NULL,
  `additional_worry_infections` INT(11) DEFAULT NULL,
  `additional_uncertain_future` INT(11) DEFAULT NULL,
  `additional_worry_new_symptoms` INT(11) DEFAULT NULL,
  `additional_emotional_ups_downs` INT(11) DEFAULT NULL,
  `additional_isolated_treatment` INT(11) DEFAULT NULL,
  `event_master_id` int(11) NOT NULL,
  KEY `event_master_id` (`event_master_id`),
  CONSTRAINT `ed_tfri_study_fact_leu_ibfk_1` FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


CREATE TABLE `ed_tfri_study_fact_leu_revs` (
  `followup_period` INT(11) DEFAULT NULL,
  `date_completion` DATE DEFAULT NULL,
  `method_of_completion` VARCHAR(50) DEFAULT NULL,
  `phy_lack_energy` INT(11) DEFAULT NULL,
  `phy_nausea` INT(11) DEFAULT NULL,
  `phy_family_needs` INT(11) DEFAULT NULL,
  `phy_pain` INT(11) DEFAULT NULL,
  `phy_bothered_side_effects` INT(11) DEFAULT NULL,
  `phy_ill` INT(11) DEFAULT NULL,
  `phy_forced_bed` INT(11) DEFAULT NULL,
  `well_being_close_friend` INT(11) DEFAULT NULL,
  `well_being_emotional_support` INT(11) DEFAULT NULL,
  `well_being_family_accepted` INT(11) DEFAULT NULL,
  `well_being_family_communication` INT(11) DEFAULT NULL,
  `well_being_partner_closeness` INT(11) DEFAULT NULL,
  `well_being_sex_life_indicator` INT(11) DEFAULT NULL,
  `well_being_satisfied_sex` INT(11) DEFAULT NULL,
  `emotional_feel_sad` INT(11) DEFAULT NULL,
  `emotional_coping` INT(11) DEFAULT NULL,
  `emotional_losing_hope` INT(11) DEFAULT NULL,
  `emotional_nervous` INT(11) DEFAULT NULL,
  `emotional_worry_dying` INT(11) DEFAULT NULL,
  `emotional_condition_worse` INT(11) DEFAULT NULL,
  `functional_able_work` INT(11) DEFAULT NULL,
  `functional_work_fulfilling` INT(11) DEFAULT NULL,
  `functional_enjoy_life` INT(11) DEFAULT NULL,
  `functional_accepted_illness`INT(11) DEFAULT NULL,
  `functional_sleeping_well` INT(11) DEFAULT NULL,
  `functional_enjoy_things_fun` INT(11) DEFAULT NULL,
  `functional_content_life` INT(11) DEFAULT NULL,
  `additional_bothered_fevers` INT(11) DEFAULT NULL,
  `additional_pain_certain_areas` INT(11) DEFAULT NULL,
  `additional_bothered_chills` INT(11) DEFAULT NULL,
  `additional_night_sweats` INT(11) DEFAULT NULL,
  `additional_lumps_swelling` INT(11) DEFAULT NULL,
  `additional_bleed_easily` INT(11) DEFAULT NULL,
  `additional_bruise_easily` INT(11) DEFAULT NULL,
  `additional_weak_all_over` INT(11) DEFAULT NULL,
  `additional_tired_easily` INT(11) DEFAULT NULL,
  `additional_losing_weight` INT(11) DEFAULT NULL,
  `additional_good_appetite` INT(11) DEFAULT NULL,
  `additional_usual_activities` INT(11) DEFAULT NULL,
  `additional_worry_infections` INT(11) DEFAULT NULL,
  `additional_uncertain_future` INT(11) DEFAULT NULL,
  `additional_worry_new_symptoms` INT(11) DEFAULT NULL,
  `additional_emotional_ups_downs` INT(11) DEFAULT NULL,
  `additional_isolated_treatment` INT(11) DEFAULT NULL, 
  `event_master_id` int(11) NOT NULL,
  KEY `event_master_id` (`event_master_id`),
  CONSTRAINT `ed_tfri_study_fact_leu_ibfk_1` FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- Add structure
INSERT INTO `structures` (`alias`) VALUES ('ed_tfri_study_fact_leu');

-- Value domain
INSERT INTO `structure_value_domains` (`domain_name`) VALUES ('fact-leu_options');

INSERT INTO structure_permissible_values (value, language_alias) VALUES("0", "0 - not at all");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="fact-leu_options"), (SELECT id FROM structure_permissible_values WHERE value="0" AND language_alias="0 - not at all"), "1", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("1", "1 - a little bit");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="fact-leu_options"), (SELECT id FROM structure_permissible_values WHERE value="1" AND language_alias="1 - a little bit"), "2", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("2", "2 - somewhat");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="fact-leu_options"), (SELECT id FROM structure_permissible_values WHERE value="2" AND language_alias="2 - somewhat"), "3", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("3", "3 - quite a bit");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="fact-leu_options"), (SELECT id FROM structure_permissible_values WHERE value="3" AND language_alias="3 - quite a bit"), "4", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("4", "4 - very much");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="fact-leu_options"), (SELECT id FROM structure_permissible_values WHERE value="4" AND language_alias="4 - very much"), "5", "1");

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
 ('0 - not at all', '0 - Not at all', ''),
 ('1 - a little bit', '1 - A little bit', ''),
 ('2 - somewhat', '2 - Somewhat', ''),
 ('3 - quite a bit', '3 - Quite a bit', ''),
 ('4 - very much', '4 - Very much', ''); 

-- Build Form (Physical well-being)
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_study_fact_leu', 'followup_period', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='tfri_followup_period') , '0', '', '', '', 'followup period', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_study_fact_leu', 'phy_lack_energy', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='fact-leu_options') , '0', '', '', '', 'phy lack energy', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_study_fact_leu', 'phy_nausea', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='fact-leu_options') , '0', '', '', '', 'phy nausea', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_study_fact_leu', 'phy_family_needs', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='fact-leu_options') , '0', '', '', '', 'phy family needs', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_study_fact_leu', 'phy_pain', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='fact-leu_options') , '0', '', '', '', 'phy pain', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_study_fact_leu', 'phy_bothered_side_effects', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='fact-leu_options') , '0', '', '', '', 'phy bothered side effects', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_study_fact_leu', 'phy_ill', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='fact-leu_options') , '0', '', '', '', 'phy ill', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_study_fact_leu', 'phy_forced_bed', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='fact-leu_options') , '0', '', '', '', 'phy forced bed', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ed_tfri_study_fact_leu'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_study_fact_leu' AND `field`='followup_period' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tfri_followup_period')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='followup period' AND `language_tag`=''), '1', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_study_fact_leu'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_study_fact_leu' AND `field`='phy_lack_energy' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='fact-leu_options')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='phy lack energy' AND `language_tag`=''), '1', '2', 'physical well-being', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_study_fact_leu'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_study_fact_leu' AND `field`='phy_nausea' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='fact-leu_options')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='phy nausea' AND `language_tag`=''), '1', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_study_fact_leu'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_study_fact_leu' AND `field`='phy_family_needs' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='fact-leu_options')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='phy family needs' AND `language_tag`=''), '1', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_study_fact_leu'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_study_fact_leu' AND `field`='phy_pain' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='fact-leu_options')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='phy pain' AND `language_tag`=''), '1', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_study_fact_leu'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_study_fact_leu' AND `field`='phy_bothered_side_effects' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='fact-leu_options')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='phy bothered side effects' AND `language_tag`=''), '1', '6', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_study_fact_leu'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_study_fact_leu' AND `field`='phy_ill' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='fact-leu_options')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='phy ill' AND `language_tag`=''), '1', '7', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_study_fact_leu'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_study_fact_leu' AND `field`='phy_forced_bed' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='fact-leu_options')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='phy forced bed' AND `language_tag`=''), '1', '8', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
 ('physical well-being', 'PHYSICAL WELL-BEING', ''),
 ('phy lack energy', '(GP1) I have a lack of energy', ''),
 ('phy nausea', '(GP2) I have nausea', ''),
 ('phy family needs', '(GP3) Because of my physical condition, I have trouble meeting the needs of my family', ''),
 ('phy pain', '(GP4) I have pain', ''),
 ('phy bothered side effects', '(GP5) I am bothered by side effects of treatment', ''), 
 ('phy ill', '(GP6) I feel ill', ''),
 ('phy forced bed', '(GP7) I am forced to spend time in bed', '');   
 

-- Build Form (Social well-being)
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_study_fact_leu', 'well_being_close_friend', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='fact-leu_options') , '0', '', '', '', 'well being close friend', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_study_fact_leu', 'well_being_emotional_support_family', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='fact-leu_options') , '0', '', '', '', 'well being emotional support', ''),
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_study_fact_leu', 'well_being_support_friends', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='fact-leu_options') , '0', '', '', '', 'well being support friends', ''),  
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_study_fact_leu', 'well_being_family_accepted', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='fact-leu_options') , '0', '', '', '', 'well being family accepted', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_study_fact_leu', 'well_being_family_communication', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='fact-leu_options') , '0', '', '', '', 'well being family communication', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_study_fact_leu', 'well_being_partner_closeness', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='fact-leu_options') , '0', '', '', '', 'well being partner closeness', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_study_fact_leu', 'well_being_sex_life_indicator', 'checkbox', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '0', '', '', '', 'well being sex life indicator', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_study_fact_leu', 'well_being_satisfied_sex', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='fact-leu_options') , '0', '', '', '', 'well being satisfied sex', '');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ed_tfri_study_fact_leu'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_study_fact_leu' AND `field`='well_being_close_friend' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='fact-leu_options')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='well being close friend' AND `language_tag`=''), '1', '20', 'social family well being', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_study_fact_leu'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_study_fact_leu' AND `field`='well_being_emotional_support_family' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='fact-leu_options')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='well being emotional support' AND `language_tag`=''), '1', '21', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='ed_tfri_study_fact_leu'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_study_fact_leu' AND `field`='well_being_support_friends' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='fact-leu_options')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='well being support friends' AND `language_tag`=''), '1', '22', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_study_fact_leu'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_study_fact_leu' AND `field`='well_being_family_accepted' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='fact-leu_options')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='well being family accepted' AND `language_tag`=''), '1', '23', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_study_fact_leu'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_study_fact_leu' AND `field`='well_being_family_communication' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='fact-leu_options')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='well being family communication' AND `language_tag`=''), '1', '24', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_study_fact_leu'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_study_fact_leu' AND `field`='well_being_partner_closeness' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='fact-leu_options')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='well being partner closeness' AND `language_tag`=''), '1', '25', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_study_fact_leu'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_study_fact_leu' AND `field`='well_being_sex_life_indicator' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='well being sex life indicator' AND `language_tag`=''), '1', '26', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_study_fact_leu'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_study_fact_leu' AND `field`='well_being_satisfied_sex' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='fact-leu_options')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='well being satisfied sex' AND `language_tag`=''), '1', '27', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
 ('social family well being', 'SOCIAL/FAMILY WELL-BEING', ''),
 ('well being close friend', '(GS1) I feel close to my friends', ''),
 ('well being support friends', '(GS2) I get support from my friends', ''),
 ('well being emotional support', '(GS3) I get emotional support from my family', ''),
 ('well being family accepted', '(GS4) My family has accepted my illness', ''),
 ('well being family communication', '(GS5) I am satisfied with family communication about my illness', ''),
 ('well being partner closeness', '(GS6) I feel close to my partner', ''), 
 ('well being sex life indicator', '(Q1) Preferred to not answer sex life satisfaction', ''),
 ('well being satisfied sex', '(GS7) I am satisfied with my sex life', '');    
 
 
-- Build Form (Emotional well-being) 
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_study_fact_leu', 'emotional_feel_sad', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='fact-leu_options') , '0', '', '', '', 'emotional feel sad', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_study_fact_leu', 'emotional_coping', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='fact-leu_options') , '0', '', '', '', 'emotional coping', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_study_fact_leu', 'emotional_losing_hope', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='fact-leu_options') , '0', '', '', '', 'emotional losing hope', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_study_fact_leu', 'emotional_nervous', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='fact-leu_options') , '0', '', '', '', 'emotional nervous', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_study_fact_leu', 'emotional_worry_dying', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='fact-leu_options') , '0', '', '', '', 'emotional worry dying', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_study_fact_leu', 'emotional_condition_worse', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='fact-leu_options') , '0', '', '', '', 'emotional condition worse', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ed_tfri_study_fact_leu'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_study_fact_leu' AND `field`='emotional_feel_sad' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='fact-leu_options')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='emotional feel sad' AND `language_tag`=''), '1', '30', 'emotional well-being', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_study_fact_leu'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_study_fact_leu' AND `field`='emotional_coping' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='fact-leu_options')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='emotional coping' AND `language_tag`=''), '1', '31', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_study_fact_leu'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_study_fact_leu' AND `field`='emotional_losing_hope' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='emotional losing hope' AND `language_tag`=''), '1', '32', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_study_fact_leu'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_study_fact_leu' AND `field`='emotional_nervous' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='fact-leu_options')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='emotional nervous' AND `language_tag`=''), '1', '33', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_study_fact_leu'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_study_fact_leu' AND `field`='emotional_worry_dying' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='fact-leu_options')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='emotional worry dying' AND `language_tag`=''), '1', '34', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_study_fact_leu'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_study_fact_leu' AND `field`='emotional_condition_worse' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='fact-leu_options')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='emotional condition worse' AND `language_tag`=''), '1', '35', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
 ('emotional well-being', 'EMOTIONAL WELL-BEING', ''),
 ('emotional feel sad', '(GE1) I feel sad', ''),
 ('emotional coping', '(GE2) I am satisfied with how I am coping with my illness', ''),
 ('emotional losing hope', '(GE3) I am losing hope in the fight against my illness', ''),
 ('emotional nervous', '(GE4) I feel nervous', ''),
 ('emotional worry dying', '(GE5) I worry about dying', ''),
 ('emotional condition worse', '(GE6) I worry that my condition will get worse', '');

-- Build Form (Functional well-being)
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_study_fact_leu', 'functional_able_work', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='fact-leu_options') , '0', '', '', '', 'functional able work', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_study_fact_leu', 'functional_work_fulfilling', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='fact-leu_options') , '0', '', '', '', 'functional work fulfilling', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_study_fact_leu', 'functional_enjoy_life', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='fact-leu_options') , '0', '', '', '', 'functional enjoy life', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_study_fact_leu', 'functional_accepted_illness', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='fact-leu_options') , '0', '', '', '', 'functional accepted illness', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_study_fact_leu', 'functional_sleeping_well', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='fact-leu_options') , '0', '', '', '', 'functional sleeping well', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_study_fact_leu', 'functional_enjoy_things_fun', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='fact-leu_options') , '0', '', '', '', 'functional enjoy things fun', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_study_fact_leu', 'functional_content_life', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='fact-leu_options') , '0', '', '', '', 'functional content life', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ed_tfri_study_fact_leu'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_study_fact_leu' AND `field`='functional_able_work' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='fact-leu_options')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='functional able work' AND `language_tag`=''), '1', '40', 'functional well-being', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_study_fact_leu'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_study_fact_leu' AND `field`='functional_work_fulfilling' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='fact-leu_options')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='functional work fulfilling' AND `language_tag`=''), '1', '41', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_study_fact_leu'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_study_fact_leu' AND `field`='functional_enjoy_life' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='fact-leu_options')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='functional enjoy life' AND `language_tag`=''), '1', '42', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_study_fact_leu'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_study_fact_leu' AND `field`='functional_accepted_illness' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='fact-leu_options')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='functional accepted illness' AND `language_tag`=''), '1', '45', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_study_fact_leu'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_study_fact_leu' AND `field`='functional_sleeping_well' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='fact-leu_options')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='functional sleeping well' AND `language_tag`=''), '1', '46', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_study_fact_leu'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_study_fact_leu' AND `field`='functional_enjoy_things_fun' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='fact-leu_options')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='functional enjoy things fun' AND `language_tag`=''), '1', '47', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_study_fact_leu'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_study_fact_leu' AND `field`='functional_content_life' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='fact-leu_options')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='functional content life' AND `language_tag`=''), '1', '48', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
 ('functional well-being', 'FUNCTIONAL WELL-BEING', ''),
 ('functional able work', '(GF1) I am able to work (include work at home)', ''),
 ('functional work fulfilling', '(GF2) My work (include work at home) is fulfilling', ''),
 ('functional enjoy life', '(GF3) I am able to enjoy life', ''),
 ('functional accepted illness', '(GF4) I have accepted my illness', ''),
 ('functional sleeping well', '(GF5) I am sleeping well', ''),
 ('functional enjoy things fun', '(GF6) I am enjoying the things I usually do for fun', ''),
 ('functional content life', '(GF7) I am content with the quality of my life right now', '');

-- Build Form (Additional concerns)
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_study_fact_leu', 'additional_bothered_fevers', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='fact-leu_options') , '0', '', '', '', 'additional bothered fevers', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_study_fact_leu', 'additional_pain_certain_areas', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='fact-leu_options') , '0', '', '', '', 'additional pain certain areas', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_study_fact_leu', 'additional_bothered_chills', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='fact-leu_options') , '0', '', '', '', 'additional bothered chills', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_study_fact_leu', 'additional_night_sweats', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='fact-leu_options') , '0', '', '', '', 'additional night sweats', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_study_fact_leu', 'additional_lumps_swelling', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='fact-leu_options') , '0', '', '', '', 'additional lumps swelling', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_study_fact_leu', 'additional_bleed_easily', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='fact-leu_options') , '0', '', '', '', 'additional bleed easily', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_study_fact_leu', 'additional_bruise_easily', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='fact-leu_options') , '0', '', '', '', 'additional bruise easily', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_study_fact_leu', 'additional_weak_all_over', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='fact-leu_options') , '0', '', '', '', 'additional weak all over', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_study_fact_leu', 'additional_tired_easily', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='fact-leu_options') , '0', '', '', '', 'additional tired easily', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_study_fact_leu', 'additional_losing_weight', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='fact-leu_options') , '0', '', '', '', 'additional losing weight', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_study_fact_leu', 'additional_good_appetite', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='fact-leu_options') , '0', '', '', '', 'additional good appetite', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_study_fact_leu', 'additional_usual_activities', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='fact-leu_options') , '0', '', '', '', 'additional usual activities', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_study_fact_leu', 'additional_worry_infections', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='fact-leu_options') , '0', '', '', '', 'additional worry infections', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_study_fact_leu', 'additional_uncertain_future', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='fact-leu_options') , '0', '', '', '', 'additional uncertain future', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_study_fact_leu', 'additional_worry_new_symptoms', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='fact-leu_options') , '0', '', '', '', 'additional worry new symptoms', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_study_fact_leu', 'additional_emotional_ups_downs', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='fact-leu_options') , '0', '', '', '', 'additional emotional ups downs', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_study_fact_leu', 'additional_isolated_treatment', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='fact-leu_options') , '0', '', '', '', 'additional isolated treatment', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_study_fact_leu', 'date_completion', 'date',  NULL , '0', '', '', '', 'date completion', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_study_fact_leu', 'method_of_completion', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='method_of_completion') , '0', '', '', '', 'method of completion', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ed_tfri_study_fact_leu'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_study_fact_leu' AND `field`='additional_bothered_fevers' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='fact-leu_options')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='additional bothered fevers' AND `language_tag`=''), '1', '60', 'additional concerns', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_study_fact_leu'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_study_fact_leu' AND `field`='additional_pain_certain_areas' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='fact-leu_options')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='additional pain certain areas' AND `language_tag`=''), '1', '61', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_study_fact_leu'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_study_fact_leu' AND `field`='additional_bothered_chills' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='fact-leu_options')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='additional bothered chills' AND `language_tag`=''), '1', '62', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_study_fact_leu'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_study_fact_leu' AND `field`='additional_night_sweats' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='fact-leu_options')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='additional night sweats' AND `language_tag`=''), '1', '63', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_study_fact_leu'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_study_fact_leu' AND `field`='additional_lumps_swelling' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='fact-leu_options')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='additional lumps swelling' AND `language_tag`=''), '1', '64', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_study_fact_leu'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_study_fact_leu' AND `field`='additional_bleed_easily' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='fact-leu_options')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='additional bleed easily' AND `language_tag`=''), '1', '65', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_study_fact_leu'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_study_fact_leu' AND `field`='additional_bruise_easily' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='fact-leu_options')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='additional bruise easily' AND `language_tag`=''), '1', '66', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_study_fact_leu'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_study_fact_leu' AND `field`='additional_weak_all_over' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='fact-leu_options')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='additional weak all over' AND `language_tag`=''), '1', '67', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_study_fact_leu'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_study_fact_leu' AND `field`='additional_tired_easily' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='fact-leu_options')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='additional tired easily' AND `language_tag`=''), '1', '68', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_study_fact_leu'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_study_fact_leu' AND `field`='additional_losing_weight' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='fact-leu_options')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='additional losing weight' AND `language_tag`=''), '1', '69', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_study_fact_leu'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_study_fact_leu' AND `field`='additional_good_appetite' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='fact-leu_options')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='additional good appetite' AND `language_tag`=''), '1', '70', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_study_fact_leu'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_study_fact_leu' AND `field`='additional_usual_activities' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='fact-leu_options')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='additional usual activities' AND `language_tag`=''), '1', '71', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_study_fact_leu'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_study_fact_leu' AND `field`='additional_worry_infections' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='fact-leu_options')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='additional worry infections' AND `language_tag`=''), '1', '72', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_study_fact_leu'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_study_fact_leu' AND `field`='additional_uncertain_future' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='fact-leu_options')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='additional uncertain future' AND `language_tag`=''), '1', '73', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_study_fact_leu'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_study_fact_leu' AND `field`='additional_worry_new_symptoms' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='fact-leu_options')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='additional worry new symptoms' AND `language_tag`=''), '1', '74', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_study_fact_leu'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_study_fact_leu' AND `field`='additional_emotional_ups_downs' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='fact-leu_options')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='additional emotional ups downs' AND `language_tag`=''), '1', '75', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_study_fact_leu'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_study_fact_leu' AND `field`='additional_isolated_treatment' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='fact-leu_options')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='additional isolated treatment' AND `language_tag`=''), '1', '76', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_study_fact_leu'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_study_fact_leu' AND `field`='date_completion' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='date completion' AND `language_tag`=''), '1', '80', 'completion details', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_study_fact_leu'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_study_fact_leu' AND `field`='method_of_completion' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='method_of_completion')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='method of completion' AND `language_tag`=''), '1', '81', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
 ('additional bothered fevers', '(BRM3) I am bothered by fevers', ''),
 ('additional pain certain areas', '(PS2) I have certain parts of my body where I experience pain', ''),
 ('additional bothered chills', '(BRM2) I am bothered by the chills', ''),
 ('additional night sweats', '(ES3) I have night sweats', ''),
 ('additional lumps swelling', '(LEU1) I am bothered by lumps or swelling in certain parts of my body', ''),
 ('additional bleed easily', '(TH1) I bleed easily', ''),  
 ('additional bruise easily', '(TH2) I bruise easily', ''),
 ('additional weak all over', '(HI12) I feel weak all over', ''),
 ('additional tired easily', '(BMT6) I get tired easily', ''),  
 ('additional losing weight', '(C2) I am losing weight', ''),
 ('additional good appetite', '(C6) I have a good appetite', ''),
 ('additional usual activities', '(An7) I am able to do my usual activities', ''),  
 ('additional worry infections', '(N3) I worry about getting infections', ''),
 ('additional uncertain future', '(LEU5) I feel uncertain about my future health', ''),
 ('additional worry new symptoms', '(LEU6) I worry that I might get new symptoms of my illness', ''),        
 ('additional emotional ups downs', '(BRM9) I have emotional ups and downs', ''),
 ('additional isolated treatment', '(LEU7) I feel isolated from others because of my illness or treatment', ''),
 ('additional concerns', 'ADDITIONAL CONCERNS', ''), 
 ('completion details', 'COMPLETION DETAILS', '');   
 
 
-- ----------------------------------------------------------------------
-- Eventum ID:3038 Questionnaire form - Baseline costs
-- ----------------------------------------------------------------------

-- Add control rows
INSERT INTO `event_controls` (`disease_site`, `event_group`, `event_type`, `flag_active`, `detail_form_alias`, `detail_tablename`, `display_order`, `databrowser_label`, `flag_use_for_ccl`, `use_addgrid`, `use_detail_form_for_index`) VALUES ('tfri', 'study', 'Baseline-Costs', '1', 'ed_tfri_study_baseline_costs', 'ed_tfri_study_baseline_costs', '3', 'clinical|study|Baseline-Costs', '0', '0', '0');

-- Create table
CREATE TABLE `ed_tfri_study_baseline_costs` (
  `birth_year` INT(11) DEFAULT NULL,
  `birth_month` INT(11) DEFAULT NULL,
  `sex` VARCHAR(10) DEFAULT NULL,
  `working_full_time_start` DATE DEFAULT NULL,
  `working_full_time_end` DATE DEFAULT NULL,
  `working_part_time_start` DATE DEFAULT NULL,
  `working_part_time_end` DATE DEFAULT NULL,
  `volunteer_work_start` DATE DEFAULT NULL,
  `volunteer_work_end` DATE DEFAULT NULL,
  `short_term_disability_source` VARCHAR(50) DEFAULT NULL,
  `short_term_disability_start` DATE DEFAULT NULL,
  `short_term_disability_end` DATE DEFAULT NULL,
  `long_term_disability_source` VARCHAR(50) DEFAULT NULL,
  `long_term_disability_start` DATE DEFAULT NULL,
  `long_term_disability_end` DATE DEFAULT NULL,
  `other_disability_reason` VARCHAR(100) DEFAULT NULL,
  `other_disability_start` DATE DEFAULT NULL,
  `other_disability_end` DATE DEFAULT NULL, 
  `retired_start` DATE DEFAULT NULL,
  `retired_end` DATE DEFAULT NULL,
  `self-employed_start` DATE DEFAULT NULL,
  `self-employed_end` DATE DEFAULT NULL,
  `homemaker_start` DATE DEFAULT NULL,
  `homemaker_end` DATE DEFAULT NULL,
  `not_working_ei_start` DATE DEFAULT NULL,
  `not_working_ei_end` DATE DEFAULT NULL,
  `maternity_leave_start` DATE DEFAULT NULL,
  `maternity_leave_end` DATE DEFAULT NULL,
  `full_time_student_start` DATE DEFAULT NULL,
  `full_time_student_end` DATE DEFAULT NULL,
  `part_time_student_start` DATE DEFAULT NULL,
  `part_time_student_end` DATE DEFAULT NULL,
  `total_income_before_tax` VARCHAR(50) DEFAULT NULL,
  `annual_household_income_before_tax` VARCHAR(50) DEFAULT NULL,
  `num_people_sharing_income` VARCHAR(50) DEFAULT NULL,
  `marital_status` VARCHAR(50) DEFAULT NULL,
  `ethnic_group_aboriginal` VARCHAR(10) DEFAULT NULL,
  `ethnic_group_asian` VARCHAR(10) DEFAULT NULL,
  `ethnic_group_black_african` VARCHAR(10) DEFAULT NULL,
  `ethnic_group_pacific_islander` VARCHAR(10) DEFAULT NULL,
  `ethnic_group_south_asian` VARCHAR(10) DEFAULT NULL,
  `ethnic_group_white` VARCHAR(10) DEFAULT NULL,
  `ethnic_group_decline_or_na` VARCHAR(10) DEFAULT NULL,
  `education_completed_elementary` VARCHAR(10) DEFAULT NULL,
  `education_completed_some_highschool` VARCHAR(10) DEFAULT NULL,
  `education_completed_tech_community_college` VARCHAR(10) DEFAULT NULL,
  `education_completed_some_university` VARCHAR(10) DEFAULT NULL,
  `education_completed_bachelor_degree` VARCHAR(10) DEFAULT NULL,
  `education_completed_highschool_diploma` VARCHAR(10) DEFAULT NULL,
  `education_completed_graduate_degree` VARCHAR(10) DEFAULT NULL,
  `method_completion` VARCHAR(50) DEFAULT NULL,
  `date_of_completion` DATE DEFAULT NULL,
  `event_master_id` int(11) NOT NULL,
  KEY `event_master_id` (`event_master_id`),
  CONSTRAINT `ed_tfri_study_baseline_costs_ibfk_1` FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `ed_tfri_study_baseline_costs_revs` (
  `birth_year` INT(11) DEFAULT NULL,
  `birth_month` INT(11) DEFAULT NULL,
  `sex` VARCHAR(10) DEFAULT NULL,
  `working_full_time_start` DATE DEFAULT NULL,
  `working_full_time_end` DATE DEFAULT NULL,
  `working_part_time_start` DATE DEFAULT NULL,
  `working_part_time_end` DATE DEFAULT NULL,  
  `volunteer_work_start` DATE DEFAULT NULL,
  `volunteer_work_end` DATE DEFAULT NULL,
  `short_term_disability_source` VARCHAR(50) DEFAULT NULL,
  `short_term_disability_start` DATE DEFAULT NULL,
  `short_term_disability_end` DATE DEFAULT NULL,
  `long_term_disability_source` VARCHAR(50) DEFAULT NULL,
  `long_term_disability_start` DATE DEFAULT NULL,
  `long_term_disability_end` DATE DEFAULT NULL,
  `other_disability_reason` VARCHAR(100) DEFAULT NULL,
  `other_disability_start` DATE DEFAULT NULL,
  `other_disability_end` DATE DEFAULT NULL, 
  `retired_start` DATE DEFAULT NULL,
  `retired_end` DATE DEFAULT NULL,
  `self-employed_start` DATE DEFAULT NULL,
  `self-employed_end` DATE DEFAULT NULL,
  `homemaker_start` DATE DEFAULT NULL,
  `homemaker_end` DATE DEFAULT NULL,
  `not_working_ei_start` DATE DEFAULT NULL,
  `not_working_ei_end` DATE DEFAULT NULL,
  `maternity_leave_start` DATE DEFAULT NULL,
  `maternity_leave_end` DATE DEFAULT NULL,
  `full_time_student_start` DATE DEFAULT NULL,
  `full_time_student_end` DATE DEFAULT NULL,
  `part_time_student_start` DATE DEFAULT NULL,
  `part_time_student_end` DATE DEFAULT NULL,
  `total_income_before_tax` VARCHAR(50) DEFAULT NULL,
  `annual_household_income_before_tax` VARCHAR(50) DEFAULT NULL,
  `num_people_sharing_income` VARCHAR(50) DEFAULT NULL,
  `marital_status` VARCHAR(50) DEFAULT NULL,
  `ethnic_group_aboriginal` VARCHAR(10) DEFAULT NULL,
  `ethnic_group_asian` VARCHAR(10) DEFAULT NULL,
  `ethnic_group_black_african` VARCHAR(10) DEFAULT NULL,
  `ethnic_group_pacific_islander` VARCHAR(10) DEFAULT NULL,
  `ethnic_group_south_asian` VARCHAR(10) DEFAULT NULL,
  `ethnic_group_white` VARCHAR(10) DEFAULT NULL,
  `ethnic_group_decline_or_na` VARCHAR(10) DEFAULT NULL,
  `education_completed_elementary` VARCHAR(10) DEFAULT NULL,
  `education_completed_some_highschool` VARCHAR(10) DEFAULT NULL,
  `education_completed_tech_community_college` VARCHAR(10) DEFAULT NULL,
  `education_completed_some_university` VARCHAR(10) DEFAULT NULL,
  `education_completed_bachelor_degree` VARCHAR(10) DEFAULT NULL,
  `education_completed_highschool_diploma` VARCHAR(10) DEFAULT NULL,
  `education_completed_graduate_degree` VARCHAR(10) DEFAULT NULL,
  `method_completion` VARCHAR(50) DEFAULT NULL,
  `date_of_completion` DATE DEFAULT NULL,
  `event_master_id` int(11) NOT NULL,
  KEY `event_master_id` (`event_master_id`),
  CONSTRAINT `ed_tfri_study_baseline_costs_ibfk_1` FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Add structures
INSERT INTO `structures` (`alias`) VALUES ('ed_tfri_study_baseline_costs');

-- Value domain (disability source options)
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("disability_source_options", "", "", NULL);
INSERT INTO structure_permissible_values (value, language_alias) VALUES("cpp/federal", "cpp/federal");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="disability_source_options"), (SELECT id FROM structure_permissible_values WHERE value="cpp/federal" AND language_alias="cpp/federal"), "1", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("provincial", "provincial");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="disability_source_options"), (SELECT id FROM structure_permissible_values WHERE value="provincial" AND language_alias="provincial"), "2", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("employer", "employer");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="disability_source_options"), (SELECT id FROM structure_permissible_values WHERE value="employer" AND language_alias="employer"), "3", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("don\'t know", "don\'t know");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="disability_source_options"), (SELECT id FROM structure_permissible_values WHERE value="don\'t know" AND language_alias="don\'t know"), "4", "1");

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
 ('cpp/federal', 'CPP/Federal', ''),
 ('provincial', 'Provincial', ''),
 ('employer', 'Employer', ''),
 ("don\'t know", "Don\'t know", '');

-- Value domain (Annual income options)
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("annual_income_options", "", "", NULL);
INSERT INTO structure_permissible_values (value, language_alias) VALUES("less than $5000", "less than $5000");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="annual_income_options"), (SELECT id FROM structure_permissible_values WHERE value="less than $5000" AND language_alias="less than $5000"), "1", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("$5,000 - $9,990", "$5,000 - $9,990");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="annual_income_options"), (SELECT id FROM structure_permissible_values WHERE value="$5,000 - $9,990" AND language_alias="$5,000 - $9,990"), "2", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("$10,000 - $19,999", "$10,000 - $19,999");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="annual_income_options"), (SELECT id FROM structure_permissible_values WHERE value="$10,000 - $19,999" AND language_alias="$10,000 - $19,999"), "3", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("$20,000 - $29,999", "$20,000 - $29,999");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="annual_income_options"), (SELECT id FROM structure_permissible_values WHERE value="$20,000 - $29,999" AND language_alias="$20,000 - $29,999"), "4", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("$30,000 - $39,999", "$30,000 - $39,999");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="annual_income_options"), (SELECT id FROM structure_permissible_values WHERE value="$30,000 - $39,999" AND language_alias="$30,000 - $39,999"), "5", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("$40,000 - $49,999", "$40,000 - $49,999");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="annual_income_options"), (SELECT id FROM structure_permissible_values WHERE value="$40,000 - $49,999" AND language_alias="$40,000 - $49,999"), "6", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("$50,000 - $59,999", "$50,000 - $59,999");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="annual_income_options"), (SELECT id FROM structure_permissible_values WHERE value="$50,000 - $59,999" AND language_alias="$50,000 - $59,999"), "7", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("$60,000 - $69,999", "$60,000 - $69,999");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="annual_income_options"), (SELECT id FROM structure_permissible_values WHERE value="$60,000 - $69,999" AND language_alias="$60,000 - $69,999"), "8", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("$70,000 - $79,999", "$70,000 - $79,999");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="annual_income_options"), (SELECT id FROM structure_permissible_values WHERE value="$70,000 - $79,999" AND language_alias="$70,000 - $79,999"), "9", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("$80,000 - $89,999", "$80,000 - $89,999");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="annual_income_options"), (SELECT id FROM structure_permissible_values WHERE value="$80,000 - $89,999" AND language_alias="$80,000 - $89,999"), "10", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("$90,000 - $99,999", "$90,000 - $99,999");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="annual_income_options"), (SELECT id FROM structure_permissible_values WHERE value="$90,000 - $99,999" AND language_alias="$90,000 - $99,999"), "11", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("$100,000 - $124,999", "$100,000 - $124,99");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="annual_income_options"), (SELECT id FROM structure_permissible_values WHERE value="$100,000 - $124,999" AND language_alias="$100,000 - $124,999"), "12", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("more than $125,000", "more than $125,000");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="annual_income_options"), (SELECT id FROM structure_permissible_values WHERE value="more than $125,00" AND language_alias="more than $125,00"), "13", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("do not wish to answer", "do not wish to answer");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="annual_income_options"), (SELECT id FROM structure_permissible_values WHERE value="do not wish to answer" AND language_alias="do not wish to answer"), "14", "1");

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
 ('less than $5000', 'Less than $5000', ''),
 ('$5,000 - $9,990', '$5,000 - $9,990', ''),
 ('$10,000 - $19,999', '$10,000 - $19,999', ''),
 ('$20,000 - $29,999', '$20,000 - $29,999', ''),
 ('$30,000 - $39,999', '$30,000 - $39,999', ''),
 ('$40,000 - $49,999', '$40,000 - $49,999', ''),
 ('$50,000 - $59,999', '$50,000 - $59,999', ''), 
 ('$60,000 - $69,999', '$60,000 - $69,999', ''), 
 ('$70,000 - $79,999', '$70,000 - $79,999', ''), 
 ('$80,000 - $89,999', '$80,000 - $89,999', ''),   
 ('$90,000 - $99,999', '$90,000 - $99,999', ''), 
 ('$100,000 - $124,999', '$100,000 - $124,999', ''), 
 ('more than $125,000', 'More than $125,000', ''), 
 ('do not wish to answer', 'Do not wish to answer', '');

-- Value domain (Household numbers)
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("num_household_options", "", "", NULL);
INSERT INTO structure_permissible_values (value, language_alias) VALUES("live alone", "live alone");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="num_household_options"), (SELECT id FROM structure_permissible_values WHERE value="live alone" AND language_alias="live alone"), "1", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("myself and one other", "myself and one other");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="num_household_options"), (SELECT id FROM structure_permissible_values WHERE value="myself and one other" AND language_alias="myself and one other"), "2", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("2 others", "2 others");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="num_household_options"), (SELECT id FROM structure_permissible_values WHERE value="2 others" AND language_alias="2 others"), "3", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("3 others", "3 others");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="num_household_options"), (SELECT id FROM structure_permissible_values WHERE value="3 others" AND language_alias="3 others"), "4", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("more than 3 others", "more than 3 others");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="num_household_options"), (SELECT id FROM structure_permissible_values WHERE value="more than 3 others" AND language_alias="more than 3 others"), "5", "1");

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
 ('live alone', 'Live alone', ''), 
 ('myself and one other', 'Myself and one other', ''),   
 ('2 others', '2 others', ''), 
 ('3 others', '3 others', ''), 
 ('more than 3 others', 'More than 3 others', ''); 

-- Value domain (Marital status)
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("martial_status_options", "", "", NULL);
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="martial_status_options"), (SELECT id FROM structure_permissible_values WHERE value="married" AND language_alias="married"), "1", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("living as married or common-law", "living as married or common-law");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="martial_status_options"), (SELECT id FROM structure_permissible_values WHERE value="living as married or common-law" AND language_alias="living as married or common-law"), "2", "1");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="martial_status_options"), (SELECT id FROM structure_permissible_values WHERE value="divorced" AND language_alias="divorced"), "3", "1");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="martial_status_options"), (SELECT id FROM structure_permissible_values WHERE value="single" AND language_alias="single"), "4", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("widowed", "widowed");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="martial_status_options"), (SELECT id FROM structure_permissible_values WHERE value="widowed" AND language_alias="widowed"), "5", "1");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="martial_status_options"), (SELECT id FROM structure_permissible_values WHERE value="separated" AND language_alias="separated"), "6", "1");

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
 ('married', 'Married', ''), 
 ('living as married or common-law', 'Living as Married or with a Common-law partner', ''),   
 ('divorced', 'Divorced', ''), 
 ('single', 'Single', ''), 
 ('widowed', 'Widowed', ''), 
 ('separated', 'Separated but still legally married', '');


-- Build form (Page 1)
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_study_baseline_costs', 'working_full_time_start', 'date',  NULL , '0', '', '', '', 'working full time start', ''),
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_study_baseline_costs', 'working_part_time_start', 'date',  NULL , '0', '', '', '', 'working part time start', ''),
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_study_baseline_costs', 'working_part_time_end', 'date',  NULL , '0', '', '', '', 'working part time end', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_study_baseline_costs', 'volunteer_work_end', 'date',  NULL , '0', '', '', '', '', 'volunteer work end'), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_study_baseline_costs', 'working_full_time_end', 'date',  NULL , '0', '', '', '', '', 'working full time end'), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_study_baseline_costs', 'volunteer_work_start', 'date',  NULL , '0', '', '', '', 'volunteer work start', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_study_baseline_costs', 'short_term_disability_source', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='disability_source_options') , '0', '', '', '', 'short term disability source', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_study_baseline_costs', 'short_term_disability_start', 'date',  NULL , '0', '', '', '', 'short term disability start', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_study_baseline_costs', 'short_term_disability_end', 'date',  NULL , '0', '', '', '', '', 'short term disability end'), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_study_baseline_costs', 'long_term_disability_start', 'date',  NULL , '0', '', '', '', 'long term disability start', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_study_baseline_costs', 'long_term_disability_end', 'date',  NULL , '0', '', '', '', '', 'long term disability end'), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_study_baseline_costs', 'long_term_disability_source', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='disability_source_options') , '0', '', '', '', 'long term disability source', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_study_baseline_costs', 'other_disability_start', 'date',  NULL , '0', '', '', '', 'other disability start', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_study_baseline_costs', 'other_disability_end', 'date',  NULL , '0', '', '', '', '', 'other disability end'), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_study_baseline_costs', 'other_disability_reason', 'input',  NULL , '0', 'size=25', '', '', 'other disability reason', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_study_baseline_costs', 'retired_start', 'date',  NULL , '0', '', '', '', 'retired start', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_study_baseline_costs', 'retired_end', 'date',  NULL , '0', '', '', '', '', 'retired end'), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_study_baseline_costs', 'self-employed_start', 'date',  NULL , '0', '', '', '', 'self-employed start', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_study_baseline_costs', 'self-employed_end', 'date',  NULL , '0', '', '', '', '', 'self-employed end'), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_study_baseline_costs', 'homemaker_start', 'date',  NULL , '0', '', '', '', 'homemaker start', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_study_baseline_costs', 'homemaker_end', 'date',  NULL , '0', '', '', '', '', 'homemaker end'), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_study_baseline_costs', 'not_working_ei_start', 'date',  NULL , '0', '', '', '', 'not working ei start', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_study_baseline_costs', 'not_working_ei_end', 'date',  NULL , '0', '', '', '', '', 'not working ei end'), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_study_baseline_costs', 'maternity_leave_start', 'date',  NULL , '0', '', '', '', 'maternity leave start', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_study_baseline_costs', 'maternity_leave_end', 'date',  NULL , '0', '', '', '', '', 'maternity leave end'), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_study_baseline_costs', 'full_time_student_start', 'date',  NULL , '0', '', '', '', 'full time student start', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_study_baseline_costs', 'full_time_student_end', 'date',  NULL , '0', '', '', '', '', 'full time student end'), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_study_baseline_costs', 'part_time_student_start', 'date',  NULL , '0', '', '', '', 'part time student start', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_study_baseline_costs', 'part_time_student_end', 'date',  NULL , '0', '', '', '', '', 'part time student end');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ed_tfri_study_baseline_costs'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_study_baseline_costs' AND `field`='working_full_time_start' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='working full time start' AND `language_tag`=''), '1', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_study_baseline_costs'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_study_baseline_costs' AND `field`='working_part_time_start' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='working part time start' AND `language_tag`=''), '1', '8', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='ed_tfri_study_baseline_costs'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_study_baseline_costs' AND `field`='working_part_time_end' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='working part time end' AND `language_tag`=''), '1', '9', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),  
((SELECT id FROM structures WHERE alias='ed_tfri_study_baseline_costs'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_study_baseline_costs' AND `field`='volunteer_work_end' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='volunteer work end'), '1', '13', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_study_baseline_costs'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_study_baseline_costs' AND `field`='working_full_time_end' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='working full time end'), '1', '6', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_study_baseline_costs'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_study_baseline_costs' AND `field`='volunteer_work_start' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='volunteer work start' AND `language_tag`=''), '1', '12', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_study_baseline_costs'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_study_baseline_costs' AND `field`='short_term_disability_source' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='disability_source_options')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='short term disability source' AND `language_tag`=''), '1', '16', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_study_baseline_costs'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_study_baseline_costs' AND `field`='short_term_disability_start' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='short term disability start' AND `language_tag`=''), '1', '14', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_study_baseline_costs'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_study_baseline_costs' AND `field`='short_term_disability_end' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='short term disability end'), '1', '15', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_study_baseline_costs'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_study_baseline_costs' AND `field`='long_term_disability_start' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='long term disability start' AND `language_tag`=''), '1', '17', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_study_baseline_costs'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_study_baseline_costs' AND `field`='long_term_disability_end' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='long term disability end'), '1', '18', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_study_baseline_costs'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_study_baseline_costs' AND `field`='long_term_disability_source' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='disability_source_options')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='long term disability source' AND `language_tag`=''), '1', '19', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_study_baseline_costs'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_study_baseline_costs' AND `field`='other_disability_start' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='other disability start' AND `language_tag`=''), '1', '20', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_study_baseline_costs'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_study_baseline_costs' AND `field`='other_disability_end' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='other disability end'), '1', '21', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_study_baseline_costs'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_study_baseline_costs' AND `field`='other_disability_reason' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=25' AND `default`='' AND `language_help`='' AND `language_label`='other disability reason' AND `language_tag`=''), '1', '22', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_study_baseline_costs'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_study_baseline_costs' AND `field`='retired_start' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='retired start' AND `language_tag`=''), '1', '30', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_study_baseline_costs'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_study_baseline_costs' AND `field`='retired_end' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='retired end'), '1', '31', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_study_baseline_costs'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_study_baseline_costs' AND `field`='self-employed_start' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='self-employed start' AND `language_tag`=''), '1', '35', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_study_baseline_costs'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_study_baseline_costs' AND `field`='self-employed_end' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='self-employed end'), '1', '36', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_study_baseline_costs'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_study_baseline_costs' AND `field`='homemaker_start' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='homemaker start' AND `language_tag`=''), '1', '40', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_study_baseline_costs'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_study_baseline_costs' AND `field`='homemaker_end' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='homemaker end'), '1', '41', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_study_baseline_costs'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_study_baseline_costs' AND `field`='not_working_ei_start' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='not working ei start' AND `language_tag`=''), '1', '42', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_study_baseline_costs'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_study_baseline_costs' AND `field`='not_working_ei_end' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='not working ei end'), '1', '43', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_study_baseline_costs'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_study_baseline_costs' AND `field`='maternity_leave_start' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='maternity leave start' AND `language_tag`=''), '1', '44', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_study_baseline_costs'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_study_baseline_costs' AND `field`='maternity_leave_end' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='maternity leave end'), '1', '45', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_study_baseline_costs'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_study_baseline_costs' AND `field`='full_time_student_start' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='full time student start' AND `language_tag`=''), '1', '46', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_study_baseline_costs'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_study_baseline_costs' AND `field`='full_time_student_end' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='full time student end'), '1', '47', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_study_baseline_costs'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_study_baseline_costs' AND `field`='part_time_student_start' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='part time student start' AND `language_tag`=''), '1', '50', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_study_baseline_costs'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_study_baseline_costs' AND `field`='part_time_student_end' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='part time student end'), '1', '51', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
 ('working full time start', 'a) Working a full-time (>=35 hours per week). Start date', ''),
 ('working part time start', 'b) Working a part-time (1-34 hours per week) paying job. Start date', ''),
 ('working part time end', 'End date', ''),
 ('volunteer work end', 'End date', ''),
 ('working full time end', 'End date', ''),
 ('volunteer work start', 'c) Volunteer work. Start date', ''),
 ('short term disability source', 'Short-term disability source', ''),
 ('short term disability start', 'd) Short-term disability for your current health condition. Start date', ''),
 ('short term disability end', 'End date', ''),
 ('long term disability source', 'Long-term disability source', ''),
 ('long term disability start', 'e) Long-term disability for your current health condition. Start date', ''),
 ('long term disability end', 'End date', ''),
 ('other disability start', 'f) Disability for another reason. Start date', ''),
 ('other disability end', 'End date', ''),
 ('other disability reason', 'Specify other reason', ''),
 ('retired start', 'g) Retired start date', ''),
 ('retired end', 'End date', ''),
 ('self-employed start', 'h) Self-employed start date', ''),
 ('self-employed end', 'End date', ''),
 ('homemaker start', 'i) Homemaker start date', ''), 
 ('homemaker end', 'End date', ''),
 ('not working ei start', 'j) Not working and on EI. Start date', ''),
 ('not working ei end', 'End date', ''),
 ('not working without ei start', 'k) Not working without EI. Start date', ''),
 ('not working without ei end', 'End date', ''),
 ('maternity leave start', 'l) Maternity leave. Start date', ''),
 ('maternity leave end', 'End date', ''),
 ('full time student start', 'm) Full-time student. Start date', ''), 
 ('full time student end', 'End date', ''),
 ('part time student start', 'n) Part-time student. Start date', ''),
 ('part time student end', 'End date', '');
 
-- Build form (Page 2)
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_study_baseline_costs', 'total_income_before_tax', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='annual_income_options') , '0', '', '', '', 'total income before tax', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_study_baseline_costs', 'annual_household_income_before_tax', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='annual_income_options') , '0', '', '', '', 'annual household income before tax', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_study_baseline_costs', 'num_people_sharing_income', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='num_household_options') , '0', '', '', '', 'num people sharing income', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_study_baseline_costs', 'marital_status', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='martial_status_options') , '0', '', '', '', 'marital status', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_study_baseline_costs', 'ethnic_group_aboriginal', 'checkbox', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '0', '', '', '', 'ethnic group aboriginal', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_study_baseline_costs', 'ethnic_group_asian', 'checkbox', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '0', '', '', '', '', 'ethnic group asian'), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_study_baseline_costs', 'ethnic_group_black_african', 'checkbox', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '0', '', '', '', 'ethnic group black african', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_study_baseline_costs', 'ethnic_group_pacific_islander', 'checkbox', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '0', '', '', '', '', 'ethnic group pacific islander'), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_study_baseline_costs', 'ethnic_group_south_asian', 'checkbox', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '0', '', '', '', 'ethnic group south asian', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_study_baseline_costs', 'ethnic_group_white', 'checkbox', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '0', '', '', '', '', 'ethnic group white'), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_study_baseline_costs', 'ethnic_group_decline_or_na', 'checkbox', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '0', '', '', '', 'ethnic group decline or na', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_study_baseline_costs', 'education_completed_elementary', 'checkbox', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '0', '', '', '', 'education completed elementary', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_study_baseline_costs', 'education_completed_some_highschool', 'checkbox', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '0', '', '', '', '', 'education completed some highschool'), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_study_baseline_costs', 'education_completed_tech_community_college', 'checkbox', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '0', '', '', '', 'education completed tech community college', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_study_baseline_costs', 'education_completed_some_university', 'checkbox', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '0', '', '', '', '', 'education completed some university'), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_study_baseline_costs', 'education_completed_bachelor_degree', 'checkbox', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '0', '', '', '', 'education completed bachelor degree', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_study_baseline_costs', 'education_completed_highschool_diploma', 'checkbox', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '0', '', '', '', '', 'education completed highschool diploma'), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_study_baseline_costs', 'education_completed_graduate_degree', 'checkbox', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '0', '', '', '', 'education completed graduate degree', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ed_tfri_study_baseline_costs'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_study_baseline_costs' AND `field`='total_income_before_tax' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='annual_income_options')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='total income before tax' AND `language_tag`=''), '1', '60', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_study_baseline_costs'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_study_baseline_costs' AND `field`='annual_household_income_before_tax' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='annual_income_options')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='annual household income before tax' AND `language_tag`=''), '1', '61', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_study_baseline_costs'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_study_baseline_costs' AND `field`='num_people_sharing_income' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='num_household_options')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='num people sharing income' AND `language_tag`=''), '1', '65', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_study_baseline_costs'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_study_baseline_costs' AND `field`='marital_status' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='martial_status_options')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='marital status' AND `language_tag`=''), '1', '66', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_study_baseline_costs'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_study_baseline_costs' AND `field`='ethnic_group_aboriginal' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ethnic group aboriginal' AND `language_tag`=''), '1', '70', 'ethnic group heading', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_study_baseline_costs'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_study_baseline_costs' AND `field`='ethnic_group_asian' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='ethnic group asian'), '1', '71', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_study_baseline_costs'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_study_baseline_costs' AND `field`='ethnic_group_black_african' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ethnic group black african' AND `language_tag`=''), '1', '72', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_study_baseline_costs'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_study_baseline_costs' AND `field`='ethnic_group_pacific_islander' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='ethnic group pacific islander'), '1', '73', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_study_baseline_costs'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_study_baseline_costs' AND `field`='ethnic_group_south_asian' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ethnic group south asian' AND `language_tag`=''), '1', '75', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_study_baseline_costs'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_study_baseline_costs' AND `field`='ethnic_group_white' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='ethnic group white'), '1', '76', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_study_baseline_costs'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_study_baseline_costs' AND `field`='ethnic_group_decline_or_na' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ethnic group decline or na' AND `language_tag`=''), '1', '77', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_study_baseline_costs'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_study_baseline_costs' AND `field`='education_completed_elementary' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='education completed elementary' AND `language_tag`=''), '1', '80', 'education heading', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_study_baseline_costs'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_study_baseline_costs' AND `field`='education_completed_some_highschool' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='education completed some highschool'), '1', '81', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_study_baseline_costs'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_study_baseline_costs' AND `field`='education_completed_tech_community_college' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='education completed tech community college' AND `language_tag`=''), '1', '82', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_study_baseline_costs'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_study_baseline_costs' AND `field`='education_completed_some_university' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='education completed some university'), '1', '83', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_study_baseline_costs'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_study_baseline_costs' AND `field`='education_completed_bachelor_degree' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='education completed bachelor degree' AND `language_tag`=''), '1', '84', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_study_baseline_costs'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_study_baseline_costs' AND `field`='education_completed_highschool_diploma' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='education completed highschool diploma'), '1', '85', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_study_baseline_costs'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_study_baseline_costs' AND `field`='education_completed_graduate_degree' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='education completed graduate degree' AND `language_tag`=''), '1', '86', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
 ('total income before tax', '2. What was your total annual income from before taxes last calendar year', ''),
 ('annual household income before tax', '3. What was your annual household income, before taxes, last calendar year', ''),
 ('num people sharing income', '4. How many other people do you share your home at the present time', ''),
 ('marital status', '5. Presently are you:', ''),
 ('ethnic group aboriginal', 'Aboriginal', ''),
 ('ethnic group asian', 'Asian', ''),
 ('ethnic group black african', 'Black or African Canadian', ''),
 ('ethnic group pacific islander', 'Pacific Islander', ''),
 ('ethnic group south asian', 'South Asian', ''),  
 ('ethnic group white', 'White', ''),  
 ('ethnic group decline or na', 'Decline to answer or do not know', ''),  
 ('education completed elementary', 'Elementary school', ''),  
 ('education completed some highschool', 'Some high school', ''),  
 ('education completed tech community college', 'Technical/Community College', ''),  
 ('education completed some university', 'Some University', ''),  
 ('education completed bachelor degree', 'Bachelor Degree at University', ''),
 ('education completed highschool diploma', 'HIgh school diploma', ''),
 ('education completed graduate degree', 'University degree above a Bachelor degree', ''); 

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_study_baseline_costs', 'date_completion', 'date',  NULL , '0', '', '', '', 'date completion', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_study_baseline_costs', 'method_of_completion', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='method_of_completion') , '0', '', '', '', 'method of completion', '');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES  
((SELECT id FROM structures WHERE alias='ed_tfri_study_baseline_costs'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_study_baseline_costs' AND `field`='date_completion' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='date completion' AND `language_tag`=''), '1', '90', 'completion details', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_tfri_study_baseline_costs'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_study_baseline_costs' AND `field`='method_of_completion' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='method_of_completion')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='method of completion' AND `language_tag`=''), '1', '91', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
 ('ethnic group heading', '6. What ethnic group do you consider yourself to belong to', ''),
 ('education heading', '7. What is the highest level of formal education that you have completed', ''); 

           
