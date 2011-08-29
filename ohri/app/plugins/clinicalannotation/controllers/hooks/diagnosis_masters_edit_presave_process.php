<?php

	if(!empty($this->data['DiagnosisMaster']['dx_origin'])) {
		if(($this->data['DiagnosisMaster']['dx_origin'] != $dx_master_data['DiagnosisMaster']['dx_origin']) 
		&& ($dx_master_data['DiagnosisMaster']['dx_origin'] != 'unknown')) {
			$this->data['DiagnosisMaster']['dx_origin'] = $dx_master_data['DiagnosisMaster']['dx_origin'];
			$this->DiagnosisMaster->validationErrors['dx_origin'][] = "the origin of this diagnosis can not be changed";	
			$submitted_data_validates = false;	
		
		} else {
			switch($this->data['DiagnosisMaster']['dx_origin']) {
				case 'primary':
					if($dx_master_data['DiagnosisMaster']['dx_origin'] == 'unknown') {
						$nbr_of_grp_diagnoses = $this->DiagnosisMaster->find('count', array('conditions'=>array('DiagnosisMaster.primary_number'=>$this->data['DiagnosisMaster']['primary_number'], 'DiagnosisMaster.participant_id'=>$participant_id)));
						if(empty($this->data['DiagnosisMaster']['primary_number']) || $nbr_of_grp_diagnoses) {
							$this->data['DiagnosisMaster']['primary_number'] = NULL;
							$this->DiagnosisMaster->validationErrors['dx_origin'][] = "a primary diagnosis should be linked to a new diagnoses group";
							$submitted_data_validates = false;	
						}						
					} else {
						if($dx_master_data['DiagnosisMaster']['primary_number'] != $this->data['DiagnosisMaster']['primary_number']) {
							$this->data['DiagnosisMaster']['primary_number'] = $dx_master_data['DiagnosisMaster']['primary_number'];
							$this->DiagnosisMaster->validationErrors['dx_origin'][] = "the diagnoses group of a primary diagnosis can not be changed";	
							$submitted_data_validates = false;	
						}
					}
					break;
				case 'secondary':
					$nbr_of_grp_diagnoses = $this->DiagnosisMaster->find('count', array('conditions'=>array('DiagnosisMaster.primary_number'=>$this->data['DiagnosisMaster']['primary_number'], 'DiagnosisMaster.participant_id'=>$participant_id)));
					if(empty($this->data['DiagnosisMaster']['primary_number']) || !$nbr_of_grp_diagnoses) {
						$this->data['DiagnosisMaster']['primary_number'] = $dx_master_data['DiagnosisMaster']['primary_number'];
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
	}
	
?>
