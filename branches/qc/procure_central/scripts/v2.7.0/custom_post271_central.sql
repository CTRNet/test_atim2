-- -------------------------------------------------------------------------------------
-- MODIFIED SCRIPT FOR ATiM CENTRAL
-- -------------------------------------------------------------------------------------
--
-- To execute after 
--    - atim_procure_central_full_installation_v271_revs_7299_7339_7345.sql
--    - atim_v2.7.1_upgrade.sql
--    - custom_post271_central.sql
--
-- @author Nicolas Luc
-- @date 2018-09-07
-- -------------------------------------------------------------------------------------

-- Password 

REPLACE INTO i18n (id,en,fr)
VALUES
('password_format_error_msg_1', "Your password should has a minimal length of 8 characters and contains at least one lowercase letter.", "Votre mot de passe doit avoir une longueur minimale de 8 caractères et contenir au moins une lettre minuscule."),
('password_format_error_msg_2', "Your password should has a minimal length of 8 characters and contains at least one lowercase letter and one number.", "Votre mot de passe doit avoir une longueur minimale de 8 caractères et contenir au moins une lettre minuscule et un chiffre."),
('password_format_error_msg_3', "Your password should has a minimal length of 8 characters and contains at least both one lowercase letter, one uppercase letter and one number.", "Votre mot de passe doit avoir une longueur minimale de 8 caractères et contenir au moins une lettre minuscule, une lettre majuscule et un chiffre."),
('password_format_error_msg_4', "Your password should has a minimal length of 8 characters and contains at least both one lowercase letter, one uppercase letter,  one number and one special character.", "Votre mot de passe doit avoir une longueur minimale de 8 caractères et contenir au moins une lettre minuscule, une lettre majuscule, un chiffre et un caractère spécial.");

-- Created by site

UPDATE structure_formats SET `flag_search`='1', `flag_index`='1', `flag_detail`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='procure_last_modification_by_bank' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_banks') AND `flag_confidential`='0');
UPDATE structure_fields SET  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='procure_banks') ,  `language_label`='last modification by bank',  `language_tag`='' WHERE model='Participant' AND tablename='participants' AND field='procure_last_modification_by_bank' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='procure_banks');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1', `flag_detail`='1' WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE `field`='procure_created_by_bank' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_banks'));
UPDATE structure_formats SET `display_order`='51', `language_heading`='system data' WHERE structure_id=(SELECT id FROM structures WHERE alias='consent_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='procure_created_by_bank' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_banks') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='2', `display_order`='1001' WHERE structure_id=(SELECT id FROM structures WHERE alias='eventmasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='procure_created_by_bank' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_banks') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='1001' WHERE structure_id=(SELECT id FROM structures WHERE alias='treatmentmasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='procure_created_by_bank' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_banks') AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_search`='1', `flag_index`='1', `flag_detail`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='procure_collected_by_bank' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_banks') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='procure_collected_by_bank' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_banks') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='collections_for_collection_tree_view') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='procure_collected_by_bank' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_banks') AND `flag_confidential`='0');

-- Menus

UPDATE menus SET flag_active = 0 WHERE use_link LIKE '/ClinicalAnnotation/ParticipantMessages%';
UPDATE menus SET flag_active = 0 WHERE use_link LIKE '/ClinicalAnnotation/ParticipantContacts%';
UPDATE datamart_browsing_controls set flag_active_1_to_2 = 0, flag_active_2_to_1 = 0 WHERE (id1 = 12 AND id2 =4) OR (id1 = 4 AND id2 =12);


-- Users

UPDATE users SET first_name = '', last_name = '', password = 'ddeaa159a89375256a02d1cfbd9a1946ad01a979', flag_active = 0, email = '';
UPDATE users SET username = 'NicoEn', flag_active = 1 WHERE id = 1;

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Versions
-- -----------------------------------------------------------------------------------------------------------------------------------

UPDATE versions SET site_branch_build_number = '7413' WHERE version_number = '2.7.1';
UPDATE versions SET site_branch_build_number = '7417' WHERE version_number = '2.7.1';
