<?php 
	$structure_links = array(
		'index'=>array(
			'detail'=>'/ClinicalAnnotation/TreatmentMasters/detail/'.$atim_menu_variables['Participant.id'].'/%%TreatmentMaster.id%%/'
		),
		'bottom'=>array(
			//'filter' => $filter_links, //this can be added back into the hook if needed 
			'add' => $add_links
		)
	);

	$structure_override = array();
	
	$final_options = array('type'=>'index', 'links'=>$structure_links, 'override'=>$structure_override);
	$final_atim_structure = $atim_structure; 
	$hook_link = $this->Structures->hook();
	if( $hook_link ) { 
		require($hook_link); 
	}
	$this->Structures->build( $final_atim_structure, $final_options );
	
