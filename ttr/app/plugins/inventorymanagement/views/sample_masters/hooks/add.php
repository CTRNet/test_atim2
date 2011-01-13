<?php
if(isset($collections)){
	$structures->build($collections, array(
		'type' 		=> 'add', 
		'links' 	=> array(
			'top' 			=> '/inventorymanagement/sample_masters/add/0/'.$sample_control_data['SampleControl']['id'].'/'),
		'settings'	=> array(
			'actions' 		=> false,
			'form_bottom'	=> false),
		'override'	=> array(
			'Collection.bc_ttr_collection_type'	=> __($sample_control_data['SampleControl']['sample_type'], true))));
	
	$final_options['settings']['form_top'] = false;
}

?>