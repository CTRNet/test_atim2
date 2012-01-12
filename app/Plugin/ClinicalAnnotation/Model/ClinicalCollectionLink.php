<?php
class ClinicalCollectionLink extends ClinicalAnnotationAppModel{
	var $belongsTo = array(
		'ConsentMaster' => array(
			'className' => 'ClinicalAnnotation.ConsentMaster',
			'foreignKey' => 'consent_master_id'),
		'DiagnosisMaster' => array(
			'className' => 'ClinicalAnnotation.DiagnosisMaster',
			'foreignKey' => 'diagnosis_master_id'),
		'Collection' => array(
			'className' => 'InventoryManagement.Collection',
			'foreignKey' => 'collection_id'),
		'Participant' => array(
			'className' => 'ClinicalAnnotation.Participant',
			'foreignKey' => 'participant_id'));
	
    function summary( $variables=array() ) {
		$return = false;
		
		if ( isset($variables['ClinicalCollectionLink.id']) ) {
			
			$result = $this->find('first', array('conditions'=>array('ClinicalCollectionLink.id'=>$variables['ClinicalCollectionLink.id'])));
			
			$return = array(
				'menu'				=>	array( NULL, ($result['Collection']['acquisition_label']) ),
				'title'				=>	array( NULL, ($result['Collection']['acquisition_label']) ),
				'structure alias' 	=> 'clinicalcollectionlinks',
				'data'				=> $result
			);
		}
		
		return $return;
	}
	
	function allowDeletion($ccl_id) {
		return array('allow_deletion' => true, 'msg' => '');
	}
	
}

?>