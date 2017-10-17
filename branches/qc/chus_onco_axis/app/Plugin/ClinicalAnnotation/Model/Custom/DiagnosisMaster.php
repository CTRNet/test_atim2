<?php

class DiagnosisMasterCustom extends DiagnosisMaster {
	var $useTable = 'diagnosis_masters';
	var $name = "DiagnosisMaster";
	
	function validates($options = array()){
		parent::validates($options);
	
		$this->validateAndUpdateTopoMorphoData();
		
		if(isset($this->data['DiagnosisMaster']['ajcc_edition'])) $this->addWritableField(array('ajcc_edition'));
		
		return empty($this->validationErrors);
	}
	
	function updateAgeAtDx($model, $primary_key_id) {
		$criteria = array(
			'DiagnosisMaster.deleted <> 1',
			$model.'.id' => $primary_key_id);
		$joins = array(array(
			'table' => 'participants',
			'alias' => 'Participant',
			'type' => 'INNER',
			'conditions'=> array('Participant.id = DiagnosisMaster.participant_id')));
		$dx_to_check = $this->find('all', array('conditions' => $criteria, 'joins' => $joins, 'recursive' => '0', 'fields' => array('Participant.*, DiagnosisMaster.*')));
	
		$dx_to_update = array();
		$warnings = array();
		foreach($dx_to_check as $new_dx) {
			$dx_id = $new_dx['DiagnosisMaster']['id'];
			$previous_age_at_dx = $new_dx['DiagnosisMaster']['age_at_dx'];
			$previous_age_at_dx_precision = $new_dx['DiagnosisMaster']['age_at_dx_precision'];
			$new_age_at_dx = '';
			$new_age_at_dx_precision = '';
			if($new_dx['DiagnosisMaster']['dx_date'] && $new_dx['Participant']['date_of_birth']) {
				$arr_spent_time = $this->getSpentTime($new_dx['Participant']['date_of_birth'].' 00:00:00', $new_dx['DiagnosisMaster']['dx_date'].' 00:00:00');
				if($arr_spent_time['message']) {
					$warnings[$arr_spent_time['message']] = __('unable to calculate age at diagnosis').': '.__($arr_spent_time['message']);
				} else {
					$new_age_at_dx = $arr_spent_time['years'];
					$new_age_at_dx_precision = 'known';
					if($new_dx['DiagnosisMaster']['dx_date_accuracy'] == 'y' || $new_dx['Participant']['date_of_birth_accuracy']== 'y') {
						$new_age_at_dx_precision = 'uncertain';
					} else if($new_dx['DiagnosisMaster']['dx_date_accuracy'] == 'm' || $new_dx['Participant']['date_of_birth_accuracy']== 'm') {
						$new_age_at_dx_precision = 'uncertain within 2 years';
					}
				}
			}
			if($previous_age_at_dx != $new_age_at_dx || $previous_age_at_dx_precision != $new_age_at_dx_precision)
				$dx_to_update[] = array('DiagnosisMaster' => array('id' => $dx_id, 'age_at_dx' => $new_age_at_dx, 'age_at_dx_precision' => $new_age_at_dx_precision));
		}
		foreach($warnings as $new_warning) AppController::getInstance()->addWarningMsg($new_warning);
	
		$this->addWritableField(array('age_at_dx', 'age_at_dx_precision'));
		
		foreach($dx_to_update as $dx_data) {
			if(isset($thid->data)) $thid->data = array();
			$this->id = $dx_data['DiagnosisMaster']['id'];
			if(!$this->save($dx_data, false)) AppController::getInstance()->redirect( '/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true );
		}
	}
	
	function validateAndUpdateTopoMorphoData() {
		$diagnosis_data =& $this->data;
	
		// check data structure
		$tmp_arr_to_check = array_values($diagnosis_data);
		if((!is_array($diagnosis_data)) || (is_array($tmp_arr_to_check) && isset($tmp_arr_to_check[0]['DiagnosisMaster']))) {
			AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		}
	
		// Launch validation
		if(array_key_exists('FunctionManagement', $diagnosis_data)) {
			//Morphology
			if(array_key_exists('chus_autocomplete_digestive_morphology', $diagnosis_data['FunctionManagement'])) {
				$diagnosis_data['FunctionManagement']['chus_autocomplete_digestive_morphology'] = trim($diagnosis_data['FunctionManagement']['chus_autocomplete_digestive_morphology']);
				if(strlen($diagnosis_data['FunctionManagement']['chus_autocomplete_digestive_morphology'])) {
					$selected_morphos = array();
					if(preg_match("/\[([0-9]+)\]$/i", $diagnosis_data['FunctionManagement']['chus_autocomplete_digestive_morphology'], $matches) > 0){
						$morphology_id = $matches[1];
						$selected_morphos = $this->query("SELECT * FROM chus_morphology_coding WHERE id = $morphology_id");
					} else if(preg_match("/^([0-9]+\/[0-9]+)/i", $diagnosis_data['FunctionManagement']['chus_autocomplete_digestive_morphology'], $matches) > 0) {
						$morphology_code = $matches[1];
						$selected_morphos = $this->query("SELECT * FROM chus_morphology_coding WHERE morphology_code = '$morphology_code'");
					}
					if(sizeof($selected_morphos) == 1) {
						$diagnosis_data['DiagnosisDetail']['chus_morphology'] = $selected_morphos['0']['chus_morphology_coding']['morphology_code'];
						$diagnosis_data['DiagnosisDetail']['morphology_id'] = $selected_morphos['0']['chus_morphology_coding']['id'];
						$diagnosis_data['DiagnosisDetail']['morphology_tumour_type'] = $selected_morphos['0']['chus_morphology_coding']['tumour_type'];
						$diagnosis_data['DiagnosisDetail']['morphology_tumour_cell_origin'] = $selected_morphos['0']['chus_morphology_coding']['tumour_cell_origin'];
						$diagnosis_data['DiagnosisDetail']['morphology_tumour_category'] = $selected_morphos['0']['chus_morphology_coding']['tumour_category'];
						$diagnosis_data['DiagnosisDetail']['morphology_behaviour_code'] = $selected_morphos['0']['chus_morphology_coding']['behaviour_code'];
						$diagnosis_data['DiagnosisDetail']['morphology_description'] = $selected_morphos['0']['chus_morphology_coding']['morphology_description'];
						$this->addWritableField(array('chus_morphology', 'morphology_tumour_type', 'morphology_tumour_cell_origin', 'morphology_tumour_category', 'morphology_behaviour_code', 'morphology_description'));
					} else if(sizeof($selected_morphos) > 1) {
						$this->validationErrors['chus_autocomplete_digestive_morphology'] = array('error' => str_replace('%s', $diagnosis_data['FunctionManagement']['chus_autocomplete_digestive_morphology'], __('more than one morphology value matches the following data [%s]')));
					} else {
						$this->validationErrors['chus_autocomplete_digestive_morphology'] = array('error' => str_replace('%s', $diagnosis_data['FunctionManagement']['chus_autocomplete_digestive_morphology'], __('no morphology value matches the following data [%s]')));
					}
				}
			}		
		}
	}
	
	function getChusMorphologyDataForDisplay($morpho_data) {
	
		//-- NOTE ----------------------------------------------------------------
		//
		// This function is linked to a function of the DiagnosisMaster controller
		// called autocompleteChusMorphology()
		//
		// When you override the getStudyDataAndCodeForDisplay() function,
		// check if you need to override these functions.
		//
		//------------------------------------------------------------------------
		
		if(!empty($morpho_data)) {
			if(isset($morpho_data['chus_morphology_coding'])) $morpho_data = $morpho_data['chus_morphology_coding'];
			if(isset($morpho_data['id']) && !empty($morpho_data['id'])) {
				$all_info = array();
				foreach(array('tumour_type', 'tumour_cell_origin', 'tumour_category', 'behaviour_code', 'morphology_description') as $field) {
					if(isset($morpho_data[$field])) $all_info[] = ' - '.$morpho_data[$field];
				}
				$all_info = implode('', $all_info);
				return (isset($morpho_data['morphology_code'])? $morpho_data['morphology_code']: 'N/A').$all_info.' ['.$morpho_data['id'].']';
			}
		}
		return '';
	}
	
	function getChusMorphologyValues($field) {
		$field = $field[0];
		$res = array();
		foreach($this->query("SELECT DISTINCT $field FROM chus_morphology_coding ORDER BY $field ASC") as $new_unit) $res[$new_unit['chus_morphology_coding'][$field]] = $new_unit['chus_morphology_coding'][$field];
		return $res;
	}
}
