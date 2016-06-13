<?php
$structure_links = array(
	'index' => array(
		'detail' => '/InventoryManagement/Collections/detail/%%ViewCollection.collection_id%%',
		'copy for new collection' => array('link' => '/InventoryManagement/Collections/add/0/%%ViewCollection.collection_id%%', 'icon' => 'copy')
	), 'bottom' => array(
		'add collection' => '/InventoryManagement/Collections/add'
	)
);
$final_options = array(
	'type' => 'index',
	'data' => $this->request->data,
	'links' => $structure_links,
	'settings' => $settings
);
// CUSTOM CODE
$hook_link = $this->Structures->hook();
if( $hook_link ) {
	require($hook_link);
}