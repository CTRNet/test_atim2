<?php 
	$filter_links = array( 'no filter'=>'/clinicalannotation/treatment_masters/listall/'.$atim_menu_variables['Participant.id'].'/');
	$add_links = array();
	foreach ( $treatment_controls as $treatment_control ) {
		$trt_header = __($treatment_control['TreatmentControl']['disease_site'], true) . ' - ' . __($treatment_control['TreatmentControl']['tx_method'], true);
		$add_links[$trt_header] = '/clinicalannotation/treatment_masters/add/'.$atim_menu_variables['Participant.id'].'/'.$treatment_control['TreatmentControl']['id'];
		$filter_links[$trt_header] = '/clinicalannotation/treatment_masters/listall/'.$atim_menu_variables['EventMaster.event_group'].'/'.$atim_menu_variables['Participant.id'].'/'.$treatment_control['TreatmentControl']['id'];
	}
	
	$structure_links = array(
		'index'=>array(
			'detail'=>'/clinicalannotation/treatment_masters/detail/'.$atim_menu_variables['Participant.id'].'/%%TreatmentMaster.id%%/'
		),
		'bottom'=>array('filter' => $filter_links, 'add' => $add_links)
	);

	$structure_override = array('TreatmentMaster.protocol_master_id'=>$protocol_list);
	
	$final_options = array('type'=>'index', 'links'=>$structure_links, 'override'=>$structure_override);
	$final_atim_structure = $atim_structure; 
	$hook_link = $structures->hook();
	if( $hook_link ) { require($hook_link); }
	$structures->build( $final_atim_structure, $final_options );
	
?>