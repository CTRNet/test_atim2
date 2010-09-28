<?php

class FamilyHistory extends ClinicalAnnotationAppModel{
	
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
	
	function validateIcd10WhoCode($id){
		return CodingIcd10Who::validateId($id);
	}
	
	function validateIcd10CaCode($id){
		return CodingIcd10Ca::validateId($id);
	}
	
	function validateIcdo3TopoCode($id){
		return CodingIcdo3Topo::validateId($id);
	}
	
	function validateIcdo3MorphoCode($id){
		return CodingIcdo3Morpho::validateId($id);
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