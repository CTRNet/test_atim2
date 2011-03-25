<?php

class ViewCollection extends InventorymanagementAppModel {
	
	function summary($variables=array()) {
		$return = false;
		
		if(isset($variables['Collection.id'])) {
			$collection_data = $this->find('first', array('conditions'=>array('ViewCollection.collection_id' => $variables['Collection.id'])));
		
			$return = array(
				'menu' => array(null, $collection_data['ViewCollection']['acquisition_label']),
				'title' => array(null, __('collection', true) . ' : ' . $collection_data['ViewCollection']['acquisition_label']),
				'structure alias' 	=> 'view_collection',
				'data'				=> $collection_data
			);			
		}
		
		return $return;
	}
	
}

?>
