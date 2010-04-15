<?php

class FamilyHistory extends ClinicalAnnotationAppModel
{
	var $belongsTo = array(
		'CodingIcd10' => array(
			'className'   => 'codingicd10.CodingIcd10',
			 	'foreignKey'  => 'primary_icd10_code',
			 	'dependent' => true)
	);
	
    function summary( $variables=array() ) {
		$return = false;
		
		if ( isset($variables['FamilyHistory.id']) ) {
			
			$result = $this->find('first', array('conditions'=>array('FamilyHistory.id'=>$variables['FamilyHistory.id'])));
			
			$return = array(
				'Summary' => array(
					'participant_id' => array( NULL, $result['FamilyHistory']['participant_id']),
					'description'	=>	array(
						'relation'	=>	$result['FamilyHistory']['relation'],
						'domain'	=>	$result['FamilyHistory']['domain'],
						'icd10'	=>	$result['FamilyHistory']['icd10_id'],
						'dx_date' => $result['FamilyHistory']['dx_date'],
						'dx_status'	=> $result['FamilyHistory']['dx_date_status'],
						'age_at_dx'	=> $result['FamilyHistory']['age_at_dx'],
						'age_at_dx_status'	=>	$result['FamilyHistory']['age_at_dx_status']
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
		if(strlen(trim($participantArray['FamilyHistory']['primary_icd10_code'])) == 0){
			$participantArray['FamilyHistory']['primary_icd10_code'] = null;
		}
	}
}

?>