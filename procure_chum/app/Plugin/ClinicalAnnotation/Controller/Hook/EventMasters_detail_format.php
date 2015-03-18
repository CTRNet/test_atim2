<?php 

	$this->set('add_link_for_procure_forms',$this->Participant->buildAddProcureFormsButton($participant_id));
	
	if($this->request->data['EventControl']['event_type'] == 'procure follow-up worksheet') {
		//Set Event Control Id for psa and clinical event
		$event_control_data = $this->EventControl->find('first', array('conditions'=>array('EventControl.event_type' => 'procure follow-up worksheet - aps')));
		$this->set('psa_event_control_id', $event_control_data['EventControl']['id']);
		$event_control_data = $this->EventControl->find('first', array('conditions'=>array('EventControl.event_type' => 'procure follow-up worksheet - clinical event')));
		$this->set('clinical_event_control_id', $event_control_data['EventControl']['id']);
		//Set Treatment Control Id for treatments list
		$this->TreatmentControl = AppModel::getInstance("ClinicalAnnotation", "TreatmentControl", true);
		$tx_control_data = $this->TreatmentControl->find('first', array('conditions'=>array('TreatmentControl.tx_method' => 'procure follow-up worksheet - treatment')));
		$this->set('treatment_control_id', $tx_control_data['TreatmentControl']['id']);
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
		$this->set('interval_start_date', $interval_start_date);
		$this->set('interval_start_date_accuracy', $interval_start_date_accuracy);
		$this->set('interval_finish_date', empty($this->request->data['EventMaster']['event_date'])? '-1': $this->request->data['EventMaster']['event_date']);
		$this->set('interval_finish_date_accuracy', empty($this->request->data['EventMaster']['event_date'])? 'c': $this->request->data['EventMaster']['event_date_accuracy']);
	}
	