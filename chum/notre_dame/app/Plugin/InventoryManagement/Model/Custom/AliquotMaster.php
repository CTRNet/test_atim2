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
		if(empty($view_sample) || empty($aliquot_control_data)) AppController::getInstance()->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
			
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
			
		} else if($view_sample['ViewSample']['bank_id'] == 8) {
			
			// *** Autopsy Bank ***
			
			$this->Collection = AppModel::getInstance('InventoryManagement', 'Collection', true);
			$tmp_col_data = $this->Collection->find('first', array('conditions' => array('id' => $view_sample['ViewSample']['collection_id']), 'recursive' => '-1'));
			$collection_date_time =  (!empty($tmp_col_data['Collection']['collection_datetime']) && preg_match('/^[0-9]{2}([0-9]{2})\-[0-9]{2}\-[0-9]{2}/', $tmp_col_data['Collection']['collection_datetime'], $matches))? $matches['1'] : '?';
			$idenitfier_value = empty($view_sample['ViewSample']['identifier_value'])? '?': substr($view_sample['ViewSample']['identifier_value'], 3, 3);
			$qc_nd_sample_label = (!empty($view_sample['ViewSample']['qc_nd_sample_label']) && preg_match('/A\-([A-Z]+)/', $view_sample['ViewSample']['qc_nd_sample_label'], $matches))? $matches['1'] : '?';
			$default_aliquot_label = $collection_date_time.$idenitfier_value.$qc_nd_sample_label;
			
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
		
		return $default_aliquot_label;
	}
	
	function regenerateAliquotBarcode() {
		$query_to_update = "UPDATE aliquot_masters SET barcode = id WHERE barcode IS NULL OR barcode LIKE '';";
		$this->tryCatchQuery($query_to_update);
		$this->tryCatchQuery(str_replace("aliquot_masters", "aliquot_masters_revs", $query_to_update));
	}
}

?>
