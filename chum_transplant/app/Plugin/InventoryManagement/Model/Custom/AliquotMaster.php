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
		$collection_model = AppModel::getInstance('InventoryManagement', 'Collection', true);
		$collection_model->unbindModel(array('hasMany' => array('SampleMaster'), 'belongsTo' => array('Participant','DiagnosisMaster','ConsentMaster')));
		$collection_data = $collection_model->find('first', array('conditions' => array('Collection.id' => $view_sample['ViewSample']['collection_id'])));
		
		$acquisition_label = $view_sample['ViewSample']['acquisition_label'];
		
		$collection_datetime = '0000-00-00';
		if(!empty($collection_data['Collection']['collection_datetime'])) {
			switch($collection_data['Collection']['collection_datetime_accuracy']) {
				case 'y':
				case 'm':
					$collection_datetime = substr($collection_data['Collection']['collection_datetime'], 0, 4).'-00-00';
					break;
				case 'd':
					$collection_datetime = substr($collection_data['Collection']['collection_datetime'], 0, 7).'-00';
					break;
				default:
					$collection_datetime = substr($collection_data['Collection']['collection_datetime'], 0, 10);
			}
		}
		$collection_datetime_tmp = explode('-', $collection_datetime);
		$collection_datetime = $collection_datetime_tmp[2].'-'.$collection_datetime_tmp[1].'-'.$collection_datetime_tmp[0];
		
		$biopsy_label = $collection_data['EventMaster']['id']? '/E' : '';
		$collection_type_label = '000N'.$biopsy_label;
		switch($view_sample['ViewSample']['chum_transplant_type']) {
			case 'donor time 0':
				$collection_type_label = '000N'.$biopsy_label; 	//TODO to confirm
				break;
			case 'recipient pre transplant':
				$collection_type_label = '000N'.$biopsy_label;	//TODO to confirm
				break;
			case 'recipient time 0':
				$collection_type_label = '000N'.$biopsy_label;
				break;
			case 'recipient time 1':
				$collection_type_label = '001N'.$biopsy_label;
				break;
			case 'recipient time 3':
				$collection_type_label = '003N'.$biopsy_label;
				break;
			case 'recipient time 6':
				$collection_type_label = '006N'.$biopsy_label;
				break;
			case 'recipient time 12':
				$collection_type_label = '012N'.$biopsy_label;
				break;
			case 'recipient time 24':
				$collection_type_label = '024N'.$biopsy_label;
				break;
			case 'recipient yearly':
			case 'recipient event':
				$start_date = $collection_data['TreatmentMaster']['start_date'];
				$end_date =substr($collection_data['Collection']['collection_datetime'], 0, 10);
				$tmp_months = '???';
				if(!empty($start_date) && !empty($end_date)) {
					$start_date = new DateTime($start_date);
					$end_date = new DateTime($end_date);
					$interval = $start_date->diff($end_date);
					if(!$interval->invert) {
						$tmp_months = $interval->y*12 + $interval->m;
						$tmp_months = str_pad($tmp_months, 3, '0', STR_PAD_LEFT);
					}
				}
				$collection_type_label = $tmp_months.($view_sample['ViewSample']['chum_transplant_type'] == 'recipient yearly'? 'N' : 'E').$biopsy_label;	//TODO to confirm
				break;
		}
		
		$sample_type_label = '?';
		switch($view_sample['ViewSample']['sample_type']) {
			case 'tissue':
				$sample_type_label = 'D';
				break;
			case 'serum':
				$sample_type_label = 'A';
				break;
			case 'plasma':
				$sample_type_label = 'B';
				break;
			case 'centrifuged urine':
				$sample_type_label = 'E';
				break;
			case 'pbmc':
				$sample_type_label = 'F';
				break;
			case 'blood':
			case 'rna':
			case 'dna':
		}
		
		return $acquisition_label.' '.$collection_datetime.' '.$collection_type_label.' ?:? '.$sample_type_label;
	}

}

?>
