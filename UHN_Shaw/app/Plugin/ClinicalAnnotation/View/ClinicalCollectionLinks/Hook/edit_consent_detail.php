<?php 

	// ADD MISC IDENTIFIER SELECTION ---------------------------------------------

	$cst_structure_links = $structure_links;
	$cst_structure_settings = $structure_settings;

	$cst_structure_links['radiolist'] = array('Collection.uhn_misc_identifier_id' => '%%MiscIdentifier.id%%');
	
	$cst_structure_settings['header'] = __('misc identifiers');	
	
	$cst_final_options = array(
			'type'		=> 'index',
			'data'		=> $miscidentifier_data,
			'settings'	=> $cst_structure_settings,
			'links'		=> $cst_structure_links,
			'extras'	=> array('end' => '<input type="radio" name="data[Collection][uhn_misc_identifier_id]"  '.($found_misc_identifier ? '' : 'checked="checked"').' value=""/>'.__('n/a'))
	);
	
	$this->Structures->build( $atim_structure_miscidentifier_detail, $cst_final_options );
	
	// END ADD MISC IDENTIFIER SELECTION ---------------------------------------------
