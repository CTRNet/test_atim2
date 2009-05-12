<?
	$structure_links = array(
		'top'=>'/sop_master/add/%%SopMaster.id%%',
		'bottom'=>array(
			'cancel'=>'/sop_master/listall/%%SopMaster.id%%'
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>