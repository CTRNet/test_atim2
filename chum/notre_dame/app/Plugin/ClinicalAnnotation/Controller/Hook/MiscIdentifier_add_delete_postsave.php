<?php
assert(isset($update_collection_sample_labels_with));

// --------------------------------------------------------------------------------
// Update participant collection sample labels
// --------------------------------------------------------------------------------
	
// Get Bank linked to this created identifier
$bank_model = AppModel::getInstance('Administrate', 'Bank', true);
$bank = $bank_model->find('first', array('conditions' => array('Bank.misc_identifier_control_id' => $misc_identifier_control_id)));

if(!empty($bank)) {
	$bank_id = $bank['Bank']['id'];

	// Launch sample labels upgrade process
	$collection_model = AppModel::getInstance('InventoryManagement', 'Collection', true);
	$collections = $collection_model->find('all', array('conditions' => array('Collection.participant_id' => $participant_id, 'Collection.bank_id' => $bank_id)));

	foreach($collections as $new_linked_collection){
		$collection_model->updateCollectionSampleLabels($new_linked_collection['Collection']['id'], $update_collection_sample_labels_with);
	}
}