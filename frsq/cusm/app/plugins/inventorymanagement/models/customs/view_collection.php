<?php

class ViewCollectionCustom extends ViewCollection {

	var $useTable = 'view_collections';
	
	function summary($variables=array()) {
		$return = false;
		
		if(isset($variables['Collection.id'])) {
			$collection_data = $this->find('first', array('conditions'=>array('ViewCollectionCustom.collection_id' => $variables['Collection.id'])));
		
			$return = array(
				'Summary' => array(
					'menu' => array($collection_data['ViewCollectionCustom']['acquisition_label']),
					'title' => array(null, __('collection', true) . ' : ' . $collection_data['ViewCollectionCustom']['acquisition_label']),
					
					'description'=> array(
						__('prostate_bank_participant_id', true) => $collection_data['ViewCollectionCustom']['qc_cusm_prostate_bank_identifier'],
						__('participant identifier', true) => $collection_data['ViewCollectionCustom']['participant_identifier'],
						__('collection bank', true) => $collection_data['ViewCollectionCustom']['bank_name'],
						__('collection datetime', true) => $collection_data['ViewCollectionCustom']['collection_datetime'],
						__('collection site', true) => $collection_data['ViewCollectionCustom']['collection_site']
					)
				)
			);			
		}
		
		return $return;
	}
	
}

?>
