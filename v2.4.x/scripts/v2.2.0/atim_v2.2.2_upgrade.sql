-- Update version information
INSERT INTO `versions` (version_number, date_installed, build_number) VALUES('2.2.2', NOW(), '3044');

DELETE FROM i18n WHERE id='Details' AND page_id='global';
DELETE FROM i18n WHERE id='inv_collection_type_defintion' AND page_id='';
DELETE FROM i18n WHERE id='Next' AND page_id='global';
DELETE FROM i18n WHERE id='Prev' AND page_id='global';
DELETE FROM i18n WHERE id='received tissue weight' AND page_id='global';

ALTER TABLE participant_contacts
 MODIFY phone_secondary VARCHAR(30) NOT NULL DEFAULT '';
ALTER TABLE participant_contacts_revs
 MODIFY phone_secondary VARCHAR(30) NOT NULL DEFAULT '';

-- adding hour as datetime accuracy 
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES
("h", "datetime_accuracy_indicator_h"),
("i", "datetime_accuracy_indicator_i");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES
((SELECT id FROM structure_value_domains WHERE domain_name="datetime_accuracy_indicator"),  (SELECT id FROM structure_permissible_values WHERE value="h" AND language_alias="datetime_accuracy_indicator_h"), "0", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="datetime_accuracy_indicator"),  (SELECT id FROM structure_permissible_values WHERE value="i" AND language_alias="datetime_accuracy_indicator_i"), "0", "1");

INSERT INTO i18n (id, en, fr) VALUES
("datetime_accuracy_indicator_h", "h", "h"),
("datetime_accuracy_indicator_i", "i", "i"),
("you cannot delete yourself", "You cannot delete yourself", "Vous ne pouvez pas vous effacer vous-même");
 
UPDATE structure_fields SET structure_value_domain=(SELECT id FROM structure_value_domains WHERE domain_name='date_accuracy')
WHERE field IN('dob_date_accuracy', 'dod_date_accuracy', 'dx_date_accuracy', 'start_date_accuracy', 'finish_date_accuracy');

DELETE FROM structure_value_domains WHERE domain_name IN('date_status', 'lkmp_date_certainty');
DELETE FROM structure_value_domains_permissible_values WHERE structure_value_domain_id NOT IN (SELECT id FROM structure_value_domains);
DELETE FROM structure_value_domains_permissible_values WHERE structure_permissible_value_id NOT IN (SELECT id FROM structure_permissible_values);
 
ALTER TABLE structure_value_domains_permissible_values
 MODIFY structure_value_domain_id INT,
 ADD FOREIGN KEY (structure_value_domain_id) REFERENCES structure_value_domains (`id`);

UPDATE structure_value_domains_permissible_values
 SET structure_permissible_value_id=(SELECT id FROM structure_permissible_values WHERE value=BINARY('d') AND language_alias='datetime_accuracy_indicator_d')
 WHERE structure_permissible_value_id IN (SELECT id FROM structure_permissible_values WHERE value='D' AND language_alias IN('day uncertain', 'datetime_accuracy_indicator_d', 'day of date is uncertain'));
UPDATE structure_value_domains_permissible_values
 SET structure_permissible_value_id=(SELECT id FROM structure_permissible_values WHERE value=BINARY('m') AND language_alias='datetime_accuracy_indicator_m')
 WHERE structure_permissible_value_id IN (SELECT id FROM structure_permissible_values WHERE value='m' AND language_alias IN('month uncertain', 'datetime_accuracy_indicator_m', 'month and day of date uncertain')); 
UPDATE structure_value_domains_permissible_values
 SET structure_permissible_value_id=(SELECT id FROM structure_permissible_values WHERE value=BINARY('y') AND language_alias='datetime_accuracy_indicator_y')
 WHERE structure_permissible_value_id IN (SELECT id FROM structure_permissible_values WHERE value='Y' AND language_alias IN('year uncertain', 'datetime_accuracy_indicator_y')); 
UPDATE structure_value_domains_permissible_values
 SET structure_permissible_value_id=(SELECT id FROM structure_permissible_values WHERE value=BINARY('c') AND language_alias='datetime_accuracy_indicator_c')
 WHERE structure_permissible_value_id IN (SELECT id FROM structure_permissible_values WHERE value='c' AND language_alias IN('Complete date known and verified', 'datetime_accuracy_indicator_c')); 

ALTER TABLE structure_value_domains_permissible_values
 DROP COLUMN language_alias;
 
DELETE FROM structure_permissible_values WHERE id NOT IN(SELECT structure_permissible_value_id FROM structure_value_domains_permissible_values);

UPDATE structure_value_domains_permissible_values
SET display_order=1 
WHERE structure_value_domain_id IN (SELECT id FROM structure_value_domains WHERE domain_name IN('datetime_accuracy_indicator'))
 AND structure_permissible_value_id=(SELECT id FROM structure_permissible_values WHERE value='i' AND language_alias='datetime_accuracy_indicator_i');
UPDATE structure_value_domains_permissible_values
SET display_order=2 
WHERE structure_value_domain_id IN (SELECT id FROM structure_value_domains WHERE domain_name IN('datetime_accuracy_indicator'))
 AND structure_permissible_value_id=(SELECT id FROM structure_permissible_values WHERE value='h' AND language_alias='datetime_accuracy_indicator_h');
UPDATE structure_value_domains_permissible_values
SET display_order=3 
WHERE structure_value_domain_id IN (SELECT id FROM structure_value_domains WHERE domain_name IN('datetime_accuracy_indicator', 'date_accuracy'))
 AND structure_permissible_value_id=(SELECT id FROM structure_permissible_values WHERE value='d' AND language_alias='datetime_accuracy_indicator_d');
UPDATE structure_value_domains_permissible_values
SET display_order=4 
WHERE structure_value_domain_id IN (SELECT id FROM structure_value_domains WHERE domain_name IN('datetime_accuracy_indicator', 'date_accuracy'))
 AND structure_permissible_value_id=(SELECT id FROM structure_permissible_values WHERE value='m' AND language_alias='datetime_accuracy_indicator_m');
UPDATE structure_value_domains_permissible_values
SET display_order=5 
WHERE structure_value_domain_id IN (SELECT id FROM structure_value_domains WHERE domain_name IN('datetime_accuracy_indicator', 'date_accuracy'))
 AND structure_permissible_value_id=(SELECT id FROM structure_permissible_values WHERE value='y' AND language_alias='datetime_accuracy_indicator_y');

 
ALTER TABLE users
 ADD COLUMN deleted TINYINT UNSIGNED NOT NULL DEFAULT 0,
 ADD COLUMN deleted_date DATETIME DEFAULT NULL;
 
UPDATE structure_formats SET `display_order`='2' WHERE structure_id=(SELECT id FROM structures WHERE alias='children_aliquots_selection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='id' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE orders SET processing_status = '' WHERE processing_status IS NULL;
UPDATE orders_revs SET processing_status = '' WHERE processing_status IS NULL;

ALTER TABLE orders
 MODIFY COLUMN processing_status VARCHAR(45) NOT NULL DEFAULT '';
ALTER TABLE orders_revs
 MODIFY COLUMN processing_status VARCHAR(45) NOT NULL DEFAULT '';

-- fixing bad flags in structure_formats
UPDATE structure_formats SET flag_add='0' WHERE flag_add='';
UPDATE structure_formats SET flag_add_readonly='0' WHERE flag_add_readonly='';
UPDATE structure_formats SET flag_edit='0' WHERE flag_edit='';
UPDATE structure_formats SET flag_edit_readonly='0' WHERE flag_edit_readonly='';
UPDATE structure_formats SET flag_search='0' WHERE flag_search='';
UPDATE structure_formats SET flag_search_readonly='0' WHERE flag_add_readonly='';
UPDATE structure_formats SET flag_addgrid='0' WHERE flag_addgrid='';
UPDATE structure_formats SET flag_addgrid_readonly='0' WHERE flag_addgrid_readonly='';
UPDATE structure_formats SET flag_editgrid='0' WHERE flag_editgrid='';
UPDATE structure_formats SET flag_editgrid_readonly='0' WHERE flag_editgrid_readonly='';
UPDATE structure_formats SET flag_summary='0' WHERE flag_summary='';
UPDATE structure_formats SET flag_batchedit='0' WHERE flag_batchedit='';
UPDATE structure_formats SET flag_batchedit_readonly='0' WHERE flag_batchedit_readonly='';
UPDATE structure_formats SET flag_index='0' WHERE flag_index='';
UPDATE structure_formats SET flag_detail='0' WHERE flag_detail='';

-- deleting certainti_of_age value domain
UPDATE structure_fields SET structure_value_domain=(SELECT id FROM structure_value_domains WHERE domain_name='age_accuracy') WHERE structure_value_domain=(SELECT id FROM structure_value_domains WHERE domain_name='certainty_of_age');
DELETE FROM structure_value_domains_permissible_values WHERE structure_value_domain_id=(SELECT id FROM structure_value_domains WHERE domain_name='certainty_of_age');
DELETE FROM structure_value_domains WHERE domain_name='certainty_of_age';

UPDATE structure_fields SET structure_value_domain=(SELECT id FROM structure_value_domains WHERE domain_name='date_accuracy') WHERE field='lnmp_accuracy' AND model='ReproductiveHistory';
