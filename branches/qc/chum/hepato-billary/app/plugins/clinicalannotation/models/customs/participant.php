<?php

class ParticipantCustom extends Participant {
	var $useTable = 'participants';
	var $name = 'Participant';
	
	function summary( $variables=array() ) {
		$return = array();
		
		if(isset($variables['Participant.id'])){
			
			$result = $this->find('first', array('conditions' => array('Participant.id' => $variables['Participant.id'])));
			$result['FunctionManagement'] = array(
				'health_insurance_card'				=> null,
				'hepato_bil_bank_participant_id'	=> null,
				'saint_luc_hospital_nbr'			=> null
			);
			
			$misc_identifier_model = AppModel::getInstance('clinicalannotation', 'MiscIdentifier', true);
			$identifiers = $misc_identifier_model->find('all', array('conditions' => array('Participant.id' => $variables['Participant.id'], 'MiscIdentifier.misc_identifier_control_id < ' => 4)));
			
		  	//Add No Labs to description
			foreach($identifiers as $identifier){
				switch($identifier['MiscIdentifier']['misc_identifier_control_id']){
					case 1:
						$result['FunctionManagement']['health_insurance_card'] = $identifier['MiscIdentifier']['identifier_value']; 
					case 2:
						$result['FunctionManagement']['saint_luc_hospital_nbr'] = $identifier['MiscIdentifier']['identifier_value'];
					case 3:
						$result['FunctionManagement']['hepato_bil_bank_participant_id'] = $identifier['MiscIdentifier']['identifier_value'];
					default:
						
				}				
			}
			
			$return = array(
				'menu'				=>	array( NULL, ($result['Participant']['first_name'].' - '.$result['Participant']['last_name']) ),
				'title'				=>	array( NULL, __('participant', TRUE) . ': ' . ($result['Participant']['first_name'].' - '.$result['Participant']['last_name']) ),
				'structure alias'	=> 'participants,qc_hb_ident_summary',
				'data'				=> $result
			);
			
		}
		
		return $return;
	}
	
	function beforeSave($options) {
		// Set Data For Trt Update
		$this->data['HbParticipantFunctionManagement']['is_last_news_date_updated'] = false;
		
		if(!empty($this->id)) {
			// Participant data has just been updated
			$previous_participant_data = $this->find('first', array('conditions' => array('Participant.id' => $this->id), 'recursive' => '-1'));
			if(empty($previous_participant_data)) AppController::getInstance()->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
			
			if($this->data['Participant']['last_news_date'] != $previous_participant_data['Participant']['last_news_date']) {
				$this->data['HbParticipantFunctionManagement']['is_last_news_date_updated'] = true;
			}
		}
		
		return true;
	}
	
	function afterSave($created) {
		if($this->data['HbParticipantFunctionManagement']['is_last_news_date_updated']) {
			$treatment_master_model = AppModel::getInstance("Clinicalannotation", "TreatmentMaster", true);
			$treatment_master_model->updateAllSurvivalTimes($this->id);
		}
	}
}

?>