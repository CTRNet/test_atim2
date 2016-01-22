UPDATE users SET flag_active = 0, password = 'ddeaa159a89375256a02d1cfbd9a1946ad01a979';
UPDATE users SET username = 'NicoEn', first_name = 'N. Luc & Migration', last_name = 'N. Luc & Migration', flag_active = 1 WHERE id = 1;

UPDATE structure_formats SET `flag_search`='1', `flag_index`='1', `flag_detail`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='procure_participant_attribution_number' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_search`='1', `flag_index`='1', `flag_detail`='1' WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE `field`='procure_created_by_bank');

ALTER TABLE realiquotings 
	ADD COLUMN procure_central_is_transfer tinyint(1) DEFAULT '0';
ALTER TABLE realiquotings_revs 
	ADD COLUMN procure_central_is_transfer tinyint(1) DEFAULT '0';
	
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='procure_last_modification_by_bank' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_banks') AND `flag_confidential`='0');
UPDATE structure_fields SET `language_label`='last modification by bank',  `language_tag`='' WHERE model='Participant' AND tablename='participants' AND field='procure_last_modification_by_bank' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='procure_banks');

REPLACE INTO i18n (id,en,fr) VALUES ('created by bank','Created In Bank','Créé dans la banque');
	
	
	
	
	
	
	


//TODO dans les utilisations jouer avec le champs procure_central_is_transfer
//TODO Afficher de maniere particuliere le transfer...
//TODO Peut être ajouter les internal uses si n'existe pas....
	
	
	
UPDATE versions SET site_branch_build_number = '6370' WHERE version_number = '2.6.6';
UPDATE versions SET permissions_regenerated = 0;
