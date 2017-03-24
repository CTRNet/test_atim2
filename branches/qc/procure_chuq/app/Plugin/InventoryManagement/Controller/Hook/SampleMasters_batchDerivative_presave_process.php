<?php 
	
	// Set data to complete the procure_created_by_bank field
	foreach($prev_data as &$children){
		foreach($children as &$child_to_save){
			$child_to_save['SampleMaster']['procure_created_by_bank'] = Configure::read('procure_bank_id');
		}
	}
	$this->SampleMaster->addWritableField(array('procure_created_by_bank'));
	
	//Manage record of the initial weight of blood tubes
	if($procure_tube_weights_to_save) {
		//Validate initial blood tube weight value and re-set submitted data to display if validation failed
		$record_counter = 0;
		foreach($this->request->data as &$procure_data_set_to_redisplay) {
			$record_counter++;
			if(array_key_exists($procure_data_set_to_redisplay['parent']['AliquotMaster']['id'], $procure_tube_weights_to_save)) {
				$procure_tube_weight_gr = str_replace(',', '.', $procure_tube_weights_to_save[$procure_data_set_to_redisplay['parent']['AliquotMaster']['id']]);
				//Re-set submitted data in case validation failed
				$procure_data_set_to_redisplay['parent']['AliquotDetail']['procure_tube_weight_gr'] = $procure_tube_weight_gr;
				//Validate procure_tube_weight_gr
				if(strlen($procure_tube_weight_gr) && !preg_match('/^(([0-9]+)|([0-9]*\.[0-9]+))$/', $procure_tube_weight_gr)) {	//Note: unable to use form validation.
					$errors['procure_tube_weight_gr'][__('error_must_be_positive_float').' ('.__('initial tube weight gr').')'][$record_counter] = $record_counter;
				}
			}			
		}
		//Add submitted initial blood tube weights to data to save
		foreach($aliquots_data as &$aliquot_data_to_save) {
			$add_wirtable_field = false;
			if(array_key_exists($aliquot_data_to_save['AliquotMaster']['id'], $procure_tube_weights_to_save)) {
				$aliquot_data_to_save['AliquotDetail']['procure_tube_weight_gr'] = $procure_tube_weights_to_save[$aliquot_data_to_save['AliquotMaster']['id']];
			}
		}
	}
	