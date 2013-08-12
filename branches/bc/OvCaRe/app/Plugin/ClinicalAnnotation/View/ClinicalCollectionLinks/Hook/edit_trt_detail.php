<?php 

	// ADD MISC IDENTIFIER SELECTION ---------------------------------------------
	
	$misc_ident_structure_links = $structure_links;
	$misc_ident_structure_settings = $structure_settings;
	
	$misc_ident_structure_links['radiolist'] = array('Collection.misc_identifier_id' => '%%MiscIdentifier.id%%');
	$misc_ident_structure_settings['header'] = __('VOA#');
	
	$final_misc_ident_options = array(
			'type'		=> 'index',
			'data'		=> $miscidentifier_data,
			'settings'	=> $misc_ident_structure_settings,
			'links'		=> $misc_ident_structure_links,
			'extras'	=> array('end' => '<input type="radio" name="data[Collection][misc_identifier_id]"  '.($found_misc_identifier ? '' : 'checked="checked"').' value=""/>'.__('n/a'))
	);
	
	$this->Structures->build( $atim_structure_miscidentifier_detail, $final_misc_ident_options );
	
	// END ADD MISC IDENTIFIER SELECTION ---------------------------------------------

	$final_options['settings']['actions'] = true;
	$final_options['settings']['form_bottom'] = true;
	$final_options['links']['bottom'] = array('cancel' => '/ClinicalAnnotation/ClinicalCollectionLinks/detail/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['Collection.id'].'/');