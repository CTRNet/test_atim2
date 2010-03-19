<?php 
	$structure_links = array(
		'top' => '/administrate/users/add/'.$atim_menu_variables['Bank.id'].'/'.$atim_menu_variables['Group.id'].'/',
		'bottom'=>array('cancel'=>'/administrate/users/listall/'.$atim_menu_variables['Bank.id'].'/'.$atim_menu_variables['Group.id'])
	);
	
	$final_atim_structure = $atim_structure; 
	$final_options = array('links' => $structure_links, 'type' => 'add');
	
	$hook_link = $structures->hook();
	if( $hook_link ) {
		require($hook_link); 
	}
		
	$structures->build( $final_atim_structure, $final_options );
	
?>