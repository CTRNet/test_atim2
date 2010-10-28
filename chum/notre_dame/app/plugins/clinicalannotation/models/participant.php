<?php

class Participant extends ClinicalannotationAppModel {
	
	function summary( $variables=array() ) {
		$return = false;
		
		if ( isset($variables['Participant.id']) ) {
			$result = $this->find('first', array('conditions'=>array('Participant.id'=>$variables['Participant.id'])));
			
			$return = array(
				'Summary'	 => array(
					'menu'			=>	array( NULL, ($result['Participant']['participant_identifier']) ),
					'title'			=>	array( NULL, ($result['Participant']['participant_identifier']) ),
					
					'description'		=>	array(
						__('participant identifier', TRUE)	=>	$result['Participant']['participant_identifier'],
						__('name', TRUE)					=>	($result['Participant']['first_name'].' '.$result['Participant']['last_name']),
						__('date of birth', TRUE)			=>	$result['Participant']['date_of_birth'],
						__('vital status', TRUE)			=>	array($result['Participant']['vital_status'], 'vital_status'), // select-option
						__('sex', TRUE)						=>	array($result['Participant']['sex'], 'sex') // select-option
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
		if(strlen(trim($participantArray['Participant']['cod_icd10_code'])) == 0){
			$participantArray['Participant']['cod_icd10_code'] = null;
		}
		if(strlen(trim($participantArray['Participant']['secondary_cod_icd10_code'])) == 0){
			$participantArray['Participant']['secondary_cod_icd10_code'] = null;
		}
	}
}

?>