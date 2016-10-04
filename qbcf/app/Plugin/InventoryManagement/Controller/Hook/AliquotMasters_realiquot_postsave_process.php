<?php
	
	// --------------------------------------------------------------------------------
	// Regenerate default barcodes
	// -------------------------------------------------------------------------------- 	
	$this->AliquotMaster->regenerateAliquotBarcode();
	
	if($child_aliquot_ctrl['AliquotControl']['aliquot_type'] == 'block') {
		foreach($this->request->data as $parent_id => $parent_and_children){
			foreach($parent_and_children['children'] as $new_aliquot) {
				if(isset($new_aliquot['AliquotMaster']['aliquot_label'])) {
					$conditions = array(
						'AliquotMaster.aliquot_label' => $new_aliquot['AliquotMaster']['aliquot_label'],
						'AliquotMaster.aliquot_control_id' => $child_aliquot_ctrl['AliquotControl']['id']);
					if($this->AliquotMaster->find('count', array('conditions' => $conditions, 'recursive' => '-1')) > 1) {
						AppController::addWarningMsg(__('more than one block have the same aliquot label [%s] - please validate', __($new_aliquot['AliquotMaster']['aliquot_label'])));
					}
				}
			}
		}
	}

?>
