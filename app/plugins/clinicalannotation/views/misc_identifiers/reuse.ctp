<?php 
	$final_atim_structure = $atim_structure;
	$final_options = array(
		'type' => 'index',
		'settings' => array(
			'pagination' => false,
			'form_inputs' => false,
			'header' => array(
				'title' => $title,
				'description' => __('select an identifier to assign to the current participant', true)
			)
		), 'links' => array(
			'radiolist' => array(
							'MiscIdentifier.selected_id'=>'%%MiscIdentifier.id%%'
			), 'bottom' => array(
				'cancel' => '/clinicalannotation/misc_identifiers/listall/'.$atim_menu_variables['Participant.id']
			), 'top' => '/clinicalannotation/misc_identifiers/reuse/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['MiscIdentifierControl.id'].'/1/'
		)
	);

	$hook_link = $structures->hook();
	if($hook_link){
		require($hook_link);
	}
	$structures->build($atim_structure, $final_options);
?>