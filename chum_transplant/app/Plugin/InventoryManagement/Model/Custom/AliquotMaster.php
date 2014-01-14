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
	
	function regenerateAliquotBarcode() {
		$aliquots_to_update = $this->find('all', array('conditions' => array("AliquotMaster.barcode IS NULL OR AliquotMaster.barcode LIKE ''"), 'fields' => array('AliquotMaster.id')));
		foreach($aliquots_to_update as $new_aliquot) {
			$new_aliquot_id = $new_aliquot['AliquotMaster']['id'];
			$aliquot_data = array('AliquotMaster' => array('barcode' => $new_aliquot_id), 'AliquotDetail' => array());
			
			$this->id = $new_aliquot_id;
			$this->data = null;
			$this->addWritableField(array('barcode'));
			$this->save($aliquot_data, false);
		}
	}
	
	function generateDefaultAliquotLabel($view_sample, $aliquot_control_data) {
		$acquisition_label = $view_sample['ViewSample']['acquisition_label'];
		$collection_datetime = '00000000';
		if(!empty($view_sample['ViewSample']['collection_datetime'])) {
			switch($view_sample['ViewSample']['collection_datetime_accuracy']) {
				case 'y':
					$collection_datetime = substr(str_replace('-','', $view_sample['ViewSample']['collection_datetime']), 0, 3).'0000';
					break;
				case 'm':
					$collection_datetime = substr(str_replace('-','', $view_sample['ViewSample']['collection_datetime']), 0, 4).'0000';
					break;
				case 'd':
					$collection_datetime = substr(str_replace('-','', $view_sample['ViewSample']['collection_datetime']), 0, 6).'00';
					break;
				default:
					$collection_datetime = substr(str_replace('-','', $view_sample['ViewSample']['collection_datetime']), 0, 8);
			}
		}
		$transplant_type_label = 'N';
		switch($view_sample['ViewSample']['chum_transplant_type']) {
			case 'donor time 0':
				$transplant_type_label = 'D';
				break;
			case 'recipient pre transplant':
				$transplant_type_label = 'N';
				break;
			case 'recipient time 0':
				$transplant_type_label = '0N';
				break;
			case 'recipient time 1':
				$transplant_type_label = '1N';
				break;
			case 'recipient time 3':
				$transplant_type_label = '3N';
				break;
			case 'recipient time 6':
				$transplant_type_label = '6N';
				break;
			case 'recipient time 12':
				$transplant_type_label = '12N';
				break;
			case 'recipient time 24':
				$transplant_type_label = '24N';
				break;
			case 'recipient yearly':
				$transplant_type_label = '?';
				break;
			case 'recipient event':
				$transplant_type_label = 'E';
				break;
		}
		$sample_type_label = '?';
		switch($view_sample['ViewSample']['sample_type']) {
			case 'tissue':
				$sample_type_label = 'T';
				break;
			case 'serum':
				$sample_type_label = 'A';
				break;
			case 'plasma':
				$sample_type_label = 'B';
				break;
			case 'urine':
				$sample_type_label = 'E';
				break;
		}
		return $acquisition_label.'-'.$collection_datetime.'-'.$transplant_type_label.'-'.$sample_type_label;
	}

}

?>
