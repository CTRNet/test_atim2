<?php 

	$structure_links = array(
		'top'=>'/datamart/batch_sets/deleteInBatch/',
		'checklist'=>array('BatchSet.ids][' => '%%BatchSet.id%%'),
		'bottom'=>array('cancel'=>'/datamart/batch_sets/index/user')
	);
	$structure_override = array();
	
	$final_atim_structure = $atim_structure; 
	$final_options = array('type'=>'checklist', 'data'=>$user_batchsets, 'settings'=>array('pagination'=>false, 'form_inputs'=>false), 'links' => $structure_links, 'override' => $structure_override);

	// CUSTOM CODE
	$hook_link = $structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options );	

?>