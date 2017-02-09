<?php 

	$structure_links = array(
		'top'=>"/Administrate/Announcements/add/$linked_model/".(isset($atim_menu_variables['User.id'])? $atim_menu_variables['Group.id'].'/'.$atim_menu_variables['User.id'].'/' : $atim_menu_variables['Bank.id']).'/',
		'bottom'=>array(
			'cancel'=>"/Administrate/Announcements/index/$linked_model/".(isset($atim_menu_variables['User.id'])? $atim_menu_variables['Group.id'].'/'.$atim_menu_variables['User.id'].'/' : $atim_menu_variables['Bank.id']).'/'
		)
	);
			
	// CUSTOM CODE
	$hook_link = $this->Structures->hook();
	if( $hook_link ) { require($hook_link); }
	
	$this->Structures->build( $atim_structure, array('links'=>$structure_links) );
