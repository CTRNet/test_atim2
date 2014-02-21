<?php

	if($event_control_data['EventControl']['use_addgrid']) $this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		
	// --------------------------------------------------------------------------------
	// Check Event Type could be created more than once
	// --------------------------------------------------------------------------------
	$unique_event_type_list = array(
		'clinical-presentation',
		'lifestyle-summary',
		'medical_history-medical past history record summary',
		'imagery-medical imaging record summary',
		'clinical-cirrhosis medical past history');
	if(in_array(($event_control_data['EventControl']['event_group'].'-'.$event_control_data['EventControl']['event_type']), $unique_event_type_list)) {
		$tmp_conditions = array(
			'EventMaster.participant_id'=>$participant_id,
			'EventMaster.event_control_id'=>$event_control_data['EventControl']['id']);
		if($this->EventMaster->find('count', array('conditions'=>array($tmp_conditions)))) {
			$this->flash(__('this type of event has already been created for your participant'), '/ClinicalAnnotation/EventMasters/listall/'.$event_group.'/'.$participant_id );
			return;
		}
	}
	
	// --------------------------------------------------------------------------------
	// hepatobiliary-lab-biology : 
	//   Set participant surgeries list for hepatobiliary-lab-biology.
	// --------------------------------------------------------------------------------
	$surgeries_for_lab_report = $this->EventMaster->getParticipantSurgeriesList($event_control_data, $participant_id);
	if(!is_null($surgeries_for_lab_report)) $this->set('surgeries_for_lab_report', $surgeries_for_lab_report);	
	
?>