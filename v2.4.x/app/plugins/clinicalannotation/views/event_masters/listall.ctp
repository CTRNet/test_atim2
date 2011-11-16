<?php
	$structure_links = array(
		'index' => array( 
			'detail' => array(
				'link' => '/clinicalannotation/event_masters/detail/'.$atim_menu_variables['EventMaster.event_group'].'/'.$atim_menu_variables['Participant.id'].'/%%EventMaster.id%%',
				'icon' => 'detail')
		),
		'bottom' => array(
			'add' => $add_links
		)
	); 
			
	$structure_override = array();

	$final_atim_structure = $atim_structure;
	$final_options = array('links'=>$structure_links, 'override' => $structure_override, 'type' => 'index');
	$hook_link = $structures->hook();
	if( $hook_link ) { require($hook_link); }
	$structures->build( $atim_structure, $final_options);
	
?>	
