<?php

	// --------------------------------------------------------------------------------
	// Regenerate default barcodes
	// --------------------------------------------------------------------------------
	$this->AliquotMaster->regenerateAliquotBarcode();
	
	// -------------------------------------------------------------------------------
	// Generate block, slide and core aliquot label
	// -------------------------------------------------------------------------------
	$linked_collection_ids = array();
	$tmp_collection_ids = $this->AliquotMaster->find('all', array('conditions' => array('AliquotMaster.id' => explode(",", $parent_aliquots_ids)), 'fields'=>'DISTINCT collection_id','recursive' => -1));
	foreach($tmp_collection_ids as $aliquots_collection_id) $linked_collection_ids[] = $aliquots_collection_id['AliquotMaster']['collection_id'];
	$this->AliquotMaster->updateAliquotLabel($linked_collection_ids);
	
	// -------------------------------------------------------------------------------
	// Check duplicated patho id +block id
	// -------------------------------------------------------------------------------
	if($child_aliquot_ctrl['AliquotControl']['aliquot_type'] == 'block') {
		//Block to block
		AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true); 
	}

?>
