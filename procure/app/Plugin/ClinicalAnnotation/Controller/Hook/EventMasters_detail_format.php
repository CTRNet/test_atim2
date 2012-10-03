<?php 

	$this->set('add_link_for_procure_forms',$this->Participant->buildAddProcureFormsButton($participant_id));
	
	if($this->request->data['EventControl']['event_type'] == 'procure follow-up worksheet') {
		$joins = array(
			array('table' => 'procure_ed_clinical_followup_worksheet_aps',
				'alias' => 'EventDetail',
				'type' => 'INNER',
				'conditions' => array('EventDetail.event_master_id = EventMaster.id'))
		);
		$this->set('aps', $this->EventMaster->find('all', array('conditions' => array('EventDetail.followup_event_master_id' => $event_master_id), 'joins' => $joins)));
		$this->Structures->set('eventmasters,procure_ed_followup_worksheet_aps', 'aps_structure');
		
		$joins = array(
				array('table' => 'procure_ed_clinical_followup_worksheet_clinical_events',
						'alias' => 'EventDetail',
						'type' => 'INNER',
						'conditions' => array('EventDetail.event_master_id = EventMaster.id'))
		);
		$this->set('clinical_events', $this->EventMaster->find('all', array('conditions' => array('EventDetail.followup_event_master_id' => $event_master_id), 'joins' => $joins)));
		$this->Structures->set('eventmasters,procure_ed_followup_worksheet_clinical_event', 'clinical_events_structure');
		
		$this->TreatmentMaster = AppModel::getInstance("ClinicalAnnotation", "TreatmentMaster", true);
		$joins = array(
				array('table' => 'procure_txd_followup_worksheet_treatments',
						'alias' => 'TreatmentDetail',
						'type' => 'INNER',
						'conditions' => array('TreatmentDetail.treatment_master_id = TreatmentMaster.id'))
		);
		$this->set('treatments', $this->TreatmentMaster->find('all', array('conditions' => array('TreatmentDetail.followup_event_master_id' => $event_master_id), 'joins' => $joins)));
		$this->Structures->set('treatmentmasters,procure_txd_followup_worksheet_treatment', 'treatments_structure');
	}
	