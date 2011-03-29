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
				'menu'				=> array(null, __($specimen_data['SampleMaster']['sample_type'], true) . ' : ' . $specimen_data['SampleMaster']['sample_label']),
				'title' 			=> array(null, __($specimen_data['SampleMaster']['sample_type'], true) . ' : ' . $specimen_data['SampleMaster']['sample_label']),
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
					'menu' 				=> array(null, __($derivative_data['SampleMaster']['sample_type'], true) . ' : ' . $derivative_data['SampleMaster']['sample_label']),
					'title' 			=> array(null, __($derivative_data['SampleMaster']['sample_type'], true) . ' : ' . $derivative_data['SampleMaster']['sample_label']),
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
	 		AppController::getInstance()->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true); 
	 	}

		// ** Set Data **
		
		if(!array_key_exists('sample_category', $sample_data['SampleControl'])
		|| !array_key_exists('sample_type', $sample_data['SampleMaster'])
		|| !array_key_exists('sample_type_code', $sample_data['SampleControl'])){ 
			AppController::getInstance()->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true); 
		}
		$sample_category = $sample_data['SampleControl']['sample_category'];
		$sample_type = $sample_data['SampleMaster']['sample_type'];
		$sample_type_code = $sample_data['SampleControl']['sample_type_code'];

		$specimen_type_code = null;
		$specimen_sequence_number = null;
		
		if($sample_category == 'specimen'){
			if(!isset($sample_data['SpecimenDetail'])
			|| !array_key_exists('type_code', $sample_data['SpecimenDetail'])
			|| !array_key_exists('sequence_number', $sample_data['SpecimenDetail'])) { 
				AppController::getInstance()->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true); 
			}
		
			$specimen_type_code =  (empty($sample_data['SpecimenDetail']['type_code']))? 'n/a' : $sample_data['SpecimenDetail']['type_code']; 
			$specimen_sequence_number = $sample_data['SpecimenDetail']['sequence_number'];
			$specimen_sequence_number = (empty($specimen_sequence_number) && (strcmp($specimen_sequence_number, '0') != 0))? '': '('.$specimen_sequence_number.')'; 		
		}
	
		if(is_null($initial_specimen_label) && (strcmp($sample_category, 'derivative') == 0)) {					
			// Search initial specimen label
			if(!array_key_exists('initial_specimen_sample_id', $sample_data['SampleMaster'])) { 
				AppController::getInstance()->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true); 
			}
			
			$this->contain();
			$tmp_initial_specimen_sample_data = $this->find('first', array('conditions' => array('SampleMaster.id' => $sample_data['SampleMaster']['initial_specimen_sample_id'])));
			if(empty($tmp_initial_specimen_sample_data)){ 
				AppController::getInstance()->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true); 
			}
			
			$initial_specimen_label = $tmp_initial_specimen_sample_data['SampleMaster']['sample_label'];		
		}
	
		if(is_null($bank_participant_identifier) && (strcmp($sample_category, 'specimen') == 0)) {
			//Sample is a specimen and $bank_participant_identifier is unknown: Get $bank_participant_identifier	
			$view_collection = AppModel::atimNew('Inventorymanagement', 'ViewCollection', true);	
					
			$view_collection = $view_collection->find('first', array('conditions' => array('ViewCollection.collection_id' => $collection_id)));
			if(empty($view_collection)) { 
				AppController::getInstance()->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true); 
			}
			
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
				$new_sample_label = $specimen_type_code. ' - ' . $bank_participant_identifier . 
					(empty($specimen_sequence_number)? '' : ' ' . $specimen_sequence_number);
    			break;
    			
			case 'blood':
				if(!array_key_exists('blood_type', $sample_data['SampleDetail'])) { AppController::getInstance()->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true); }
				$new_sample_label = $specimen_type_code . ' - ' . $bank_participant_identifier . 
					(empty($specimen_sequence_number)? '' : ' ' . $specimen_sequence_number) .
					(empty($sample_data['SampleDetail']['blood_type'])? ' n/a': ' ' . $sample_data['SampleDetail']['blood_type']);	
    			break;
    			
			case 'tissue':
				if(!array_key_exists('labo_laterality', $sample_data['SampleDetail'])) { AppController::getInstance()->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true); }
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
			case 'plasma':
			case 'serum':
			case 'concentrated urine':
			case 'centrifuged urine':		
    		case 'amplified dna': 			
    		case 'amplified rna':			
    		case 'tissue lysate':			
    		case 'tissue suspension':
    		case 'peritoneal wash cell':
    		case 'peritoneal wash supernatant':
    		case 'cystic fluid cell':
    		case 'cystic fluid supernatant':
    		case 'other fluid cell':
    		case 'other fluid supernatant':
				$new_sample_label = $sample_type_code. ' ' . $initial_specimen_label;
    			break;
    			
    		case 'cell culture':
    			if(!array_key_exists('cell_passage_number', $sample_data['SampleDetail'])) { AppController::getInstance()->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true); }
				$new_sample_label = $sample_type_code. ' ' . $initial_specimen_label.
					((empty($sample_data['SampleDetail']['cell_passage_number']) && (strcmp($sample_data['SampleDetail']['cell_passage_number'], '0') != 0))? '': ' P'.$sample_data['SampleDetail']['cell_passage_number']);
    			break;	
    					
    		case 'dna': 			
    		case 'rna':		 
    			if(!array_key_exists('source_cell_passage_number', $sample_data['SampleDetail'])) { AppController::getInstance()->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true); }
				$new_sample_label = $sample_type_code . ' ' . $initial_specimen_label.
					((empty($sample_data['SampleDetail']['source_cell_passage_number']) && (strcmp($sample_data['SampleDetail']['source_cell_passage_number'], '0') != 0))? '': ' P'.$sample_data['SampleDetail']['source_cell_passage_number']);
    			break;
    		
    		default :
    			// Type is unknown
				AppController::getInstance()->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		}
		
		return $new_sample_label;
	}	 
	 
	function validateLabTypeCodeAndLaterality(&$data_to_validate) {				
		$process_validates= true;
		
		if($data_to_validate['SampleMaster']['sample_category'] === 'specimen') {
			// Load model to control data
			$lab_type_laterality_match = AppModel::atimNew('Inventorymanagement', 'LabTypeLateralityMatch', true);		
			
			// Get Data
			if(!array_key_exists('sample_type', $data_to_validate['SampleMaster'])
			|| !array_key_exists('SpecimenDetail', $data_to_validate)
			|| !array_key_exists('type_code', $data_to_validate['SpecimenDetail'])) { 
				AppController::getInstance()->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true); 
			}
			$tmp_specimen_type = $data_to_validate['SampleMaster']['sample_type'];
			$tmp_selected_type_code = $data_to_validate['SpecimenDetail']['type_code'];
									
			if($tmp_specimen_type == 'tissue') { 				
				// ** Validate Tissue Specimen + Set tissue additional data **
								
				if(!array_key_exists('labo_laterality', $data_to_validate['SampleDetail'])) { 
					AppController::getInstance()->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true); 
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
						$this->validationErrors[] 
							= 'the selected type code and labo laterality combination is not supported';
						
					}else if(count($matching_records) > 1){
						// Only one row should be defined in model 'LabTypeLateralityMatch' 
						// for this specific combination sample_type_matching.selected_type_code.selected_labo_laterality
						AppController::getInstance()->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);	
						
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
						AppController::getInstance()->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);	
					}
				}
			}
		} 
		
		return $process_validates;	
	}

}

?>