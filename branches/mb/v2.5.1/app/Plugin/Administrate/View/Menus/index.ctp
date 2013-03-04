<?php 
	$structure_links = array(
		'index'	=> array(
			'detail'	=> '/Administrate/menus/detail/%%Menu.id%%'
		)
	);
	
	$this->Structures->build( $atim_structure, array('type'=>'tree', 'links'=>$structure_links) );
?>