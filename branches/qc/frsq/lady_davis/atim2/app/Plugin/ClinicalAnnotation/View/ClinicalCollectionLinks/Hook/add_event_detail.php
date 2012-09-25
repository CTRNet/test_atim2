<?php 

	// ADD MISC IDENTIFIER SELECTION ---------------------------------------------
	
	$structure_links['radiolist'] = array('Collection.misc_identifier_id' => '%%MiscIdentifier.id%%');
	
	$structure_settings['header'] = __('misc identifiers');
	$structure_settings['form_bottom'] = true;
	$structure_settings['actions'] = true;
	$structure_settings['form_top'] = false;
	
	$final_atim_structure = $atim_structure_miscidentifier_detail;
	$final_options = array(
			'type'		=> 'index',
			'data'		=> $miscidentifier_data,
			'settings'	=> $structure_settings,
			'links'		=> $structure_links,
			'extras'	=> array('end' => '<input type="radio" name="data[Collection][misc_identifier_id]"  '.($found_misc_identifier ? '' : 'checked="checked"').' value=""/>'.__('n/a'))
	);
	
	$this->Structures->build( $final_atim_structure, $final_options );

	// END ADD MISC IDENTIFIER SELECTION ---------------------------------------------
	
	$display_next_sub_form=false;
