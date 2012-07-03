<?php 
$can_delete = AppController::checkLinkPermission('/Order/shipments/deleteContact/');
$this->Structures->build($atim_structure, array(
	'type' => 'index',
	'links' => array('index' => array('detail' => 'javascript:', 'delete' => $can_delete ? 'javascript:deleteContact(%%ShipmentContact.id%%);' : '/cannot/'),
	),'settings' => array(
		'header' => __('manage contacts'),
		'pagination' => false
	)
));
