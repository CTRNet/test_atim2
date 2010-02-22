<?php 
	
	$structure_links = array(
		'top' => '/inventorymanagement/collections/add',
		'bottom' => array('cancel' => '/inventorymanagement/collections/index')
	);
	
	$structure_override = array();
	
	$bank_list = array();
	foreach($banks as $new_bank) {
		$bank_list[$new_bank['Bank']['id']] = $new_bank['Bank']['name'];
	}
	$structure_override['Collection.bank_id'] = $bank_list;
	
	$sops_list = array();
	foreach($arr_collection_sops as $sop_masters) { $sops_list[$sop_masters['SopMaster']['id']] = $sop_masters['SopMaster']['code']; }
	$structure_override['Collection.sop_master_id'] = $sops_list; 
	
	$final_atim_structure = $atim_structure; 
	$final_options = array('links' => $structure_links, 'override' => $structure_override);
	
	// CUSTOM CODE
	$hook_link = $structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options );	
	
?>