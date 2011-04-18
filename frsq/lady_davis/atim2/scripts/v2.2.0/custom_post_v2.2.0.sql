-- this script needs to be ran right after 2.2.0. upgrade.

truncate acos;

INSERT INTO i18n (id, en, fr) VALUES
("the collection identifier cannot be deleted", "The collection identifier cannot be deleted", "L'identifiant de collection ne peut pas être supprimé");

UPDATE structure_fields SET `type`='float_positive' WHERE `model`='Collection' AND `tablename`='collections' AND `field`='qc_lady_follow_up' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_lady_coll_follow_up') AND `flag_confidential`='0';


UPDATE structure_fields SET type='input' WHERE field='sardo_number';
UPDATE structure_formats SET type='float_positive' WHERE type='number';

INSERT INTO datamart_adhoc (title, description, plugin, model, form_alias_for_search, form_alias_for_results, form_links_for_results, sql_query_for_results, flag_use_query_results) VALUES
('participant B-M-T', 'qc_lady_participant_bmt_query_desc', 'clinicalannotation', 'Participant', 'participants', 'participants', '', 
'SELECT Participant.* FROM clinical_collection_links AS ccl_tumor
INNER JOIN collections AS c_tumor ON ccl_tumor.collection_id=c_tumor.id AND c_tumor.qc_lady_type="tumor"
INNER JOIN participants AS Participant ON Participant.id= ccl_tumor.participant_id
WHERE participant_id IN(
 SELECT participant_id FROM clinical_collection_links AS ccl_metastasis
 INNER JOIN collections AS c_metastasis ON ccl_metastasis.collection_id=c_metastasis.id AND c_metastasis.qc_lady_type="metastasis"
 WHERE participant_id IN(
  SELECT participant_id FROM clinical_collection_links AS ccl_biopsy
  INNER JOIN collections AS c_biopsy ON ccl_biopsy.collection_id=c_biopsy.id AND c_biopsy.qc_lady_type="biopsy"
  INNER JOIN participants AS Participant ON ccl_biopsy.participant_id=Participant.id
  WHERE Participant.created >= "@@Participant.created_start@@" AND Participant.created <= "@@Participant.created_end@@"
  AND Participant.title = "@@Participant.title@@" AND Participant.first_name = "@@Participant.first_name@@"
  AND Participant.last_name = "@@Participant.last_name@@" AND Participant.race = "@@Participant.race@@" AND Participant.sex = "@@Participant.sex@@"
  AND Participant.deleted=0
 )
)',
false);







DELETE FROM i18n WHERE id='core_appname';
REPLACE INTO i18n (id, en, fr) VALUES
('participant B-M-T', 'Participant B-M-T', 'Participant B-M-T'),
('qc_lady_participant_bmt_query_desc', "Searches for participants having B, M and T identifiers", "Cherche les participant ayant les identifiants B, M et T"),
('core_appname', 'ATiM - Advanced Tissue Management', "ATiM - Application de gestion avancée des tissus"),
('core_installname', "Lady Davis - Breast", "Lady Davis - Sein");

UPDATE menus SET flag_active=0 WHERE id='procd_CAN_01';

DELETE FROM misc_identifier_controls WHERE id IN(1,2,3,4);

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("blood", "blood");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="qc_lady_coll_type"),  (SELECT id FROM structure_permissible_values WHERE value="blood" AND language_alias="blood"), "", "1");

UPDATE misc_identifier_controls SET flag_once_per_participant=1 WHERE id IN(5,6,7);