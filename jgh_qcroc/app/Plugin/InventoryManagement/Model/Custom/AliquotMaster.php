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
	
	function generateSystemAliquotBarcode() {
		$query = "UPDATE aliquot_masters SET barcode = CONCAT('SYS#',id) WHERE barcode LIKE '' OR barcode IS NULL";
		$this->tryCatchQuery($query);
		$this->tryCatchQuery(str_replace('aliquot_masters', 'aliquot_masters_revs', $query));
		//The Barcode values of AliquotView will be updated by AppModel::releaseBatchViewsUpdateLock(); call in AliquotMaster.add() and AliquotMaster.realiquot() function
	}
	
	function validateBarcodeInput($new_aliquot) {
		if(is_array($new_aliquot) && isset($new_aliquot['AliquotMaster']) && array_key_exists('barcode', $new_aliquot['AliquotMaster'])) {
			//Barcode has to be validated
			if(preg_match('/^'.$this->getSystemBarcodePattern().'$/i', $new_aliquot['AliquotMaster']['barcode'])) {
				return false;
			}
		}
		return true;
	}
	
	function getSystemBarcodePattern() {
		return 'SYS#[0-9]*';
	}

	function generateDefaultAliquotLabel($aliquot_control_data, $qcroc_collection_id, $sample_type, $initial_specimen_sample_id, $sample_master_id, $parent_aliquot_data = null) {
		$default_aliquot_label = "$qcroc_collection_id-";
		
		$tmp_counter = 0;
		switch($sample_type) {
			case 'tissue':
				//Nothing to change, unable to add data to block or slide because we don't know the parent
				switch($aliquot_control_data['AliquotControl']['aliquot_type']) {
					case 'tube':
						$default_aliquot_label = "$qcroc_collection_id-";
						break;
					case 'block':
						if(!$parent_aliquot_data) {
							$default_aliquot_label = "$qcroc_collection_id-?";
						} else if($parent_aliquot_data['aliquot_type'] == 'tube') {
							$default_aliquot_label = $parent_aliquot_data['aliquot_label'];							
						} else if($parent_aliquot_data['aliquot_type'] == 'block') {
							$default_aliquot_label = $parent_aliquot_data['aliquot_label'].'-N';							
						}					
						break;
					case 'slide':
						if(!$parent_aliquot_data) {
							$default_aliquot_label = "$qcroc_collection_id-?-l?";
						} else if($parent_aliquot_data['aliquot_type'] == 'block') {
							$default_aliquot_label = $parent_aliquot_data['aliquot_label'].'-l';							
						}						
						break;
				}
				break;
			case 'rna':
				$tmp_counter++;
			case 'dna':
				$query = "SELECT am.aliquot_label
					FROM source_aliquots sa INNER JOIN aliquot_masters am ON am.id = sa.aliquot_master_id
					WHERE sa.deleted <> 1 AND am.deleted <> 1 AND sa.sample_master_id = $sample_master_id";
				$derivative_aliquot_source = $this->tryCatchQuery($query);
				if($derivative_aliquot_source) {
					$default_aliquot_label = $derivative_aliquot_source[0]['am']['aliquot_label']."-".($tmp_counter? 'R':'D')."?-t";
				} else {
					$default_aliquot_label = "$qcroc_collection_id-?-".($tmp_counter? 'R':'D')."?-t";
				}
				break;
			case 'plasma':
				$tmp_counter++;
			case 'pbmc':
				$this->SampleMaster = AppModel::getInstance("InventoryManagement", "SampleMaster", true);
				$this->SampleMaster->unbindModel(array('belongsTo' => array('Collection'),'hasOne' => array('SpecimenDetail','DerivativeDetail'),'hasMany' => array('AliquotMaster')),false);
				$specimen_data = $this->SampleMaster->find('first', array('conditions' => array('SampleMaster.id' => $initial_specimen_sample_id), 'recursive' => '0'));
				$blood_key = '?';
				if($specimen_data) {
					switch($specimen_data['SampleDetail']['blood_type']) {
						case 'CTAD':
						case 'EDTA':
							$blood_key = $specimen_data['SampleDetail']['blood_type'];
							break;
					}
				}
				$default_aliquot_label = "$qcroc_collection_id-$blood_key-".($tmp_counter? 'P' : 'BC');
				break;
		
		}
		
		return $default_aliquot_label;
	}
}

?>
