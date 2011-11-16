<?php 
$can_delete = AppController::checkLinkPermission('/order/shipments/deleteContact/');
$structures->build($atim_structure, array(
	'type' => 'index',
	'links' => array('index' => array('detail' => 'javascript:', 'delete' => $can_delete ? 'javascript:deleteContact(%%ShipmentContact.id%%);' : '/cannot/'),
	),'settings' => array(
		'header' => __('manage contacts', true),
		'pagination' => false
	)
));
