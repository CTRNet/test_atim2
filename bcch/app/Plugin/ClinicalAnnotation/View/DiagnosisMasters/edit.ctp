<?php 
	$structure_links = array(
		'top'=>'/ClinicalAnnotation/DiagnosisMasters/edit/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['DiagnosisMaster.id'].'/',
		'bottom'=>array(
			'cancel'=>'/ClinicalAnnotation/DiagnosisMasters/detail/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['DiagnosisMaster.id'].'/'
		)
	);
		
	// 1- DIAGNOSTIC DATA

	$structure_settings = array(
		'header' => null
	);

	// BB-192
	pr($dx_ctrl);

	if($dx_ctrl['DiagnosisControl']['controls_type'] == 'neurology' || $dx_ctrl['DiagnosisControl']['controls_type'] == 'Neurology') {
		echo $this->Html->script('jquery-1.7.2.min.js');
		echo '<script> 
		if (window.jQuery) {
			alert("jQuery Loaded");
		} else {
			alert("Not Loaded");
		}
			</script>';
	}

	$final_atim_structure = $atim_structure;
	$final_options = array('links' => $structure_links, 'settings' => $structure_settings);

	$hook_link = $this->Structures->hook();
	if( $hook_link ) { 
		require($hook_link); 
	}

	$this->Structures->build( $final_atim_structure, $final_options );	
