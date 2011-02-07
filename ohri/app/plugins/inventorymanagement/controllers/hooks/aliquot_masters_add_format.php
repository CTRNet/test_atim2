<?php
 
 	// --------------------------------------------------------------------------------
	// Set Default Aliquot Data
	// -------------------------------------------------------------------------------- 	
	
	if(empty($this->data)) {
		// Participant participant_id and Bank Number
		if(!isset($this->ViewSample)) {
			App::import('Model', 'Inventorymanagement.ViewSample');
			$this->ViewSample = new ViewSample();					
		}
		$tmp_view_sample_data = $this->ViewSample->find('first', array('conditions' => array('ViewSample.sample_master_id' => $sample_master_id)));
		$bank_number = empty($tmp_view_sample_data['ViewSample']['ohri_bank_participant_id'])? 'n/a' : $tmp_view_sample_data['ViewSample']['ohri_bank_participant_id'];
		$participant_id = empty($tmp_view_sample_data['ViewSample']['participant_id'])? null : $tmp_view_sample_data['ViewSample']['participant_id'];

		switch($sample_data['SampleMaster']['sample_type']) {
			
			case 'ascite supernatant':
				$aliquot_count = $this->ViewAliquot->find('count', array('conditions' => array(
					'ViewAliquot.sample_control_id' => $tmp_view_sample_data['ViewSample']['sample_control_id'], 
					'ViewAliquot.aliquot_control_id' => $aliquot_control_data['AliquotControl']['id'],
					'ViewAliquot.participant_id' => $participant_id)));
				
				$inital_data[0]['AliquotMaster']['barcode'] = $bank_number . ' S' . ($aliquot_count+1);
				$inital_data[0]['AliquotMaster']['initial_volume'] = '15';
				
				break;
				
			case 'ascite cell':
				$aliquots_list = $this->ViewAliquot->find('all', array('conditions' => array(
					'ViewAliquot.sample_control_id' => $tmp_view_sample_data['ViewSample']['sample_control_id'], 
					'ViewAliquot.aliquot_control_id' => $aliquot_control_data['AliquotControl']['id'],
					'ViewAliquot.participant_id' => $participant_id)));				
				$ids = array();
				foreach($aliquots_list as $new_aliq) {
					$ids[] = $new_aliq['ViewAliquot']['aliquot_master_id'];
				}	
				
				$flash_frozen_count = 0;
				$dmso_count = 0;
				if(!empty($aliquots_list)) {
					$aliquots_details = $this->AliquotMaster->find('all',  array('conditions' => array('AliquotMaster.id' => $ids)));	
					foreach($aliquots_details as $tmp_al)	{
						if($tmp_al['AliquotDetail']['ohri_storage_method'] == 'flash frozen') {
							$flash_frozen_count++;
						} else if($tmp_al['AliquotDetail']['ohri_storage_solution'] == 'dmso') {
							$dmso_count++;
						}
					}		
				}

				$inital_data[0]['AliquotMaster']['initial_volume'] = '1';
				$inital_data[1] = $inital_data[0];
				
				$inital_data[0]['AliquotDetail']['ohri_storage_method'] = 'flash frozen';
				$inital_data[0]['AliquotMaster']['barcode'] = $bank_number . ' A' . ($flash_frozen_count+1);
				
				$inital_data[1]['AliquotDetail']['ohri_storage_solution'] = 'dmso';
				$inital_data[1]['AliquotMaster']['barcode'] = $bank_number . ' C' . ($dmso_count+1);
				break;
				
			case 'cell culture':				
				$inital_data[0]['AliquotMaster']['initial_volume'] = '1';
				break;
				
			case 'tissue':
				$aliquot_count = $this->ViewAliquot->find('count', array('conditions' => array(
					'ViewAliquot.sample_control_id' => $tmp_view_sample_data['ViewSample']['sample_control_id'], 
					'ViewAliquot.aliquot_control_id' => $aliquot_control_data['AliquotControl']['id'],
					'ViewAliquot.participant_id' => $participant_id)));				
				
				if($aliquot_control_data['AliquotControl']['aliquot_type'] == 'block') {
					$inital_data[0]['AliquotMaster']['barcode'] = $bank_number . ' B' . ($aliquot_count+1);
					$inital_data[0]['AliquotDetail']['block_type'] = 'paraffin';
				} else if($aliquot_control_data['AliquotControl']['aliquot_type'] == 'tube') {
					$inital_data[0]['AliquotMaster']['barcode'] = $bank_number . ' T' . ($aliquot_count+1);
					$inital_data[0]['AliquotDetail']['ohri_storage_method'] = 'flash frozen';
				}
				break;
				
			default:
		}
	}
	
?>