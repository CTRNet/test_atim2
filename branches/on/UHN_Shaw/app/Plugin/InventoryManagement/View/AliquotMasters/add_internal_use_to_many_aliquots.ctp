<?php 
	
	$structure_links = array(
		'top' => '/InventoryManagement/AliquotMasters/addInternalUseToManyAliquots/'.$storage_master_id,
		'bottom' => array('cancel' => $url_to_cancel)
	);
	
	$final_atim_structure = $atim_structure; 
	$final_options = array(
		'type' => 'add',
		'links' => $structure_links,
		'extras'	=> $this->Form->text('aliquot_ids', array("type" => "hidden", "id" => false, "value" => $aliquot_ids)).
			$this->Form->text('url_to_cancel', array("type" => "hidden", "id" => false, "value" => $url_to_cancel)),
		'settings'	=> array(
			'header' => array(
				'title' => __('use/event creation'), 
				'description' => (isset($storage_description)?
					 __('you are about to create an use/event for %s aliquot(s) contained into %s', substr_count($aliquot_ids, ',') + 1, $storage_description):
					 __('you are about to create an use/event for %d aliquot(s)', substr_count($aliquot_ids, ',') + 1))),
			'confirmation_msg' => __('batch_edit_confirmation_msg')
		)
	);
	if($aliquot_volume_unit) $final_options['override']['AliquotControl.volume_unit'] = $aliquot_volume_unit;
	
	// CUSTOM CODE
	$hook_link = $this->Structures->hook();
	if( $hook_link ) { 
		require($hook_link); 
	}
		
	// BUILD FORM
	$this->Structures->build( $final_atim_structure, $final_options );			
		
?>
