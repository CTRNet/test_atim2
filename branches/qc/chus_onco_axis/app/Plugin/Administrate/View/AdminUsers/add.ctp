<?php 
	$structure_links = array(
		'top' => '/Administrate/AdminUsers/add/'.$atim_menu_variables['Group.id'].'/',
		'bottom'=>array('cancel'=>'/Administrate/AdminUsers/listall/'.$atim_menu_variables['Group.id'])
	);
	
	$final_atim_structure = $atim_structure; 
	$final_options = array('links' => $structure_links, 'type' => 'add');
	
	$hook_link = $this->Structures->hook();
	if( $hook_link ) {
		require($hook_link); 
	}
		
	$this->Structures->build( $final_atim_structure, $final_options );
	
?>