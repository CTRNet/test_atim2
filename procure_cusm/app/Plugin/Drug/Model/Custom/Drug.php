<?php

class DrugCustom extends Drug {
	var $useTable = 'drugs';
	var $name = 'Drug';

	private $tested_drugs = array();
	
	function getDrugDataAndCodeForDisplay($drug_data) {
	
		//-- NOTE ----------------------------------------------------------------
		//
		// This function is linked to a function of the Drug controller
		// called autocompleteDrug()
		// and to functions of the Drug model
		// getDrugIdFromDrugDataAndCode().
		//
		// When you override the getDrugDataAndCodeForDisplay() function,
		// check if you need to override these functions.
		//
		//------------------------------------------------------------------------
	
		$formatted_data = '';
		if((!empty($drug_data)) && isset($drug_data['Drug']['id']) && (!empty($drug_data['Drug']['id']))) {
			if(!isset($this->drug_data_and_code_for_display_already_set[$drug_data['Drug']['id']])) {
				if(!isset($drug_data['Drug']['generic_name'])) {
					$drug_data = $this->find('first', array('conditions' => array('Drug.id' => ($drug_data['Drug']['id']))));
				}
				if(isset($new_tx['Drug']['procure_study']) && $new_tx['Drug']['procure_study']) {
				    $new_tx['Drug']['generic_name'] .= ' ('.__('experimental treatment').')';
				}
				$this->drug_data_and_code_for_display_already_set[$drug_data['Drug']['id']] = $drug_data['Drug']['generic_name'] . ($drug_data['Drug']['procure_study']? ' ('.__('experimental treatment').')' : '') . " [". $drug_data['Drug']['id'] . ']';
			}
			$formatted_data = $this->drug_data_and_code_for_display_already_set[$drug_data['Drug']['id']];
		}
		return $formatted_data;
	}
	
	function getDrugIdFromDrugDataAndCode($drug_data_and_code){
	
		//-- NOTE ----------------------------------------------------------------
		//
		// This function is linked to a function of the Drug controller
		// called autocompleteDrug()
		// and to function of the Drug model
		// getDrugDataAndCodeForDisplay().
		//
		// When you override the getDrugIdFromDrugDataAndCode() function,
		// check if you need to override these functions.
		//
		//------------------------------------------------------------------------
		
		if(!isset($this->drug_titles_already_checked[$drug_data_and_code])) {
			$matches = array();
			$selected_drugs = array();
			if(preg_match("/(.+)\[([0-9]+)\]$/", str_replace(' ('.__('experimental treatment').')', '', $drug_data_and_code), $matches) > 0){
			    // Auto complete tool has been used
				$selected_drugs = $this->find('all', array('conditions' => array("Drug.generic_name LIKE '%".str_replace("'", "''", trim($matches[1]))."%'", 'Drug.id' => $matches[2])));
			} else {
				// consider $drug_data_and_code contains just drug title
				$term = str_replace('_', '\_', str_replace('%', '\%', $drug_data_and_code));
				$terms = array();
				foreach(explode(' ', $term) as $key_word) $terms[] = "Drug.generic_name LIKE '%".str_replace("'", "''", $key_word)."%'";
				$conditions = array('AND' => $terms);
				$selected_drugs = $this->find('all', array('conditions' => $conditions));
			}
			if(sizeof($selected_drugs) == 1) {
				$this->drug_titles_already_checked[$drug_data_and_code] = array('Drug' => $selected_drugs[0]['Drug']);
			} else if(sizeof($selected_drugs) > 1) {
				$this->drug_titles_already_checked[$drug_data_and_code] = array('error' => str_replace('%s', $drug_data_and_code, __('more than one drug matches the following data [%s]')));
			} else {
				$this->drug_titles_already_checked[$drug_data_and_code] = array('error' => str_replace('%s', $drug_data_and_code, __('no drug matches the following data [%s]')));
			}
		}
		return $this->drug_titles_already_checked[$drug_data_and_code];
	}
	
	function allowDeletion($drug_id){
		$TreatmentMaster = AppModel::getInstance("ClinicalAnnotation", "TreatmentMaster", true);
		$returned_nbr = $TreatmentMaster->find('count', array('conditions' => array('TreatmentMaster.procure_drug_id' => $drug_id), 'recursive' => '1'));
		if($returned_nbr > 0) {
			return array('allow_deletion' => false, 'msg' => 'drug is defined as a component of at least one participant treatment');
		}
	
		return parent::allowDeletion($drug_id);
	}
	
	function validates($options = array()){
	    if(isset($this->data['Drug']['generic_name'])){
	        $this->data['Drug']['generic_name'] = trim($this->data['Drug']['generic_name']);
	        $this->checkDuplicatedDrug($this->data);
	    }
	    return parent::validates($options);
	}
	
	function checkDuplicatedDrug($drug_data) {
	    	
	    // check data structure
	    $tmp_arr_to_check = array_values($drug_data);
	    if((!is_array($drug_data)) || (is_array($tmp_arr_to_check) && isset($tmp_arr_to_check[0]['Drug']))) {
	        AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
	    }
	    
	    $generic_name = $drug_data['Drug']['generic_name'];
	    $procure_study = $drug_data['Drug']['procure_study'];
	    $key_drug ="$generic_name [$procure_study]";
	    
	    // Check duplicated drug into submited record
	    if(!strlen($generic_name)) {
	        // Not studied
	    } else if(isset($this->tested_drugs[$key_drug])) {
	        $this->validationErrors['generic_name'][] = str_replace('%s', $generic_name.($procure_study? ' ('.__('experimental treatment').')' : ''), __('you can not record drug [%s] twice'));
	    } else {
	        $this->tested_drugs[$key_drug] = '';
	    }
	
	    // Check duplicated barcode into db
	    $criteria = array('Drug.generic_name' => $generic_name, 'Drug.procure_study' => $procure_study);
	    $drugs_having_duplicated_name = $this->find('all', array('conditions' => $criteria, 'recursive' => -1));;
	    if(!empty($drugs_having_duplicated_name)) {
	        foreach($drugs_having_duplicated_name as $duplicate) {
	            if((!array_key_exists('id', $drug_data['Drug'])) || ($duplicate['Drug']['id'] != $drug_data['Drug']['id'])) {
	                $this->validationErrors['generic_name'][] = str_replace('%s', $generic_name.($procure_study? ' ('.__('experimental treatment').')' : ''), __('the drug [%s] has already been recorded'));
	            }
	        }
	    }
	}
}


?>