<?php

class Participant extends ClinicalannotationAppModel {
	
	function summary($variables=array()){
		$return = false;
		
		if ( isset($variables['Participant.id']) ) {
			$result = $this->find('first', array('conditions'=>array('Participant.id'=>$variables['Participant.id'])));
			
			$return = array(
					'menu'				=>	array( NULL, ($result['Participant']['participant_identifier']) ),
					'title'				=>	array( NULL, ($result['Participant']['participant_identifier']) ),
					'structure alias' 	=> 'participants',
					'data'				=> $result
			);
		}
		
		return $return;
	}
	
	/**
	 * Replaces icd10 empty string to null values to respect foreign keys constraints
	 * @param array $participantArray
	 */
	function patchIcd10NullValues(array &$participant){
		if(isset($participant['Participant']['cod_icd10_code']) && strlen(trim($participant['Participant']['cod_icd10_code'])) == 0){
			$participant['Participant']['cod_icd10_code'] = null;
		}
		if(isset($participant['Participant']['secondary_cod_icd10_code']) && strlen(trim($participant['Participant']['secondary_cod_icd10_code'])) == 0){
			$participant['Participant']['secondary_cod_icd10_code'] = null;
		}
	}
}

?>