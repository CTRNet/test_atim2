<?php

class Participant extends ClinicalannotationAppModel {
	var $belongsTo = array(
		'CodingIcd10' => array(
			'className'   => 'codingicd10.CodingIcd10',
			 	'foreignKey'  => 'cod_icd10_code',
			 	'dependent' => true)
	);
	
	function summary( $variables=array() ) {
		$return = false;
		
		if ( isset($variables['Participant.id']) ) {
			$result = $this->find('first', array('conditions'=>array('Participant.id'=>$variables['Participant.id'])));
			
			$return = array(
				'Summary'	 => array(
					'menu'			=>	array( NULL, ($result['Participant']['participant_identifier'].' - '.$result['Participant']['last_name']) ),
					'title'			=>	array( NULL, ($result['Participant']['participant_identifier'].' - '.$result['Participant']['last_name']) ),
					
					'description'		=>	array(
						'participant identifier'	=>	$result['Participant']['participant_identifier'],
						'date of birth'				=>	$result['Participant']['date_of_birth'],
						'marital status'				=>	array($result['Participant']['marital_status'], 'marital_status'), // select-option
						'vital status'					=>	array($result['Participant']['vital_status'], 'vital_status'), // select-option
						'sex'								=>	array($result['Participant']['sex'], 'sex') // select-option
					)
				)
			);
		}
		
		return $return;
	}
   
	function validateIcd10Code(&$check){
		$values = array_values($check);
		return CodingIcd10::id_blank_or_exists($values[0]);
	}
	
	/**
	 * Replaces icd10 empty string to null values to respect foreign keys constraints
	 * @param $participantArray
	 */
	function patchIcd10NullValues(&$participantArray){
		if(strlen(trim($participantArray['Participant']['cod_icd10_code'])) == 0){
			$participantArray['Participant']['cod_icd10_code'] = null;
		}
		if(strlen(trim($participantArray['Participant']['secondary_cod_icd10_code'])) == 0){
			$participantArray['Participant']['secondary_cod_icd10_code'] = null;
		}
	}
}

?>