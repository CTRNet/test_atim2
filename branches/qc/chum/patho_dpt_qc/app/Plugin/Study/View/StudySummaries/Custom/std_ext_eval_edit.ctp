<?php 
	$structure_links = array(
		'top'=>'/Study/StudySummaries/stdExtEvalEdit/'.$atim_menu_variables['StudyExternalEvaluation.id'].'/',
		'bottom'=>array(
			'cancel'=>'/Study/StudySummaries/stdExtEvalListall/'.$atim_menu_variables['StudySummary.id'].'/'
		)
	);
	$final_atim_structure = $atim_structure;
	$final_options = array('links'=>$structure_links, 'type' => 'edit');
	$this->Structures->build( $final_atim_structure, $final_options );
?>