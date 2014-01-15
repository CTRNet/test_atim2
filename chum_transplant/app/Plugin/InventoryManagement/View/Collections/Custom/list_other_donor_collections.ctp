<?php 
		$final_atim_structure = $atim_structure; 
		$final_options = array(
			'type' => 'index', 
			'settings' => array('pagination' => false),
			'links' => array(
				'index' => array('detail'=>'/InventoryManagement/Collections/detail/%%ViewCollection.collection_id%%'),
				'bottom' => array(
					'link to other collection' => array('link' => '/InventoryManagement/Collections/linkToOtherDonorCollection/'.$atim_menu_variables['Collection.id'], 'icon' => 'add'),
					'remove collection from list' => array('link' => '/InventoryManagement/Collections/removeFromDonorCollectionsList/'.$atim_menu_variables['Collection.id'], 'icon' => 'delete'),
					'delete list' => array('link' => '/InventoryManagement/Collections/deleteAllDonorCollectionsList/'.$atim_menu_variables['Collection.id'], 'icon' => 'delete'))));
	
		$this->Structures->build( $final_atim_structure, $final_options );
?>