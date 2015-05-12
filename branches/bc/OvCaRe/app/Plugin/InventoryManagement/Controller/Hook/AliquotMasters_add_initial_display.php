<?php

	//Get the last storage used for this type of aliquot
	$last_aliquot_created = $this->AliquotMaster->find('first', array('conditions' => array('AliquotMaster.aliquot_control_id' => $aliquot_control['AliquotControl']['id'], 'AliquotMaster.storage_master_id IS NOT NULL', "AliquotMaster.storage_master_id NOT LIKE ''"), 'order' => 'AliquotMaster.created DESC', 'recursive' => '0'));
	$default_selection_label = $last_aliquot_created? $last_aliquot_created['StorageMaster']['selection_label']: '';
	
	//Set data
	$default_aliquot_data = array();
	foreach($this->request->data as &$new_data_set){	
		$view_sample = $new_data_set['parent'];
		// ** 1 ** Set default aliquot data **
		$tmp_default_aliquot_data = array(
			'AliquotMaster.aliquot_label' => 'VOA'.$view_sample['ViewSample']['ovcare_collection_voa_nbr'],
			'AliquotMaster.ovcare_clinical_aliquot' => 'no');
		$ovcare_default_storage_datetime = array('ovcare_storage_datetime_buffy_coat' => null, 'ovcare_storage_datetime_plasma_serum' => null);
		$ovcare_storage_datetime_plasma_serum = null;
		if(isset(AppController::getInstance()->passedArgs['templateInitId'])) {
			$template_init_data = AppController::getInstance()->Session->read('Template.init_data.'.AppController::getInstance()->passedArgs['templateInitId']);
			if($template_init_data && array_key_exists('0', $template_init_data) && array_key_exists('ovcare_storage_datetime_buffy_coat', $template_init_data['0'])) {
				foreach(array('ovcare_storage_datetime_buffy_coat','ovcare_storage_datetime_plasma_serum') as $tmp_field) {
					$ovcare_default_storage_datetime[$tmp_field] = null;
					if($template_init_data['0'][$tmp_field]['year']) $ovcare_default_storage_datetime[$tmp_field] = $template_init_data['0'][$tmp_field]['year'];
					if($ovcare_default_storage_datetime[$tmp_field] && $template_init_data['0'][$tmp_field]['month']) $ovcare_default_storage_datetime[$tmp_field] .= '-'.$template_init_data['0'][$tmp_field]['month'];
					if($ovcare_default_storage_datetime[$tmp_field] && $template_init_data['0'][$tmp_field]['day']) $ovcare_default_storage_datetime[$tmp_field] .= '-'.$template_init_data['0'][$tmp_field]['day'];
					if($ovcare_default_storage_datetime[$tmp_field] && $template_init_data['0'][$tmp_field]['hour']) $ovcare_default_storage_datetime[$tmp_field] .= ' '.$template_init_data['0'][$tmp_field]['hour'];
					if($ovcare_default_storage_datetime[$tmp_field] && $template_init_data['0'][$tmp_field]['min']) $ovcare_default_storage_datetime[$tmp_field] .= ':'.$template_init_data['0'][$tmp_field]['min'];
				}
			}
		}
		switch($view_sample['ViewSample']['sample_type']) {
			case 'blood cell':
				$tmp_default_aliquot_data['AliquotMaster.aliquot_label'] .= 'BC';
				$tmp_default_aliquot_data['AliquotMaster.initial_volume'] = '1.0';
				$tmp_default_aliquot_data['FunctionManagement.recorded_storage_selection_label'] = $default_selection_label;
				if($ovcare_default_storage_datetime['ovcare_storage_datetime_buffy_coat']) $tmp_default_aliquot_data['AliquotMaster.storage_datetime'] = $ovcare_default_storage_datetime['ovcare_storage_datetime_buffy_coat'];
				break;
			case 'plasma':
				$tmp_default_aliquot_data['AliquotMaster.aliquot_label'] .= 'P';
				$tmp_default_aliquot_data['AliquotMaster.initial_volume'] = '1.8';
				$tmp_default_aliquot_data['AliquotDetail.hemolysis_signs'] = 'n';
				$tmp_default_aliquot_data['FunctionManagement.recorded_storage_selection_label'] = $default_selection_label;
				if($ovcare_default_storage_datetime['ovcare_storage_datetime_plasma_serum']) $tmp_default_aliquot_data['AliquotMaster.storage_datetime'] = $ovcare_default_storage_datetime['ovcare_storage_datetime_plasma_serum'];
				break;
			case 'serum':
				$tmp_default_aliquot_data['AliquotMaster.aliquot_label'] .= 'S';
				$tmp_default_aliquot_data['AliquotMaster.initial_volume'] = '1.8';
				$tmp_default_aliquot_data['AliquotDetail.hemolysis_signs'] = 'n';
				$tmp_default_aliquot_data['FunctionManagement.recorded_storage_selection_label'] = $default_selection_label;
				if($ovcare_default_storage_datetime['ovcare_storage_datetime_plasma_serum']) $tmp_default_aliquot_data['AliquotMaster.storage_datetime'] = $ovcare_default_storage_datetime['ovcare_storage_datetime_plasma_serum'];
				break;
			case 'ascite':
				$tmp_default_aliquot_data['AliquotMaster.aliquot_label'] .= 'Ascites';
				break;
			case 'saliva':
				$tmp_default_aliquot_data['AliquotMaster.aliquot_label'] .= 'Saliva';
				break;
			case 'tissue':
				if($aliquot_control['AliquotControl']['aliquot_type'] == 'block') {
					if(!isset(AppController::getInstance()->passedArgs['templateInitId'])) $tmp_default_aliquot_data['AliquotDetail.block_type'] = 'paraffin';
				} else if($aliquot_control['AliquotControl']['aliquot_type'] == 'tube') {
					$tmp_default_aliquot_data['AliquotDetail.ovcare_storage_method'] = 'snap frozen';
				}
				break;
		}
		$default_aliquot_data[$view_sample['ViewSample']['sample_master_id']] = $tmp_default_aliquot_data;
		// ** 2 ** Set aliquot label of the first aliquots displayed **
		$existing_patient_aliquots_nbr = $this->AliquotMaster->find('count', array('conditions' => array('AliquotMaster.collection_id' => $view_sample['ViewSample']['collection_id'], 'AliquotMaster.aliquot_control_id' => $aliquot_control['AliquotControl']['id'], 'Collection.participant_id' => $view_sample['ViewSample']['participant_id']), 'recursive' => '0'));
		if($view_sample['ViewSample']['sample_type'] == 'tissue') {
			$next_labels = null;
			if($aliquot_control['AliquotControl']['aliquot_type'] == 'tube') {
				$next_labels = array_slice(range('a', 'z'), $existing_patient_aliquots_nbr);
			} else if($aliquot_control['AliquotControl']['aliquot_type'] == 'block'){
				$next_labels = array_slice(range('A', 'Z'), $existing_patient_aliquots_nbr);
			}
			if($next_labels) {
				foreach($new_data_set['children'] as &$new_aliquot) {
					$new_aliquot['AliquotDetail']['ocvare_tissue_section'] = array_shift($next_labels);
					$new_aliquot['AliquotMaster']['aliquot_label'] = $tmp_default_aliquot_data['AliquotMaster.aliquot_label'].$new_aliquot['AliquotDetail']['ocvare_tissue_section'];
				}
			}
		} else {
			foreach($new_data_set['children'] as &$new_aliquot) {
				$new_aliquot['AliquotMaster']['aliquot_label'] = $tmp_default_aliquot_data['AliquotMaster.aliquot_label'].($existing_patient_aliquots_nbr? $existing_patient_aliquots_nbr : '');
				$existing_patient_aliquots_nbr++;
			}
		}	
	}
	$this->set('default_aliquot_data', $default_aliquot_data);

?>
