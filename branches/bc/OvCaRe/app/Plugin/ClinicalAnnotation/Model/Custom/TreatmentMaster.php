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
			if($tx_to_delete['TreatmentControl']['tx_method'] == 'surgery') {
				$DiagnosisMaster = AppModel::getInstance("ClinicalAnnotation", "DiagnosisMaster", true);
				$DiagnosisMaster->updateCalculatedFields($tx_to_delete['TreatmentMaster']['participant_id']);
			}
			return true;
		}
		return false;
	}
}
?>