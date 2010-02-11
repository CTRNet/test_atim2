-- Add any new SQL changes to this file which will then be merged with the master
-- upgrade scripts for v2.0.1

/*
  CLINCIAL ANNOTATION  
*/ 

INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('event_group', '', 'Annotation Group', ''),
('event_type', '', 'Form Type', ''),
('mail', '', 'Mail', ''),
('in person', '', 'In Person', ''),
('surgery specific', '', 'Surgery Specific', ''),
('disease site form', '', 'Disease Site Form', '');

-- Fixed field display for topography
UPDATE `structure_formats` SET `flag_add` = '1',
`flag_edit` = '1' WHERE `structure_formats`.`old_id` = 'CANM-00001_CAN-823';
UPDATE `structure_formats` SET `flag_add` = '1',
`flag_detail` = '1' WHERE `structure_formats`.`old_id` = 'CANM-00010_CAN-823';

-- Improved order of fields on family history form
UPDATE `structure_formats` SET `display_order` = '5' WHERE `structure_formats`.`old_id` = 'CAN-999-999-000-999-3_CAN-999-999-000-999-29';
UPDATE `structure_formats` SET `display_order` = '4' WHERE `structure_formats`.`old_id` = 'CAN-999-999-000-999-3_CAN-999-999-000-999-30';
UPDATE `structure_formats` SET `display_order` = '3' WHERE `structure_formats`.`old_id` = 'CAN-999-999-000-999-3_CAN-999-999-000-999-31';

-- Manage event language label

UPDATE `structure_fields` SET `language_label` = 'event_type' WHERE `old_id` = 'CAN-999-999-000-999-228';



/*
  INVENTORY MANAGEMENT  
*/ 

#SQL View for collections
INSERT INTO `structures` (
`id`, `old_id`, `alias`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`, `created`, `created_by`, `modified`, `modified_by`)
VALUES (NULL , 'CANM-00025', 'view_collection', '', '', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

SET @last_structure_id = LAST_INSERT_ID();

INSERT INTO structure_fields (public_identifier,old_id,plugin,model,tablename,field,language_label,language_tag,type,setting,`default`,structure_value_domain,language_help,validation_control,value_domain_control,field_control,created,created_by,modified,modified_by)
SELECT public_identifier, CONCAT(old_id, '-v'),plugin, 'ViewCollection',tablename,field,language_label,language_tag,type,setting,`default`,structure_value_domain,language_help,validation_control,value_domain_control,field_control,created,created_by,modified,modified_by 
FROM structure_fields WHERE old_id IN('CAN-999-999-000-999-1000', 'CAN-999-999-000-999-1003', 'CAN-999-999-000-999-1004', 'CAN-999-999-000-999-1007', 'CAN-999-999-000-999-1008', 'CAN-999-999-000-999-1013', 'CAN-999-999-000-999-1223', 'CAN-999-999-000-999-1285');

INSERT INTO `structure_formats` (`old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`)
SELECT CONCAT('CANM-00025_', structure_field_old_id, '-v'), @last_structure_id, 'CANM-00025', `structure_field_id`, CONCAT(`structure_field_old_id`, '-v'), `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, '0', '0', '0', '0', `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`
FROM structure_formats WHERE structure_old_id='CAN-999-999-000-999-1000' AND (flag_search='1' OR flag_index='1' OR flag_detail='1');

SET @last_id = LAST_INSERT_ID();

UPDATE structure_formats
INNER JOIN structure_fields ON structure_fields.old_id=structure_formats.structure_field_old_id
SET structure_formats.structure_field_id=structure_fields.id
WHERE structure_formats.id >= @last_id;

UPDATE structure_formats
SET display_order = '1'
WHERE old_id = 'CANM-00025_CANM-00026';

UPDATE structure_formats
SET display_order = '0'
WHERE old_id = 'CANM-00025_CAN-999-999-000-999-1000-v'; 

DROP VIEW view_collections;
CREATE VIEW view_collections AS 
SELECT 
collection_id, 
bank_id, 
sop_master_id, 
participant_id, 
diagnosis_master_id, 
consent_master_id, 

acquisition_label, 
collection_site, 
collection_datetime, 
collection_datetime_accuracy, 
collection_property, 
collection_notes, 
collections.deleted, 
collections.deleted_date,

participant_identifier, 

banks.name AS bank_name,

sops.title AS sop_title, 	
sops.code AS sop_code, 	
sops.version AS sop_version, 		
sop_group,
sops.type 	

FROM collections
LEFT JOIN clinical_collection_links AS ccl ON collections.id=ccl.collection_id AND ccl.deleted != 1
LEFT JOIN participants ON ccl.participant_id=participants.id AND participants.deleted != 1
LEFT JOIN banks ON collections.bank_id=banks.id AND banks.deleted != 1
LEFT JOIN sop_masters AS sops ON collections.sop_master_id=sops.id AND sops.deleted != 1;

INSERT INTO `structure_fields` (`id`, `public_identifier`, `old_id`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `created`, `created_by`, `modified`, `modified_by`)
VALUES (NULL , '', 'CANM-00026', 'Inventorymanagement', 'ViewCollection', '', 'participant_identifier', 'participant identifier', '', 'input', '', '', NULL , '', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

SET @last_id = LAST_INSERT_ID();

INSERT INTO `structure_formats` (`id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`)
VALUES (NULL , 'CANM-00025_CANM-00026', @last_structure_id, 'CANM-00025', @last_id, 'CANM-00026', '0', '13', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '1', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

UPDATE `menus`
SET `use_summary` = 'Inventorymanagement.ViewCollection::summary'
WHERE `use_summary` LIKE 'Inventorymanagement.Collection::summary';

#end SQL view for collections

#cell lysate
DROP TABLE `sd_der_cell_lysates`;
CREATE TABLE `sd_der_cell_lysates` (
  `id` int(11) NOT NULL auto_increment,
  `sample_master_id` int(11) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime default NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ; 

DROP TABLE `sd_der_cell_lysates_revs`;
CREATE TABLE `sd_der_cell_lysates_revs` (
  `id` int(11) NOT NULL,
  `sample_master_id` int(11) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime default NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ; 

INSERT INTO `sample_controls` (`id`, `sample_type`, `sample_type_code`, `sample_category`, `status`, `form_alias`, `detail_tablename`, `display_order`)
VALUES (NULL , 'cell lysate', 'C-LYSATE', 'derivative', 'active', 'sd_undetailed_derivatives', 'sd_der_cell_lysates', '0');

SET @last_id = LAST_INSERT_ID();

INSERT INTO `parent_to_derivative_sample_controls` (`id` ,`parent_sample_control_id` ,`derivative_sample_control_id` ,`status`) VALUES 
(NULL , '3', @last_id, 'active'),#tissue
(NULL , '11', @last_id, 'active'),#cell culture
(NULL , '8', @last_id, 'active');#pbmc
#end cell lysate

#clean up
UPDATE structure_value_domains_permissible_values AS tu
INNER JOIN (SELECT spv.id AS spv_id, doubles.id AS d_id, c FROM structure_permissible_values AS spv INNER JOIN
(select *, count(*) AS c from structure_permissible_values group by value, language_alias HAVING c > 1) AS doubles ON spv.language_alias=doubles.language_alias AND spv.value=doubles.value) as m on tu.structure_permissible_value_id=m.spv_id
SET tu.structure_permissible_value_id=m.d_id;

CREATE TEMPORARY TABLE tmp_id(
id int(11) unsigned not null
);

INSERT INTO tmp_id (SELECT spv.id FROM structure_permissible_values AS spv INNER JOIN
(select *, count(*) AS c from structure_permissible_values group by value, language_alias HAVING c > 1) AS doubles ON spv.language_alias=doubles.language_alias AND spv.value=doubles.value WHERE spv.id!=doubles.id);

DELETE FROM structure_permissible_values WHERE id IN
(SELECT * FROM tmp_id);

DROP TABLE tmp_id;

ALTER TABLE structure_permissible_values ADD UNIQUE KEY(value, language_alias);