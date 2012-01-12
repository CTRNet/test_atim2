<?php
	$structure_links = array(
		'index' => array(
			'detail' => '/ClinicalAnnotation/TreatmentExtends/detail/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['TreatmentMaster.id'].'/%%TreatmentExtend.id%%/'
		),
		'bottom' => array(
			'add' => '/ClinicalAnnotation/TreatmentExtends/add/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['TreatmentMaster.id']
		)
	);
	
	if(isset($extended_data_import_process)) {
		$structure_links['bottom']['import from associated protocol'] = '/ClinicalAnnotation/TreatmentExtends/'.$extended_data_import_process.'/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['TreatmentMaster.id'];
	}
		
	$structure_override = array();
	
	$final_atim_structure = $atim_structure; 
	$final_options = array('type'=>'index', 'links'=>$structure_links,'override'=>$structure_override);
	
	// CUSTOM CODE
	$hook_link = $this->Structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$this->Structures->build( $final_atim_structure, $final_options );

?>