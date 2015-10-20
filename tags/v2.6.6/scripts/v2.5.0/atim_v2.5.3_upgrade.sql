INSERT INTO `versions` (version_number, date_installed, build_number) VALUES
('2.5.3', NOW(), '5107');

ALTER TABLE structure_formats
 ADD COLUMN margin TINYINT UNSIGNED DEFAULT 0;

DROP VIEW view_structure_formats_simplified;
CREATE VIEW `view_structure_formats_simplified` AS select `str`.`alias` AS `structure_alias`,`sfo`.`id` AS `structure_format_id`,`sfi`.`id` AS `structure_field_id`,`sfo`.`structure_id` AS `structure_id`,`sfi`.`plugin` AS `plugin`,`sfi`.`model` AS `model`,`sfi`.`tablename` AS `tablename`,`sfi`.`field` AS `field`,`sfi`.`structure_value_domain` AS `structure_value_domain`,`svd`.`domain_name` AS `structure_value_domain_name`,`sfi`.`flag_confidential` AS `flag_confidential`,if((`sfo`.`flag_override_label` = '1'),`sfo`.`language_label`,`sfi`.`language_label`) AS `language_label`,if((`sfo`.`flag_override_tag` = '1'),`sfo`.`language_tag`,`sfi`.`language_tag`) AS `language_tag`,if((`sfo`.`flag_override_help` = '1'),`sfo`.`language_help`,`sfi`.`language_help`) AS `language_help`,if((`sfo`.`flag_override_type` = '1'),`sfo`.`type`,`sfi`.`type`) AS `type`,if((`sfo`.`flag_override_setting` = '1'),`sfo`.`setting`,`sfi`.`setting`) AS `setting`,if((`sfo`.`flag_override_default` = '1'),`sfo`.`default`,`sfi`.`default`) AS `default`,`sfo`.`flag_add` AS `flag_add`,`sfo`.`flag_add_readonly` AS `flag_add_readonly`,`sfo`.`flag_edit` AS `flag_edit`,`sfo`.`flag_edit_readonly` AS `flag_edit_readonly`,`sfo`.`flag_search` AS `flag_search`,`sfo`.`flag_search_readonly` AS `flag_search_readonly`,`sfo`.`flag_addgrid` AS `flag_addgrid`,`sfo`.`flag_addgrid_readonly` AS `flag_addgrid_readonly`,`sfo`.`flag_editgrid` AS `flag_editgrid`,`sfo`.`flag_editgrid_readonly` AS `flag_editgrid_readonly`,`sfo`.`flag_batchedit` AS `flag_batchedit`,`sfo`.`flag_batchedit_readonly` AS `flag_batchedit_readonly`,`sfo`.`flag_index` AS `flag_index`,`sfo`.`flag_detail` AS `flag_detail`,`sfo`.`flag_summary` AS `flag_summary`, sfo.flag_float AS flag_float, `sfo`.`display_column` AS `display_column`,`sfo`.`display_order` AS `display_order`,`sfo`.`language_heading` AS `language_heading`, margin AS margin 
from (((`structure_formats` `sfo` join `structure_fields` `sfi` on((`sfo`.`structure_field_id` = `sfi`.`id`))) 
join `structures` `str` on((`str`.`id` = `sfo`.`structure_id`))) 
left join `structure_value_domains` `svd` on((`svd`.`id` = `sfi`.`structure_value_domain`)));

INSERT INTO i18n (id,en,fr) VALUES 
('at least one collection is linked to that bank', 'At least one collection is linked to that bank', 'Au moins une collection est attachée à cette banque'),
('at least one group is linked to that bank', 'At least one group is linked to that bank', 'Au moins un groupe est attaché à cette banque');

INSERT IGNORE INTO i18n (id,en,fr) VALUES ('confidential data','Confidential Data','Données confidentielles');

SELECT 'WARNING: Change all QualityControl model references to QualityCtrl in both ViewAliquotUse and ViewAliquotUseCustom models' AS MSG;

INSERT INTO i18n (id,en,fr) VALUES ('sample derivative creation#', 'Sample Derivative Creation | ', 'Création de dérivé | ');

UPDATE menus SET flag_active = 0 WHERE use_link LIKE '/Protocol/ProtocolExtends%';

INSERT IGNORE INTO i18n (id,en,fr) 
VALUES 
('you do not own that template','You do not own that template','Vous n''êtes pas propiétaire du modèle'),
('edit properties', 'Edit Properties', 'Modifier propriétés');
ALTER TABLE templates ADD COLUMN  `created_by` int(10) unsigned NOT NULL;

UPDATE templates SET created_by = owning_entity_id WHERE owner = 'user' AND flag_system = 0 AND created_by = 0;
SELECT IF(COUNT(*) > 0, 
"WARNING: UPDATE templates.created_by field for following tempalte by the user_id of the person who created the template to be sure no functional bug will happen!", 'Templates table is ok!') AS msg 
FROM templates WHERE flag_system = 0 AND created_by = 0;
SELECT name AS 'template to update' FROM templates WHERE flag_system = 0 AND created_by = 0;

ALTER TABLE versions CHANGE build_number trunk_build_number varchar(45) NOT NULL;
ALTER TABLE versions ADD COLUMN  branch_build_number varchar(45) DEFAULT '';
UPDATE structure_fields SET `language_label`='trunk build number', `language_tag`='', field = 'trunk_build_number' WHERE model='Version' AND tablename='versions' AND field='build_number';
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Administrate', 'Version', 'versions', 'branch_build_number', 'input-readonly',  NULL , '0', 'size=25', '', '', 'branch build number', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='versions'), (SELECT id FROM structure_fields WHERE `model`='Version' AND `tablename`='versions' AND `field`='branch_build_number'), '1', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0');
UPDATE structure_formats SET `display_order`='4' WHERE structure_id=(SELECT id FROM structures WHERE alias='versions') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Version' AND `tablename`='versions' AND `field`='date_installed' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
INSERT IGNORE INTO i18n (id,en,fr) VALUES 
('trunk build number','Build Number (Trunk)', 'Numéro Version (application principal)'), 
('branch build number','Bank Version/Build','Banque Version/Numéro Version'); 

INSERT IGNORE INTO i18n (id,en,fr) VALUES ('access to aliquot','Access to Aliquot','Accéder à l''aliquot');
