<?php
		
	if(!empty($this->data['DiagnosisMaster']['dx_origin'])) {
		switch($this->data['DiagnosisMaster']['dx_origin']) {
			case 'primary':
				$nbr_of_grp_diagnoses = $this->DiagnosisMaster->find('count', array('conditions'=>array('DiagnosisMaster.primary_number'=>$this->data['DiagnosisMaster']['primary_number'], 'DiagnosisMaster.participant_id'=>$participant_id)));
				if(empty($this->data['DiagnosisMaster']['primary_number']) || $nbr_of_grp_diagnoses) {
					$this->data['DiagnosisMaster']['primary_number'] = NULL;
					$this->DiagnosisMaster->validationErrors['dx_origin'][] = "a primary diagnosis should be linked to a new diagnoses group";
					$submitted_data_validates = false;	
				}
				break;
			case 'secondary':
				$nbr_of_grp_diagnoses = $this->DiagnosisMaster->find('count', array('conditions'=>array('DiagnosisMaster.primary_number'=>$this->data['DiagnosisMaster']['primary_number'], 'DiagnosisMaster.participant_id'=>$participant_id)));
				if(empty($this->data['DiagnosisMaster']['primary_number']) || !$nbr_of_grp_diagnoses) {
					$this->data['DiagnosisMaster']['primary_number'] = NULL;
					$this->DiagnosisMaster->validationErrors['dx_origin'][] = "a secondary diagnosis should be linked to an existing diagnoses group";	
					$submitted_data_validates = false;	
				}			
				break;
			case 'unknown':
				if(!empty($this->data['DiagnosisMaster']['primary_number'])) {
					$this->data['DiagnosisMaster']['primary_number'] = NULL;
					$this->DiagnosisMaster->validationErrors['dx_origin'][] = "a diagnosis with an origin equals to unknown should not be linked to a diagnoses group";
					$submitted_data_validates = false;	
				}
				break;
			default:
				$this->redirect( '/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true );		
		}
	}

	if(($this->data['DiagnosisMaster']['ohri_tumor_site'] == "Female Genital-Ovary") && ($dx_control_data['DiagnosisControl']['controls_type'] != 'diagnosis ohri - ovary')) {
		$this->DiagnosisMaster->validationErrors['dx_origin'][] = "use diagnosis ohri - ovary diagnosis type to record ovarian tumor";
		$submitted_data_validates = false;	
	}
?>
