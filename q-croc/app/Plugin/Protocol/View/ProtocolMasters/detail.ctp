<?php 

	$structure_links = array(
		'bottom'=>array(
			'edit'=>'/Protocol/ProtocolMasters/edit/'.$atim_menu_variables['ProtocolMaster.id'].'/',
			'delete'=>'/Protocol/ProtocolMasters/delete/'.$atim_menu_variables['ProtocolMaster.id'].'/'
		)
	);
	
	$structure_settings = array();
	if($display_precisions) $structure_settings['actions'] = false;
	
	$final_atim_structure = $atim_structure; 
	$final_options = array('links'=>$structure_links, 'settings' => $structure_settings);
	
	// CUSTOM CODE
	$hook_link = $this->Structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$this->Structures->build( $final_atim_structure, $final_options );

	if($display_precisions) {		
		$final_atim_structure = array();
		$final_options['type'] = 'detail';
		$final_options['settings']['header'] = __('precision');
		$final_options['settings']['actions'] = true;
		$final_options['extras'] = $this->Structures->ajaxIndex('Protocol/ProtocolExtendMasters/listall/'.$atim_menu_variables['ProtocolMaster.id']);
		$final_options['links']['bottom']['add precision'] = '/Protocol/ProtocolExtendMasters/add/'.$atim_menu_variables['ProtocolMaster.id'];
		
		$hook_link = $this->Structures->hook('precision');
		if( $hook_link ) {
			require($hook_link);
		}
	
		$this->Structures->build( $final_atim_structure, $final_options);
	}
	
?>