<?php
	
	// --------------------------------------------------------------------------------
	// Regenerate default barcodes
	// -------------------------------------------------------------------------------- 	
	$this->AliquotMaster->regenerateAliquotBarcode();
	
	if($aliquot_control['AliquotControl']['aliquot_type'] == 'block') {
		foreach($this->request->data as $created_aliquots){
			foreach($created_aliquots['children'] as $new_aliquot) {
				if(isset($new_aliquot['AliquotMaster']['aliquot_label'])) {
					$conditions = array(
						'AliquotMaster.aliquot_label' => $new_aliquot['AliquotMaster']['aliquot_label'],
						'AliquotMaster.aliquot_control_id' => $aliquot_control['AliquotControl']['id']);
					if($this->AliquotMaster->find('count', array('conditions' => $conditions, 'recursive' => '-1')) > 1) {
						AppController::addWarningMsg(__('more than one block have the same aliquot label [%s] - please validate', __($new_aliquot['AliquotMaster']['aliquot_label'])));
					}
				}
			}
		}	
	}

?>
