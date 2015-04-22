<?php 

	$this->set('add_link_for_procure_forms',$this->Participant->buildAddProcureFormsButton($participant_id));
	
	if($this->request->data['EventControl']['event_type'] == 'procure follow-up worksheet') {
		//Set Event Control Id for psa and clinical event
		$events_types = array('procure follow-up worksheet - aps',
			'procure follow-up worksheet - clinical event',
			'procure follow-up worksheet - clinical note');
		$this->set('linked_events_control_data', $this->EventControl->find('all', array('conditions'=>array('EventControl.event_type' => $events_types))));
		$events_types = array('procure follow-up worksheet - other tumor dx');		
		$this->set('other_dx_events_control_data', $this->EventControl->find('all', array('conditions'=>array('EventControl.event_type' => $events_types))));
		//Set Treatment Control Id for treatments list
		$this->TreatmentControl = AppModel::getInstance("ClinicalAnnotation", "TreatmentControl", true);
		$this->set('linked_tx_control_data', $this->TreatmentControl->find('all', array('conditions'=>array('TreatmentControl.tx_method' => array('procure follow-up worksheet - treatment')))));
		$this->set('other_dx_tx_control_data', $this->TreatmentControl->find('all', array('conditions'=>array('TreatmentControl.tx_method' => array('procure follow-up worksheet - other tumor tx')))));
		//Set Inteval Dates (previous Medication Worksheet date to studied Medication Worksheet date)
		$interval_start_date = '-1';
		$interval_start_date_accuracy = 'c';
		if($this->request->data['EventMaster']['event_date']) {
			$previous_followup_woksheet_conditions = array(
				'EventMaster.event_control_id'=>$this->request->data['EventControl']['id'],
				'EventMaster.participant_id' => $participant_id,
				"EventMaster.event_date IS NOT NULL",
				"EventMaster.event_date < '".$this->request->data['EventMaster']['event_date']."'",
			);
			$previous_followup_woksheet_data = $this->EventMaster->find('first',array('conditions'=>$previous_followup_woksheet_conditions, 'order' => array('EventMaster.event_date DESC')));
			if($previous_followup_woksheet_data) {
				$interval_start_date = $previous_followup_woksheet_data['EventMaster']['event_date'];
				$interval_start_date_accuracy = $previous_followup_woksheet_data['EventMaster']['event_date_accuracy'];
			}
		}
		$interval_finish_date = empty($this->request->data['EventMaster']['event_date'])? '-1': $this->request->data['EventMaster']['event_date'];
		$interval_finish_date_accuracy = empty($this->request->data['EventMaster']['event_date'])? 'c': $this->request->data['EventMaster']['event_date_accuracy'];
		$this->set('interval_start_date', $interval_start_date);
		$this->set('interval_start_date_accuracy', $interval_start_date_accuracy);
		$this->set('interval_finish_date', $interval_finish_date);
		$this->set('interval_finish_date_accuracy', $interval_finish_date_accuracy);
		//Interval message
		$msg = '';
		$interval_start_date = preg_match('/^[0-9]{4}\-[0-9]{2}\-[0-9]{2}$/', $interval_start_date)? $interval_start_date : '';
		$interval_finish_date = preg_match('/^[0-9]{4}\-[0-9]{2}\-[0-9]{2}$/', $interval_finish_date)? $interval_finish_date : '';
		if($interval_start_date && $interval_finish_date) {
			$msg = "clincial data from %start% to %end%";
		} else if($interval_start_date){
			$msg = "clincial data after %start%";
		} else if($interval_finish_date){
			$msg = "clincial data before %end%";
		} else {
			$msg = "unable to limit clincial data to a dates interval";
		}
		AppController::addWarningMsg(str_replace(array('%start%', '%end%'), array($interval_start_date,$interval_finish_date),__($msg)));
		
	}
	