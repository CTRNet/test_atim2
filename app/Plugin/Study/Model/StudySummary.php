<?php

class StudySummary extends StudyAppModel
{
	var $name = 'StudySummary';
	var $useTable = 'study_summaries';
	
	var $study_titles_already_checked = array();
	var $study_data_and_code_for_display_already_set = array();
	

	function summary( $variables=array() ) {
		$return = false;
		
		if ( isset($variables['StudySummary.id']) ) {
			
			$result = $this->find('first', array('conditions'=>array('StudySummary.id'=>$variables['StudySummary.id'])));
			
			$return = array(
				'menu'			=>	array( NULL, $result['StudySummary']['title'], TRUE),
				'title'			=>	array( NULL, $result['StudySummary']['title'], TRUE),
				'data'			=> $result,
				'structure alias'=>'studysummaries'
			);
		}
		
		return $return;
	}
	
	/**
	 * Get permissible values array gathering all existing studies.
	 *
	 * @author N. Luc
	 * @since 2010-05-26
	 * @updated N. Luc
	 */  
	function getStudyPermissibleValues() {
		$result = array();
					
		foreach($this->find('all', array('order' => 'StudySummary.title ASC')) as $new_study) {
			$result[$new_study['StudySummary']['id']] = $this->getStudyDataAndCodeForDisplay($new_study);
		}
		asort($result);
		
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
		
		$formatted_data = '';
		if((!empty($study_data)) && isset($study_data['StudySummary']['id']) && (!empty($study_data['StudySummary']['id']))) {
			if(!isset($this->study_data_and_code_for_display_already_set[$study_data['StudySummary']['id']])) {
				if(!isset($study_data['StudySummary']['title'])) {
					$study_data = $this->find('first', array('conditions' => array('StudySummary.id' => ($study_data['StudySummary']['id']))));
				}
				$this->study_data_and_code_for_display_already_set[$study_data['StudySummary']['id']] = $study_data['StudySummary']['title'] . ' [' . $study_data['StudySummary']['id'] . ']';
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
				$selected_studies = $this->find('all', array('conditions' => array("StudySummary.title LIKE '%".trim($matches[1])."%'", 'StudySummary.id' => $matches[2])));
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
	
	function getStudyPermissibleValuesForView() {
		$result = $this->getStudyPermissibleValues();
		$result['-1'] = __('not applicable');			
		return $result;
	}
	
	function allowDeletion($study_summary_id) {
		$ctrl_model = AppModel::getInstance("Study", "StudyFunding", true);
		$ctrl_value = $ctrl_model->find('count', array('conditions' => array('StudyFunding.study_summary_id' => $study_summary_id), 'recursive' => '-1'));
		if($ctrl_value > 0) { 
			return array('allow_deletion' => false, 'msg' => 'study funding is assigned to the study/project'); 
		}	
		
		$ctrl_model = AppModel::getInstance("Study", "StudyInvestigator", true);
		$ctrl_value = $ctrl_model->find('count', array('conditions' => array('StudyInvestigator.study_summary_id' => $study_summary_id), 'recursive' => '-1'));
		if($ctrl_value > 0) { 
			return array('allow_deletion' => false, 'msg' => 'study investigator is assigned to the study/project'); 
		}	
		
		$ctrl_model = AppModel::getInstance("StorageLayout", "TmaSlide", true);
		$ctrl_value = $ctrl_model->find('count', array('conditions' => array('TmaSlide.study_summary_id' => $study_summary_id), 'recursive' => '-1'));
		if($ctrl_value > 0) {
			return array('allow_deletion' => false, 'msg' => 'study/project is assigned to a tma slide');
		}
		
		$ctrl_model = AppModel::getInstance("ClinicalAnnotation", "MiscIdentifier", true);
		$ctrl_value = $ctrl_model->find('count', array('conditions' => array('MiscIdentifier.study_summary_id' => $study_summary_id), 'recursive' => '-1'));
		if($ctrl_value > 0) { 
			return array('allow_deletion' => false, 'msg' => 'study/project is assigned to a participant'); 
		}	
		
		$ctrl_model = AppModel::getInstance("ClinicalAnnotation", "ConsentMaster", true);
		$ctrl_value = $ctrl_model->find('count', array('conditions' => array('ConsentMaster.study_summary_id' => $study_summary_id), 'recursive' => '-1'));
		if($ctrl_value > 0) { 
			return array('allow_deletion' => false, 'msg' => 'study/project is assigned to a consent'); 
		}	
		
		$ctrl_model = AppModel::getInstance("Order", "Order", true);
		$ctrl_value = $ctrl_model->find('count', array('conditions' => array('Order.default_study_summary_id' => $study_summary_id), 'recursive' => '-1'));
		if($ctrl_value > 0) { 
			return array('allow_deletion' => false, 'msg' => 'study/project is assigned to an order'); 
		}
		
		$order_ling_model = AppModel::getInstance("Order", "OrderLine", true);
		$returned_nbr = $order_ling_model->find('count', array('conditions' => array('OrderLine.study_summary_id' => $study_summary_id), 'recursive' => '-1'));
		if($returned_nbr > 0) { 
			return array('allow_deletion' => false, 'msg' => 'study/project is assigned to an order line'); 
		}
		
		$ctrl_model = AppModel::getInstance("InventoryManagement", "AliquotMaster", true);
		$ctrl_value = $ctrl_model->find('count', array('conditions' => array('AliquotMaster.study_summary_id' => $study_summary_id), 'recursive' => '-1'));
		if($ctrl_value > 0) { 
			return array('allow_deletion' => false, 'msg' => 'study/project is assigned to an aliquot'); 
		}	

		$ctrl_model = AppModel::getInstance("InventoryManagement", "AliquotInternalUse", true);
		$ctrl_value = $ctrl_model->find('count', array('conditions' => array('AliquotInternalUse.study_summary_id' => $study_summary_id), 'recursive' => '-1'));
		if($ctrl_value > 0) { 
			return array('allow_deletion' => false, 'msg' => 'study/project is assigned to an aliquot'); 
		}		

		return array('allow_deletion' => true, 'msg' => '');
	}
	
}
?>