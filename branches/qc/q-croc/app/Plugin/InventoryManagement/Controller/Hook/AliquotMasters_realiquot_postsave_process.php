<?php
	
	$this->AliquotMaster->regenerateAliquotBarcode();
	
	// Check for redirect
	$tmp_collection_ids = array();
	$tmp_parents_type = '';
	$tmp_children_type = '';
	foreach($this->request->data as $tmp_new_set){
		$tmp_parents_type = $tmp_new_set['parent']['AliquotControl']['aliquot_type'];
		foreach($tmp_new_set['children'] as $new_child) {
			$tmp_collection_ids[$new_child['AliquotMaster']['collection_id']] = $new_child['AliquotMaster']['collection_id'];
			$tmp_children_type = $new_child['AliquotControl']['aliquot_type'];
		}
	}
	if((sizeof($tmp_collection_ids) == 1) && in_array($tmp_parents_type, array('tube', 'block')) && in_array($tmp_children_type, array('slide', 'block'))) {
		AppController::addWarningMsg(__('your data has been saved').' '.__('aliquot storage data were deleted (if required)'));
		$this->redirect('/InventoryManagement/Collections/detail/'.array_shift($tmp_collection_ids));
	}

?>
