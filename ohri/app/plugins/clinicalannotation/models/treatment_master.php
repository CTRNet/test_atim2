<?php

class TreatmentMaster extends ClinicalannotationAppModel {
	
	var $useTable = 'tx_masters';
    var $belongsTo = array(        
		'TreatmentControl' => array(            
		'className'    => 'Clinicalannotation.TreatmentControl',            
		'foreignKey'    => 'tx_control_id'     
		)    
	); 
	
	function summary( $variables=array() ) {
		$return = false;
		
		if ( isset($variables['TreatmentMaster.id']) ) {
			
			$result = $this->find('first', array('conditions'=>array('TreatmentMaster.id'=>$variables['TreatmentMaster.id'])));
			
			$return = array(
				'Summary'	 => array(
					'menu'    		=> array( NULL, __($result['TreatmentMaster']['disease_site'], TRUE) . ' - ' . __($result['TreatmentMaster']['tx_method'], TRUE) ),
					'title'	 		=> array( NULL, __($result['TreatmentMaster']['disease_site'], TRUE)  . ' - ' . __($result['TreatmentMaster']['tx_method'], TRUE)),

					'description'	=> array(
						__('intent', TRUE)		=>	__($result['TreatmentMaster']['tx_intent'], TRUE),
						__('start date', TRUE)  =>  $result['TreatmentMaster']['start_date']
					)
				)
			);
		}
		
		return $return;
	}
}

?>