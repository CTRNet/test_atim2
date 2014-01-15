<?php
	
	if(isset($validation_error)){
		$this->validationErrors = array('model' => array($validation_error));
	}
	$links = array(
		'top'=> '/InventoryManagement/Collections/linkToOtherDonorCollection/'.$atim_menu_variables['Collection.id'],
		'bottom' => array('cancel' => '/InventoryManagement/Collections/listOtherDonorCollections/'.$atim_menu_variables['Collection.id'])
	);
	$this->Structures->build(array(), array(
		'type' => 'detail',
		'settings'	=> array(
			'header' => array('title' => 'selected collection', 'description' => 'click on search to find an other donor collection'),
			'actions'	=> true,
			'form_bottom' => true), 
		'extras' => array('end' => $this->Structures->generateSelectItem('InventoryManagement/Collections/search', 'donor_collection_url')),
		'links' => $links));
	