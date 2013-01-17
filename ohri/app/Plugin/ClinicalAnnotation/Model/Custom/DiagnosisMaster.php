<?php

class DiagnosisMasterCustom extends DiagnosisMaster {
	
	var $useTable = 'diagnosis_masters';
	var $name = 'DiagnosisMaster';
	
	function summary( $diagnosis_master_id = null ) {
		$return = false;
		if ( !is_null($diagnosis_master_id) ) {
			$result = $this->find('first', array('conditions'=>array('DiagnosisMaster.id'=>$diagnosis_master_id), 'recursive' => 0));
			
			$structure_alias = 'diagnosismasters';
			
			$return = array(
					'menu' 				=> array(NULL, __($result['DiagnosisControl']['category'], TRUE) . ' - '. __($result['DiagnosisControl']['controls_type'], TRUE)),
					'title' 			=> array(NULL,  __($result['DiagnosisControl']['category'], TRUE)),
					'data'				=> $result,
					'structure alias'	=> $structure_alias
			);
			
		}
		return $return;
	}
	
}
?>