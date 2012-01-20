<?php 
		
	// BUILD FORM
	$structures->build($final_atim_structure, $final_options );
	
	//#FRSQ----------------
	$structure_links = array(
		'radiolist' => array(
				'ClinicalCollectionLink.misc_identifier_id'=>'%%MiscIdentifier.id%%'
			),
	);
	$structure_settings['header'] = __('#FRSQ', true);
	
	$final_atim_structure = $atim_structure_miscidentifier_detail; 
	$final_options = array(
		'type'		=> 'index', 
		'data'		=> $miscidentifier_data, 
		'settings'	=> $structure_settings, 
		'links'		=> $structure_links,
		'extras'	=> array('end' => '<input type="radio" name="data[ClinicalCollectionLink][misc_identifier_id]" checked="checked" value=""/>'.__('n/a', true))
	);

?>