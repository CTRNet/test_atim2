<?php

class StudySummaryCustom extends StudySummary
{
	var $name = 'StudySummary';
	var $useTable = 'study_summaries';
	
	function allowDeletion($study_summary_id) {	
		$ctrl_model = AppModel::getInstance("ClinicalAnnotation", "EventMaster", true);
		$ctrl_value = $ctrl_model->find('count', array(
			'conditions' => array('EventDetail.study_summary_id' => $study_summary_id), 
			'joins' => array(array('table' => 'ovcare_ed_study_inclusions', 'alias' => 'EventDetail', 'type' => 'INNER', 'conditions' => array('EventDetail.event_master_id = EventMaster.id'))),
			'recursive' => '-1'));
		if($ctrl_value > 0) { 
			return array('allow_deletion' => false, 'msg' => 'study/project is assigned to a participant'); 
		}
		return parent::allowDeletion($study_summary_id);
	}
	
}
?>