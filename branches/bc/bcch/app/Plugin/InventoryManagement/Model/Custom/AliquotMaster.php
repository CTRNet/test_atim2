<?php
class AliquotMasterCustom extends AliquotMaster {

	var $useTable = 'aliquot_masters';	
	var $name = 'AliquotMaster';	
	
	function summary($variables=array()) {
		$return = false;
		
		if (isset($variables['Collection.id']) && isset($variables['SampleMaster.id']) && isset($variables['AliquotMaster.id'])) {
			
			$result = $this->find('first', array('conditions'=>array('AliquotMaster.collection_id'=>$variables['Collection.id'], 'AliquotMaster.sample_master_id'=>$variables['SampleMaster.id'], 'AliquotMaster.id'=>$variables['AliquotMaster.id'])));
			if(!isset($result['AliquotMaster']['storage_coord_y'])){
				$result['AliquotMaster']['storage_coord_y'] = "";
			}
			$return = array(
					'menu'	        	=> array(null, __($result['AliquotControl']['aliquot_type'], true) . ' : '. $result['AliquotMaster']['aliquot_label']),
					'title'		  		=> array(null, __($result['AliquotControl']['aliquot_type'], true) . ' : '. $result['AliquotMaster']['aliquot_label']),
					'data'				=> $result,
					'structure alias'	=> 'aliquot_masters'
			);
		}
		
		return $return;
	}
	
	function generateDefaultAliquotLabel($view_sample, $aliquot_control_data) {
		// Parameters check: Verify parameters have been set
/*		if(empty($view_sample) || empty($aliquot_control_data)) AppController::getInstance()->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
			
		$default_aliquot_label = '';
		if($view_sample['ViewSample']['bank_id'] == 4) {
			//*** Prostate Bank ***		
			$idenitfier_value = empty($view_sample['ViewSample']['identifier_value'])? '?': $view_sample['ViewSample']['identifier_value'];
			$visit_label = empty($view_sample['ViewSample']['visit_label'])? '?': $view_sample['ViewSample']['visit_label'];
			$label = '-?';
			switch($view_sample['ViewSample']['sample_type'].'-'.$aliquot_control_data['AliquotControl']['aliquot_type']) {
				case 'blood-tube':
					$this->SampleMaster = AppModel::getInstance('InventoryManagement', 'SampleMaster', true);
					$sample_data = $this->SampleMaster->find('first', array('conditions' => array('SampleMaster.id' => $view_sample['ViewSample']['sample_master_id']), 'recursive' => '0'));
					if($sample_data) {
						switch($sample_data['SampleDetail']['blood_type']) {
							case 'gel SST':
								$label = '-SRB';
								break;
							case 'paxgene':
								$label = '-RNB';
								break;
							case 'EDTA':
								$label = '-EDB';
								break;
						}
					}
					break;
				case 'blood-whatman paper':
					$label = '-WHT';
					break;
				case 'serum-tube':
					$label = '-SER';
					break;
				case 'plasma-tube':
					$label = '-PLA';
					break;
				case 'pbmc-tube':
					$label = '-BFC';
					break;
				case 'urine-cup':
					$label = '-URI';
					break;
				case 'centrifuged urine-tube':
					$label = '-URN';
					break;
				case 'tissue-block':
					$label = '-FRZ';
					break;
				case 'rna-tube':
					$label = '-RNA';
					break;
				case 'dna-tube':
					$label = '-DNA';
					break;
			}
			$default_aliquot_label = $idenitfier_value . ' ' . $visit_label . ' ' . $label;
		} else {
			// *** Other Bank ***
			
			// Set date for aliquot label			
			$aliquot_creation_date = '';			
			if($view_sample['ViewSample']['sample_category'] == 'specimen'){
				// Specimen Aliquot
				if(!isset($this->SpecimenDetail)){
					$this->SpecimenDetail = AppModel::getInstance('InventoryManagement', 'SpecimenDetail', true);
				}
				$specimen_detail = $this->SpecimenDetail->getOrRedirect($view_sample['ViewSample']['sample_master_id']);
				
				$aliquot_creation_date = $specimen_detail['SpecimenDetail']['reception_datetime'];
	
			}else{
				// Derviative Aliquot
				if(!isset($this->DerivativeDetail)){
					$this->DerivativeDetail = AppModel::getInstance('InventoryManagement', 'DerivativeDetail', true);
				}
				
				$derivative_detail = $this->DerivativeDetail->getOrRedirect($view_sample['ViewSample']['sample_master_id']);
				
				$aliquot_creation_date = $derivative_detail['DerivativeDetail']['creation_datetime'];
			} 
			
			$default_aliquot_label =
				(empty($view_sample['ViewSample']['qc_nd_sample_label'])? 'n/a' : $view_sample['ViewSample']['qc_nd_sample_label']) .
				(empty($aliquot_creation_date)? '' : ' ' . substr($aliquot_creation_date, 0, strpos($aliquot_creation_date," ")));
		}
		*/
		$default_aliquot_label = "BCCH Custom Label";
		return $default_aliquot_label;
	}
	
	function generateAliquotBarcode($aliquotIDs) {
		
		// Get all aliquots that now need barcodes
		$aliquots_to_update = 
			$this->find('all', array('conditions' => array('AliquotMaster.id' => $aliquotIDs)));			
		
		// Find next barcode to use
		$new_barcode = $this->findNextBarcode();
		
		// Update barcode for selected aliquots
		foreach($aliquots_to_update as $aliquot) {
			$aliquot_data = array('AliquotMaster' => array('barcode' => $new_barcode), 'AliquotDetail' => array());
			$this->id = $aliquot['AliquotMaster']['id'];
			$this->data = null;
			$this->addWritableField(array('barcode'));
			$this->save($aliquot_data, false);
		}
	
	}
	
	function findNextBarcode() {
		
		// Find aliquot with the highest barcode
		$lastAliquot = 
			$this->find('first', array('conditions' => array('AliquotMaster.deleted' => array(0,1)),
			'order' => array('AliquotMaster.barcode' => 'desc')));
		$next_barcode = $lastAliquot['AliquotMaster']['barcode'];
		
		// Increment last used barcode by 1	
 		$next_barcode = $next_barcode + 1;
		return $next_barcode;
	}
}

?>