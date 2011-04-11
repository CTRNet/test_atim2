-- this script needs to be ran right after 2.2.0. upgrade.

truncate acos;

INSERT INTO i18n (id, en, fr) VALUES
("the collection identifier cannot be deleted", "The collection identifier cannot be deleted", "L'identifiant de collection ne peut pas être supprimé");

UPDATE structure_fields SET `type`='float_positive' WHERE `model`='Collection' AND `tablename`='collections' AND `field`='qc_lady_follow_up' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_lady_coll_follow_up') AND `flag_confidential`='0';


>>>>>>>>>>>>>>>>>>>DIE: VALIDATE OLD ENTRIES BEFORE PROCEEDING<<<<<<<<<<<<<<<<<<<<<<<
INSERT INTO misc_identifiers (identifier_value, misc_identifier_control_id, identifier_name, participant_id, created, created_by, modified, modified_by)
(SELECT SUBSTRING(identifier_value, 2), 9, 'collection', participant_id, created, created_by, NOW(), 1 FROM misc_identifiers WHERE misc_identifier_control_id IN(1,2,3,4) AND SUBSTRING(identifier_value, 2) > 999 GROUP BY participant_id);

DELETE FROM misc_identifiers WHERE misc_identifier_control_id IN(1,2,3,4);

UPDATE structure_fields SET type='input' WHERE field='sardo_number';
UPDATE structure_formats SET type='float_positive' WHERE type='number';

INSERT INTO datamart_adhoc (title, description, plugin, model, form_alias_for_search, form_alias_for_results, form_links_for_results, sql_query_for_results, flag_use_query_results) VALUES
('participant B-M-T', 'qc_lady_participant_bmt_query_desc', 'clinicalannotation', 'Participant', 'participants', 'participants', '', 
'SELECT Participant.* FROM participants AS Participant
INNER JOIN misc_identifiers AS mi_b ON mi_b.misc_identifier_control_id=1 AND mi_b.deleted=0 AND Participant.id=mi_b.participant_id
INNER JOIN misc_identifiers AS mi_m ON mi_m.misc_identifier_control_id=2 AND mi_b.deleted=0 AND Participant.id=mi_m.participant_id
INNER JOIN misc_identifiers AS mi_t ON mi_t.misc_identifier_control_id=4 AND mi_b.deleted=0 AND Participant.id=mi_t.participant_id
WHERE Participant.created >= "@@Participant.created_start@@" AND Participant.created <= "@@Participant.created_end@@"
AND Participant.title = "@@Participant.title@@" AND Participant.first_name = "@@Participant.first_name@@"
AND Participant.last_name = "@@Participant.last_name@@" AND Participant.race = "@@Participant.race@@" AND Participant.sex = "@@Participant.sex@@"
AND Participant.deleted=0',
false);

DELETE FROM i18n WHERE id='core_appname';
REPLACE INTO i18n (id, en, fr) VALUES
('participant B-M-T', 'Participant B-M-T', 'Participant B-M-T'),
('qc_lady_participant_bmt_query_desc', "Searches for participants having B, M and T identifiers", "Cherche les participant ayant les identifiants B, M et T"),
('core_appname', 'ATiM - Advanced Tissue Management', "ATiM - Application de gestion avancée des tissus"),
('core_installname', "Lady Davis - Breast", "Lady Davis - Sein");

UPDATE menus SET flag_active=0 WHERE id='procd_CAN_01';