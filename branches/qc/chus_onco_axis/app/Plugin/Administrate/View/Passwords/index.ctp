<?php
	$structure_links = array(
		'top'=>'/Administrate/PasswordsAdmin/index/'.$atim_menu_variables['Group.id'].'/'.$atim_menu_variables['User.id']
	);
	
	$this->Structures->build($atim_structure, array('type'=>'edit', 'links'=>$structure_links, 'settings' => array('stretch' => false)));
?>