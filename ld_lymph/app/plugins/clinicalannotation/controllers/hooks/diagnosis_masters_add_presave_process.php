<?php
		
	switch($dx_control_data['DiagnosisControl']['controls_type']) {
		case 'ld lymph. diagnostic':
			$this->data['DiagnosisMaster']['dx_origin'] = 'primary';
			if(empty($this->data['DiagnosisMaster']['primary_number']) || $this->DiagnosisMaster->find('count', array('conditions'=>array('DiagnosisMaster.primary_number'=>$this->data['DiagnosisMaster']['primary_number'], 'DiagnosisMaster.participant_id'=>$participant_id)))) {
				$this->data['DiagnosisMaster']['primary_number'] = NULL;
				$this->DiagnosisMaster->validationErrors['dx_origin'][] = "a new diagnostic should be linked to a new diagnoses group";
				$submitted_data_validates = false;	
			}
			break;
			
		case 'ld lymph. progression':
		case 'ld lymph. cns relapse':
		case 'ld lymph. histological transformation':
			$this->data['DiagnosisMaster']['dx_origin'] = 'progression';
			if(empty($this->data['DiagnosisMaster']['primary_number']) || !($this->DiagnosisMaster->find('count', array('conditions'=>array('DiagnosisMaster.primary_number'=>$this->data['DiagnosisMaster']['primary_number'], 'DiagnosisMaster.participant_id'=>$participant_id))))) {
				$this->data['DiagnosisMaster']['primary_number'] = NULL;
				$this->DiagnosisMaster->validationErrors['dx_origin'][] = "a progression should be linked to an existing diagnoses group";	
				$submitted_data_validates = false;	
			}
			break;		
		
		default:
			$this->redirect( '/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true );
	}	

?>
