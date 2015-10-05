<?php 
	$structure_links = array(
		'index'	=> array(
			'detail'	=> '/Administrate/Menus/detail/%%Menu.id%%'
		)
	);
	
	$this->Structures->build( $atim_structure, array('type'=>'tree', 'links'=>$structure_links) );
?>