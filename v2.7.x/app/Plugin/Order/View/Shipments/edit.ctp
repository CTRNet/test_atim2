<?php

$structure_links = array(
	'top' => '/Order/Shipments/edit/' . $atim_menu_variables['Order.id'] . '/' . $atim_menu_variables['Shipment.id'] . '/',
	'bottom' => array(
		'cancel' => '/Order/Shipments/detail/' . $atim_menu_variables['Order.id'] . '/' . $atim_menu_variables['Shipment.id'] . '/',
		'manage recipients' => array(
			'select recipient' => array(
				'icon' => 'detail',
				'link' => AppController::checkLinkPermission('/Order/Shipments/manageContact') ? 'javascript:manageContacts();' : '/notallowed/'
			),
			'save recipient' => array(
				'icon' => 'disk',
				'link' => AppController::checkLinkPermission('/Order/Shipments/saveContact/') ? 'javascript:saveContact();' : '/notallowed/'
			)
		)
	)
);

$final_atim_structure = $atim_structure;
$final_options = array('links' => $structure_links);

// CUSTOM CODE
$hook_link = $this->Structures->hook();
if ($hook_link) {
	require($hook_link);
}

// BUILD FORM
$this->Structures->build($final_atim_structure, $final_options);

require("contacts_functions.php");
