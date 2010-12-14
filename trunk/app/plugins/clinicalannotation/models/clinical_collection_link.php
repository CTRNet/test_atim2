<?php
class ClinicalCollectionLink extends ClinicalAnnotationAppModel{
	var $belongsTo = array(
		'ConsentMaster' => array(
			'className' => 'Clinicalannotation.ConsentMaster',
			'foreignKey' => 'consent_master_id'),
		'DiagnosisMaster' => array(
			'className' => 'Clinicalannotation.DiagnosisMaster',
			'foreignKey' => 'diagnosis_master_id'),
		'Collection' => array(
			'className' => 'Inventorymanagement.Collection',
			'foreignKey' => 'collection_id'),
		'Participant' => array(
			'className' => 'Clinicalannotation.Participant',
			'foreignKey' => 'participant_id'));
	
    function summary( $variables=array() ) {
		$return = false;
		
		if ( isset($variables['ClinicalCollectionLinks.id']) ) {
			
			$result = $this->find('first', array('conditions'=>array('ClinicalCollectionLink.id'=>$variables['ClinicalCollectionLink.id'])));
			
			$return = array(
				'data'			=> $result,
				'structure alias'=>'clinicalcollectionlinks'
			);
		}
		
		return $return;
	}
	
}

?>