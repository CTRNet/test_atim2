<?php
	
	// --------------------------------------------------------------------------------
	// Regenerate default barcodes
	// -------------------------------------------------------------------------------- 	
	$this->AliquotMaster->regenerateAliquotBarcode();
	
	// -------------------------------------------------------------------------------
	// Generate block, slide and core aliquot label
	// -------------------------------------------------------------------------------
	$linked_collection_ids = array();
	foreach($this->request->data as $created_aliquots) $linked_collection_ids[] = $created_aliquots['parent']['ViewSample']['collection_id'];
	$this->AliquotMaster->updateAliquotLabel($linked_collection_ids);
	
	// -------------------------------------------------------------------------------
	// Check duplicated patho id +block id
	// -------------------------------------------------------------------------------
	if($aliquot_control['AliquotControl']['aliquot_type'] == 'block') {
		foreach($this->request->data as $created_aliquots){
			foreach($created_aliquots['children'] as $new_aliquot) {
				if(isset($new_aliquot['AliquotDetail']['patho_dpt_block_code'])) {
					$conditions = array(
						'AliquotMaster.aliquot_label' => $created_aliquots['parent']['ViewSample']['qbcf_pathology_id'].' '.$new_aliquot['AliquotDetail']['patho_dpt_block_code'],
						'AliquotMaster.aliquot_control_id' => $aliquot_control['AliquotControl']['id']);
					if($this->AliquotMaster->find('count', array('conditions' => $conditions, 'recursive' => '-1')) > 1) {
						AppController::addWarningMsg(__('more than one block have the same aliquot label [%s] - please validate', $created_aliquots['parent']['ViewSample']['qbcf_pathology_id'].' '.$new_aliquot['AliquotDetail']['patho_dpt_block_code']));
					}
				}
			}
		}
	}

?>
