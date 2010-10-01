<?php

class TreatmentMasterCustom extends TreatmentMaster {
	
	var $useTable = 'tx_masters';
	var $name = 'TreatmentMaster';

	function summary( $variables=array() ) {
		$return = false;
		
		if ( isset($variables['TreatmentMaster.id']) ) {
			
			$result = $this->find('first', array('conditions'=>array('TreatmentMaster.id'=>$variables['TreatmentMaster.id'])));
			
			$precision = isset($variables['TreatmentExtend.menu_precision'])? ' - ' . __($variables['TreatmentExtend.menu_precision'], null): '';
			
			$return = array(
				'Summary'	 => array(
					'menu'    		=> array( NULL, __($result['TreatmentMaster']['disease_site'], TRUE) . ' - ' . __($result['TreatmentMaster']['tx_method'], TRUE) . $precision),
					'title'	 		=> array( NULL, __($result['TreatmentMaster']['disease_site'], TRUE)  . ' - ' . __($result['TreatmentMaster']['tx_method'], TRUE)),

					'description'	=> array(
						__('start date', TRUE)  =>  $result['TreatmentMaster']['start_date']
					)
				)
			);
		}
		
		return $return;
	}
	
}

?>