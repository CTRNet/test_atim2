<?php

	$this->MiscIdentifier = AppModel::getInstance('Clinicalannotation', 'MiscIdentifier', true);
	$this->MiscIdentifier->bindModel(array('hasMany' => array(
		'ClinicalCollectionLink' => array(
			'className' => 'ClinicalCollectionLink',
			'foreignKey' => 'misc_identifier_id'))));
	
	$miscidentifier_data = $this->MiscIdentifier->find('all', array('conditions' => array('MiscIdentifier.deleted' => '0', 'MiscIdentifier.participant_id' => $participant_id, "MiscIdentifierControl.misc_identifier_name LIKE '#FRSQ%'"), 'order' => array('MiscIdentifier.created DESC')));
	$identifier_found = false;
	foreach($miscidentifier_data as &$identifier){
		foreach($identifier['ClinicalCollectionLink'] as $unit){
			if($unit['id'] == $clinical_collection_link_id){
				//we found the one that interests us
				$identifier['ClinicalCollectionLink'] = $unit;
				$identifier_found = true;
				break;
			}
		}
		
		if($identifier_found){
			break;
		}
	}
	
	$this->set('miscidentifier_data', $miscidentifier_data );
	$this->set('found_identifier', $identifier_found);
	
	$this->Structures->set('miscidentifiers', 'atim_structure_miscidentifier_detail');

?>