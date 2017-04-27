<?php

class SampleMasterCustom extends SampleMaster {
	
	var $useTable = 'sample_masters';	
	var $name = 'SampleMaster';	
	
	function specimenSummary($variables=array()) {
		$return = false;
		
		if (isset($variables['Collection.id']) && isset($variables['SampleMaster.initial_specimen_sample_id'])) {
			// Get specimen data
			$criteria = array(
				'SampleMaster.collection_id' => $variables['Collection.id'],
				'SampleMaster.id' => $variables['SampleMaster.initial_specimen_sample_id']);
			$specimen_data = $this->find('first', array('conditions' => $criteria));
			
			// Set summary	 	
	 		$return = array(
				'menu'				=> array(null, __($specimen_data['SampleControl']['sample_type'], true) . ' : ' . $specimen_data['SampleMaster']['qc_nd_sample_label']),
				'title' 			=> array(null, __($specimen_data['SampleControl']['sample_type'], true) . ' : ' . $specimen_data['SampleMaster']['qc_nd_sample_label']),
				'data' 				=> $specimen_data,
	 			'structure alias' 	=> 'sample_masters_for_search_result'
			);
		}	
		
		return $return;
	}

	function derivativeSummary($variables=array()) {
		$return = false;
		
		if (isset($variables['Collection.id']) && isset($variables['SampleMaster.initial_specimen_sample_id']) && isset($variables['SampleMaster.id'])) {
			// Get derivative data
			$criteria = array(
				'SampleMaster.collection_id' => $variables['Collection.id'],
				'SampleMaster.id' => $variables['SampleMaster.id']);
			$derivative_data = $this->find('first', array('conditions' => $criteria));
			
			// Set summary	 	
	 		$return = array(
					'menu' 				=> array(null, __($derivative_data['SampleControl']['sample_type'], true) . ' : ' . $derivative_data['SampleMaster']['qc_nd_sample_label']),
					'title' 			=> array(null, __($derivative_data['SampleControl']['sample_type'], true) . ' : ' . $derivative_data['SampleMaster']['qc_nd_sample_label']),
					'data' 				=> $derivative_data,
	 				'structure alias' 	=> 'sample_masters_for_search_result'
			);
		}	
		
		return $return;
	}
	
	function createSampleLabel($collection_id, $sample_data, $bank_participant_identifier = null, $initial_specimen_label = null) {
		// Check parameters
	 	if(empty($collection_id) || empty($sample_data) 
	 	|| (!isset($sample_data['SampleMaster'])) || (!isset($sample_data['SampleControl']))) { 
	 		AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true); 
	 	}
	 	
	 	$prev_id = $this->id;

		// ** Set Data **

	 	$sample_category = null;
	 	if(array_key_exists('sample_category', $sample_data['SampleControl'])) {
	 		$sample_category = $sample_data['SampleControl']['sample_category'];
	 	} else if(array_key_exists('SpecimenDetail', $sample_data)) {
	 		$sample_category = 'specimen';
	 	} else  if(array_key_exists('DerivativeDetail', $sample_data)) {
			$sample_category = 'derivative';
	 	}		
		
		if(is_null($sample_category)
		|| !array_key_exists('sample_type', $sample_data['SampleControl'])
		|| !array_key_exists('qc_nd_sample_type_code', $sample_data['SampleControl'])) {
			AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true); 
		}
		$sample_type = $sample_data['SampleControl']['sample_type'];
		$qc_nd_sample_type_code = $sample_data['SampleControl']['qc_nd_sample_type_code'];

		$specimen_type_code = null;
		$specimen_sequence_number = null;
		
		if($sample_category == 'specimen'){
			if(!isset($sample_data['SpecimenDetail'])
				|| !array_key_exists('type_code', $sample_data['SpecimenDetail'])
				|| !array_key_exists('sequence_number', $sample_data['SpecimenDetail'])
			){ 
				AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true); 
			}
		
			$specimen_type_code =  (empty($sample_data['SpecimenDetail']['type_code']))? 'n/a' : $sample_data['SpecimenDetail']['type_code']; 
			$specimen_sequence_number = $sample_data['SpecimenDetail']['sequence_number'];
			$specimen_sequence_number = (empty($specimen_sequence_number) && (strcmp($specimen_sequence_number, '0') != 0))? '': '('.$specimen_sequence_number.')'; 		
		}
	
		if(is_null($initial_specimen_label) && (strcmp($sample_category, 'derivative') == 0)) {					
			// Search initial specimen label
			if(!array_key_exists('initial_specimen_sample_id', $sample_data['SampleMaster'])) { 
				AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true); 
			}
			
			$this->contain();
			$tmp_initial_specimen_sample_data = $this->getOrRedirect($sample_data['SampleMaster']['initial_specimen_sample_id']);
			$initial_specimen_label = $tmp_initial_specimen_sample_data['SampleMaster']['qc_nd_sample_label'];		
		}
	
		if(is_null($bank_participant_identifier) && ((strcmp($sample_category, 'specimen') == 0) || (strcmp($sample_type, 'cell culture') == 0))) {
			//Sample is a specimen and $bank_participant_identifier is unknown: Get $bank_participant_identifier	
			$view_collection = AppModel::getInstance('InventoryManagement', 'ViewCollection', true);	
			$view_collection = $view_collection->getOrRedirect($collection_id);
			$bank_participant_identifier = $view_collection['ViewCollection']['identifier_value'];			
		}
		$bank_participant_identifier = empty($bank_participant_identifier)? 'n/a' : $bank_participant_identifier;
		
		// ** Create sample label **
				
		$new_sample_label = '';
		
		switch ($sample_type) {
			// Specimen
			case 'urine':
			case 'ascite':
    		case 'peritoneal wash':
    		case 'cystic fluid':
    		case 'other fluid':
    		case 'pleural fluid':
    		case 'pericardial fluid':
    		case 'nail':
    		case 'saliva':
    		case 'stool':
    		case 'vaginal swab':
				$new_sample_label = $specimen_type_code. ' - ' . $bank_participant_identifier . 
					(empty($specimen_sequence_number)? '' : ' ' . $specimen_sequence_number);
    			break;
    			
			case 'blood':
				if(!array_key_exists('blood_type', $sample_data['SampleDetail'])) { AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true); }
				$new_sample_label = $specimen_type_code . ' - ' . $bank_participant_identifier . 
					(empty($specimen_sequence_number)? '' : ' ' . $specimen_sequence_number) .
					(empty($sample_data['SampleDetail']['blood_type'])? ' n/a': ' ' . $sample_data['SampleDetail']['blood_type']);	
    			break;
    			
			case 'tissue':
				if(!array_key_exists('labo_laterality', $sample_data['SampleDetail'])) { AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true); }
				$new_sample_label = $specimen_type_code . ' - ' . $bank_participant_identifier .
					(empty($sample_data['SampleDetail']['labo_laterality'])? ' n/a': ' ' . $sample_data['SampleDetail']['labo_laterality']) .
					(empty($specimen_sequence_number)? '' : ' ' . $specimen_sequence_number);
    			break;
    			
    		// Derivative
			case 'ascite cell':			
			case 'ascite supernatant':
			case 'blood cell':
			case 'pbmc':
			case 'b cell':
			case 'concentrated urine':
			case 'centrifuged urine':		
    		case 'amplified dna': 			
    		case 'amplified rna':			
    		case 'purified rna':			
    		case 'tissue lysate':			
    		case 'tissue suspension':
    		case 'peritoneal wash cell':
    		case 'peritoneal wash supernatant':
    		case 'cystic fluid cell':
    		case 'cystic fluid supernatant':
    		case 'other fluid cell':
    		case 'other fluid supernatant':
    		case 'plasma':
			case 'serum':
			case 'xenograft':
			case 'pleural fluid cell':
			case 'pleural fluid supernatant':
			case 'pericardial fluid cell':
			case 'pericardial fluid supernatant':
				$new_sample_label = $qc_nd_sample_type_code. ' ' . $initial_specimen_label;
    			break;
    							
    		case 'cell culture':
    			if(!array_key_exists('qc_culture_population', $sample_data['SampleDetail'])) { 
    				AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true); 
    			}
    			
				if(!empty($sample_data['SampleDetail']['qc_culture_population'])) {	
					$initial_specimen_label = str_replace((' - ' . $bank_participant_identifier),(' - ' . $bank_participant_identifier.'.'.$sample_data['SampleDetail']['qc_culture_population']),$initial_specimen_label);
				}
    			if(!array_key_exists('cell_passage_number', $sample_data['SampleDetail'])) { 
    				AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true); 
    			}
    			
				$new_sample_label = $qc_nd_sample_type_code. ' ' . $initial_specimen_label.
					((empty($sample_data['SampleDetail']['cell_passage_number']) && (strcmp($sample_data['SampleDetail']['cell_passage_number'], '0') != 0))? '': ' P'.$sample_data['SampleDetail']['cell_passage_number']);
    			break;	
    					
    		case 'dna': 			
    		case 'rna':		 
    			if(!array_key_exists('source_cell_passage_number', $sample_data['SampleDetail'])) { 
    				AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true); 
    			}
    			
				$new_sample_label = $qc_nd_sample_type_code . ' ' . $initial_specimen_label;
				
				if(is_numeric($sample_data['SampleMaster']['parent_id'])){
					$parent_element = $this->findById($sample_data['SampleMaster']['parent_id']);
					if(isset($parent_element['SampleDetail']['qc_culture_population']) && is_numeric($parent_element['SampleDetail']['qc_culture_population'])){
						$new_sample_label .= ".".$parent_element['SampleDetail']['qc_culture_population'];
					}
				}
				
				if(is_numeric($sample_data['SampleDetail']['source_cell_passage_number'])){
					$new_sample_label .= ' P'.$sample_data['SampleDetail']['source_cell_passage_number']; 
				}
				
    			break;
    		
    		default :
    			// Type is unknown
				AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__.'type='.$sample_type, null, true);
		}
		
		$this->id = $prev_id;
		
		return $new_sample_label;
	}
	 
	private function validateLabTypeCodeAndLaterality(&$data_to_validate) {	
		
		$process_validates = true;
		
		if((isset($data_to_validate['SampleControl']['sample_category']) && $data_to_validate['SampleControl']['sample_category'] === 'specimen') || 
		(!isset($data_to_validate['SampleControl']['sample_category']) && array_key_exists('SpecimenDetail', $data_to_validate))) {
			// Load model to control data
			$lab_type_laterality_match = AppModel::getInstance('InventoryManagement', 'LabTypeLateralityMatch', true);		
			
			// Get Data
			if(!array_key_exists('sample_type', $data_to_validate['SampleControl'])
				|| !array_key_exists('SpecimenDetail', $data_to_validate)
				|| !array_key_exists('type_code', $data_to_validate['SpecimenDetail'])
			){ 
				AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true); 
			}
			$tmp_specimen_type = $data_to_validate['SampleControl']['sample_type'];
			$tmp_selected_type_code = $data_to_validate['SpecimenDetail']['type_code'];
									
			if($tmp_specimen_type == 'tissue') { 				
				// ** Validate Tissue Specimen + Set tissue additional data **
								
				if(!array_key_exists('labo_laterality', $data_to_validate['SampleDetail'])) { 
					AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true); 
				}
				$tmp_labo_laterality = $data_to_validate['SampleDetail']['labo_laterality'];
					
				$tissue_source = '';	
				$nature = '';	
				$laterality = '';	
					
				if(!(empty($tmp_selected_type_code) && empty($tmp_labo_laterality))){	
					// Search LabTypeLateralityMatch record
					$criteria = array();
					$criteria['LabTypeLateralityMatch.sample_type_matching'] = $tmp_specimen_type; 
					$criteria['LabTypeLateralityMatch.selected_type_code'] = $tmp_selected_type_code;
					$criteria['LabTypeLateralityMatch.selected_labo_laterality'] = $tmp_labo_laterality; 
								
					$matching_records = $lab_type_laterality_match->find('all', array('conditions' => $criteria));
													
					if(empty($matching_records)){
						// The selected type code and labo laterality combination not currently supported by the laboratory				
						$process_validates= false;
						$this->validationErrors['labo_laterality'][] = 'the selected type code and labo laterality combination is not supported';
						$this->validationErrors['type_code'][] = 'the selected type code and labo laterality combination is not supported';
						
					}else if(count($matching_records) > 1){
						// Only one row should be defined in model 'LabTypeLateralityMatch' 
						// for this specific combination sample_type_matching.selected_type_code.selected_labo_laterality
						AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);	
						
					}else{
						// Set automatically tissue source, nature and laterality
						$tissue_source = $matching_records[0]['LabTypeLateralityMatch']['tissue_source_matching'];
	             		$nature= $matching_records[0]['LabTypeLateralityMatch']['nature_matching'];
	             		$laterality= $matching_records[0]['LabTypeLateralityMatch']['laterality_matching'];
		
					}
				}
				
				// Set tissue additional data
				$data_to_validate['SampleDetail']['tissue_source'] = $tissue_source;
         		$data_to_validate['SampleDetail']['tissue_nature'] = $nature;
         		$data_to_validate['SampleDetail']['tissue_laterality'] = $laterality;	
								
			}else{
				// ** Validate All Specimen Except Tissue **
								
				if(!empty($tmp_selected_type_code)){
					// Type code has been selected: Check this one matches sample type 
					
					$criteria = array();
					$criteria['LabTypeLateralityMatch.sample_type_matching'] = $tmp_specimen_type; 
					$criteria['LabTypeLateralityMatch.selected_type_code'] = $tmp_selected_type_code;
					$criteria['LabTypeLateralityMatch.selected_labo_laterality'] = ''; 
					
					$matching_records = $lab_type_laterality_match->find('all', array('conditions' => $criteria));
					
					if(empty($matching_records)){
						// The selected type code and labo laterality combination is not currently supported by the laboratory				
						$process_validates= false;
						$this->validationErrors[] 
							= 'the selected type code does not match sample type';
					}else if(count($matching_records) > 1){
						// Only one row should be defined in model 'LabTypeLateralityMatch' 
						// for this specific combination sample_type_matching.selected_type_code.selected_labo_laterality
						AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);	
					}
				}
			}
		} 
		
		return $process_validates;	
	}

	
	function formatParentSampleDataForDisplay($parent_sample_data) {
		$formatted_data = array();
		if(!empty($parent_sample_data)) {
			if(isset($parent_sample_data['SampleMaster'])) {
				$formatted_data[$parent_sample_data['SampleMaster']['id']] = $parent_sample_data['SampleMaster']['qc_nd_sample_label'] . ' [' . __($parent_sample_data['SampleControl']['sample_type'], TRUE) . ']';
			} else if(isset($parent_sample_data[0]['ViewSample'])){
				foreach($parent_sample_data as $new_parent) {
					$formatted_data[$new_parent['ViewSample']['sample_master_id']] = $new_parent['ViewSample']['qc_nd_sample_label'] . ' [' . __($new_parent['ViewSample']['sample_type'], TRUE) . ']';
				}
			}
		}
		return $formatted_data;		
		
	}
	
	function validates($options = array()){
		$result = parent::validates($options);
		
		// --------------------------------------------------------------------------------
		// Check selected type code for all specimen plus set read only fields for tissue
		// (tissue source, nature, laterality)
		// --------------------------------------------------------------------------------
		if(!$this->validateLabTypeCodeAndLaterality($this->data)){
			$result = false;
		}
		
		return $result;
	}
}

?>