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
	
	function generateSystemAliquotBarcode($aliquot_master_ids = array()) {
		if(!empty($aliquot_master_ids)) {
			$query = "UPDATE aliquot_masters SET barcode = CONCAT('SYS#',id) WHERE id IN (".implode(',',$aliquot_master_ids).") AND (barcode LIKE '' OR barcode IS NULL)";
			$this->tryCatchQuery($query);
			$this->tryCatchQuery(str_replace('aliquot_masters', 'aliquot_masters_revs', $query));
			//The Barcode values of AliquotView will be updated by AppModel::releaseBatchViewsUpdateLock(); call in AliquotMaster.add() and AliquotMaster.realiquot() function
		}
	}
	
	function validateBarcodeInput($new_aliquot) {
		if(is_array($new_aliquot) && isset($new_aliquot['AliquotMaster']) && array_key_exists('barcode', $new_aliquot['AliquotMaster'])) {
			//Barcode has to be validated
			if(preg_match('/^syst#/i', $new_aliquot['AliquotMaster']['barcode'])) {
				return false;
			}
		}
		return true;
	}
	
	function getSystemBarcodePattern() {
		return 'SYS#';
	}

	function generateDefaultAliquotLabel($view_sample, $aliquot_control_data) {
		$default_aliquot_label = 'n/a';
		
		// Parameters check: Verify parameters have been set
		if(empty($view_sample) || empty($aliquot_control_data)) AppController::getInstance()->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		
		//Collection Variables
		$this->Collection = AppModel::getInstance("InventoryManagement", "Collection", true);
		$qcroc_project_number = array_shift($this->Collection->getQcrocCollectionProjectNumbers($view_sample['ViewSample']['qcroc_misc_identifier_control_id']));
		$collection_type = $view_sample['ViewSample']['qcroc_collection_type'];
		$collection_visit = $view_sample['ViewSample']['qcroc_collection_visit'];
		$participant_qcroc_id = $view_sample['ViewSample']['identifier_value'];
		
		switch($view_sample['ViewSample']['sample_type']) {
			case 'plasma':
				$this->SampleMaster = AppModel::getInstance("InventoryManagement", "SampleMaster", true);
				$this->SampleMaster->unbindModel(array('belongsTo' => array('Collection'),'hasOne' => array('SpecimenDetail','DerivativeDetail'),'hasMany' => array('AliquotMaster')),false);
				$specimen_data = $this->SampleMaster->find('first', array('conditions' => array('SampleMaster.id' => $view_sample['ViewSample']['initial_specimen_sample_id']), 'recursive' => '0'));
				$blood_key = '?';
				if($specimen_data) {
					switch($specimen_data['SampleDetail']['blood_type']) {
						case 'CTAD':
							$blood_key = '1';
							break;
						case 'EDTA':
							$blood_key = '2';
							break;
					}
				}
				$default_aliquot_label = "$qcroc_project_number-$collection_type$collection_visit-$participant_qcroc_id-$blood_key-";
				break;
			case 'pbmc':
				$default_aliquot_label = "$qcroc_project_number-$collection_type$collection_visit-$participant_qcroc_id-3-";
				break;
			case 'tissue':
				if($aliquot_control_data['AliquotControl']['aliquot_type'] == 'tube') {
					$participant_qcroc_id = sprintf("%03d", $participant_qcroc_id);
					$default_aliquot_label = "$qcroc_project_number-$collection_visit-$participant_qcroc_id-";
				}
				break;
		}
		
		return $default_aliquot_label;
	}
}

?>
