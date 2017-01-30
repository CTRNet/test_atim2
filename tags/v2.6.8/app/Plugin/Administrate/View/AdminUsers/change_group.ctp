<?php
	$final_options = array(
		'type'	=> 'edit',		
		'links' => array(
			'top'	 => sprintf('/Administrate/AdminUsers/changeGroup/%d/%d/', $atim_menu_variables['Group.id'], $atim_menu_variables['User.id']),
			'bottom' => array('cancel' => sprintf('/Administrate/AdminUsers/detail/%d/%d/', $atim_menu_variables['Group.id'], $atim_menu_variables['User.id'])))
	);
	
	$final_atim_structure = $atim_structure;

	$this->Structures->build($final_atim_structure, $final_options); 