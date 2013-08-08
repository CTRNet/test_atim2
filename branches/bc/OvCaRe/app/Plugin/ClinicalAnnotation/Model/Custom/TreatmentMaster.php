<?php

class TreatmentMasterCustom extends TreatmentMaster {
	var $name = 'TreatmentMaster';
	var $useTable = 'treatment_masters';
	
	var $ovcareIsTreatmentDeletion = false;
	
	function summary( $variables=array() ) {
		$return = false;
	
		if ( isset($variables['TreatmentMaster.id']) ) {
				
			$result = $this->find('first', array('conditions'=>array('TreatmentMaster.id'=>$variables['TreatmentMaster.id'])));
				
			$return = array(
					'menu'    			=> array( NULL, __($result['TreatmentControl']['tx_method'], TRUE) ),
					'title'	 			=> array( NULL, __($result['TreatmentControl']['tx_method'], TRUE)),
					'data'				=> $result,
					'structure alias'	=> 'treatmentmasters'
			);
		}
	
		return $return;
	}
	
	function atimDelete($model_id, $cascade = true){	
		$tx_to_delete = $this->find('first', array('conditions' => array('TreatmentMaster.id' => $model_id), 'recursive' => '0'));
		if(parent::atimDelete($model_id, $cascade)){		
			if($tx_to_delete['TreatmentControl']['tx_method'] == 'procedure - surgery biopsy') {
				$DiagnosisMaster = AppModel::getInstance("ClinicalAnnotation", "DiagnosisMaster", true);
				$DiagnosisMaster->updateCalculatedFields($tx_to_delete['TreatmentMaster']['participant_id']);
			}
			return true;
		}
		return false;
	}
	
	function updateCalculatedFields($participant_id, $treatment_master_id = null) {
		// MANAGE OVARY DIAGNOSIS CALCULATED FIELDS
		$Participant = AppModel::getInstance("ClinicalAnnotation", "Participant", true);
	
		// Get Participant Data
	
		$particpant_data = $Participant->find('first', array('conditions' => array('Participant.id' => $participant_id), 'recursive' => '-1'));
		$date_of_birth = $particpant_data['Participant']['date_of_birth'];
		$date_of_birth_accuracy = $particpant_data['Participant']['date_of_birth_accuracy'];
	
		// Get all procedures
		
		$conditions = array('TreatmentMaster.participant_id' => $participant_id, 'TreatmentControl.tx_method' => 'procedure - surgery biopsy');
		if($treatment_master_id) $conditions['TreatmentMaster.id'] = $treatment_master_id;
		$all_procedures = $this->find('all', array('conditions' => $conditions));
		
		foreach($all_procedures as $new_procedure) {
			$treatment_master_id = $new_procedure['TreatmentMaster']['id'];
			
			$procedure_date = $new_procedure['TreatmentMaster']['start_date'];
			$procedure_date_accuracy = $new_procedure['TreatmentMaster']['start_date_accuracy'];
			
			$ovcare_age_at_surgery = $new_procedure['TreatmentDetail']['ovcare_age_at_surgery'];
			$ovcare_age_at_surgery_precision = $new_procedure['TreatmentDetail']['ovcare_age_at_surgery_precision'];
			$new_ovcare_age_at_surgery = '';
			$new_ovcare_age_at_surgery_precision = 'missing information';
				
			if($date_of_birth && $procedure_date) {
				$DateOfBirthObj = new DateTime($date_of_birth);
				$ProcedureDateObj = new DateTime($procedure_date);
				$interval = $DateOfBirthObj->diff($ProcedureDateObj);	
				$new_ovcare_age_at_surgery = $interval->format('%r%y');
				if($new_ovcare_age_at_surgery < 0) {
					$new_ovcare_age_at_surgery = '';
					$new_ovcare_age_at_surgery_precision = "date error";
					AppController::addWarningMsg(str_replace('%%field%%', __('age at surgery'), __('error in the dates definitions: the field [%%field%%] can not be generated')));
				} else if(!(in_array($procedure_date_accuracy, array('c')) && in_array($date_of_birth_accuracy, array('c')))) {
					$new_ovcare_age_at_surgery_precision = "approximate";
				} else {
					$new_ovcare_age_at_surgery_precision = "exact";
				}
			}
			
			// Data to update
				
			$data_to_update = array();
			if($new_ovcare_age_at_surgery != $ovcare_age_at_surgery) $data_to_update['TreatmentDetail']['ovcare_age_at_surgery'] = (empty($new_ovcare_age_at_surgery)? "''" : $new_ovcare_age_at_surgery);
			if($new_ovcare_age_at_surgery_precision != $ovcare_age_at_surgery_precision) $data_to_update['TreatmentDetail']['ovcare_age_at_surgery_precision'] = $new_ovcare_age_at_surgery_precision;
			if($data_to_update) {
				$this->data = array();
				$this->id = $treatment_master_id;
				$data_to_update['TreatmentMaster']['id'] = $treatment_master_id;
				$this->check_writable_fields = false;
				if(!$this->save($data_to_update)) AppController::getInstance()->redirect( '/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true ); 
			}
		}
	}
}
?>