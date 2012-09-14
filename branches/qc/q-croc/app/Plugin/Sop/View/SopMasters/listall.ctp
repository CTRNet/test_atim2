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
	
	$final_atim_structure = $atim_structure;
	$final_options = array('type'=>'index','links'=>$structure_links);
	
	// CUSTOM CODE
	$hook_link = $this->Structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	$this->Structures->build( $final_atim_structure,  $final_options);
