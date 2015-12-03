<?php 
	$structure_links = array(
		'top'=>'/Study/StudySummaries/stdRefEdit/'.$atim_menu_variables['StudyReference.id'].'/',
		'bottom'=>array(
			'cancel'=>'/Study/StudySummaries/stdRefListall/'.$atim_menu_variables['StudyReference.id'].'/'
		)
	);
	$final_atim_structure = $atim_structure;
	$final_options = array('links'=>$structure_links, 'type' => 'edit');
	$this->Structures->build( $final_atim_structure, $final_options );
?>