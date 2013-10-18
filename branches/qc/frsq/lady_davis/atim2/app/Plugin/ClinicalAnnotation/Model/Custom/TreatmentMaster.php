<?php

class TreatmentMasterCustom extends TreatmentMaster {
	var $name 		= "TreatmentMaster";
	var $tableName	= "treatment_masters";
	
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

}

?>