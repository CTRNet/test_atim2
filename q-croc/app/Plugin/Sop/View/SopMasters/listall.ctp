<?php 
	$add_links = array();
	foreach ( $sop_controls as $sop_control ) {
		$add_links[$sop_control['SopControl']['sop_group'].' - '.$sop_control['SopControl']['type']] = '/Sop/SopMasters/add/'.$sop_control['SopControl']['id'].'/';
	}
	
	$structure_links = array(
		'index'=>array(
			'detail'=>'/Sop/SopMasters/detail/%%SopMaster.id%%/'
		),
		'bottom'=>array('add' => $add_links)
	);
	
	$this->Structures->build( $atim_structure, array('type'=>'index','links'=>$structure_links) );
?>
