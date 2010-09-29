<?php

class DiagnosisMaster extends ClinicalannotationAppModel {
	var $belongsTo = array(        
		'DiagnosisControl' => array(            
		'className'    => 'Clinicalannotation.DiagnosisControl',            
		'foreignKey'    => 'diagnosis_control_id'
		),
	);
	
	var $hasOne = array(
		'ClinicalCollectionLink' => array(
			'className' => 'Clinicalannotation.ClinicalCollectionLink',
			'foreignKey' => 'diagnosis_master_id'));
	
	function summary( $variables=array() ) {
		$return = false;
		if ( isset($variables['DiagnosisMaster.id']) ) {
			$result = $this->find('first', array('conditions'=>array('DiagnosisMaster.id'=>$variables['DiagnosisMaster.id'])));
			
			$return = array(
				'Summary'	 => array(
					'menu' => array(NULL, __($result['DiagnosisControl']['controls_type'], TRUE)),
					'title' => array(NULL, __('diagnosis', TRUE)),
					'description' => array(
						__('nature', TRUE) => __($result['DiagnosisMaster']['dx_nature'], TRUE),
						__('origin', TRUE) => __($result['DiagnosisMaster']['dx_origin'], TRUE),
						__('date', TRUE) => $result['DiagnosisMaster']['dx_date'],
						__('method', TRUE) => __($result['DiagnosisMaster']['dx_method'], TRUE)
					)
				)
			);
			
		}
		return $return;
	}
	
	/**
	 * Replaces icd10 empty string to null values to respect foreign keys constraints
	 * @param $participantArray
	 */
	function patchIcd10NullValues(&$participantArray){
		if(strlen(trim($participantArray['DiagnosisMaster']['primary_icd10_code'])) == 0){
			$participantArray['DiagnosisMaster']['primary_icd10_code'] = null;
		}
	}
	
	function getMorphologyValues(){
		$result = array();
		foreach($this->query("SELECT code AS val, CONCAT(code, ' - ', en_desc) AS `default` FROM coding_icdo_3") as $icdo3){
			$result[] = array("value" => $icdo3['coding_icdo_3']['val'], "default" => $icdo3[0]['default']);
		}
		return $result;
	}
}
?>