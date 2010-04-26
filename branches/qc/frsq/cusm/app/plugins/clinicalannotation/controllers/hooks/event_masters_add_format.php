<?php
 	// --------------------------------------------------------------------------------
	// Lab: Hidde diagnoses already linked to a lab report
	// -------------------------------------------------------------------------------- 	
	if($event_group == 'lab') {
		// Get diagnosis already linked to a lab report
		$criteria = array(
			'EventMaster.participant_id' => $participant_id,
			'EventMaster.event_control_id' => $event_control_id,
			'EventMaster.diagnosis_master_id IS NOT NULL');
			
		$linked_diagnosis_id = $this->EventMaster->find('list', array('conditions' => $criteria, 'fields' => 'EventMaster.diagnosis_master_id'));
		
		// Delete diagnosis already linked from data_for_checklist and reset data_for_checklist
		foreach($diagnosis_data as $key => $new_diagnosis) {
			if(in_array($new_diagnosis['DiagnosisMaster']['id'], $linked_diagnosis_id)) {
				unset($diagnosis_data[$key]);
			}
		}
		
		$this->set( 'data_for_checklist',  $diagnosis_data);
	}
	 	
?>
