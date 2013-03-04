<?php 
$structure_links = array(
		'top' => '/Administrate/Groups/edit/%%Group.id%%',
		'bottom'=>array(
			'cancel'=>'/Administrate/Groups/detail/%%Group.id%%', 
		)
	);
	
	$this->Structures->build( $atim_structure, array('links'=>$structure_links) );
	
?>
