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
	
	function validateAndUpdateTopoMorphoData() {
		$diagnosis_data =& $this->data;
	
		// check data structure
		$tmp_arr_to_check = array_values($diagnosis_data);
		if((!is_array($diagnosis_data)) || (is_array($tmp_arr_to_check) && isset($tmp_arr_to_check[0]['DiagnosisMaster']))) {
			AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		}
	
		// Launch validation
		if(array_key_exists('FunctionManagement', $diagnosis_data)) {
			//Topography
			if(array_key_exists('chus_autocomplete_digestive_topography', $diagnosis_data['FunctionManagement'])) {
				$diagnosis_data['FunctionManagement']['chus_autocomplete_digestive_topography'] = trim($diagnosis_data['FunctionManagement']['chus_autocomplete_digestive_topography']);
				if(strlen($diagnosis_data['FunctionManagement']['chus_autocomplete_digestive_topography'])) {
					$selected_topos = array();				
					if(preg_match("/^(C[0-9]+)/i", $diagnosis_data['FunctionManagement']['chus_autocomplete_digestive_topography'], $matches) > 0){				
						$topography = $matches[1];
						$selected_topos = $this->query("SELECT * FROM chus_topography_coding WHERE code = '$topography'");
					}
					if(sizeof($selected_topos) == 1) {
						$diagnosis_data['DiagnosisMaster']['topography'] = $selected_topos['0']['chus_topography_coding']['code'];
						$diagnosis_data['DiagnosisDetail']['topography_category'] = $selected_topos['0']['chus_topography_coding']['category'];
						$diagnosis_data['DiagnosisDetail']['topography_description'] = $selected_topos['0']['chus_topography_coding']['description'];
						$this->addWritableField(array('topography', 'topography_category', 'topography_description'));
					} else if(sizeof($selected_topos) > 1) {
						$this->validationErrors['chus_autocomplete_digestive_topography'] = array('error' => str_replace('%s', $diagnosis_data['FunctionManagement']['chus_autocomplete_digestive_topography'], __('more than one topography value matches the following data [%s]')));
					} else {
						$this->validationErrors['chus_autocomplete_digestive_topography'] = array('error' => str_replace('%s', $diagnosis_data['FunctionManagement']['chus_autocomplete_digestive_topography'], __('no topography value matches the following data [%s]')));
					}
				}
			}
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
						$diagnosis_data['DiagnosisMaster']['morphology'] = $selected_morphos['0']['chus_morphology_coding']['morphology_code'];
						$diagnosis_data['DiagnosisDetail']['morphology_id'] = $selected_morphos['0']['chus_morphology_coding']['id'];
						$diagnosis_data['DiagnosisDetail']['morphology_tumour_type'] = $selected_morphos['0']['chus_morphology_coding']['tumour_type'];
						$diagnosis_data['DiagnosisDetail']['morphology_tumour_cell_origin'] = $selected_morphos['0']['chus_morphology_coding']['tumour_cell_origin'];
						$diagnosis_data['DiagnosisDetail']['morphology_tumour_category'] = $selected_morphos['0']['chus_morphology_coding']['tumour_category'];
						$diagnosis_data['DiagnosisDetail']['morphology_behaviour_code'] = $selected_morphos['0']['chus_morphology_coding']['behaviour_code'];
						$diagnosis_data['DiagnosisDetail']['morphology_description'] = $selected_morphos['0']['chus_morphology_coding']['morphology_description'];
						$this->addWritableField(array('morphology', 'morphology_tumour_type', 'morphology_tumour_cell_origin', 'morphology_tumour_category', 'morphology_behaviour_code', 'morphology_description'));
					} else if(sizeof($selected_morphos) > 1) {
						$this->validationErrors['chus_autocomplete_digestive_morphology'] = array('error' => str_replace('%s', $diagnosis_data['FunctionManagement']['chus_autocomplete_digestive_morphology'], __('more than one morphology value matches the following data [%s]')));
					} else {
						$this->validationErrors['chus_autocomplete_digestive_morphology'] = array('error' => str_replace('%s', $diagnosis_data['FunctionManagement']['chus_autocomplete_digestive_morphology'], __('no morphology value matches the following data [%s]')));
					}
				}
			}		
		}
	}
	
	function getChusTopographyDataForDisplay($topo_data) {
	
		//-- NOTE ----------------------------------------------------------------
		//
		// This function is linked to a function of the DiagnosisMaster controller
		// called autocompleteChusTopography().
		//
		// When you override the getStudyDataAndCodeForDisplay() function,
		// check if you need to override these functions.
		//
		//------------------------------------------------------------------------
		
		if(!empty($topo_data)) {
			if(isset($topo_data['chus_topography_coding'])) $topo_data = $topo_data['chus_topography_coding'];
			if(isset($topo_data['code']) && !empty($topo_data['code'])) {
				return $topo_data['code'].
					(isset($topo_data['category'])? ' - '.$topo_data['category']: '').
					(isset($topo_data['description'])? ' - '.$topo_data['description']: '');
			}	
		}
		return '';
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
	
	function getChusTopographyValues($field) {
		$field = $field[0];
		$res = array();
		foreach($this->query("SELECT DISTINCT $field FROM chus_topography_coding ORDER BY $field ASC") as $new_unit) $res[$new_unit['chus_topography_coding'][$field]] = $new_unit['chus_topography_coding'][$field];
		return $res;
	}
	
	function getChusMorphologyValues($field) {
		$field = $field[0];
		$res = array();
		foreach($this->query("SELECT DISTINCT $field FROM chus_morphology_coding ORDER BY $field ASC") as $new_unit) $res[$new_unit['chus_morphology_coding'][$field]] = $new_unit['chus_morphology_coding'][$field];
		return $res;
	}
	
	function getSecondaryIcd10Codes() {
		$res = array();
		$lang = Configure::read('Config.language') == "eng" ? "en" : "fr";
		$CodingIcd_model = AppModel::getInstance("CodingIcd", "CodingIcd10Who", true);
		foreach($CodingIcd_model->find('all', array('conditions' => array('CodingIcd10Who.en_title' => 'neoplasms', "CodingIcd10Who.en_description LIKE  '%secondary%'"), 'order' => 'id ASC')) as $new_unit) {
			$res[$new_unit['CodingIcd10Who']['id']] = $new_unit['CodingIcd10Who']['id'].' '.$new_unit['CodingIcd10Who'][$lang.'_description'];
		}
		return $res;
	}
}
