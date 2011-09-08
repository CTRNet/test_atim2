<?php
			
	if(($event_control_data['EventControl']['disease_site'] == 'ld lymph.') && ($event_control_data['EventControl']['event_type'] == 'p/e and imaging')) {
		$this->data['EventDetail']['initial_pet_suv_max'] = $this->getPeAndImagingScore($this->data, $event_control_data['EventControl']);
	}

	if(($event_control_data['EventControl']['disease_site'] == 'ld lymph.') && ($event_control_data['EventControl']['event_type'] == 'initial biopsy')) {
		// Check intial biopsy linked to a primary
		
		if(empty($this->data['EventMaster']['diagnosis_master_id'])) {
			$this->DiagnosisMaster->validationErrors['dx_origin'][] = "an initial biopsy should be linked to a primary diagnosis";	
			$submitted_data_validates = false;	
			
		} else {
			$selected_diagnosis = $this->DiagnosisMaster->find('first', array('conditions'=>array('DiagnosisMaster.participant_id'=>$participant_id, 'DiagnosisMaster.id'=>$this->data['EventMaster']['diagnosis_master_id']), 'recursive' => '-1'));
			if(empty($selected_diagnosis)) $this->redirect( '/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true );
			
			if($selected_diagnosis['DiagnosisMaster']['dx_origin'] != 'primary') {
				$this->DiagnosisMaster->validationErrors['dx_origin'][] = "an initial biopsy should be linked to a primary diagnosis";	
				$submitted_data_validates = false;	
			}
		}
		
		$conditions = array(
			'EventMaster.event_control_id'=>$this->data['EventMaster']['event_control_id'], 
			'EventMaster.participant_id'=>$participant_id, 
			'EventMaster.diagnosis_master_id'=>$this->data['EventMaster']['diagnosis_master_id']);
		if($submitted_data_validates && $this->EventMaster->find('count',array('conditions'=>$conditions))) {
			$this->addWarningMsg(__('2 initial biopsies are linked to the same diagnosis', true));
		}
	}

?>
