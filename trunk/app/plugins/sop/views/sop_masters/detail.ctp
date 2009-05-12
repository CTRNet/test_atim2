<?
	$structure_links = array(
		'bottom'=>array(
			'edit'=>'/sop_master/edit/%%SopMaster.id%%, 
			'list'=>'/sop_master/listall/%%SopMaster.id%%'
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>