<?php
	 
class SampleMastersControllerCustom extends SampleMastersController {
	
	function createSampleLabel($collection_id, $sample_data, $bank_participant_identifier = null, $initial_specimen_label = null) {
					
		// Check parameters
	 	if(empty($collection_id) || empty($sample_data) 
	 	|| (!isset($sample_data['SampleMaster'])) || (!isset($sample_data['SampleDetail'])) || (!isset($sample_data['SampleControl']))) { 
	 		$this->redirect('/pages/err_inv_system_error', null, true); 
	 	}

		// ** Set Data **
		
		if(!array_key_exists('sample_category', $sample_data['SampleControl'])) { $this->redirect('/pages/err_inv_system_error', null, true); }
		$sample_category = $sample_data['SampleControl']['sample_category'];
		
		if(!array_key_exists('sample_type', $sample_data['SampleMaster'])) { $this->redirect('/pages/err_inv_system_error', null, true); }
		$sample_type = $sample_data['SampleMaster']['sample_type'];
		
		if(!array_key_exists('sample_type_code', $sample_data['SampleControl'])) { $this->redirect('/pages/err_inv_system_error', null, true); }
		$sample_type_code = $sample_data['SampleControl']['sample_type_code'];

		$specimen_type_code = null;
		$specimen_sequence_number = null;
		
		if($sample_category == 'specimen') {
			if(!isset($sample_data['SpecimenDetail'])) { $this->redirect('/pages/err_inv_system_error', null, true); }
		
			if(!array_key_exists('type_code', $sample_data['SpecimenDetail'])) { $this->redirect('/pages/err_inv_system_error', null, true); }
			$specimen_type_code =  (empty($sample_data['SpecimenDetail']['type_code']))? 'n/a' : $sample_data['SpecimenDetail']['type_code']; 
		
			if(!array_key_exists('sequence_number', $sample_data['SpecimenDetail'])) { $this->redirect('/pages/err_inv_system_error', null, true); }
			$specimen_sequence_number = $sample_data['SpecimenDetail']['sequence_number'];
			$specimen_sequence_number = (empty($specimen_sequence_number) && (strcmp($specimen_sequence_number, '0') != 0))? '': '('.$specimen_sequence_number.')'; 		
		}
	
		if(is_null($initial_specimen_label) && (strcmp($sample_category, 'derivative') == 0)) {					
			// Search initial specimen label
			if(!array_key_exists('initial_specimen_sample_id', $sample_data['SampleMaster'])) { $this->redirect('/pages/err_inv_system_error', null, true); }
			
			$this->SampleMaster->contain();
			$tmp_initial_specimen_sample_data = $this->SampleMaster->find('first', array('conditions' => array('SampleMaster.id' => $sample_data['SampleMaster']['initial_specimen_sample_id'])));
			if(empty($tmp_initial_specimen_sample_data)){ $this->redirect('/pages/err_inv_system_error', null, true); }
			
			$initial_specimen_label = $tmp_initial_specimen_sample_data['SampleMaster']['sample_label'];		
		}
	
		if(is_null($bank_participant_identifier) && (strcmp($sample_category, 'specimen') == 0)) {
			//Sample is a specimen and $bank_participant_identifier is unknown: Get $bank_participant_identifier	
			App::import('Model', 'Inventorymanagement.ViewCollection');		
			$ViewCollection = new ViewCollection();
					
			$view_collection = $ViewCollection->find('first', array('conditions' => array('ViewCollection.collection_id' => $collection_id)));
			if(empty($view_collection)) { $this->redirect('/pages/err_inv_system_error', null, true); }
			
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
				if(!array_key_exists('blood_type', $sample_data['SampleDetail'])) { $this->redirect('/pages/err_inv_system_error', null, true); }
				$new_sample_label = $specimen_type_code . ' - ' . $bank_participant_identifier . 
					(empty($specimen_sequence_number)? '' : ' ' . $specimen_sequence_number) .
					(empty($sample_data['SampleDetail']['blood_type'])? ' n/a': ' ' . $sample_data['SampleDetail']['blood_type']);	
    			break;
    			
			case 'tissue':
				if(!array_key_exists('labo_laterality', $sample_data['SampleDetail'])) { $this->redirect('/pages/err_inv_system_error', null, true); }
				$new_sample_label = $specimen_type_code . ' - ' . $bank_participant_identifier .
					(empty($sample_data['SampleDetail']['labo_laterality'])? ' n/a': ' ' . $sample_data['SampleDetail']['labo_laterality']) .
					(empty($specimen_sequence_number)? '' : ' ' . $specimen_sequence_number);
    			break;
    			
    		// Derivative
			case 'ascite cell':			
			case 'ascite supernatant':
			case 'blood cell':
			case 'pbmc':
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
    			if(!array_key_exists('cell_passage_number', $sample_data['SampleDetail'])) { $this->redirect('/pages/err_inv_system_error', null, true); }
				$new_sample_label = $sample_type_code. ' ' . $initial_specimen_label.
					((empty($sample_data['SampleDetail']['cell_passage_number']) && (strcmp($sample_data['SampleDetail']['cell_passage_number'], '0') != 0))? '': ' P'.$sample_data['SampleDetail']['cell_passage_number']);
    			break;	
    					
    		case 'dna': 			
    		case 'rna':		 
    			if(!array_key_exists('source_cell_passage_number', $sample_data['SampleDetail'])) { $this->redirect('/pages/err_inv_system_error', null, true); }
				$new_sample_label = $sample_type_code . ' ' . $initial_specimen_label.
					((empty($sample_data['SampleDetail']['source_cell_passage_number']) && (strcmp($sample_data['SampleDetail']['source_cell_passage_number'], '0') != 0))? '': ' P'.$sample_data['SampleDetail']['source_cell_passage_number']);
    			break;
    		
    		default :
    			// Type is unknown
				$this->redirect('/pages/err_inv_system_error', null, true);
		}
		
		return $new_sample_label;
	}	 
	 
	function formatParentSampleDataForDisplay($parent_sample_data) {
		$formatted_data = array();
		if(!empty($parent_sample_data) && isset($parent_sample_data['SampleMaster'])) {
			$formatted_data[$parent_sample_data['SampleMaster']['id']] = $parent_sample_data['SampleMaster']['sample_label'] . ' / ' . $parent_sample_data['SampleMaster']['sample_code'] . ' [' . __($parent_sample_data['SampleMaster']['sample_type'], TRUE) . ']';
		}
		
		return $formatted_data;
	}
	 
	 
	 
	 
	 
	 
	
	/**
	 * For each specimen, check the selected type code.
	 * 
	 * When specimen type is tissue, this function will also set
	 * automatically fields tissue source, nature and laterality.
	 * 
	 * @param $submitted_data_validates Variable passed by reference to validate data entry.
	 * Will be set to FALSE, when an error has been detected.
	 * 
	 * @return FALSE if an error has been detected else TRUE.
	 * 
	 * @author N. Luc
	 * @since 2008-01-29
	 */
	function manageLabTypeCodeAndLaterality() {
return true;				
		$data_validates = true;
		
		if($this->data['SampleMaster']['sample_category'] === 'specimen') {
						
			// Get Data
			if(!array_key_exists('sample_type', $this->data['SampleMaster'])) { $this->redirect('/pages/err_inv_system_error', null, true); }
			$tmp_specimen_type = $this->data['SampleMaster']['sample_type'];
				
			if(!array_key_exists('SpecimenDetail', $this->data)) { $this->redirect('/pages/err_inv_system_error', null, true); }
			if(!array_key_exists('type_code', $this->data['SpecimenDetail'])) { $this->redirect('/pages/err_inv_system_error', null, true); }
			$tmp_selected_type_code = $this->data['SpecimenDetail']['type_code'];
				
			//Load model to control data
			App::import('Model', 'Inventorymanagement.LabTypeLateralityMatch');		
			$LabTypeLateralityMatch = new LabTypeLateralityMatch();

pr($tmp_selected_type_code);
pr($tmp_specimen_type);
exit;							
			if($tmp_specimen_type == 'tissue') { 
				
				// ** Validate Tissue Specimen **
				
				if(array_key_exists('labo_laterality', $this->data['SampleDetail'])) { $this->redirect('/pages/err_inv_system_error', null, true); }
				$tmp_labo_laterality = $this->data['SampleDetail']['labo_laterality'];
					
				if(!(empty($tmp_selected_type_code) && empty($tmp_labo_laterality))){
					// At least one value has been selected
					
					// Search LabTypeLaterMatchControl record
					$criteria = array();
					$criteria['LabTypeLaterMatchControl.sample_type_matching'] = 'tissue'; 
					$criteria['LabTypeLaterMatchControl.selected_type_code'] = $tmp_selected_type_code;
					$criteria['LabTypeLaterMatchControl.selected_labo_laterality'] = $tmp_labo_laterality; 
								
					$Lab_type_later_match_data = $LabTypeLaterMatchControl->findAll($criteria);
									
					if(sizeof($Lab_type_later_match_data) == 0) {
						// The selected type code and labo laterality combination not currently supported by the laboratory				
						$data_validates = FALSE;
						$this->SampleMaster->validationErrors[] 
							= 'the selected type code and labo laterality combination is not supported';
						
					} else if(sizeof($Lab_type_later_match_data) == 1) {
						// Set automatically tissue source, nature and laterality
						$this->data['SampleDetail']['tissue_source'] 
	            			= $Lab_type_later_match_data[0]['LabTypeLaterMatchControl']['tissue_source_matching'];
	             		$this->data['SampleDetail']['nature']
	            			= $Lab_type_later_match_data[0]['LabTypeLaterMatchControl']['nature_matching'];
	             		$this->data['SampleDetail']['laterality']
	            			= $Lab_type_later_match_data[0]['LabTypeLaterMatchControl']['laterality_matching'];
		
					} else {
						// Only one row should be defined in model 'LabTypeLaterMatchControl' 
						// for this specific combination 'tissue'.type_code.labo_laterality
						$this->redirect('/pages/err_inv_system_error', null, true);	
					}				
				
				} else {
					// Set automatically tissue source, nature and laterality to empty
					$this->data['SampleDetail']['tissue_source'] = '';
             		$this->data['SampleDetail']['nature'] = '';
             		$this->data['SampleDetail']['laterality'] = '';					
				}
								
			} else {
				// OTHER SPECIMEN THAN TISSUE
				
				if(!empty($this->data['SpecimenDetail']['type_code'])) {
					// Type code has been recorded: Check this one matches sample type 
					
					$criteria = array();
					$criteria['LabTypeLaterMatchControl.sample_type_matching'] = $tmp_specimen_type; 
					
					$Lab_type_later_match_data = $LabTypeLaterMatchControl->findAll($criteria);
					
					if(sizeof($Lab_type_later_match_data) == 0) {
						// The selected type code and labo laterality combination 
						// is not currently supported by the laboratory				
						$data_validates = FALSE;
						$this->SampleMaster->validationErrors[] 
							= 'no type code can currently be selected for the studied specimen type';
						
					} else {
						
						// Set flag
						$bool_find_match = FALSE;
						
						// Search match
						foreach($Lab_type_later_match_data as $id => $new_lab_type_later_match) {
							if(strcmp($new_lab_type_later_match['LabTypeLaterMatchControl']['selected_type_code'], 
							$tmp_selected_type_code) == 0) {
								$bool_find_match = TRUE;								
							}	
						}
						
						if(!$bool_find_match) {
							// The selected type code doesn't match the sample type	
							$data_validates = FALSE;
							$this->SampleMaster->validationErrors[] 
								= 'the selected type code does not match sample type';						
						}
	
					}
				}
			}
		} 
		
		return $data_validates;
		
	}	 
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 	
	 
}
	
?>
