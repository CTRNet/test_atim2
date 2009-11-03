<?php

class DiagnosisMaster extends ClinicalannotationAppModel {
	var $belongsTo = array(        
		'DiagnosisControl' => array(            
		'className'    => 'Clinicalannotation.DiagnosisControl',            
		'foreignKey'    => 'diagnosis_control_id'
		)    
	);
	
	var $hasOne = array(
		'ClinicalCollectionLink' => array(
			'className' => 'Clinicalannotation.ClinicalCollectionLink',
			'foreignKey' => 'collection_id'));
	
	
function summary( $variables=array() ) {
		$return = false;
		if ( isset($variables['DiagnosisMaster.id']) ) {
			$result = $this->find('first', array('conditions'=>array('DiagnosisMaster.id'=>$variables['DiagnosisMaster.id'])));
			
			$return = array(
				'Summary'	 => array(
					'menu' => array(NULL, __($result['DiagnosisMaster']['type'], TRUE)),
					'title' => array(NULL, 'NOT WORKING title'),
					'description' => array(
						__('nature', TRUE) => __($result['DiagnosisMaster']['dx_nature'], TRUE),
						__('origin', TRUE) => __($result['DiagnosisMaster']['dx_origin'], TRUE),
						__('date', TRUE) => __($result['DiagnosisMaster']['dx_date'], TRUE),
						__('method', TRUE) => __($result['DiagnosisMaster']['dx_method'], TRUE)
					)
				)
			);
			
		}
		return $return;
	}
}
/*$return = array(
				'Summary'	 => array(
					'menu'			=>	array( NULL, __($result['Participant']['first_name'].' '.$result['Participant']['last_name'], TRUE) ),
					'title'			=>	array( NULL, __($result['Participant']['first_name'].' '.$result['Participant']['last_name'], TRUE) ),
					
					'description'		=>	array(
						__('tumour bank number',TRUE)	=>	__($result['Participant']['tb_number'], TRUE),
						__('date of birth', TRUE)		=>	__($result['Participant']['date_of_birth'], TRUE),
						__('marital status', TRUE)		=>	__($result['Participant']['marital_status'], TRUE),
						__('vital status', TRUE)		=>	__($result['Participant']['vital_status'], TRUE),
						__('sex', TRUE)					=>	__($result['Participant']['sex'], TRUE)
					)
				)
			);*/
?>