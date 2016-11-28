<?php

class Drug extends DrugAppModel {
	
	var $name = 'Drug';
	var $useTable = 'drugs';
	
	var $drug_titles_already_checked = array();
	var $drug_data_and_code_for_display_already_set = array();

	function summary( $variables=array() ) {
		$return = false;
		
		if ( isset($variables['Drug.id']) ) {
			
			$result = $this->find('first', array('conditions'=>array('Drug.id'=>$variables['Drug.id'])));
			
			$return = array(
				'menu'			=>	array( NULL, $result['Drug']['generic_name']),
				'title'			=>	array( NULL, $result['Drug']['generic_name']),
				'data'			=> $result,
				'structure alias'=>'drugs'
			);
		}
		
		return $return;
	}
	
 	/**
	 * Get permissible values array gathering all existing drugs.
	 *
	 * @author N. Luc
	 * @since 2010-05-26
	 * @updated N. Luc
	 */  	
	function getDrugPermissibleValues() {
		$result = array();
		foreach($this->find('all', array('order' => array('Drug.generic_name'))) as $drug){
			$result[$drug["Drug"]["id"]] = $drug["Drug"]["generic_name"];
		}
		return $result;
	}
	
	/**
	 * Check if a record can be deleted.
	 * 
	 * @param $drug_id Id of the studied record.
	 * 
	 * @return Return results as array:
	 * 	['allow_deletion'] = true/false
	 * 	['msg'] = message to display when previous field equals false
	 * 
	 * @author N. Luc
	 * @since 2007-10-16
	 */
	function allowDeletion($drug_id){
		$TreatmentExtendMaster = AppModel::getInstance("ClinicalAnnotation", "TreatmentExtendMaster", true);
		$returned_nbr = $TreatmentExtendMaster->find('count', array('conditions' => array('TreatmentExtendMaster.drug_id' => $drug_id), 'recursive' => '1'));
		if($returned_nbr > 0) {
			return array('allow_deletion' => false, 'msg' => 'drug is defined as a component of at least one participant treatment'); 
		}
		
		$ProtocolExtendMaster = AppModel::getInstance("Protocol", "ProtocolExtendMaster", true);
		$returned_nbr = $ProtocolExtendMaster->find('count', array('conditions' => array('$ProtocolExtendMaster.drug_id' => $drug_id), 'recursive' => '1'));
		if($returned_nbr > 0) {
			return array('allow_deletion' => false, 'msg' => 'drug is defined as a component of at least one protocol');
		}
		
		return array('allow_deletion' => true, 'msg' => '');
	}	
	
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
				$this->drug_data_and_code_for_display_already_set[$drug_data['Drug']['id']] = $drug_data['Drug']['generic_name'] . ' [' . $drug_data['Drug']['id'] . ']';
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
			if(preg_match("/(.+)\[([0-9]+)\]$/", $drug_data_and_code, $matches) > 0){
				// Auto complete tool has been used
				$selected_drugs = $this->find('all', array('conditions' => array("Drug.generic_name LIKE '%".trim($matches[1])."%'", 'Drug.id' => $matches[2])));
			} else {
				// consider $drug_data_and_code contains just drug title
				$term = str_replace('_', '\_', str_replace('%', '\%', $drug_data_and_code));
				$terms = array();
				foreach(explode(' ', $term) as $key_word) $terms[] = "Drug.generic_name LIKE '%".$key_word."%'";
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
}

?>