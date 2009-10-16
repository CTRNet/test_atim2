<?php 

	$structure_settings = array(
		'pagination' => 	false,
		'add_fields'	=> true,
		'del_fields'	=> true
	);
	
	$structure_links = array(
		'top'		=> '/clinicalannotation/family_histories/grid/'.$atim_menu_variables['Participant.id'],
		'bottom'	=> array(
			'list'	=> '/clinicalannotation/family_histories/listall/'.$atim_menu_variables['Participant.id'],
			'add'		=> '/clinicalannotation/family_histories/add/'.$atim_menu_variables['Participant.id']
		)
	);
	
	$structures->build( $atim_structure, array('type'=>'datagrid', 'settings'=>$structure_settings, 'links'=>$structure_links) );

?>
