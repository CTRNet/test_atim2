<?php
class ClinicalCollectionLinkCustom extends ClinicalCollectionLink {
	var $useTable = 'clinical_collection_links';
	var $name = 'ClinicalCollectionLink';
	
    function summary( $variables=array() ) {
		$return = false;
		
		if ( isset($variables['ClinicalCollectionLink.id']) ) {
			
			$result = $this->find('first', array('conditions'=>array('ClinicalCollectionLink.id'=>$variables['ClinicalCollectionLink.id'])));
			
			$bank_model = AppModel::getInstance("Administrate", "Bank", true);
			$bank_data = $bank_model->find('first', array('conditions'=>array('Bank.id'=>$result['Collection']['bank_id'])));		
						
			$label = $bank_data['Bank']['name']. ' ' . substr($result['Collection']['collection_datetime'], 0, 7);
			$return = array(
				'menu'				=>	array( NULL, ($label) ),
				'title'				=>	array( NULL, ($label) ),
				'structure alias' 	=> 'clinicalcollectionlinks',
				'data'				=> $result
			);
		}
		
		return $return;
	}
	
}

?>