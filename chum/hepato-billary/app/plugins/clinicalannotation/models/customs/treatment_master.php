<?php

class TreatmentMasterCustom extends TreatmentMaster {
	
	var $useTable = 'treatment_masters';
	var $name = 'TreatmentMaster';

	function summary( $variables=array() ) {
		$return = false;
		
		if ( isset($variables['TreatmentMaster.id']) ) {
			
			$result = $this->find('first', array('conditions'=>array('TreatmentMaster.id'=>$variables['TreatmentMaster.id'])));
			
			$precision = isset($variables['TreatmentExtend.menu_precision'])? ' - ' . __($variables['TreatmentExtend.menu_precision'], null): '';
			
			$return = array(
				'menu'    			=> array( NULL, __($result['TreatmentControl']['disease_site'], TRUE) . ' - ' . __($result['TreatmentControl']['tx_method'], TRUE) . $precision),
				'title'	 			=> array( NULL, __($result['TreatmentControl']['disease_site'], TRUE)  . ' - ' . __($result['TreatmentControl']['tx_method'], TRUE)),
				'structure alias'	=> $result['TreatmentControl']['form_alias'],
				'data'				=> $result
			);
		}
		
		return $return;
	}
	
}

?>