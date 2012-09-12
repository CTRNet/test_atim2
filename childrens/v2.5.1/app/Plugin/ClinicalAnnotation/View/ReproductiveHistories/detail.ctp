<?php 
	$structure_links = array(
		'bottom'=>array(
			'list'=>'/ClinicalAnnotation/ReproductiveHistories/listall/'.$atim_menu_variables['Participant.id'].'/',
			'edit'=>'/ClinicalAnnotation/ReproductiveHistories/edit/'.$atim_menu_variables['Participant.id'].'/%%ReproductiveHistory.id%%/',
			'delete'=>'/ClinicalAnnotation/ReproductiveHistories/delete/'.$atim_menu_variables['Participant.id'].'/%%ReproductiveHistory.id%%/'
		)
	);
	
	// Set form structure and option 
	$final_atim_structure = $atim_structure; 
	$final_options = array('links'=>$structure_links);
	
	// CUSTOM CODE
	$hook_link = $this->Structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$this->Structures->build( $final_atim_structure, $final_options );
?>