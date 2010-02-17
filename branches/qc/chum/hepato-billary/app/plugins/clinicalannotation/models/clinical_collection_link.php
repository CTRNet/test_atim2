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
			'foreignKey' => 'collection_id'));
	
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
	
	function productFilterSummary($variables=array()) {
		$return = false;
		
		if(array_key_exists('FilterLevel', $variables) && ($variables['FilterLevel'] == 'participant_products')) {
			// User is working on participant product
			
			// Build filter information
			$studied_sample_type = array_key_exists('FilterForTreeView', $variables)? $variables['FilterForTreeView']: '';
			
			$filter_data = empty($studied_sample_type)? '': __($studied_sample_type, true);
			$filter_data = empty($filter_data)? __('all products', true): $filter_data;

			// Set summary						
			$return = array(
				'Summary' => array(
					'menu' => array(null, $filter_data,
					'title' => false,
					'description'=> false)));	
		}
		
		return $return;
	}
}

?>