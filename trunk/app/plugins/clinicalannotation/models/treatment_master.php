<?php

class TreatmentMaster extends ClinicalannotationAppModel {
	
	var $useTable = 'tx_masters';
    var $belongsTo = array(        
		'TreatmentControl' => array(            
		'className'    => 'Clinicalannotation.TreatmentControl',            
		'foreignKey'    => 'treatment_control_id'     
		)    
	); 
	
	function summary( $variables=array() ) {
		$return = false;
		
		if ( isset($variables['TreatmentMaster.id']) ) {
			
			$result = $this->find('first', array('conditions'=>array('TreatmentMaster.id'=>$variables['TreatmentMaster.id'])));
			
			$return = array(
				'Summary' => array(
					'menu'        => array( NULL, $result['TreatmentMaster']['tx_group'] ),
					'title'		  => array( NULL, $result['TreatmentMaster']['tx_group'] ),

					'description' => array(
						'Intent'	=>	$result['TreatmentMaster']['tx_intent'],
						'Start Date'      =>  $result['TreatmentMaster']['start_date']
					)
				)
			);
		}
		
		return $return;
	}
}

?>