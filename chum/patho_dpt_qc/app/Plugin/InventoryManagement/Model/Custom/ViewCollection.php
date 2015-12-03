<?php

class ViewCollectionCustom extends ViewCollection {
	
	var $name = 'ViewCollection';
	
	function summary($variables=array()) {
		$return = false;
		
		if(isset($variables['Collection.id'])) {
			$collection_data = $this->find('first', array('conditions'=>array('ViewCollection.collection_id' => $variables['Collection.id']), 'recursive' => '-1'));
			
			$return = array(
				'menu' => array(null, __('acquisition_label') . ' : ' . $collection_data['ViewCollection']['acquisition_label']),
				'title' => array(null, __('collection') . ' : ' . $collection_data['ViewCollection']['acquisition_label']),
				'structure alias' 	=> 'view_collection',
				'data'				=> $collection_data
			);
		}
		
		return $return;
	}
}

