<?php
App::import('Model', 'inventorymanagement.ViewCollection');
$this->ViewCollection = new ViewCollection(false);
App::import('Model', 'clinicalannotation.MiscIdentifier');
$this->MiscIdentifier = new MiscIdentifier(false);

$collection_data = $this->ViewCollection->find('first', array('conditions' => array('ViewCollection.collection_id'=> $collection_id)));

if(!empty($collection_data)){
	$misc_data = $this->MiscIdentifier->find('first', array('conditions' => array('MiscIdentifier.participant_id' => $collection_data['ViewCollection']['participant_id']), 'recursive' => 2));
	if(!empty($misc_data)){
		$this->set('aliquot_label', $misc_data['MiscIdentifier']['identifier_value']." N ".date("Y-m-d", mktime()));
	}
}
?>