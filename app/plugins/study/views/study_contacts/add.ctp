<?php 
	$structure_links = array(
		'top'=>'/study/study_contacts/add/'.$atim_menu_variables['StudySummary.id'].'/',
		'bottom'=>array(
			'cancel'=>'/study/study_contacts/listall/'.$atim_menu_variables['StudySummary.id'].'/'
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>