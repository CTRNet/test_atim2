<?php

class StudySummaryCustom extends StudySummary
{
	var $name = 'StudySummary';
	var $useTable = 'study_summaries';
	
	private $study_complementary_information_for_autocomplete = array();
	
	function beforeFind($queryData){
		if(isset($queryData['conditions']) && isset($queryData['conditions']['StudyInvestigator.last_name'])) {
	 		$queryData['joins'][] = array(
	 				'table' => 'study_investigators',
	 				'alias'	=> 'StudyInvestigator',
	 				'type'	=> 'LEFT',
	 				'conditions' => array('StudyInvestigator.study_summary_id = StudySummary.id')
			);
		}		
		return $queryData;
	}
	
	function getStudyComplementaryInformationFromId($add_institution = false) {
		$result = array();
		$StructurePermissibleValuesCustom = AppModel::getInstance("", "StructurePermissibleValuesCustom", true);
		//Build id to isntitution array
		$institutions = $StructurePermissibleValuesCustom->getCustomDropdown(array('Institutions & Laboratories'));
		$institutions = array_replace($institutions['defined'], $institutions['previously_defined']);
		foreach($this->find('all', array('conditions' => array(), 'fields' => 'StudySummary.id, StudySummary.qc_nd_institution')) as $new_study) {
			$qc_nd_institution = strlen($new_study['StudySummary']['qc_nd_institution'])? 
				(isset($institutions[$new_study['StudySummary']['qc_nd_institution']])? $institutions[$new_study['StudySummary']['qc_nd_institution']] : $new_study['StudySummary']['qc_nd_institution']): 
				'';
			$result[$new_study['StudySummary']['id']] = array('institution' => $qc_nd_institution, 'investigators' => array());
		}
		
		//Add investigators to the list
		if($result) {
			$investigators = $StructurePermissibleValuesCustom->getCustomDropdown(array('researchers'));
			$investigators = array_replace($investigators['defined'], $investigators['previously_defined']);
			$StudyInvestigator = AppModel::getInstance("Study", "StudyInvestigator", true);
			foreach($StudyInvestigator->find('all', array('conditions' => array('StudyInvestigator.study_summary_id' => array_keys($result)), 'fields' => 'StudyInvestigator.study_summary_id, StudyInvestigator.last_name')) as $new_investigator) {
				if(isset($result[$new_investigator['StudyInvestigator']['study_summary_id']]) && strlen($new_investigator['StudyInvestigator']['last_name'])) {
					$investiagtor_last_name = isset($investigators[$new_investigator['StudyInvestigator']['last_name']])? 
						$investigators[$new_investigator['StudyInvestigator']['last_name']] : 
						$new_investigator['StudyInvestigator']['last_name'];
					$result[$new_investigator['StudyInvestigator']['study_summary_id']]['investigators'][$investiagtor_last_name] = $investiagtor_last_name;
				}
			}
		}
		//Build list
		foreach($result as $key => $res) {
			if(!$add_institution) unset($res['institution']);
			$res['investigators'] = implode(' & ', $res['investigators']);
			$res = array_filter($res);
			$result[$key] = implode(' - ', $res);
		}	
		return $result;
	}
	
	function getStudyDataAndCodeForDisplay($study_data) {
	
		//-- NOTE ----------------------------------------------------------------
		//
		// This function is linked to a function of the StudySummary controller
		// called autocompleteStudy()
		// and to functions of the StudySummary model
		// getStudyIdFromStudyDataAndCode().
		//
		// When you override the getStudyDataAndCodeForDisplay() function,
		// check if you need to override these functions.
		//
		//------------------------------------------------------------------------
		
		if(!$this->study_complementary_information_for_autocomplete) {
			$this->study_complementary_information_for_autocomplete = $this->getStudyComplementaryInformationFromId(true);
		}		
		$formatted_data = '';
		if((!empty($study_data)) && isset($study_data['StudySummary']['id']) && (!empty($study_data['StudySummary']['id']))) {
			if(!isset($this->study_data_and_code_for_display_already_set[$study_data['StudySummary']['id']])) {
				if(!isset($study_data['StudySummary']['title'])) {
					$study_data = $this->find('first', array('conditions' => array('StudySummary.id' => ($study_data['StudySummary']['id']))));
				}
				$study_complementary_information = isset($this->study_complementary_information_for_autocomplete[$study_data['StudySummary']['id']])?
					$this->study_complementary_information_for_autocomplete[$study_data['StudySummary']['id']] : 
					'';
				$this->study_data_and_code_for_display_already_set[$study_data['StudySummary']['id']] = 
					$study_data['StudySummary']['title'] . 
					(strlen($study_complementary_information)? ' ('.$study_complementary_information.')': '').
					' [' . $study_data['StudySummary']['id'] . ']';
			}
			$formatted_data = $this->study_data_and_code_for_display_already_set[$study_data['StudySummary']['id']];
		}
		return $formatted_data;
	}
	
	function getStudyIdFromStudyDataAndCode($study_data_and_code){
	
		//-- NOTE ----------------------------------------------------------------
		//
		// This function is linked to a function of the StudySummary controller
		// called autocompleteStudy()
		// and to function of the StudySummary model
		// getStudyDataAndCodeForDisplay().
		//
		// When you override the getStudyIdFromStudyDataAndCode() function,
		// check if you need to override these functions.
		//
		//------------------------------------------------------------------------
	
		if(!isset($this->study_titles_already_checked[$study_data_and_code])) {
			$matches = array();
			$selected_studies = array();
			if(preg_match("/(.+)\[([0-9]+)\]/", $study_data_and_code, $matches) > 0){
				// Auto complete tool has been used
				$selected_studies = $this->find('all', array('conditions' => array('StudySummary.id' => $matches[2])));
			} else {
				// consider $study_data_and_code contains just study title
				$term = str_replace('_', '\_', str_replace('%', '\%', $study_data_and_code));
				$terms = array();
				foreach(explode(' ', $term) as $key_word) $terms[] = "StudySummary.title LIKE '%".$key_word."%'";
				$conditions = array('AND' => $terms);
				$selected_studies = $this->find('all', array('conditions' => $conditions));
			}
			if(sizeof($selected_studies) == 1) {
				$this->study_titles_already_checked[$study_data_and_code] = array('StudySummary' => $selected_studies[0]['StudySummary']);
			} else if(sizeof($selected_studies) > 1) {
				$this->study_titles_already_checked[$study_data_and_code] = array('error' => str_replace('%s', $study_data_and_code, __('more than one study matches the following data [%s]')));
			} else {
				$this->study_titles_already_checked[$study_data_and_code] = array('error' => str_replace('%s', $study_data_and_code, __('no study matches the following data [%s]')));
			}
		}
		return $this->study_titles_already_checked[$study_data_and_code];
	}
	
}
?>