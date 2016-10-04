<?php
	
	// --------------------------------------------------------------------------------
	// Regenerate default barcodes
	// -------------------------------------------------------------------------------- 	
	$this->AliquotMaster->regenerateAliquotBarcode();
	
	if($aliquot_data['AliquotControl']['aliquot_type'] == 'block') {
		if(isset($this->request->data['AliquotMaster']['aliquot_label'])) {
			$conditions = array(
				'AliquotMaster.aliquot_label' => $this->request->data['AliquotMaster']['aliquot_label'],
				'AliquotMaster.aliquot_control_id' => $aliquot_data['AliquotControl']['id']);
			if($this->AliquotMaster->find('count', array('conditions' => $conditions, 'recursive' => '-1')) > 1) {
				AppController::addWarningMsg(__('more than one block have the same aliquot label [%s] - please validate', __($this->request->data['AliquotMaster']['aliquot_label'])));
			}
		}
	}

?>
