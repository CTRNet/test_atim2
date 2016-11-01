<?php

class CollectionCustom extends Collection {
	
	var $useTable = 'collections';
	var $name = 'Collection';
	
	function afterFind($results, $primary = false){
		$results = parent::afterFind($results);
		
		if(isset($results[0]['Collection']['bank_id'])
		|| isset($results[0]['Collection']['qbcf_bank_participant_identifier'])
		|| isset($results[0]['Collection']['qbcf_pathology_id'])) {
			foreach($results as &$result){
				//To force the use of ViewCollection for ant display of collection data
				$result['Collection']['bank_id'] = CONFIDENTIAL_MARKER;
				$result['Collection']['qbcf_bank_participant_identifier'] = CONFIDENTIAL_MARKER;
				$result['Collection']['qbcf_pathology_id'] = CONFIDENTIAL_MARKER;
			}
		} else if(isset($results['Collection'])){
			pr('TODO afterFind Collection');
			pr($results);
			exit;
		}
	
		return $results;
	}
}

?>
