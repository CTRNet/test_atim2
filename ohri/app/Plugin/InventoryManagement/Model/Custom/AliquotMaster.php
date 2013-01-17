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
					'menu'	        	=> array(null, __($result['AliquotControl']['aliquot_type']) . ' : '. $result['AliquotMaster']['aliquot_label']),
					'title'		  		=> array(null, __($result['AliquotControl']['aliquot_type']) . ' : '. $result['AliquotMaster']['aliquot_label']),
					'data'				=> $result,
					'structure alias'	=> 'aliquot_masters'
			);
		}
		
		return $return;
	}
	
	function getDefaultLabel($view_sample_data, $aliquot_control_id, $is_realiquoting = false) {
		$inital_data = array();
	
		if(in_array($view_sample_data['sample_type'], array('ascite supernatant', 'ascite cell', 'cell culture', 'tissue'))) {
				
			// Participant participant_id and Bank Number
			$bank_number = empty($view_sample_data['participant_identifier'])? 'n/a' : $view_sample_data['participant_identifier'];
			$participant_id = empty($view_sample_data['participant_id'])? null : $view_sample_data['participant_id'];
	
			// Get aliquot already created
			$aliquot_control_data = $this->AliquotControl->findById($aliquot_control_id);
			$criteria = array('ViewAliquot.sample_control_id' => $view_sample_data['sample_control_id'],
					'ViewAliquot.aliquot_control_id' => $aliquot_control_data['AliquotControl']['id']);
			if(empty($participant_id)) {
				$criteria['ViewAliquot.collection_id'] = $view_sample_data['collection_id'];
			} else {
				$criteria['ViewAliquot.participant_id'] = $participant_id;
			}
			$existing_aliquots_list = $this->ViewAliquot->find('all', array('conditions' => $criteria));
				
			switch($view_sample_data['sample_type']) {
	
				case 'ascite supernatant':
					$inital_data[0]['AliquotMaster']['aliquot_label'] = $bank_number . ' S' . (sizeof($existing_aliquots_list)+1);
					$inital_data[0]['AliquotMaster']['initial_volume'] = '15';
						
					break;
						
				case 'ascite cell':
					$ids = array();
					foreach($existing_aliquots_list as $new_aliq) {
						$ids[] = $new_aliq['ViewAliquot']['aliquot_master_id'];
					}
						
					$flash_frozen_count = 0;
					$dmso_count = 0;
					if(!empty($existing_aliquots_list)) {
						$aliquots_details = $this->find('all',  array('conditions' => array('AliquotMaster.id' => $ids)));
						foreach($aliquots_details as $tmp_al)	{
							if(isset($tmp_al['AliquotDetail']['ohri_storage_method']) && $tmp_al['AliquotDetail']['ohri_storage_method'] == 'flash frozen') {
								$flash_frozen_count++;
							}else if(isset($tmp_al['AliquotDetail']['ohri_storage_solution']) && $tmp_al['AliquotDetail']['ohri_storage_solution'] == 'dmso') {
								$dmso_count++;
							}
						}
					}
	
					$inital_data[0]['AliquotMaster']['initial_volume'] = '1';
					$inital_data[1] = $inital_data[0];
						
					$inital_data[0]['AliquotDetail']['ohri_storage_method'] = 'flash frozen';
					$inital_data[0]['AliquotMaster']['aliquot_label'] = $bank_number . ' A' . ($flash_frozen_count+1);
						
					$inital_data[1]['AliquotDetail']['ohri_storage_solution'] = 'dmso';
					$inital_data[1]['AliquotMaster']['aliquot_label'] = $bank_number . ' C' . ($dmso_count+1);
					break;
						
				case 'cell culture':
					$inital_data[0]['AliquotMaster']['initial_volume'] = '1';
					break;
						
				case 'tissue':
					if($aliquot_control_data['AliquotControl']['aliquot_type'] == 'block') {
						$inital_data[0]['AliquotMaster']['aliquot_label'] = $bank_number . ' B' . (sizeof($existing_aliquots_list)+1);
						$inital_data[0]['AliquotDetail']['block_type'] = 'paraffin';
					} else if($aliquot_control_data['AliquotControl']['aliquot_type'] == 'tube') {
						$inital_data[0]['AliquotMaster']['aliquot_label'] = $bank_number . ' T' . (sizeof($existing_aliquots_list)+1);
						$inital_data[0]['AliquotDetail']['ohri_storage_method'] = 'flash frozen';
					}
					break;
						
				default:
			}
		}
	
		return $inital_data;
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
	
}

?>
