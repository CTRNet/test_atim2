<?php
		
	$this->MiscIdentifier = AppModel::getInstance('ClinicalAnnotation', 'MiscIdentifier', true);
	$conditions = array(
		'MiscIdentifier.deleted' => '0', 
		'MiscIdentifier.participant_id' => $participant_id, 
		"MiscIdentifierControl.misc_identifier_name LIKE 'Q-CROC-%'");
	$miscidentifier_data = $this->MiscIdentifier->find('all', array('conditions' => $conditions, 'order' => array('MiscIdentifier.created DESC')));
	$found_misc_identifier = false;
	if(isset($this->request->data['Collection']['misc_identifier_id'])){
		$found_misc_identifier = $this->setForRadiolist($miscidentifier_data, 'MiscIdentifier', 'id', $this->request->data, 'Collection', 'misc_identifier_id');
	} else if(empty($this->request->data) && !empty($miscidentifier_data)) {
		$miscidentifier_data[0]['Collection']['misc_identifier_id'] = $miscidentifier_data[0]['MiscIdentifier']['id'];
		$found_misc_identifier = true;
	}
	$this->set( 'miscidentifier_data', $miscidentifier_data );
	$this->set('found_misc_identifier', $found_misc_identifier);
	
	$this->Structures->set('miscidentifiers', 'atim_structure_miscidentifier_detail');
