<?php 
	$structure_links = array(
		'bottom'=>array(
			'edit'=>'/Administrate/Groups/edit/%%Group.id%%', 
			'delete'=>'/Administrate/Groups/delete/%%Group.id%%', 
			'list'=>'/Administrate/Groups/index/'
		)
	);
	
	if($atim_menu_variables['Group.id'] == 1){
		unset($structure_links['bottom']['delete'], $structure_links['bottom']['edit']);
	}
	
	$this->Structures->build( $atim_structure, array('links'=>$structure_links) );
?>
