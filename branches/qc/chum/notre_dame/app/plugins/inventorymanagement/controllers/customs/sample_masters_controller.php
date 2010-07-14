<?php
	 
class SampleMastersControllerCustom extends SampleMastersController {
	
	function createSampleLabel($collection_id, $sample_data, $bank_participant_identifier = null, $initial_specimen_label = null) {
					
		// Check parameters
	 	if(empty($collection_id) || empty($sample_data) 
	 	|| (!isset($sample_data['SampleMaster'])) || (!isset($sample_data['SampleControl']))) { 
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
	 * For each specimen, check following fields combination matches defintion
	 * done into table LabTypeLateralityMatch:
	 * 
	 * 		[sample_type_matching . selected_type_code . selected_labo_laterality]
	 * 
	 * When specimen type is tissue, this function will also set
	 * automatically fields tissue source, nature and laterality.
	 * 
	 * @return false if data has not been validated.
	 * 
	 * @author N. Luc
	 * @since 2008-01-29
	 */
	 
	function validateLabTypeCodeAndLaterality() {				
		$process_validates= true;
		
		if($this->data['SampleMaster']['sample_category'] === 'specimen') {
			// Load model to control data
			App::import('Model', 'Inventorymanagement.LabTypeLateralityMatch');		
			$LabTypeLateralityMatch = new LabTypeLateralityMatch();			
			
			// Get Data
			if(!array_key_exists('sample_type', $this->data['SampleMaster'])) {pr('ascasc1');exit; $this->redirect('/pages/err_inv_system_error', null, true); }
			$tmp_specimen_type = $this->data['SampleMaster']['sample_type'];
				
			if(!array_key_exists('SpecimenDetail', $this->data)) {pr('ascasc2');exit; $this->redirect('/pages/err_inv_system_error', null, true); }
			if(!array_key_exists('type_code', $this->data['SpecimenDetail'])) {pr('ascasc3');exit; $this->redirect('/pages/err_inv_system_error', null, true); }
			$tmp_selected_type_code = $this->data['SpecimenDetail']['type_code'];
									
			if($tmp_specimen_type == 'tissue') { 				
				// ** Validate Tissue Specimen + Set tissue additional data **
								
				if(!array_key_exists('labo_laterality', $this->data['SampleDetail'])) {pr('ascasc4');exit; $this->redirect('/pages/err_inv_system_error', null, true); }
				$tmp_labo_laterality = $this->data['SampleDetail']['labo_laterality'];
					
				$tissue_source = '';	
				$nature = '';	
				$laterality = '';	
					
				if(!(empty($tmp_selected_type_code) && empty($tmp_labo_laterality))){	
					// Search LabTypeLateralityMatch record
					$criteria = array();
					$criteria['LabTypeLateralityMatch.sample_type_matching'] = $tmp_specimen_type; 
					$criteria['LabTypeLateralityMatch.selected_type_code'] = $tmp_selected_type_code;
					$criteria['LabTypeLateralityMatch.selected_labo_laterality'] = $tmp_labo_laterality; 
								
					$matching_records = $LabTypeLateralityMatch->findAll($criteria);
									
					if(sizeof($matching_records) == 0) {
						// The selected type code and labo laterality combination not currently supported by the laboratory				
						$process_validates= false;
						$this->SampleMaster->validationErrors[] 
							= 'the selected type code and labo laterality combination is not supported';
						
					} else if(sizeof($matching_records) > 1) {
						// Only one row should be defined in model 'LabTypeLateralityMatch' 
						// for this specific combination sample_type_matching.selected_type_code.selected_labo_laterality
						pr('ascasc5');exit;$this->redirect('/pages/err_inv_system_error', null, true);	
						
					} else {
						// Set automatically tissue source, nature and laterality
						$tissue_source = $matching_records[0]['LabTypeLateralityMatch']['tissue_source_matching'];
	             		$nature= $matching_records[0]['LabTypeLateralityMatch']['nature_matching'];
	             		$laterality= $matching_records[0]['LabTypeLateralityMatch']['laterality_matching'];
		
					}
				}
				
				// Set tissue additional data
				$this->data['SampleDetail']['tissue_source'] = $tissue_source;
         		$this->data['SampleDetail']['tissue_nature'] = $nature;
         		$this->data['SampleDetail']['tissue_laterality'] = $laterality;	
								
			} else {
				// ** Validate All Specimen Except Tissue **
								
				if(!empty($tmp_selected_type_code)) {
					// Type code has been selected: Check this one matches sample type 
					
					$criteria = array();
					$criteria['LabTypeLateralityMatch.sample_type_matching'] = $tmp_specimen_type; 
					$criteria['LabTypeLateralityMatch.selected_type_code'] = $tmp_selected_type_code;
					$criteria['LabTypeLateralityMatch.selected_labo_laterality'] = ''; 
					
					$matching_records = $LabTypeLateralityMatch->findAll($criteria);
					
					if(sizeof($matching_records) == 0) {
						// The selected type code and labo laterality combination is not currently supported by the laboratory				
						$process_validates= false;
						$this->SampleMaster->validationErrors[] 
							= 'the selected type code does not match sample type';
						
					} else if(sizeof($matching_records) > 1) {
						// Only one row should be defined in model 'LabTypeLateralityMatch' 
						// for this specific combination sample_type_matching.selected_type_code.selected_labo_laterality
						pr('ascasc6');exit;$this->redirect('/pages/err_inv_system_error', null, true);	
						
					}
				}
			}
		} 
		
		return $process_validates;	
	}	 
 
}
	
?>
