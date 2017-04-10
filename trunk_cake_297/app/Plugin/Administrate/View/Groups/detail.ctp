<?php 
	$structure_links = array(
		'bottom'=>array(
			'edit'=>'/Administrate/Groups/edit/%%Group.id%%', 
			'delete'=>'/Administrate/Groups/delete/%%Group.id%%'
		)
	);
	if(!$display_edit_button) unset($structure_links['bottom']['delete'], $structure_links['bottom']['edit']);
	
	$this->Structures->build( $atim_structure, array('links'=>$structure_links) );
?>
