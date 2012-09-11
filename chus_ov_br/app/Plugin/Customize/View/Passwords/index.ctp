<?php
	$structure_links = array(
		'top'=>'/Customize/Passwords/index'
	);
	
	$this->Structures->build($atim_structure, array( 'type'=>'edit', 'links'=>$structure_links, 'settings' => array('stretch' => false)));
?>