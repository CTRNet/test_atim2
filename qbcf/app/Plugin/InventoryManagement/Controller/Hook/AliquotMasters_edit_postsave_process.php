<?php

	// -------------------------------------------------------------------------------
	// Generate block, slide and core aliquot label
	// -------------------------------------------------------------------------------
	$this->AliquotMaster->updateAliquotLabel(array($collection_id));
	
	// -------------------------------------------------------------------------------
	// Check duplicated patho id +block id
	// -------------------------------------------------------------------------------
	if($aliquot_data['AliquotControl']['aliquot_type'] == 'block' && isset($this->request->data['AliquotDetail']['patho_dpt_block_code'])) {
		$conditions = array(
			'AliquotMaster.aliquot_label' => $aliquot_data['Collection']['qbcf_pathology_id'].' '.$this->request->data['AliquotDetail']['patho_dpt_block_code'],
			'AliquotMaster.aliquot_control_id' => $aliquot_data['AliquotControl']['id']);
		if($this->AliquotMaster->find('count', array('conditions' => $conditions, 'recursive' => '-1')) > 1) {
			AppController::addWarningMsg(__('more than one block have the same aliquot label [%s] - please validate', $aliquot_data['Collection']['qbcf_pathology_id'].' '.$this->request->data['AliquotDetail']['patho_dpt_block_code']));
		}
	}

?>
