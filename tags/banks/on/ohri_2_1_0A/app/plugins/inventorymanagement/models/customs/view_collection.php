<?php

class ViewCollectionCustom extends ViewCollection {
	
	var $useTable = 'view_collections';	
	var $name = 'ViewCollection';	
		
	function summary($variables=array()) {
		$return = false;
		
		if(isset($variables['Collection.id'])) {
			$collection_data = $this->find('first', array('conditions'=>array('ViewCollection.collection_id' => $variables['Collection.id'])));
			
			$collection_title = (empty($collection_data['ViewCollection']['ohri_bank_participant_id']))? __('unlinked', true) : $collection_data['ViewCollection']['ohri_bank_participant_id'];
			if(!empty($collection_data['ViewCollection']['collection_datetime'])) {
				$collection_title .= ' ' . substr($collection_data['ViewCollection']['collection_datetime'], 0, strpos($collection_data['ViewCollection']['collection_datetime'], ' '));
			}
			
			$return = array(
				'Summary' => array(
					'menu' => array(null, $collection_title),
					'title' => array(null, __('collection', true) . ' : ' . $collection_title),
					
					'description'=> array(
						__('participant code', true) => $collection_data['ViewCollection']['participant_identifier'],
						__('ohri_bank_participant_id', true) => $collection_data['ViewCollection']['ohri_bank_participant_id'],
						__('collection bank', true) => $collection_data['ViewCollection']['bank_name'],
						__('collection datetime', true) => $collection_data['ViewCollection']['collection_datetime'],
						__('collection site', true) => array($collection_data['ViewCollection']['collection_site'], 'collection_site')
					)
				)
			);			
		}
		
		return $return;
	}
	
}

?>