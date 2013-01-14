<?php
	
	$this->AliquotMaster->regenerateAliquotBarcode();
	
	$set_time_in_rna_later = false;
	if($parent_aliquot_ctrl['AliquotControl']['aliquot_type'] == 'tube'
	&& $child_aliquot_ctrl['AliquotControl']['aliquot_type'] == 'block'
	&& (strpos($parent_aliquot_ctrl['AliquotControl']['detail_form_alias'], 'qcroc_ad_tissue_tubes') !== false)) {
		$set_time_in_rna_later = true;
	}
	
	foreach($this->request->data as $tmp_new_set){
		if($set_time_in_rna_later) $this->AliquotMaster->updateTimeRemainedInRNAlater($tmp_new_set['parent']['AliquotMaster']['collection_id'], $tmp_new_set['parent']['AliquotMaster']['sample_master_id'], $tmp_new_set['parent']['AliquotMaster']['id']);
		$tmp_collection_ids[$tmp_new_set['parent']['AliquotMaster']['collection_id']] = $tmp_new_set['parent']['AliquotMaster']['collection_id'];
	}
	
	if((sizeof($tmp_collection_ids) == 1) && in_array($parent_aliquot_ctrl['AliquotControl']['aliquot_type'], array('tube', 'block')) && in_array($child_aliquot_ctrl['AliquotControl']['aliquot_type'], array('slide', 'block'))) {
		AppController::addWarningMsg(__('your data has been saved').' '.__('aliquot storage data were deleted (if required)'));
		$this->redirect('/InventoryManagement/Collections/detail/'.array_shift($tmp_collection_ids));
	}

?>
