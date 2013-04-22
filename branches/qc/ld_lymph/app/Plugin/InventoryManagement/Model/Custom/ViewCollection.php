<?php

class ViewCollectionCustom extends ViewCollection {
	
	var $name = 'ViewCollection';	

	function summary($variables=array()) {
		$return = false;
		
		if(isset($variables['Collection.id'])) {
			$collection_data = $this->find('first', array('conditions'=>array('ViewCollection.collection_id' => $variables['Collection.id'])));
			
			$label = (empty($collection_data['ViewCollection']['participant_identifier'])? 'n/a' : 'Part #'.($collection_data['ViewCollection']['participant_identifier'])). 
				' '.
				substr($collection_data['ViewCollection']['collection_datetime'], 0, 10);
							
			$return = array(
				'menu' => array(null,  $label),
				'title' => array(null, $label),
				'structure alias' 	=> 'view_collection',
				'data'				=> $collection_data
			);
			
		}
		
		return $return;
	}
}

?>
