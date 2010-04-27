<?php 
	$add_links = array();
	foreach ( $treatment_controls as $treatment_control ) {
		$add_links[$treatment_control['TreatmentControl']['tx_method']] = '/clinicalannotation/treatment_masters/add/'.$atim_menu_variables['Participant.id'].'/'.$treatment_control['TreatmentControl']['id'];
	}
	
	$structure_links = array(
		'index'=>array(
			'detail'=>'/clinicalannotation/treatment_masters/detail/'.$atim_menu_variables['Participant.id'].'/%%TreatmentMaster.id%%/'
		),
		'bottom'=>array('add' => sizeof($add_links) > 0 ? $add_links : "/underdev/")
	);

	$structure_override = array('TreatmentMaster.protocol_id'=>$protocol_list);
	
	$final_options = array('type'=>'index', 'links'=>$structure_links, 'override'=>$structure_override);
	$final_atim_structure = $atim_structure; 
	$hook_link = $structures->hook();
	if( $hook_link ) { require($hook_link); }
	$structures->build( $final_atim_structure, $final_options );
	
?>