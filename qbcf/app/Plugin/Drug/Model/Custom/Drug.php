<?php

class DrugCustom extends Drug {
	
	var $name = 'Drug';
	var $useTable = 'drugs';

	private $drugTypeValues = array();
	
	public function getDrugDataAndCodeForDisplay($drugData) {
	
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
	
		$formattedData = '';
		if((!empty($drugData)) && isset($drugData['Drug']['id']) && (!empty($drugData['Drug']['id']))) {
			if(!isset($this->drugDataAndCodeForDisplayAlreadySet[$drugData['Drug']['id']])) {
				if(!isset($drugData['Drug']['generic_name'])) {
					$drugData = $this->find('first', array('conditions' => array('Drug.id' => ($drugData['Drug']['id']))));
				}
				if(!$this->drugTypeValues) {
					App::uses('StructureValueDomain', 'Model');
					$StructureValueDomain = new StructureValueDomain();
					$drugTypes = $StructureValueDomain->find('first', array('conditions' => array('StructureValueDomain.domain_name' => 'type'), 'recursive' => 2));
					foreach($drugTypes['StructurePermissibleValue'] as $newValue) {
						$this->drugTypeValues[$newValue['value']] = __($newValue['language_alias']);
					}
				}
				$this->drugDataAndCodeForDisplayAlreadySet[$drugData['Drug']['id']] = $drugData['Drug']['generic_name'] . ' :: '. $this->drugTypeValues[$drugData['Drug']['type']] . ' [' . $drugData['Drug']['id'] . ']';
			}
			$formattedData = $this->drugDataAndCodeForDisplayAlreadySet[$drugData['Drug']['id']];
		}
		return $formattedData;
	}
	
	public function getDrugIdFromDrugDataAndCode($drugDataAndCode){
	
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
		
		if(!isset($this->drugTitlesAlreadyChecked[$drugDataAndCode])) {
			$matches = array();
			$selectedDrugs = array();
			if(preg_match("/(.+)\ ::\ (.+)\[([0-9]+)\]$/", $drugDataAndCode, $matches) > 0){
				// Auto complete tool has been used
				$selectedDrugs = $this->find('all', array('conditions' => array("Drug.generic_name LIKE '%".trim($matches[1])."%'", 'Drug.id' => $matches[3])));
			} else {
				// consider $drugDataAndCode contains just drug title
				$term = str_replace('_', '\_', str_replace('%', '\%', $drugDataAndCode));
				$terms = array();
				foreach(explode(' ', $term) as $keyWord) $terms[] = "Drug.generic_name LIKE '%".$keyWord."%'";
				$conditions = array('AND' => $terms);
				$selectedDrugs = $this->find('all', array('conditions' => $conditions));
			}
			if(sizeof($selectedDrugs) == 1) {
				$this->drugTitlesAlreadyChecked[$drugDataAndCode] = array('Drug' => $selectedDrugs[0]['Drug']);
			} elseif(sizeof($selectedDrugs) > 1) {
				$this->drugTitlesAlreadyChecked[$drugDataAndCode] = array('error' => str_replace('%s', $drugDataAndCode, __('more than one drug matches the following data [%s]')));
			} else {
				$this->drugTitlesAlreadyChecked[$drugDataAndCode] = array('error' => str_replace('%s', $drugDataAndCode, __('no drug matches the following data [%s]')));
			}
		}
		
		return $this->drugTitlesAlreadyChecked[$drugDataAndCode];
	}
	
}