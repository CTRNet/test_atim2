<?php

class TreatmentMasterCustom extends TreatmentMaster {
	var $useTable = 'treatment_masters';
	var $name = 'TreatmentMaster';
	
	function summary( $variables=array() ) {
		$return = false;
	
		if ( isset($variables['TreatmentMaster.id']) ) {
				
			$result = $this->find('first', array('conditions'=>array('TreatmentMaster.id'=>$variables['TreatmentMaster.id'])));
				
			$return = array(
					'menu'    			=> array( NULL, __($result['TreatmentControl']['tx_method'], TRUE)),
					'title'	 			=> array( NULL, __($result['TreatmentControl']['tx_method'], TRUE)),
					'data'				=> $result,
					'structure alias'	=> 'treatmentmasters'
			);
		}
	
		return $return;
	}
	
	function beforeValidate($options) {
		$result = parent::beforeValidate($options);
			
		if(array_key_exists('followup_event_master_id', $this->data['TreatmentDetail'])) {
			//F1-Followup medical treatment
			$EventMaster = AppModel::getInstance("ClinicalAnnotation", "EventMaster", true);
			$tmp_res = $EventMaster->find('first', array('conditions' => array('EventMaster.id' => $this->data['TreatmentDetail']['followup_event_master_id']), 'recursive' => '0'));
			$this->data['TreatmentMaster']['procure_form_identification'] = empty($tmp_res)? 'n/a' : $tmp_res['EventMaster']['procure_form_identification'];
			$this->addWritableField(array('procure_form_identification'));
		
		} else if(array_key_exists('procure_form_identification', $this->data['TreatmentMaster'])) {
			//Form identification validation
			$Participant = AppModel::getInstance("ClinicalAnnotation", "Participant", true);
			$error = $Participant->validateFormIdentification($this->data['TreatmentMaster']['procure_form_identification'], 'TreatmentMaster', $this->id);
			if($error) {
				$result = false;
				$this->validationErrors['procure_form_identification'][] = $error;
			}
				
		} else {
			AppController::getInstance()->redirect( '/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true );
		}
		
		return $result;
	}
}

?>