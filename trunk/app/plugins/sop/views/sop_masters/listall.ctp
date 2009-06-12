<?php 
	$add_links = array();
	foreach ( $sop_controls as $sop_control ) {
		$add_links[$sop_control['SopControl']['sop_group'].' - '.$sop_control['SopControl']['type']] = '/sop/sop_masters/add/';
	}
	
	$structure_links = array(
		'index'=>array(
			'detail'=>'/sop/sop_masters/detail/%%SopMaster.id%%/'
		),
		'bottom'=>array('add' => $add_links)
	);
	
	$structures->build( $atim_structure, array('type'=>'index','links'=>$structure_links) );
?>
