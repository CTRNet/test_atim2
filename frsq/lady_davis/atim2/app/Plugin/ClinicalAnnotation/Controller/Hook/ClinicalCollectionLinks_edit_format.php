<?php

	$this->MiscIdentifier = AppModel::getInstance('ClinicalAnnotation', 'MiscIdentifier', true);
	$this->MiscIdentifier->bindModel(array('hasMany' => array(
		'Collection' => array(
			'className' => 'Collection',
			'foreignKey' => 'misc_identifier_id'))));
	$conditions = array(
			'MiscIdentifier.deleted' => '0',
			'MiscIdentifier.participant_id' => $participant_id,
			"MiscIdentifierControl.misc_identifier_name IN ('Breast bank #', 'Q-CROC-03')");
	$miscidentifier_data = $this->MiscIdentifier->find('all', array('conditions' => $conditions, 'order' => array('MiscIdentifier.created DESC')));
	$found_misc_identifier = false;
	
	foreach($miscidentifier_data as &$identifier){
		foreach($identifier['Collection'] as $unit){
			if($unit['id'] == $collection_id){
				//we found the one that interests us
				$identifier['Collection'] = $unit;
				$found_misc_identifier = true;
				break;
			}
		}
		
		if($found_misc_identifier){
			break;
		}
	}
	
	$this->set('miscidentifier_data', $miscidentifier_data );
	$this->set('found_misc_identifier', $found_misc_identifier);
	
	$this->Structures->set('miscidentifiers', 'atim_structure_miscidentifier_detail');
