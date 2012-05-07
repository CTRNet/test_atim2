<?php
if(isset($validation_error)){
	$this->validationErrors = array('model' => array($validation_error));
}

$links = array('top' => '/Administrate/Merge/mergeCollections/', 'bottom' => array('cancel' => '/Administrate/Merge/index/'));
$this->Structures->build(array(), array(
		'type' => 'detail',
		'settings'	=> array(
			'header' => array('title' => __('merge collection'), 'description' => __('merge_coll_desc')),
			'actions'	=> false,
			'form_bottom' => false
		), 'extras' => array('end' => $this->Structures->generateSelectItem('InventoryManagement/Collections/search', 'from')),
		'links' => $links
	)
);
$this->Structures->build(array(), array(
		'type' => 'detail',
		'settings'	=> array('header' => array('title' => __('into collection'), 'description' => __('merge_coll_into_desc'), 'form_bottom' => true)),
		'extras'	=> array('end' => $this->Structures->generateSelectItem('InventoryManagement/Collections/search', 'to')),
		'links' => $links
	)
);
