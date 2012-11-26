<?php
		
	$this->MiscIdentifier = AppModel::getInstance('ClinicalAnnotation', 'MiscIdentifier', true);
	$conditions = array(
		'MiscIdentifier.deleted' => '0', 
		'MiscIdentifier.participant_id' => $participant_id, 
		"MiscIdentifierControl.misc_identifier_name = 'participant coded identifier'");
	$miscidentifier_data = $this->MiscIdentifier->find('all', array('conditions' => $conditions, 'order' => array('MiscIdentifier.created DESC')));
	$found_misc_identifier = false;
	if(isset($this->request->data['Collection']['misc_identifier_id'])){
		$found_misc_identifier = $this->setForRadiolist($miscidentifier_data, 'MiscIdentifier', 'id', $this->request->data, 'Collection', 'misc_identifier_id');
	}
	$this->set( 'miscidentifier_data', $miscidentifier_data );
	$this->set('found_misc_identifier', $found_misc_identifier);
	
	$this->Structures->set('miscidentifiers', 'atim_structure_miscidentifier_detail');
