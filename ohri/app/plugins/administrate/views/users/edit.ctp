<?php 
	$structure_links = array(
		'top' => '/administrate/users/edit/'.$atim_menu_variables['Group.id'].'/'.$atim_menu_variables['User.id'].'/',
		'bottom'=>array('cancel'=>'/administrate/users/detail/'.$atim_menu_variables['Group.id'].'/'.$atim_menu_variables['User.id'].'/')
	);
	
	$final_atim_structure = $atim_structure; 
	$final_options = array('links' => $structure_links, 'type' => 'edit');
	
	$hook_link = $structures->hook();
	if( $hook_link ) {
		require($hook_link); 
	}
		
	$structures->build( $final_atim_structure, $final_options );
	
?>