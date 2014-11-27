<?php

class EventMastersControllerCustom extends EventMastersController {
	
	var $paginate = array('EventMaster'=>array('limit' => pagination_amount,'order'=>'EventMaster.event_date ASC, EventMaster.procure_form_identification ASC'));
	
	function listallBasedOnControlId($participant_id, $event_control_id, $event_type = '', $interval_start_date = null, $interval_start_date_accuracy = null, $interval_finish_date = null, $interval_finish_date_accuracy = null){
		//*** Specific list display based on control_id
		$participant_data = $this->Participant->getOrRedirect($participant_id);
		$this->set('atim_menu_variables', array('Participant.id'=>$participant_id));
		$this->set('atim_menu', $this->Menus->get('/ClinicalAnnotation/EventMasters/listall/Clinical/%%Participant.id%%'));
		$event_control = $this->EventControl->getOrRedirect($event_control_id);
		$this->Structures->set($event_control['EventControl']['form_alias']);
		if(is_null($interval_start_date) && is_null($interval_finish_date)) {
			// 1- No Date Restriction
			$this->request->data = $this->paginate($this->EventMaster, array('EventMaster.participant_id' => $participant_id, 'EventMaster.event_control_id' => $event_control_id));
		} else {
			// 2- Date Restriction
			$interval_start_date = preg_match('/^[0-9]{4}\-[0-9]{2}\-[0-9]{2}$/', $interval_start_date)? $interval_start_date : '';
			$interval_finish_date = preg_match('/^[0-9]{4}\-[0-9]{2}\-[0-9]{2}$/', $interval_finish_date)? $interval_finish_date : '';
			$events_list_conditions = array(
				'EventMaster.participant_id' => $participant_id,
				'EventMaster.event_control_id' => $event_control_id);
			$msg = '';
			if($interval_start_date && $interval_finish_date) {
				$events_list_conditions[]['OR'] = array(
					"EventMaster.event_date IS NULL",
					"EventMaster.event_date IS NOT NULL AND '$interval_start_date' <= EventMaster.event_date  AND EventMaster.event_date <= '$interval_finish_date'");
				$msg = "%event% list from %start% to %end%";
			} else if($interval_start_date){
				$events_list_conditions[]['OR'] = array(
						"EventMaster.event_date IS NULL",
						"EventMaster.event_date IS NOT NULL AND EventMaster.event_date >= '$interval_start_date'");
				$msg = "%event% list after %start%";
			} else if($interval_finish_date){
				$events_list_conditions[]['OR'] = array(
						"EventMaster.event_date IS NULL",
						"EventMaster.event_date IS NOT NULL AND EventMaster.event_date <= '$interval_finish_date'");
				$msg = "%event% list before %end%";
			} else {
				$msg = "unable to limit data list to a dates interval";
			}
			AppController::addWarningMsg(str_replace(array('%event%','%start%', '%end%'), array(__($event_type), $interval_start_date,$interval_finish_date),__($msg)));
			if(($interval_finish_date_accuracy.$interval_start_date_accuracy) != 'cc') AppController::addWarningMsg(__("at least one of the studied interval date is inaccurate"));
			$this->request->data = $this->paginate($this->EventMaster, $events_list_conditions);
		}
	}
}

?>