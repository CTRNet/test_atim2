<?php 
		
	$previous_final_atim_structure = $final_atim_structure;
	$previous_final_options = $final_options;
	
	//#FRSQ----------------	
	
	$structure_links['radiolist'] = array('Collection.misc_identifier_id'=>'%%MiscIdentifier.id%%');
	$structure_settings['header'] = __('#FRSQ');
	$structure_settings['form_top'] = false;
	//consent
	$final_atim_structure = $atim_structure_miscidentifier_detail;
	$final_options = array(
			'type'		=> 'index',
			'data'		=> $miscidentifier_data,
			'settings'	=> $structure_settings,
			'links'		=> $structure_links,
			'extras'	=> array('end' => '<input type="radio" name="data[Collection][misc_identifier_id]" '.($found_misc_identifier ? '' : 'checked="checked"').'" value=""/>'.__('n/a'))
	);
	
	// BUILD FORM
	$this->Structures->build($final_atim_structure, $final_options );

	//END #FRSQ ----------------
	
	$final_atim_structure = $previous_final_atim_structure;
	$final_options = $previous_final_options;

?>