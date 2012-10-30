<?php

class ParticipantCustom extends Participant {
	var $name = 'Participant';
	var $useTable = 'participants';
	
	var $hasMany = array(
		'TreatmentMaster' => array(
			'className'   => 'ClinicalAnnotation.TreatmentMaster',
			 'foreignKey'  => 'participant_id')
	); 	
	
	function beforeSave($options = array()) {
		
		$this->addWritableField(array('last_modification', 'last_modification_ds_id'));
		$this->data['Participant']['last_modification'] = $this->data['Participant']['modified']; 
		 
		if (!$this->data['Participant']['last_modification_ds_id']) {

			// If this is a new participant skip updating related diagnosis records					
			if(!empty($this->id)) {

				// Get previous participant data
				$previous_participant_data = $this->find('first', array('conditions' => array('Participant.id' => $this->id), 'recursive' => '-1'));
			
				if(empty($previous_participant_data)) {
					AppController::getInstance()->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
				}
			
				$date_of_birth = $this->data['Participant']['date_of_birth'];
				$previous_date_of_birth = $previous_participant_data['Participant']['date_of_birth'];
			
				// Update all treatment records if DOB has changed
				if($previous_date_of_birth != $date_of_birth) {
					$this->updateAllTxAges($date_of_birth);
				}	
			}	
		}	
		return true;
	}
	
	function updateAllTxAges($date_of_birth) {

		// Finds all associated treatment records
		$treatment_master_model = AppModel::getInstance("ClinicalAnnotation", "TreatmentMaster", true);
		$participant_tx_results = $treatment_master_model->find('all', array('conditions' => array ('TreatmentMaster.participant_id' => $this->id), 'recursive' => '0'));		
		
		foreach($participant_tx_results as $new_tx) {
	
			$new_tx_id = $new_tx['TreatmentMaster']['id'];
			$tx_date = $new_tx['TreatmentMaster']['start_date'];
						
			$new_tx_data = array();

			// Ensure both dates are not empty and date of dx is after DOB
			if(!empty($tx_date) && !empty($date_of_birth) && ($tx_date >= $date_of_birth)) {

				// Calculate interval between DOB and Date of Dx
				$birthDateObj = new DateTime($date_of_birth);
				$txDateObj = new DateTime($tx_date);
				$interval = $birthDateObj->diff($txDateObj);
			
				$ageInYears = $interval->format('%r%y');
				
				// Set age at values for current dx record
				$new_tx_data['TreatmentMaster']['id'] = $new_tx_id;	
				$new_tx_data['TreatmentMaster']['npttb_age_at_tx'] = $ageInYears;
       			$new_tx_data['TreatmentMaster']['skip'] = true;			
			} else {
				$new_tx_data['TreatmentMaster']['id'] = $new_tx_id;	
				$new_tx_data['TreatmentMaster']['npttb_age_at_tx'] = '';
       			$new_tx_data['TreatmentMaster']['skip'] = true;		
       		}
       		// TODO: Unsure about this section - Have it checked
       		$treatment_master_model->id = $new_tx_id;
			$treatment_master_model->data = array();
			$treatment_master_model->check_writable_fields = false;
			
			if(!$treatment_master_model->save($new_tx_data, false)) {
				AppController::getInstance()->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
			}
			$treatment_master_model->check_writable_fields = true;
				
		}
		
		return true;
	}
}
?>