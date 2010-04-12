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
				'Summary' => array(
					'participant_id' => array(NULL, $result['ClinicalCollectionLinks']['participant_id']),
					'collection_id'	=> array(NULL, $result['ClincicalCollectionLinks']['collection_id']),
					'diagnosis_master_id'	=> array(NULL, $result['ClinicalCollectionLinks']['diagnosis_master_id']),
					'consent_master_id'	=> array(NULL, $result['ClinicalCollectionLinks']['consent_master_id'])
				)
			);
		}
		
		return $return;
	}
	
}

?>