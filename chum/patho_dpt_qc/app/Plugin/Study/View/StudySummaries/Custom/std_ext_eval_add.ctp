<?php 
	$structure_links = array(
			'top'=>'/Study/StudySummaries/stdExtEvalAdd/'.$atim_menu_variables['StudySummary.id'].'/',
			'bottom'=>array(
				'cancel' => '/Study/StudySummaries/stdExtEvalListall/'.$atim_menu_variables['StudySummary.id'].'/'
			)
	);
	
	// Set form structure and option
	$final_atim_structure = $atim_structure;
	$final_options = array('links'=>$structure_links, 'type' => 'add');
	
	$this->Structures->build( $final_atim_structure, $final_options );
?>