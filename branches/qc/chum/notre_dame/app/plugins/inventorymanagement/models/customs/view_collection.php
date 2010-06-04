<?php

class ViewCollectionCustom extends ViewCollection {
	
	var $useTable = 'view_collections';	
	var $name = 'ViewCollection';	
		
	function summary($variables=array()) {
		$return = false;
		
		if(isset($variables['Collection.id'])) {
			$collection_data = $this->find('first', array('conditions'=>array('ViewCollection.collection_id' => $variables['Collection.id'])));
		
			$return = array(
				'Summary' => array(
					'menu' => array(null, $collection_data['ViewCollection']['acquisition_label']),
					'title' => array(null, __('collection', true) . ' : ' . $collection_data['ViewCollection']['acquisition_label']),
					
					'description'=> array(
						__('participant identifier', true) => $collection_data['ViewCollection']['participant_identifier'],
						__('collection bank', true) => $collection_data['ViewCollection']['bank_name'],
						__('bank no lab', true) => $collection_data['ViewCollection']['identifier_value'],
						__('collection datetime', true) => $collection_data['ViewCollection']['collection_datetime'],
						__('collection site', true) => $collection_data['ViewCollection']['collection_site'].'too'
					)
				)
			);			
		}
		
		return $return;
	}
	
}

?>
