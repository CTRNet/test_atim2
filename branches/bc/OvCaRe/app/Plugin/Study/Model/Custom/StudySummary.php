<?php

class StudySummaryCustom extends StudySummary
{
	var $name = 'StudySummary';
	var $useTable = 'study_summaries';
	
	function allowDeletion($study_summary_id) {	
		
		$ctrl_model = AppModel::getInstance("ClinicalAnnotation", "EventMaster", true);
		$ctrl_value = $ctrl_model->find('count', array(
			'conditions' => array('EventMaster.ovcare_study_summary_id' => $study_summary_id), 
			'recursive' => '-1'));
		if($ctrl_value > 0) { 
			return array('allow_deletion' => false, 'msg' => 'study/project is assigned to a participant'); 
		}
		
		//***********************************************************************************************************************
		//TODO Ying Request To Validate
		//***********************************************************************************************************************
// 		$ctrl_model = AppModel::getInstance("InventoryManagement", "Collection", true);
// 		$ctrl_value = $ctrl_model->find('count', array(
// 				'conditions' => array('Collection.ovcare_study_summary_id' => $study_summary_id),
// 				'recursive' => '-1'));
// 		if($ctrl_value > 0) {
// 			return array('allow_deletion' => false, 'msg' => 'study/project is assigned to a collection');
// 		}
		//***********************************************************************************************************************
		//TODO End Ying Request To Validate
		//***********************************************************************************************************************
		
		return parent::allowDeletion($study_summary_id);
	}
	
}
?>