<?php 

$structure_links = array(
	'top'=>'/order/shipments/add/'.$atim_menu_variables['Order.id'].'/',
	'bottom'=>array(
		'cancel'=>'/order/shipments/listall/'.$atim_menu_variables['Order.id'].'/',
		'manage contacts' => array('icon' => 'detail', 'link' => AppController::checkLinkPermission('/order/shipments/manageContact') ? 'javascript:manageContacts();' : '/notallowed/'),
		'save contact' => array('icon' => 'disk', 'link' => AppController::checkLinkPermission('/order/shipments/saveContact/') ? 'javascript:saveContact();' : '/notallowed/')
	)
);

$final_atim_structure = $atim_structure; 
$final_options = array('links'=>$structure_links);

// CUSTOM CODE
$hook_link = $structures->hook();
if( $hook_link ) { require($hook_link); }
	
// BUILD FORM
$structures->build( $final_atim_structure, $final_options );

require("contacts_functions.php");