UPDATE menus SET flag_active = 0 WHERE use_link LIKE '/ClinicalAnnotation/ParticipantContacts%';

UPDATE menus SET flag_active = 0 WHERE use_link LIKE '/Order/Orders/%';
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = 0, flag_active_2_to_1 = 0 WHERE id1 IN (SELECT id FROM datamart_structures WHERE model = 'OrderItem');
UPDATE datamart_structure_functions fct SET fct.flag_active = 0 WHERE fct.label IN ('add to order');

UPDATE treatment_extend_controls SET type = 'other transplanted organ', databrowser_label = 'other transplanted organ' WHERE detail_tablename = 'chum_transplant_txe_transplants';

INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("serum", "serum");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="blood_type"), (SELECT id FROM structure_permissible_values WHERE value="serum" AND language_alias="serum"), "", "1");

INSERT INTO structure_validations (structure_field_id, rule) VALUES ((SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `field`='blood_type' ), 'notEmpty');

UPDATE versions SET branch_build_number = '5852' WHERE version_number = '2.6.3';
